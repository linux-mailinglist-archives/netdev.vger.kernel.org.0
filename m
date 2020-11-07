Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44172AA733
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgKGRZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbgKGRZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:25:51 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0510BC0613CF;
        Sat,  7 Nov 2020 09:25:51 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id r9so1007234pjl.5;
        Sat, 07 Nov 2020 09:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cGWu/C+12zss/m0Fs14PTVMmX5fXCE6aVtGhQCZq34o=;
        b=BrNCyXb4g1Tv9yX8NCbCTj9N0/wkp/pVCnwnxvJHoQhVve5Wa82FZkR69+bPcwfZhO
         e+WJQCEOIIqlQavDblv42z9898zsBSoNK8eTlePiXBrJsW0P8+Sgb2vmpHSAeR5cgIIb
         FqsFbBbj0Iw2lQvBo6cqTqqtrnYNnNvcu+oHQZ/piAkZwUFu7eeDG7XJSUaZ/fVXLdYM
         3BAbEsKL1D405YT9k4nR2Vxh8NTZgW3wYW2IHuhd4qRml+ZxCON+gk8ay/2RSlqYf0Nf
         Srg0+q4oni6y/4y2nLqgRRwNjrmGQKEAAguYq+rvSx8ezBXBFhTP+bUX5SJeyJNZ+0wQ
         zgCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cGWu/C+12zss/m0Fs14PTVMmX5fXCE6aVtGhQCZq34o=;
        b=SqyJu1u6Iy833i5OUE1bBafdJf15sO1UynBW1Pwf1P2reR46piy9qE14hnAbTUsXxe
         8RY5FUV3F+HV0qkCD3FlZu3FtM1QZr1yFcf1nS5RSkXp0GU//6592E/2a3w48II+Qhr5
         PJICKh6O5C3Wwqp97RDRkBNkuFlJw/koy15tP2j3xB9miEZQIJ+XDYlP8ah+hS4yqAsM
         F9cAghkYertV2rfNEoVXH1BB2nd7N9KFw9BuUYmfVnFyH0tz5zO6woXHYt74M7KMuTzA
         8nSfzF2mMcrs/L/d2V1GiEufTgq47+hTRn9kzrVb2wZlhyzA/iM4kyTRBabPyPO/IrGp
         zOFw==
X-Gm-Message-State: AOAM532lS5dxtpzahx7F9VWEEf0JNRvCHv5QPrTWy2OgJCfVrsmkT+Sr
        HMB7yMmTjBzdNX1dV8uXPtM=
