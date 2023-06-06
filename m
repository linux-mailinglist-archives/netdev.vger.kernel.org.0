Return-Path: <netdev+bounces-8645-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAADC725098
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 01:15:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F25FA2810D1
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 23:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4030134468;
	Tue,  6 Jun 2023 23:15:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5B07E4
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 23:15:13 +0000 (UTC)
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF12F1992
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 16:15:11 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id 6a1803df08f44-62614f2eee1so51468986d6.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 16:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686093310; x=1688685310;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5pEsgz3TdSH5GiAvcoIag9xF6lfM+RfV2pNwi75atNM=;
        b=UjvMByTiBKdpSmNcBi6UnSap7Nei0m9pGs42hf74SiOlGqLos9llr3i1ESPOB5rtzF
         GQmi4TRij94mnuZor92lajQqad+zF6XjjlmFj1cuK6jq8wsj0oQKJ4EUq3OjMTXNU+f/
         FV98cox8aMp+BodbXkPRbrfz3UcNB2u0pXhymuniYUtnOnUTwOY8ZIgJo1PSHKdWSriM
         uTda2o6LQcFIW1NJohgh7z4uOI5KP0/JFgibiXQLhpgZo8MgbF1YYk+l39HSvHINRIw/
         xn4j14mbH1dc9ih5F21lCa+dGv9a8p2uB6ICjc6NpR9M75D0Q516zYnAXQM0gTzrpju9
         5QWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686093310; x=1688685310;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5pEsgz3TdSH5GiAvcoIag9xF6lfM+RfV2pNwi75atNM=;
        b=MrBzrdRJPOolT1UrZU/QeNvJ88lfBSR9eNLCo9idjD/7erY7Fci3UZ8SpwdHjq70It
         iBuonlopn1OjPu/skkV31XasIzx2K/59gXxzdOtYRbyUAZheZrXGAavBtAO5x3+zVyZj
         6mO58wbuIse91ctiazjBQPgisPW192Vah5H3tijH7cfwJrqGjKYcVDBKfbfNtWaL8cS+
         28sW1Q/BXiUxy0io2INqO+OegBXo0ICEEeAeTIvd76OTpfFJRBrHePm75IZkV9RGML6Q
         aCb7aVTMV2a7huNYXfuiilVj7fgiIXOgU+tZf8amzOsjPwwRsCdeoRVQarR6PpZ3n8bu
         Go7g==
X-Gm-Message-State: AC+VfDzPnl6NG93IpNkpWPzsBkeNhVY17+Ot0eYrGfKuLHv8G/c5h27H
	h0zXiZRS5B4q1fDSTMFq+STf9jKU9A==
X-Google-Smtp-Source: ACHHUZ6sfzImH3zlFBFo81g9ymQ+r/1YKyy7+DUhGUbXl+//IfeclbSrZ64RjpZS0Yi/fBqHfWD6aA==
X-Received: by 2002:a05:6214:767:b0:61b:6fcd:34b7 with SMTP id f7-20020a056214076700b0061b6fcd34b7mr1055163qvz.17.1686093310395;
        Tue, 06 Jun 2023 16:15:10 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:6c60:5e57:914a:4abf])
        by smtp.gmail.com with ESMTPSA id n18-20020a056214009200b006262e5c96d0sm5732596qvr.129.2023.06.06.16.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 16:15:09 -0700 (PDT)
Date: Tue, 6 Jun 2023 16:15:03 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Eric Dumazet <edumazet@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	netdev@vger.kernel.org, eric.dumazet@gmail.com,
	syzbot <syzkaller@googlegroups.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Peilin Ye <peilin.ye@bytedance.com>
Subject: Re: [PATCH net] net: sched: add rcu annotations around
 qdisc->qdisc_sleeping
Message-ID: <ZH+993P67V0EaMJT@C02FL77VMD6R.googleapis.com>
References: <20230606111929.4122528-1-edumazet@google.com>
 <CAM0EoMk+uj9UZERGLuNf_T65iGwPP04hsN5cwsNj3_YcXzM1ew@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMk+uj9UZERGLuNf_T65iGwPP04hsN5cwsNj3_YcXzM1ew@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 11:50:45AM -0400, Jamal Hadi Salim wrote:
