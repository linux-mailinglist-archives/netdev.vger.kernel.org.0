Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA5F6EB9EB
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 17:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjDVPMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 11:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjDVPMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 11:12:02 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1DB1BE3;
        Sat, 22 Apr 2023 08:12:00 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f193ca053eso10580965e9.0;
        Sat, 22 Apr 2023 08:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682176319; x=1684768319;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KGnY/HrREypDX51+I0zk+Oky/GDuvb1Orcb4OWwp5ls=;
        b=E1An35Vb8Wi5CCtIwmYghGbuQAT8ktyAcFUx4SMPW2I0X2+3bu5s6YXz0C80dbr+QS
         OIxqBjy2vLF32/Iw0p9E/hjc88VyWzzsT5s7EtBotJEtZEyvDCS1WsOEpNKQnLsQaYPz
         jEvB4ul3Hk5SNk/Tq7JocJHx3i+SI9L2reie/93ywaZMjq8MItVYekYgfdy018+VEgBa
         NMDMh8UqZw0Nyt2Zx8Apq17r16KGHVVlPjfQ2iu3Wlo1L5RxtuvbqSOmUBZ+GLIEWnmu
         JyZD2GQgLXX5EmTRfwIZrd2Ry0bzxV7+JiZmoZ+Lsn6MdAKR1RJwB/NcGbdBskZdxAjR
         WpFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682176319; x=1684768319;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KGnY/HrREypDX51+I0zk+Oky/GDuvb1Orcb4OWwp5ls=;
        b=S5TKCm60HnSnaNSNRH5OuOVEo0Gv6Ak/q+Ley+ACGIb15Upl/VQbArTQd1Bu1ch4OO
         1K+I6t6vgk5AMmW9BFdaO+XfQ29INB//IJ/e3U7z4gdOlQ0AlHMij5QS88LQhDHKdfAC
         hM0d47Z19Vbt5FjAbooylMmrHIEa1h8Op/Yhem6EDo1CjG5KbFrEZ/6cfeimaFilcfIN
         1WK9TozTP9yoeB7b5RbZoCRWfy41zrFzChzc7fr8uDypuzjOdpGMwVN+oDndCvExqKo6
         WBRfmfJsBTgiQq8hApd4tHJlydbwXkWko/gwDWsFkWTpDxdabsYEGyeK2NhKUe+RxLMv
         7C6g==
X-Gm-Message-State: AAQBX9dlATHFnacA7jC5YbOVTGysdNfSwDPy8uT7P89SBOMkZWhgPTxF
        jZiYWc3zsp/771b8uh05XQU=
X-Google-Smtp-Source: AKy350b9xvj9jwrxKJk8V3GRLhVFE2yLWA0V7jX8ItlECpLAB4ADCm//ga8niJK+p4HgdnDYE+u9Xg==
X-Received: by 2002:a5d:428e:0:b0:2f9:b08a:a3af with SMTP id k14-20020a5d428e000000b002f9b08aa3afmr5166473wrq.49.1682176319086;
        Sat, 22 Apr 2023 08:11:59 -0700 (PDT)
Received: from ?IPV6:2a01:c23:bde0:3700:f91a:6f26:d655:eae8? (dynamic-2a01-0c23-bde0-3700-f91a-6f26-d655-eae8.c23.pool.telefonica.de. [2a01:c23:bde0:3700:f91a:6f26:d655:eae8])
        by smtp.googlemail.com with ESMTPSA id b1-20020a5d45c1000000b002fdeafcb132sm6693003wrs.107.2023.04.22.08.11.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Apr 2023 08:11:58 -0700 (PDT)
Message-ID: <d7eaf73b-282a-df7d-d9a5-530e431701a1@gmail.com>
Date:   Sat, 22 Apr 2023 17:11:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Chen Minqiang <ptpt52@gmail.com>, Chukun Pan <amadeus@jmu.edu.cn>,
        Yevhen Kolomeiko <jarvis2709@gmail.com>,
        Alexander Couzens <lynxis@fe80.eu>
References: <cover.1682163424.git.daniel@makrotopia.org>
 <85eb0791bd614ccfdeccdc6fe39be55e602c521c.1682163424.git.daniel@makrotopia.org>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC PATCH net-next 5/8] net: phy: realtek: use phy_read_paged
 instead of open coding
In-Reply-To: <85eb0791bd614ccfdeccdc6fe39be55e602c521c.1682163424.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.04.2023 13:48, Daniel Golle wrote:
> Instead of open coding a paged read, use the phy_read_paged function
> in rtlgen_supports_2_5gbps.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  drivers/net/phy/realtek.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index f97b5e49fae58..62fb965b6d338 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -735,9 +735,7 @@ static bool rtlgen_supports_2_5gbps(struct phy_device *phydev)
>  {
>  	int val;
>  
> -	phy_write(phydev, RTL821x_PAGE_SELECT, 0xa61);
> -	val = phy_read(phydev, 0x13);
> -	phy_write(phydev, RTL821x_PAGE_SELECT, 0);
> +	val = phy_read_paged(phydev, 0xa61, 0x13);
>  
>  	return val >= 0 && val & RTL_SUPPORTS_2500FULL;
>  }

I remember I had a reason to open-code it, it took me some minutes
to recall it.
phy_read_paged() calls __phy_read_page() that relies on phydev->drv
being set. phydev->drv is set in phy_probe(). And probing is done
after matching. __phy_read_paged() should have given you a warning.
Did you test this patch? If yes and you didn't get the warning,
then apparently I miss something.

