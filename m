Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E394E6C51
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 03:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357650AbiCYCF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 22:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237272AbiCYCF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 22:05:28 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15AD6D1B9;
        Thu, 24 Mar 2022 19:03:55 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id k6so6612109plg.12;
        Thu, 24 Mar 2022 19:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e8oRVZ23KjzG/ypngzxPfcRE3bvQPKD6JKIf9Qg0x6w=;
        b=NLa+LKKCEYhiDLBTumzp8eZ2+tl8XDRYFgi2MPSiH9gd75ab5/pWG/yxu4T55oKqy6
         /a4BLs4P0yXKPJBCZKf5yIMwJnr76H8hnEYYDD4EwqY3RZNwgIdb14BqJYkBsh6cYAXg
         pZ93xFc63IwBiDpYXIY5EMuzCDCb3f81o5RKFYH0fVrqpc8z4cfGHtcEio4i6Bidx+gf
         BI2QkGwd8h9zDoYb0+JL00ctWrimYIou0Wt7Gh3K/M/oXp7VneF0XqCanJsFi4rfSzza
         oD5uOLcDZemYA+CBf7dCg1h7/R1euOE7B6SiM0EI4FhXMzF5qV5PUTHuqcLck5tRPCmF
         xTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e8oRVZ23KjzG/ypngzxPfcRE3bvQPKD6JKIf9Qg0x6w=;
        b=wulo8WGYHrQpOL03DI1XUk5EZRMSMG4WBhyAcjQeZsEv3Aon5tfm4BzrTWClfUrNFz
         3lSU1L9uRrCTPeENvjeYsuAm+qi5T8PFvKhp4kS20h7FnRMQ7RC9sj4BnOwLw27SOBZe
         cPM+JvwQ/aBSE2Eyzu2eMLaEfnD6WRPHi4c1XkFHFN3aq2t+l/0oVWXlQob2Ey07wOLp
         w65Jntg2he7y4H7iGvubD93dOc31/BmetTjhWkGzyLUmHdYb1gywX6BirPQizV340Ylf
         2bkJ/C8qWbTOKi45Ayp29HlBVKwOYQN0Vi9F2yvExiK9Zg+xyxc2qXAaqtXCIDAOKlWa
         DRnQ==
X-Gm-Message-State: AOAM533RW71oi4eigTGFLzLrzMy0Sm9JQENXlCjc5TMA37BwlGTJUcFw
        QiJcIukOlgEWFuZK6IJQmfZ1aGx9r6EuYpMQTeg=
X-Google-Smtp-Source: ABdhPJwq8DpvjN2e8Pf+oXugqYDzTIP7B8v8DwphjndqLIDOp3YhE2LtujNv5gkKDEZy8S2luZWi2fJs8MXjEDGili0=
X-Received: by 2002:a17:90b:4b45:b0:1c7:cc71:fdf7 with SMTP id
 mi5-20020a17090b4b4500b001c7cc71fdf7mr5156663pjb.33.1648173835008; Thu, 24
 Mar 2022 19:03:55 -0700 (PDT)
MIME-Version: 1.0
References: <164800288611.1716332.7053663723617614668.stgit@devnote2>
 <164800289923.1716332.9772144337267953560.stgit@devnote2> <YjrUxmABaohh1I8W@hirez.programming.kicks-ass.net>
 <20220323204119.1feac1af0a1d58b8e63acd5d@kernel.org>
In-Reply-To: <20220323204119.1feac1af0a1d58b8e63acd5d@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 24 Mar 2022 19:03:43 -0700
Message-ID: <CAADnVQLfu+uDUmovM8sOJSnH=HGxMEtmjk4+nWsAR+Mdj2TTYg@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 1/1] rethook: x86: Add rethook x86 implementation
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 4:41 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> On Wed, 23 Mar 2022 09:05:26 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
>
> > On Wed, Mar 23, 2022 at 11:34:59AM +0900, Masami Hiramatsu wrote:
> > > Add rethook for x86 implementation. Most of the code has been copied from
> > > kretprobes on x86.
> >
> > Right; as said, I'm really unhappy with growing a carbon copy of this
> > stuff instead of sharing. Can we *please* keep it a single instance?
>
> OK, then let me update the kprobe side too.
>
> > Them being basically indentical, it should be trivial to have
> > CONFIG_KPROBE_ON_RETHOOK (or somesuch) and just share this.
>
> Yes, ideally it should use CONFIG_HAVE_RETHOOK since the rethook arch port
> must be a copy of the kretprobe implementation. But for safety, I think
> having CONFIG_KPROBE_ON_RETHOOK is a good idea until replacing all kretprobe
> implementations.

Masami,

you're respinning this patch to combine
arch_rethook_trampoline and __kretprobe_trampoline
right?
