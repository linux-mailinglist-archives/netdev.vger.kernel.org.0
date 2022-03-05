Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A0B4CE409
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 10:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiCEJzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 04:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiCEJzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 04:55:42 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB09357143;
        Sat,  5 Mar 2022 01:54:52 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id z8so6995414oix.3;
        Sat, 05 Mar 2022 01:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nLa4Cpd6Xd8qLrAmRhbVrWhN1Lu5pmble/aRSf36KTE=;
        b=CKhBgN8Od9ZbW7JxeJRyxUI27hWxrvhyWv3lj4zpjleUIxL/LxTr1VyHR9lgL6ia55
         9M/xIDy3uP6t4/jsmMpPMw/FFP+0XSEHGuLRV3XuHJ/4hU80umxifaHhljXdQx6+NSA7
         7cZTxxAyhjuiRnfvVrtztKtVyBg3PpQM8qDm1X0GwoN3pFZw41mHAtlwUOSD0qrADfRw
         lyf3lZrhabJz/g2bowqISwAd/Lp5WU05d47Ki160GMIgXeDdqE+8obsm0NRF3PiYvNc8
         OJ68zBTRFxa0ovXwR9yYCx2XOKhWY+vui5WUImVRpLUcqQV3oLCNiFh3/+mjz4rgov/u
         qnXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nLa4Cpd6Xd8qLrAmRhbVrWhN1Lu5pmble/aRSf36KTE=;
        b=m7laIspBloAXE4zkjlHtsk5g8x0r91/o4n2ajwUSmLDMndwxxNIi9gm3RBEJETYGk2
         lXV/mPIl541Se11x9O918mFe6TYMEz4qNxTd26hpWG7UPJJF9btE2JBlwQzvhJTRIYTM
         fv8AiDt0Uh0bekKrJ545MrbEVwZvlht3wDo5S5Rs9Ul13469PsAkSQPIhNoHEK7VI6z8
         vpZCtaLLt70xqyRkV598CVod2GL8uYuY7wZjgPYtXR6pcVNyeYsNhrGD5RcmlvkMR6xF
         htXX3iNLFJEYra3bmalXy5HDYSfAseqpdgVziOtdfiibBbQsLx1lBq+jzdMLEMpezQTu
         xjWQ==
X-Gm-Message-State: AOAM53252cayekWPeyJtFcoLXSgliMm3ozLv5952MMVW/k2ZRVF6IPJZ
        oSxxcMlqPnniv4gTWzVTTtU7iZ0+j3CsSR3jsSU=
X-Google-Smtp-Source: ABdhPJz/k5bl7+Soe/sBfdfKbokR4zRXDOyv5k9or4b352BUPOFezuz+RbitwqqD0s0gHVXWRa4FTawlxMhdtC9Gd0I=
X-Received: by 2002:a05:6808:bce:b0:2d9:a01a:487d with SMTP id
 o14-20020a0568080bce00b002d9a01a487dmr1833093oik.200.1646474092109; Sat, 05
 Mar 2022 01:54:52 -0800 (PST)
MIME-Version: 1.0
References: <20220227142551.2349805-1-james.hilliard1@gmail.com> <6af1530a-a4bf-dccf-947d-78ce235a4414@iogearbox.net>
In-Reply-To: <6af1530a-a4bf-dccf-947d-78ce235a4414@iogearbox.net>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Sat, 5 Mar 2022 02:54:41 -0700
Message-ID: <CADvTj4pOE+WD1rmS4S6kazeJWtoRTi5Ng_gJXVUkZwC_xMCySA@mail.gmail.com>
Subject: Re: [PATCH 1/1] libbpf: ensure F_DUPFD_CLOEXEC is defined
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 8:00 AM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> Hi James,
>
> On 2/27/22 3:25 PM, James Hilliard wrote:
> > This definition seems to be missing from some older toolchains.
> >
> > Note that the fcntl.h in libbpf_internal.h is not a kernel header
> > but rather a toolchain libc header.
> >
> > Fixes:
> > libbpf_internal.h:521:18: error: 'F_DUPFD_CLOEXEC' undeclared (first us=
e in this function); did you mean 'FD_CLOEXEC'?
> >     fd =3D fcntl(fd, F_DUPFD_CLOEXEC, 3);
> >                    ^~~~~~~~~~~~~~~
> >                    FD_CLOEXEC
> >
> > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
>
> Do you have some more info on your env (e.g. libc)? Looks like F_DUPFD_CL=
OEXEC
> was added back in 2.6.24 kernel. When did libc add it?
>
> Should we instead just add an include for <linux/fcntl.h> to libbpf_inter=
nal.h
> (given it defines F_DUPFD_CLOEXEC as well)?

That seems to cause a conflict: error: redefinition of =E2=80=98struct floc=
k=E2=80=99


>
> > ---
> >   tools/lib/bpf/libbpf_internal.h | 4 ++++
> >   1 file changed, 4 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_int=
ernal.h
> > index 4fda8bdf0a0d..d2a86b5a457a 100644
> > --- a/tools/lib/bpf/libbpf_internal.h
> > +++ b/tools/lib/bpf/libbpf_internal.h
> > @@ -31,6 +31,10 @@
> >   #define EM_BPF 247
> >   #endif
> >
> > +#ifndef F_DUPFD_CLOEXEC
> > +#define F_DUPFD_CLOEXEC 1030
> > +#endif
> > +
> >   #ifndef R_BPF_64_64
> >   #define R_BPF_64_64 1
> >   #endif
> >
>
> Thanks,
> Daniel
