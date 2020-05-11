Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9331CDA8F
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgEKM5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726687AbgEKM53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:57:29 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB5FC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 05:57:27 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id k12so17904094wmj.3
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 05:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l43sg+FHkOW9zfkhGkFIlgd6CsLqpdFPaKw1HHQsoqM=;
        b=MtFlOFlYOkC3GFBW2hTntA5RgWKaejJEcBhEol6QvNDASiLigljOWeIInU7PCsxBXQ
         XXBp7g6NLHfGUXCIQRfg9MCdVb2N1YcGsSmqh1xMuEMrFGWReehmri9uD06Eg26lLKhN
         lxIcRAVgHg+XLD8/oVNQOuILZo3jzNia1Swj4gLyCXAbrzvM6WPQyur4gNwmpKjx+IxL
         w+NcLyEy9+ws+nbIF8KRB/qwacW8cjMjJ3LrB9Wmu3PnC1VWiKW7KxELJV1PO0fgG5I3
         vgjjujxW/RD5TM9/F8aPXcSNJKAkJ+WD9THYlnTY8MIXwk+5pJCniDSdULwmxHhCqcok
         g45A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l43sg+FHkOW9zfkhGkFIlgd6CsLqpdFPaKw1HHQsoqM=;
        b=gfSLnO3d1JIB3P4N9CkrHDhHnEV3d6dWv6C1xICfVKCnAFOe47ONrflRIR4hquzP9F
         PRGTl57GVqSANPzxMYeNEMizdSF5sXNdmcQMRTSU8ntJnRT1BhWzi3pQgQdgQDuTQ2Hm
         I37bw3ju7Y6hSHgfhGJrJAYaV7f5zVzAYT1aQXOHyFOm/UW5DsLFh2lQTfvmo3fBh658
         TYS9H6IZa0KjLcSuIw3iqCxjvnBhuPPJA3DZR5wROhydxJAtja3vabCX9l5uh+2Ja9PM
         o/xfO5v5q8rBKQ5Dk3la79YB72s9sBaWEO56AGiQe8A55yuEqyBE3CDDa9owRncd5Kv1
         +20g==
X-Gm-Message-State: AGi0PuZ3aTvsONnM8ozTsktHg+HAOYSTgJo0tYEDxzmwClNfCB99fKr5
        kS8380WKuBOTvIGTOruPxjLjyw==
X-Google-Smtp-Source: APiQypJAvKBdjfBiNuHKuODdxUUZWFORts2BXioCDRRov01Ez9Q9fDiK3H5LHyCIlHgu04m8u8efFA==
X-Received: by 2002:a7b:c046:: with SMTP id u6mr1961022wmc.57.1589201846004;
        Mon, 11 May 2020 05:57:26 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id p23sm20854902wmj.37.2020.05.11.05.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 05:57:25 -0700 (PDT)
Date:   Mon, 11 May 2020 14:57:23 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: Re: [RFC next-next v2 1/5] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200511125723.GI2245@nanopsycho>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-2-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430232052.9016-2-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[...]

>diff --git a/drivers/net/ethernet/marvell/prestera/prestera_dsa.c b/drivers/net/ethernet/marvell/prestera/prestera_dsa.c
>new file mode 100644
>index 000000000000..c4f7d9f6edcb
>--- /dev/null
>+++ b/drivers/net/ethernet/marvell/prestera/prestera_dsa.c
>@@ -0,0 +1,134 @@
>+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
>+/* Copyright (c) 2020 Marvell International Ltd. All rights reserved */
>+
>+#include "prestera_dsa.h"
>+
>+#include <linux/string.h>
>+#include <linux/bitops.h>
>+#include <linux/bitfield.h>
>+#include <linux/errno.h>
>+
>+#define W0_MASK_IS_TAGGED	BIT(29)
>+
>+/* TrgDev[4:0] = {Word0[28:24]} */
>+#define W0_MASK_HW_DEV_NUM	GENMASK(28, 24)
>+
>+/* SrcPort/TrgPort extended to 8b
>+ * SrcPort/TrgPort[7:0] = {Word2[20], Word1[11:10], Word0[23:19]}
>+ */
>+#define W0_MASK_IFACE_PORT_NUM	GENMASK(23, 19)
>+
>+/* bits 30:31 - TagCommand 1 = FROM_CPU */
>+#define W0_MASK_DSA_CMD		GENMASK(31, 30)
>+
>+/* bits 13:15 -- UP */
>+#define W0_MASK_VPT		GENMASK(15, 13)
>+
>+#define W0_MASK_EXT_BIT		BIT(12)
>+
>+/* bits 0:11 -- VID */
>+#define W0_MASK_VID		GENMASK(11, 0)
>+
>+/* SrcPort/TrgPort extended to 8b
>+ * SrcPort/TrgPort[7:0] = {Word2[20], Word1[11:10], Word0[23:19]}
>+ */
>+#define W1_MASK_IFACE_PORT_NUM	GENMASK(11, 10)
>+
>+#define W1_MASK_EXT_BIT		BIT(31)
>+#define W1_MASK_CFI_BIT		BIT(30)
>+
>+/* SrcPort/TrgPort extended to 8b
>+ * SrcPort/TrgPort[7:0] = {Word2[20], Word1[11:10], Word0[23:19]}
>+ */
>+#define W2_MASK_IFACE_PORT_NUM	BIT(20)
>+
>+#define W2_MASK_EXT_BIT		BIT(31)
>+
>+/* trgHwDev and trgPort
>+ * TrgDev[11:5] = {Word3[6:0]}
>+ */
>+#define W3_MASK_HW_DEV_NUM	GENMASK(6, 0)
>+
>+/* VID 16b [15:0] = {Word3[30:27], Word0[11:0]} */
>+#define W3_MASK_VID		GENMASK(30, 27)
>+
>+/* TRGePort[16:0] = {Word3[23:7]} */
>+#define W3_MASK_DST_EPORT	GENMASK(23, 7)
>+
>+#define DEV_NUM_MASK		GENMASK(11, 5)
>+#define VID_MASK		GENMASK(15, 12)

Looks like you forgot to add the "prestera" prefix here.


