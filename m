Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 648A9128976
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 15:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfLUOO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 09:14:57 -0500
Received: from smtp7.web4u.cz ([81.91.87.87]:51144 "EHLO mx-8.mail.web4u.cz"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726339AbfLUOO4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Dec 2019 09:14:56 -0500
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Dec 2019 09:14:54 EST
Received: from mx-8.mail.web4u.cz (localhost [127.0.0.1])
        by mx-8.mail.web4u.cz (Postfix) with ESMTP id 3806920365D;
        Sat, 21 Dec 2019 15:07:40 +0100 (CET)
Received: from thor.pikron.com (unknown [89.102.8.6])
        (Authenticated sender: ppisa@pikron.com)
        by mx-8.mail.web4u.cz (Postfix) with ESMTPA id C31982028B9;
        Sat, 21 Dec 2019 15:07:39 +0100 (CET)
From:   pisa@cmp.felk.cvut.cz
To:     devicetree@vger.kernel.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, socketcan@hartkopp.net
Cc:     wg@grandegger.com, davem@davemloft.net, robh+dt@kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.jerabek01@gmail.com,
        ondrej.ille@gmail.com, jnovak@fel.cvut.cz, jara.beran@gmail.com,
        porazil@pikron.com, Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [PATCH v3 0/6] CTU CAN FD open-source IP core SocketCAN driver, PCI, platform integration and documentation
Date:   Sat, 21 Dec 2019 15:07:29 +0100
Message-Id: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-W4U-Auth: 45b96b56ea6a80041d650a8b1a415143a1868872
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Pisa <pisa@cmp.felk.cvut.cz>

This driver adds support for the CTU CAN FD open-source IP core.
More documentation and core sources at project page
(https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core).
The core integration to Xilinx Zynq system as platform driver
is available (https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top).
Implementation on Intel FGA based PCI Express board is available
from project (https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd).
More about CAN related projects used and developed at the Faculty
of the Electrical Engineering (http://www.fel.cvut.cz/en/)
of Czech Technical University (https://www.cvut.cz/en)
in at Prague http://canbus.pages.fel.cvut.cz/ .

Martin Jerabek (1):
  can: ctucanfd: add support for CTU CAN FD open-source IP core - bus
    independent part.

Pavel Pisa (5):
  dt-bindings: vendor-prefix: add prefix for Czech Technical University
    in Prague.
  dt-bindings: net: can: binding for CTU CAN FD open-source IP core.
  can: ctucanfd: CTU CAN FD open-source IP core - PCI bus support.
  can: ctucanfd: CTU CAN FD open-source IP core - platform/SoC support.
  docs: ctucanfd: CTU CAN FD open-source IP core documentation.

The version 3 chages:
  - adapts device tree bindings documentation according to
    Rob Herring suggestions.
  - the driver has been separated to individual modules for core support,
    PCI bus integration and platform, SoC integration.
  - the FPGA design has been cleaned up and CAN protocol FSM redesigned
    by Onrej Ille (the core redesign has been reason to pause attempts to driver
    submission)
  - the work from February 2019 on core, test framework and driver
    1601 commits in total, 436 commits in the core sources, 144 commits
    in the driver, 151 docuemnation, 502 in tests.
  - not all continuos integration tests updated for latest design version yet
    https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core/pipelines
  - Zynq hardware in the loop test show no issues for after driver PCI and platform
    separation and latest VHDL sources updates.
  - driver code has been periodically tested on 4.18.5-rt3 and 4.19 long term
    stable kernels.
  - test of the patches before submission is run on 5.4 kernel
  - the core has been integrated by Jaroslav Beran <jara.beran@gmail.com>
    into Intel FPGA based SoC used in the tester developed for Skoda auto
    at Department of Measurement, Faculty of Electrical Engineering,
    Czech Technical University https://meas.fel.cvut.cz/ . He has contributed
    feedbak and fixes to the project.

Ondrej Ille prepares the CTU CAN IP Core sources for new release now.
It should happen in one or two months. Intention is to finalize
review of the patches and updates according to the comments by that
time, ideally to be on the way to mainline when IP is released.

DKMS CTU CAN FD driver build by OpenBuildService to ease integration
into Debian systems when driver is not provided by the distribution

https://build.opensuse.org/package/show/home:ppisa/ctu_can_fd

Jan Charvat <charvj10@fel.cvut.cz> started the work to extend
our already mainlined QEMU SJA1000 and SocketCAN support
to provide even CAN FD support and CTU CAN FD core support

https://gitlab.fel.cvut.cz/canbus/qemu-canbus/tree/charvj10-canfd

Planned time of the thesis submission is the summer 2020.
QEMU mainlining efforts should start in optimal case by that time.

Thanks in advance to all who help us to deliver the project into public.

Thanks to all colleagues, reviewers and other providing feedback,
infrastructure and enthusiasm and motivation for open-source work.

Build infrastructure and hardware is provided by
  Department of Control Engineering,
  Faculty of Electrical Engineering,
  Czech Technical University in Prague
  https://dce.fel.cvut.cz/en

 .../devicetree/bindings/net/can/ctu,ctucanfd.txt   |   61 ++
 .../devicetree/bindings/vendor-prefixes.yaml       |    2 +
 .../device_drivers/ctu/FSM_TXT_Buffer_user.png     |  Bin 0 -> 174807 bytes
 .../device_drivers/ctu/ctucanfd-driver.rst         |  613 +++++++++++
 drivers/net/can/Kconfig                            |    1 +
 drivers/net/can/Makefile                           |    1 +
 drivers/net/can/ctucanfd/Kconfig                   |   38 +
 drivers/net/can/ctucanfd/Makefile                  |   13 +
 drivers/net/can/ctucanfd/ctu_can_fd.c              | 1116 ++++++++++++++++++++
 drivers/net/can/ctucanfd/ctu_can_fd.h              |   88 ++
 drivers/net/can/ctucanfd/ctu_can_fd_frame.h        |  190 ++++
 drivers/net/can/ctucanfd/ctu_can_fd_hw.c           |  781 ++++++++++++++
 drivers/net/can/ctucanfd/ctu_can_fd_hw.h           |  917 ++++++++++++++++
 drivers/net/can/ctucanfd/ctu_can_fd_pci.c          |  316 ++++++
 drivers/net/can/ctucanfd/ctu_can_fd_platform.c     |  145 +++
 drivers/net/can/ctucanfd/ctu_can_fd_regs.h         |  965 +++++++++++++++++
 16 files changed, 5247 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/can/ctu,ctucanfd.txt
 create mode 100644 Documentation/networking/device_drivers/ctu/FSM_TXT_Buffer_user.png
 create mode 100644 Documentation/networking/device_drivers/ctu/ctucanfd-driver.rst
 create mode 100644 drivers/net/can/ctucanfd/Kconfig
 create mode 100644 drivers/net/can/ctucanfd/Makefile
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd.c
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd.h
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd_frame.h
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd_hw.c
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd_hw.h
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd_pci.c
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd_platform.c
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd_regs.h

-- 
2.11.0

