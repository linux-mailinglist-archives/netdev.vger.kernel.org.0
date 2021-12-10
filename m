Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C0E46FD2F
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 10:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbhLJJDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 04:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbhLJJDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 04:03:44 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13B6C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 01:00:09 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id g18so7888894pfk.5
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 01:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T/3YCVIcYZhtGsSe2dZenZzYij8hoSUNbzY6yPDHM54=;
        b=CnVwUAJTsVv3JI8uq9J7NiWxE84NYt5Gzsuy+4MNGR14CwaUH1xANdWFSEcFel3i74
         7pI3mRKChZ4E4QbYTCxmMsur56ZaV81+dyD1apIHHbhmMJN4hAwjzeoQK5b3sL4AkTMX
         atbzoOf5q8sXayrQKslJSfJN6kKEM+XAmH8XpP/019u4lsAs5K6Jya2WI4UcjQ45QXqI
         NVcbbCwGdZWvoaI+qoUZUWvdc9hrvfSJ4fmxH+ekcmTTf1AN481f66mOzGLsSQ96oyIA
         802eZpUc73REta9oFqESHvLD0Fz6gRagydGk8fikMCKEObW8fqU14qZLXk0BB4qqL1jd
         K9Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T/3YCVIcYZhtGsSe2dZenZzYij8hoSUNbzY6yPDHM54=;
        b=zlDg5maB0BGNIK73l5Ntyb6boQbM04p2sz7L78i4aTnOFAPsv2SgtErZiiahMlJeGR
         RrsRNQ8gBaqUK0oRWOp+i7Pq4LfLDliJvumrKxT5hBSJXBD9Yquvwo2ZobiGzR+fSwnV
         zANN52Z+RYXjRYcO/qbfI4DlrQtyY3IK+oxHb+peBJvtupx3WqUWzzJJJeCUbTrzon1+
         zSmMlpzBBlTD3bq6PccZQ8VuGNiZYpG07srp8Cr9RfQPwFsF9vN3rOuH+Meeg208Vj2Y
         hfBIUTwl1/Wg7VWzRRLHHUO4TPbbNDLYrl5rEtWBhxe+PPEphk0npViKy7xJYfiUMGoQ
         CaqA==
X-Gm-Message-State: AOAM530SLzhocGxwdXlLlozddgeSqmIsw+ZzrywiZVTYRXUv5tEYULZF
        0T52eNT52Ss4b/24HzjFkuqwNV5EkMo=
X-Google-Smtp-Source: ABdhPJyyr/lQJ9CC7ZNv0rp2ZHOWLWP0+ZnIVU2VikZv8z3Pism2YQ5MVyjhDL/XorIYA31IvLuBog==
X-Received: by 2002:a62:3888:0:b0:4a9:5e0e:8b99 with SMTP id f130-20020a623888000000b004a95e0e8b99mr16640510pfa.30.1639126808975;
        Fri, 10 Dec 2021 01:00:08 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o124sm2383038pfb.177.2021.12.10.01.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 01:00:08 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net-next 0/2] net: add new hwtstamp flag HWTSTAMP_FLAG_BONDED_PHC_INDEX
Date:   Fri, 10 Dec 2021 16:59:57 +0800
Message-Id: <20211210085959.2023644-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset add a new hwtstamp_config flag HWTSTAMP_FLAG_BONDED_PHC_INDEX.
When user want to get bond active interface's PHC, they need to add this flag
and aware the PHC index may changed.

v3: Use bitwise test to check the flags validation
v2: rename the flag to HWTSTAMP_FLAG_BONDED_PHC_INDEX

Hangbin Liu (2):
  net_tstamp: add new flag HWTSTAMP_FLAG_BONDED_PHC_INDEX
  Bonding: force user to add HWTSTAMP_FLAG_BONDED_PHC_INDEX when get/set
    HWTSTAMP

 drivers/net/bonding/bond_main.c               | 33 ++++++++++++-------
 .../net/dsa/hirschmann/hellcreek_hwtstamp.c   |  4 ---
 drivers/net/dsa/mv88e6xxx/hwtstamp.c          |  4 ---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  3 --
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  3 --
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  5 ---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c |  3 --
 drivers/net/ethernet/broadcom/tg3.c           |  3 --
 drivers/net/ethernet/cadence/macb_ptp.c       |  4 ---
 .../net/ethernet/cavium/liquidio/lio_main.c   |  3 --
 .../ethernet/cavium/liquidio/lio_vf_main.c    |  3 --
 .../net/ethernet/cavium/octeon/octeon_mgmt.c  |  3 --
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  4 ---
 drivers/net/ethernet/engleder/tsnep_ptp.c     |  3 --
 drivers/net/ethernet/freescale/fec_ptp.c      |  4 ---
 drivers/net/ethernet/freescale/gianfar.c      |  4 ---
 drivers/net/ethernet/intel/e1000e/netdev.c    |  4 ---
 drivers/net/ethernet/intel/i40e/i40e_ptp.c    |  4 ---
 drivers/net/ethernet/intel/ice/ice_ptp.c      |  4 ---
 drivers/net/ethernet/intel/igb/igb_ptp.c      |  4 ---
 drivers/net/ethernet/intel/igc/igc_ptp.c      |  4 ---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c  |  4 ---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  3 --
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  4 ---
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  4 ---
 drivers/net/ethernet/microchip/lan743x_ptp.c  |  6 ----
 drivers/net/ethernet/mscc/ocelot.c            |  4 ---
 .../net/ethernet/neterion/vxge/vxge-main.c    |  4 ---
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |  3 --
 drivers/net/ethernet/qlogic/qede/qede_ptp.c   |  5 ---
 drivers/net/ethernet/renesas/ravb_main.c      |  4 ---
 drivers/net/ethernet/sfc/ptp.c                |  3 --
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 ---
 drivers/net/ethernet/ti/cpsw_priv.c           |  4 ---
 drivers/net/ethernet/ti/netcp_ethss.c         |  4 ---
 drivers/net/ethernet/xscale/ixp4xx_eth.c      |  3 --
 drivers/net/phy/dp83640.c                     |  3 --
 drivers/net/phy/mscc/mscc_ptp.c               |  3 --
 drivers/ptp/ptp_ines.c                        |  4 ---
 include/uapi/linux/net_tstamp.h               | 16 ++++++++-
 net/core/dev_ioctl.c                          |  2 +-
 41 files changed, 37 insertions(+), 156 deletions(-)

-- 
2.31.1

