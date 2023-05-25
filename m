Return-Path: <netdev+bounces-5421-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49B8271136E
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:15:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF5E51C20F01
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:15:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBC8F21071;
	Thu, 25 May 2023 18:15:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF18F101DA
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:15:19 +0000 (UTC)
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF41B6
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:15:18 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4f3a166f8e9so27606e87.0
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferroamp-se.20221208.gappssmtp.com; s=20221208; t=1685038516; x=1687630516;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xg251fsiIYw3qWTfIcLONfM9uY43qlxM6QeEgD3mLt8=;
        b=XTntDypnh5Uf6CF+MJvG0PSo7eml2QfxU6f594/4SMnkDJFpHclHD41rDmHXdQSfH0
         OV1MOqIqXldWfxIh1+tz+KPpS5LUXeRp3Kc8sGk68XwkBuy51Dk6CgrhNDDi+y/PZcBd
         pXC9+UP9/NjsSkF+erowBk5dTyr9Ch4X+mXRkvwKfIowjw3zWrHuADeOM0FeRq3ccgvi
         oXkdJuIYGuciKVudMn/NhFPwWERFooaVMGHIr2q0ZfeFUMix4/h9LiLGXW5zoiVco8HH
         mwb73qUi21PewJVycMEQyqahFzgV38MCwOG80QUASpNeq5YvqPOlGlSjHwobf85/XrGC
         X/ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685038516; x=1687630516;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xg251fsiIYw3qWTfIcLONfM9uY43qlxM6QeEgD3mLt8=;
        b=Jf8l+KUVpGlhlsI2WovOiUTNMt0eDx40UXFFTUZVayb/rttlZQdvr0gGWO3e12ZfLR
         Mx3eiMVMkGp/LAHvTEqX5WhaWbH7Cq59R0OtBxkGCK1xp2WTSLagjgTNjbLgp8Qybzwo
         1LyOW4RAeAXLdr/KPXvZI3y3U9W1dHwv55Df4iJ0FDbcOxGVp4TKupzwv5+PBgLI1eNP
         D7dMN5PuL2RZxhVUHSxcPF7ax351J07nQlYY53pDK4ypQaqQeRCAvwY+A44+2bTqcFIS
         sdk08BBIi+GCbSvIrtXDiMqg/s20GOsg8spX50CpmQaOK/bQ9yR/vxja9ElkhG6aUvVK
         g9IA==
X-Gm-Message-State: AC+VfDwIthMKshtbU7+MdCCZWBYSyNLpwZIeUy+87+cUFHZsFvLf5Eh7
	qa7rbJLB9IKwZuHUgT/2ktZhqw==
X-Google-Smtp-Source: ACHHUZ6V1Pd2/k+oR65KWLSd1Fk0jZ6weFIFZNcH2/JxGR8nXHwEXZPQd+dccQ37k8dck66vVUBQpA==
X-Received: by 2002:a19:f01a:0:b0:4ee:fdd8:a536 with SMTP id p26-20020a19f01a000000b004eefdd8a536mr1051182lfc.8.1685038516533;
        Thu, 25 May 2023 11:15:16 -0700 (PDT)
Received: from builder (c188-149-203-37.bredband.tele2.se. [188.149.203.37])
        by smtp.gmail.com with ESMTPSA id x7-20020ac25dc7000000b004f155762085sm295649lfq.122.2023.05.25.11.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 11:15:15 -0700 (PDT)
Date: Thu, 25 May 2023 20:15:14 +0200
From: =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
To: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
	Woojung.Huh@microchip.com, Nicolas.Ferre@microchip.com,
	Thorsten.Kummermehr@microchip.com
Subject: Re: [PATCH net-next v3 1/6] net: phy: microchip_t1s: modify driver
 description to be more generic
Message-ID: <ZG+lshBh+eXU47J3@builder>
References: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
 <20230524144539.62618-2-Parthiban.Veerasooran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230524144539.62618-2-Parthiban.Veerasooran@microchip.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 08:15:34PM +0530, Parthiban Veerasooran wrote:
> Remove LAN867X from the driver description as this driver is common for
> all the Microchip 10BASE-T1S PHYs.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
> ---

Reviewed-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>

