Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 420FD5149D3
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 14:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359459AbiD2Mwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 08:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359292AbiD2Mwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 08:52:32 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C045C9B75;
        Fri, 29 Apr 2022 05:49:12 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x18so10710344wrc.0;
        Fri, 29 Apr 2022 05:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6gx1I2LEKWcJc0uFAMan792S2TeZ8Y9b5WwgAcqsFho=;
        b=eqsr3iRoOLraeHQfAN1F8lxbHhTSxdIjUQr8ExFzQAGCUmElefmB7guzyjC0kxl5je
         HT0OIrgMVP7TYB+jH1by1xcLHdxR/iPH0RxBMg5q8hDehljaEk52mNtAkz7VAAAfq6uQ
         U598+3czQfs9pI2uIeUeVm6xVsHA+ogUhmyhCFfyVDEr1zdRF7yHyA3ybZoPFqixxaT/
         X/6mA+22S80hqy84zvJQgTv/OkAWwpJyHz4aD/4jYED4VSKNHVEP2I/N4UZ4TPedAj0+
         bMQcG1Int7xYiYvMjssXccYPNgZwB9G02qDFer0iaKKzUSx93WZuxt9XIQVsQf2k38am
         8hHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6gx1I2LEKWcJc0uFAMan792S2TeZ8Y9b5WwgAcqsFho=;
        b=g2ZUMiRnKtjH6tpnXLB55RVW1enbglb9qsMIRcpUfBbjDjkC8oF+rZHlHUku864Z0x
         K7DM3XtMnLuS3PJ+uffHJdHUqs+IFbxkoGtzez/+aIGsX2w91cTxDgJsac+uohUwn3+H
         XXf5ORy8zDYnWCmSzhtrTPgQEPyTSpuUgtbK7Qgf31klmt4evUk0NPPiotvcvXjrbcM3
         fqiDYbUadTlAdWvkqO5Yx7WOc0GmtgHK7viqtIRbCR5kPRhIpoSDzvOXL7ptN11hSMCm
         D5oYKc+tD0t5krXdVT81tUsWSzvIAJX9Lb992fxSZqpuYvi8Si2fKNMikLTHAkwnbTrv
         i2WQ==
X-Gm-Message-State: AOAM530+4qfI+vypNXtoryLW1vZAVV9GTeM+Vy4+Rx13Mkxq3H99awr/
        z8Qts5SXxdG5JUuLmyvLN/o=
X-Google-Smtp-Source: ABdhPJxuNgz+00AZk2K+3MHKXW1rmmSUinMRc2h419aF6uzywdkwSk8Wwqe7afiMqRAzA0LmEjtA6A==
X-Received: by 2002:a5d:498d:0:b0:20a:dc6b:35c9 with SMTP id r13-20020a5d498d000000b0020adc6b35c9mr19910335wrq.176.1651236550512;
        Fri, 29 Apr 2022 05:49:10 -0700 (PDT)
Received: from alaa-emad ([197.57.200.226])
        by smtp.gmail.com with ESMTPSA id g18-20020a05600c4ed200b00393e810038esm2899835wmq.34.2022.04.29.05.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 05:49:10 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa@nvidia.com, jdenham@redhat.com,
        sbrivio@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, shshaikh@marvell.com,
        manishc@marvell.com, razor@blackwall.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, GR-Linux-NIC-Dev@marvell.com,
        bridge@lists.linux-foundation.org,
        eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH net-next v5 0/2] propagate extack to vxlan_fdb_delete
Date:   Fri, 29 Apr 2022 14:49:05 +0200
Message-Id: <cover.1651236081.git.eng.alaamohamedsoliman.am@gmail.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to propagate extack to vxlan_fdb_delete and vxlan_fdb_parse,
add extack to .ndo_fdb_del and edit all fdb del handelers.

Alaa Mohamed (2):
  rtnetlink: add extack support in fdb del handlers
  net: vxlan: Add extack support to vxlan_fdb_delete

 drivers/net/ethernet/intel/ice/ice_main.c     |  2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  3 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  3 +-
 drivers/net/macvlan.c                         |  3 +-
 drivers/net/vxlan/vxlan_core.c                | 41 +++++++++++++------
 include/linux/netdevice.h                     |  2 +-
 net/bridge/br_fdb.c                           |  3 +-
 net/bridge/br_private.h                       |  3 +-
 net/core/rtnetlink.c                          |  4 +-
 9 files changed, 43 insertions(+), 21 deletions(-)

-- 
2.36.0

