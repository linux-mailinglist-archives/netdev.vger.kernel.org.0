Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBC7258F53
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 15:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgIANnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 09:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728161AbgIANlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 09:41:21 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28A2C061244;
        Tue,  1 Sep 2020 06:40:25 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id z22so1696665ejl.7;
        Tue, 01 Sep 2020 06:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=on/Tz02yPmqRlHqRasVFp/SkQjVqay1eo3Le0Rj4RgE=;
        b=lc0pIskeBbWOLbBawfPqHI9KBiJsepxt8mqpdkrDen4Vxz9tQ+vL6z2XNePFHCsxXU
         JTPzORv+QYubQ2D9eZJxFd+mUhdv/Inp2mM1eT5m1rZpSLyFe33D1vhUjM3rJNXE1n8s
         4IyBFWlCJzRAhAsdp/oipZqvg0U0WETj65A0pyvI/bG+ElBRN5fDb/uAXcz85mu+vnwm
         breuWQLtfNUaQYIVlg9DoOElESPxJ0fYZf5uNwV7wCCpfbcA/ZPQMlYZPiJfpKMouJ4U
         qV06BZ8qBM1if/bEwOFFZWJVRPbaC9i9x6u3CPo1nWAvpIo3aoPNVR4mqOqGeERsnvWf
         heDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=on/Tz02yPmqRlHqRasVFp/SkQjVqay1eo3Le0Rj4RgE=;
        b=SgWsJJD6PWQ88qWOBbjvUabWD3zhJ2XuLH0UayA9WQdXTdfjSUDXn2e7W+GWtN0AMR
         DlWllNacICstp7tGxul5VcLJMrOyfOJeGfuTkPTN0UMnix4W6QGIqM95Pq6FracyyirM
         Tmg1ZVjBJBjzX2yvTG5Q74pw5yCDLig+Bx6ZzQjZyC3h6zqF/pFB0h8+BA1Q0DvBKSHU
         KtnT8gRo7l4aArYWcGk+QROIIMc7DGFWxud2Zt0DVPk9WcZAh8OONB9Q+mdg5zvpydxM
         5xNV85svx9s+1vueohtj9g3P+A5GfzU6mgF3ffD7UUZjNYxykjjxrtwAmg8PKL39aKgb
         MzLw==
X-Gm-Message-State: AOAM5332Rw3LBxTrAxkjHDTUg1GTJeGlHZXUe7iVwN5Y5LIp8855IHuK
        kIxfx+xsbn9PtyG7ZiBmmtE=
X-Google-Smtp-Source: ABdhPJzv90VpS1RVR4JcApIxSexwReAHbMW5NFvqqMG1i6aU71Tpic2YKbIYkPnHC/YEIGfnYiKA1Q==
X-Received: by 2002:a17:906:5490:: with SMTP id r16mr1457119ejo.222.1598967624031;
        Tue, 01 Sep 2020 06:40:24 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id n7sm1319656eji.13.2020.09.01.06.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 06:40:23 -0700 (PDT)
Date:   Tue, 1 Sep 2020 16:40:20 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v4 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek
 switches
Message-ID: <20200901134020.53vob6fis5af7nig@skbuf>
References: <20200901125014.17801-1-kurt@linutronix.de>
 <20200901125014.17801-3-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901125014.17801-3-kurt@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,

