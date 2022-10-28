Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9658E6106E7
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 02:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbiJ1Ahd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 20:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234235AbiJ1Ahb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 20:37:31 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192ABA287A;
        Thu, 27 Oct 2022 17:37:31 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so8369775pji.1;
        Thu, 27 Oct 2022 17:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ghCqk+Du9L6funnJsNVXREamebkJ3xs1SyQxjyBeGn0=;
        b=JCp01FMmUaMZfe4VXq8TGradDanACYmTCc+OqnPNZUCol4WHmP8aX3+WZB1NkNr3XA
         6VcqUsK2tyS2T88hdD97K0nr0GLDqMq97IMvGB/ZBA/aqUxjorJBfiUjG7lZY8lWYaZL
         K1BXESNxNdmXBIuCcFdVMrvsgv5lhUBpq8zkTf1lIPYDFyKqIL8Vg1YhBHbmWSMe2Vs6
         yE22mhP5JPM9UZ2xOq60lVtacrZ1JJ5HY8FaTbULmAw2Xo2vhqFwa7GrrAXHAbYGGRrT
         s7JQGSeQG+8N1ZhsZrRWV1tW3wfZwH9ZUm8KbBXCSz4T/rVip7yfhGE0WB44WPB+VCGg
         Wr3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ghCqk+Du9L6funnJsNVXREamebkJ3xs1SyQxjyBeGn0=;
        b=agFmzIhKyLsiOPK3DvmiSXg/yX1X79BCe2HjKLHYynIKB/2XKRxrETTYv4bnBBpIdf
         4ICFoWZmp1e310DZ+wgoYpwhvE77148CxPhwC89toTXbcmGzJAZNyLO5BkLLpRatQhlS
         PY4GKLcDdPiOakTRRRMn2r9yDwocZt7jxh4fdVw9tOauNBOrBpsq6Nbu7DaII5RJZKKz
         qlq3W1FS/se2tL+bi1saulAweZqjfFTljh+0RhiFDPdB4AAGtW8SWta4lb77bBBVnjwI
         aE1jAkKngwfGbIoR9ulxV/8AX9wK0hZqdPbBVcXnLopa3vrAilonpEWyAhrF/Z8G6AvS
         pleQ==
X-Gm-Message-State: ACrzQf3liBWjGbRJwEeonyboKXqTIIbXZ8nHAtJUKu4jaybj/KEEZoSf
        pNb6AXK2Lr/c9IJQUOKYoJwLipKULe+TpQ==
X-Google-Smtp-Source: AMsMyM497LQuq3xY+/2/sfJ80fX2tU4Jn9WmTZor5hp9dYn/is50XtE6TA6ys0nkHJ8I1J8sJ1O0cA==
X-Received: by 2002:a17:902:d0d3:b0:186:9869:adb5 with SMTP id n19-20020a170902d0d300b001869869adb5mr28051051pln.105.1666917439845;
        Thu, 27 Oct 2022 17:37:19 -0700 (PDT)
Received: from localhost.localdomain ([2601:601:9100:9230:37fc:258f:1646:1aea])
        by smtp.googlemail.com with ESMTPSA id q6-20020a17090a178600b00210c84b8ae5sm1491562pja.35.2022.10.27.17.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 17:37:19 -0700 (PDT)
From:   Shane Parslow <shaneparslow808@gmail.com>
To:     m.chetan.kumar@intel.com, linuxwwan@intel.com
Cc:     shaneparslow808@gmail.com, Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: wwan: iosm: add rpc interface for xmm modems
Date:   Thu, 27 Oct 2022 17:31:29 -0700
Message-Id: <20221028003128.514318-1-shaneparslow808@gmail.com>
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
index 128c999e08bb..91e3e83fc47b 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
@@ -39,7 +39,7 @@ static struct ipc_chnl_cfg modem_cfg[] = {
 	/* RPC - 0 */
 	{ IPC_MEM_CTRL_CHL_ID_1, IPC_MEM_PIPE_2, IPC_MEM_PIPE_3,
 	  IPC_MEM_MAX_TDS_RPC, IPC_MEM_MAX_TDS_RPC,
-	  IPC_MEM_MAX_DL_RPC_BUF_SIZE, WWAN_PORT_UNKNOWN },
+	  IPC_MEM_MAX_DL_RPC_BUF_SIZE, WWAN_PORT_RPC },
 	/* IAT0 */
 	{ IPC_MEM_CTRL_CHL_ID_2, IPC_MEM_PIPE_4, IPC_MEM_PIPE_5,
 	  IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_DL_AT_BUF_SIZE,
diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 62e9f7d6c9fe..cf16a2704914 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -319,6 +319,10 @@ static const struct {
 		.name = "FIREHOSE",
 		.devsuf = "firehose",
 	},
+	[WWAN_PORT_RPC] = {
+		.name = "RPC",
+		.devsuf = "rpc",
+	},
 };
 
 static ssize_t type_show(struct device *dev, struct device_attribute *attr,
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index 5ce2acf444fb..3cf2182ad4e9 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -15,6 +15,7 @@
  * @WWAN_PORT_QMI: Qcom modem/MSM interface for modem control
  * @WWAN_PORT_QCDM: Qcom Modem diagnostic interface
  * @WWAN_PORT_FIREHOSE: XML based command protocol
+ * @WWAN_PORT_RPC: Control protocol for Intel XMM modems
  *
  * @WWAN_PORT_MAX: Highest supported port types
  * @WWAN_PORT_UNKNOWN: Special value to indicate an unknown port type
@@ -26,6 +27,7 @@ enum wwan_port_type {
 	WWAN_PORT_QMI,
 	WWAN_PORT_QCDM,
 	WWAN_PORT_FIREHOSE,
+	WWAN_PORT_RPC,
 
 	/* Add new port types above this line */
 
-- 
2.38.1

