Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0354B85EE
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 11:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiBPKgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 05:36:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiBPKgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 05:36:16 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70852B9A3C
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 02:36:03 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id bu29so3084515lfb.0
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 02:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DPYWkKQW0nFWmY1xKFD4WRaxOqq/BeFHyxszPN5EPVU=;
        b=sUG7rjTRD6NrI48dGWwKOWJyGgjS5g2H1DjFZUQiMmRJj/ir9Wv7S+f3pcYhwB3G21
         jgW2ghTrDeTyWExposS8pU9olgt0OSFSsKqTWvFBrZtYeR1hzrMRB/QHZbRFsmF8Z2S0
         H/h0PiEEIFA7GmMAI2JMN3sa/fyLmEXYE57MT9xMELnMPIGAArOM53KTMVRbp5J3baMB
         isLqyWoSSBY1G4sXiIcXWs7lxW91pyd5h21jcWCoFLVEL0Fbk7le1PLdPy5uxaXftMdu
         5wLQBv6dJWYyW7H1/lavO2wyNL8O5n34jBSkfOXmCyy+T54Vr7Az+AHoRojt+05MRAOP
         vMsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DPYWkKQW0nFWmY1xKFD4WRaxOqq/BeFHyxszPN5EPVU=;
        b=JmHyIVSIB2xj2Fhwok1ThuP/O1GYntKljw5bJAvg/34OJHSJ9G2onqphKGBTgi5naw
         dgeZR+lPO8/5MPgKkfgtXUaTbObLDRSHSGDGFX5DiTGIzRjWgXl5KGQtGiPvPLy5NLyT
         4J3pasmKWin/fw7myAL9gjRwYcowws/uSR9vrMnSHNwnre3B2ds+ox29RobR4HBLeqp5
         mQ/4OhGiumjnDkyx00dOuc5+OYiz6+hfI+oG4UIklWZdtdtkFvQ0FtrJciUUBM73JcQQ
         U+A4laiOUGyqxH6xkpDliqvYu+AuSas/rzaFkmkiBnTC8nzr11HESggImzfAxADZaq7v
         dH4g==
X-Gm-Message-State: AOAM533rWBVimIe2gShZ5QG6vkUwGoaXIcS2ZVtMyxcN5wpVF7Dm+4Kn
        doFYsKC9gbjQRsjO6PmolhvoerGJkjetZQDZVQl7HQ==
X-Google-Smtp-Source: ABdhPJz9lTvKXYqNUYEUwJcowusuOCgV3hil3k2PW920Mo0Cq3dd/tLhknO2IA4VJElhIgGQWuFNWTFzEa2t3lXDQAk=
X-Received: by 2002:a05:6512:388d:b0:443:6066:2c8d with SMTP id
 n13-20020a056512388d00b0044360662c8dmr1552732lft.184.1645007762118; Wed, 16
 Feb 2022 02:36:02 -0800 (PST)
MIME-Version: 1.0
References: <20220216093112.92469-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20220216093112.92469-1-Jerome.Pouiller@silabs.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 16 Feb 2022 11:35:25 +0100
Message-ID: <CAPDyKFreMJigpAgE95EgkStNrE+r+_k9iRuTXsFk6t9d66e0TQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] staging: wfx: apply SDIO suggestions
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 at 10:31, Jerome Pouiller
<Jerome.Pouiller@silabs.com> wrote:
>
> From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>
> Hi Ulf, Greg,
>
> The second patch of this series touch to the staging tree and to the MMC
> framework. I don't know what is the rule for these cases, but I think it
> makes more sense to carry this patch with the staging tree.

I don't believe the changes to the mmc core will cause any merge
conflict, so feel free to funnel this through whatever tree makes best
sense.

For the series:
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

>
>
> J=C3=A9r=C3=B4me Pouiller (2):
>   staging: wfx: WF200 has no official SDIO IDs
>   staging: wfx: apply the necessary SDIO quirks for the Silabs WF200
>
>  drivers/mmc/core/quirks.h      | 5 +++++
>  drivers/staging/wfx/bus_sdio.c | 8 ++------
>  2 files changed, 7 insertions(+), 6 deletions(-)
>
> --
> 2.34.1
>
