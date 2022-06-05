Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020FB53DCFB
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 18:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351214AbiFEQZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 12:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243238AbiFEQZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 12:25:44 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526614B1D7;
        Sun,  5 Jun 2022 09:25:41 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id x75so6040407qkb.12;
        Sun, 05 Jun 2022 09:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jzeOZTwN2f/J/OJcQ9lpgGCRe+zk8pQI2TCaiI73TRE=;
        b=VESAxWS8qarvWfNFu+/pNRu1oyDb4QAYE20AGmuwGmmwtvgDBIRdINCzScuCqhrQEP
         nbSG/eWvfIV5IwD2Q6ELfgUbJ/QwBpMevOuJcrn2Tngbym4mYmsGCZTLJ3LY57euVqhz
         BNV/sUJ3z6FfgMKAUKKs6Zve6jpr7mwQZ/1faxmZN7hTQBmvONTBwrpz0r2l/DwQF5kL
         eSg4WAvBUJ8smR1gnsbOLCG0J2qQ2XNlhflL1x6qhXBeaCyDbq0JO4fPIpUEpg64L13Q
         VQc9SsexygxMUL6+inGUiJlHsPRdMR3VouzVHHG1VZJqh0y/2yySFMlDkxK8bSjos+N8
         mCVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jzeOZTwN2f/J/OJcQ9lpgGCRe+zk8pQI2TCaiI73TRE=;
        b=HMRH90a9gBVoXPEAMB47m5ZpZeDS/R/t7nE1uEYTCUojDlEr8nEQAVaTLjtQObV6Ub
         nbnV2arqv5q709H9O1Np+5+Y9osZ+v0rezP0KdLzWvjyJp0XDkW0XskD7XnDOYeDh0kX
         /oaBAJaESkFQVlJu9a/9k/lLfahpWjMVTBOza2KIZz4JTaQDt2qX8gLBnS6lm7YUrfGc
         fTq9w4y/897OhgkqRTgG8qnNmq+0ABniob1mdUU6wfs13SiIMOM6Us5CNOn+76vghh4u
         WjJJ8wjkzkzfkjrJ17zggjaH/57rGVdvnXl+mX4MeKNXX4sseh06fLK7QVXxC89GYiou
         Reug==
X-Gm-Message-State: AOAM530Dvgh5iXzwH+k59wbYVoV+UhhaeISGrcAaadFcbwAnCUDNzC9V
        mnQ0M+xHSzfsez3onox3WjE=
X-Google-Smtp-Source: ABdhPJwCwdzIOy3Bqh7K3E9XuHVpb5kIfVWzXT4od4LeMn8TqqOzG0zxkJg3OHcxYC2bclNuuBBwQg==
X-Received: by 2002:a37:742:0:b0:6a6:9ed5:14ee with SMTP id 63-20020a370742000000b006a69ed514eemr8450287qkh.124.1654446340313;
        Sun, 05 Jun 2022 09:25:40 -0700 (PDT)
Received: from localhost (c-69-254-185-160.hsd1.fl.comcast.net. [69.254.185.160])
        by smtp.gmail.com with ESMTPSA id 21-20020ac84e95000000b002f90a33c78csm9341222qtp.67.2022.06.05.09.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jun 2022 09:25:39 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Guo Ren <guoren@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        torvalds@linux-foundation.org
Subject: [PATCH] net/bluetooth: fix erroneous use of bitmap_from_u64()
Date:   Sun,  5 Jun 2022 09:25:37 -0700
Message-Id: <20220605162537.1604762-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
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

The commit 0a97953fd221 ("lib: add bitmap_{from,to}_arr64") changed
implementation of bitmap_from_u64(), so that it doesn't typecast
argument to u64, and actually dereferences memory.

With that change, compiler spotted few places in bluetooth code
where bitmap_from_u64 is called for 32-bit variable.

As reported by Sudip Mukherjee:

"arm allmodconfig" fails with the error:

In file included from ./include/linux/string.h:253,
                 from ./include/linux/bitmap.h:11,
                 from ./include/linux/cpumask.h:12,
                 from ./include/linux/smp.h:13,
                 from ./include/linux/lockdep.h:14,
                 from ./include/linux/mutex.h:17,
                 from ./include/linux/rfkill.h:35,
                 from net/bluetooth/hci_core.c:29:
