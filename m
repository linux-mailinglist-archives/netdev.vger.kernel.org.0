Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E335D121ABF
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 21:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfLPUQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 15:16:18 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33101 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbfLPUQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 15:16:18 -0500
Received: by mail-lf1-f65.google.com with SMTP id n25so5248419lfl.0
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 12:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=YLUuImzEeNdgR4wgqVgRBbAIWmyCTwR/wtnyDd3xIaE=;
        b=0EDEWKHIm56j47HaFMM23Z3l1LkmrWmnHY1vwaiC80joIxDNVf68/zHyaL5o/+Lno3
         jS607DFkpV9KSvysbU3IDwbrLZ1mLeiY7CX6/iqErTbFVxleUV8gIyNL+1JgaVcqSFsH
         1nnIVwAmIgGN7cAVMzgm0kfZ4hU+l67/r69M4dIzz2+/43LE/kZ1O2N70G6d4P+AivYw
         knkVpPKaJZlw9y26rrvgYDXTE3UJNnUZI3Zaj144jWyOaLMSMguaaOmz0ZzmHsc9rFcq
         OhTrIg9WMCIvoVT3FX3TXPMmq/qGg3NY4v2qt831uQs7kgAsBUASHHCN2qbpxRFaN3mf
         JInA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=YLUuImzEeNdgR4wgqVgRBbAIWmyCTwR/wtnyDd3xIaE=;
        b=qY5zC1zjSXHRu5Wo/NVhWfI+LZQpwQOM9vykVM6V2q4SOxmR4MLy+Q7QpvJqu+ezEp
         PRjRAih2Ma9H/xu7p/aR/7OEgk27JFj2KHMhci7jLGlspQuZ2qD0QOVU0BeGWjTht2gR
         KdyacWWhgVDyIrBSyaDUUyu+qnnAkd0HPfwreppCBmycvjwjirCpy2OGOA+EpokWhq5q
         zpKODPigsk0HB6CQdpQ5KGjHmCRYubCNet+E3Du6e1nDTKwcZ8saHC0jkTrbN1khkmqn
         smwCVZDVcUvxbDT+EfmV8knpV14eQ0dOVIkHsfRq/no9sVuATx62swfzoWdCsa8LgDn+
         CR7w==
X-Gm-Message-State: APjAAAVpKV+Qc1nW0iJLQyX+eLG0Ed7KuMJLWyQ/GMOdhRnh5QaS2gi5
        5YeQGPoxHJRyRnBubZOMU97UWA==
X-Google-Smtp-Source: APXvYqyt/fVYTuNQcFJk0htjrTxRnckdp1ZR4t6oFaGjxai9lo0wTzQ8KMfd0AAc9f/0dPUfeLqsog==
X-Received: by 2002:ac2:4884:: with SMTP id x4mr559623lfc.92.1576527376259;
        Mon, 16 Dec 2019 12:16:16 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a24sm11015145ljp.97.2019.12.16.12.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 12:16:16 -0800 (PST)
Date:   Mon, 16 Dec 2019 12:16:05 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 4/4] net: stmmac: Always use TX coalesce timer
 value when rescheduling
Message-ID: <20191216121605.4780302d@cakuba.netronome.com>
In-Reply-To: <BN8PR12MB3266BDA48CE9F65D564B0918D3510@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1576007149.git.Jose.Abreu@synopsys.com>
        <23c0ff1feddcc690ee66adebefdc3b10031afe1b.1576007149.git.Jose.Abreu@synopsys.com>
        <20191214122837.4960adfd@cakuba.netronome.com>
        <BN8PR12MB3266BDA48CE9F65D564B0918D3510@BN8PR12MB3266.namprd12.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 09:20:53 +0000, Jose Abreu wrote:
> > > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > index f61780ae30ac..726a17d9cc35 100644
> > > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > @@ -1975,7 +1975,7 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
> > >  
> > >  	/* We still have pending packets, let's call for a new scheduling */
> > >  	if (tx_q->dirty_tx != tx_q->cur_tx)
> > > -		mod_timer(&tx_q->txtimer, STMMAC_COAL_TIMER(10));
> > > +		mod_timer(&tx_q->txtimer, STMMAC_COAL_TIMER(priv->tx_coal_timer));  
> > 
> > I think intent of this code is to re-check the ring soon. The same
> > value of 10 is used in stmmac_tx_timer() for quick re-check.
> > 
> > tx_coal_timer defaults to 1000, so it's quite a jump from 10 to 1000.
> > 
> > I think the commit message leaves too much unsaid.
> > 
> > Also if you want to change to the ethtool timeout value, could you move 
> > stmmac_tx_timer_arm() and reuse that helper?  
> 
> Yeah, it's a quick re-check but 10us can be too low on some speeds and 
> leads to CPU useless-looping. The intent is to let this always be 
> configurable by user.

Okay, please do mention the bump from 10us to the default of 1ms in the
commit message, though.
