Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF801E30F7
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 23:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389698AbgEZVKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388900AbgEZVKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 17:10:40 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3800AC061A0F;
        Tue, 26 May 2020 14:10:40 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d10so10673955pgn.4;
        Tue, 26 May 2020 14:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:message-id:in-reply-to:references:subject:mime-version
         :content-transfer-encoding;
        bh=LQ07X5bAq3Ki1aAX/noIXrCEkby3LJZQPnhWb4E5GUk=;
        b=taOgEz1ppNiAxsHsY6RuY8GtvxE7Y9WvNL2ppqBmENgFbZ50Ksgx+OxpFVV3pkUlpR
         xi0EMl2ZmZh/A6ljW3Zf0HH/b6R616adjjS0Lo+sDjCpOuOxM13FLrT/WUFaU7YshhrS
         J1d8I2ZEnJM4QsSLf8lOL+9T3xBCQTq7KO/XYZf3JrcOv6CMxmlpiMucq9njwlk9QDLp
         8aT0qOXeNoR6sR85qy41kA73rousDRBn905VrKiAgYdscrqHBqB1ycyA4zIIV/2eefxC
         G5CbZX15eQr7G3mCPdSDNXjEaP05ArMzqazPPprvfrkmioJvFp9lPNhjcsH569dwlxXX
         Ccfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:message-id:in-reply-to:references
         :subject:mime-version:content-transfer-encoding;
        bh=LQ07X5bAq3Ki1aAX/noIXrCEkby3LJZQPnhWb4E5GUk=;
        b=XEhguT5E1fRA6zctGhMQ9COmvqrAnGLH9VVXrkxPlhLeWWrJdhlYC8/1KUuX+iSUlO
         lcoMZuShAw2/JUUt8MiCpLgqHxXsN0v7KxrSCGyt9OOZ9Ot8iwHto3ci6Tx8cHINceZE
         QelJD0+rLnKn4I8FcSumrVArDyfoiSZ+nwh5zyBaqlx3ZrCCPKnaVtaNXjZkz4LgDyLZ
         NBggYnQrVUOA82BvYkm617Oy37yO8ppVcSzsnCljITq5EFAtIh35DI/PSX8kJidb7YAv
         3Ku9oWJz7itRp9JJlybFpbR5pqXboAvjRzjlhw+KSvn1OTb3gUzFy+vvZhsVbjvZJlqg
         ST1Q==
X-Gm-Message-State: AOAM532PKzouv43FfhFcw3rKuzJktGxfgj3nvGHUWwmrG9G5voriETWm
        LG//QMnvYoMBOsuoAxzz0V4=
X-Google-Smtp-Source: ABdhPJwYI63FtqISWI/Jl563YFOg5YPghRJbQn8RnadTZE/Fm4gWxXreTsGZZgrl8dKuvEQ6M3JvVg==
X-Received: by 2002:a65:498f:: with SMTP id r15mr716284pgs.345.1590527439802;
        Tue, 26 May 2020 14:10:39 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h7sm446324pgn.60.2020.05.26.14.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 14:10:38 -0700 (PDT)
Date:   Tue, 26 May 2020 14:10:31 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     dihu <anny.hu@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <5ecd85c7a21fd_35792ad4115a05b8a9@john-XPS-13-9370.notmuch>
In-Reply-To: <db5393a3-d4b3-45c1-8219-f23b43a8d2ab.anny.hu@linux.alibaba.com>
References: <db5393a3-d4b3-45c1-8219-f23b43a8d2ab.anny.hu@linux.alibaba.com>
Subject: RE: [PATCH] bpf/sockmap: fix kernel panic at __tcp_bpf_recvmsg
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dihu wrote:
> From 865a45747de6b68fd02a0ff128a69a5c8feb73c3 Mon Sep 17 00:00:00 2001
> From: dihu <anny.hu@linux.alibaba.com>
> Date: Mon, 25 May 2020 17:23:16 +0800
> Subject: [PATCH] bpf/sockmap: fix kernel panic at __tcp_bpf_recvmsg
> 
> When user application calls read() with MSG_PEEK flag to read data
> of bpf sockmap socket, kernel panic happens at
> __tcp_bpf_recvmsg+0x12c/0x350. sk_msg is not removed from ingress_msg
> queue after read out under MSG_PEEK flag is set. Because it's not
> judged whether sk_msg is the last msg of ingress_msg queue, the next
> sk_msg may be the head of ingress_msg queue, whose memory address of
> sg page is invalid. So it's necessary to add check codes to prevent
> this problem.
> 
> [20759.125457] BUG: kernel NULL pointer dereference, address:
> 0000000000000008
> [20759.132118] CPU: 53 PID: 51378 Comm: envoy Tainted: G            E
> 5.4.32 #1
> [20759.140890] Hardware name: Inspur SA5212M4/YZMB-00370-109, BIOS
> 4.1.12 06/18/2017
> [20759.149734] RIP: 0010:copy_page_to_iter+0xad/0x300
> [20759.270877] __tcp_bpf_recvmsg+0x12c/0x350
> [20759.276099] tcp_bpf_recvmsg+0x113/0x370
> [20759.281137] inet_recvmsg+0x55/0xc0
> [20759.285734] __sys_recvfrom+0xc8/0x130
> [20759.290566] ? __audit_syscall_entry+0x103/0x130
> [20759.296227] ? syscall_trace_enter+0x1d2/0x2d0
> [20759.301700] ? __audit_syscall_exit+0x1e4/0x290
> [20759.307235] __x64_sys_recvfrom+0x24/0x30
> [20759.312226] do_syscall_64+0x55/0x1b0
> [20759.316852] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Signed-off-by: dihu <anny.hu@linux.alibaba.com>
> ---
>  net/ipv4/tcp_bpf.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index 5a05327..c0d4624 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -64,6 +64,9 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
>    } while (i != msg_rx->sg.end);
> 
>    if (unlikely(peek)) {
> +   if (msg_rx == list_last_entry(&psock->ingress_msg,
> +       struct sk_msg, list))
> +    break;


Thanks. Change looks good but spacing is a bit off . Can we
turn those spaces into tabs? Otherwise adding fixes tag and
my ack would be great.

Fixes: 02c558b2d5d67 ("bpf: sockmap, support for msg_peek in sk_msg with redirect ingress")
Acked-by: John Fastabend <john.fastabend@gmail.com>
