Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA54B1E36C2
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 05:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgE0DzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 23:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728448AbgE0DzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 23:55:13 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F727C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 20:55:13 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x13so11203840pfn.11
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 20:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AEpQAbeW3bEDITSOpqcwnDUrVnTAhNhFKlGaUNISJHo=;
        b=NJ+9QfFPGsAJe27shZeuMIMksUdn1QnJwv/+X6eK+BIvhK2q0mMcdB1kGC6pwhLvhi
         BweLR8FJ5VxOy5VzH/w6GW3PYWQhkZLcnFDQRM7HkED2jG4KM4gl2noyVzq2Iu6GpYlq
         kyzlUmbYTA4MbbhVI5TJ25z2bHQ2jPh2HUGsXnRIUfohpeDUvMtckJcVa4Cf9vKHh03i
         yxvl9aO7plKQXbeN5nh+Ati3ObBL1/KipJuokLVj8TshEGPhhTnoTEfjCPzr/hrU0oQb
         WiFay9RDu05yqcCZ+VZzJd+6JL6jU71Swrl2qT13HM+pRNaewc8BIUnMhy0cliR4HyYC
         EtXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AEpQAbeW3bEDITSOpqcwnDUrVnTAhNhFKlGaUNISJHo=;
        b=Ih07SqZpHhO6VAyQhKbZcmlGDF//OE4SrGfxjGqCYP0d2HYzzI4gU/3GCTY5blpCMn
         +LUQtwA/zPZvu13VhpCMdxBpR9jam5zdVuG9ihUPP1cmt7djcgwPbDafvQHCfGWt+F9v
         FqmXDwGd0ZDsZ+oikZL9aoGkwRXKEupvGQvceT7sSAxArpiZPNXQTl9HVdR1lJQ49c1W
         7QXqDowNaf2+K/q0tDCtWWjpZ+eqgvWTwcwXui4ouZaaTX7M0KTdrIi+Nq8P0v/2M9Kj
         gjVKkQTSltEOq5HOhYzASQs/u2Ig5399a3wySL0vv9b608N+lMTAJm3U32rFASr+cKMS
         26TA==
X-Gm-Message-State: AOAM532pC6eI6yAFGmcbOnsMhJssYAwOw8yt+xMWteUYFLgmJJBRLFoD
        qtFZZlkXjzHyg/pVj4wSIE1WLreolPY=
X-Google-Smtp-Source: ABdhPJyHhK9t6UcA5csl2xuKGN+xrccSmfqfgiqJnL8EoCIVvhnd/HfId7fQAZR+sccu1ao4eZV9Mg==
X-Received: by 2002:a63:5763:: with SMTP id h35mr1949127pgm.98.1590551712795;
        Tue, 26 May 2020 20:55:12 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id jx10sm813746pjb.46.2020.05.26.20.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 20:55:12 -0700 (PDT)
Date:   Tue, 26 May 2020 20:55:09 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Olivier Dautricourt <olivier.dautricourt@orolia.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 3/3] net: stmmac: Support coarse mode through ioctl
Message-ID: <20200527035509.GA18483@localhost>
References: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
 <20200514102808.31163-4-olivier.dautricourt@orolia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514102808.31163-4-olivier.dautricourt@orolia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 12:28:08PM +0200, Olivier Dautricourt wrote:
> The required time adjustment is written in the Timestamp Update registers
> while the Sub-second increment register is programmed with the period
> of the clock, which is the precision of our correction.

I don't see in this patch where the "required time adjustment is
written in the Timestamp Update registers".

What am I missing?

Thanks,
Richard


> 
> The fine adjutment mode is always the default behavior of the driver.
> One should use the HWTSAMP_FLAG_ADJ_COARSE flag while calling
> SIOCGHWTSTAMP ioctl to enable coarse mode for stmmac driver.
> 
> Signed-off-by: Olivier Dautricourt <olivier.dautricourt@orolia.com>
> ---
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c   | 17 +++++++++++++----
>  .../net/ethernet/stmicro/stmmac/stmmac_ptp.c    |  3 +++
>  2 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index c39fafe69b12..f46503b086f4 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -541,9 +541,12 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
>  	netdev_dbg(priv->dev, "%s config flags:0x%x, tx_type:0x%x, rx_filter:0x%x\n",
>  		   __func__, config.flags, config.tx_type, config.rx_filter);
>  
> -	/* reserved for future extensions */
> -	if (config.flags)
> -		return -EINVAL;
> +	if (config.flags != HWTSTAMP_FLAGS_ADJ_COARSE) {
> +		/* Defaulting to fine adjustment for compatibility */
> +		netdev_dbg(priv->dev, "%s defaulting to fine adjustment mode\n",
> +			   __func__);
> +		config.flags = HWTSTAMP_FLAGS_ADJ_FINE;
> +	}
>  
>  	if (config.tx_type != HWTSTAMP_TX_OFF &&
>  	    config.tx_type != HWTSTAMP_TX_ON)
> @@ -689,10 +692,16 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
>  		stmmac_set_hw_tstamping(priv, priv->ptpaddr, 0);
>  	else {
>  		stmmac_get_hw_tstamping(priv, priv->ptpaddr, &value);
> -		value |= (PTP_TCR_TSENA | PTP_TCR_TSCFUPDT | PTP_TCR_TSCTRLSSR |
> +		value |= (PTP_TCR_TSENA |  PTP_TCR_TSCTRLSSR |
>  			 tstamp_all | ptp_v2 | ptp_over_ethernet |
>  			 ptp_over_ipv6_udp | ptp_over_ipv4_udp | ts_event_en |
>  			 ts_master_en | snap_type_sel);
> +
> +		if (config.flags == HWTSTAMP_FLAGS_ADJ_FINE)
> +			value |= PTP_TCR_TSCFUPDT;
> +		else
> +			value &= ~PTP_TCR_TSCFUPDT;
> +
>  		stmmac_set_hw_tstamping(priv, priv->ptpaddr, value);
>  
>  		/* program Sub Second Increment reg */
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
> index 920f0f3ebbca..7fb318441015 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
> @@ -27,6 +27,9 @@ static int stmmac_adjust_freq(struct ptp_clock_info *ptp, s32 ppb)
>  	int neg_adj = 0;
>  	u64 adj;
>  
> +	if (priv->tstamp_config.flags != HWTSTAMP_FLAGS_ADJ_FINE)
> +		return -EPERM;
> +
>  	if (ppb < 0) {
>  		neg_adj = 1;
>  		ppb = -ppb;
> -- 
> 2.17.1
> 
