Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654844ABFEF
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387998AbiBGNqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381046AbiBGNdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 08:33:33 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF9FC043189;
        Mon,  7 Feb 2022 05:33:32 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id v129so6337305wme.2;
        Mon, 07 Feb 2022 05:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V9QEgmdSl8jrpLmboxH3MycHRrNVtMiq+z3Om5YP+L4=;
        b=ZeXCogp2RMZJX5bCWf5GbVepmcsMjxXm6LLMgfx0ol8BSDdh8zAsv+NO9/LnCpM0jB
         bVrc/woX1x72Ie3U1zOWBW+QSDGWgRoIhxbPYK3X2ZzjKJDMjnPpbYMJVM6Boqr2sPeL
         /6sCSMQUF7rByaBI1nwjEu/MhYDhu1qvv+5TCmAdzNs7BgTo2djdrGjEPKsqW7EJefsD
         P3neh3NRyJGCLgoNX1YxdsjWaL698+tF51+kY7JtQSg/bF3ycqX9PoPavxEQn+06JR4T
         r2XMKw7uXjNmpoJYCU770I/sBp4rR71G5lrGSFrHU/NEg1K3bRMhiRMuuK+eyQHFr6Fw
         u8yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V9QEgmdSl8jrpLmboxH3MycHRrNVtMiq+z3Om5YP+L4=;
        b=hJAE/FGJ5sfq/a269J/NFlK9/RZWFhoSeD1eWoHdDgKmPyT0Net15V3f5swN2xv58G
         ccUHSCExOlLT9h+7HOJjrXp0gIedPUjgIwzbveqSx5thHPVrvXnBgiQjKwIZ/FqB5ZFY
         QhEpGnZPhpCsZwZNn0KrNF4KHPhvMDKeeZwfdDEk5PLjKio5gyeuQb7Am0KsezISk6a9
         Ktg7BLS3l1i1FutbamshnrFKEZYnUGcLmi8RUlf5PX4hgP7wXy6RE7klayg6hUhkokRO
         RJIs2Gr8adbAE/o4edtBVjHISu/t37QjJ5DnYUZxmfvFufe/8+aFbvSc+yRhQa5AOkbH
         GXBg==
X-Gm-Message-State: AOAM533fI1CIBL30lwDqLqgWMGmoZcEUqhsIkv/Y/HnjxFyPa49chFVZ
        UprX5CeTAJMQUC3cj6gAA1s=
X-Google-Smtp-Source: ABdhPJylUXyrmFmYPgL7jbK0a9g9xkwVwdjDV+JW8NPwgewUuCwNlNWvwo/VRNkr3mzIoT3RoF/Q2Q==
X-Received: by 2002:a7b:c84f:: with SMTP id c15mr14361555wml.181.1644240811059;
        Mon, 07 Feb 2022 05:33:31 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id bg23sm11366849wmb.5.2022.02.07.05.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 05:33:30 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] brcmfmac: of: remove redundant variable len
Date:   Mon,  7 Feb 2022 13:33:29 +0000
Message-Id: <20220207133329.336664-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

The variable len is being assigned bit is never used. The variable
and the strlen call are redundant and can be removed.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index 5708de1d9f26..8623bde5eb70 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -71,14 +71,13 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 	/* Set board-type to the first string of the machine compatible prop */
 	root = of_find_node_by_path("/");
 	if (root) {
-		int i, len;
+		int i;
 		char *board_type;
 		const char *tmp;
 
 		of_property_read_string_index(root, "compatible", 0, &tmp);
 
 		/* get rid of '/' in the compatible string to be able to find the FW */
-		len = strlen(tmp) + 1;
 		board_type = devm_kstrdup(dev, tmp, GFP_KERNEL);
 		if (!board_type) {
 			of_node_put(root);
-- 
2.34.1

