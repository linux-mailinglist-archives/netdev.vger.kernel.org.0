Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5006629C6
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 16:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237216AbjAIPW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 10:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233321AbjAIPWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 10:22:10 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D401C922
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 07:21:11 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-482363a1232so117229767b3.3
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 07:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5aVQsmC4CXYrfVLoZKxVbVq0RUkZDRsh5TxThuMCMmU=;
        b=k9tk/TmHq0DhEW6Qi9fIk4cVJeag11W69L7khvrCZJ1Q2diWkv9jOy/aCGFsvPZtqp
         waK2jBW0khYv0eb8tLpUJlMkD+iRaz8kI3US8UyGyvTBNO+YbF7BGzwT3TVMA+Htt36m
         48rVVqvcryLQGi/BKwkRrX/+Mgyrqe06eGYD8FtCh/kBei8AqhODpoyaNwDnETAtoUga
         PinmJmWCf9bjoweT1hXszTZ2/rx2w0U2inuOD3i9MB1gMJz3TXs3P0LLxU7UesDw2xp0
         xMT5O6cVrl2JjRZo9d95sJtn4huV2LR9D8lBVCQDHf547PzTIQCYCueY7U/Qxa4lQ47d
         dAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5aVQsmC4CXYrfVLoZKxVbVq0RUkZDRsh5TxThuMCMmU=;
        b=w5/XBckM4+ba5vNzH+yHa8zCGg7WiFigFJjBE/MGrmoFMfKmC5YWEnRGxRTbY+l7WT
         CROggtot5louD754m1KGFKCqA5ImKOAJVsUZoOlfGydgK/KSbE/OZj7dLMfwT3DORGik
         BjMhOY1dL5huhpkkODICs1A1tdl40V8IzTKj2pUCMJFmrEpYl5RKd6l9kki5+0j7G6F6
         rOsIyzoBuMJE/o6/lNedZpoHATnMw1h/MsirN74DVn7NKvkurp+TfIKcDxS132sXTI/G
         bVFVk8UOkJOsA5o4JrFi0pLtft97+2AyHoqwGbcIO1wMIBazxunHHkZ1n2qcy/1VUAKt
         AG8w==
X-Gm-Message-State: AFqh2kr1M2NRPOEow3n98/m/5HSzt0mt/I6jdJv0Rz6Yrtu5RwkulrmO
        fPrVO+gj2roh5lmSZGlbGVyqeAkV6VMIK7EVUxNo2g==
X-Google-Smtp-Source: AMrXdXtCAaK/W4YJAVUXbfQF5hrS5JdhIlhoJOGJiMzb4BqXysNXeH/yn46e2nop+FonHtZvP038uB/VnpPV8dv0VHI=
X-Received: by 2002:a81:6d85:0:b0:3f2:e8b7:a6ec with SMTP id
 i127-20020a816d85000000b003f2e8b7a6ecmr862462ywc.332.1673277670464; Mon, 09
 Jan 2023 07:21:10 -0800 (PST)
MIME-Version: 1.0
References: <20230108025545.338-1-cuiyunhui@bytedance.com> <CANn89i+W__5-jDUdM=_97jzQy9Wq+n9KBEuOGjUi=Fxe_ntqbg@mail.gmail.com>
 <CAEEQ3wnoKqN+uTmMmUDJ9pp+YVaLmKnv42RApzPbNOGg6CRmnA@mail.gmail.com>
 <CANn89iKY5gOC97NobXkhYv6d9ik=ks5ZEwVe=6H-VTwux=BwGQ@mail.gmail.com> <20230109100833.03f4d4b1@gandalf.local.home>
In-Reply-To: <20230109100833.03f4d4b1@gandalf.local.home>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 Jan 2023 16:20:58 +0100
Message-ID: <CANn89iJwBkCsuNH9vih30xy_Ur6+0dtbfs8wmsA4s7r8=J3cBw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v4] sock: add tracepoint for send recv length
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     =?UTF-8?B?6L+Q6L6J5bSU?= <cuiyunhui@bytedance.com>,
        mhiramat@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, kuniyu@amazon.com, xiyou.wangcong@gmail.com,
        duanxiongchun@bytedance.com, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 9, 2023 at 4:08 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 9 Jan 2023 15:54:38 +0100
