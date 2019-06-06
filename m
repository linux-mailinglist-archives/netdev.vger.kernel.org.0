Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A36793709D
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 11:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfFFJra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 05:47:30 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44311 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728070AbfFFJr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 05:47:29 -0400
Received: by mail-lf1-f67.google.com with SMTP id r15so1053192lfm.11
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 02:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7nW3mZt+9ZnxuAFL1+ZAaurMAqAqlQaogmKT12Q9bkc=;
        b=CzwkPpSR7JxGv5fTN1QNy7x2oHDM4EE8O4QEeZBUh+hN0z2w54ETNmPLmP8r76XLto
         0t2kV0IsL0DtZ2SDzJ+pWYFnxocbxNTPMpf8NM/nEingkJX16quxgrdNYsaygv8MPFeP
         T6YjtAE91PsFnmwPSI61gDl+JP5ex5/7e2lk/zMJqwzzT+zn5JfQptytp+gdMp0WbXK2
         +Tb9akU37mhth+Ae11wWtu1UJB/ifvxQuDvtpN55ghdIfW1yoDCZimq1r3mopfO2mRuk
         GwgyTcqRHiAxJJdsqlYjM4kjEgnzoKo5ZFhnQqZ6s1WgSTyFViIFBRK7V3Lo4Vr9wIRD
         F/GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7nW3mZt+9ZnxuAFL1+ZAaurMAqAqlQaogmKT12Q9bkc=;
        b=fPqacNv+H9qfSMSM1wGb1/RUzmZGYaHzfvr1LMIz9iSJie3GUpiPeDf2kSnMesc513
         FA0m42tMJMgCjoF5KK7dQP2a6E5eoGSf0yBDt7x8Qb3JeiIpC+t85J3oWTGpiWfdCRQV
         KxyaedkjU2U1y5BgHjmG48kyzJrYTURaJ1aFqM8lVfokDcxxn5uC77NIieBQUguxXNbK
         ZHeeGp3Z44rj9pnvfehwsFJGM8zo8pjmfb4hXh3Laj2oH/lJVLxApnPuyZw4rTh0VyiK
         DFleseZgz2dbg9XuOAXLIZf81Qd6sJ844SemdnRDeJ5oYArnRRyU69OUcldOoA4McHIV
         H+Bg==
X-Gm-Message-State: APjAAAVpkMEfbnNeqwJHsYRbCTSe3NH+RcDsuK7msNGxyNJEuk68XP86
        qd12iwKpOD3Cu8Cn5n1hHvpbVQ==
X-Google-Smtp-Source: APXvYqx/DDTeaN+7wcBnH7SJY8W7bd3Q5Vdb+xcU4CnRCqt72c8lJvk4A3phFKwb3KZM6axwL3tiRQ==
X-Received: by 2002:ac2:5938:: with SMTP id v24mr12708910lfi.161.1559814446768;
        Thu, 06 Jun 2019 02:47:26 -0700 (PDT)
Received: from localhost (c-1c3670d5.07-21-73746f28.bbcust.telenor.se. [213.112.54.28])
        by smtp.gmail.com with ESMTPSA id k7sm250518ljc.92.2019.06.06.02.47.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 02:47:25 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     mchehab@kernel.org, p.zabel@pengutronix.de
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        marex@denx.de, stefan@agner.ch, airlied@linux.ie, daniel@ffwll.ch,
        shawnguo@kernel.org, s.hauer@pengutronix.de,
        b.zolnierkie@samsung.com, a.hajda@samsung.com,
        hkallweit1@gmail.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-media@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 5/8] drivers: media: coda: fix warning same module names
Date:   Thu,  6 Jun 2019 11:47:22 +0200
Message-Id: <20190606094722.23816-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with CONFIG_VIDEO_CODA and CONFIG_CODA_FS enabled as
loadable modules, we see the following warning:

warning: same module names found:
  fs/coda/coda.ko
  drivers/media/platform/coda/coda.ko

Rework so media coda matches the config fragment. Leaving CODA_FS as is
since thats a well known module.

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/media/platform/coda/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/Makefile b/drivers/media/platform/coda/Makefile
index 54e9a73a92ab..588e6bf7c190 100644
--- a/drivers/media/platform/coda/Makefile
+++ b/drivers/media/platform/coda/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-coda-objs := coda-common.o coda-bit.o coda-gdi.o coda-h264.o coda-mpeg2.o coda-mpeg4.o coda-jpeg.o
+video-coda-objs := coda-common.o coda-bit.o coda-gdi.o coda-h264.o coda-mpeg2.o coda-mpeg4.o coda-jpeg.o
 
-obj-$(CONFIG_VIDEO_CODA) += coda.o
+obj-$(CONFIG_VIDEO_CODA) += video-coda.o
 obj-$(CONFIG_VIDEO_IMX_VDOA) += imx-vdoa.o
-- 
2.20.1

