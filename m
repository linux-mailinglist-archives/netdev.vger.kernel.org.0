Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642B65BC08A
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 01:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiIRX0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 19:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiIRX0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 19:26:32 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2B015FCA;
        Sun, 18 Sep 2022 16:26:30 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id z9so9295264qvn.9;
        Sun, 18 Sep 2022 16:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=6B4jp+CWTu+ONEvzzx9Lu1ej/YdPxUyWLQ6EnE0GdQo=;
        b=XJIdPP8Us/fuPT1tYBy3ybLJQOpWupdcindhYqopY0rnNzylUuvCCkCal77cBIDlNS
         HfNx0RuPVJWHUoBO6jXNTR3ca++CD24zA4MY4kbKUj+hQapSEl2kSUe/w3lBGK538VlM
         FdmZmFZwrPxJJSFBXno0GsQ7ZRPOq5YBN5ozROvtPZOqGgQYQ645HfVRERD31I7Hw3G4
         0+tkBw155b91r0Mr8YZ4ZhZzB5FGCdlSUgTZs6qrUwTx88iYjGWg+3/GW1tNhZMBcUVz
         YSjmnnEUlSZjUW3a3ZrqsEhTjD8qkaS60gdY0dqy/Ac0Q5YvPSz4oLePG9hIAS0cuaoH
         67mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=6B4jp+CWTu+ONEvzzx9Lu1ej/YdPxUyWLQ6EnE0GdQo=;
        b=hJVdkD90H5J7cB0Gp1pvNyjUXkI1G8HZ8S9uQuDsvj/ByBSzktIMVPH6Q+VT83a3aM
         uRObPVi1MOGiNlHtX0+1GAf+m2+UHEh8iGqiJ0DttcmdYb+bHw6RW+ROz54zzS0BFlvK
         d+LFwcmdlbaxSniyHF/ncXAfk2JN0UgKS4AZ6tEt+t7sWCeqqeNizgx7KYCiwgd/aZMD
         eoCJM5vPNnRbg4yerbI+EMjz7/vrCIiCAMoyWQZuXtP687iWQNFsgnR6Tny8rAtzEmBG
         s5a7RMFiYipbA6vADmrZtWwFPug6l68bx1my93MPHfG+d/OLAQVLId0gEtcmtPU2uf1y
         iSAg==
X-Gm-Message-State: ACrzQf0Gd57XutdLFLG3j03ESF37p0Mhnu+RKyR5yUrFCyNvmXI6PaeA
        e4lKdD4Oiu9jHmxu/p02ZzY=
X-Google-Smtp-Source: AMsMyM7vsJl7VK7AWtB3Zl8I9SrKZXT20Q2Wlx6NK+oRUzGUq5LrQQgsg+mabYBE0FvHgvK+OfEJVQ==
X-Received: by 2002:a05:6214:29c5:b0:4ad:3134:7de9 with SMTP id gh5-20020a05621429c500b004ad31347de9mr4759298qvb.96.1663543589845;
        Sun, 18 Sep 2022 16:26:29 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id w16-20020a05620a425000b006b9c9b7db8bsm12274666qko.82.2022.09.18.16.26.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 16:26:29 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list),
        Zheyu Ma <zheyuma97@gmail.com>,
        Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next 00/13] net: sunhme: Cleanups and logging improvements
Date:   Sun, 18 Sep 2022 19:26:13 -0400
Message-Id: <20220918232626.1601885-1-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is a continuation of [1] with a focus on logging improvements (in
the style of commit b11e5f6a3a5c ("net: sunhme: output link status with a single
print.")). I have included several of Rolf's patches in the series where
appropriate (with slight modifications). After this series is applied, many more
messages from this driver will come with driver/device information.
Additionally, most messages (especially debug messages) have been condensed onto
one line (as KERN_CONT messages get split).

[1] https://lore.kernel.org/netdev/4686583.GXAFRqVoOG@eto.sf-tec.de/


Rolf Eike Beer (3):
  sunhme: remove unused tx_dump_ring()
  sunhme: forward the error code from pci_enable_device()
  sunhme: switch to devres

Sean Anderson (10):
  sunhme: Remove version
  sunhme: Return an ERR_PTR from quattro_pci_find
  sunhme: Regularize probe errors
  sumhme: Convert FOO((...)) to FOO(...)
  sunhme: Clean up debug infrastructure
  sunhme: Convert printk(KERN_FOO ...) to pr_foo(...)
  sunhme: Use (net)dev_foo wherever possible
  sunhme: Combine continued messages
  sunhme: Use vdbg for spam-y prints
  sunhme: Add myself as a maintainer

 MAINTAINERS                       |   5 +
 drivers/net/ethernet/sun/sunhme.c | 641 ++++++++++++------------------
 2 files changed, 256 insertions(+), 390 deletions(-)

-- 
2.37.1

