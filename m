Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A260A1ED1EA
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 16:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgFCOQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 10:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgFCOQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 10:16:35 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CF9C08C5C1
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 07:16:35 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u26so4648787wmn.1
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 07:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LMJUzlHQiGip4acEF2/cl30byATvrjvit2jFY84eZr0=;
        b=JQijf8RADQb+9sOzcBfuuJpEPXgoSRmYVBVxBuVJdPPFZ5CAfSeTAbZnVRKSL/7Jb1
         qui4iJ0bgp+osINXpX75We5R4k8l/xj3yB0XMF2Zn0wR5MrUj4jV+HsSFOB1C6xvnttI
         dHyLI3HL3H/rPMlm9TdQSzmoJaMUGmDuEDkuESIiVNcU91zJCKbUqfqZg075NpqhpKT6
         ofpAzX6ifUY4jgJtTWFheF2sMsdqaDZ5prVNk8cdSsosNCZh7nExcYI17KIcZwcHPbCI
         He8166Ow68vkaen+IAdwUR2FkuDjN3eyxnIwOwFnXbpaPy4US3bC/9jomdo/5/Snt3wB
         Wo+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LMJUzlHQiGip4acEF2/cl30byATvrjvit2jFY84eZr0=;
        b=FjskL0U3ZrppjCJOnW1mZEeTtfpCJApMUjLcNZ5liT59Hrnc5g1WaoLmXObfHGiUAP
         MslyfoUcqrGy+k9zX8sFWXl+jHiIoc9smIxc/bgncG+4rH5f0hebRHwNjPnRz+ib4MNe
         ZMr/5cKVBrg+USXLyinqXksKw4TXoKxuHEI/TzB1aEuhi7v999JE4c8vVE731xfKnVsA
         5v9xPKeYh4vG2zKvDUO2p25/LqnEpmp5lrBBJ3dUgOhoujdXhv5nPyuuyhOtE1VSKKz2
         Ugl6E3QmCbVy54TveZr7gogehI/1uwEVWY1dN/D7zDjqRmjSFe2D8Xd1meWiHWhTiN16
         mPpw==
X-Gm-Message-State: AOAM5322RRBMivV7iLuWp4ZDrYHaadJvdIOi7TOfqX/E+kp7mIVX+pdO
        mgVDrFCiZfCX68hotH56u2W3Fw==
X-Google-Smtp-Source: ABdhPJyD3vm6Dr3U7AFlLulYyXu/i2F+XGotyvR45DbX6fLDBqhVteikogf9bj2oBC6mutobck+A8w==
X-Received: by 2002:a1c:6744:: with SMTP id b65mr8904637wmc.170.1591193793934;
        Wed, 03 Jun 2020 07:16:33 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h18sm3549738wru.7.2020.06.03.07.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 07:16:33 -0700 (PDT)
Date:   Wed, 3 Jun 2020 16:16:32 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next 1/6] net: marvell: prestera: Add driver for Prestera
 family ASIC devices
Message-ID: <20200603141632.GA2274@nanopsycho.orion>
References: <20200528151245.7592-1-vadym.kochan@plvision.eu>
 <20200528151245.7592-2-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528151245.7592-2-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 28, 2020 at 05:12:40PM CEST, vadym.kochan@plvision.eu wrote:

[...]

>+}
>+
>+int prestera_hw_port_info_get(const struct prestera_port *port,
>+			      u16 *fp_id, u32 *hw_id, u32 *dev_id)

Please unify the ordering of "hw_id" and "dev_id" with the rest of the
functions having the same args.



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

Try to avoid use of synchronice rcu. You can rather do:
kfree_rcu(eh, rcu);


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
>diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
>new file mode 100644
>index 000000000000..b5241e9b784a
>--- /dev/null
>+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
>@@ -0,0 +1,506 @@
>+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
>+/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
>+
>+#include <linux/kernel.h>
>+#include <linux/module.h>
>+#include <linux/list.h>
>+#include <linux/netdevice.h>
>+#include <linux/netdev_features.h>
>+#include <linux/etherdevice.h>
>+#include <linux/jiffies.h>
>+#include <linux/of.h>
>+#include <linux/of_net.h>
>+
>+#include "prestera.h"
>+#include "prestera_hw.h"
>+#include "prestera_rxtx.h"
>+
>+#define PRESTERA_MTU_DEFAULT 1536
>+
>+#define PRESTERA_STATS_DELAY_MS	msecs_to_jiffies(1000)
>+
>+static struct workqueue_struct *prestera_wq;
>+
>+struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
>+						 u32 dev_id, u32 hw_id)

