Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2B024C728
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 23:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgHTVYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 17:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbgHTVYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 17:24:33 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC80AC061385;
        Thu, 20 Aug 2020 14:24:32 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id i10so3715936ljn.2;
        Thu, 20 Aug 2020 14:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T8K3hU+6RbHXPV23LYzDkjtWzAtVysJstQwvCAunJ+Q=;
        b=rYEn1j0Mk4x5/wQX26hTIguD+rQFPcNo9IeUmQWrsl06L5qtJFs6/I+sAqj5soSzFH
         A7ZEl2oLXmrRdCEZrnj6JGuWJUOJD0JHMsykUw7DTMgiLo/sZezqfDxjRixRmSJCS+Eg
         ywSlJX3I02oDfQYbmINrGrH8j/EowsDKiqmt69nrko2Bhkef7tGy/Vrzd91Rwca651HB
         vWbly7VnzE/Vu9KnwQaOvNcrgAk4j8Ee7wzJxfeD171mxu67cfqqQGXEPowO6Fy6iOkY
         luQgVFLpqdgb8eQw+CmseMx5b3sRAxafBkLxslilvJRTy6OT8gYJg8ixb8AM5g5jQQLo
         +ctA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T8K3hU+6RbHXPV23LYzDkjtWzAtVysJstQwvCAunJ+Q=;
        b=Uufc4UYPjK9EkNv1Hk/JLhYGhPAXkyMLa9HVPvcXiqbp/kRlST+S1V/DfSViaBGczk
         2rMWqJuLuv/01qJVUrQSbJZK4rGzSRPuFE6tWKtYM636TjTWcr51sCIiuDmbgflJ5tjK
         7lh3FI7oRxYWC443giyO3P9o7xE5uVeyR1mjQLjzFOx8pBm7dugWY9OGPhSuo7Cgae+Z
         njoGsgvDb5p06H2OenvHHDoWa5xN3qY3v2NWXUKwhaJiAjde6smQnobRorgLpyJKlGjt
         PeBcknL64AzD6ldenfhoaEoVN4BeLoqgvVy4eZEkSx5/QE4W2T88rBp463eWRGcs4CBI
         OjpA==
X-Gm-Message-State: AOAM530GUtHXYk8A4p7R9lrIwcbjbVtTiZCf1UozDpQCM1KIeRWABUsv
        cLK2qcig09B61Z/9UcjFwOxLqGM37jScoFouldY=
X-Google-Smtp-Source: ABdhPJwUKo/Ft+3ez1/sd5jf/Y7A6hHYC34rAF/yaLxy4ru+V0vfOZZS2acaZz9jF+Zua60Iasm/3n1jOCz+BVt4NLw=
X-Received: by 2002:a2e:8e28:: with SMTP id r8mr104036ljk.290.1597958670606;
 Thu, 20 Aug 2020 14:24:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200819092342.259004-1-jolsa@kernel.org> <254246ed-1b76-c435-a7bd-0783a29094d9@fb.com>
 <20200819173618.GH177896@krava> <CAKwvOdnfy4ASdeVqPjMtALXOXgMKdEB8U0UzWDPBKVqdhcPaFg@mail.gmail.com>
 <2e35cf9e-d815-5cd7-9106-7947e5b9fe3f@fb.com> <CAFP8O3+mqgQr_zVS9pMXSpFsCm0yp5y5Vgx1jmDc+wi-8-HOVQ@mail.gmail.com>
 <ba7bbec7-9fb5-5f8f-131e-1e0aeff843fa@fb.com> <5ef90a283aa2f68018763258999fa66cd34cb3bb.camel@klomp.org>
 <7029ff8f-77d3-584b-2e7e-388c001cd648@fb.com> <a6f1d7be73ca5d9f767a746927e7872ddcf18244.camel@klomp.org>
 <35b05eda-f76a-a071-d69e-9ba8c6f48382@fb.com>
In-Reply-To: <35b05eda-f76a-a071-d69e-9ba8c6f48382@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 20 Aug 2020 14:24:19 -0700
Message-ID: <CAADnVQ+C3OMe=5=j-zqcTNA=Yo1NtGRkzpwNzUrDfGsQnMagZQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: Fix sections with wrong alignment
To:     Yonghong Song <yhs@fb.com>
Cc:     Mark Wielaard <mark@klomp.org>,
        =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nick Clifton <nickc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 10:54 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/20/20 10:36 AM, Mark Wielaard wrote:
> > Hi
> >
> > On Thu, 2020-08-20 at 08:51 -0700, Yonghong Song wrote:
> >>>> Do you think we could skip these .debug_* sections somehow in elf
> >>>> parsing in resolve_btfids? resolve_btfids does not need to read
> >>>> these sections. This way, no need to change their alignment
> >>>> either.
> >>>
> >>> The issue is that elfutils libelf will not allow writing out the
> >>> section when it notices the sh_addralign field is setup wrongly.
> >>
> >> Maybe resolve_btfids can temporarily change sh_addralign to 4/8
> >> before elf manipulation (elf_write) to make libelf happy.
> >> After all elf_write is done, change back to whatever the
> >> original value (1). Does this work?
> >
> > Unfortunately no, because there is no elf_write, elf_update is how you
> > write out the ELF image to disc.
> >
> > Since the code is using ELF_F_LAYOUT this will not change the actual
> > layout of the ELF image if that is what you are worried about.
> >
> > And the workaround to set sh_addralign correctly before calling
> > elf_update is precisely what the fix in elfutils libelf will do itself
> > in the next release. Also binutils ld has been fixed to setup
> > sh_addralign to 4/8 as appropriate now (in git).
>
> Sounds good then.
> Thanks for fixing the issue in upstream, both libelf and binutils!

In the meantime I've applied Jiri's workaround to bpf tree. Thanks!
