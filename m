Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57FC8612C30
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 19:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiJ3SRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 14:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiJ3SRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 14:17:31 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86371B484;
        Sun, 30 Oct 2022 11:17:29 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id m6so8951486pfb.0;
        Sun, 30 Oct 2022 11:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FKiTxkhmW01FsjmqPtf+yJSPZRDfXBpZLYs+QLD1Y3s=;
        b=KMjRbyUQbK/qMAqOzDmwGd/TIltucuP8unSi2yGMRWwxQnFAFAYdVm7N9hAX0wIRJr
         I1JCALbf47hg2VJqa0kkG6Rqb683/E22lyNTEwLnjyjw1JmejfNWVLIi4LzTeBsM1bWd
         2LxNw5VLs5Vs+fLPjVZyAyhVpJCUi82yRGlmUUoAEKGFBMNq9epPtKcUbjsWpBd5n86i
         Dd451JC1aV3YS2Nf/O3yiUflkg3NvcRCm/IAR5lT4jH0OVMPvXgc1885NbeUfbdPzfu5
         t4egUN2rMDR1EU5nCde0Tg2v48sIZkb9cfMH+qdV1zIXaKTN0h+wWmRwGDVCNQjZbOCv
         BBig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FKiTxkhmW01FsjmqPtf+yJSPZRDfXBpZLYs+QLD1Y3s=;
        b=hvJbbax3rMdrAhuy3bOIICQV6jBDM2M2QlFqj3j+wNjBndVra3O6ZaZjjVhzdUYiXD
         xXaNj+AjExNsjzKQ51emHiLo7Wnb4IKpMvrwJpuboPnbjI70xtmxh8RIA1oK+oGaeghR
         qOlf6cHKAw5NuQtJm58DJPXxvPsl3flE4SLGrVs1CXXgvjVOKj3Hxg4CxWmSaQ7AePNh
         /WbNPg5kbhU/ZamkzvfLCGZU0URclGYnmpCXPk3jcEToXmDYbUOYXr+UmTazNZTVfvyq
         vS0EWUaKzwzAagEvP/oty4BhA1RlEKpHeS+HgsNOgJEATwD+0NYARQ+CF+LAQIlrcnkC
         xoHA==
X-Gm-Message-State: ACrzQf3SofgxWN7pv1fxUg4Epx78sE4Dimc6p6r2nuL+CQqgWnkuentC
        dHXR4/SBHqIqmXeAqYMjn0s=
X-Google-Smtp-Source: AMsMyM7Dq4r4eH0TBUc4++0r/HVdMb34IEY3xNIkkS+hbrE1SR6uRpXMS+qhiJ8Nd/QXukndKqEY7w==
X-Received: by 2002:a63:8942:0:b0:46e:c02e:2eaf with SMTP id v63-20020a638942000000b0046ec02e2eafmr9271878pgd.394.1667153848974;
        Sun, 30 Oct 2022 11:17:28 -0700 (PDT)
Received: from uftrace.. ([14.5.161.231])
        by smtp.gmail.com with ESMTPSA id nk21-20020a17090b195500b0020af2bab83fsm2704076pjb.23.2022.10.30.11.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Oct 2022 11:17:28 -0700 (PDT)
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
Subject: [PATCH v3] Bluetooth: Use kzalloc instead of kmalloc/memset
Date:   Mon, 31 Oct 2022 03:17:22 +0900
Message-Id: <20221030181722.34788-1-tegongkang@gmail.com>
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

Replace kmalloc+memset by kzalloc
for better readability and simplicity.

This addresses the cocci warning below:

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

