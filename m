Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB34483903
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 00:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiACXZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 18:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiACXZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 18:25:58 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F83C061761;
        Mon,  3 Jan 2022 15:25:58 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id u20so30616636pfi.12;
        Mon, 03 Jan 2022 15:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PT7v3yq/kKPO1bv2dt1Zy6Lmb6fcIZnpBOyxe/r0pQY=;
        b=kr48qctul0wB+QJd5D/ghiCCJ48P7A1+gHe2fyCp/kB+h6Next1ppT7mqReVg8z1t5
         mwDXumiacNv6NEEh2WmX5sRP7uboT9IX3qCvqnurpQfvXzLmpvG03uapcl9bBrGn4wjZ
         jo9XXxU+aYj5i8XBA5JTCbzcwCyH1p0jFLV3g0gFs+P3M6DLeaRvSp2ElKnt3EETvJnK
         wVdNFbLKtDopj9IRE4C7WYcK6IW9tJr9GpxomklKflswEwSKBD7Nz8MVR0U6yVbik1LC
         xWrO/XTpa8aMxvNegU+yke4O8Gzm4OuMTWNhYhDuyJ+eVJgDslnSCeHVal/P0XgtbNo9
         AU/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PT7v3yq/kKPO1bv2dt1Zy6Lmb6fcIZnpBOyxe/r0pQY=;
        b=If9ay3awFe2GLbyvq4AR/onBBsV9/IewgDC11pMLVI1PxXN5GG/ysVr/3fr7Q7MlOw
         +av1jui1SEfii7GZ2RWiB2XGZW89G8r1gW65FQzqtryEXccND5Cdcot6Umd2LnTsaPy9
         eVtcPEnrt6AVcS2WN7OlXXFiKZZzG8AVf/5iR+3TjRsqzrZPO0L0c1+UnkkrW+tQCal+
         nfJA63wwwBU2/JHHHRuZIPrv8wBDQ6rrbCA3d9vpseZAswkP7WytfEjFMmHMelweiDh8
         qzav98HtnrgEgYPcIN8DFO9/1lO3RFa6o8ZDgJKlXrE6FheQhXsvVdDPnjEIudYz7IQl
         qYEA==
X-Gm-Message-State: AOAM532yJ0n/2FAS1IPauIQFzWrEmC2kBMecSp6GWVRCTREm/mIatRSi
        ujU6Vs/lEjNO+s66ls2o0TftFija3hc=
X-Google-Smtp-Source: ABdhPJzdBE+N2mqpdCPYMmB6xVm7y8Bzvl457NfjVxl2KINWTsCJRlLT/1/XWujesny+KX4tTRnl9g==
X-Received: by 2002:aa7:8154:0:b0:4bc:a467:614d with SMTP id d20-20020aa78154000000b004bca467614dmr6896063pfn.48.1641252357412;
        Mon, 03 Jan 2022 15:25:57 -0800 (PST)
Received: from localhost.localdomain ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id k6sm41340191pff.106.2022.01.03.15.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 15:25:56 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH RFC V1 net-next 0/4] Make MAC/PHY time stamping selectable
Date:   Mon,  3 Jan 2022 15:25:51 -0800
Message-Id: <20220103232555.19791-1-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Up until now, there was no way to let the user select the layer at
which time stamping occurs.  The stack assumed that PHY time stamping
is always preferred, but some MAC/PHY combinations were buggy.

This series aims to allow the user to select the desired layer
administratively.

- Patch 1 refactors get_ts_info copy/paste code.

- Patch 2 introduces sysfs files that reflect the current, static
  preference of PHY over MAC.

- Patch 3 makes the layer selectable at run time.

- Patch 4 fixes up MAC drivers that attempt to defer to the PHY layer.
  This patch is broken out for review, but it will eventually be
  squashed into Patch 3 after comments come in.

Thanks,
Richard


Richard Cochran (4):
  net: ethtool: Refactor identical get_ts_info implementations.
  net: Expose available time stamping layers to user space.
  net: Let the active time stamping layer be selectable.
  net: fix up drivers WRT phy time stamping

 .../ABI/testing/sysfs-class-net-timestamping  |  20 ++++
 drivers/net/bonding/bond_main.c               |  14 +--
 drivers/net/ethernet/freescale/fec_main.c     |  23 ++--
 drivers/net/ethernet/mscc/ocelot_net.c        |  21 ++--
 drivers/net/ethernet/ti/cpsw_priv.c           |  12 +--
 drivers/net/ethernet/ti/netcp_ethss.c         |  26 +----
 drivers/net/macvlan.c                         |   4 +-
 drivers/net/phy/phy_device.c                  |   2 +
 include/linux/ethtool.h                       |   8 ++
 include/linux/netdevice.h                     |  10 ++
 net/8021q/vlan_dev.c                          |  15 +--
 net/core/dev_ioctl.c                          |  44 +++++++-
 net/core/net-sysfs.c                          | 102 ++++++++++++++++++
 net/core/timestamping.c                       |   6 ++
 net/ethtool/common.c                          |  24 ++++-
 15 files changed, 244 insertions(+), 87 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-net-timestamping

-- 
2.20.1

