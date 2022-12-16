Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A87264EEC1
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbiLPQOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiLPQO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:14:28 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF578FEF;
        Fri, 16 Dec 2022 08:14:26 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id 4so2792331plj.3;
        Fri, 16 Dec 2022 08:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nRLE0KwusSvAiIcLR1vSOUa6NaXkWQIhEtVspgyp8bM=;
        b=ArFOblj7GBSNP1bX2BEOHs3j5CV+HIMEX6xuqSPMbb5kMug16IN2fmgbXY9AsrpD3A
         qGMR2zm4kt/Np8Ls/76e4VoRDPHy89b/gT9Y/OlyC4BhYPDMRLm0LXKtaERaR+gadXn1
         Dg8hZyO0FUXBEp7X+j2tyTBlgXuVnMhqfjN2c9V1/Cx7ur0lMi9QrU8HPODuDaRmtrgn
         YGX9lbVy4VUtvbzmBYNi/d2FnrZ5YB9ryV270huDwwhJNPCrTuSjdyPuE3og8t12d8/5
         qzWFXaEjFfnE2Fxca/XjqfQHBqsXsYfNM+4D9NwWuHZkHoyVc5ErVzI9bZilnXTB6iFn
         xpng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nRLE0KwusSvAiIcLR1vSOUa6NaXkWQIhEtVspgyp8bM=;
        b=sXvMO2jJms02RgO5GjUcjbwL6kpG1TMOXS7sFXn1UoyhRmIKIpvEHFHK6+nIG+5cM5
         bPqr/61kkR0y+sJOEd4Iol1ZJDWtNVCGl0+WAg3FTkRC1U/ykvjzTvyXJ0+YQlkNGNyM
         xC1Aj+fwDm9oSNa6aevv/vgUbAdxZOqpKd5qQK4jQKbXFV47KXBfFDTHwMQ0g5pW3lw8
         CH/si3Bc7jn5vDXXFjUsd+a7MgKb2Km/v3cDMukABArxSiNaL4aYSdJj5fFTFVkQrMjx
         Dd09ZwlH/UNKw/NCJgX60yowkB1G3k5/9Ab1C796KDjRvIJ4KxOzbAo0OBsH93hugliz
         BdVg==
X-Gm-Message-State: ANoB5pkwRETTYrrC7ABekQN0x2w990JlpRdXLsDLqbkRdgle9rbgHqDC
        F8dTuoDxhtOMeS7ej42NMzc=
X-Google-Smtp-Source: AA0mqf4P2LoVShFvOZHi2uHuICHfln15BegIiCEq3wUWrIAqfaIv0mPsq8OEIhrB1seVN4Aar5yp6g==
X-Received: by 2002:a05:6a20:9f96:b0:a3:9f32:a9d1 with SMTP id mm22-20020a056a209f9600b000a39f32a9d1mr42376731pzb.31.1671207266337;
        Fri, 16 Dec 2022 08:14:26 -0800 (PST)
Received: from [192.168.0.128] ([98.97.117.20])
        by smtp.googlemail.com with ESMTPSA id f10-20020a631f0a000000b004790f514f15sm1648371pgf.22.2022.12.16.08.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:14:25 -0800 (PST)
Message-ID: <b72b0f7692e5693f214d6acea33b878bfb3a372c.camel@gmail.com>
Subject: Re: [PATCH] net: ethernet: ti: am65-cpsw: fix CONFIG_PM #ifdef
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Roger Quadros <rogerq@kernel.org>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 16 Dec 2022 08:14:24 -0800
In-Reply-To: <20221215163918.611609-1-arnd@kernel.org>
References: <20221215163918.611609-1-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-12-15 at 17:39 +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The #ifdef check is incorrect and leads to a warning:
>=20
> drivers/net/ethernet/ti/am65-cpsw-nuss.c:1679:13: error: 'am65_cpsw_nuss_=
remove_rx_chns' defined but not used [-Werror=3Dunused-function]
>  1679 | static void am65_cpsw_nuss_remove_rx_chns(void *data)
>=20
> It's better to remove the #ifdef here and use the modern
> SYSTEM_SLEEP_PM_OPS() macro instead.
>=20
> Fixes: 24bc19b05f1f ("net: ethernet: ti: am65-cpsw: Add suspend/resume su=
pport")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ether=
net/ti/am65-cpsw-nuss.c
> index 9decb0c7961b..ecbde83b5243 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -2878,7 +2878,6 @@ static int am65_cpsw_nuss_remove(struct platform_de=
vice *pdev)
>  	return 0;
>  }
> =20
> -#ifdef CONFIG_PM_SLEEP
>  static int am65_cpsw_nuss_suspend(struct device *dev)
>  {
>  	struct am65_cpsw_common *common =3D dev_get_drvdata(dev);
> @@ -2964,10 +2963,9 @@ static int am65_cpsw_nuss_resume(struct device *de=
v)
> =20
>  	return 0;
>  }
> -#endif /* CONFIG_PM_SLEEP */
> =20
>  static const struct dev_pm_ops am65_cpsw_nuss_dev_pm_ops =3D {
> -	SET_SYSTEM_SLEEP_PM_OPS(am65_cpsw_nuss_suspend, am65_cpsw_nuss_resume)
> +	SYSTEM_SLEEP_PM_OPS(am65_cpsw_nuss_suspend, am65_cpsw_nuss_resume)
>  };
> =20
>  static struct platform_driver am65_cpsw_nuss_driver =3D {

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