>+
>+int prestera_dsa_parse(struct prestera_dsa *dsa, const u8 *dsa_buf)
>+{
>+	u32 *dsa_words = (u32 *)dsa_buf;
>+	enum prestera_dsa_cmd cmd;
>+	u32 words[4] = { 0 };
>+	u32 field;
>+
>+	words[0] = ntohl((__force __be32)dsa_words[0]);
>+	words[1] = ntohl((__force __be32)dsa_words[1]);
>+	words[2] = ntohl((__force __be32)dsa_words[2]);
>+	words[3] = ntohl((__force __be32)dsa_words[3]);
>+
>+	/* set the common parameters */
>+	cmd = (enum prestera_dsa_cmd)FIELD_GET(W0_MASK_DSA_CMD, words[0]);
>+
>+	/* only to CPU is supported */
>+	if (unlikely(cmd != PRESTERA_DSA_CMD_TO_CPU_E))
>+		return -EINVAL;
>+
>+	if (FIELD_GET(W0_MASK_EXT_BIT, words[0]) == 0)
>+		return -EINVAL;
>+	if (FIELD_GET(W1_MASK_EXT_BIT, words[1]) == 0)
>+		return -EINVAL;
>+	if (FIELD_GET(W2_MASK_EXT_BIT, words[2]) == 0)
>+		return -EINVAL;
>+
>+	field = FIELD_GET(W3_MASK_VID, words[3]);
>+
>+	dsa->vlan.is_tagged = (bool)FIELD_GET(W0_MASK_IS_TAGGED, words[0]);
>+	dsa->vlan.cfi_bit = (u8)FIELD_GET(W1_MASK_CFI_BIT, words[1]);
>+	dsa->vlan.vpt = (u8)FIELD_GET(W0_MASK_VPT, words[0]);
>+	dsa->vlan.vid = (u16)FIELD_GET(W0_MASK_VID, words[0]);
>+	dsa->vlan.vid &= ~VID_MASK;
>+	dsa->vlan.vid |= FIELD_PREP(VID_MASK, field);
>+
>+	field = FIELD_GET(W3_MASK_HW_DEV_NUM, words[3]);
>+
>+	dsa->hw_dev_num = FIELD_GET(W0_MASK_HW_DEV_NUM, words[0]);
>+	dsa->hw_dev_num &= W3_MASK_HW_DEV_NUM;
>+	dsa->hw_dev_num |= FIELD_PREP(DEV_NUM_MASK, field);
>+
>+	dsa->port_num = (FIELD_GET(W0_MASK_IFACE_PORT_NUM, words[0]) << 0) |
>+			(FIELD_GET(W1_MASK_IFACE_PORT_NUM, words[1]) << 5) |
>+			(FIELD_GET(W2_MASK_IFACE_PORT_NUM, words[2]) << 7);
>+	return 0;
>+}
>+
>+int prestera_dsa_build(const struct prestera_dsa *dsa, u8 *dsa_buf)
>+{
>+	__be32 *dsa_words = (__be32 *)dsa_buf;
>+	u32 words[4] = { 0 };
>+
>+	if (dsa->hw_dev_num >= BIT(12))
>+		return -EINVAL;
>+	if (dsa->port_num >= BIT(17))
>+		return -EINVAL;
>+
>+	words[0] |= FIELD_PREP(W0_MASK_DSA_CMD, PRESTERA_DSA_CMD_FROM_CPU_E);
>+
>+	words[0] |= FIELD_PREP(W0_MASK_HW_DEV_NUM, dsa->hw_dev_num);
>+	words[3] |= FIELD_PREP(W3_MASK_HW_DEV_NUM, (dsa->hw_dev_num >> 5));
>+	words[3] |= FIELD_PREP(W3_MASK_DST_EPORT, dsa->port_num);
>+
>+	words[0] |= FIELD_PREP(W0_MASK_EXT_BIT, 1);
>+	words[1] |= FIELD_PREP(W1_MASK_EXT_BIT, 1);
>+	words[2] |= FIELD_PREP(W2_MASK_EXT_BIT, 1);
>+
>+	dsa_words[0] = htonl(words[0]);
>+	dsa_words[1] = htonl(words[1]);
>+	dsa_words[2] = htonl(words[2]);
>+	dsa_words[3] = htonl(words[3]);
>+
>+	return 0;
>+}
>diff --git a/drivers/net/ethernet/marvell/prestera/prestera_dsa.h b/drivers/net/ethernet/marvell/prestera/prestera_dsa.h
>new file mode 100644
>index 000000000000..34cb260f1a74
>--- /dev/null
>+++ b/drivers/net/ethernet/marvell/prestera/prestera_dsa.h
>@@ -0,0 +1,37 @@
>+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
>+ *
>+ * Copyright (c) 2020 Marvell International Ltd. All rights reserved.
>+ *
>+ */
>+#ifndef __PRESTERA_DSA_H_
>+#define __PRESTERA_DSA_H_
>+
>+#include <linux/types.h>
>+
>+#define PRESTERA_DSA_HLEN	16
>+
>+enum prestera_dsa_cmd {
>+	/* DSA command is "To CPU" */
>+	PRESTERA_DSA_CMD_TO_CPU_E = 0,
>+
>+	/* DSA command is "FROM CPU" */
>+	PRESTERA_DSA_CMD_FROM_CPU_E,
>+};
>+
>+struct prestera_dsa_vlan {
>+	u16 vid;
>+	u8 vpt;
>+	u8 cfi_bit;
>+	bool is_tagged;
>+};
>+
>+struct prestera_dsa {
>+	struct prestera_dsa_vlan vlan;
>+	u32 hw_dev_num;
>+	u32 port_num;
>+};
>+
>+int prestera_dsa_parse(struct prestera_dsa *dsa, const u8 *dsa_buf);
>+int prestera_dsa_build(const struct prestera_dsa *dsa, u8 *dsa_buf);
>+
>+#endif /* _PRESTERA_DSA_H_ */
>diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
>new file mode 100644
>index 000000000000..b4626cf288b6
>--- /dev/null
>+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
>@@ -0,0 +1,614 @@
>+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
>+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
>+
>+#include <linux/etherdevice.h>
>+#include <linux/ethtool.h>
>+#include <linux/netdevice.h>
>+#include <linux/list.h>
>+
>+#include "prestera.h"
>+#include "prestera_hw.h"
>+
>+#define PRESTERA_SWITCH_INIT_TIMEOUT 30000000	/* 30sec */
>+#define PRESTERA_MIN_MTU 64
>+
>+enum prestera_cmd_type_t {
>+	PRESTERA_CMD_TYPE_SWITCH_INIT = 0x1,
>+	PRESTERA_CMD_TYPE_SWITCH_ATTR_SET = 0x2,
>+
>+	PRESTERA_CMD_TYPE_PORT_ATTR_SET = 0x100,
>+	PRESTERA_CMD_TYPE_PORT_ATTR_GET = 0x101,
>+	PRESTERA_CMD_TYPE_PORT_INFO_GET = 0x110,
>+
>+	PRESTERA_CMD_TYPE_RXTX_INIT = 0x800,
>+	PRESTERA_CMD_TYPE_RXTX_PORT_INIT = 0x801,
>+
>+	PRESTERA_CMD_TYPE_ACK = 0x10000,
>+	PRESTERA_CMD_TYPE_MAX
>+};
>+
>+enum {
>+	PRESTERA_CMD_PORT_ATTR_ADMIN_STATE = 1,
>+	PRESTERA_CMD_PORT_ATTR_MTU = 3,
>+	PRESTERA_CMD_PORT_ATTR_MAC = 4,
>+	PRESTERA_CMD_PORT_ATTR_CAPABILITY = 9,
>+	PRESTERA_CMD_PORT_ATTR_AUTONEG = 15,
>+	PRESTERA_CMD_PORT_ATTR_STATS = 17,
>+};
>+
>+enum {
>+	PRESTERA_CMD_SWITCH_ATTR_MAC = 1,
>+};
>+
>+enum {
>+	PRESTERA_CMD_ACK_OK,
>+	PRESTERA_CMD_ACK_FAILED,
>+
>+	PRESTERA_CMD_ACK_MAX
>+};
>+
>+enum {
>+	PRESTERA_PORT_GOOD_OCTETS_RCV_CNT,
>+	PRESTERA_PORT_BAD_OCTETS_RCV_CNT,
>+	PRESTERA_PORT_MAC_TRANSMIT_ERR_CNT,
>+	PRESTERA_PORT_BRDC_PKTS_RCV_CNT,
>+	PRESTERA_PORT_MC_PKTS_RCV_CNT,
>+	PRESTERA_PORT_PKTS_64L_CNT,
>+	PRESTERA_PORT_PKTS_65TO127L_CNT,
>+	PRESTERA_PORT_PKTS_128TO255L_CNT,
>+	PRESTERA_PORT_PKTS_256TO511L_CNT,
>+	PRESTERA_PORT_PKTS_512TO1023L_CNT,
>+	PRESTERA_PORT_PKTS_1024TOMAXL_CNT,
>+	PRESTERA_PORT_EXCESSIVE_COLLISIONS_CNT,
>+	PRESTERA_PORT_MC_PKTS_SENT_CNT,
>+	PRESTERA_PORT_BRDC_PKTS_SENT_CNT,
>+	PRESTERA_PORT_FC_SENT_CNT,
>+	PRESTERA_PORT_GOOD_FC_RCV_CNT,
>+	PRESTERA_PORT_DROP_EVENTS_CNT,
>+	PRESTERA_PORT_UNDERSIZE_PKTS_CNT,
>+	PRESTERA_PORT_FRAGMENTS_PKTS_CNT,
>+	PRESTERA_PORT_OVERSIZE_PKTS_CNT,
>+	PRESTERA_PORT_JABBER_PKTS_CNT,
>+	PRESTERA_PORT_MAC_RCV_ERROR_CNT,
>+	PRESTERA_PORT_BAD_CRC_CNT,
>+	PRESTERA_PORT_COLLISIONS_CNT,
>+	PRESTERA_PORT_LATE_COLLISIONS_CNT,
>+	PRESTERA_PORT_GOOD_UC_PKTS_RCV_CNT,
>+	PRESTERA_PORT_GOOD_UC_PKTS_SENT_CNT,
>+	PRESTERA_PORT_MULTIPLE_PKTS_SENT_CNT,
>+	PRESTERA_PORT_DEFERRED_PKTS_SENT_CNT,
>+	PRESTERA_PORT_PKTS_1024TO1518L_CNT,
>+	PRESTERA_PORT_PKTS_1519TOMAXL_CNT,
>+	PRESTERA_PORT_GOOD_OCTETS_SENT_CNT,
>+
>+	PRESTERA_PORT_CNT_MAX,
>+};
>+
>+struct prestera_fw_event_handler {
>+	struct list_head list;
>+	enum prestera_event_type type;
>+	prestera_event_cb_t func;
>+	void *arg;
>+};
>+
>+struct prestera_msg_cmd {
>+	u32 type;
>+} __packed __aligned(4);
>+
>+struct prestera_msg_ret {
>+	struct prestera_msg_cmd cmd;
>+	u32 status;
>+} __packed __aligned(4);
>+
>+struct prestera_msg_common_req {
>+	struct prestera_msg_cmd cmd;
>+} __packed __aligned(4);
>+
>+struct prestera_msg_common_resp {
>+	struct prestera_msg_ret ret;
>+} __packed __aligned(4);
>+
>+union prestera_msg_switch_param {
>+	u8 mac[ETH_ALEN];
>+};
>+
>+struct prestera_msg_switch_attr_req {
>+	struct prestera_msg_cmd cmd;
>+	u32 attr;
>+	union prestera_msg_switch_param param;
>+} __packed __aligned(4);
>+
>+struct prestera_msg_switch_init_resp {
>+	struct prestera_msg_ret ret;
>+	u32 port_count;
>+	u32 mtu_max;
>+	u8  switch_id;
>+} __packed __aligned(4);
>+
>+struct prestera_msg_port_autoneg_param {
>+	u64 link_mode;
>+	u8  enable;
>+	u8  fec;
>+};
>+
>+struct prestera_msg_port_cap_param {
>+	u64 link_mode;
>+	u8  type;
>+	u8  fec;
>+	u8  transceiver;
>+};
>+
>+union prestera_msg_port_param {
>+	u8  admin_state;
>+	u8  oper_state;
>+	u32 mtu;
>+	u8  mac[ETH_ALEN];
>+	struct prestera_msg_port_autoneg_param autoneg;
>+	struct prestera_msg_port_cap_param cap;
>+};
>+
>+struct prestera_msg_port_attr_req {
>+	struct prestera_msg_cmd cmd;
>+	u32 attr;
>+	u32 port;
>+	u32 dev;
>+	union prestera_msg_port_param param;
>+} __packed __aligned(4);
>+
>+struct prestera_msg_port_attr_resp {
>+	struct prestera_msg_ret ret;
>+	union prestera_msg_port_param param;
>+} __packed __aligned(4);
>+
>+struct prestera_msg_port_stats_resp {
>+	struct prestera_msg_ret ret;
>+	u64 stats[PRESTERA_PORT_CNT_MAX];
>+} __packed __aligned(4);
>+
>+struct prestera_msg_port_info_req {
>+	struct prestera_msg_cmd cmd;
>+	u32 port;
>+} __packed __aligned(4);
>+
>+struct prestera_msg_port_info_resp {
>+	struct prestera_msg_ret ret;
>+	u32 hw_id;
>+	u32 dev_id;
>+	u16 fp_id;
>+} __packed __aligned(4);
>+
>+struct prestera_msg_rxtx_req {
>+	struct prestera_msg_cmd cmd;
>+	u8 use_sdma;
>+} __packed __aligned(4);
>+
>+struct prestera_msg_rxtx_resp {
>+	struct prestera_msg_ret ret;
>+	u32 map_addr;
>+} __packed __aligned(4);
>+
>+struct prestera_msg_rxtx_port_req {
>+	struct prestera_msg_cmd cmd;
>+	u32 port;
>+	u32 dev;
>+} __packed __aligned(4);
>+
>+struct prestera_msg_event {
>+	u16 type;
>+	u16 id;
>+} __packed __aligned(4);
>+
>+union prestera_msg_event_port_param {
>+	u32 oper_state;
>+};
>+
>+struct prestera_msg_event_port {
>+	struct prestera_msg_event id;
>+	u32 port_id;
>+	union prestera_msg_event_port_param param;
>+} __packed __aligned(4);
>+
>+static int __prestera_cmd_ret(struct prestera_switch *sw,
>+			      enum prestera_cmd_type_t type,
>+			      struct prestera_msg_cmd *cmd, size_t clen,
>+			      struct prestera_msg_ret *ret, size_t rlen,
>+			      int wait)
>+{
>+	struct prestera_device *dev = sw->dev;
>+	int err;
>+
>+	cmd->type = type;
>+
>+	err = dev->send_req(dev, (u8 *)cmd, clen, (u8 *)ret, rlen, wait);
>+	if (err)
>+		return err;
>+
>+	if (ret->cmd.type != PRESTERA_CMD_TYPE_ACK)
>+		return -EBADE;
>+	if (ret->status != PRESTERA_CMD_ACK_OK)
>+		return -EINVAL;
>+
>+	return 0;
>+}
>+
>+static int prestera_cmd_ret(struct prestera_switch *sw,
>+			    enum prestera_cmd_type_t type,
>+			    struct prestera_msg_cmd *cmd, size_t clen,
>+			    struct prestera_msg_ret *ret, size_t rlen)
>+{
>+	return __prestera_cmd_ret(sw, type, cmd, clen, ret, rlen, 0);
>+}
>+
>+static int prestera_cmd_ret_wait(struct prestera_switch *sw,
>+				 enum prestera_cmd_type_t type,
>+				 struct prestera_msg_cmd *cmd, size_t clen,
>+				 struct prestera_msg_ret *ret, size_t rlen,
>+				 int wait)
>+{
>+	return __prestera_cmd_ret(sw, type, cmd, clen, ret, rlen, wait);
>+}
>+
>+static int prestera_cmd(struct prestera_switch *sw,
>+			enum prestera_cmd_type_t type,
>+			struct prestera_msg_cmd *cmd, size_t clen)
>+{
>+	struct prestera_msg_common_resp resp;
>+
>+	return prestera_cmd_ret(sw, type, cmd, clen, &resp.ret, sizeof(resp));
>+}
>+
>+static int prestera_fw_parse_port_evt(u8 *msg, struct prestera_event *evt)
>+{
>+	struct prestera_msg_event_port *hw_evt;
>+
>+	hw_evt = (struct prestera_msg_event_port *)msg;
>+
>+	evt->port_evt.port_id = hw_evt->port_id;
>+
>+	if (evt->id == PRESTERA_PORT_EVENT_STATE_CHANGED)
>+		evt->port_evt.data.oper_state = hw_evt->param.oper_state;
>+	else
>+		return -EINVAL;
>+
>+	return 0;
>+}
>+
>+static struct prestera_fw_evt_parser {
>+	int (*func)(u8 *msg, struct prestera_event *evt);
>+} fw_event_parsers[PRESTERA_EVENT_TYPE_MAX] = {
>+	[PRESTERA_EVENT_TYPE_PORT] = {.func = prestera_fw_parse_port_evt},
>+};
>+
>+static struct prestera_fw_event_handler *
>+__find_event_handler(const struct prestera_switch *sw,
>+		     enum prestera_event_type type)
>+{
>+	struct prestera_fw_event_handler *eh;
>+
>+	list_for_each_entry_rcu(eh, &sw->event_handlers, list) {
>+		if (eh->type == type)
>+			return eh;
>+	}
>+
>+	return NULL;
>+}
>+
>+static int prestera_find_event_handler(const struct prestera_switch *sw,
>+				       enum prestera_event_type type,
>+				       struct prestera_fw_event_handler *eh)
>+{
>+	struct prestera_fw_event_handler *tmp;
>+	int err = 0;
>+
>+	rcu_read_lock();
>+	tmp = __find_event_handler(sw, type);
>+	if (tmp)
>+		*eh = *tmp;
>+	else
>+		err = -EEXIST;
>+	rcu_read_unlock();
>+
>+	return err;
>+}
>+
>+static int prestera_evt_recv(struct prestera_device *dev, u8 *buf, size_t size)
>+{
>+	struct prestera_msg_event *msg = (struct prestera_msg_event *)buf;
>+	struct prestera_switch *sw = dev->priv;
>+	struct prestera_fw_event_handler eh;
>+	struct prestera_event evt;
>+	int err;
>+
>+	if (msg->type >= PRESTERA_EVENT_TYPE_MAX)
>+		return -EINVAL;
>+
>+	err = prestera_find_event_handler(sw, msg->type, &eh);
>+
>+	if (err || !fw_event_parsers[msg->type].func)
>+		return 0;
>+
>+	evt.id = msg->id;
>+
>+	err = fw_event_parsers[msg->type].func(buf, &evt);
>+	if (!err)
>+		eh.func(sw, &evt, eh.arg);
>+
>+	return err;
>+}
>+
>+static void prestera_pkt_recv(struct prestera_device *dev)
>+{
>+	struct prestera_switch *sw = dev->priv;
>+	struct prestera_fw_event_handler eh;
>+	struct prestera_event ev;
>+	int err;
>+
>+	ev.id = PRESTERA_RXTX_EVENT_RCV_PKT;
>+
>+	err = prestera_find_event_handler(sw, PRESTERA_EVENT_TYPE_RXTX, &eh);
>+	if (err)
>+		return;
>+
>+	eh.func(sw, &ev, eh.arg);
>+}
>+
>+int prestera_hw_port_info_get(const struct prestera_port *port,
>+			      u16 *fp_id, u32 *hw_id, u32 *dev_id)
>+{
>+	struct prestera_msg_port_info_resp resp;
>+	struct prestera_msg_port_info_req req = {
>+		.port = port->id
>+	};
>+	int err;
>+
>+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_INFO_GET,
>+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
>+	if (err)
>+		return err;
>+
>+	*hw_id = resp.hw_id;
>+	*dev_id = resp.dev_id;
>+	*fp_id = resp.fp_id;
>+
>+	return 0;
>+}
>+
>+int prestera_hw_switch_mac_set(struct prestera_switch *sw, char *mac)
>+{
>+	struct prestera_msg_switch_attr_req req = {
>+		.attr = PRESTERA_CMD_SWITCH_ATTR_MAC,
>+	};
>+
>+	memcpy(req.param.mac, mac, sizeof(req.param.mac));
>+
>+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_SWITCH_ATTR_SET,
>+			    &req.cmd, sizeof(req));
>+}
>+
>+int prestera_hw_switch_init(struct prestera_switch *sw)
>+{
>+	struct prestera_msg_switch_init_resp resp;
>+	struct prestera_msg_common_req req;
>+	int err;
>+
>+	INIT_LIST_HEAD(&sw->event_handlers);
>+
>+	err = prestera_cmd_ret_wait(sw, PRESTERA_CMD_TYPE_SWITCH_INIT,
>+				    &req.cmd, sizeof(req),
>+				    &resp.ret, sizeof(resp),
>+				    PRESTERA_SWITCH_INIT_TIMEOUT);
>+	if (err)
>+		return err;
>+
>+	sw->id = resp.switch_id;
>+	sw->port_count = resp.port_count;
>+	sw->mtu_min = PRESTERA_MIN_MTU;
>+	sw->mtu_max = resp.mtu_max;
>+	sw->dev->recv_msg = prestera_evt_recv;
>+	sw->dev->recv_pkt = prestera_pkt_recv;
>+
>+	return 0;
>+}
>+
>+int prestera_hw_port_state_set(const struct prestera_port *port,
>+			       bool admin_state)
>+{
>+	struct prestera_msg_port_attr_req req = {
>+		.attr = PRESTERA_CMD_PORT_ATTR_ADMIN_STATE,
>+		.port = port->hw_id,
>+		.dev = port->dev_id,
>+		.param = {.admin_state = admin_state}
>+	};
>+
>+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
>+			    &req.cmd, sizeof(req));
>+}
>+
>+int prestera_hw_port_mtu_set(const struct prestera_port *port, u32 mtu)
>+{
>+	struct prestera_msg_port_attr_req req = {
>+		.attr = PRESTERA_CMD_PORT_ATTR_MTU,
>+		.port = port->hw_id,
>+		.dev = port->dev_id,
>+		.param = {.mtu = mtu}
>+	};
>+
>+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
>+			    &req.cmd, sizeof(req));
>+}
>+
>+int prestera_hw_port_mac_set(const struct prestera_port *port, char *mac)
>+{
>+	struct prestera_msg_port_attr_req req = {
>+		.attr = PRESTERA_CMD_PORT_ATTR_MAC,
>+		.port = port->hw_id,
>+		.dev = port->dev_id
>+	};
>+	memcpy(&req.param.mac, mac, sizeof(req.param.mac));
>+
>+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
>+			    &req.cmd, sizeof(req));
>+}
>+
>+int prestera_hw_port_cap_get(const struct prestera_port *port,
>+			     struct prestera_port_caps *caps)
>+{
>+	struct prestera_msg_port_attr_resp resp;
>+	struct prestera_msg_port_attr_req req = {
>+		.attr = PRESTERA_CMD_PORT_ATTR_CAPABILITY,
>+		.port = port->hw_id,
>+		.dev = port->dev_id
>+	};
>+	int err;
>+
>+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
>+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
>+	if (err)
>+		return err;
>+
>+	caps->supp_link_modes = resp.param.cap.link_mode;
>+	caps->supp_fec = resp.param.cap.fec;
>+	caps->type = resp.param.cap.type;
>+	caps->transceiver = resp.param.cap.transceiver;
>+
>+	return err;
>+}
>+
>+int prestera_hw_port_autoneg_set(const struct prestera_port *port,
>+				 bool autoneg, u64 link_modes, u8 fec)
>+{
>+	struct prestera_msg_port_attr_req req = {
>+		.attr = PRESTERA_CMD_PORT_ATTR_AUTONEG,
>+		.port = port->hw_id,
>+		.dev = port->dev_id,
>+		.param = {.autoneg = {.link_mode = link_modes,
>+				      .enable = autoneg,
>+				      .fec = fec}
>+		}
>+	};
>+
>+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
>+			    &req.cmd, sizeof(req));
>+}
>+
>+int prestera_hw_port_stats_get(const struct prestera_port *port,
>+			       struct prestera_port_stats *st)
>+{
>+	struct prestera_msg_port_stats_resp resp;
>+	struct prestera_msg_port_attr_req req = {
>+		.attr = PRESTERA_CMD_PORT_ATTR_STATS,
>+		.port = port->hw_id,
>+		.dev = port->dev_id
>+	};
>+	u64 *hw = resp.stats;
>+	int err;
>+
>+	err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
>+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
>+	if (err)
>+		return err;
>+
>+	st->good_octets_received = hw[PRESTERA_PORT_GOOD_OCTETS_RCV_CNT];
>+	st->bad_octets_received = hw[PRESTERA_PORT_BAD_OCTETS_RCV_CNT];
>+	st->mac_trans_error = hw[PRESTERA_PORT_MAC_TRANSMIT_ERR_CNT];
>+	st->broadcast_frames_received = hw[PRESTERA_PORT_BRDC_PKTS_RCV_CNT];
>+	st->multicast_frames_received = hw[PRESTERA_PORT_MC_PKTS_RCV_CNT];
>+	st->frames_64_octets = hw[PRESTERA_PORT_PKTS_64L_CNT];
>+	st->frames_65_to_127_octets = hw[PRESTERA_PORT_PKTS_65TO127L_CNT];
>+	st->frames_128_to_255_octets = hw[PRESTERA_PORT_PKTS_128TO255L_CNT];
>+	st->frames_256_to_511_octets = hw[PRESTERA_PORT_PKTS_256TO511L_CNT];
>+	st->frames_512_to_1023_octets = hw[PRESTERA_PORT_PKTS_512TO1023L_CNT];
>+	st->frames_1024_to_max_octets = hw[PRESTERA_PORT_PKTS_1024TOMAXL_CNT];
>+	st->excessive_collision = hw[PRESTERA_PORT_EXCESSIVE_COLLISIONS_CNT];
>+	st->multicast_frames_sent = hw[PRESTERA_PORT_MC_PKTS_SENT_CNT];
>+	st->broadcast_frames_sent = hw[PRESTERA_PORT_BRDC_PKTS_SENT_CNT];
>+	st->fc_sent = hw[PRESTERA_PORT_FC_SENT_CNT];
>+	st->fc_received = hw[PRESTERA_PORT_GOOD_FC_RCV_CNT];
>+	st->buffer_overrun = hw[PRESTERA_PORT_DROP_EVENTS_CNT];
>+	st->undersize = hw[PRESTERA_PORT_UNDERSIZE_PKTS_CNT];
>+	st->fragments = hw[PRESTERA_PORT_FRAGMENTS_PKTS_CNT];
>+	st->oversize = hw[PRESTERA_PORT_OVERSIZE_PKTS_CNT];
>+	st->jabber = hw[PRESTERA_PORT_JABBER_PKTS_CNT];
>+	st->rx_error_frame_received = hw[PRESTERA_PORT_MAC_RCV_ERROR_CNT];
>+	st->bad_crc = hw[PRESTERA_PORT_BAD_CRC_CNT];
>+	st->collisions = hw[PRESTERA_PORT_COLLISIONS_CNT];
>+	st->late_collision = hw[PRESTERA_PORT_LATE_COLLISIONS_CNT];
>+	st->unicast_frames_received = hw[PRESTERA_PORT_GOOD_UC_PKTS_RCV_CNT];
>+	st->unicast_frames_sent = hw[PRESTERA_PORT_GOOD_UC_PKTS_SENT_CNT];
>+	st->sent_multiple = hw[PRESTERA_PORT_MULTIPLE_PKTS_SENT_CNT];
>+	st->sent_deferred = hw[PRESTERA_PORT_DEFERRED_PKTS_SENT_CNT];
>+	st->frames_1024_to_1518_octets = hw[PRESTERA_PORT_PKTS_1024TO1518L_CNT];
>+	st->frames_1519_to_max_octets = hw[PRESTERA_PORT_PKTS_1519TOMAXL_CNT];
>+	st->good_octets_sent = hw[PRESTERA_PORT_GOOD_OCTETS_SENT_CNT];
>+
>+	return 0;
>+}
>+
>+int prestera_hw_rxtx_init(struct prestera_switch *sw,
>+			  struct prestera_rxtx_params *params)
>+{
>+	struct prestera_msg_rxtx_resp resp;
>+	struct prestera_msg_rxtx_req req;
>+	int err;
>+
>+	req.use_sdma = params->use_sdma;
>+
>+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_RXTX_INIT,
>+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
>+	if (err)
>+		return err;
>+
>+	params->map_addr = resp.map_addr;
>+	return 0;
>+}
>+
>+int prestera_hw_rxtx_port_init(struct prestera_port *port)
>+{
>+	struct prestera_msg_rxtx_port_req req = {
>+		.port = port->hw_id,
>+		.dev = port->dev_id,
>+	};
>+
>+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_RXTX_PORT_INIT,
>+			    &req.cmd, sizeof(req));
>+}
>+
>+int prestera_hw_event_handler_register(struct prestera_switch *sw,
>+				       enum prestera_event_type type,
>+				       prestera_event_cb_t fn,
>+				       void *arg)
>+{
>+	struct prestera_fw_event_handler *eh;
>+
>+	eh = __find_event_handler(sw, type);
>+	if (eh)
>+		return -EEXIST;
>+	eh = kmalloc(sizeof(*eh), GFP_KERNEL);
>+	if (!eh)
>+		return -ENOMEM;
>+
>+	eh->type = type;
>+	eh->func = fn;
>+	eh->arg = arg;
>+
>+	INIT_LIST_HEAD(&eh->list);
>+
>+	list_add_rcu(&eh->list, &sw->event_handlers);
>+
>+	return 0;
>+}
>+
>+void prestera_hw_event_handler_unregister(struct prestera_switch *sw,
>+					  enum prestera_event_type type,
>+					  prestera_event_cb_t fn)
>+{
>+	struct prestera_fw_event_handler *eh;
>+
>+	eh = __find_event_handler(sw, type);
>+	if (!eh)
>+		return;
>+
>+	list_del_rcu(&eh->list);
>+	synchronize_rcu();
>+	kfree(eh);
>+}
>diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
>new file mode 100644
>index 000000000000..acb0e31d6684
>--- /dev/null
>+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
>@@ -0,0 +1,71 @@
>+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
>+ *
>+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
>+ *
>+ */
>+
>+#ifndef _PRESTERA_HW_H_
>+#define _PRESTERA_HW_H_
>+
>+#include <linux/types.h>
>+
>+enum {
>+	PRESTERA_PORT_TYPE_NONE,
>+	PRESTERA_PORT_TYPE_TP,
>+
>+	PRESTERA_PORT_TYPE_MAX,
>+};
>+
>+enum {
>+	PRESTERA_PORT_FEC_OFF,
>+
>+	PRESTERA_PORT_FEC_MAX,
>+};
>+
>+struct prestera_switch;
>+struct prestera_port;
>+struct prestera_port_stats;
>+struct prestera_port_caps;
>+enum prestera_event_type;
>+struct prestera_event;
>+
>+typedef void (*prestera_event_cb_t)
>+	(struct prestera_switch *sw, struct prestera_event *evt, void *arg);
>+
>+struct prestera_rxtx_params;
>+
>+/* Switch API */
>+int prestera_hw_switch_init(struct prestera_switch *sw);
>+int prestera_hw_switch_mac_set(struct prestera_switch *sw, char *mac);
>+
>+/* Port API */
>+int prestera_hw_port_info_get(const struct prestera_port *port,
>+			      u16 *fp_id, u32 *hw_id, u32 *dev_id);
>+int prestera_hw_port_state_set(const struct prestera_port *port,
>+			       bool admin_state);
>+int prestera_hw_port_mtu_set(const struct prestera_port *port, u32 mtu);
>+int prestera_hw_port_mtu_get(const struct prestera_port *port, u32 *mtu);
>+int prestera_hw_port_mac_set(const struct prestera_port *port, char *mac);
>+int prestera_hw_port_mac_get(const struct prestera_port *port, char *mac);
>+int prestera_hw_port_cap_get(const struct prestera_port *port,
>+			     struct prestera_port_caps *caps);
>+int prestera_hw_port_autoneg_set(const struct prestera_port *port,
>+				 bool autoneg, u64 link_modes, u8 fec);
>+int prestera_hw_port_stats_get(const struct prestera_port *port,
>+			       struct prestera_port_stats *stats);
>+
>+/* Event handlers */
>+int prestera_hw_event_handler_register(struct prestera_switch *sw,
>+				       enum prestera_event_type type,
>+				       prestera_event_cb_t fn,
>+				       void *arg);
>+void prestera_hw_event_handler_unregister(struct prestera_switch *sw,
>+					  enum prestera_event_type type,
>+					  prestera_event_cb_t fn);
>+
>+/* RX/TX */
>+int prestera_hw_rxtx_init(struct prestera_switch *sw,
>+			  struct prestera_rxtx_params *params);
>+int prestera_hw_rxtx_port_init(struct prestera_port *port);
>+
>+#endif /* _PRESTERA_HW_H_ */
>diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
>new file mode 100644
>index 000000000000..556941d97d4d
>--- /dev/null
>+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
>@@ -0,0 +1,825 @@
>+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
>+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
>+
>+#include <linux/platform_device.h>
>+#include <linux/of.h>
>+#include <linux/of_address.h>
>+#include <linux/of_device.h>
>+#include <linux/dmapool.h>
>+#include <linux/netdevice.h>
>+#include <linux/etherdevice.h>
>+#include <linux/if_vlan.h>
>+
>+#include "prestera.h"
>+#include "prestera_hw.h"
>+#include "prestera_dsa.h"
>+
>+struct prestera_sdma_desc {
>+	__le32 word1;
>+	__le32 word2;
>+	__le32 buff;
>+	__le32 next;
>+} __packed __aligned(16);
>+
>+#define SDMA_BUFF_SIZE_MAX	1544
>+
>+#define SDMA_RX_DESC_PKT_LEN(desc) \
>+	((le32_to_cpu((desc)->word2) >> 16) & 0x3FFF)
>+
>+#define SDMA_RX_DESC_OWNER(desc) \
>+	((le32_to_cpu((desc)->word1) & BIT(31)) >> 31)
>+
>+#define SDMA_RX_DESC_CPU_OWN	0
>+#define SDMA_RX_DESC_DMA_OWN	1
>+
>+#define SDMA_RX_QUEUE_NUM	8
>+
>+#define SDMA_RX_DESC_PER_Q	1000
>+
>+#define SDMA_TX_DESC_PER_Q	1000
>+#define SDMA_TX_MAX_BURST	64
>+
>+#define SDMA_TX_DESC_OWNER(desc) \
>+	((le32_to_cpu((desc)->word1) & BIT(31)) >> 31)
>+
>+#define SDMA_TX_DESC_CPU_OWN	0
>+#define SDMA_TX_DESC_DMA_OWN	1
>+
>+#define SDMA_TX_DESC_IS_SENT(desc) \
>+	(SDMA_TX_DESC_OWNER(desc) == SDMA_TX_DESC_CPU_OWN)
>+
>+#define SDMA_TX_DESC_LAST	BIT(20)
>+#define SDMA_TX_DESC_FIRST	BIT(21)
>+#define SDMA_TX_DESC_SINGLE	(SDMA_TX_DESC_FIRST | SDMA_TX_DESC_LAST)
>+#define SDMA_TX_DESC_CALC_CRC	BIT(12)
>+
>+#define SDMA_RX_INTR_MASK_REG		0x2814
>+#define SDMA_RX_QUEUE_STATUS_REG	0x2680
>+#define SDMA_RX_QUEUE_DESC_REG(n)	(0x260C + (n) * 16)
>+
>+#define SDMA_TX_QUEUE_DESC_REG		0x26C0
>+#define SDMA_TX_QUEUE_START_REG		0x2868

