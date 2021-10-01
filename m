Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A01241F453
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 20:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355652AbhJASIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 14:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhJASIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 14:08:22 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392EBC061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 11:06:38 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id s16so8681818pfk.0
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 11:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=NITV41AcBpN0TKA8bdy6sYT4y3Y+qbyYTsbMzsCw188=;
        b=FSYYOH1cPPSqF2VTC0EcWewOtNO3FK6SBe4k+Cv925PuItMzDeFwZZtLOaWTmR/qAU
         9mnCtMuEcXEWQwjfCHUvrk5V6DsMBhZkv+Qp3iwMfkxJdxBUptqOLiX8HINf4/IhJetD
         yrA8DG19kkyBRqE5AA1wFujSQcuMHtBNLKv+r/ZcO0qSMSZWZbeXADXdETCO46ye3iSg
         u7UETcfFJdgIkHK3Sh26g+0Ui1qSgnw1m7ewiVvh7qnaCeege9dET0mqsdzhWsC/V0Jl
         +6ncbNpwaJH6+g3qa5vSqzFpihl1XxVTUv+0V7tdwFMpxWJG4epMR1yVdJqWFLocZnAy
         A+xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NITV41AcBpN0TKA8bdy6sYT4y3Y+qbyYTsbMzsCw188=;
        b=q9IYn+Pzm9Zy2qjlILbM3Hu7DwDorcqvjOCY/oSQw32vMPUKqGTr4VB/+kuVY2Q0FF
         qBI/9TYqAy6VPsCbTl+f/Qz8NYZj1YHej14ulQIeqKoWYLfETiuSGwta6jQcEjVCDhgs
         wRaVf+b9u5SnCf76OoyZAJqj+Z7ssPBHCxP+zorc7FbMwG1OQafFgWnWXtTnPqkp8166
         8xIJVYISPDDmPZr0zODrr/FxKYdZH28xOeeJ7ld/5kk6RErDLOejsPIuqgnto5Y53ONV
         fgPlybIdL40e0nknGJd1KKOfrVog1Tn6EWKSCYcPNvswYTYE5UUWPQMjXfWwvOM8XVBV
         WvHQ==
X-Gm-Message-State: AOAM532TIlXq/zpNNHvRbifmjhOGV3UrSHh7w5EUmQ1P0M8qegBA0qVe
        iZnKPDyfRt/zYHm+DvGZ8nBOog==
X-Google-Smtp-Source: ABdhPJyXmyd/Pr4nWuKoVZCQNEmm65A1TgUcQeNb27nYfOiIXPJqC7HHa6XLlnb/3PG/4/uBNSp+XQ==
X-Received: by 2002:a62:5803:0:b0:447:d62d:161a with SMTP id m3-20020a625803000000b00447d62d161amr12587319pfb.85.1633111597672;
        Fri, 01 Oct 2021 11:06:37 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a2sm6409384pjd.33.2021.10.01.11.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 11:06:37 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 0/7] ionic: housekeeping updates
Date:   Fri,  1 Oct 2021 11:05:50 -0700
Message-Id: <20211001180557.23464-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a few changes for code clean up and a couple
more lock management tweaks.

v2: rebased

Shannon Nelson (7):
  ionic: remove debug stats
  ionic: check for binary values in FW ver string
  ionic: move lif mutex setup and delete
  ionic: widen queue_lock use around lif init and deinit
  ionic: add polling to adminq wait
  ionic: have ionic_qcq_disable decide on sending to hardware
  ionic: add lif param to ionic_qcq_disable

 drivers/net/ethernet/pensando/ionic/ionic.h   |   1 +
 .../ethernet/pensando/ionic/ionic_debugfs.c   |   2 -
 .../net/ethernet/pensando/ionic/ionic_dev.c   |   1 -
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   4 -
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  38 ------
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  74 ++++++-----
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  45 -------
 .../net/ethernet/pensando/ionic/ionic_main.c  |  53 ++++++--
 .../net/ethernet/pensando/ionic/ionic_stats.c | 121 ------------------
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  14 --
 10 files changed, 89 insertions(+), 264 deletions(-)

-- 
2.17.1

