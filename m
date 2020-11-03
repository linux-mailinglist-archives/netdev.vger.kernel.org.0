Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4F02A3D2C
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgKCHKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCHKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:10:07 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FA0C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 23:10:07 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 72so6691740pfv.7
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 23:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CowDR4jzGOBVCdoTKX3aHpWEV4frAcW7T2hSPdQ2uqQ=;
        b=C+p02lgNrjs1ladMNwEDN4D0hvlwXFiDeuHuEVM77P98g3tpmNJA1LfobccGCPVFPT
         euMZJLVNbCX0WP5ORUByQKufrz1DQZZ6XW4ycggOOR7a6ZGrW6pYhJdgG/8pWJqM4sGl
         yqv7AEDmNc8/vIqJdLsqFAPQRFwha75R7DHARSpSdHxNhEb6/GnWgLrcu1apbrZAL6XM
         3krm9jS/oYqpXZUmvYP4W544O71ktlKCdV43MDizJyJT+gBLEQ7enZjAaaqFJgFt6kJ4
         UgfBPzBkHgOmDh13mcoyTjhkhLopl+sI+pxfVTnyt6LOTQivLEeLBRbSAR2WUKQJSnCD
         5T6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CowDR4jzGOBVCdoTKX3aHpWEV4frAcW7T2hSPdQ2uqQ=;
        b=OruWqPPUzVb7SazJiUc8YICmKE0uLMAaa0oi0xLj/V6bTPIGj4d2WCoWlRDTM6ChSE
         YqECoS6trjkv54Jo7j0IW86Q4wZDANhPXYuvwPBQ46UHfJFaXiLCD4VyBrV2QLTzghp7
         u1+BO64xcSjtVJ3u9GA2XlgCYj9l6WVrmMnld6S/CUb/yYHj9I0oo6V9PO8teikW9wYf
         DIkRJm6vEhZdd1L18kslqVLM+ukoBerOGdtH/HaHm6yIhkxO0YkELzWT59Dnt5yyeAx2
         FZu9RwS1SW4T0+frs0Z7diGHUpiUj0eESSulLYFEYeFBcNrGm+E0TF1IVBzEt1OT0oy1
         uodA==
X-Gm-Message-State: AOAM531aLV1bz9EwyllJ+6b35Hvomo6ZL7n9b9VX2JiGyNp+iyS0PFOe
        cx604+uK3GEF6LT9DIWoqKY=
X-Google-Smtp-Source: ABdhPJzKjUUY5PaVayeW17kXRuvhS5orDlrvPprzNpc5a8UNw1KF5EY89GxHHGrgWoPTObfVr51/mA==
X-Received: by 2002:aa7:9e03:0:b029:164:427a:8f94 with SMTP id y3-20020aa79e030000b0290164427a8f94mr23941848pfq.5.1604387406847;
        Mon, 02 Nov 2020 23:10:06 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.192])
        by smtp.gmail.com with ESMTPSA id 92sm2020074pjv.32.2020.11.02.23.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 23:10:06 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>
Subject: [net-next V3 0/8] net: convert tasklets to use new tasklet_setup API
Date:   Tue,  3 Nov 2020 12:39:39 +0530
Message-Id: <20201103070947.577831-1-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

ommit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
introduced a new tasklet initialization API. This series converts
all the net/* drivers to use the new tasklet_setup() API

The following series is based on net-next (9faebeb2d)

v2:
  get rid of QDISC_ALIGN() 
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
 net/sched/sch_atm.c        |  8 ++++----
 net/smc/smc_cdc.c          |  6 +++---
 net/smc/smc_wr.c           | 14 ++++++--------
 net/xfrm/xfrm_input.c      |  7 +++----
 12 files changed, 47 insertions(+), 58 deletions(-)

-- 
2.25.1

