Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3131A2AA6E2
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbgKGRWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgKGRWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:22:53 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA6CC0613CF;
        Sat,  7 Nov 2020 09:22:52 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id r9so1004865pjl.5;
        Sat, 07 Nov 2020 09:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CiDS6Teu78wmWygf2J2zdXtriik6tBTmq5dTYnwE40o=;
        b=tCgApyOqPT+RZAX5zLv9TE7h+GzvOLEXvLP8T1DpB2w+OaCLTTk5xtxuDwixegEQkW
         MaheBhqBA5iiP6GvAKyxHdD5e8ubUr2YEBqD2BiiSczsFQUVYMDLSmppUaOyR2zccweL
         dukM+4mWPc7gDMT/oPFU3v9J63IZY9qxpqJzUD7CB+UQWCrJMT5vHFvZ4DM3wrWd99kP
         JgIOoLiNk+2xhNBGWH+fO8R1lZipfpO2+MEMrdedtudBGpRbGA5zea1A9/aW6UKYbbnV
         WBS2l56e+LtqS9NU9CtYPU03HRViedTLeoWvgl0JXmcdvemq0aVsylLk36kbuWmuraEy
         W91A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CiDS6Teu78wmWygf2J2zdXtriik6tBTmq5dTYnwE40o=;
        b=rQldtJeFVRyQbo7tMzEd7g9oswGTDm8uXt5ov3s+L6gQUiFiRKLt0Zuaq2yQyRW/wf
         mzj4F7fdV/IxhpAynfEd2c9ELpi8asMNHQXi8AzBM6VE0tkRGBcmM7yHWcstR5A6BUsr
         Fm8CpXIA47hGP2HzPR9LTO7D3RwC1sagePQk13B2C6NrDrKa6q41nL75fHXxT50KSUmI
         a7EKdalAj6yDLM8QNW37tMwQax/Dm7Pmvpjq8dAtnvxVs9otFH9e3TAW/xaQjoBrUKN5
         R+YfaF+SbUzajru7l+vrMDQrFqTjrkGgi8k75E1BTReTMunlL2Vy6mBj6H57HENZsHC1
         IXPg==
X-Gm-Message-State: AOAM531Nn9n9mmUkcYqPxYr4MQLvvpAvGqcV4B/kvAd7k+vr9A3s7K2/
        xJVLWpfZHU5ljFBAd6Bh+Xs=
X-Google-Smtp-Source: ABdhPJyKBW8P+7OQmuvTY1J/Yv9saMA6cBcGLM77v9zrCJXHc1wUWn9jrHDjVOPNdNz1Nyt5SRLR/Q==
X-Received: by 2002:a17:902:b711:b029:d3:f1e5:c9c1 with SMTP id d17-20020a170902b711b02900d3f1e5c9c1mr3207871pls.3.1604769771923;
        Sat, 07 Nov 2020 09:22:51 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:22:51 -0800 (PST)
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
Subject: [PATCH net v2 01/21] net: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:32 +0000
Message-Id: <20201107172152.828-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 9e466250ede3 ("batman-adv: Prefix bat_debugfs local static functions with batadv_")
Fixes: 5609c185f24d ("6lowpan: iphc: add support for stateful compression")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline
 - Squash patches into per-driver/subsystem

 net/6lowpan/debugfs.c | 1 +
 net/batman-adv/log.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/6lowpan/debugfs.c b/net/6lowpan/debugfs.c
index 1c140af06d52..2f791ccc783b 100644
--- a/net/6lowpan/debugfs.c
+++ b/net/6lowpan/debugfs.c
@@ -161,6 +161,7 @@ static const struct file_operations lowpan_ctx_pfx_fops = {
 	.write		= lowpan_ctx_pfx_write,
 	.llseek		= seq_lseek,
 	.release	= single_release,
+	.owner          = THIS_MODULE,
 };
 
 static void lowpan_dev_debugfs_ctx_init(struct net_device *dev,
diff --git a/net/batman-adv/log.c b/net/batman-adv/log.c
index a67b2b091447..c0ca5fbe5b08 100644
--- a/net/batman-adv/log.c
+++ b/net/batman-adv/log.c
@@ -180,6 +180,7 @@ static const struct file_operations batadv_log_fops = {
 	.read           = batadv_log_read,
 	.poll           = batadv_log_poll,
 	.llseek         = no_llseek,
+	.owner          = THIS_MODULE,
 };
 
 /**
-- 
2.17.1

