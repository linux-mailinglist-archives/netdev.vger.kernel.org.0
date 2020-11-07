Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB4E2AA730
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbgKGRZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbgKGRZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:25:42 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040DAC0613CF;
        Sat,  7 Nov 2020 09:25:42 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id t22so2460513plr.9;
        Sat, 07 Nov 2020 09:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3mCRQwzMlvyIXUL9jNNxjMBdUUyjiqAr7lrzvqU4ySA=;
        b=nHASIL7RXHI4gHQneP0FYxlVJ4fx7R5mbzGegaL1Ner9rQrSPd8p32XH6h2oqyvcTS
         Xa+uf9k/8FdF2rZaMQ8Q3yOzzgkAPsJ0CDWmz6p8TzOzWN07okeNsR5VjEJCDeOVHSys
         Sr6N6QrTALmEQkR3e/ELScthBfFDRT5e2WfHQDKZYsxiUvSHgP8j1so9UoVYPH9F2Jov
         +DM3PG+KHnCybCOh1SX2Vdx66VZDTlda0L4ihe/cqP+yUuo/w9kgXdDabbeEKr7Tx0e8
         EIB936AgW/1/d2GnxwudNBc7K2yqARNKvNwTK5Tje67S0US30c6qXxDN4XtYdN+eBOoz
         ay5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3mCRQwzMlvyIXUL9jNNxjMBdUUyjiqAr7lrzvqU4ySA=;
        b=JrXosW8GBucIdgOwTK8e3hiRCaPOxxWilCKaxQJxnle0uBwAgjhg1KD7E3ZObtm8cd
         rcaYOTniap+arB7KBL21wUJ+/2fSqa9kz06arLnQ7VXC+jf3E8sODWa8LTrSuI52KFYp
         GHUIP5lu7gyTNRd9v5hW4a3gDCSVXmJ1m1MRKTPmI+4xaBC2slpEN7aFzFLVV9fyLB9I
         uCWFwVrmPuSQMBFnF1SIPZ32TP46GGlIL9+wbvQxcIJf4j0XQJb5DDvTxczZ+dDAHsNL
         a/TG+nFxmqDkP9lDWErMfjYGZd4VixWpIbWzI3GsBthOVERYYSTMAMohhDCy5P28B8XE
         Qk1g==
X-Gm-Message-State: AOAM531UZdPTT61AnjmbDEg413umQqCrljxsadFq87Vmc45C9TOtVCM+
        nIvdI3GNREBU0a3nR7pp2/A=
X-Google-Smtp-Source: ABdhPJwQM/+tDsY/mm9rWSw88wITFlVZJLf1XLdnYL5pnL7fOvtiQ6SFPegBXj/ZDTOoeRKlP3sKdw==
X-Received: by 2002:a17:902:c142:b029:d6:ac10:6d25 with SMTP id 2-20020a170902c142b02900d6ac106d25mr6198782plj.37.1604769941511;
        Sat, 07 Nov 2020 09:25:41 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:25:40 -0800 (PST)
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
Subject: [PATCH net v2 20/21] mwifiex: mwifiex: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:51 +0000
Message-Id: <20201107172152.828-21-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline
 - Squash patches into per-driver/subsystem

 drivers/net/wireless/marvell/mwifiex/debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c b/drivers/net/wireless/marvell/mwifiex/debugfs.c
index dded92db1f37..641113260439 100644
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
+++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -931,18 +931,21 @@ static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 	.read = mwifiex_##name##_read,                                  \
 	.write = mwifiex_##name##_write,                                \
 	.open = simple_open,                                            \
+	.owner = THIS_MODULE,						\
 };
 
 #define MWIFIEX_DFS_FILE_READ_OPS(name)                                 \
 static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 	.read = mwifiex_##name##_read,                                  \
 	.open = simple_open,                                            \
+	.owner = THIS_MODULE,						\
 };
 
 #define MWIFIEX_DFS_FILE_WRITE_OPS(name)                                \
 static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 	.write = mwifiex_##name##_write,                                \
 	.open = simple_open,                                            \
+	.owner = THIS_MODULE,						\
 };
 
 
-- 
2.17.1

