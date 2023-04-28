Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C186F1022
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 04:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344636AbjD1CAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 22:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjD1CAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 22:00:18 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F673A88
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 19:00:17 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id a1e0cc1a2514c-7782debbc94so3309270241.2
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 19:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20221208.gappssmtp.com; s=20221208; t=1682647216; x=1685239216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Bu06xaZjqwdhavFM+nCEMDPQNzUKIISgFnYAUBIAag=;
        b=h6oFHljrG+HXxPmuqq2stsVnzZgqSPxUe26OkBrjJGIzolHbcrwCzznfpD8JNP0X1V
         spbVfzVFjDvR7S9HlGCRX4GesPpcLHrdYOmTgRlF2ryVQPVwrLqn/JAqpH6dwKw4DMTZ
         Mrtm/GkHlmjehI9V6YrBDNVzc5cjBIYZ+Ibg/6Hx8r/352f4zzDozQMbzbyW/BV+zdAX
         pdoVs6EOkNJgxjUb7Lr78elGeTxCa4s68Hp657YqlLLfpKJHypL4r20qUS2qh3nwEF38
         w20T2pkVHcO0r9TnEbTECCHvra6OxPelXVr2YQkIt4IGdKzR/3Bct6PRFHAO/yUpghYl
         yIWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682647216; x=1685239216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Bu06xaZjqwdhavFM+nCEMDPQNzUKIISgFnYAUBIAag=;
        b=AIRMZqir3KOQZJlypqineziUe3Ybf4Cr8ADoxg3tIDQ7T3WlH6Lllt+Ohvfyj4P3Zy
         dAIyudB1DlErKVPoH9CtVrmzMZBWtOfJW5QvrG/bunaubj0byW76CAg3unsB5c0oNjsi
         KQIvbJnSStmmX2sv6QDN5X972KW101zM8GvO3F0jzR4wqi3rd5cZ/nt5PEjBrf/vah44
         YQ0Ozk7fjOgLT1JoPqvUB7oTtZh0z1iPP3yucESZyMmp5We0dETP4LrNVc97ROhqhP9H
         t1f0trZ+2VwgWSvBCEYX48panraO52pEQ4OMIFP41BUWOVyPpTjyVYELJIigyNg4y1Ar
         SiSw==
X-Gm-Message-State: AC+VfDz1A+SuAYx2eL+cFO/kfWA7l90G0BrbzgfpACEI3Md+wXa3fKYO
        04Q1BBQ40g/RsO3DxNszUM8jkEH6oxNcr2YphseAwg==
X-Google-Smtp-Source: ACHHUZ5q50UOPeI0svu3+cdmdaaSAo9Ud0iFTTHsDeVc7WvvOu/Nn3vVEHATa5X99m1ESmYr6ewdb1QJqxLTp/rywBE=
X-Received: by 2002:a1f:bfd4:0:b0:440:8a24:e716 with SMTP id
 p203-20020a1fbfd4000000b004408a24e716mr1726465vkf.6.1682647215811; Thu, 27
 Apr 2023 19:00:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230425102250.3847395-1-mie@igel.co.jp> <CACGkMEumt4p7jU+H+T-b9My0buhdS8a-1GCSnWjnCwMAM=wo1Q@mail.gmail.com>
