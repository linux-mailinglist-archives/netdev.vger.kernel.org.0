Return-Path: <netdev+bounces-6000-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67184714538
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 09:06:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2B8B1C20980
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 07:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52722A38;
	Mon, 29 May 2023 07:06:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44555EBD
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:06:38 +0000 (UTC)
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADBA10D
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 00:06:05 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2af2d092d7aso30802291fa.2
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 00:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferroamp-se.20221208.gappssmtp.com; s=20221208; t=1685343963; x=1687935963;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bSGCe5USSQJEGiF5Fy/UcpM812mnZfMtSYhSOl2CPIg=;
        b=yQ2RPOVq3xwqv0kByvZOr7NUoTwGS3KYUBuoFO2EN1/+riLmQQ+gl9KBdbY2XNa2Jm
         yf/5UujrzcXwrAGJIROdbayji0Bh217OowCFGgM9AZJGkReWDmzGiJZq/HjBp+dO3Utt
         AhPlTFhN16867KYDuPmyh3X0WCmxNTzZyye26DI7zoLt7LPAX9pgO92hARHQDTOnW9yn
         d/i3qIv5HKFpEsX8GkhCuaBS2GTwc1zV006/YEnkF12N/WXX1vjpLufIg7fg1cIT6X2Q
         AXa/DLQZ7H0Q8ZMt9TSsnYV40gtDv5CwfyBls1Aw7nxLr0MHiFT4Eb2pH0gnxu8F9H+p
         cOvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685343963; x=1687935963;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bSGCe5USSQJEGiF5Fy/UcpM812mnZfMtSYhSOl2CPIg=;
        b=G0TBaCjOWdaK1X2cbzFTHThL+MTHibBz2AqOXosyLblSpzcjaxOP8d5dYLCahzmQ0P
         ajwYzli33paSSE9wMEwZi85Ai43keRhX8ZhHbMPf6bsw7eR4IbFZLb+QtcqA7Hc1oPyr
         sdrJI6MapW3YeFKfJjMgcnD+3BhmYLM6TQZvXbV8TGYpyLucPgRlEbgj6wTzB8GiiNO+
         zzWhZ1K13uO24mtXUImbPHqn4uqK48h7exTalYB/ix9TDRGIowKEyqH8WoUe7cuq6q1i
         L/lu0hRHJAXHhFkcnfLdrokLIFfGot17iujDQHVosJ7ndxm+5SG8Z3uADlRzAbxvodyM
         cxBQ==
X-Gm-Message-State: AC+VfDxr1v70K4a4OTu/LtP9vcJwdZMA0hBoQBTeXdibz0ULVcJa0gQp
	R11+Sv44gUmgmD6pgecmnakKPA==
X-Google-Smtp-Source: ACHHUZ7ghxvNiBXIZexmU6mGNqC84T8NesjozSmGJVnzo7tfrKT3UAnltzTThAYM5S8QkaTa1ZnIig==
X-Received: by 2002:a2e:7d18:0:b0:2ad:990a:212c with SMTP id y24-20020a2e7d18000000b002ad990a212cmr3309182ljc.32.1685343962830;
        Mon, 29 May 2023 00:06:02 -0700 (PDT)
Received: from debian (151.236.202.107.c.fiberdirekt.net. [151.236.202.107])
        by smtp.gmail.com with ESMTPSA id w5-20020a2e3005000000b002ab017899e8sm2298927ljw.39.2023.05.29.00.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 00:06:02 -0700 (PDT)
Date: Mon, 29 May 2023 09:06:00 +0200
From: =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
To: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
	Woojung.Huh@microchip.com, Nicolas.Ferre@microchip.com,
	Thorsten.Kummermehr@microchip.com
Subject: Re: [PATCH net-next v4 6/6] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Message-ID: <ZHRO2HZdrTzDoOQm@debian>
References: <20230526152348.70781-1-Parthiban.Veerasooran@microchip.com>
 <20230526152348.70781-7-Parthiban.Veerasooran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230526152348.70781-7-Parthiban.Veerasooran@microchip.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 08:53:48PM +0530, Parthiban Veerasooran wrote:
> Add support for the Microchip LAN865x Rev.B0 10BASE-T1S Internal PHYs
> (LAN8650/1). The LAN865x combines a Media Access Controller (MAC) and an
> internal 10BASE-T1S Ethernet PHY to access 10BASE‑T1S networks. As
> LAN867X and LAN865X are using the same function for the read_status,
> rename the function as lan86xx_read_status.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
> ---

Reviewed-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
Tested-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>

