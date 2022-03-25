Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F87A4E6C99
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 03:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346237AbiCYCmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 22:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbiCYCmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 22:42:45 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC69186E35;
        Thu, 24 Mar 2022 19:41:12 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id jx9so6333671pjb.5;
        Thu, 24 Mar 2022 19:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YhbHvKOe3R9wr4WqHvvvMBja08hCbQeffvIT8N9J4tY=;
        b=lSD69GpG3fScXZeIiFhxLUpG7zr6II06PDD3LiZ/yFNZpViixqk1oVGH+ZIv9YsmFF
         JuD0HVFNEkKEKGmFjXBEHItS29+7VHjlEpcZHBbR35jvTZFNQ9q+ohKHhbAAU4hOZs1u
         esCibAlKYdQDmXnnGixMs07Ow6L8iVgfqAzon9mdbzl11CpCR8deFFfotcFePhlTELFY
         M97urpuWR79ToiJ4Ni6RaX1ezlCJp5vhp4aowfkBgT3tvDFAdCskFtxT72gGy9+WTi/Q
         Zslw1aCnM9yovxGWFx3pEr23MOknGo8M7r4pHYgiR9RGy+ALNpYQXL+sX1A9KCZlDMRN
         Xvnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YhbHvKOe3R9wr4WqHvvvMBja08hCbQeffvIT8N9J4tY=;
        b=TZ+JuPG/17QaPc0MiWt91R4apW4ijXneVC1tSfLa6AhzT3lDI/rLA5V2M3dvUBH/V1
         WTs5jhyNEB/lbNYkSHA98PUvYE+/ss7ZYt7R5PO/sRkZ2asv3Grqav3qta8Tr/CAuouf
         UJYYs+223F6xl0tld8KETVYq+UDoRHBziDOkpq/8qIvOIvO5Od80AgUei/hXhYx11or+
         ArwVBgOQQ4OuU+DIVV3jIgJkKz32a2MHD16/gBuBPSl4t9V+WgboDjCjZUV5KBCqg0j5
         jGrNh49YOWyqIy5ZTTWX1NVuZdePVJaR96J2rkGqZC3BhaTgNlY1LXLLthQcD+azHuwE
         eSMg==
X-Gm-Message-State: AOAM533G39ZFTAsN/nZoFV68jumivdQSG3oM56mf5wgYT/HoceY2yJd5
        ZaJ4wRmBr7v3lo61NH3W4VEswJlGLaRko1romUA=
X-Google-Smtp-Source: ABdhPJz6WZrBEX0skuDL82D0kkGisFThl7BLfGbFbH6DvyzjO9DwCGSj4rIRO8W4F4hWkqTxSnDM8yhN8EcCWa7+bJ0=
X-Received: by 2002:a17:90b:1a81:b0:1bc:c3e5:27b2 with SMTP id
 ng1-20020a17090b1a8100b001bcc3e527b2mr21991347pjb.20.1648176072202; Thu, 24
 Mar 2022 19:41:12 -0700 (PDT)
MIME-Version: 1.0
References: <164800288611.1716332.7053663723617614668.stgit@devnote2>
 <164800289923.1716332.9772144337267953560.stgit@devnote2> <YjrUxmABaohh1I8W@hirez.programming.kicks-ass.net>
 <20220323204119.1feac1af0a1d58b8e63acd5d@kernel.org> <CAADnVQLfu+uDUmovM8sOJSnH=HGxMEtmjk4+nWsAR+Mdj2TTYg@mail.gmail.com>
 <20220325112114.4604291a58ee5b214ee334da@kernel.org>
In-Reply-To: <20220325112114.4604291a58ee5b214ee334da@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 24 Mar 2022 19:41:01 -0700
Message-ID: <CAADnVQ+uFiFJKPcsPuLW2CU+VfoSLM4fL1KzJWC2ZXEMt7jHAQ@mail.gmail.com>
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

On Thu, Mar 24, 2022 at 7:21 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> On Thu, 24 Mar 2022 19:03:43 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
> > On Wed, Mar 23, 2022 at 4:41 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > >
> > > On Wed, 23 Mar 2022 09:05:26 +0100
> > > Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > > On Wed, Mar 23, 2022 at 11:34:59AM +0900, Masami Hiramatsu wrote:
> > > > > Add rethook for x86 implementation. Most of the code has been copied from
> > > > > kretprobes on x86.
> > > >
> > > > Right; as said, I'm really unhappy with growing a carbon copy of this
> > > > stuff instead of sharing. Can we *please* keep it a single instance?
> > >
> > > OK, then let me update the kprobe side too.
> > >
> > > > Them being basically indentical, it should be trivial to have
> > > > CONFIG_KPROBE_ON_RETHOOK (or somesuch) and just share this.
> > >
> > > Yes, ideally it should use CONFIG_HAVE_RETHOOK since the rethook arch port
> > > must be a copy of the kretprobe implementation. But for safety, I think
> > > having CONFIG_KPROBE_ON_RETHOOK is a good idea until replacing all kretprobe
> > > implementations.
> >
> > Masami,
> >
> > you're respinning this patch to combine
> > arch_rethook_trampoline and __kretprobe_trampoline
> > right?
>
> Yes, let me send the first patch set (for x86 at first).

great

> BTW, can you review these 2 patches? These are only for the fprobes,
> so it can be picked to bpf-next.
>
> https://lore.kernel.org/all/164802091567.1732982.1242854551611267542.stgit@devnote2/T/#u

Yes. They look good. Will push them soon.
