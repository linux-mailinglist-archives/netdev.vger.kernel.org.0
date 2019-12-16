Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A661121AB8
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 21:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbfLPUOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 15:14:21 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34710 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbfLPUOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 15:14:19 -0500
Received: by mail-lf1-f68.google.com with SMTP id l18so5232362lfc.1
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 12:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=SBA8qsH74joROaQ7qUDtcV487nsBL4T4WgclmBa0Frc=;
        b=ku4jjLQyhZhXcIGu4nZIjg8rbK20un3MtB+TCOZXShMDtjr2HGOaRu9he7uOTF7Cih
         T3brX3yh+ceFv1ntlhNGLP08m0V9P/WctQ31kCqVPwTi11yHvWDB5zIM2L5gdtJU0t6C
         toL5piqJBqXKVfkIh8mA39aWi5VXl3mGdfXtivjFonFdjVGqYWA8jh0Vc6d9QCyAkARu
         JsEfg1+SXICLbj/4yY8AtlA1Ik7ZG/HN0JzGkdvM1S4w9ncr2eYD6CVNrpouMnS8Sv2w
         5TLiAlvSGrxO3NlzrooXpjw9JCEb10909JKvwfctiyJBYaKdJw18ww6wndKPu+6NMY0+
         zznQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=SBA8qsH74joROaQ7qUDtcV487nsBL4T4WgclmBa0Frc=;
        b=F62lZszr/u7AkS4zwpvlGgqpT7/4PmGBYC39x4+sMGats25yiyhPk4epxULFBF4IpY
         RNduwzDVjVIW4oZnB9xhVd8hz/fuiHbfjbPZk+pDA1Q8TziQv1XO+qDYFf94OI2p/b6k
         Zy4TFrsT6qQTumCWPmN6sMm7u/jB2qFGzsQYe8gSbNfZdBJwfipAusBla5nnUmg3F6e3
         tr2LzxZRyzkKa7XzbBsGBubzdNgTRmJYSr7zcjEGomEQebn484xmu3yc1VSKJwVOeZkn
         qvJopBejUPWkAExN2UzlUGZCu3iq48IOxQ3Xl5aAA0mXAQMlN24fCzBZNLm9qifnkn8W
         U83w==
X-Gm-Message-State: APjAAAWzgUukSc+wxcWCY+RKBRZs+0mg3FFH+uTShKL+NrDfRHOdMUDT
        /JBIxkYrdQOUyS9IEYchfxcMyA==
X-Google-Smtp-Source: APXvYqxKjc/fsBTpIng96/mIdsynKS0oePdJPNDLm9lKBC2UNlCq0QkEhG6AghBZJ/xPXJHMxWvS4w==
X-Received: by 2002:ac2:5635:: with SMTP id b21mr512845lff.127.1576527257085;
        Mon, 16 Dec 2019 12:14:17 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 192sm9615625lfh.28.2019.12.16.12.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 12:14:16 -0800 (PST)
Date:   Mon, 16 Dec 2019 12:14:04 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/4] net: stmmac: Let TX and RX interrupts be
 independently enabled/disabled
Message-ID: <20191216121404.43966b89@cakuba.netronome.com>
In-Reply-To: <BN8PR12MB3266288303A6CA6C3CAA5E6CD3510@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1576007149.git.Jose.Abreu@synopsys.com>
        <04c000a3e0356e8bfb63e07490d8de8e081a2afe.1576007149.git.Jose.Abreu@synopsys.com>
        <20191214123623.1aeb4966@cakuba.netronome.com>
        <BN8PR12MB3266288303A6CA6C3CAA5E6CD3510@BN8PR12MB3266.namprd12.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 09:18:50 +0000, Jose Abreu wrote:
> > > @@ -3759,24 +3777,18 @@ static int stmmac_napi_poll_tx(struct napi_struct *napi, int budget)
> > >  	struct stmmac_channel *ch =
> > >  		container_of(napi, struct stmmac_channel, tx_napi);
> > >  	struct stmmac_priv *priv = ch->priv_data;
> > > -	struct stmmac_tx_queue *tx_q;
> > >  	u32 chan = ch->index;
> > >  	int work_done;
> > >  
> > >  	priv->xstats.napi_poll++;
> > >  
> > > -	work_done = stmmac_tx_clean(priv, DMA_TX_SIZE, chan);
> > > -	work_done = min(work_done, budget);
> > > -
> > > -	if (work_done < budget)
> > > -		napi_complete_done(napi, work_done);
> > > +	work_done = stmmac_tx_clean(priv, budget, chan);
> > > +	if (work_done < budget && napi_complete_done(napi, work_done)) {  
> > 
> > Not really related to this patch, but this looks a little suspicious. 
> > I think the TX completions should all be processed regardless of the
> > budget. The budget is for RX.  
> 
> Well but this is a TX NAPI ... Shouldn't it be limited to prevent CPU 
> starvation ?

It is a bit confusing, but at least netpoll expects the TX completions
to be processed with zero budget. Check out poll_one_napi().