In-Reply-To: <CACGkMEumt4p7jU+H+T-b9My0buhdS8a-1GCSnWjnCwMAM=wo1Q@mail.gmail.com>
From:   Shunsuke Mie <mie@igel.co.jp>
Date:   Fri, 28 Apr 2023 11:00:04 +0900
Message-ID: <CANXvt5pn5uFxp1RYX+UQuVq=RyTjVZHBb-LgipFDN4L-0Z6ekg@mail.gmail.com>
Subject: Re: [PATCH v3] vringh: IOMEM support
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023=E5=B9=B44=E6=9C=8826=E6=97=A5(=E6=B0=B4) 15:10 Jason Wang <jasowang@re=
dhat.com>:
>
> On Tue, Apr 25, 2023 at 6:23=E2=80=AFPM Shunsuke Mie <mie@igel.co.jp> wro=
te:
> >
> > Introduce a new memory accessor for vringh. It is able to use vringh to
> > virtio rings located on io-memory region.
>
> Is there a user for this? It would be better if you can describe the
> use cases for this. Maybe you can post the user or at least a link to
> the git as a reference.
This is for the following patch.
https://lore.kernel.org/virtualization/20230427175244.GA261197@bhelgaas/T/#=
m30a258509caca2413a21f9a9ce0f5fd31d3bd006
I'd like to add a description of how this feature will be used in the
next version.
> >
> > Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
> > ---
> >
> > Changes from v2: https://lore.kernel.org/virtualization/20230202090934.=
549556-1-mie@igel.co.jp/
> > - Focus on an adding io memory APIs
> > Remove vringh API unification and some fixes.
> > - Rebase on next-20230414
> >
> >  drivers/vhost/Kconfig  |   6 ++
> >  drivers/vhost/vringh.c | 129 +++++++++++++++++++++++++++++++++++++++++
> >  include/linux/vringh.h |  33 +++++++++++
> >  3 files changed, 168 insertions(+)
> >
> > diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> > index b455d9ab6f3d..4b0dbb4a8ab3 100644
> > --- a/drivers/vhost/Kconfig
> > +++ b/drivers/vhost/Kconfig
> > @@ -6,6 +6,12 @@ config VHOST_IOTLB
> >           This option is selected by any driver which needs to support
> >           an IOMMU in software.
> >
> > +config VHOST_RING_IOMEM
> > +       tristate
> > +       select VHOST_IOMEM
> > +       help
> > +         This option enables vringh APIs to supports io memory space.
>
> There's no specific Kconfig for all the existing accessors. Any reason
> I/O memory is special or do you care about the size of the module?
I followed the IOTLB that is used for vhost and vringh. However, this code =
has
little effect on the code size and dependencies if included, so I
would like to remove
the Kconfig.
> > +
> >  config VHOST_RING
> >         tristate
> >         select VHOST_IOTLB
> > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > index 955d938eb663..ce5a88eecc05 100644
> > --- a/drivers/vhost/vringh.c
> > +++ b/drivers/vhost/vringh.c
> > @@ -1604,4 +1604,133 @@ EXPORT_SYMBOL(vringh_need_notify_iotlb);
> >
> >  #endif
> >
>
> [...]
>
> >
> > base-commit: d3f2cd24819158bb70701c3549e586f9df9cee67
> > prerequisite-patch-id: 760abbe8c981c52ccc421b8139e8999ab71619aa
> > prerequisite-patch-id: 99d8679ab4569545c8af401e84142c66312e953e
> > prerequisite-patch-id: aca81516aba75b58c8422d37c2dc7db2f61ffe92
> > prerequisite-patch-id: 3d76136200c4e55ba2c41681325f242859dd6dbd
> > prerequisite-patch-id: 47a994feb68d95412d81b0fd1fa27bc7ba05ae18
> > prerequisite-patch-id: a2f7fc3f35358f70b6dad4c919ce293b10295c4f
> > prerequisite-patch-id: 70e2ee32b945be96a0388f0ff564651ac9335220
> > prerequisite-patch-id: 2023690f9c47017b56d7f036332a5ca3ece6bde8
> > prerequisite-patch-id: 211e113fec6c450d13fbdb437ecfad67dec0a157
> > prerequisite-patch-id: f2bcd3168933886e4cd4c39e47446d1bd7cb2691
> > prerequisite-patch-id: 37b131560808733a0b8878e85a3d2a46d6ab02ca
> > prerequisite-patch-id: 79b0219a715cb5ace227d55666d62fdb2dcc6ffe
> > prerequisite-patch-id: 30f1740cd48a19aa1c3c93e625c740cae2845478
> > prerequisite-patch-id: 31989e4a521f2fc6f68c4ccdb6960035e87666a7
> > prerequisite-patch-id: 3948bb3e0c045e2ffff06a714d17bab16c94775d
> > prerequisite-patch-id: cf28e0115b9111bcb77aa9c710d98b2be93c7e89
> > prerequisite-patch-id: ebf2349c0ae1296663854eee2da0b43fe8972f9b
> > prerequisite-patch-id: fc570921d885a2a6000800b4022321e63f1650a5
> > prerequisite-patch-id: 1fd5219fef17c2bf2d76000207b25aae58c368f3
> > prerequisite-patch-id: 34e5f078202762fe69df471e97b51b1341cbdfa9
> > prerequisite-patch-id: 7fa5151b9e0488b48c2b9d1219152cfb047d6586
> > prerequisite-patch-id: 33cca272767af04ae9abe7af2f6cbb9972cc0b77
> > prerequisite-patch-id: bb1a6befc899dd97bcd946c2d76ce73675a1fa45
> > prerequisite-patch-id: 10be04dd92fa451d13676e91d9094b63cd7fbcf8
> > prerequisite-patch-id: 87b86eb4ce9501bba9c04ec81094ac9202392431
> > prerequisite-patch-id: a5ced28762bf6bd6419dae0e4413d02ccafd72c2
> > prerequisite-patch-id: 2db4c9603e00d69bb0184dabcc319e7f74f30305
> > prerequisite-patch-id: 41933f9d53e5e9e02efd6157b68ee7d92b10cfa2
> > prerequisite-patch-id: df3295b4cdde3a45eaf4c40047179698a4224d05
> > prerequisite-patch-id: 9e2fca9ab0ba2b935daa96f1745ff4c909792231
> > prerequisite-patch-id: 8948378099ba4d61e10a87e617d69ed2fc4104ae
> > prerequisite-patch-id: 5e7466f3f0d74880d1a574a1bd91b12091dcf3f5
> > prerequisite-patch-id: 902899e1cd53b7fcc7971f630aed103830fc3e3d
> > prerequisite-patch-id: 42126b180500f9ff123db78748972c6ece18ac57
> > prerequisite-patch-id: 5236a03ef574074f3c1009a52612051862b31eff
> > prerequisite-patch-id: adae1aa80df65bd02a9e3f4db490cf801c1c6119
> > prerequisite-patch-id: 22806fcabb973ee5f04ee6212db6161aab5bcbfc
> > prerequisite-patch-id: 6eb14cfdc2cf31e90556f6afe7361427a332e8dc
>
> These seem meaningless?
I'm sorry, that didn't make sense. I'll remove it.
> Thanks
>
> > --
> > 2.25.1
> >
>
Best regards,
Shunsuke
