Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAF251C384
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 17:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377895AbiEEPNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 11:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbiEEPNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 11:13:50 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501CF4AE25;
        Thu,  5 May 2022 08:10:10 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id u3so6535635wrg.3;
        Thu, 05 May 2022 08:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+/sF+rK/sk8Mcq8ZDKrTQ+5QhRG26LQDZuCE59tq5gg=;
        b=WyanZJ4pfugP4UBrAHAI3jE+0AMPPz0h7gFUM9vNG+p5YrdeWWhgzma2gPVbbEw7nQ
         zqyXYKcg6ZlClU+WsCyXFa9pOTdvmphmLTQBVM970g+nAyt6eS078/B7r+Yd2D4Muq6n
         tAQ/j/L/oDKTLJ2BpBFlbUakTEiPv6kzIRg2ny56L8R9Zq1zQM0TXBtzngd0ygArbjI2
         hkOt6i+dsXb84AMFlA6JORanoOhW8jKTQJmasSfefZ/stu/MnlyiD+jTUcuWdV+cgtuH
         DUyIzIrpkgZJdZNH7TxCKR41L621Fs4c3vS28PpKOYcmjt5RTsDegQQyR3I10AjN2LwM
         20oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+/sF+rK/sk8Mcq8ZDKrTQ+5QhRG26LQDZuCE59tq5gg=;
        b=0ZCVosktmh1cm1QyZDihdnmwaBvjdoZ9LpGGJllezH6PQb3m2e0sBGQBX/+E7GL+PZ
         Ql7awPydocNNOpQK1OccukIAbhKUScOhvzvUp4ypakWj02y0DaXphwbU36ZP2D3F/KRJ
         nCAgWU5sLsvokdhgJ9ZnoVx80lwCuO0St+UWy4NGJXJUKMhz6NOFKhB489gPYv5y0q/k
         PMllReNE8mZamdeHqBzECpWUbeq0HbSUy2641iyXR4UJ7QEO9OLkpY3ax97ZpZVI1Q7r
         tXezKMNDfxxkgFJJCYl232s0lE6ed99iHBojGI0yhamHlDUEAIFkQa4B8PIhYELVWpXY
         0IBQ==
X-Gm-Message-State: AOAM530Eeqa/KCU9/UR6AZYmcl/04VH6Pf3z7hmVpEO+yEPF+0Z9epN1
        /Wc8c0uZ6EMimKS9PI4BBDI=
X-Google-Smtp-Source: ABdhPJyH3FeC0GOlGDlLA3jmninPUid5beNQGRlfuR6gYFWw5/iHWVU9gj8FHEZ8LDE1fOqtvSu2cQ==
X-Received: by 2002:adf:e491:0:b0:20a:cf97:58df with SMTP id i17-20020adfe491000000b0020acf9758dfmr21162391wrm.213.1651763408733;
        Thu, 05 May 2022 08:10:08 -0700 (PDT)
Received: from alaa-emad ([197.57.200.226])
        by smtp.gmail.com with ESMTPSA id s6-20020adfea86000000b0020c5253d907sm1419204wrm.83.2022.05.05.08.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 08:10:08 -0700 (PDT)
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
Subject: [PATCH net-next v6 0/2] propagate extack to vxlan_fdb_delete
Date:   Thu,  5 May 2022 17:09:56 +0200
Message-Id: <cover.1651762829.git.eng.alaamohamedsoliman.am@gmail.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

 drivers/net/ethernet/intel/ice/ice_main.c     |  3 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  3 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  3 +-
 drivers/net/macvlan.c                         |  3 +-
 drivers/net/vxlan/vxlan_core.c                | 41 +++++++++++++------
 include/linux/netdevice.h                     |  2 +-
 net/bridge/br_fdb.c                           |  3 +-
 net/bridge/br_private.h                       |  3 +-
 net/core/rtnetlink.c                          |  4 +-
 9 files changed, 44 insertions(+), 21 deletions(-)

-- 
2.36.0

