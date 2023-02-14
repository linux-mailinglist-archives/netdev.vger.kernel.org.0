Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6233696F14
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBNVQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbjBNVQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:16:36 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EFD2FCDA
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:16:04 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id bv2-20020a0568300d8200b0068dc615ee44so5073141otb.10
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uRgmcUUBCgjYjhuV3l+BgW540hs5+UG5kBmTbVoB8xM=;
        b=Gkhykd07IUs1OrB5R3yuQfpbAdctwKK4kEHJ2K3O5MN8CVL6so4uTGcWYXZHFjq2zM
         MV60FaojLUrGGDsFmrCvEjPIGfK6PaLNRgxMIizX4J1KD3yfZNpC+SYFDxIzh0VbGCqS
         8ecb1wFl3Q3XqqmDffCYOBpnb9ekfrvl9VyN7D3bVCAVGBoDBqWdUvFVhMuGDkquEY13
         m3HP5EFvXC4hnaduJTTsV9Ev2KahjiOIVNFPFEaKfZllIfhOGl6VybFM4f8pLnDsY8NI
         A6zca/9/2lEocmv4DsaqlVfIaEqfTsclN45Piqk9UTrXMeMubDzPC1ttw5wcM7zRnCF6
         Spyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uRgmcUUBCgjYjhuV3l+BgW540hs5+UG5kBmTbVoB8xM=;
        b=5ZDqw+un9xfX6k2OB1LH/KT2D80l6uqR97WeZM/sS3R3tat9/J8Y0A8BF3Lj47hkDC
         92bgOB2C1QJUEbVqMkOuaH0+w10cp3eXJeu+kuZihXtunCyC/Jrfsgw77dJrFl3PwYJI
         MKfXOOGJAtKqR6akKr42bXbdVbof+LxEOi5xu8VWW740/7TDatUFBzoXtDMLRAQzWg6I
         6vN06PvenlL8S4XbVHu2Dz4MCO/ZiZR9MhYc+a8cYa7AFWO5Z8XX17bq03LOpSw8I7ra
         APPzZGxJu57fFFwq0qcto/2vF4K6Ittsy1Lk2uZGPYfHPjHhPtIEVX3SdcvAV6qrn+zk
         7f1g==
X-Gm-Message-State: AO0yUKUbBTaPzHewsi/AXUqnOCRPQiCRyuY41clmaEhI8XxldNY5pICB
        K9iDjsJ0Itb8zK8gAvvl++1ZmKBIaL6spui8
X-Google-Smtp-Source: AK7set//ch5oxuNYKlaxWHNTEbPS+qGsMeQrG3Sxm6SXTRnYopy8ZoWQWceQ9fgl/l4qttVrtSTuig==
X-Received: by 2002:a9d:734f:0:b0:68d:4568:e83c with SMTP id l15-20020a9d734f000000b0068d4568e83cmr1403128otk.19.1676409349404;
        Tue, 14 Feb 2023 13:15:49 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:565a:c0a1:97af:209b])
        by smtp.gmail.com with ESMTPSA id b6-20020a9d5d06000000b0068bd3001922sm6949754oti.45.2023.02.14.13.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:15:48 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 0/4] net/sched: transition actions to pcpu stats and rcu
Date:   Tue, 14 Feb 2023 18:15:30 -0300
Message-Id: <20230214211534.735718-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
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

Following the work done for act_pedit[0], transition the remaining tc
actions to percpu stats and rcu, whenever possible.
Percpu stats make updating the action stats very cheap, while combining
it with rcu action parameters makes it possible to get rid of the per
action lock in the datapath.

For act_connmark and act_nat we run the following tests:
- tc filter add dev ens2f0 ingress matchall action connmark
- tc filter add dev ens2f0 ingress matchall action nat ingress any 10.10.10.10

Our setup consists of a 26 cores Intel CPU and a 25G NIC.
We use TRex to shoot 10mpps TCP packets and take perf measurements.
Both actions improved performance as expected since the datapath lock disappeared.

For act_pedit we move the drop counter to percpu, when available.
For act_gate we move the counters to percpu, when available.

[0] https://lore.kernel.org/all/20230131145149.3776656-1-pctammela@mojatatu.com/

v1->v2:
- Address comments by Paolo

Pedro Tammela (4):
  net/sched: act_nat: transition to percpu stats and rcu
  net/sched: act_connmark: transition to percpu stats and rcu
  net/sched: act_gate: use percpu stats
  net/sched: act_pedit: use percpu overlimit counter when available

 include/net/tc_act/tc_connmark.h |   9 ++-
 include/net/tc_act/tc_nat.h      |  10 ++-
 net/sched/act_connmark.c         | 107 ++++++++++++++++++++-----------
 net/sched/act_gate.c             |  30 +++++----
 net/sched/act_nat.c              |  72 ++++++++++++++-------
 net/sched/act_pedit.c            |   4 +-
 6 files changed, 148 insertions(+), 84 deletions(-)

-- 
2.34.1

