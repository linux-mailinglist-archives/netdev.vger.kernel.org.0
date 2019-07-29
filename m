Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3D378955
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbfG2KLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:11:34 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37054 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728244AbfG2KL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:11:28 -0400
Received: by mail-pg1-f194.google.com with SMTP id i70so17264829pgd.4
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 03:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hU6HZiPuN/orktWETkJg32uOAmpi81wqNjh2lz8AqtM=;
        b=GyYemxexAJj+9Xx7wOj7IgitKYg4L532uYNKd0kb0pMo/J2RGcS4vBgfgJEuMc30Br
         CadT1ZdZ4ACuPLTYQbSqPy5lHtIscXWG3Dfzp/IaDDBNF64JR8MwW49IPLPBA3gQz9/n
         rl38TVysiaUJIKY5QP8RO80ghJlVZ3kXqKdPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hU6HZiPuN/orktWETkJg32uOAmpi81wqNjh2lz8AqtM=;
        b=XA+lMYKkXz8O/B/9Sn+9Jyn7JMlk5oqmSwzomw/6StXCFYJRm7/66nhft5x/KqbLMd
         RNZbbLRXLsbhGVKJYWZVl3cDuJI3KTW8XDHTXt9unCWrqB9Lga16wpKQUd3eMJlb6/xE
         2Me4HqUXVVJYzvwTzVNN68UX0vZZV0EGUP81akxNgbPRhSjOD1AAZKBiqpNq1Ay4gCos
         02GFa3krRWZzdSPaOSjBE9vx4hwwLMT37PcS3kTJnIyg2vsns1+1ojHTYzpCU1EQ7XXH
         QR8WtBYwVn9LLl7CSFkpX2jrGPoTK0+2PTR0MwsHdNy6mhUd+A1PYiryR/Pe/efnaDvA
         IaRQ==
X-Gm-Message-State: APjAAAWzh+iXF7DN5rRqtsHZuGYEwesYSVP9MBdOAilZphL5FZL48b/T
        mcLBredK5V35scUZr7sJrdrPSg==
X-Google-Smtp-Source: APXvYqzHhOO3/6Am5wVkGw9dM3NLHkE++Q4BElCzoPUUSXZZR8HG8174Rde5d29i4zVc9lo9ONpTIg==
X-Received: by 2002:a17:90a:b312:: with SMTP id d18mr108283989pjr.35.1564395087455;
        Mon, 29 Jul 2019 03:11:27 -0700 (PDT)
Received: from localhost.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e124sm99045812pfh.181.2019.07.29.03.11.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 03:11:26 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 15/16] bnxt_en: Support all variants of the 5750X chip family.
Date:   Mon, 29 Jul 2019 06:10:32 -0400
Message-Id: <1564395033-19511-16-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
References: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define the 57508, 57504, and 57502 chip IDs that are all part of the
BNXT_CHIP_P5 family of chips.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index c61af57..e326208 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1362,7 +1362,9 @@ struct bnxt {
 
 #define CHIP_NUM_5745X		0xd730
 
-#define CHIP_NUM_57500		0x1750
+#define CHIP_NUM_57508		0x1750
+#define CHIP_NUM_57504		0x1751
+#define CHIP_NUM_57502		0x1752
 
 #define CHIP_NUM_58802		0xd802
 #define CHIP_NUM_58804		0xd804
@@ -1464,7 +1466,9 @@ struct bnxt {
 
 /* Chip class phase 5 */
 #define BNXT_CHIP_P5(bp)			\
-	((bp)->chip_num == CHIP_NUM_57500)
+	((bp)->chip_num == CHIP_NUM_57508 ||	\
+	 (bp)->chip_num == CHIP_NUM_57504 ||	\
+	 (bp)->chip_num == CHIP_NUM_57502)
 
 /* Chip class phase 4.x */
 #define BNXT_CHIP_P4(bp)			\
-- 
2.5.1

