Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2461628792B
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732014AbgJHP6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731166AbgJHP6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:58:03 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40894C0613D2;
        Thu,  8 Oct 2020 08:58:03 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id l126so4348289pfd.5;
        Thu, 08 Oct 2020 08:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GkTNl3/nsnJPBgnMSizZWf0E4PedPJPKpjsCAjH/rSI=;
        b=l9pdMfwwUkBmdUfH0BiH+l9UFVL3L4n9wEhKj6JsXB4H31pUdpiKYnKtP+FAtjb9Pv
         l3gCzsg1LMMBvnDsqMs1KlNzSPf1KVrhxGVSYPZMaOn/3ImTMJYMPJWh3BPPYLmDfUHe
         r+TnEY8wIWX7bFjbvFVCRH1/aes3F/dgmp8lzWHQzdph3WGtxo+AKihP/BQHeLuBuMhw
         z6InIOHYxFKf/G7AlGpDyRAgO2RUsi6LzWd30wzAeXTQqGyZpKB6m/Guf9sIIVyDUnfT
         jFM2nxPXaNIPtMOsI611TbsaUL2CZE/g2/VukAxuNR7yVr/5gcmSDzOdRwwiKEd9IlOG
         JjEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GkTNl3/nsnJPBgnMSizZWf0E4PedPJPKpjsCAjH/rSI=;
        b=HaT2FqLxSMyv3TAPhfDKMuJR5YETasjoZZ1Z+2n35+WeP4NI8Q+BeBmIo8nVafjKzZ
         +2LomIavaJ23vLmXF2YkQlGbtoFfszrvyWjlcmXMn18h0alXkXI0l5VIlujByh+oMUJn
         UZKe4bXPPgbySvRqgUnDZQki6fPbfRw1szv0cAukupYVx9LTz88l6SBCUwVd3+iOzTZV
         rT5ie0GaPmmhWlwrsVAO4r+XYBmpU68DGFNTEQcqiT5PS4N8esFKEk5z2LmRhSin7oLE
         HDFu0k2dnfvmUN3SAewFL+DuC8ohVgTJ4pW3QLgAjrwc95Buh6SRJPvV0I27CZxWYN9F
         zDTw==
X-Gm-Message-State: AOAM532X5Q9K8kKWGgzQ0ej1Yhk0eDOAbpJ1ezaYgGd8JAIVwEk0Upzl
        DqUbRFlV//ooWyYKDMtFEMg=
X-Google-Smtp-Source: ABdhPJyEbdiyg2r4RhJZiJRw8ba/9x4CpgA8jVNX0HpSWq/BGG/+8FzdHFnUWDmuzRfNbC7KemSmpA==
X-Received: by 2002:a17:90b:118a:: with SMTP id gk10mr8429327pjb.218.1602172682817;
        Thu, 08 Oct 2020 08:58:02 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:58:02 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 110/117] Bluetooth: set use_debug_keys_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:52:02 +0000
Message-Id: <20201008155209.18025-110-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 0886aea6acd2 ("Bluetooth: Expose debug keys usage setting via debugfs")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/bluetooth/hci_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
index 5e8af2658e44..cdf19e494c31 100644
--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -284,6 +284,7 @@ static const struct file_operations use_debug_keys_fops = {
 	.open		= simple_open,
 	.read		= use_debug_keys_read,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 static ssize_t sc_only_mode_read(struct file *file, char __user *user_buf,
-- 
2.17.1

