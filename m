Return-Path: <netdev+bounces-4105-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B4470AE35
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 15:33:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 419FA1C2091F
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 13:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 421033C38;
	Sun, 21 May 2023 13:33:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376C27EB
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 13:33:36 +0000 (UTC)
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E8B10E;
	Sun, 21 May 2023 06:33:34 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-510b4e488e4so9211058a12.3;
        Sun, 21 May 2023 06:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684676013; x=1687268013;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Ukn0umlPn2JrK3EGjWPUqtC7A/8NyDHErgwepaLDQk=;
        b=FK0H/JPupa6Wz30QQZvH7z4O1UHyoSWCXOByyA0pEzRONm8T8+c9TENH3MrZAloywT
         HMqPL3wh4xvfr4RrfXfPLMlYhmh1csTatUxok571VvtOrQgUi7dn2mPtFSRH97ZMmNNN
         L+8MzOJNrFmGv74u22IQaq9oQo+CbH8YpPju8JMIQUoZDPXL1uxJhHiF8oSjJcPsdOdy
         deD07IjN576P9QWTprUIF/4H33BoXQ0mQ9LEOV5s3oYO+E+fsx9NcBn7xd09gxppJGkn
         5o+AsDl5d5bJWxL9xla3gnD70vIsIaZyvnYe5bGXNzezqQ/ZTjDd7975a2r8TGKFcPML
         uXcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684676013; x=1687268013;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Ukn0umlPn2JrK3EGjWPUqtC7A/8NyDHErgwepaLDQk=;
        b=gSQ7yR/rDYX7QC8WQljy2X9OATylqEhpOPafU/Fq4sBfKr5XfXxGXjCVBAVjp2TpWn
         da4j38BufnapO4z2JagRJRxw3MFz6OYDisAROZtcct+B7poxoJSvLd+m03yMkZ3VNGTY
         XUfoMg5u9d6o9lI6cLYV520ZMLLg2wzbFtqpNLJA7vFXRVcPbyrZfOj2Nrqs5FOyGwzs
         6pH9Bd9LsRVIvuOlau7n7L4eiESVMy9/M4shEWeTgUmEdlKZTdE+L1ZuSmlqvwZ7HH24
         50MqzPzT7Bxbr2R4A3GYxJxkCvPykLaMpkv0DZTO/vhXr5EopYcsO9Ife0jAq7mVo/ej
         1P8w==
X-Gm-Message-State: AC+VfDypi3U1wVqiaDUOgts8UlWJEuiXAwgvO1S1EEofD1zwWFTl0VV3
	FaOemw4ZnNbP2VoLrq/4Tyk=
X-Google-Smtp-Source: ACHHUZ4pzI4HIr30yDlddpH+kpvr8bJj+2OCUyUnb12RV49Nmakn/C4mwP2JSP9VA1LLMzAVsuD+fA==
X-Received: by 2002:a05:6402:686:b0:50b:d5d1:7409 with SMTP id f6-20020a056402068600b0050bd5d17409mr6548202edy.23.1684676012758;
        Sun, 21 May 2023 06:33:32 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id b17-20020aa7c911000000b00502689a06b2sm1837138edt.91.2023.05.21.06.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 May 2023 06:33:32 -0700 (PDT)
Date: Sun, 21 May 2023 16:33:30 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: David Epping <david.epping@missinglinkelectronics.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net 0/3] net: phy: mscc: support VSC8501
Message-ID: <20230521133330.qcr43rq2k7cxxtlt@skbuf>
References: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 20, 2023 at 06:06:00PM +0200, David Epping wrote:
> Since I can only test RGMII mode, and the register is called RGMII,
> my patch is limited to the RGMII mode. However, according to
> Microchip support (case number 01268776) this applies to all modes
> using the RX_CLK (which is all modes?).

I logged into my Microchip support account, but it looks like I can only
view cases which are mine. If they say that bit 11 applies to all PHY
modes where the PHY drives RX_CLK, that would mean MII, GMII and RGMII.

> Since the VSC8502 shares the same description, this would however mean
> the existing code for VSC8502 could have never worked.
> Is that possible? Has someone used VSC8502 successfully?

Yup (with U-Boot pre-initialization though). Thanks for the investigation.

> Other PHYs sharing the same basic code, like VSC8530/31/40/41 don't
> have the clock disabled and the bit 11 is reserved for them.
> Hence the check for PHY ID.
> 
> Should the uncertainty about GMII and MII modes be a source code
> comment? Or in the commit message? Or not mentioned at all?

I think we'd be better off moving the vsc85xx_rgmii_enable_rx_clk() call
outside the "if phy_interface_mode_is_rgmii(phydev->interface)" block,
if that's what Microchip support seems to suggest.

