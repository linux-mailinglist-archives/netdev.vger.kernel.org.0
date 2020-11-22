Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377E82BC5A8
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 13:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgKVMlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 07:41:21 -0500
Received: from m12-15.163.com ([220.181.12.15]:54667 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727634AbgKVMlU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Nov 2020 07:41:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=b8Hav6Ucjm73NF9mhy
        msARsSWYvA0cFZJwMIjRxo4pY=; b=XVYP6t7VNSCfEs2FJnuoM7FWO4hJTjbamK
        e0MVzfE0i3+7oPJ9BGGPTgqUMzulGu8aUHS9d9pkezXbm2ru//ExNfsOcUngQlhT
        GLQog8FW93nA0dIjZXzovyv0tGPFBnVKwdD6RjCQnIT7Efc7/cl/zTJeZY4hzW42
        hvzcwrEAo=
Received: from hby-server.localdomain (unknown [27.18.76.181])
        by smtp11 (Coremail) with SMTP id D8CowADHtCpIOLpfyZICCg--.9687S2;
        Sun, 22 Nov 2020 18:07:04 +0800 (CST)
From:   hby <hby2003@163.com>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hby <hby2003@163.com>
Subject: [PATCH] drivers: Fix the Raspberry Pi debug version compile
Date:   Sun, 22 Nov 2020 18:06:06 +0800
Message-Id: <20201122100606.20289-1-hby2003@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: D8CowADHtCpIOLpfyZICCg--.9687S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CrW3CF18trWDGF4fZry3twb_yoW8Jw1rpa
        nrJa4qkr1Uu3yak3y0yFsrAFyfKas7WwnFkay8u3y3uF1kAw4Fqr40gFWIkr15uFWxC3y7
        AFWvq3sxJFsrKa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U6MKNUUUUU=
X-Originating-IP: [27.18.76.181]
X-CM-SenderInfo: hke1jiiqt6il2tof0z/1tbiQAjkHFSIhEeThQAAs5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

enable the DEBUG in source code, and it will compile fail,
modify the DEBUG macro, to adapt the compile

Signed-off-by: hby <hby2003@163.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index 4146faeed..c2eb3aa67 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -60,7 +60,7 @@ void __brcmf_err(struct brcmf_bus *bus, const char *func, const char *fmt, ...);
 				  ##__VA_ARGS__);			\
 	} while (0)
 
-#if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
+#if defined(CONFIG_BRCM_TRACING) || defined(CONFIG_BRCMDBG)
 
 /* For debug/tracing purposes treat info messages as errors */
 #define brcmf_info brcmf_err
@@ -114,7 +114,7 @@ extern int brcmf_msg_level;
 
 struct brcmf_bus;
 struct brcmf_pub;
-#ifdef DEBUG
+#if defined(CONFIG_BRCMDBG)
 struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr);
 void brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
 			     int (*read_fn)(struct seq_file *seq, void *data));
-- 
2.17.1


