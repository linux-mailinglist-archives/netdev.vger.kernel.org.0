Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26614365FC9
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 20:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbhDTSx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 14:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbhDTSxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 14:53:53 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C653BC06138A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 11:53:21 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id c15so29818962wro.13
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 11:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=Yp3JrwQnttmZmyi912X2sJUn4tXEulH8Ua25YGbhlZk=;
        b=pLSWx0GYqnKfXRWvEdRMBTKAno4HHnjiVETJhTcd0q4GddFDoApPLPfdPe/znTbxGT
         bChMq2vMMkwlGFl0ckJoHQuKVancU10fSu5Gy5C3pEevLxz/VXkxNSVGP5u6SGwYpikT
         qLaiiWoEUWZxeV8aPl8bsTUFabHxkKJ0g07VcVSnef1MnZncZLrEZI/TjR706+kKLjpW
         Ak6og95DO3nja8DGp1PmBsqzYv+WscPf96Y4+g/1Q/UknhzBg9GFCc0B0shPJ9v8g5AN
         OBhvHfEcfgqrdL91OGxeEv7dOeo33majhGABcAq9rAIyI2mpxo1zzM7dXnc/zDGUKLTc
         mlmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=Yp3JrwQnttmZmyi912X2sJUn4tXEulH8Ua25YGbhlZk=;
        b=Y9AGpwaKdTV0kTIVibWbEj5P+AKngHrFp63cBFkyQnJVYtSh06XkAH4vZmGkbclPvm
         uaqIPezv+SnHCXIqSxTkU6C0OUYxu4Xun9pCbokWpyhLRpTR9wdV/g0WfKD9qJBDQdqI
         Y2wYgL6mX972ulukStUcoaxeAZjTQ6dgGwRH58HfQdtx++DGbcuTgbN8rje4p5DcHWvl
         +8vGpADTIzw9j1CjmGXwUeIGA6hYHSx+cJioDc7wb8yYKvUyFNA6k+T/UI8JO4xrTkrK
         6u1fNmCeJ/y5RIEy3fd2jj4q6Qm+pe+DAlqc0XrC7cGS8gAMAEZAXCuKaks7V8cRZRv9
         AO3Q==
X-Gm-Message-State: AOAM533pCZ7+a8JFDZiTni3m46+ozdhxFgqI6QLWrxLice7g4XNcY4p3
        9BI+HdMec2lezTXiHwCjjlnKoQ==
X-Google-Smtp-Source: ABdhPJzOv3jQhyEWrh8cYOgJuO9ljGFH9omRIK+Ld0ltTc+/qZHqEMri1zzoU9BsCiAO94l2XvAg0Q==
X-Received: by 2002:adf:f750:: with SMTP id z16mr22534815wrp.340.1618944800489;
        Tue, 20 Apr 2021 11:53:20 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id f7sm25897402wrp.48.2021.04.20.11.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 11:53:19 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v3 net-next 0/5] net: dsa: Allow default tag protocol to be overridden from DT
Date:   Tue, 20 Apr 2021 20:53:06 +0200
Message-Id: <20210420185311.899183-1-tobias@waldekranz.com>
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

v2 -> v3:
  - Rename "dsa,tag-protocol" -> "dsa-tag-protocol". (Rob)
  - Some cleanups to 4/5. (Vladimir)
  - Add a comment detailing how tree/driver agreement on the tag
    protocol is enforced. (Vladimir).

Tobias Waldekranz (5):
  net: dsa: mv88e6xxx: Mark chips with undocumented EDSA tag support
  net: dsa: mv88e6xxx: Allow dynamic reconfiguration of tag protocol
  net: dsa: Only notify CPU ports of changes to the tag protocol
  net: dsa: Allow default tag protocol to be overridden from DT
  dt-bindings: net: dsa: Document dsa-tag-protocol property

 .../devicetree/bindings/net/dsa/dsa.yaml      |   9 ++
 drivers/net/dsa/mv88e6xxx/chip.c              |  99 +++++++++++------
 drivers/net/dsa/mv88e6xxx/chip.h              |  21 +++-
 include/net/dsa.h                             |   5 +
 net/dsa/dsa2.c                                | 103 +++++++++++++++---
 net/dsa/switch.c                              |  25 ++---
 6 files changed, 192 insertions(+), 70 deletions(-)

-- 
2.25.1

