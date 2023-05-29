Return-Path: <netdev+bounces-5998-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E7FE71452A
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 09:03:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4811E280DC1
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 07:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6381C81E;
	Mon, 29 May 2023 07:03:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58256800
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:03:06 +0000 (UTC)
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62498BE
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 00:02:57 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2afb2874e83so31013561fa.0
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 00:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferroamp-se.20221208.gappssmtp.com; s=20221208; t=1685343775; x=1687935775;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tH8g1ekIg69Qrl0yhVydO5jTTrGC3bGgfrq7vcoo3ls=;
        b=LSzhdOX7vT2a4pcStAvCVH/Ag+2ngZv8HrXWcZyYa+NjdGmaJP+JxtPt3XJJoYhKLZ
         EWkjiJfTe/fWIUnIv12oLEt+nzPO/nF4JDvE0qTVGOdgRG/HlqXH0sfZTgv97hud3eNa
         sa7D/DZn3EqH2GYYP6D7h/E0GfKXZHroU5KM9DOzAlh6XTmTVRGv7vzWlNq4/xaiAob/
         uEcpbSKRGIt6LqGfT/4eUwF72enNjfGla4JUFdsg0e4P6+1tmRKBgZpx5IliDiR9RuCe
         yZjTB0WPUuNneAQirI0WAIk0RwNMUoQYfCMDTuVGJphYaj/lWRayRyDCE7D+ySH/sdxV
         fObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685343775; x=1687935775;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tH8g1ekIg69Qrl0yhVydO5jTTrGC3bGgfrq7vcoo3ls=;
        b=EiVTequBpzOKmYLnE84jdvdzhxNyanWaUXbzkaID7PZibrdXemPRGS6vjuO+PhaW/r
         OHuu3fWwBYi3Yh5udUChZl1gmg2LrAXDpDE5MHaP8YER4t4Su02Iz8VGwi7aP+uqUlle
         hS/pGNNpT7nyd38TFzffm/GZ6/JXvPW1hCi/H6tJ9bQLWeZI8KFhpk1IoxXlblWfAbbA
         wXIgK6CcrhcXo8va91Co9t3HLyjwDAhtEhZBvYXRtQOFKwSSCotWR9qEav+STjtOEYAJ
         g7rLtzAf2UNiANZaoOHi12VMIKXNc2lCif3M0vxCMnd/V9Z8Pb08jtl0nIJdR8xj33T1
         N6cw==
X-Gm-Message-State: AC+VfDxQtmOOv75aiG3XkZgWvostIpfKMfsftwOZFCW0jRdmRPnsOhTg
	RpazVvoSF3B3UVH63+mVVcHMhg==
X-Google-Smtp-Source: ACHHUZ5A2gkiYymrOP+RqHAli0SUin/a2l45wvlc0Gn0Wx+lzYoPnZF4ULp6Pb3j8lqV5xd0R5HtDA==
X-Received: by 2002:a2e:b703:0:b0:2ac:66c8:3c4b with SMTP id j3-20020a2eb703000000b002ac66c83c4bmr3501959ljo.11.1685343775651;
        Mon, 29 May 2023 00:02:55 -0700 (PDT)
Received: from debian (151.236.202.107.c.fiberdirekt.net. [151.236.202.107])
        by smtp.gmail.com with ESMTPSA id a24-20020a2e8618000000b002a76c16ad65sm2348781lji.87.2023.05.29.00.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 00:02:54 -0700 (PDT)
Date: Mon, 29 May 2023 09:02:52 +0200
From: =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
To: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
	Woojung.Huh@microchip.com, Nicolas.Ferre@microchip.com,
	Thorsten.Kummermehr@microchip.com
Subject: Re: [PATCH net-next v4 2/6] net: phy: microchip_t1s: replace
 read-modify-write code with phy_modify_mmd
Message-ID: <ZHROHPboJrIiBy5J@debian>
References: <20230526152348.70781-1-Parthiban.Veerasooran@microchip.com>
 <20230526152348.70781-3-Parthiban.Veerasooran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230526152348.70781-3-Parthiban.Veerasooran@microchip.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 08:53:44PM +0530, Parthiban Veerasooran wrote:
> Replace read-modify-write code in the lan867x_config_init function to
> avoid handling data type mismatch and to simplify the code.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
> ---

Reviewed-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>

