Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A324D4827
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 14:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242469AbiCJNhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 08:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242452AbiCJNhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 08:37:42 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6035B14EF41;
        Thu, 10 Mar 2022 05:36:40 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id r7so9480096lfc.4;
        Thu, 10 Mar 2022 05:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=1DB/xtUlg/bv2cuDVJn+P6RhKyQoRLt8abFtk957r6s=;
        b=KBGIzYMTJcy4uw8dS+TAg5MvLQFgLkwp2dDT3D+ltBEnHvsAQgnYDBZONyDk4w0Axx
         PVVD6ezuq5vH+cvZ8jHllKjdd9G/oTQggbuVa29313tGszcpcO5A+42DVTsP4sEtPJHF
         rFjfeJuRAa5OeLyH49lDkzNLaQ+ThCDPZaQZkOxXNmni4mfRJIJ2M+kpomLff6L1IyaI
         IU6tc5P1rlt0jsPyBlbYcETV/4IuQE/F2ezJU9KzTltndoCqOhlqnl4s3BW80ekQ1MX4
         Q9fbbhfYZdo9jE310hgPS9x8zUdqvoRiuNEGZUeWuslxgEBq1cjHHLvNNBpY6gAUvjyL
         mkWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=1DB/xtUlg/bv2cuDVJn+P6RhKyQoRLt8abFtk957r6s=;
        b=aQ/aTdoz8SsGIBa2ZNL1QnKjc4bFG9HRdU2RoFtueyiJUSejgwOlLnpPTNxCdGaypP
         BLO2SH9c1EPBeAjKyMkrIX589ZXo0FjRKq99FoaZZxCmu9FV7tj/iAwXc/OhyQCrWGag
         mZyOOKJt/EU6IDDKrWfeE9+CRfgmWSPzyuJyZgk9WQ5sDIDP15G2TnZbiz08+J/niiW6
         p/M6OpM3Qo6Ixuv2fDAo9kVB8YIBbpobV6CvLegfadwictsoo46n/by0tEdOrExCwJqh
         fXfPBiBROAYC+10o4vupQV2o0t0+TUD/N3fAw95q6jhB+shUDJsiJCFF4YAAoLQmUVDW
         YQzQ==
X-Gm-Message-State: AOAM533OEW9xvg2774FewIaaeST3w+x0Vj9oALqgl3hJoYQb16dzZscC
        vr6UaMhW/DqRz9WeSW7YCsY=
X-Google-Smtp-Source: ABdhPJy2Fp0IQemgzjdj7RNcr85FsKQiGyYZMQp8zrY1JJ8cAi7qZVOQefmAvKJ21S0Lpl2rnOAR6w==
X-Received: by 2002:a19:e00e:0:b0:443:127b:558d with SMTP id x14-20020a19e00e000000b00443127b558dmr3016797lfg.396.1646919398432;
        Thu, 10 Mar 2022 05:36:38 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id i2-20020a05651c120200b00247d22bc318sm1060299lja.22.2022.03.10.05.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 05:36:37 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: [PATCH iproute2-next 0/3] Extend locked port feature with FDB locked flag (MAC-Auth/MAB)
Date:   Thu, 10 Mar 2022 14:36:14 +0100
Message-Id: <20220310133617.575673-1-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set extends the locked port feature for devices
that are behind a locked port, but do not have the ability to
authorize themselves as a supplicant using IEEE 802.1X.
Such devices can be printers, meters or anything related to
fixed installations. Instead of 802.1X authorization, devices
can get access based on their MAC addresses being whitelisted.

For an authorization daemon to detect that a device is trying
to get access through a locked port, the bridge will add the
MAC address of the device to the FDB with a locked flag to it.
Thus the authorization daemon can catch the FDB add event and
check if the MAC address is in the whitelist and if so replace
the FDB entry without the locked flag enabled, and thus open
the port for the device.

This feature is known as MAC-Auth or MAC Authentication Bypass
(MAB) in Cisco terminology, where the full MAB concept involves
additional Cisco infrastructure for authorization. There is no
real authentication process, as the MAC address of the device
is the only input the authorization daemon, in the general
case, has to base the decision if to unlock the port or not.

With this patch set, an implementation of the offloaded case is
supplied for the mv88e6xxx driver. When a packet ingresses on
a locked port, an ATU miss violation event will occur. When
handling such ATU miss violation interrupts, the MAC address of
the device is added to the FDB with a zero destination port
vector (DPV) and the MAC address is communicated through the
switchdev layer to the bridge, so that a FDB entry with the
locked flag enabled can be added.

Hans Schultz (3):
  net: bridge: add fdb flag to extent locked port feature
  net: switchdev: add support for offloading of fdb locked flag
  net: dsa: mv88e6xxx: mac-auth/MAB implementation

 drivers/net/dsa/mv88e6xxx/Makefile            |  1 +
 drivers/net/dsa/mv88e6xxx/chip.c              | 10 +--
 drivers/net/dsa/mv88e6xxx/chip.h              |  5 ++
 drivers/net/dsa/mv88e6xxx/global1.h           |  1 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c       | 29 +++++++-
 .../net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c   | 67 +++++++++++++++++++
 .../net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h   | 20 ++++++
 drivers/net/dsa/mv88e6xxx/port.c              | 11 +++
 drivers/net/dsa/mv88e6xxx/port.h              |  1 +
 include/net/switchdev.h                       |  3 +-
 include/uapi/linux/neighbour.h                |  1 +
 net/bridge/br.c                               |  3 +-
 net/bridge/br_fdb.c                           | 13 +++-
 net/bridge/br_input.c                         | 11 ++-
 net/bridge/br_private.h                       |  5 +-
 15 files changed, 167 insertions(+), 14 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h

-- 
2.30.2

