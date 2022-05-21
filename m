Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC4D52FCA3
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 15:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354517AbiEUNOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 09:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351062AbiEUNOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 09:14:00 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CEB38BDE;
        Sat, 21 May 2022 06:13:58 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id bh5so9415864plb.6;
        Sat, 21 May 2022 06:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oLH4/O4hnVy3wOLUc8vz0oBE8xaj2C4NuAcXjfnz4nc=;
        b=niDfWBSUsX18Eo+z1BzxhZCU0ofsCu4DzD5HfoxNZ2DTnYgxx7Gju+frSRnrp+vCXH
         56FcSy+kE3Tzknxnz265wjA6qtdrDw1NHLH7gpTBurdvVMhyQfaY0IKmh7x14FEGzU1J
         sokW175+Q/YkF0Gw+GsrOdzkjO18FNWMHN1NdbBbAoMdbwIW0mTkc6R5dyILzQVh5azT
         7Ga+jYtgsuuqtCBn5LRVaIhqfvZdesaxpIyqKyAymbcjamb7ctqYXusn8eTGtzEEFGP6
         4CMKup3FFKMfsGCjPmY/nUiko07rH+dTyYeXaYgzHKD3aYcjlrH5w+6oDj6SX6PyVyaI
         MVMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oLH4/O4hnVy3wOLUc8vz0oBE8xaj2C4NuAcXjfnz4nc=;
        b=wrk5VsgdJssWNrao876mDNE2tiLGNdHfW1SIBi2LFS3nU/ITnC32Y366N1bjhoZcrg
         sNBzqGoY1iF4X4a/lE5KquoZrMIW934hbIdIRbV22CKIhvjEKNb1DTwI7oKVZ/Zxu/wA
         0EFnf3Y/XN3IY3gDk4sA/U9IBmmtEswDLFFU1NMKX6JyGttH4s9pJmLi07HqM63LmM0t
         0L52cdgI17RZcezcT/QMG3hikzu4LL9FjtNyiFz8ugfFa+qce98jgA55UIzP3nC6se0B
         DLrPzaHrDNC1x3Q8jg5lfTI3yLbGMZZSZEl8VCym7UDhiVWfn6GeUoB7haPNZkzL2/er
         4F1g==
X-Gm-Message-State: AOAM532fyjYQp0J0adzioKmSCancqTRZb+uoB7lnmcD4P0xf5UNnrQTw
        ABsyKJiB0s088HuWq+S+PIHOEZbWKlEDMQ==
X-Google-Smtp-Source: ABdhPJzKwRby6wAL6fXmsCoBg2Jo18skM3PQfHlN6h+jnaXjyVK1aQ/gnt4kwrr5w8dLwD11V0/c0A==
X-Received: by 2002:a17:90b:1b41:b0:1e0:17f:d17 with SMTP id nv1-20020a17090b1b4100b001e0017f0d17mr7128754pjb.85.1653138837559;
        Sat, 21 May 2022 06:13:57 -0700 (PDT)
Received: from localhost ([2409:10:24a0:4700:e8ad:216a:2a9d:6d0c])
        by smtp.gmail.com with ESMTPSA id y16-20020a62b510000000b0051843980605sm3593579pfe.181.2022.05.21.06.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 May 2022 06:13:57 -0700 (PDT)
From:   Stafford Horne <shorne@gmail.com>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Openrisc <openrisc@lists.librecores.org>,
        Stafford Horne <shorne@gmail.com>,
        Jonas Bonn <jonas@southpole.se>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH v3 06/13] openrisc: Update litex defconfig to support glibc userland
Date:   Sat, 21 May 2022 22:13:16 +0900
Message-Id: <20220521131323.631209-7-shorne@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220521131323.631209-1-shorne@gmail.com>
References: <20220521131323.631209-1-shorne@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have been using a litex SoC for glibc verification.  Update the
default litex config to support required userspace API's needed for the
full glibc testsuite to pass.

This includes enabling the litex mmc driver and filesystems used
in a typical litex environment.

Signed-off-by: Stafford Horne <shorne@gmail.com>
---
 arch/openrisc/configs/or1klitex_defconfig | 32 +++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/openrisc/configs/or1klitex_defconfig b/arch/openrisc/configs/or1klitex_defconfig
index d695879a4d26..d3fb964b4f85 100644
--- a/arch/openrisc/configs/or1klitex_defconfig
+++ b/arch/openrisc/configs/or1klitex_defconfig
@@ -1,22 +1,54 @@
+CONFIG_SYSVIPC=y
+CONFIG_POSIX_MQUEUE=y
+CONFIG_CGROUPS=y
+CONFIG_NAMESPACES=y
+CONFIG_USER_NS=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+CONFIG_SGETMASK_SYSCALL=y
 CONFIG_EMBEDDED=y
 CONFIG_OPENRISC_BUILTIN_DTB="or1klitex"
 CONFIG_HZ_100=y
+CONFIG_OPENRISC_HAVE_SHADOW_GPRS=y
 CONFIG_NET=y
 CONFIG_PACKET=y
+CONFIG_PACKET_DIAG=y
 CONFIG_UNIX=y
+CONFIG_UNIX_DIAG=y
 CONFIG_INET=y
+CONFIG_IP_MULTICAST=y
+CONFIG_IP_ADVANCED_ROUTER=y
+CONFIG_INET_UDP_DIAG=y
+CONFIG_INET_RAW_DIAG=y
+# CONFIG_WIRELESS is not set
+# CONFIG_ETHTOOL_NETLINK is not set
 CONFIG_DEVTMPFS=y
 CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_OF_OVERLAY=y
 CONFIG_NETDEVICES=y
 CONFIG_LITEX_LITEETH=y
+# CONFIG_WLAN is not set
 CONFIG_SERIAL_LITEUART=y
 CONFIG_SERIAL_LITEUART_CONSOLE=y
 CONFIG_TTY_PRINTK=y
+# CONFIG_GPIO_CDEV is not set
+CONFIG_MMC=y
+CONFIG_MMC_LITEX=y
+# CONFIG_VHOST_MENU is not set
+# CONFIG_IOMMU_SUPPORT is not set
 CONFIG_LITEX_SOC_CONTROLLER=y
+CONFIG_EXT2_FS=y
+CONFIG_EXT3_FS=y
+CONFIG_MSDOS_FS=y
+CONFIG_VFAT_FS=y
+CONFIG_EXFAT_FS=y
 CONFIG_TMPFS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3_ACL=y
+CONFIG_NFS_V4=y
+CONFIG_NLS_CODEPAGE_437=y
+CONFIG_NLS_ISO8859_1=y
+CONFIG_LSM="lockdown,yama,loadpin,safesetid,integrity,bpf"
 CONFIG_PRINTK_TIME=y
 CONFIG_PANIC_ON_OOPS=y
 CONFIG_SOFTLOCKUP_DETECTOR=y
-- 
2.31.1

