Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDA862A16A
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 19:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiKOSh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 13:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiKOSh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 13:37:57 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D799209B9
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 10:37:56 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-1322d768ba7so17236667fac.5
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 10:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QhMUoKXVcMHmZEBz9MdS5zopFN48S1PqhhOi5SQP8d8=;
        b=V0rZ4d85Xqc2HRJ94PzmtFOnpPbAaBdwVWu/3Iev1I5GTwtDLKyuG1FwKqZDzphhWF
         PmzT8Mue1qsX/T/wISpvNwvtp01Vxrj3doz0SdUrjfD/F0YlP82djlWuq0Uq9Xy3uaXR
         mIM3dwXPUGMJU+MPYWN3x4Rpr5p99iyI24oWzxlEpyvnqAtPb28hjXr1WhWWU/4LwOc9
         Qnnxs4THCRLdL5NuyM7LyBq2bigQxiVWi4zbf2+4BD5Jl9Y4CjRmr9ZQydCnd0Jaq6aP
         VYR+eMLieAydf9FplWWfG7K8aUEXGDJ5ockZvspK2jsEbZYmIs0KDROCsjBybfTdB2gn
         p3hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QhMUoKXVcMHmZEBz9MdS5zopFN48S1PqhhOi5SQP8d8=;
        b=i8vHxVNAcsYZrw9OkyIDF3sXRZz/h3alLTNvA12wD4yBsExYGe4zSvx1/OQsTl7juu
         tYhfDLJlLNXPTkaQ+ecAbnY4Ww4ON6Jfcie4GhTMiTgNnPpcSfv0OAvEuijOgM7ITS/x
         WR2i2B7yLb67/LAgrjgr1LdaFHcBRMj9zKEQ+NHq9mceOQOJhoJEjVdfcgUhcF//GVqh
         wDUyXeqfOjyeziK3JvBRqkI9sfbuuD1m7Knd4QN6rf0OS2GzRoo7mtLVdaOO2KKM2e8b
         yIzAlo3/HzbozHFf0LxZI3G/66GSmWorZMqdwdAK2QkGSHpfcS3IAvVuU6m7QBOFAGOK
         kujA==
X-Gm-Message-State: ANoB5pnFdSK7Fwc9lxTX1w6KdpLMBalRV3psrFTpN2I8VQUE9Rbep6oK
        PsP1vThG2/z+u3wPdaXe0cxW1vC6BQt9XkWrG52WJA==
X-Google-Smtp-Source: AA0mqf41NxdjStkZGmG9M30H6U1J1P0O9gnXmxLWefGJiEvgAFmccBPxAM9KsLI4KXvYYOU+yHPWdMvsDvJODX86Ef8=
X-Received: by 2002:a05:6870:9624:b0:13b:be90:a68a with SMTP id
 d36-20020a056870962400b0013bbe90a68amr1856335oaq.181.1668537474926; Tue, 15
 Nov 2022 10:37:54 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <20221115030210.3159213-6-sdf@google.com>
 <87h6z0i449.fsf@toke.dk>
In-Reply-To: <87h6z0i449.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 15 Nov 2022 10:37:43 -0800
Message-ID: <CAKH8qBsEGD3L0XAVzVHcTW6k_RhEt74pfXrPLANuznSAJw7bEg@mail.gmail.com>
Subject: Re: [xdp-hints] [PATCH bpf-next 05/11] veth: Support rx timestamp
 metadata for xdp
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 8:17 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > The goal is to enable end-to-end testing of the metadata
> > for AF_XDP. Current rx_timestamp kfunc returns current
> > time which should be enough to exercise this new functionality.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> > Cc: xdp-hints@xdp-project.net
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  drivers/net/veth.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index 2a4592780141..c626580a2294 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -25,6 +25,7 @@
> >  #include <linux/filter.h>
> >  #include <linux/ptr_ring.h>
> >  #include <linux/bpf_trace.h>
> > +#include <linux/bpf_patch.h>
> >  #include <linux/net_tstamp.h>
> >
> >  #define DRV_NAME     "veth"
> > @@ -1659,6 +1660,18 @@ static int veth_xdp(struct net_device *dev, stru=
ct netdev_bpf *xdp)
> >       }
> >  }
> >
> > +static void veth_unroll_kfunc(const struct bpf_prog *prog, u32 func_id=
,
> > +                           struct bpf_patch *patch)
> > +{
> > +     if (func_id =3D=3D xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TI=
MESTAMP_SUPPORTED)) {
> > +             /* return true; */
> > +             bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 1));
> > +     } else if (func_id =3D=3D xdp_metadata_kfunc_id(XDP_METADATA_KFUN=
C_RX_TIMESTAMP)) {
> > +             /* return ktime_get_mono_fast_ns(); */
> > +             bpf_patch_append(patch, BPF_EMIT_CALL(ktime_get_mono_fast=
_ns));
> > +     }
> > +}
>
> So these look reasonable enough, but would be good to see some examples
> of kfunc implementations that don't just BPF_CALL to a kernel function
> (with those helper wrappers we were discussing before).

Let's maybe add them if/when needed as we add more metadata support?
xdp_metadata_export_to_skb has an example, and rfc 1/2 have more
examples, so it shouldn't be a problem to resurrect them back at some
point?
