Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72F84E5806
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 19:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343918AbiCWSEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 14:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343916AbiCWSEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 14:04:00 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31A388794
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 11:02:30 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t13so534695pgn.8
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 11:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+vhUVkYYqSMRPXwABeEXGVAUkLgXfGxO7Iwv+BSFBag=;
        b=ONI92zooPFODPz+oM5A6PFVgICqa6LAyrUfEQsv5h7QMlubwTEzpA1eH7PNtfvX2nA
         7OnA/PxNdB7+CJQ57XSMKShuQ6KM5WLBcYiIbP3oqXUXNaWXX1kyUAey9q1ohzdkPNOL
         pAzu9RL6gMWtjRnAOQxmJrG3gVUT6vdBJk5sg+PlRR5xtdklrwqmWmR1G2DZ00X+F+Oz
         Ol4/Tmtoe58WppeE90n2jfUk1yOZ+1w48TNNsx5tUlgONeWLuXfhE8qjpA+hilkci7ml
         uPEQQ/aPJ/m6Bl/LWwbZp/QpStU+cC5G7cEQbVYXLr345SEbOjrsLA1yQ3pge1iI/7E2
         Xc7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+vhUVkYYqSMRPXwABeEXGVAUkLgXfGxO7Iwv+BSFBag=;
        b=CceP4bqCdW5CMwRnRoqrROfRBeF1qF+owN7/cW25Oe4RBAYViNf764nDJUa0Yha+Om
         YtXOzwjxzkm160zJll4o0J0S3tOsInMIY/r0qSbjXKoVDFyn+7xuFU4m39geaIz+tWtP
         MAnXqERBo5Zv9Z1ln06AweAohlbs/t4a2iI+dqmEQ6QIr2DxEiqPCDaJQdMHisaimgep
         xVMO+uad2OARWauBlDQCXDMIzyjN1IfpwksYyWs1dWKD7WcdzSCVEMAGXbvS6uidGY8C
         oo6hWlqwWmV9AHHqIwq3ibcyGTnEnguygrHn0ea6sY/vq7KRBliJ5Sp1xTjKbrBzoa0t
         t+pA==
X-Gm-Message-State: AOAM5315yBkO5yGRB+5PdzZrnsWnuS67EOqYCxvLoPovG274OUvlJssw
        hCYVHjGhz+dEbJrDmDoD93ToeA==
X-Google-Smtp-Source: ABdhPJybMH7prPEUWwxTS01Q1gq6+E6xSD0ItDHehCAVfOkahORz0J/W33Wz+VHoCeuKJPotbFDdrA==
X-Received: by 2002:a05:6a00:9aa:b0:4f6:ebd0:25bd with SMTP id u42-20020a056a0009aa00b004f6ebd025bdmr1167608pfg.12.1648058550000;
        Wed, 23 Mar 2022 11:02:30 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id l19-20020a17090aec1300b001c7a31ba88csm1265870pjy.1.2022.03.23.11.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 11:02:29 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     radhey.shyam.pandey@xilinx.com, robert.hancock@calian.com,
        michal.simek@xilinx.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, linux@armlinux.org.uk, andrew@lunn.ch,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        robh@kernel.org, Andy Chiu <andy.chiu@sifive.com>
Subject: [PATCH v5 net 0/4] Fix broken link on Xilinx's AXI Ethernet in SGMII mode
Date:   Thu, 24 Mar 2022 02:00:18 +0800
Message-Id: <20220323180022.864567-1-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Ethernet driver use phy-handle to reference the PCS/PMA PHY. This
could be a problem if one wants to configure an external PHY via phylink,
since it use the same phandle to get the PHY. To fix this, introduce a
dedicated pcs-handle to point to the PCS/PMA PHY and deprecate the use
of pointing it with phy-handle. A similar use case of pcs-handle can be
seen on dpaa2 as well.

The v4 patch was wrongly based on net-next tree. 1,2,4 parts of v5 patch
was generated after re-applying the v4 patch then resolving conflicts on
the net tree. 3/5 also describes the pcs-handle more globally at the
ethernet-controller device tree binding document.

Andy Chiu (4):
  net: axienet: setup mdio unconditionally
  net: axienet: factor out phy_node in struct axienet_local
  dt-bindings: net: add pcs-handle attribute
  net: axiemac: use a phandle to reference pcs_phy

 .../bindings/net/ethernet-controller.yaml     |  6 ++++
 .../bindings/net/xilinx_axienet.txt           |  8 ++++-
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  2 --
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 33 ++++++++++---------
 4 files changed, 31 insertions(+), 18 deletions(-)

-- 
2.34.1

