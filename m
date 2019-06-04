Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41BB934E45
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfFDRDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:03:53 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34003 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727716AbfFDRDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:03:52 -0400
Received: by mail-pl1-f196.google.com with SMTP id i2so4246796plt.1
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 10:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7Pf0QicXxfN2srvIq30K2JO0+38qHGngiWlgj1OADl0=;
        b=h7w2TbiEYIfXaRrJKoCCa8gNEzjrXXp8ejuTvMcjjSbjMKe+nxNfho+Hm/Mot9FeDw
         WxR11yii4YnSEzkP7VFGccL2WJcaGqMRwgUSxaIqzpYiOeUEfa+GLDLAnbi4WxeW3LMj
         ZmpMUvbbzwJHyyLbAWkc3ZSBxMGXfCD3d9vpnyQY2qXc+K3G1GvipntZMAdhmLmvxsik
         8gAkpqhAzSDvvFZwUH4gf6ZijA7Lo85a3wgiIHpQzpYuyT/+tKokN3HwUkE9T5sdKFGq
         SR/LAwPMdTb5hyZrCjvDnoHAx2LmdfjBzYUVjbmm2B5ZajZdmaqmVjyv/RemGe5uMyq9
         DKYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7Pf0QicXxfN2srvIq30K2JO0+38qHGngiWlgj1OADl0=;
        b=ZxWNrSuIR+ES/y8kSbO49t6ijC6BVzt/qsBGnrAD28LPqhtXEVvym7YT9RrzAdZwYI
         psX4U4l+yDO/4IlyLEmviqCnd/FHDSAoc58CAC6h3KeZdAwPV8F/TEnpbPfqSCRzvMgz
         gb40daTKdirrNAukUuxbW1wpHgxST2IQ7Fr1nSrHFTO1hUNaKXHiw7bZelmQZaADvNgF
         q82kc8CKcOvOOkrOSxIpPtNj3t3QfUctXehf33ItDqU8fHyKlC90dY3NgdciEr7F+PJD
         QGvVrNR6SWc4NRb3kbAC+V96EhEhEXm9jHFJZvoFBrKrOoBY8XOkbwndI1wi/dqcHEj2
         NFxQ==
X-Gm-Message-State: APjAAAVnI56FywP+oOKBYqpqHPjAIRODldR2RcDES7z9gExjj0tYAh7m
        IJr6w5JE1d+kHcGIItabSLyjwI/K
X-Google-Smtp-Source: APXvYqwCfXzpj+WxfJzbXV8EgxoTInY0YzcmlM78Yj4buLHi8pLgbFkomGL07u2NiCxTt4ukDjoZOA==
X-Received: by 2002:a17:902:5ac9:: with SMTP id g9mr38241540plm.134.1559667832154;
        Tue, 04 Jun 2019 10:03:52 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id a21sm7000077pfc.108.2019.06.04.10.03.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 10:03:51 -0700 (PDT)
Date:   Tue, 4 Jun 2019 10:03:49 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 7/9] mlxsw: spectrum_ptp: Add implementation for
 physical hardware clock operations
Message-ID: <20190604170349.wqsocilmlaisyzar@localhost>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-8-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603121244.3398-8-idosch@idosch.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 03:12:42PM +0300, Ido Schimmel wrote:
> +struct mlxsw_sp_ptp_clock *
> +mlxsw_sp1_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev)
> +{
> +	u64 overflow_cycles, nsec, frac = 0;
> +	struct mlxsw_sp_ptp_clock *clock;
> +	int err;
> +
> +	clock = kzalloc(sizeof(*clock), GFP_KERNEL);
> +	if (!clock)
> +		return ERR_PTR(-ENOMEM);
> +
> +	spin_lock_init(&clock->lock);
> +	clock->cycles.read = mlxsw_sp1_ptp_read_frc;
> +	clock->cycles.shift = MLXSW_SP1_PTP_CLOCK_CYCLES_SHIFT;
> +	clock->cycles.mult = clocksource_khz2mult(MLXSW_SP1_PTP_CLOCK_FREQ_KHZ,
> +						  clock->cycles.shift);
> +	clock->nominal_c_mult = clock->cycles.mult;
> +	clock->cycles.mask = CLOCKSOURCE_MASK(MLXSW_SP1_PTP_CLOCK_MASK);
> +	clock->core = mlxsw_sp->core;
> +
> +	timecounter_init(&clock->tc, &clock->cycles,
> +			 ktime_to_ns(ktime_get_real()));
> +
> +	/* Calculate period in seconds to call the overflow watchdog - to make
> +	 * sure counter is checked at least twice every wrap around.
> +	 * The period is calculated as the minimum between max HW cycles count
> +	 * (The clock source mask) and max amount of cycles that can be
> +	 * multiplied by clock multiplier where the result doesn't exceed
> +	 * 64bits.
> +	 */
> +	overflow_cycles = div64_u64(~0ULL >> 1, clock->cycles.mult);
> +	overflow_cycles = min(overflow_cycles, div_u64(clock->cycles.mask, 3));
> +
> +	nsec = cyclecounter_cyc2ns(&clock->cycles, overflow_cycles, 0, &frac);
> +	clock->overflow_period = nsecs_to_jiffies(nsec);
> +
> +	INIT_DELAYED_WORK(&clock->overflow_work, mlxsw_sp1_ptp_clock_overflow);
> +	mlxsw_core_schedule_dw(&clock->overflow_work, 0);
> +
> +	clock->ptp_info = mlxsw_sp1_ptp_clock_info;
> +	clock->ptp = ptp_clock_register(&clock->ptp_info, dev);
> +	if (IS_ERR(clock->ptp)) {
> +		err = PTR_ERR(clock->ptp);
> +		dev_err(dev, "ptp_clock_register failed %d\n", err);
> +		goto err_ptp_clock_register;
> +	}
> +
> +	return clock;

You need to handle the case where ptp_clock_register() returns NULL...

/**
 * ptp_clock_register() - register a PTP hardware clock driver
 *
 * @info:   Structure describing the new clock.
 * @parent: Pointer to the parent device of the new clock.
 *
 * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
 * support is missing at the configuration level, this function
 * returns NULL, and drivers are expected to gracefully handle that
 * case separately.
 */

Thanks,
Richard
