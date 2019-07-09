Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36E9D62E59
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfGICxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:53:51 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33547 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfGICxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:53:50 -0400
Received: by mail-qt1-f193.google.com with SMTP id h24so20253848qto.0
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 19:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7ZeutNI2A2/MuD9M2WzG56pfmEYpQAngxaUnCYp7Sv8=;
        b=GLqvN/uYaS6D9NJ8bWjScdPXOFDswhwx1zm/ZgqgySfN5qIwhlgkZSY1CXqgBDXhtK
         gPE1PuYB5O8vQ4Ehs9NevymOO0PAxQxWbu8zZ1gUrj6EYL+kq2DXEZKqYxMHsONA98Lx
         cS5NYXJ6eKyx7zRYbLyKc9KDFC53bBXMpFdp1eLqsSnsExfhdayfaSdKoiwSsGDVFaZF
         Q62wk2XW1ixO9Z5un19TdG1Q5ghch8hR9KWRzLzEizsvvuV3jHcuZnOI4UXUalb0/thL
         wseXmiAnPlR81J2LSxQkLVbQEoGZqU8TiJcH+cyij4aeR+g3jXzqRMpyGBo8tPETlfgw
         6cdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7ZeutNI2A2/MuD9M2WzG56pfmEYpQAngxaUnCYp7Sv8=;
        b=m61WlTuoXy1Sfpfto49RexoR9UcpAJUGKxKoFOJCEKNaiT+Hdow1BDaZ1NWAZkN1hZ
         sVitmCfIO1i8ijT5WeJwW055WzlWTPRUpPhAN0a385d9JmasmVr8z9CtWzC26eKxu3CI
         5JLFHRu1K7VwSbve+83ZJJ7u2574iiNfoq5hjjFnbeUv9N9+JovH1VhfJW8soSUNp5sh
         FKfPFcN2vloTaLAohHtdnAmapCVpyrm5OxvmIRXvX0vA9mAXZ+q7yFzGESU+DDDYfIYO
         II+C1KYfAYrDVekWGFtyQmG6cQG9HnEa5UTTOhb1nv42PsbRLFKWDY8Lr+zRXks768gA
         5Lig==
X-Gm-Message-State: APjAAAX+FCCt3PZAMmkx8cwlQErJho/M2c5Q2jdHvApPyI2+xmslE+f1
        l2PFovrkfg8uot0RiJ/Mi0ex2Q==
X-Google-Smtp-Source: APXvYqyfm12ACrCzBEAwcsw6UbY03kiJ5AJKV5SyGZiwicn6YJtuLP+Mi7dBs+tSJgVONmNA1RrEXQ==
X-Received: by 2002:ac8:67d1:: with SMTP id r17mr16293411qtp.11.1562640829918;
        Mon, 08 Jul 2019 19:53:49 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g13sm8148837qkm.17.2019.07.08.19.53.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 19:53:49 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 04/11] nfp: ccm: increase message limits
Date:   Mon,  8 Jul 2019 19:53:11 -0700
Message-Id: <20190709025318.5534-5-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190709025318.5534-1-jakub.kicinski@netronome.com>
References: <20190709025318.5534-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Increase the batch limit to consume small message bursts more
effectively. Practically, the effect on the 'add' messages is not
significant since the mailbox is sized such that the 'add' messages are
still limited to the same order of magnitude that it was originally set
for.

Furthermore, increase the queue size limit to 1024 entries. This further
improves the handling of bursts of small control messages.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/ccm_mbox.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/ccm_mbox.c b/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
index d160ac794d98..f0783aa9e66e 100644
--- a/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
+++ b/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
@@ -13,7 +13,7 @@
  * form a batch.  Threads come in with CMSG formed in an skb, then
  * enqueue that skb onto the request queue.  If threads skb is first
  * in queue this thread will handle the mailbox operation.  It copies
- * up to 16 messages into the mailbox (making sure that both requests
+ * up to 64 messages into the mailbox (making sure that both requests
  * and replies will fit.  After FW is done processing the batch it
  * copies the data out and wakes waiting threads.
  * If a thread is waiting it either gets its the message completed
@@ -23,9 +23,9 @@
  * to limit potential cache line bounces.
  */
 
-#define NFP_CCM_MBOX_BATCH_LIMIT	16
+#define NFP_CCM_MBOX_BATCH_LIMIT	64
 #define NFP_CCM_TIMEOUT			(NFP_NET_POLL_TIMEOUT * 1000)
-#define NFP_CCM_MAX_QLEN		256
+#define NFP_CCM_MAX_QLEN		1024
 
 enum nfp_net_mbox_cmsg_state {
 	NFP_NET_MBOX_CMSG_STATE_QUEUED,
-- 
2.21.0

