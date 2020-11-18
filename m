Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DACF2B827B
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgKRRAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgKRRAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 12:00:52 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AEAC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 09:00:50 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id o21so3772573ejb.3
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 09:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Oh07eUvMLiOXodH14U1r2kLuSGuhGzf0ZnEoBJHem5k=;
        b=KO5xyH4UHWJnlJNFMEIofHlDKbOxA4DsycMQ349wJqVb9JefVR28RxQV1P+XX88eHp
         s9KTiAfe7MZmRArybOIJN6q95Sm0mF6WpmP+TxIezEhMbW+Xy2MFQEnX3NTgenQahuxg
         Y7sZAXnvpGOQlZfELEZlq1SG/hNJaoy4/OtxTAPqbY0Q5S1eYNSJnXUNlsU1rAd7wqwT
         kYn7V9FVrymMnmP15lXEtcuWhzNrvJId9rdDXaBR85mIMyawUH9LyKY9qhL8pVek4XSa
         0xYs/8Eg5KtJVeEelreWEiD1RCYXDNLG8s6W2Qah9zZ01JT6IMeZ1ymhfF+wSm7l953j
         pHqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Oh07eUvMLiOXodH14U1r2kLuSGuhGzf0ZnEoBJHem5k=;
        b=l5tMmTgomELiBtyfj5Q4s6TiYTNG3hl17sVJvbFRwKRpOf/twBhnVvL6m+wlbkdzsN
         3eT6xsEBHqLVhd3RhAqXBdXY7u8mpa3OMte90WXu6F234ZZ1Lq9NJAF7LH1uWio6X/th
         YO/qQnqe0r6UsiBoV6XMJX9dLvohPlkLdEJmSYd6O7xwJIr2Z++CLoVW6r3mKVcSvkRJ
         lfwoY4YTAJpXPNcUFjV6bU9YMu8rMI3nrzvl5CVvqVbCgzQ3oh5j/OpXicpDMvqFc9J/
         eIkZNS0N1GenrrQnjjlK8XxqMWHBwO3rv67+9ZCLeM7TwID2S2XthqUeNGc4ojHC94Vc
         dvnQ==
X-Gm-Message-State: AOAM531tS6nFm2lvqFcTAmiF4SE7hIg6muUxD0NTWKSZ9E7uitAGFR+2
        x/xwe/NCIABGes55s2qj2OA=
X-Google-Smtp-Source: ABdhPJz61ZBKisFl259Cvj8bDlRByALins1PmHimBRHKpj+FXr35nfxTnk0kMiHDtbO89PzK0iDBIQ==
X-Received: by 2002:a17:906:ec9:: with SMTP id u9mr24877291eji.400.1605718849513;
        Wed, 18 Nov 2020 09:00:49 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id u14sm1414258edy.17.2020.11.18.09.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 09:00:48 -0800 (PST)
Date:   Wed, 18 Nov 2020 19:00:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net] enetc: Workaround for MDIO register access issue
Message-ID: <20201118170044.57jlk42gjht3gd74@skbuf>
References: <20201112182608.26177-1-claudiu.manoil@nxp.com>
 <20201117024450.GH1752213@lunn.ch>
 <AM0PR04MB6754D77454B6DA79FB59917896E20@AM0PR04MB6754.eurprd04.prod.outlook.com>
 <20201118133856.GC1804098@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118133856.GC1804098@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 02:38:56PM +0100, Andrew Lunn wrote:
> On Tue, Nov 17, 2020 at 10:22:20AM +0000, Claudiu Manoil wrote:
> > >-----Original Message-----
> > >From: Andrew Lunn <andrew@lunn.ch>
> > >Sent: Tuesday, November 17, 2020 4:45 AM
> > >To: Claudiu Manoil <claudiu.manoil@nxp.com>
> > >Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>; David S .
> > >Miller <davem@davemloft.net>; Alexandru Marginean
> > ><alexandru.marginean@nxp.com>; Vladimir Oltean
> > ><vladimir.oltean@nxp.com>
> > >Subject: Re: [PATCH net] enetc: Workaround for MDIO register access issue
> > >
> > >> +static inline void enetc_lock_mdio(void)
> > >> +{
> > >> +	read_lock(&enetc_mdio_lock);
> > >> +}
> > >> +
> > >
> > >> +static inline u32 _enetc_rd_mdio_reg_wa(void __iomem *reg)
> > >> +{
> > >> +	unsigned long flags;
> > >> +	u32 val;
> > >> +
> > >> +	write_lock_irqsave(&enetc_mdio_lock, flags);
> > >> +	val = ioread32(reg);
> > >> +	write_unlock_irqrestore(&enetc_mdio_lock, flags);
> > >> +
> > >> +	return val;
> > >> +}
> > >
> > >Can you mix read_lock() with write_lock_irqsave()?  Normal locks you
> > >should not mix, so i assume read/writes also cannot be mixed?
> > >
> > 
> > Not sure I understand your concerns, but this is the readers-writers locking
> > scheme. The readers (read_lock) are "lightweight", they get the most calls,
> > can be taken from any context including interrupt context, and compete only
> > with the writers (write_lock). The writers can take the lock only when there are
> > no readers holding it, and the writer must insure that it doesn't get preempted
> > (by interrupts etc.) when holding the lock (irqsave). The good part is that mdio
> > operations are not frequent. Also, we had this code out of the tree for quite some
> > time, it's well exercised.
> 
> Hi CLaidiu
> 
> Thanks for the explanation. I don't think i've every reviewed a driver
> using read/write locks like this. But thinking it through, it does
> seem O.K.

Thanks for reviewing and getting this merged. It sure is helpful to not
have the link flap while running iperf3 or other intensive network
activity.

Even if this use of rwlocks may seem unconventional, I think it is the
right tool for working around the hardware bug.
