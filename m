Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC6C4D037B
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 16:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240904AbiCGPyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 10:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238588AbiCGPyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 10:54:35 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF32866610;
        Mon,  7 Mar 2022 07:53:40 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id b5so24052114wrr.2;
        Mon, 07 Mar 2022 07:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VCMF7JOePAGAD2TRuJoonUYYB1mQc1S3qSAF6RtOJWY=;
        b=mqvy472H4fpcBOM1bST+j5DbuOBj4z4Zd8s+2YSbdcQo6ChrFa6JapwmdFDuwZtvnd
         IMXCTSOD3UH8W3dh4affMWFJeG9t7zLBnzCseOxGwss+RhRaTMPJi9+Gh/LG+7NLJGwz
         09JtCCYz55HcoePAc8CIjItO5FFk01yWi1dhcVUJ6AVHygAdvQvYB4p1ugGTP4w3MwTb
         uaIOxR6/gl74GqxZlO3G2wzbCZNNDD641IE/0tc61jLvsgDmPQ3grbRpXBOgemIw45iZ
         p7rSjpQctaEvD9aDhcAvIOZS6aSSsxsjQcgomCvaIa8xTfhX6dc2wsFEEMmI+tYTrjEf
         r31w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VCMF7JOePAGAD2TRuJoonUYYB1mQc1S3qSAF6RtOJWY=;
        b=Ct/L2FQwvOSYXvAeNejwJm70MKdZNRXOOsrx8CdMuyIAzF9ZT7kl0L+epIn9V1qRpx
         8rEK0gP7ndHcyqDS37S8vRT2t4qm9IDkN7lAwoP5dMY6uhRV5mzwRds+vHw00sNPXAJ6
         VPRk+GluitJb+TKMQrKNkh2vocly5Ei2YgvXi+i2JN68S0jZELnmOb8lRsjufdggHOp6
         PnNM7f5vuD7EfsWMYYPTSS4uczyfeMc7jZuyXGLo/qr3XpJeseivMnB0RkqsrOqK5y1O
         i0KweFECenlOA3b95DE2qEs9FQfNIA7ezqysktr3n0EM94178wOf5mikbMk6yoROfzpm
         v4hQ==
X-Gm-Message-State: AOAM532J1bEVlUx2NF6XGeOfvj/HsPIZDzxCucb0FlSP1m9MPUhIy2CP
        F+mDiBJms1siIOuEkIvJZtttR8s9sXcPvQ==
X-Google-Smtp-Source: ABdhPJx9tp6UqpNijYut2CQMscnG37GHYd0RtPgRD/hiGSg3Txqamr2jn3+qrxh5a0lI0idxw+ZDGg==
X-Received: by 2002:a5d:6a47:0:b0:1f1:e562:bef9 with SMTP id t7-20020a5d6a47000000b001f1e562bef9mr7183983wrw.445.1646668419347;
        Mon, 07 Mar 2022 07:53:39 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id g17-20020adff411000000b001f03426827csm11727167wro.71.2022.03.07.07.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 07:53:39 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH] Bluetooth: mgmt: remove redundant assignment to variable cur_len
Date:   Mon,  7 Mar 2022 15:53:38 +0000
Message-Id: <20220307155338.140860-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
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

Variable cur_len is being ininitialized with a value in the start of
a for-loop but this is never read, it is being re-assigned a new value
on the first statement in the for-loop.  The initialization is redundant
and can be removed.

Cleans up clang scan build warning:
net/bluetooth/mgmt.c:7958:14: warning: Although the value stored to 'cur_len'
is used in the enclosing expression, the value is never actually read
from 'cur_len' [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 net/bluetooth/mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 8101a6a31841..e0137bc1080e 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7955,7 +7955,7 @@ static bool tlv_data_is_valid(struct hci_dev *hdev, u32 adv_flags, u8 *data,
 		return false;
 
 	/* Make sure that the data is correctly formatted. */
-	for (i = 0, cur_len = 0; i < len; i += (cur_len + 1)) {
+	for (i = 0; i < len; i += (cur_len + 1)) {
 		cur_len = data[i];
 
 		if (!cur_len)
-- 
2.35.1

