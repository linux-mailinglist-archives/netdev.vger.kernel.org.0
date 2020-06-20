Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492A520228E
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 10:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgFTISF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 04:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgFTISF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 04:18:05 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C84C06174E
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 01:18:04 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id g18so2725930wrm.2
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 01:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=hEgO3e/9DEWPStxRZQSK0rUWjqyYF51wg63ooYT3mmc=;
        b=Hublbc9dmOq2EdtTOEylzzlWsOcLyCd/jO/qz56mJhRd7WtmObHoqRywq+yqWhfSKC
         QmoILGfQf1Wbq7qMhYckoIZ2I6NiTImtAAN1Xlfggtus4O3TzImqLQyOigfJZFa4Ydfw
         vcfFktDa8FF7cPgTU0gGWHOxuMmqdbd2uAdpE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hEgO3e/9DEWPStxRZQSK0rUWjqyYF51wg63ooYT3mmc=;
        b=aCADrSWtg9k+z35yE/FsaeE/fmkbMbO24cnZ3tbNNuG/KsKn4ZApu0sJ/JvA5cwEwP
         uytrjzydcp6KzhDwA1/oK7qj/N4XaOcipSJJ2yAM/daSEHMWugvN34aEB9ao0gNWnUFj
         QxEUO4/mxyGvJos/+JRB+7fgp5XcyOeoxWvBA5FwkeQzpzyiqzbQA8l//86G/xePlsHN
         ubspg6zk/jg6G7cXJSVM2woYM9wAWmouJdami67srxl5wTNh8mN5YehooZ0wpwDrZHAw
         l/DGjb++aHsYczjcZ5S6P/cOaRNjKz2teYLqhmbANwoOSeu5gp+82XqoFeFcATI6joXV
         zCuQ==
X-Gm-Message-State: AOAM530RvHdm/XgbekGHcHgarmKqYtu6YYy9tvCBtxE7yX08oCjcGTPi
        F60vKyaH2S7oL0Im+dOI51P1rA==
X-Google-Smtp-Source: ABdhPJxASqWx/BWloibUD3xzBsglaAxntyzAmj1Ay/SgPZbzaCDdclfXOJ6cQo5EwY+r8AwDC2I/Bw==
X-Received: by 2002:adf:81c7:: with SMTP id 65mr7828764wra.47.1592641080938;
        Sat, 20 Jun 2020 01:18:00 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b201sm9354152wmb.36.2020.06.20.01.17.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Jun 2020 01:18:00 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com, kuba@kernel.org,
        jiri@mellanox.com, jacob.e.keller@intel.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 0/2] devlink: Add board_serial_number field to info_get cb.
Date:   Sat, 20 Jun 2020 13:45:45 +0530
Message-Id: <1592640947-10421-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for board_serial_number to devlink info_get
cb and also use it in bnxt_en driver.

Sample output:

$ devlink dev info pci/0000:af:00.1
pci/0000:af:00.1:
  driver bnxt_en
  serial_number 00-10-18-FF-FE-AD-1A-00
  board_serial_number 433551F+172300000
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

Vasundhara Volam (2):
  devlink: Add support for board_serial_number to info_get cb.
  bnxt_en: Add board_serial_number field to info_get cb

 Documentation/networking/devlink/devlink-info.rst | 12 +++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |  7 +++++++
 include/net/devlink.h                             |  2 ++
 include/uapi/linux/devlink.h                      |  2 ++
 net/core/devlink.c                                |  8 ++++++++
 5 files changed, 24 insertions(+), 7 deletions(-)

-- 
1.8.3.1

