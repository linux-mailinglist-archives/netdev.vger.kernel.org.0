Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D07DA5C55
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 20:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfIBSmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 14:42:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35496 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbfIBSmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 14:42:52 -0400
Received: from localhost (unknown [63.64.162.234])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8401E15404A7B;
        Mon,  2 Sep 2019 11:42:51 -0700 (PDT)
Date:   Mon, 02 Sep 2019 11:42:51 -0700 (PDT)
Message-Id: <20190902.114251.1327692999568460655.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     sridhar.samudrala@intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net_failover: get rid of the limitaion
 receive packet from standy dev when primary exist
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567141668-12196-1-git-send-email-wenxu@ucloud.cn>
References: <1567141668-12196-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Sep 2019 11:42:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu@ucloud.cn
Date: Fri, 30 Aug 2019 13:07:48 +0800

> From: wenxu <wenxu@ucloud.cn>
> 
> For receive side the standby, primary and failover is the same one,
> If the packet receive from standby or primary should can be deliver
> to failover dev.
> 
> For example: there are VF and virtio device failover together.
> When live migration the VF detached and send/recv packet through
> virtio device. When VF attached again some ingress traffic may
> receive from virtio device for cache reason(TC flower offload in
> sw mode).
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>

I don't understand, the device logic guarding the device rewriting in
this handler looks very much intentional.

After your changes we have no logic at all, we just unconditionally
always rewrite.

