Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9DFA57BDEE
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiGTSiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiGTSh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:37:57 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FA072BFB;
        Wed, 20 Jul 2022 11:37:56 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id w12so24831398edd.13;
        Wed, 20 Jul 2022 11:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4N7oCHZtVzIBlvFCkiMA9HtsjdDFB6uOfrNG8bNIr6A=;
        b=f33iqSFnt7mKk+oP+AsranAop+aLyJu1XrOCyqg2sDb6jpP4yqxRnYp7CstMEkOqvS
         lfynqfLSuQ0HqxbbNTmJrf56Cu2kSnv6MGvGcMAyFMGYwS7JSuuLGaAaQC1k+cyBbp+Q
         86mHB1KLXWofC/Ppc6LUGDGvtBJcTGEWQ51cK/A0+XufoX9MvWdGRtYv1H6kxcWhJGe4
         mMJxDnvVd3/yBgp9BcZbhwrWL46hxMxNtpisPYU6F4diVqFo59JqnF+Ikvpia814LSXf
         Ra4XcVGKNQfdgIYUMTjGLtwqYHptsOKbUaotVSY4xOo2bXvVxQXsVOQq5lWi8Cq2oyc6
         /k9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4N7oCHZtVzIBlvFCkiMA9HtsjdDFB6uOfrNG8bNIr6A=;
        b=CaDNjarqHIDHxhtvOqI9onswYcesCFUO2I5XaEssIWpqtlFa9arEikGC4mIC49W/7M
         QqQrmUiqJVV8DTefytEhZaLZcYRGrzq1/EuFMDcDCEM6pHCT3pphldfb/7z+T54WAraA
         FGn7QNeLiGxHkjKNmCwOjXL3wLVNBSuzCcxSzoSm/S4KILsunDiKK4/GAVkgUbiPQxT9
         IsQtyyR87h3ViJYCWwGW1zoF9cnIAIPE2l9V3C/4c3SqoFrGUMngYWUS2uVyr4n+CjJb
         s5zHTaCgsFh+dfpLgihIMrPY4LNNS7gP2W05JYpnEUH7bMSzlqwrqePurTtDtmJUJ2Wd
         Xnug==
X-Gm-Message-State: AJIora911a8CCPLY1zNlRsy3E9ysbYdEBiCnNyVou+CAfQiFfK1+nk5j
        Vp8cXfdnu4jhthhlD/Nv2K9KnAEeSjdx6HtX3drE33p2RXraZQ==
X-Google-Smtp-Source: AGRyM1u/DVw/7922iqn+S2XfaGwM9VpZx1E5Rx1DwEYcFTbhfDbugm2F3Xfa7s8DiZVcdlCCCxTnwArknwFmXmeg/lw=
X-Received: by 2002:a05:6402:5cb:b0:434:eb48:754f with SMTP id
 n11-20020a05640205cb00b00434eb48754fmr53098889edx.421.1658342274838; Wed, 20
 Jul 2022 11:37:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220720065211.369241-1-jhpark1013@gmail.com> <3feb6514-de2c-4b95-b203-74362b3cc002@6wind.com>
In-Reply-To: <3feb6514-de2c-4b95-b203-74362b3cc002@6wind.com>
From:   Jaehee <jhpark1013@gmail.com>
Date:   Wed, 20 Jul 2022 14:37:58 -0400
Message-ID: <CAA1TwFCr3XryLzPTa-4V1MidusBbJf9kzL5T5zVD+Fy6iqTM_g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ipv6: avoid accepting values greater than 2
 for accept_untracked_na
To:     nicolas.dichtel@6wind.com
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, shuah@kernel.org,
        linux-kernel@vger.kernel.org, Arun Ajith S <aajith@arista.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Roopa Prabhu <roopa.prabhu@gmail.com>,
        Andy Roulin <aroulin@nvidia.com>,
        Stefano Brivio <sbrivio@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 4:26 AM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
>
> Le 20/07/2022 =C3=A0 08:52, Jaehee Park a =C3=A9crit :
> > The accept_untracked_na sysctl changed from a boolean to an integer
> > when a new knob '2' was added. This patch provides a safeguard to avoid
> > accepting values that are not defined in the sysctl. When setting a
> > value greater than 2, the user will get an 'invalid argument' warning.
> >
> > Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
> > Suggested-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> > Suggested-by: Roopa Prabhu <roopa@nvidia.com>
> > ---
> >  net/ipv6/addrconf.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> > index 6ed807b6c647..d3e77ea24f05 100644
> > --- a/net/ipv6/addrconf.c
> > +++ b/net/ipv6/addrconf.c
> > @@ -7042,9 +7042,9 @@ static const struct ctl_table addrconf_sysctl[] =
=3D {
> >               .data           =3D &ipv6_devconf.accept_untracked_na,
> >               .maxlen         =3D sizeof(int),
> >               .mode           =3D 0644,
> > -             .proc_handler   =3D proc_dointvec,
> > +             .proc_handler   =3D proc_dointvec_minmax,
> >               .extra1         =3D (void *)SYSCTL_ZERO,
> > -             .extra2         =3D (void *)SYSCTL_ONE,
> > +             .extra2         =3D (void *)SYSCTL_TWO,
> Nit: the cast is useless:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/i=
nclude/linux/sysctl.h#n40
>

O yes thank you for pointing that out! I just sent a v2 for your review.

>
> Regards,
> Nicolas

Thanks,
Jaehee
