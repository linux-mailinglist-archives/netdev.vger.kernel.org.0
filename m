Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83623D4A4D
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 23:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhGXVJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 17:09:28 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:43998
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230344AbhGXVJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 17:09:22 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 425C93F34F
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 21:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627163393;
        bh=6J2lTgqHYzy3l3MCZfIFQGtEtcoxxKRMkHa94SdSjak=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Auw3vH/4t/KArtwICGNCg02LtuX3rsWgfguOwhLmmM40Tz2Z9hWlSsD9mjyL4CX00
         DcE6qAn1tMxbzGPrIC1/yyl4UkiFmzBJyGdmBLHEWSJxSlYaqqp1byhwwTLzrzf5WH
         SiU0vNUzz4TpwFUCiDF4LLa7Utium/5kxT54NhSRgwSFcBDmWJdQkgBSpsQ6fMTeT8
         KrMyYs4ijB2t/5n9UfKr1fUg/9t074ggVDryG8dmoTtQdPDXatIovy/eaH2KylIORq
         tt27XfveZ6MzXAhp3H7b98teMlNS2Lh86EQpB96Jlo7DK+px9MvczZzI2ayaxy2NbI
         7Qyd/0grRPk5w==
Received: by mail-ed1-f72.google.com with SMTP id i89-20020a50b0620000b02903b8906e05b4so2753467edd.19
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 14:49:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6J2lTgqHYzy3l3MCZfIFQGtEtcoxxKRMkHa94SdSjak=;
        b=AXaYyL9znFhHF9U8rU+2J7z7oWvIDL7XOYG9UgsRR1SVsDHV+vVXs3AdEKSfgUell5
         POWNNPGYk8iJ8Dn67xe8iatTMhgdfiYClB4qc9wOviAdS9Es8wGpBssRL0N8DgvZ1wfJ
         qUc2Yx6Lwz4COrtXxHlyimb76tOUNGUcm/JqcnKBZ3HJZ46pekBhuR3wIH4Md5lnWcn+
         8y2cJpQDP84x/g6mcOVrVJbSkoxcw8ua1TfizgnAamoWKx8tVDHCYuGHM5q8iM7YuTmB
         78eJt6jTGryH2I38CKlPfjtOeLNaoaByw71y8TFZTKGDGxcK8tSjpb3qMJ7thjrdlk7R
         5FDA==
X-Gm-Message-State: AOAM53313sjYQ2zyBTv732gCKamCR2nUfZXypHdlvicTPWJNzFCZAWow
        1XWY5AjQSEziaCj8hakMCklvweHWfUBcVmobTd0EcanwoYE/8O8OYzG4Q7N+vJFVwETvwgcPH/+
        sBqPYGCFeI55kYqCW7TFKvJQ/hhLPWxV3+g==
X-Received: by 2002:aa7:d143:: with SMTP id r3mr13186663edo.110.1627163392075;
        Sat, 24 Jul 2021 14:49:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynYqsTng3py05vnEd/zOimw7GtW4mRC4/+/JHfPY2EnELDBn9UeX+yaAenZaRxe7Mt5Rc8fA==
X-Received: by 2002:aa7:d143:: with SMTP id r3mr13186647edo.110.1627163391958;
        Sat, 24 Jul 2021 14:49:51 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id s10sm12821908ejc.39.2021.07.24.14.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jul 2021 14:49:51 -0700 (PDT)
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
Subject: [PATCH 09/12] nfc: constify nfc_ops
Date:   Sat, 24 Jul 2021 23:49:25 +0200
Message-Id: <20210724214928.122096-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210724214743.121884-1-krzysztof.kozlowski@canonical.com>
References: <20210724214743.121884-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neither the core nor the drivers modify the passed pointer to struct
nfc_ops, so make it a pointer to const for correctness and safety.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/pn533/pn533.c | 2 +-
 include/net/nfc/nfc.h     | 4 ++--
 net/nfc/core.c            | 2 +-
 net/nfc/digital_core.c    | 2 +-
 net/nfc/hci/core.c        | 2 +-
 net/nfc/nci/core.c        | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index cd64bfe20402..2f3f3fe9a0ba 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2623,7 +2623,7 @@ static int pn533_dev_down(struct nfc_dev *nfc_dev)
 	return ret;
 }
 
-static struct nfc_ops pn533_nfc_ops = {
+static const struct nfc_ops pn533_nfc_ops = {
 	.dev_up = pn533_dev_up,
 	.dev_down = pn533_dev_down,
 	.dep_link_up = pn533_dep_link_up,
diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 31672021d071..85b698794b14 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -191,14 +191,14 @@ struct nfc_dev {
 	const struct nfc_vendor_cmd *vendor_cmds;
 	int n_vendor_cmds;
 
-	struct nfc_ops *ops;
+	const struct nfc_ops *ops;
 	struct genl_info *cur_cmd_info;
 };
 #define to_nfc_dev(_dev) container_of(_dev, struct nfc_dev, dev)
 
 extern struct class nfc_class;
 
-struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
+struct nfc_dev *nfc_allocate_device(const struct nfc_ops *ops,
 				    u32 supported_protocols,
 				    int tx_headroom,
 				    int tx_tailroom);
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 573c80c6ff7a..6ade54149b73 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -1048,7 +1048,7 @@ struct nfc_dev *nfc_get_device(unsigned int idx)
  * @tx_headroom: reserved space at beginning of skb
  * @tx_tailroom: reserved space at end of skb
  */
-struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
+struct nfc_dev *nfc_allocate_device(const struct nfc_ops *ops,
 				    u32 supported_protocols,
 				    int tx_headroom, int tx_tailroom)
 {
diff --git a/net/nfc/digital_core.c b/net/nfc/digital_core.c
index 5044c7db577e..8f2572decccd 100644
--- a/net/nfc/digital_core.c
+++ b/net/nfc/digital_core.c
@@ -732,7 +732,7 @@ static int digital_in_send(struct nfc_dev *nfc_dev, struct nfc_target *target,
 	return rc;
 }
 
-static struct nfc_ops digital_nfc_ops = {
+static const struct nfc_ops digital_nfc_ops = {
 	.dev_up = digital_dev_up,
 	.dev_down = digital_dev_down,
 	.start_poll = digital_start_poll,
diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index e37d30302b06..b33fe4ee1581 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -928,7 +928,7 @@ static int hci_fw_download(struct nfc_dev *nfc_dev, const char *firmware_name)
 	return hdev->ops->fw_download(hdev, firmware_name);
 }
 
-static struct nfc_ops hci_nfc_ops = {
+static const struct nfc_ops hci_nfc_ops = {
 	.dev_up = hci_dev_up,
 	.dev_down = hci_dev_down,
 	.start_poll = hci_start_poll,
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 50c625940fa3..400d66c4e210 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1102,7 +1102,7 @@ static int nci_fw_download(struct nfc_dev *nfc_dev, const char *firmware_name)
 	return ndev->ops->fw_download(ndev, firmware_name);
 }
 
-static struct nfc_ops nci_nfc_ops = {
+static const struct nfc_ops nci_nfc_ops = {
 	.dev_up = nci_dev_up,
 	.dev_down = nci_dev_down,
 	.start_poll = nci_start_poll,
-- 
2.27.0

