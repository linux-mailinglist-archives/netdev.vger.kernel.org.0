Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC55682A01
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjAaKKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbjAaKKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:10:22 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AE155A0
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 02:10:20 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id n28-20020a05600c3b9c00b003ddca7a2bcbso181774wms.3
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 02:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=7CdDpf2HvFlRQpQEy8BTNgrbPxxoMvWAhrZNxv0ihbw=;
        b=EsczMRY9pPKBmk0Uoa90CyuZBNr/wmbe8DL6DdmUKyhg9uT4jfKKwFFR/eXjWogSyS
         byyQ2TmNEFYrdw1gNOTj7au/GibHuX4b+usuQwoqP6zJAWmiUzHxrBvlJ+jBw1DIrYsv
         SNHCXPqB+idCsnYL+8IZqYaSe2HFxMEt+coR3oQHHEMG71Fob8ex995m6rbqdBo1DWBd
         F0h68k2qzLM3JMl+LoAUaN95pSRayhCLxjsWv+biSmsBzwzWGbZY6UmSungwu9YTmLwU
         kwrcT8DFMIOeGI0jbMWklUnyGTdbv6mukyK/4883jkLf5dpBeCGLnipNcMAgIa6Dkezd
         ldcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7CdDpf2HvFlRQpQEy8BTNgrbPxxoMvWAhrZNxv0ihbw=;
        b=rRX+ytde9L70xmMJ2fT6pntOuyBY5HVpajBT5VQsAZN2cpFJ/8fouwbNcrC9Eyt1Vp
         +JqhCxw79YLdt/luGUG4Hj6TaywDtaoBbotpJPnDyRj06yhCrr3ATHuDqW0nessOPBT6
         DrWrURlgrPsumf++z4N21c1lFbFq1ll92OAhVQqHh7km0ppE3DgzGH/elwOvrnLqCoYT
         9Wl7KpbzdKXsx/m8HA7IV6EjVHRGu6LH/4XgAmUw996zrc6miQZQ/tuo78fefiCDaKec
         Ja9Fr+S/+h+di7OdKJS5Yzha4iJtQe+a1mwXWNN2wsK16779cvK8M9EHlbshass+Zgl8
         uiXw==
X-Gm-Message-State: AFqh2koI1SwVD+E6XkpRrElKLGnKXEIJqWoY/jYRXLkkfqWbmV2/ZbOQ
        bWBc5uu27Pe3JU04sBFZMpzeCg==
X-Google-Smtp-Source: AMrXdXthUNPuxugLmFyr20OmcGU3scVtN6peVaj9WzwNmFTstwv/1P+9kRFJRaBdgp4jtqclwOZUvw==
X-Received: by 2002:a05:600c:539b:b0:3da:1bb0:4d78 with SMTP id hg27-20020a05600c539b00b003da1bb04d78mr50940932wmb.14.1675159818451;
        Tue, 31 Jan 2023 02:10:18 -0800 (PST)
Received: from localhost (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id u9-20020a05600c4d0900b003dc54eef495sm7097981wmp.24.2023.01.31.02.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 02:10:17 -0800 (PST)
References: <20230130231402.471493-1-cphealy@gmail.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     cphealy@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        neil.armstrong@linaro.org, khilman@baylibre.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        jeremy.wang@amlogic.com
Cc:     Chris Healy <healych@amazon.com>
Subject: Re: [PATCH v3] net: phy: meson-gxl: Add generic dummy stubs for MMD
 register access
Date:   Tue, 31 Jan 2023 11:05:19 +0100
In-reply-to: <20230130231402.471493-1-cphealy@gmail.com>
Message-ID: <1jbkmf2ewn.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon 30 Jan 2023 at 15:14, Chris Healy <cphealy@gmail.com> wrote:

> From: Chris Healy <healych@amazon.com>
>
> The Meson G12A Internal PHY does not support standard IEEE MMD extended
> register access, therefore add generic dummy stubs to fail the read and
> write MMD calls. This is necessary to prevent the core PHY code from
> erroneously believing that EEE is supported by this PHY even though this
> PHY does not support EEE, as MMD register access returns all FFFFs.

This is definitely something that should be done, Thx !

>
> Fixes: 5c3407abb338 ("net: phy: meson-gxl: add g12a support")

This commit does not seems appropriate, especially since only the GXL ops
are changed, not the g12a variant.

This brings a 2nd point, any reason for not changing the g12 variant ?
I'm fairly confident it does support EEE either.

> Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Chris Healy <healych@amazon.com>
>
> ---
>
> Changes in v3:
> * Add reviewed-by
> Change in v2:
> * Add fixes tag
>
>  drivers/net/phy/meson-gxl.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
> index c49062ad72c6..5e41658b1e2f 100644
> --- a/drivers/net/phy/meson-gxl.c
> +++ b/drivers/net/phy/meson-gxl.c
> @@ -271,6 +271,8 @@ static struct phy_driver meson_gxl_phy[] = {
>  		.handle_interrupt = meson_gxl_handle_interrupt,
>  		.suspend        = genphy_suspend,
>  		.resume         = genphy_resume,
> +		.read_mmd	= genphy_read_mmd_unsupported,
> +		.write_mmd	= genphy_write_mmd_unsupported,
>  	},
>  };

