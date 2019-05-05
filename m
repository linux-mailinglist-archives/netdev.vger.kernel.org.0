Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E31F913F25
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 13:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfEELRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 07:17:21 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34700 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfEELRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 07:17:20 -0400
Received: by mail-pf1-f196.google.com with SMTP id b3so5225991pfd.1
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 04:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=zoY5vXJw039b52pI6IQCKwFwK9TNKRZnXsbWiie7ZaY=;
        b=MjUXkwS3ZiSGqnSiu9UbliZRZfuuQh26+bo3qNK7zJNv+jOki5U5F7IvikF6geRrkE
         sdhjKH/aar2lEKfWa69Z3nl5SIU1NUOdpoAm0zfBhezkNf0wAfteIA/r3FW0dZp2q7Bk
         jSIO/gOH3JcFFXg4+jY92LDgMLkzK8zXfveEk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zoY5vXJw039b52pI6IQCKwFwK9TNKRZnXsbWiie7ZaY=;
        b=EdQSJDn0GCVTcvCz4kT0XA9/ZG/dsdw3RFzqOXSURsfm6uYrUOhAb4/u27Yh/oqBm6
         WecxPk+H1DIjusdMcHNd4xKcHWYJhJkAXodPS2SPZXXtqMnxlVhxUZhIkTX2xoBv6ekG
         6iOut07e58a85TFCSn61JvxfLb4j77yAk1I60wcc1DSEfYA2Z3RFGszLEJkDI2DCJuCk
         hMmhgwFcBiYhq6Ot86S9xoW4JcTYxuLYsM5ci9sFd7e4uLdLW8eLsOZQOqE28bU4SGFd
         99kGVYGzVQa8TvKdiQm2NRZXyts4HAICXWRCnu+65lwk6T7LR4lF39ublbaILrgOoSjw
         fdtQ==
X-Gm-Message-State: APjAAAWbHL1ZOyck0sVPpBZfgNpaMgJx8ciCOHAzJMRXaj7+8BwoxNTT
        yDwOlHT3p7FKv90NxrddJEUVBhOdqhc=
X-Google-Smtp-Source: APXvYqwJ1Su0hrqucF+wvbJvZHgsK/L9XTfoA8kODx6MjL+0kUDeWuoL8pgYZy6UA1UzbHLlTe9Arg==
X-Received: by 2002:a63:2c4a:: with SMTP id s71mr23836735pgs.373.1557055040251;
        Sun, 05 May 2019 04:17:20 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id 10sm9378902pfh.14.2019.05.05.04.17.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 04:17:19 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 00/11] bnxt_en: Driver updates.
Date:   Sun,  5 May 2019 07:16:57 -0400
Message-Id: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds some extended statistics available with the new
firmware interface, package version from firmware, aRFS support on
57500 chips, new PCI IDs, and some miscellaneous fixes and improvements.

Devesh Sharma (1):
  bnxt_en: Separate RDMA MR/AH context allocation.

Michael Chan (5):
  bnxt_en: Update firmware interface to 1.10.0.69.
  bnxt_en: Improve NQ reservations.
  bnxt_en: Query firmware capability to support aRFS on 57500 chips.
  bnxt_en: Add support for aRFS on 57500 chips.
  bnxt_en: Add device IDs 0x1806 and 0x1752 for 57500 devices.

Vasundhara Volam (5):
  bnxt_en: Refactor bnxt_alloc_stats().
  bnxt_en: Add support for PCIe statistics
  bnxt_en: Check new firmware capability to display extended stats.
  bnxt_en: Read package version from firmware.
  bnxt_en: read the clause type from the PHY ID

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 213 ++++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  12 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  46 +++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h     | 263 +++++++++++++++++-----
 4 files changed, 432 insertions(+), 102 deletions(-)

-- 
2.5.1

