Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B39E136360
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgAIWqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:46:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:46855 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbgAIWqd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 17:46:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 14:46:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="421926783"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2020 14:46:32 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 00/17] devlink documentation refactor
Date:   Thu,  9 Jan 2020 14:46:08 -0800
Message-Id: <20200109224625.1470433-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series updates the devlink documentation, with a few primary goals

 * move all of the devlink documentation into a dedicated subfolder
 * convert that documentation to the reStructuredText format
 * merge driver-specific documentations into a single file per driver
 * add missing documentation, including per-driver and devlink generally

For each driver, I took the time to review the code and add further
documentation on the various features it currently supports. Additionally, I
added new documentation files for some of the features such as
devlink-dpipe, devlink-resource, and devlink-regions.

Note for the region snapshot triggering, I kept that as a separate patch as
that is based on work that has not yet been merged to net-next, and may
change.

I also improved the existing documentation for devlink-info and
devlink-param by adding a bit more of an introduction when converting it to
the rst format.

Jacob Keller (17):
  devlink: add macro for "fw.psid"
  devlink: move devlink documentation to subfolder
  devlink: convert devlink-health.txt to rst format
  devlink: rename devlink-info-versions.rst and add a header
  devlink: convert devlink-params.txt to reStructuredText
  devlink: add documentation for generic devlink parameters
  devlink: mention reloading in devlink-params.rst
  devlink: convert driver-specific files to reStructuredText
  devlink: document info versions for each driver
  devlink: add parameter documentation for the mlx4 driver
  devlink: add a driver-specific file for the qed driver
  devlink: add a file documenting devlink regions
  devlink: add documentation for ionic device driver
  devlink: rename and expand devlink-trap-netdevsim.rst
  devlink: add a devlink-resource.rst documentation file
  devlink: introduce devlink-dpipe.rst documentation file
  devlink: document region snapshot triggering from userspace

 .../device_drivers/ti/cpsw_switchdev.txt      |   2 +-
 Documentation/networking/devlink-health.txt   |  86 ------
 .../networking/devlink-info-versions.rst      |  64 -----
 .../networking/devlink-params-bnxt.txt        |  18 --
 .../networking/devlink-params-mlx5.txt        |  17 --
 .../networking/devlink-params-mlxsw.txt       |  10 -
 .../networking/devlink-params-mv88e6xxx.txt   |   7 -
 .../networking/devlink-params-nfp.txt         |   5 -
 .../devlink-params-ti-cpsw-switch.txt         |  10 -
 Documentation/networking/devlink-params.txt   |  71 -----
 .../networking/devlink-trap-netdevsim.rst     |  20 --
 Documentation/networking/devlink/bnxt.rst     |  41 +++
 .../networking/devlink/devlink-dpipe.rst      | 252 ++++++++++++++++++
 .../networking/devlink/devlink-health.rst     | 114 ++++++++
 .../networking/devlink/devlink-info.rst       |  94 +++++++
 .../networking/devlink/devlink-params.rst     | 108 ++++++++
 .../networking/devlink/devlink-region.rst     |  60 +++++
 .../networking/devlink/devlink-resource.rst   |  62 +++++
 .../networking/{ => devlink}/devlink-trap.rst |   2 +-
 Documentation/networking/devlink/index.rst    |  42 +++
 Documentation/networking/devlink/ionic.rst    |  29 ++
 Documentation/networking/devlink/mlx4.rst     |  56 ++++
 Documentation/networking/devlink/mlx5.rst     |  59 ++++
 Documentation/networking/devlink/mlxsw.rst    |  59 ++++
 .../networking/devlink/mv88e6xxx.rst          |  28 ++
 .../networking/devlink/netdevsim.rst          |  72 +++++
 Documentation/networking/devlink/nfp.rst      |  65 +++++
 Documentation/networking/devlink/qed.rst      |  26 ++
 .../networking/devlink/ti-cpsw-switch.rst     |  31 +++
 Documentation/networking/index.rst            |   4 +-
 MAINTAINERS                                   |   3 +-
 drivers/net/netdevsim/dev.c                   |   2 +-
 include/net/devlink.h                         |   6 +-
 33 files changed, 1208 insertions(+), 317 deletions(-)
 delete mode 100644 Documentation/networking/devlink-health.txt
 delete mode 100644 Documentation/networking/devlink-info-versions.rst
 delete mode 100644 Documentation/networking/devlink-params-bnxt.txt
 delete mode 100644 Documentation/networking/devlink-params-mlx5.txt
 delete mode 100644 Documentation/networking/devlink-params-mlxsw.txt
 delete mode 100644 Documentation/networking/devlink-params-mv88e6xxx.txt
 delete mode 100644 Documentation/networking/devlink-params-nfp.txt
 delete mode 100644 Documentation/networking/devlink-params-ti-cpsw-switch.txt
 delete mode 100644 Documentation/networking/devlink-params.txt
 delete mode 100644 Documentation/networking/devlink-trap-netdevsim.rst
 create mode 100644 Documentation/networking/devlink/bnxt.rst
 create mode 100644 Documentation/networking/devlink/devlink-dpipe.rst
 create mode 100644 Documentation/networking/devlink/devlink-health.rst
 create mode 100644 Documentation/networking/devlink/devlink-info.rst
 create mode 100644 Documentation/networking/devlink/devlink-params.rst
 create mode 100644 Documentation/networking/devlink/devlink-region.rst
 create mode 100644 Documentation/networking/devlink/devlink-resource.rst
 rename Documentation/networking/{ => devlink}/devlink-trap.rst (99%)
 create mode 100644 Documentation/networking/devlink/index.rst
 create mode 100644 Documentation/networking/devlink/ionic.rst
 create mode 100644 Documentation/networking/devlink/mlx4.rst
 create mode 100644 Documentation/networking/devlink/mlx5.rst
 create mode 100644 Documentation/networking/devlink/mlxsw.rst
 create mode 100644 Documentation/networking/devlink/mv88e6xxx.rst
 create mode 100644 Documentation/networking/devlink/netdevsim.rst
 create mode 100644 Documentation/networking/devlink/nfp.rst
 create mode 100644 Documentation/networking/devlink/qed.rst
 create mode 100644 Documentation/networking/devlink/ti-cpsw-switch.rst

-- 
2.25.0.rc1

