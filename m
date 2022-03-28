Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500D34E9898
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 15:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243429AbiC1Nsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 09:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243418AbiC1Nsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 09:48:51 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC824E3AB
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 06:47:10 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id k124-20020a1ca182000000b0038c9cf6e2a6so8616605wme.0
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 06:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=lqWUovhT3deFfz1zrmG2BdScTmfXFTXlEBWbC7kOkUc=;
        b=Casp3ieHRH0PsmFMjKH7TFdpT/TNQBYWEewfJb+0xu+uR1ofg9WJFp8XZHfsoJ6hWp
         C3nRcv1dmEeOPPKeVzOxrD+erWCy3JA6tU8mIHsAGm/8BjsYzwvx7P5mI7L1KmNHeogG
         38uNEFuvu5fJtLpThq9lRBZu4UJTQpGAB9zPox6v7iYfXD/Z14PGXT9t5owO2tQYWh0P
         3dUo+G/1/czVs79WbHUKkU/6h2niPOopvKPMU5QpP07x/qfD1LrC5Cesac25l5SMzvon
         esMFddga3HKSH7nNwn2IpXtOjAEGaytpRSosc2jrznnt1TPvUIg3fMjEdTz9d4Vfr7yu
         igag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=lqWUovhT3deFfz1zrmG2BdScTmfXFTXlEBWbC7kOkUc=;
        b=HIi0oBaD6nYaeKwIA1a1dDmZ0b3zwQpgHkVERY5TQfts970wxZR8e89gusYCnRoUPI
         pLzxUcPkuoFLUzdxWJjAkeIVkYJW6RMOQFFNtFAtoWYVngg8KZmsUHgBjfP5AmYpNcA5
         QXqo1CvxAOSuPlASi/8ud1Bmbl2KNJpWM/MA7AjCpZ9ylvAKXLG0Way9ZhQdKtqUN2ff
         taYUIfJod0wVJ1W+9BoG6RSwdNSM0U4NZmWdy7C3hSygpiBS2jSKkeCeWX7Ft9zGSVMx
         HIyyY/wNUv5qpFxLubMU/YCjLZZo6b74DO6qWLdUBRBwlmIOAwbxYCVOsk8sRYfoeec8
         fthQ==
X-Gm-Message-State: AOAM532uYDVkN6BjNTpTFu8SVEEEb642Pqm3Mhz0mSMrsm9xFREOEl6J
        LojJWwkNtsNP2pSpSY/Yz7LTiA==
X-Google-Smtp-Source: ABdhPJwB0pYnLloiCs6wa/2INWNx44L+qT5u6Nb9H+6gXgQ9TsmBu3vjwmvbBF2kaoxeBO0KJ0MWbQ==
X-Received: by 2002:a05:600c:4401:b0:38c:8df8:9797 with SMTP id u1-20020a05600c440100b0038c8df89797mr35783652wmn.13.1648475228582;
        Mon, 28 Mar 2022 06:47:08 -0700 (PDT)
Received: from maple.lan (cpc141216-aztw34-2-0-cust174.18-1.cable.virginm.net. [80.7.220.175])
        by smtp.gmail.com with ESMTPSA id t4-20020a05600001c400b00203fb5dcf29sm12145898wrx.40.2022.03.28.06.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 06:47:08 -0700 (PDT)
Date:   Mon, 28 Mar 2022 14:47:05 +0100
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Benjamin =?utf-8?B?U3TDvHJ6?= <benni@stuerz.xyz>
Cc:     sebastian.hesselbarth@gmail.com, gregory.clement@bootlin.com,
        linux@armlinux.org.uk, linux@simtec.co.uk, krzk@kernel.org,
        alim.akhtar@samsung.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        robert.moore@intel.com, rafael.j.wysocki@intel.com,
        lenb@kernel.org, 3chas3@gmail.com, laforge@gnumonks.org,
        arnd@arndb.de, gregkh@linuxfoundation.org, mchehab@kernel.org,
        tony.luck@intel.com, james.morse@arm.com, rric@kernel.org,
        linus.walleij@linaro.org, brgl@bgdev.pl,
        mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca,
        pali@kernel.org, dmitry.torokhov@gmail.com, isdn@linux-pingi.de,
        benh@kernel.crashing.org, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        nico@fluxnic.net, loic.poulain@linaro.org, kvalo@kernel.org,
        pkshih@realtek.com, bhelgaas@google.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-input@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 00/22] Replace comments with C99 initializers
Message-ID: <20220328134705.lnxwwznhw622r2pr@maple.lan>
References: <20220326165909.506926-1-benni@stuerz.xyz>
 <8f9271b6-0381-70a9-f0c2-595b2235866a@stuerz.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8f9271b6-0381-70a9-f0c2-595b2235866a@stuerz.xyz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 27, 2022 at 02:46:00PM +0200, Benjamin Stürz wrote:
> This patch series replaces comments with C99's designated initializers
> in a few places. It also adds some enum initializers. This is my first
> time contributing to the Linux kernel, therefore I'm probably doing a
> lot of things the wrong way. I'm sorry for that.

Welcome!


> I've gotten a few emails so far stating that this patch series is
> unnecessary. Yes, in fact this patch series is not necessary by itself,
> but it could help me understand how the whole process works and maybe I
> could help somewhere, where help is actually needed.

Have you been told the series is unnecessary or too big?

Although all patches represent a variant of the same mechanical
transformation but they are mostly unrelated to each other and, if
accepted, they will be applied by many different people.

Taken as a whole presenting this to maintainers as a 22 patch set is too
big. I'd recommend starting with a smaller patch or patch series where
all the patches get picked up by the same maintainer.


> This patch itself is a no-op.

PATCH 0/XX is for the covering letter. You should generate a template for
it using the --cover-letter option of git format-patch. That way patch 0
will contain the diffstat for the whole series (which is often useful
to help understand what the series is for) and there is no need to
make no-op changes.


Daniel.

> 
> Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
> ---
>  .gitignore | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/.gitignore b/.gitignore
> index 7afd412dadd2..706f667261eb 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -20,7 +20,7 @@
>  *.dtb
>  *.dtbo
>  *.dtb.S
> -*.dwo
> +*.dwo
>  *.elf
>  *.gcno
>  *.gz
> -- 
> 2.35.1
