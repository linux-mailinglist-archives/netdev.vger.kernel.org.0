Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6534A2878B8
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730774AbgJHPzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731738AbgJHPze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:34 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74839C0613D4;
        Thu,  8 Oct 2020 08:55:34 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a200so4327147pfa.10;
        Thu, 08 Oct 2020 08:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Gm0EkTGTsyJArgWHylori1G+cwITsA//QEoUuazW48k=;
        b=qryhqfZHWmNk6RmdcJZqyG8aLGm3XBVUt+stDUxnPYnXM19PT0Z67X5ST7RQnPg1AD
         hQ08ugL7VG6kEIl1LolLxHFOlVwN6EiSaa3uVZULMqMut3f20HctfUWE9UqoPL5FjRgs
         MfcirWqSbB/LHool8yy6KDVabIPsFB1LuefYilcOjD8buTbubxKX2mBhfOSY4SgnI0GE
         g+veAbAZ67HHZWZEtAgme1qhD4pZXIgJnOUM/7kcXoceUKyXMokTH83/w/F4oXHHFgOb
         OLWt0JJk4uceWaB6ECXEbxlVaHR2a+WIwxVzqpPLvRLD3twkSMjs9NsyjKooniiTr8kW
         Gklg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Gm0EkTGTsyJArgWHylori1G+cwITsA//QEoUuazW48k=;
        b=odey4NfuQrjlezTo2ffzvcjK8sWj3dMuyyHGC/+FBtSNbkvq2QdnRW/r7j1m1IGFgm
         VRVW4LucPIFro6VLP1xsqluG8aBXtM0DZiRzyLm6QgsWUZGewg/1Dxcz410BzCuW7AK8
         ATfeWQCsQumE/23OYPtLiCdpv94MPTTM4qn3/6Al2H2wI6+JeFLRDHEvfwivo7iv5aaA
         fhV4s22Z9azrekyN2UV+gzD6HWjX4UPiSVCeCZSn9R0zZBqz2ujXlHMQs1RohpUM520K
         sR2J+hwbk/oLX//1HXf8/KLhRNwhbXrqNQ4sM5qBtlj4XvBs6wlBW0SNKsYjSSQR8m4S
         6DEA==
X-Gm-Message-State: AOAM532Jh7EztRLTtfjRN0aL9QZugUvJ4Cr3WtPQZMBfYwOkoOPpWWD7
        cK+vK72AYKSHPDs4T9rL05I=
X-Google-Smtp-Source: ABdhPJxn6on3Jkv5lysvn4Dv6XhEOsU5sgzuOvOw1r4qxwqVfsY1CpaT5ryFUBh0GXjJ/DSr6zorOA==
X-Received: by 2002:a63:68e:: with SMTP id 136mr7846351pgg.211.1602172533813;
        Thu, 08 Oct 2020 08:55:33 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:33 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 062/117] iwlagn: set DEBUGFS_READ_WRITE_FILE_OPS.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:14 +0000
Message-Id: <20201008155209.18025-62-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 87e5666c0722 ("iwlagn: transport handler can register debugfs entries")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 7c13184fc8e7..f228e362b71f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2522,6 +2522,7 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.read = iwl_dbgfs_##name##_read,				\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 struct iwl_dbgfs_tx_queue_priv {
-- 
2.17.1

