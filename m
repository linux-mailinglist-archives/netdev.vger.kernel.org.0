Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81881F9B2E
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 16:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbgFOO7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 10:59:20 -0400
Received: from m12-14.163.com ([220.181.12.14]:38337 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730697AbgFOO7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 10:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=dEe5e
        43rDVb5syfbbJurCXIT1sjOVadZWQ34XIbuhM0=; b=ezIYXHaDQ2nTu9R7C36Fp
        yLexiC0DX1Z2f548FKlV/lYJujSRvnzsD8oed7NuHXlI5K53VvUhpW6yOo5iEC3q
        yVrQhBmNK+MicViLShCtRE0R3ZoCWhtdbZBjLiYUr2R6xF63VoewJu5e3UGOOyqy
        bj43jtw0RabD4xwfBWzoSU=
Received: from SZA191027643-PM.china.huawei.com (unknown [223.74.115.177])
        by smtp10 (Coremail) with SMTP id DsCowABXOli7jOdeQnE4Gw--.52836S2;
        Mon, 15 Jun 2020 22:59:08 +0800 (CST)
From:   yunaixin03610@163.com
To:     netdev@vger.kernel.org
Cc:     yunaixin <yunaixin@huawei.com>
Subject: [PATCH 0/5] Adding Huawei BMA drivers
Date:   Mon, 15 Jun 2020 22:59:01 +0800
Message-Id: <20200615145906.1013-1-yunaixin03610@163.com>
X-Mailer: git-send-email 2.26.2.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-CM-TRANSID: DsCowABXOli7jOdeQnE4Gw--.52836S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxtw4DtFWUKrW3tr15Aw1UZFb_yoWxtFWrpa
        yjya4UurWxKFy7Xw1vy3W8KFn8J3WDtry5u393Z3WrX3s2yry5JryDWF15uF1fWa97Gr4I
        vF1Y9F1fWFZ8X3JanT9S1TB71UUUUjUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjD7-UUUUU=
X-Originating-IP: [223.74.115.177]
X-CM-SenderInfo: 51xqtxx0lqijqwrqqiywtou0bp/1tbiVB9E5lUMNSUcfAABsB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: yunaixin <yunaixin@huawei.com>

This patch set contains 5 communication drivers for Huawei BMA software.=0D
The BMA software is a system management software. It supports the status=0D
monitoring, performance monitoring, and event monitoring of various=0D
components, including server CPUs, memory, hard disks, NICs, IB cards,=0D
PCIe cards, RAID controller cards, and optical modules.=0D
=0D
These 5 drivers are used to send/receive message through PCIe channel in=0D
different ways by BMA software.

yunaixin (5):
  Huawei BMA: Adding Huawei BMA driver: host_edma_drv
  Huawei BMA: Adding Huawei BMA driver: host_cdev_drv
  Huawei BMA: Adding Huawei BMA driver: host_veth_drv
  Huawei BMA: Adding Huawei BMA driver: cdev_veth_drv
  Huawei BMA: Adding Huawei BMA driver: host_kbox_drv

 drivers/net/ethernet/huawei/Kconfig           |    1 +
 drivers/net/ethernet/huawei/Makefile          |    1 +
 drivers/net/ethernet/huawei/bma/Kconfig       |    5 +
 drivers/net/ethernet/huawei/bma/Makefile      |    9 +
 .../net/ethernet/huawei/bma/cdev_drv/Kconfig  |   11 +
 .../net/ethernet/huawei/bma/cdev_drv/Makefile |    2 +
 .../ethernet/huawei/bma/cdev_drv/bma_cdev.c   |  369 +++
 .../ethernet/huawei/bma/cdev_veth_drv/Kconfig |   11 +
 .../huawei/bma/cdev_veth_drv/Makefile         |    2 +
 .../bma/cdev_veth_drv/virtual_cdev_eth_net.c  | 1839 ++++++++++++
 .../bma/cdev_veth_drv/virtual_cdev_eth_net.h  |  300 ++
 .../net/ethernet/huawei/bma/edma_drv/Kconfig  |   11 +
 .../net/ethernet/huawei/bma/edma_drv/Makefile |    2 +
 .../huawei/bma/edma_drv/bma_devintf.c         |  597 ++++
 .../huawei/bma/edma_drv/bma_devintf.h         |   40 +
 .../huawei/bma/edma_drv/bma_include.h         |  118 +
 .../ethernet/huawei/bma/edma_drv/bma_pci.c    |  533 ++++
 .../ethernet/huawei/bma/edma_drv/bma_pci.h    |   94 +
 .../ethernet/huawei/bma/edma_drv/edma_host.c  | 1462 ++++++++++
 .../ethernet/huawei/bma/edma_drv/edma_host.h  |  351 +++
 .../huawei/bma/include/bma_ker_intf.h         |   91 +
 .../net/ethernet/huawei/bma/kbox_drv/Kconfig  |   11 +
 .../net/ethernet/huawei/bma/kbox_drv/Makefile |    2 +
 .../ethernet/huawei/bma/kbox_drv/kbox_dump.c  |  122 +
 .../ethernet/huawei/bma/kbox_drv/kbox_dump.h  |   33 +
 .../ethernet/huawei/bma/kbox_drv/kbox_hook.c  |  101 +
 .../ethernet/huawei/bma/kbox_drv/kbox_hook.h  |   33 +
 .../huawei/bma/kbox_drv/kbox_include.h        |   42 +
 .../ethernet/huawei/bma/kbox_drv/kbox_main.c  |  168 ++
 .../ethernet/huawei/bma/kbox_drv/kbox_main.h  |   23 +
 .../ethernet/huawei/bma/kbox_drv/kbox_mce.c   |  264 ++
 .../ethernet/huawei/bma/kbox_drv/kbox_mce.h   |   23 +
 .../ethernet/huawei/bma/kbox_drv/kbox_panic.c |  187 ++
 .../ethernet/huawei/bma/kbox_drv/kbox_panic.h |   25 +
 .../huawei/bma/kbox_drv/kbox_printk.c         |  362 +++
 .../huawei/bma/kbox_drv/kbox_printk.h         |   33 +
 .../huawei/bma/kbox_drv/kbox_ram_drive.c      |  188 ++
 .../huawei/bma/kbox_drv/kbox_ram_drive.h      |   31 +
 .../huawei/bma/kbox_drv/kbox_ram_image.c      |  135 +
 .../huawei/bma/kbox_drv/kbox_ram_image.h      |   84 +
 .../huawei/bma/kbox_drv/kbox_ram_op.c         |  986 +++++++
 .../huawei/bma/kbox_drv/kbox_ram_op.h         |   77 +
 .../net/ethernet/huawei/bma/veth_drv/Kconfig  |   11 +
 .../net/ethernet/huawei/bma/veth_drv/Makefile |    2 +
 .../ethernet/huawei/bma/veth_drv/veth_hb.c    | 2508 +++++++++++++++++
 .../ethernet/huawei/bma/veth_drv/veth_hb.h    |  442 +++
 46 files changed, 11742 insertions(+)
 create mode 100644 drivers/net/ethernet/huawei/bma/Kconfig
 create mode 100644 drivers/net/ethernet/huawei/bma/Makefile
 create mode 100644 drivers/net/ethernet/huawei/bma/cdev_drv/Kconfig
 create mode 100644 drivers/net/ethernet/huawei/bma/cdev_drv/Makefile
 create mode 100644 drivers/net/ethernet/huawei/bma/cdev_drv/bma_cdev.c
 create mode 100644 drivers/net/ethernet/huawei/bma/cdev_veth_drv/Kconfig
 create mode 100644 drivers/net/ethernet/huawei/bma/cdev_veth_drv/Makefile
 create mode 100644 drivers/net/ethernet/huawei/bma/cdev_veth_drv/virtual_c=
dev_eth_net.c
 create mode 100644 drivers/net/ethernet/huawei/bma/cdev_veth_drv/virtual_c=
dev_eth_net.h
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/Kconfig
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/Makefile
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/bma_devintf.c
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/bma_devintf.h
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/bma_include.h
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/bma_pci.c
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/bma_pci.h
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/edma_host.c
 create mode 100644 drivers/net/ethernet/huawei/bma/edma_drv/edma_host.h
 create mode 100644 drivers/net/ethernet/huawei/bma/include/bma_ker_intf.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/Kconfig
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/Makefile
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_dump.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_dump.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_hook.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_hook.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_include.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_main.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_main.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_mce.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_mce.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_panic.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_panic.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_printk.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_printk.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_drive=
.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_drive=
.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_image=
.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_image=
.h
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_op.c
 create mode 100644 drivers/net/ethernet/huawei/bma/kbox_drv/kbox_ram_op.h
 create mode 100644 drivers/net/ethernet/huawei/bma/veth_drv/Kconfig
 create mode 100644 drivers/net/ethernet/huawei/bma/veth_drv/Makefile
 create mode 100644 drivers/net/ethernet/huawei/bma/veth_drv/veth_hb.c
 create mode 100644 drivers/net/ethernet/huawei/bma/veth_drv/veth_hb.h

--=20
2.26.2.windows.1


