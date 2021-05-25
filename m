Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3560E38F805
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhEYCU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhEYCUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 22:20:55 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BB9C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:19:25 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id a7so6890726plh.3
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PtMKv8H8fr0/cGUPfPuqk5XV9KgBYgm65hebSFoOV3s=;
        b=YqbqjeuWsUB5kt3eTTsLdf73fha29fSbbR8U0dPfLee+CaM0lwoqrEq+kGspYq9hTp
         8DZq9ErV3zLOTLkSjYid9FVWsftnR+bKRNXXP1Lx929SEeXz+SbzW9ctaLAENRXhGoYp
         6zMlpsTd3qQix/78VyX6mFDM64AkNFAE1msfTCwpo24/RXN6YrD5CPJuRzYOnz66LSr5
         f9anP+9Uns2cUvTKXUfdS44Cx/cFS6RC7N4hnsyQt9CJTaD79R3pNId9TCHZH0WIhM/s
         qhnq63EAqmGuJF7x4TTkez15Zhhe3cVFZ0MpVbUK9RLzOCckgNkZU2UI3glRwCV1eSOL
         HwHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PtMKv8H8fr0/cGUPfPuqk5XV9KgBYgm65hebSFoOV3s=;
        b=ki47HLn56BJu6faGZpS/OxdHLIHQZPOCkxBWYTDAvHemRojtohsdzTfPtrctk2x3Iy
         ODVyiOFM1BloTyCDxc8yJhaniTjFOkpp3SZUEAjsHSvh+lImtFby3jKwZ3WvUvkSf8Cb
         IiKPgxpEofJRywhODDTS5Ox8OwOH6pjTrG8de5WZsPK2VorQMOr/E2H4yKlpBznjM0hc
         CfPKB/ZHCF/fy1TkfCf3wBNX0iQ4o8lTD5IMugRSOOWpaVmciNAGbIomnuKW+BuYBwLa
         lJpihsJtv80FCIRYr3GLAxDp8ZnpMP5uy3pGQfVO1CFHAhzVCDPDdyHplWY3ym73r/wY
         5r6w==
X-Gm-Message-State: AOAM533m8VLgHzPlm8DpOSfWw9BhMTWSxYEtb3yH/8098m26ep+cWROs
        U0M9B/95jY69ACaG14Df2es=
X-Google-Smtp-Source: ABdhPJww4k2paLPRiHAxnjlbHHeGUZSES6TNWsXllyLTXa7kYh+zH5kBy+ILMMLrZk5uALlfS5iOyA==
X-Received: by 2002:a17:902:ce90:b029:f7:72be:b420 with SMTP id f16-20020a170902ce90b02900f772beb420mr18662583plg.67.1621909165423;
        Mon, 24 May 2021 19:19:25 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e22sm5640744pfl.188.2021.05.24.19.19.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 19:19:24 -0700 (PDT)
Subject: Re: [PATCH net-next 03/13] net: dsa: sja1105: the 0x1F0000 SGMII
 "base address" is actually MDIO_MMD_VEND2
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <65e73b63-2c9b-b847-9221-91f23d2511d3@gmail.com>
Date:   Mon, 24 May 2021 19:19:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210524232214.1378937-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/24/2021 4:22 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Looking at the SGMII PCS from SJA1110, which is accessed indirectly
> through a different base address as can be seen in the next patch, it
> appears odd that the address accessed through indirection still
> references the base address from the SJA1105S register map (first MDIO
> register is at 0x1f0000), when it could index the SGMII registers
> starting from zero.
> 
> Except that the 0x1f0000 is not a base address at all, it seems. It is
> 0x1f << 16 | 0x0000, and 0x1f is coding for the vendor-specific MMD2.
> So, it turns out, the Synopsys PCS implements all its registers inside
> the vendor-specific MMDs 1 and 2 (0x1e and 0x1f). This explains why the
> PCS has no overlaps (for the other MMDs) with other register regions of
> the switch (because no other MMDs are implemented).
> 
> Change the code to remove the SGMII "base address" and explicitly encode
> the MMD for reads/writes. This will become necessary for SJA1110 support.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

[snip]
>  
> @@ -1905,7 +1904,9 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
>  		mac[i].speed = SJA1105_SPEED_AUTO;
>  
>  		if (sja1105_supports_sgmii(priv, i))
> -			bmcr[i] = sja1105_sgmii_read(priv, i, MII_BMCR);
> +			bmcr[i] = sja1105_sgmii_read(priv, i,
> +						     MDIO_MMD_VEND2,
> +						     MDIO_CTRL1);

This appears different from what you had before?
-- 
Florian
