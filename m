Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3E7571185
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 06:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbiGLEkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 00:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiGLEks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 00:40:48 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461578CCA4;
        Mon, 11 Jul 2022 21:40:47 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id l23so12242403ejr.5;
        Mon, 11 Jul 2022 21:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9bwM//cvZFymb4WUWDusQzRbwBn9nlsjCD79TISVsJ0=;
        b=BlHWfQPRFKfJ61g8T/P6TuGTmb0P9ffpqao3TOROw798XwkY9vxuZfu0lO+CKXaQiG
         d6+RYqD2XsbD4tuL0uSsjRjGTsOVyb8nctHQiTWhwqUBX423OELfHfILQR636DVDHBKI
         FnLOAeWO5pIZNRHRThYFWUrrbPXMzoxkPIKKo1eHYfV+tgBTTwSEDPyVtCRUmO/q+Yh2
         ae8PBjZEYvVwZ9GfqiKXfkkLvW4cNtsfm2kpb8tZvLXouY+zrZJKd7VQCSjs3BC36kQi
         atzjqc5CJBJpoiiK0II/s1WhGlID11Na/5QluR1+87qFM+BE/6cwmlpFJrQ9yaAvvRJe
         QYrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9bwM//cvZFymb4WUWDusQzRbwBn9nlsjCD79TISVsJ0=;
        b=FS+mVrsLRenNII9J1xawOjOY0sz5n8D1AWxmjfA79T/g3eqjLtTWSgHuIvXS+RERJI
         3Iwu4c3uitc/ACPLFtEAknnCVn0b5PnSFRKifYN4MP35SMaXRHk+iCmd/FQRvSo/iain
         i+BgezRWJKA2A++xpL7VtJ5C1kXz1j6hiAbyphDJUq072O3iE+EJ16Oe7oKkBReKdtqC
         jzButVbmlIuGBWDtXNqAgXffoZzJ0OTysNyf8S+d89RvokdwY054uBM6OUxWnCNrK8QA
         FGEIGej3+1ZO2gx9nMtVTGD01h5oEPgEIA637ichoWcMhJWFYGuE9U36IemCKLdlWaip
         rawg==
X-Gm-Message-State: AJIora8CM1Kb0DATrvnOCO+qQPFDGNG2toLLyy4zt53bE++o9/QKtcb5
        T5yR4PNvGPOSqaTNOrFM0eYtWZ8zfsL147Wtw80=
X-Google-Smtp-Source: AGRyM1tPTIVzj650H/XE+ZZ8SPlMtwf7jTnRkEAvIGcGsDc4hAd7svZcAbESE0UtOfkT6dlwP4W6Oncm4IQIYJ2P9bw=
X-Received: by 2002:a17:906:5a6c:b0:72b:561a:3458 with SMTP id
 my44-20020a1709065a6c00b0072b561a3458mr8361763ejc.114.1657600845829; Mon, 11
 Jul 2022 21:40:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220706172814.169274-1-james.hilliard1@gmail.com>
 <a0bddf0b-e8c4-46ce-b7c6-a22809af1677@fb.com> <CADvTj4ovwExtM-bWUpJELy-OqsT=J9stmqbAXto8ds2n+G8mfw@mail.gmail.com>
In-Reply-To: <CADvTj4ovwExtM-bWUpJELy-OqsT=J9stmqbAXto8ds2n+G8mfw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Jul 2022 21:40:34 -0700
Message-ID: <CAEf4BzYwRyXG1zE5BK1ZXmxLh+ZPU0=yQhNhpqr0JmfNA30tdQ@mail.gmail.com>
Subject: Re: [PATCH v2] bpf/scripts: Generate GCC compatible helpers
To:     James Hilliard <james.hilliard1@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev
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

CC Quentin as well

On Mon, Jul 11, 2022 at 5:11 PM James Hilliard
<james.hilliard1@gmail.com> wrote:
>
> On Mon, Jul 11, 2022 at 5:36 PM Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > On 7/6/22 10:28 AM, James Hilliard wrote:
> > > The current bpf_helper_defs.h helpers are llvm specific and don't work
> > > correctly with gcc.
> > >
> > > GCC appears to required kernel helper funcs to have the following
> > > attribute set: __attribute__((kernel_helper(NUM)))
> > >
> > > Generate gcc compatible headers based on the format in bpf-helpers.h.
> > >
> > > This adds conditional blocks for GCC while leaving clang codepaths
> > > unchanged, for example:
> > >       #if __GNUC__ && !__clang__
> > >       void *bpf_map_lookup_elem(void *map, const void *key) __attribute__((kernel_helper(1)));
> > >       #else
> > >       static void *(*bpf_map_lookup_elem)(void *map, const void *key) = (void *) 1;
> > >       #endif
> >
> > It does look like that gcc kernel_helper attribute is better than
> > '(void *) 1' style. The original clang uses '(void *) 1' style is
> > just for simplicity.
>
> Isn't the original style going to be needed for backwards compatibility with
> older clang versions for a while?

I'm curious, is there any added benefit to having this special
kernel_helper attribute vs what we did in Clang for a long time? Did
GCC do it just to be different and require workarounds like this or
there was some technical benefit to this?

This duplication of definitions with #if for each one looks really
awful, IMO. I'd rather have a macro invocation like below (or
something along those lines) for each helper:

BPF_HELPER_DEF(2, void *, bpf_map_update_elem, void *map, const void
*key, const void *value, __u64 flags);

And then define BPF_HELPER_DEF() once based on whether it's Clang or GCC.

>
> >
> > Do you mind to help implement similar attribute in clang so we
> > don't need "#if" here?
>
> That's well outside my area of expertise unfortunately.
>
> >
> > >
> > >       #if __GNUC__ && !__clang__
> > >       long bpf_map_update_elem(void *map, const void *key, const void *value, __u64 flags) __attribute__((kernel_helper(2)));
> > >       #else
> > >       static long (*bpf_map_update_elem)(void *map, const void *key, const void *value, __u64 flags) = (void *) 2;
> > >       #endif
> > >
> > > See:
> > > https://github.com/gcc-mirror/gcc/blob/releases/gcc-12.1.0/gcc/config/bpf/bpf-helpers.h#L24-L27
> > >
> > > This fixes the following build error:
> > > error: indirect call in function, which are not supported by eBPF
> > >
> > > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> > > ---
> > > Changes v1 -> v2:
> > >    - more details in commit log
> > > ---
> > >   scripts/bpf_doc.py | 43 ++++++++++++++++++++++++++-----------------
> > >   1 file changed, 26 insertions(+), 17 deletions(-)
> > >
> > [...]
