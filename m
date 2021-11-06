Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC713446C0C
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 03:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhKFCfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 22:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhKFCfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 22:35:37 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DD3C061570;
        Fri,  5 Nov 2021 19:32:57 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id s19-20020a056830125300b0055ad9673606so14549789otp.0;
        Fri, 05 Nov 2021 19:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qQWOLFiWqAxjwAAeFXl9+YsFchVkFO4XJY9lG1INzkU=;
        b=QEGcKUZptaYLjYpM/+bJFKqO92hizKff1BtteZGn3bMHOWkBsMhiP+WgYO6CV57w6M
         UIgK9B5ndYcQVtLfaEVwLkwiCUcqVA1m65mhOI+ataJwd5vPfJMsX4S+nf5d4PQI3Gr4
         VdJ8CBhSPhJYSYizt5tgCxYUGvr43stkulz9B6PjkjI0Xgp3vA5gdAJYDtfMfRqMVdUe
         aBoyb0wD5gXLXPw6QXym3zAX1uE3h5ahWrnMIk1bsQ9nnYqRB0+o0vGpaZoC1H5Lvg/+
         RRJs8SzaR4aL18dhhEwnZGWXgmkd8sIqWIAi47O13GKcAtmpLWSQXxznnRf+OWji5B2i
         9YBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qQWOLFiWqAxjwAAeFXl9+YsFchVkFO4XJY9lG1INzkU=;
        b=BQbhFPg3uK3zI4JikEfDt55vIwf3fWthiCR0btufxfY6Oz7wUxVt7hI4riiQGAmum1
         TKlg0HKfxVCx5aB22304gQ/xa4jHBsSJRgGeuuDOXAXOtj4aARzKQWLdBrAQRp62Ozlu
         eGkEKlfcdA/7v9O8s1xoulaLBgnoaMFDAc39wRLUgdVIhdCsTnlO7WoyCuo7rG034+Gv
         9S8lu/QmpVKB0Mg03fY34LIAiYncVeFXeN6JnSoGSyJenOxpWKTrVg2ll/tE5OTSksaJ
         3O1yNIuRnkJIk1LqQ5brvO58ek4USkcZX22mUUySXI/l9mmV66hACARU5ptthj44VaB4
         iIww==
X-Gm-Message-State: AOAM532w/xBP8LYVquSEHpVpyMFOPwMbl99rLk5fctu+4hb4SgHyGAhe
        6BIJUv3+sBfPRp6TCu0HKqM=
X-Google-Smtp-Source: ABdhPJxzgtB3jBA2tHvTqI2ctaA5SEIILQkNwk3fyx/rTjDFHhMYpdH0PAgMg2UrE4Utq2kXfKMAfA==
X-Received: by 2002:a05:6830:1e42:: with SMTP id e2mr47610176otj.41.1636165976621;
        Fri, 05 Nov 2021 19:32:56 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:14e0:e534:f753:ba71? ([2600:1700:dfe0:49f0:14e0:e534:f753:ba71])
        by smtp.gmail.com with ESMTPSA id j9sm1113995ots.68.2021.11.05.19.32.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 19:32:55 -0700 (PDT)
Message-ID: <666b195b-e7d7-6f1f-e09d-bfe113c2f4fe@gmail.com>
Date:   Fri, 5 Nov 2021 19:32:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH 4/7] net: dsa: b53: Add PHC clock support
Content-Language: en-US
To:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-5-martin.kaistra@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211104133204.19757-5-martin.kaistra@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/2021 6:31 AM, Martin Kaistra wrote:
> The BCM53128 switch has an internal clock, which can be used for
> timestamping. Add support for it.
> 
> The 32-bit free running clock counts nanoseconds. In order to account
> for the wrap-around at 999999999 (0x3B9AC9FF) while using the cycle
> counter infrastructure, we need to set a 30bit mask and use the
> overflow_point property.
> 
> Enable the Broadsync HD timestamping feature in b53_ptp_init() for PTPv2
> Ethertype (0x88f7).
> 
> Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
> ---

[snip]


