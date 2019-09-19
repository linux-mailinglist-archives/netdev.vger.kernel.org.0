Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C574B784A
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 13:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389613AbfISLSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 07:18:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54998 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389541AbfISLSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 07:18:23 -0400
Received: from localhost (unknown [86.58.254.34])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0D127154F9E16;
        Thu, 19 Sep 2019 04:18:21 -0700 (PDT)
Date:   Thu, 19 Sep 2019 13:18:16 +0200 (CEST)
Message-Id: <20190919.131816.1861650130627229336.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     marcelo.leitner@gmail.com, willemdebruijn.kernel@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH RFC v3 0/5] Support fraglist GRO/GSO
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190919110125.GN2879@gauss3.secunet.de>
References: <CA+FuTSdVFguDHXYPJBRrLhzPWBaykd+7PRqEmGf_eOFC3iHpAg@mail.gmail.com>
        <20190918165817.GA3431@localhost.localdomain>
        <20190919110125.GN2879@gauss3.secunet.de>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Sep 2019 04:18:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Thu, 19 Sep 2019 13:01:25 +0200

> If the packet data of all the fraglist GRO skbs are backed by a
> page fragment then we could just do the same by iterating with
> skb_walk_frags(). I'm not a driver expert and might be misstaken,
> but it looks like that could be done with existing hardware that
> supports segmentation offload.

Having to add frag list as well as page frag iterating in a driver is
quite a bit of logic, and added complexity.

If the frag list SKBs are indeed backed by a page, you could just as
easily coalesce everything into the page frag array of the first SKB.
