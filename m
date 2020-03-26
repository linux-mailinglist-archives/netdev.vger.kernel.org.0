Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC322193E89
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 13:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgCZME0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 08:04:26 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51266 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbgCZME0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 08:04:26 -0400
Received: by mail-wm1-f66.google.com with SMTP id c187so6189166wme.1
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 05:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=SucbxylAIn30XCM5UTMAf858CfM6JT86REcwyjy4J90=;
        b=HHklw4rEGcikBGMHfAmxGjXgWcH4FNrIZlHkiXNgRHVwl4RSmmfB2rOtVZ/KpEJV4J
         8hlK/wFKWkrud/bMzIE2F7/rhCYcyQMHfx+e3rtLm5VGypMJyTeksjtUqeN1R76gFpuG
         m10TUnTsFQINCfVoJYNwedKPiT5t/9ubY4sak=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SucbxylAIn30XCM5UTMAf858CfM6JT86REcwyjy4J90=;
        b=CZ5zWLk6CNqMfYtl3R9kgkKN+2UDVf2bz5/2e0FU+r3fdgG2aCO4UWe0/ZsjqM9Z3K
         aFgy18GgZsKxcSTDXlkurClSyLYXXKL5R8wYbTQn6ArEsglrI53CTIgkytSmbfrCsKzO
         Cvz8xZQYUnpspukDUxjqoZheEprD+V3RZ2B1ISE8dvI6GIwZsdEav4smhy6+V7HIdaPo
         HOordKUZTH54EL7aTVt/gK0TezAE6a0btvfyZh98Ci3ANIrlfqTD9wL886HNKZEvHPxI
         6l/03h+oDw3xV7gfjn2Q4siJhPaChAdHDEQVqSQRq9mA5xBfPAEHS4JTqtDAa/cUj6QK
         FUCg==
X-Gm-Message-State: ANhLgQ1DR6jnEEhd7DMkwKWRNJMthqksaHcIJ33wlOgYBuLM+/Yf+hDR
        tdt2uIGpNHlbtjqRtbNyYc4ofA==
X-Google-Smtp-Source: ADFU+vsbwxS4Jj9u6RZlgeQHSSKtI96u9Kl7ZTVyOlbq2aUKQ4pGEi/GZKm0UNS86523Vwj/j1pyxA==
X-Received: by 2002:a05:600c:2f90:: with SMTP id t16mr238561wmn.66.1585224263937;
        Thu, 26 Mar 2020 05:04:23 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id k84sm3316637wmk.2.2020.03.26.05.04.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Mar 2020 05:04:22 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH v3 net-next 0/5] bnxt_en: Updates to devlink info_get cb
Date:   Thu, 26 Mar 2020 17:32:33 +0530
Message-Id: <1585224155-11612-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for a generic macro to devlink info_get cb.
Adds support for fw.api and board.id info to bnxt_en driver info_get cb.
Also, updates the devlink-info.rst and bnxt.rst documentation accordingly.

---
v1->v2: Remove ECN dev param, base_mh_addr and serial number info support
in this series.
Rename drv.spec macro to fw.api.
---
v2->v3: Remove hw.addr info as it is per netdev but not per device info.
---

Vasundhara Volam (5):
  devlink: Add macro for "fw.api" to info_get cb.
  bnxt_en: Add fw.api version to devlink info_get cb.
  PCI: Add new PCI_VPD_RO_KEYWORD_SERIALNO macro
  bnxt_en: Read partno and serialno of the board from VPD
  bnxt_en: Add partno to devlink info_get cb

 Documentation/networking/devlink/bnxt.rst         |  6 ++
 Documentation/networking/devlink/devlink-info.rst |  6 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 74 ++++++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  5 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 13 ++++
 include/linux/pci.h                               |  1 +
 include/net/devlink.h                             |  2 +
 7 files changed, 106 insertions(+), 1 deletion(-)

-- 
1.8.3.1

