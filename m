Return-Path: <netdev+bounces-5427-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 216997113B0
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:30:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9FD22815FD
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:30:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56C32125DE;
	Thu, 25 May 2023 18:30:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AA223D41
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:30:37 +0000 (UTC)
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE78125
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:30:31 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4f3bb61f860so2931372e87.3
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferroamp-se.20221208.gappssmtp.com; s=20221208; t=1685039430; x=1687631430;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+YJ/U9yQq7zENy/xeT5OhlkVCIP/m9WLirdWwzeDK4I=;
        b=jklSg68Yjq7Ohsf/zGVOv18G5cs2zXhVUYIHJ9oz41V5C6o9cEHx0aUKecr5ZvoSMz
         bfvuVb+k25HF7HOGe68clM7VAZM/PrDoBpAhleFL9zvFYPvvXvzz8clUm+txJU7XeYw5
         /AdH8wAIROoj0XRklCZKZ2yNmZcXiE2QkHUF+N7ioHqcEFJXPDqY+YuHgrJtBTeIChwF
         xhVUst+NzkjyVjGhtZWA2Ek7XS1/wyfXkSyl8dkYWF3j+9glwpQVhDpY31boqS8kYa9F
         brttZp2s3/JdaEwTHpdtkgl7+Yp+U07XKejie82aCumUh5KB+40AiG29ZQo+6hKp6JOh
         TI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685039430; x=1687631430;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+YJ/U9yQq7zENy/xeT5OhlkVCIP/m9WLirdWwzeDK4I=;
        b=FAezchjsZ4EvUm4i6BiW0y0K2QCMjmlqIvvZy1tZm4lVtRFBXMmogenSntnfe+NvGZ
         jDY2luCmKFbSsCKVRjFmHfuT6UIs0HEq+3qsOTpPvA84uc+3y4rlGpr4cHNybPGYyooa
         1hxbanS/SV83HDKNq24Ndv/M409L+GXPntkrCSbPaKXFUwDwv1yc79IkCfbqEE7eU7fJ
         y/NGb4qLIpUEnF+JcJ/D6jLyK/yMnUshi8SenOCtaecDP81mmKGANfCDNG4OmyA4OHoF
         vgTowm80LXsUboWggA/hQIJVuzUdEZ1hexCExIKQZfxdUtl2+iIh090k3UyvwBNPASB+
         ZRQw==
X-Gm-Message-State: AC+VfDwe0Mfemnc57n2+KnleZxs9Gker0o449kb4Vbpz30Bk1kx/c1Fm
	UbByWx8kNHubkocDIV3On6pUZQ==
X-Google-Smtp-Source: ACHHUZ6GpGNkXqsuXcs2YgoOJsCMXwrX9WEYcj1NNZ2HxN1HKZL1L3M96Tda83v8EXyBwnNG83x1Bg==
X-Received: by 2002:ac2:4299:0:b0:4d8:75f8:6963 with SMTP id m25-20020ac24299000000b004d875f86963mr5769978lfh.38.1685039430204;
        Thu, 25 May 2023 11:30:30 -0700 (PDT)
Received: from builder (c188-149-203-37.bredband.tele2.se. [188.149.203.37])
        by smtp.gmail.com with ESMTPSA id g21-20020ac25395000000b004f3b258feefsm296583lfh.179.2023.05.25.11.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 11:30:29 -0700 (PDT)
Date: Thu, 25 May 2023 20:30:27 +0200
From: =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
To: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
	Woojung.Huh@microchip.com, Nicolas.Ferre@microchip.com,
	Thorsten.Kummermehr@microchip.com
Subject: Re: [PATCH net-next v3 5/6] net: phy: microchip_t1s: remove
 unnecessary interrupts disabling code
Message-ID: <ZG+pQ95pU2yn7LlR@builder>
References: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
 <20230524144539.62618-6-Parthiban.Veerasooran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230524144539.62618-6-Parthiban.Veerasooran@microchip.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 08:15:38PM +0530, Parthiban Veerasooran wrote:
> By default, except Reset Complete interrupt in the Interrupt Mask 2
> Register all other interrupts are disabled/masked. As Reset Complete
> status is already handled, it doesn't make sense to disable it.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
> ---

Reviewed-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
Tested-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>

Testing has been pretty rudamentary, but the procedure has been as
follows:
    * Hotplug 2 devices
    * Unload and reload the lkm
    * Ping 2 devices over ipv6 link local addresses
All testing has been performed with the EVB-LAN8670-USB

