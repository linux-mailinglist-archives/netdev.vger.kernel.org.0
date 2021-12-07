Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB84346B523
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 09:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhLGIKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 03:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhLGIK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 03:10:28 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4C8C061746;
        Tue,  7 Dec 2021 00:06:58 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id j9so12345931qvm.10;
        Tue, 07 Dec 2021 00:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=7edR5WxT1YjL2dnpTI5UXulEYHedPZ52o2wOhWq9rH4=;
        b=PiiRyeDACRK4/VRbRbC7Oai8DJ2lQ/2SrjubRp/GxNzXEPfhnphnTDD5VoSPwfqgkd
         imjFmuEsd2xOdIUOVRsH7YsIjF7dMV5m5oWVHrH/5donZfnihQ0k+JcWqwDmSYHGRT/e
         HiCdn8KUwJfWINN5/ofoO0R71ZboGWwOXDD5Zh4ekW+xJkq+TXwBKrDdG8FTXxxMF0se
         mOgW2Lm9XA0k1MNLj5VVCStX+P/MFqlHAcSY/dLUk4LgcyUSmlIndwhxPagEyRePaypG
         VsOUxWNfNg8uhMkkv59atyCEYDzCbC2yT7Sb1te9W7XDizYdqvLOe/qzV8OYe64FLpb3
         D2Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7edR5WxT1YjL2dnpTI5UXulEYHedPZ52o2wOhWq9rH4=;
        b=mtLDXwGcs5FDU1xDbMAbmQRqIDQLntDYh9Gspm4fFYpIWSd9jcqVY90RUruGpH1m68
         tA0eH+AY+O/QvbTF40+FfVkz1IndPV//KX3EHwuTrqxuk3jWH41ewnzkpNIjFbVcl5Y3
         wRr4prjHfoSLoSrVeqy1bYl1zi86rYstAqxji86LzZYroRDgpyCs5dG5yOVBZahhbgqZ
         qEXW/ujoGIiZTZk9tmtlAPCb78IWxHamqDfBUNrg2bpkjtV7HiVqukneCxXMmjoCcznX
         KcIUn7subqKlDzO3CXPmBLOnEAhPDKooSZ7/Ul+dM1p7Fc8L/OoyY/sD0Z9K7GnIT9Yu
         mA1A==
X-Gm-Message-State: AOAM530nDvZBHmTTKLpIHFqDiWRxuEpj/eyMIAgnVam7jFaC5q8AtgEV
        p/MaL7CnGzM0xxy2v8gBRBnmx7E910I=
X-Google-Smtp-Source: ABdhPJx0zblY7BJY+dR+0sMV9cI4k9iwyseQxW1QFTyP/ECyskdkJs0F6ssTspbCckMOtbSCfpqYfQ==
X-Received: by 2002:a0c:c784:: with SMTP id k4mr42749665qvj.1.1638864418140;
        Tue, 07 Dec 2021 00:06:58 -0800 (PST)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id bj32sm7673679qkb.75.2021.12.07.00.06.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Dec 2021 00:06:57 -0800 (PST)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
Cc:     wells.lu@sunplus.com, vincent.shih@sunplus.com,
        Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next v4 0/2] This is a patch series for Ethernet driver of Sunplus SP7021 SoC.
Date:   Tue,  7 Dec 2021 16:06:57 +0800
Message-Id: <1638864419-17501-1-git-send-email-wellslutw@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sunplus SP7021 is an ARM Cortex A7 (4 cores) based SoC. It integrates
many peripherals (ex: UART, I2C, SPI, SDIO, eMMC, USB, SD card and
etc.) into a single chip. It is designed for industrial control
applications.

Refer to:
https://sunplus-tibbo.atlassian.net/wiki/spaces/doc/overview
https://tibbo.com/store/plus1.html

Wells Lu (2):
  devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
  net: ethernet: Add driver for Sunplus SP7021

 .../bindings/net/sunplus,sp7021-emac.yaml          | 172 ++++++
 MAINTAINERS                                        |   8 +
 drivers/net/ethernet/Kconfig                       |   1 +
 drivers/net/ethernet/Makefile                      |   1 +
 drivers/net/ethernet/sunplus/Kconfig               |  36 ++
 drivers/net/ethernet/sunplus/Makefile              |   6 +
 drivers/net/ethernet/sunplus/spl2sw_define.h       | 282 +++++++++
 drivers/net/ethernet/sunplus/spl2sw_desc.c         | 226 ++++++++
 drivers/net/ethernet/sunplus/spl2sw_desc.h         |  19 +
 drivers/net/ethernet/sunplus/spl2sw_driver.c       | 629 +++++++++++++++++++++
 drivers/net/ethernet/sunplus/spl2sw_driver.h       |  12 +
 drivers/net/ethernet/sunplus/spl2sw_int.c          | 253 +++++++++
 drivers/net/ethernet/sunplus/spl2sw_int.h          |  13 +
 drivers/net/ethernet/sunplus/spl2sw_mac.c          | 353 ++++++++++++
 drivers/net/ethernet/sunplus/spl2sw_mac.h          |  19 +
 drivers/net/ethernet/sunplus/spl2sw_mdio.c         | 126 +++++
 drivers/net/ethernet/sunplus/spl2sw_mdio.h         |  12 +
 drivers/net/ethernet/sunplus/spl2sw_phy.c          |  92 +++
 drivers/net/ethernet/sunplus/spl2sw_phy.h          |  12 +
 drivers/net/ethernet/sunplus/spl2sw_register.h     |  94 +++
 20 files changed, 2366 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
 create mode 100644 drivers/net/ethernet/sunplus/Kconfig
 create mode 100644 drivers/net/ethernet/sunplus/Makefile
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_define.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_desc.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_desc.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_driver.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_driver.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_int.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_int.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mac.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mac.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mdio.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mdio.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_phy.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_phy.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_register.h

-- 
2.7.4

