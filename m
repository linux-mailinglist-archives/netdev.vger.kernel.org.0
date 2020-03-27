Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1CB5195422
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 10:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgC0Jgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 05:36:46 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50466 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgC0Jgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 05:36:46 -0400
Received: by mail-wm1-f68.google.com with SMTP id d198so10725946wmd.0
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 02:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=bibr26/LP/e0bxTNTPbUk/xVm79OUc32QpQLyKLiR+s=;
        b=D15YUcre9lk6C9el7g9UIZAE/7dxwgaExXG+EyZk1owNp8vHDnTY/LZzWZbH5xu3Dm
         viotoi0mLTWUeen2NW9qmfc0swpIY7XNKsTIGsbeQYeOUCvzCQilGkctxxxJGFZeQVsE
         u86rk0oMEQgtIBMR+3u8EAlYMyNgx3Q/mAPkQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bibr26/LP/e0bxTNTPbUk/xVm79OUc32QpQLyKLiR+s=;
        b=F0NoB2VQue8bswJIgAijWk+80rpNSc7dph2oAsBwp3/uusuSr05PGNpUzbxrjB3OeS
         hJzqRiMLrhyr+5tzsjlqDbhVqFHl98AyYg3Pzmum0lIvROxDs4RzGqVRnj9y19RuJS0H
         371F99aVVEOmxyXC2cJFhdgti2jEO1Q13hKuW5l3Z5C2IDrq0FpVLcfkLkkgXf0vHMq/
         Qe5BXnflwHu+HiA6GL/LerO8ZwfMX6WCI67F7NrZWJOGrqA+KFPeWQz6bXgKyhBnXXxC
         2gFVdT25Qi/AwCKdpBzBcPNm1xylOaKzqQJgoeI/AsfJLT5UWwXsB5Fe5BkKaGgM9IaJ
         0VjA==
X-Gm-Message-State: ANhLgQ1KTV7QcyFvHk4oV/vvy9JMtUXyVM/2md52PuuUBsQ0lIGlS9aP
        wMmfGbpfLaGEg6fjsQnC3FkLow==
X-Google-Smtp-Source: ADFU+vuOlMz93Q/petE5ffirm9IWfgKdRJdJt5wD/sVUyXP3c1nGT/NeBkfZ23DAPVSEgpEEbsi+uQ==
X-Received: by 2002:a7b:c117:: with SMTP id w23mr4340801wmi.26.1585301803866;
        Fri, 27 Mar 2020 02:36:43 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id g186sm7607450wmg.36.2020.03.27.02.36.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 02:36:43 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH v4 net-next 0/6] bnxt_en: Updates to devlink info_get cb
Date:   Fri, 27 Mar 2020 15:04:50 +0530
Message-Id: <1585301692-25954-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for a generic macro to devlink info_get cb.
Adds support for fw.mgmt.api and board.id info to bnxt_en driver info_get
cb. Also, updates the devlink-info.rst and bnxt.rst documentation
accordingly.

This series adds a patch to fix few macro names that maps to bnxt_en
firmware versions.

---
v1->v2: Remove ECN dev param, base_mh_addr and serial number info support
in this series.
Rename drv.spec macro to fw.api.
---
v2->v3: Remove hw.addr info as it is per netdev but not per device info.
---
v3->v4: Rename "fw.api" to "fw.mgmt.api".
Also, add a patch that modifies few macro names in info_get command,
to match the devlink documentation.
---

Vasundhara Volam (6):
  devlink: Add macro for "fw.mgmt.api" to info_get cb.
  bnxt_en: Add fw.mgmt.api version to devlink info_get cb.
  PCI: Add new PCI_VPD_RO_KEYWORD_SERIALNO macro
  bnxt_en: Read partno and serialno of the board from VPD
  bnxt_en: Add partno to devlink info_get cb
  bnxt_en: Fix "fw.mgmt" and "fw.nsci" info via devlink info_get cb

 Documentation/networking/devlink/bnxt.rst         | 14 +++--
 Documentation/networking/devlink/devlink-info.rst |  6 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 74 ++++++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  5 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 18 +++++-
 include/linux/pci.h                               |  1 +
 include/net/devlink.h                             |  2 +
 7 files changed, 113 insertions(+), 7 deletions(-)

-- 
1.8.3.1

