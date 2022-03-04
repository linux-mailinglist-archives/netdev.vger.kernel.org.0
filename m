Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30FA4CD272
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 11:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbiCDKfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 05:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiCDKe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 05:34:59 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99615E728E
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 02:34:08 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id q7-20020a7bce87000000b00382255f4ca9so6423609wmj.2
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 02:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VH20Zo3xMAyB1ENYKXV619rapGoxrp0lO/okMoG8uVc=;
        b=UiHM2LNK79CVnrUE/xeTFqkqfh06XAFSwa3dDca91L/hEfCyFVpdsCpd0/1jqCqGxM
         7LYcGa8RYz6tcpLn6SYj3anP75ZVB+zmvLPzSOrCuIx0HUwYhs8+dTjzH2yTOSynZWC+
         6YhQ1tZCRS0hnWsJKODCUUcTNB5RNdWjFskWP4bOaJYq6ulao6oTEAKkXI32KMDbiEF5
         xybZwywRSMLeepKMKfiz+F9y7q6ZkjJYwr3B4Se4WRtBIIcMDKkw6T4uZatH370QbTvG
         S0TtAYy9lhKvDe6SS5lQiSpHEzlMhu5LEdQxVPpd7CwwU/hqdQN3NOYHHpxteaQtmlls
         78lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VH20Zo3xMAyB1ENYKXV619rapGoxrp0lO/okMoG8uVc=;
        b=NVkTMymVyEWaz7BcjPD+hsKs/2NVgxNfWGJCb3kq7dr3rJUUnp7QcqA9KKqj70wLNi
         uA2iqODXxIonyONvQQYFHU5kRXUlSZX0Z2tLhnvbiVj0IxwgXwerVKyCBx1/5TyWr+1W
         rARN6daYqah4XBbLPJAmR+zJB6j+uuNLEIqfJjtZarC9mqlNKQzEZ+RzJr1HxbLrfbBf
         LloQeWFAv0s4shNmT9aTlrmelnmggLse7ueor6cOHY5o0bdw5XhSKdjsuRbNeJuZ+GqS
         j9XF2QgYjg9ccwr+yg7WmkFm7RQGuN2SjJECBpS3Gv4QRNbSWTtQ8096p06FUXeoIR3r
         pg+Q==
X-Gm-Message-State: AOAM531tlRx+j4PFqtkRZYoJPFgV8/Kp9BTRv8W8ZSXuHEGuaAgl7JDd
        gfS8pFO8fjD4Jlif47CqZ9kxdJ/Nu0YAlA==
X-Google-Smtp-Source: ABdhPJz6BkDj55iGs67UjNkvmiBnzTgHrXYpXMchDsV0uL683MGpCFpWHzvayi2IyafB2dCw1Ibg2Q==
X-Received: by 2002:a7b:c091:0:b0:381:8179:a7b with SMTP id r17-20020a7bc091000000b0038181790a7bmr6957978wmh.195.1646390046725;
        Fri, 04 Mar 2022 02:34:06 -0800 (PST)
Received: from syracuse.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id k10-20020adfe3ca000000b001f0329ba94csm5834958wrm.18.2022.03.04.02.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 02:34:06 -0800 (PST)
From:   Nicolas Escande <nico.escande@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>,
        Nicolas Escande <nico.escande@gmail.com>
Subject: [PATCH iproute2-next] ip/batadv: allow to specify RA when creating link
Date:   Fri,  4 Mar 2022 11:33:54 +0100
Message-Id: <20220304103354.68086-1-nico.escande@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the possibility to specify batadv specific options when
creating a new batman link. The only option available on link creation
is IFLA_BATADV_ALGO_NAME which specifies the routing algorithm.
Note there is no batadv specific attr to be handled on link dump.

Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
---
 include/uapi/linux/batman_adv.h | 704 ++++++++++++++++++++++++++++++++
 ip/Makefile                     |   2 +-
 ip/iplink_batadv.c              |  64 +++
 3 files changed, 769 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/batman_adv.h
 create mode 100644 ip/iplink_batadv.c

