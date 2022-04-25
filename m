Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B788650DDEF
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237580AbiDYKeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240928AbiDYKen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:34:43 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3FADF16;
        Mon, 25 Apr 2022 03:31:25 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c12so25991693plr.6;
        Mon, 25 Apr 2022 03:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=cZgPMkw4PGg4N1fmGOz5Prvw3irIQNYaupEuDrhOlpc=;
        b=KCEy82C15B6lJxruOPIQPXIJ2eXMSO+oCQt51DB64jZYccDfsfW43H9yT3hBrnC21S
         B6msM0+wPHlu0Dh9KRNWJMyWxC7g351yy9TFfGSSiHkQGhE1AaOW/5pf4XTV7wKhq/ED
         uGmzPwsGBzDRUR0eASVOC5nz2fd6zpLUGkhiijcDlDCfkKiVYCX1zycXgq09py4vAfeA
         +M+UZYLtgR9uqt7e+HkzitvjdAHLk9FY3jMwf6vqBlQNHAXkbtEJT15alcnpQb342+ny
         s1VN+q0MJI7hbSycwqmzT7xFuVsp6vTz3swal1TWnai78Qm+93+Z41U46ySl1IvD2sdE
         eidQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cZgPMkw4PGg4N1fmGOz5Prvw3irIQNYaupEuDrhOlpc=;
        b=vxLfAtNCz8MtlhQZoTTdIj5LZpZBbaAejh1DXJ9OaSpW8KP+4nip7AJvrUtV0pOeZx
         1l9PAXoNr+jtJFjZCaW+JZFTJR4Baf0+gcEhj5mLAdpB/Xn0D8SURwTbx8+ex/Cl8aGb
         otnJ33/+pqliaVzkeaN0Ex8DR/0gJzCulLXkNROtxPJom3ho4qx6GybZwKHSL20d9Q5a
         ekufrSnPgf0tEPz2f+Rqz4ERHsfur77//lC6QuJqZT1rCKjk07L6H3D37Y0dTvyZmGSK
         KDwiMDLTtEp3ynlRiqJVeEDxi7YBrJFhIimRC/baeTkwJUhBxtYhlj9XGUNhlZkep8bG
         hjPQ==
X-Gm-Message-State: AOAM531Y8xaRf0a8wMszq33XG6q7yukagxK6y01DXtM5A3lqW9fTQhPS
        tLLwIRLPyC6N/WekSqqUm3U=
X-Google-Smtp-Source: ABdhPJw12Bz9IqteQi2zoQqdI4wqFS07DooW5xZPTzKv96sZ/v93sLZGCtIKSrw1ITvnFsKlzOOnSA==
X-Received: by 2002:a17:903:248:b0:155:e660:b774 with SMTP id j8-20020a170903024800b00155e660b774mr17311002plh.174.1650882684549;
        Mon, 25 Apr 2022 03:31:24 -0700 (PDT)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id m4-20020a17090ab78400b001cd4989fed0sm14680828pjr.28.2022.04.25.03.31.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Apr 2022 03:31:24 -0700 (PDT)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        pabeni@redhat.com, krzk+dt@kernel.org, roopa@nvidia.com,
        andrew@lunn.ch, edumazet@google.com
Cc:     wells.lu@sunplus.com, Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next v9 0/2] This is a patch series for Ethernet driver of Sunplus SP7021 SoC.
Date:   Mon, 25 Apr 2022 18:30:38 +0800
Message-Id: <1650882640-7106-1-git-send-email-wellslutw@gmail.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

 .../bindings/net/sunplus,sp7021-emac.yaml     | 141 +++++
 MAINTAINERS                                   |   8 +
 drivers/net/ethernet/Kconfig                  |   1 +
 drivers/net/ethernet/Makefile                 |   1 +
 drivers/net/ethernet/sunplus/Kconfig          |  35 ++
 drivers/net/ethernet/sunplus/Makefile         |   6 +
 drivers/net/ethernet/sunplus/spl2sw_define.h  | 270 ++++++++
 drivers/net/ethernet/sunplus/spl2sw_desc.c    | 228 +++++++
 drivers/net/ethernet/sunplus/spl2sw_desc.h    |  19 +
 drivers/net/ethernet/sunplus/spl2sw_driver.c  | 577 ++++++++++++++++++
 drivers/net/ethernet/sunplus/spl2sw_driver.h  |  12 +
 drivers/net/ethernet/sunplus/spl2sw_int.c     | 260 ++++++++
 drivers/net/ethernet/sunplus/spl2sw_int.h     |  13 +
 drivers/net/ethernet/sunplus/spl2sw_mac.c     | 274 +++++++++
 drivers/net/ethernet/sunplus/spl2sw_mac.h     |  18 +
 drivers/net/ethernet/sunplus/spl2sw_mdio.c    | 126 ++++
 drivers/net/ethernet/sunplus/spl2sw_mdio.h    |  12 +
 drivers/net/ethernet/sunplus/spl2sw_phy.c     |  92 +++
 drivers/net/ethernet/sunplus/spl2sw_phy.h     |  12 +
 .../net/ethernet/sunplus/spl2sw_register.h    |  86 +++
 20 files changed, 2191 insertions(+)
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
2.25.1

