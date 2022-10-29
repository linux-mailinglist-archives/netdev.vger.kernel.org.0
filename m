Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3383612599
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 23:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiJ2VlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 17:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJ2VlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 17:41:07 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF300C7;
        Sat, 29 Oct 2022 14:41:05 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 3-20020a17090a0f8300b00212d5cd4e5eso12836411pjz.4;
        Sat, 29 Oct 2022 14:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/861UoRf3F+2YILewsi3E4Q/g8WnmJGSnP8oXVC9Ulo=;
        b=Ad6qNuVd703mDsl9h9ZAFsw+rsT5SEsCTchCIKfFP44Xw+gJ4ZfiSGIYWEhlj5L7Sx
         2tpFfUK8v9ilSz10X4y5m7vL+RN7tmz8XEIySk2o7ZVIxe72uDQTBOP63kf/83y7hpiF
         bryuzIiGOO3huvQOXoDCZecEV7CTb6OS8uaAhP0NdeAB9vI3Avs1I+3LOwUPf9gTUJg+
         mdHCwIGiHP2idwSOiSFMdRqSmo0kYVClECsemKd44LEYQn5IzFPe/vZnKqlkQpAIiwnz
         Y41wH/aOcqn5m0P3Kwji/Bn7zMWI+56Qx6BRfY4d1zonOslZfhsDPIosTEo+fE9YsJfr
         tSfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/861UoRf3F+2YILewsi3E4Q/g8WnmJGSnP8oXVC9Ulo=;
        b=cYlIm5XsoBqzmFsI+mS9pG8CWpVupsYvXYWb+L+kzx4yJO1e0htNoJeRQ+Vm9tyXZH
         SvK/IQtyIpNa1KJt4HeaVzeVSRxX56Aq2obnbS11Wi/tsWwFUFo16X7fMorrvqZ91AyK
         l5+6biPtZlaXFRo8bvdD3cqTgtzfPS1JaCO69FJB1g3l2PeYYMimFHTmoy8V8Lji4bmS
         Mz+RwewiKi6d44j64aFAOcbVMFrIxfG+0LuaPUbUS197IQwk6BtWjgO8QVdJ64F1ePjh
         fbWO9lgLztobzRscVIDfn3YVwNs3uIJ9PN1bC+jQYeXEGeN9gYdqhh2G+NtZkTyeNcRz
         q5bQ==
X-Gm-Message-State: ACrzQf1yLhey2/DvQmmU3026rN9tQZhbx1o8U8AxCYM6LV6YkjdIGXIZ
        1fSuf1ZYLWjR3rjXZvXfrIs=
X-Google-Smtp-Source: AMsMyM5zxFHvDuRdShgj/syyAjot5EnVw4SXb2fxPU/SarqT3cN7v5lpzmVDLYzSHzuwSS2pclmy7g==
X-Received: by 2002:a17:90b:2751:b0:20a:e437:a9e8 with SMTP id qi17-20020a17090b275100b0020ae437a9e8mr23139521pjb.181.1667079665307;
        Sat, 29 Oct 2022 14:41:05 -0700 (PDT)
Received: from uftrace.. ([14.5.161.231])
        by smtp.gmail.com with ESMTPSA id 17-20020a17090a19d100b002036006d65bsm1448759pjj.39.2022.10.29.14.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 14:41:04 -0700 (PDT)
From:   Kang Minchul <tegongkang@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kang Minchul <tegongkang@gmail.com>
Subject: [PATCH v2] Bluetooth: Use kzalloc instead of kmalloc/memset
Date:   Sun, 30 Oct 2022 06:40:58 +0900
Message-Id: <20221029214058.25159-1-tegongkang@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit replace kmalloc + memset to kzalloc
for better code readability and simplicity.

Following messages are related cocci warnings.

WARNING: kzalloc should be used for d, instead of kmalloc/memset

Signed-off-by: Kang Minchul <tegongkang@gmail.com>
---
V1 -> V2: Change subject prefix

 net/bluetooth/hci_conn.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 7a59c4487050..287d313aa312 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -824,11 +824,10 @@ static int hci_le_terminate_big(struct hci_dev *hdev, u8 big, u8 bis)
 
 	bt_dev_dbg(hdev, "big 0x%2.2x bis 0x%2.2x", big, bis);
 
-	d = kmalloc(sizeof(*d), GFP_KERNEL);
+	d = kzalloc(sizeof(*d), GFP_KERNEL);
 	if (!d)
 		return -ENOMEM;
 
-	memset(d, 0, sizeof(*d));
 	d->big = big;
 	d->bis = bis;
 
@@ -861,11 +860,10 @@ static int hci_le_big_terminate(struct hci_dev *hdev, u8 big, u16 sync_handle)
 
 	bt_dev_dbg(hdev, "big 0x%2.2x sync_handle 0x%4.4x", big, sync_handle);
 
-	d = kmalloc(sizeof(*d), GFP_KERNEL);
+	d = kzalloc(sizeof(*d), GFP_KERNEL);
 	if (!d)
 		return -ENOMEM;
 
-	memset(d, 0, sizeof(*d));
 	d->big = big;
 	d->sync_handle = sync_handle;
 
-- 
2.34.1

