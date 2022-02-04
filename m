Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C5A4AA357
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352093AbiBDWmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236207AbiBDWmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 17:42:43 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AB7C061354
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 14:42:42 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id y5-20020a17090aca8500b001b8127e3d3aso7426546pjt.3
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 14:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jff8z/4dtB/6ZFjvKptCMq1EXpNZVyYxi+w8krHlTeE=;
        b=T9lcj4ZcpPNKGykgjVkJrWNwjp3kKvEjSacn2X4tl3Y+AMmYYqOT9maDxRjEqZ+zof
         6GmTsMHGuGrkYdfMsSJJCDxmUkE8wyArY3Pt7SdV0sQAkypIyFkXSNRIPa6u5JGJzr9R
         giUkP5Ye3bROKH2kEfRgePOBiLgi3UpUVvID2QtFO/TYeVf9X/WyjOAnuttkwLt3cz2j
         YaAKH5MldbAsB3CJw4F05gg0jjWIxkZHrhSG+cfwU9RVn8pz86GbomqJSrQ7E/a2nul1
         FvY8vtK4LLOVuIRQZVaflQXNsejLI0iphMuc/MP/kYbFqKqevp7Aw2bFBacO6J50NCk4
         I8YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jff8z/4dtB/6ZFjvKptCMq1EXpNZVyYxi+w8krHlTeE=;
        b=Ku3q9kxmJpT4pOhaxILXg8wPuxbuHWLe5yvYmtOwZ9VuZuWIWGpMxdkRI7Mr4jcyIl
         5inrCmZyfkSvEluPG3z7FPKl95Ky1TzVLThZl36KEsqc8s8Bg0q41zwSuaYqYtVABrlQ
         a8WkbNgIuetKczN4wrbwFK57QeNr90lHLcbfRhRtwb6Y5OqcDZL8GKTYEhzoVUKxCcuF
         1b8B0UFNhiAFfybBiTkanZ4CflfA+u8F2RVfouAivMmLFJfNpRdcVd8Bo7+b+YtnsrNn
         R4PqM3iaFwWcicd6QMFQolieVeBqgQAKim/VOPByAQqqqXO8cgpCoGZfpT5V9s1siyaP
         dwsg==
X-Gm-Message-State: AOAM532iKgZ2WqLlqRE9mVH2EMTc8oicKiARootdCWyWiVfZmmln/bV+
        DxFHRdmAmGUGcFlfhZOJS/k=
X-Google-Smtp-Source: ABdhPJwa7C4Co1dVaC8wqYJs/+80HdRyssPS2+oyMCMZp/CvCNc2TRfKnnF7yNDHCNv5wM/DhbXcvg==
X-Received: by 2002:a17:902:c412:: with SMTP id k18mr5493934plk.68.1644014561569;
        Fri, 04 Feb 2022 14:42:41 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e0d3:6ec9:bd06:3e67])
        by smtp.gmail.com with ESMTPSA id s2sm2410060pgl.21.2022.02.04.14.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 14:42:41 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 0/3] net: device tracking improvements
Date:   Fri,  4 Feb 2022 14:42:34 -0800
Message-Id: <20220204224237.2932026-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
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

From: Eric Dumazet <edumazet@google.com>

Main goal of this series is to be able to detect the following case
which apparently is still haunting us.

dev_hold_track(dev, tracker_1, GFP_ATOMIC);
    dev_hold(dev);
    dev_put(dev);
    dev_put(dev);              // Should complain loudly here.
dev_put_track(dev, tracker_1); // instead of here (as before this series)


v2: third patch:
  I replaced the dev_put() in linkwatch_do_dev() with __dev_put().

Eric Dumazet (3):
  ref_tracker: implement use-after-free detection
  ref_tracker: add a count of untracked references
  net: refine dev_put()/dev_hold() debugging

 include/linux/netdevice.h   | 69 ++++++++++++++++++++++++-------------
 include/linux/ref_tracker.h |  4 +++
 lib/ref_tracker.c           | 17 ++++++++-
 net/core/dev.c              |  2 +-
 net/core/link_watch.c       |  6 ++--
 5 files changed, 70 insertions(+), 28 deletions(-)

-- 
2.35.0.263.gb82422642f-goog