You forgot to prefix these.


>+
>+struct prestera_sdma_buf {
>+	struct prestera_sdma_desc *desc;
>+	dma_addr_t desc_dma;
>+	struct sk_buff *skb;
>+	dma_addr_t buf_dma;
>+	bool is_used;
>+};
>+
>+struct prestera_rx_ring {
>+	struct prestera_sdma_buf *bufs;
>+	int next_rx;
>+};
>+
>+struct prestera_tx_ring {
>+	struct prestera_sdma_buf *bufs;
>+	int next_tx;
>+	int max_burst;
>+	int burst;
>+};
>+
>+struct prestera_sdma {
>+	struct prestera_rx_ring rx_ring[SDMA_RX_QUEUE_NUM];
>+	struct prestera_tx_ring tx_ring;
>+	const struct prestera_switch *sw;
>+	struct dma_pool *desc_pool;
>+	struct work_struct tx_work;
>+	struct napi_struct rx_napi;
>+	struct net_device napi_dev;
>+	u32 map_addr;
>+	u64 dma_mask;
>+};
>+
>+struct prestera_rxtx {
>+	struct prestera_sdma sdma;
>+};
>+
>+static int prestera_sdma_buf_init(struct prestera_sdma *sdma,
>+				  struct prestera_sdma_buf *buf)
>+{
>+	struct device *dma_dev = sdma->sw->dev->dev;
>+	struct prestera_sdma_desc *desc;
>+	dma_addr_t dma;
>+
>+	desc = dma_pool_alloc(sdma->desc_pool, GFP_DMA | GFP_KERNEL, &dma);
>+	if (!desc)
>+		return -ENOMEM;
>+
>+	if (dma + sizeof(struct prestera_sdma_desc) > sdma->dma_mask) {
>+		dev_err(dma_dev, "failed to alloc desc\n");
>+		dma_pool_free(sdma->desc_pool, desc, dma);
>+		return -ENOMEM;
>+	}
>+
>+	buf->buf_dma = DMA_MAPPING_ERROR;
>+	buf->desc_dma = dma;
>+	buf->desc = desc;
>+	buf->skb = NULL;
>+
>+	return 0;
>+}
>+
>+static u32 prestera_sdma_map(struct prestera_sdma *sdma, dma_addr_t pa)
>+{
>+	return sdma->map_addr + pa;
>+}
>+
>+static void prestera_sdma_rx_desc_set_len(struct prestera_sdma_desc *desc,
>+					  size_t val)
>+{
>+	u32 word = le32_to_cpu(desc->word2);
>+
>+	word = (word & ~GENMASK(15, 0)) | val;
>+	desc->word2 = cpu_to_le32(word);
>+}
>+
>+static void prestera_sdma_rx_desc_init(struct prestera_sdma *sdma,
>+				       struct prestera_sdma_desc *desc,
>+				       dma_addr_t buf)
>+{
>+	prestera_sdma_rx_desc_set_len(desc, SDMA_BUFF_SIZE_MAX);
>+	desc->buff = cpu_to_le32(prestera_sdma_map(sdma, buf));
>+
>+	/* make sure buffer is set before reset the descriptor */
>+	wmb();
>+
>+	desc->word1 = cpu_to_le32(0xA0000000);
>+}
>+
>+static void prestera_sdma_rx_desc_set_next(struct prestera_sdma *sdma,
>+					   struct prestera_sdma_desc *desc,
>+					   dma_addr_t next)
>+{
>+	desc->next = cpu_to_le32(prestera_sdma_map(sdma, next));
>+}
>+
>+static int prestera_sdma_rx_skb_alloc(struct prestera_sdma *sdma,
>+				      struct prestera_sdma_buf *buf)
>+{
>+	struct device *dev = sdma->sw->dev->dev;
>+	struct sk_buff *skb;
>+	dma_addr_t dma;
>+
>+	skb = alloc_skb(SDMA_BUFF_SIZE_MAX, GFP_DMA | GFP_ATOMIC);
>+	if (!skb)
>+		return -ENOMEM;
>+
>+	dma = dma_map_single(dev, skb->data, skb->len, DMA_FROM_DEVICE);
>+
>+	if (dma_mapping_error(dev, dma))
>+		goto err_dma_map;
>+	if (dma + skb->len > sdma->dma_mask)
>+		goto err_dma_range;
>+
>+	if (buf->skb)
>+		dma_unmap_single(dev, buf->buf_dma, buf->skb->len,
>+				 DMA_FROM_DEVICE);
>+
>+	buf->buf_dma = dma;
>+	buf->skb = skb;
>+	return 0;
>+
>+err_dma_range:
>+	dma_unmap_single(dev, dma, skb->len, DMA_FROM_DEVICE);
>+err_dma_map:
>+	kfree_skb(skb);
>+
>+	return -ENOMEM;
>+}
>+
>+static struct sk_buff *prestera_sdma_rx_skb_get(struct prestera_sdma *sdma,
>+						struct prestera_sdma_buf *buf)
>+{
>+	dma_addr_t buf_dma = buf->buf_dma;
>+	struct sk_buff *skb = buf->skb;
>+	u32 len = skb->len;
>+	int err;
>+
>+	err = prestera_sdma_rx_skb_alloc(sdma, buf);
>+	if (err) {
>+		buf->buf_dma = buf_dma;
>+		buf->skb = skb;
>+
>+		skb = alloc_skb(skb->len, GFP_ATOMIC);
>+		if (skb) {
>+			skb_put(skb, len);
>+			skb_copy_from_linear_data(buf->skb, skb->data, len);
>+		}
>+	}
>+
>+	prestera_sdma_rx_desc_init(sdma, buf->desc, buf->buf_dma);
>+
>+	return skb;
>+}
>+
>+static int prestera_rxtx_process_skb(struct sk_buff *skb)
>+{
>+	const struct prestera_port *port;
>+	struct prestera_dsa dsa;
>+	u32 hw_port, hw_id;
>+	int err;
>+
>+	skb_pull(skb, ETH_HLEN);
>+
>+	/* ethertype field is part of the dsa header */
>+	err = prestera_dsa_parse(&dsa, skb->data - ETH_TLEN);
>+	if (err)
>+		return err;
>+
>+	hw_port = dsa.port_num;
>+	hw_id = dsa.hw_dev_num;
>+
>+	port = prestera_port_find_by_hwid(hw_id, hw_port);
>+	if (unlikely(!port)) {
>+		pr_warn_ratelimited("prestera: received pkt for non-existent port(%u, %u)\n",
>+				    hw_id, hw_port);
>+		return -EEXIST;
>+	}
>+
>+	if (unlikely(!pskb_may_pull(skb, PRESTERA_DSA_HLEN)))
>+		return -EINVAL;
>+
>+	/* remove DSA tag and update checksum */
>+	skb_pull_rcsum(skb, PRESTERA_DSA_HLEN);
>+
>+	memmove(skb->data - ETH_HLEN, skb->data - ETH_HLEN - PRESTERA_DSA_HLEN,
>+		ETH_ALEN * 2);
>+
>+	skb_push(skb, ETH_HLEN);
>+
>+	skb->protocol = eth_type_trans(skb, port->dev);
>+
>+	if (dsa.vlan.is_tagged) {
>+		u16 tci = dsa.vlan.vid & VLAN_VID_MASK;
>+
>+		tci |= dsa.vlan.vpt << VLAN_PRIO_SHIFT;
>+		if (dsa.vlan.cfi_bit)
>+			tci |= VLAN_CFI_MASK;
>+
>+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), tci);
>+	}
>+
>+	return 0;
>+}
>+
>+static int prestera_sdma_rx_poll(struct napi_struct *napi, int budget)
>+{
>+	unsigned int qmask = GENMASK(SDMA_RX_QUEUE_NUM - 1, 0);
>+	struct prestera_sdma *sdma;
>+	unsigned int rxq_done_map = 0;
>+	struct list_head rx_list;
>+	int pkts_done = 0;
>+	int q;
>+
>+	INIT_LIST_HEAD(&rx_list);
>+
>+	sdma = container_of(napi, struct prestera_sdma, rx_napi);
>+
>+	while (pkts_done < budget && rxq_done_map != qmask) {
>+		for (q = 0; q < SDMA_RX_QUEUE_NUM && pkts_done < budget; q++) {
>+			struct prestera_rx_ring *ring = &sdma->rx_ring[q];
>+			int buf_idx = ring->next_rx;
>+			struct prestera_sdma_desc *desc;
>+			struct prestera_sdma_buf *buf;
>+			struct sk_buff *skb;
>+
>+			buf = &ring->bufs[buf_idx];
>+			desc = buf->desc;
>+
>+			if (SDMA_RX_DESC_OWNER(desc) != SDMA_RX_DESC_CPU_OWN) {
>+				rxq_done_map |= BIT(q);
>+				continue;
>+			} else {
>+				rxq_done_map &= ~BIT(q);
>+			}
>+
>+			pkts_done++;
>+
>+			__skb_trim(buf->skb, SDMA_RX_DESC_PKT_LEN(desc));
>+
>+			skb = prestera_sdma_rx_skb_get(sdma, buf);
>+			if (!skb)
>+				goto rx_next_buf;
>+
>+			if (unlikely(prestera_rxtx_process_skb(skb)))
>+				goto rx_next_buf;
>+
>+			list_add_tail(&skb->list, &rx_list);
>+rx_next_buf:
>+			ring->next_rx = (buf_idx + 1) % SDMA_RX_DESC_PER_Q;
>+		}
>+	}
>+
>+	if (pkts_done < budget && napi_complete_done(napi, pkts_done))
>+		prestera_write(sdma->sw, SDMA_RX_INTR_MASK_REG, 0xff << 2);
>+
>+	netif_receive_skb_list(&rx_list);
>+
>+	return pkts_done;
>+}
>+
>+static void prestera_sdma_rx_fini(struct prestera_sdma *sdma)
>+{
>+	int q, b;
>+
>+	/* disable all rx queues */
>+	prestera_write(sdma->sw, SDMA_RX_QUEUE_STATUS_REG, 0xff00);
>+
>+	for (q = 0; q < SDMA_RX_QUEUE_NUM; q++) {
>+		struct prestera_rx_ring *ring = &sdma->rx_ring[q];
>+
>+		if (!ring->bufs)
>+			break;
>+
>+		for (b = 0; b < SDMA_RX_DESC_PER_Q; b++) {
>+			struct prestera_sdma_buf *buf = &ring->bufs[b];
>+
>+			if (buf->desc_dma)
>+				dma_pool_free(sdma->desc_pool, buf->desc,
>+					      buf->desc_dma);
>+
>+			if (!buf->skb)
>+				continue;
>+
>+			if (buf->buf_dma != DMA_MAPPING_ERROR)
>+				dma_unmap_single(sdma->sw->dev->dev,
>+						 buf->buf_dma, buf->skb->len,
>+						 DMA_FROM_DEVICE);
>+			kfree_skb(buf->skb);
>+		}
>+	}
>+}
>+
>+static int prestera_sdma_rx_init(struct prestera_sdma *sdma)
>+{
>+	int q, b;
>+	int err;
>+
>+	/* disable all rx queues */
>+	prestera_write(sdma->sw, SDMA_RX_QUEUE_STATUS_REG, 0xff00);
>+
>+	for (q = 0; q < SDMA_RX_QUEUE_NUM; q++) {
>+		struct prestera_rx_ring *ring = &sdma->rx_ring[q];
>+		struct prestera_sdma_buf *head;
>+
>+		ring->bufs = kmalloc_array(SDMA_RX_DESC_PER_Q, sizeof(*head),
>+					   GFP_KERNEL);
>+		if (!ring->bufs)
>+			return -ENOMEM;
>+
>+		head = &ring->bufs[0];
>+		ring->next_rx = 0;
>+
>+		for (b = 0; b < SDMA_RX_DESC_PER_Q; b++) {
>+			struct prestera_sdma_buf *buf = &ring->bufs[b];
>+
>+			err = prestera_sdma_buf_init(sdma, buf);
>+			if (err)
>+				return err;
>+
>+			err = prestera_sdma_rx_skb_alloc(sdma, buf);
>+			if (err)
>+				return err;
>+
>+			prestera_sdma_rx_desc_init(sdma, buf->desc,
>+						   buf->buf_dma);
>+
>+			if (b == 0)
>+				continue;
>+
>+			prestera_sdma_rx_desc_set_next(sdma,
>+						       ring->bufs[b - 1].desc,
>+						       buf->desc_dma);
>+
>+			if (b == SDMA_RX_DESC_PER_Q - 1)
>+				prestera_sdma_rx_desc_set_next(sdma, buf->desc,
>+							       head->desc_dma);
>+		}
>+
>+		prestera_write(sdma->sw, SDMA_RX_QUEUE_DESC_REG(q),
>+			       prestera_sdma_map(sdma, head->desc_dma));
>+	}
>+
>+	/* make sure all rx descs are filled before enabling all rx queues */
>+	wmb();
>+
>+	prestera_write(sdma->sw, SDMA_RX_QUEUE_STATUS_REG, 0xff);
>+
>+	return 0;
>+}
>+
>+static void prestera_sdma_tx_desc_init(struct prestera_sdma *sdma,
>+				       struct prestera_sdma_desc *desc)
>+{
>+	desc->word1 = cpu_to_le32(SDMA_TX_DESC_SINGLE | SDMA_TX_DESC_CALC_CRC);
>+	desc->word2 = 0;
>+}
>+
>+static void prestera_sdma_tx_desc_set_next(struct prestera_sdma *sdma,
>+					   struct prestera_sdma_desc *desc,
>+					   dma_addr_t next)
>+{
>+	desc->next = cpu_to_le32(prestera_sdma_map(sdma, next));
>+}
>+
>+static void prestera_sdma_tx_desc_set_buf(struct prestera_sdma *sdma,
>+					  struct prestera_sdma_desc *desc,
>+					  dma_addr_t buf, size_t len)
>+{
>+	u32 word = le32_to_cpu(desc->word2);
>+
>+	word = (word & ~GENMASK(30, 16)) | ((len + ETH_FCS_LEN) << 16);
>+
>+	desc->buff = cpu_to_le32(prestera_sdma_map(sdma, buf));
>+	desc->word2 = cpu_to_le32(word);
>+}
>+
>+static void prestera_sdma_tx_desc_xmit(struct prestera_sdma_desc *desc)
>+{
>+	u32 word = le32_to_cpu(desc->word1);
>+
>+	word |= (SDMA_TX_DESC_DMA_OWN << 31);

Drop the ()s here.


>+
>+	/* make sure everything is written before enable xmit */
>+	wmb();
>+
>+	desc->word1 = cpu_to_le32(word);
>+}
>+
>+static int prestera_sdma_tx_buf_map(struct prestera_sdma *sdma,
>+				    struct prestera_sdma_buf *buf,
>+				    struct sk_buff *skb)
>+{
>+	struct device *dma_dev = sdma->sw->dev->dev;
>+	struct sk_buff *new_skb;
>+	size_t len = skb->len;
>+	dma_addr_t dma;
>+
>+	dma = dma_map_single(dma_dev, skb->data, len, DMA_TO_DEVICE);
>+	if (!dma_mapping_error(dma_dev, dma) && dma + len <= sdma->dma_mask) {
>+		buf->buf_dma = dma;
>+		buf->skb = skb;
>+		return 0;
>+	}
>+
>+	if (!dma_mapping_error(dma_dev, dma))
>+		dma_unmap_single(dma_dev, dma, len, DMA_TO_DEVICE);
>+
>+	new_skb = alloc_skb(len, GFP_ATOMIC | GFP_DMA);
>+	if (!new_skb)
>+		goto err_alloc_skb;
>+
>+	dma = dma_map_single(dma_dev, new_skb->data, len, DMA_TO_DEVICE);
>+	if (dma_mapping_error(dma_dev, dma))
>+		goto err_dma_map;
>+	if (dma + len > sdma->dma_mask)
>+		goto err_dma_range;
>+
>+	skb_copy_from_linear_data(skb, skb_put(new_skb, len), len);
>+
>+	dev_consume_skb_any(skb);
>+
>+	buf->skb = new_skb;
>+	buf->buf_dma = dma;
>+
>+	return 0;
>+
>+err_dma_range:
>+	dma_unmap_single(dma_dev, dma, len, DMA_TO_DEVICE);
>+err_dma_map:
>+	dev_kfree_skb(new_skb);
>+err_alloc_skb:
>+	dev_kfree_skb(skb);
>+
>+	return -ENOMEM;
>+}
>+
>+static void prestera_sdma_tx_buf_unmap(struct prestera_sdma *sdma,
>+				       struct prestera_sdma_buf *buf)
>+{
>+	struct device *dma_dev = sdma->sw->dev->dev;
>+
>+	dma_unmap_single(dma_dev, buf->buf_dma, buf->skb->len, DMA_TO_DEVICE);
>+}
>+
>+static void prestera_sdma_tx_recycle_work_fn(struct work_struct *work)
>+{
>+	struct prestera_tx_ring *tx_ring;
>+	struct prestera_sdma *sdma;
>+	struct device *dma_dev;
>+	int b;
>+
>+	sdma = container_of(work, struct prestera_sdma, tx_work);
>+
>+	dma_dev = sdma->sw->dev->dev;
>+	tx_ring = &sdma->tx_ring;
>+
>+	for (b = 0; b < SDMA_TX_DESC_PER_Q; b++) {
>+		struct prestera_sdma_buf *buf = &tx_ring->bufs[b];
>+
>+		if (!buf->is_used)
>+			continue;
>+
>+		if (!SDMA_TX_DESC_IS_SENT(buf->desc))
>+			continue;
>+
>+		prestera_sdma_tx_buf_unmap(sdma, buf);
>+		dev_consume_skb_any(buf->skb);
>+		buf->skb = NULL;
>+
>+		/* make sure everything is cleaned up */
>+		wmb();
>+
>+		buf->is_used = false;
>+	}
>+}
>+
>+static int prestera_sdma_tx_init(struct prestera_sdma *sdma)
>+{
>+	struct prestera_tx_ring *tx_ring = &sdma->tx_ring;
>+	struct prestera_sdma_buf *head;
>+	int err;
>+	int b;
>+
>+	INIT_WORK(&sdma->tx_work, prestera_sdma_tx_recycle_work_fn);
>+
>+	tx_ring->bufs = kmalloc_array(SDMA_TX_DESC_PER_Q, sizeof(*head),
>+				      GFP_KERNEL);
>+	if (!tx_ring->bufs)
>+		return -ENOMEM;
>+
>+	head = &tx_ring->bufs[0];
>+
>+	tx_ring->max_burst = SDMA_TX_MAX_BURST;
>+	tx_ring->burst = tx_ring->max_burst;
>+	tx_ring->next_tx = 0;
>+
>+	for (b = 0; b < SDMA_TX_DESC_PER_Q; b++) {
>+		struct prestera_sdma_buf *buf = &tx_ring->bufs[b];
>+
>+		err = prestera_sdma_buf_init(sdma, buf);
>+		if (err)
>+			return err;
>+
>+		prestera_sdma_tx_desc_init(sdma, buf->desc);
>+
>+		buf->is_used = false;
>+
>+		if (b == 0)
>+			continue;
>+
>+		prestera_sdma_tx_desc_set_next(sdma, tx_ring->bufs[b - 1].desc,
>+					       buf->desc_dma);
>+
>+		if (b == SDMA_TX_DESC_PER_Q - 1)
>+			prestera_sdma_tx_desc_set_next(sdma, buf->desc,
>+						       head->desc_dma);
>+	}
>+
>+	/* make sure descriptors are written */
>+	wmb();
>+
>+	prestera_write(sdma->sw, SDMA_TX_QUEUE_DESC_REG,
>+		       prestera_sdma_map(sdma, head->desc_dma));
>+
>+	return 0;
>+}
>+
>+static void prestera_sdma_tx_fini(struct prestera_sdma *sdma)
>+{
>+	struct prestera_tx_ring *ring = &sdma->tx_ring;
>+	int b;
>+
>+	cancel_work_sync(&sdma->tx_work);
>+
>+	if (!ring->bufs)
>+		return;
>+
>+	for (b = 0; b < SDMA_TX_DESC_PER_Q; b++) {
>+		struct prestera_sdma_buf *buf = &ring->bufs[b];
>+
>+		if (buf->desc)
>+			dma_pool_free(sdma->desc_pool, buf->desc,
>+				      buf->desc_dma);
>+
>+		if (!buf->skb)
>+			continue;
>+
>+		dma_unmap_single(sdma->sw->dev->dev, buf->buf_dma,
>+				 buf->skb->len, DMA_TO_DEVICE);
>+
>+		dev_consume_skb_any(buf->skb);
>+	}
>+}
>+
>+static void prestera_rxtx_handle_event(struct prestera_switch *sw,
>+				       struct prestera_event *evt,
>+				       void *arg)
>+{
>+	struct prestera_sdma *sdma = arg;
>+
>+	if (evt->id != PRESTERA_RXTX_EVENT_RCV_PKT)
>+		return;
>+
>+	prestera_write(sdma->sw, SDMA_RX_INTR_MASK_REG, 0);
>+	napi_schedule(&sdma->rx_napi);
>+}
>+
>+int prestera_sdma_switch_init(struct prestera_switch *sw)
>+{
>+	struct prestera_sdma *sdma = &sw->rxtx->sdma;
>+	struct device *dev = sw->dev->dev;
>+	struct prestera_rxtx_params p;
>+	int err;
>+
>+	p.use_sdma = true;
>+
>+	err = prestera_hw_rxtx_init(sw, &p);
>+	if (err) {
>+		dev_err(dev, "failed to init rxtx by hw\n");
>+		return err;
>+	}
>+
>+	sdma->dma_mask = dma_get_mask(dev);
>+	sdma->map_addr = p.map_addr;
>+	sdma->sw = sw;
>+
>+	sdma->desc_pool = dma_pool_create("desc_pool", dev,
>+					  sizeof(struct prestera_sdma_desc),
>+					  16, 0);
>+	if (!sdma->desc_pool)
>+		return -ENOMEM;
>+
>+	err = prestera_sdma_rx_init(sdma);
>+	if (err) {
>+		dev_err(dev, "failed to init rx ring\n");
>+		goto err_rx_init;
>+	}
>+
>+	err = prestera_sdma_tx_init(sdma);
>+	if (err) {
>+		dev_err(dev, "failed to init tx ring\n");
>+		goto err_tx_init;
>+	}
>+
>+	err = prestera_hw_event_handler_register(sw, PRESTERA_EVENT_TYPE_RXTX,
>+						 prestera_rxtx_handle_event,
>+						 sdma);
>+	if (err)
>+		goto err_evt_register;
>+
>+	init_dummy_netdev(&sdma->napi_dev);
>+
>+	netif_napi_add(&sdma->napi_dev, &sdma->rx_napi, prestera_sdma_rx_poll, 64);
>+	napi_enable(&sdma->rx_napi);
>+
>+	return 0;
>+
>+err_evt_register:
>+err_tx_init:
>+	prestera_sdma_tx_fini(sdma);
>+err_rx_init:
>+	prestera_sdma_rx_fini(sdma);
>+
>+	dma_pool_destroy(sdma->desc_pool);
>+	return err;
>+}
>+
>+void prestera_sdma_switch_fini(struct prestera_switch *sw)
>+{
>+	struct prestera_sdma *sdma = &sw->rxtx->sdma;
>+
>+	prestera_hw_event_handler_unregister(sw, PRESTERA_EVENT_TYPE_RXTX,
>+					     prestera_rxtx_handle_event);
>+	napi_disable(&sdma->rx_napi);
>+	netif_napi_del(&sdma->rx_napi);
>+	prestera_sdma_rx_fini(sdma);
>+	prestera_sdma_tx_fini(sdma);
>+	dma_pool_destroy(sdma->desc_pool);
>+}
>+
>+static int prestera_sdma_tx_wait(struct prestera_sdma *sdma,
>+				 struct prestera_tx_ring *tx_ring)
>+{
>+	int tx_retry_num = 10 * tx_ring->max_burst;
>+
>+	while (--tx_retry_num) {
>+		if (!(prestera_read(sdma->sw, SDMA_TX_QUEUE_START_REG) & 1))
>+			return 0;
>+
>+		udelay(1);
>+	}
>+
>+	return -EBUSY;
>+}
>+
>+static void prestera_sdma_tx_start(struct prestera_sdma *sdma)
>+{
>+	prestera_write(sdma->sw, SDMA_TX_QUEUE_START_REG, 1);
>+	schedule_work(&sdma->tx_work);
>+}
>+
>+netdev_tx_t prestera_sdma_xmit(struct prestera_sdma *sdma, struct sk_buff *skb)
>+{
>+	struct device *dma_dev = sdma->sw->dev->dev;
>+	struct prestera_tx_ring *tx_ring;
>+	struct net_device *dev = skb->dev;
>+	struct prestera_sdma_buf *buf;
>+	int err;
>+
>+	tx_ring = &sdma->tx_ring;
>+
>+	buf = &tx_ring->bufs[tx_ring->next_tx];
>+	if (buf->is_used) {
>+		schedule_work(&sdma->tx_work);
>+		goto drop_skb;
>+	}

What is preventing 2 CPUs to get here and work with the same buf?



>+
>+	if (unlikely(eth_skb_pad(skb)))
>+		goto drop_skb_nofree;
>+
>+	err = prestera_sdma_tx_buf_map(sdma, buf, skb);
>+	if (err)
>+		goto drop_skb;
>+
>+	prestera_sdma_tx_desc_set_buf(sdma, buf->desc, buf->buf_dma, skb->len);
>+
>+	dma_sync_single_for_device(dma_dev, buf->buf_dma, skb->len,
>+				   DMA_TO_DEVICE);
>+
>+	if (!tx_ring->burst--) {
>+		tx_ring->burst = tx_ring->max_burst;
>+
>+		err = prestera_sdma_tx_wait(sdma, tx_ring);
>+		if (err)
>+			goto drop_skb_unmap;
>+	}
>+
>+	tx_ring->next_tx = (tx_ring->next_tx + 1) % SDMA_TX_DESC_PER_Q;
>+	prestera_sdma_tx_desc_xmit(buf->desc);
>+	buf->is_used = true;
>+
>+	prestera_sdma_tx_start(sdma);
>+
>+	return NETDEV_TX_OK;
>+
>+drop_skb_unmap:
>+	prestera_sdma_tx_buf_unmap(sdma, buf);
>+drop_skb:
>+	dev_consume_skb_any(skb);
>+drop_skb_nofree:
>+	dev->stats.tx_dropped++;
>+	return NETDEV_TX_OK;
>+}
>+
>+int prestera_rxtx_switch_init(struct prestera_switch *sw)
>+{
>+	struct prestera_rxtx *rxtx;
>+
>+	rxtx = kzalloc(sizeof(*rxtx), GFP_KERNEL);
>+	if (!rxtx)
>+		return -ENOMEM;
>+
>+	sw->rxtx = rxtx;
>+
>+	return prestera_sdma_switch_init(sw);
>+}
>+
>+void prestera_rxtx_switch_fini(struct prestera_switch *sw)
>+{
>+	prestera_sdma_switch_fini(sw);
>+	kfree(sw->rxtx);
>+}
>+
>+int prestera_rxtx_port_init(struct prestera_port *port)
>+{
>+	int err;
>+
>+	err = prestera_hw_rxtx_port_init(port);
>+	if (err)
>+		return err;
>+
>+	port->dev->needed_headroom = PRESTERA_DSA_HLEN + ETH_FCS_LEN;
>+	return 0;
>+}
>+
>+netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct sk_buff *skb)

