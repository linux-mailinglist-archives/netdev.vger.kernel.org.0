Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAF846E686
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbhLIK2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhLIK2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 05:28:41 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE4AC061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 02:25:08 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso4459443pjb.2
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 02:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/x4YKImFPvD+Gv1jfIUx7Dv8b9bxfCDHJSBi000/+6s=;
        b=hzXEMijUcN9nFXo2Am7opca2Y4G4eBKK0IBfhTciekirqcqnxCRzc6/gUJHB4NMU5O
         6O/2UV92bHbiWCrEHL+q1ktFDW3jVeK1I0S+SHPoxVWnL/OgLJGf3H7nf/266T86cG9b
         CDoKdZOlGa9mKLBLsaTXkYvRFMes4TYSeVa6+UlMCg8TjTH29G1tiSTOjYmBBIymR1OI
         aEwuyQtHkoBJfSwUWz4PJ2LTw7Ah/owO3dpA5W6jYhaU50gslFTWfiBQXCOg0nIw4thG
         O6sZrUo+Z4pmtFBrvQTkD1AdUUAbkqn6Yjcle4hWL9tCOSJDxIj2iUl23R6lZ08h9th9
         umIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/x4YKImFPvD+Gv1jfIUx7Dv8b9bxfCDHJSBi000/+6s=;
        b=C7qwn6LTyi90aVtN1537XIfQCISp7A9rdns6/yeekKk4eCv3tTKd6ywiMLlq/Eb2XF
         b2cMG4BNcAHIwRqE7ssR2M2RfK5NriS5qWth1vc83YXoW70iLhLKjjjEId80WeA8BS2S
         GZ/LUqth9zsoqiHbrT3QbU96arw//ptqCmSk6+FRPbQMlxM0+cwNcs2es1zw7AVdnNPB
         TmIVe4E7NbcVwICjj2DpzAZYGY4vwpFlC+Aza9W01Ho5yzfGSSd4HdvsyAZvwXnWJeUD
         VYogzEWc4fOjhs4HqoMGEG+y0nGrFMaW819EiuiNq+U84be2NxofoET0qjvPColhdDjf
         /B+w==
X-Gm-Message-State: AOAM530+OlkW7L+yUrCvaKDP7Nwg4rwgAwtZCWQiSTKJG1GMqSi+7hzY
        3JL1OhQj90fpVedW+FJx6pOkypghXhQ=
X-Google-Smtp-Source: ABdhPJweGpLRJfMSt81C5bry+3t5TlmUvsgN2I2GHvEQGoT9PAWndA7pHDd9xf27xhWVjRRJ7/ygHw==
X-Received: by 2002:a17:90b:4f86:: with SMTP id qe6mr14456143pjb.224.1639045507463;
        Thu, 09 Dec 2021 02:25:07 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t4sm6708507pfj.168.2021.12.09.02.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 02:25:07 -0800 (PST)
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
Subject: [PATCHv2 net-next 0/2] net: add new hwtstamp flag HWTSTAMP_FLAG_BONDED_PHC_INDEX
Date:   Thu,  9 Dec 2021 18:24:47 +0800
Message-Id: <20211209102449.2000401-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset add a new hwtstamp_config flag HWTSTAMP_FLAG_BONDED_PHC_INDEX.
When user want to get bond active interface's PHC, they need to add this flag
and aware the PHC index may changed.

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
 net/core/dev_ioctl.c                          | 19 ++++++++---
 41 files changed, 50 insertions(+), 160 deletions(-)

-- 
2.31.1

