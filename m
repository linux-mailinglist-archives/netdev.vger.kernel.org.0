Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF84A202550
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 18:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgFTQeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 12:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgFTQeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 12:34:20 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C4FC06174E
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 09:34:20 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id z13so766350wrw.5
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 09:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Ul8LyqGSJnGpuv3v2kk+h3m2M9Mwub/8+VYndTjxwQw=;
        b=KpyPOLMXs12FINVYgRZV6JMu/QPh5DCFRWs1bNDMvlCE2wfHDhOL3c/BDTBzewnzpY
         bTay69GzRiJcGm8CFCVW4OXG5YaAQ13+oMDQz4ISB1RUR5asJhceoNiHv2S3MH1rYaC6
         aVKjq+bxixdmeycAzjSfQhhgQZRWwoKDLGBDk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ul8LyqGSJnGpuv3v2kk+h3m2M9Mwub/8+VYndTjxwQw=;
        b=gquMCX9LFc2ahQCYe1Y3VPYHuJwIA6RHS07kGAg041t7C2vFZ7aMc3ZnlhGCWH0Ii4
         6UDubo8LLKjUg+GXMpLrACwasPIVW8rgEk2JyvNJVQXzglYQt5+mgWQw2/SK1I6Majna
         WBu/PUhA9Ardn3HN6XpKl1Lbx4FhCEcSPbpRgDbmhH4vlMkgFdpsHgp9YbPEnLP41Lbz
         UyR3S8p1NIXTIXDSKjMTUX2Qy93XDLguqLZ2/8DAxB204h3/akZspxX5xTaoLw/aagDG
         /7g7Zg6v8e0/cOW4LAPhIcMLMvFN1f8syQPKhO+BcsjvUv5OCaiDaiOuwn2JWzgafoDk
         t98Q==
X-Gm-Message-State: AOAM530y2bpvfIFYVnJbuAkRloi9u5VIYPmSFayik0Z8U01K7lyzmkm9
        wfJw6eR9npp0FuqILPgl8GSeBw==
X-Google-Smtp-Source: ABdhPJw66h9ruVlyLl1inNC36pkvUHJYM2uy7RBaO1nnUFuoGJ+B9ZK5Qcr5/P1xU/JQ10AO9ZiB6w==
X-Received: by 2002:a5d:6749:: with SMTP id l9mr9721008wrw.63.1592670859020;
        Sat, 20 Jun 2020 09:34:19 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id c6sm10825974wma.15.2020.06.20.09.34.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Jun 2020 09:34:18 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com, kuba@kernel.org,
        jiri@mellanox.com, jacob.e.keller@intel.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH v2 net-next 0/2] devlink: Add board.serial_number field to info_get cb.
Date:   Sat, 20 Jun 2020 22:01:55 +0530
Message-Id: <1592670717-28851-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for board.serial_number to devlink info_get
cb and also use it in bnxt_en driver.

Sample output:

$ devlink dev info pci/0000:af:00.1
pci/0000:af:00.1:
  driver bnxt_en
  serial_number 00-10-18-FF-FE-AD-1A-00
  board.serial_number 433551F+172300000
  versions:
      fixed:
        board.id 7339763 Rev 0.
        asic.id 16D7
        asic.rev 1
      running:
        fw 216.1.216.0
        fw.psid 0.0.0
        fw.mgmt 216.1.192.0
        fw.mgmt.api 1.10.1
        fw.ncsi 0.0.0.0
        fw.roce 216.1.16.0

---
v2:
- Modify board_serial_number to board.serial_number for maintaining
consistency.
- Combine 2 lines in second patchset as column limit is 100 now
---

Vasundhara Volam (2):
  devlink: Add support for board.serial_number to info_get cb.
  bnxt_en: Add board.serial_number field to info_get cb

 Documentation/networking/devlink/devlink-info.rst | 12 +++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |  6 ++++++
 include/net/devlink.h                             |  2 ++
 include/uapi/linux/devlink.h                      |  2 ++
 net/core/devlink.c                                |  8 ++++++++
 5 files changed, 23 insertions(+), 7 deletions(-)

-- 
1.8.3.1

