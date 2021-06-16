Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B023A8F77
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 05:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhFPDmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 23:42:39 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:7284 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhFPDmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 23:42:36 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G4W6R2pfLz1BMt7;
        Wed, 16 Jun 2021 11:35:27 +0800 (CST)
Received: from SZX1000464847.huawei.com (10.21.59.169) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 11:40:27 +0800
From:   Dongdong Liu <liudongdong3@huawei.com>
To:     <helgaas@kernel.org>, <hch@infradead.org>, <kw@linux.com>,
        <linux-pci@vger.kernel.org>, <rajur@chelsio.com>,
        <hverkuil-cisco@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH V4 0/6] PCI: Enable 10-Bit tag support for PCIe devices
Date:   Wed, 16 Jun 2021 11:39:20 +0800
Message-ID: <1623814766-91906-1-git-send-email-liudongdong3@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.21.59.169]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

10-Bit Tag capability, introduced in PCIe-4.0 increases the total Tag
field size from 8 bits to 10 bits.

This patchset is to enable 10-Bit tag for PCIe EP devices (include VF) and
RP devices

V3->V4:
- Get the value of pcie_devcap2 in set_pcie_port_type().
- Add Reviewed-by: Christoph Hellwig <hch@lst.de> in [PATCH V4 1/6],
  [PATCH V4 3/6], [PATCH V4 4/6], [PATCH V4 5/6].
- Fix some code style.
- Rebased on v5.13-rc6.

V2->V3:
- Use cached Device Capabilities Register suggested by Christoph.
- Fix code style to avoid > 80 char lines.
- Renamve devcap2 to pcie_devcap2.

V1->V2: Fix some comments by Christoph.
- Store the devcap2 value in the pci_dev instead of reading it multiple
  times.
- Change pci_info to pci_dbg to avoid the noisy log.
- Rename ext_10bit_tag_comp_path to ext_10bit_tag.
- Fix the compile error.
- Rebased on v5.13-rc1.

Dongdong Liu (6):
  PCI: Use cached Device Capabilities Register
  PCI: Use cached Device Capabilities 2 Register
  PCI: Add 10-Bit Tag register definitions
  PCI: Enable 10-Bit tag support for PCIe Endpoint devices
  PCI/IOV: Enable 10-Bit tag support for PCIe VF devices
  PCI: Enable 10-Bit tag support for PCIe RP devices

 drivers/media/pci/cobalt/cobalt-driver.c        |  5 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |  4 +-
 drivers/pci/iov.c                               |  8 +++
 drivers/pci/pci.c                               | 14 ++---
 drivers/pci/pcie/aspm.c                         | 11 ++--
 drivers/pci/pcie/portdrv_pci.c                  | 73 +++++++++++++++++++++++++
 drivers/pci/probe.c                             | 54 +++++++++++++-----
 drivers/pci/quirks.c                            |  3 +-
 include/linux/pci.h                             |  5 ++
 include/uapi/linux/pci_regs.h                   |  5 ++
 10 files changed, 145 insertions(+), 37 deletions(-)

--
2.7.4

