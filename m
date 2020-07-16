Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA886222D33
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgGPUsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgGPUsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 16:48:35 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18B8C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 13:48:35 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id n5so5451652pgf.7
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 13:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cerP/B8/un1iOxVeiGNeO/HhO78eHY3c4nG7/q3OpsE=;
        b=aepDrEcx4Oyeq1CDcO55Q0F8n0NDKOcO0GU7zmcZHfRzOqjGGDJApdr+NPQmVrV6eN
         prByUhY8YiBm/0yax9iJZTtFS/XnJlos5TNNIVilWEnu+olaWK4/SPUEH3Pe4WPN9sS/
         B59DKfbgGjvsXpLjVolI0vlmKkYk9jY852kzm7nHpYnDW/MxuGv9FBRI6oJjl3BESOCp
         IGI4PtH1T1uCHqfCluDNgB1Kik0m2DmPiorCIwRAUNb2HGop1Ate2oXqzuDiurKdXgUj
         1OGtmFMVRQdOU2rweQdQM7ojzZJD5oM2T5KBnTcz8kGWOUh2aBgOKLMJV+2GI+yTSDVy
         JOsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cerP/B8/un1iOxVeiGNeO/HhO78eHY3c4nG7/q3OpsE=;
        b=kHEsy+SPjr8xsudXwTals5qMVXTAksKoqdY3cKasMD/A76Liu6ahPh9vz5hznZf0Rm
         HjvP9yI0RSJacCuBJXObOrDl85esmJWrnVwCVQ6CrhMyPonHilTOI16o0YbnjSIkGcaE
         6TQ+Np9JgwynackI048EGl8wgVk6yNsEf5cQWMG0dmYTz7cFc+bUByDj26FpgpJub9Xe
         3pgC+KtXkmwCDc2LrGL8sDUdjZmwW3coG//4TKFEfDbZKSsEB61U0sQyxlrMiArI2kog
         Fkcar4lMrks5lDUvWkD60kSBlOnCAC2R1WjW+PZzcQmjYkEDnNZVFt12L5WOEfj8Hd2P
         MBNQ==
X-Gm-Message-State: AOAM532X96NIhchbrOPuv/sh9vXPqn86DcNw3oAyfOMXyunujSU6YJ4J
        vTPppqUOShYn+P/BFlp/b8M=
X-Google-Smtp-Source: ABdhPJx6acwQ8Q5mHEynnu+sN0YkANvW+TNp3ihFCnJaXBBdueMlBzTQtRZrDq0VTCZt83S0MVtqSw==
X-Received: by 2002:a63:d30a:: with SMTP id b10mr5714388pgg.430.1594932515151;
        Thu, 16 Jul 2020 13:48:35 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id u2sm5761199pfl.21.2020.07.16.13.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 13:48:34 -0700 (PDT)
Date:   Thu, 16 Jul 2020 13:48:32 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <20200716204832.GA1385@hoboy>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 05:26:28PM +0100, Russell King wrote:

> With this driver, there appears to be three instances of a ptp_header()
> like function in the kernel - I think that ought to become a helper in
> generic code.

Yes, and the hellcreek DSA driver will add yet another.  I'll be happy
if patches that refactor everything this magically appear!

