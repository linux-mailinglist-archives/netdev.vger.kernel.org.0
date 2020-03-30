Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDAC19858E
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 22:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbgC3Ukn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 16:40:43 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38207 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgC3Ukm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 16:40:42 -0400
Received: by mail-wr1-f66.google.com with SMTP id s1so23312869wrv.5
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 13:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xFkPu+Dik5qNV/a3s6CZjNNglt5r70lx8LUszE7tMTE=;
        b=gS2qSmrkE4BBFu4GF7FN3iJQB0RCz2iyYnLkHPBrcPFdYSD7byQ9mfR1PeX8x+6hc4
         k1jXO1mC4bdQIe1IrKAn2ECO87t8T0oafI3IA8g/1s2nMw1CdfJjNd2+Mx0MW+ipzWRk
         Jba6Kbqb/BfnCQjdgri2GWzjyY8dcTvmlBFFaqV0Zu06lqRsPVApLYIYRaeT0nTsuKpc
         xbD5BlnDej2zmqu3rgfHm+5gQVilKJNH81e6vx8OB/+o2TE/cFpI0qpQLXKdlM0I8UeL
         aeofejhl765JIsOBUOdWot0NnntQlSe1bg6FwE7E3BwEYTRrbw7Oz+EsBCPoCENVYpyI
         mChQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xFkPu+Dik5qNV/a3s6CZjNNglt5r70lx8LUszE7tMTE=;
        b=hEZiYG/LlGOiVePlwsBjn71uK3aZgcLQ4sI6Zons0KVoTol9uuQF5oUrQbOWwfREbl
         YHu7N4J6QMHBXUruYE+GjAndWRqpdn20vD9dEu2SLBZgZOnP87P0s3/wRu7pWJE9SOiS
         pufPTBTu1GlRMb6/tF6vK8xnPJC21670SxvnRVGfKEQS6SRumhLIzQ09wwf16jp2rEtV
         rheyJ4oISkOa0aHwyxrQ80bAvREbkGB2WsbAomYDOi/k8I8LCQIlFyMTrwCRJwQPB/2Q
         LPblc9/QHQ9M9a7pdWqa2jy0zuLOhmt2x+U81SBHgmVfblTPUGunHxUyiUyo2cdjmaTg
         Ii8Q==
X-Gm-Message-State: ANhLgQ2j52vqKCjmWmG5Wc/5CQ4WBhTCh3RcIB4Ib9wfL6Edk8ar8E3f
        TMpW24qlHx1az4+eL+2AC53E/Cnk
X-Google-Smtp-Source: ADFU+vt+RFOn55VUjpeuaUOmV5qbPxdlg2Css18/2TmiZlVhVtBHWP/TWruV2xzFP3kwdxYAtuyv9g==
X-Received: by 2002:adf:fe0f:: with SMTP id n15mr17892517wrr.204.1585600840362;
        Mon, 30 Mar 2020 13:40:40 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o16sm23371109wrs.44.2020.03.30.13.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 13:40:39 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next 0/9] net: dsa: b53 & bcm_sf2 updates for 7278
Date:   Mon, 30 Mar 2020 13:40:23 -0700
Message-Id: <20200330204032.26313-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Andrew, Vivien,

This patch series contains some updates to the b53 and bcm_sf2 drivers
specifically for the 7278 Ethernet switch.

The first patch is technically a bug fix so it should ideally be
backported to -stable, provided that Dan also agress with my resolution
on this.

Patches #2 through #4 are minor changes to the core b53 driver to
restore VLAN configuration upon system resumption as well as deny
specific bridge/VLAN operations on port 7 with the 7278 which is special
and does not support VLANs.

Patches #5 through #9 add support for matching VLAN TCI keys/masks to
the CFP code.

Florian Fainelli (9):
  net: dsa: bcm_sf2: Fix overflow checks
  net: dsa: b53: Restore VLAN entries upon (re)configuration
  net: dsa: b53: Prevent tagged VLAN on port 7 for 7278
  net: dsa: b53: Deny enslaving port 7 for 7278 into a bridge
  net: dsa: bcm_sf2: Disable learning for ASP port
  net: dsa: bcm_sf2: Check earlier for FLOW_EXT and FLOW_MAC_EXT
  net: dsa: bcm_sf2: Move writing of CFP_DATA(5) into slicing functions
  net: dsa: bcm_sf2: Add support for matching VLAN TCI
  net: dsa: bcm_sf2: Support specifying VLAN tag egress rule

 drivers/net/dsa/b53/b53_common.c |  29 +++++++
 drivers/net/dsa/bcm_sf2.c        |  10 ++-
 drivers/net/dsa/bcm_sf2_cfp.c    | 139 ++++++++++++++++++++++---------
 3 files changed, 136 insertions(+), 42 deletions(-)

-- 
2.17.1

