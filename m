Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFFBA223863
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 11:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgGQJaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 05:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgGQJaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 05:30:04 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F28CC061755;
        Fri, 17 Jul 2020 02:30:03 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f5so11817174ljj.10;
        Fri, 17 Jul 2020 02:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wHM2c/vZDxflG1f3XzwOEemirRBb3T704CxpASnP1GE=;
        b=ua67o6ky01fQISCxWjueZpubRrCnC94h3qUwuhF+JQaykGfgXFMdB8bvHTEoRWyT7T
         PJKSe0iIlYKIvAy1H56ZeIYOtTzD6ptNAFgBrKfqZzpHzYrIaKDjJmcuD7M4s0ULIrrv
         GpYZ09QZrHgcYRNfhDo65SGR7wH0XgoHKK7FzgpY8UuTMrGV+Z2nLo33Iq+3NQoPcEWg
         rZGAHjpbV6dcQFJkedtRusUSh9APzruE1NhxfGn0tt1WNQ8195BmeLXojUsAsD5R0VD7
         M7JgntYykdGsIpArDBiL5AoStpRxeW7c59vqFKxRWHdq6ikA3+TvsK5v60JB8N5lAsAS
         C7OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wHM2c/vZDxflG1f3XzwOEemirRBb3T704CxpASnP1GE=;
        b=mFdamXSh2U0CjDZ5nWjnB4xyZ+cOZMfMQblnWU2vSIwkpB1wkQqvxmhDv2oorAprKF
         UZRthp56epax3+j4vtgD+8GWVxrFq3M4HoFiDWvrgiKekSP6hQG0cC/91rxjSfIz+SxU
         Op6gOM0jpU3f7znF2scl4yy1hHEbmzmO8Qhzcl4e7TINOqzyH5a5gEMcA0CmMnHKMfST
         2qJe8Zxy4rc8FPwBHmGWSu4YnX7MOrS/KJcBg+oGYew3E0tof81pjpimvUJCR/iNWjR1
         IW9fOxTFUQQ88/KTePSsGxoVGVTH/U497JjYbqK9gvZCCqzTq/Yjuiov5ti+h0c5tjwT
         paGg==
X-Gm-Message-State: AOAM532AaGh570gKv45hm5djH1a+6m+oKvZSBooFAbLFdrYYmcvhfxg0
        LebecP5LqTZ6K9+Lup8eeuIXbkiMKutgfdcTbwI=
X-Google-Smtp-Source: ABdhPJxAYfl7LTmiaZ9O4UMiQ+Vvp5xtJS6XiD+zkjNMK2z4urIcJ+6j7uhZai3FANLXo3m33Qr9bNL9N/N0tKlF6do=
X-Received: by 2002:a2e:a0cd:: with SMTP id f13mr3810730ljm.343.1594978202137;
 Fri, 17 Jul 2020 02:30:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200715233634.3868-1-maciej.fijalkowski@intel.com>
 <20200715233634.3868-2-maciej.fijalkowski@intel.com> <d631a16d-2cf0-cf12-2ddc-82ac64e51f6e@iogearbox.net>
In-Reply-To: <d631a16d-2cf0-cf12-2ddc-82ac64e51f6e@iogearbox.net>
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Date:   Fri, 17 Jul 2020 11:29:51 +0200
Message-ID: <CAOuyyO4B3V-TzzJLneEqXcPZWhhpPSe7kiY1G5g6NDMDVGazTQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] bpf, x64: use %rcx instead of %rax for tail
 call retpolines
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 10:37 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 7/16/20 1:36 AM, Maciej Fijalkowski wrote:
> > Currently, %rax is used to store the jump target when BPF program is
> > emitting the retpoline instructions that are handling the indirect
> > tailcall.
> >
> > There is a plan to use %rax for different purpose, which is storing the
> > tail call counter. In order to preserve this value across the tailcalls,
> > use %rcx instead for jump target storage in retpoline instructions.
> >
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >   arch/x86/include/asm/nospec-branch.h | 16 ++++++++--------
> >   1 file changed, 8 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> > index e7752b4038ff..e491c3d9f227 100644
> > --- a/arch/x86/include/asm/nospec-branch.h
> > +++ b/arch/x86/include/asm/nospec-branch.h
> > @@ -314,19 +314,19 @@ static inline void mds_idle_clear_cpu_buffers(void)
> >    *    lfence
> >    *    jmp spec_trap
> >    *  do_rop:
> > - *    mov %rax,(%rsp) for x86_64
> > + *    mov %rcx,(%rsp) for x86_64
> >    *    mov %edx,(%esp) for x86_32
> >    *    retq
> >    *
> >    * Without retpolines configured:
> >    *
> > - *    jmp *%rax for x86_64
> > + *    jmp *%rcx for x86_64
> >    *    jmp *%edx for x86_32
> >    */
> >   #ifdef CONFIG_RETPOLINE
> >   # ifdef CONFIG_X86_64
> > -#  define RETPOLINE_RAX_BPF_JIT_SIZE 17
> > -#  define RETPOLINE_RAX_BPF_JIT()                            \
> > +#  define RETPOLINE_RCX_BPF_JIT_SIZE 17
> > +#  define RETPOLINE_RCX_BPF_JIT()                            \
> >   do {                                                                \
> >       EMIT1_off32(0xE8, 7);    /* callq do_rop */             \
> >       /* spec_trap: */                                        \
> > @@ -334,7 +334,7 @@ do {                                                              \
> >       EMIT3(0x0F, 0xAE, 0xE8); /* lfence */                   \
> >       EMIT2(0xEB, 0xF9);       /* jmp spec_trap */            \
> >       /* do_rop: */                                           \
> > -     EMIT4(0x48, 0x89, 0x04, 0x24); /* mov %rax,(%rsp) */    \
> > +     EMIT4(0x48, 0x89, 0x0C, 0x24); /* mov %rcx,(%rsp) */    \
> >       EMIT1(0xC3);             /* retq */                     \
> >   } while (0)
> >   # else /* !CONFIG_X86_64 */
> > @@ -352,9 +352,9 @@ do {                                                              \
> >   # endif
> >   #else /* !CONFIG_RETPOLINE */
> >   # ifdef CONFIG_X86_64
> > -#  define RETPOLINE_RAX_BPF_JIT_SIZE 2
> > -#  define RETPOLINE_RAX_BPF_JIT()                            \
> > -     EMIT2(0xFF, 0xE0);       /* jmp *%rax */
> > +#  define RETPOLINE_RCX_BPF_JIT_SIZE 2
> > +#  define RETPOLINE_RCX_BPF_JIT()                            \
> > +     EMIT2(0xFF, 0xE1);       /* jmp *%rcx */
>
> Hmm, so the target prog gets loaded into rax in emit_bpf_tail_call_indirect()
> but then you jump into rcx? What am I missing? This still needs to be bisectable.

Somehow your comments on patches 1, 2 and 3 didn't arrive to my work mail.
I'm responding from web-gmail as my client seems to be broken and I am
in a bit of hurry, so apologize for any inconveniences...

You are right of course, I will include the JIT change in this patch on v2.

>
> >   # else /* !CONFIG_X86_64 */
> >   #  define RETPOLINE_EDX_BPF_JIT()                           \
> >       EMIT2(0xFF, 0xE2)        /* jmp *%edx */
> >
>
