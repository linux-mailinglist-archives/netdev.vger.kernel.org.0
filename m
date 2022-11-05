Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4414561DDE5
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 20:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiKETuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 15:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiKETuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 15:50:22 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3467C10571;
        Sat,  5 Nov 2022 12:50:20 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id n18so5615315qvt.11;
        Sat, 05 Nov 2022 12:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wmi4cBXwD4RRiAsJ9cBaoYF9X/IkJO2wazc8jyFJHBc=;
        b=JYsT2fJvA35DUV/jmQhlG2b7SFajiMKzyX4Tnk/eVH/r5Sptdv4tCFcZngrwmeCC8j
         zAasNwI9vtR21jIPowm5HcKpsHM5+waa0MoFKts08nLqXisVu/XQhU2MqRSo4hz3uLL8
         BU3SjNCcZHaJagh5GWj59TTLeFDxNr2wYj6iDoId8SvCpAeC4wAe4jeKVm5TG/crkjxK
         4O9Xa3At7L9pd5z8yg5PfAMu06aZGOO9EpHwC9Bvsio4TIBNGoAuS67qHNaJ3Zw724BY
         ebdchdJLqmpyroO4pfWlSQUmI5EjGO/O2DX7NuWlxLXF6T6JmhpDaW58LycivZfJ3GWX
         ks/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wmi4cBXwD4RRiAsJ9cBaoYF9X/IkJO2wazc8jyFJHBc=;
        b=gCICPZ5UrBaWCQKSUclT4Hgn687i/MqQ6IU1xkg02gDkVdX6anKTnLU/9yyS+lKN6X
         I4DB3LrC4l+ivi/OTIQlqesKVMERoe2p9gKV1fSZ4uEXCNUkQBmgAFX7kWtzrGu3zn2J
         D2+XYJIpsDG2++0V5MI8W3Yeu9QaRyj1QrN1VTs5pjVBIzRW08Yq2N3qzJiGBjzrU27m
         yPbo8ryrlywbexg/758drxVc2gZUTy6UHkvxxVxz+1DLFhNhoeaQhgoaKiOa9b+tGE2h
         VUwgDH+3SJuaxKm+aHSJO7hsG3ZaQK5KJrj+G9N7pDrbgfmj0aeJpWNHqaLFPZec6ZXN
         LU3w==
X-Gm-Message-State: ACrzQf0B08mfi7X4mw5dHZrD42LArHzCJm4ztXMUb2HL3U4IM6EJzGzI
        4ORbK2QU9apMw7rU0LnHBsA=
X-Google-Smtp-Source: AMsMyM7isalRWuMXBDXLY0ObQZqbl0dHs9ZeH6F4EgOl0oQm4LwJtXNQ2tEdFg/2uMHVtf87FmIabA==
X-Received: by 2002:ad4:4ea7:0:b0:4b9:365b:2a86 with SMTP id ed7-20020ad44ea7000000b004b9365b2a86mr37733354qvb.58.1667677819332;
        Sat, 05 Nov 2022 12:50:19 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:3e4a:e8c3:587a:efae])
        by smtp.gmail.com with ESMTPSA id m19-20020a05620a24d300b006ee8874f5fasm2646829qkn.53.2022.11.05.12.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 12:50:18 -0700 (PDT)
Date:   Sat, 5 Nov 2022 12:50:17 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, 18801353760@163.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sched: fix memory leak in tcindex_set_parms
Message-ID: <Y2a+eXr20BcI3JDe@pop-os.localdomain>
References: <20221031060835.11722-1-yin31149@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031060835.11722-1-yin31149@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 02:08:35PM +0800, Hawkins Jiawei wrote:
> Syzkaller reports a memory leak as follows:
> ====================================
> BUG: memory leak
> unreferenced object 0xffff88810c287f00 (size 256):
>   comm "syz-executor105", pid 3600, jiffies 4294943292 (age 12.990s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff814cf9f0>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1046
>     [<ffffffff839c9e07>] kmalloc include/linux/slab.h:576 [inline]
>     [<ffffffff839c9e07>] kmalloc_array include/linux/slab.h:627 [inline]
>     [<ffffffff839c9e07>] kcalloc include/linux/slab.h:659 [inline]
>     [<ffffffff839c9e07>] tcf_exts_init include/net/pkt_cls.h:250 [inline]
>     [<ffffffff839c9e07>] tcindex_set_parms+0xa7/0xbe0 net/sched/cls_tcindex.c:342
>     [<ffffffff839caa1f>] tcindex_change+0xdf/0x120 net/sched/cls_tcindex.c:553
>     [<ffffffff8394db62>] tc_new_tfilter+0x4f2/0x1100 net/sched/cls_api.c:2147
>     [<ffffffff8389e91c>] rtnetlink_rcv_msg+0x4dc/0x5d0 net/core/rtnetlink.c:6082
>     [<ffffffff839eba67>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2540
>     [<ffffffff839eab87>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>     [<ffffffff839eab87>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
>     [<ffffffff839eb046>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
>     [<ffffffff8383e796>] sock_sendmsg_nosec net/socket.c:714 [inline]
>     [<ffffffff8383e796>] sock_sendmsg+0x56/0x80 net/socket.c:734
>     [<ffffffff8383eb08>] ____sys_sendmsg+0x178/0x410 net/socket.c:2482
>     [<ffffffff83843678>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
>     [<ffffffff838439c5>] __sys_sendmmsg+0x105/0x330 net/socket.c:2622
>     [<ffffffff83843c14>] __do_sys_sendmmsg net/socket.c:2651 [inline]
>     [<ffffffff83843c14>] __se_sys_sendmmsg net/socket.c:2648 [inline]
>     [<ffffffff83843c14>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2648
>     [<ffffffff84605fd5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>     [<ffffffff84605fd5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> ====================================
> 
> Kernel will uses tcindex_change() to change an existing
> traffic-control-indices filter properties. During the
> process of changing, kernel will clears the old
> traffic-control-indices filter result, and updates it
> by RCU assigning new traffic-control-indices data.
> 
> Yet the problem is that, kernel will clears the old
> traffic-control-indices filter result, without destroying
> its tcf_exts structure, which triggers the above
> memory leak.
> 
> This patch solves it by using tcf_exts_destroy() to
> destroy the tcf_exts structure in old
> traffic-control-indices filter result.

So... your patch can be just the following one-liner, right?


diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 1c9eeb98d826..00a6c04a4b42 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -479,6 +479,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	}
 
 	if (old_r && old_r != r) {
+		tcf_exts_destroy(&old_r->exts);
 		err = tcindex_filter_result_init(old_r, cp, net);
 		if (err < 0) {
 			kfree(f);
