Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FF04BAC35
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 23:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343750AbiBQWDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 17:03:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237360AbiBQWDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 17:03:15 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2500403FC
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 14:02:59 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id r64-20020a17090a43c600b001b8854e682eso6767404pjg.0
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 14:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=2DgehUHuweVM98daOJrJv5KIgh28twysHUqFGuo/eD8=;
        b=35Xq6pens1goFb272MRiwE9awax5KM1IE3lRuQeB2gyOa5/9sZbMt3CvfiFgNX59hC
         POQjVIDscBCtXKuk5QEsBIfhMeqtDemQ5bju+VLJsmTk5Qj0jMvHxfOYyLggodJHWHPZ
         Oh0H79wlBIzRIFzvBA4kmV9I+qds+lLWFPjaBIdYypsXCsE3TGD8NTwLlTjSAgGdms+e
         JC6pc2hjO+zp8ExwTfEBoZDiKD+G8e/+EbqY4izp1wkqonyGmFBhefeVfEvM6N+a+lVO
         S6rh6ESRjmtmhcwiQ0Sps19Ds8Lhl6hjx+KShhbL6/5JmAWx8SZx9uqSiBpyWx++B7Ru
         eTZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2DgehUHuweVM98daOJrJv5KIgh28twysHUqFGuo/eD8=;
        b=cAtRcRZ2M4H4NZjFIRrzq4veeYkLFZT2jpvkRvcGHy8vG8+k3caLGWZdw47P4/XfAI
         OVOCsVLTlZ4SA7WtPySiJvLoOTKzn/bAQIAg8N25KVv+qxd0E06kyb93WL/LQtIVzazR
         5A1rtnmc+W7SuDadsDieXZvfr4tAmuAfZmdFxAe++lu8bPdwT0erx6GPxtTP47dYVXU1
         dx2yaVROQLgXtaiKxtZLAi8Sawgy6tkCRqFA0rtHxQcSEXA+gnCTj+obRkwwZOFpqka4
         oiXhbNIhSsVzkCVAZJRPwD8+7P9Inr6cCZvz2pKExZIgvi8n3Ei5Nr9TR4gKCveFbvvY
         QCEw==
X-Gm-Message-State: AOAM5339EhOM5fwrb93bfU0oT9P6Lnf6tSPZYNLMqvCey0pLjypU0ODV
        Uq+CfvTXZasYh3ZAU9LdjUn1FA==
X-Google-Smtp-Source: ABdhPJy3Oa91PVHxIQyaxhsMjSgcKV883B11tAkScHMZhLl//+wAMPv7BelkN40Pg7TOy+D+85fVhA==
X-Received: by 2002:a17:903:230f:b0:14f:28e0:262b with SMTP id d15-20020a170903230f00b0014f28e0262bmr4637608plh.123.1645135379368;
        Thu, 17 Feb 2022 14:02:59 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 16sm516119pfm.200.2022.02.17.14.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 14:02:59 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/4] ionic: driver updates
Date:   Thu, 17 Feb 2022 14:02:48 -0800
Message-Id: <20220217220252.52293-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a couple of checkpatch cleanup patches, a bug fix,
and something to alleviate memory pressure in tight places.

Brett Creeley (1):
  ionic: Use vzalloc for large per-queue related buffers

Shannon Nelson (3):
  ionic: catch transition back to RUNNING with fw_generation 0
  ionic: prefer strscpy over strlcpy
  ionic: clean up comments and whitespace

 drivers/net/ethernet/pensando/ionic/ionic_dev.c  |  4 ++--
 .../net/ethernet/pensando/ionic/ionic_ethtool.c  |  6 +++---
 drivers/net/ethernet/pensando/ionic/ionic_if.h   |  6 +++---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c  | 16 +++++++---------
 .../net/ethernet/pensando/ionic/ionic_stats.c    |  1 -
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c |  1 -
 6 files changed, 15 insertions(+), 19 deletions(-)

-- 
2.17.1

