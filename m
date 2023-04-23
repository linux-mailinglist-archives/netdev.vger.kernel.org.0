Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F696EBC9B
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 05:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjDWDYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 23:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjDWDYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 23:24:40 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843FE1986
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 20:24:39 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id e9e14a558f8ab-329627dabfbso34191835ab.0
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 20:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682220279; x=1684812279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RA+QWLl4Jom/yJs8baGbkRm9xhOWQWeLoOTSkhafsuc=;
        b=kpFgmQWQAITuBQTLxGzOh+wG5/dkPnKZruqNS8BdQLSqozWVg4LCNjs4QaHaNtnfUf
         IHpOaHTlmbYBKwz6/5wRGn81yUhBYBN2gow+lsWYEox5Mgt5wNfi8Uww1tzjQ+FeknMv
         sVCFu2fcoMRnx8jJSSGq/6VwSSM0rfefv9st7YUZSsj33k/nq/nHBybWCJDzJYUWstsf
         tR8iypGdIXFp0OHtOH/pkGmpCB/YtxFzQLC7KpigLuVMulqDTq2NJwbY63Nd5M0gHdSz
         Yhqeo8cJNyw9tvt4TI6vOoLLWeATfID5F4PraQ8JPrrWc2U5iCRptCB6JjXxgxODKsC1
         LnOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682220279; x=1684812279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RA+QWLl4Jom/yJs8baGbkRm9xhOWQWeLoOTSkhafsuc=;
        b=kdhCABiP03/dXAAdjL3TRZNkMv8XzJlux6HkZJp7nwSSdn3wKT8rIBR8aVZVEbeIgN
         2v4hEaUojj4MayuPhdxT5iIWNjm7Sz8AyvM4c0tHwMFxu+kBxFwSdhnTbnRwlczbx91r
         MhijagMhlmCrugJXrmzwhmemdZGQy6EFUAf4nikZaqhLu7/IWAkvQn2TN9/bhhqekRCG
         tHe/L3CuINqQhfjOtW8bpuAowVM9MOp3fTt4+JPgbIS/DBi9w2WwIZHub3LPomO9jJgD
         8+GNIbkyZTclLGwZ1Q/Odz3ET971duxOJw1acKH9YSvxMPNGNJKHVtAlS1PDC1xM3qI4
         DpRw==
X-Gm-Message-State: AAQBX9cw3Forrqwnr/8/2zWbGOdzsHJNvPbVDlxUO0rpEexgrr21mpfC
        +6P+rbuAqnQziluVow3xvBw=
X-Google-Smtp-Source: AKy350arpw4qx/IG1od/kw4D7gy4qrWncwZZssVcWK/lYvjUE6RUJN8wFzw94uFrSK9ry1x5mcnKfw==
X-Received: by 2002:a05:6e02:1c48:b0:32c:b48a:9ae7 with SMTP id d8-20020a056e021c4800b0032cb48a9ae7mr3256930ilg.1.1682220278745;
        Sat, 22 Apr 2023 20:24:38 -0700 (PDT)
Received: from lenovot480s.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id e4-20020a022104000000b0040fa0f43777sm580630jaa.161.2023.04.22.20.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 20:24:38 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     glipus@gmail.com, kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: [RFC PATCH v4 0/5] New NDO methods ndo_hwtstamp_get/set
Date:   Sat, 22 Apr 2023 21:24:37 -0600
Message-Id: <20230423032437.285014-1-glipus@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

This stack of patches introduces a couple of new NDO methods,
ndo_hwtstamp_get and ndo_hwtstamp_set. These new methods can be
implemented by NIC drivers to allow setting and querying HW
timestamp settings. Drivers implementing these methods will
not need to handle SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs.
The new NDO methods will handle copying request parameters
between user address space and kernel space.

Maxim Georgiev (5):
  Add NDOs for hardware timestamp get/set
  Add ifreq pointer field to kernel_hwtstamp_config structure
  Add ndo_hwtstamp_get/set support to vlan/maxvlan code path
  Add ndo_hwtstamp_get/set support to bond driver
  Implement ndo_hwtstamp_get/set methods in netdevsim driver

 drivers/net/bonding/bond_main.c   | 106 +++++++++++++++++-----------
 drivers/net/macvlan.c             |  34 ++++-----
 drivers/net/netdevsim/ethtool.c   |  11 +++
 drivers/net/netdevsim/netdev.c    |  24 +++++++
 drivers/net/netdevsim/netdevsim.h |   1 +
 include/linux/net_tstamp.h        |  15 ++++
 include/linux/netdevice.h         |  22 ++++++
 net/8021q/vlan_dev.c              |  25 +++++--
 net/core/dev_ioctl.c              | 110 +++++++++++++++++++++++++++++-
 9 files changed, 279 insertions(+), 69 deletions(-)

-- 
2.39.2

