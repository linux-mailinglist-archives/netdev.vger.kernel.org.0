Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91096363B99
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 08:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbhDSGjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 02:39:23 -0400
Received: from mga12.intel.com ([192.55.52.136]:32762 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229630AbhDSGjW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 02:39:22 -0400
IronPort-SDR: fithrntEnbkqI+ZMRifUZKEJ4w1Rd+MaNQK3XHISLrAcHOK0wAMP3hacVium1EG8E89W12tc9K
 E15C8K1eYT2g==
X-IronPort-AV: E=McAfee;i="6200,9189,9958"; a="174766091"
X-IronPort-AV: E=Sophos;i="5.82,233,1613462400"; 
   d="scan'208";a="174766091"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2021 23:38:52 -0700
IronPort-SDR: WSKcKiyUlWqe20hedjo0o9RhDUU6UeZ9trksqtiStHNusdT3iocgr7fAx25JiX0s6ycTxP+qyu
 MLxSXq9iDVOg==
X-IronPort-AV: E=Sophos;i="5.82,233,1613462400"; 
   d="scan'208";a="523328521"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2021 23:38:50 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 0/3] vDPA/ifcvf: enables Intel C5000X-PL virtio-blk
Date:   Mon, 19 Apr 2021 14:33:23 +0800
Message-Id: <20210419063326.3748-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series enabled Intel FGPA SmartNIC C5000X-PL virtio-blk for vDPA.

This series requires:
Stefano's vdpa block patchset: https://lkml.org/lkml/2021/3/15/2113
my patchset to enable Intel FGPA SmartNIC C5000X-PL virtio-net for vDPA:
https://lkml.org/lkml/2021/3/17/432

changes from V3:
remove (pdev->device < 0x1000 || pdev->device > 0x107f) checks in
probe(), because id_table already cut them off(Jason)

changes from V2:
both get_features() and get_config_size() use switch code block
now(Stefano)

changes from V1:
(1)add comments to explain this driver drives virtio modern devices
and transitional devices in modern mode.(Jason)
(2)remove IFCVF_BLK_SUPPORTED_FEATURES, use hardware feature bits
directly(Jason)
(3)add error handling and message in get_config_size(Stefano)

Thanks!

Zhu Lingshan (3):
  vDPA/ifcvf: deduce VIRTIO device ID when probe
  vDPA/ifcvf: enable Intel C5000X-PL virtio-block for vDPA
  vDPA/ifcvf: get_config_size should return dev specific config size

 drivers/vdpa/ifcvf/ifcvf_base.h |  9 ++++-
 drivers/vdpa/ifcvf/ifcvf_main.c | 65 ++++++++++++++++++++++++++-------
 2 files changed, 59 insertions(+), 15 deletions(-)

-- 
2.27.0