> > syzbot reported a race around qdisc->qdisc_sleeping [1]
> >
> > It is time we add proper annotations to reads and writes to/from
> > qdisc->qdisc_sleeping.
> >
> > [1]
> > BUG: KCSAN: data-race in dev_graft_qdisc / qdisc_lookup_rcu
> >
> > read to 0xffff8881286fc618 of 8 bytes by task 6928 on cpu 1:
> > qdisc_lookup_rcu+0x192/0x2c0 net/sched/sch_api.c:331
> > __tcf_qdisc_find+0x74/0x3c0 net/sched/cls_api.c:1174
> > tc_get_tfilter+0x18f/0x990 net/sched/cls_api.c:2547
> > rtnetlink_rcv_msg+0x7af/0x8c0 net/core/rtnetlink.c:6386
> > netlink_rcv_skb+0x126/0x220 net/netlink/af_netlink.c:2546
> > rtnetlink_rcv+0x1c/0x20 net/core/rtnetlink.c:6413
> > netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
> > netlink_unicast+0x56f/0x640 net/netlink/af_netlink.c:1365
> > netlink_sendmsg+0x665/0x770 net/netlink/af_netlink.c:1913
> > sock_sendmsg_nosec net/socket.c:724 [inline]
> > sock_sendmsg net/socket.c:747 [inline]
> > ____sys_sendmsg+0x375/0x4c0 net/socket.c:2503
> > ___sys_sendmsg net/socket.c:2557 [inline]
> > __sys_sendmsg+0x1e3/0x270 net/socket.c:2586
> > __do_sys_sendmsg net/socket.c:2595 [inline]
> > __se_sys_sendmsg net/socket.c:2593 [inline]
> > __x64_sys_sendmsg+0x46/0x50 net/socket.c:2593
> > do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
> > entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > write to 0xffff8881286fc618 of 8 bytes by task 6912 on cpu 0:
> > dev_graft_qdisc+0x4f/0x80 net/sched/sch_generic.c:1115
> > qdisc_graft+0x7d0/0xb60 net/sched/sch_api.c:1103
> > tc_modify_qdisc+0x712/0xf10 net/sched/sch_api.c:1693
> > rtnetlink_rcv_msg+0x807/0x8c0 net/core/rtnetlink.c:6395
> > netlink_rcv_skb+0x126/0x220 net/netlink/af_netlink.c:2546
> > rtnetlink_rcv+0x1c/0x20 net/core/rtnetlink.c:6413
> > netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
> > netlink_unicast+0x56f/0x640 net/netlink/af_netlink.c:1365
> > netlink_sendmsg+0x665/0x770 net/netlink/af_netlink.c:1913
> > sock_sendmsg_nosec net/socket.c:724 [inline]
> > sock_sendmsg net/socket.c:747 [inline]
> > ____sys_sendmsg+0x375/0x4c0 net/socket.c:2503
> > ___sys_sendmsg net/socket.c:2557 [inline]
> > __sys_sendmsg+0x1e3/0x270 net/socket.c:2586
> > __do_sys_sendmsg net/socket.c:2595 [inline]
> > __se_sys_sendmsg net/socket.c:2593 [inline]
> > __x64_sys_sendmsg+0x46/0x50 net/socket.c:2593
> > do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
> > entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > Reported by Kernel Concurrency Sanitizer on:
> > CPU: 0 PID: 6912 Comm: syz-executor.5 Not tainted 6.4.0-rc3-syzkaller-00190-g0d85b27b0cc6 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/16/2023
> >
> > Fixes: 3a7d0d07a386 ("net: sched: extend Qdisc with rcu")
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Vlad Buslov <vladbu@nvidia.com>
> 
> Acked-by: Jamal Hadi Salim<jhs@mojatatu.com>
> 
> +Cc Peilin. Peilin any update on what you are chasing on grafting?

Hi Jamal,

Sorry for the delay, I was looking at how Qdisc::flags are accessed since
Vlad mentioned it.  I'll update in that thread hopefully today.

Thanks,
Peilin Ye


