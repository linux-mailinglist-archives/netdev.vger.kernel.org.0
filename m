Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64702F8A6B
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbhAPB0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbhAPB0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:26:30 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E6EC061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:25:49 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id v67so15915240lfa.0
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=Wfap8KnOyOmZss2WsGffFT6cqP7qkJZksDv26GtM5u8=;
        b=T6qwIKDuIqj4Fy5LKHBePcW+oOhVa0C5JllzWf3MGVDPwEaRYMyUmLa0dCeCgStSYQ
         CauTuw7VjDeBrVsnBmhcgebXWjT4ywUhEqLVn2wjlV9JFAiescB14jNPYmejDSJr/rSm
         jMIFVlk4463BdfWkDU/VnIkUeeIZRBLbkqAqt2MWTo5kcogkfFO2H4Glzs+n9SJuQKgp
         5fI444OCns92yVrCBOPMacle2cURkl4mydkMtrcd1PZAHl6wOHANDGJ7+Q7iHNPkcU1+
         4oMG67/HuSNQIU0qcUp4B8lCIviwRhqhIEsMDSanrJk5UOYcjNZ0uSFjfFybafWGlRp8
         t8Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=Wfap8KnOyOmZss2WsGffFT6cqP7qkJZksDv26GtM5u8=;
        b=qSxH2vSkPtuoKB2iRxIN7I9sNC6o5VT/do5kt0SjZnBfw0HSjGY/iCk1V5KCd65B3Q
         I//ccJMjGLCwOj7qNF6nRnyin+LLr+NnMkCtYUppBZsuc8LhjW1x+0IP5+zB5xmphk0r
         SvoowoAt3Q5+Gl0lcltQf0uXfBGH0x4yHoVWRoQdQD16VjPE5RjfGyRKX9UiRTjFITxo
         zhmPR0d9dvKr4xD7M322E5Jk6FudaLT3wrcaPxJtDIKdNS33wQm3Hh0G387P358pQO2D
         sMtgPGcALiBqEK5To7ONqeWooRJ5R2GN5I+6MQfvWCEdbSKKstZrvwrJBNg0v1CYZAQT
         EiiQ==
X-Gm-Message-State: AOAM530eS/NkUbgsaiFmYiXsVSBt/SbGFk3Ubx4SCYHPu2NLQaCYh3/m
        vE7uRv7EVeZMeP0lWIYxeoq00X0sKuh1TZ9+
X-Google-Smtp-Source: ABdhPJznQYSAuSk5qc2I1D0hsGAioqr1C8DJFRLLoKiAVTIPApCS1p0gJDxqBeMWL5u4r5yx0tJu/Q==
X-Received: by 2002:a19:600d:: with SMTP id u13mr6689631lfb.312.1610760348480;
        Fri, 15 Jan 2021 17:25:48 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 198sm1085686lfn.51.2021.01.15.17.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:25:47 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        netdev@vger.kernel.org
Subject: [RFC net-next 0/7] net: dsa: Sync local bridge FDB addresses to hardware
Date:   Sat, 16 Jan 2021 02:25:08 +0100
Message-Id: <20210116012515.3152-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an extension of previous work done by Vladimir Oltean:
https://lore.kernel.org/netdev/20210106095136.224739-1-olteanv@gmail.com/

With this series, local addresses belonging to bridge ports or to the
bridge itself are also synced down to the hardware FDB. As a result
the hardware can avoid flooding return traffic to the CPU which is not
only inefficient but also very confusing to users:

https://lore.kernel.org/netdev/CAGwvh_MAQWuKuhu5VuYjibmyN-FRxCXXhrQBRm34GShZPSN6Aw@mail.gmail.com/
https://lore.kernel.org/netdev/6106e3d5-31fc-388e-d4ac-c84ac0746a72@prevas.dk/

Patch 1 through 3 extends the switchdev fdb notifications to include
the local flag, and to handle the case when an entry is added to the
bridge itself.

Patches 4 through 6 enables DSA to make use of those extensions.

Finally, enable assisted learning on the CPU port for mv88e6xxx.

Tobias Waldekranz (7):
  net: bridge: switchdev: Refactor br_switchdev_fdb_notify
  net: bridge: switchdev: Include local flag in FDB notifications
  net: bridge: switchdev: Send FDB notifications for host addresses
  net: dsa: Include local addresses in assisted CPU port learning
  net: dsa: Include bridge addresses in assisted CPU port learning
  net: dsa: Sync static FDB entries on foreign interfaces to hardware
  net: dsa: mv88e6xxx: Request assisted learning on CPU port

 drivers/net/dsa/mv88e6xxx/chip.c |  1 +
 include/net/switchdev.h          |  1 +
 net/bridge/br_fdb.c              |  4 +--
 net/bridge/br_private.h          |  7 +++--
 net/bridge/br_switchdev.c        | 47 ++++++++++----------------------
 net/dsa/slave.c                  | 26 ++++++++++++------
 6 files changed, 40 insertions(+), 46 deletions(-)

-- 
2.17.1

