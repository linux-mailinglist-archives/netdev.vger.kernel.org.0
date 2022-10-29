Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9476121AD
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 11:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiJ2JEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 05:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiJ2JEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 05:04:40 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADD65FE5;
        Sat, 29 Oct 2022 02:04:37 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id f9so6776652pgj.2;
        Sat, 29 Oct 2022 02:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YRn1A+WL1jPxIpvEG2LgNiWp5qXbKdGgQitgU+8dRwE=;
        b=h1+/xZhoXaOn0ibpZS2AaI34ufCN+lhYvvnAs8bhvyg3XayXlkprkE6V/1QirCETfV
         0rvie4kgCL1SEYAYiQnB+Ciy5ZntspLx7eS6iPJ1T/MHRQOYl2V0JBqE1XQCVWFnsrXp
         tPfmrqR51gTw7VYG9ACaDPZ0TImmal4SoRY7VOcVRXgVnQy8Oa5Xb2bRd/TgzPk1SbWh
         jxgb+tJF+kI8w7Cs7LVbkomemH9v3vr+vKxgu8Xr6ETgHwAzQq3bv0/x0WLCw9mNdfKO
         8Fnelh5/HDMpWDv80TGYJgNBg5cGiq298ZLcGKX5beXOnAUiqyDpESjJubOzwg3qc8iT
         LLGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YRn1A+WL1jPxIpvEG2LgNiWp5qXbKdGgQitgU+8dRwE=;
        b=2DBZuUvva+HeTUSNkbY8/Mi8Ylt9m+kTHm0c1Vv5BQEWGivgGwGlSLewVK57NNKPuA
         7CKVNu4u7aPG4RqEzGKky3BWLNwKylyQQT3gM3B2STEFOaKmXbjSYDDWWC4EFF48Xcls
         izuqsSLHympTxRa7bkYFNKJNkCsKzR5iZWkwC5DHS0rbldWSfrYhxPIkiC9FlQfLDwEt
         tyMY4QJS1LtZr6lazLKvw619zLbyEZ7hwyeLfuYJ8KZ4TeNT0L+WjLSPtpdDHgrmUk17
         UtMnmx3s7k8pQ7hxQQoHPV3VDx4vAOsyi3PpcnYyg8L0kYRh1iaJMbsqxfT19aKdX9uT
         EPPQ==
X-Gm-Message-State: ACrzQf2QSIu+KZUVsRjSwsD7BUC1yQkTk7jziiwRV0mneHADlwVviPPB
        eVRKo17RqsZOOewSZY8iyuY=
X-Google-Smtp-Source: AMsMyM5lpFX7w4z7uTVjN9rzpM3U9yyj65T1fQtXlWcMfItOZIBNA0dq5cZGD9sP16mrztvpGrzQEg==
X-Received: by 2002:a05:6a00:78f:b0:56c:8c22:79d6 with SMTP id g15-20020a056a00078f00b0056c8c2279d6mr3569847pfu.16.1667034276648;
        Sat, 29 Oct 2022 02:04:36 -0700 (PDT)
Received: from localhost.localdomain ([2601:601:9100:9230:37fc:258f:1646:1aea])
        by smtp.googlemail.com with ESMTPSA id t4-20020a17090ad50400b002130c269b6fsm683535pju.1.2022.10.29.02.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 02:04:35 -0700 (PDT)
From:   Shane Parslow <shaneparslow808@gmail.com>
To:     loic.poulain@linaro.org
Cc:     Shane Parslow <shaneparslow808@gmail.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] net: wwan: iosm: add rpc interface for xmm modems
Date:   Sat, 29 Oct 2022 02:03:56 -0700
Message-Id: <20221029090355.565200-1-shaneparslow808@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new iosm wwan port that connects to the modem rpc interface. This
interface provides a configuration channel, and in the case of the 7360, is
the only way to configure the modem (as it does not support mbim).

The new interface is compatible with existing software, such as
open_xdatachannel.py from the xmm7360-pci project [1].

[1] https://github.com/xmm7360/xmm7360-pci

Signed-off-by: Shane Parslow <shaneparslow808@gmail.com>
---
 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c | 2 +-
 drivers/net/wwan/wwan_core.c              | 4 ++++
 include/linux/wwan.h                      | 2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
index 128c999e08bb..bcfbc6b3d617 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
@@ -39,7 +39,7 @@ static struct ipc_chnl_cfg modem_cfg[] = {
 	/* RPC - 0 */
 	{ IPC_MEM_CTRL_CHL_ID_1, IPC_MEM_PIPE_2, IPC_MEM_PIPE_3,
 	  IPC_MEM_MAX_TDS_RPC, IPC_MEM_MAX_TDS_RPC,
-	  IPC_MEM_MAX_DL_RPC_BUF_SIZE, WWAN_PORT_UNKNOWN },
+	  IPC_MEM_MAX_DL_RPC_BUF_SIZE, WWAN_PORT_XMMRPC },
 	/* IAT0 */
 	{ IPC_MEM_CTRL_CHL_ID_2, IPC_MEM_PIPE_4, IPC_MEM_PIPE_5,
 	  IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_DL_AT_BUF_SIZE,
diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 62e9f7d6c9fe..4988d91d00bb 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -319,6 +319,10 @@ static const struct {
 		.name = "FIREHOSE",
 		.devsuf = "firehose",
 	},
+	[WWAN_PORT_XMMRPC] = {
+		.name = "XMMRPC",
+		.devsuf = "xmmrpc",
+	},
 };
 
 static ssize_t type_show(struct device *dev, struct device_attribute *attr,
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index 5ce2acf444fb..24d76500b1cc 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -15,6 +15,7 @@
  * @WWAN_PORT_QMI: Qcom modem/MSM interface for modem control
  * @WWAN_PORT_QCDM: Qcom Modem diagnostic interface
  * @WWAN_PORT_FIREHOSE: XML based command protocol
+ * @WWAN_PORT_XMMRPC: Control protocol for Intel XMM modems
  *
  * @WWAN_PORT_MAX: Highest supported port types
  * @WWAN_PORT_UNKNOWN: Special value to indicate an unknown port type
@@ -26,6 +27,7 @@ enum wwan_port_type {
 	WWAN_PORT_QMI,
 	WWAN_PORT_QCDM,
 	WWAN_PORT_FIREHOSE,
+	WWAN_PORT_XMMRPC,
 
 	/* Add new port types above this line */
 
-- 
2.38.1

