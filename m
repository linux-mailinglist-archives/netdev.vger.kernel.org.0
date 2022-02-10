Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A09054B1727
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 21:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344389AbiBJUnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 15:43:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238191AbiBJUnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 15:43:40 -0500
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 12:43:39 PST
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8D8109B;
        Thu, 10 Feb 2022 12:43:39 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.88,359,1635199200"; 
   d="scan'208";a="5603081"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 21:42:32 +0100
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-crypto@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        linux-ide@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [PATCH 0/9] use GFP_KERNEL
Date:   Thu, 10 Feb 2022 21:42:14 +0100
Message-Id: <20220210204223.104181-1-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Platform_driver and pci_driver probe functions aren't called with
locks held and thus don't need GFP_ATOMIC. Use GFP_KERNEL instead.

All changes have been compile-tested.

---

 drivers/ata/pata_mpc52xx.c               |    2 +-
 drivers/crypto/ux500/cryp/cryp_core.c    |    2 +-
 drivers/crypto/ux500/hash/hash_core.c    |    2 +-
 drivers/media/pci/cx18/cx18-driver.c     |    2 +-
 drivers/media/platform/fsl-viu.c         |    2 +-
 drivers/message/fusion/mptspi.c          |    2 +-
 drivers/mfd/sta2x11-mfd.c                |    2 +-
 drivers/mtd/devices/spear_smi.c          |    2 +-
 drivers/net/ethernet/moxa/moxart_ether.c |    4 ++--
 sound/soc/intel/boards/bytcr_wm5102.c    |    2 +-
 10 files changed, 11 insertions(+), 11 deletions(-)
