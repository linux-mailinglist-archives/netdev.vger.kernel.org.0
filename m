Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D712AA700
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgKGRX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgKGRXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:23:55 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B062C0613CF;
        Sat,  7 Nov 2020 09:23:55 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id m17so1005798pjz.3;
        Sat, 07 Nov 2020 09:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gtnojxwNPLzdgmwWawXjklMOz8pCiClwWa86xyzRf48=;
        b=vTujXt8BiFcOi9EOhMUnqzdTeJasNXAqMzPqgawUzcNMmO7fCN8kXxYdwYhB2bebWL
         sip6xshqalxvWP5KIH0zyZapRxmq31FYgXr4rH4wnWrSKVTb5LtltDt+nn3wgGOvpFv1
         xTf7WpRnSDDsVL+HjF+5GZ0qDBdIPngGzlvt56bI9qZgKj/9Dpx8TEnoNhhNA8WeT7C5
         k0onseQ/iRFUDRdEJ5P7ZCsuntgv/lEqPYhgn7PZ39I5sXEJ9UhR3XyWIzJdM2mcU7qD
         DwTbx4xjba4ShoeOglg7C5TJyJuDAmpVCoNtYjHOfOSmd+3xSIOyP3GemlMwVAqWYZME
         Eghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gtnojxwNPLzdgmwWawXjklMOz8pCiClwWa86xyzRf48=;
        b=MaNn8Er1M7+R2LoyYvv4dbZ1qhH/zMHfGYmJPkQAF1lhKR/iVM2D6FSH/TiAXbvEoE
         iB4xrT8/Av/2AtkJzHpJtXcwjv9/vghwgBvPq/eCGVPZ8RO/iP74dt/C5b0e0itDMUbW
         Or30yaLplTTPRu6ILA6yeOgds4HAfhrvKLOPbg0StAhAZFef2sTDoUqSbUa/FBBOoeXg
         SwVySSNOINaHGI8sZC6+XHGrNkpYiJWc5pm40ZTe61P50IXgTJxwpsDFA780X6rj+zyk
         SGdbLrB8/3AqmnicnZxRQWelmCr+gQYEucRldF5uwBWEsnY6Jw7zHUeri6+baVSgJFBx
         QpkQ==
X-Gm-Message-State: AOAM531w5bYojP4BndO034re16t1M2irAd2RzB1Ndi+gQLaRQ0fYtF6K
        rZuAFCqlXQ4r6deJrq6HRq8=
X-Google-Smtp-Source: ABdhPJwadgvZD+i+qLkY/p678kGK4NBR5zn8hdySWkJjzcB7ZlbwLPtrTPEcTBFf+kmWHek9QhxhQw==
X-Received: by 2002:a17:90a:c686:: with SMTP id n6mr1318397pjt.21.1604769834982;
        Sat, 07 Nov 2020 09:23:54 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:23:54 -0800 (PST)
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
Subject: [PATCH net v2 08/21] wl1251: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:39 +0000
Message-Id: <20201107172152.828-9-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 2f01a1f58889 ("wl12xx: add driver")
Fixes: b7339b1de0f7 ("wl1251: add tx queue status to debugfs")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline
 - Squash patches into per-driver/subsystem

 drivers/net/wireless/ti/wl1251/debugfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ti/wl1251/debugfs.c b/drivers/net/wireless/ti/wl1251/debugfs.c
index d48746e640cc..0a26cee0f287 100644
--- a/drivers/net/wireless/ti/wl1251/debugfs.c
+++ b/drivers/net/wireless/ti/wl1251/debugfs.c
@@ -35,6 +35,7 @@ static const struct file_operations name## _ops = {			\
 	.read = name## _read,						\
 	.open = simple_open,						\
 	.llseek	= generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_ADD(name, parent)					\
@@ -67,6 +68,7 @@ static const struct file_operations sub## _ ##name## _ops = {		\
 	.read = sub## _ ##name## _read,					\
 	.open = simple_open,						\
 	.llseek	= generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_FWSTATS_ADD(sub, name)				\
@@ -212,6 +214,7 @@ static const struct file_operations tx_queue_len_ops = {
 	.read = tx_queue_len_read,
 	.open = simple_open,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t tx_queue_status_read(struct file *file, char __user *userbuf,
@@ -234,6 +237,7 @@ static const struct file_operations tx_queue_status_ops = {
 	.read = tx_queue_status_read,
 	.open = simple_open,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 static void wl1251_debugfs_delete_files(struct wl1251 *wl)
-- 
2.17.1

