Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4B126390C
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 00:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbgIIW3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 18:29:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:32737 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730067AbgIIW3l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 18:29:41 -0400
IronPort-SDR: bCBfMZLEqR7nvh9Bh0ecF993JSBq/6oqfCU9Iv8h5VlZXOJn3SQfFtEMD6okhEIrHXDz/w8Lpf
 d3EurMQl5oEA==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="146141077"
X-IronPort-AV: E=Sophos;i="5.76,410,1592895600"; 
   d="scan'208";a="146141077"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 15:29:35 -0700
IronPort-SDR: Oh6aMKwuqzx3Pa4cJcbj/c4OUUpNs4VJ45LKvqzibQetmMZls6zWDa1VGAP4l8GbrWY8PUBeLn
 wF/AQXM17ZeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,410,1592895600"; 
   d="scan'208";a="480641406"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by orsmga005.jf.intel.com with ESMTP; 09 Sep 2020 15:29:35 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [iproute2-next v4 0/2] devlink: add flash update overwrite mask
Date:   Wed,  9 Sep 2020 15:28:40 -0700
Message-Id: <20200909222842.33952-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.218.ge27853923b9d.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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

Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jakub Kicinski <kuba@kernel.org>

Jacob Keller (2):
  Update devlink header for overwrite mask attribute
  devlink: support setting the overwrite mask

 devlink/devlink.c            | 48 ++++++++++++++++++++++++++++++++++--
 include/uapi/linux/devlink.h | 27 ++++++++++++++++++++
 2 files changed, 73 insertions(+), 2 deletions(-)


base-commit: ad34d5fadb0b4699b0fe136fc408685e26bb1b43
-- 
2.28.0.218.ge27853923b9d

