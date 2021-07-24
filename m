Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4F63D4A36
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 23:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhGXVIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 17:08:06 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:58424
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229588AbhGXVHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 17:07:44 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 18C453F365
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 21:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627163293;
        bh=UnOWzB6PFujT/DWlS5nVosxLJqokbjOw4vZz2zLdo+w=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=qXJ8r3xxM1+s/NnrNkC51L8YBOq1NF1HGPkzjHxG8FVxQ+FKW0JhEuFF/SEXfIZDp
         5OFKL12bkxnmMR0nUxzZetMWgZEk9aKmE7W4f5R1QEyYx73vzVYYGtA38wJRpARfDl
         F21OKIQCy4tyfta56eqVzdbjo+onXzpAXlAO2yQ4ijIPKqF581LvoN3PPbsoySlKCe
         vl6TOfQivgiW8LxPcmra0/bINoJb5oayf7coWW4L0eBSOrjiYF/Iq6jK2CmE40xfHz
         pTOYECFdO+YY6H3RMNYUHHZ8JLSCc3mOyRgFmPpYLvQNmWpb8k+/jsXIYrqOyRGqW4
         t3PkfKlYAQB5g==
Received: by mail-ed1-f70.google.com with SMTP id b13-20020a056402278db029039c013d5b80so2803368ede.7
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 14:48:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UnOWzB6PFujT/DWlS5nVosxLJqokbjOw4vZz2zLdo+w=;
        b=gKeBXk582FNSSaBQwlTnbxfs8hJ6CssSD+qqHMosKw/5DwuGJ+XoY3Y/r/gmQ9cATH
         CpSHR18SwvIpWaGDSQLn8Qf+H6mdAlwbb4rXjLR/S1NFk8TbPtNGIKwXJTe58xlxd9z/
         ZQze3VOZyjqMKmHAw2ggnU/xGKkhWhEO6nfo3RRlx3B7P64DktIxpBVM2gtqzcnPf6WI
         C6W6J9hjpnUa3B3oZdn2AsQ4oO7443PLExWRxA01BpAnFzGxzAeJA75gXATPyHde20ST
         L0VRJrrmmH5rXYdLwbv08onDn0V4vnPzA1r84Eo7YS0z+GE1sbe6ZWhs/lWjimuQwSJU
         +sWg==
X-Gm-Message-State: AOAM530HHTlYV9oxKfoe0Zx25cb5ZPJt0BGBbdUe2c29HzzlpiyrXMua
        m2XXUi3bO6lhxmozKaJxqx66RcyeDyNg4FaOwySNMBWBpHFH3nmQGoyRzGEbAxC0qE7DYMKFAVZ
        xN5qXW4xfkftJBMoXIVJPoIQz7Pc2CXXpMQ==
X-Received: by 2002:a17:906:f15:: with SMTP id z21mr10466741eji.177.1627163292622;
        Sat, 24 Jul 2021 14:48:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcC7JbUplW/EECe6Pj5DymoKEbtDHlyJUdE09NwDpBM4vPpQiH5q7A9qSREZv1RYkK2nQ3Kg==
X-Received: by 2002:a17:906:f15:: with SMTP id z21mr10466728eji.177.1627163292493;
        Sat, 24 Jul 2021 14:48:12 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id j5sm8383005edv.10.2021.07.24.14.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jul 2021 14:48:12 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 04/12] nfc: constify nci_driver_ops (prop_ops and core_ops)
Date:   Sat, 24 Jul 2021 23:47:35 +0200
Message-Id: <20210724214743.121884-5-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210724214743.121884-1-krzysztof.kozlowski@canonical.com>
References: <20210724214743.121884-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neither the core nor the drivers modify the passed pointer to struct
nci_driver_ops (consisting of function pointers), so make it a pointer
to const for correctness and safety.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/fdp/fdp.c      |  4 ++--
 drivers/nfc/s3fwrn5/nci.c  |  2 +-
 drivers/nfc/s3fwrn5/nci.h  |  2 +-
 drivers/nfc/st-nci/core.c  |  2 +-
 include/net/nfc/nci_core.h |  4 ++--
 net/nfc/nci/core.c         | 16 ++++++++--------
 6 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index 73f51848a693..4d88a617d0e8 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -651,7 +651,7 @@ static int fdp_nci_core_get_config_rsp_packet(struct nci_dev *ndev,
 	return 0;
 }
 
