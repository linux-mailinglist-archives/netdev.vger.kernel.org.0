Return-Path: <netdev+bounces-5999-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F210714536
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 09:05:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5968F280DC9
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 07:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4523DA38;
	Mon, 29 May 2023 07:05:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A15736D
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:05:50 +0000 (UTC)
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3987B100
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 00:05:03 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2af290cf9b7so29066071fa.3
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 00:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferroamp-se.20221208.gappssmtp.com; s=20221208; t=1685343877; x=1687935877;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kkpXRKBp6tLBV/C8Bc2iFoXX2yo7lYgsiqT8T/fdzBA=;
        b=3+w3QBSMX8zRb5YVZXKdheBnfrEoex1OUJoFkoXtGXbZB1CpDIRkJiDyqNew4vKlnP
         R533l/DmKe0AHcIGDxXz7GpJ0N6krk2teDjFaYD0+7BRNXCKPOX4trTBhXipDmV2YoMy
         QeRQYdndYuz7182GCiSENO1riE1eB/H1eBJc828iNpuZjRpF0hdQSbx59xhBjY4zyH5F
         7yCKf9TtjITxnXmHiTmQjVS1avduUJrWFexqy/HQr7ylLKJq5Li+9lwOjTSKFngtOyB0
         4GgQOn3MNMuoJhfb/Y3T1Ka2/iYLJSxWJGpyGaHcWt3a1vJLpYHVTbQ2b72c5T+9Mcqt
         zncA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685343877; x=1687935877;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kkpXRKBp6tLBV/C8Bc2iFoXX2yo7lYgsiqT8T/fdzBA=;
        b=S1Lvsdhzm+pWUYGWnQ2+2/ERZv9D81xK4+0SRL6Hhgfj/b5QFRdw55ZihxV5kZazaM
         SEK9s2z7tvifuirTsHfIXhtXWlMT880l0cO0j7RMsL/lPN56H6a1Y2E2CR7ZEZBOMEpo
         tFjhlzVOWtKO5o5luZcLOU+mB2BD/QVJq/xom8GSA0VarKg7RoOPhaETUbiWJG0wZUeC
         /CesOxFJO0wjUkXIgnXacSWIGC7GXsvhzJ1k4NhcXkDY3MHNnEOKRdCWtNLgiEYK24Cr
         x7gtdQ7+VEhVsPUEUVZ/EDi2ZC4rQ6KwLGqfuKe88EXPPh1Va3TS1ZNUpgVR9GY0ZhaI
         Sr7g==
X-Gm-Message-State: AC+VfDxRg/nnbWhMH4T1HKqxv+6ZGJEerzfRQopxlkZfW3hFK6Wz35nZ
	rIwJTjj6VdCEauWbX/Pm9/inuA==
X-Google-Smtp-Source: ACHHUZ759hIY68qhR4aOUhfQVilhiuNqBUa4ZOWg+ZqRZeiUOjhzygCc2OgOlVDEPEbtpDkTntQr/A==
X-Received: by 2002:a2e:870d:0:b0:2a8:ba49:a811 with SMTP id m13-20020a2e870d000000b002a8ba49a811mr3931277lji.25.1685343876823;
        Mon, 29 May 2023 00:04:36 -0700 (PDT)
Received: from debian (151.236.202.107.c.fiberdirekt.net. [151.236.202.107])
        by smtp.gmail.com with ESMTPSA id o4-20020a2e9b44000000b002adc5ea2791sm2234119ljj.103.2023.05.29.00.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 00:04:36 -0700 (PDT)
Date: Mon, 29 May 2023 09:04:34 +0200
From: =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
To: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
	Woojung.Huh@microchip.com, Nicolas.Ferre@microchip.com,
	Thorsten.Kummermehr@microchip.com
Subject: Re: [PATCH net-next v4 4/6] net: phy: microchip_t1s: fix reset
 complete status handling
Message-ID: <ZHROghMyWEcJ/4J1@debian>
References: <20230526152348.70781-1-Parthiban.Veerasooran@microchip.com>
 <20230526152348.70781-5-Parthiban.Veerasooran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230526152348.70781-5-Parthiban.Veerasooran@microchip.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 08:53:46PM +0530, Parthiban Veerasooran wrote:
> As per the datasheet DS-LAN8670-1-2-60001573C.pdf, the Reset Complete
> status bit in the STS2 register has to be checked before proceeding to
> the initial configuration. Reading STS2 register will also clear the
> Reset Complete interrupt which is non-maskable.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
> ---

Reviewed-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
Tested-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>

