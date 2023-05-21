Return-Path: <netdev+bounces-4101-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA1E70AE0A
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 14:28:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE0BF1C20965
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 12:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D093220F3;
	Sun, 21 May 2023 12:28:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19621FA6
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 12:28:29 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B23BB3;
	Sun, 21 May 2023 05:28:27 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-96f7bf3cf9eso408507966b.0;
        Sun, 21 May 2023 05:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684672106; x=1687264106;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1SrGFQtR2jiBR6ysezi7MycwJOIv0m56h1P8LCgkbX4=;
        b=EIUZcwdNlNCdeOJ7lY2J6ICLaA5DzISDaGP6+U3EsSqS09Nf9+ELbrDd9BAx9p0T8Y
         WJuQdtuVsJTDfC2Bv/tAwZYM6OVAAnw3WKKhdfgF4LKmIr6/uK1WhstC6LLlvAEeRB8r
         9lCXmV54LuUdVtAFN1pVwkaIoPedcmtscnugkb+YLX4QfB2ueuMxItSfLJESOwylN5Kd
         /5k/AW1VWd66i2HRDm6TjkTXXFnuumPYYibeQWRWMqo77P3Z0tsh5QZVLrW1Urp5wt/D
         +rydJHTb6MOWID2dHrfw1Yq/H7DAWJ2FXHnpdP/ALKe2zirLkg7JUaQ0g1X9Mgyf7I+b
         UL3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684672106; x=1687264106;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1SrGFQtR2jiBR6ysezi7MycwJOIv0m56h1P8LCgkbX4=;
        b=Xsip5joZYykaDESA36u/eN8UUzTmvXC1eXHAQId/Ye0LRBb2yttwmAY8RXj0f3590v
         I/Yahu2MTrnBsOr/Blx7t6KTO6FuOg84Q0uxU9Zw+Il4U3ifTjadbPhdmPNJXloSaKrX
         u96bW+UbDu1JtZ6TmMfDTmx3VoA6D2X2Ch0lJYs8HVzHW0IHfAkWRrG7YYS6EgGDB3x0
         MCazfCWWUMYpI3q2h5MkoNnu5IKCZLsIkI5YkVsREfLYt0mLyyBaUZj+0F/GdKD/zyBr
         eBKS9CiAST/fVDMLID1Pf3m/X/alvWwYP8tqG4zNWDQKIwR3J4WszYC49enqbksKw8uI
         PkkQ==
X-Gm-Message-State: AC+VfDxtq0BMHtHo3HwUFkHWSKPgmyc36Kq7lg07P9tFh2NPEU6X1QiS
	Mfgp4htpaMl+idgliQtQgLY=
X-Google-Smtp-Source: ACHHUZ4Lg3T1HkqC4oBAASfdnSlYiDAfj8JP5QSVyd9TcAidFxOIvNQ0h35wBc/8ikPrfm7Ex6DDUA==
X-Received: by 2002:a17:907:3e92:b0:969:e88a:6071 with SMTP id hs18-20020a1709073e9200b00969e88a6071mr7055554ejc.61.1684672105517;
        Sun, 21 May 2023 05:28:25 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id i7-20020a170906444700b00965aee5be9asm1855407ejp.170.2023.05.21.05.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 May 2023 05:28:25 -0700 (PDT)
Date: Sun, 21 May 2023 15:28:23 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: David Epping <david.epping@missinglinkelectronics.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net 1/3] net: phy: mscc: add VSC8502 to
 MODULE_DEVICE_TABLE
Message-ID: <20230521122823.6hrwkaqusu27isdz@skbuf>
References: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-2-david.epping@missinglinkelectronics.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230520160603.32458-2-david.epping@missinglinkelectronics.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 20, 2023 at 06:06:01PM +0200, David Epping wrote:
> The mscc driver implements support for VSC8502, so its ID should be in
> the MODULE_DEVICE_TABLE for automatic loading.
> 
> Signed-off-by: David Epping <david.epping@missinglinkelectronics.com>
> ---

Fixes: d3169863310d ("net: phy: mscc: add support for VSC8502")
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Please carry these tags with future revisions of the patches.

