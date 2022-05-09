Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57A451FFFF
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237420AbiEIOkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237409AbiEIOki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:40:38 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1801B1779
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 07:36:41 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id i5so19733658wrc.13
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 07:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XHZCc9KkCkiMkPg4oNxM0kp6W9oK2PEGUqIawe5Nj4A=;
        b=FG12aAHkrTaOiwYtJnoTsermbyosAi0TYyZ/xCIKk1f8xsLm/EKrQ4r5Qq8nCZjdqA
         XnJTASox8Selnp3Kv0PeBeWIpEAXw9xvs45S8g+ZDf8P4LoWJ2XhclJKbD4Spgc9dDms
         L7xdxXH4LxPQsN5ASTpBxOOzvATDdcp2JAZoUsp12d2v7K769ym5g35R/6bYgLg+U8SP
         qTtPcuBSqmaTNqLolPQOrgxQMj/bai3IUlOWbUsNQVgLe4Czl1w7/aLvff4Xibtva7aH
         aXzhR0WufHcOqRTZwqAwAQAhZPecuWHNdevg5b6PQFiVyCO5n78u9k2krP3y9BY5zbqO
         EszQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XHZCc9KkCkiMkPg4oNxM0kp6W9oK2PEGUqIawe5Nj4A=;
        b=Pok2mS8CWcjc8NgvXqSI5cttN3N2YS+mNbYQ41/HaukhI5wxUvsxHj2wa1R1HEjOFZ
         Pj4T/MiBAPBhNgBjYwV5b0YyM5sE44wGbBXkZGVw92Ou9sdcKGIyCv8KW/YnB/B1b2yy
         t8120e8pn2ezs/5Z0/bPspSIHOWrIGgoCqUqENWtjiX/nYshsPABWf+nSAsMkdk9jmzo
         epUjXk79R3UnUEVrBThYTwdlZ9HmPXq6NK4ZuAMD5+rGdn57RMKxMMPe/Ft6Tku13XJ5
         CX2DK2ZmaXOCM9Cnt5ZOhJ+xzyRpZO7vu4ea0ZfcwWO4WxSd/zfpdIh/IlnSkOCMvI5a
         Y6pA==
X-Gm-Message-State: AOAM530TIHaUsueXSKbslG2tyskTv+9eVT+DasYC4DKBG9r2PwaRmLI4
        hsAPtszUjQCCNx0w0S+bk0pe86FXm6o8LuSV8k2SVw==
X-Google-Smtp-Source: ABdhPJwe3NQAKj4gbRSCBxXIZaIl39CSw61d0sByu3vjfWOjPXW4ZWVLANxArx1j+/vhgubG+H5Yzg==
X-Received: by 2002:a5d:5984:0:b0:20c:7de2:5416 with SMTP id n4-20020a5d5984000000b0020c7de25416mr14084604wri.30.1652106999898;
        Mon, 09 May 2022 07:36:39 -0700 (PDT)
Received: from josua-work.lan (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id x18-20020adfdd92000000b0020c5253d915sm11121155wrl.97.2022.05.09.07.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 07:36:39 -0700 (PDT)
From:   Josua Mayer <josua@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com, Josua Mayer <josua@solid-run.com>
Subject: [PATCH v4 0/3] adin: add support for clock output
Date:   Mon,  9 May 2022 17:36:32 +0300
Message-Id: <20220509143635.26233-1-josua@solid-run.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220428082848.12191-1-josua@solid-run.com>
References: <20220428082848.12191-1-josua@solid-run.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for configuring the two clock outputs of adin
1200 and 1300 PHYs. Certain network controllers require an external reference
clock which can be provided by the PHY.

One of the replies to v1 was asking why the common clock framework isn't used.
Currently no PHY driver has implemented providing a clock to the network
controller. Instead they rely on vendor extensions to make the appropriate
configuration. For example ar8035 uses qca,clk-out-frequency - this patchset
aimed to replicate the same functionality.

Finally the 125MHz free-running clock is enabled in the device-tree for
SolidRun i.MX6 SoMs, to support revisions 1.9 and later, where the original phy
has been replaced with an adin 1300.
To avoid introducing new warning messages during boot for SoMs before rev 1.9,
the status field of the new phy node is disabled by default, and will be
enabled by U-Boot on demand.

Changes since v3:
- fix coding style violations reported by Andrew and checkpatch
- changed type of adi,phy-output-reference-clock from flag to boolean

Changes since v2:
- set new phy node status to disabled
- fix integer-as-null-pointer compiler warning
  Reported-by: kernel test robot <lkp@intel.com>

Changes since v1:
- renamed device-tree property and changed to enum
- added device-tree property for second clock output
- implemented all bits from the clock configuration register

Josua Mayer (3):
  dt-bindings: net: adin: document phy clock output properties
  net: phy: adin: add support for clock output
  ARM: dts: imx6qdl-sr-som: update phy configuration for som revision
    1.9

 .../devicetree/bindings/net/adi,adin.yaml     | 17 +++++++
 arch/arm/boot/dts/imx6qdl-sr-som.dtsi         | 10 +++++
 drivers/net/phy/adin.c                        | 44 +++++++++++++++++++
 3 files changed, 71 insertions(+)

-- 
2.35.3

