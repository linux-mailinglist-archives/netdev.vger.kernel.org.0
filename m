Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C6550E308
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 16:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242518AbiDYO22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 10:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242511AbiDYO20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 10:28:26 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF93E1EEC3;
        Mon, 25 Apr 2022 07:25:21 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id i5so2063654wrc.13;
        Mon, 25 Apr 2022 07:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OhzJ18rUdY++br4oj9YWYkBT8GEB1PEcZ+V/iXVMZrg=;
        b=Yp2ksl18LS/4Zs/ovpsVTlQwPq8RKkSp5QpY5tBP2+j05ULF7qPRftNv6iD6RV/IlN
         wBgjKe+jfS8pkoAlzDTWhfuCNXo8tuvgYq8GdjluJNdsL0Egy2XuECnoZ1b2EPAjXUe+
         jMVbqPb4/rU9tF+FQiWisfBHk5ZPwSSW1FGaE1as3zRZF/Bl8U0iJvqlG30E5ae4IJ3/
         fULg5bRvkciOv3RjeFApqNa7WkOnypR+SOycWijAO17Hx98IiaXeUtULZ3nSGJ+2vbiX
         wDgY8NgfbOWevz+rMK4KPWxSboDV2TSMJmbRhXZAbyf/q0RpPAAY7AoTalW7Zk59XBqQ
         a2EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OhzJ18rUdY++br4oj9YWYkBT8GEB1PEcZ+V/iXVMZrg=;
        b=KcibpJf1Nd9TI+lS9IVvgzAb0v3iuuxCaeFGAUO110G7ewAH6tVnIzrguJ5YXwg/3X
         aigwSpsh2IJfGAfkzESHvH0HlamCoTJgkSJIyaPtH7P6GKFwbDRfA0FRZ+r9G0g0+v+i
         qoTRznD8fFUcCXj7grZba8pO/Iffg3FmJYOC2bwlCbcu/hOaGefOWxh3d8AeYs7Hz3q5
         BWCiqFo70tP9TxRzXkdr4eFu/5JpxDd5V8JXoqfVBHuSGvY7LHDZ3KrcKtjxG5oPO8pd
         JlNSYnrcgjkyYE07aH9aaarxjDydqhT3HNrLzlPZW6IBSttLp1//JVdxsOLEuGj0YWs8
         yEUQ==
X-Gm-Message-State: AOAM531vti3sIfrfiDdMdCcf1igZDOwpUo20WGGskEZbtsPimU5ClgZc
        BkBTnlceuSprYFwqyadfBtE=
X-Google-Smtp-Source: ABdhPJzUAnIDjq4TtxReYzY4dzLCr4HXcpG6aANRg5FZdis9Nq2Rs17U9H23mO/9FxTROOaYVJ/RSA==
X-Received: by 2002:a05:6000:1f09:b0:20a:c427:c7c with SMTP id bv9-20020a0560001f0900b0020ac4270c7cmr14209914wrb.337.1650896720308;
        Mon, 25 Apr 2022 07:25:20 -0700 (PDT)
Received: from alaa-emad ([197.57.226.213])
        by smtp.gmail.com with ESMTPSA id d4-20020a05600c3ac400b0039082eeff53sm8615670wms.22.2022.04.25.07.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 07:25:19 -0700 (PDT)
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
Subject: [PATCH net-next v4 0/2] propagate extack to vxlan_fdb_delete
Date:   Mon, 25 Apr 2022 16:25:05 +0200
Message-Id: <cover.1650896000.git.eng.alaamohamedsoliman.am@gmail.com>
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
add extack to .ndo_fdb_del and edit all fdb del handelers

Alaa Mohamed (2):
  rtnetlink: add extack support in fdb del handlers
  net: vxlan: vxlan_core.c: Add extack support to vxlan_fdb_delete

 drivers/net/ethernet/intel/ice/ice_main.c     |  2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  4 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  2 +-
 drivers/net/macvlan.c                         |  2 +-
 drivers/net/vxlan/vxlan_core.c                | 39 +++++++++++++------
 include/linux/netdevice.h                     |  2 +-
 net/bridge/br_fdb.c                           |  2 +-
 net/bridge/br_private.h                       |  3 +-
 net/core/rtnetlink.c                          |  4 +-
 9 files changed, 38 insertions(+), 22 deletions(-)

-- 
2.36.0

