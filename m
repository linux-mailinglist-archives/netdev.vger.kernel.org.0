Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC9064A9F4B
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377589AbiBDSgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377588AbiBDSgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:36:35 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D431C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 10:36:35 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id y5so4885758pfe.4
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 10:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pm4zKmK47GpCA+RstqXSM2KLwZB1GmIBwzVxKJMkQGA=;
        b=iQCOs/XVYt6uWktWpUGCJqpipk4ChGdMK0Ms/cU/M+P+CRqxEGUjfCq4O4JK1O0NGJ
         7Sf29Cwx7rCXagihXbj2AKbFMG/VQD7XJRxNX6gefhs4eP7OuWnozZK8R0txpZ4WRL79
         eb+um/7xVVOt8MltgAAd1EvzADsAMc3IbkGkSMKAMiW65ScMYHFiIu31y+B3jHnBXQk7
         xABsIHCdSZUD3Iu/v3kfMXHcrWyEhOOSwp1FQqv1Cn35KwF62QMe97MG609jBLgPj//6
         E7a5+WyTAZxLQ5xxtX6POuJhOJ38PrTGd9prdOqsPX02/vww3xXG23uMWKCFPEQgLFqB
         3F7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pm4zKmK47GpCA+RstqXSM2KLwZB1GmIBwzVxKJMkQGA=;
        b=l7uwptWPwp3+HswEVHflmqMlEIWNe6N6OcEOj7CByB6zVU5ulpyblpZocV+6N8fkXO
         U7qV+rYoDYp+bnO1E6jQjq1J1IKqbzUNU3EJ+1xvG68vl8FNHXrUihhS2MF9ONilcSnh
         ReTUPfoGZVNwXJaQAp8Tpcm1q71onLgCXAjSsDJxdFo1Xiz7TXpzeGmW5149W4q0h7G6
         MBPqnswWDBdW9+zFlc7/yWDOD/k8YWWjdw9TMq9qBy/0kHj9Jl0HzjsAE2MLqePSbL2Y
         eqLEGclcuGGyrsqilG98togyPCwaYZqFDaGgB+J3ME49a2/ezwF9mADEYqTjJeQOp6MV
         D/Ow==
X-Gm-Message-State: AOAM5300mQno1DDivfkvLJhHkWyg39ZqeSOMlPV2PJuByR3KUpq6Zc5V
        BHUUNmXjiUQGtUHZy6Zx9oI=
X-Google-Smtp-Source: ABdhPJwo5kZC/qGFa+uSXJg2ZzPFf9JAHwyuz7ZC3lGieVt16KFwJ9+VqJSqgAOTF3eLbuSJvfK7FA==
X-Received: by 2002:a63:8548:: with SMTP id u69mr242278pgd.419.1643999794827;
        Fri, 04 Feb 2022 10:36:34 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e0d3:6ec9:bd06:3e67])
        by smtp.gmail.com with ESMTPSA id f15sm3483142pfv.189.2022.02.04.10.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 10:36:34 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/3] net: device tracking improvements
Date:   Fri,  4 Feb 2022 10:36:27 -0800
Message-Id: <20220204183630.2376998-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

Eric Dumazet (3):
  ref_tracker: implement use-after-free detection
  ref_tracker: add a count of untracked references
  net: refine dev_put()/dev_hold() debugging

 include/linux/netdevice.h   | 69 ++++++++++++++++++++++++-------------
 include/linux/ref_tracker.h |  4 +++
 lib/ref_tracker.c           | 17 ++++++++-
 net/core/dev.c              |  2 +-
 4 files changed, 67 insertions(+), 25 deletions(-)

-- 
2.35.0.263.gb82422642f-goog

