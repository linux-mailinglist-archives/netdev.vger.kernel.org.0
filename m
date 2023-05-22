Return-Path: <netdev+bounces-4352-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3223570C2A3
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:42:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E14F11C20ADE
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 288A114ABF;
	Mon, 22 May 2023 15:42:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177DC14AA9
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 15:42:22 +0000 (UTC)
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914F3BB;
	Mon, 22 May 2023 08:42:21 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-96f683e8855so542302166b.2;
        Mon, 22 May 2023 08:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684770140; x=1687362140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R2uvdvik+ZWgrMacuWa8N+oGUBZ4UqdxP/XkyU0vVCU=;
        b=U2JdCWOlAEnxMrpCk0ohuQN/dmFIlp+/a2HFjzth/IhAI4ofWxOMTwC8R/sAE9Nry0
         Mw5JFqba8dRi6JgL65PToml4YMSUQnogCWk8wny9+eHDbeJ5YivWA6p5VWJS1TJA9TIb
         DHUvMOMfbDOnvA/Tj0G+Jpc+3k6TQ0j7y//VvW9+oCMGvjwclp34566ocC/nwPxRicGu
         xWYl58sZ4o1xRR/5+GNcQB4tAmmnFkPr9mHS5jlHrVePZxI30LJ2qJcHPkBDjE2sUfbn
         DNtI91EIfZMR9kxC/I3SW1XTDbYRGJ/c8v9DMmbGKy/o8wyhQ/sgeHWFmxOnDx/gM+vl
         TtSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684770140; x=1687362140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R2uvdvik+ZWgrMacuWa8N+oGUBZ4UqdxP/XkyU0vVCU=;
        b=GcN4tqFre8gdgc+t6mXHNq4bm82yTXZSRsjt2BGC+phNoT/YYPyGDVQWo6SExBdNAk
         Mswd+XtqoUGw6JTTZ+wQ+40GlBVY+4E7V9W7Dive5aJi3zXGGtpOYbfC8x5WDvUx0Msb
         ZzOm8HBHKBboB/Q1F1Bewv5syIIc+Gds7h0QLrEg8Sm1lgZgvxfwpm+BfRkUrp1pxU9H
         cL5JWJT52OiXQCXpc3b7WPz4fahk4P+NRN9iNyx+4uiM1qR9b4pGziRzCBmPovDspV8/
         ZWql6gopydoJaoxPkTpm+FNi1t5AaKTG89rQtVktyp7Ef5Vl/+UuKcHFZdnona0Bbux2
         Vkyg==
X-Gm-Message-State: AC+VfDwZn0gGbYZNIsLuL26Id0gyC7I3XoPjgKrDbGJUsW5cMc9Tn8st
	0L4R8/0rBJUTYtSblngxtzk=
X-Google-Smtp-Source: ACHHUZ4e+/grE6eeyjke4A9GPCdARoK2xdjM92TMhGaC/BxZNe9NDxwRznvQX09oc39D9LhbOhII4g==
X-Received: by 2002:a17:907:2da7:b0:970:10a9:3ca8 with SMTP id gt39-20020a1709072da700b0097010a93ca8mr1576740ejc.22.1684770139610;
        Mon, 22 May 2023 08:42:19 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id w20-20020a170907271400b0096a16761ab4sm3279674ejk.144.2023.05.22.08.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 08:42:19 -0700 (PDT)
Date: Mon, 22 May 2023 18:42:17 +0300
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
Message-ID: <20230522154217.ganjnt2bng5wxng6@skbuf>
References: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-4-david.epping@missinglinkelectronics.com>
 <20230521134356.ar3itavhdypnvasc@skbuf>
 <20230521161650.GC2208@nucnuc.mle>
 <20230522095833.otk2nv24plmvarpt@skbuf>
 <20230522140057.GB18381@nucnuc.mle>
 <20230522151104.clf3lmsqdndihsvo@skbuf>
 <20230522152221.GA21090@nucnuc.mle>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522152221.GA21090@nucnuc.mle>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 05:22:21PM +0200, David Epping wrote:
> > > Also we don't want to enable for
> > > all PHY types, and the differentiation is already available at the
> > > caller. I would thus opt for a separate function and fewer conditional
> > > statements.
> > 
> > I don't understand this. We don't? For what PHY types don't we want to
> > enable the RX_CLK?
> 
> I meant all PHYs using vsc85xx_rgmii_set_skews() via vsc8584_config_init().

Aha. By "PHY types" I thought you mean "PHY interface types" like RGMII/GMII/MII,
not PHY device models.

> As you pointed out they don't have a clear definition of what bit 11 means
> for them.

And I wasn't suggesting to make bit 11 part of the modified "mask" for them.

> But we can easily differentiate using the condition you suggested.
> I'll do that for the new patch version.

Sounds good, thanks.

