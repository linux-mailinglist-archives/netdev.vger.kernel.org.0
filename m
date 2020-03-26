Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8125E193892
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgCZG3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:29:15 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:37123 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgCZG3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:29:15 -0400
Received: by mail-wm1-f46.google.com with SMTP id d1so5710484wmb.2
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 23:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=z4e+0HWr0atN9R50+IX15C2iWfPT4znw3EBrH78H3zc=;
        b=TZhVB8DIjoqF3PM8mgNlwYKBaPtxiypr+GJXK33PODZdDgkXflSbkDhrAN1fFpoIx1
         oJhZHnM+ynPgq+Fy75DxUPy0nM5XzzTtxiQoN9YCqRsJv557GehpBE8u3fBdX3ifPrDa
         uTAgZWTtpgMHnCtQtyPGJ9qU03VgRJjMU5Amc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=z4e+0HWr0atN9R50+IX15C2iWfPT4znw3EBrH78H3zc=;
        b=fr1svkyn7A/OtOFjQMUKElN5pbAuDrvPucPtsDWV90NJvwJKstum65x+dFeVQ9uNN4
         qDGVb2O9BX6CAtvuDpIL7Bv1ls2GPXXPCupnw67104jI6WvD3gyH7dokVgUzvovwILuv
         eKnj56gPfjuAnMrn9EPH2Tf5xY82ygkvRkTGOLkwNA+TMDrmxsCODtcPI7dnX/+H8ifd
         zcLi+EMAqvC8oL3WHoHOyIFGQqu+ZF0gy2stzy7Odl/Qmtpo/TkKY8WeR7xm7Xfw3tf/
         EUkM01K0tgXs/GFtmBYjiVGxC1+U7AehKrCbc9DneQPI8fAP49hSOh9Vt57VBx1WKVsD
         9MDQ==
X-Gm-Message-State: ANhLgQ3pbL3c9e+xBmDjNJ8sbaD+28BY1ReMd+dGOlysIvVPIJAZFTP2
        xc5SuzPjSf8fhVr6YPWSXFZRus3+IrY=
X-Google-Smtp-Source: ADFU+vvVJGpTG4L+6d7uIAqiHnigF7BlJ7aps/NzuexpXhd1lfUBH2e4uXMWcOMd2UH7YhUN2x9Mug==
X-Received: by 2002:a05:600c:2101:: with SMTP id u1mr1390557wml.177.1585204152984;
        Wed, 25 Mar 2020 23:29:12 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y200sm2106768wmc.20.2020.03.25.23.29.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2020 23:29:12 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH v2 net-next 0/7] bnxt_en: Updates to devlink info_get cb
Date:   Thu, 26 Mar 2020 11:56:57 +0530
Message-Id: <1585204021-10317-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for some of the generic macros to devlink info_get
cb. Updates the devlink-info.rst and bnxt.rst documentation accordingly.

---
v1->v2: Remove ECN dev param, base_mh_addr and serial number info support
in this series.
Rename drv.spec macro to fw.api.
---

Vasundhara Volam (7):
  devlink: Add macro for "fw.api" to info_get cb.
  bnxt_en: Add fw.api version to devlink info_get cb.
  devlink: Add macro for "hw.addr" to info_get cb.
  bnxt_en: Add hw addr to devlink info_get cb.
  PCI: Add new PCI_VPD_RO_KEYWORD_SERIALNO macro
  bnxt_en: Read partno and serialno of the board from VPD
  bnxt_en: Add partno to devlink info_get cb

 Documentation/networking/devlink/bnxt.rst         |  9 +++
 Documentation/networking/devlink/devlink-info.rst | 11 ++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 74 ++++++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  5 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 19 ++++++
 include/linux/pci.h                               |  1 +
 include/net/devlink.h                             |  5 ++
 7 files changed, 123 insertions(+), 1 deletion(-)

-- 
1.8.3.1

