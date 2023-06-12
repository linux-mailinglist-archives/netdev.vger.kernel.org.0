Return-Path: <netdev+bounces-10064-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79B7472BCED
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:43:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 493EA281026
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:43:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E3D5182DD;
	Mon, 12 Jun 2023 09:43:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BCA17ADC
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:43:27 +0000 (UTC)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EEB8212C;
	Mon, 12 Jun 2023 02:43:26 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-9788554a8c9so730358166b.2;
        Mon, 12 Jun 2023 02:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686563004; x=1689155004;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hubj9IqBvYhyeiKXQ+E/srvUx+rB0kgttBCGxXgXiCo=;
        b=fWUJxwuwLWCHh/IiHIX561eSTSxX2XyqEKRftGlIBYV1EERsmY3dh+gLQPcgkHytNl
         7z/t+ndVI8rxFmCjIN50Z3zFw4t91z0wm1D70GSlDOMkRqBWUCvYoKh65F6G50OevdUl
         Hu/ztP80tDRBVYIpNUiDBy/FVuDbJD/O9nBwskyhjkfR9TsPM2OWXWz87wU9YgPZfdAj
         q2U6CWXQV1nFqRLTpULdXoUvaYG0v56mNyQ3iOq3vrcdpDeW196mykcUwPrXOo6lWt26
         r0+401tOw0mNz2iGQWdb+uPvwCQufU44oaGB8SQrbvjv2TBR37tjWvu7byv+VvLvrB6L
         1MNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686563004; x=1689155004;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hubj9IqBvYhyeiKXQ+E/srvUx+rB0kgttBCGxXgXiCo=;
        b=XQLAuF8Jrc7Qkk+0uEqQbaej0zwaOEuem4M2dYpAxM8MTLPeV4Da7aics+AHBQzbp0
         qSiqam/lllOwV47A8m2Ff9E7Hw05uvq+FZDVVWYL6S9NK8exfugbEe2u3VdhxmQrGGao
         AwAHvhf00hslUsnHtw12eTz7MEME4IzNMz72IpMeenkoNXY4MqCQMQZ7P2J1CO+PrlIQ
         ADZilVnRr9ttHEoM3/LAchtu3c7F+KgZ13WSQ32hBAIB9gSMk0D2HjhBXGSQ0OTDqFx2
         wxLj243n9CokNEoOQp7t7mhWGOkulSvFlz+WC8/mHCzlqCjUs4pF8mAM9VnXXh2OcQGO
         X8rg==
X-Gm-Message-State: AC+VfDx332B4hO/+cSgaUkZuEvt1J3lyviPuyjJppX9uPAonzsI5sV25
	AD1U4MvuWiZqURZHWvyRgXQ=
X-Google-Smtp-Source: ACHHUZ4m/c83n7pnUZoqScGpp6ou7gf14PCvyE95XhttJgKuvmDM2Jnorpf8UnrSwOSzbz2qKDWxqg==
X-Received: by 2002:a17:907:320e:b0:974:b15:fce5 with SMTP id xg14-20020a170907320e00b009740b15fce5mr9120869ejb.38.1686563004174;
        Mon, 12 Jun 2023 02:43:24 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id dc18-20020a170906c7d200b0096ace7ae086sm4993883ejb.174.2023.06.12.02.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 02:43:23 -0700 (PDT)
Date: Mon, 12 Jun 2023 12:43:21 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc: Alexis =?utf-8?Q?Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	paul.arola@telus.com, scott.roberts@telus.com
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: implement egress tbf
 qdisc for 6393x family
Message-ID: <20230612094321.vjvj3jnyw7bcnjmw@skbuf>
References: <20230609141812.297521-1-alexis.lothore@bootlin.com>
 <20230609141812.297521-3-alexis.lothore@bootlin.com>
 <d196f8c7-19f7-4a7c-9024-e97001c21b90@lunn.ch>
 <dbec77de-ee34-e281-3dd4-2332116a0910@bootlin.com>
 <176f073a-b5ab-4d8a-8850-fcd8eff65aa7@lunn.ch>
 <bb799b06-8ca8-8a29-3873-af09c859ae88@bootlin.com>
 <CA+sq2CcG4pQDLcw+fTkcEfTZv6zPY3pcGCKeOy8owiaRF2HELA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+sq2CcG4pQDLcw+fTkcEfTZv6zPY3pcGCKeOy8owiaRF2HELA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Sunil,

On Mon, Jun 12, 2023 at 12:04:56PM +0530, Sunil Kovvuri wrote:
> For setting up simple per-port ratelimit, instead of TBF isn't "egress
> matchall" suitable here ?

"matchall" is a filter. What would be the associated action for a
port-level shaper?

