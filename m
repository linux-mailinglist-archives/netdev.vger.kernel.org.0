Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA018573891
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbiGMOTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiGMOTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:19:00 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01460B4B8
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 07:18:57 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id w12so13563832edd.13
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 07:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CtNLc+zHrE4eROp1W7Buw5YfPYD5lQRArRs16J3dFe8=;
        b=xY0ZkLJuCBuUKrIPscwvyMyRCdmP6+SuW4kMQPpCSu3cG8bZ0kov8BMjAsO4Bzi2Ls
         Sl8M46TXizeRu6yMGegXi6Iw+j2ZWNoD3eKMUufEKDbTsp24CQaJuEGvtqt2xqKS/Ycp
         pjuoSYPT0iyVA5hGLa+PSQXpyzM0nr2F6VpK0Nf/LGVYtETWsypSKksMtsdVBvIR1Mk+
         7TtxS6RZNdbtm2jyCTaVO979n6HEsu2mfQJAHdkfIYeUJi7VR2RC/0jYRHHAbE2y7+hV
         MH1ZZ2JmSkCl/6rTGD2LxLXjnSG1z9TSaQHm8lRV2BQb5M7mBeyI9V0vd+4BpB//llYY
         8MGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CtNLc+zHrE4eROp1W7Buw5YfPYD5lQRArRs16J3dFe8=;
        b=CugROezHNV9pwE5JPwjHdzp6vcCK25pbJIU77oG/VkhOWpCxVPxlF64+b7vC8GWtYM
         c04g/TSp5f2Z+dyXkiijlgNc3SLYGnrmwme6DEZRrUf1OJhNHG7PjpGtXdYQ1q6j22ag
         umK1V3jvFtbzJl0lERuGcEnRdGohRjExEhrU8175Z5qBAZ+tIPnYTcCfVSQEJ1W6DUDG
         2BexuBkzu99gqLiFXLdXo7lPW5cP4KROK28GpgbiWgsEXzQMDL1KFHtuBJEq41RvCiJB
         KiCMg53qnJqqC7hONv/niaV98xRKpj5g86Z7OcaMCkqVSbGZZZO54DiKLWZmpHvkrdBw
         rpMQ==
X-Gm-Message-State: AJIora+gfZhl8HIF6Q5PcI7quFRQeiPtye7xY9A0e9C8NIr2aSM8+3P6
        vISA3w/FCtxro+7gDxv+Zzixdn77v63PvA4x+N0=
X-Google-Smtp-Source: AGRyM1vui1cjdg05sXcayNy5Fj6ExI2+XaYMzgV1vw69P873FA/JJw9VrLTnHJ6skMr7Kelx9Lnxmw==
X-Received: by 2002:a05:6402:510c:b0:43a:e041:a371 with SMTP id m12-20020a056402510c00b0043ae041a371mr5240649edd.424.1657721935535;
        Wed, 13 Jul 2022 07:18:55 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g1-20020a17090604c100b0072b51fb36f7sm3604261eja.196.2022.07.13.07.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 07:18:54 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next repost 0/3] net: devlink: couple of trivial fixes
Date:   Wed, 13 Jul 2022 16:18:50 +0200
Message-Id: <20220713141853.2992014-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Just a couple of trivial fixes I found on the way.

Jiri Pirko (3):
  net: devlink: make devlink_dpipe_headers_register() return void
  net: devlink: fix a typo in function name devlink_port_new_notifiy()
  net: devlink: fix return statement in devlink_port_new_notify()

 .../net/ethernet/mellanox/mlxsw/spectrum_dpipe.c |  6 ++----
 include/net/devlink.h                            |  2 +-
 net/core/devlink.c                               | 16 +++++++---------
 3 files changed, 10 insertions(+), 14 deletions(-)

-- 
2.35.3