In function 'fortify_memcpy_chk',
    inlined from 'bitmap_copy' at ./include/linux/bitmap.h:254:2,
    inlined from 'bitmap_copy_clear_tail' at ./include/linux/bitmap.h:263:2,
    inlined from 'bitmap_from_u64' at ./include/linux/bitmap.h:540:2,
    inlined from 'hci_bdaddr_list_add_with_flags' at net/bluetooth/hci_core.c:2156:2:
./include/linux/fortify-string.h:344:25: error: call to '__write_overflow_field' declared with attribute warning:
+detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
  344 |                         __write_overflow_field(p_size_field, size);

And, "csky allmodconfig" fails with the error:

In file included from ./include/linux/cpumask.h:12,
                 from ./include/linux/mm_types_task.h:14,
                 from ./include/linux/mm_types.h:5,
                 from ./include/linux/buildid.h:5,
                 from ./include/linux/module.h:14,
                 from net/bluetooth/mgmt.c:27:
In function 'bitmap_copy',
    inlined from 'bitmap_copy_clear_tail' at ./include/linux/bitmap.h:263:2,
    inlined from 'bitmap_from_u64' at ./include/linux/bitmap.h:540:2,
    inlined from 'set_device_flags' at net/bluetooth/mgmt.c:4534:4:
./include/linux/bitmap.h:254:9: error: 'memcpy' forming offset [4, 7] is out of the bounds [0, 4] of object 'flags'
+with type 'long unsigned int[1]' [-Werror=array-bounds]
  254 |         memcpy(dst, src, len);
      |         ^~~~~~~~~~~~~~~~~~~~~
In file included from ./include/linux/kasan-checks.h:5,
                 from ./include/asm-generic/rwonce.h:26,
                 from ./arch/csky/include/generated/asm/rwonce.h:1,
                 from ./include/linux/compiler.h:248,
                 from ./include/linux/build_bug.h:5,
                 from ./include/linux/container_of.h:5,
                 from ./include/linux/list.h:5,
                 from ./include/linux/module.h:12,
                 from net/bluetooth/mgmt.c:27:
net/bluetooth/mgmt.c: In function 'set_device_flags':
net/bluetooth/mgmt.c:4532:40: note: 'flags' declared here
 4532 |                         DECLARE_BITMAP(flags, __HCI_CONN_NUM_FLAGS);
      |                                        ^~~~~
./include/linux/types.h:11:23: note: in definition of macro 'DECLARE_BITMAP'
   11 |         unsigned long name[BITS_TO_LONGS(bits)]

Fix it by replacing bitmap_from_u64 with bitmap_from_arr32.

Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 net/bluetooth/hci_core.c | 2 +-
 net/bluetooth/mgmt.c     | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 5abb2ca5b129..2de7e1ec4035 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2153,7 +2153,7 @@ int hci_bdaddr_list_add_with_flags(struct list_head *list, bdaddr_t *bdaddr,
 
 	bacpy(&entry->bdaddr, bdaddr);
 	entry->bdaddr_type = type;
-	bitmap_from_u64(entry->flags, flags);
+	bitmap_from_arr32(entry->flags, &flags, 32);
 
 	list_add(&entry->list, list);
 
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 74937a834648..b63025c70c2c 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4519,7 +4519,8 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 							      cp->addr.type);
 
 		if (br_params) {
-			bitmap_from_u64(br_params->flags, current_flags);
+			bitmap_from_arr32(br_params->flags, &current_flags,
+					  __HCI_CONN_NUM_FLAGS);
 			status = MGMT_STATUS_SUCCESS;
 		} else {
 			bt_dev_warn(hdev, "No such BR/EDR device %pMR (0x%x)",
@@ -4531,7 +4532,7 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 		if (params) {
 			DECLARE_BITMAP(flags, __HCI_CONN_NUM_FLAGS);
 
-			bitmap_from_u64(flags, current_flags);
+			bitmap_from_arr32(flags, &current_flags, __HCI_CONN_NUM_FLAGS);
 
 			/* Devices using RPAs can only be programmed in the
 			 * acceptlist LL Privacy has been enable otherwise they
@@ -4546,7 +4547,7 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 				goto unlock;
 			}
 
-			bitmap_from_u64(params->flags, current_flags);
+			bitmap_from_arr32(params->flags, &current_flags, __HCI_CONN_NUM_FLAGS);
 			status = MGMT_STATUS_SUCCESS;
 
 			/* Update passive scan if HCI_CONN_FLAG_DEVICE_PRIVACY
-- 
2.32.0

