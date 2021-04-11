Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E9E35B5D7
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 17:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbhDKPLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 11:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbhDKPLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 11:11:14 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DE6C061574;
        Sun, 11 Apr 2021 08:10:58 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so8174312pjb.0;
        Sun, 11 Apr 2021 08:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0zyJmgYFpxkhTs/vyxtcrJtWhM0pW8558w941/ZF9cA=;
        b=dNM/qJPcIvjk2GYrFX+iD68pia86U0nkEur8Znqf0zzxhPwx/6/yF3WVQJV+akOxXa
         6nhsJtBR0s1/Zu2MPgihMZm2c9Jy1dDFL62QlsF3+vZxlna0kSEHlNg9uxgKMfDhnGTV
         vabdloE7g/PGvZ7aTGfFD2mqP8RA2hcvUdYDHX8eMNp9yLYcrWlIz1mzFQ2+K1qS0VTk
         FZbcFFqrQF7x4iplkPjXGIyrdaR8alrZIxBPiMdYMWzwGs19tkscKha3htk5Tx6sDT+C
         3lhi5XRgSbZHcWwX2Q+dU9fW0q5t58naYiSYzle8a4eC0gNwEXarUSPgwqMvwpLeo3qq
         nzzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0zyJmgYFpxkhTs/vyxtcrJtWhM0pW8558w941/ZF9cA=;
        b=huJ1SEWSQ0Nc0drCnG7r0lPoK/8m5cXtr497m9SSbqaGFag5XCY+Fwny9LpHBzHqBG
         E6Th8XJupWuuBjlAmLw1wmQBGA9ZUaDDPsQHupEvl+szGfFmWPgWK/AGNLHm9mj3kiNL
         QHgRPj1PPbRtyIALuIsCTxkSkmM7Z6c2Q3MoTD7xnOa/YOY/Sjya0DL+O3sTajK5zp4z
         3sCXjz25C3EyaBINeFPZxpAnusYn8c1r+4gpjO7K9XlUECaXSCGkBxeE/Kh534j+v+3x
         pgchn5ZE0RRiihJfui2Aa+MND0X79ZaUusb95lNCG5Kd0ZpDkvW2hpx8H+1Yhkiv99br
         LFew==
X-Gm-Message-State: AOAM533ohCdb6eeTuQnExZ81nEHMm8NWqIC6g1nA2nTXHMWs6GgqLSoW
        Q715qcPln5nG9Ie+jeWo7uA=
X-Google-Smtp-Source: ABdhPJyxe5QsUTOLJbnqYvFYhhw4EICeQSg4a6tfupQqHJpLeyqg+yKz2Nyebvxe/3ewOWsJ/I0lHg==
X-Received: by 2002:a17:90b:88c:: with SMTP id bj12mr22694484pjb.177.1618153857985;
        Sun, 11 Apr 2021 08:10:57 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id r6sm8355586pgp.64.2021.04.11.08.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 08:10:57 -0700 (PDT)
Date:   Sun, 11 Apr 2021 08:10:55 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/1] net: stmmac: Add support for external
 trigger timestamping
