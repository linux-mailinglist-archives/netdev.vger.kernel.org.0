Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CC557590B
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 03:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240954AbiGOBTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 21:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbiGOBS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 21:18:59 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC2424F37;
        Thu, 14 Jul 2022 18:18:57 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id b11so6398419eju.10;
        Thu, 14 Jul 2022 18:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z4ZOmBhvG/vrBEAiyPKvO+yeijURQ0Ebcnr6F+80vp0=;
        b=GejBMuRGtjxQZ33xcKp48Z968DaneQvcthquhegMII1eRjQtmUQgSfH3dLmTH9ysMt
         +TU2TORYJbUIWYnMBV/5oP3DGia36LFVLbDejExd8h255CuPlocW/o3jmcz+83sPHln0
         J0zGwUfX63g3Gx2Z4rshknIzes4coYdhxG8LAM3dY9FqkrOZjHaUshLktXXu/+ID+nz/
         DDsKxLVMQmUA/fGtBf1NIPyuSeUs/N2okQ+1Bo1Xsj3w1bcTgpq73Vu6Jwe/xnzgXzPl
         iATzdCVVKEGAMpWV8HJdndTID52Ir4HEIrNcjJDLFIhGQ6uT1ZcDIdgVvLDs3pZa2lhu
         SUHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z4ZOmBhvG/vrBEAiyPKvO+yeijURQ0Ebcnr6F+80vp0=;
        b=ALpxN4dJAHatntgd6XNYNKhsaqEfIghJrMAJdke+k4rXJGiO4DyB83Se7khWyKe269
         vLKk7mQNczn/vmhcj+b6/Tm5mBHxxSJREvER/p1fUTdkUN8MVN1300g5jSLXVbqhpEKb
         z+6PM/MIkcZQ641u0sVFU6QPQgGMDYSlfwtiphFyQ9AiPTOx4nw4Ojn/mAVgh3x8pSzf
         U8CoAm6nZwym4dTrQYEOLxLHLSNdNXzPdfLSRCp2ut9R+yEZUbx1vydlWgjebgCUxdwj
         QNSukVWOhvtF0+s24DDdKMz8BRwn5LRHfrpX1QIQHNd8pHQMYWXw885X2HkyGqDVLklb
         dJYg==
X-Gm-Message-State: AJIora+bc7eVJJqnavbOUCmHXh1XOWyDw0a+n71ZFh2I05jyaW+q8AVu
        yvgicLGQcLQLCvP5D6L5NEhflp3tAhY7i5oxyAhFtCFz
X-Google-Smtp-Source: AGRyM1sOr3zkegrI3IfczOPBxPKCJXUwdjT5Cx3D27kp9KHPVDEukQHkWa8VkRVMxNWsQx3V2FiwCY1wmzXJngu72Yo=
X-Received: by 2002:a17:907:971c:b0:72b:83d2:aa7a with SMTP id
 jg28-20020a170907971c00b0072b83d2aa7amr11393369ejc.633.1657847936279; Thu, 14
 Jul 2022 18:18:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220709211849.210850-1-ebiggers@kernel.org> <20220709211849.210850-3-ebiggers@kernel.org>
 <20220711110348.4c951fff@kernel.org>
In-Reply-To: <20220711110348.4c951fff@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 14 Jul 2022 18:18:45 -0700
Message-ID: <CAADnVQ+qS2ooA_LVndHfwm5AngRqQFceHPwYi=0WwXd350ePcg@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: make the sha1 library optional
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 11:22 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat,  9 Jul 2022 14:18:49 -0700 Eric Biggers wrote:
> > Since the Linux RNG no longer uses sha1_transform(), the SHA-1 library
> > is no longer needed unconditionally.  Make it possible to build the
> > Linux kernel without the SHA-1 library by putting it behind a kconfig
> > option, and selecting this new option from the kconfig options that gate
> > the remaining users: CRYPTO_SHA1 for crypto/sha1_generic.c, BPF for
> > kernel/bpf/core.c, and IPV6 for net/ipv6/addrconf.c.
> >
> > Unfortunately, since BPF is selected by NET, for now this can only make
> > a difference for kernels built without networking support.
>
> > diff --git a/init/Kconfig b/init/Kconfig
> > index c984afc489dead..d8d0b4bdfe4195 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -1472,6 +1472,7 @@ config HAVE_PCSPKR_PLATFORM
> >  # interpreter that classic socket filters depend on
> >  config BPF
> >       bool
> > +     select CRYPTO_LIB_SHA1
> >
>
> Let's give it an explicit CC: bpf@
>
> > diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
> > index bf2e5e5fe14273..658bfed1df8b17 100644
> > --- a/net/ipv6/Kconfig
> > +++ b/net/ipv6/Kconfig
> > @@ -7,6 +7,7 @@
> >  menuconfig IPV6
> >       tristate "The IPv6 protocol"
> >       default y
> > +     select CRYPTO_LIB_SHA1
> >       help
> >         Support for IP version 6 (IPv6).
>
> FWIW:
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Alexei Starovoitov <ast@kernel.org>

I believe I found the right full patch set in lore.
In the future (if there are follow ups)
please cc the full patchset to us.
Thanks!
