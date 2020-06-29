Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBB720E235
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389881AbgF2VDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730887AbgF2TMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:12:48 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F22C0086D9;
        Mon, 29 Jun 2020 02:31:13 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f9so7673116pfn.0;
        Mon, 29 Jun 2020 02:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ld538JaKDXIGo10uVIPf/OU9ypVMHtMKsndOQ0uoERY=;
        b=kNVV8i+/97Zn5s/MHxIAt2QNER/BXTzL3YDs1qt3DOpG5XCX9RXz4wHmmN94H4DwkU
         M4Q0UuZJp/0kinhl4WxCtg7mewPv210DRtDVqjPKOY/XxfNtT0yRUsHMVT17dMliME1A
         k1yZh2RgyG5uhLj91imY9haypvx73lMIct0B78mnsGKgPMbqpWshBN6mCMzJ4DxSqqrA
         0e1LosaeH0fKz5NeWHnV73cfBwtWZXMfQWGR2lkdYI02wRq/A8jrJQ/ZZ+yWlW6F0GH3
         3zxdkuWiMu9miFniSuZM7WE0K9uvwTGKj4JhR8BeVctJuIy0HIJZ/+fzmzjymQ0kNFi+
         n/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ld538JaKDXIGo10uVIPf/OU9ypVMHtMKsndOQ0uoERY=;
        b=KsYH72Qe13wzG1Ti4JphxFWbWWBJZv375dpQwSKt55997037jPOgaStdHEw3oNm/bl
         zYZJwlaB6/mJcU19O8O0ihtcRC9fd7wbOacrZkRJI4jt9jabbZ9uUHgwS55CVyZTV537
         zHZNTp/5FY/9YpDhI+Y/1NqyUhZoheLl05lAkwfs/1lc4GLPJch7w4NAHIvoDzb0LSnR
         nZ4bwAoTOaWfscRS4i7B7lkNutksdJt/WGLP0LKfu88kgDkU4krojpqEQ7ceRAHkWnKJ
         x0PUaACvXIKZU6YSy+G/7N6qwpCSl/ELZQBT0iCdCjMR4d7UsTBR55QG+y4lWkVGUl4u
         VRUg==
X-Gm-Message-State: AOAM5325HoNOiA83JtTU/74z3uWy8IJT++8JeNXMNke03Yi4VPhii4D0
        Dz4uQLxd6B6De3nVceHnAKo=
X-Google-Smtp-Source: ABdhPJzg4uMdcuYxGKzmX4AkigvWMPMBvIUAccjNVi7bKO3S0bEG3v2GQq16Tqlxe/ePLRLJFpEoaA==
X-Received: by 2002:a63:fc52:: with SMTP id r18mr3397847pgk.334.1593423072881;
        Mon, 29 Jun 2020 02:31:12 -0700 (PDT)
Received: from varodek.localdomain ([106.210.40.90])
        by smtp.gmail.com with ESMTPSA id q20sm2921286pfn.111.2020.06.29.02.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 02:31:12 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 0/5] ethernet: intel: Convert to generic power management
Date:   Mon, 29 Jun 2020 14:59:38 +0530
Message-Id: <20200629092943.227910-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux Kernel Mentee: Remove Legacy Power Management.

The purpose of this patch series is to remove legacy power management callbacks
from amd ethernet drivers.

The callbacks performing suspend() and resume() operations are still calling
pci_save_state(), pci_set_power_state(), etc. and handling the power management
themselves, which is not recommended.

The conversion requires the removal of the those function calls and change the
callback definition accordingly and make use of dev_pm_ops structure.

All patches are compile-tested only.

Vaibhav Gupta (5):
  iavf: use generic power management
  igbvf: netdev: use generic power management
  ixgbe: use generic power management
  ixgbevf: use generic power management
  e100: use generic power management

 drivers/net/ethernet/intel/e100.c             | 31 ++++------
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 45 ++++----------
 drivers/net/ethernet/intel/igbvf/netdev.c     | 37 +++--------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 61 +++++--------------
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 44 +++----------
 5 files changed, 58 insertions(+), 160 deletions(-)

-- 
2.27.0