This is confusing. The called is calling this like:
	port = prestera_port_find_by_hwid(sdma->sw, hw_id, hw_port);

You are mixing hw_id and dev_id.



>+{
>+	struct prestera_port *port;
>+
>+	rcu_read_lock();
>+
>+	list_for_each_entry_rcu(port, &sw->port_list, list) {
>+		if (port->dev_id == dev_id && port->hw_id == hw_id) {

Note this is the fast path. I'm not sure what the values of dev_id or
hw_id are, but didn't you consider having the port pointers in 2 dim
array? Or, if the values are totally arbitrary, at least a hash table
would be nice here.


>+			rcu_read_unlock();
>+			return port;

As Ido already pointed out, this is invalid use of rcu read.
If you really need to do rcu read lock, the caller should hold it while
calling this function and until it finisher work with port struct.


>+		}
>+	}
>+
>+	rcu_read_unlock();
>+
>+	return NULL;
>+}
>+
>+static struct prestera_port *prestera_find_port(struct prestera_switch *sw,
>+						u32 port_id)
>+{
>+	struct prestera_port *port;
>+
>+	rcu_read_lock();
>+
>+	list_for_each_entry_rcu(port, &sw->port_list, list) {
>+		if (port->id == port_id)
>+			break;
>+	}
>+
>+	rcu_read_unlock();
>+
>+	return port;
>+}
>+
>+static int prestera_port_state_set(struct net_device *dev, bool is_up)
>+{
>+	struct prestera_port *port = netdev_priv(dev);
>+	int err;
>+
>+	if (!is_up)
>+		netif_stop_queue(dev);
>+
>+	err = prestera_hw_port_state_set(port, is_up);
>+
>+	if (is_up && !err)
>+		netif_start_queue(dev);
>+
>+	return err;
>+}
>+
>+static int prestera_port_open(struct net_device *dev)
>+{
>+	return prestera_port_state_set(dev, true);
>+}
>+
>+static int prestera_port_close(struct net_device *dev)
>+{
>+	return prestera_port_state_set(dev, false);
>+}
>+
>+static netdev_tx_t prestera_port_xmit(struct sk_buff *skb,
>+				      struct net_device *dev)
>+{
>+	return prestera_rxtx_xmit(netdev_priv(dev), skb);
>+}
>+
>+static int prestera_is_valid_mac_addr(struct prestera_port *port, u8 *addr)
>+{
>+	if (!is_valid_ether_addr(addr))
>+		return -EADDRNOTAVAIL;
>+
>+	if (memcmp(port->sw->base_mac, addr, ETH_ALEN - 1))
>+		return -EINVAL;
>+
>+	return 0;
>+}
>+
>+static int prestera_port_set_mac_address(struct net_device *dev, void *p)
>+{
>+	struct prestera_port *port = netdev_priv(dev);
>+	struct sockaddr *addr = p;
>+	int err;
>+
>+	err = prestera_is_valid_mac_addr(port, addr->sa_data);
>+	if (err)
>+		return err;
>+
>+	err = prestera_hw_port_mac_set(port, addr->sa_data);
>+	if (err)
>+		return err;
>+
>+	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
>+	return 0;
>+}
>+
>+static int prestera_port_change_mtu(struct net_device *dev, int mtu)
>+{
>+	struct prestera_port *port = netdev_priv(dev);
>+	int err;
>+
>+	err = prestera_hw_port_mtu_set(port, mtu);
>+	if (err)
>+		return err;
>+
>+	dev->mtu = mtu;
>+	return 0;
>+}
>+
>+static void prestera_port_get_stats64(struct net_device *dev,
>+				      struct rtnl_link_stats64 *stats)
>+{
>+	struct prestera_port *port = netdev_priv(dev);
>+	struct prestera_port_stats *port_stats = &port->cached_hw_stats.stats;
>+
>+	stats->rx_packets = port_stats->broadcast_frames_received +
>+				port_stats->multicast_frames_received +
>+				port_stats->unicast_frames_received;
>+
>+	stats->tx_packets = port_stats->broadcast_frames_sent +
>+				port_stats->multicast_frames_sent +
>+				port_stats->unicast_frames_sent;
>+
>+	stats->rx_bytes = port_stats->good_octets_received;
>+
>+	stats->tx_bytes = port_stats->good_octets_sent;
>+
>+	stats->rx_errors = port_stats->rx_error_frame_received;
>+	stats->tx_errors = port_stats->mac_trans_error;
>+
>+	stats->rx_dropped = port_stats->buffer_overrun;
>+	stats->tx_dropped = 0;
>+
>+	stats->multicast = port_stats->multicast_frames_received;
>+	stats->collisions = port_stats->excessive_collision;
>+
>+	stats->rx_crc_errors = port_stats->bad_crc;
>+}
>+
>+static void prestera_port_get_hw_stats(struct prestera_port *port)
>+{
>+	prestera_hw_port_stats_get(port, &port->cached_hw_stats.stats);
>+}
>+
>+static void prestera_port_stats_update(struct work_struct *work)
>+{
>+	struct prestera_port *port =
>+		container_of(work, struct prestera_port,
>+			     cached_hw_stats.caching_dw.work);
>+
>+	prestera_port_get_hw_stats(port);
>+
>+	queue_delayed_work(prestera_wq, &port->cached_hw_stats.caching_dw,
>+			   PRESTERA_STATS_DELAY_MS);
>+}
>+
>+static const struct net_device_ops netdev_ops = {
>+	.ndo_open = prestera_port_open,
>+	.ndo_stop = prestera_port_close,
>+	.ndo_start_xmit = prestera_port_xmit,
>+	.ndo_change_mtu = prestera_port_change_mtu,
>+	.ndo_get_stats64 = prestera_port_get_stats64,
>+	.ndo_set_mac_address = prestera_port_set_mac_address,
>+};
>+
>+static int prestera_port_autoneg_set(struct prestera_port *port, bool enable,
>+				     u64 link_modes, u8 fec)
>+{
>+	bool refresh = false;
>+	int err = 0;
>+
>+	if (port->caps.type != PRESTERA_PORT_TYPE_TP)
>+		return enable ? -EINVAL : 0;
>+
>+	if (port->adver_link_modes != link_modes || port->adver_fec != fec) {
>+		port->adver_fec = fec ?: BIT(PRESTERA_PORT_FEC_OFF);
>+		port->adver_link_modes = link_modes;
>+		refresh = true;
>+	}
>+
>+	if (port->autoneg == enable && !(port->autoneg && refresh))
>+		return 0;
>+
>+	err = prestera_hw_port_autoneg_set(port, enable, port->adver_link_modes,
>+					   port->adver_fec);
>+	if (err)
>+		return -EINVAL;
>+
>+	port->autoneg = enable;
>+	return 0;
>+}
>+
>+static int prestera_port_create(struct prestera_switch *sw, u32 id)
>+{
>+	struct prestera_port *port;
>+	struct net_device *dev;
>+	int err;
>+
>+	dev = alloc_etherdev(sizeof(*port));
>+	if (!dev)
>+		return -ENOMEM;
>+
>+	port = netdev_priv(dev);
>+
>+	port->dev = dev;
>+	port->id = id;
>+	port->sw = sw;
>+
>+	err = prestera_hw_port_info_get(port, &port->fp_id,
>+					&port->hw_id, &port->dev_id);
>+	if (err) {
>+		dev_err(prestera_dev(sw), "Failed to get port(%u) info\n", id);
>+		goto err_port_init;
>+	}
>+
>+	dev->features |= NETIF_F_NETNS_LOCAL;
>+	dev->netdev_ops = &netdev_ops;
>+
>+	netif_carrier_off(dev);
>+
>+	dev->mtu = min_t(unsigned int, sw->mtu_max, PRESTERA_MTU_DEFAULT);
>+	dev->min_mtu = sw->mtu_min;
>+	dev->max_mtu = sw->mtu_max;
>+
>+	err = prestera_hw_port_mtu_set(port, dev->mtu);
>+	if (err) {
>+		dev_err(prestera_dev(sw), "Failed to set port(%u) mtu(%d)\n",
>+			id, dev->mtu);
>+		goto err_port_init;
>+	}
>+
>+	/* Only 0xFF mac addrs are supported */
>+	if (port->fp_id >= 0xFF)
>+		goto err_port_init;
>+
>+	memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
>+	dev->dev_addr[dev->addr_len - 1] = (char)port->fp_id;
>+
>+	err = prestera_hw_port_mac_set(port, dev->dev_addr);
>+	if (err) {
>+		dev_err(prestera_dev(sw), "Failed to set port(%u) mac addr\n", id);
>+		goto err_port_init;
>+	}
>+
>+	err = prestera_hw_port_cap_get(port, &port->caps);
>+	if (err) {
>+		dev_err(prestera_dev(sw), "Failed to get port(%u) caps\n", id);
>+		goto err_port_init;
>+	}
>+
>+	port->adver_fec = BIT(PRESTERA_PORT_FEC_OFF);
>+	prestera_port_autoneg_set(port, true, port->caps.supp_link_modes,
>+				  port->caps.supp_fec);
>+
>+	err = prestera_hw_port_state_set(port, false);
>+	if (err) {
>+		dev_err(prestera_dev(sw), "Failed to set port(%u) down\n", id);
>+		goto err_port_init;
>+	}
>+
>+	err = prestera_rxtx_port_init(port);
>+	if (err)
>+		goto err_port_init;
>+
>+	INIT_DELAYED_WORK(&port->cached_hw_stats.caching_dw,
>+			  &prestera_port_stats_update);
>+
>+	list_add_rcu(&port->list, &sw->port_list);

I still am not sure I fully follow. We discussed this before. Can one
of the following cases happen?

1) a packet is RXed while adding ports
2) a packet is RXed while removing ports

