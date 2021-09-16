Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D5440D1E8
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 05:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbhIPDGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 23:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbhIPDGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 23:06:05 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1718CC061574;
        Wed, 15 Sep 2021 20:04:46 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id c13-20020a17090a558d00b00198e6497a4fso6460126pji.4;
        Wed, 15 Sep 2021 20:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MJCDqLgFxyEe5DTpyLISiR8Fy82cK2SzhVk5c7Mnf80=;
        b=nVKLa1MOXE/k1Lte634to4bk7/chUbQco2uRRSY+SJ7MCJiMbyhnTymviK/7m2H7dy
         4VFH4PKJc4F4wzvAuXyf+iwisxWBWCwiPCVuI9164J6AwX/i1MViq/YXYmgkdSr7wV3i
         pjrvblbgnqd9Tl9S1mqeLF8h6D+aBe0TW7zTOu6kqkQCtsOy04VfxloZunxS6w667Mb/
         +OFRANYHoyOt6fI1rqT4u7PzPj6rtQjThkFdEUtNxmxWtsDJr4gkDAjqxzSqR/RPDvxu
         fvhM055Cx+WfKVtW4Kp5vKN8sbjC6I1drpJGGnoajNkeOb+2nOPb0EiPWRF0rJYPeVHh
         931Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MJCDqLgFxyEe5DTpyLISiR8Fy82cK2SzhVk5c7Mnf80=;
        b=HCMSz100HwbNfmFJw2XZllurm7aqnd48ZL0dXc57EQIMR5/UgvIPrjtGc4h9bXNZqo
         iclcDwgC/9aWc6poXA2GcCkJAe6r1AcooY32mg7ndx8e3zxrdbzbev4nsqzZfirkGM64
         ZqbEe3GR21g6ptgoDsa5lFmfcnknjpF/ErI/3ylB3HC2rmm4t5FQpNVqPRR9mDyNtoal
         Tq341N2m2S8FTNVRKSRrkO/Pp9+MtQX8/kkCUS0P2VoSHwuwJuRNsqeL5GI1dkYxV4Y/
         4mvhV02CCc4PUtucB06be9GFnKGbN5NOguii0ZDYyWfgGwf/ReKbMezb0WeAU094eycn
         VdfA==
X-Gm-Message-State: AOAM5338TcLpNOsJ8I3zhVmw8gwtStn9swUd4bZj43xdCsevJD107gg5
        737gIYlZ+LMdl5PDeLNal2P/UpAZdHHSPgkFcL6FMpntVUM=
X-Google-Smtp-Source: ABdhPJwRXXuo5SasRkE41tqB8l58BMSy148MmmPvkGg0PON7cJHU4F6xyY8b6MHd4VTwMd9wppQfcnJOY4nQKT96KdI=
X-Received: by 2002:a17:902:710e:b0:139:3bd:59b9 with SMTP id
 a14-20020a170902710e00b0013903bd59b9mr2553959pll.3.1631761485434; Wed, 15 Sep
 2021 20:04:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210915050943.679062-1-memxor@gmail.com> <20210915050943.679062-4-memxor@gmail.com>
 <20210915161835.xipxa324own7s6ya@ast-mbp.dhcp.thefacebook.com> <20210915180626.a367fkhp2gb23yfb@apollo.localdomain>
In-Reply-To: <20210915180626.a367fkhp2gb23yfb@apollo.localdomain>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 15 Sep 2021 20:04:34 -0700
Message-ID: <CAADnVQLVpQeejimgdgntYtqw+EN2df1=rcpfxyqygbaHhiddnA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 03/10] bpf: btf: Introduce helpers for dynamic
 BTF set registration
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 11:06 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Wed, Sep 15, 2021 at 09:48:35PM IST, Alexei Starovoitov wrote:
> > On Wed, Sep 15, 2021 at 10:39:36AM +0530, Kumar Kartikeya Dwivedi wrote=
:
> > > This adds helpers for registering btf_id_set from modules and the
> > > check_kfunc_call callback that can be used to look them up.
> > >
> > > With in kernel sets, the way this is supposed to work is, in kernel
> > > callback looks up within the in-kernel kfunc whitelist, and then defe=
rs
> > > to the dynamic BTF set lookup if it doesn't find the BTF id. If there=
 is
> > > no in-kernel BTF id set, this callback can be used directly.
> > >
> > > Also fix includes for btf.h and bpfptr.h so that they can included in
> > > isolation. This is in preparation for their usage in tcp_bbr, tcp_cub=
ic
> > > and tcp_dctcp modules in the next patch.
> > >
> > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > ---
> > >  include/linux/bpfptr.h |  1 +
> > >  include/linux/btf.h    | 32 ++++++++++++++++++++++++++
> > >  kernel/bpf/btf.c       | 51 ++++++++++++++++++++++++++++++++++++++++=
++
> > >  3 files changed, 84 insertions(+)
> > >
> > > diff --git a/include/linux/bpfptr.h b/include/linux/bpfptr.h
> > > index 546e27fc6d46..46e1757d06a3 100644
> > > --- a/include/linux/bpfptr.h
> > > +++ b/include/linux/bpfptr.h
> > > @@ -3,6 +3,7 @@
> > >  #ifndef _LINUX_BPFPTR_H
> > >  #define _LINUX_BPFPTR_H
> > >
> > > +#include <linux/mm.h>
> >
> > Could you explain what this is for?
> >
>
> When e.g. tcp_bbr.c includes btf.h and btf_ids.h without this, it leads t=
o this
> error.
>
>                  from net/ipv4/tcp_bbr.c:59:
> ./include/linux/bpfptr.h: In function =E2=80=98kvmemdup_bpfptr=E2=80=99:
> ./include/linux/bpfptr.h:67:19: error: implicit declaration of function =
=E2=80=98kvmalloc=E2=80=99;
>  did you mean =E2=80=98kmalloc=E2=80=99? [-Werror=3Dimplicit-function-dec=
laration]
>    67 |         void *p =3D kvmalloc(len, GFP_USER | __GFP_NOWARN);
>       |                   ^~~~~~~~
>       |                   kmalloc
> ./include/linux/bpfptr.h:67:19: warning: initialization of =E2=80=98void =
*=E2=80=99 from =E2=80=98int=E2=80=99
>         makes pointer from integer without a cast [-Wint-conversion]
> ./include/linux/bpfptr.h:72:17: error: implicit declaration of function =
=E2=80=98kvfree=E2=80=99;
>         did you mean =E2=80=98kfree=E2=80=99? [-Werror=3Dimplicit-functio=
n-declaration]
>    72 |                 kvfree(p);
>       |                 ^~~~~~
>       |                 kfree

Interesting.
It's because of kvmalloc in kvmemdup_bpfptr.
Which is used in ___bpf_copy_key.
Which is used in map_update_elem.
And afair all maps enforce key_size < KMALLOC_MAX_SIZE.
Not sure why kvmalloc was there.
If it was kmalloc instead then
#include <linux/slab.h>
in linux/sockptr.h that is included by linux/bpfptr.h
would have been enough.
A food for thought.
