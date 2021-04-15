Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47E5360597
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhDOJ06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbhDOJ04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 05:26:56 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C08BC061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 02:26:32 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id f41so14763330lfv.8
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 02:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=uGnyIlNR+gHTNp/zACEMhB8cDITd6OLFs9XvWKNmoJY=;
        b=nyyYb0WTLMxTLKVT5ZPvU+Z3GFViYA3rn9Awxtt3MWpwNo245XYNNE5j4EYbFlFKg3
         /Xfa7rglL9L6p7QSmdN10mImiYKPDXIoAZTlnHy3XzgubgHbW8c3HKf7cjit2A2tPhpN
         8y2fPh2ZHI57kh5cBIyn5sp36j2YLU0KMdvpc5jze9KlNS2KGezj8ndQGsFMD2kH4ekk
         r8Ck3OBxqEiFjDkxgENo7P8xVhtrhy5RIVtpCoTN7WAfxQ/Guj10ZaXhqWQWxqlTefXW
         JEwT2vBius9I0tUFYUWap1yFKcjJsnYMhLja8XKAjPXHvTo/bx8QCmOPU09xQVG7Bz9A
         p+hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=uGnyIlNR+gHTNp/zACEMhB8cDITd6OLFs9XvWKNmoJY=;
        b=Nji5ZkpdHjRW7leAC4IJkeqgY8VbCQazyhUUR/gnBMveyIjzPYYY+o7aCa7TBdYzhg
         g20sEMzYom/2C6BRiXt9ZjYSK2qR0hp+7ndz+aDpjM5n84PorrGSYDn+A7gET6dxlsNz
         ujLuxMIavzptMCQOQWQeBYhoRfBQK5gpQNPIh6XiAJ230fbLdrxdtw6ZFz1trlohDWRq
         CdlhcSOzTR6eg48sfJhpaP2l5Bb9XFOEYw3CJrJWnT5h4sAjeYjBhUYjvjdpkv9dVf2p
         YfAUtuAMn3S0uy3eMd91b5DPsA6/+LUZz+P0k+togMM9F/e7/NOllThZyIkABZ3AwAfq
         lfqg==
X-Gm-Message-State: AOAM532UP8yWfmzsF9MXOVgL2Q508a4q03HHWMPmbRnHwWuh2HSfXwV/
        Br9OrkfTZJ6V1+ldGsdgyPzm4g==
X-Google-Smtp-Source: ABdhPJyOhajoZHsVfs/vGT0SJw1XGh9C/d5QPwPZ4BDjq6PvSir5ojd3FbETIiQSfny2GLa9xQGkPQ==
X-Received: by 2002:a05:6512:2019:: with SMTP id a25mr1881809lfb.347.1618478790564;
        Thu, 15 Apr 2021 02:26:30 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g4sm595557lfc.102.2021.04.15.02.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 02:26:30 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 net-next 0/5] net: dsa: Allow default tag protocol to be overridden from DT
Date:   Thu, 15 Apr 2021 11:26:05 +0200
Message-Id: <20210415092610.953134-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a continuation of the work started in this patch:
https://lore.kernel.org/netdev/20210323102326.3677940-1-tobias@waldekranz.com/

In addition to the mv88e6xxx support to dynamically change the
protocol, it is now possible to override the protocol from the device
tree. This means that when a board vendor finds an incompatibility,
they can specify a working protocol in the DT, and users will not have
to worry about it.

Some background information:

In a system using an NXP T1023 SoC connected to a 6390X switch, we
noticed that TO_CPU frames where not reaching the CPU. This only
happened on hardware port 8. Looking at the DSA master interface
(dpaa-ethernet) we could see that an Rx error counter was bumped at
the same rate. The logs indicated a parser error.

It just so happens that a TO_CPU coming in on device 0, port 8, will
result in the first two bytes of the DSA tag being one of:

00 40
00 44
00 46

My guess was that since these values looked like 802.3 length fields,
the controller's parser would signal an error if the frame length did
not match what was in the header.

This was later confirmed using two different workarounds provided by
Vladimir. Unfortunately these either bypass or ignore the hardware
parser and thus robs working combinations of the ability to do RSS and
other nifty things. It was therefore decided to go with the option of
a DT override.

v1 -> v2:
  - Fail if the device does not support changing protocols instead of
    falling back to the default. (Andrew)
  - Only call change_tag_protocol on CPU ports. (Andrew/Vladimir)
  - Only allow changing the protocol on chips that have at least
    "undocumented" level of support for EDSA. (Andrew).
  - List the supported protocols in the binding documentation. I opted
    for only listing the protocols that I have tested. As more people
    test their drivers, they can add them. (Rob)

  I did not change the property name, as I am not sure which vendor
  prefix to use (if any). Since there is an existing "dsa,member"
  property, "dsa" seemed reasonable.

Tobias Waldekranz (5):
  net: dsa: mv88e6xxx: Mark chips with undocumented EDSA tag support
  net: dsa: mv88e6xxx: Allow dynamic reconfiguration of tag protocol
  net: dsa: Only notify CPU ports of changes to the tag protocol
  net: dsa: Allow default tag protocol to be overridden from DT
  dt-bindings: net: dsa: Document dsa,tag-protocol property

 .../devicetree/bindings/net/dsa/dsa.yaml      |  9 ++
 drivers/net/dsa/mv88e6xxx/chip.c              | 99 ++++++++++++-------
 drivers/net/dsa/mv88e6xxx/chip.h              | 21 +++-
 include/net/dsa.h                             |  5 +
 net/dsa/dsa2.c                                | 95 ++++++++++++++----
 net/dsa/switch.c                              | 25 ++---
 6 files changed, 184 insertions(+), 70 deletions(-)

-- 
2.25.1

