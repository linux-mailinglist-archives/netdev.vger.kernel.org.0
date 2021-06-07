Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715E239DC03
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 14:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhFGMPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 08:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhFGMPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 08:15:55 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD569C061766
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 05:13:48 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id r16so2717352ljk.9
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 05:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=DMjTqjD1pePan0o9IugSGJk/X3ga2QYCfYQFfSpkOS8=;
        b=tJuL70o/OTYt3njlbYSZjRTOUBnpiHSo4jIMAwB4+z2W/iecfj4JxYbXBbcJI0RnTp
         EXIxfcxYy+5EIh/WsO442pVWiCG31FHgcxCFtw4NrmlnMW2R9HMt54l7mGJSBQEwI8tE
         SrTdLQP06zkyTFPOIIQnChRKe2sV9wNzkbT6SnOO4ZW5RjQ22j3f6bg95xlLgdiG5b3o
         IImR24xs7eSUnT7LPdz3SMz87cGSxQiNKCS2vh6vEMXMc1gSymG8qf4So9RZrndGyXEg
         mFjDoQ8NCCjvoYYCYU6rq1lu30xzEUeLmde/IVTC9Tj1/RHPky30CQzjJg3kStwTQ5xv
         1CQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=DMjTqjD1pePan0o9IugSGJk/X3ga2QYCfYQFfSpkOS8=;
        b=bC766cNqnJ96T2LbMmHZpilm1DT20/vmmDojZJ1y+bS3oer+vuiUNUaONponbmDdKM
         C/yRFcnmfbs1eLRKhtPcmgPy/IRxe2L8ZrVPtuscneC7BIgta8V8SbRCSfv4YCIeHKqv
         imP92h3ghaaplVEewLMfc4RtULl2fYhLem7bx0CS4l5fxDTziCcwiK/CzSCD1hkRA884
         zRZwVjxWd50DYWZOHpwOOEnh5hxHvmjkUA2J3ElK3G3rxVz/shopA8aA1Fv7kSWg30Ko
         9dHrdV5nJj1s7Jiy4dgDTMmx1f//7mMIch+MyQXim+YOeip+sNwSyNzSsCuJc7B3K6dJ
         8jrA==
X-Gm-Message-State: AOAM533gJUjKRMn/XUiYew0KfzWS7O3Sp68/MufdRatp3aB/wgWwLQ1I
        PgJh7cRG+YrAp3c96/xv+30/NuMRiuOsBxeS3g==
X-Google-Smtp-Source: ABdhPJx4wCuH+7bOycqkJrky8bv0TG2pC8V7TSz3TC1R7JQBnLyjyEp8Gf01yLSAWObrZrnELN9kKDy3fpxTiAiXKhQ=
X-Received: by 2002:a2e:a16e:: with SMTP id u14mr14113432ljl.343.1623068022005;
 Mon, 07 Jun 2021 05:13:42 -0700 (PDT)
MIME-Version: 1.0
From:   Johannes Pointner <h4nn35.work@gmail.com>
Date:   Mon, 7 Jun 2021 14:13:31 +0200
Message-ID: <CAHvQdo2yzJC89K74c_CZFjPydDQ5i22w36XPR5tKVv_W8a2vcg@mail.gmail.com>
Subject: net: phy: DP83822: not able to get a link
To:     dmurphy@ti.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I just updated a i.MX6 device which uses the DP83822 from 5.4 to 5.10
and can't get a link anymore.

ip addr shows:
1: lo: <LOOPBACK> mtu 65536 qdisc noop qlen 1000
   link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast qlen 1000
   link/ether 00:60:65:54:32:10 brd ff:ff:ff:ff:ff:ff

It seems to me that the commit 5dc39fd5ef35 ("net: phy: DP83822: Add
ability to advertise Fiber connection") causes this.
If I revert the following part of this commit, it is working again:
@@ -314,13 +451,85 @@ static int dp83822_phy_reset(struct phy_device *phydev)
 {
  int err;

- err = phy_write(phydev, MII_DP83822_RESET_CTRL, DP83822_HW_RESET);
+ err = phy_write(phydev, MII_DP83822_RESET_CTRL, DP83822_SW_RESET);

Was this change intentional? Because I took a look at the driver
DP83867 which has similar bits to reset the phy and there this wasn't
changed.
Maybe the naming of the defines in case of the DP83822 is a bit misleading?
DP83882:
#define DP83822_HW_RESET BIT(15)
#define DP83822_SW_RESET BIT(14)
datasheet description:
15 Software Reset
14 Digital Restart

DP83867:
#define DP83867_SW_RESET BIT(15)
#define DP83867_SW_RESTART BIT(14)
datasheet description:
15 SW_RESET
14 SW_RESTART

Thanks,
Hannes