> Eric Dumazet <edumazet@google.com> wrote:
>
> > > static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *msg)
> > > {
> > >         int ret = INDIRECT_CALL_INET(sock->ops->sendmsg, inet6_sendmsg,
> > >                                      inet_sendmsg, sock, msg,
> > >                                      msg_data_left(msg));
> > >         BUG_ON(ret == -EIOCBQUEUED);
> > >
> > >         if (trace_sock_send_length_enabled()) {
> >
> > A barrier() is needed here, with the current state of affairs.
> >
> > IMO, ftrace/x86 experts should take care of this generic issue ?
>
> trace_*_enabled() is a static_branch() (aka. jump label).
>
> It's a nop, where the if block is in the out-of-line code and skipped. When
> the tracepoint is enabled, it gets turned into a jump to the if block
> (which returns back to this location).
>

This is not a nop, as shown in the generated assembly, I copied in
this thread earlier.

Compiler does all sorts of things before the point the static branch
is looked at.

Let's add the extract again with <<*>> tags on added instructions/dereferences.


sock_recvmsg_nosec:
        pushq   %r12    #
        movl    %edx, %r12d     # tmp123, flags
        pushq   %rbp    #
# net/socket.c:999:     int ret =
INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
        movl    %r12d, %ecx     # flags,
# net/socket.c:998: {
        movq    %rdi, %rbp      # tmp121, sock
        pushq   %rbx    #
# net/socket.c:999:     int ret =
INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
        movq    32(%rdi), %rax  # sock_19(D)->ops, sock_19(D)->ops
# ./include/linux/uio.h:270:    return i->count;
        movq    32(%rsi), %rdx  # MEM[(const struct iov_iter
*)msg_20(D) + 16B].count, pretmp_48
# net/socket.c:999:     int ret =
INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
        movq    144(%rax), %rax # _1->recvmsg, _2
        cmpq    $inet6_recvmsg, %rax    #, _2
        jne     .L107   #,
        call    inet6_recvmsg   #
 <<*>>       movl    %eax, %ebx      # tmp124, <retval>
.L108:
# net/socket.c:1003:    trace_sock_recv_length(sock->sk, sock->sk->sk_family,
  <<*>>      xorl    %r8d, %r8d      # tmp127
   <<*>>     testl   %ebx, %ebx      # <retval>
# net/socket.c:1004:                           sock->sk->sk_protocol,
 <<*>>       movq    24(%rbp), %rsi  # sock_19(D)->sk, _10
# net/socket.c:1003:    trace_sock_recv_length(sock->sk, sock->sk->sk_family,
 <<*>>       cmovle  %ebx, %r8d      # <retval>,, tmp119
  <<*>>      testb   $2, %r12b       #, flags
# net/socket.c:1004:                           sock->sk->sk_protocol,
  <<*>>      movzwl  516(%rsi), %ecx # _10->sk_protocol,
# net/socket.c:1003:    trace_sock_recv_length(sock->sk, sock->sk->sk_family,
  <<*>>      movzwl  16(%rsi), %edx  # _10->__sk_common.skc_family,
# net/socket.c:1003:    trace_sock_recv_length(sock->sk, sock->sk->sk_family,
  <<*>>      cmove   %ebx, %r8d      # tmp119,, <retval>, iftmp.54_16
# ./arch/x86/include/asm/jump_label.h:27:       asm_volatile_goto("1:"
#APP
# 27 "./arch/x86/include/asm/jump_label.h" 1
        1:jmp .L111 # objtool NOPs this         #
        .pushsection __jump_table,  "aw"
         .balign 8
        .long 1b - .
        .long .L111 - .         #
         .quad __tracepoint_sock_recv_length+8 + 2 - .  #,
        .popsection

# 0 "" 2
#NO_APP
.L106:
# net/socket.c:1008: }
 <<*>>       movl    %ebx, %eax      # <retval>,
        popq    %rbx    #
        popq    %rbp    #
        popq    %r12    #
        ret
.L111:
# ./include/trace/events/sock.h:308: DEFINE_EVENT(sock_msg_length,
sock_recv_length,

> That is, when the tracepoint in the block gets enabled so does the above
> branch. Sure, there could be a race between the two being enabled, but I
> don't see any issue if there is. But the process to modify the jump labels,
> does a bunch of synchronization between the CPUs.
>
> What barrier are you expecting?

Something preventing the compiler being 'smart', forcing expression evaluations
before TP_fast_assign() is eventually called.



>
> -- Steve
>
> >
> >
> >
> > >                 call_trace_sock_send_length(sock->sk, sock->sk->sk_family,
> > >                                             sock->sk->sk_protocol, ret, 0);
> > >         }
> > >         return ret;
> > > }
> > >
> > > What do you think?
