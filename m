Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEEF46064D
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 14:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357650AbhK1NDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 08:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237099AbhK1NBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 08:01:11 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596D0C06174A
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:55:35 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id t11so28968903ljh.6
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MGJnwlQPpiNh66b9SCMbW7HB4dAqYbf0gLkVpa0vFto=;
        b=JMSzX6o+VRm356r2Bi3IMM0w/ZYfpYpTVDyFEB6JgG8Yp/qqbOB2OvOKEmbBVpAG4K
         8vHunV3XW36t/ZkvWcFpW6F8Wo9r/1kryIDNlUc7EDRb/Np3CIns/LXDsdJ9r63arMB7
         PlMnBprD8guItWFoxkzw0o3doaLMTDOV5w1zXeLGZB0b1784q8ZJ0NSJxtnQv1CE51yW
         3KCuD/+vnYmOyY4kazOec4Nps57zWW0K6em7r53FhAA7KSyOPBDcIL0BmaBSxfpyjSBl
         +dxXtqz0rVxZYJkv5WkBhesgF80IEu9mkweF7LPAKa5PaHyPV424x3Te8SuqW4uIWpDZ
         Pi4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MGJnwlQPpiNh66b9SCMbW7HB4dAqYbf0gLkVpa0vFto=;
        b=14ngfcZ6dTnX3wakH0Nfa0/qmHhGysY1lK7JCuVmaloFP5dpPNZjKAc+mOiPfZUmC4
         Fg7sAr1jH8Kq7uRdCfR+1Jra6j2i9L6GbBcPGeahTw2LyHfoQ5ZnVnLbi9tsFcwBP2QW
         5hBMlMI7VVQdSlm5Fd6QHxVexCgBaWIHSS2vQEUdw50CYPqqFe5HE7rNX+8cGTUVLdA6
         ZxWDlpiF61O9Bjq1ro8CjG3gdtZ7P9Sjg4MhbqUQdPBDT2doZfxpG62ZMaBWas8F09sh
         wx2gLdTttWgdSKkwy6y6EoCa3vw6BhI72Qd2YwnhWc9rUIO+GDqezA/LGWFutYfGx47u
         Zavw==
X-Gm-Message-State: AOAM531O1NI7We/Q1t8aw7pqHcOm8xSija371NYwr4lQo4vA4kK9z34m
        XEWsGW+vgA0kZahBzTI164y1r0AQkvs=
X-Google-Smtp-Source: ABdhPJzKcdo+ch7UGtXKUn0nEHjxq6NYWtzrj8JEcVBL6uxqzwPmHewJei5pX0uow6E9sNundTbHcw==
X-Received: by 2002:a05:651c:1548:: with SMTP id y8mr44044693ljp.458.1638104133705;
        Sun, 28 Nov 2021 04:55:33 -0800 (PST)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id c1sm1066595ljr.111.2021.11.28.04.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 04:55:33 -0800 (PST)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH RESEND net-next 2/5] net: wwan: iosm: allow trace port be uninitialized
Date:   Sun, 28 Nov 2021 15:55:19 +0300
Message-Id: <20211128125522.23357-3-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211128125522.23357-1-ryazanov.s.a@gmail.com>
References: <20211128125522.23357-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Collecting modem firmware traces is optional for the regular modem use.
There are not many reasons for aborting device initialization due to an
inability to initialize the trace port and (or) its debugfs interface.
So, demote the initialization failure erro message into a warning and do
not break the initialization sequence in this case. Rework packet
processing and deinitialization so that they do not crash in case of
uninitialized trace port.

This change is mainly a preparation for an upcoming configuration option
introduction that will help disable driver debugfs functionality.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/iosm/iosm_ipc_imem.c  | 8 +++-----
 drivers/net/wwan/iosm/iosm_ipc_trace.c | 3 +++
 drivers/net/wwan/iosm/iosm_ipc_trace.h | 5 +++++
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index 49bdadb855e5..a60b93cefd2e 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -272,7 +272,7 @@ static void ipc_imem_dl_skb_process(struct iosm_imem *ipc_imem,
 		if (port_id == IPC_MEM_CTRL_CHL_ID_7)
 			ipc_imem_sys_devlink_notify_rx(ipc_imem->ipc_devlink,
 						       skb);
-		else if (port_id == ipc_imem->trace->chl_id)
+		else if (ipc_is_trace_channel(ipc_imem, port_id))
 			ipc_trace_port_rx(ipc_imem->trace, skb);
 		else
 			wwan_port_rx(ipc_imem->ipc_port[port_id]->iosm_port,
@@ -555,10 +555,8 @@ static void ipc_imem_run_state_worker(struct work_struct *instance)
 	}
 
 	ipc_imem->trace = ipc_trace_init(ipc_imem);
-	if (!ipc_imem->trace) {
-		dev_err(ipc_imem->dev, "trace channel init failed");
-		return;
-	}
+	if (!ipc_imem->trace)
+		dev_warn(ipc_imem->dev, "trace channel init failed");
 
 	ipc_task_queue_send_task(ipc_imem, ipc_imem_send_mdm_rdy_cb, 0, NULL, 0,
 				 false);
diff --git a/drivers/net/wwan/iosm/iosm_ipc_trace.c b/drivers/net/wwan/iosm/iosm_ipc_trace.c
index 5f5cfd39bede..c588a394cd94 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_trace.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_trace.c
@@ -172,6 +172,9 @@ struct iosm_trace *ipc_trace_init(struct iosm_imem *ipc_imem)
  */
 void ipc_trace_deinit(struct iosm_trace *ipc_trace)
 {
+	if (!ipc_trace)
+		return;
+
 	debugfs_remove(ipc_trace->ctrl_file);
 	relay_close(ipc_trace->ipc_rchan);
 	mutex_destroy(&ipc_trace->trc_mutex);
diff --git a/drivers/net/wwan/iosm/iosm_ipc_trace.h b/drivers/net/wwan/iosm/iosm_ipc_trace.h
index 53346183af9c..419540c91219 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_trace.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_trace.h
@@ -45,6 +45,11 @@ struct iosm_trace {
 	enum trace_ctrl_mode mode;
 };
 
+static inline bool ipc_is_trace_channel(struct iosm_imem *ipc_mem, u16 chl_id)
+{
+	return ipc_mem->trace && ipc_mem->trace->chl_id == chl_id;
+}
+
 struct iosm_trace *ipc_trace_init(struct iosm_imem *ipc_imem);
 void ipc_trace_deinit(struct iosm_trace *ipc_trace);
 void ipc_trace_port_rx(struct iosm_trace *ipc_trace, struct sk_buff *skb);
-- 
2.32.0