-static struct nci_driver_ops fdp_core_ops[] = {
+static const struct nci_driver_ops fdp_core_ops[] = {
 	{
 		.opcode = NCI_OP_CORE_GET_CONFIG_RSP,
 		.rsp = fdp_nci_core_get_config_rsp_packet,
@@ -662,7 +662,7 @@ static struct nci_driver_ops fdp_core_ops[] = {
 	},
 };
 
-static struct nci_driver_ops fdp_prop_ops[] = {
+static const struct nci_driver_ops fdp_prop_ops[] = {
 	{
 		.opcode = nci_opcode_pack(NCI_GID_PROP, NCI_OP_PROP_PATCH_OID),
 		.rsp = fdp_nci_prop_patch_rsp_packet,
diff --git a/drivers/nfc/s3fwrn5/nci.c b/drivers/nfc/s3fwrn5/nci.c
index 819e3474a437..e374e670b36b 100644
--- a/drivers/nfc/s3fwrn5/nci.c
+++ b/drivers/nfc/s3fwrn5/nci.c
@@ -20,7 +20,7 @@ static int s3fwrn5_nci_prop_rsp(struct nci_dev *ndev, struct sk_buff *skb)
 	return 0;
 }
 
-struct nci_driver_ops s3fwrn5_nci_prop_ops[4] = {
+const struct nci_driver_ops s3fwrn5_nci_prop_ops[4] = {
 	{
 		.opcode = nci_opcode_pack(NCI_GID_PROPRIETARY,
 				NCI_PROP_SET_RFREG),
diff --git a/drivers/nfc/s3fwrn5/nci.h b/drivers/nfc/s3fwrn5/nci.h
index 5c22c5315f79..c2d906591e9e 100644
--- a/drivers/nfc/s3fwrn5/nci.h
+++ b/drivers/nfc/s3fwrn5/nci.h
@@ -50,7 +50,7 @@ struct nci_prop_fw_cfg_rsp {
 	__u8 status;
 };
 
-extern struct nci_driver_ops s3fwrn5_nci_prop_ops[4];
+extern const struct nci_driver_ops s3fwrn5_nci_prop_ops[4];
 int s3fwrn5_nci_rf_configure(struct s3fwrn5_info *info, const char *fw_name);
 
 #endif /* __LOCAL_S3FWRN5_NCI_H_ */
diff --git a/drivers/nfc/st-nci/core.c b/drivers/nfc/st-nci/core.c
index f6fce34a77da..72bb51efdf9c 100644
--- a/drivers/nfc/st-nci/core.c
+++ b/drivers/nfc/st-nci/core.c
@@ -86,7 +86,7 @@ static int st_nci_prop_rsp_packet(struct nci_dev *ndev,
 	return 0;
 }
 
-static struct nci_driver_ops st_nci_prop_ops[] = {
+static const struct nci_driver_ops st_nci_prop_ops[] = {
 	{
 		.opcode = nci_opcode_pack(NCI_GID_PROPRIETARY,
 					  ST_NCI_CORE_PROP),
diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index 5dae7e2cbc49..e7118e0cc3b1 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -82,10 +82,10 @@ struct nci_ops {
 	void  (*hci_cmd_received)(struct nci_dev *ndev, u8 pipe, u8 cmd,
 				  struct sk_buff *skb);
 
-	struct nci_driver_ops *prop_ops;
+	const struct nci_driver_ops *prop_ops;
 	size_t n_prop_ops;
 
-	struct nci_driver_ops *core_ops;
+	const struct nci_driver_ops *core_ops;
 	size_t n_core_ops;
 };
 
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index a7d26f2791b0..50c625940fa3 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1363,12 +1363,12 @@ int nci_send_cmd(struct nci_dev *ndev, __u16 opcode, __u8 plen, const void *payl
 EXPORT_SYMBOL(nci_send_cmd);
 
 /* Proprietary commands API */
-static struct nci_driver_ops *ops_cmd_lookup(struct nci_driver_ops *ops,
-					     size_t n_ops,
-					     __u16 opcode)
+static const struct nci_driver_ops *ops_cmd_lookup(const struct nci_driver_ops *ops,
+						   size_t n_ops,
+						   __u16 opcode)
 {
 	size_t i;
-	struct nci_driver_ops *op;
+	const struct nci_driver_ops *op;
 
 	if (!ops || !n_ops)
 		return NULL;
@@ -1383,10 +1383,10 @@ static struct nci_driver_ops *ops_cmd_lookup(struct nci_driver_ops *ops,
 }
 
 static int nci_op_rsp_packet(struct nci_dev *ndev, __u16 rsp_opcode,
-			     struct sk_buff *skb, struct nci_driver_ops *ops,
+			     struct sk_buff *skb, const struct nci_driver_ops *ops,
 			     size_t n_ops)
 {
-	struct nci_driver_ops *op;
+	const struct nci_driver_ops *op;
 
 	op = ops_cmd_lookup(ops, n_ops, rsp_opcode);
 	if (!op || !op->rsp)
@@ -1396,10 +1396,10 @@ static int nci_op_rsp_packet(struct nci_dev *ndev, __u16 rsp_opcode,
 }
 
 static int nci_op_ntf_packet(struct nci_dev *ndev, __u16 ntf_opcode,
-			     struct sk_buff *skb, struct nci_driver_ops *ops,
+			     struct sk_buff *skb, const struct nci_driver_ops *ops,
 			     size_t n_ops)
 {
-	struct nci_driver_ops *op;
+	const struct nci_driver_ops *op;
 
 	op = ops_cmd_lookup(ops, n_ops, ntf_opcode);
 	if (!op || !op->ntf)
-- 
2.27.0

