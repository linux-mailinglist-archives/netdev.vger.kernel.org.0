Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A77D1E173F
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 23:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731440AbgEYVlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 17:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgEYVlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 17:41:44 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C80C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 14:41:44 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id bh7so937186plb.11
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 14:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CY/j0wx/+MC4peatLGaJ7pEd7N3ZupWkWQU5WcAZUiA=;
        b=VK9BoWQJI/QAMXChqHiV0D3l9CuGEy37IFeRnycEGRw5L2es2XbXCdbsnoDXKgz3Nt
         eFce0cF2SnAEwC+RVvPa2rVPTCK4jpM3p6hQquUb7onKhCecfXlCoh32BT/LpfEql8Bj
         Oie2AG9YT93WCFv+eukZvdMGHCZBcLOoWONhk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CY/j0wx/+MC4peatLGaJ7pEd7N3ZupWkWQU5WcAZUiA=;
        b=Sq39m8nipObcik5+TfuBjIaIvDXBKTrcL08WeABUoswZiZaxbIqnGdV9vh1e12p/Rw
         sMGkt4o4eRsDc4PjY/jwREhqmrYA/ShaPzWzLfNRWgLiV5FY+PCTe5xkdWc6QouoXq0s
         d2U5uF0DndcB9CRtVK5HOM9VgoScoNUBws4L6b3bKgPO5bhiEPovyaj2a5+N/gHrl1Z+
         XKxocSTJ1ypTgkz2oJ3lVJp+6ucdGQPAq9ljZjq5CsrUAn5F9Y+AaTAXRDIUVTCWIYpA
         wbhC1L3z2Oi7oFdkH/mE9A5dDsIbn+ZnrAhJm+dsjR0vH9Hjdh458ZgfK8WRDDiwGRC7
         Fn3w==
X-Gm-Message-State: AOAM5309PyJmFbDdKEJUKaECYFL+6YYnS974jtBghq4QnIY2GQFdvZGg
        0Sb9hPf3+Hl6ianxF99q1jVryeFMIi0=
X-Google-Smtp-Source: ABdhPJytGWZGTX5EdJafgKXv0Bt07vRiVBND8Ngv2jwjYwUDraQdJBFLMOgS8I0+Sj0D7y5T1xdarQ==
X-Received: by 2002:a17:902:868d:: with SMTP id g13mr29106338plo.246.1590442904202;
        Mon, 25 May 2020 14:41:44 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g1sm13309401pfo.142.2020.05.25.14.41.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 May 2020 14:41:43 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 2/3] bnxt_en: Fix return code to "flash_device".
Date:   Mon, 25 May 2020 17:41:18 -0400
Message-Id: <1590442879-18961-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590442879-18961-1-git-send-email-michael.chan@broadcom.com>
References: <1590442879-18961-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

When NVRAM directory is not found, return the error code
properly as per firmware command failure instead of the hardcode
-ENOBUFS.

Fixes: 3a707bed13b7 ("bnxt_en: Return -EAGAIN if fw command returns BUSY")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 34046a6..360f9a9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2012,11 +2012,12 @@ int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
 
 	bnxt_hwrm_fw_set_time(bp);
 
-	if (bnxt_find_nvram_item(dev, BNX_DIR_TYPE_UPDATE,
-				 BNX_DIR_ORDINAL_FIRST, BNX_DIR_EXT_NONE,
-				 &index, &item_len, NULL) != 0) {
+	rc = bnxt_find_nvram_item(dev, BNX_DIR_TYPE_UPDATE,
+				  BNX_DIR_ORDINAL_FIRST, BNX_DIR_EXT_NONE,
+				  &index, &item_len, NULL);
+	if (rc) {
 		netdev_err(dev, "PKG update area not created in nvram\n");
-		return -ENOBUFS;
+		return rc;
 	}
 
 	rc = request_firmware(&fw, filename, &dev->dev);
-- 
2.5.1

