Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B3F25D81
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 07:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbfEVFVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 01:21:25 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44352 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfEVFVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 01:21:24 -0400
Received: by mail-pf1-f195.google.com with SMTP id g9so668634pfo.11;
        Tue, 21 May 2019 22:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A3GSMoFtIIu9gnm2oZly2q3vAs35Rn87VGmbBuylL+M=;
        b=X4TZ9d/S3vWo07LOsHAjPNORAxOtuouzOUHa/G4iQLPSL3hN57UsUh84AqVWgiI+vU
         P971S7BBSPaOD1ahjKh73WlKDa2S5ntc6IP5Nomo4ZSE5e8hotTFimwaYiAzCboEUhRr
         Tco+ybvVge8XTmAys+Ta82JbS7udrsqPCFrOJ21LaKBF7gltIqugG6ngpe/rGchSxGlg
         6EY7ICyUFhZ5ZrbaSD3vqHnxFXGLPaLcDhTtSEWblZCRb21QXOpxoQuYYHRSvVi4B+KI
         0jdHwZ9KKFFe6BC+M7dXeRtfeEn+rxt5K/aqFCcCBaJVMqO2oqmHyCED8VyPbg2NDyP8
         vmCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A3GSMoFtIIu9gnm2oZly2q3vAs35Rn87VGmbBuylL+M=;
        b=NJwxJ0b+OH7hyFjZ49jQSSLaFB8rK8NkqPnYqTCRxvh6EGyXdccI47v0n34hi3/Vx/
         RAhYwNlWBtFk13TwkErqoPuO9JSwVUwLopeJAoY04YTrg41slLlBj5oekA1ANrZrBYdq
         IHeP49/PLqrsphbWszUAVCS3Crhi1wKAUHMm0Jl+oxSSDZQKVZTbRLCuWHa00yXw4Gr6
         56XMVgdkU+cwuzj7Gg5RKgBKi0sXOFq3g2u7j9k6HpFGHg8EX/0dfRyOE/WoSVzBpNmb
         0b+GXXHFF3tyxme76ZdbiL8WbT7VP9lgjFOvwl1Ju3KDT4H6WcD2xjCH9RB3J3F/tX+6
         P3CA==
X-Gm-Message-State: APjAAAUr1G2Ho+b3HbJu7w3k0QkxLYniAsbxTYpilIZRhdJuqKPJSUcK
        gG4OYCsyaArP6JDHX88wA+E=
X-Google-Smtp-Source: APXvYqxSZ7EXEUPmJF3/IZH6oaVimhi52QTGFi31kHkYhOmIkXSS1LnhSRqDHbj40ar84kakjRjwjw==
X-Received: by 2002:a63:9a52:: with SMTP id e18mr88157840pgo.335.1558502483806;
        Tue, 21 May 2019 22:21:23 -0700 (PDT)
Received: from anarsoul-thinkpad.lan (216-71-213-236.dyn.novuscom.net. [216.71.213.236])
        by smtp.gmail.com with ESMTPSA id d9sm28138152pgj.34.2019.05.21.22.21.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 22:21:23 -0700 (PDT)
From:   Vasily Khoruzhick <anarsoul@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vasily Khoruzhick <anarsoul@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] Revert "Bluetooth: Align minimum encryption key size for LE and BR/EDR connections"
Date:   Tue, 21 May 2019 22:20:02 -0700
Message-Id: <20190522052002.10411-1-anarsoul@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit d5bb334a8e171b262e48f378bd2096c0ea458265.

This commit breaks some HID devices, see [1] for details

https://bugzilla.kernel.org/show_bug.cgi?id=203643

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: stable@vger.kernel.org
---
 include/net/bluetooth/hci_core.h | 3 ---
 net/bluetooth/hci_conn.c         | 8 --------
 2 files changed, 11 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 05b1b96f4d9e..094e61e07030 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -190,9 +190,6 @@ struct adv_info {
 
 #define HCI_MAX_SHORT_NAME_LENGTH	10
 
-/* Min encryption key size to match with SMP */
-#define HCI_MIN_ENC_KEY_SIZE		7
-
 /* Default LE RPA expiry time, 15 minutes */
 #define HCI_DEFAULT_RPA_TIMEOUT		(15 * 60)
 
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 3cf0764d5793..bd4978ce8c45 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1276,14 +1276,6 @@ int hci_conn_check_link_mode(struct hci_conn *conn)
 	    !test_bit(HCI_CONN_ENCRYPT, &conn->flags))
 		return 0;
 
-	/* The minimum encryption key size needs to be enforced by the
-	 * host stack before establishing any L2CAP connections. The
-	 * specification in theory allows a minimum of 1, but to align
-	 * BR/EDR and LE transports, a minimum of 7 is chosen.
-	 */
-	if (conn->enc_key_size < HCI_MIN_ENC_KEY_SIZE)
-		return 0;
-
 	return 1;
 }
 
-- 
2.21.0

