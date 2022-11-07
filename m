Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6194961F69E
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 15:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbiKGOwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 09:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbiKGOwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 09:52:23 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB6C1C90F
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 06:52:17 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id a67so17925455edf.12
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 06:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VDsKMoQ3o7DUmaY4RPJ3ac8u3+dZxMb8NGji98P/F8M=;
        b=Wo02C/N0e7antyLbVrtC9NRaRzPPlgLXKeHz7pi4fPmW0CCwsfdJ6v4QOdXNM7gDp0
         RaYVep8V8BahP1bgXQunAnFuMkE/B8iao0sK6PDsmTduff3RAecHCL+EkQyIFseOlNdb
         4AsGc9REFbnjURw6FMWTP8zanwMw/1Y0PqBWh/FE2CYEHCcCkXNv/708DJ4uvtEj8K0M
         rQSoNQtzv5gQ5/Z3QyAIuNVTsUDrQXDOA75fnEWYB+BvpSIE7AEsosoTrrUKcgf8b/1e
         F4qzlx7Q3ryFac+EW9nlhnaD6P6l5hJni22uMKatw9szOJRG5ZF6WErAqz5zuaWYBtNo
         1bWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VDsKMoQ3o7DUmaY4RPJ3ac8u3+dZxMb8NGji98P/F8M=;
        b=bBwBkJ2DARfr8sFBjMhoKudor7m5RLJkkKTpSfSuDre8tHLUYEoBNU/uhEpZZ0HFw+
         fHmHqGPQ/KEMIvbyFHMY2z4RInRLDvHblKI1jLM+zb2R31XPtaJ67ATLzcFhrL/Bt/vB
         4Kq6V6pvy7J4zlSxEl9EYZ4kZ0LsfnlpUbb68zN/bpvPgvCLnPuNHGfzdVNnC8xVzwxR
         dpmYfFwHJIqGtG8WsfmQNpYFABVSk2kGn+KBiPHo//XJKsblZn9F5a8woo+L258/1Guv
         TbvuCD2pZTTg5Dwq/jeZ+vxfovHc8kHq6T/dwARqQxcuXyPRz6vvxuSr5DGWsXBhBnDH
         FECw==
X-Gm-Message-State: ACrzQf2ZMlF2GFcRV0cgMSMeFohTFmqRKdBGOBBfxWVOohrYx2YnSV9c
        fDHQqft+HfR4T0BJ/HP9+iYLe8fzKvpquBRD6tU=
X-Google-Smtp-Source: AMsMyM5h7GWsQ1hW1Ezv55b+QfoKReuzmicElPtqBXvexDP/Rvx4R1/lNVEzzlpvPR2QeiBIJ4YyrA==
X-Received: by 2002:a50:eb05:0:b0:457:c6f5:5f65 with SMTP id y5-20020a50eb05000000b00457c6f55f65mr49960817edp.311.1667832735600;
        Mon, 07 Nov 2022 06:52:15 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j5-20020aa7c405000000b0046182b3ad46sm4307964edq.20.2022.11.07.06.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 06:52:14 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, idosch@idosch.org, bigeasy@linutronix.de,
        imagedong@tencent.com, kuniyu@amazon.com, petrm@nvidia.com
Subject: [patch net-next 0/2] net: devlink: move netdev notifier block to dest namespace during reload
Date:   Mon,  7 Nov 2022 15:52:11 +0100
Message-Id: <20221107145213.913178-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Patch #1 is just a dependency of patch #2, which is the actual fix.

Jiri Pirko (2):
  net: introduce a helper to move notifier block to different namespace
  net: devlink: move netdev notifier block to dest namespace during
    reload

 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 22 ++++++++++++++++++----
 net/core/devlink.c        |  5 ++++-
 3 files changed, 24 insertions(+), 5 deletions(-)

-- 
2.37.3

