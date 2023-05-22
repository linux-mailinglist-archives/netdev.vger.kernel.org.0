Return-Path: <netdev+bounces-4196-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE1870B985
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 11:58:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E060280EBE
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE3C2AD4D;
	Mon, 22 May 2023 09:58:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E108279C5
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 09:58:39 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74177A6;
	Mon, 22 May 2023 02:58:38 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f606912ebaso5250865e9.3;
        Mon, 22 May 2023 02:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684749517; x=1687341517;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W4Loc6CfQwOGlHQ/N+c3X6o6eRwQeEfiytZshPv7WsM=;
        b=ZQMBjaGaX/t1rh05LZR38VOoplznkq4BL8Zdg+raQxt3CGA64lcWq05j5c6bbI3LOZ
         XiybUC6oSKseJSf3doqcX6rZ54Jg1mvRQv1vyTfBHt5SQBBsSFoonZKTO+v97HX1E4Ct
         kFmp5GhrCOb+usudkg9r9C1y4rHwbACYPPODPdjOtJlVKmOm7Xs8a2onxUnSbsyblJs1
         1+Qje78KhW3xRk4n0LKTrZAJksa0EtymM+G+N+N99npjwEyWOWltPNY3E7EX7GBAPdxL
         SHSFRibA5nH9g+5w3kuZVuXCfOB6NZAp2jpF6XEwBRSOR5gZb71wU2/3LWGRWF50LusV
         5I3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684749517; x=1687341517;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W4Loc6CfQwOGlHQ/N+c3X6o6eRwQeEfiytZshPv7WsM=;
        b=JXz5NvzP4ev4Sl+mXZbE768GXEiMtcwSxSXXC0ycywj/3MkclFt3DbGDhn2GCE8RKj
         seXrISV/5fR+e5K762g+FUhTF/KgpFdlgbkffP+cJFCkHynlIXGqe1dNdkp4uFJT/Asb
         m2zIZcfhufSLtKaF2IEii21bJROWpL/X8arNGsAg9e/NhumcSmGrbXY8fDJz7BRDE4uT
         b+fWFV6SvTAa813DT/kvsOO3iznfuhBIwmy6ag0mOn7l7rVptEmboFQ7Qphf8S6ZXyyw
         ZWzpQVr1S3TiXQXi6QLj0qEsnqEK6Xo9p4lucUHY1X5px5HwQkYxyYm9S3Kdu6UY3iZg
         JUEg==
X-Gm-Message-State: AC+VfDwr1tNLuOUV9d5HaNGmIs+TvY7NzoxW/Uu2Dq3sE9KeVVwrZWFm
	HQyVrC1V+4uKvuB6HFcYJqs=
X-Google-Smtp-Source: ACHHUZ6iF/eUCoAXzXR05pMd2hvo5chM2UJEMOeSNZyOih1LksOeoXOeUizi8VazDqrVCmd/yLGYFA==
X-Received: by 2002:a05:600c:2119:b0:3f6:4c4:d0c9 with SMTP id u25-20020a05600c211900b003f604c4d0c9mr1192351wml.7.1684749516490;
        Mon, 22 May 2023 02:58:36 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id y5-20020a7bcd85000000b003f6028a4c85sm4588692wmj.16.2023.05.22.02.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 02:58:36 -0700 (PDT)
Date: Mon, 22 May 2023 12:58:33 +0300
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
Message-ID: <20230522095833.otk2nv24plmvarpt@skbuf>
References: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-4-david.epping@missinglinkelectronics.com>
 <20230521134356.ar3itavhdypnvasc@skbuf>
 <20230521161650.GC2208@nucnuc.mle>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230521161650.GC2208@nucnuc.mle>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 21, 2023 at 06:16:50PM +0200, David Epping wrote:
> Since we found an explanation why the current driver works in some
> setups (U-Boot), I would go with the Microchip support statement, that
> writing bit 11 to 0 is required in all modes.
> It would thus stay a separate function, called without a phy mode
> condition, and not be combined with the RGMII skew setting function.

If you still prefer to write twice in a row to the same paged register
instead of combining the changes, then fine by me, it's not a huge deal.

