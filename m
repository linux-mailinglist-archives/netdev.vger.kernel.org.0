Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026226AE683
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 17:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjCGQbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 11:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCGQbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 11:31:08 -0500
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E699284F70
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 08:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version:content-type
        :content-transfer-encoding; s=k1; bh=TPA/48OT+2kB9yn2MigoHhqgXOt
        p9jPFDswRzTAc5g8=; b=3Zoihj5Dt8eXrRj9jMkYSxw6mJKY59FPznWASEkzuOO
        88NfaXIF96AWq7r5T29loJerRYjPDWaDQz70BSdlZXjlDFTF7UU59wyYWX38cmFL
        dJVRN7YalCZNx44TZR/D/SkYWgs7FzXt4zm9MRCD7856KAhoLQG7/VbN7jyubl3c
        =
Received: (qmail 751813 invoked from network); 7 Mar 2023 17:31:01 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 7 Mar 2023 17:31:01 +0100
X-UD-Smtp-Session: l3s3148p1@Urm671H2UIMgAQnoAFQ+AGEn9EY5VOxJ
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-renesas-soc@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 00/11] tree-wide: remove support for Renesas R-Car H3 ES1
Date:   Tue,  7 Mar 2023 17:30:28 +0100
Message-Id: <20230307163041.3815-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because H3 ES1 becomes an increasing maintenance burden and was only available
to a development group, we decided to remove upstream support for it. Here are
the patches to remove driver changes. Review tags have been gathered before
during an internal discussion. Only change since the internal version is a
plain rebase to v6.3-rc1. A branch with all removals is here:

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git renesas/h3es1-removal

Please apply individually per subsystem. There are no dependencies and the SoC
doesn't boot anymore since v6.3-rc1.

Thanks and happy hacking!


Wolfram Sang (11):
  iommu/ipmmu-vmsa: remove R-Car H3 ES1.* handling
  drm: rcar-du: remove R-Car H3 ES1.* workarounds
  media: rcar-vin: remove R-Car H3 ES1.* handling
  media: rcar-vin: csi2: remove R-Car H3 ES1.* handling
  media: renesas: fdp1: remove R-Car H3 ES1.* handling
  thermal/drivers/rcar_gen3_thermal: remove R-Car H3 ES1.* handling
  ravb: remove R-Car H3 ES1.* handling
  mmc: renesas_sdhi: remove R-Car H3 ES1.* handling
  usb: host: xhci-rcar: remove leftover quirk handling
  usb: host: xhci-rcar: remove R-Car H3 ES1.* handling
  usb: gadget: udc: renesas_usb3: remove R-Car H3 ES1.* handling

 drivers/gpu/drm/rcar-du/rcar_du_crtc.c        | 37 ++-----------
 drivers/gpu/drm/rcar-du/rcar_du_drv.c         | 48 -----------------
 drivers/gpu/drm/rcar-du/rcar_du_drv.h         |  2 -
 drivers/gpu/drm/rcar-du/rcar_du_regs.h        |  3 +-
 drivers/iommu/ipmmu-vmsa.c                    |  1 -
 .../platform/renesas/rcar-vin/rcar-core.c     | 36 -------------
 .../platform/renesas/rcar-vin/rcar-csi2.c     | 15 ++----
 drivers/media/platform/renesas/rcar_fdp1.c    |  4 --
 drivers/mmc/host/renesas_sdhi_internal_dmac.c | 10 ++--
 drivers/net/ethernet/renesas/ravb_main.c      | 15 ------
 drivers/thermal/rcar_gen3_thermal.c           | 52 +------------------
 drivers/usb/gadget/udc/renesas_usb3.c         | 23 +-------
 drivers/usb/host/xhci-rcar.c                  | 34 +-----------
 13 files changed, 16 insertions(+), 264 deletions(-)

-- 
2.35.1

