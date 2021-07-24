Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8F83D4A4F
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 23:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhGXVJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 17:09:31 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:58694
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230424AbhGXVJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 17:09:26 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 57AFA3F245
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 21:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627163396;
        bh=YaYGR91qsiSocIs8IC8xy1Q/DfuvgUc0SvOHFTtp8Po=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=CVQrCj9gfFjwb5m0USKzpFyTpJ4IAk1rUJXxO8G/I+lQKAuZnV/kQYpbmIBUTxaZ5
         +ae+iluDBqG/xxRrmERCsfcMNXVczqKdqLGI/vFbqjpSPPeMQj9hoAb5gMyScXmrgb
         e7qtZ02aA0Wuf1KEDFWGmQrPL7iQqOQJsxNBgZunETffehoE5uT7GamJ5u+B8BnwtX
         tLRrawh2roDzenUoBGkwmLbIOLCK8hiCHsRDXeJM4Zy5OsOY/0b2VzThEGHtV9THht
         PBMTM7/ASqzaP/DpZ4aeVuVyitZsEOpvJQCbrqcmr+RJ/8hnOV3DWClJEVaCbOeHN3
         6D9SrQNOs1xUg==
Received: by mail-ed1-f70.google.com with SMTP id s8-20020a0564020148b02903948b71f25cso2801915edu.4
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 14:49:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YaYGR91qsiSocIs8IC8xy1Q/DfuvgUc0SvOHFTtp8Po=;
        b=Ea0X7Uglm5yUtMKn4xj8ZA4rdWN98StzMRC+rf1R8G3IyFYxIklyrlTJpuC+lx4NES
         VwxAdeLiu6w7CcPYIV2RPdZCj+ulI9JRSI+Ue2g0UwypgN+yakNIFqdATNGbfqZDUZ1f
         SaPW7DZ+6xrHowHrRhbQTtk6QkRmMlP/7Ydk9Hc1P7uQrq3sTXHZ/lTLscdusheHp8zc
         tIYfzgK+YnuNWbV1i0vHSELa0ArPw/ZazAZaegMmeQdijg0YaWRP6HkTWRr2QwXNXPio
         3Db38xIhilGnd/XbwB11MoXntBKGCPgonAaL7nSJsHeMYQBejUyVnOHVMIbQnmwFQZGS
         8Izw==
X-Gm-Message-State: AOAM531mhX7SK0F9Rq1XyS95G5IfyPpM0USnEr9gBmETX7lmlebfhvql
        PBNRoe23BOfEQsk25j11046trygp39ROJzj8O+36Wr1SL9UiWCFbfzTKZntIUSy71B+TMlB7KTg
        6pkTpPC0DkjQ0GgB33QtFTe4x4dKbhuGIBw==
X-Received: by 2002:a17:907:1def:: with SMTP id og47mr10501867ejc.51.1627163396096;
        Sat, 24 Jul 2021 14:49:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyptb2lC5eNQ/8Ds9TdTrfNbFenR2CMYkDrtf1zT+eHhzYKImpUkxn5Xw9eViwKIQfNH0c+9g==
X-Received: by 2002:a17:907:1def:: with SMTP id og47mr10501850ejc.51.1627163395950;
        Sat, 24 Jul 2021 14:49:55 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id s10sm12821908ejc.39.2021.07.24.14.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jul 2021 14:49:55 -0700 (PDT)
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
Subject: [PATCH 11/12] nfc: constify nfc_llc_ops
Date:   Sat, 24 Jul 2021 23:49:27 +0200
Message-Id: <20210724214928.122096-6-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210724214743.121884-1-krzysztof.kozlowski@canonical.com>
References: <20210724214743.121884-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neither the core nor the drivers modify the passed pointer to struct
nfc_llc_ops, so make it a pointer to const for correctness and safety.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 Documentation/driver-api/nfc/nfc-hci.rst | 2 +-
 net/nfc/hci/llc.c                        | 2 +-
 net/nfc/hci/llc.h                        | 6 +++---
 net/nfc/hci/llc_nop.c                    | 2 +-
 net/nfc/hci/llc_shdlc.c                  | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/driver-api/nfc/nfc-hci.rst b/Documentation/driver-api/nfc/nfc-hci.rst
