Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C7F1FFF8D
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 03:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbgFSBHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 21:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgFSBHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 21:07:02 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FBEC06174E;
        Thu, 18 Jun 2020 18:07:01 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id w1so7530857qkw.5;
        Thu, 18 Jun 2020 18:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zgOM3kHr14+Eq7Isv5Qcr6nrihrQ6H5Qw1+YMcW95BI=;
        b=Bh25y0VY9/hkodEDMEYHIH+Z5/4J7/wVYpbvYPw9l9q2drKSgEEaW62gK7uFeZT+rM
         /wuKRBxVD44zZzvE9J7JZqVCjh1EQ8TnfAPa0QtBqto/OvjraIsYRHzWap1RGujOBRBk
         EJHzZpjO2ZvPCQbB6Nl/+d1CYF+AKgsdFW/7kiqFPrpr9QYOwuCTVeWPv29IKE49VAJR
         ZaMuymWW1KfVeARlBrqspXPeY8Zn9UnuyMXdUmauvtBiV8vGrGxsRF5IK/AARZVx5CTm
         6BHcsuti1N6YY7SrY8hlOMibvJiVnr7HpWus2kQFzr9S02dHcGSjv84EFFSxR6xXV3HO
         mCmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zgOM3kHr14+Eq7Isv5Qcr6nrihrQ6H5Qw1+YMcW95BI=;
        b=lzySKHd/2mS9knjIeOPDLYsJFoCxmDf2vwO6+j96qi9zDauyne1E2jALNE+QVlSEOK
         OWr6N4hr38XiEb+DGjqKShqa9U34cwRPp9+5dRIVaoE5GeOviGOfIOrkIeUzeiTm1apt
         gB6O5Yv7qrJ4UaDC+YOrwZ0G7N6b1ajLFSm+9pMNHYAdKnaGDNqpak2hrVP7rkReP5+v
         KuN20x2FSK4IQz1miV1wcEcyeDRt/FQ8lzNopHZf/M2mYDivA5uKZd+VeZ6B1Efiarsr
         uFuM0IgqtA3JBjXUoTJG612kTycwut+PaxKNPziLVFXhIdM8cXnKhORqreIiFG5aPIXC
         6qXg==
X-Gm-Message-State: AOAM532PGsAGERH/yFEk4qvxLOaO/mQqrWT9k4VHTfiRKf0ByRFuAcif
        pkQjcH0YWg8/T906CRdbwRSyZztAfrFAqvycUdY1zH1O
X-Google-Smtp-Source: ABdhPJyhxyuKHQPp0xRK7W1dKHmW7+dvCzS28Os9euR42Y945ilhi5xrXG7mB8kKSNk0F3by5wB0oNXTeQb6NdpThzg=
X-Received: by 2002:a37:a89:: with SMTP id 131mr1242684qkk.92.1592528820899;
 Thu, 18 Jun 2020 18:07:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-4-jolsa@kernel.org>
 <CAEf4BzZ=BN7zDU_8xMEEoF7khjC4bwGitU+iYf+6uFXPZ_=u-g@mail.gmail.com>