> +/* Read the status, timestamp and PTP common header sequence from the PHY.
> + * Apparently, reading these are atomic, but there is no mention how the
> + * PHY treats this access as atomic. So, we set the DisTSOverwrite bit
> + * when configuring the PHY.
> + */
> +static int marvell_read_tstamp(struct phy_device *phydev,
> +			       struct marvell_ts *ts,
> +			       uint8_t page, uint8_t reg)
> +{
> +	int oldpage;
> +	int ret;
> +
> +	/* Read status register */
> +	oldpage = phy_select_page(phydev, page);
> +	if (oldpage >= 0) {

Suggest avoiding the IfOk anti-pattern.

> +		ret = __phy_read(phydev, reg);
> +		if (ret < 0)
> +			goto restore;
> +
> +		ts->stat = ret;
> +		if (!(ts->stat & MV_STATUS_VALID)) {
> +			ret = 0;
> +			goto restore;
> +		}
> +
> +		/* Read low timestamp */
> +		ret = __phy_read(phydev, reg + 1);
> +		if (ret < 0)
> +			goto restore;
> +
> +		ts->time = ret;
> +
> +		/* Read high timestamp */
> +		ret = __phy_read(phydev, reg + 2);
> +		if (ret < 0)
> +			goto restore;
> +
> +		ts->time |= ret << 16;
> +
> +		/* Read sequence */
> +		ret = __phy_read(phydev, reg + 3);
> +		if (ret < 0)
> +			goto restore;
> +
> +		ts->seq = ret;
> +
> +		/* Clear valid */
> +		__phy_write(phydev, reg, 0);
> +	}
> +restore:
> +	return phy_restore_page(phydev, oldpage, ret);
> +}


> +/* Check whether the packet is suitable for timestamping, and if so,
> + * try to find a pending timestamp for it. If no timestamp is found,
> + * queue the packet with a timeout.
> + */
> +static bool marvell_ptp_rxtstamp(struct mii_timestamper *mii_ts,
> +				 struct sk_buff *skb, int type)
> +{
> +	struct marvell_ptp *ptp = mii_ts_to_ptp(mii_ts);
> +	struct marvell_rxts *rxts;
> +	bool found = false;
> +	u8 *ptp_hdr;
> +	u16 seqid;
> +	u64 ns;
> +
> +	if (ptp->rx_filter == HWTSTAMP_FILTER_NONE)
> +		return false;
> +
> +	ptp_hdr = ptp_header(skb, type);
> +	if (!ptp_hdr)
> +		return false;
> +
> +	seqid = ptp_seqid(ptp_hdr);
> +
> +	mutex_lock(&ptp->rx_mutex);
> +
> +	/* Search the pending receive timestamps for a matching seqid */
> +	list_for_each_entry(rxts, &ptp->rx_pend, node) {
> +		if (rxts->seq == seqid) {
> +			found = true;
> +			ns = rxts->ns;
> +			/* Move this timestamp entry to the free list */
> +			list_move_tail(&rxts->node, &ptp->rx_free);
> +			break;
> +		}
> +	}
> +
> +	if (!found) {
> +		/* Store the seqid and queue the skb. Do this under the lock
> +		 * to ensure we don't miss any timestamps appended to the
> +		 * rx_pend list.
> +		 */
> +		MARVELL_PTP_CB(skb)->seq = seqid;
> +		MARVELL_PTP_CB(skb)->timeout = jiffies +
> +			msecs_to_jiffies(RX_TIMEOUT_MS);
> +		__skb_queue_tail(&ptp->rx_queue, skb);
> +	}
> +
> +	mutex_unlock(&ptp->rx_mutex);
> +
> +	if (found) {
> +		/* We found the corresponding timestamp. If we can add the
> +		 * timestamp, do we need to go through the netif_rx_ni()
> +		 * path, or would it be more efficient to add the timestamp
> +		 * and return "false" here?
> +		 */

The caller expects the driver to deliver the skb.  If you return the
skb with your hwtstamp value, there is no guarantee that the caller
won't clobber it.

> +		marvell_ptp_rx(skb, ns);
> +	} else {
> +		schedule_delayed_work(&ptp->ts_work, 2);

Instead of using a separate work item, consider combining this with
the counter overflow logic in caps.do_aux_work = marvell_tai_aux_work.
The advantage of do_aux_work is that you get your own kernel thread
which can be given scheduling priority via chrt on busy systems.

> +	}
> +
> +	return true;
> +}


