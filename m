Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934CB4885EF
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 21:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbiAHUqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 15:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiAHUqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 15:46:53 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811E1C06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 12:46:53 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id x15so8677383plg.1
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 12:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lH09cYRpYLeiBoy4IYLHPmVdtNDtfAEpltHf9P99Uho=;
        b=Rbfc+VAR1aSRTJoE+M0uqtHtlcbS8Eg8ksCtbNMovCSGSP46KycgPmF2CUVHLOmWjI
         ZtIyTRrSp1gMJAJojpy+uZgdmV+SW87+9bNQOEhxWZSSH+36oQP/EA+qxYOtRHq5J88W
         5TnCV4E2SHjFiYEFdFzzVv9v+0/FhEcjyMlzuDO7tas6Xo0UEMAEaU+E21ioh5sBanaz
         2ZHxN7ra3wTlPD3gcXcC3TOZllPGOTfyofqo1r8+8siAHMglbxNJ+Z8/Y5ExM1oW4tiZ
         9FNqLUNBo+OE7YgeGcJoE6iS44ObZv+8zXGRK+pWOlJsdlqeGwO4nsG7i7QulRmjj3QS
         2uoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lH09cYRpYLeiBoy4IYLHPmVdtNDtfAEpltHf9P99Uho=;
        b=OftHiRZda5BcnsoHiYjKvA/4Ug5s0gyYgJeXGDfvEHSoZ1EkUPgtbwpgZEsLGBb0LR
         cw2w2zYanT7ensxix7weX/e+vayKJPgE6v5DDdYEdnJtgRqZZhgQ2KssjxlMcUAqfRlv
         RIRf/NrnxkFGyLJgkpN9oEo1vZbKJGoJoGwMy+bVrM5tMC7kXfppYyNN3/ylDa1rmBCA
         9LBxFT4EkZ/aodgUXSTjs/UCKvx9I+RMEr2DcMPnxewN1NGv2hrfyeQ80+RhfTBoRfzF
         wKoCCEsHfDQbCZ883L37r59lWsWsU4e6wNFbxRbhw+H6D+VGpHcBmnGyhTOwNaikDrgs
         7iKQ==
X-Gm-Message-State: AOAM5305IOQ6mBzGCmhu2cMxp53Mn9+Bw/iJQI1j/TP0QKlhvufKsLLI
        kpsfypeGL3HHRfuPzi0YeBX1zFoTPwsDag==
X-Google-Smtp-Source: ABdhPJwS2GnxJcsh/1zNQ3uM1GDOTHy0J86tjJ1rZJvsrgUYftbSGt4L0tJDfNcSbAFp3x1VQoF9eA==
X-Received: by 2002:a17:90b:14e:: with SMTP id em14mr20198494pjb.12.1641674812484;
        Sat, 08 Jan 2022 12:46:52 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u71sm2129393pgd.68.2022.01.08.12.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 12:46:52 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>
Subject: [PATCH iproute2-next 00/11] Clang warning fixes
Date:   Sat,  8 Jan 2022 12:46:39 -0800
Message-Id: <20220108204650.36185-1-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Building iproute2-next generates a lot of warnings and
finds a few bugs.  This patchset resolves many of these
warnings but some areas (BPF, RDMA, DCB) need more work.

Stephen Hemminger (11):
  tc: add format attribute to tc_print_rate
  utils: add format attribute
  netem: fix clang warnings
  m_vlan: fix formatting of push ethernet src mac
  flower: fix clang warnings
  nexthop: fix clang warning about timer check
  tc_util: fix clang warning in print_masked_type
  ipl2tp: fix clang warning
  can: fix clang warning
  tipc: fix clang warning about empty format string
  tunnel: fix clang warning

 include/utils.h |  4 +++-
 ip/ipl2tp.c     |  5 ++--
 ip/iplink_can.c |  5 ++--
 ip/ipnexthop.c  | 10 ++++----
 ip/tunnel.c     |  6 ++---
 tc/f_flower.c   | 62 +++++++++++++++++++++++--------------------------
 tc/m_vlan.c     |  4 ++--
 tc/q_netem.c    | 33 +++++++++++++++-----------
 tc/tc_util.c    | 21 +++++++----------
 tipc/link.c     |  2 +-
 10 files changed, 77 insertions(+), 75 deletions(-)

-- 
2.30.2

