Return-Path: <netdev+bounces-4106-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F06CB70AE3F
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 15:44:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7DD3280F0C
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 13:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1ADB3D76;
	Sun, 21 May 2023 13:44:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9457F33FB
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 13:44:02 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7B7AA;
	Sun, 21 May 2023 06:44:01 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-510e90d785fso5509312a12.2;
        Sun, 21 May 2023 06:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684676639; x=1687268639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sZpvyR57mXeFP0Qm641psPJxyuo/h1ZNJwmOyidkJfY=;
        b=dtajUC7PCeAXr0i98qEMgbSbvz9+wLFlJmCSyIjzkoKKqbQWGVCSdDqQ02Tf9ZMo9X
         SjvQyT+rcpG2A0JMQCBCHCjQrkwGnVhXjWBu4/0bQK0C+WUrdd/Jcnk25qZVNzbcVJaY
         uOT2SvrnMM377XU39AC+GtJk4t8Gslcxxmp+vB+Sekg0MbWUf+0eVlI8jE0Mjt16opss
         up8AYRk8G9CIFr7qk23BbG6uydqnNS7uEMJoLX2juXKPSxCuhIaLlZuMBdDUpLAIe/8P
         sS2wThyIssKp1s8Jnm8xzSqe7z5GIK67MCMYL/R95nmYiMDzIb0JadJq6tGEznk2swF5
         jlyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684676639; x=1687268639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZpvyR57mXeFP0Qm641psPJxyuo/h1ZNJwmOyidkJfY=;
        b=Qo67RR5/Nm6UlH9Mnb95EaYpAx7bTZmc7MfEiJutk+kPW79+Tabkb2MyOwTvUWOOOy
         xjf2/uX61gPSOY3Ts3gUB2keaje+gtTzMvSuE4lGUNGO7smBnmn+hTTBF3Ms/jXH4+Ej
         oVA1ssmso/E65xBdWSrIOBjU/StSowPl15KxN16Dn2O0CoOPoGEpSwyGO4h198A8uUqS
         +r+zAvFwecFgfdSXNDezwU1qvI0qckNxakT/I2iHpHgsauA1E+m/SukVPHbvmQePczOs
         yUIPf+tq5f6JywD3enY1UfD5J1Lq+IqqnhuEcTt0/H9KltWXRzJ6kG8UJMZlCNn2iAAF
         nAaA==
X-Gm-Message-State: AC+VfDy/w5VcE6DCWEL1fABZROxon+LDCSGugVbaU/1FgOV2+k+hPJL/
	1UBJ8aes0ivA0PzpmU3bOrzdm+QDMbc=
X-Google-Smtp-Source: ACHHUZ6s8i/nz0kHAigbvf8YrctI31S/v/qbPm9d7o6kBKJDLRrNaZVogWmEF2pFxyMFalKjd/4G2Q==
X-Received: by 2002:a17:907:7b98:b0:965:ff38:2fb3 with SMTP id ne24-20020a1709077b9800b00965ff382fb3mr7715778ejc.74.1684676639346;
        Sun, 21 May 2023 06:43:59 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id sb8-20020a170906edc800b0096f6e2f4d9esm1875140ejb.83.2023.05.21.06.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 May 2023 06:43:58 -0700 (PDT)
Date: Sun, 21 May 2023 16:43:56 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: David Epping <david.epping@missinglinkelectronics.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net 3/3] net: phy: mscc: enable VSC8501/2 RGMII RX clock
Message-ID: <20230521134356.ar3itavhdypnvasc@skbuf>
References: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-4-david.epping@missinglinkelectronics.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230520160603.32458-4-david.epping@missinglinkelectronics.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 20, 2023 at 06:06:03PM +0200, David Epping wrote:
> +/* For VSC8501 and VSC8502 the RGMII RX clock output is disabled by default. */
> +static int vsc85xx_rgmii_enable_rx_clk(struct phy_device *phydev,
> +				       u32 rgmii_cntl)
> +{
> +	int rc, phy_id;
> +
> +	phy_id = phydev->drv->phy_id & phydev->drv->phy_id_mask;
> +	if (PHY_ID_VSC8501 != phy_id && PHY_ID_VSC8502 != phy_id)
> +		return 0;

Not only bit 11 is reserved for VSC8530, but it's also read-only, so it
should not matter what is written there.

Since vsc85xx_rgmii_enable_rx_clk() and vsc85xx_rgmii_set_skews() write
to the same register, would it not make sense to combine the two into a
single phy_modify_paged() call, and to zeroize bit 11 as part of that?

The other caller of vsc85xx_rgmii_set_skews(), VSC8572, unfortunately
does not document bit 11 at all - it doesn't say if it's read-only or not.
We could conditionally include the VSC8502_RGMII_RX_CLK_DISABLE bit in the
"mask" argument of phy_modify_paged() based on rgmii_cntl == VSC8502_RGMII_CNTL,
such as to exclude VSC8572.

What do you think?

