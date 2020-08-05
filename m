Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9021D23CF3F
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgHETRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgHETPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 15:15:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B922C061A29;
        Wed,  5 Aug 2020 12:13:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 57300152E87E4;
        Wed,  5 Aug 2020 11:56:35 -0700 (PDT)
Date:   Wed, 05 Aug 2020 12:13:20 -0700 (PDT)
Message-Id: <20200805.121320.990654813010240919.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     echaudro@redhat.com, kuba@kernel.org, pabeni@redhat.com,
        pshelar@ovn.org, syzkaller-bugs@googlegroups.com,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: openvswitch: silence suspicious RCU usage warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200805071911.64101-1-xiangxia.m.yue@gmail.com>
References: <20200805071911.64101-1-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Aug 2020 11:56:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Wed,  5 Aug 2020 15:19:11 +0800

> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> ovs_flow_tbl_destroy always is called from RCU callback
> or error path. It is no need to check if rcu_read_lock
> or lockdep_ovsl_is_held was held.
> 
> ovs_dp_cmd_fill_info always is called with ovs_mutex,
> So use the rcu_dereference_ovsl instead of rcu_dereference
> in ovs_flow_tbl_masks_cache_size.
> 
> Fixes: 9bf24f594c6a ("net: openvswitch: make masks cache size configurable")
> Cc: Eelco Chaudron <echaudro@redhat.com>
> Reported-by: syzbot+c0eb9e7cdde04e4eb4be@syzkaller.appspotmail.com
> Reported-by: syzbot+f612c02823acb02ff9bc@syzkaller.appspotmail.com
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Applied, thank you.
