Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00CC154E673
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 17:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377225AbiFPP52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 11:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377859AbiFPP51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 11:57:27 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D384130567
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 08:57:26 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id u37so1878859pfg.3
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 08:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=y4hIoccrpEBvbRmekAk7uJ6aJ9uBx6pEBsR/N5eo7qo=;
        b=b3UcH0OXINDS1EuYLbs/VNoRuYYlEAIvvV3oGEZJkXqzIXpNDpRWLlYHCjcftLL9yK
         Ead9OZ85TawNLeKn0616r3m7uM4LhsGFEb8uohi1mTi/F5y1/KsbN1cIRjLwD3Uerp79
         SoUQ2B5LhCNvbu1bqnLCpIIuZymnTtd7nUKkv8OYKz6WlkNhB8xKE/INTyFuQP6lAVM4
         qwFEPBEw69YhZOu38XuD3LopokYuzA62VQ77znCCDS9SXYF2g6FQV+UBlGHrggyYyYXW
         Q/wQodKpWApb7VL6sEThHONtrES2AaZmtQvYQSKdn33PyEsA0L2QhVBckRzbTj4GUUGP
         oyHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=y4hIoccrpEBvbRmekAk7uJ6aJ9uBx6pEBsR/N5eo7qo=;
        b=HRQ9LX5zl2CLzjw9cBhx2m6GsGct14YvAO2JqeQfYSEeGJBla1mq9mgDKlE/q/uUPV
         OyX7W4njlb+uykmIAbCpAHweLMCjc2lyJrgUaqgKNZ+z7h9usMwlKi9SShIYYKENh+pd
         ZsBsz20VRz3AaaRTdXR9NVISZShj3shJTzYXl8+WF0iD6PjgutrZZkAAOX0Uan9g4gg7
         A89HSwsSAjFZCTs62zx6blaM/0GavreaMn3YMx/K5/TBmqlOwodKg9K9r9atuzghTxBw
         qGe6/NYp6rMv6l5WqLw/eyMeJfejQBWa+iLCOFVZWa6IJ94xb2ULhcEF2hOvi9LdQRyV
         6uuw==
X-Gm-Message-State: AJIora/jpeedRMSwDdzLfCb3ikp1KbiVUEIFtMC0/PNP8aA8TYueq9On
        cjW1E7+0HN3kYZKuXXEJKREtyOhEhQRo9ZSkXJIbig==
X-Google-Smtp-Source: AGRyM1tgdihzLruKB0/p4TES0q+uCOr/NKoSqikU431QPVJ2IRxlAKRL8A1X734iOfj79eFGf6t2YuU4ZmYe0XL/Epg=
X-Received: by 2002:aa7:8691:0:b0:51c:db9:4073 with SMTP id
 d17-20020aa78691000000b0051c0db94073mr5589886pfo.72.1655395046062; Thu, 16
 Jun 2022 08:57:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAHo-Ooy+8O16k0oyMGHaAcmLm_Pfo=Ju4moTc95kRp2Z6itBcg@mail.gmail.com>
 <CANP3RGed9Vbu=8HfLyNs9zwA=biqgyew=+2tVxC6BAx2ktzNxA@mail.gmail.com>
 <CAADnVQKBqjowbGsSuc2g8yP9MBANhsroB+dhJep93cnx_EmNow@mail.gmail.com>
 <CANP3RGcZ4NULOwe+nwxfxsDPSXAUo50hWyN9Sb5b_d=kfDg=qg@mail.gmail.com>
 <YqodE5lxUCt6ojIw@google.com> <YqpAYcvM9DakTjWL@google.com>
 <YqpB+7pDwyOk20Cp@google.com> <YqpDcD6vkZZfWH4L@google.com> <CANP3RGcBCeMeCfpY3__4X_OHx6PB6bXtRjwLdYi-LRiegicVXQ@mail.gmail.com>
In-Reply-To: <CANP3RGcBCeMeCfpY3__4X_OHx6PB6bXtRjwLdYi-LRiegicVXQ@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 16 Jun 2022 08:57:14 -0700
Message-ID: <CAKH8qBv=+QVBqHd=9rAWe3d5d47dSkppYc1JbS+WgQs8XgB+Yg@mail.gmail.com>
Subject: Re: Curious bpf regression in 5.18 already fixed in stable 5.18.3
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        Carlos Llamas <cmllamas@google.com>,
        YiFei Zhu <zhuyifei@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 6:36 PM Maciej =C5=BBenczykowski <maze@google.com> =
wrote:
>
> > > > I've bisected the original issue to:
> > > >
> > > > b44123b4a3dc ("bpf: Add cgroup helpers bpf_{get,set}_retval to get/=
set
> > > > syscall return value")
> > > >
> > > > And I believe it's these two lines from the original patch:
> > > >
> > > >  #define BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY(array, ctx, func)   =
         \
> > > >     ({                                              \
> > > > @@ -1398,10 +1398,12 @@ out:
> > > >             u32 _ret;                               \
> > > >             _ret =3D BPF_PROG_RUN_ARRAY_CG_FLAGS(array, ctx, func, =
0, &_flags); \
> > > >             _cn =3D _flags & BPF_RET_SET_CN;          \
> > > > +           if (_ret && !IS_ERR_VALUE((long)_ret))  \
> > > > +                   _ret =3D -EFAULT;
> > > >
> > > > _ret is u32 and ret gets -1 (ffffffff). IS_ERR_VALUE((long)ffffffff=
)
> > > returns
> > > > false in this case because it doesn't sign-expand the argument and
> > > internally
> > > > does ffff_ffff >=3D ffff_ffff_ffff_f001 comparison.
> > > >
> > > > I'll try to see what I've changed in my unrelated patch to fix it. =
But
> > > I think
> > > > we should audit all these IS_ERR_VALUE((long)_ret) regardless; they
> > > don't
> > > > seem to work the way we want them to...
> >
> > > Ok, and my patch fixes it because I'm replacing 'u32 _ret' with 'int =
ret'.
> >
> > > So, basically, with u32 _ret we have to do IS_ERR_VALUE((long)(int)_r=
et).
> >
> > > Sigh..
> >
> > And to follow up on that, the other two places we have are fine:
> >
> > IS_ERR_VALUE((long)run_ctx.retval))
> >
> > run_ctx.retval is an int.
>
> I'm guessing this means the regression only affects 64-bit archs,
> where long =3D void* is 8 bytes > u32 of 4 bytes, but not 32-bit ones,
> where long =3D u32 =3D 4 bytes
>
> Unfortunately my dev machine's 32-bit build capability has somehow
> regressed again and I can't check this.

Seems so, yes. But I'm actually not sure whether we should at all
treat it as a regression. There is a question of whether that EPERM is
UAPI or not. That's why we most likely haven't caught it in the
selftests; most of the time we only check that syscall has returned -1
and don't pay attention to the particular errno.
