Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDD84DC303
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 10:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbiCQJkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 05:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiCQJkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 05:40:35 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF7D185447;
        Thu, 17 Mar 2022 02:39:16 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id u7so6401359ljk.13;
        Thu, 17 Mar 2022 02:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=IAni6CZ3rMr9AtNTUfmAVEBymHaVw/hvggCMmkUx9/o=;
        b=Mb0vVZplMfFqQljm0vS4KbqDPo346w3lbKqjCZZmv816h8VP9QGTpJ7UBew3uB/4PM
         Hh6SAqiF4HSyR7s3C3cZ/Ykd7l+4Kpfj3ERrMuELhABalzRQtZ+ccHLbLTrgjvchnqgw
         ftcAbs3BBrIvJPli6osV4wKOTTH6o0lFhm0x3JwLV49vPM3EzP6SMQjV9QvLN8eASWbl
         irD5YC7ApxtpjJx0JXTgKFt5FTDuAJsVWS3zp+F9k0Rznfwscex4M3OTTTkWlOZg7A+Z
         Cgj8fsscSrERR7eMSOGezU5wigTHeU285EGVS7/yZRf42kvYw9GG16ZKklcbFHJcnybW
         P20g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=IAni6CZ3rMr9AtNTUfmAVEBymHaVw/hvggCMmkUx9/o=;
        b=TJXL/nLNoPTpTgDUejBPaSnv5gC0Ejd2zDyp+wZN2w2Gtz2Ke99DT2EnBGaUVKfKs5
         zaJMMQZ64bRzLMwaYXx6NgxPay+3MxhVCGHwba13dJ10QCf33tKaZR9xC6a88q3TQ2bB
         l8gkJAcl3fb/dIROyG+qdj0OcVyAAn2mqt+Y9X4soLIXbn5zqMcceGBR0unXNNqAi+AW
         tfIV01l9mYxFvh/Nq2Q+DH9kV0c2Upt0hbBW7z0iqdwqqr24HyJXPxigvvuc0k/zzc8i
         IsIMwHE1XMVZSbsAfItil+R/QHysKGFfb+G2wUvcVm5/6h0CptjnNNtmWGG/769CDcnU
         qDyQ==
X-Gm-Message-State: AOAM533eNDGyhkNaEtW+BYtBSoAuxMTeOa2suRJuHTtqWuBU5Ee3yfRy
        XuoDVJ5pwAT1nEBeD4Pn7yc=
X-Google-Smtp-Source: ABdhPJwCJ3qid9v1XmzSyyNEYPw8NR7deFnj9+fvlK/qXfsIozHJaXLcZCtZaYbFSPEkAMpTl5ZvqA==
X-Received: by 2002:a2e:804d:0:b0:246:1aba:af59 with SMTP id p13-20020a2e804d000000b002461abaaf59mr2258039ljg.508.1647509955084;
        Thu, 17 Mar 2022 02:39:15 -0700 (PDT)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id w13-20020a2e998d000000b002496199495csm113479lji.55.2022.03.17.02.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 02:39:14 -0700 (PDT)
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
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v2 net-next 0/4] Extend locked port feature with FDB locked flag (MAC-Auth/MAB)
Date:   Thu, 17 Mar 2022 10:38:58 +0100
Message-Id: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
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

Hans Schultz (4):
  net: bridge: add fdb flag to extent locked port feature
  net: switchdev: add support for offloading of fdb locked flag
  net: dsa: mv88e6xxx: mac-auth/MAB implementation
  selftests: forwarding: add test of MAC-Auth Bypass to locked port
    tests

 drivers/net/dsa/mv88e6xxx/Makefile            |  1 +
 drivers/net/dsa/mv88e6xxx/chip.c              | 10 +--
 drivers/net/dsa/mv88e6xxx/chip.h              |  5 ++
 drivers/net/dsa/mv88e6xxx/global1.h           |  1 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c       | 29 ++++++-
 .../net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c   | 75 +++++++++++++++++++
 .../net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h   | 20 +++++
 drivers/net/dsa/mv88e6xxx/port.c              | 17 ++++-
 drivers/net/dsa/mv88e6xxx/port.h              |  1 +
 include/net/switchdev.h                       |  3 +-
 include/uapi/linux/neighbour.h                |  1 +
 net/bridge/br.c                               |  3 +-
 net/bridge/br_fdb.c                           | 13 +++-
 net/bridge/br_input.c                         | 10 ++-
 net/bridge/br_private.h                       |  5 +-
 .../net/forwarding/bridge_locked_port.sh      | 29 ++++++-
 16 files changed, 206 insertions(+), 17 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h

-- 
2.30.2

