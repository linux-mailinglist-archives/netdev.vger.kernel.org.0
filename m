Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBEA130D85
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 07:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgAFG0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 01:26:08 -0500
Received: from mail-pl1-f170.google.com ([209.85.214.170]:45559 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727438AbgAFG0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 01:26:07 -0500
Received: by mail-pl1-f170.google.com with SMTP id b22so21456908pls.12
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 22:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oF6knoEIXIh5/2ho9eTkMDQ7i4T1em2sODYcYmaIN5c=;
        b=Qx9hJxqSoeByPnDu5I6N8nLqYmnD/n/TFizYFSxkokDBcGr9HZGOz/YmHxE9KWiBQQ
         vTMdnGLmUbAzuVa8C8/5DsVHVYPsom3mnAZ6P2Y7g6qzv53Ycovd58KswcOdQStRrPEx
         QhDffY24zViPnDYARO/2ujDursTTjRJTfXW48=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oF6knoEIXIh5/2ho9eTkMDQ7i4T1em2sODYcYmaIN5c=;
        b=RKHcSXwenEdZBYmoeqy6FJItsDdterheD4OLCPWQDz/ORhc2R5Qehl+6jTP2X7KqIs
         C+mtNhsVNDfdGHjgRxN/o7bBivAayphAh5Pjxfe55TB4B98QrIVZVkIuUtUD++rZTaEh
         5gDBMSDtiQmEOOqW41n17OIX4PGZy8ueolJ9Qz6C4LRGznPoZEiUqzhtP/k6pNpJbPFD
         7Dz+FCOijycSMZ5324/4aC9zuP2ohXZ5z736wTIG54u+8f5Lcm0/rVVmR6j8fB2OQBPm
         WloVEDbXbt/ZdOjETLmedCAxyV1rUr7qhKopqRctrzjiXxRpW5FpDD2KPoSEIebLt7N6
         ed9Q==
X-Gm-Message-State: APjAAAXfl4MxgJ4/az8oTFRp+F4oni+3LzSEXZPsMolRcvvC7EZLuygs
        oUarh5NzuY1vui0pV9gZbq+g7A==
X-Google-Smtp-Source: APXvYqyoEbhHG23Net99CSVTZkoLeCXvBLndpYwq4e+TTbG9IrD3BVjtQW9FzAL0L05mswcPYvmoLw==
X-Received: by 2002:a17:90a:b10b:: with SMTP id z11mr42304735pjq.132.1578291967278;
        Sun, 05 Jan 2020 22:26:07 -0800 (PST)
Received: from Ninja.ibn.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id o16sm70704250pgl.58.2020.01.05.22.26.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 05 Jan 2020 22:26:06 -0800 (PST)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>
Cc:     vikram.prakash@broadcom.com, vasundhara-v.volam@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH v1] firmware: tee_bnxt: Reduce shm mem size to 4K
Date:   Mon,  6 Jan 2020 11:54:03 +0530
Message-Id: <1578291843-27613-2-git-send-email-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1578291843-27613-1-git-send-email-vikas.gupta@broadcom.com>
References: <1578291843-27613-1-git-send-email-vikas.gupta@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce shm memory size as maximum size supported by optee_shm_register
API is 4K.

Fixes: 246880958ac9 (“firmware: broadcom: add OP-TEE based BNXT f/w manager”)
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
---
 drivers/firmware/broadcom/tee_bnxt_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/broadcom/tee_bnxt_fw.c b/drivers/firmware/broadcom/tee_bnxt_fw.c
index 5b7ef89..8f0c61c6 100644
--- a/drivers/firmware/broadcom/tee_bnxt_fw.c
+++ b/drivers/firmware/broadcom/tee_bnxt_fw.c
@@ -12,7 +12,7 @@
 
 #include <linux/firmware/broadcom/tee_bnxt_fw.h>
 
-#define MAX_SHM_MEM_SZ	SZ_4M
+#define MAX_SHM_MEM_SZ	SZ_4K
 
 #define MAX_TEE_PARAM_ARRY_MEMB		4
 
-- 
2.7.4