If yes, the rcu makes sense here. If no, you are okay with a simple
list.


>+
>+	err = register_netdev(dev);
>+	if (err)
>+		goto err_register_netdev;
>+
>+	return 0;
>+
>+err_register_netdev:
>+	list_del_rcu(&port->list);
>+err_port_init:
>+	free_netdev(dev);
>+	return err;
>+}
>+
>+static void prestera_port_destroy(struct prestera_port *port)
>+{
>+	struct net_device *dev = port->dev;
>+
>+	cancel_delayed_work_sync(&port->cached_hw_stats.caching_dw);
>+	unregister_netdev(dev);
>+
>+	list_del_rcu(&port->list);
>+
>+	free_netdev(dev);
>+}
>+
>+static void prestera_destroy_ports(struct prestera_switch *sw)
>+{
>+	struct prestera_port *port, *tmp;
>+	struct list_head remove_list;
>+
>+	INIT_LIST_HEAD(&remove_list);
>+
>+	list_splice_init(&sw->port_list, &remove_list);

Why do you need a separate remove list? Why don't you iterate sw->port_list
directly?


>+
>+	list_for_each_entry_safe(port, tmp, &remove_list, list)
>+		prestera_port_destroy(port);
>+}
>+

[...]


>+static int prestera_rxtx_process_skb(struct prestera_sdma *sdma,
>+				     struct sk_buff *skb)
>+{
>+	const struct prestera_port *port;
>+	struct prestera_dsa dsa;

What "DSA" stands for? Anything to do with net/dsa/ ?


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
>+	port = prestera_port_find_by_hwid(sdma->sw, hw_id, hw_port);
>+	if (unlikely(!port)) {
>+		pr_warn_ratelimited("prestera: received pkt for non-existent port(%u, %u)\n",

Drop the "prestera: " prefix.


>+				    hw_id, hw_port);
>+		return -EEXIST;
>+	}
>+

[...]
