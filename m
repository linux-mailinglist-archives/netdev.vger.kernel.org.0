Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFDDD529651
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 02:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbiEQA6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 20:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239719AbiEQAzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 20:55:53 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62042DEA3;
        Mon, 16 May 2022 17:55:46 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t11-20020a17090a6a0b00b001df6f318a8bso958517pjj.4;
        Mon, 16 May 2022 17:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oszu+rft9ZMt8hn3XlfQBiWXh4vkWerpEVjVpNGVwQE=;
        b=GmR3175J1QJA++Kl/bkM18GAR0pdIOR/nKTuYJ02O2yIkNWXEOJPq5w2+cfh2DL/TI
         +jpF745GD82YqiM0gAdhkEKWSc1XbAzth44QQ+UornMYJ4amJjWzRY33tQN2cmVR4ZWe
         aUt8vVXkkVq0g7off74SJU92u11TirCMvQligM3DUzTK7LwzvsjXzY8jNQyQTQVHUY6G
         Wl/ZlIgB8DVF8oJQKkNjJGtI74NFgq2+9SOhSvo8bQx38xZOaKs6snbLQD2nvg3DT4wT
         j7yJRDZp4nZL3LnHSNNdGMqGRVp+SBRs8NMW1exWDQAv5MMUkn6s4sPJL4eNLfA873eH
         Wwzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oszu+rft9ZMt8hn3XlfQBiWXh4vkWerpEVjVpNGVwQE=;
        b=veYIC+h+A4zg0b7UWqwWJlDCvLPIpRUv/1yxy+CU1IYSF6NNZ8psnOmMAveYLobQna
         5WV24ZS0mQzhki7NoxQ/CSCZUNa2HfiPkLNtnwaGg9a2xfCBPJDmgxTEPJItSaxvEkWW
         K71kzgFbEyGKo14lwtb8sts5GoBhkIRc0NZ3VVy/FHFBLAoz0JkpQ8B5MMvMYq/gGH/a
         uyX11BztmYu/rl67yBhXt3wOsrRO8/VXqo+vDaFiZhQpDhE93VfX9hBmu5lInyKzX5mG
         o8R9OOJfSY8az1n+iWoFxzUJW1r6KZATradB2fy0TcCK/2TxxjI9vzgXHvSZCjGF1VSK
         7VJQ==
X-Gm-Message-State: AOAM532+XcaJnOvigQUJUa3x3O8MimYT/47q0OUDwva7KQPenxFg8CwX
        rewvzBJenoF+SUXxSBhkAMzaV8OeOgEElw==
X-Google-Smtp-Source: ABdhPJx6yIrIZNvt4OMM4DykP/blCEK67dJ+2zkDI1WzYEMFAxHoTyKI6A15UXJyEq9tmctm+aFOgQ==
X-Received: by 2002:a17:902:ce11:b0:15f:4acc:f1fb with SMTP id k17-20020a170902ce1100b0015f4accf1fbmr19520857plg.76.1652748945576;
        Mon, 16 May 2022 17:55:45 -0700 (PDT)
Received: from localhost ([2409:10:24a0:4700:e8ad:216a:2a9d:6d0c])
        by smtp.gmail.com with ESMTPSA id p26-20020a62b81a000000b0050dc7628177sm7474333pfe.81.2022.05.16.17.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 17:55:44 -0700 (PDT)
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
Subject: [PATCH v2 06/13] openrisc: Update litex defconfig to support glibc userland
Date:   Tue, 17 May 2022 09:55:03 +0900
Message-Id: <20220517005510.3500105-7-shorne@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220517005510.3500105-1-shorne@gmail.com>
References: <20220517005510.3500105-1-shorne@gmail.com>
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

