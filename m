Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02FD450D19A
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 14:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiDXMNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 08:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiDXMNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 08:13:04 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A9D29CB2;
        Sun, 24 Apr 2022 05:10:03 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id x18so17222615wrc.0;
        Sun, 24 Apr 2022 05:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2JuRhXyb4Ip8swSB1obPedgsH1Io7sAcBXX0fUCg2UY=;
        b=jbX6/SXWTvvMbmrClbsX++gd1w+2OD/ikoRsd8tpj0m1wta4k5jOn0afedb92k1P2z
         +XQINnTMiG5QDJtcBkVePlDctVDMI27MIwacGSG55x9yPASrF13hi0M8Ja2lghZD/7WR
         aXO5aN1Gh/AUJTaW9VNqPFqczdDVzbeF0OA9JE5wqmxFMuDXeYDBVGjpfbtf1O14672Z
         k0J9PvfQNxqWYo8gRQJTFJr8FYgMYDVYXuhFOpuiATTnF+DkdwHMZJ1VGOAITW3S62Dn
         t5P7EgxV/cY6odv9qhQkvAoMe9QfLSeQSgAVGmprh1KoqLCMDIvg45x0UWdIfoYGDHwT
         lWcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2JuRhXyb4Ip8swSB1obPedgsH1Io7sAcBXX0fUCg2UY=;
        b=lU+1zLnh+XGVXsJldJinwJgkqtRcpbb2/xz6ycRnCf8k9VErDV9SB4Kg8PInqFOG5r
         wmR+dLN8kyL98sOIKbF1NetA7cwFVZYVc6jnf0e9I8dOfCd1YFiXErbTaJqBa/I5QRfD
         rQokMcCeMDKrtlGydVxcjRe9Zhxl5DnvrgUxE0eN9aC4KctnV6CUB77rFDtVK1y248nL
         QpJHyxAPL0Pvr+X21L5S9VU2Ou/3H8MRHEMlrX4pYUQPgK5UefX80o6Y6V8kseRl4CND
         /r3s/rcUnJVh3bA+3mlzvkJyMT05m21THZlXBAWGv9DhbWj5KUrnkiU0mHUd1p0N6M6C
         69CA==
X-Gm-Message-State: AOAM532gMz77WqLph1oCDsjQC8gsg7HAESnEg8ReIiZ+I+SeNN6ZRoRv
        dkzFH1Ovh01WMn+T1VNrpmc=
X-Google-Smtp-Source: ABdhPJw0KYa7fhoRDswIm3fxHdgxTAvbu2xgjiARxGl5eH6CMPiXt8aK1ddLkk2hzdMh9Cw0a6r7JQ==
X-Received: by 2002:a05:6000:100c:b0:20a:c68a:e9a with SMTP id a12-20020a056000100c00b0020ac68a0e9amr10622884wrx.314.1650802201258;
        Sun, 24 Apr 2022 05:10:01 -0700 (PDT)
Received: from alaa-emad ([197.57.78.84])
        by smtp.gmail.com with ESMTPSA id a4-20020a056000188400b0020a9ec6e8e3sm7124788wri.55.2022.04.24.05.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 05:10:00 -0700 (PDT)
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
Subject: [PATCH net-next v3 0/2] propagate extack to vxlan_fdb_delete
Date:   Sun, 24 Apr 2022 14:09:43 +0200
Message-Id: <cover.1650800975.git.eng.alaamohamedsoliman.am@gmail.com>
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

 drivers/net/ethernet/intel/ice/ice_main.c     |  4 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  4 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  2 +-
 drivers/net/macvlan.c                         |  2 +-
 drivers/net/vxlan/vxlan_core.c                | 38 +++++++++++++------
 include/linux/netdevice.h                     |  2 +-
 net/bridge/br_fdb.c                           |  2 +-
 net/bridge/br_private.h                       |  2 +-
 net/core/rtnetlink.c                          |  4 +-
 9 files changed, 37 insertions(+), 23 deletions(-)

-- 
2.36.0

