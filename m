Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F4F46CCA6
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 05:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244280AbhLHErF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 23:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240064AbhLHErC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 23:47:02 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592D1C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 20:43:28 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id u11so757254plf.3
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 20:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vvOKTjSqGbkVM8o2ReZbxPR/Vf+GQT4NWMeKMdhMtKw=;
        b=F5J55I1GYsY21heIQXi9Jr8OWlIDZtF4E/eEASWlI5pUr3qGbgM37v2NwrmLR01jRf
         hebGBtciGs3c5UWjpg+3WFmllAsyR+Qz4uV6ST0DwnBSadE583PrE/FkftaW9xuLn1hC
         126ha5GmtrKYtuYInxMZTi7PGdVM4mRI7qoRYZTcx/BMVBkwb9ThfsyzkN4PaEwMZL2j
         SQYNxHWM/fhP9aC77fnJ3HGBiLQeaufBUPfxDLPdaOugaGIXzrvBRUA05YI7hvGIMIvQ
         B4PcVhhrJKWWwMY3gmGhRL25QMrLJjjYb/6Nc2VQH0RuQTcIN/aGiHj5pkha/kPsz4wi
         7ZzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vvOKTjSqGbkVM8o2ReZbxPR/Vf+GQT4NWMeKMdhMtKw=;
        b=oXBEfanbWg5ZMwUHZNyrWNKkedySDTUE0I1WitreZ/oFDK9uHtCUzIp+YE0pWv1U7/
         +IDOt50hZv7bWYf0Nlh+gpZhduWeebeEjzReaxMPFmMQy3SwzFkHgXh+fUyuSTLvzxFU
         hjizfMV0UCnZr7Kq0St1XtxJibJcTWV8PK7o/Wg2/8rwXiXLvGzGJSf+ikhExoBTvKw/
         WO8K6kZru8eQJlak/LiL1tI88R+xEl3pUxHi6OPzRv4AiOFa3VaI9qFXUzcQ8EKqj4+R
         iwCtHtH0e6Of/SzSTk2VbYKFQwJvgqUnaExw5H2P8EyGEz/hU+lNqOYrsnWVw010mNfK
         praA==
X-Gm-Message-State: AOAM533x/XArh4iIDo8URrvPsUzh+Dqgpd38/eSFfkLdtpYYrKBYMMgM
        RV5H6uFPK2IFXuLf4uRhclOnrrMMbMw=
X-Google-Smtp-Source: ABdhPJyLWZWm2F1zNOnzx6FC1WltQsPkaSyM4tpN4Qw6BXZhF2f8X7vU/Qx1Iw6xbZT19gBcDHkGxg==
X-Received: by 2002:a17:903:4053:b0:143:6d84:984c with SMTP id n19-20020a170903405300b001436d84984cmr57058769pla.37.1638938607551;
        Tue, 07 Dec 2021 20:43:27 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u12sm1491631pfk.71.2021.12.07.20.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 20:43:26 -0800 (PST)
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
Subject: [PATCH net-next 0/2] net: add new hwtstamp flag HWTSTAMP_FLAGS_UNSTABLE_PHC
Date:   Wed,  8 Dec 2021 12:42:22 +0800
Message-Id: <20211208044224.1950323-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset add a new hwtstamp_config flag HWTSTAMP_FLAGS_UNSTABLE_PHC.
When user want to get unstable PHC index, like bond's active interface PHC,
they need to add this flag and aware the PHC index may changed.

Hangbin Liu (2):
  net_tstamp: add new flag HWTSTAMP_FLAGS_UNSTABLE_PHC
  Bonding: force user to add HWTSTAMP_FLAGS_UNSTABLE_PHC when get/set
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
 include/uapi/linux/net_tstamp.h               | 15 ++++++++-
 net/core/dev_ioctl.c                          |  3 --
 41 files changed, 35 insertions(+), 158 deletions(-)

-- 
2.31.1

