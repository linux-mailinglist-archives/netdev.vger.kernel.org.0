Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1441454EEA
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240169AbhKQVIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240297AbhKQVIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:08:16 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A71C061570;
        Wed, 17 Nov 2021 13:05:17 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id x15so17055529edv.1;
        Wed, 17 Nov 2021 13:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Faw8cIvG+RI1BhwkS1A22U+SiHmOAQoNP8Yl5CPDSYk=;
        b=nQQnCTsj3utUHIUwQStjB55zDSZU04WMfhlqKbJVQ2W1frXy+AL8SgPMiCD7BPS4Ga
         Lg8de3OB1XSYWS9dxTHrE/KfJgbTMjqiAtAsMftKzyuPVAPAVRDbV2oTnYSMV0ZlDXO9
         i7rBeuS35UrW1dPgQXCIp0EnZeEAe8SsEM18x2oOQXdmXafVTqFCSTxjpM7b59Uckzpc
         JiQqyKQUMKkMwUIuQcMSa2YCDZkBn7ATfVmhz8XxGkor1sZZ9hD2qb3NllSRypPMJwYy
         ft32TgVxmJuwG/TmgHE2tzunkta9NoKyLVZKBTPRqEuxGKa9cyp1opplQTSUPyM3bA+i
         CUng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Faw8cIvG+RI1BhwkS1A22U+SiHmOAQoNP8Yl5CPDSYk=;
        b=48oJqt2tjM5BxevJ+2g9mfXd4FomOKBjw02FAtUCF3dTbRWYOjEi8muKGeMnHZyyjJ
         4DNAsVtVzT70F88v5oJk6eYDeq3VVp252I6nBIgL1BACkiZAUPz7PvJQM8NE00R1c5hb
         Z/NcX7tqR5xBy4OLg98tKeuQy2flYS9pROIEnl7tzOsTVci28/FjHQwYUuIJfNq1Q763
         bcVTZtH/JwNHMCfiQ1H2WKR/Tiw0vmjK3Ek+4dxwh2oJhYFeqJ+Q3isA2XXBcbMyEP51
         Qaa05NJzKEgb69rHUAyxxzH5M+hTTRSsa4iRbOMSP1CVo45FMNehLvcY5SeXQ9qdSjPL
         TSuA==
X-Gm-Message-State: AOAM533FeeXeRddxgOY5sm/BpR83aaKzmLxEHgAS/Sn3V1Ng4Paazi0D
        rTPQ/HOKyTtaMp5nBEr/DF4=
X-Google-Smtp-Source: ABdhPJwTmE8dSej2DgsV+NUj3urTuwSOu6pgej6yujxodqRI7ypIJoAaLBSNfWiD1CSlQ7Cgkxf09A==
X-Received: by 2002:a17:906:3408:: with SMTP id c8mr25358911ejb.41.1637183116021;
        Wed, 17 Nov 2021 13:05:16 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id di4sm467070ejc.11.2021.11.17.13.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:05:15 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH 00/19] Multiple cleanup and feature for qca8k
Date:   Wed, 17 Nov 2021 22:04:32 +0100
Message-Id: <20211117210451.26415-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains 3 main patch groups:
- Cleanup with conversion of the driver to bitfield macro and regmap.
- Add multiple feature mdb add/del, lag support, ageing and fast age.
- Code split of common code from specific code.

The first patch is just a reference from linux-next needed for the
regmap conversion.

As said in the commits, the code split is required as ipq40xx internal
switch is based on the same qca8k reg but use a different way to
read/write to the switch regs. We convert the driver to the generic
regmap and we split the driver to common and specific code.

This also contains a patch to fix a corner case when and if multi cpu
will be supported to DSA.
We add mdb add/del using the ARL table.
We add ageing support and fast age.
We add support for mirror mode.
We add 2 additional MIB present on qca8337.

The regmap conversion patch and the lag patch contains checkpatch
warning for too long line and these error are not fixed to not make the
definition of these regs pratically not readable.

Ansuel Smith (19):
  regmap: allow to define reg_update_bits for no bus configuration
  net: dsa: qca8k: remove redundant check in parse_port_config
  net: dsa: qca8k: skip sgmii delay on double cpu conf
  net: dsa: qca8k: convert to GENMASK/FIELD_PREP/FIELD_GET
  net: dsa: qca8k: move read switch id function in qca8k_setup
  net: dsa: qca8k: remove extra mutex_init in qca8k_setup
  net: dsa: qca8k: set regmap init as mandatory for regmap conversion
  net: dsa: qca8k: convert qca8k to regmap helper
  net: dsa: qca8k: add additional MIB counter and make it dynamic
  net: dsa: qca8k: add support for port fast aging
  net: dsa: qca8k: add support for mirror mode
  net: dsa: qca8k: add set_ageing_time support
  net: dsa: qca8k: add min/max ageing time
  net: dsa: qca8k: add support for mdb_add/del
  net: dsa: qca8k: add LAG support
  net: dsa: qca8k: enable mtu_enforcement_ingress
  net: dsa: qca8k: move qca8k to qca dir
  net: dsa: qca8k: use device_get_match_data instead of the OF variant
  net: dsa: qca8k: split qca8k in common and 8xxx specific code

 drivers/base/regmap/regmap.c                  |    1 +
 drivers/net/dsa/Kconfig                       |    8 -
 drivers/net/dsa/Makefile                      |    1 -
 drivers/net/dsa/qca/Kconfig                   |    9 +
 drivers/net/dsa/qca/Makefile                  |    2 +
 drivers/net/dsa/{qca8k.c => qca/qca8k-8xxx.c} | 1144 +++-------------
 drivers/net/dsa/qca/qca8k-common.c            | 1157 +++++++++++++++++
 drivers/net/dsa/qca/qca8k.h                   |  413 ++++++
 drivers/net/dsa/qca8k.h                       |  311 -----
 include/linux/regmap.h                        |    7 +
 10 files changed, 1750 insertions(+), 1303 deletions(-)
 rename drivers/net/dsa/{qca8k.c => qca/qca8k-8xxx.c} (56%)
 create mode 100644 drivers/net/dsa/qca/qca8k-common.c
 create mode 100644 drivers/net/dsa/qca/qca8k.h
 delete mode 100644 drivers/net/dsa/qca8k.h

-- 
2.32.0

