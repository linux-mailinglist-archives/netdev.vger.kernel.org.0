Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4371B27DCD4
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 01:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgI2Xni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 19:43:38 -0400
Received: from mga06.intel.com ([134.134.136.31]:13564 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728895AbgI2Xnh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 19:43:37 -0400
IronPort-SDR: Ri2HLab/LEU91VJfEkHm2THRRpGYzS2KfQtl/eq6pbj8eiWI4TR5S5doIvQdwnYa4xMtIywamM
 9VfGKhjcnyGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="223915017"
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="223915017"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 16:43:37 -0700
IronPort-SDR: 4Bb8KL8d9XZJkcTMFb0ZQ4w7cw5SWWtQ8Q4OO7gG+NkLOz42JVJi0tgxOg5dCalQKuRcfnayh7
 MzPgzonnRhmw==
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="350464199"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 16:43:36 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [iproute2-next 0/2] devlink: add flash update overwrite mask
Date:   Tue, 29 Sep 2020 16:42:35 -0700
Message-Id: <20200929234237.3567664-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.497.g54e85e7af1ac
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements the iproute2 side of the new
DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK.

This attribute is used to allow userspace to indicate what a device should
do with various subsections of a flash component when updating. For example,
a flash component might contain vital data such as the PCIe serial number or
configuration fields such as settings that control device bootup.

The overwrite mask allows the user to specify what behavior they want when
performing an update. If nothing is specified, then the update should
preserve all vital fields and configuration.

By specifying "overwrite identifiers" the user requests that the flash
update should overwrite any identifiers in the updated flash component with
identifier values from the provided flash image.

  $devlink dev flash pci/0000:af:00.0 file flash_image.bin overwrite identifiers

By specifying "overwrite settings" the user requests that the flash update
should overwrite any settings in the updated flash component with setting
values from the provided flash image.

  $devlink dev flash pci/0000:af:00.0 file flash_image.bin overwrite settings

These options may be combined, in which case both subsections will be sent
in the overwrite mask, resulting in a request to overwrite all settings and
identifiers stored in the updated flash components.

  $devlink dev flash pci/0000:af:00.0 file flash_image.bin overwrite settings overwrite identifiers

Jacob Keller (2):
  Update kernel headers for devlink
  devlink: support setting the overwrite mask

 devlink/devlink.c            | 48 ++++++++++++++++++++++++++++++++++--
 include/uapi/linux/devlink.h |  2 ++
 2 files changed, 48 insertions(+), 2 deletions(-)


base-commit: d2be31d9b671ec0b3e32f56f9c913e249ed048bd
-- 
2.28.0.497.g54e85e7af1ac

