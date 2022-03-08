Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FFE4D1685
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 12:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243257AbiCHLpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 06:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346695AbiCHLpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 06:45:36 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4033E5D7;
        Tue,  8 Mar 2022 03:44:36 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id x5so24036190edd.11;
        Tue, 08 Mar 2022 03:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=JMRbz6J1yWshdN+XM2gYkyrpKd4K5wvxuv5/wGGiQFc=;
        b=OKM75JlRjWvWpwoYf1E0yHZch86+h4aKV1Tj1Zt/TVB6Wg6FBJL1axc55dc0CodgRu
         civSLGEB/uQ8FErK0LBEaCNcC9FcRCWqNXmA7WBCFOqqA5RhhkKYrGpGF58nrDEwLOdU
         XE9nDRx8gUPU83ih4io9MlShh2My8VtsZ8yzi+SePDKF8uAy/dtihvmpHRIIBMl6EdYu
         m0zLAs4HvYrxmaN+SNqmtMTEWtcksgm9A+WDIOVXPnTuBt4gQGyqD3oHK+La3ls7K6Jz
         D0VPEaE6hRJggWYbqubE7AyXpZDYq3LfhBq8GLIewJlkJOkclDTB0MVzrtokyzfSvhco
         lxwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JMRbz6J1yWshdN+XM2gYkyrpKd4K5wvxuv5/wGGiQFc=;
        b=uJkQjmFnxbFEOyg+7RmlFy/Jfy7nyUv4B/T5izVcA/D/V5kMiNxUs2SZKJ9bA7n76u
         ZCKXym1/A1XITwN3DaLSoUND9FYg7gHBHfOu8DoHxQXDG9osIBsvKX0gsWhEM9szOF4S
         EJ1+hKR2Z3A1g/CZP+eBk8Tn0UKmSo57qeGnOiCNHkVsQfUZRG/E94jPeN/vQhTWiOqR
         vlOYnXg3IgJ33mt1asreVlZt4VVH0XSY7f//8CBPb4//O3PAWPB89kz8sVJ1RulQfwde
         lwZ0lkUNKDp7kD5k4bwviuvmP2NBq5sucC6FVPK40iB5KGtfVc5WuUhpaica/7sICpMH
         8XUQ==
X-Gm-Message-State: AOAM5332smgcNPgON7tSevRCWEfBWOQuAyWiv+D5uj5Ih+rHiOvmGROK
        mAh1PQb1Kh2A56wME4TsvkY=
X-Google-Smtp-Source: ABdhPJynjbtLJHmlzmzSALzgeprNdMLWfvq3lyyL11wapuPi1rffKj6gVUedEWAiSb+GbE3XbdLmQQ==
X-Received: by 2002:a50:9d47:0:b0:40f:9d3d:97b6 with SMTP id j7-20020a509d47000000b0040f9d3d97b6mr15545850edk.392.1646739875071;
        Tue, 08 Mar 2022 03:44:35 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id r6-20020a1709064d0600b006da7ca3e514sm5734108eju.208.2022.03.08.03.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 03:44:34 -0800 (PST)
Date:   Tue, 8 Mar 2022 13:44:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: rectify entry for REALTEK RTL83xx SMI DSA
 ROUTER CHIPS
Message-ID: <20220308114433.ucxenhxoq2grty4k@skbuf>
References: <20220308103027.32191-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220308103027.32191-1-lukas.bulwahn@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 11:30:27AM +0100, Lukas Bulwahn wrote:
> Commit 429c83c78ab2 ("dt-bindings: net: dsa: realtek: convert to YAML
> schema, add MDIO") converts realtek-smi.txt to realtek.yaml, but missed to
> adjust its reference in MAINTAINERS.
> 
> Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
> broken reference.
> 
> Repair this file reference in REALTEK RTL83xx SMI DSA ROUTER CHIPS.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> applies cleanly on next-20220308
> 
> David, please pick this minor non-urgent clean-up patch for net-next.
> 
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 38cdf9aadfe4..8c7e40e1215e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16638,7 +16638,7 @@ REALTEK RTL83xx SMI DSA ROUTER CHIPS
>  M:	Linus Walleij <linus.walleij@linaro.org>
>  M:	Alvin Šipraga <alsi@bang-olufsen.dk>
>  S:	Maintained
> -F:	Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
> +F:	Documentation/devicetree/bindings/net/dsa/realtek.yaml
>  F:	drivers/net/dsa/realtek/*
>  
>  REALTEK WIRELESS DRIVER (rtlwifi family)
> -- 
> 2.17.1
> 
