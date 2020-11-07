Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A082AA6E6
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbgKGRXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgKGRXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:23:02 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43116C0613D2;
        Sat,  7 Nov 2020 09:23:01 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id y7so4411843pfq.11;
        Sat, 07 Nov 2020 09:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Svu+8zZ1HFkOwV4kgZcEyG8KAuhCUkKQSH8fdpqwQuc=;
        b=MYWbjFmLYT8cO4Ib43c8sfdsiUN/EiEtHmO+Kv8gwdsD5UCpKjO04gnM/+3bCBE6L1
         2u+vs4qcvHaGs5aj2asgVXjv2mbLYJHBje+G2+phfNoX98BbuVnINSE11UYhiUZHbAqi
         rChP/QnrSPrkkQBuvU+RXPRm3v+qAPF4uZMhA6ARlx1uXEROI8wNpS/m/nXN8D2Sj6VR
         EsqOp4Zw/zgFDRvLOesHFq+klW0Dc5Eu/ZG68mbq1Rzo9eTHg17H+ljnH7Hc1r4WvZoI
         Hk8aCKvI8gsUHOcsDvwI/QEFfNODq2pxRUROTwRq9pEyRdYHleFQWDuBDcTeBmmBdti5
         cGQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Svu+8zZ1HFkOwV4kgZcEyG8KAuhCUkKQSH8fdpqwQuc=;
        b=B9AxAlo4UKEztgFo9HtNwzwpN1ySAnNGLMLkzv/zohTOK5Y+3X7Cu4imLdO03qdTIx
         nEC9F5d73CVcw8uvHgTBWT31dG0CrZJcLXp9QIqSFPLAktket9+lP/Gc2D4oGncgE4aK
         xG0aXAe5TMzQfG4vK1At8zN4O8W7xaYaPw51QqXjCdvqW68rmxgAsGS6dmtVjYNpHoMs
         apTeoveHIoNrWv2HQczpKGHeGm37sGBztjytS6igMXOpYIOOzbHRek/7VopB06E0LyeI
         GpaDTU+dDxUwjiZ5kU5wNlJRkfzVj6OKezHxSC2Mk9m/8kDwWgMXq0dMRJPMMcOfdKzM
         IGKg==
X-Gm-Message-State: AOAM531/gCQhcv1ZZ/vjh0pUOwlCR+sungBPiKtzlw5kFWgYcXrmyBl9
        zT+xJ/Y72payhgRDlJPB+XU=
X-Google-Smtp-Source: ABdhPJw45yizT66uymYl4g7/Fn719gVJCC+oaYIYG2LBWngS+BnKhNNmh1jzXexx3iYEjaR18BXdhA==
X-Received: by 2002:a63:4f5f:: with SMTP id p31mr6232629pgl.158.1604769780833;
        Sat, 07 Nov 2020 09:23:00 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:22:59 -0800 (PST)
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
Subject: [PATCH net v2 02/21] mac80211: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:33 +0000
Message-Id: <20201107172152.828-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: e9f207f0ff90 ("[MAC80211]: Add debugfs attributes.")
Fixes: 4b7679a561e5 ("mac80211: clean up rate control API")
Fixes: ec8aa669b839 ("mac80211: add the minstrel_ht rate control algorithm")
Fixes: 2cae0b6a70d6 ("mac80211: add new Minstrel-HT statistic output via csv")
Fixes: d0a77c6569ab ("mac80211: allow writing TX PN in debugfs")
Fixes: 8f20fc24986a ("[MAC80211]: embed key conf in key, fix driver interface")
Fixes: a75b4363eaaf ("mac80211: allow controlling aggregation manually")
Fixes: 9399b86c0e9a ("mac80211: add debug knobs for fair queuing")
Fixes: e322c07f8371 ("mac80211: debugfs: improve airtime_flags handler readability")
Fixes: 3ace10f5b5ad ("mac80211: Implement Airtime-based Queue Limit (AQL)")
Fixes: 276d9e82e06c ("mac80211: debugfs option to force TX status frames")
Fixes: 827b1fb44b7e ("mac80211: resume properly, add suspend/resume test")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline
 - Squash patches into per-driver/subsystem

 net/mac80211/debugfs.c                     | 7 +++++++
 net/mac80211/debugfs_key.c                 | 3 +++
 net/mac80211/debugfs_netdev.c              | 1 +
 net/mac80211/debugfs_sta.c                 | 2 ++
 net/mac80211/rate.c                        | 1 +
 net/mac80211/rc80211_minstrel_ht_debugfs.c | 2 ++
 6 files changed, 16 insertions(+)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 90470392fdaa..abbfc1bbdb8b 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -46,6 +46,7 @@ static const struct file_operations name## _ops = {			\
 	.read = name## _read,						\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_READONLY_FILE(name, fmt, value...)		\
