Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE51294B70
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 12:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438911AbgJUKti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 06:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438817AbgJUKtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 06:49:36 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E900C0613CE;
        Wed, 21 Oct 2020 03:49:36 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t14so1273955pgg.1;
        Wed, 21 Oct 2020 03:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E0yCY0SpftLklX9lkt/4glAUkm5pgCK2Z2FzzS9HyFU=;
        b=oc8KRxpjuJiPdA4l3XqT8vaCubaCZmHuJ+6um00UCj0QKc7cIX2Nu201/Ym3hTTTrR
         INljYBVSKf5bahcYmwPzkQx7/eBXKY9LmPgPHTIYJxn8AsEUtKW5XqDdZUCmuh9LGnLI
         K/wA4PCotmlkIclEh3YvOJBFo93LJ1NGA7BYNNvrIFlHYBrFffepK4XIdmLHxrONB97c
         U4UxInr0tW69H0ycDUm0kgq+J3OofKhcPorQDFv7EdAnF/A/XZPRJaGKajTZcoYQJn49
         bmxfftVmTTE35+Efj04f6gGnMfwacpfc6J4+mSzaLDNUORyEznrWNIG2ldb1SI6F3wnY
         YVzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E0yCY0SpftLklX9lkt/4glAUkm5pgCK2Z2FzzS9HyFU=;
        b=eb/h/SLY4qa4iwp3vfXOJsv6wnq85CAyl71QEHJW+OkezrXa8H1TM9ztfxMGU5yHGY
         iwYAgVYSu0jQdyuwhBKfmEjtzyXMEBvJvq3zA0w8CSMXdd3Ux1h6be4DLp18rkt+U+wt
         xtbPqklFlUYcbuiH/ZD7l1hrs9AynOVZDzMgzQ+/Mgn+DvY9JSO1xFTJ0lVlU8xMytbu
         UFyEDWWG1KkRG+LPhgya4wkivUE2F2qI1/PyPP/Kc4S1I2Wc0sofnhxSUBJpktUlByrv
         aLhP5h1tTI8h0ASfIoBlmfXnL3askzK+Jc3O1Pr9TLg6UTk0Jb/MW4a3AUYW/MA541CR
         S5Ig==
X-Gm-Message-State: AOAM531uxwiNVfEF0/6Yn5LI7a5x8JrwgGBL624njbQKCdXBcMaEQQkX
        LuO+FAR6lHNJz5gmuvKkuaY=
X-Google-Smtp-Source: ABdhPJxGT9OgVDbZXxMFh3A/vyQWIzgIUV5BrZbI/T2RjJx4MMxWu/gfzakiWFGbSUIWgj1RHZ1vzQ==
X-Received: by 2002:a63:1f03:: with SMTP id f3mr2717149pgf.381.1603277376081;
        Wed, 21 Oct 2020 03:49:36 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:6caa:ebf2:3bbb:f04e])
        by smtp.gmail.com with ESMTPSA id k8sm2149422pgi.39.2020.10.21.03.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 03:49:35 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next RFC] net: dlci: Deprecate the DLCI driver (aka the Frame Relay layer)
Date:   Wed, 21 Oct 2020 03:49:28 -0700
Message-Id: <20201021104928.599621-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I wish to deprecate the Frame Relay layer (dlci.c) in the kernel because
we already have a newer and better "HDLC Frame Relay" layer (hdlc_fr.c).

Reasons why hdlc_fr.c is better than dlci.c include:

1.
dlci.c is dated 1997, while hdlc_fr.c is dated 1999 - 2006, so the later
is newer than the former.

2.
hdlc_fr.c is working well (tested by me). For dlci.c, I cannot even find
the user space problem needed to use it. The link provided in
Documentation/networking/framerelay.rst (in the last paragraph) is no
longer valid.

3.
dlci.c supports only one hardware driver - sdla.c, while hdlc_fr.c
supports many hardware drivers through the generic HDLC layer (hdlc.c).

WAN hardware devices are usually able to support several L2 protocols
at the same time, so the HDLC layer is more suitable for these devices.

The hardware devices that sdla.c supports are also multi-protocol
(according to drivers/net/wan/Kconfig), so the HDLC layer is more
suitable for these devices, too.

4.
hdlc_fr.c supports LMI and supports Ethernet emulation. dlci.c supports
neither according to its code.

5.
include/uapi/linux/if_frad.h, which comes with dlci.c, contains two
structs for ioctl configs (dlci_conf and frad_conf). According to the
comments, these two structs are specially crafted for sdla.c (the only
hardware driver dlci.c supports). I think this makes dlci.c not generic
enough to support other hardware drivers.

Cc: Lee Jones <lee.jones@linaro.org>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 Documentation/networking/framerelay.rst | 3 +++
 drivers/net/wan/dlci.c                  | 2 ++
 drivers/net/wan/sdla.c                  | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/Documentation/networking/framerelay.rst b/Documentation/networking/framerelay.rst
index 6d904399ec6d..bfbbaa531d8b 100644
--- a/Documentation/networking/framerelay.rst
+++ b/Documentation/networking/framerelay.rst
@@ -4,6 +4,9 @@
 Frame Relay (FR)
 ================
 
+Note that the Frame Relay layer is deprecated. New drivers should use the HDLC
+Frame Relay layer instead.
+
 Frame Relay (FR) support for linux is built into a two tiered system of device
 drivers.  The upper layer implements RFC1490 FR specification, and uses the
 Data Link Connection Identifier (DLCI) as its hardware address.  Usually these
diff --git a/drivers/net/wan/dlci.c b/drivers/net/wan/dlci.c
index 3ca4daf63389..98cb023f08ac 100644
--- a/drivers/net/wan/dlci.c
+++ b/drivers/net/wan/dlci.c
@@ -514,6 +514,8 @@ static int __init init_dlci(void)
 	register_netdevice_notifier(&dlci_notifier);
 
 	printk("%s.\n", version);
+	pr_warn("The DLCI driver (the Frame Relay layer) is deprecated.\n"
+		"Please move your driver to using the HDLC Frame Relay instead.\n");
 
 	return 0;
 }
diff --git a/drivers/net/wan/sdla.c b/drivers/net/wan/sdla.c
index bc2c1c7fb1a4..21d4cf06d6af 100644
--- a/drivers/net/wan/sdla.c
+++ b/drivers/net/wan/sdla.c
@@ -1623,6 +1623,9 @@ static int __init init_sdla(void)
 	int err;
 
 	printk("%s.\n", version);
+	pr_warn("The SDLA driver is deprecated.\n"
+		"If you are still using the hardware,\n"
+		"please help move this driver to using the HDLC Frame Relay layer.\n");
 
 	sdla = alloc_netdev(sizeof(struct frad_local), "sdla0",
 			    NET_NAME_UNKNOWN, setup_sdla);
-- 
2.25.1

