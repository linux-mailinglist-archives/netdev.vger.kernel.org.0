Return-Path: <netdev+bounces-7986-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74E7872259D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:25:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1ADB1C209A5
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:25:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E49718B0C;
	Mon,  5 Jun 2023 12:25:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D8F525E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:25:35 +0000 (UTC)
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC58F7
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 05:25:27 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-30ae69ef78aso4365695f8f.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 05:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685967925; x=1688559925;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sJB4I9XF3euDnetyF47YxxSCps0bNVDe3GpO+Wob5AY=;
        b=IUTtSbUe2dNmMuBUScQfzzUcpClRRyti0mt/hCFNuXOT31Iwwvz0vWwrX380xgHMtT
         MKA32M+HuenCPi8hltngWGss3PwYoOQDI6fK6Z4nBf/s8+wfVrJ38DDsIH2y0pgLoScU
         MfTCHhntcDybEKFOO7gPtA99XX2oy0gmvdihhGCgt9wRVbc6hnE0Zatn+kejanB4Jhjc
         R8TOZhpzdX4xWDoMVRMSiknd/SFoL7EWVtZ6FmOkRzasaYw0dnBhia0qCVY58ttkaMLC
         lg3cpHZlw0gxJ30TXs4/zsq+JAia2RQif7U1rdlNUwmUq/eC9jshPLwhZ3lMuH2Kbto/
         b0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685967925; x=1688559925;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sJB4I9XF3euDnetyF47YxxSCps0bNVDe3GpO+Wob5AY=;
        b=REO/4U7C1PzMkIyJfhzCwlgzVbjXmxxEQwJwJy+JrsiQ0tfq87NPuotH3wEoG+Ut6G
         jRFKVXdnh0po3hRTtE6FqUvbM1fXGob56oGUA2Yg5H+2H2ToreqY3ZciwwxauCzG9I2z
         GMwh0QqV5kAa5YNDavqKGJ6ImDtMafWDBRuVxZQ3jydiiuhzpp6Qvw/4r1ExMNPhFiy6
         lLMR1dqFEHO3RJpvvDge3/vpr85iwcnE71ueGsOJ02vCIfS5A2iJma+0S82DWrVvt5FB
         Nere7yG4l9rAxCnM/qTsrG6IFv14qD5/7+fCco7wHALVY42Mp4ymYDRQwrXrSVCoDbh1
         LQOg==
X-Gm-Message-State: AC+VfDyCFJO0XyVEkPKuPR1uOvjVg4+otp1ISNlgSviF4uIyBhWAWTFz
	e0CgNjLbKtMTBPXjgPn91dk=
X-Google-Smtp-Source: ACHHUZ6s/ij7cM9WeaAPFlRfVdBagH860ZsDeF5xmcrIMoazOKE3CcfBCYObALQa+Qx2Zn04Y8UFSg==
X-Received: by 2002:adf:cf04:0:b0:30a:ea65:6676 with SMTP id o4-20020adfcf04000000b0030aea656676mr6086726wrj.23.1685967925426;
        Mon, 05 Jun 2023 05:25:25 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id u16-20020a05600c211000b003f4fe09aa43sm14309999wml.8.2023.06.05.05.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 05:25:25 -0700 (PDT)
Date: Mon, 5 Jun 2023 15:25:23 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: QUSGMII control word
Message-ID: <20230605122523.a6hrfyt43xblnnac@skbuf>
References: <ZHnd+6FUO77XFJvQ@shell.armlinux.org.uk>
 <20230605081334.3258befa@pc-7.home>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605081334.3258befa@pc-7.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 08:13:34AM +0200, Maxime Chevallier wrote:
> Hello Russell,
> 
> On Fri, 2 Jun 2023 13:18:03 +0100
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> 
> > Hi Maxime,
> > 
> > Looking at your commit which introduced QUSGMII -
> > 5e61fe157a27 ("net: phy: Introduce QUSGMII PHY mode"), are you sure
> > your decoding of the control word is correct?
> > 
> > I've found some information online which suggests that QUSGMII uses a
> > slightly different format to the control word from SGMII. Most of the
> > bits are the same, but the speed bits occupy the three bits from 11:9,
> > and 10M, 100M and 1G are encoded using bits 10:9, whereas in SGMII
> > they are bits 11:10. In other words, in QUSGMII they are shifted one
> > bit down. In your commit, you used the SGMII decoder for QUSGMII,
> > which would mean we'd be picking out the wrong bits for decoding the
> > speed.
> > 
> > QUSGMII also introduces EEE information into bits 8 and 7 whereas
> > these are reserved in SGMII.
> > 
> > Please could you take a look, because I think we need a different
> > decoder for the QUSGMII speed bits.
> 
> I've taken a look at it, back when I sent that patch I didn't have
> access to the full documentation and used a vendor reference
> implementation as a basis... I managed to get my hands on the proper
> doc and the control word being used looks to be the usxgmii control
> word, which matches with the offset you are seeing.

Just to be on the same page with everyone regarding what Q-USGMII is.

Commit 5e61fe157a27 ("net: phy: Introduce QUSGMII PHY mode") says that
phy-mode "qusgmii" is a derivative of phy-mode "usxgmii". I don't think
that wording was particularly helpful.

I've downloaded the 3 specifications at
https://developer.cisco.com/site/usgmii-usxgmii/, and it says that
4-port Q-USGMII is capable of speeds 10/100/1000 over each port, with
a maximum SERDES speed of 10 Gbps, and with the 8b/10b coding. But
phylink_interface_max_speed() lists PHY_INTERFACE_MODE_QUSGMII as
supporting 10G per port, which is also incorrect in addition to what
Russell already noticed about the in-band autoneg code word.

The autoneg message is indeed structurally similar to the autoneg
message from USXGMII, save for the fact that speed encodings (bits 11:9)
higher than 1G are reserved. Also (big difference), USXGMII uses the
64b/66b coding scheme rather than the 8b/10b of USGMII / Q-USGMII.

I hope there is no confusion between Q-USGMII and the quad-port variant
of USXGMII: 10G-QXGMII! The latter also uses a SERDES speed of 10.3125
Gbps, but individual port speeds are 10/100/1000/2500, and the coding
scheme is 64b/66b. 10G-QXGMII is what I would think of as the quad-port
derivative of USXGMII...

