Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94DE33065C
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 04:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbhCHD0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 22:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233805AbhCHD0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 22:26:08 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4592CC06175F;
        Sun,  7 Mar 2021 19:26:08 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id f124so8055764qkj.5;
        Sun, 07 Mar 2021 19:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b3gaboiJgJIOoDpDuaORkzc0Km12UiNYnqNRebiTimg=;
        b=QG5aVISxQMHCusIBbqG/1x4/jf8PSgsix23YCvIMCYdJaI9Jg4x4S9Fb88c4+VP/Z0
         i5bK15x4sYmR/uGt0yYlRfrwo0evDmXwMn7u+4SnqfTX5jPsRDqHr1tgI+eoSeHk4vJq
         ypojmqOgGp7mLg4aJkvKQAiRDe8Uru3HkgYZGkADARI1OhnUTRdX1bnouH2YW2XgWtLT
         XgmfOohZcIkJ3r0xFfwkRZaWd/uk3qrNe0Rt7dFOPp9qwWtNn3oljSRs1UgZInEcbNom
         cCVraN81wrXMlVlUP28RhB0RhosE74bktTrFqIu0avC889ub45XnQAtQzDqXytsUuGjp
         RbSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b3gaboiJgJIOoDpDuaORkzc0Km12UiNYnqNRebiTimg=;
        b=NmHeLFImQyf2RRMPszAIostEs1uY4MrcawaKx6is9LskC2SABfiy3pY5SrVZxFT0yw
         0sU/wWG8jkmz5x8uo4xQPt/QwDndjElCiirGuNt9dk4KHcMbL86oMM2k7wSX9e7m1TZq
         6S6e52zffhkTvvVucW04w47p4Ug1nod6YEp/D0Ik/KrWWC3fysbtX8QbYXeYlu6RQfM8
         k4wsQSlToV7tnsX8Qz7I7T4p38bOCwMX08eLasNpdzemhEfu8qhioWq07Et5H2MNqMLU
         hy1wdCb7Pnn5yTmF4HMuCX26xpqf9tw8HOaXpGWSAaIq6u22JhFazjIVt8P7Z5/zib+k
         +4zA==
X-Gm-Message-State: AOAM53380xgc1pPIO39DnoDBJ4cKXoe5RwabiKfYlMP1V8FTXL8IdedD
        WCF8M/4k4b1CQsXq7x0zWGw=
X-Google-Smtp-Source: ABdhPJxqaxYFTley5OKVU2kFe1XuBDh0wLvDDLkSokpsCAbW7ZNyWFvf2EyrICy7H1SPrKxg5/Y0Fw==
X-Received: by 2002:a37:30f:: with SMTP id 15mr19271390qkd.494.1615173967447;
        Sun, 07 Mar 2021 19:26:07 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:99a3:37aa:84df:4276])
        by smtp.googlemail.com with ESMTPSA id r7sm339725qtm.88.2021.03.07.19.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 19:26:07 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ztong0001@gmail.com
Subject: [PATCH 3/3] atm: idt77252: fix null-ptr-dereference
Date:   Sun,  7 Mar 2021 22:25:30 -0500
Message-Id: <20210308032529.435224-4-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210308032529.435224-1-ztong0001@gmail.com>
References: <20210308032529.435224-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this one is similar to the phy_data allocation fix in uPD98402, the
driver allocate the idt77105_priv and store to dev_data but later
dereference using dev->dev_data, which will cause null-ptr-dereference.

fix this issue by changing dev_data to phy_data so that PRIV(dev) can
work correctly.

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/atm/idt77105.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/idt77105.c b/drivers/atm/idt77105.c
index 3c081b6171a8..bfca7b8a6f31 100644
--- a/drivers/atm/idt77105.c
+++ b/drivers/atm/idt77105.c
@@ -262,7 +262,7 @@ static int idt77105_start(struct atm_dev *dev)
 {
 	unsigned long flags;
 
-	if (!(dev->dev_data = kmalloc(sizeof(struct idt77105_priv),GFP_KERNEL)))
+	if (!(dev->phy_data = kmalloc(sizeof(struct idt77105_priv),GFP_KERNEL)))
 		return -ENOMEM;
 	PRIV(dev)->dev = dev;
 	spin_lock_irqsave(&idt77105_priv_lock, flags);
@@ -337,7 +337,7 @@ static int idt77105_stop(struct atm_dev *dev)
                 else
                     idt77105_all = walk->next;
 	        dev->phy = NULL;
-                dev->dev_data = NULL;
+                dev->phy_data = NULL;
                 kfree(walk);
                 break;
             }
-- 
2.25.1