> +int b53_ptp_init(struct b53_device *dev)
> +{
> +	mutex_init(&dev->ptp_mutex);
> +
> +	INIT_DELAYED_WORK(&dev->overflow_work, b53_ptp_overflow_check);
> +
> +	/* Enable BroadSync HD for all ports */
> +	b53_write16(dev, B53_BROADSYNC_PAGE, B53_BROADSYNC_EN_CTRL1, 0x00ff);

Can you do this for all enabled user ports instead of each port, that 
way it is clera that this register is supposed to be a bitmask of ports 
for which you desire PTP timestamping to be enabled?

> +
> +	/* Enable BroadSync HD Time Stamping Reporting (Egress) */
> +	b53_write8(dev, B53_BROADSYNC_PAGE, B53_BROADSYNC_TS_REPORT_CTRL, 0x01);

Can you add a define for this bit in b53_regs.h and name it:

#define TSRPT_PKT_EN	BIT(0)

which will enable timestamp reporting towards the IMP port.

> +
> +	/* Enable BroadSync HD Time Stamping for PTPv2 ingress */
> +
> +	/* MPORT_CTRL0 | MPORT0_TS_EN */
> +	b53_write16(dev, B53_ARLCTRL_PAGE, 0x0e, (1 << 15) | 0x01);

Please add a definition for 0x0e which is the multi-port control 
register and is 16-bit wide.

Bit 15 is MPORT0_TS_EN and it will ensure that packets matching 
multiport 0 (address or ethertype) will be timestamped.

and then add a macro or generic definitions that are applicable to all 
multiport control registers, something like:

#define MPORT_CTRL_DIS_FORWARD	0
#define MPORT_CTRL_CMP_ADDR	1
#define MPORT_CTRL_CMP_ETYPE	2
#define MPORT_CTRL_CMP_ADDR_ETYPE 3

#define MPORT_CTRL_SHIFT(x)	((x) << 2)
#define MPORT_CTRL_MASK		0x3

> +	/* Forward to IMP port 8 */
> +	b53_write64(dev, B53_ARLCTRL_PAGE, 0x18, (1 << 8));

0x18 is the multiport vector N register so we would want a macro to 
define the multiprot vector being used (up to 6 of them), and this is a 
32-bit register, not a 64-bit register. The 8 here should be checked 
against the actual CPU port index number, it is 8 for you, it could be 5 
for someone else, or 7, even.

> +	/* PTPv2 Ether Type */
> +	b53_write64(dev, B53_ARLCTRL_PAGE, 0x10, (u64)0x88f7 << 48);

Use ETH_P_1588 here and 0x10 deserves a define which is the multiport 
address N register. Likewise, we need a base offset of 0x10 and then a 
macro to address the 6 multiports that exists.

> +
> +	/* Setup PTP clock */
> +	dev->ptp_clock_info.owner = THIS_MODULE;
> +	snprintf(dev->ptp_clock_info.name, sizeof(dev->ptp_clock_info.name),
> +		 dev_name(dev->dev));
> +
> +	dev->ptp_clock_info.max_adj = 1000000000ULL;
> +	dev->ptp_clock_info.n_alarm = 0;
> +	dev->ptp_clock_info.n_pins = 0;
> +	dev->ptp_clock_info.n_ext_ts = 0;
> +	dev->ptp_clock_info.n_per_out = 0;
> +	dev->ptp_clock_info.pps = 0;

memset the structure ahead of time so you only need explicit 
initialization where needed?

> +	dev->ptp_clock_info.adjfine = b53_ptp_adjfine;
> +	dev->ptp_clock_info.adjtime = b53_ptp_adjtime;
> +	dev->ptp_clock_info.gettime64 = b53_ptp_gettime;
> +	dev->ptp_clock_info.settime64 = b53_ptp_settime;
> +	dev->ptp_clock_info.enable = b53_ptp_enable;
> +
> +	dev->ptp_clock = ptp_clock_register(&dev->ptp_clock_info, dev->dev);
> +	if (IS_ERR(dev->ptp_clock))
> +		return PTR_ERR(dev->ptp_clock);
> +
> +	/* The switch provides a 32 bit free running counter. Use the Linux
> +	 * cycle counter infrastructure which is suited for such scenarios.
> +	 */
> +	dev->cc.read = b53_ptp_read;
> +	dev->cc.mask = CYCLECOUNTER_MASK(30);
> +	dev->cc.overflow_point = 999999999;
> +	dev->cc.mult = (1 << 28);
> +	dev->cc.shift = 28;
> +
> +	b53_write32(dev, B53_BROADSYNC_PAGE, B53_BROADSYNC_TIMEBASE_ADJ1, 40);

You are writing the default value of the register, is that of any use?
-- 
Florian
