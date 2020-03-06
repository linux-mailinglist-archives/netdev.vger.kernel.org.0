Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A80A317B592
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 05:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgCFE3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 23:29:25 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35475 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbgCFE3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 23:29:07 -0500
Received: by mail-yw1-f68.google.com with SMTP id d79so38578ywd.2
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 20:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LjIqQIN/2szfQ75PSKeiupXgUSHFFM6xFTZ/Ss1UYRs=;
        b=FGwdqCT7fT/IWN+Y38w0FCNa/CgWHSS8UwbEubged5SWFysRdxaXpQFfr6kn81jTeL
         kKMy3Qm2YFxb8sgeQxGVVfm2oYpZ71Hk7NOAEVninw0MXRfVEq0fBLo8PzHmhq28ZTGI
         4btelsPz5yLX6kZHSi1EodeO2ZMg4+46aZNEMwAC3iaSYlqRZCQvPXK06IZuA70r3wsC
         E6vtaT3mncZGUZdLIQCL1FQ5muWzjUass58VYQkNzOaqZM4jdMdAnmWToEanzHZ6mii0
         x58eBQOrT/aXP0KW2Mv2abHQ9/x8Q3VgPkTbRHZ1cxrYfa80OEXFIs2sxBZDo0ekdGOK
         fksA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LjIqQIN/2szfQ75PSKeiupXgUSHFFM6xFTZ/Ss1UYRs=;
        b=hmtKkhPfC3v3ohFSGXY1IU9mUj67flKzE/YVCkVOEDXU+t4R+7RK2q2in0yHgYwtOo
         wbzuvtyT/soW2PhYh8wYrPKa55TJ1KgdHXsXlREOMYU5uHVbqQRUoYn6Gc7LPKLu3wdw
         jfrAbJHRBkEUykvMf3jhtqN2qEcS5XVg6gYo601HpM33OumyWfhZnJnAoroHi6VS6IvK
         mVllSmzigya3EQyd5m1G8ZFuzmPmEdSU4PHH/+WgZMg/OY6sAQmMX5z2rY5UroTuhD63
         oLuScOJiHiIgEzR5NAvJe3uiUGUqdeT5zIpwBb+2tLXjK7DK0beyW7XTfHMkEupHAUys
         tUJQ==
X-Gm-Message-State: ANhLgQ3pA6n34uQyuIhncMtizH1Fg8SFWjlhqsjNprVjOBX5MUzoezge
        X4TXYSQ9hJTVSvDtsGcAtbs0ig==
X-Google-Smtp-Source: ADFU+vuuyAuj7AdtF/lGQjlASBP1BaoTFy1BP25r0/bGAdrtVTd9IDZj18jkYsHe0TmF3VToKLorrg==
X-Received: by 2002:a81:9d8:: with SMTP id 207mr2231269ywj.101.1583468943945;
        Thu, 05 Mar 2020 20:29:03 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x2sm12581836ywa.32.2020.03.05.20.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 20:29:03 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     David Miller <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
        Evan Green <evgreen@google.com>,
        Eric Caruso <ejcaruso@google.com>,
        Susheel Yadav Yadagiri <syadagir@codeaurora.org>,
        Chaitanya Pratapa <cpratapa@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 14/17] soc: qcom: ipa: AP/modem communications
Date:   Thu,  5 Mar 2020 22:28:28 -0600
Message-Id: <20200306042831.17827-15-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200306042831.17827-1-elder@linaro.org>
References: <20200306042831.17827-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements two forms of out-of-band communication between
the AP and modem.

  - QMI is a mechanism that allows clients running on the AP
    interact with services running on the modem (and vice-versa).
    The AP IPA driver uses QMI to communicate with the corresponding
    IPA driver resident on the modem, to agree on parameters used
    with the IPA hardware and to ensure both sides are ready before
    entering operational mode.

  - SMP2P is a more primitive mechanism available for the modem and
    AP to communicate with each other.  It provides a means for either
    the AP or modem to interrupt the other, and furthermore, to provide
    32 bits worth of information.  The IPA driver uses SMP2P to tell
    the modem what the state of the IPA clock was in the event of a
    crash.  This allows the modem to safely access the IPA hardware
    (or avoid doing so) when a crash occurs, for example, to access
    information within the IPA hardware.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_qmi.c     | 538 +++++++++++++++++++++++++++
 drivers/net/ipa/ipa_qmi.h     |  41 +++
 drivers/net/ipa/ipa_qmi_msg.c | 663 ++++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_qmi_msg.h | 252 +++++++++++++
 drivers/net/ipa/ipa_smp2p.c   | 335 +++++++++++++++++
 drivers/net/ipa/ipa_smp2p.h   |  48 +++
 6 files changed, 1877 insertions(+)
 create mode 100644 drivers/net/ipa/ipa_qmi.c
 create mode 100644 drivers/net/ipa/ipa_qmi.h
 create mode 100644 drivers/net/ipa/ipa_qmi_msg.c
 create mode 100644 drivers/net/ipa/ipa_qmi_msg.h
 create mode 100644 drivers/net/ipa/ipa_smp2p.c
 create mode 100644 drivers/net/ipa/ipa_smp2p.h

diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
new file mode 100644
index 000000000000..5090f0f923ad
--- /dev/null
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -0,0 +1,538 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2020 Linaro Ltd.
+ */
+
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/qrtr.h>
+#include <linux/soc/qcom/qmi.h>
+
+#include "ipa.h"
+#include "ipa_endpoint.h"
+#include "ipa_mem.h"
+#include "ipa_table.h"
+#include "ipa_modem.h"
+#include "ipa_qmi_msg.h"
+
+/**
+ * DOC: AP/Modem QMI Handshake
+ *
+ * The AP and modem perform a "handshake" at initialization time to ensure
+ * both sides know when everything is ready to begin operating.  The AP
+ * driver (this code) uses two QMI handles (endpoints) for this; a client
+ * using a service on the modem, and server to service modem requests (and
+ * to supply an indication message from the AP).  Once the handshake is
+ * complete, the AP and modem may begin IPA operation.  This occurs
+ * only when the AP IPA driver, modem IPA driver, and IPA microcontroller
+ * are ready.
+ *
+ * The QMI service on the modem expects to receive an INIT_DRIVER request from
+ * the AP, which contains parameters used by the modem during initialization.
+ * The AP sends this request as soon as it is knows the modem side service
+ * is available.  The modem responds to this request, and if this response
+ * contains a success result, the AP knows the modem IPA driver is ready.
+ *
+ * The modem is responsible for loading firmware on the IPA microcontroller.
+ * This occurs only during the initial modem boot.  The modem sends a
+ * separate DRIVER_INIT_COMPLETE request to the AP to report that the
+ * microcontroller is ready.  The AP may assume the microcontroller is
+ * ready and remain so (even if the modem reboots) once it has received
+ * and responded to this request.
+ *
+ * There is one final exchange involved in the handshake.  It is required
+ * on the initial modem boot, but optional (but in practice does occur) on
+ * subsequent boots.  The modem expects to receive a final INIT_COMPLETE
+ * indication message from the AP when it is about to begin its normal
+ * operation.  The AP will only send this message after it has received
+ * and responded to an INDICATION_REGISTER request from the modem.
+ *
+ * So in summary:
+ * - Whenever the AP learns the modem has booted and its IPA QMI service
+ *   is available, it sends an INIT_DRIVER request to the modem.  The
+ *   modem supplies a success response when it is ready to operate.
+ * - On the initial boot, the modem sets up the IPA microcontroller, and
+ *   sends a DRIVER_INIT_COMPLETE request to the AP when this is done.
+ * - When the modem is ready to receive an INIT_COMPLETE indication from
+ *   the AP, it sends an INDICATION_REGISTER request to the AP.
+ * - On the initial modem boot, everything is ready when:
+ *	- AP has received a success response from its INIT_DRIVER request
+ *	- AP has responded to a DRIVER_INIT_COMPLETE request
+ *	- AP has responded to an INDICATION_REGISTER request from the modem
+ *	- AP has sent an INIT_COMPLETE indication to the modem
+ * - On subsequent modem boots, everything is ready when:
+ *	- AP has received a success response from its INIT_DRIVER request
+ *	- AP has responded to a DRIVER_INIT_COMPLETE request
+ * - The INDICATION_REGISTER request and INIT_COMPLETE indication are
+ *   optional for non-initial modem boots, and have no bearing on the
+ *   determination of when things are "ready"
+ */
+
+#define IPA_HOST_SERVICE_SVC_ID		0x31
+#define IPA_HOST_SVC_VERS		1
+#define IPA_HOST_SERVICE_INS_ID		1
+
+#define IPA_MODEM_SERVICE_SVC_ID	0x31
+#define IPA_MODEM_SERVICE_INS_ID	2
+#define IPA_MODEM_SVC_VERS		1
+
+#define QMI_INIT_DRIVER_TIMEOUT		60000	/* A minute in milliseconds */
+
+/* Send an INIT_COMPLETE indication message to the modem */
+static void ipa_server_init_complete(struct ipa_qmi *ipa_qmi)
+{
+	struct ipa *ipa = container_of(ipa_qmi, struct ipa, qmi);
+	struct qmi_handle *qmi = &ipa_qmi->server_handle;
+	struct sockaddr_qrtr *sq = &ipa_qmi->modem_sq;
+	struct ipa_init_complete_ind ind = { };
+	int ret;
+
+	ind.status.result = QMI_RESULT_SUCCESS_V01;
+	ind.status.error = QMI_ERR_NONE_V01;
+
+	ret = qmi_send_indication(qmi, sq, IPA_QMI_INIT_COMPLETE,
+				   IPA_QMI_INIT_COMPLETE_IND_SZ,
+				   ipa_init_complete_ind_ei, &ind);
+	if (ret)
+		dev_err(&ipa->pdev->dev,
+			"error %d sending init complete indication\n", ret);
+	else
+		ipa_qmi->indication_sent = true;
+}
+
+/* If requested (and not already sent) send the INIT_COMPLETE indication */
+static void ipa_qmi_indication(struct ipa_qmi *ipa_qmi)
+{
+	if (!ipa_qmi->indication_requested)
+		return;
+
+	if (ipa_qmi->indication_sent)
+		return;
+
+	ipa_server_init_complete(ipa_qmi);
+}
+
+/* Determine whether everything is ready to start normal operation.
+ * We know everything (else) is ready when we know the IPA driver on
+ * the modem is ready, and the microcontroller is ready.
+ *
+ * When the modem boots (or reboots), the handshake sequence starts
+ * with the AP sending the modem an INIT_DRIVER request.  Within
+ * that request, the uc_loaded flag will be zero (false) for an
+ * initial boot, non-zero (true) for a subsequent (SSR) boot.
+ */
+static void ipa_qmi_ready(struct ipa_qmi *ipa_qmi)
+{
+	struct ipa *ipa = container_of(ipa_qmi, struct ipa, qmi);
+	int ret;
+
+	/* We aren't ready until the modem and microcontroller are */
+	if (!ipa_qmi->modem_ready || !ipa_qmi->uc_ready)
+		return;
+
+	/* Send the indication message if it was requested */
+	ipa_qmi_indication(ipa_qmi);
+
+	/* The initial boot requires us to send the indication. */
+	if (ipa_qmi->initial_boot) {
+		if (!ipa_qmi->indication_sent)
+			return;
+
+		/* The initial modem boot completed successfully */
+		ipa_qmi->initial_boot = false;
+	}
+
+	/* We're ready.  Start up normal operation */
+	ipa = container_of(ipa_qmi, struct ipa, qmi);
+	ret = ipa_modem_start(ipa);
+	if (ret)
+		dev_err(&ipa->pdev->dev, "error %d starting modem\n", ret);
+}
+
+/* All QMI clients from the modem node are gone (modem shut down or crashed). */
+static void ipa_server_bye(struct qmi_handle *qmi, unsigned int node)
+{
+	struct ipa_qmi *ipa_qmi;
+
+	ipa_qmi = container_of(qmi, struct ipa_qmi, server_handle);
+
+	/* The modem client and server go away at the same time */
+	memset(&ipa_qmi->modem_sq, 0, sizeof(ipa_qmi->modem_sq));
+
+	/* initial_boot doesn't change when modem reboots */
+	/* uc_ready doesn't change when modem reboots */
+	ipa_qmi->modem_ready = false;
+	ipa_qmi->indication_requested = false;
+	ipa_qmi->indication_sent = false;
+}
+
+static struct qmi_ops ipa_server_ops = {
+	.bye		= ipa_server_bye,
+};
+
+/* Callback function to handle an INDICATION_REGISTER request message from the
+ * modem.  This informs the AP that the modem is now ready to receive the
+ * INIT_COMPLETE indication message.
+ */
+static void ipa_server_indication_register(struct qmi_handle *qmi,
+					   struct sockaddr_qrtr *sq,
+					   struct qmi_txn *txn,
+					   const void *decoded)
+{
+	struct ipa_indication_register_rsp rsp = { };
+	struct ipa_qmi *ipa_qmi;
+	struct ipa *ipa;
+	int ret;
+
+	ipa_qmi = container_of(qmi, struct ipa_qmi, server_handle);
+	ipa = container_of(ipa_qmi, struct ipa, qmi);
+
+	rsp.rsp.result = QMI_RESULT_SUCCESS_V01;
+	rsp.rsp.error = QMI_ERR_NONE_V01;
+
+	ret = qmi_send_response(qmi, sq, txn, IPA_QMI_INDICATION_REGISTER,
+				IPA_QMI_INDICATION_REGISTER_RSP_SZ,
+				ipa_indication_register_rsp_ei, &rsp);
+	if (!ret) {
+		ipa_qmi->indication_requested = true;
+		ipa_qmi_ready(ipa_qmi);		/* We might be ready now */
+	} else {
+		dev_err(&ipa->pdev->dev,
+			"error %d sending register indication response\n", ret);
+	}
+}
+
+/* Respond to a DRIVER_INIT_COMPLETE request message from the modem. */
+static void ipa_server_driver_init_complete(struct qmi_handle *qmi,
+					    struct sockaddr_qrtr *sq,
+					    struct qmi_txn *txn,
+					    const void *decoded)
+{
+	struct ipa_driver_init_complete_rsp rsp = { };
+	struct ipa_qmi *ipa_qmi;
+	struct ipa *ipa;
+	int ret;
+
+	ipa_qmi = container_of(qmi, struct ipa_qmi, server_handle);
+	ipa = container_of(ipa_qmi, struct ipa, qmi);
+
+	rsp.rsp.result = QMI_RESULT_SUCCESS_V01;
+	rsp.rsp.error = QMI_ERR_NONE_V01;
+
+	ret = qmi_send_response(qmi, sq, txn, IPA_QMI_DRIVER_INIT_COMPLETE,
+				IPA_QMI_DRIVER_INIT_COMPLETE_RSP_SZ,
+				ipa_driver_init_complete_rsp_ei, &rsp);
+	if (!ret) {
+		ipa_qmi->uc_ready = true;
+		ipa_qmi_ready(ipa_qmi);		/* We might be ready now */
+	} else {
+		dev_err(&ipa->pdev->dev,
+			"error %d sending init complete response\n", ret);
+	}
+}
+
+/* The server handles two request message types sent by the modem. */
+static struct qmi_msg_handler ipa_server_msg_handlers[] = {
+	{
+		.type		= QMI_REQUEST,
+		.msg_id		= IPA_QMI_INDICATION_REGISTER,
+		.ei		= ipa_indication_register_req_ei,
+		.decoded_size	= IPA_QMI_INDICATION_REGISTER_REQ_SZ,
+		.fn		= ipa_server_indication_register,
+	},
+	{
+		.type		= QMI_REQUEST,
+		.msg_id		= IPA_QMI_DRIVER_INIT_COMPLETE,
+		.ei		= ipa_driver_init_complete_req_ei,
+		.decoded_size	= IPA_QMI_DRIVER_INIT_COMPLETE_REQ_SZ,
+		.fn		= ipa_server_driver_init_complete,
+	},
+};
+
+/* Handle an INIT_DRIVER response message from the modem. */
+static void ipa_client_init_driver(struct qmi_handle *qmi,
+				   struct sockaddr_qrtr *sq,
+				   struct qmi_txn *txn, const void *decoded)
+{
+	txn->result = 0;	/* IPA_QMI_INIT_DRIVER request was successful */
+	complete(&txn->completion);
+}
+
+/* The client handles one response message type sent by the modem. */
+static struct qmi_msg_handler ipa_client_msg_handlers[] = {
+	{
+		.type		= QMI_RESPONSE,
+		.msg_id		= IPA_QMI_INIT_DRIVER,
+		.ei		= ipa_init_modem_driver_rsp_ei,
+		.decoded_size	= IPA_QMI_INIT_DRIVER_RSP_SZ,
+		.fn		= ipa_client_init_driver,
+	},
+};
+
+/* Return a pointer to an init modem driver request structure, which contains
+ * configuration parameters for the modem.  The modem may be started multiple
+ * times, but generally these parameters don't change so we can reuse the
+ * request structure once it's initialized.  The only exception is the
+ * skip_uc_load field, which will be set only after the microcontroller has
+ * reported it has completed its initialization.
+ */
+static const struct ipa_init_modem_driver_req *
+init_modem_driver_req(struct ipa_qmi *ipa_qmi)
+{
+	struct ipa *ipa = container_of(ipa_qmi, struct ipa, qmi);
+	static struct ipa_init_modem_driver_req req;
+	const struct ipa_mem *mem;
+
+	/* The microcontroller is initialized on the first boot */
+	req.skip_uc_load_valid = 1;
+	req.skip_uc_load = ipa->uc_loaded ? 1 : 0;
+
+	/* We only have to initialize most of it once */
+	if (req.platform_type_valid)
+		return &req;
+
+	req.platform_type_valid = 1;
+	req.platform_type = IPA_QMI_PLATFORM_TYPE_MSM_ANDROID;
+
+	mem = &ipa->mem[IPA_MEM_MODEM_HEADER];
+	if (mem->size) {
+		req.hdr_tbl_info_valid = 1;
+		req.hdr_tbl_info.start = ipa->mem_offset + mem->offset;
+		req.hdr_tbl_info.end = req.hdr_tbl_info.start + mem->size - 1;
+	}
+
+	mem = &ipa->mem[IPA_MEM_V4_ROUTE];
+	req.v4_route_tbl_info_valid = 1;
+	req.v4_route_tbl_info.start = ipa->mem_offset + mem->offset;
+	req.v4_route_tbl_info.count = mem->size / IPA_TABLE_ENTRY_SIZE;
+
+	mem = &ipa->mem[IPA_MEM_V6_ROUTE];
+	req.v6_route_tbl_info_valid = 1;
+	req.v6_route_tbl_info.start = ipa->mem_offset + mem->offset;
+	req.v6_route_tbl_info.count = mem->size / IPA_TABLE_ENTRY_SIZE;
+
+	mem = &ipa->mem[IPA_MEM_V4_FILTER];
+	req.v4_filter_tbl_start_valid = 1;
+	req.v4_filter_tbl_start = ipa->mem_offset + mem->offset;
+
+	mem = &ipa->mem[IPA_MEM_V6_FILTER];
+	req.v6_filter_tbl_start_valid = 1;
+	req.v6_filter_tbl_start = ipa->mem_offset + mem->offset;
+
+	mem = &ipa->mem[IPA_MEM_MODEM];
+	if (mem->size) {
+		req.modem_mem_info_valid = 1;
+		req.modem_mem_info.start = ipa->mem_offset + mem->offset;
+		req.modem_mem_info.size = mem->size;
+	}
+
+	req.ctrl_comm_dest_end_pt_valid = 1;
+	req.ctrl_comm_dest_end_pt =
+		ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]->endpoint_id;
+
+	/* skip_uc_load_valid and skip_uc_load are set above */
+
+	mem = &ipa->mem[IPA_MEM_MODEM_PROC_CTX];
+	if (mem->size) {
+		req.hdr_proc_ctx_tbl_info_valid = 1;
+		req.hdr_proc_ctx_tbl_info.start =
+			ipa->mem_offset + mem->offset;
+		req.hdr_proc_ctx_tbl_info.end =
+			req.hdr_proc_ctx_tbl_info.start + mem->size - 1;
+	}
+
+	/* Nothing to report for the compression table (zip_tbl_info) */
+
+	mem = &ipa->mem[IPA_MEM_V4_ROUTE_HASHED];
+	if (mem->size) {
+		req.v4_hash_route_tbl_info_valid = 1;
+		req.v4_hash_route_tbl_info.start =
+				ipa->mem_offset + mem->offset;
+		req.v4_hash_route_tbl_info.count =
+				mem->size / IPA_TABLE_ENTRY_SIZE;
+	}
+
+	mem = &ipa->mem[IPA_MEM_V6_ROUTE_HASHED];
+	if (mem->size) {
+		req.v6_hash_route_tbl_info_valid = 1;
+		req.v6_hash_route_tbl_info.start =
+			ipa->mem_offset + mem->offset;
+		req.v6_hash_route_tbl_info.count =
+			mem->size / IPA_TABLE_ENTRY_SIZE;
+	}
+
+	mem = &ipa->mem[IPA_MEM_V4_FILTER_HASHED];
+	if (mem->size) {
+		req.v4_hash_filter_tbl_start_valid = 1;
+		req.v4_hash_filter_tbl_start = ipa->mem_offset + mem->offset;
+	}
+
+	mem = &ipa->mem[IPA_MEM_V6_FILTER_HASHED];
+	if (mem->size) {
+		req.v6_hash_filter_tbl_start_valid = 1;
+		req.v6_hash_filter_tbl_start = ipa->mem_offset + mem->offset;
+	}
+
+	/* None of the stats fields are valid (IPA v4.0 and above) */
+
+	if (ipa->version != IPA_VERSION_3_5_1) {
+		mem = &ipa->mem[IPA_MEM_STATS_QUOTA];
+		if (mem->size) {
+			req.hw_stats_quota_base_addr_valid = 1;
+			req.hw_stats_quota_base_addr =
+				ipa->mem_offset + mem->offset;
+			req.hw_stats_quota_size_valid = 1;
+			req.hw_stats_quota_size = ipa->mem_offset + mem->size;
+		}
+
+		mem = &ipa->mem[IPA_MEM_STATS_DROP];
+		if (mem->size) {
+			req.hw_stats_drop_base_addr_valid = 1;
+			req.hw_stats_drop_base_addr =
+				ipa->mem_offset + mem->offset;
+			req.hw_stats_drop_size_valid = 1;
+			req.hw_stats_drop_size = ipa->mem_offset + mem->size;
+		}
+	}
+
+	return &req;
+}
+
+/* Send an INIT_DRIVER request to the modem, and wait for it to complete. */
+static void ipa_client_init_driver_work(struct work_struct *work)
+{
+	unsigned long timeout = msecs_to_jiffies(QMI_INIT_DRIVER_TIMEOUT);
+	const struct ipa_init_modem_driver_req *req;
+	struct ipa_qmi *ipa_qmi;
+	struct qmi_handle *qmi;
+	struct qmi_txn txn;
+	struct device *dev;
+	struct ipa *ipa;
+	int ret;
+
+	ipa_qmi = container_of(work, struct ipa_qmi, init_driver_work);
+	qmi = &ipa_qmi->client_handle,
+
+	ipa = container_of(ipa_qmi, struct ipa, qmi);
+	dev = &ipa->pdev->dev;
+
+	ret = qmi_txn_init(qmi, &txn, NULL, NULL);
+	if (ret < 0) {
+		dev_err(dev, "error %d preparing init driver request\n", ret);
+		return;
+	}
+
+	/* Send the request, and if successful wait for its response */
+	req = init_modem_driver_req(ipa_qmi);
+	ret = qmi_send_request(qmi, &ipa_qmi->modem_sq, &txn,
+			       IPA_QMI_INIT_DRIVER, IPA_QMI_INIT_DRIVER_REQ_SZ,
+			       ipa_init_modem_driver_req_ei, req);
+	if (ret)
+		dev_err(dev, "error %d sending init driver request\n", ret);
+	else if ((ret = qmi_txn_wait(&txn, timeout)))
+		dev_err(dev, "error %d awaiting init driver response\n", ret);
+
+	if (!ret) {
+		ipa_qmi->modem_ready = true;
+		ipa_qmi_ready(ipa_qmi);		/* We might be ready now */
+	} else {
+		/* If any error occurs we need to cancel the transaction */
+		qmi_txn_cancel(&txn);
+	}
+}
+
+/* The modem server is now available.  We will send an INIT_DRIVER request
+ * to the modem, but can't wait for it to complete in this callback thread.
+ * Schedule a worker on the global workqueue to do that for us.
+ */
+static int
+ipa_client_new_server(struct qmi_handle *qmi, struct qmi_service *svc)
+{
+	struct ipa_qmi *ipa_qmi;
+
+	ipa_qmi = container_of(qmi, struct ipa_qmi, client_handle);
+
+	ipa_qmi->modem_sq.sq_family = AF_QIPCRTR;
+	ipa_qmi->modem_sq.sq_node = svc->node;
+	ipa_qmi->modem_sq.sq_port = svc->port;
+
+	schedule_work(&ipa_qmi->init_driver_work);
+
+	return 0;
+}
+
+static struct qmi_ops ipa_client_ops = {
+	.new_server	= ipa_client_new_server,
+};
+
+/* This is called by ipa_setup().  We can be informed via remoteproc that
+ * the modem has shut down, in which case this function will be called
+ * again to prepare for it coming back up again.
+ */
+int ipa_qmi_setup(struct ipa *ipa)
+{
+	struct ipa_qmi *ipa_qmi = &ipa->qmi;
+	int ret;
+
+	ipa_qmi->initial_boot = true;
+
+	/* The server handle is used to handle the DRIVER_INIT_COMPLETE
+	 * request on the first modem boot.  It also receives the
+	 * INDICATION_REGISTER request on the first boot and (optionally)
+	 * subsequent boots.  The INIT_COMPLETE indication message is
+	 * sent over the server handle if requested.
+	 */
+	ret = qmi_handle_init(&ipa_qmi->server_handle,
+			      IPA_QMI_SERVER_MAX_RCV_SZ, &ipa_server_ops,
+			      ipa_server_msg_handlers);
+	if (ret)
+		return ret;
+
+	ret = qmi_add_server(&ipa_qmi->server_handle, IPA_HOST_SERVICE_SVC_ID,
+			     IPA_HOST_SVC_VERS, IPA_HOST_SERVICE_INS_ID);
+	if (ret)
+		goto err_server_handle_release;
+
+	/* The client handle is only used for sending an INIT_DRIVER request
+	 * to the modem, and receiving its response message.
+	 */
+	ret = qmi_handle_init(&ipa_qmi->client_handle,
+			      IPA_QMI_CLIENT_MAX_RCV_SZ, &ipa_client_ops,
+			      ipa_client_msg_handlers);
+	if (ret)
+		goto err_server_handle_release;
+
+	/* We need this ready before the service lookup is added */
+	INIT_WORK(&ipa_qmi->init_driver_work, ipa_client_init_driver_work);
+
+	ret = qmi_add_lookup(&ipa_qmi->client_handle, IPA_MODEM_SERVICE_SVC_ID,
+			     IPA_MODEM_SVC_VERS, IPA_MODEM_SERVICE_INS_ID);
+	if (ret)
+		goto err_client_handle_release;
+
+	return 0;
+
+err_client_handle_release:
+	/* Releasing the handle also removes registered lookups */
+	qmi_handle_release(&ipa_qmi->client_handle);
+	memset(&ipa_qmi->client_handle, 0, sizeof(ipa_qmi->client_handle));
+err_server_handle_release:
+	/* Releasing the handle also removes registered services */
+	qmi_handle_release(&ipa_qmi->server_handle);
+	memset(&ipa_qmi->server_handle, 0, sizeof(ipa_qmi->server_handle));
+
+	return ret;
+}
+
+void ipa_qmi_teardown(struct ipa *ipa)
+{
+	cancel_work_sync(&ipa->qmi.init_driver_work);
+
+	qmi_handle_release(&ipa->qmi.client_handle);
+	memset(&ipa->qmi.client_handle, 0, sizeof(ipa->qmi.client_handle));
+
+	qmi_handle_release(&ipa->qmi.server_handle);
+	memset(&ipa->qmi.server_handle, 0, sizeof(ipa->qmi.server_handle));
+}
diff --git a/drivers/net/ipa/ipa_qmi.h b/drivers/net/ipa/ipa_qmi.h
new file mode 100644
index 000000000000..3993687593d0
--- /dev/null
+++ b/drivers/net/ipa/ipa_qmi.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2020 Linaro Ltd.
+ */
+#ifndef _IPA_QMI_H_
+#define _IPA_QMI_H_
+
+#include <linux/types.h>
+#include <linux/soc/qcom/qmi.h>
+
+struct ipa;
+
+/**
+ * struct ipa_qmi - QMI state associated with an IPA
+ * @client_handle	- used to send an QMI requests to the modem
+ * @server_handle	- used to handle QMI requests from the modem
+ * @initialized		- whether QMI initialization has completed
+ * @indication_register_received - tracks modem request receipt
+ * @init_driver_response_received - tracks modem response receipt
+ */
+struct ipa_qmi {
+	struct qmi_handle client_handle;
+	struct qmi_handle server_handle;
+
+	/* Information used for the client handle */
+	struct sockaddr_qrtr modem_sq;
+	struct work_struct init_driver_work;
+
+	/* Flags used in negotiating readiness */
+	bool initial_boot;
+	bool uc_ready;
+	bool modem_ready;
+	bool indication_requested;
+	bool indication_sent;
+};
+
+int ipa_qmi_setup(struct ipa *ipa);
+void ipa_qmi_teardown(struct ipa *ipa);
+
+#endif /* !_IPA_QMI_H_ */
diff --git a/drivers/net/ipa/ipa_qmi_msg.c b/drivers/net/ipa/ipa_qmi_msg.c
new file mode 100644
index 000000000000..03a1d0e55964
--- /dev/null
+++ b/drivers/net/ipa/ipa_qmi_msg.c
@@ -0,0 +1,663 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2020 Linaro Ltd.
+ */
+#include <linux/stddef.h>
+#include <linux/soc/qcom/qmi.h>
+
+#include "ipa_qmi_msg.h"
+
+/* QMI message structure definition for struct ipa_indication_register_req */
+struct qmi_elem_info ipa_indication_register_req_ei[] = {
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_indication_register_req,
+				     master_driver_init_complete_valid),
+		.tlv_type	= 0x10,
+		.offset		= offsetof(struct ipa_indication_register_req,
+					   master_driver_init_complete_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_1_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_indication_register_req,
+				     master_driver_init_complete),
+		.tlv_type	= 0x10,
+		.offset		= offsetof(struct ipa_indication_register_req,
+					   master_driver_init_complete),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_indication_register_req,
+				     data_usage_quota_reached_valid),
+		.tlv_type	= 0x11,
+		.offset		= offsetof(struct ipa_indication_register_req,
+					   data_usage_quota_reached_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_1_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_indication_register_req,
+				     data_usage_quota_reached),
+		.tlv_type	= 0x11,
+		.offset		= offsetof(struct ipa_indication_register_req,
+					   data_usage_quota_reached),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_indication_register_req,
+				     ipa_mhi_ready_ind_valid),
+		.tlv_type	= 0x11,
+		.offset		= offsetof(struct ipa_indication_register_req,
+					   ipa_mhi_ready_ind_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_1_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_indication_register_req,
+				     ipa_mhi_ready_ind),
+		.tlv_type	= 0x11,
+		.offset		= offsetof(struct ipa_indication_register_req,
+					   ipa_mhi_ready_ind),
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
+
+/* QMI message structure definition for struct ipa_indication_register_rsp */
+struct qmi_elem_info ipa_indication_register_rsp_ei[] = {
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_indication_register_rsp,
+				     rsp),
+		.tlv_type	= 0x02,
+		.offset		= offsetof(struct ipa_indication_register_rsp,
+					   rsp),
+		.ei_array	= qmi_response_type_v01_ei,
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
+
+/* QMI message structure definition for struct ipa_driver_init_complete_req */
+struct qmi_elem_info ipa_driver_init_complete_req_ei[] = {
+	{
+		.data_type	= QMI_UNSIGNED_1_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_driver_init_complete_req,
+				     status),
+		.tlv_type	= 0x01,
+		.offset		= offsetof(struct ipa_driver_init_complete_req,
+					   status),
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
+
+/* QMI message structure definition for struct ipa_driver_init_complete_rsp */
+struct qmi_elem_info ipa_driver_init_complete_rsp_ei[] = {
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_driver_init_complete_rsp,
+				     rsp),
+		.tlv_type	= 0x02,
+		.elem_size	= offsetof(struct ipa_driver_init_complete_rsp,
+					   rsp),
+		.ei_array	= qmi_response_type_v01_ei,
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
+
+/* QMI message structure definition for struct ipa_init_complete_ind */
+struct qmi_elem_info ipa_init_complete_ind_ei[] = {
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_complete_ind,
+				     status),
+		.tlv_type	= 0x02,
+		.elem_size	= offsetof(struct ipa_init_complete_ind,
+					   status),
+		.ei_array	= qmi_response_type_v01_ei,
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
+
+/* QMI message structure definition for struct ipa_mem_bounds */
+struct qmi_elem_info ipa_mem_bounds_ei[] = {
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_mem_bounds, start),
+		.offset		= offsetof(struct ipa_mem_bounds, start),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_mem_bounds, end),
+		.offset		= offsetof(struct ipa_mem_bounds, end),
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
+
+/* QMI message structure definition for struct ipa_mem_array */
+struct qmi_elem_info ipa_mem_array_ei[] = {
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_mem_array, start),
+		.offset		= offsetof(struct ipa_mem_array, start),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_mem_array, count),
+		.offset		= offsetof(struct ipa_mem_array, count),
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
+
+/* QMI message structure definition for struct ipa_mem_range */
+struct qmi_elem_info ipa_mem_range_ei[] = {
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_mem_range, start),
+		.offset		= offsetof(struct ipa_mem_range, start),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_mem_range, size),
+		.offset		= offsetof(struct ipa_mem_range, size),
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
+
+/* QMI message structure definition for struct ipa_init_modem_driver_req */
+struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     platform_type_valid),
+		.tlv_type	= 0x10,
+		.elem_size	= offsetof(struct ipa_init_modem_driver_req,
+					   platform_type_valid),
+	},
+	{
+		.data_type	= QMI_SIGNED_4_BYTE_ENUM,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     platform_type),
+		.tlv_type	= 0x10,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   platform_type),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     hdr_tbl_info_valid),
+		.tlv_type	= 0x11,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   hdr_tbl_info_valid),
+	},
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     hdr_tbl_info),
+		.tlv_type	= 0x11,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   hdr_tbl_info),
+		.ei_array	= ipa_mem_bounds_ei,
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v4_route_tbl_info_valid),
+		.tlv_type	= 0x12,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v4_route_tbl_info_valid),
+	},
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v4_route_tbl_info),
+		.tlv_type	= 0x12,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v4_route_tbl_info),
+		.ei_array	= ipa_mem_array_ei,
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v6_route_tbl_info_valid),
+		.tlv_type	= 0x13,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v6_route_tbl_info_valid),
+	},
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v6_route_tbl_info),
+		.tlv_type	= 0x13,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v6_route_tbl_info),
+		.ei_array	= ipa_mem_array_ei,
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v4_filter_tbl_start_valid),
+		.tlv_type	= 0x14,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v4_filter_tbl_start_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v4_filter_tbl_start),
+		.tlv_type	= 0x14,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v4_filter_tbl_start),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v6_filter_tbl_start_valid),
+		.tlv_type	= 0x15,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v6_filter_tbl_start_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v6_filter_tbl_start),
+		.tlv_type	= 0x15,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v6_filter_tbl_start),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     modem_mem_info_valid),
+		.tlv_type	= 0x16,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   modem_mem_info_valid),
+	},
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     modem_mem_info),
+		.tlv_type	= 0x16,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   modem_mem_info),
+		.ei_array	= ipa_mem_range_ei,
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     ctrl_comm_dest_end_pt_valid),
+		.tlv_type	= 0x17,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   ctrl_comm_dest_end_pt_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     ctrl_comm_dest_end_pt),
+		.tlv_type	= 0x17,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   ctrl_comm_dest_end_pt),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     skip_uc_load_valid),
+		.tlv_type	= 0x18,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   skip_uc_load_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_1_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     skip_uc_load),
+		.tlv_type	= 0x18,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   skip_uc_load),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     hdr_proc_ctx_tbl_info_valid),
+		.tlv_type	= 0x19,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   hdr_proc_ctx_tbl_info_valid),
+	},
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     hdr_proc_ctx_tbl_info),
+		.tlv_type	= 0x19,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   hdr_proc_ctx_tbl_info),
+		.ei_array	= ipa_mem_bounds_ei,
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     zip_tbl_info_valid),
+		.tlv_type	= 0x1a,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   zip_tbl_info_valid),
+	},
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     zip_tbl_info),
+		.tlv_type	= 0x1a,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   zip_tbl_info),
+		.ei_array	= ipa_mem_bounds_ei,
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v4_hash_route_tbl_info_valid),
+		.tlv_type	= 0x1b,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v4_hash_route_tbl_info_valid),
+	},
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v4_hash_route_tbl_info),
+		.tlv_type	= 0x1b,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v4_hash_route_tbl_info),
+		.ei_array	= ipa_mem_array_ei,
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v6_hash_route_tbl_info_valid),
+		.tlv_type	= 0x1c,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v6_hash_route_tbl_info_valid),
+	},
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v6_hash_route_tbl_info),
+		.tlv_type	= 0x1c,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v6_hash_route_tbl_info),
+		.ei_array	= ipa_mem_array_ei,
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v4_hash_filter_tbl_start_valid),
+		.tlv_type	= 0x1d,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v4_hash_filter_tbl_start_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v4_hash_filter_tbl_start),
+		.tlv_type	= 0x1d,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v4_hash_filter_tbl_start),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v6_hash_filter_tbl_start_valid),
+		.tlv_type	= 0x1e,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v6_hash_filter_tbl_start_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     v6_hash_filter_tbl_start),
+		.tlv_type	= 0x1e,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   v6_hash_filter_tbl_start),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     hw_stats_quota_base_addr_valid),
+		.tlv_type	= 0x1f,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   hw_stats_quota_base_addr_valid),
+	},
+	{
+		.data_type	= QMI_SIGNED_4_BYTE_ENUM,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     hw_stats_quota_base_addr),
+		.tlv_type	= 0x1f,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   hw_stats_quota_base_addr),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     hw_stats_quota_size_valid),
+		.tlv_type	= 0x1f,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   hw_stats_quota_size_valid),
+	},
+	{
+		.data_type	= QMI_SIGNED_4_BYTE_ENUM,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     hw_stats_quota_size),
+		.tlv_type	= 0x1f,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   hw_stats_quota_size),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     hw_stats_drop_size_valid),
+		.tlv_type	= 0x1f,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   hw_stats_drop_size_valid),
+	},
+	{
+		.data_type	= QMI_SIGNED_4_BYTE_ENUM,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_req,
+				     hw_stats_drop_size),
+		.tlv_type	= 0x1f,
+		.offset		= offsetof(struct ipa_init_modem_driver_req,
+					   hw_stats_drop_size),
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
+
+/* QMI message structure definition for struct ipa_init_modem_driver_rsp */
+struct qmi_elem_info ipa_init_modem_driver_rsp_ei[] = {
+	{
+		.data_type	= QMI_STRUCT,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_rsp,
+				     rsp),
+		.tlv_type	= 0x02,
+		.offset		= offsetof(struct ipa_init_modem_driver_rsp,
+					   rsp),
+		.ei_array	= qmi_response_type_v01_ei,
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_rsp,
+				     ctrl_comm_dest_end_pt_valid),
+		.tlv_type	= 0x10,
+		.offset		= offsetof(struct ipa_init_modem_driver_rsp,
+					   ctrl_comm_dest_end_pt_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_rsp,
+				     ctrl_comm_dest_end_pt),
+		.tlv_type	= 0x10,
+		.offset		= offsetof(struct ipa_init_modem_driver_rsp,
+					   ctrl_comm_dest_end_pt),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_rsp,
+				     default_end_pt_valid),
+		.tlv_type	= 0x11,
+		.offset		= offsetof(struct ipa_init_modem_driver_rsp,
+					   default_end_pt_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_4_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_rsp,
+				     default_end_pt),
+		.tlv_type	= 0x11,
+		.offset		= offsetof(struct ipa_init_modem_driver_rsp,
+					   default_end_pt),
+	},
+	{
+		.data_type	= QMI_OPT_FLAG,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_rsp,
+				     modem_driver_init_pending_valid),
+		.tlv_type	= 0x12,
+		.offset		= offsetof(struct ipa_init_modem_driver_rsp,
+					   modem_driver_init_pending_valid),
+	},
+	{
+		.data_type	= QMI_UNSIGNED_1_BYTE,
+		.elem_len	= 1,
+		.elem_size	=
+			sizeof_field(struct ipa_init_modem_driver_rsp,
+				     modem_driver_init_pending),
+		.tlv_type	= 0x12,
+		.offset		= offsetof(struct ipa_init_modem_driver_rsp,
+					   modem_driver_init_pending),
+	},
+	{
+		.data_type	= QMI_EOTI,
+	},
+};
diff --git a/drivers/net/ipa/ipa_qmi_msg.h b/drivers/net/ipa/ipa_qmi_msg.h
new file mode 100644
index 000000000000..cfac456cea0c
--- /dev/null
+++ b/drivers/net/ipa/ipa_qmi_msg.h
@@ -0,0 +1,252 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2020 Linaro Ltd.
+ */
+#ifndef _IPA_QMI_MSG_H_
+#define _IPA_QMI_MSG_H_
+
+/* === Only "ipa_qmi" and "ipa_qmi_msg.c" should include this file === */
+
+#include <linux/types.h>
+#include <linux/soc/qcom/qmi.h>
+
+/* Request/response/indication QMI message ids used for IPA.  Receiving
+ * end issues a response for requests; indications require no response.
+ */
+#define IPA_QMI_INDICATION_REGISTER	0x20	/* modem -> AP request */
+#define IPA_QMI_INIT_DRIVER		0x21	/* AP -> modem request */
+#define IPA_QMI_INIT_COMPLETE		0x22	/* AP -> modem indication */
+#define IPA_QMI_DRIVER_INIT_COMPLETE	0x35	/* modem -> AP request */
+
+/* The maximum size required for message types.  These sizes include
+ * the message data, along with type (1 byte) and length (2 byte)
+ * information for each field.  The qmi_send_*() interfaces require
+ * the message size to be provided.
+ */
+#define IPA_QMI_INDICATION_REGISTER_REQ_SZ	12	/* -> server handle */
+#define IPA_QMI_INDICATION_REGISTER_RSP_SZ	7	/* <- server handle */
+#define IPA_QMI_INIT_DRIVER_REQ_SZ		162	/* client handle -> */
+#define IPA_QMI_INIT_DRIVER_RSP_SZ		25	/* client handle <- */
+#define IPA_QMI_INIT_COMPLETE_IND_SZ		7	/* <- server handle */
+#define IPA_QMI_DRIVER_INIT_COMPLETE_REQ_SZ	4	/* -> server handle */
+#define IPA_QMI_DRIVER_INIT_COMPLETE_RSP_SZ	7	/* <- server handle */
+
+/* Maximum size of messages we expect the AP to receive (max of above) */
+#define IPA_QMI_SERVER_MAX_RCV_SZ		8
+#define IPA_QMI_CLIENT_MAX_RCV_SZ		25
+
+/* Request message for the IPA_QMI_INDICATION_REGISTER request */
+struct ipa_indication_register_req {
+	u8 master_driver_init_complete_valid;
+	u8 master_driver_init_complete;
+	u8 data_usage_quota_reached_valid;
+	u8 data_usage_quota_reached;
+	u8 ipa_mhi_ready_ind_valid;
+	u8 ipa_mhi_ready_ind;
+};
+
+/* The response to a IPA_QMI_INDICATION_REGISTER request consists only of
+ * a standard QMI response.
+ */
+struct ipa_indication_register_rsp {
+	struct qmi_response_type_v01 rsp;
+};
+
+/* Request message for the IPA_QMI_DRIVER_INIT_COMPLETE request */
+struct ipa_driver_init_complete_req {
+	u8 status;
+};
+
+/* The response to a IPA_QMI_DRIVER_INIT_COMPLETE request consists only
+ * of a standard QMI response.
+ */
+struct ipa_driver_init_complete_rsp {
+	struct qmi_response_type_v01 rsp;
+};
+
+/* The message for the IPA_QMI_INIT_COMPLETE_IND indication consists
+ * only of a standard QMI response.
+ */
+struct ipa_init_complete_ind {
+	struct qmi_response_type_v01 status;
+};
+
+/* The AP tells the modem its platform type.  We assume Android. */
+enum ipa_platform_type {
+	IPA_QMI_PLATFORM_TYPE_INVALID		= 0,	/* Invalid */
+	IPA_QMI_PLATFORM_TYPE_TN		= 1,	/* Data card */
+	IPA_QMI_PLATFORM_TYPE_LE		= 2,	/* Data router */
+	IPA_QMI_PLATFORM_TYPE_MSM_ANDROID	= 3,	/* Android MSM */
+	IPA_QMI_PLATFORM_TYPE_MSM_WINDOWS	= 4,	/* Windows MSM */
+	IPA_QMI_PLATFORM_TYPE_MSM_QNX_V01	= 5,	/* QNX MSM */
+};
+
+/* This defines the start and end offset of a range of memory.  Both
+ * fields are offsets relative to the start of IPA shared memory.
+ * The end value is the last addressable byte *within* the range.
+ */
+struct ipa_mem_bounds {
+	u32 start;
+	u32 end;
+};
+
+/* This defines the location and size of an array.  The start value
+ * is an offset relative to the start of IPA shared memory.  The
+ * size of the array is implied by the number of entries (the entry
+ * size is assumed to be known).
+ */
+struct ipa_mem_array {
+	u32 start;
+	u32 count;
+};
+
+/* This defines the location and size of a range of memory.  The
+ * start is an offset relative to the start of IPA shared memory.
+ * This differs from the ipa_mem_bounds structure in that the size
+ * (in bytes) of the memory region is specified rather than the
+ * offset of its last byte.
+ */
+struct ipa_mem_range {
+	u32 start;
+	u32 size;
+};
+
+/* The message for the IPA_QMI_INIT_DRIVER request contains information
+ * from the AP that affects modem initialization.
+ */
+struct ipa_init_modem_driver_req {
+	u8			platform_type_valid;
+	u32			platform_type;	/* enum ipa_platform_type */
+
+	/* Modem header table information.  This defines the IPA shared
+	 * memory in which the modem may insert header table entries.
+	 */
+	u8			hdr_tbl_info_valid;
+	struct ipa_mem_bounds	hdr_tbl_info;
+
+	/* Routing table information.  These define the location and size of
+	 * non-hashable IPv4 and IPv6 filter tables.  The start values are
+	 * offsets relative to the start of IPA shared memory.
+	 */
+	u8			v4_route_tbl_info_valid;
+	struct ipa_mem_array	v4_route_tbl_info;
+	u8			v6_route_tbl_info_valid;
+	struct ipa_mem_array	v6_route_tbl_info;
+
+	/* Filter table information.  These define the location of the
+	 * non-hashable IPv4 and IPv6 filter tables.  The start values are
+	 * offsets relative to the start of IPA shared memory.
+	 */
+	u8			v4_filter_tbl_start_valid;
+	u32			v4_filter_tbl_start;
+	u8			v6_filter_tbl_start_valid;
+	u32			v6_filter_tbl_start;
+
+	/* Modem memory information.  This defines the location and
+	 * size of memory available for the modem to use.
+	 */
+	u8			modem_mem_info_valid;
+	struct ipa_mem_range	modem_mem_info;
+
+	/* This defines the destination endpoint on the AP to which
+	 * the modem driver can send control commands.  Must be less
+	 * than ipa_endpoint_max().
+	 */
+	u8			ctrl_comm_dest_end_pt_valid;
+	u32			ctrl_comm_dest_end_pt;
+
+	/* This defines whether the modem should load the microcontroller
+	 * or not.  It is unnecessary to reload it if the modem is being
+	 * restarted.
+	 *
+	 * NOTE: this field is named "is_ssr_bootup" elsewhere.
+	 */
+	u8			skip_uc_load_valid;
+	u8			skip_uc_load;
+
+	/* Processing context memory information.  This defines the memory in
+	 * which the modem may insert header processing context table entries.
+	 */
+	u8			hdr_proc_ctx_tbl_info_valid;
+	struct ipa_mem_bounds	hdr_proc_ctx_tbl_info;
+
+	/* Compression command memory information.  This defines the memory
+	 * in which the modem may insert compression/decompression commands.
+	 */
+	u8			zip_tbl_info_valid;
+	struct ipa_mem_bounds	zip_tbl_info;
+
+	/* Routing table information.  These define the location and size
+	 * of hashable IPv4 and IPv6 filter tables.  The start values are
+	 * offsets relative to the start of IPA shared memory.
+	 */
+	u8			v4_hash_route_tbl_info_valid;
+	struct ipa_mem_array	v4_hash_route_tbl_info;
+	u8			v6_hash_route_tbl_info_valid;
+	struct ipa_mem_array	v6_hash_route_tbl_info;
+
+	/* Filter table information.  These define the location and size
+	 * of hashable IPv4 and IPv6 filter tables.  The start values are
+	 * offsets relative to the start of IPA shared memory.
+	 */
+	u8			v4_hash_filter_tbl_start_valid;
+	u32			v4_hash_filter_tbl_start;
+	u8			v6_hash_filter_tbl_start_valid;
+	u32			v6_hash_filter_tbl_start;
+
+	/* Statistics information.  These define the locations of the
+	 * first and last statistics sub-regions.  (IPA v4.0 and above)
+	 */
+	u8			hw_stats_quota_base_addr_valid;
+	u32			hw_stats_quota_base_addr;
+	u8			hw_stats_quota_size_valid;
+	u32			hw_stats_quota_size;
+	u8			hw_stats_drop_base_addr_valid;
+	u32			hw_stats_drop_base_addr;
+	u8			hw_stats_drop_size_valid;
+	u32			hw_stats_drop_size;
+};
+
+/* The response to a IPA_QMI_INIT_DRIVER request begins with a standard
+ * QMI response, but contains other information as well.  Currently we
+ * simply wait for the the INIT_DRIVER transaction to complete and
+ * ignore any other data that might be returned.
+ */
+struct ipa_init_modem_driver_rsp {
+	struct qmi_response_type_v01	rsp;
+
+	/* This defines the destination endpoint on the modem to which
+	 * the AP driver can send control commands.  Must be less than
+	 * ipa_endpoint_max().
+	 */
+	u8				ctrl_comm_dest_end_pt_valid;
+	u32				ctrl_comm_dest_end_pt;
+
+	/* This defines the default endpoint.  The AP driver is not
+	 * required to configure the hardware with this value.  Must
+	 * be less than ipa_endpoint_max().
+	 */
+	u8				default_end_pt_valid;
+	u32				default_end_pt;
+
+	/* This defines whether a second handshake is required to complete
+	 * initialization.
+	 */
+	u8				modem_driver_init_pending_valid;
+	u8				modem_driver_init_pending;
+};
+
+/* Message structure definitions defined in "ipa_qmi_msg.c" */
+extern struct qmi_elem_info ipa_indication_register_req_ei[];
+extern struct qmi_elem_info ipa_indication_register_rsp_ei[];
+extern struct qmi_elem_info ipa_driver_init_complete_req_ei[];
+extern struct qmi_elem_info ipa_driver_init_complete_rsp_ei[];
+extern struct qmi_elem_info ipa_init_complete_ind_ei[];
+extern struct qmi_elem_info ipa_mem_bounds_ei[];
+extern struct qmi_elem_info ipa_mem_array_ei[];
+extern struct qmi_elem_info ipa_mem_range_ei[];
+extern struct qmi_elem_info ipa_init_modem_driver_req_ei[];
+extern struct qmi_elem_info ipa_init_modem_driver_rsp_ei[];
+
+#endif /* !_IPA_QMI_MSG_H_ */
diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
new file mode 100644
index 000000000000..4d33aa7ebfbb
--- /dev/null
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -0,0 +1,335 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019-2020 Linaro Ltd.
+ */
+
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/notifier.h>
+#include <linux/soc/qcom/smem.h>
+#include <linux/soc/qcom/smem_state.h>
+
+#include "ipa_smp2p.h"
+#include "ipa.h"
+#include "ipa_uc.h"
+#include "ipa_clock.h"
+
+/**
+ * DOC: IPA SMP2P communication with the modem
+ *
+ * SMP2P is a primitive communication mechanism available between the AP and
+ * the modem.  The IPA driver uses this for two purposes:  to enable the modem
+ * to state that the GSI hardware is ready to use; and to communicate the
+ * state of the IPA clock in the event of a crash.
+ *
+ * GSI needs to have early initialization completed before it can be used.
+ * This initialization is done either by Trust Zone or by the modem.  In the
+ * latter case, the modem uses an SMP2P interrupt to tell the AP IPA driver
+ * when the GSI is ready to use.
+ *
+ * The modem is also able to inquire about the current state of the IPA
+ * clock by trigging another SMP2P interrupt to the AP.  We communicate
+ * whether the clock is enabled using two SMP2P state bits--one to
+ * indicate the clock state (on or off), and a second to indicate the
+ * clock state bit is valid.  The modem will poll the valid bit until it
+ * is set, and at that time records whether the AP has the IPA clock enabled.
+ *
+ * Finally, if the AP kernel panics, we update the SMP2P state bits even if
+ * we never receive an interrupt from the modem requesting this.
+ */
+
+/**
+ * struct ipa_smp2p - IPA SMP2P information
+ * @ipa:		IPA pointer
+ * @valid_state:	SMEM state indicating enabled state is valid
+ * @enabled_state:	SMEM state to indicate clock is enabled
+ * @valid_bit:		Valid bit in 32-bit SMEM state mask
+ * @enabled_bit:	Enabled bit in 32-bit SMEM state mask
+ * @enabled_bit:	Enabled bit in 32-bit SMEM state mask
+ * @clock_query_irq:	IPA interrupt triggered by modem for clock query
+ * @setup_ready_irq:	IPA interrupt triggered by modem to signal GSI ready
+ * @clock_on:		Whether IPA clock is on
+ * @notified:		Whether modem has been notified of clock state
+ * @disabled:		Whether setup ready interrupt handling is disabled
+ * @mutex mutex:	Motex protecting ready interrupt/shutdown interlock
+ * @panic_notifier:	Panic notifier structure
+*/
+struct ipa_smp2p {
+	struct ipa *ipa;
+	struct qcom_smem_state *valid_state;
+	struct qcom_smem_state *enabled_state;
+	u32 valid_bit;
+	u32 enabled_bit;
+	u32 clock_query_irq;
+	u32 setup_ready_irq;
+	bool clock_on;
+	bool notified;
+	bool disabled;
+	struct mutex mutex;
+	struct notifier_block panic_notifier;
+};
+
+/**
+ * ipa_smp2p_notify() - use SMP2P to tell modem about IPA clock state
+ * @smp2p:	SMP2P information
+ *
+ * This is called either when the modem has requested it (by triggering
+ * the modem clock query IPA interrupt) or whenever the AP is shutting down
+ * (via a panic notifier).  It sets the two SMP2P state bits--one saying
+ * whether the IPA clock is running, and the other indicating the first bit
+ * is valid.
+ */
+static void ipa_smp2p_notify(struct ipa_smp2p *smp2p)
+{
+	u32 value;
+	u32 mask;
+
+	if (smp2p->notified)
+		return;
+
+	smp2p->clock_on = ipa_clock_get_additional(smp2p->ipa);
+
+	/* Signal whether the clock is enabled */
+	mask = BIT(smp2p->enabled_bit);
+	value = smp2p->clock_on ? mask : 0;
+	qcom_smem_state_update_bits(smp2p->enabled_state, mask, value);
+
+	/* Now indicate that the enabled flag is valid */
+	mask = BIT(smp2p->valid_bit);
+	value = mask;
+	qcom_smem_state_update_bits(smp2p->valid_state, mask, value);
+
+	smp2p->notified = true;
+}
+
+/* Threaded IRQ handler for modem "ipa-clock-query" SMP2P interrupt */
+static irqreturn_t ipa_smp2p_modem_clk_query_isr(int irq, void *dev_id)
+{
+	struct ipa_smp2p *smp2p = dev_id;
+
+	ipa_smp2p_notify(smp2p);
+
+	return IRQ_HANDLED;
+}
+
+static int ipa_smp2p_panic_notifier(struct notifier_block *nb,
+				    unsigned long action, void *data)
+{
+	struct ipa_smp2p *smp2p;
+
+	smp2p = container_of(nb, struct ipa_smp2p, panic_notifier);
+
+	ipa_smp2p_notify(smp2p);
+
+	if (smp2p->clock_on)
+		ipa_uc_panic_notifier(smp2p->ipa);
+
+	return NOTIFY_DONE;
+}
+
+static int ipa_smp2p_panic_notifier_register(struct ipa_smp2p *smp2p)
+{
+	/* IPA panic handler needs to run before modem shuts down */
+	smp2p->panic_notifier.notifier_call = ipa_smp2p_panic_notifier;
+	smp2p->panic_notifier.priority = INT_MAX;	/* Do it early */
+
+	return atomic_notifier_chain_register(&panic_notifier_list,
+					      &smp2p->panic_notifier);
+}
+
+static void ipa_smp2p_panic_notifier_unregister(struct ipa_smp2p *smp2p)
+{
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &smp2p->panic_notifier);
+}
+
+/* Threaded IRQ handler for modem "ipa-setup-ready" SMP2P interrupt */
+static irqreturn_t ipa_smp2p_modem_setup_ready_isr(int irq, void *dev_id)
+{
+	struct ipa_smp2p *smp2p = dev_id;
+
+	mutex_lock(&smp2p->mutex);
+
+	if (!smp2p->disabled) {
+		int ret;
+
+		ret = ipa_setup(smp2p->ipa);
+		if (ret)
+			dev_err(&smp2p->ipa->pdev->dev,
+				"error %d from ipa_setup()\n", ret);
+		smp2p->disabled = true;
+	}
+
+	mutex_unlock(&smp2p->mutex);
+
+	return IRQ_HANDLED;
+}
+
+/* Initialize SMP2P interrupts */
+static int ipa_smp2p_irq_init(struct ipa_smp2p *smp2p, const char *name,
+			      irq_handler_t handler)
+{
+	struct device *dev = &smp2p->ipa->pdev->dev;
+	unsigned int irq;
+	int ret;
+
+	ret = platform_get_irq_byname(smp2p->ipa->pdev, name);
+	if (ret <= 0) {
+		dev_err(dev, "DT error %d getting \"%s\" IRQ property\n",
+			ret, name);
+		return ret ? : -EINVAL;
+	}
+	irq = ret;
+
+	ret = request_threaded_irq(irq, NULL, handler, 0, name, smp2p);
+	if (ret) {
+		dev_err(dev, "error %d requesting \"%s\" IRQ\n", ret, name);
+		return ret;
+	}
+
+	return irq;
+}
+
+static void ipa_smp2p_irq_exit(struct ipa_smp2p *smp2p, u32 irq)
+{
+	free_irq(irq, smp2p);
+}
+
+/* Drop the clock reference if it was taken in ipa_smp2p_notify() */
+static void ipa_smp2p_clock_release(struct ipa *ipa)
+{
+	if (!ipa->smp2p->clock_on)
+		return;
+
+	ipa_clock_put(ipa);
+	ipa->smp2p->clock_on = false;
+}
+
+/* Initialize the IPA SMP2P subsystem */
+int ipa_smp2p_init(struct ipa *ipa, bool modem_init)
+{
+	struct qcom_smem_state *enabled_state;
+	struct device *dev = &ipa->pdev->dev;
+	struct qcom_smem_state *valid_state;
+	struct ipa_smp2p *smp2p;
+	u32 enabled_bit;
+	u32 valid_bit;
+	int ret;
+
+	valid_state = qcom_smem_state_get(dev, "ipa-clock-enabled-valid",
+					  &valid_bit);
+	if (IS_ERR(valid_state))
+		return PTR_ERR(valid_state);
+	if (valid_bit >= 32)		/* BITS_PER_U32 */
+		return -EINVAL;
+
+	enabled_state = qcom_smem_state_get(dev, "ipa-clock-enabled",
+					    &enabled_bit);
+	if (IS_ERR(enabled_state))
+		return PTR_ERR(enabled_state);
+	if (enabled_bit >= 32)		/* BITS_PER_U32 */
+		return -EINVAL;
+
+	smp2p = kzalloc(sizeof(*smp2p), GFP_KERNEL);
+	if (!smp2p)
+		return -ENOMEM;
+
+	smp2p->ipa = ipa;
+
+	/* These fields are needed by the clock query interrupt
+	 * handler, so initialize them now.
+	 */
+	mutex_init(&smp2p->mutex);
+	smp2p->valid_state = valid_state;
+	smp2p->valid_bit = valid_bit;
+	smp2p->enabled_state = enabled_state;
+	smp2p->enabled_bit = enabled_bit;
+
+	/* We have enough information saved to handle notifications */
+	ipa->smp2p = smp2p;
+
+	ret = ipa_smp2p_irq_init(smp2p, "ipa-clock-query",
+				 ipa_smp2p_modem_clk_query_isr);
+	if (ret < 0)
+		goto err_null_smp2p;
+	smp2p->clock_query_irq = ret;
+
+	ret = ipa_smp2p_panic_notifier_register(smp2p);
+	if (ret)
+		goto err_irq_exit;
+
+	if (modem_init) {
+		/* Result will be non-zero (negative for error) */
+		ret = ipa_smp2p_irq_init(smp2p, "ipa-setup-ready",
+					 ipa_smp2p_modem_setup_ready_isr);
+		if (ret < 0)
+			goto err_notifier_unregister;
+		smp2p->setup_ready_irq = ret;
+	}
+
+	return 0;
+
+err_notifier_unregister:
+	ipa_smp2p_panic_notifier_unregister(smp2p);
+err_irq_exit:
+	ipa_smp2p_irq_exit(smp2p, smp2p->clock_query_irq);
+err_null_smp2p:
+	ipa->smp2p = NULL;
+	mutex_destroy(&smp2p->mutex);
+	kfree(smp2p);
+
+	return ret;
+}
+
+void ipa_smp2p_exit(struct ipa *ipa)
+{
+	struct ipa_smp2p *smp2p = ipa->smp2p;
+
+	if (smp2p->setup_ready_irq)
+		ipa_smp2p_irq_exit(smp2p, smp2p->setup_ready_irq);
+	ipa_smp2p_panic_notifier_unregister(smp2p);
+	ipa_smp2p_irq_exit(smp2p, smp2p->clock_query_irq);
+	/* We won't get notified any more; drop clock reference (if any) */
+	ipa_smp2p_clock_release(ipa);
+	ipa->smp2p = NULL;
+	mutex_destroy(&smp2p->mutex);
+	kfree(smp2p);
+}
+
+void ipa_smp2p_disable(struct ipa *ipa)
+{
+	struct ipa_smp2p *smp2p = ipa->smp2p;
+
+	if (!smp2p->setup_ready_irq)
+		return;
+
+	mutex_lock(&smp2p->mutex);
+
+	smp2p->disabled = true;
+
+	mutex_unlock(&smp2p->mutex);
+}
+
+/* Reset state tracking whether we have notified the modem */
+void ipa_smp2p_notify_reset(struct ipa *ipa)
+{
+	struct ipa_smp2p *smp2p = ipa->smp2p;
+	u32 mask;
+
+	if (!smp2p->notified)
+		return;
+
+	ipa_smp2p_clock_release(ipa);
+
+	/* Reset the clock enabled valid flag */
+	mask = BIT(smp2p->valid_bit);
+	qcom_smem_state_update_bits(smp2p->valid_state, mask, 0);
+
+	/* Mark the clock disabled for good measure... */
+	mask = BIT(smp2p->enabled_bit);
+	qcom_smem_state_update_bits(smp2p->enabled_state, mask, 0);
+
+	smp2p->notified = false;
+}
diff --git a/drivers/net/ipa/ipa_smp2p.h b/drivers/net/ipa/ipa_smp2p.h
new file mode 100644
index 000000000000..1f65cdc9d406
--- /dev/null
+++ b/drivers/net/ipa/ipa_smp2p.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019-2020 Linaro Ltd.
+ */
+#ifndef _IPA_SMP2P_H_
+#define _IPA_SMP2P_H_
+
+#include <linux/types.h>
+
+struct ipa;
+
+/**
+ * ipa_smp2p_init() - Initialize the IPA SMP2P subsystem
+ * @ipa:	IPA pointer
+ * @modem_init:	Whether the modem is responsible for GSI initialization
+ *
+ * @Return:	0 if successful, or a negative error code
+ *
+ */
+int ipa_smp2p_init(struct ipa *ipa, bool modem_init);
+
+/**
+ * ipa_smp2p_exit() - Inverse of ipa_smp2p_init()
+ * @ipa:	IPA pointer
+ */
+void ipa_smp2p_exit(struct ipa *ipa);
+
+/**
+ * ipa_smp2p_disable() - Prevent "ipa-setup-ready" interrupt handling
+ * @IPA:	IPA pointer
+ *
+ * Prevent handling of the "setup ready" interrupt from the modem.
+ * This is used before initiating shutdown of the driver.
+ */
+void ipa_smp2p_disable(struct ipa *ipa);
+
+/**
+ * ipa_smp2p_notify_reset() - Reset modem notification state
+ * @ipa:	IPA pointer
+ *
+ * If the modem crashes it queries the IPA clock state.  In cleaning
+ * up after such a crash this is used to reset some state maintained
+ * for managing this notification.
+ */
+void ipa_smp2p_notify_reset(struct ipa *ipa);
+
+#endif /* _IPA_SMP2P_H_ */
-- 
2.20.1

