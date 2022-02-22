Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CED74C02D6
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 21:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235417AbiBVUIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 15:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234231AbiBVUII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 15:08:08 -0500
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5451BE1D7
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 12:07:42 -0800 (PST)
Received: by mail-ua1-x930.google.com with SMTP id p33so348180uap.8
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 12:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3of7j8sAFxaENpbvktleuyRYBlpkjpkzUP359TvVwW4=;
        b=UbtArfAz/RfwPO82ch2dVQnlV9oVIz2oFwHMgq2VYf0aR9yNy/Mp4kq1H3UQ+lKEn2
         TeELo6ctPwIKwblqBW6yTeRD27/dgoIYY/QHzq/yUKcVymE6/VDwBSJjSpcI3i455Fs4
         xZPeJexTe+ygvFCgYYm+5zfCfxInxgEE3TGLPBxw4saV9v7kWymqfCRwu7D/cMONqSLq
         nS9d9t9yMuyeR2zgjFBMhSF6Pw8wUk+DgNvo0Nqkn7blc0QTItxXktAxFCDbo64Kk9GQ
         OySuOv/AGJexAYApgL/hX+ZssWD5unhZPik45f4Z1Mkxuxcydl9p00+Ml2Jg+0RVMpT2
         1b7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3of7j8sAFxaENpbvktleuyRYBlpkjpkzUP359TvVwW4=;
        b=lcko/yvIiO+PZNXSP23bZs6jwPImB59FplxWCJs3lKcqTbQX4W14jHpD3Zc4UwXFrb
         YrQF+27ooowpLsgcsW6HGzmSV4iK/8y96xhrqY+gR/3Qo1qUnYyz7B6MbIcilRlsV/Ll
         cN5+QPJRQoq2IAj+vmBX8qfh/IQ3oik+o8CwWXwX9+BNuwVyl7DRTmpw6cMEihlUehhr
         KKd2Uz6BFV4+aF7SecOTJxFAcNmW6WCj6mZQkYpbh/atVgY5akUOyvxPOUShhKUUSeLU
         woAtZB6I5UgOavHVHEpy1P9CqC6yDrwyudy5zLVWyrRYnK8oeBQ4TwWGJHYyho4ar5kI
         uRmA==
X-Gm-Message-State: AOAM5301rucU1hsipFAtFRMQg6Xzkeal/IxQdj80D8mLvCi04k2tP7Yh
        zZxHWIprltz50C6/NTKmT3CfZ3KD8ajO1LSFDnZaKlRVu9Q=
X-Google-Smtp-Source: ABdhPJwjWqPseWA7n1T+EJJs3f1wHzq6m3244RPgQBsCxbwhgerRFdDgAd3d8od0D2AcKdmpNWnQIIN82tBmWsdqCJc=
X-Received: by 2002:ab0:72d1:0:b0:342:3751:d637 with SMTP id
 g17-20020ab072d1000000b003423751d637mr5821726uap.143.1645560461706; Tue, 22
 Feb 2022 12:07:41 -0800 (PST)
MIME-Version: 1.0
References: <20220222095348.2926536-1-pbrobinson@gmail.com> <f79df42b-ff25-edaa-7bf3-00b44b126007@gmail.com>
In-Reply-To: <f79df42b-ff25-edaa-7bf3-00b44b126007@gmail.com>
From:   Peter Robinson <pbrobinson@gmail.com>
Date:   Tue, 22 Feb 2022 20:07:30 +0000
Message-ID: <CALeDE9NGckRoatePdaWFYqHXHcOJ2Xzd4PGLOoNWDibzPB_zXQ@mail.gmail.com>
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>
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

> On 2/22/2022 1:53 AM, Peter Robinson wrote:
> > The ethtool WoL enable function wasn't checking if the device
> > has the optional WoL IRQ and hence on platforms such as the
> > Raspberry Pi 4 which had working ethernet prior to the last
> > fix regressed with the last fix, so also check if we have a
> > WoL IRQ there and return ENOTSUPP if not.
> >
> > Fixes: 9deb48b53e7f ("bcmgenet: add WOL IRQ check")
> > Fixes: 8562056f267d ("net: bcmgenet: request Wake-on-LAN interrupt")
> > Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
> > Suggested-by: Javier Martinez Canillas <javierm@redhat.com>
> > ---
> >   drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> >
> > We're seeing this crash on the Raspberry Pi 4 series of devices on
> > Fedora on 5.17-rc with the top Fixes patch and wired ethernet doesn't work.
>
> Are you positive these two things are related to one another? The
> transmit queue timeout means that the TX DMA interrupt is not firing up
> what is the relationship with the absence/presence of the Wake-on-LAN
> interrupt line?

The first test I did was revert 9deb48b53e7f and the problem went
away, then poked at a few bits and the patch also fixes it without
having to revert the other fix. I don't know the HW well enough to
know more.

It seems there's other fixes/improvements that could be done around
WOL in the driver, the bcm2711 SoC at least in the upstream DT doesn't
support/implement a WOL IRQ, yet the RPi4 reports it supports WOL.

This fix at least makes it work again in 5.17, I think improvements
can be looked at later by something that actually knows their way
around the driver and IP.

Peter

[1] https://elixir.bootlin.com/linux/v5.17-rc5/source/arch/arm/boot/dts/bcm2711.dtsi#L541

> At any rate:
>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> --
> Florian
