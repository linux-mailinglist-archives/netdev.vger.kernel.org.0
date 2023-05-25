Return-Path: <netdev+bounces-5429-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFCFC7113CA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:33:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E81F1C20F52
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:33:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DDE7156E2;
	Thu, 25 May 2023 18:32:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2253B1C778
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:32:56 +0000 (UTC)
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5161BD
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:32:39 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4f4b256a0c9so2769411e87.2
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferroamp-se.20221208.gappssmtp.com; s=20221208; t=1685039558; x=1687631558;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iAHUEgbFnw3D+6JImSfMdEZFM4u/CF4elLGMdfBIlgc=;
        b=Wo42d9VzBBKLnUU1SJWAOUQwZWv1Y64O4NtBF3YlMCv6AEBlFq8tkrtf8pHj07RfsE
         Ng4euRAegggoxYNmzyVGvO71F1LpZuDVkJF7hNRFNJE2U8gSRfFYaFmtNG4WccDaOHEB
         QQ2BUrQcmokRX/XBAN1pHmARYFZyGva5dG2h9thT7zu5R+N1EK3zL3JkgrFY+2hKlIYK
         S+OCmHhMhM4Myj2YVTQLKvWRwhkTb/ClLeeugB7obcJUb91LaIz5SdzawWp5rrOGpDst
         ZERr0KxlulSukzHGytEG2rmpvOatmCqnO25jBl+HTMoaaeOb+mugOX2tHKiI+t/+ZNTe
         nUIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685039558; x=1687631558;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iAHUEgbFnw3D+6JImSfMdEZFM4u/CF4elLGMdfBIlgc=;
        b=fnz1FUNj/lk5Ufx0Rr/b+6abbqYa3s1rKJAe9FHUjvX4SLj1EIW6/kFy3ydaTq00eU
         B/iAZAhJkG1xx8qiPEV5l53s/vX7WX4MBfuxad+HPxAZ+kt7CMLqUxQ4dHwKUyE0A4wH
         qCWALHQhtLOG+jiv7UjxFab9oqApBm89akbk4O5oW4R2ZCYr8+AqcxVY9dZSaTVGu0kp
         abgQgEr2z5kppDIyyBNOYAIjpFn6t80zQFOUkt7x6SYAM5cQoGJux0ltixr9PGgJXJGL
         tn52FIVorpVh84tLTDByIK/weymgiDdi1cqkEg/7OZKHVL3yQoy6OTmuW6TjYYGAsWwm
         kb+w==
X-Gm-Message-State: AC+VfDyKafG/GC4EdgV5VZTCKA4Eo/FV1zjZkGyNmu73ZJV2sQolTGGb
	7DXoh1jA+fTh6Mlpp4BKnUDd6A==
X-Google-Smtp-Source: ACHHUZ4nd0TjszyNEI8XdbDYLgJTt3BXQfWREolhBw18gJnnpGwLlJfigp8JqRXQjt1MPNJcM/eEPg==
X-Received: by 2002:ac2:5ddc:0:b0:4f4:b5a8:c24a with SMTP id x28-20020ac25ddc000000b004f4b5a8c24amr3435640lfq.50.1685039558120;
        Thu, 25 May 2023 11:32:38 -0700 (PDT)
Received: from builder (c188-149-203-37.bredband.tele2.se. [188.149.203.37])
        by smtp.gmail.com with ESMTPSA id f7-20020a19ae07000000b004edc72be17csm299567lfc.2.2023.05.25.11.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 11:32:37 -0700 (PDT)
Date: Thu, 25 May 2023 20:32:35 +0200
From: =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
To: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
	Woojung.Huh@microchip.com, Nicolas.Ferre@microchip.com,
	Thorsten.Kummermehr@microchip.com
Subject: Re: [PATCH net-next v3 6/6] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Message-ID: <ZG+pwy/4ZZgUav26@builder>
References: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
 <20230524144539.62618-7-Parthiban.Veerasooran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230524144539.62618-7-Parthiban.Veerasooran@microchip.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 08:15:39PM +0530, Parthiban Veerasooran wrote:
> Add support for the Microchip LAN865x Rev.B0 10BASE-T1S Internal PHYs
> (LAN8650/1). The LAN865x combines a Media Access Controller (MAC) and an
> internal 10BASE-T1S Ethernet PHY to access 10BASE‑T1S networks. As
> LAN867X and LAN865X are using the same function for the read_status,
> rename the function as lan86xx_read_status.
> 
> Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
> ---

Reviewed-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>

