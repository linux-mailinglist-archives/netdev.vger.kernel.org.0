Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12634C7C1B
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 22:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiB1Vf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 16:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiB1Vf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 16:35:57 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 919D113CEEC;
        Mon, 28 Feb 2022 13:35:18 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1DC3B60201;
        Mon, 28 Feb 2022 22:33:54 +0100 (CET)
Date:   Mon, 28 Feb 2022 22:35:15 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH nf] netfilter: fix use-after-free in
 __nf_register_net_hook()
Message-ID: <Yh1AEzg4OHvcCECE@salvia>
References: <20220227180141.931857-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220227180141.931857-1-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 27, 2022 at 10:01:41AM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We must not dereference @new_hooks after nf_hook_mutex has been released,
> because other threads might have freed our allocated hooks already.
> 
> BUG: KASAN: use-after-free in nf_hook_entries_get_hook_ops include/linux/netfilter.h:130 [inline]
> BUG: KASAN: use-after-free in hooks_validate net/netfilter/core.c:171 [inline]
> BUG: KASAN: use-after-free in __nf_register_net_hook+0x77a/0x820 net/netfilter/core.c:438
> Read of size 2 at addr ffff88801c1a8000 by task syz-executor237/4430

Applied, thanks.
