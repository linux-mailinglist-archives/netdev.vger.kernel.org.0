Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F52D2A6B33
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731704AbgKDQ5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731642AbgKDQ5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:57:39 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99990C0613D3;
        Wed,  4 Nov 2020 08:57:38 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id oq3so28900174ejb.7;
        Wed, 04 Nov 2020 08:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ashmw3okAVzdC5tUe8F0vnmIPc+292ruMMEHi+QowxM=;
        b=WUzYvl8IZ1OXW/Qxz/4WcrqkHSwqC3IYW4Bwr+9Tvor/vXUV+usRkiitDoESYHWZjH
         KUi945WO2cyZeTsu++CB3XbccncvfWJYUahyAOaJOxszGKHrkyc+nPGVrvIY4DOae3zH
         pni8KU2zOan4BlsyK00o0Yt/JXXbkue4dRqsuI5veIPVpBEX5OQcEU5fecxobbr8Df2J
         mTiXLqapooS4pARTHw+pJVRj9vvPiRNcknFCGHtdf3QZkFCsgPP2QjHjUxkkQralPWbi
         wisc27XHwp185yQyaXecKcDrTQzb6lZjcBh5ByphQS2s9cfXWScL7JawZgz6cBaVFSu/
         Irug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ashmw3okAVzdC5tUe8F0vnmIPc+292ruMMEHi+QowxM=;
        b=hPo+iBZVW7TQhZpQ+qKuBZiyFWF2FDPtTuOz3syTij8a9FnZ5IOHCxUHpgfJVdf/Od
         q0HGNInzoNODb0v+aCwfdnoEi8BgaL3hOjVAl1mujgUUhvc88c3206dLWjC7qh+JnR+h
         V4/CAMNtSpvQH1RCjAna0lGUh1yVpdCcvIcuVjzFiWbynKbzjH3z44OeKFIAcr0+7rlh
         KF52Y/LAtf2OSpIRwN5UxLj9t72mCI7uzEFQvRuCYzMeBYyFUoqonWnrA0mz1+XNDtBG
         jMQn/JO1WG7UAYKwPHgfc8DgLypyqZ9fS05XJG9efwXN+SX1INLXn1XJA3IGAG1I6zq1
         TAUQ==
X-Gm-Message-State: AOAM533K2mRxZoIsbAIsz5f4ZURitwJPJiJB8qCboWY/XAtnPZ4KzYYH
        oPemJ6A6Fpk1K6TmuJR1dh0=
X-Google-Smtp-Source: ABdhPJzbaFn1uNL0Y8I3ylQh+ONvVwffVznEDHU5YXuT85PTwkvNZM+mioikV/QaaeLJhDrkKLq4tQ==
X-Received: by 2002:a17:906:d8b0:: with SMTP id qc16mr25310162ejb.268.1604509057322;
        Wed, 04 Nov 2020 08:57:37 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id l12sm1354748edt.46.2020.11.04.08.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 08:57:36 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RFC 7/9] staging: dpaa2-switch: enable the control interface
Date:   Wed,  4 Nov 2020 18:57:18 +0200
Message-Id: <20201104165720.2566399-8-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104165720.2566399-1-ciorneiioana@gmail.com>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Enable the CTRL_IF of the switch object, now that all the pieces are in
place (buffer and queue management, interrupts, NAPI instances etc).

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h |  2 ++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.c     | 37 ++++++++++++++++++++++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.h     |  5 +++
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c    |  9 ++++++
 4 files changed, 53 insertions(+)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
index e239747f8a54..c6eb9bffdd3e 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
@@ -79,6 +79,8 @@
 
 #define DPSW_CMDID_CTRL_IF_GET_ATTR         DPSW_CMD_ID(0x0A0)
 #define DPSW_CMDID_CTRL_IF_SET_POOLS        DPSW_CMD_ID(0x0A1)
+#define DPSW_CMDID_CTRL_IF_ENABLE           DPSW_CMD_ID(0x0A2)
+#define DPSW_CMDID_CTRL_IF_DISABLE          DPSW_CMD_ID(0x0A3)
 #define DPSW_CMDID_CTRL_IF_SET_QUEUE        DPSW_CMD_ID(0x0A6)
 
 /* Macros for accessing command fields smaller than 1byte */
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
index 2a1967754913..f5cfe61498b8 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
@@ -1456,3 +1456,40 @@ int dpsw_if_set_primary_mac_addr(struct fsl_mc_io *mc_io, u32 cmd_flags,
 	/* send command to mc*/
 	return mc_send_command(mc_io, &cmd);
 }
+
+/**
+ * dpsw_ctrl_if_enable() - Enable control interface
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpsw_ctrl_if_enable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token)
+{
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_CTRL_IF_ENABLE, cmd_flags,
+					  token);
+
+	return mc_send_command(mc_io, &cmd);
+}
+
+/**
+ * dpsw_ctrl_if_disable() - Function disables control interface
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpsw_ctrl_if_disable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token)
+{
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_CTRL_IF_DISABLE,
+					  cmd_flags,
+					  token);
+
+	return mc_send_command(mc_io, &cmd);
+}
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
index a6ed6860946c..9e30adad4ffa 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
@@ -245,6 +245,11 @@ struct dpsw_ctrl_if_queue_cfg {
 int dpsw_ctrl_if_set_queue(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 			   enum dpsw_queue_type qtype,
 			   const struct dpsw_ctrl_if_queue_cfg *cfg);
+
+int dpsw_ctrl_if_enable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token);
+
+int dpsw_ctrl_if_disable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token);
+
 /**
  * enum dpsw_action - Action selection for special/control frames
  * @DPSW_ACTION_DROP: Drop frame
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 7805f0e58ec2..24bdac6d6005 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -2220,8 +2220,16 @@ static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
 	if (err)
 		goto err_destroy_rings;
 
+	err = dpsw_ctrl_if_enable(ethsw->mc_io, 0, ethsw->dpsw_handle);
+	if (err) {
+		dev_err(ethsw->dev, "dpsw_ctrl_if_enable err %d\n", err);
+		goto err_deregister_dpio;
+	}
+
 	return 0;
 
+err_deregister_dpio:
+	dpaa2_switch_free_dpio(ethsw);
 err_destroy_rings:
 	dpaa2_switch_destroy_rings(ethsw);
 err_drain_dpbp:
@@ -2421,6 +2429,7 @@ static void dpaa2_switch_takedown(struct fsl_mc_device *sw_dev)
 
 static void dpaa2_switch_ctrl_if_teardown(struct ethsw_core *ethsw)
 {
+	dpsw_ctrl_if_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
 	dpaa2_switch_free_dpio(ethsw);
 	dpaa2_switch_destroy_rings(ethsw);
 	dpaa2_switch_drain_bp(ethsw);
-- 
2.28.0

