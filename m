Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A533592D12
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 12:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241942AbiHOJex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 05:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbiHOJew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 05:34:52 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6526A1117F;
        Mon, 15 Aug 2022 02:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660556091; x=1692092091;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b2nMgVoDmZRok+G5jFuN3MkuIp+LX/igDeVHIvm3Yxo=;
  b=KElPWeuDzpAQZrTx35w+5BZ9DiblEHxJi+B6IorQWqr55BEgh6z2LyvT
   GLQN1tqvIj70fviJU7iXDQ3TFt/ZKwIpon+f6wRHf7T7FtM0V/qGydgIr
   EluJ1OJ185jkDxT9F4DDPy9vwDDdlfhegicyBQiydaWBgJW1az9aGyRFe
   lB9vPQqcQJGidgTGZ54uuw0TRKjc/nkuJy/ImbCLB8akbx8WFT/5fpIOL
   cgH28jpDcEgSCoe8ZFNvG+FTXT2S5qaxH96FcdLqpDHUYBcNLNo24jmYB
   RfqXmoWc2SuUNpVXAHB5dosJExA7fILKh6v4ZuXaRZELEodm7ycuBSYzk
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10439"; a="353668398"
X-IronPort-AV: E=Sophos;i="5.93,238,1654585200"; 
   d="scan'208";a="353668398"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 02:34:50 -0700
X-IronPort-AV: E=Sophos;i="5.93,238,1654585200"; 
   d="scan'208";a="666604151"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 02:34:48 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 0/2] allow userspace to query device features
Date:   Mon, 15 Aug 2022 17:26:36 +0800
Message-Id: <20220815092638.504528-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series allows userspace to query device features of
a vDPA device through a new netlink attr
VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES

This series also make some fields of virtio-net 
device config space conditional on the feature bits,
this means:

MTU should be conditional on VIRTIO_F_NET_MTU
MAC should be conditional on VIRTIO_F_NET_MAC
MQ should be conditional on VIRTIO_F_NET_MQ

For details, please refer to commit message
of patch 2/2

Thanks!

Zhu Lingshan (2):
  vDPA: allow userspace to query features of a vDPA device
  vDPA: conditionally read fields in virtio-net dev

 drivers/vdpa/vdpa.c       | 71 +++++++++++++++++++++++++++++++--------
 include/uapi/linux/vdpa.h |  3 ++
 2 files changed, 60 insertions(+), 14 deletions(-)

-- 
2.31.1

