Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7E60113926
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 02:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbfLEBME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 20:12:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38564 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728100AbfLEBME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 20:12:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E62514F478FA;
        Wed,  4 Dec 2019 17:12:03 -0800 (PST)
Date:   Wed, 04 Dec 2019 17:12:02 -0800 (PST)
Message-Id: <20191204.171202.946324250971280038.davem@davemloft.net>
To:     martinvarghesenokia@gmail.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        martin.varghese@nokia.com
Subject: Re: [PATCH net v2] net: Fixed updating of ethertype in
 skb_mpls_push()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1575505642-5626-1-git-send-email-martinvarghesenokia@gmail.com>
References: <1575505642-5626-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Dec 2019 17:12:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martinvarghesenokia@gmail.com>
Date: Thu,  5 Dec 2019 05:57:22 +0530

> From: Martin Varghese <martin.varghese@nokia.com>
> 
> The skb_mpls_push was not updating ethertype of an ethernet packet if
> the packet was originally received from a non ARPHRD_ETHER device.
> 
> In the below OVS data path flow, since the device corresponding to
> port 7 is an l3 device (ARPHRD_NONE) the skb_mpls_push function does
> not update the ethertype of the packet even though the previous
> push_eth action had added an ethernet header to the packet.
> 
> recirc_id(0),in_port(7),eth_type(0x0800),ipv4(tos=0/0xfc,ttl=64,frag=no),
> actions:push_eth(src=00:00:00:00:00:00,dst=00:00:00:00:00:00),
> push_mpls(label=13,tc=0,ttl=64,bos=1,eth_type=0x8847),4
> 
> Fixes: 8822e270d697 ("net: core: move push MPLS functionality from OvS to core helper")
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> ---
> Changes in v2:
>     Changed the subject line of patch.

Applied and queued up for -stable, thanks.
