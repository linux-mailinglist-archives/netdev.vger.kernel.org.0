Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69372612550
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 22:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJ2Upw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 16:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJ2Upv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 16:45:51 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41EC25EA5;
        Sat, 29 Oct 2022 13:45:49 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id q1so7592131pgl.11;
        Sat, 29 Oct 2022 13:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hSH/pzqnHJhmvnpNbViIPrlE7JaKhF2bqCNFXMf0qyI=;
        b=hZolOdpUebBYpfjmAF3KEiy7Rax6O1IpX0qOeRey0OC3zuO462/AWCuWH4wS2f5ZcZ
         NjbVUmRe7OYZbvUlxVpgLS9+6tluA9Vo0r0Un/Mlj3YyU3VX+y07wIiwCHNaGcZriuAU
         D9XuIMkPKJvYVG+hshpDVMLHmIYVMwNLxmFkQoqoA6PUV+MuoENAFprroXoimjXlHAjp
         ejGeAedSkx7QPQUM0HLVTCU9HZOuw7zGsvc4bfPQ7sy9GrABqwQY4atxpz5hjmgqAtMy
         0Sd6pgSJHVcNoCSJvalzHka3/Z/thV1tCRGppwKjtprVL3t12Df2tzJM4sGv4J/R4mxE
         afBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hSH/pzqnHJhmvnpNbViIPrlE7JaKhF2bqCNFXMf0qyI=;
        b=eqzkjMH4hPaqHTJbpbIg+IWTS12cUUi3ZQfxVfhXiTQ1v1DsidDDh8iKweI+XLMHpq
         a+VEEOU2/dL1qmDgGO6J/sZrIRvPRC04fJZYqjuWkaDoF59OCYwOiFdgmK//2nsiVj7x
         C9nDl09c3hC1nVufJn9ep7/snwwtpkv0/JfUmYrKqlWuerqVe5kl7xypd0sY6OGHYB2Z
         sYC/rF0b6iXaXr1/NzuH4BdS0N2shRPnMwLQ4rH9Lk880sr+4lGPcw1oQ7tRmgynx0MJ
         OnbCnqAlcGVhVT/ncDQP2zDqewvDaKbzmFZ2C7KnenXQc64BCupypIT7xkWdVTrswLLd
         l3Mw==
X-Gm-Message-State: ACrzQf1XdggBAp6Mi34gSHYGWzIvN5acn7jenqApuYuAHXeqJZurgZzm
        3abMtk/H3AnBJLudRVUY/bvNTNcghCth5RrB
X-Google-Smtp-Source: AMsMyM5Q7E0Puhxa79DKWNwU7/JkQpTOgvOA1SwUpbA7XES8QMi4xRRCHPJFxc0/9khH2ouQ2nSczw==
X-Received: by 2002:a63:6986:0:b0:43c:8417:8dac with SMTP id e128-20020a636986000000b0043c84178dacmr5335735pgc.286.1667076349102;
        Sat, 29 Oct 2022 13:45:49 -0700 (PDT)
Received: from uftrace.. ([14.5.161.231])
        by smtp.gmail.com with ESMTPSA id q42-20020a17090a17ad00b0021282014066sm1461246pja.9.2022.10.29.13.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 13:45:48 -0700 (PDT)
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
Subject: [PATCH] net: bluetooth: Use kzalloc instead of kmalloc/memset
Date:   Sun, 30 Oct 2022 05:45:41 +0900
Message-Id: <20221029204541.20967-1-tegongkang@gmail.com>
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

