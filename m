Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E140832C3F5
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354568AbhCDAJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357186AbhCCIUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 03:20:07 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1137FC0617A7;
        Wed,  3 Mar 2021 00:19:26 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id d11so22628925wrj.7;
        Wed, 03 Mar 2021 00:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RxKeaJE+nu2TyOO2eKwM9sn1ONl4+NYDV2sw0WpA958=;
        b=VRh7bHU7s5bPuJy9yo8sEiqZiA2nhS0iLkcG3DCQAA5MLKMnTficy1VU58xqt0ENp+
         Q62ToJg8ZIyPsRIAyP1ScrMXcQS31Ohl6s+r8h06xO4sajS1taVF+B6pulNMT0vbMN+V
         XuGdRWm0rNc3hubJAJpRnsvTFF2DgmFNgopZoHYjaXrmhG2BZiYES6k9/nf5uPzXqR/K
         59f3M3/kcf+xE2sMgJxAQqyDgVUBqidfQXRBftg3L8XaWB4a4ELTml5khhbmv0Iadpms
         tBt0RLxBrv9kJFgV8xJD2COxU93LvBWiwfz0+H8QLCC5shUbrjFHiemOnrkhsk99vRen
         ZvKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RxKeaJE+nu2TyOO2eKwM9sn1ONl4+NYDV2sw0WpA958=;
        b=rd6Xhlzp/fUiGFppCijRXw41C8UHf41/vFTZkcHlAgA1IhzCVK4ABDDRZacxMaRn6F
         e7DsF04Vx6cPmDHgvpB7z49bhy8ve810eTDE0DqRuDJNGkV+qJNghLJAAJ8uDfbs/J2T
         JpL2smEygIV6TekWd+9uKoPCp18nOsMNb87pi1a+nbpiVnZH472DNRP6Qi5/JZGk1OLG
         fRurbMTOudb1o9V87pkINs25qYZm1SX+G8Hr6l4mfysEGJ+avtPnU1G0E5zbJwqNejD3
         AU50xpFRrycm45Z667TNcRjwlg65J8CwcQqRoTVknvAktIbweebATYVdg/AxW0Ze3Goh
         SHUA==
X-Gm-Message-State: AOAM530DR0S8tQsSHl6Px6lsIjysIjjK0yQE+4+PdSRvRN8hpPD9/RDz
        gBTHCewsV1dPpeqXuIHCx5bq3OI6wmwmAJ4mWJZ4JSJLpZsMJA==
X-Google-Smtp-Source: ABdhPJySNiJOw35YC7QlRp1YSeG2rHrV1dxubFt9W0DlXcxJzzbaks61psVBOI7lW2kQyaqn6P74IyPcaxul+sduuPs=
X-Received: by 2002:a5d:4ac6:: with SMTP id y6mr23211765wrs.160.1614759564854;
 Wed, 03 Mar 2021 00:19:24 -0800 (PST)
MIME-Version: 1.0
References: <20210301104318.263262-1-bjorn.topel@gmail.com>
 <20210301104318.263262-3-bjorn.topel@gmail.com> <CAEf4BzZFDAcnaWU2JGL2GKmTTWQPDrcdgEn2NOM9cGFe16XheQ@mail.gmail.com>
 <a65075f7-b46c-9131-f969-a6458e6001b7@intel.com>
In-Reply-To: <a65075f7-b46c-9131-f969-a6458e6001b7@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 3 Mar 2021 09:19:13 +0100
Message-ID: <CAJ+HfNiA7Pm8A_uwZxaUhRf4YMhq_pBExNcebpEwR4t7E12ANg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] libbpf, xsk: add libbpf_smp_store_release libbpf_smp_load_acquire
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, maximmi@nvidia.com,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Mar 2021 at 08:14, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> =
wrote:
>
> On 2021-03-03 05:38, Andrii Nakryiko wrote:
> > On Mon, Mar 1, 2021 at 2:43 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail=
.com> wrote:
> >>
> >> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >>
> >> Now that the AF_XDP rings have load-acquire/store-release semantics,
> >> move libbpf to that as well.
> >>
> >> The library-internal libbpf_smp_{load_acquire,store_release} are only
> >> valid for 32-bit words on ARM64.
> >>
> >> Also, remove the barriers that are no longer in use.
> >>
> >> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >> ---
> >>   tools/lib/bpf/libbpf_util.h | 72 +++++++++++++++++++++++++----------=
--
> >>   tools/lib/bpf/xsk.h         | 17 +++------
> >>   2 files changed, 55 insertions(+), 34 deletions(-)
> >>
> >> diff --git a/tools/lib/bpf/libbpf_util.h b/tools/lib/bpf/libbpf_util.h
> >> index 59c779c5790c..94a0d7bb6f3c 100644
> >> --- a/tools/lib/bpf/libbpf_util.h
> >> +++ b/tools/lib/bpf/libbpf_util.h
> >> @@ -5,6 +5,7 @@
> >>   #define __LIBBPF_LIBBPF_UTIL_H
> >>
> >>   #include <stdbool.h>
> >> +#include <linux/compiler.h>
> >>
> >>   #ifdef __cplusplus
> >>   extern "C" {
> >> @@ -15,29 +16,56 @@ extern "C" {
> >>    * application that uses libbpf.
> >>    */
> >>   #if defined(__i386__) || defined(__x86_64__)
> >> -# define libbpf_smp_rmb() asm volatile("" : : : "memory")
> >> -# define libbpf_smp_wmb() asm volatile("" : : : "memory")
> >> -# define libbpf_smp_mb() \
> >> -       asm volatile("lock; addl $0,-4(%%rsp)" : : : "memory", "cc")
> >> -/* Hinders stores to be observed before older loads. */
> >> -# define libbpf_smp_rwmb() asm volatile("" : : : "memory")
> >
> > So, technically, these four are part of libbpf's API, as libbpf_util.h
> > is actually installed on target hosts. Seems like xsk.h is the only
> > one that is using them, though.
> >
> > So the question is whether it's ok to remove them now?
> >
>
> I would say that. Ideally, the barriers shouldn't be visible at all,
> since they're only used as an implementation detail for the static
> inline functions.
>
>
> > And also, why wasn't this part of xsk.h in the first place?
> >
>
> I guess there was a "maybe it can be useful for more than the XDP socket
> parts of libbpf"-idea. I'll move them to xsk.h for the v2, which will
> make the migration easier.
>

Clarification! The reason for not having them in xsk.h, was that the
idea was that only the APIs allowed from the application should reside
there. IOW, libbpf_utils.h is only "implementation details". Again,
the static-inline function messes things up. Maybe moving to an
LTO-only world would be better, so we can get rid of the inlining all
together.

>
> Bj=C3=B6rn
>
>
> >> +# define libbpf_smp_store_release(p, v)                              =
          \
> >> +       do {                                                          =
  \
> >> +               asm volatile("" : : : "memory");                      =
  \
> >> +               WRITE_ONCE(*p, v);                                    =
  \
> >> +       } while (0)
> >> +# define libbpf_smp_load_acquire(p)                                  =
  \
> >> +       ({                                                            =
  \
> >> +               typeof(*p) ___p1 =3D READ_ONCE(*p);                   =
    \
> >> +               asm volatile("" : : : "memory");                      =
  \
> >> +               ___p1;                                                =
  \
> >> +       })
> >
> > [...]
> >
