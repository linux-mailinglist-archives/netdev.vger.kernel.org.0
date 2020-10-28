Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF2929DB8A
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390497AbgJ2ACK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390211AbgJ2ACI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 20:02:08 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAD4C0613CF;
        Wed, 28 Oct 2020 17:02:08 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id z23so1482771oic.1;
        Wed, 28 Oct 2020 17:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ri/uN8TTYEf6pJTwm3Av1brlrjdHanupQuH9C/Tp4+s=;
        b=tvz7A+wr5laSoOjzvkle1XCzEsgFcrHa9rqC9IgQDlOqEe9iEHl5Zq9wNqZmNfbfp0
         YmHOPNmrX33703zH/yJ6AUvwJfuXPl1AvVp3+THRPVVENIwwzjc4yy69rx4EGj7Xlebw
         JhwCq9dwm6tfU2HsYrD4AtbR2U/VG7h1JFydvfQTtRt8q1y6vKhZEJsiSgjgp2+GWibM
         Rdwt6A6b7Zw3bUoxyje3fqDzFoVLWTmqZcAZweuK9DV143lfulBV47PAfE1BCr5aKmXH
         JONfuESTPoflBOXf05EMtZCI/8wy6yhv/Fy5o7BYq115MbkhasSvdiA/3MVqo3YafIF8
         5dtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ri/uN8TTYEf6pJTwm3Av1brlrjdHanupQuH9C/Tp4+s=;
        b=Bk5rnkqVMvHXrYjDsZHe09BIKi6AUPhniDynHhxa4x9oOdbNGx3p55OfH62Jkisvll
         t0pWRejEgL4G57IyevgzDZ+J06DpWBVvfK6Ccov3ctjH5dQQd/RC1wVVQgvttiR1ikAr
         VbWW/PWjZD4V4BvcK3bk1Me37kdYh1dBLBkW1iOBWT+tQ2k5W/PCobFB/2oTZZszuES3
         l4WMslhsHXI3Wf0K5K1ZhvOFloT39S8kaFlUzTEB2la2X/UZBiufC5OG34Yn57rx8x5G
         DzyQCnfdIAnNJrt1H0QzmbdTzVg2K5IOKIS1XcKISQD7tFi+mnRHh1iN32gJ19kh7Ij8
         V9+g==
X-Gm-Message-State: AOAM532dcxaMrtYOTpTOwOXAt65aw36REqecQOX9iwk6NxyoLF1hP2Wb
        fPpirrcMZBZTQ+/5Ru7dvg57l7ZxDf8=
X-Google-Smtp-Source: ABdhPJxO3bzgCwET3g6FbTm2Zj+mxsK5v8YdJB7adZBJDDNyHTuoUZImLPZPxoie3Kj8ZReTz6y7Ng==
X-Received: by 2002:a17:90a:aa15:: with SMTP id k21mr4110305pjq.169.1603868722043;
        Wed, 28 Oct 2020 00:05:22 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:a46c:8b86:395a:7a3d])
        by smtp.gmail.com with ESMTPSA id z16sm4777470pfq.33.2020.10.28.00.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 00:05:21 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next] net: dlci: Deprecate the DLCI driver (aka the Frame Relay layer)
Date:   Wed, 28 Oct 2020 00:05:04 -0700
Message-Id: <20201028070504.362164-1-xie.he.0141@gmail.com>
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

Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 Documentation/networking/framerelay.rst | 3 +++
 drivers/net/wan/dlci.c                  | 2 ++
 drivers/net/wan/sdla.c                  | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/Documentation/networking/framerelay.rst b/Documentation/networking/framerelay.rst
index 6d904399ec6d..92e66fc3dffc 100644
--- a/Documentation/networking/framerelay.rst
+++ b/Documentation/networking/framerelay.rst
@@ -4,6 +4,9 @@
 Frame Relay (FR)
 ================
 
+(Note that this Frame Relay layer is deprecated. New drivers should use the
+HDLC Frame Relay layer instead.)
+
 Frame Relay (FR) support for linux is built into a two tiered system of device
 drivers.  The upper layer implements RFC1490 FR specification, and uses the
 Data Link Connection Identifier (DLCI) as its hardware address.  Usually these
diff --git a/drivers/net/wan/dlci.c b/drivers/net/wan/dlci.c
index 3ca4daf63389..1f0eee10c13f 100644
--- a/drivers/net/wan/dlci.c
+++ b/drivers/net/wan/dlci.c
@@ -514,6 +514,8 @@ static int __init init_dlci(void)
 	register_netdevice_notifier(&dlci_notifier);
 
 	printk("%s.\n", version);
+	pr_warn("The DLCI driver (the Frame Relay layer) is deprecated.\n"
+		"Please move your driver to the HDLC Frame Relay layer.\n");
 
 	return 0;
 }
diff --git a/drivers/net/wan/sdla.c b/drivers/net/wan/sdla.c
index bc2c1c7fb1a4..21d602f698fc 100644
--- a/drivers/net/wan/sdla.c
+++ b/drivers/net/wan/sdla.c
@@ -1623,6 +1623,9 @@ static int __init init_sdla(void)
 	int err;
 
 	printk("%s.\n", version);
+	pr_warn("The SDLA driver is deprecated.\n"
+		"If you are still using the hardware,\n"
+		"please help move this driver to the HDLC Frame Relay layer.\n");
 
 	sdla = alloc_netdev(sizeof(struct frad_local), "sdla0",
 			    NET_NAME_UNKNOWN, setup_sdla);
-- 
2.25.1

