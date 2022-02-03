Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267D04A823A
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 11:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350033AbiBCKRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 05:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiBCKRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 05:17:04 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5A1C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 02:17:04 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id c192so1569023wma.4
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 02:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=tI8S399i7Bv6ovYxZF1iobXX3+ODO3WZuRgiLSPaERU=;
        b=MC6EyJhBT/8iAVw/UOYt4HOYgFOzl6IvmfD0LwIl/C0pWKjlu3qlUlqDzfu8Miy2Fg
         Yu12zB4cg/q22mqbPCveoE3DAjEhZBLz/AcvFgOWXaFQAZ2S+OkTCTxPHaa97/dAVMw0
         /DnMP6QkmUTDIJ/IWgQTBMe71sTDLaSssfKydnJV8MO3WGyLki5w29asNZqZva6Ghzli
         UU/ehiHlNUuiEn93XoV7b0TO3EZ2lufD67pcuAozWsEPI9Kf7FomlMGmb/+BcAv0Nhv8
         ZRMpvB84aRO16bM2GKOL+Iih2F54xXkMqiI+xmaWsW2AoSnX6vieM8ZCqYfVDPI6AWKN
         iEAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=tI8S399i7Bv6ovYxZF1iobXX3+ODO3WZuRgiLSPaERU=;
        b=uGjg9vxDE7ug8uVzn787lx/T4Gs5KM+3M4tQOevMniYl3RAtLsvYfCvkPpc3/ivat8
         jr/rF5sIOB1CE9qxCQS80HOe5niLDD22abGooHv/xhAwh029tdhNL3e4JdCnfhu3/nll
         11W2Gl0RMA0SF4tfXUiaeqTQIVf5lEpacw2LLnautaBx3dPwDnXYMvH9Az1pvh43S/sd
         5VRdPrKlY4OrAM0Gzieqw+jm9p1i/Nvnu/fIcFdJKlPcPMO9e3/YYNx6PBCWwyP42iO0
         yGOMKknEfxk5cUekv+alWi8yiB3ygSebDLfPR7XVtr4DE6h5gtAKaF1d7JbT9t9Ojz92
         cQsg==
X-Gm-Message-State: AOAM531haRp63Q0A26F2QQuicRe5hvC/LuF9RJl7RYBu/Ejcts6crp/i
        CA6OiJPS4q231cmQ5p1HKOXGbS1PJ0ZLEA==
X-Google-Smtp-Source: ABdhPJwwMa7Ap//B7C6BA7G5jvvbjRvrs8/nvB/WT4I8xm2X/ww+wXG7jISuc+DKwaItqUezRSa0sQ==
X-Received: by 2002:a05:600c:1d17:: with SMTP id l23mr9540148wms.174.1643883422605;
        Thu, 03 Feb 2022 02:17:02 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g6sm19017148wrq.97.2022.02.03.02.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 02:17:02 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2 net-next 0/5] net: dsa: mv88e6xxx: Improve standalone port isolation
Date:   Thu,  3 Feb 2022 11:16:52 +0100
Message-Id: <20220203101657.990241-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ideal isolation between standalone ports satisfies two properties:
1. Packets from one standalone port must not be forwarded to any other
   port.
2. Packets from a standalone port must be sent to the CPU port.

mv88e6xxx solves (1) by isolating standalone ports using the PVT. Up
to this point though, (2) has not guaranteed; as the ATU is still
consulted, there is a chance that incoming packets never reach the CPU
if its DA has previously been used as the SA of an earlier packet (see
1/5 for more details). This is typically not a problem, except for one
very useful setup in which switch ports are looped in order to run the
bridge kselftests in tools/testing/selftests/net/forwarding. This
series attempts to solve (2).

Ideally, we could simply use the "ForceMap" bit of more modern chips
(Agate and newer) to classify all incoming packets as MGMT. This is
not available on older silicon that is still widely used (Opal Plus
chips like the 6097 for example).

Instead, this series takes a two pronged approach:

1/5: Always clear MapDA on standalone ports to make sure that no ATU
     entry can lead packets astray. This solves (2) for single-chip
     systems.

2/5: Trivial prep work for 4/5.
3/5: Trivial prep work for 4/5.

4/5: On multi-chip systems though, this is not enough. On the incoming
     chip, the packet will be forced out towards the CPU thanks to
     1/5, but on any intermediate chips the ATU is still consulted. We
     override this behavior by marking the reserved standalone VID (0)
     as a policy VID, the DSA ports' VID policy is set to TRAP. This
     will cause the packet to be reclassified as MGMT on the first
     intermediate chip, after which it's a straight shot towards the
     CPU.

Finally, we allow more tests to be run on mv88e6xxx:

5/5: The bridge_vlan{,un}aware suites sets an ageing_time of 10s on
     the bridge it creates, but mv88e6xxx has a minimum supported time
     of 15s. Allow this time to be overridden in forwarding.config.

With this series in place, mv88e6xxx passes the following kselftest
suites:

- bridge_port_isolation.sh
- bridge_sticky_fdb.sh
- bridge_vlan_aware.sh
- bridge_vlan_unaware.sh

v1 -> v2:
  - Wording/spelling (Vladimir)
  - Use standard iterator in dsa_switch_upstream_port (Vladimir)
  - Limit enabling of VTU port policy to downstream DSA ports (Vladimir)

Tobias Waldekranz (5):
  net: dsa: mv88e6xxx: Improve isolation of standalone ports
  net: dsa: mv88e6xxx: Support policy entries in the VTU
  net: dsa: mv88e6xxx: Enable port policy support on 6097
  net: dsa: mv88e6xxx: Improve multichip isolation of standalone ports
  selftests: net: bridge: Parameterize ageing timeout

 drivers/net/dsa/mv88e6xxx/chip.c              | 97 ++++++++++++++-----
 drivers/net/dsa/mv88e6xxx/chip.h              |  1 +
 drivers/net/dsa/mv88e6xxx/global1.h           |  1 +
 drivers/net/dsa/mv88e6xxx/global1_vtu.c       |  5 +-
 drivers/net/dsa/mv88e6xxx/port.c              |  7 +-
 drivers/net/dsa/mv88e6xxx/port.h              |  2 +-
 include/net/dsa.h                             | 18 ++++
 .../net/forwarding/bridge_vlan_aware.sh       |  5 +-
 .../net/forwarding/bridge_vlan_unaware.sh     |  5 +-
 .../net/forwarding/forwarding.config.sample   |  2 +
 tools/testing/selftests/net/forwarding/lib.sh |  1 +
 11 files changed, 110 insertions(+), 34 deletions(-)

-- 
2.25.1

