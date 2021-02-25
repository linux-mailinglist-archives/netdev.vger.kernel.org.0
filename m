Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D92324FCA
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 13:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhBYMTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 07:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhBYMTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 07:19:36 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05750C061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:18:56 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id s8so6590536edd.5
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m15kHRSRXSoSDtXUA3Ckkig5uqmave4WqpJGhJNiDbc=;
        b=M+cBxXTEVssYHEF0RPwVlomLacp6f/gQsqczCjJGK7Jy4k9kr0b3Xs6Iu+43V+cla3
         XhqTRUopSJEfRBcgG9Su489r1ts4Odond4ufgc/D/8tZ3deb0WlQ4HQ9XxGDJ+WAhBht
         Zz3qWrcG9MsBuHX/m7v274NssAWWE13Qoqs+Rg5ho5BR4d8ymzVUsgxq+8TUPkSXBA5u
         Nsvv3cLOYy9wCxr/5QkhrX0/bWcssCZMjrk9d6sec1kLnhwGELOyoPq18s6S34HVMIPn
         tXZbqQxIoI1CjcOymK4+lYFiAJmRBhybkwkwFgJx6RgM3eM5tJADPaT2+Mxl0MnFscFB
         hMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m15kHRSRXSoSDtXUA3Ckkig5uqmave4WqpJGhJNiDbc=;
        b=m/fQy18hd97LORzOuJHUps14RR5T2zf2CzZY/5wZLOpR9JPs5Ot4/0Jd87f9Gc4u8p
         GQJZwv8NJOePMPpQMsGhlXPQ7naaJcFt8yh5//SrJNs5HZGMG98Ge6UwUshlFeOfRWAy
         Fh6u0DDYxI75CsX4a2O9Yd4dvagXkhOorP2ptHM/xlj0NN7BQ2b3jYYmb7PG3FNe3NfM
         bIQmZYgnZYUd4rqGphM0oDErSEgckIYTdLeLzXiqilh8JHMKnGrRurc0OPgHBbjnoy2L
         dM8NfZenTqrK2UqaLggGNGvR0vbpJH9IxI1FwB7v7TtFfOGrOSH0zrR0HEa4m2Q2zrkD
         87Gg==
X-Gm-Message-State: AOAM533D1h6ZZtJ1v3HpBnJt29Tr5I19vVm8wUi4H5fy87dcgAxVn3II
        4U0NPo9/uKUaEBLLYC/jDBC+nzcUMys=
X-Google-Smtp-Source: ABdhPJwxDlvp+FybbVZ2laqhlXvK6qgcQwT8TUkBMjjdprcPpemC7nFadTn3AXtxsl505i5vyYgk5Q==
X-Received: by 2002:aa7:dd0d:: with SMTP id i13mr2481047edv.132.1614255534790;
        Thu, 25 Feb 2021 04:18:54 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id x25sm3420925edv.65.2021.02.25.04.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 04:18:54 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net 0/6] Fixes for NXP ENETC driver
Date:   Thu, 25 Feb 2021 14:18:29 +0200
Message-Id: <20210225121835.3864036-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This contains an assorted set of fixes collected over the past week on
the enetc driver. Some are related to VLAN processing, some to physical
link settings, some are fixups of previous hardware workarounds.

Vladimir Oltean (6):
  net: enetc: don't overwrite the RSS indirection table when
    initializing
  net: enetc: initialize RFS/RSS memories for unused ports too
  net: enetc: take the MDIO lock only once per NAPI poll cycle
  net: enetc: fix incorrect TPID when receiving 802.1ad tagged packets
  net: enetc: don't disable VLAN filtering in IFF_PROMISC mode
  net: enetc: force the RGMII speed and duplex instead of operating in
    inband mode

 drivers/net/ethernet/freescale/enetc/enetc.c  | 130 +++++-------------
 drivers/net/ethernet/freescale/enetc/enetc.h  |   5 +
 .../net/ethernet/freescale/enetc/enetc_cbdr.c |  54 ++++++++
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  18 ++-
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 103 +++++++++++---
 .../net/ethernet/freescale/enetc/enetc_vf.c   |   7 +
 6 files changed, 203 insertions(+), 114 deletions(-)

-- 
2.25.1

