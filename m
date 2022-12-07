Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B74645BA4
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiLGN6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiLGN60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:58:26 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B0D11462
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 05:58:24 -0800 (PST)
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0A98B41678
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 13:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1670421503;
        bh=9GCL3W6v/AmfhZbVCu5utEsH4vGz3v+tufp1/dYemRM=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=HH+h+3oTMqvrHGs5gWorf+M2Y70iE7rXMVv0cuMn1v0ZeZW4pdYr0rp20tKvWM6vK
         1OV97b9qHBwDDkJcrGaiZ6k+tTR8ly1PGH7A0iqSeSCqMncmEJFhKnfwRuB+gtNU07
         fHSAJwCSLLiweGlHBxI+VhZB2q6R0Tw+wWvpEkvvNbxySvjOJqkPtMHIhh5JwslTct
         FOoVS381Kj++0iZard8yobdylgobqKrNIdTw8NoCKNxfnQ8tF78mV4FZf2SYERwQyT
         L4rhMGElgBMgH/JbP37rm7z1aiRd1cCnulFBO0SYc6LA0RS1X3+iwHuGZMae5nA/h9
         IRo08DD/8lnww==
Received: by mail-il1-f197.google.com with SMTP id h20-20020a056e021d9400b00300581edaa5so16660884ila.12
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 05:58:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9GCL3W6v/AmfhZbVCu5utEsH4vGz3v+tufp1/dYemRM=;
        b=OTNlLFh96hymLnXnaXusxP162/UHM4Y8D3cJHl9IMztJYcqDdHleAn+NwXml4WgtZO
         bpN+9GXGeLDzzUziz3rtZvfXsEz4h9StqrXkj7uXI4QgQy8+0QxB09tgSPid4kYQZ29N
         fJ0fyBvpiB+ibFoYDTVr8knwraksVoS40HkY/r/K36cWsRQIuNgHI8DWRGXDH0TgQs7p
         M7EE6r/k/S0LDjuIaixJU+Vr0LmnnDZFy3Sgaqg6INQhZmRHju1tSVegK25CDCIfHHUg
         e1vQ12Wbr8c4NJzVPD76pKj52ZghfcMfL1ZOeYgzDz/LUf+8id/kiDyKPRcsJP16DHe7
         6PvQ==
X-Gm-Message-State: ANoB5pncZYmFQcXqlsz9TQXqvbhhzOnpCmzDJyFL+6kijmxmjtKHD3FA
        UTX+pq2vMoxmK5TBA61nS+eJvycPF/Iv/HsymUaVy3romGTA3TXDkBx5XsJJYEfCO9H2JQeQaXZ
        o+HTdBh2o74VJVUlyQzQEQh4Ql6K5UYBCZ3dItR3o/+T9P9mGUQ==
X-Received: by 2002:a05:6638:15cb:b0:38a:a2c:5c1e with SMTP id i11-20020a05663815cb00b0038a0a2c5c1emr14812166jat.35.1670421501101;
        Wed, 07 Dec 2022 05:58:21 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6oS4WtB4AY/x9xEAWaZszCLUNeiIhVzCL4QBdnRGkNjsZUkTVArtcl3+u1LcaAO1HHytY7Lk4DCTgXk2m0eYo=
X-Received: by 2002:a05:6638:15cb:b0:38a:a2c:5c1e with SMTP id
 i11-20020a05663815cb00b0038a0a2c5c1emr14812154jat.35.1670421500857; Wed, 07
 Dec 2022 05:58:20 -0800 (PST)
MIME-Version: 1.0
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com> <20221201090242.2381-3-yanhong.wang@starfivetech.com>
In-Reply-To: <20221201090242.2381-3-yanhong.wang@starfivetech.com>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Wed, 7 Dec 2022 14:58:04 +0100
Message-ID: <CAJM55Z8ZDKWEkdWuRZfcMQDrySMh4vdB1UvkAC+q1GRKMbGuEw@mail.gmail.com>
Subject: Re: [PATCH v1 2/7] net: stmmac: platform: Add snps,dwmac-5.20 IP
 compatible string
To:     Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Dec 2022 at 10:05, Yanhong Wang <yanhong.wang@starfivetech.com> wrote:
>
> Add "snps,dwmac-5.20" compatible string for 5.20 version that can avoid
> to define some platform data in the glue layer.
>
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>

Hi Yanhong.

Thanks for submitting this.
But just as a reminder. Please don't change the author of the commits
you cherry-picked from my tree.

/Emil

> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> index 50f6b4a14be4..cc3b701af802 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> @@ -519,7 +519,8 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
>         if (of_device_is_compatible(np, "snps,dwmac-4.00") ||
>             of_device_is_compatible(np, "snps,dwmac-4.10a") ||
>             of_device_is_compatible(np, "snps,dwmac-4.20a") ||
> -           of_device_is_compatible(np, "snps,dwmac-5.10a")) {
> +           of_device_is_compatible(np, "snps,dwmac-5.10a") ||
> +           of_device_is_compatible(np, "snps,dwmac-5.20")) {
>                 plat->has_gmac4 = 1;
>                 plat->has_gmac = 0;
>                 plat->pmt = 1;
> --
> 2.17.1
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