diff --git a/include/uapi/linux/batman_adv.h b/include/uapi/linux/batman_adv.h
new file mode 100644
index 00000000..35dc016c
--- /dev/null
+++ b/include/uapi/linux/batman_adv.h
@@ -0,0 +1,704 @@
+/* SPDX-License-Identifier: MIT */
+/* Copyright (C) B.A.T.M.A.N. contributors:
+ *
+ * Matthias Schiffer
+ */
+
+#ifndef _UAPI_LINUX_BATMAN_ADV_H_
+#define _UAPI_LINUX_BATMAN_ADV_H_
+
+#define BATADV_NL_NAME "batadv"
+
+#define BATADV_NL_MCAST_GROUP_CONFIG	"config"
+#define BATADV_NL_MCAST_GROUP_TPMETER	"tpmeter"
+
+/**
+ * enum batadv_tt_client_flags - TT client specific flags
+ *
+ * Bits from 0 to 7 are called _remote flags_ because they are sent on the wire.
+ * Bits from 8 to 15 are called _local flags_ because they are used for local
+ * computations only.
+ *
+ * Bits from 4 to 7 - a subset of remote flags - are ensured to be in sync with
+ * the other nodes in the network. To achieve this goal these flags are included
+ * in the TT CRC computation.
+ */
+enum batadv_tt_client_flags {
+	/**
+	 * @BATADV_TT_CLIENT_DEL: the client has to be deleted from the table
+	 */
+	BATADV_TT_CLIENT_DEL     = (1 << 0),
+
+	/**
+	 * @BATADV_TT_CLIENT_ROAM: the client roamed to/from another node and
+	 * the new update telling its new real location has not been
+	 * received/sent yet
+	 */
+	BATADV_TT_CLIENT_ROAM    = (1 << 1),
+
+	/**
+	 * @BATADV_TT_CLIENT_WIFI: this client is connected through a wifi
+	 * interface. This information is used by the "AP Isolation" feature
+	 */
+	BATADV_TT_CLIENT_WIFI    = (1 << 4),
+
+	/**
+	 * @BATADV_TT_CLIENT_ISOLA: this client is considered "isolated". This
+	 * information is used by the Extended Isolation feature
+	 */
+	BATADV_TT_CLIENT_ISOLA	 = (1 << 5),
+
+	/**
+	 * @BATADV_TT_CLIENT_NOPURGE: this client should never be removed from
+	 * the table
+	 */
+	BATADV_TT_CLIENT_NOPURGE = (1 << 8),
+
+	/**
+	 * @BATADV_TT_CLIENT_NEW: this client has been added to the local table
+	 * but has not been announced yet
+	 */
+	BATADV_TT_CLIENT_NEW     = (1 << 9),
+
+	/**
+	 * @BATADV_TT_CLIENT_PENDING: this client is marked for removal but it
+	 * is kept in the table for one more originator interval for consistency
+	 * purposes
+	 */
+	BATADV_TT_CLIENT_PENDING = (1 << 10),
+
+	/**
+	 * @BATADV_TT_CLIENT_TEMP: this global client has been detected to be
+	 * part of the network but no node has already announced it
+	 */
+	BATADV_TT_CLIENT_TEMP	 = (1 << 11),
+};
+
+/**
+ * enum batadv_mcast_flags_priv - Private, own multicast flags
+ *
+ * These are internal, multicast related flags. Currently they describe certain
+ * multicast related attributes of the segment this originator bridges into the
+ * mesh.
+ *
+ * Those attributes are used to determine the public multicast flags this
+ * originator is going to announce via TT.
+ *
+ * For netlink, if BATADV_MCAST_FLAGS_BRIDGED is unset then all querier
+ * related flags are undefined.
+ */
+enum batadv_mcast_flags_priv {
+	/**
+	 * @BATADV_MCAST_FLAGS_BRIDGED: There is a bridge on top of the mesh
+	 * interface.
+	 */
+	BATADV_MCAST_FLAGS_BRIDGED			= (1 << 0),
+
+	/**
+	 * @BATADV_MCAST_FLAGS_QUERIER_IPV4_EXISTS: Whether an IGMP querier
+	 * exists in the mesh
+	 */
+	BATADV_MCAST_FLAGS_QUERIER_IPV4_EXISTS		= (1 << 1),
+
+	/**
+	 * @BATADV_MCAST_FLAGS_QUERIER_IPV6_EXISTS: Whether an MLD querier
+	 * exists in the mesh
+	 */
+	BATADV_MCAST_FLAGS_QUERIER_IPV6_EXISTS		= (1 << 2),
+
+	/**
+	 * @BATADV_MCAST_FLAGS_QUERIER_IPV4_SHADOWING: If an IGMP querier
+	 * exists, whether it is potentially shadowing multicast listeners
+	 * (i.e. querier is behind our own bridge segment)
+	 */
+	BATADV_MCAST_FLAGS_QUERIER_IPV4_SHADOWING	= (1 << 3),
+
+	/**
+	 * @BATADV_MCAST_FLAGS_QUERIER_IPV6_SHADOWING: If an MLD querier
+	 * exists, whether it is potentially shadowing multicast listeners
+	 * (i.e. querier is behind our own bridge segment)
+	 */
+	BATADV_MCAST_FLAGS_QUERIER_IPV6_SHADOWING	= (1 << 4),
+};
+
+/**
+ * enum batadv_gw_modes - gateway mode of node
+ */
+enum batadv_gw_modes {
+	/** @BATADV_GW_MODE_OFF: gw mode disabled */
+	BATADV_GW_MODE_OFF,
+
+	/** @BATADV_GW_MODE_CLIENT: send DHCP requests to gw servers */
+	BATADV_GW_MODE_CLIENT,
+
+	/** @BATADV_GW_MODE_SERVER: announce itself as gateway server */
+	BATADV_GW_MODE_SERVER,
+};
+
+/**
+ * enum batadv_nl_attrs - batman-adv netlink attributes
+ */
+enum batadv_nl_attrs {
+	/**
+	 * @BATADV_ATTR_UNSPEC: unspecified attribute to catch errors
+	 */
+	BATADV_ATTR_UNSPEC,
+
+	/**
+	 * @BATADV_ATTR_VERSION: batman-adv version string
+	 */
+	BATADV_ATTR_VERSION,
+
+	/**
+	 * @BATADV_ATTR_ALGO_NAME: name of routing algorithm
+	 */
+	BATADV_ATTR_ALGO_NAME,
+
+	/**
+	 * @BATADV_ATTR_MESH_IFINDEX: index of the batman-adv interface
+	 */
+	BATADV_ATTR_MESH_IFINDEX,
+
+	/**
+	 * @BATADV_ATTR_MESH_IFNAME: name of the batman-adv interface
+	 */
+	BATADV_ATTR_MESH_IFNAME,
+
+	/**
+	 * @BATADV_ATTR_MESH_ADDRESS: mac address of the batman-adv interface
+	 */
+	BATADV_ATTR_MESH_ADDRESS,
+
+	/**
+	 * @BATADV_ATTR_HARD_IFINDEX: index of the non-batman-adv interface
+	 */
+	BATADV_ATTR_HARD_IFINDEX,
+
+	/**
+	 * @BATADV_ATTR_HARD_IFNAME: name of the non-batman-adv interface
+	 */
+	BATADV_ATTR_HARD_IFNAME,
+
+	/**
+	 * @BATADV_ATTR_HARD_ADDRESS: mac address of the non-batman-adv
+	 * interface
+	 */
+	BATADV_ATTR_HARD_ADDRESS,
+
+	/**
+	 * @BATADV_ATTR_ORIG_ADDRESS: originator mac address
+	 */
+	BATADV_ATTR_ORIG_ADDRESS,
+
+	/**
+	 * @BATADV_ATTR_TPMETER_RESULT: result of run (see
+	 * batadv_tp_meter_status)
+	 */
+	BATADV_ATTR_TPMETER_RESULT,
+
+	/**
+	 * @BATADV_ATTR_TPMETER_TEST_TIME: time (msec) the run took
+	 */
+	BATADV_ATTR_TPMETER_TEST_TIME,
+
+	/**
+	 * @BATADV_ATTR_TPMETER_BYTES: amount of acked bytes during run
+	 */
+	BATADV_ATTR_TPMETER_BYTES,
+
+	/**
+	 * @BATADV_ATTR_TPMETER_COOKIE: session cookie to match tp_meter session
+	 */
+	BATADV_ATTR_TPMETER_COOKIE,
+
+	/**
+	 * @BATADV_ATTR_PAD: attribute used for padding for 64-bit alignment
+	 */
+	BATADV_ATTR_PAD,
+
+	/**
+	 * @BATADV_ATTR_ACTIVE: Flag indicating if the hard interface is active
+	 */
+	BATADV_ATTR_ACTIVE,
+
+	/**
+	 * @BATADV_ATTR_TT_ADDRESS: Client MAC address
+	 */
+	BATADV_ATTR_TT_ADDRESS,
+
+	/**
+	 * @BATADV_ATTR_TT_TTVN: Translation table version
+	 */
+	BATADV_ATTR_TT_TTVN,
+
+	/**
+	 * @BATADV_ATTR_TT_LAST_TTVN: Previous translation table version
+	 */
+	BATADV_ATTR_TT_LAST_TTVN,
+
+	/**
+	 * @BATADV_ATTR_TT_CRC32: CRC32 over translation table
+	 */
+	BATADV_ATTR_TT_CRC32,
+
+	/**
+	 * @BATADV_ATTR_TT_VID: VLAN ID
+	 */
+	BATADV_ATTR_TT_VID,
+
+	/**
+	 * @BATADV_ATTR_TT_FLAGS: Translation table client flags
+	 */
+	BATADV_ATTR_TT_FLAGS,
+
+	/**
+	 * @BATADV_ATTR_FLAG_BEST: Flags indicating entry is the best
+	 */
+	BATADV_ATTR_FLAG_BEST,
+
+	/**
+	 * @BATADV_ATTR_LAST_SEEN_MSECS: Time in milliseconds since last seen
+	 */
+	BATADV_ATTR_LAST_SEEN_MSECS,
+
+	/**
+	 * @BATADV_ATTR_NEIGH_ADDRESS: Neighbour MAC address
+	 */
+	BATADV_ATTR_NEIGH_ADDRESS,
+
+	/**
+	 * @BATADV_ATTR_TQ: TQ to neighbour
+	 */
+	BATADV_ATTR_TQ,
+
+	/**
+	 * @BATADV_ATTR_THROUGHPUT: Estimated throughput to Neighbour
+	 */
+	BATADV_ATTR_THROUGHPUT,
+
+	/**
+	 * @BATADV_ATTR_BANDWIDTH_UP: Reported uplink bandwidth
+	 */
+	BATADV_ATTR_BANDWIDTH_UP,
+
+	/**
+	 * @BATADV_ATTR_BANDWIDTH_DOWN: Reported downlink bandwidth
+	 */
+	BATADV_ATTR_BANDWIDTH_DOWN,
+
+	/**
+	 * @BATADV_ATTR_ROUTER: Gateway router MAC address
+	 */
+	BATADV_ATTR_ROUTER,
+
+	/**
+	 * @BATADV_ATTR_BLA_OWN: Flag indicating own originator
+	 */
+	BATADV_ATTR_BLA_OWN,
+
+	/**
+	 * @BATADV_ATTR_BLA_ADDRESS: Bridge loop avoidance claim MAC address
+	 */
+	BATADV_ATTR_BLA_ADDRESS,
+
+	/**
+	 * @BATADV_ATTR_BLA_VID: BLA VLAN ID
+	 */
+	BATADV_ATTR_BLA_VID,
+
+	/**
+	 * @BATADV_ATTR_BLA_BACKBONE: BLA gateway originator MAC address
+	 */
+	BATADV_ATTR_BLA_BACKBONE,
+
+	/**
+	 * @BATADV_ATTR_BLA_CRC: BLA CRC
+	 */
+	BATADV_ATTR_BLA_CRC,
+
+	/**
+	 * @BATADV_ATTR_DAT_CACHE_IP4ADDRESS: Client IPv4 address
+	 */
+	BATADV_ATTR_DAT_CACHE_IP4ADDRESS,
+
+	/**
+	 * @BATADV_ATTR_DAT_CACHE_HWADDRESS: Client MAC address
+	 */
+	BATADV_ATTR_DAT_CACHE_HWADDRESS,
+
+	/**
+	 * @BATADV_ATTR_DAT_CACHE_VID: VLAN ID
+	 */
+	BATADV_ATTR_DAT_CACHE_VID,
+
+	/**
+	 * @BATADV_ATTR_MCAST_FLAGS: Per originator multicast flags
+	 */
+	BATADV_ATTR_MCAST_FLAGS,
+
+	/**
+	 * @BATADV_ATTR_MCAST_FLAGS_PRIV: Private, own multicast flags
+	 */
+	BATADV_ATTR_MCAST_FLAGS_PRIV,
+
+	/**
+	 * @BATADV_ATTR_VLANID: VLAN id on top of soft interface
+	 */
+	BATADV_ATTR_VLANID,
+
+	/**
+	 * @BATADV_ATTR_AGGREGATED_OGMS_ENABLED: whether the batman protocol
+	 *  messages of the mesh interface shall be aggregated or not.
+	 */
+	BATADV_ATTR_AGGREGATED_OGMS_ENABLED,
+
+	/**
+	 * @BATADV_ATTR_AP_ISOLATION_ENABLED: whether the data traffic going
+	 *  from a wireless client to another wireless client will be silently
+	 *  dropped.
+	 */
+	BATADV_ATTR_AP_ISOLATION_ENABLED,
+
+	/**
+	 * @BATADV_ATTR_ISOLATION_MARK: the isolation mark which is used to
+	 *  classify clients as "isolated" by the Extended Isolation feature.
+	 */
+	BATADV_ATTR_ISOLATION_MARK,
+
+	/**
+	 * @BATADV_ATTR_ISOLATION_MASK: the isolation (bit)mask which is used to
+	 *  classify clients as "isolated" by the Extended Isolation feature.
+	 */
+	BATADV_ATTR_ISOLATION_MASK,
+
+	/**
+	 * @BATADV_ATTR_BONDING_ENABLED: whether the data traffic going through
+	 *  the mesh will be sent using multiple interfaces at the same time.
+	 */
+	BATADV_ATTR_BONDING_ENABLED,
+
+	/**
+	 * @BATADV_ATTR_BRIDGE_LOOP_AVOIDANCE_ENABLED: whether the bridge loop
+	 *  avoidance feature is enabled. This feature detects and avoids loops
+	 *  between the mesh and devices bridged with the soft interface
+	 */
+	BATADV_ATTR_BRIDGE_LOOP_AVOIDANCE_ENABLED,
+
+	/**
+	 * @BATADV_ATTR_DISTRIBUTED_ARP_TABLE_ENABLED: whether the distributed
+	 *  arp table feature is enabled. This feature uses a distributed hash
+	 *  table to answer ARP requests without flooding the request through
+	 *  the whole mesh.
+	 */
+	BATADV_ATTR_DISTRIBUTED_ARP_TABLE_ENABLED,
+
+	/**
+	 * @BATADV_ATTR_FRAGMENTATION_ENABLED: whether the data traffic going
+	 *  through the mesh will be fragmented or silently discarded if the
+	 *  packet size exceeds the outgoing interface MTU.
+	 */
+	BATADV_ATTR_FRAGMENTATION_ENABLED,
+
+	/**
+	 * @BATADV_ATTR_GW_BANDWIDTH_DOWN: defines the download bandwidth which
+	 *  is propagated by this node if %BATADV_ATTR_GW_BANDWIDTH_MODE was set
+	 *  to 'server'.
+	 */
+	BATADV_ATTR_GW_BANDWIDTH_DOWN,
+
+	/**
+	 * @BATADV_ATTR_GW_BANDWIDTH_UP: defines the upload bandwidth which
+	 *  is propagated by this node if %BATADV_ATTR_GW_BANDWIDTH_MODE was set
+	 *  to 'server'.
+	 */
+	BATADV_ATTR_GW_BANDWIDTH_UP,
+
+	/**
+	 * @BATADV_ATTR_GW_MODE: defines the state of the gateway features.
+	 * Possible values are specified in enum batadv_gw_modes
+	 */
+	BATADV_ATTR_GW_MODE,
+
+	/**
+	 * @BATADV_ATTR_GW_SEL_CLASS: defines the selection criteria this node
+	 *  will use to choose a gateway if gw_mode was set to 'client'.
+	 */
+	BATADV_ATTR_GW_SEL_CLASS,
+
+	/**
+	 * @BATADV_ATTR_HOP_PENALTY: defines the penalty which will be applied
+	 *  to an originator message's tq-field on every hop and/or per
+	 *  hard interface
+	 */
+	BATADV_ATTR_HOP_PENALTY,
+
+	/**
+	 * @BATADV_ATTR_LOG_LEVEL: bitmask with to define which debug messages
+	 *  should be send to the debug log/trace ring buffer
+	 */
+	BATADV_ATTR_LOG_LEVEL,
+
+	/**
+	 * @BATADV_ATTR_MULTICAST_FORCEFLOOD_ENABLED: whether multicast
+	 *  optimizations should be replaced by simple broadcast-like flooding
+	 *  of multicast packets. If set to non-zero then all nodes in the mesh
+	 *  are going to use classic flooding for any multicast packet with no
+	 *  optimizations.
+	 */
+	BATADV_ATTR_MULTICAST_FORCEFLOOD_ENABLED,
+
+	/**
+	 * @BATADV_ATTR_NETWORK_CODING_ENABLED: whether Network Coding (using
+	 *  some magic to send fewer wifi packets but still the same content) is
+	 *  enabled or not.
+	 */
+	BATADV_ATTR_NETWORK_CODING_ENABLED,
+
+	/**
+	 * @BATADV_ATTR_ORIG_INTERVAL: defines the interval in milliseconds in
+	 *  which batman sends its protocol messages.
+	 */
+	BATADV_ATTR_ORIG_INTERVAL,
+
+	/**
+	 * @BATADV_ATTR_ELP_INTERVAL: defines the interval in milliseconds in
+	 *  which batman emits probing packets for neighbor sensing (ELP).
+	 */
+	BATADV_ATTR_ELP_INTERVAL,
+
+	/**
+	 * @BATADV_ATTR_THROUGHPUT_OVERRIDE: defines the throughput value to be
+	 *  used by B.A.T.M.A.N. V when estimating the link throughput using
+	 *  this interface. If the value is set to 0 then batman-adv will try to
+	 *  estimate the throughput by itself.
+	 */
+	BATADV_ATTR_THROUGHPUT_OVERRIDE,
+
+	/**
+	 * @BATADV_ATTR_MULTICAST_FANOUT: defines the maximum number of packet
+	 * copies that may be generated for a multicast-to-unicast conversion.
+	 * Once this limit is exceeded distribution will fall back to broadcast.
+	 */
+	BATADV_ATTR_MULTICAST_FANOUT,
+
+	/* add attributes above here, update the policy in netlink.c */
+
+	/**
+	 * @__BATADV_ATTR_AFTER_LAST: internal use
+	 */
+	__BATADV_ATTR_AFTER_LAST,
+
+	/**
+	 * @NUM_BATADV_ATTR: total number of batadv_nl_attrs available
+	 */
+	NUM_BATADV_ATTR = __BATADV_ATTR_AFTER_LAST,
+
+	/**
+	 * @BATADV_ATTR_MAX: highest attribute number currently defined
+	 */
+	BATADV_ATTR_MAX = __BATADV_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum batadv_nl_commands - supported batman-adv netlink commands
+ */
+enum batadv_nl_commands {
+	/**
+	 * @BATADV_CMD_UNSPEC: unspecified command to catch errors
+	 */
+	BATADV_CMD_UNSPEC,
+
+	/**
+	 * @BATADV_CMD_GET_MESH: Get attributes from softif/mesh
+	 */
+	BATADV_CMD_GET_MESH,
+
+	/**
+	 * @BATADV_CMD_GET_MESH_INFO: Alias for @BATADV_CMD_GET_MESH
+	 */
+	BATADV_CMD_GET_MESH_INFO = BATADV_CMD_GET_MESH,
+
+	/**
+	 * @BATADV_CMD_TP_METER: Start a tp meter session
+	 */
+	BATADV_CMD_TP_METER,
+
+	/**
+	 * @BATADV_CMD_TP_METER_CANCEL: Cancel a tp meter session
+	 */
+	BATADV_CMD_TP_METER_CANCEL,
+
+	/**
+	 * @BATADV_CMD_GET_ROUTING_ALGOS: Query the list of routing algorithms.
+	 */
+	BATADV_CMD_GET_ROUTING_ALGOS,
+
+	/**
+	 * @BATADV_CMD_GET_HARDIF: Get attributes from a hardif of the
+	 *  current softif
+	 */
+	BATADV_CMD_GET_HARDIF,
+
+	/**
+	 * @BATADV_CMD_GET_HARDIFS: Alias for @BATADV_CMD_GET_HARDIF
+	 */
+	BATADV_CMD_GET_HARDIFS = BATADV_CMD_GET_HARDIF,
+
+	/**
+	 * @BATADV_CMD_GET_TRANSTABLE_LOCAL: Query list of local translations
+	 */
+	BATADV_CMD_GET_TRANSTABLE_LOCAL,
+
+	/**
+	 * @BATADV_CMD_GET_TRANSTABLE_GLOBAL: Query list of global translations
+	 */
+	BATADV_CMD_GET_TRANSTABLE_GLOBAL,
+
+	/**
+	 * @BATADV_CMD_GET_ORIGINATORS: Query list of originators
+	 */
+	BATADV_CMD_GET_ORIGINATORS,
+
+	/**
+	 * @BATADV_CMD_GET_NEIGHBORS: Query list of neighbours
+	 */
+	BATADV_CMD_GET_NEIGHBORS,
+
+	/**
+	 * @BATADV_CMD_GET_GATEWAYS: Query list of gateways
+	 */
+	BATADV_CMD_GET_GATEWAYS,
+
+	/**
+	 * @BATADV_CMD_GET_BLA_CLAIM: Query list of bridge loop avoidance claims
+	 */
+	BATADV_CMD_GET_BLA_CLAIM,
+
+	/**
+	 * @BATADV_CMD_GET_BLA_BACKBONE: Query list of bridge loop avoidance
+	 * backbones
+	 */
+	BATADV_CMD_GET_BLA_BACKBONE,
+
+	/**
+	 * @BATADV_CMD_GET_DAT_CACHE: Query list of DAT cache entries
+	 */
+	BATADV_CMD_GET_DAT_CACHE,
+
+	/**
+	 * @BATADV_CMD_GET_MCAST_FLAGS: Query list of multicast flags
+	 */
+	BATADV_CMD_GET_MCAST_FLAGS,
+
+	/**
+	 * @BATADV_CMD_SET_MESH: Set attributes for softif/mesh
+	 */
+	BATADV_CMD_SET_MESH,
+
+	/**
+	 * @BATADV_CMD_SET_HARDIF: Set attributes for hardif of the
+	 *  current softif
+	 */
+	BATADV_CMD_SET_HARDIF,
+
+	/**
+	 * @BATADV_CMD_GET_VLAN: Get attributes from a VLAN of the
+	 *  current softif
+	 */
+	BATADV_CMD_GET_VLAN,
+
+	/**
+	 * @BATADV_CMD_SET_VLAN: Set attributes for VLAN of the
+	 *  current softif
+	 */
+	BATADV_CMD_SET_VLAN,
+
+	/* add new commands above here */
+
+	/**
+	 * @__BATADV_CMD_AFTER_LAST: internal use
+	 */
+	__BATADV_CMD_AFTER_LAST,
+
+	/**
+	 * @BATADV_CMD_MAX: highest used command number
+	 */
+	BATADV_CMD_MAX = __BATADV_CMD_AFTER_LAST - 1
+};
+
+/**
+ * enum batadv_tp_meter_reason - reason of a tp meter test run stop
+ */
+enum batadv_tp_meter_reason {
+	/**
+	 * @BATADV_TP_REASON_COMPLETE: sender finished tp run
+	 */
+	BATADV_TP_REASON_COMPLETE		= 3,
+
+	/**
+	 * @BATADV_TP_REASON_CANCEL: sender was stopped during run
+	 */
+	BATADV_TP_REASON_CANCEL			= 4,
+
+	/* error status >= 128 */
+
+	/**
+	 * @BATADV_TP_REASON_DST_UNREACHABLE: receiver could not be reached or
+	 * didn't answer
+	 */
+	BATADV_TP_REASON_DST_UNREACHABLE	= 128,
+
+	/**
+	 * @BATADV_TP_REASON_RESEND_LIMIT: (unused) sender retry reached limit
+	 */
+	BATADV_TP_REASON_RESEND_LIMIT		= 129,
+
+	/**
+	 * @BATADV_TP_REASON_ALREADY_ONGOING: test to or from the same node
+	 * already ongoing
+	 */
+	BATADV_TP_REASON_ALREADY_ONGOING	= 130,
+
+	/**
+	 * @BATADV_TP_REASON_MEMORY_ERROR: test was stopped due to low memory
+	 */
+	BATADV_TP_REASON_MEMORY_ERROR		= 131,
+
+	/**
+	 * @BATADV_TP_REASON_CANT_SEND: failed to send via outgoing interface
+	 */
+	BATADV_TP_REASON_CANT_SEND		= 132,
+
+	/**
+	 * @BATADV_TP_REASON_TOO_MANY: too many ongoing sessions
+	 */
+	BATADV_TP_REASON_TOO_MANY		= 133,
+};
+
+/**
+ * enum batadv_ifla_attrs - batman-adv ifla nested attributes
+ */
+enum batadv_ifla_attrs {
+	/**
+	 * @IFLA_BATADV_UNSPEC: unspecified attribute which is not parsed by
+	 *  rtnetlink
+	 */
+	IFLA_BATADV_UNSPEC,
+
+	/**
+	 * @IFLA_BATADV_ALGO_NAME: routing algorithm (name) which should be
+	 *  used by the newly registered batadv net_device.
+	 */
+	IFLA_BATADV_ALGO_NAME,
+
+	/* add attributes above here, update the policy in soft-interface.c */
+
+	/**
+	 * @__IFLA_BATADV_MAX: internal use
+	 */
+	__IFLA_BATADV_MAX,
+};
+
+#define IFLA_BATADV_MAX (__IFLA_BATADV_MAX - 1)
+
+#endif /* _UAPI_LINUX_BATMAN_ADV_H_ */
diff --git a/ip/Makefile b/ip/Makefile
index 2a7a51c3..11a361ce 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -12,7 +12,7 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
     iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
     ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
     ipnexthop.o ipmptcp.o iplink_bareudp.o iplink_wwan.o ipioam6.o \
-    iplink_amt.o
+    iplink_amt.o iplink_batadv.o
 
 RTMONOBJ=rtmon.o
 
diff --git a/ip/iplink_batadv.c b/ip/iplink_batadv.c
new file mode 100644
index 00000000..45bd923f
--- /dev/null
+++ b/ip/iplink_batadv.c
@@ -0,0 +1,64 @@
+/*
+ * iplink_batadv.c	Batman-adv support
+ *
+ * Authors:     Nicolas Escande <nico.escande@gmail.com>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <linux/batman_adv.h>
+
+#include "rt_names.h"
+#include "utils.h"
+#include "ip_common.h"
+
+static void print_explain(FILE *f)
+{
+	fprintf(f,
+		"Usage: ... batadv [ ra ROUTING_ALG ]\n"
+		"\n"
+		"Where: ROUTING_ALG := { BATMAN_IV | BATMAN_V }\n"
+	);
+}
+
+static void explain(void)
+{
+	print_explain(stderr);
+}
+
+static int batadv_parse_opt(struct link_util *lu, int argc, char **argv,
+			    struct nlmsghdr *n)
+{
+	while (argc > 0) {
+		if (matches(*argv, "ra") == 0) {
+			NEXT_ARG();
+			addattrstrz(n, 1024, IFLA_BATADV_ALGO_NAME, *argv);
+		} else if (matches(*argv, "help") == 0) {
+			explain();
+			return -1;
+		} else {
+			fprintf(stderr,
+				"batadv: unknown command \"%s\"?\n",
+				*argv);
+			explain();
+			return -1;
+		}
+		argc--, argv++;
+	}
+
+	return 0;
+}
+
+static void batadv_print_help(struct link_util *lu, int argc, char **argv,
+			      FILE *f)
+{
+	print_explain(f);
+}
+
+struct link_util batadv_link_util = {
+	.id		= "batadv",
+	.maxattr	= IFLA_BATADV_MAX,
+	.parse_opt	= batadv_parse_opt,
+	.print_help	= batadv_print_help,
+};
-- 
2.35.1

