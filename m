Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBAF723F54
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 19:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390445AbfETRp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 13:45:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55402 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389355AbfETRp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 13:45:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 743BB14EC4685;
        Mon, 20 May 2019 10:45:57 -0700 (PDT)
Date:   Mon, 20 May 2019 10:45:54 -0700 (PDT)
Message-Id: <20190520.104554.602275142720021716.davem@davemloft.net>
To:     hujunwei4@huawei.com
Cc:     jon.maloy@ericsson.com, ying.xue@windriver.com,
        willemdebruijn.kernel@gmail.com, sfr@canb.auug.org.au,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, mingfangsen@huawei.com
Subject: Re: [PATCH v4] tipc: fix modprobe tipc failed after switch order
 of device registration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <624f5be3-12b4-cbd4-39e2-5419b976624b@huawei.com>
References: <624f5be3-12b4-cbd4-39e2-5419b976624b@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 May 2019 10:45:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: hujunwei <hujunwei4@huawei.com>
Date: Mon, 20 May 2019 14:43:59 +0800

> From: Junwei Hu <hujunwei4@huawei.com>
> 
> Error message printed:
> modprobe: ERROR: could not insert 'tipc': Address family not
> supported by protocol.
> when modprobe tipc after the following patch: switch order of
> device registration, commit 7e27e8d6130c
> ("tipc: switch order of device registration to fix a crash")
> 
> Because sock_create_kern(net, AF_TIPC, ...) called by
> tipc_topsrv_create_listener() in the initialization process
> of tipc_init_net(), so tipc_socket_init() must be execute before that.
> Meanwhile, tipc_net_id need to be initialized when sock_create()
> called, and tipc_socket_init() is no need to be called for each namespace.
> 
> I add a variable tipc_topsrv_net_ops, and split the
> register_pernet_subsys() of tipc into two parts, and split
> tipc_socket_init() with initialization of pernet params.
> 
> By the way, I fixed resources rollback error when tipc_bcast_init()
> failed in tipc_init_net().
> 
> Fixes: 7e27e8d6130c ("tipc: switch order of device registration to fix a crash")
> Signed-off-by: Junwei Hu <hujunwei4@huawei.com>
> Reported-by: Wang Wang <wangwang2@huawei.com>
> Reported-by: syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com
> Reviewed-by: Kang Zhou <zhoukang7@huawei.com>
> Reviewed-by: Suanming Mou <mousuanming@huawei.com>

Applied.
