Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E7A527782
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 14:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236726AbiEOMmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 08:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbiEOMme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 08:42:34 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5557417A9A;
        Sun, 15 May 2022 05:42:29 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id h186so9056459pgc.3;
        Sun, 15 May 2022 05:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oszu+rft9ZMt8hn3XlfQBiWXh4vkWerpEVjVpNGVwQE=;
        b=QUztnKckQLs6QOL8wh+L9s4NyE/A8ErSr88cMUnsKmTDwPlNYC6Rp4+HzfVNvYV2Oa
         Q7MGVkowm1N/DDlz6Xg20X9zN3qSuCedUqwcV48ueXbh26LWmY/cpQuchz59prtRtOO5
         IrUCN1j327AKQZLblw1wKiz5B6wgpf1OMkk9wFQc0ZgEToQBhP1ina+2fwH1e+XmTzM1
         OAEoDZH9ak8dX2+IFHY18sz75yGaAcUIZ7+YmBXKk6Q9LyHAaC4kFoMdeo8uvT3jxzFU
         1y5+634tI12cXc4Lmt6sfuxj2GTmTpHINqtZx4D0oYCHh/UEFkDZXygge0r9iDfd0KA+
         wkCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oszu+rft9ZMt8hn3XlfQBiWXh4vkWerpEVjVpNGVwQE=;
        b=YbYiHbDp81wMYNkanA9RbVfvbCNMB5wU+6v4A3g4Hf6lL1AUAj/4xa0v8trhwDk86k
         2ECXgFKCxh1wHNJtM2FSJ3diMvqkPXjIkJ24xZQA9BPmQmhKlNntt4eTgfXTGgsGOv1x
         sgMGIUJQPcOQi7qV58wWCDjzb4F+EWaf2pdNBeExL/PBbBAXpUJEQd7UMOgxqs2KmuTo
         8Niqne3ORsojRXaSd30c6q1Tx5bj+zv8dX0pIwB6l6pkEwjcs1zyjMreajJS53vJKArC
         bg7CPP5ZKgXL92fLUEDwe/dhk3WezYhuYnBBkNevUU/submBI6+iL4vCpYynwPf9+S/f
         llfw==
X-Gm-Message-State: AOAM530gwJzMt3KcWSXiVgL9n7tqpJLXN+vEaZb1Y4kT4wz+jy8EnU0W
        VkIKTJar6glhz/iZ/IXfUZUF3G9q5wr2Ww==
X-Google-Smtp-Source: ABdhPJxY/yTMQfvtEzhS34eTR0MZAVjQ59q1O6m6syIwdFav8U5MnXyWVoR9IZMyQi/HTPqQgRyI8Q==
X-Received: by 2002:a63:7056:0:b0:3f2:638e:c914 with SMTP id a22-20020a637056000000b003f2638ec914mr1958482pgn.65.1652618548432;
        Sun, 15 May 2022 05:42:28 -0700 (PDT)
Received: from localhost ([2409:10:24a0:4700:e8ad:216a:2a9d:6d0c])
        by smtp.gmail.com with ESMTPSA id o8-20020a656a48000000b003c14af50622sm4957616pgu.58.2022.05.15.05.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 05:42:27 -0700 (PDT)
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
Subject: [PATCH 06/13] openrisc: Update litex defconfig to support glibc userland
Date:   Sun, 15 May 2022 21:41:51 +0900
Message-Id: <20220515124158.3167452-7-shorne@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220515124158.3167452-1-shorne@gmail.com>
References: <20220515124158.3167452-1-shorne@gmail.com>
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
 arch/openrisc/configs/or1klitex_defconfig | 33 +++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/openrisc/configs/or1klitex_defconfig b/arch/openrisc/configs/or1klitex_defconfig
index d695879a4d26..4c0138340bd9 100644
--- a/arch/openrisc/configs/or1klitex_defconfig
+++ b/arch/openrisc/configs/or1klitex_defconfig
@@ -1,22 +1,55 @@
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
+# CONFIG_OPENRISC_HAVE_INST_RORI is not set
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

