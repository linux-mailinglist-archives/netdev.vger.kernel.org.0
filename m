Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA5410F1D8
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 22:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbfLBVE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 16:04:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40538 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbfLBVE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 16:04:27 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1424414CEFF0F;
        Mon,  2 Dec 2019 13:04:26 -0800 (PST)
Date:   Mon, 02 Dec 2019 13:04:23 -0800 (PST)
Message-Id: <20191202.130423.1014387604144365216.davem@davemloft.net>
To:     martinvarghesenokia@gmail.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        martin.varghese@nokia.com
Subject: Re: [PATCH v3 net] Fixed updating of ethertype in function
 skb_mpls_pop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1575263991-5915-1-git-send-email-martinvarghesenokia@gmail.com>
References: <1575263991-5915-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Dec 2019 13:04:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martinvarghesenokia@gmail.com>
Date: Mon,  2 Dec 2019 10:49:51 +0530

> From: Martin Varghese <martin.varghese@nokia.com>
> 
> The skb_mpls_pop was not updating ethertype of an ethernet packet if the
> packet was originally received from a non ARPHRD_ETHER device.
> 
> In the below OVS data path flow, since the device corresponding to port 7
> is an l3 device (ARPHRD_NONE) the skb_mpls_pop function does not update
> the ethertype of the packet even though the previous push_eth action had
> added an ethernet header to the packet.
> 
> recirc_id(0),in_port(7),eth_type(0x8847),
> mpls(label=12/0xfffff,tc=0/0,ttl=0/0x0,bos=1/1),
> actions:push_eth(src=00:00:00:00:00:00,dst=00:00:00:00:00:00),
> pop_mpls(eth_type=0x800),4
> 
> Fixes: ed246cee09b9 ("net: core: move pop MPLS functionality from OvS to core helper")
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

Applied and queued up for -stable, thanks.
