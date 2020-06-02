Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FE61EB7D5
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 11:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgFBJDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 05:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgFBJDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 05:03:35 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF8CC03E97D
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 02:03:34 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id e2so11964411eje.13
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 02:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=OCBiVEb5pjPsb0aqtFO+a+GT5/LuUuNxOzOXSUsfdzw=;
        b=k+MUEBJ38H86qqXO1xpz00JaM4MyCjl5ZpLlnLrKfafF38w7k79ZrhweLhI/4EcGBm
         un/YRPmDKPIPzngboPT4ysf6qZT9nL4pXAExQ8XWJWo/5hJqIYzXY092jAXOV2U/COfp
         RtygS1YMueZgvUNjdCzTRddKlhVB63nycK/c0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=OCBiVEb5pjPsb0aqtFO+a+GT5/LuUuNxOzOXSUsfdzw=;
        b=mtigs9RQdd7Nf7KqmezdBkA4yel2EFCi47jAI81XdM1NUn+ZXuNo2sx1mekIbL7FCG
         edEfQO/+QRC762fxqTIAtZKqF1Lk4Rsoi01AkcG7RIerR+w48jSiRVQXdvyFzUHeo//P
         iPLR6sZQCmKN/BelvYDz7WMsFxiEeL781uSVYZNNKiFav8FgGMceiOaojKcQ+oxQC+f1
         BWp6sCVUsatxWA1SpDSlereE1siPEdqADy94upIvtUQknUv/5CofYNbYfdl4a5pEmazO
         pmP2dXPNsf3M5PSWu22wDxzyQZSTdm4dNN0KXICQcaA+UwfdZSShCG7GvqyDYEE69imD
         sL+Q==
X-Gm-Message-State: AOAM533uSXVZoPlTBpRtaQ52ZZyAKF8VhMMB8v7ECMgGCwVustyPvuEn
        VwwNiEId7w8HG/GSpH7ilcnE4gM/38I=
X-Google-Smtp-Source: ABdhPJwaaivmKs7lDTBVdz8sdAS4W2cZYPPCt5OW1AuFGraUfkWciVLjNUCU1DL65/2wzHswDjT6bQ==
X-Received: by 2002:a17:906:1b48:: with SMTP id p8mr21204797ejg.399.1591088613068;
        Tue, 02 Jun 2020 02:03:33 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id b24sm1237354edw.70.2020.06.02.02.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 02:03:32 -0700 (PDT)
References: <db5393a3-d4b3-45c1-8219-f23b43a8d2ab.anny.hu@linux.alibaba.com> <5ecd85c7a21fd_35792ad4115a05b8a9@john-XPS-13-9370.notmuch> <c2f19152-efd0-530f-8b59-74e2393cee0e@linux.alibaba.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     dihu <anny.hu@linux.alibaba.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
Subject: Re: [PATCH] bpf/sockmap: fix kernel panic at __tcp_bpf_recvmsg
In-reply-to: <c2f19152-efd0-530f-8b59-74e2393cee0e@linux.alibaba.com>
Date:   Tue, 02 Jun 2020 11:03:30 +0200
Message-ID: <87h7vt3km5.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 11:05 AM CEST, dihu wrote:
> On 2020/5/27 5:10, John Fastabend wrote:
>> dihu wrote:
>>>  From 865a45747de6b68fd02a0ff128a69a5c8feb73c3 Mon Sep 17 00:00:00 2001
>>> From: dihu <anny.hu@linux.alibaba.com>
>>> Date: Mon, 25 May 2020 17:23:16 +0800
>>> Subject: [PATCH] bpf/sockmap: fix kernel panic at __tcp_bpf_recvmsg
>>>
>>> When user application calls read() with MSG_PEEK flag to read data
>>> of bpf sockmap socket, kernel panic happens at
>>> __tcp_bpf_recvmsg+0x12c/0x350. sk_msg is not removed from ingress_msg
>>> queue after read out under MSG_PEEK flag is set. Because it's not
>>> judged whether sk_msg is the last msg of ingress_msg queue, the next
>>> sk_msg may be the head of ingress_msg queue, whose memory address of
>>> sg page is invalid. So it's necessary to add check codes to prevent
>>> this problem.
>>>
>>> [20759.125457] BUG: kernel NULL pointer dereference, address:
>>> 0000000000000008
>>> [20759.132118] CPU: 53 PID: 51378 Comm: envoy Tainted: G            E
>>> 5.4.32 #1
>>> [20759.140890] Hardware name: Inspur SA5212M4/YZMB-00370-109, BIOS
>>> 4.1.12 06/18/2017
>>> [20759.149734] RIP: 0010:copy_page_to_iter+0xad/0x300
>>> [20759.270877] __tcp_bpf_recvmsg+0x12c/0x350
>>> [20759.276099] tcp_bpf_recvmsg+0x113/0x370
>>> [20759.281137] inet_recvmsg+0x55/0xc0
>>> [20759.285734] __sys_recvfrom+0xc8/0x130
>>> [20759.290566] ? __audit_syscall_entry+0x103/0x130
>>> [20759.296227] ? syscall_trace_enter+0x1d2/0x2d0
>>> [20759.301700] ? __audit_syscall_exit+0x1e4/0x290
>>> [20759.307235] __x64_sys_recvfrom+0x24/0x30
>>> [20759.312226] do_syscall_64+0x55/0x1b0
>>> [20759.316852] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>
>>> Signed-off-by: dihu <anny.hu@linux.alibaba.com>
>>> ---
>>>   net/ipv4/tcp_bpf.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
>>> index 5a05327..c0d4624 100644
>>> --- a/net/ipv4/tcp_bpf.c
>>> +++ b/net/ipv4/tcp_bpf.c
>>> @@ -64,6 +64,9 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
>>>     } while (i != msg_rx->sg.end);
>>>
>>>     if (unlikely(peek)) {
>>> +   if (msg_rx == list_last_entry(&psock->ingress_msg,
>>> +       struct sk_msg, list))
>>> +    break;
>>
>> Thanks. Change looks good but spacing is a bit off . Can we
>> turn those spaces into tabs? Otherwise adding fixes tag and
>> my ack would be great.
>>
>> Fixes: 02c558b2d5d67 ("bpf: sockmap, support for msg_peek in sk_msg with redirect ingress")
>> Acked-by: John Fastabend <john.fastabend@gmail.com>
>
>
> From 127a334fa5e5d029353ceb1a0414886c527f4be5 Mon Sep 17 00:00:00 2001
> From: dihu <anny.hu@linux.alibaba.com>
> Date: Fri, 29 May 2020 16:38:50 +0800
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
> [20759.132118] CPU: 53 PID: 51378 Comm: envoy Tainted: G E
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
> net/ipv4/tcp_bpf.c | 3 +++
> 1 file changed, 3 insertions(+)
>
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index 5a05327..b82e4c3 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -64,6 +64,9 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
>   } while (i != msg_rx->sg.end);
>
>   if (unlikely(peek)) {
> +   if (msg_rx == list_last_entry(&psock->ingress_msg,
> +       struct sk_msg, list))
> +    break;
>    msg_rx = list_next_entry(msg_rx, list);
>    continue;
>   }

Looks like the patch is garbled. I suspect due to copy-paste to an
e-mail client. Context line got wrapped and there are non-breaking
spaces instead of tabs in the body.

Crash fix is important so could you resend it with `git send-email`?

  git send-email --to bpf@vger.kernel.org --cc netdev@vger.kernel.org file.patch

You might find the documentation below helpful:

  https://www.kernel.org/doc/html/latest/process/email-clients.html
