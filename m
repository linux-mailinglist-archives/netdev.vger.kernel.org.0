Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD866E702F
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 02:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjDSAKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 20:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjDSAKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 20:10:30 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CD0113;
        Tue, 18 Apr 2023 17:10:29 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id a23so26722116qtj.8;
        Tue, 18 Apr 2023 17:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681863029; x=1684455029;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rE1EEDO+fEqLoZiLrhfSx85AyW8A+vdoa/Snn4cvZO8=;
        b=ZHXM1vJBIY5/tmjJT0bVpzwkzgcuj3UqE6ZuAM+WopWTizO0zDdpKa7LVRnsmGTn1d
         dNzyQC1wJv2vOr86Nkl6+DausEEP53FrPRiRv4UhVQurNRPpO1CmxFUxHDSvYCh0/r4L
         STAJGBMIzP8mz/nBypYUlSeBjFBmmgYZ34WTb9Sd6ekjELm6Sq0Us2ZOuGOcqa6R7okN
         2jNHKJT6OPVZCX1v4iC9zXkRhVV+lHS8I1FE7A1UBj5sBxKKNp3qwrF86F1KMEggt5SN
         XY0Sxw8Awni/NHCWXYhwkKcyE6nH1rM9D1QcXbrpE5pYEXAY0ipeoblBZlUd07Kvxxbt
         q+Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681863029; x=1684455029;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rE1EEDO+fEqLoZiLrhfSx85AyW8A+vdoa/Snn4cvZO8=;
        b=h4cBprx4lIu4Z7Z/DeZGOHsMMC5oAJ0Zsc91lD/fLgys7/1O2HeyI/tCdLJowtSCjy
         iSO3KLxLi/cDFd7SsfWZSOYRkeuC6GkxfiBQ3rZ6mJoKqyfOunnU1UyiX7Osmtda5cjn
         pDOed8Zkuo5LjW2cCs+4FUYERBW60LZey06HuTdQIjJVWUpQLrlhPw8nH3SV8vP+FEkN
         l71rCrjEE7An8IlDWDfilXHiSXqeQlaP0sSlr9gV7mJ6XwSZQO5IjoaDyXGfa1u7ybcA
         FFAZ/LMcnjHzDSzD4Yv1nQBEOjxIPsLiUhzOvZs9ZB0DoxAvJ6fqwttpd3AYvGsbFNnk
         gy8A==
X-Gm-Message-State: AAQBX9dSznZERbZ2AYCsCJftl1NBUQN/msnRbqHdaz1N10ZSgrxsqliq
        exEHR5JR5DWQr+nsYhzdivhorvcT/Nj+pw==
X-Google-Smtp-Source: AKy350aJZdwTEBQKh+v50v7gsPOE+8maA9oyygbdcVRFgplCIK6a3+p7/GpmoeTI1M2smoh5fZHNFg==
X-Received: by 2002:ac8:5e4d:0:b0:3e6:4fab:478e with SMTP id i13-20020ac85e4d000000b003e64fab478emr3325666qtx.33.1681863028798;
        Tue, 18 Apr 2023 17:10:28 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d14-20020a37680e000000b0074d1b6a8187sm2639035qkc.130.2023.04.18.17.10.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Apr 2023 17:10:28 -0700 (PDT)
From:   Justin Chen <justinpopo6@gmail.com>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        bcm-kernel-feedback-list@broadcom.com
Cc:     justin.chen@broadcom.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com
Subject: [PATCH net-next 0/6] Brcm ASP 2.0 Ethernet controller
Date:   Tue, 18 Apr 2023 17:10:12 -0700
Message-Id: <1681863018-28006-1-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Justin Chen <justin.chen@broadcom.com>

Add support for the Broadcom ASP 2.0 Ethernet controller which is first
introduced with 72165.

Add support for 74165 10/100 integrated Ethernet PHY which also uses
the ASP 2.0 Ethernet controller.

Florian Fainelli (2):
  dt-bindings: net: Brcm ASP 2.0 Ethernet controller
  net: phy: bcm7xxx: Add EPHY entry for 74165

Justin Chen (4):
  dt-bindings: net: brcm,unimac-mdio: Add asp-v2.0
  net: bcmasp: Add support for ASP2.0 Ethernet controller
  net: phy: mdio-bcm-unimac: Add asp v2.0 support
  MAINTAINERS: ASP 2.0 Ethernet driver maintainers

 .../devicetree/bindings/net/brcm,asp-v2.0.yaml     |  146 ++
 .../devicetree/bindings/net/brcm,unimac-mdio.yaml  |    2 +
 MAINTAINERS                                        |    9 +
 drivers/net/ethernet/broadcom/Kconfig              |   11 +
 drivers/net/ethernet/broadcom/Makefile             |    1 +
 drivers/net/ethernet/broadcom/asp2/Makefile        |    2 +
 drivers/net/ethernet/broadcom/asp2/bcmasp.c        | 1527 ++++++++++++++++++++
 drivers/net/ethernet/broadcom/asp2/bcmasp.h        |  636 ++++++++
 .../net/ethernet/broadcom/asp2/bcmasp_ethtool.c    |  620 ++++++++
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   | 1425 ++++++++++++++++++
 .../net/ethernet/broadcom/asp2/bcmasp_intf_defs.h  |  238 +++
 drivers/net/mdio/mdio-bcm-unimac.c                 |    2 +
 drivers/net/phy/bcm7xxx.c                          |    1 +
 include/linux/brcmphy.h                            |    1 +
 14 files changed, 4621 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
 create mode 100644 drivers/net/ethernet/broadcom/asp2/Makefile
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp.c
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp.h
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp_intf_defs.h

-- 
2.7.4