> +/* Check whether the skb will be timestamped on transmit; we only support
> + * a single outstanding skb. Add it if the slot is available.
> + */
> +static bool marvell_ptp_do_txtstamp(struct mii_timestamper *mii_ts,
> +				    struct sk_buff *skb, int type)
> +{
> +	struct marvell_ptp *ptp = mii_ts_to_ptp(mii_ts);
> +	u8 *ptp_hdr;
> +
> +	if (ptp->tx_type != HWTSTAMP_TX_ON)
> +		return false;
> +
> +	if (!(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
> +		return false;
> +
> +	ptp_hdr = ptp_header(skb, type);
> +	if (!ptp_hdr)
> +		return false;
> +
> +	MARVELL_PTP_CB(skb)->seq = ptp_seqid(ptp_hdr);
> +	MARVELL_PTP_CB(skb)->timeout = jiffies +
> +		msecs_to_jiffies(TX_TIMEOUT_MS);
> +
> +	if (cmpxchg(&ptp->tx_skb, NULL, skb) != NULL)
> +		return false;
> +
> +	/* DP83640 marks the skb for hw timestamping. Since the MAC driver
> +	 * may call skb_tx_timestamp() but may not support timestamping
> +	 * itself, it may not set this flag. So, we need to do this here.
> +	 */

The purpose of this flag is to prevent a SW time stamp from being
delivered when the user dialed HW time stamps only.  The PHY driver is
expected to set this flag all by itself regardless of the MAC driver.
Unfortunately the stack doesn't support simultaneous MAC and PHY time
stamping, and so it is up to the MAC driver to avoid setting this flag
when a time stamping PHY is attached.

> +	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> +	schedule_delayed_work(&ptp->ts_work, 2);
> +
> +	return true;
> +}
> +
> +static void marvell_ptp_txtstamp(struct mii_timestamper *mii_ts,
> +				 struct sk_buff *skb, int type)
> +{
> +	if (!marvell_ptp_do_txtstamp(mii_ts, skb, type))
> +		kfree_skb(skb);
> +}
> +
> +static int marvell_ptp_hwtstamp(struct mii_timestamper *mii_ts,
> +				struct ifreq *ifreq)
> +{
> +	struct marvell_ptp *ptp = mii_ts_to_ptp(mii_ts);
> +	struct hwtstamp_config config;
> +	u16 cfg0 = PTP1_PORT_CONFIG_0_DISPTP;
> +	u16 cfg2 = 0;
> +	int err;
> +
> +	if (copy_from_user(&config, ifreq->ifr_data, sizeof(config)))
> +		return -EFAULT;
> +
> +	if (config.flags)
> +		return -EINVAL;
> +
> +	switch (config.tx_type) {
> +	case HWTSTAMP_TX_OFF:
> +		break;
> +
> +	case HWTSTAMP_TX_ON:
> +		cfg0 = 0;
> +		cfg2 |= PTP1_PORT_CONFIG_2_DEPINTEN;
> +		break;
> +
> +	default:
> +		return -ERANGE;
> +	}
> +
> +	switch (config.rx_filter) {
> +	case HWTSTAMP_FILTER_NONE:
> +		break;
> +
> +	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
> +	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
> +	case HWTSTAMP_FILTER_PTP_V2_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
> +		/* We accept 802.1AS, IEEE 1588v1 and IEEE 1588v2. We could
> +		 * filter on 802.1AS using the transportSpecific field, but
> +		 * that affects the transmit path too.
> +		 */
> +		config.rx_filter = HWTSTAMP_FILTER_SOME;

I think you want HWTSTAMP_FILTER_PTP_V2_EVENT here.

From Documentation/networking/timestamping.rst...

   Drivers are free to use a more permissive configuration than the requested
   configuration. It is expected that drivers should only implement directly the
   most generic mode that can be supported. For example if the hardware can
   support HWTSTAMP_FILTER_V2_EVENT, then it should generally always upscale
   HWTSTAMP_FILTER_V2_L2_SYNC_MESSAGE, and so forth, as HWTSTAMP_FILTER_V2_EVENT
   is more generic (and more useful to applications).

   A driver which supports hardware time stamping shall update the struct
   with the actual, possibly more permissive configuration. If the
   requested packets cannot be time stamped, then nothing should be
   changed and ERANGE shall be returned (in contrast to EINVAL, which
   indicates that SIOCSHWTSTAMP is not supported at all).

> +		Cfg0 = 0;
> +		cfg2 |= PTP1_PORT_CONFIG_2_ARRINTEN;
> +		break;
> +
> +	default:
> +		return -ERANGE;
> +	}
> +
> +	err = phy_modify_paged(ptp->phydev, MARVELL_PAGE_PTP_PORT_1,
> +			       PTP1_PORT_CONFIG_0,
> +			       PTP1_PORT_CONFIG_0_DISPTP, cfg0);
> +	if (err)
> +		return err;
> +
> +	err = phy_write_paged(ptp->phydev, MARVELL_PAGE_PTP_PORT_1,
> +			      PTP1_PORT_CONFIG_2, cfg2);
> +	if (err)
> +		return err;
> +
> +	ptp->tx_type = config.tx_type;
> +	ptp->rx_filter = config.rx_filter;
> +
> +	return copy_to_user(ifreq->ifr_data, &config, sizeof(config)) ?
> +		-EFAULT : 0;
> +}


> +int marvell_tai_get(struct marvell_tai **taip, struct phy_device *phydev)
> +{
> +	struct marvell_tai *tai;
> +	unsigned long overflow_ms;
> +	int err;
> +
> +	err = marvell_tai_global_config(phydev);
> +	if (err < 0)
> +		return err;
> +
> +	tai = kzalloc(sizeof(*tai), GFP_KERNEL);
> +	if (!tai)
> +		return -ENOMEM;
> +
> +	mutex_init(&tai->mutex);
> +
> +	tai->phydev = phydev;
> +
> +	/* This assumes a 125MHz clock */
> +	tai->cc_mult = 8 << 28;
> +	tai->cc_mult_num = 1 << 9;
> +	tai->cc_mult_den = 15625U;
> +
> +	tai->cyclecounter.read = marvell_tai_clock_read;
> +	tai->cyclecounter.mask = CYCLECOUNTER_MASK(32);
> +	tai->cyclecounter.mult = tai->cc_mult;
> +	tai->cyclecounter.shift = 28;
> +
> +	overflow_ms = (1ULL << 32 * tai->cc_mult * 1000) >>
> +			tai->cyclecounter.shift;
> +	tai->half_overflow_period = msecs_to_jiffies(overflow_ms / 2);
> +
> +	timecounter_init(&tai->timecounter, &tai->cyclecounter,
> +			 ktime_to_ns(ktime_get_real()));
> +
> +	tai->caps.owner = THIS_MODULE;
> +	snprintf(tai->caps.name, sizeof(tai->caps.name), "Marvell PHY");
> +	/* max_adj of 1000000 is what MV88E6xxx DSA uses */
> +	tai->caps.max_adj = 1000000;
> +	tai->caps.adjfine = marvell_tai_adjfine;
> +	tai->caps.adjtime = marvell_tai_adjtime;
> +	tai->caps.gettimex64 = marvell_tai_gettimex64;
> +	tai->caps.settime64 = marvell_tai_settime64;
> +	tai->caps.do_aux_work = marvell_tai_aux_work;
> +
> +	tai->ptp_clock = ptp_clock_register(&tai->caps, &phydev->mdio.dev);
> +	if (IS_ERR(tai->ptp_clock)) {
> +		kfree(tai);
> +		return PTR_ERR(tai->ptp_clock);
> +	}
> +
> +	ptp_schedule_worker(tai->ptp_clock, tai->half_overflow_period);

ptp_clock_register() can return NULL, and so you should check for that
case before passing tai->ptp_clock here.

 * ptp_clock_register() - register a PTP hardware clock driver
 *
 * @info:   Structure describing the new clock.
 * @parent: Pointer to the parent device of the new clock.
 *
 * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
 * support is missing at the configuration level, this function
 * returns NULL, and drivers are expected to gracefully handle that
 * case separately.

Thanks,
Richard
