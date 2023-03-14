Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D11D6B9E4E
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjCNS1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbjCNS13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:27:29 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D43B0493;
        Tue, 14 Mar 2023 11:27:24 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id o11-20020a05600c4fcb00b003eb33ea29a8so10835762wmq.1;
        Tue, 14 Mar 2023 11:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678818443;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OslNVTGF/1+Bz6lNmbS+ej3jqHu92dOWopXVORTQ9vw=;
        b=SmDwFntjE1vamX2E10WyRpj0EKfTP1+8t1av9av5yp1w17FX8mCac6dPwuUaf1NNV1
         m6GUzkq7nrUwU9My2+IPlROyEE3Kz/hPpvEeA0vbmJZgMt3I9AdJ7gdxrIgalqtcwuDf
         Pu64VCkBhlfL0n6pBrHtZYdq+9RAi3sENM0LQ5CiMcJgxU6A8kDhzRUhXXVYaq5/VWIj
         GCL1CogEGAZ2BeUfYFvXgLwptm5+JJseLyAq/hN/8WX0qybkUWhGfOQGpZeMZDQ1sP3M
         6aVRnPo8KN935oSBpaLF4wJrEIanBy2oP4QYFeoqGuf2c7t4mtihmgolVnrfnzxCmkY+
         zDoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678818443;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OslNVTGF/1+Bz6lNmbS+ej3jqHu92dOWopXVORTQ9vw=;
        b=GSRYR6GgRsyvHDIRDNNS9/U7SJBohOmo5xQkxDZZ1V73Zt+RHJCdEwSd5c1wUe3wvl
         MQn3sw2y2racor7Z5Lp2jaa1o+gLk0ABO/t5XApuxGoeiwaYNssi4Ahn5hOLA3ahCHCh
         LGlbCJHBJmCPs47nCYp3M9K2iyT2jv0omn8XBHuuhYrquYQ3FSyED4A1+lmDJ1YMRqBI
         E074vs5a6dTG4sWEMrOpWa/v40uiU6V7fwWbcAdXYFV2PDQmfTvyhZMNj2nOvCtWrxp6
         BeNTZbXU5zIc4K819QUUPip+B/DBMN+L64H1yrf9IuEmSvzZya8UC0KB2LmfyZdJEJXJ
         xz7w==
X-Gm-Message-State: AO0yUKWT3RKUgcE/EvewwUTnLWzOM8j68YlvvPcF85s3ejqz8hohmNqZ
        7i0KjGU60som6HlvDChEyRg=
X-Google-Smtp-Source: AK7set89Bn6ym5r+P1wuuMlpR6pc4EiEG5u00As9st/iuxmhBFjX9BC5zBbpYch8jf8s4FN5NevwjQ==
X-Received: by 2002:a05:600c:5386:b0:3ed:301c:375c with SMTP id hg6-20020a05600c538600b003ed301c375cmr1114753wmb.21.1678818443026;
        Tue, 14 Mar 2023 11:27:23 -0700 (PDT)
Received: from mars.. ([2a02:168:6806:0:5862:40de:7045:5e1b])
        by smtp.gmail.com with ESMTPSA id u7-20020a7bc047000000b003e206cc7237sm3443490wmc.24.2023.03.14.11.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 11:27:22 -0700 (PDT)
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Klaus Kudielka <klaus.kudielka@gmail.com>
Subject: [PATCH net-next v3 0/4] net: dsa: mv88e6xxx: accelerate C45 scan
Date:   Tue, 14 Mar 2023 19:26:55 +0100
Message-Id: <20230314182659.63686-1-klaus.kudielka@gmail.com>
X-Mailer: git-send-email 2.39.2
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

Starting with commit 1a136ca2e089 ("net: mdio: scan bus based on bus
capabilities for C22 and C45"), mdiobus_scan_bus_c45() is being called on
buses with MDIOBUS_NO_CAP. On a Turris Omnia (Armada 385, 88E6176 switch),
this causes a significant increase of boot time, from 1.6 seconds, to 6.3
seconds. The boot time stated here is until start of /init.

Further testing revealed that the C45 scan is indeed expensive (around
2.7 seconds, due to a huge number of bus transactions), and called twice.

Two things were suggested:
(1) to move the expensive call of mv88e6xxx_mdios_register() from
    mv88e6xxx_probe() to mv88e6xxx_setup().
(2) to mask apparently non-existing phys during probing.

Before that:
Patch #1 prepares the driver to handle the movement of
mv88e6xxx_mdios_register() to mv88e6xxx_setup() for cross-chip DSA trees.
Patch #2 is preparatory code movement, without functional change.

With those changes, boot time on the Turris Omnia is back to normal.

Link: https://lore.kernel.org/lkml/449bde236c08d5ab5e54abd73b645d8b29955894.camel@gmail.com/

Changes in v2:
Add cover letter
Extend the cleanup in mv88e6xxx_setup() to remove the mdio bus on failure 
Add patch "mask apparently non-existing phys during probing"

Changes in v3:
Add patch "don't dispose of Global2 IRQ mappings from mdiobus code"

Klaus Kudielka (3):
  net: dsa: mv88e6xxx: re-order functions
  net: dsa: mv88e6xxx: move call to mv88e6xxx_mdios_register()
  net: dsa: mv88e6xxx: mask apparently non-existing phys during probing

Vladimir Oltean (1):
  net: dsa: mv88e6xxx: don't dispose of Global2 IRQ mappings from
    mdiobus code

 drivers/net/dsa/mv88e6xxx/chip.c    | 381 ++++++++++++++--------------
 drivers/net/dsa/mv88e6xxx/global2.c |  20 +-
 2 files changed, 196 insertions(+), 205 deletions(-)

-- 
2.39.2