On Tue, Sep 01, 2020 at 02:50:09PM +0200, Kurt Kanzenbach wrote:
> Add a basic DSA driver for Hirschmann Hellcreek switches. Those switches are
> implementing features needed for Time Sensitive Networking (TSN) such as support
> for the Time Precision Protocol and various shapers like the Time Aware Shaper.
> 
> This driver includes basic support for networking:
> 
>  * VLAN handling
>  * FDB handling
>  * Port statistics
>  * STP
>  * Phylink
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  drivers/net/dsa/Kconfig                       |    2 +
>  drivers/net/dsa/Makefile                      |    1 +
>  drivers/net/dsa/hirschmann/Kconfig            |    8 +
>  drivers/net/dsa/hirschmann/Makefile           |    2 +
>  drivers/net/dsa/hirschmann/hellcreek.c        | 1176 +++++++++++++++++
>  drivers/net/dsa/hirschmann/hellcreek.h        |  245 ++++
>  .../platform_data/hirschmann-hellcreek.h      |   22 +
>  7 files changed, 1456 insertions(+)
>  create mode 100644 drivers/net/dsa/hirschmann/Kconfig
>  create mode 100644 drivers/net/dsa/hirschmann/Makefile
>  create mode 100644 drivers/net/dsa/hirschmann/hellcreek.c
>  create mode 100644 drivers/net/dsa/hirschmann/hellcreek.h
>  create mode 100644 include/linux/platform_data/hirschmann-hellcreek.h
> 
> diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
> new file mode 100644
> index 000000000000..79e553e2e57d
> --- /dev/null
> +++ b/drivers/net/dsa/hirschmann/hellcreek.h
> @@ -0,0 +1,245 @@
> +/* SPDX-License-Identifier: (GPL-2.0 or MIT) */
> +/*
> + * DSA driver for:
> + * Hirschmann Hellcreek TSN switch.
> + *
> + * Copyright (C) 2019,2020 Linutronix GmbH
> + * Author Kurt Kanzenbach <kurt@linutronix.de>
> + */
> +
> +#ifndef _HELLCREEK_H_
> +#define _HELLCREEK_H_
> +
> +#include <linux/bitops.h>
> +#include <linux/kernel.h>
> +#include <linux/device.h>
> +#include <linux/ptp_clock_kernel.h>
> +#include <linux/timecounter.h>
> +#include <linux/mutex.h>
> +#include <linux/platform_data/hirschmann-hellcreek.h>
> +#include <net/dsa.h>
> +
> +/* Ports:
> + *  - 0: CPU
> + *  - 1: Tunnel
> + *  - 2: TSN front port 1
> + *  - 3: TSN front port 2
> + *  - ...
> + */
> +#define CPU_PORT			0
> +#define TUNNEL_PORT			1
> +
> +#define HELLCREEK_VLAN_NO_MEMBER	0x0
> +#define HELLCREEK_VLAN_UNTAGGED_MEMBER	0x1
> +#define HELLCREEK_VLAN_TAGGED_MEMBER	0x3
> +#define HELLCREEK_NUM_EGRESS_QUEUES	8
> +
> +/* Register definitions */
> +#define HR_MODID_C			(0 * 2)
> +#define HR_REL_L_C			(1 * 2)
> +#define HR_REL_H_C			(2 * 2)
> +#define HR_BLD_L_C			(3 * 2)
> +#define HR_BLD_H_C			(4 * 2)
> +#define HR_CTRL_C			(5 * 2)
> +#define HR_CTRL_C_READY			BIT(14)
> +#define HR_CTRL_C_TRANSITION		BIT(13)
> +#define HR_CTRL_C_ENABLE		BIT(0)
> +
> +#define HR_PSEL				(0xa6 * 2)
> +#define HR_PSEL_PTWSEL_SHIFT		4
> +#define HR_PSEL_PTWSEL_MASK		GENMASK(5, 4)
> +#define HR_PSEL_PRTCWSEL_SHIFT		0
> +#define HR_PSEL_PRTCWSEL_MASK		GENMASK(2, 0)
> +
> +#define HR_PTCFG			(0xa7 * 2)
> +#define HR_PTCFG_MLIMIT_EN		BIT(13)
> +#define HR_PTCFG_UMC_FLT		BIT(10)
> +#define HR_PTCFG_UUC_FLT		BIT(9)
> +#define HR_PTCFG_UNTRUST		BIT(8)
> +#define HR_PTCFG_TAG_REQUIRED		BIT(7)
> +#define HR_PTCFG_PPRIO_SHIFT		4
> +#define HR_PTCFG_PPRIO_MASK		GENMASK(6, 4)
> +#define HR_PTCFG_INGRESSFLT		BIT(3)
> +#define HR_PTCFG_BLOCKED		BIT(2)
> +#define HR_PTCFG_LEARNING_EN		BIT(1)
> +#define HR_PTCFG_ADMIN_EN		BIT(0)
> +
> +#define HR_PRTCCFG			(0xa8 * 2)
> +#define HR_PRTCCFG_PCP_TC_MAP_SHIFT	0
> +#define HR_PRTCCFG_PCP_TC_MAP_MASK	GENMASK(2, 0)
> +
> +#define HR_CSEL				(0x8d * 2)
> +#define HR_CSEL_SHIFT			0
> +#define HR_CSEL_MASK			GENMASK(7, 0)
> +#define HR_CRDL				(0x8e * 2)
> +#define HR_CRDH				(0x8f * 2)
> +
> +#define HR_SWTRC_CFG			(0x90 * 2)
> +#define HR_SWTRC0			(0x91 * 2)
> +#define HR_SWTRC1			(0x92 * 2)
> +#define HR_PFREE			(0x93 * 2)
> +#define HR_MFREE			(0x94 * 2)
> +
> +#define HR_FDBAGE			(0x97 * 2)
> +#define HR_FDBMAX			(0x98 * 2)
> +#define HR_FDBRDL			(0x99 * 2)
> +#define HR_FDBRDM			(0x9a * 2)
> +#define HR_FDBRDH			(0x9b * 2)
> +
> +#define HR_FDBMDRD			(0x9c * 2)
> +#define HR_FDBMDRD_PORTMASK_SHIFT	0
> +#define HR_FDBMDRD_PORTMASK_MASK	GENMASK(3, 0)
> +#define HR_FDBMDRD_AGE_SHIFT		4
> +#define HR_FDBMDRD_AGE_MASK		GENMASK(7, 4)
> +#define HR_FDBMDRD_OBT			BIT(8)
> +#define HR_FDBMDRD_PASS_BLOCKED		BIT(9)
> +#define HR_FDBMDRD_STATIC		BIT(11)
> +#define HR_FDBMDRD_REPRIO_TC_SHIFT	12
> +#define HR_FDBMDRD_REPRIO_TC_MASK	GENMASK(14, 12)
> +#define HR_FDBMDRD_REPRIO_EN		BIT(15)
> +
> +#define HR_FDBWDL			(0x9d * 2)
> +#define HR_FDBWDM			(0x9e * 2)
> +#define HR_FDBWDH			(0x9f * 2)
> +#define HR_FDBWRM0			(0xa0 * 2)
> +#define HR_FDBWRM0_PORTMASK_SHIFT	0
> +#define HR_FDBWRM0_PORTMASK_MASK	GENMASK(3, 0)
> +#define HR_FDBWRM0_OBT			BIT(8)
> +#define HR_FDBWRM0_PASS_BLOCKED		BIT(9)
> +#define HR_FDBWRM0_REPRIO_TC_SHIFT	12
> +#define HR_FDBWRM0_REPRIO_TC_MASK	GENMASK(14, 12)
> +#define HR_FDBWRM0_REPRIO_EN		BIT(15)
> +#define HR_FDBWRM1			(0xa1 * 2)
> +
> +#define HR_FDBWRCMD			(0xa2 * 2)
> +#define HR_FDBWRCMD_FDBDEL		BIT(9)
> +
> +#define HR_SWCFG			(0xa3 * 2)
> +#define HR_SWCFG_GM_STATEMD		BIT(15)
> +#define HR_SWCFG_LAS_MODE_SHIFT		12
> +#define HR_SWCFG_LAS_MODE_MASK		GENMASK(13, 12)
> +#define HR_SWCFG_LAS_OFF		(0x00)
> +#define HR_SWCFG_LAS_ON			(0x01)
> +#define HR_SWCFG_LAS_STATIC		(0x10)
> +#define HR_SWCFG_CT_EN			BIT(11)
> +#define HR_SWCFG_LAN_UNAWARE		BIT(10)
> +#define HR_SWCFG_ALWAYS_OBT		BIT(9)
> +#define HR_SWCFG_FDBAGE_EN		BIT(5)
> +#define HR_SWCFG_FDBLRN_EN		BIT(4)
> +
> +#define HR_SWSTAT			(0xa4 * 2)
> +#define HR_SWSTAT_FAIL			BIT(4)
> +#define HR_SWSTAT_BUSY			BIT(0)
> +
> +#define HR_SWCMD			(0xa5 * 2)
> +#define HW_SWCMD_FLUSH			BIT(0)
> +
> +#define HR_VIDCFG			(0xaa * 2)
> +#define HR_VIDCFG_VID_SHIFT		0
> +#define HR_VIDCFG_VID_MASK		GENMASK(11, 0)
> +#define HR_VIDCFG_PVID			BIT(12)
> +
> +#define HR_VIDMBRCFG			(0xab * 2)
> +#define HR_VIDMBRCFG_P0MBR_SHIFT	0
> +#define HR_VIDMBRCFG_P0MBR_MASK		GENMASK(1, 0)
> +#define HR_VIDMBRCFG_P1MBR_SHIFT	2
> +#define HR_VIDMBRCFG_P1MBR_MASK		GENMASK(3, 2)
> +#define HR_VIDMBRCFG_P2MBR_SHIFT	4
> +#define HR_VIDMBRCFG_P2MBR_MASK		GENMASK(5, 4)
> +#define HR_VIDMBRCFG_P3MBR_SHIFT	6
> +#define HR_VIDMBRCFG_P3MBR_MASK		GENMASK(7, 6)
> +
> +#define HR_FEABITS0			(0xac * 2)
> +#define HR_FEABITS0_FDBBINS_SHIFT	4
> +#define HR_FEABITS0_FDBBINS_MASK	GENMASK(7, 4)
> +#define HR_FEABITS0_PCNT_SHIFT		8
> +#define HR_FEABITS0_PCNT_MASK		GENMASK(11, 8)
> +#define HR_FEABITS0_MCNT_SHIFT		12
> +#define HR_FEABITS0_MCNT_MASK		GENMASK(15, 12)
> +
> +#define TR_QTRACK			(0xb1 * 2)
> +#define TR_TGDVER			(0xb3 * 2)
> +#define TR_TGDVER_REV_MIN_MASK		GENMASK(7, 0)
> +#define TR_TGDVER_REV_MIN_SHIFT		0
> +#define TR_TGDVER_REV_MAJ_MASK		GENMASK(15, 8)
> +#define TR_TGDVER_REV_MAJ_SHIFT		8
> +#define TR_TGDSEL			(0xb4 * 2)
> +#define TR_TGDSEL_TDGSEL_MASK		GENMASK(1, 0)
> +#define TR_TGDSEL_TDGSEL_SHIFT		0
> +#define TR_TGDCTRL			(0xb5 * 2)
> +#define TR_TGDCTRL_GATE_EN		BIT(0)
> +#define TR_TGDCTRL_CYC_SNAP		BIT(4)
> +#define TR_TGDCTRL_SNAP_EST		BIT(5)
> +#define TR_TGDCTRL_ADMINGATESTATES_MASK	GENMASK(15, 8)
> +#define TR_TGDCTRL_ADMINGATESTATES_SHIFT	8
> +#define TR_TGDSTAT0			(0xb6 * 2)
> +#define TR_TGDSTAT1			(0xb7 * 2)
> +#define TR_ESTWRL			(0xb8 * 2)
> +#define TR_ESTWRH			(0xb9 * 2)
> +#define TR_ESTCMD			(0xba * 2)
> +#define TR_ESTCMD_ESTSEC_MASK		GENMASK(2, 0)
> +#define TR_ESTCMD_ESTSEC_SHIFT		0
> +#define TR_ESTCMD_ESTARM		BIT(4)
> +#define TR_ESTCMD_ESTSWCFG		BIT(5)
> +#define TR_EETWRL			(0xbb * 2)
> +#define TR_EETWRH			(0xbc * 2)
> +#define TR_EETCMD			(0xbd * 2)
> +#define TR_EETCMD_EETSEC_MASK		GEMASK(2, 0)
> +#define TR_EETCMD_EETSEC_SHIFT		0
> +#define TR_EETCMD_EETARM		BIT(4)
> +#define TR_CTWRL			(0xbe * 2)
> +#define TR_CTWRH			(0xbf * 2)
> +#define TR_LCNSL			(0xc1 * 2)
> +#define TR_LCNSH			(0xc2 * 2)
> +#define TR_LCS				(0xc3 * 2)
> +#define TR_GCLDAT			(0xc4 * 2)
> +#define TR_GCLDAT_GCLWRGATES_MASK	GENMASK(7, 0)
> +#define TR_GCLDAT_GCLWRGATES_SHIFT	0
> +#define TR_GCLDAT_GCLWRLAST		BIT(8)
> +#define TR_GCLDAT_GCLOVRI		BIT(9)
> +#define TR_GCLTIL			(0xc5 * 2)
> +#define TR_GCLTIH			(0xc6 * 2)
> +#define TR_GCLCMD			(0xc7 * 2)
> +#define TR_GCLCMD_GCLWRADR_MASK		GENMASK(7, 0)
> +#define TR_GCLCMD_GCLWRADR_SHIFT	0
> +#define TR_GCLCMD_INIT_GATE_STATES_MASK	GENMASK(15, 8)
> +#define TR_GCLCMD_INIT_GATE_STATES_SHIFT	8
> +
> +struct hellcreek_counter {
> +	u8 offset;
> +	const char *name;
> +};
> +
> +struct hellcreek;
> +
> +struct hellcreek_port {
> +	struct hellcreek *hellcreek;
> +	int port;
> +	u16 ptcfg;		/* ptcfg shadow */
> +	u64 *counter_values;
> +};
> +
> +struct hellcreek_fdb_entry {
> +	size_t idx;
> +	unsigned char mac[6];
> +	u8 portmask;
> +	u8 age;
> +	u8 is_obt;
> +	u8 pass_blocked;
> +	u8 is_static;
> +	u8 reprio_tc;
> +	u8 reprio_en;
> +};
> +
> +struct hellcreek {
> +	const struct hellcreek_platform_data *pdata;
> +	struct device *dev;
> +	struct dsa_switch *ds;
> +	struct hellcreek_port *ports;
> +	struct mutex reg_lock;	/* Switch IP register lock */

Pardon me asking, but I went back through the previous review comments
and I didn't see this being asked.

What is the register lock protecting against, exactly?

> +	void __iomem *base;
> +	u8 *vidmbrcfg;		/* vidmbrcfg shadow */
> +	size_t fdb_entries;
> +};
> +
> +#endif /* _HELLCREEK_H_ */
> -- 
> 2.20.1
> 

Thanks,
-Vladimir