@@ -148,6 +149,7 @@ static const struct file_operations aqm_ops = {
 	.read = aqm_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t airtime_flags_read(struct file *file,
@@ -201,6 +203,7 @@ static const struct file_operations airtime_flags_ops = {
 	.read = airtime_flags_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t aql_txq_limit_read(struct file *file,
@@ -282,6 +285,7 @@ static const struct file_operations aql_txq_limit_ops = {
 	.read = aql_txq_limit_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t force_tx_status_read(struct file *file,
@@ -334,6 +338,7 @@ static const struct file_operations force_tx_status_ops = {
 	.read = force_tx_status_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 #ifdef CONFIG_PM
@@ -354,6 +359,7 @@ static const struct file_operations reset_ops = {
 	.write = reset_write,
 	.open = simple_open,
 	.llseek = noop_llseek,
+	.owner = THIS_MODULE,
 };
 #endif
 
@@ -537,6 +543,7 @@ static const struct file_operations stats_ ##name## _ops = {		\
 	.read = stats_ ##name## _read,					\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_STATS_ADD(name)					\
diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 98a713475e0f..d7c0c28045ef 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -30,6 +30,7 @@ static const struct file_operations key_ ##name## _ops = {		\
 	.read = key_##name##_read,					\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define KEY_OPS_W(name)							\
@@ -38,6 +39,7 @@ static const struct file_operations key_ ##name## _ops = {		\
 	.write = key_##name##_write,					\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define KEY_FILE(name, format)						\
@@ -53,6 +55,7 @@ static const struct file_operations key_ ##name## _ops = {		\
 	.read = key_conf_##name##_read,					\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define KEY_CONF_FILE(name, format)					\
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index fe8a7a87e513..8efa31ae7334 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -127,6 +127,7 @@ static const struct file_operations name##_ops = {			\
 	.write = (_write),						\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define _IEEE80211_IF_FILE_R_FN(name)					\
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 829dcad69c2c..9ce49346c32a 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -34,6 +34,7 @@ static const struct file_operations sta_ ##name## _ops = {		\
 	.read = sta_##name##_read,					\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define STA_OPS_RW(name)						\
@@ -42,6 +43,7 @@ static const struct file_operations sta_ ##name## _ops = {		\
 	.write = sta_##name##_write,					\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define STA_FILE(name, field, format)					\
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 45927202c71c..bbb691119a44 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -225,6 +225,7 @@ const struct file_operations rcname_ops = {
 	.read = rcname_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 #endif
 
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index bebb71917742..cdb51aa460a3 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -173,6 +173,7 @@ static const struct file_operations minstrel_ht_stat_fops = {
 	.read = minstrel_stats_read,
 	.release = minstrel_stats_release,
 	.llseek = no_llseek,
+	.owner = THIS_MODULE,
 };
 
 static char *
@@ -311,6 +312,7 @@ static const struct file_operations minstrel_ht_stat_csv_fops = {
 	.read = minstrel_stats_read,
 	.release = minstrel_stats_release,
 	.llseek = no_llseek,
+	.owner = THIS_MODULE,
 };
 
 void
-- 
2.17.1