index eb8a1a14e919..f10fe53aa9fe 100644
--- a/Documentation/driver-api/nfc/nfc-hci.rst
+++ b/Documentation/driver-api/nfc/nfc-hci.rst
@@ -181,7 +181,7 @@ xmit_from_hci():
 The llc must be registered with nfc before it can be used. Do that by
 calling::
 
-	nfc_llc_register(const char *name, struct nfc_llc_ops *ops);
+	nfc_llc_register(const char *name, const struct nfc_llc_ops *ops);
 
 Again, note that the llc does not handle the physical link. It is thus very
 easy to mix any physical link with any llc for a given chip driver.
diff --git a/net/nfc/hci/llc.c b/net/nfc/hci/llc.c
index 6ab40ea17662..fc6b63de3462 100644
--- a/net/nfc/hci/llc.c
+++ b/net/nfc/hci/llc.c
@@ -41,7 +41,7 @@ void nfc_llc_exit(void)
 	}
 }
 
-int nfc_llc_register(const char *name, struct nfc_llc_ops *ops)
+int nfc_llc_register(const char *name, const struct nfc_llc_ops *ops)
 {
 	struct nfc_llc_engine *llc_engine;
 
diff --git a/net/nfc/hci/llc.h b/net/nfc/hci/llc.h
index 823ddb621e5d..d66271d211a5 100644
--- a/net/nfc/hci/llc.h
+++ b/net/nfc/hci/llc.h
@@ -26,20 +26,20 @@ struct nfc_llc_ops {
 
 struct nfc_llc_engine {
 	const char *name;
-	struct nfc_llc_ops *ops;
+	const struct nfc_llc_ops *ops;
 	struct list_head entry;
 };
 
 struct nfc_llc {
 	void *data;
-	struct nfc_llc_ops *ops;
+	const struct nfc_llc_ops *ops;
 	int rx_headroom;
 	int rx_tailroom;
 };
 
 void *nfc_llc_get_data(struct nfc_llc *llc);
 
-int nfc_llc_register(const char *name, struct nfc_llc_ops *ops);
+int nfc_llc_register(const char *name, const struct nfc_llc_ops *ops);
 void nfc_llc_unregister(const char *name);
 
 int nfc_llc_nop_register(void);
diff --git a/net/nfc/hci/llc_nop.c b/net/nfc/hci/llc_nop.c
index a42852f36f2e..a58716f16954 100644
--- a/net/nfc/hci/llc_nop.c
+++ b/net/nfc/hci/llc_nop.c
@@ -71,7 +71,7 @@ static int llc_nop_xmit_from_hci(struct nfc_llc *llc, struct sk_buff *skb)
 	return llc_nop->xmit_to_drv(llc_nop->hdev, skb);
 }
 
-static struct nfc_llc_ops llc_nop_ops = {
+static const struct nfc_llc_ops llc_nop_ops = {
 	.init = llc_nop_init,
 	.deinit = llc_nop_deinit,
 	.start = llc_nop_start,
diff --git a/net/nfc/hci/llc_shdlc.c b/net/nfc/hci/llc_shdlc.c
index 1e3a90049da9..6b747856d095 100644
--- a/net/nfc/hci/llc_shdlc.c
+++ b/net/nfc/hci/llc_shdlc.c
@@ -820,7 +820,7 @@ static int llc_shdlc_xmit_from_hci(struct nfc_llc *llc, struct sk_buff *skb)
 	return 0;
 }
 
-static struct nfc_llc_ops llc_shdlc_ops = {
+static const struct nfc_llc_ops llc_shdlc_ops = {
 	.init = llc_shdlc_init,
 	.deinit = llc_shdlc_deinit,
 	.start = llc_shdlc_start,
-- 
2.27.0