X-Google-Smtp-Source: ABdhPJyjOKcPOkKCrNENebDqUKKscQzxaS780dS40HVKXKhagociHFkbe8+3uUtJJMNcXcfW5mMxlw==
X-Received: by 2002:a17:90a:940c:: with SMTP id r12mr2595487pjo.107.1604769950389;
        Sat, 07 Nov 2020 09:25:50 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:25:49 -0800 (PST)
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
Subject: [PATCH net v2 21/21] Bluetooth: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:52 +0000
Message-Id: <20201107172152.828-22-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 4b4148e9acc1 ("Bluetooth: Add support for setting DUT mode")
Fixes: 4b4113d6dbdb ("Bluetooth: Add debugfs entry for setting vendor diagnostic mode")
Fixes: 300acfdec916 ("Bluetooth: Introduce force_bredr_smp debugfs option for testing")
Fixes: 64dd374eac15 ("Bluetooth: Export SMP selftest result in debugfs")
Fixes: 0886aea6acd2 ("Bluetooth: Expose debug keys usage setting via debugfs")
Fixes: 134c2a89af22 ("Bluetooth: Add debugfs entry to show Secure Connections Only mode")
Fixes: b55d1abf568c ("Bluetooth: Expose quirks through debugfs")
Fixes: 6e07231a80de ("Bluetooth: Expose Secure Simple Pairing debug mode setting in debugfs")
Fixes: ac345813c4ac ("Bluetooth: Expose current identity information in debugfs")
Fixes: c2aa30db744d ("Bluetooth: debugfs option to unset MITM flag")
Fixes: 6b8d4a6a0314 ("Bluetooth: 6LoWPAN: Use connected oriented channel instead of fixed one")
Fixes: 6de50f9fdb60 ("Bluetooth: Export ECDH selftest result in debugfs")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline
 - Squash patches into per-driver/subsystem

 net/bluetooth/6lowpan.c     | 1 +
 net/bluetooth/hci_core.c    | 2 ++
 net/bluetooth/hci_debugfs.c | 6 ++++++
 net/bluetooth/selftest.c    | 1 +
 net/bluetooth/smp.c         | 2 ++
 5 files changed, 12 insertions(+)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index cff4944d5b66..0936184f0813 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -1214,6 +1214,7 @@ static const struct file_operations lowpan_control_fops = {
 	.write		= lowpan_control_write,
 	.llseek		= seq_lseek,
 	.release	= single_release,
+	.owner		= THIS_MODULE,
 };
 
 static void disconnect_devices(void)
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 502552d6e9af..dba8506202ff 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -116,6 +116,7 @@ static const struct file_operations dut_mode_fops = {
 	.read		= dut_mode_read,
 	.write		= dut_mode_write,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 static ssize_t vendor_diag_read(struct file *file, char __user *user_buf,
@@ -172,6 +173,7 @@ static const struct file_operations vendor_diag_fops = {
 	.read		= vendor_diag_read,
 	.write		= vendor_diag_write,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 static void hci_debugfs_create_basic(struct hci_dev *hdev)
diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
index 5e8af2658e44..c9a074da16dd 100644
--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -71,6 +71,7 @@ static const struct file_operations __name ## _fops = {			      \
 	.read		= __name ## _read,				      \
 	.write		= __name ## _write,				      \
 	.llseek		= default_llseek,				      \
+	.owner		= THIS_MODULE,					      \
 }									      \
 
 #define DEFINE_INFO_ATTRIBUTE(__name, __field)				      \
@@ -284,6 +285,7 @@ static const struct file_operations use_debug_keys_fops = {
 	.open		= simple_open,
 	.read		= use_debug_keys_read,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 static ssize_t sc_only_mode_read(struct file *file, char __user *user_buf,
@@ -302,6 +304,7 @@ static const struct file_operations sc_only_mode_fops = {
 	.open		= simple_open,
 	.read		= sc_only_mode_read,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 DEFINE_INFO_ATTRIBUTE(hardware_info, hw_info);
@@ -438,6 +441,7 @@ static const struct file_operations ssp_debug_mode_fops = {
 	.open		= simple_open,
 	.read		= ssp_debug_mode_read,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 static int auto_accept_delay_set(void *data, u64 val)
@@ -726,6 +730,7 @@ static const struct file_operations force_static_address_fops = {
 	.read		= force_static_address_read,
 	.write		= force_static_address_write,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 static int white_list_show(struct seq_file *f, void *ptr)
@@ -1117,6 +1122,7 @@ static const struct file_operations force_no_mitm_fops = {
 	.read		= force_no_mitm_read,
 	.write		= force_no_mitm_write,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 DEFINE_QUIRK_ATTRIBUTE(quirk_strict_duplicate_filter,
diff --git a/net/bluetooth/selftest.c b/net/bluetooth/selftest.c
index f71c6fa65fb3..445ea247061b 100644
--- a/net/bluetooth/selftest.c
+++ b/net/bluetooth/selftest.c
@@ -194,6 +194,7 @@ static const struct file_operations test_ecdh_fops = {
 	.open		= simple_open,
 	.read		= test_ecdh_read,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 static int __init test_ecdh(void)
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index bf4bef13d935..3b91f927aab5 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -3407,6 +3407,7 @@ static const struct file_operations force_bredr_smp_fops = {
 	.read		= force_bredr_smp_read,
 	.write		= force_bredr_smp_write,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 int smp_register(struct hci_dev *hdev)
@@ -3751,6 +3752,7 @@ static const struct file_operations test_smp_fops = {
 	.open		= simple_open,
 	.read		= test_smp_read,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 static int __init run_selftests(struct crypto_shash *tfm_cmac,
-- 
2.17.1

