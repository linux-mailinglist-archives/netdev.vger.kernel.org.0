Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4645828460E
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgJFGcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgJFGcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:32:13 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB3EC0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:32:13 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id g10so5184358pfc.8
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kGjGBafNoGOY6eDR1x9jqFwwiBuEnKGcLreZdxEqbiM=;
        b=u+B30qCS/DM3XA5ngzQuXlilOzBVaveyC3opuHcGWH0by7I8W1x3rIBRjD6g4GYRDq
         Qi8C+xkNj/jZi/F/GIKt5IItloFcUmpSwp+7rKckNHtm0MT9lJyzBV/peJh99mL4kKHL
         PAkAV3bluwQ8SkcacmYrelduaehQpEyWm6kiQn/JnDRzxH4Z3d34n9rocVrVCQrEwOX9
         uqJ7wJCahEOXoKc5AB9EgaQcYvOIPyEQAa7v+/ytg0aoGrI2pITF9uVdAJS36SIf+2X2
         BqEg/fhY2DHII7NDmW8uz8YbbcR9G4BZ1dC5AFuYJojH/dFAVEygpxZC/tSpzdgGEyB1
         vK2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kGjGBafNoGOY6eDR1x9jqFwwiBuEnKGcLreZdxEqbiM=;
        b=X7HHkKCfi0kK70AULm8IFQvaNfs9g9LLw2WDkbcEqGm7vCdYqUdxZF0Jl7QKWLp1DZ
         27VNh2ybaMvChTgVN3Ays2PjIDK3sOKL7iXeKIY3sOSznIP2J192ptTsE7cJcR5+UGG3
         PUzYHvN6+bTMK7nV/q4NGi0eVBLqL+gZdGy7pSthVbuvrpBdDlcN7PGQOKzYY42O99Gf
         FvSoo+CgLTnOVntUi8ZdQDKKtklPNASpVCt0fLtVJum7Aoqdod8N7XSKXuCmkNbh48gx
         /0zJQD6WmpkAynFL/jR8mvpEeMzy52Wx70w2WoK9vabj8izU8HhmEhTIJLY2+g26Mfiz
         GZsw==
X-Gm-Message-State: AOAM532Pb9fm9vCVxhZNn/3f2V+/tEe0dLkWJxy+EdVds0/8ypyBEqu1
        3E158+sF+U452jDUk9yc62A=
X-Google-Smtp-Source: ABdhPJzSaWqPhCu/ShHRxhYz3SDbMo+ZMmHhmwiEQiNRhCTVh8qlATUXOKbITNNmV170ljB1BW4QFw==
X-Received: by 2002:a65:4c8a:: with SMTP id m10mr2624045pgt.403.1601965933173;
        Mon, 05 Oct 2020 23:32:13 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id 124sm2047361pfd.132.2020.10.05.23.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:32:12 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>
Subject: [RESEND net-next 0/8] net: convert tasklets to use new
Date:   Tue,  6 Oct 2020 12:01:53 +0530
Message-Id: <20201006063201.294959-1-allen.lkml@gmail.com>
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

The following series is based on net-next.git(8b0308fe3)


Allen Pais (8):
  net: dccp: convert tasklets to use new tasklet_setup() API
  net: ipv4: convert tasklets to use new tasklet_setup() API
  net: mac80211: convert tasklets to use new tasklet_setup() API
  net: mac802154: convert tasklets to use new tasklet_setup() API
  net: rds: convert tasklets to use new tasklet_setup() API
  net: sched: convert tasklets to use new tasklet_setup() API
  net: smc: convert tasklets to use new tasklet_setup() API
  net: xfrm: convert tasklets to use new tasklet_setup() API

 net/dccp/timer.c           | 10 +++++-----
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
 12 files changed, 47 insertions(+), 57 deletions(-)

-- 
2.25.1

