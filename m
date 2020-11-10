Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD2D2AD08E
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 08:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbgKJHiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 02:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgKJHiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 02:38:05 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC97C0613CF;
        Mon,  9 Nov 2020 23:38:05 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id l1so7118908wrb.9;
        Mon, 09 Nov 2020 23:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iq/ftfUT5fyKh06LGM2xX4OHrUmblBvdj19McHGYIWM=;
        b=KBO8yNX5bziqNjDrWUP0O6G7RGd0FzaGF8Mwk77jWnlkA9pFaLBUSr2Cr7U5VlbJt5
         eRY1tqr/KEOtLPYJhoDeXl/Am9M07FyzR7/qJNX001V4b1v/pkMX5UnI5OANIr4AZjp5
         s+tW5oSki49qEbj02vLpR+pjOus9Xbizr2c5yZAVt5CUe0tAGkqIixps5+w6OzM3M1re
         rPbp0Iwvn5xwwKkQmw+PbsVpQc38WUsimuUjTlxp9f1wHqK0sxfmPgFOIYNCrtwUPyTu
         2XXTgwngaivBFX4OfNGK+gKsNymYyvxTZvPkrlE19qXtRwGM994fKYNNgpx9MnXj/Fd1
         fEBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iq/ftfUT5fyKh06LGM2xX4OHrUmblBvdj19McHGYIWM=;
        b=UVCwdOXAH5IP+DALdM8HLa7yQTAmJsdB0ldISL/+LFPFDxAILIei1fhFI0OzWv/2TQ
         z/x1ikzakjLidCVB4y8SmAC+M6ypOvnOJHc6NvAXD4S4eR5hKYP4G6hseVAejW77Rn6c
         ch5VqtMwtdOwMYdQBRV+dleMd7qqda78mAGlCRU/FHMOIiFgqNAmkL/vs6yL0z7D8yJo
         aOEi0mAWuWbWVHp02txpr0JmIP0YR53WRizH8hIYlI2fPJpj77p6LIm5FqpM6bTl/UWV
         mM1tysBZAGdGqGsl9+sle5I/KJdrETWruy+PiVWCpvJ5JGl3hno6ntSHIrUfaawMxeCv
         Jrig==
X-Gm-Message-State: AOAM533bmvJDNlNIlOMjNvUBkoeOip1KcZ3JQX5s2aDs2rqmApIYXMsW
        Pcn/MxW7uVMcEKZLYrLDN0+KdfICV0k=
X-Google-Smtp-Source: ABdhPJxFe0LsmPNprAlQRXOX+aqKWAPNaEhqsg5Ntn9tH7a4mm5YsKNFqJ6Ec68myjyQ5K5YvagqEQ==
X-Received: by 2002:a5d:5752:: with SMTP id q18mr21348720wrw.176.1604993883674;
        Mon, 09 Nov 2020 23:38:03 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id h128sm2076266wme.38.2020.11.09.23.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 23:38:02 -0800 (PST)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH net/next] net: ipconfig: Avoid spurious blank lines in boot log
Date:   Tue, 10 Nov 2020 08:37:57 +0100
Message-Id: <20201110073757.1284594-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

When dumping the name and NTP servers advertised by DHCP, a blank line
is emitted if either of the lists is empty. This can lead to confusing
issues such as the blank line getting flagged as warning. This happens
because the blank line is the result of pr_cont("\n") and that may see
its level corrupted by some other driver concurrently writing to the
console.

Fix this by making sure that the terminating newline is only emitted
if at least one entry in the lists was printed before.

Reported-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 net/ipv4/ipconfig.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 561f15b5a944..3cd13e1bc6a7 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1441,7 +1441,7 @@ static int __init ip_auto_config(void)
 	int retries = CONF_OPEN_RETRIES;
 #endif
 	int err;
-	unsigned int i;
+	unsigned int i, count;
 
 	/* Initialise all name servers and NTP servers to NONE (but only if the
 	 * "ip=" or "nfsaddrs=" kernel command line parameters weren't decoded,
@@ -1575,7 +1575,7 @@ static int __init ip_auto_config(void)
 	if (ic_dev_mtu)
 		pr_cont(", mtu=%d", ic_dev_mtu);
 	/* Name servers (if any): */
-	for (i = 0; i < CONF_NAMESERVERS_MAX; i++) {
+	for (i = 0, count = 0; i < CONF_NAMESERVERS_MAX; i++) {
 		if (ic_nameservers[i] != NONE) {
 			if (i == 0)
 				pr_info("     nameserver%u=%pI4",
@@ -1583,12 +1583,14 @@ static int __init ip_auto_config(void)
 			else
 				pr_cont(", nameserver%u=%pI4",
 					i, &ic_nameservers[i]);
+
+			count++;
 		}
-		if (i + 1 == CONF_NAMESERVERS_MAX)
+		if ((i + 1 == CONF_NAMESERVERS_MAX) && count > 0)
 			pr_cont("\n");
 	}
 	/* NTP servers (if any): */
-	for (i = 0; i < CONF_NTP_SERVERS_MAX; i++) {
+	for (i = 0, count = 0; i < CONF_NTP_SERVERS_MAX; i++) {
 		if (ic_ntp_servers[i] != NONE) {
 			if (i == 0)
 				pr_info("     ntpserver%u=%pI4",
@@ -1596,8 +1598,10 @@ static int __init ip_auto_config(void)
 			else
 				pr_cont(", ntpserver%u=%pI4",
 					i, &ic_ntp_servers[i]);
+
+			count++;
 		}
-		if (i + 1 == CONF_NTP_SERVERS_MAX)
+		if ((i + 1 == CONF_NTP_SERVERS_MAX) && count > 0)
 			pr_cont("\n");
 	}
 #endif /* !SILENT */
-- 
2.29.2

