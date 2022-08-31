Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5975A826C
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbiHaPzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbiHaPza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:55:30 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9074925C1;
        Wed, 31 Aug 2022 08:55:19 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q9so13855707pgq.6;
        Wed, 31 Aug 2022 08:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=edgz/anZga5B72kbydsFpS1Ao3mlt2fMRx3NBRP9Gq4=;
        b=qlBngZZaSEVwvn7bItNRiGaPrBgECXcr+7OxMT9fTFLDDQABEnsCVX/jzIVjH1IqMQ
         L2WgwEl9fJbxg24FKFmgN9ym62WX/5VxWgG8kM3jdvXPUTMUhaO64tM410d/X+u5LFBD
         O3DWb0tMLRiqWgfxcqcuROonwwNPPvteBoi27PkQnWR7hQt8YXQyD++seFOUPvs2O2hg
         tqRkNIclGm1erWgKiGIwUDeU6Hlo8RA4LhWxY4iunAfqcIjey8XK0Wi7l2Fl+lPxaUv1
         OWSiwU/54CI+xkT4mCztPddOblu+e1PoEtYHBo8piYcoJymfxOXvbhuw7oagp3zhQHzq
         ueZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=edgz/anZga5B72kbydsFpS1Ao3mlt2fMRx3NBRP9Gq4=;
        b=zMlFRNBfi1xw5nkB3Z5a8f8RHg3cJfg2qXTHFDXn+5ljGVbt0UFInmOf20Qoe2WeO2
         tU6N3o+9lL2rGWL5LVbzzAZj1Q//Gc3A9Vba2UIylXLMqGPVQoGrdkYSQyvMwe6yjBn5
         VslBckFrreuTj/GMBqQiviL9297st2LlDaSRGGas3xfQgyUDTU9GrcK/ha5gaC1hyqi3
         h/KN3vufBbGCn0KIXk2JDKXSrd+VStBBG+LcYN783C1QZDJv7QsJjBUR0pV29pXjS5oZ
         iLF9si9VbyUUlo6XTH6ROskKV6yXO0h37isPTCUElZtis1jpx6lNIFBR08hkQwBQvDGZ
         j7xg==
X-Gm-Message-State: ACgBeo1VuAsWC8O5lDA92ZDsrwZT9CoEaO8bC8Y6mzCbtydGO3l42lN9
        xYTnJn+pR55/4CrJUrlvveTBlJQv2Lw=
X-Google-Smtp-Source: AA6agR6UsOtrvoJEGiBIH6cOM0PsQId4AZnTdwuDINNG2Bvbepv7yeGjk6f3Gx0yYntq9kGinUzuhg==
X-Received: by 2002:a63:e90c:0:b0:422:5ab9:99d6 with SMTP id i12-20020a63e90c000000b004225ab999d6mr22872698pgh.394.1661961318621;
        Wed, 31 Aug 2022 08:55:18 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id d7-20020a170902654700b001641b2d61d4sm11834952pln.30.2022.08.31.08.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 08:55:18 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: cui.jinpeng2@zte.com.cn
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] Bluetooth: remove redundant variable err
Date:   Wed, 31 Aug 2022 15:55:13 +0000
Message-Id: <20220831155513.305604-1-cui.jinpeng2@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
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

From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

Return value directly from hci_req_run_skb() instead of
getting value from redundant variable err.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
---
 net/bluetooth/msft.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index bee6a4c656be..53872f9600f4 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -819,16 +819,14 @@ int msft_set_filter_enable(struct hci_dev *hdev, bool enable)
 {
 	struct hci_request req;
 	struct msft_data *msft = hdev->msft_data;
-	int err;
 
 	if (!msft)
 		return -EOPNOTSUPP;
 
 	hci_req_init(&req, hdev);
 	msft_req_add_set_filter_enable(&req, enable);
-	err = hci_req_run_skb(&req, msft_le_set_advertisement_filter_enable_cb);
 
-	return err;
+	return hci_req_run_skb(&req, msft_le_set_advertisement_filter_enable_cb);
 }
 
 bool msft_curve_validity(struct hci_dev *hdev)
-- 
2.25.1

