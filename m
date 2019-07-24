Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7653B727CD
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 08:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfGXGFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 02:05:22 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35910 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfGXGFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 02:05:22 -0400
Received: by mail-pg1-f194.google.com with SMTP id l21so20635214pgm.3;
        Tue, 23 Jul 2019 23:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kEit7lAB1Ue2Pj5oh+Mlb7ShDCe+fsz5zjPxqobMIKg=;
        b=LOZBVGQxyAGRUFVP8mPfnlKQD07SIGGlVfHqkFTEab3aa0FHzBfOCDb58AWG2QNF11
         KT0/Q5L2+y3O8rh914AlOqnBcMckN/0ycwl1E/FhHjHhxV2wsgtluQ9amIthLTXIZ6KI
         QVczTYnvho5/2SufK7VAhoSU8moWT1GL6DvExtCg7Lrsdc1SHpVZwkLjiB5eWwS5whNu
         kcFm5zVqBELbsneoH3jM4hjpxAOvrtK2WlyOrptwVEbr6W1vFe8nIK5Yy/36E2LXxg0k
         zqShovDJzgsBZsQbU6ER2hMs5AJGkNOEhhKPM1P5aGHDoNZ9thbjTArNYZ0eU6WOP1pG
         GpSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kEit7lAB1Ue2Pj5oh+Mlb7ShDCe+fsz5zjPxqobMIKg=;
        b=SXlT0E7jkA0HBX/cW8hyPkN6v4+RrVPfXJVCHWMZZchX7EZmP7WXmw0XgOtMznMtMj
         HVdZZfKQSzus6EzrT+RNSOXw2QckRkh+k1DKRKUUasDTXIqUK9VYg+GLMmGQjqHsmcJH
         JSVDv4inN6jb0agBikhIM7Ig5cRU6rhKBnoB+RMSjKgbs7T7VbSoZ56/l1ystjaLfkbo
         fv/cGIbGNy4Z0lZQFTSF2EwMh/wret5IbTWtLj7oWt34cEnPUPnTlk+pLR8yYSvvSNER
         Qj/zRkcdso6RYb8LKK3XBNw4ZotKyi0Hm7mz9kvLI94lIhUwBKFRUmPh8zBclTl1OvhG
         mtXg==
X-Gm-Message-State: APjAAAUHr9EWJ7anGaHG2YfnYzXKPKeAIzZqnVe0YxFE3r88zWASsDRk
        V6h3Ryxh2WRdoDvhSbjyXf8=
X-Google-Smtp-Source: APXvYqzgXdUAYYOPzIp2tCoOz/dnsYdNYa9oDXaK677WPWN4WX5+xa+IElSv4CWN2p4eSe3FBrKanA==
X-Received: by 2002:a17:90a:220a:: with SMTP id c10mr87503028pje.33.1563948321586;
        Tue, 23 Jul 2019 23:05:21 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id y8sm42498752pfn.52.2019.07.23.23.05.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 23:05:20 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Steffen Klassert <klassert@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Rasesh Mody <rmody@marvell.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Guo-Fu Tseng <cooldavid@cooldavid.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net-next v2 0/8] Use dev_get_drvdata where possible
Date:   Wed, 24 Jul 2019 14:05:12 +0800
Message-Id: <20190724060512.23899-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches use dev_get_drvdata instead of
using to_pci_dev + pci_get_drvdata to make
code simpler where possible.

Changelog:

v1 -> v2:
- Change pci_set_drvdata to dev_set_drvdata
  to keep consistency.

Chuhong Yuan (8):
  net: 3com: 3c59x: Use dev_get_drvdata
  net: atheros: Use dev_get_drvdata
  net: broadcom: Use dev_get_drvdata
  e1000e: Use dev_get_drvdata where possible
  fm10k: Use dev_get_drvdata
  i40e: Use dev_get_drvdata
  igb: Use dev_get_drvdata where possible
  net: jme: Use dev_get_drvdata

 drivers/net/ethernet/3com/3c59x.c               |  8 +++-----
 drivers/net/ethernet/atheros/alx/main.c         |  8 +++-----
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 10 ++++------
 drivers/net/ethernet/atheros/atlx/atl1.c        |  8 +++-----
 drivers/net/ethernet/broadcom/bnx2.c            |  8 +++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt.c       |  8 +++-----
 drivers/net/ethernet/broadcom/tg3.c             |  8 +++-----
 drivers/net/ethernet/intel/e1000e/netdev.c      |  9 ++++-----
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c    |  6 +++---
 drivers/net/ethernet/intel/i40e/i40e_main.c     | 10 ++++------
 drivers/net/ethernet/intel/igb/igb_main.c       |  5 ++---
 drivers/net/ethernet/jme.c                      |  8 +++-----
 12 files changed, 38 insertions(+), 58 deletions(-)

-- 
2.20.1

