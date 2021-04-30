Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA6236FBF6
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 16:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbhD3ORS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 10:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhD3ORR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 10:17:17 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E8AC06174A;
        Fri, 30 Apr 2021 07:16:28 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id u16so52821005oiu.7;
        Fri, 30 Apr 2021 07:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=08k08CgX5BilS2vJ05XkgnS9mG6yls8RajFj4RRSwsA=;
        b=Pa/JGrPwzoZCRcYp+/IQbD9dj9lzN1/KDddM9Xnlnf4Hdo+phrGcRuwNwemCNNuGWX
         GU5V/ZbZuMF1UXZwL1i39SPVOs1hZHZq6ztpvquBLtxZ+xRQm4AMvB5PQtPM7/S5QWRH
         uTb61LUautMhXWdSti7ze4l6OxTUBhhO+0jDbRm8OntcX9IqtpugyfSwmvFB+EMehuq4
         mh+UqsdbJ4a7D5Uy05gdJiwfWugCrCwulw79JWL1r2q3xuGKuiCDQ891ThSAFPiOhhdE
         Pd43IFFUPz+sr65o3P6yq8idu0GykSRsGJLxnjeDOalzn4A/6bF/UrP+PBVjBjYGWgqq
         BgqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=08k08CgX5BilS2vJ05XkgnS9mG6yls8RajFj4RRSwsA=;
        b=nW+dUPH1s2wCgUcONV40C3HObW9zPSe9sbWlNNZW+K8O/a57fHYba/ckGTR5pTM5aC
         JxRu1IZPc7IfZ+jYCFVuTdArND47VDxxQIXmN4/ofDugU8y8g03QybyollhnDfvRBGY0
         6jBZMweEaUYF+M03SZF1AaJxRN+uDDCmDB61/iZXWl3+mRZLWacSW9Le6f/II+XBcJaf
         k6G3NjingohKkMdq3wl8psHzpboIuH94pMq/g5cnHLlSIJGPV6M/AL5GKrk7wMpF/Q4Y
         Rtog8M31eQ1ukhbJBmuDjjNisjUtjfbV3FFtxkSYnAZM6yidZ6tYUEPGT/M7L1fZ6HqV
         QEGg==
X-Gm-Message-State: AOAM530bGq6UPDH/Jtlj1J4A59MEYKOkvAxKLtdhC5JQdW379q8d/49q
        +/Qt++RCxgZi/PJ5oZqSTmVmkadirKi8bhRnsk8=
X-Google-Smtp-Source: ABdhPJysf3rfT0lvmSPKZxe9m5qMvnS7sb1JrAke96J2ddA3fsBJGqkZ+b12G4l22op+CYATyulTUpYBz1gJJYtn3Fs=
X-Received: by 2002:aca:5c44:: with SMTP id q65mr4062960oib.12.1619792187587;
 Fri, 30 Apr 2021 07:16:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210424221648.809525-1-pctammela@mojatatu.com> <7c789fc1-de3d-5232-4d32-5bd3afbf26ea@iogearbox.net>
In-Reply-To: <7c789fc1-de3d-5232-4d32-5bd3afbf26ea@iogearbox.net>
From:   Pedro Tammela <pctammela@gmail.com>
Date:   Fri, 30 Apr 2021 11:16:16 -0300
Message-ID: <CAKY_9u2XfB81QEstxu-ALHfyZr1CWdfiFhJVMYB0ngvrhN6vDw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: handle ENOTSUPP errno in libbpf_strerror()
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em ter., 27 de abr. de 2021 =C3=A0s 13:18, Daniel Borkmann
<daniel@iogearbox.net> escreveu:
>
> On 4/25/21 12:16 AM, Pedro Tammela wrote:
> > The 'bpf()' syscall is leaking the ENOTSUPP errno that is internal to t=
he kernel[1].
> > More recent code is already using the correct EOPNOTSUPP, but changing
> > older return codes is not possible due to dependency concerns, so handl=
e ENOTSUPP
> > in libbpf_strerror().
> >
> > [1] https://lore.kernel.org/netdev/20200511165319.2251678-1-kuba@kernel=
.org/
> >
> > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > ---
> >   tools/lib/bpf/libbpf_errno.c | 9 +++++++++
> >   1 file changed, 9 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf_errno.c b/tools/lib/bpf/libbpf_errno.=
c
> > index 0afb51f7a919..7de8bbc34a37 100644
> > --- a/tools/lib/bpf/libbpf_errno.c
> > +++ b/tools/lib/bpf/libbpf_errno.c
> > @@ -13,6 +13,9 @@
> >
> >   #include "libbpf.h"
> >
> > +/* This errno is internal to the kernel but leaks in the bpf() syscall=
. */
> > +#define ENOTSUPP 524
> > +
> >   /* make sure libbpf doesn't use kernel-only integer typedefs */
> >   #pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
> >
> > @@ -43,6 +46,12 @@ int libbpf_strerror(int err, char *buf, size_t size)
> >
> >       err =3D err > 0 ? err : -err;
> >
> > +     if (err =3D=3D ENOTSUPP) {
> > +             snprintf(buf, size, "Operation not supported");
> > +             buf[size - 1] =3D '\0';
> > +             return 0;
> > +     }
> > +
> >       if (err < __LIBBPF_ERRNO__START) {
> >               int ret;
>
> Could you fold this into the __LIBBPF_ERRNO__START test body to denote th=
at it
> belongs outside the libbpf error range? For example, could be simplified =
like this:
>
>          if (err < __LIBBPF_ERRNO__START) {
>                  int ret;
>
>                  /* Handle ENOTSUPP separate here given it's kernel inter=
nal,
>                   * but for sake of error string it has the same meaning =
as
>                   * the EOPNOTSUPP error.
>                   */
>                  if (err =3D=3D ENOTSUPP)
>                          err =3D EOPNOTSUPP;
>                  ret =3D strerror_r(err, buf, size);
>                  buf[size - 1] =3D '\0';
>                  return ret;
>          }
>
> Thanks,
> Daniel

Sure, looks simpler indeed.

Pedro
