Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F132AA728
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbgKGRZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbgKGRZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:25:24 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DA5C0613CF;
        Sat,  7 Nov 2020 09:25:24 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id a18so4246856pfl.3;
        Sat, 07 Nov 2020 09:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sWQ6+mIEaeb7hGESflLEE3hcuFCwgRIQKA3kNoiJ/ds=;
        b=JZCQkGWaEHWS+8iZi2/aqFIW6Igg2MwEMFDuegt2mCGVOSqpaIUgLscCRkhAmgr/JG
         yK+thKsG/uz+2qpCNxRvlLUhgqVh3rC0ujiNWVCkYiml56SHOXXEFrszdO090jgyeCJe
         oDry5QPP2pU119wfMG2U0LqK/NG/eElnqKQm8b1FrNBsKK4Yw9MhL0HqCxwaL7BWHrH9
         MFLYwQk1IVIBBEwFad/8rX9AyhVjdpWrMBeajyUaGOTiqTMo5FRSW81RgVCnVuUWt/Z0
         3c4z8yhPRKloGH/kPD3KwKHMHIJfdCehfoBxovQSe/34xGzTmonMx3UrFczIH+o+6NUb
         VtOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sWQ6+mIEaeb7hGESflLEE3hcuFCwgRIQKA3kNoiJ/ds=;
        b=MkXHEqnU3TW+kUkJe2a6huSO9oJP7JmvyRMGeWrCBV53auEUw2Fy73J5SihI+pPo83
         9bl5CZF0igxZMOh3w8+AJ9ha42Jp5akm9tNDBPoKg4+f44BSYr/kFvDFTa54UxGyYXYh
         RPYwO7grzWdwG9Ogk6TyGbxjr7ILHOGb94q+AlpRYSekdEDGp1Xi1sp1UFKKnHC4sCg5
         mLicrS1q+49b8C1msLPrncNFSgNlHMb6IA0hYbZNWM9tGgoH0N8VisPY+MQ9tAESYO5q
         ZIP9irL4UwLl5kRbLoiOmLd/B+QifGPF2tjDRCs13iP56Y3IbnR2XwsOl1sl3Bu7E1Ys
         zkJg==
X-Gm-Message-State: AOAM531SaTpX67HjTYDOKARG+t+xYS59MpWWJa1zeob45hZLO5mHMcAO
        B29Dk00ROqX1017Y2CS02ig=
X-Google-Smtp-Source: ABdhPJzUR/2tceki351rShY8u3Iq4Dw70s2JbwzK9GgEd2GVdOeCaQDysl6nIqM/IitHdxfApO5zHg==
X-Received: by 2002:a62:804d:0:b029:18b:9bf:2979 with SMTP id j74-20020a62804d0000b029018b09bf2979mr6741176pfd.11.1604769923854;
        Sat, 07 Nov 2020 09:25:23 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:25:22 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, David.Laight@aculab.com,
        johannes@sipsolutions.net, nstange@suse.de, derosier@gmail.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, michael.hennerich@analog.com,
        linux-wpan@vger.kernel.org, stefan@datenfreihafen.org,
        inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        stf_xl@wp.pl, pkshih@realtek.com, ath11k@lists.infradead.org,
        ath10k@lists.infradead.org, wcn36xx@lists.infradead.org,
        merez@codeaurora.org, pizza@shaftnet.org,
        Larry.Finger@lwfinger.net, amitkarwar@gmail.com,
        ganapathi.bhat@nxp.com, huxinming820@gmail.com,
        marcel@holtmann.org, johan.hedberg@gmail.com, alex.aring@gmail.com,
        jukka.rissanen@linux.intel.com, arend.vanspriel@broadcom.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chung-hsien.hsu@infineon.com, wright.feng@infineon.com,
        chi-hsien.lin@infineon.com
Subject: [PATCH net v2 18/21] b43legacy: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:49 +0000
Message-Id: <20201107172152.828-19-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline

 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/b43legacy/debugfs.c b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
index e7e4293c01f2..7c6e7cfeb822 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
@@ -318,6 +318,7 @@ static ssize_t b43legacy_debugfs_write(struct file *file,
 			.read	= b43legacy_debugfs_read,		\
 			.write	= b43legacy_debugfs_write,		\
 			.llseek = generic_file_llseek,			\
+			.owner = THIS_MODULE,				\
 		},						\
 		.file_struct_offset = offsetof(struct b43legacy_dfsentry, \
 					       file_##name),	\
-- 
2.17.1

