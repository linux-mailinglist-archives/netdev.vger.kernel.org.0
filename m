Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E692AB797C
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 14:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732109AbfISMdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 08:33:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55686 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbfISMc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 08:32:59 -0400
Received: from localhost (unknown [86.58.254.34])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4DE2D154F7DB6;
        Thu, 19 Sep 2019 05:32:57 -0700 (PDT)
Date:   Thu, 19 Sep 2019 14:32:52 +0200 (CEST)
Message-Id: <20190919.143252.1698401511955783402.davem@davemloft.net>
To:     gerlitz.or@gmail.com
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, soheil@google.com, ncardwell@google.com,
        ycheng@google.com, daniel@iogearbox.net, tariqt@mellanox.com
Subject: Re: [PATCH net-next] tcp: force a PSH flag on TSO packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAJ3xEMhh=Ow-fZqnPtxUyZsCN89dRmy=NcaO+iK+iZZYBdZbqA@mail.gmail.com>
References: <20190910214928.220727-1-edumazet@google.com>
        <CAJ3xEMhh=Ow-fZqnPtxUyZsCN89dRmy=NcaO+iK+iZZYBdZbqA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Sep 2019 05:32:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Gerlitz <gerlitz.or@gmail.com>
Date: Thu, 19 Sep 2019 15:17:54 +0300

> On Wed, Sep 11, 2019 at 12:54 AM Eric Dumazet <edumazet@google.com> wrote:
>> When tcp sends a TSO packet, adding a PSH flag on it
>> reduces the sojourn time of GRO packet in GRO receivers.
>>
>> This is particularly the case under pressure, since RX queues
>> receive packets for many concurrent flows.
>>
>> A sender can give a hint to GRO engines when it is
>> appropriate to flush a super-packet, especially when pacing
> 
> Hi Eric,
> 
> Is this correct that we add here the push flag for the tcp header template
> from which all the tcp headers for SW GSO packets will be generated?
> 
> Wouldn't that cause a too early flush on GRO engines at the receiver side?

I thought segmentation offload mechanism are not supposed to propagate
the PSH to all of the packets.
