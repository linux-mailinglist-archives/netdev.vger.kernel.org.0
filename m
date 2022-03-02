Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFDE14CADB5
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 19:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241125AbiCBSia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 13:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiCBSi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 13:38:26 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C4A33E21
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 10:37:42 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id qa43so5535340ejc.12
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 10:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PoZkJu6l4h6aEzKk7gmr65X6dMSH0Mhj2hdZdZe2/k8=;
        b=sCZsWSaON5fifyK+cTu9Jpav7ukmQdPZcvJ8b1jip96KR+SkxHipK9wJjrwjFVQPCL
         asHEqwz1jlbctMX6R4MF5ZgHzXalSY9PNXzB5M1ELN40mdln2T/k1KoIZ6nSC/1+52N0
         SuD1XUwvqwnjZA+T5HBrlH5+8wV1Y8nsT6gNrcLfzINuhkvaglQCEo//V1+vhpdwxIEy
         /KbdSVBZDeMzxuQy/z3t5sCw7fnJiE762wYu1WuM/gyjoroTgVxZaY2HJxmdqtuELCyg
         X0yLgvkUZVZEPLbAXDuQZVGbGghDWdxyVFRJ56apHgHQbMJ0B7lDAM3r2uHEcSaaayvw
         Q8Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PoZkJu6l4h6aEzKk7gmr65X6dMSH0Mhj2hdZdZe2/k8=;
        b=7nIK8Ore3Lp+xXzYtrx2lkKuW7vbvP9h7wJ2f/N19SukXn5wuiNXXozSwSDjrDGQlk
         UUma5xOPlgGhSU5PolVqkh9FSymi4tWsE0tO6kJN/y6FkloJTh0zF9VYKZKLbBWQZNPq
         KtCAxlID6DqzKJcJZaOcMQ3I8IW9VZfUuk6E+dgXVhFiR6fGkV5KabJfJm19ipYgnDkU
         mN6uvVqRqZ5KRG8C2U5j++2QScYaoLqaCgTUDxwsIDz8wqXGxCck0trU7snS31TVjqCa
         Ug1D8RvgczmuiiNlMllONmjxHAnWbBHoRD4fZJI8Ddussn1189vMlp9Z+WSCq7fgvMnf
         haHA==
X-Gm-Message-State: AOAM530UFGlMW/T6EyKJVRUbCi6mbIMFjTEMKQg/Yk6QSohB73Faec6P
        44YhZI4RUPh7+poqyAsVSGuI7t/U9JyjsA==
X-Google-Smtp-Source: ABdhPJz4rF9lPkcQKUWNfVTvbozvbxjzwEWTM141WwHUI8VTZcXbD4YSDWRS8Hr9C8nf3kA1RjFEmQ==
X-Received: by 2002:a17:906:9913:b0:6d6:dc48:5d49 with SMTP id zl19-20020a170906991300b006d6dc485d49mr9576712ejb.325.1646246261332;
        Wed, 02 Mar 2022 10:37:41 -0800 (PST)
Received: from localhost.localdomain (cpc78119-cwma10-2-0-cust590.7-3.cable.virginm.net. [81.96.50.79])
        by smtp.gmail.com with ESMTPSA id b17-20020aa7c6d1000000b0041301be2b5esm8732375eds.58.2022.03.02.10.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 10:37:40 -0800 (PST)
From:   Caleb Connolly <caleb.connolly@linaro.org>
To:     caleb.connolly@linaro.org, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2] bluetooth: hci_event: don't print an error on vendor events
Date:   Wed,  2 Mar 2022 18:35:17 +0000
Message-Id: <20220302183515.448334-1-caleb.connolly@linaro.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 3e54c5890c87 ("Bluetooth: hci_event: Use of a function table to handle HCI events"),
some devices see warnings being printed for vendor events, e.g.

[   75.806141] Bluetooth: hci0: setting up wcn399x
[   75.948311] Bluetooth: hci0: unexpected event 0xff length: 14 > 0
[   75.955552] Bluetooth: hci0: QCA Product ID   :0x0000000a
[   75.961369] Bluetooth: hci0: QCA SOC Version  :0x40010214
[   75.967417] Bluetooth: hci0: QCA ROM Version  :0x00000201
[   75.973363] Bluetooth: hci0: QCA Patch Version:0x00000001
[   76.000289] Bluetooth: hci0: QCA controller version 0x02140201
[   76.006727] Bluetooth: hci0: QCA Downloading qca/crbtfw21.tlv
[   76.986850] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.013574] Bluetooth: hci0: QCA Downloading qca/oneplus6/crnv21.bin
[   77.024302] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.032681] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.040674] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.049251] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.057997] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.066320] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.075065] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.083073] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.091250] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.099417] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.110166] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.118672] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.127449] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.137190] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.146192] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.154242] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.163183] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.171202] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.179364] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.187259] Bluetooth: hci0: unexpected event 0xff length: 3 > 0
[   77.198451] Bluetooth: hci0: QCA setup on UART is completed

Avoid printing the event length warning for vendor events, this reverts
to the previous behaviour where such warnings weren't printed.

Fixes: 3e54c5890c87 ("Bluetooth: hci_event: Use of a function table to handle HCI events")
Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
---
Changes since v1:
 * Don't return early! Vendor events still get parsed despite the
   warning. I should have looked a little more closely at that...
---
 net/bluetooth/hci_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index fc30f4c03d29..9b7c9ab77971 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6822,7 +6822,7 @@ static void hci_event_func(struct hci_dev *hdev, u8 event, struct sk_buff *skb,
 	 * possible to partially parse the event so leave to callback to
 	 * decide if that is acceptable.
 	 */
-	if (skb->len > ev->max_len)
+	if (skb->len > ev->max_len && event != HCI_EV_VENDOR)
 		bt_dev_warn(hdev, "unexpected event 0x%2.2x length: %u > %u",
 			    event, skb->len, ev->max_len);
 
-- 
2.35.1

