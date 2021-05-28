Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91FD3948F3
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 00:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhE1WyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 18:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhE1WyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 18:54:23 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28EFC0613CE
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 15:52:47 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id lg14so7534481ejb.9
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 15:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hYw5L9uovAkFsfHnHeXQzSMU5L4IRTMjhY6/K5rzT9U=;
        b=yuNgeXWN+6xWyHkZN3hopiuhLwOwLkMW4jfx/Ke9qnP+4D2F8F70wSggXfODvDfJTi
         ILz10rk+8ClZi8HbQdGtQbcSvgtB1sGOONGOZStOBth62K6Hz5gg9CX1vrt+j4VA5tlX
         Ix+Nfa7RDnmnOhfUmMbJi+8cg+u3ye37cM6IYBcAIMHhRDDaEBkVCskOi0kOs7gnKSdI
         mXKdCDDvyo3dLsxWV8KBORTR/cOBJBOknrc9qVd3Bzm0TtTxq1bM5m5gMw8Uhs9lgJXG
         aX1MQzG+pMBsWwu0lszw5ECGLix/RDqMzdlR8Bx+v92dGBI1vhRO3aOIv5eom6bntiJ4
         /j8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hYw5L9uovAkFsfHnHeXQzSMU5L4IRTMjhY6/K5rzT9U=;
        b=A7V6yPYwdut7DlRnvocQ+RPHKuC/ttzn7vqSC14yHg1iN6IdTlq5HOQXX1QF2O822l
         I3yZqD3gowWJL2BWsgBhBsLaTFH/7TjFN/Uqo3z6ImccvI3m0Jc6tYcad5qNeUIYZV/K
         gwcIiKUvS4IjIpPriRlrqBYzc7a8VN3EYR4NIbR7YcdLEjc1LjZFJN0gqBeDhEJQoJAk
         w3QkbMTi6nIzf/GtXj/c3DoMRYWBqCaZXk39lcYl+5cOu3dpzZhTcuVpZoVJ4jUhhWE/
         4/emBZlV5yis+PlOpdvGFtX2eddoLXHFG9Lb1nSdeuN/jSM63JA9IcD1chHq+ei6cgi2
         7Z2w==
X-Gm-Message-State: AOAM531MuZFPBfNYXVQXlREw8yyNvBTay6OL4I2tmLokQYkXSGWmbU+3
        CzzCwwLd6c920WG8PJlUEPGyy5iVaRuVF4IbE26E
X-Google-Smtp-Source: ABdhPJyM59D/3ndTZ2tM5xKxQiqHabnQvuoHlfDxd+J5YttV0ukxr9SsE/gZ/BunSIgaPf5x9SH6g251CYE//WbdFbc=
X-Received: by 2002:a17:906:4111:: with SMTP id j17mr1665351ejk.488.1622242365987;
 Fri, 28 May 2021 15:52:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210517092006.803332-1-omosnace@redhat.com> <CAHC9VhTasra0tU=bKwVqAwLRYaC+hYakirRz0Mn5jbVMuDkwrA@mail.gmail.com>
 <01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net> <CAHC9VhR-kYmMA8gsqkiL5=poN9FoL-uCyx1YOLCoG2hRiUBYug@mail.gmail.com>
 <c7c2d7e1-e253-dce0-d35c-392192e4926e@iogearbox.net>
In-Reply-To: <c7c2d7e1-e253-dce0-d35c-392192e4926e@iogearbox.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 28 May 2021 18:52:34 -0400
Message-ID: <CAHC9VhRkz48MLv_QNfnRWFPvFxEV7oJH5eNHGUtvWdjG4M1YFA@mail.gmail.com>
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>, jolsa@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 2:28 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 5/28/21 5:47 PM, Paul Moore wrote:
> > Let's reset.
>
> Sure, yep, lets shortly take one step back. :)
>
> > What task_struct is running the BPF tracing program which is calling
> > into security_locked_down()?  My current feeling is that it is this
> > context/domain/cred that should be used for the access control check;
> > in the cases where it is a kernel thread, I think passing NULL is
> > reasonable, but I think the proper thing for SELinux is to interpret
> > NULL as kernel_t.
>
> If this was a typical LSM hook and, say, your app calls into bind(2) where
> we then invoke security_socket_bind() and check 'current' task, then I'm all
> with you, because this was _explicitly initiated_ by the httpd app, so that
> allow/deny policy belongs in the context of httpd.
>
> In the case of tracing, it's different. You install small programs that are
> triggered when certain events fire. Random example from bpftrace's README [0],
> you want to generate a histogram of syscall counts by program. One-liner is:
>
>    bpftrace -e 'tracepoint:raw_syscalls:sys_enter { @[comm] = count(); }'
>
> bpftrace then goes and generates a BPF prog from this internally. One way of
> doing it could be to call bpf_get_current_task() helper and then access
> current->comm via one of bpf_probe_read_kernel{,_str}() helpers. So the
> program itself has nothing to do with httpd or any other random app doing
> a syscall here. The BPF prog _explicitly initiated_ the lockdown check.
> The allow/deny policy belongs in the context of bpftrace: meaning, you want
> to grant bpftrace access to use these helpers, but other tracers on the
> systems like my_random_tracer not. While this works for prior mentioned
> cases of security_locked_down() with open_kcore() for /proc/kcore access
> or the module_sig_check(), it is broken for tracing as-is, and the patch
> I sent earlier fixes this.

Sigh.

Generally it's helpful when someone asks a question if you answer it
directly before going off and answering your own questions.  Listen, I
get it, you wrote a patch and it fixes your problem (you've mentioned
that already) and it's wonderful and all that, but the rest of us
(maybe just me) need to sort this out too and talking past questions
isn't a great way to help us get there (once again, maybe just me).  I
think I can infer an answer from you, but you've made me grumpy now so
I'm not ACK'ing or NACK'ing anything right now; I clearly need to go
spend some time reading through BPF code.  Woo.

>    [0] https://github.com/iovisor/bpftrace

-- 
paul moore
www.paul-moore.com