In-Reply-To: <CAEf4BzZ=BN7zDU_8xMEEoF7khjC4bwGitU+iYf+6uFXPZ_=u-g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 18:06:49 -0700
Message-ID: <CAEf4BzZivgf2r+tAnY4+cMTKN3dCb_M-PyVWL_ZSa7SY=x2efA@mail.gmail.com>
Subject: Re: [PATCH 03/11] bpf: Add btf_ids object
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 5:56 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Jun 16, 2020 at 3:05 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding support to generate .BTF_ids section that would
> > hold various BTF IDs list for verifier.
> >
> > Adding macros help to define lists of BTF IDs placed in
> > .BTF_ids section. They are initially filled with zeros
> > (during compilation) and resolved later during the
> > linking phase by btfid tool.
> >
> > Following defines list of one BTF ID that is accessible
> > within kernel code as bpf_skb_output_btf_ids array.
> >
> >   extern int bpf_skb_output_btf_ids[];
> >
> >   BTF_ID_LIST(bpf_skb_output_btf_ids)
> >   BTF_ID(struct, sk_buff)
> >
> > Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/asm-generic/vmlinux.lds.h |  4 ++
> >  kernel/bpf/Makefile               |  2 +-
> >  kernel/bpf/btf_ids.c              |  3 ++
> >  kernel/bpf/btf_ids.h              | 70 +++++++++++++++++++++++++++++++
> >  4 files changed, 78 insertions(+), 1 deletion(-)
> >  create mode 100644 kernel/bpf/btf_ids.c
> >  create mode 100644 kernel/bpf/btf_ids.h
> >
>
> [...]
>
> > +/*
> > + * Following macros help to define lists of BTF IDs placed
> > + * in .BTF_ids section. They are initially filled with zeros
> > + * (during compilation) and resolved later during the
> > + * linking phase by btfid tool.
> > + *
> > + * Any change in list layout must be reflected in btfid
> > + * tool logic.
> > + */
> > +
> > +#define SECTION ".BTF_ids"
>
> nit: SECTION is super generic and non-greppable. BTF_IDS_SECTION?
>
> > +
> > +#define ____BTF_ID(symbol)                             \
> > +asm(                                                   \
> > +".pushsection " SECTION ",\"a\";               \n"     \
>
> section should be also read-only? Either immediately here, of btfid
> tool should mark it? Unless I missed that it's already doing it :)
>
> > +".local " #symbol " ;                          \n"     \
> > +".type  " #symbol ", @object;                  \n"     \
> > +".size  " #symbol ", 4;                        \n"     \
> > +#symbol ":                                     \n"     \
> > +".zero 4                                       \n"     \
> > +".popsection;                                  \n");
> > +
> > +#define __BTF_ID(...) \
> > +       ____BTF_ID(__VA_ARGS__)
>
> why varargs, if it's always a single argument? Or it's one of those
> macro black magic things were it works only in this particular case,
> but not others?
>
>
> > +
> > +#define __ID(prefix) \
> > +       __PASTE(prefix, __COUNTER__)
> > +
> > +
> > +/*
> > + * The BTF_ID defines unique symbol for each ID pointing
> > + * to 4 zero bytes.
> > + */
> > +#define BTF_ID(prefix, name) \
> > +       __BTF_ID(__ID(__BTF_ID__##prefix##__##name##__))
> > +
> > +
> > +/*
> > + * The BTF_ID_LIST macro defines pure (unsorted) list
> > + * of BTF IDs, with following layout:
> > + *
> > + * BTF_ID_LIST(list1)
> > + * BTF_ID(type1, name1)
> > + * BTF_ID(type2, name2)
> > + *
> > + * list1:
> > + * __BTF_ID__type1__name1__1:
> > + * .zero 4
> > + * __BTF_ID__type2__name2__2:
> > + * .zero 4
> > + *
> > + */
> > +#define BTF_ID_LIST(name)                              \
>
> nit: btw, you call it a list here, but btfids tool talks about
> "sorts". Maybe stick to consistent naming. Either "list" or "set"
> seems to be appropriate. Set implies a sorted aspect a bit more, IMO.
>
> > +asm(                                                   \
> > +".pushsection " SECTION ",\"a\";               \n"     \
> > +".global " #name ";                            \n"     \
>
> I was expecting to see reserved 4 bytes for list size? I also couldn't
> find where btfids tool prepends it. From what I could understand, it
> just assumed the first 4 bytes are the length prefix? Sorry if I'm
> slow...

Never mind, this is different from whitelisting you do in patch #8.
But now I'm curious how this list symbol gets its size correctly
calculated?..

>
>
> > +#name ":;                                      \n"     \
> > +".popsection;                                  \n");
> > +
> > +#endif
> > --
> > 2.25.4
> >
