Return-Path: <netdev+bounces-4104-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 872DB70AE2A
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 15:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 140071C20916
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 13:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2870210F;
	Sun, 21 May 2023 13:12:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E557EB
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 13:12:34 +0000 (UTC)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D5DD2;
	Sun, 21 May 2023 06:12:31 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-510d8d7f8eeso8800922a12.0;
        Sun, 21 May 2023 06:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684674749; x=1687266749;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8iBg6fZcsLrOWyeykX+56jGb75hNNV7FJu88HNfeKOU=;
        b=eLCXHvu+AUn1UenGQt31AhojUxR6fg3IytThxncsBLzz+958Qx0MEr/oCAi6XSRVTU
         bBaXK/rwS5gdy2End1Qyqg8DThD7ZMp1KRtfJw3c+lUOocGXyVyK3w27sPfxTHN2/HJS
         +Uo+s/8ZAQjk+AaNxx4I7MIvOQhqri/C0hV4qNCbkg2UuMYqEZAfsYb0xpdBC4IITexT
         31OIDEsgi1xp9iKTG7rXOxqf0IagaK8X2v0bNjdwUMLxI82QaHVlPsAL8kcO0vu7gnlI
         qaBjQY8WKtTb8wLuMP7fF0Ln56MHHCAFTRxPUIVMH4yfshCFethJEVJGqlASfyTg3vZ0
         6VAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684674749; x=1687266749;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8iBg6fZcsLrOWyeykX+56jGb75hNNV7FJu88HNfeKOU=;
        b=Hgig1A8X73kBkTomp05+zOgynCtIgpJR2RY1/3jllxtjRnw+2ogKdJInGKSpPKibVQ
         HvHLtp3vC1lfGZ6KPanoVv2WJqAWx9ni5n+eTrT/0DrVuylo1ipMaaVOJP959SbHxZwU
         sOJgTTNbwTi8HV6p0E3gLZE2XO+7nvsyv8WOpS7hSS0z3eHkyBafc6uU8lecHYw5JI06
         0To6k0phwj5nx2FDMubojZijIyoZYiyW5skX7U4lXHTTK6hMzr7CeXyCGoXiV3IgZEf5
         7rp89Wm9rhFLMI3z1fV8kOrGxz+WAyA+ZAISoF16ggBI3OtqDLaGr6lcM3KfrzW1/KnO
         pIDg==
X-Gm-Message-State: AC+VfDxpaepITJ/uDe/aIFYHGdBI6N5Jsr8tLsCulMslj9FLQxyeOjPM
	XpJYMFjJ21L9GYKpI2pxtmU=
X-Google-Smtp-Source: ACHHUZ6Ae2KA7P/eF3KFKnhVugAaxwTE4acjoeTtAVQ6prvxMnu6ZPmaA2P0rUr4iYlh35bp1KUmCQ==
X-Received: by 2002:aa7:c74c:0:b0:506:bda9:e063 with SMTP id c12-20020aa7c74c000000b00506bda9e063mr5643911eds.16.1684674749177;
        Sun, 21 May 2023 06:12:29 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id o26-20020a056402039a00b00509d1c6dcefsm1842830edv.13.2023.05.21.06.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 May 2023 06:12:28 -0700 (PDT)
Date: Sun, 21 May 2023 16:12:26 +0300
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
Message-ID: <20230521131226.bxk4g5gstprrvngp@skbuf>
References: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-4-david.epping@missinglinkelectronics.com>
 <20230521123512.3kpy66sjnzj2chie@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230521123512.3kpy66sjnzj2chie@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 21, 2023 at 03:35:12PM +0300, Vladimir Oltean wrote:
> Let's resolve that difference before the patches are merged, and write
> some correct comments.
> 
> I agree that the datasheet is not clear, but I think that the RX_CLK
> output is enabled or not based on the strapping of the RCVRDCLK1 and
> RCVRDCLK2 pins. Coincidentally, these are also muxed with PHYADD1 and
> PHYADD2, so the default value of RX_CLK_DISABLE might depend on the
> PHY address (?!).
> 
> What is your PHY address? Mine are 0x10 and 0x11 for the VSC8502 on my
> board.
> 
> Not saying that the patch is wrong or that the resolution should be any
> different than it is. Just that it's clear we can't both be right, and
> my PHYs clearly work (re-tested just now).
> 
> --
> pw-bot: changes-requested

Ah, no, I think the explanation is much simpler. I see the datasheet
mentions that "RX_CLK output disable" is a sticky bit, which means it
preserves its value across a reset.

In my case, it is the U-Boot driver which clears that setting, as part
of configuring RGMII delays.
https://source.denx.de/u-boot/u-boot/-/blob/master/drivers/net/phy/mscc.c#L1553

