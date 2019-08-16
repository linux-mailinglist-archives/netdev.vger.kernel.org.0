Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D9A905E1
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 18:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbfHPQcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 12:32:19 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36859 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfHPQcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 12:32:19 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so2117006wrt.3;
        Fri, 16 Aug 2019 09:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J314qdUvz12V6d3QViRALM7rawvrwtwSfJHkRDPm5Hw=;
        b=bFlPjlEbw16qXErPnq5piBe7z3XTDmnzeoiTTCa7lc/N9m/opz9lUSrcjavE9JorkZ
         ogHzZOEyqVTNQ29Wfj+KQ6HXetYWVNw44ukOtf2YM7iaRbDHWQuamn2ZiJe2ZBRWjPGg
         /V1Lk3DwUZUEFaUQfPny1AKHESiMWuA1DRdKdh1evm8msptix+KZXlHrnKOXSsk5a5iU
         MpVlOZY5tzglGEYHY7nDPG8rzcRAiO7fks7ZhcMR7gCSiAlnMd0N4DBpZAhazBgCpv/u
         pGdfGTgQLCiNJ3PskruNkCZmVRO75aVGcqnyorAWE/4WGX3IkgAR76HI5gwQqZJx4sz2
         Ob7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J314qdUvz12V6d3QViRALM7rawvrwtwSfJHkRDPm5Hw=;
        b=ogxq41SWjEuwW/SS3SQTojLB2WFJhKjjpGkChtSwT3TrhV2kgfKXarW1mAgH8eGQYL
         ydfGN9kp/An8hM7gKS54xDgPAiPeGOOb18fijuo2JLP3IUUQ1jQbrCG7+2KYTgpW5w08
         9H1LIdD1PiGiuWQh0PGL3PeInrh1SPMhGOINhawvdy0OD3q37cUrTdRVwJuYByS0Lfzz
         9FnLcOow0Tf17wI5/NoBKeoTv7VO8oDq0ICPNwmNaOHy1KzGwU4Lj/w3q+JQ2aS+92JR
         QeJAD7+R1/azML/MYXwcBLb0BNUnvsk+OdCrAKg6pSYeZBX9zRS4T9fPDftykbJCSMGZ
         y/MA==
X-Gm-Message-State: APjAAAWgRg9th8H+t1va+ezOZ8QfXD/sPH4pSCydgpiZzjrxttDuwMmQ
        kWo1/07u2rdKnwI9Dk68b9cmcTm4NGk=
X-Google-Smtp-Source: APXvYqzkC/sFkwVKPTSaPC2A+NnLvZAz6bMhSLia3Uf5bqM63YYSyf50PbcbsfXUKBK5OQl5rwiQKw==
X-Received: by 2002:adf:fd82:: with SMTP id d2mr11692806wrr.194.1565973136985;
        Fri, 16 Aug 2019 09:32:16 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id d19sm11031677wrb.7.2019.08.16.09.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 09:32:16 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 0/3] Improve phc2sys precision for mv88e6xxx switch in combination with imx6-fec
Date:   Fri, 16 Aug 2019 18:31:54 +0200
Message-Id: <20190816163157.25314-1-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this patchset the phc2sys synchronisation precision improved to +/-555ns on an IMX6DL with an MV88E6220 switch attached.

This patchset takes into account the comments from the following discussions:
- https://lkml.org/lkml/2019/8/2/1364
- https://lkml.org/lkml/2019/8/5/169

Patch 01 adds the required infrastructure in the MDIO layer.
Patch 02 adds support for the PTP_SYS_OFFSET_EXTENDED ioctl in the mv88e6xxx driver.
Patch 03 adds support for the PTP system timestamping in the imx-fec driver.

The following tests show the improvement caused by each patch. The system clock precision was set to 15ns instead of 333ns (as described in https://lkml.org/lkml/2019/8/2/1364).

Without this patchset applied, the phc2sys synchronisation performance was very poor:

  offset: min -27120 max 28840 mean 2.44 stddev 8040.78 count 1236
  delay:  min 282103 max 386385 mean 352568.03 stddev 27814.27 count 1236
  (test runtime 20 minutes)

Results after appling patch 01 and 02:

  offset: min -12316 max 13314 mean -9.38 stddev 4274.82 count 1022
  delay:  min 69977 max 96266 mean 87939.04 stddev 6466.17 count 1022
  (test runtime 16 minutes)

Results after appling patch 03:

  offset: min -788 max 528 mean -0.06 stddev 185.02 count 7171
  delay:  min 1773 max 2031 mean 1909.43 stddev 33.74 count 7171
  (test runtime 119 minutes)

Hubert Feurstein (3):
  net: mdio: add support for passing a PTP system timestamp to the
    mii_bus driver
  net: dsa: mv88e6xxx: extend PTP gettime function to read system clock
  net: fec: add support for PTP system timestamping for MDIO devices

 drivers/net/dsa/mv88e6xxx/chip.h          |   2 +
 drivers/net/dsa/mv88e6xxx/ptp.c           |  11 ++-
 drivers/net/dsa/mv88e6xxx/smi.c           |   3 +-
 drivers/net/ethernet/freescale/fec_main.c |   3 +
 drivers/net/phy/mdio_bus.c                | 105 ++++++++++++++++++++++
 include/linux/mdio.h                      |   7 ++
 include/linux/phy.h                       |  25 ++++++
 7 files changed, 151 insertions(+), 5 deletions(-)

-- 
2.22.1

