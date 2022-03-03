Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7BB84CC964
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 23:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237096AbiCCWrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 17:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiCCWrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 17:47:07 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE5716DAE7;
        Thu,  3 Mar 2022 14:46:17 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id bi12so641105ejb.3;
        Thu, 03 Mar 2022 14:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8G4fsdSTZhHoqhtMqzCYvFpkqK9xPa9Uuwfj+Kc4FDc=;
        b=Vv6qPamZ34/Ss4Omy+Sumi9AgjANPMe7auZ0nBj4JSeydwwqGjIP+hcyZrglQBlZcu
         duJMY8yJkpGpiT+2TD6c/iq4zUhj1xfAhCmWegesHd7ZKcwoKHNW2Gk7ECIeitqLF2oc
         VH3Ir5YY2GcspLm+CD3tbIpF2BIFseWkxqncN+NRNJGU99TyB/SzNzwSc95/Ul7Y5BcK
         cD87a7Nk+VbD/4iTqN8cDle1ZZ95bvqxYXHXjxf/9H6E2vf6aJR5Z+u6EvieJXgoROdo
         46oPhvUDiG9DWnc+SuowgIPyc/HMoydyVyJz+Mzzbji8gFtv4OEsrWWW084223TPz5oG
         DNTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8G4fsdSTZhHoqhtMqzCYvFpkqK9xPa9Uuwfj+Kc4FDc=;
        b=zEDNV0M7ewXHxztSfxXg6+5ZWE5MdxfoFJWyiJcp8kEaT7noZgiwzlyx1fTkAiTFUZ
         /Ig+OEFwHPa5bKDYczJQxI5hZhamqalfEKfnXI87meFu3p2PcOjRUJrqXTPLkdZSpfEc
         79zuqWhNO75myAMBXYMKbbZqvjeGQHnMl4J0hopDfCmAyX3+WzsH05iw97F9F8p5m+FN
         teWeG3mSfnLuXB9OjMDyaqch8DFoQX01/VPBpwBgChYf0RQB/1o1dS1DXUOkdipqFsPx
         Cd05JyLWw+/zjTzxoYatZebRGF/xrZKm5bueb3E2JXLaAzW5jFytH2aY4gFmq+m/mGo7
         jSlQ==
X-Gm-Message-State: AOAM5316EW+jHkpe95958RX8wpzZ5P2REZtpJeqbZw4W/sHf9BAgl5df
        Hs6We0klr5bFKECobQON3nU=
X-Google-Smtp-Source: ABdhPJxDygBr+KpHY2REE6mJWoCbqzYcS5amc+jaOuQCbso4BmBRhR/1IV1fcfyjno9g6NqtzkJT0g==
X-Received: by 2002:a17:906:30d1:b0:6cf:d160:d8e4 with SMTP id b17-20020a17090630d100b006cfd160d8e4mr29143060ejb.265.1646347575877;
        Thu, 03 Mar 2022 14:46:15 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id ep16-20020a1709069b5000b006daa26de2fbsm581804ejc.153.2022.03.03.14.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 14:46:15 -0800 (PST)
Date:   Fri, 4 Mar 2022 00:46:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v5 1/3] dt-bindings: net: dsa: add rtl8_4 and
 rtl8_4t tag formats
Message-ID: <20220303224613.sdyfcipcmhzepbo7@skbuf>
References: <20220303015235.18907-1-luizluca@gmail.com>
 <20220303015235.18907-2-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303015235.18907-2-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 10:52:33PM -0300, Luiz Angelo Daros de Luca wrote:
> Realtek rtl8365mb DSA driver can use these two tag formats.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  Documentation/devicetree/bindings/net/dsa/dsa-port.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> index 702df848a71d..e60867c7c571 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> @@ -51,6 +51,8 @@ properties:
>        - edsa
>        - ocelot
>        - ocelot-8021q
> +      - rtl8_4
> +      - rtl8_4t
>        - seville
>  
>    phy-handle: true
> -- 
> 2.35.1
> 
