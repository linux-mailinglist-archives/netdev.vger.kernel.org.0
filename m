Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B90323AFEC
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgHCWFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgHCWFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:05:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E9EC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 15:05:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 050691276EAEA;
        Mon,  3 Aug 2020 14:48:59 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:05:44 -0700 (PDT)
Message-Id: <20200803.150544.288223634189041379.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net/sched: act_ct: fix miss set mru for ovs
 after defrag in act_ct
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1596163501-7113-1-git-send-email-wenxu@ucloud.cn>
References: <1596163501-7113-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 14:49:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu@ucloud.cn
Date: Fri, 31 Jul 2020 10:45:01 +0800

> From: wenxu <wenxu@ucloud.cn>
> 
> When openvswitch conntrack offload with act_ct action. Fragment packets
> defrag in the ingress tc act_ct action and miss the next chain. Then the
> packet pass to the openvswitch datapath without the mru. The over
> mtu packet will be dropped in output action in openvswitch for over mtu.
> 
> "kernel: net2: dropped over-mtu packet: 1528 > 1500"
> 
> This patch add mru in the tc_skb_ext for adefrag and miss next chain
> situation. And also add mru in the qdisc_skb_cb. The act_ct set the mru
> to the qdisc_skb_cb when the packet defrag. And When the chain miss,
> The mru is set to tc_skb_ext which can be got by ovs datapath.
> 
> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Applied and queued up for -stable, thank you.
