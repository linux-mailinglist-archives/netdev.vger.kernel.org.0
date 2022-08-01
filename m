Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D0C5866BE
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 11:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiHAJQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 05:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiHAJQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 05:16:07 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8783C1A04D
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 02:16:03 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id uj29so6032336ejc.0
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 02:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc;
        bh=mVLib6+KglGWzrVB//L7ezE4how+oky3wShDacSr+Rk=;
        b=fp+jCnQ/ItfHQ1hBwegHh+Ldz7J5kAwEOruTIPovevlje/32kxnh/US3StTNaYN0hk
         LBjV0xdxA2kKiZ7glZAtjn3ihomHLymWh2cSyoDhKTDoMt0iZjgAys3zXeZ2SIK1lC6N
         FW7ALONcIV5nxv9CvyCeLgNoZFZ3ZWcMX0q24=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc;
        bh=mVLib6+KglGWzrVB//L7ezE4how+oky3wShDacSr+Rk=;
        b=QzGbnrua1XU5Kd/vAmuFosnL0h6lhZVfowE3HBgQR1TkLmqxgWvI4n/+APEORjwaLA
         WkeWV0XhkzHQhiY/29De2S7hmVansnRQ5oFF2kDvPkscc6iG4Mdmw1XtKYEDWhbxEePI
         +SLff2NhgEhYovFyC2wHnYC2+H0P7VadwhtBy8OGLuvdL+XWHyk9uQGQd+Yt+nfno/iS
         d8eakOT1Blq/oE0XRe73TW5Ps70fY+8ph3PRKhR2sQt6nfpLSAUdxLohpIE4QItW12C1
         clDozKzbahiYU7Z8wEIG1XEmwJ6EKaBAFYENDThZ7dxAv1DBYC5tmrtjAoEmzs+daVZ2
         EuTw==
X-Gm-Message-State: ACgBeo19dm+ztzEwnACWyPpI9h0Yn5Rm7+WjG5I+JwwPYFPMH91DMf2G
        hAxMLT4PKvgZgUE3u4kipQNO4g==
X-Google-Smtp-Source: AA6agR4W2ED17/n5sJ/4mk6scRZmpD1dZvTpHT3k2MkraGjSqDq6np/Nh+5vKxICYqkmm4nr3glzrg==
X-Received: by 2002:a17:907:1deb:b0:730:81ea:1d09 with SMTP id og43-20020a1709071deb00b0073081ea1d09mr3464726ejc.183.1659345362041;
        Mon, 01 Aug 2022 02:16:02 -0700 (PDT)
Received: from cloudflare.com (79.184.200.53.ipv4.supernova.orange.pl. [79.184.200.53])
        by smtp.gmail.com with ESMTPSA id ky1-20020a170907778100b00722e52d043dsm4984008ejc.114.2022.08.01.02.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 02:16:01 -0700 (PDT)
References: <00000000000026328205e08cdbeb@google.com>
 <20220730085654.2598-1-yin31149@gmail.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com,
        andrii@kernel.org, ast@kernel.org, borisp@nvidia.com,
        bpf@vger.kernel.org, wenjia@linux.ibm.com, ubraun@linux.ibm.com,
        daniel@iogearbox.net, guvenc@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, guwen@linux.alibaba.com,
        john.fastabend@gmail.com, kafai@fb.com, kgraul@linux.ibm.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, linux-s390@vger.kernel.org,
        yhs@fb.com, 18801353760@163.com, paskripkin@gmail.com,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v2] net/smc: fix refcount bug in sk_psock_get (2)
Date:   Mon, 01 Aug 2022 11:09:23 +0200
In-reply-to: <20220730085654.2598-1-yin31149@gmail.com>
Message-ID: <87wnbsjpdb.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sat, Jul 30, 2022 at 04:56 PM +08, Hawkins Jiawei wrote:
> Syzkaller reports refcount bug as follows:
> ------------[ cut here ]------------
> refcount_t: saturated; leaking memory.
> WARNING: CPU: 1 PID: 3605 at lib/refcount.c:19 refcount_warn_saturate+0xf4/0x1e0 lib/refcount.c:19
> Modules linked in:
> CPU: 1 PID: 3605 Comm: syz-executor208 Not tainted 5.18.0-syzkaller-03023-g7e062cda7d90 #0
> ...
> Call Trace:
>  <TASK>
>  __refcount_add_not_zero include/linux/refcount.h:163 [inline]
>  __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
>  refcount_inc_not_zero include/linux/refcount.h:245 [inline]
>  sk_psock_get+0x3bc/0x410 include/linux/skmsg.h:439
>  tls_data_ready+0x6d/0x1b0 net/tls/tls_sw.c:2091
>  tcp_data_ready+0x106/0x520 net/ipv4/tcp_input.c:4983
>  tcp_data_queue+0x25f2/0x4c90 net/ipv4/tcp_input.c:5057
>  tcp_rcv_state_process+0x1774/0x4e80 net/ipv4/tcp_input.c:6659
>  tcp_v4_do_rcv+0x339/0x980 net/ipv4/tcp_ipv4.c:1682
>  sk_backlog_rcv include/net/sock.h:1061 [inline]
>  __release_sock+0x134/0x3b0 net/core/sock.c:2849
>  release_sock+0x54/0x1b0 net/core/sock.c:3404
>  inet_shutdown+0x1e0/0x430 net/ipv4/af_inet.c:909
>  __sys_shutdown_sock net/socket.c:2331 [inline]
>  __sys_shutdown_sock net/socket.c:2325 [inline]
>  __sys_shutdown+0xf1/0x1b0 net/socket.c:2343
>  __do_sys_shutdown net/socket.c:2351 [inline]
>  __se_sys_shutdown net/socket.c:2349 [inline]
>  __x64_sys_shutdown+0x50/0x70 net/socket.c:2349
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
>  </TASK>
>
> During SMC fallback process in connect syscall, kernel will
> replaces TCP with SMC. In order to forward wakeup
> smc socket waitqueue after fallback, kernel will sets
> clcsk->sk_user_data to origin smc socket in
> smc_fback_replace_callbacks().
>
> Later, in shutdown syscall, kernel will calls
> sk_psock_get(), which treats the clcsk->sk_user_data
> as sk_psock type, triggering the refcnt warning.
>
> So, the root cause is that smc and psock, both will use
> sk_user_data field. So they will mismatch this field
> easily.
>
> This patch solves it by using another bit(defined as
> SK_USER_DATA_NOTPSOCK) in PTRMASK, to mark whether
> sk_user_data points to a sk_psock object or not.
> This patch depends on a PTRMASK introduced in commit f1ff5ce2cd5e
> ("net, sk_msg: Clear sk_user_data pointer on clone if tagged").
>
> Fixes: 341adeec9ada ("net/smc: Forward wakeup to smc socket waitqueue after fallback")
> Fixes: a60a2b1e0af1 ("net/smc: reduce active tcp_listen workers")
> Reported-and-tested-by: syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Acked-by: Wen Gu <guwen@linux.alibaba.com>
> Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
> ---

Since using psock is not the common case, I'm wondering if it makes more
sense to have an inverse flag - SK_USER_DATA_PSOCK. Flag would be set by
the psock code on assignment to sk_user_data.

This way we would also avoid some confusion. With the change below, the
SK_USER_DATA_NOTPSOCK is not *always* set when sk_user_data holds a
non-psock pointer. Only when SMC sets it.

If we go with the current approach, the rest of sites, execpt for psock,
that assign to sk_user_data should be updated to set
SK_USER_DATA_NOTPSOCK as well, IMO.

That is why I'd do it the other way.

[...]
