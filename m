Return-Path: <netdev+bounces-10750-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76ACF730184
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:18:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D330D281467
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:18:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E772DDDC4;
	Wed, 14 Jun 2023 14:18:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEECC2C8
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 14:18:48 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29374CD;
	Wed, 14 Jun 2023 07:18:47 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-30af56f5f52so4762389f8f.1;
        Wed, 14 Jun 2023 07:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686752325; x=1689344325;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=D3tehYIm42xn6IneOOUeBNA/YtuO2mEylaC1sAfhrzI=;
        b=pU9p/PHcW4EsK4HI7C5OpL+/n1Mn6H404jyLHg0b55qfoKipiYScehY0aLEjPsNE0n
         hTlAz8k5Rq6Sgd0xei3LeFy/g7cAqrIfR4IYefBVLbHEgcXvijHeiatZgfFOieS0bCME
         K1Wevs/OjMqlH+dFmK6L1Cauctwt7xGQc+BNVPx/CXrTHDKwY7EoCwvsNKMPzmepDS8C
         vC7uh8/cq6UXkbRB+/K3u/RTckdHIqJQdhQPXCNZQ3Nc9u2NAn54+3wM2ibzIlUTkcOE
         6GtRYuNkuCWx8BrwOtzN0/AKQHHtT4ojATlCc1kGePM2JCGNwpBxdtMQarey34Xt2GJG
         fbFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686752325; x=1689344325;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D3tehYIm42xn6IneOOUeBNA/YtuO2mEylaC1sAfhrzI=;
        b=aybHr5vnkgB6JkeIYPpqCAITEq/oU2vjUNWH9VEQHOQx825Y4zGsOsFVTyrdWx4mEb
         HSsmnPUt1YAcjQY6Tf3W8OItWUO4Uo/SzId91GguCdCuLmLbTxxXBIhx1pJZ5mNF2LWa
         X4HMJ+4xR4uDGLF7Xsm0F5IFWKXpFVt6SF/6IVgbP8o9wR15dqFEm+LMA41idZyak0B0
         uzeEij8EV/HKtu6mcSIzxk3PaTidtHw1l5ngGOqqdQXjtPXRybuAryOjQ3R45Rjf0zCt
         AwcSmT7SVd/fpfMN3trSBvfGM2F4gzgef0tda1VtJlQ9x4jzkBjE40KqBaevbbDdtM4t
         oxnw==
X-Gm-Message-State: AC+VfDwGI5vFLAvy3qyvZbZaIld2HJOZptdjhurMSfVuC4zp76W9wJ/O
	MIMQQ1HK8j+EeON+TeGa2qA=
X-Google-Smtp-Source: ACHHUZ7CFktIQYnBooUgoy/VmvR6/Rx8dLtSqGFHp4FzXcBUDcuL4zzpl28fyUyL+ErrtInzpeg6Dw==
X-Received: by 2002:a05:6000:1:b0:310:c670:d110 with SMTP id h1-20020a056000000100b00310c670d110mr1812627wrx.13.1686752325455;
        Wed, 14 Jun 2023 07:18:45 -0700 (PDT)
Received: from Ansuel-xps. (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.gmail.com with ESMTPSA id z18-20020a5d44d2000000b003110dc7f408sm1433466wrr.41.2023.06.14.07.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 07:18:44 -0700 (PDT)
Message-ID: <6489cc44.5d0a0220.47312.6e31@mx.google.com>
X-Google-Original-Message-ID: <ZIltpnzbNda7Inq9@Ansuel-xps.>
Date: Wed, 14 Jun 2023 09:35:02 +0200
From: Christian Marangi <ansuelsmth@gmail.com>
To: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-stm32@st-md-mailman.stormreply.com" <linux-stm32@st-md-mailman.stormreply.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [net-next PATCH v5 4/5] net: ethernet: stmicro: stmmac: generate
 stmmac dma conf before open
References: <20220723142933.16030-1-ansuelsmth@gmail.com>
 <20220723142933.16030-5-ansuelsmth@gmail.com>
 <DM4PR12MB508882D5BE351BD756A7A9A4D35AA@DM4PR12MB5088.namprd12.prod.outlook.com>
 <64898745.5d0a0220.546a.a6f1@mx.google.com>
 <DM4PR12MB508899B25BA18E2E53939BE7D35AA@DM4PR12MB5088.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM4PR12MB508899B25BA18E2E53939BE7D35AA@DM4PR12MB5088.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 01:48:40PM +0000, Jose Abreu wrote:
> From: Christian Marangi <ansuelsmth@gmail.com>
> Date: Wed, Jun 14, 2023 at 03:16:08
> 
> > I'm not following the meaning of leak here. If it's intended as a memory
> > leak then dma_conf is correctly freed in the 2 user of __stmmac_open.
> > 
> > stmmac_init_phy also doesn't seems to use dma_conf. Am I missing
> > something here?
> > 
> 
> Sorry, I should have been clearer: It's not leaking the dma_conf per-se but
> the contents of it: The DMA descriptors. Since the memcpy() is only done after
> init_phy(); if init_phy() fails, then stmmac will never free up the DMA descriptors.
> 
> Does it make sense?
> 

Thanks for the clarification! Sent a follow-up patch that should fix the
possible leak. Would be good if you can also test it for a Tested-by
tag.

-- 
	Ansuel

