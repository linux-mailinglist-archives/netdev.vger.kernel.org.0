Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF8B178BEE
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 08:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgCDHui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 02:50:38 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36267 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728539AbgCDHui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 02:50:38 -0500
Received: by mail-pf1-f193.google.com with SMTP id i13so550964pfe.3
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 23:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FE0Ixc8KNXtxV3AJi0NrIhjLcJ5PN1SKiqUXieUAH+k=;
        b=mAoQjiAj2xMs70WpzaXbeW7LLMm+P5vfAu06ipyVx4dCmIXXlseknx/XeAscunbmJF
         I0n4ZhZrecLymQdl4wBxDgTRc0t73+vuSltAltkiOVXnZTNKN6B0y7pt98P3RfNkTEcR
         HrHBqv1nQ8FmEpSubeGlIuEngyYfx2OLuEK8emCYDuFjHrX9hXlr/i60j2MtM3f6hwuN
         PeFi3qezrzyiD9qkI2pBTjZP20uh2DALV8iSMu69P6LJiWjC3RNr5+QTaDMTZJB2/mQT
         Jzv/9D4CNyWKjw82QpjhSTTbBn2lTdDNuFHsXGpwEUv81/CvvtnMHPxFkBZ7vLMdxZ91
         tZ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FE0Ixc8KNXtxV3AJi0NrIhjLcJ5PN1SKiqUXieUAH+k=;
        b=h+trDGYqnbVIwRF9+g96UyJ2CO0hAKfWcPlC1XKeepCSvuAdC7nxH/qm0alrd/Q7uR
         rI7ikYdF3sZatkGRmoNloS+wwCl437BldvxVlaz2EL9BNBODbY6CaYzQXQ7pA8aTNpLf
         L57sC6vhytbVpV+eZzOsTz3zbNEn5TxEkLVD6CiModpF0YF156j2xCdSrtxsXNcYGDYA
         S0eLqzvvntkGKtfgAaCilj+J4REyFgv8jeUwjFp4GV+R8Z8eopSTd4rvKrnP79xp+TIm
         a2UKiKwyuhF5iOLalSTmRG0VJLQNqhG9T79bCG0/EgEzP5X63QQG2P0fkYg+PueId5HS
         jYZw==
X-Gm-Message-State: ANhLgQ2zPajOF3gPugT3w6SUK1FpNckD/nIqwqxehXi3i/cTTE3UKI9O
        BM0nKNlcCLIxs2DNF3n0SVc=
X-Google-Smtp-Source: ADFU+vvDbrIhygitp2q/hctYYN9le2unR2/Wq+DCnkXR7KIUxrzAV81nrf8MRJ8QBgq7Ek7AATAjqQ==
X-Received: by 2002:a63:24c6:: with SMTP id k189mr1419934pgk.436.1583308235962;
        Tue, 03 Mar 2020 23:50:35 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id c18sm26404055pgw.17.2020.03.03.23.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 23:50:34 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 0/3] net: rmnet: several code cleanup for rmnet module
Date:   Wed,  4 Mar 2020 07:50:26 +0000
Message-Id: <20200304075026.23184-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to cleanup rmnet module code.

1. The first patch is to add module alias
rmnet module can not be loaded automatically because there is no
alias name.

2. The second patch is to add extack error message code.
When rmnet netlink command fails, it doesn't print any error message.
So, users couldn't know the exact reason.
In order to tell the exact reason to the user, the extack error message
is used in this patch.

3. The third patch is to use GFP_KERNEL instead of GFP_ATOMIC.
In the sleepable context, GFP_KERNEL can be used.
So, in this patch, GFP_KERNEL is used instead of GFP_ATOMIC.

Taehee Yoo (3):
  net: rmnet: add missing module alias
  net: rmnet: print error message when command fails
  net: rmnet: use GFP_KERNEL instead of GFP_ATOMIC

 .../ethernet/qualcomm/rmnet/rmnet_config.c    | 36 ++++++++++++-------
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   | 11 +++---
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |  3 +-
 3 files changed, 32 insertions(+), 18 deletions(-)

-- 
2.17.1

