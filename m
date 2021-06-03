Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E202439A21B
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 15:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhFCNYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 09:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhFCNYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 09:24:41 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBBBC06174A;
        Thu,  3 Jun 2021 06:22:41 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id k7so3619957pjf.5;
        Thu, 03 Jun 2021 06:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EdFWekv+S9XseyODwpuYcxtZCECIyzKMWt6NYM6pA6o=;
        b=q3CpbYePhZFCKQyKzpR9O/WbO+aQW/35/DrvcLr+gsK/WjVnHXuZ3JCGrGS02sJlel
         mZRujAxWHOb9vJWkKgnGGT3E3NjWc/FzukLeRBdz0IsoI8Ff7poK+R3INTgcKjgpyVeT
         shKsCSAaavdga8v7+EKmiSW8JEcy0hYqbX4dQpgQiN2enk2tnFqLFXb0p+liLs8oppcW
         XAspeQYNn7eY+sqsEURi7tpeb+fR6cLLzWpOZ8l8QWENBCj/Ek1aVtePJHOXM62fq7WE
         hmqP7wbz9/AdUPuEAZcu3jxtvNWKEzwWLGmhqK4PAN0qQEWBc47ZHtvTgfP81IrBafxy
         1MUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EdFWekv+S9XseyODwpuYcxtZCECIyzKMWt6NYM6pA6o=;
        b=ijXN7KFg/f65Rq3boXl2/nssuFQJ8aeBagHoM0SV6ld64aZTWeAvmVWnDK3fvO1opX
         N5zczwJy0oYyYeccz3xgsmbEU67Ckl7SmfVr7mSvM+cllKrF2Rz8UmOhGKWi0awCVUKR
         lRgCzx7VQq/fUqesJiecbiuzOVeLXPci3/j39IZoCLMOCHWZprTnpsD4PPSM4bdMyQNf
         6XABi/LneyFclCdGyrTCKOxFnDlYLYh4jhs3+Jxj191a817xSiDWinFqdrpCf7qAKSX1
         SRGg4bz45gtn+DP3j4B91L+A9u3BlEyFgQQkCqZWf0jobo+22XOW051dqGfT9JtONuSH
         9ojw==
X-Gm-Message-State: AOAM532FPgu7l2Aj+2L/KrefHEUydxQiK3uSMFzJ7/Ztd0Cj6pDeAQlm
        0FftHM6ZFhiyOF3Uxjd0F90=
X-Google-Smtp-Source: ABdhPJzr5BSe4uNH/RTMcJdkjA1JHCHiK+s1p78DLpMajlqEaCc36oGuZE/dfjMDQ/pJVOMCV8awpw==
X-Received: by 2002:a17:90a:fee:: with SMTP id 101mr11549610pjz.230.1622726561095;
        Thu, 03 Jun 2021 06:22:41 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id w14sm2424138pjf.12.2021.06.03.06.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 06:22:40 -0700 (PDT)
Date:   Thu, 3 Jun 2021 06:22:37 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, salil.mehta@huawei.com,
        lipeng321@huawei.com, tanhuazhong@huawei.com
Subject: Re: [RESEND net-next 1/2] net: hns3: add support for PTP
Message-ID: <20210603132237.GC6216@hoboy.vegasvil.org>
References: <1622602664-20274-1-git-send-email-huangguangbin2@huawei.com>
 <1622602664-20274-2-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622602664-20274-2-git-send-email-huangguangbin2@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 10:57:43AM +0800, Guangbin Huang wrote:

> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
> new file mode 100644
> index 000000000000..b133b5984584
> --- /dev/null
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
> @@ -0,0 +1,520 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +// Copyright (c) 2021 Hisilicon Limited.
> +
> +#include <linux/skbuff.h>
> +#include "hclge_main.h"
> +#include "hnae3.h"
> +
> +static int hclge_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
> +{
> +	struct hclge_dev *hdev = hclge_ptp_get_hdev(ptp);
> +	u64 adj_val, adj_base, diff;
> +	bool is_neg = false;
> +	u32 quo, numerator;
> +
> +	if (ppb < 0) {
> +		ppb = -ppb;
> +		is_neg = true;
> +	}
> +
> +	adj_base = HCLGE_PTP_CYCLE_ADJ_BASE * HCLGE_PTP_CYCLE_ADJ_UNIT;
> +	adj_val = adj_base * ppb;
> +	diff = div_u64(adj_val, 1000000000ULL);
> +
> +	if (is_neg)
> +		adj_val = adj_base - diff;
> +	else
> +		adj_val = adj_base + diff;
> +
> +	/* This clock cycle is defined by three part: quotient, numerator
> +	 * and denominator. For example, 2.5ns, the quotient is 2,
> +	 * denominator is fixed to HCLGE_PTP_CYCLE_ADJ_UNIT, and numerator
> +	 * is 0.5 * HCLGE_PTP_CYCLE_ADJ_UNIT.
> +	 */
> +	quo = div_u64_rem(adj_val, HCLGE_PTP_CYCLE_ADJ_UNIT, &numerator);
> +	writel(quo, hdev->ptp->io_base + HCLGE_PTP_CYCLE_QUO_REG);
> +	writel(numerator, hdev->ptp->io_base + HCLGE_PTP_CYCLE_NUM_REG);
> +	writel(HCLGE_PTP_CYCLE_ADJ_UNIT,
> +	       hdev->ptp->io_base + HCLGE_PTP_CYCLE_DEN_REG);
> +	writel(HCLGE_PTP_CYCLE_ADJ_EN,
> +	       hdev->ptp->io_base + HCLGE_PTP_CYCLE_CFG_REG);

Need mutex or spinlock to protest against concurrent access.

> +
> +	return 0;
> +}
> +
> +bool hclge_ptp_set_tx_info(struct hnae3_handle *handle, struct sk_buff *skb)
> +{
> +	struct hclge_vport *vport = hclge_get_vport(handle);
> +	struct hclge_dev *hdev = vport->back;
> +	struct hclge_ptp *ptp = hdev->ptp;
> +
> +	if (!test_bit(HCLGE_PTP_FLAG_TX_EN, &ptp->flags) ||
> +	    test_and_set_bit(HCLGE_STATE_PTP_TX_HANDLING, &hdev->state)) {
> +		ptp->tx_skipped++;
> +		return false;
> +	}
> +
> +	ptp->tx_start = jiffies;
> +	ptp->tx_skb = skb_get(skb);
> +	ptp->tx_cnt++;
> +
> +	return true;
> +}
> +
> +void hclge_ptp_clean_tx_hwts(struct hclge_dev *hdev)
> +{
> +	struct sk_buff *skb = hdev->ptp->tx_skb;
> +	struct skb_shared_hwtstamps hwts;
> +	u32 hi, lo;
> +	u64 ns;
> +
> +	ns = readl(hdev->ptp->io_base + HCLGE_PTP_TX_TS_NSEC_REG) &
> +	     HCLGE_PTP_TX_TS_NSEC_MASK;
> +	lo = readl(hdev->ptp->io_base + HCLGE_PTP_TX_TS_SEC_L_REG);
> +	hi = readl(hdev->ptp->io_base + HCLGE_PTP_TX_TS_SEC_H_REG) &
> +	     HCLGE_PTP_TX_TS_SEC_H_MASK;
> +	hdev->ptp->last_tx_seqid = readl(hdev->ptp->io_base +
> +		HCLGE_PTP_TX_TS_SEQID_REG);
> +
> +	if (skb) {
> +		hdev->ptp->tx_skb = NULL;
> +		hdev->ptp->tx_cleaned++;
> +
> +		ns += (((u64)hi) << 32 | lo) * NSEC_PER_SEC;
> +		hwts.hwtstamp = ns_to_ktime(ns);
> +		skb_tstamp_tx(skb, &hwts);
> +		dev_kfree_skb_any(skb);
> +	}
> +
> +	clear_bit(HCLGE_STATE_PTP_TX_HANDLING, &hdev->state);
> +}
> +
> +void hclge_ptp_get_rx_hwts(struct hnae3_handle *handle, struct sk_buff *skb,
> +			   u32 nsec, u32 sec)
> +{
> +	struct hclge_vport *vport = hclge_get_vport(handle);
> +	struct hclge_dev *hdev = vport->back;
> +	u64 ns = nsec;
> +	u32 sec_h;
> +
> +	if (!test_bit(HCLGE_PTP_FLAG_RX_EN, &hdev->ptp->flags))
> +		return;
> +
> +	/* Since the BD does not have enough space for the higher 16 bits of
> +	 * second, and this part will not change frequently, so read it
> +	 * from register.
> +	 */
> +	sec_h = readl(hdev->ptp->io_base + HCLGE_PTP_CUR_TIME_SEC_H_REG);

Need mutex or spinlock to protest against concurrent access.

> +	ns += (((u64)sec_h) << HCLGE_PTP_SEC_H_OFFSET | sec) * NSEC_PER_SEC;
> +	skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(ns);
> +	hdev->ptp->last_rx = jiffies;
> +	hdev->ptp->rx_cnt++;
> +}
> +
> +static int hclge_ptp_gettimex(struct ptp_clock_info *ptp, struct timespec64 *ts,
> +			      struct ptp_system_timestamp *sts)
> +{
> +	struct hclge_dev *hdev = hclge_ptp_get_hdev(ptp);
> +	u32 hi, lo;
> +	u64 ns;
> +
> +	ns = readl(hdev->ptp->io_base + HCLGE_PTP_CUR_TIME_NSEC_REG);
> +	hi = readl(hdev->ptp->io_base + HCLGE_PTP_CUR_TIME_SEC_H_REG);
> +	lo = readl(hdev->ptp->io_base + HCLGE_PTP_CUR_TIME_SEC_L_REG);

Need mutex or spinlock to protest against concurrent access.

> +	ns += (((u64)hi) << HCLGE_PTP_SEC_H_OFFSET | lo) * NSEC_PER_SEC;
> +	*ts = ns_to_timespec64(ns);
> +
> +	return 0;
> +}
> +
> +static int hclge_ptp_settime(struct ptp_clock_info *ptp,
> +			     const struct timespec64 *ts)
> +{
> +	struct hclge_dev *hdev = hclge_ptp_get_hdev(ptp);
> +
> +	writel(ts->tv_nsec, hdev->ptp->io_base + HCLGE_PTP_TIME_NSEC_REG);
> +	writel(ts->tv_sec >> HCLGE_PTP_SEC_H_OFFSET,
> +	       hdev->ptp->io_base + HCLGE_PTP_TIME_SEC_H_REG);
> +	writel(ts->tv_sec & HCLGE_PTP_SEC_L_MASK,
> +	       hdev->ptp->io_base + HCLGE_PTP_TIME_SEC_L_REG);
> +	/* synchronize the time of phc */
> +	writel(HCLGE_PTP_TIME_SYNC_EN,
> +	       hdev->ptp->io_base + HCLGE_PTP_TIME_SYNC_REG);

Need mutex or spinlock to protest against concurrent access.

> +	return 0;
> +}
> +
> +static int hclge_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
> +{
> +	struct hclge_dev *hdev = hclge_ptp_get_hdev(ptp);
> +	bool is_neg = false;
> +	u32 adj_val = 0;
> +
> +	if (delta < 0) {
> +		adj_val |= HCLGE_PTP_TIME_NSEC_NEG;
> +		delta = -delta;
> +		is_neg = true;
> +	}
> +
> +	if (delta > HCLGE_PTP_TIME_NSEC_MASK) {
> +		struct timespec64 ts;
> +		s64 ns;
> +
> +		hclge_ptp_gettimex(ptp, &ts, NULL);
> +		ns = timespec64_to_ns(&ts);
> +		ns = is_neg ? ns - delta : ns + delta;
> +		ts = ns_to_timespec64(ns);
> +		return hclge_ptp_settime(ptp, &ts);
> +	}
> +
> +	adj_val |= delta & HCLGE_PTP_TIME_NSEC_MASK;
> +	writel(adj_val, hdev->ptp->io_base + HCLGE_PTP_TIME_NSEC_REG);
> +	writel(HCLGE_PTP_TIME_ADJ_EN,
> +	       hdev->ptp->io_base + HCLGE_PTP_TIME_ADJ_REG);

Need mutex or spinlock to protest against concurrent access.

> +
> +	return 0;
> +}

Thanks,
Richard

