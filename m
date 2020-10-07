Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97BF285C99
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgJGKMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbgJGKMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:12:34 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297C4C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 03:12:34 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id bb1so767911plb.2
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 03:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XJqtU+qSTs9Z6nT0yW60YoHpdGiXKLBzWgmdn/Juk24=;
        b=ezNQm3H3MCV8A6tafhprk3ckyJK8Y6IvMfWLo+vo5/JBoU319EJSeTY4QpLj3QZzbK
         deHLN8wYMRM1boDbNuNrBIv8zT2h5U9yLM1IlU9vkiyKdwlu0aIChrg8vUNmodDYYlxc
         OlGp5w2QmfXrcbDXR2sCjID0Fz9pMVmU47Lwapw25RSZ+onyjdvo17dmKyQbne5cHGDw
         G97NeltJUXWuyXKDSf3ksM2UXKX5MRbFPDndTJYRcWEjG6bj7YanQl1apwoSVxBpILVs
         rPNAc+RmFdFDg7D6qFikmnxigOit7nG66hYVOAYVw/JZj/X4PIxVQAJtSwKCOe0BMiJa
         NS0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XJqtU+qSTs9Z6nT0yW60YoHpdGiXKLBzWgmdn/Juk24=;
        b=YWNJkR82fUe1lX67rna6xsMiWcdHK/i0TivRZ7mcLdPitPYjvAbbuc948frALwIrEF
         5GNNq+B6tUlev1vs8UvUPupfdzXcBb6C41PKJB+mSs5nahyrdF/2M8NIVHbCqkXm5Y/u
         RONPwYc0Vokn4TKrT7feBdcxfJYNHzkiTGT8zltClqAK8azrNkk986G+AfdMK/3q8i8Y
         9u3V6B10YzoCw9ufvQwYIzbGDGzoxMa3wpFtq3scjwXGm8WRf6vO9ph7ficd27gKqq+a
         h0+m1XWX8oHtoxUg2jvYEvYDOK1lCCXtpfC0kU+lV6m3Bf/tLKsMBuNmwwNEXE/PavuF
         ur+Q==
X-Gm-Message-State: AOAM530DZp1F9y67C6ogBmjsMbBut0faw112xn7VjWb3uBKEDR9BdFmH
        6Ut3a5gTWuR11DUSjAT/yLk=
X-Google-Smtp-Source: ABdhPJyNTNVma6GtHLzpoB7zvMqbbLDZXATXw5CUAiCQkSGlVhEXjPRNVCcn4Go+aTxGINuKoiBfeA==
X-Received: by 2002:a17:902:7e82:b029:d3:f3b5:d99a with SMTP id z2-20020a1709027e82b02900d3f3b5d99amr1351856pla.7.1602065553694;
        Wed, 07 Oct 2020 03:12:33 -0700 (PDT)
Received: from localhost.localdomain ([49.207.204.22])
        by smtp.gmail.com with ESMTPSA id q24sm1105291pgb.12.2020.10.07.03.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 03:12:33 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>
Subject: [net-next v2 0/8] net: convert tasklets to use new
Date:   Wed,  7 Oct 2020 15:42:11 +0530
Message-Id: <20201007101219.356499-1-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
introduced a new tasklet initialization API. This series converts
all the net/* drivers to use the new tasklet_setup() API

The following series is based on net-next (9faebeb2d)

v1:
  fix kerneldoc

Allen Pais (8):
  net: dccp: convert tasklets to use new tasklet_setup() API
  net: ipv4: convert tasklets to use new tasklet_setup() API
  net: mac80211: convert tasklets to use new tasklet_setup() API
  net: mac802154: convert tasklets to use new tasklet_setup() API
  net: rds: convert tasklets to use new tasklet_setup() API
  net: sched: convert tasklets to use new tasklet_setup() API
  net: smc: convert tasklets to use new tasklet_setup() API
  net: xfrm: convert tasklets to use new tasklet_setup() API

 net/dccp/timer.c           | 12 ++++++------
 net/ipv4/tcp_output.c      |  8 +++-----
 net/mac80211/ieee80211_i.h |  4 ++--
 net/mac80211/main.c        | 14 +++++---------
 net/mac80211/tx.c          |  5 +++--
 net/mac80211/util.c        |  5 +++--
 net/mac802154/main.c       |  8 +++-----
 net/rds/ib_cm.c            | 14 ++++++--------
 net/sched/sch_atm.c        |  9 +++++----
 net/smc/smc_cdc.c          |  6 +++---
 net/smc/smc_wr.c           | 14 ++++++--------
 net/xfrm/xfrm_input.c      |  7 +++----
 12 files changed, 48 insertions(+), 58 deletions(-)

-- 
2.25.1

