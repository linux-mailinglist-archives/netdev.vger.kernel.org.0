Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F572EBBE3
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 10:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbhAFJws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 04:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbhAFJws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 04:52:48 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4A6C061357;
        Wed,  6 Jan 2021 01:52:07 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id b73so3768693edf.13;
        Wed, 06 Jan 2021 01:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wFYVdNCGZo254Md4m2v48sFF9I2fZhhCJRCbYo96ynw=;
        b=r2hEt3YhyZtRbtTbKEgM7AOCqI7maZ7J138o7yqh2U812EyJXex68bYOO1VKErnc7a
         TyfLHIvKIAN4jpLN8ISxdbLNv5IGt6zkxgcqC8Zfj+O0TPMTrjyfeYatRMLY3rPQnPV9
         WHooaDbovRFSuCmtx1hbVe13OkZL+o8IkJwLi5v2X2etGgPp7z61ORFGyvkwknDoqaTy
         OZgvBQoXxLT2LhjIOllhwVtZBGj7ehBLwJ8dh0AJZzj2qqWbu/Aj5n6inx9EBArJQlW/
         EWDrGYPKnqKaayDO+8Ke/iXzt1PnKp22uvAd/uQlcBfKvO1YD7AYlqDdKMdg+UHGP8JK
         9zLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wFYVdNCGZo254Md4m2v48sFF9I2fZhhCJRCbYo96ynw=;
        b=bvl6A0f+Sqo/RSSuoaIrtedhrd2Z95W0csY6YaLCv7Bl+Z/VdNmHFSzIkpJgDZz/Uu
         Po8QZU0y/tAgdgNBv3/70NJn6dxg8Apgv7DKcG4zKmy5DU1j+tcFe8Wz6/azVQEI+vXA
         XkoTjH5YamE6/XYJ/WNMFLG/rVxPfH3ykqiVGijGQtBqygyefZu69X/w4LsHxA8lHS+L
         zHTq5CcyKWX2qw9DYwenhfSF87n/xD37N3F6LFdMnPXLCLWWNyGYvvABzCjE46WYSksX
         +wPf2KUMhdUzP98e6r2f4PCkf0rT+LlogoN2nBKOcIQF5zGHOPzvJXB+djYfZjtWirYC
         3R0w==
X-Gm-Message-State: AOAM530tXgh39+EiwmNLsKxJmowuhp3LO5PtE5IeuAo4U0m+P9pAWqXN
        h8+i8uJ3X2EHRvo5FA+KzwY=
X-Google-Smtp-Source: ABdhPJx6jQJEjUJu+pPJq4VL96D+e7Xlxkq7a+kpLfhHQq9snCSQsVZHsxrmUc2CD5wkfstxBayVaA==
X-Received: by 2002:a50:fb85:: with SMTP id e5mr3402235edq.153.1609926726098;
        Wed, 06 Jan 2021 01:52:06 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id n8sm1019587eju.33.2021.01.06.01.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 01:52:05 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 0/7] Offload software learnt bridge addresses to DSA
Date:   Wed,  6 Jan 2021 11:51:29 +0200
Message-Id: <20210106095136.224739-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series tries to make DSA behave a bit more sanely when bridged with
"foreign" (non-DSA) interfaces and source address learning is not
supported on the hardware CPU port (which would make things work more
seamlessly without software intervention). When a station A connected to
a DSA switch port needs to talk to another station B connected to a
non-DSA port through the Linux bridge, DSA must explicitly add a route
for station B towards its CPU port.

Initial RFC was posted here:
https://patchwork.ozlabs.org/project/netdev/cover/20201108131953.2462644-1-olteanv@gmail.com/

v2 was posted here:
https://patchwork.kernel.org/project/netdevbpf/cover/20201213024018.772586-1-vladimir.oltean@nxp.com/

v3 was posted here:
https://patchwork.kernel.org/project/netdevbpf/cover/20201213140710.1198050-1-vladimir.oltean@nxp.com/

This is a resend of the previous v3 with some added Reviewed-by tags.

Vladimir Oltean (7):
  net: bridge: notify switchdev of disappearance of old FDB entry upon
    migration
  net: dsa: be louder when a non-legacy FDB operation fails
  net: dsa: don't use switchdev_notifier_fdb_info in
    dsa_switchdev_event_work
  net: dsa: move switchdev event implementation under the same
    switch/case statement
  net: dsa: exit early in dsa_slave_switchdev_event if we can't program
    the FDB
  net: dsa: listen for SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign
    bridge neighbors
  net: dsa: ocelot: request DSA to fix up lack of address learning on
    CPU port

 drivers/net/dsa/ocelot/felix.c |   1 +
 include/net/dsa.h              |   5 +
 net/bridge/br_fdb.c            |   1 +
 net/dsa/dsa_priv.h             |  12 +++
 net/dsa/slave.c                | 174 +++++++++++++++++++++------------
 5 files changed, 130 insertions(+), 63 deletions(-)

-- 
2.25.1

