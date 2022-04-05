Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED7D4F35A4
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 15:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235530AbiDEKxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 06:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244536AbiDEJl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 05:41:28 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053B5BBE02
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 02:26:57 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id w21so10556385pgm.7
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 02:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KAIC36RoAaF0zMvy5en9w7Q3tRhDi5KYODVjE0XiqsM=;
        b=R/H2aztL1jGJL8oyCL6x+4jrviOl2E2lcnooHGunHkrmkuTg/y0RURtD6fu6NQDhuC
         dkIBQm1mljqruYdFp3hSnrZA9aJuwS5PjptBG/aixt2fJaMUpoLnYofOI0x1tIhuIxn7
         Q8kh5SZSIPgNVxWAl34QDS7E+8njX9feMw3Vt1D0eHSWzJ/6opMhoHyQahGOA+wrME58
         EkGP7o84+nouYtXGJbTlQUYH8FsOLJj1nQlt3dub+gH+V3CFK4W0kzBJYEOD9jnHeuJq
         rhMs5u3VWDOoRnvYkvMuc7Szf3oANvO9fGSEhoGISDdgA3FC+1NvPK/TvVNz9Hf6rkar
         zNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KAIC36RoAaF0zMvy5en9w7Q3tRhDi5KYODVjE0XiqsM=;
        b=JzsBXnarzSQ6PChpYBJulcWGBspjnlYbrecNuqHUZsXKGD+NdU90q/ldiDGQCOtYIS
         ysfqzCVPL9/p7Dj7QJVNdacd30vA1J7DI+vf4DBZleyIyqHd8oAf65Drdwrf/9QtiBat
         erM6RP/l2GevvcuF+zMGlxWbiSrgLT/rZlrRG6S0oCW4oqrTygwDwJ6yKt4E+W6TlIv+
         HBk3ExUWFEguBDPRxu3X+zzMl/QjIHT5tySYt9TBud/cxM3WeQEJ2tPbyMLnJ0bp1H7T
         1nS+MNy1KWO1f+bLYSnFSmzn6/M3ZHnSh/+9QY+LxmQSolth9U8ZpWbJ4rvTImHozjXW
         a2TQ==
X-Gm-Message-State: AOAM531x2aD7ugReh0gLD7vksmi7Aewiz9Ywm9rJ2+nzN3veB9p+pBcm
        XhO2y2qCKAS9J0oQjoa6hPkfAA==
X-Google-Smtp-Source: ABdhPJyK5yJU1KSceQDQyjByfs3eQ5OW0HgoipKSPHrNybszdA6k8ufcPCd75t/IzkEAfuEH+hJ3nw==
X-Received: by 2002:a05:6a00:21c6:b0:4fa:914c:2c2b with SMTP id t6-20020a056a0021c600b004fa914c2c2bmr2750101pfj.56.1649150815761;
        Tue, 05 Apr 2022 02:26:55 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b4-20020aa78704000000b004fe0ce6d6e1sm5824291pfo.32.2022.04.05.02.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 02:26:55 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com
Cc:     andrew@lunn.ch, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Andy Chiu <andy.chiu@sifive.com>
Subject: [PATCH v8 net-next 0/4] Fix broken link on Xilinx's AXI Ethernet in SGMII mode
Date:   Tue,  5 Apr 2022 17:19:25 +0800
Message-Id: <20220405091929.670951-1-andy.chiu@sifive.com>
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

--- patch v5 ---
 - Re-apply the v4 patch on the net tree.
 - Describe the pcs-handle DT binding at ethernet-controller level.
--- patch v6 ---
 - Remove "preferrably" to clearify usage of pcs_handle.
--- patch v7 ---
 - Rebase the patch on latest net/master
--- patch v8 ---
 - Rebase the patch on net-next/master
 - Add "reviewed-by" tag in PATCH 3/4: dt-bindings: net: add pcs-handle
   attribute
 - Remove "fix" tag in last commit message since this is not a critical
   bug and will not be back ported to stable.

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

