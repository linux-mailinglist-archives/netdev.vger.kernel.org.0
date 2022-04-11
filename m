Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD40C4FC2F3
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 19:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348766AbiDKRNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 13:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241751AbiDKRNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 13:13:53 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38D124940;
        Mon, 11 Apr 2022 10:11:38 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so17531280pjk.4;
        Mon, 11 Apr 2022 10:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=KRbjfwqnUJkO/oZR6EgbQFsxUrbUtVn2epYGMXMRecM=;
        b=D7EZCUirid5cyqRcttkHIIgXNddbJofWNW7Dl1h+y48dK5l6Mv9mDsnQU7ZTNCwuuc
         wiGwzLhPBSWi+MtILwvnUXvYnlVv5sCdeSfVSmx2GsZJc1+Eh/6nnApe1E8psHL5gcYI
         9hIjyUVf5caQHQqlrnBMNb6GPiv/qEjkrwze1s62V7chQ/55QV+vnY4/lbVojTVLH1q+
         zSA60P9M7CjgkJR2DJbsksoeC121SWHeF26Ub8lpXgWtMBzEmiWBojrP8Q1oqotNRnIr
         7P9C/6egbfva3KPvuS9CrWMXCCEJpcq25BLwoVbGmaFUGjEpR6T1lxe/SNgLx1s85/V4
         qlSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KRbjfwqnUJkO/oZR6EgbQFsxUrbUtVn2epYGMXMRecM=;
        b=Dws4DUqFLVodVi8H9Dq/vXNd3RMXjF1S6jc1caRsVGfFzgjngQ7SGh5CsJineyA2P7
         KJJN56NyLjaeOL+3Q8jHHh13AWtaJ13NiUHIofD0fUP1njLHlNM4phYgKZbqG4khtLZo
         /08BfxtewPcfin8LBcqLxC0aq0l8/mDZJ1DI9ZfjxHz8nDlVmtlUvpx0DNdX3BTviWju
         vq50jIJrNiO5p19sfQydibHi/Jr59/oFk1g05I988zTMid1fpkLmJO6l74loXBBwF05W
         4dxeUE1pf8EwYEmfE4DBJDebmgHeKjBkOsws3tSv49GkHEZvJxCkuVsjda6xFjaobygp
         iW7Q==
X-Gm-Message-State: AOAM5323A0/GSHqUYFPI7/VE6rFP+vbmkbyO3d07ZJO0/4d4qz1Sc8gT
        WsO4BQmiknrTTaicw0hwyRkQWdas4JRjfA==
X-Google-Smtp-Source: ABdhPJy6SbawjX50HMjoBwG9ZKj6KsfkBAnNGVAK77ufa0BKjHn4AfXVtvMuovlRUIBZ76o08pwONQ==
X-Received: by 2002:a17:90b:3b8f:b0:1c7:b62e:8e87 with SMTP id pc15-20020a17090b3b8f00b001c7b62e8e87mr197216pjb.156.1649697098404;
        Mon, 11 Apr 2022 10:11:38 -0700 (PDT)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id y16-20020a63b510000000b00398d8b19bbfsm307213pge.23.2022.04.11.10.11.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Apr 2022 10:11:38 -0700 (PDT)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        pabeni@redhat.com, krzk+dt@kernel.org, roopa@nvidia.com,
        andrew@lunn.ch, edumazet@google.com
Cc:     wells.lu@sunplus.com, Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next v7 0/2] This is a patch series for Ethernet driver of Sunplus SP7021 SoC.
Date:   Tue, 12 Apr 2022 01:11:26 +0800
Message-Id: <1649697088-7812-1-git-send-email-wellslutw@gmail.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sunplus SP7021 is an ARM Cortex A7 (4 cores) based SoC. It integrates
many peripherals (ex: UART, I2C, SPI, SDIO, eMMC, USB, SD card and
etc.) into a single chip. It is designed for industrial control
applications.

Refer to:
https://sunplus.atlassian.net/wiki/spaces/doc/overview
https://tibbo.com/store/plus1.html

Wells Lu (2):
  devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
  net: ethernet: Add driver for Sunplus SP7021

 .../bindings/net/sunplus,sp7021-emac.yaml          | 140 +++++
 MAINTAINERS                                        |   8 +
 drivers/net/ethernet/Kconfig                       |   1 +
 drivers/net/ethernet/Makefile                      |   1 +
 drivers/net/ethernet/sunplus/Kconfig               |  36 ++
 drivers/net/ethernet/sunplus/Makefile              |   6 +
 drivers/net/ethernet/sunplus/spl2sw_define.h       | 271 +++++++++
 drivers/net/ethernet/sunplus/spl2sw_desc.c         | 226 ++++++++
 drivers/net/ethernet/sunplus/spl2sw_desc.h         |  19 +
 drivers/net/ethernet/sunplus/spl2sw_driver.c       | 604 +++++++++++++++++++++
 drivers/net/ethernet/sunplus/spl2sw_driver.h       |  12 +
 drivers/net/ethernet/sunplus/spl2sw_int.c          | 253 +++++++++
 drivers/net/ethernet/sunplus/spl2sw_int.h          |  13 +
 drivers/net/ethernet/sunplus/spl2sw_mac.c          | 346 ++++++++++++
 drivers/net/ethernet/sunplus/spl2sw_mac.h          |  19 +
 drivers/net/ethernet/sunplus/spl2sw_mdio.c         | 126 +++++
 drivers/net/ethernet/sunplus/spl2sw_mdio.h         |  12 +
 drivers/net/ethernet/sunplus/spl2sw_phy.c          |  92 ++++
 drivers/net/ethernet/sunplus/spl2sw_phy.h          |  12 +
 drivers/net/ethernet/sunplus/spl2sw_register.h     |  86 +++
 20 files changed, 2283 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
 create mode 100644 drivers/net/ethernet/sunplus/Kconfig
 create mode 100644 drivers/net/ethernet/sunplus/Makefile
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_define.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_desc.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_desc.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_driver.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_driver.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_int.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_int.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mac.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mac.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mdio.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mdio.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_phy.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_phy.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_register.h

-- 
2.7.4