Why this has "rx" in the name??


>+{
>+	struct prestera_dsa dsa;
>+
>+	dsa.hw_dev_num = port->dev_id;
>+	dsa.port_num = port->hw_id;
>+
>+	if (skb_cow_head(skb, PRESTERA_DSA_HLEN) < 0)
>+		return NET_XMIT_DROP;
>+
>+	skb_push(skb, PRESTERA_DSA_HLEN);
>+	memmove(skb->data, skb->data + PRESTERA_DSA_HLEN, 2 * ETH_ALEN);
>+
>+	if (prestera_dsa_build(&dsa, skb->data + 2 * ETH_ALEN) != 0)
>+		return NET_XMIT_DROP;
>+
>+	return prestera_sdma_xmit(&port->sw->rxtx->sdma, skb);
>+}
>diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
>new file mode 100644
>index 000000000000..bbbadfa5accf
>--- /dev/null
>+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
>@@ -0,0 +1,21 @@
>+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
>+ *
>+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
>+ *
>+ */
>+
>+#ifndef _PRESTERA_RXTX_H_
>+#define _PRESTERA_RXTX_H_
>+
>+#include <linux/netdevice.h>
>+
>+#include "prestera.h"
>+
>+int prestera_rxtx_switch_init(struct prestera_switch *sw);
>+void prestera_rxtx_switch_fini(struct prestera_switch *sw);
>+
>+int prestera_rxtx_port_init(struct prestera_port *port);
>+
>+netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct sk_buff *skb);
>+
>+#endif /* _PRESTERA_RXTX_H_ */
>-- 
>2.17.1
>
