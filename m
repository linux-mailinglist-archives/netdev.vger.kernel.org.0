Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E811246E3DF
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 09:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbhLIIQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 03:16:44 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:59782
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234438AbhLIIQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 03:16:44 -0500
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 41DC53F1FE
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 08:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639037590;
        bh=li++Q1lkbhIYARBNYivAD9l31K5a4noYe2Z2qkyrMDA=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=NJ6MGgaeHrnuyE2MQCSeMRqYy5oGX+euEWyXXkpCMstgdI5+oDOLyOjazVcqsgvS/
         ElUVaGNwtG/n9OZF/EaAKQQiyNV6M6VlZtfs7lZ5VKx4Gy0HZLIS7RNufRMXkpbWZU
         SLsK/pCnoDc6KTiw20yz9dJ6K7uG+3a6q+HhYbw4hvFMMvY9fFAyx6EFUgmzcINAGG
         PUYvBEykG32W+JJ9AKTNehx9zp5fBqPCVFZ3MMR96wPNSCpXor+OyOMJERpKFLbqUM
         viGaJhF1rhFxzeGDPuzERh5j2eaYA1SRWjHMd1o7EwhxYwv6yRW6iddrY0cBkU6BaG
         smd0t1p7NQkhQ==
Received: by mail-lf1-f72.google.com with SMTP id q13-20020a19f20d000000b0041fcb65b6c7so93432lfh.8
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 00:13:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=li++Q1lkbhIYARBNYivAD9l31K5a4noYe2Z2qkyrMDA=;
        b=WPr8ETlthlh4h9xS/aB6TNu36tXceP9G2b9mmPSV5NVUEpJhMMV48Shsv3KqYALrlh
         h+94SRB7AfqqpP7BHGuERfFX2j3ZMuhwAH+QUy7fxLl+V2LN0FMNRcBycxVE8/Deehb+
         YpZtkT5tcMrkiPBPNxCNnImtigix6zaD+T2G4Dir+130F4AlKKL+rSINauKCyWJogb1p
         7lxFI2JRkhwPBh4D5rRiPySRWxfDFPQV7cUt4xRfMJyuozThF+UwK9O7CGjy7nDL4jny
         B2DgInDwlXMdg3KdRckL2VReh02yUK/C5v4X0WYI1tj2bpH9q9FPoTdCF0Xm9SR8lD8v
         Vr+g==
X-Gm-Message-State: AOAM531E0wKdl/HsKup1oECvtwAhrzjC7VvY5wOnZImR5mqybcqU7LjG
        ZV5L91fw0NbQStzQ3YUi3UOyrU473vem5oFw8nBwwZnqSNPgVIZo6P23Mq3tOkPgiWBXEsLwMSc
        vTgZUzwYWCdeMsD0Lqu7sk1J/a5vjxW7Lkg==
X-Received: by 2002:a05:6512:3082:: with SMTP id z2mr4516782lfd.351.1639037589270;
        Thu, 09 Dec 2021 00:13:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxew4i4a9DoT8yTaM1mSJukQJbcgVSv8A/a2FaL4870WYGHn9oTdN4j+N4jiTVK5QQzEioo6A==
X-Received: by 2002:a05:6512:3082:: with SMTP id z2mr4516767lfd.351.1639037589089;
        Thu, 09 Dec 2021 00:13:09 -0800 (PST)
Received: from krzk-bin.lan (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id s5sm531144ljg.3.2021.12.09.00.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 00:13:08 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     tadeusz.struk@linaro.org, stable@vger.kernel.org
Subject: [PATCH] nfc: fix potential NULL pointer deref in nfc_genl_dump_ses_done
Date:   Thu,  9 Dec 2021 09:13:07 +0100
Message-Id: <20211209081307.57337-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The done() netlink callback nfc_genl_dump_ses_done() should check if
received argument is non-NULL, because its allocation could fail earlier
in dumpit() (nfc_genl_dump_ses()).

Fixes: ac22ac466a65 ("NFC: Add a GET_SE netlink API")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/netlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 334f63c9529e..5c706ed75b33 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1392,8 +1392,10 @@ static int nfc_genl_dump_ses_done(struct netlink_callback *cb)
 {
 	struct class_dev_iter *iter = (struct class_dev_iter *) cb->args[0];
 
-	nfc_device_iter_exit(iter);
-	kfree(iter);
+	if (iter) {
+		nfc_device_iter_exit(iter);
+		kfree(iter);
+	}
 
 	return 0;
 }
-- 
2.32.0

