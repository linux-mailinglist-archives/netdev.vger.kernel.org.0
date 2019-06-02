Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C23324E5
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfFBVMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:12:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41272 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbfFBVMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:12:36 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so9971481wrm.8
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 14:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iW92S/TfpsdxTxWJKbo7zdWmVh0zKjrbJoCAgZoHifk=;
        b=uDc3V6F1IfVUBma0pN+Ob+r+CE+T+188pZ9M5vG99hZzGmHCdKNvtPvvTm6KD5SdW3
         i+lZSXn1+cySU2dEYNVbF8lKCLPAB/wNai6uMhcI5gva5B3FDqrMtO/xMnQ7jBq6byE0
         qJSU42rSFuD2VupxPI8RdUfro3KegoKEQeeZoKYINIAXCd5oOWobOxr5K+CtYtkW+C5Z
         dbelTT8AmJ0ZEUtbloibd+tY2ojkCK8oPkhaAhgiRw7sT6y2i/8aG4pD0dt7sSPJeyGZ
         Me65wk7xFCxsNOEFL5P37U847Z1V5f43jixAECpjua3YCILYB4JS5Biws/Ux2fkpsLRa
         f+4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iW92S/TfpsdxTxWJKbo7zdWmVh0zKjrbJoCAgZoHifk=;
        b=mrno+KlWioOUuj+Nnbq749FQW1+b9IkY/wfOI3GfyWRuFQ29vE9Sebbp186dSv3hMW
         RXVDLhIEMRW7MatyVdP87RiOWRW3O9Ejn13Qd8EWbAK28Ll8rv0KyZGyzA5NnlmUYcUM
         Ld3bnipIHXUPTKf52e+KJLszG3GtEnEPy+UMR20RXgDXEUAdyiUNVCmYFXxs6IRaFpuC
         NqAeq0/JMHoADl/zzA1IkKrpG9Q7PEudkx9I0zaTH8H4tU1naseG7jyY/5tyCaWAC0NO
         sTzyS+AKIZFsVrHN8J5K99L/573KOCTiMvCUdE3dYqCynNkH8IWZIIuQaUuoViX6Rjb2
         THcA==
X-Gm-Message-State: APjAAAU3tv9xv/kD0p2BSBIsRtcK/yBS+WSlud+37MVthaX5YXFPKm3K
        30DUO2jJj3eX+ofvLurUCyw=
X-Google-Smtp-Source: APXvYqyU7v+/im7E1v+HvIi6s7ccPLKjjYbDv64TMVL2lTbm8oYtaClYvQV5COXeBt+zwL+bvF8ACA==
X-Received: by 2002:adf:b688:: with SMTP id j8mr13476539wre.238.1559509955636;
        Sun, 02 Jun 2019 14:12:35 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id q11sm9548193wmc.15.2019.06.02.14.12.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:12:34 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 02/11] net: dsa: sja1105: Fix bit offsets of index field from L2 lookup entries
Date:   Mon,  3 Jun 2019 00:11:54 +0300
Message-Id: <20190602211203.17773-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602211203.17773-1-olteanv@gmail.com>
References: <20190602211203.17773-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This was inadvertently copied from the SJA1105 E/T structure and not
tested.  Cross-checking with the P/Q/R/S documentation (UM11040) makes
it immediately obvious what the correct bit offsets for this field are.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index c981c12eb181..0023b03a010d 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -62,7 +62,7 @@ sja1105pqrs_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 	 * such that our API doesn't need to ask for a full-blown entry
 	 * structure when e.g. a delete is requested.
 	 */
-	sja1105_packing(buf, &cmd->index, 29, 20,
+	sja1105_packing(buf, &cmd->index, 15, 6,
 			SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY, op);
 	/* TODO hostcmd */
 }
-- 
2.17.1

