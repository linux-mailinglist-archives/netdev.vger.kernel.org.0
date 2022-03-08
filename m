Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44F64D0D8D
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 02:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243478AbiCHBg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 20:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiCHBg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 20:36:26 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001F12DD4E;
        Mon,  7 Mar 2022 17:35:30 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id r2so2127852iod.9;
        Mon, 07 Mar 2022 17:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GTL3hRdSnZee6BzFesghhjKeBSLzF5i+4W5RqXw7Zkg=;
        b=p41SMB3+qRRalMx3T7yDG23jzpjVDwf5lrQvOphsFv+oK99smM7BJs/BbWrnhPXTSw
         A9c3di/T9o86/qQ7oz926EmZx85glqgKRgyVt89e1zlLPBvcCpw9glDJztXThWcW7Tbz
         2qjoARzp+lb6h5UkRUljQlq95WFKznrlJDoeOGfYFIUA84rv3poeOCBHGDEBSfrXsV3I
         uo3BtM61qV2AXr3pNsAPp7ESz03xoCHBrPCr4m+kc/Mz9nAOoLU5OaPz/WLeaunSj/+S
         NG/eimppi/mUKW1KMD59jzYmW1YNs0MrTKOlKM/xUoZGYFXDMcviSdIXlviCOuxhbona
         JiAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GTL3hRdSnZee6BzFesghhjKeBSLzF5i+4W5RqXw7Zkg=;
        b=vxsMcHZBjoabz2406kaUwob17uqMp5KY2/BxCWkr963KPzNMfvvqXyPod0oXfwJOIJ
         TEmPQqnWYA/UkpPWW5OI2XkqClCCpPU57czb4A5XeZmv1M7jm/CcfW/lTQ6+cI4ALSY2
         OQMGVVwU6eUEISMfzzwxx3yhRzfThhJPlSSyyKRtkExzvrRnNv26cGUdISHGV2xcFooz
         kKxsvgUbcQSBLztPeWqpvu97m1Bj2RYafevIl9BfQM/Z72pueaonwpgqM4Y4ZvpvjvHC
         Sx+SO3rqUCLJtOacTFgObWlWD5d8sP7TU6/w+NPYk8DC0/3ZTyIeO7m6ulxMNCx94doX
         p2vw==
X-Gm-Message-State: AOAM533ecvqWF7HhEUvBagQ+Qt/zxUctXDgtb3IrzDks6VSQGnrAka01
        wuPexEtOODiDgM0/StYNn1NFQqzjU/FNzPylju0=
X-Google-Smtp-Source: ABdhPJzq+YlKuLQhQaMaPjqbdqaIH6zntBvRF1setFxblrZzQ2IyiQAOhG2eyjhPthFV7ETmSlZHa/tstmVMVuphhjk=
X-Received: by 2002:a05:6602:1605:b0:644:d491:1bec with SMTP id
 x5-20020a056602160500b00644d4911becmr12539919iow.63.1646703330317; Mon, 07
 Mar 2022 17:35:30 -0800 (PST)
MIME-Version: 1.0
References: <20220227142551.2349805-1-james.hilliard1@gmail.com>
 <6af1530a-a4bf-dccf-947d-78ce235a4414@iogearbox.net> <CADvTj4pOE+WD1rmS4S6kazeJWtoRTi5Ng_gJXVUkZwC_xMCySA@mail.gmail.com>
In-Reply-To: <CADvTj4pOE+WD1rmS4S6kazeJWtoRTi5Ng_gJXVUkZwC_xMCySA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Mar 2022 17:35:19 -0800
Message-ID: <CAEf4BzbfqdvefVfqqipRY8crP_tj0uUFuAfBk70oz4Ag6RP4qw@mail.gmail.com>
Subject: Re: [PATCH 1/1] libbpf: ensure F_DUPFD_CLOEXEC is defined
To:     James Hilliard <james.hilliard1@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 5, 2022 at 1:54 AM James Hilliard <james.hilliard1@gmail.com> w=
rote:
>
> On Mon, Feb 28, 2022 at 8:00 AM Daniel Borkmann <daniel@iogearbox.net> wr=
ote:
> >
> > Hi James,
> >
> > On 2/27/22 3:25 PM, James Hilliard wrote:
> > > This definition seems to be missing from some older toolchains.
> > >
> > > Note that the fcntl.h in libbpf_internal.h is not a kernel header
> > > but rather a toolchain libc header.
> > >
> > > Fixes:
> > > libbpf_internal.h:521:18: error: 'F_DUPFD_CLOEXEC' undeclared (first =
use in this function); did you mean 'FD_CLOEXEC'?
> > >     fd =3D fcntl(fd, F_DUPFD_CLOEXEC, 3);
> > >                    ^~~~~~~~~~~~~~~
> > >                    FD_CLOEXEC
> > >
> > > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> >
> > Do you have some more info on your env (e.g. libc)? Looks like F_DUPFD_=
CLOEXEC
> > was added back in 2.6.24 kernel. When did libc add it?
> >
> > Should we instead just add an include for <linux/fcntl.h> to libbpf_int=
ernal.h
> > (given it defines F_DUPFD_CLOEXEC as well)?
>
> That seems to cause a conflict: error: redefinition of =E2=80=98struct fl=
ock=E2=80=99
>
>
> >
> > > ---
> > >   tools/lib/bpf/libbpf_internal.h | 4 ++++
> > >   1 file changed, 4 insertions(+)
> > >
> > > diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_i=
nternal.h
> > > index 4fda8bdf0a0d..d2a86b5a457a 100644
> > > --- a/tools/lib/bpf/libbpf_internal.h
> > > +++ b/tools/lib/bpf/libbpf_internal.h
> > > @@ -31,6 +31,10 @@
> > >   #define EM_BPF 247
> > >   #endif
> > >
> > > +#ifndef F_DUPFD_CLOEXEC
> > > +#define F_DUPFD_CLOEXEC 1030
> > > +#endif

Let's just do this then (assuming the value of F_DUPFD_CLOEXEC is
architecture-independent)

> > > +
> > >   #ifndef R_BPF_64_64
> > >   #define R_BPF_64_64 1
> > >   #endif
> > >
> >
> > Thanks,
> > Daniel