Message-ID: <20210411151055.GA5719@hoboy.vegasvil.org>
References: <20210411024028.14586-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210411024028.14586-1-vee.khee.wong@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 10:40:28AM +0800, Wong Vee Khee wrote:
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> index 60566598d644..60e17fd24aba 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> @@ -296,6 +296,13 @@ static int intel_crosststamp(ktime_t *device,
>  
>  	intel_priv = priv->plat->bsp_priv;
>  
> +	/* Both internal crosstimestamping and external triggered event
> +	 * timestamping cannot be run concurrently.
> +	 */
> +	if (priv->plat->ext_snapshot_en)
> +		return -EBUSY;
> +
> +	mutex_lock(&priv->aux_ts_lock);

Lock, then ...

>  	/* Enable Internal snapshot trigger */
>  	acr_value = readl(ptpaddr + PTP_ACR);
>  	acr_value &= ~PTP_ACR_MASK;
> @@ -321,6 +328,7 @@ static int intel_crosststamp(ktime_t *device,
>  	acr_value = readl(ptpaddr + PTP_ACR);
>  	acr_value |= PTP_ACR_ATSFC;
>  	writel(acr_value, ptpaddr + PTP_ACR);
> +	mutex_unlock(&priv->aux_ts_lock);

unlock, then ...
  
>  	/* Trigger Internal snapshot signal
>  	 * Create a rising edge by just toggle the GPO1 to low
> @@ -355,6 +363,8 @@ static int intel_crosststamp(ktime_t *device,
>  		*system = convert_art_to_tsc(art_time);
>  	}
>  
> +	/* Release the mutex */
> +	mutex_unlock(&priv->aux_ts_lock);

unlock again?  Huh?

> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> index c49debb62b05..abadcd8cdc41 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> @@ -239,6 +239,9 @@ struct stmmac_priv {
>  	int use_riwt;
>  	int irq_wake;
>  	spinlock_t ptp_lock;
> +	/* Mutex lock for Auxiliary Snapshots */
> +	struct mutex aux_ts_lock;

In the comment, please be specific about which data are protected.
For example:

	/* Protects auxiliary snapshot registers from concurrent access. */

> @@ -163,6 +166,43 @@ static void get_ptptime(void __iomem *ptpaddr, u64 *ptp_time)
>  	*ptp_time = ns;
>  }
>  
> +static void timestamp_interrupt(struct stmmac_priv *priv)
> +{
> +	struct ptp_clock_event event;
> +	unsigned long flags;
> +	u32 num_snapshot;
> +	u32 ts_status;
> +	u32 tsync_int;

Please group same types together (u32) in a one-line list.

> +	u64 ptp_time;
> +	int i;
> +
> +	tsync_int = readl(priv->ioaddr + GMAC_INT_STATUS) & GMAC_INT_TSIE;
> +
> +	if (!tsync_int)
> +		return;
> +
> +	/* Read timestamp status to clear interrupt from either external
> +	 * timestamp or start/end of PPS.
> +	 */
> +	ts_status = readl(priv->ioaddr + GMAC_TIMESTAMP_STATUS);

Reading this register has a side effect of clearing status?  If so,
doesn't it need protection against concurrent access?

The function, intel_crosststamp() also reads this bit.

> +	if (!priv->plat->ext_snapshot_en)
> +		return;

Doesn't this test come too late?  Setting ts_status just cleared the
bit used by the other code path.

> +	num_snapshot = (ts_status & GMAC_TIMESTAMP_ATSNS_MASK) >>
> +		       GMAC_TIMESTAMP_ATSNS_SHIFT;
> +
> +	for (i = 0; i < num_snapshot; i++) {
> +		spin_lock_irqsave(&priv->ptp_lock, flags);
> +		get_ptptime(priv->ptpaddr, &ptp_time);
> +		spin_unlock_irqrestore(&priv->ptp_lock, flags);
> +		event.type = PTP_CLOCK_EXTTS;
> +		event.index = 0;
> +		event.timestamp = ptp_time;
> +		ptp_clock_event(priv->ptp_clock, &event);
> +	}
> +}
> +

> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
> index b164ae22e35f..d668c33a0746 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
> @@ -135,9 +135,13 @@ static int stmmac_enable(struct ptp_clock_info *ptp,
>  {
>  	struct stmmac_priv *priv =
>  	    container_of(ptp, struct stmmac_priv, ptp_clock_ops);
> +	void __iomem *ptpaddr = priv->ptpaddr;
> +	void __iomem *ioaddr = priv->hw->pcsr;
>  	struct stmmac_pps_cfg *cfg;
>  	int ret = -EOPNOTSUPP;
>  	unsigned long flags;
> +	u32 intr_value;
> +	u32 acr_value;

Please group same types together.

Thanks,
Richard
