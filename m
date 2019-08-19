Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6905B94BB3
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfHSR2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:28:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33130 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbfHSR2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 13:28:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id u16so9563119wrr.0;
        Mon, 19 Aug 2019 10:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ClqerbBjg450Lc58lgKLRGrPHpYt30ShGni2xyZq7jk=;
        b=G9Z0Rpf+onGK5QjPJhVeaBrOMXNzNK0E+Bn892hf/AZon2K+1TO7PSdTRS9dCdQTrx
         4XQsuuV00u27PVrigNcsD67Sn5AOe5EGuncZsFOTU10VgnqPTZcG1+aIvGKBS2b5m7WH
         72acXK+VdVJd2BdxwJSS7CZ6FpSKgZl0Y8WwzkXFeQBNf3hKl8UiHwfKqUQodrXVvUm6
         h9QjQ0wwtwkpL4DLg/Ci8MJBlD9GkoxYp2Zej6AjlsHHEs1KHZ9ARuosJEoAJynNzJnj
         yccSgrm/mIcTnCeUpulEdXRC44jNThTsyW50+0zjf76JU0c+qkenPpcehu9PZkDzohZg
         7XTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ClqerbBjg450Lc58lgKLRGrPHpYt30ShGni2xyZq7jk=;
        b=EI57JKc60UNuc4OyFSpyEJfJMMRhKYxa90o8Z3mPAcspbKdsC14IFbvDDvo6vhq9fx
         fX+/AXT5Hj8F+KvBo43xfeVurUnJ3mWGa7lIC7pLDmxNMaDm4ds5suIPumRHcaSrMpp3
         8S6fIryUA08VdMXDZ27RaOTOZSCaU7AvFQ5Zw916w4SItrCEW3EIFTag8G3oWR+NxBVg
         sPdPLFqdFXELnrbII2K3cgw5auaHAZTqrvZoB0X1QwgnJF8rw/3V2nwO1USWE1VOTMgu
         rJg9Yj73RYWECZ/7KwP/WBMR8YfGw+yycl1GvMjy3G/0TnxF6v+Fu7S1VeBJ+ZnzMqQt
         EfYA==
X-Gm-Message-State: APjAAAWBjFpqRlmwD8d//SD+TTnlf0dmb6t1W4uabk7WmEQgYqYA8Lcw
        Jrc7UsKRE092oaQwNCVQ0ccGxeNNsbM=
X-Google-Smtp-Source: APXvYqwOzeOqNU2U8v9rSRb1/N5W0q2PMNswSlIAFqQviGpjWFOnDSAf8H00WPzdUC12oJ4x9majZQ==
X-Received: by 2002:a5d:4a45:: with SMTP id v5mr21031974wrs.108.1566235718344;
        Mon, 19 Aug 2019 10:28:38 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id c15sm41983879wrb.80.2019.08.19.10.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 10:28:37 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
X-Google-Original-From: Hubert Feurstein <hubert.feurstein@vahle.at>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <hubert.feurstein@vahle.at>,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next v2 0/4] Improve phc2sys precision for mv88e6xxx switch in combination with imx6-fec
Date:   Mon, 19 Aug 2019 19:28:23 +0200
Message-Id: <20190819172827.9550-1-hubert.feurstein@vahle.at>
X-Mailer: git-send-email 2.22.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this patchset the phc2sys synchronisation precision improved to +/-555ns on
an IMX6DL with an MV88E6220 switch attached.

This patchset takes into account the comments from the following discussions:
- https://lkml.org/lkml/2019/8/2/1364
- https://lkml.org/lkml/2019/8/5/169

Patch 01 adds the required infrastructure in the MDIO layer.
Patch 02 adds additional PTP offset compensation
Patch 03 adds support for the PTP_SYS_OFFSET_EXTENDED ioctl in the mv88e6xxx driver.
Patch 04 adds support for the PTP system timestamping in the imx-fec driver.

The following tests show the improvement caused by each patch. The system clock 
precision was set to 15ns instead of 333ns (as described in https://lkml.org/lkml/2019/8/2/1364).

Without this patchset applied, the phc2sys synchronisation performance was very 
poor:

  offset: min -27120 max 28840 mean 2.44 stddev 8040.78 count 1236
  delay:  min 282103 max 386385 mean 352568.03 stddev 27814.27 count 1236
  (test runtime 20 minutes)

Results after appling patch 01-03:

  offset: min -12316 max 13314 mean -9.38 stddev 4274.82 count 1022
  delay:  min 69977 max 96266 mean 87939.04 stddev 6466.17 count 1022
  (test runtime 16 minutes)

Results after appling patch 03:

  offset: min -788 max 528 mean -0.06 stddev 185.02 count 7171
  delay:  min 1773 max 2031 mean 1909.43 stddev 33.74 count 7171
  (test runtime 119 minutes)

Hubert Feurstein (4):
  net: mdio: add support for passing a PTP system timestamp to the
    mii_bus driver
  net: mdio: add PTP offset compensation to mdiobus_write_sts
  net: dsa: mv88e6xxx: extend PTP gettime function to read system clock
  net: fec: add support for PTP system timestamping for MDIO devices

 drivers/net/dsa/mv88e6xxx/chip.h          |  2 +
 drivers/net/dsa/mv88e6xxx/ptp.c           | 11 +--
 drivers/net/dsa/mv88e6xxx/smi.c           |  3 +-
 drivers/net/ethernet/freescale/fec_main.c |  7 +-
 drivers/net/phy/mdio_bus.c                | 88 +++++++++++++++++++++++
 include/linux/mdio.h                      |  5 ++
 include/linux/phy.h                       | 42 +++++++++++
 7 files changed, 152 insertions(+), 6 deletions(-)

-- 
2.22.1

