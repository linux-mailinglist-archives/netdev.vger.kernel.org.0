Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E97365ABD6
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 22:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjAAV57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 16:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjAAV55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 16:57:57 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D3AE9B
        for <netdev@vger.kernel.org>; Sun,  1 Jan 2023 13:57:56 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id g7so21288512qts.1
        for <netdev@vger.kernel.org>; Sun, 01 Jan 2023 13:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4RIE6xZebAYoDU1dyrt2ZO4yBxRnUWAzeqPFFXukTlA=;
        b=fIijv1Z83vKPBg8cWgvVZAOJH/5BMBXFcsmGWPIK2otBXI5O79T2kp+DtJazmJfFmO
         TJdHzMWmEmCrzsV96GftCIPCDIjx72fKHzstGjw+7buzoIB5fZ4ClCCKZVapzWu94QmP
         oTmx+TmmQ4blBOFC2FND0j11wv18tx6x+26eZoUc6r+Uqt2+nOKcOOQ+faE5/rXKJMkP
         svvYua+1z2Xn5VaPu8WC/6zmpeRwyjLKY3hx1eZvuoxCFvkL2LfyjXpYh/y2+72wlDYM
         CSnZPBboYNbjX21rT64GIY9YzwK9X6LQvOxNKC+jYHquUrGnZ7p5WvkBF/Gpf0kxS5pC
         jasg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4RIE6xZebAYoDU1dyrt2ZO4yBxRnUWAzeqPFFXukTlA=;
        b=4/h9X4yC/oR+tIBBR3xZNiq9zl0s3QPM5pMygvm2x/w0rOz5IaZqg9nnmvBOgd2J0S
         noImNHhpDGMYkCvapEVhnlgjcWiL8iYGGLXoSsRhl71Zz4Ut3d20u9yR4mbekPe5UPpn
         3uR+GMvc2f5PizUS2XZRgpBzDs6+KBNHelTvqptk53x3omRIP4an1s1PC+/c5iZS534m
         dpVDY7ll7OQZX22zPtIu0em265h3tu8MM47tK2mMkICZEuNE9LBbpY0XneL20/EBDWwZ
         vHYnVPC+9dAp22q787gPpWRnPO+e2QZv0UBKdN2kyxR4mwvdvGKtiFjcX6GMEPSqBGkv
         UTwA==
X-Gm-Message-State: AFqh2krXIRR5mv46IuTLR4IypLVG17uw8CoyJOowq2552Cp0aHtdu6ak
        TK2V3eBjHvCBAGuy5jePOl0xOQ==
X-Google-Smtp-Source: AMrXdXs/cnqlaX3HrFuZvFvfjX/7+FmnntoMlAS5QCjvRu794xhBDPgLK1PoHyd4trXHDUbUt2NHoQ==
X-Received: by 2002:ac8:4b76:0:b0:3a8:1447:d10b with SMTP id g22-20020ac84b76000000b003a81447d10bmr48850533qts.46.1672610275576;
        Sun, 01 Jan 2023 13:57:55 -0800 (PST)
Received: from mbili.. (bras-base-kntaon1618w-grc-10-184-145-9-33.dsl.bell.ca. [184.145.9.33])
        by smtp.gmail.com with ESMTPSA id m14-20020ae9e70e000000b006e42a8e9f9bsm19233073qka.121.2023.01.01.13.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Jan 2023 13:57:54 -0800 (PST)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
Cc:     xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
        zengyhkyle@gmail.com, Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net 0/2] dont intepret cls results when asked to drop
Date:   Sun,  1 Jan 2023 16:57:42 -0500
Message-Id: <20230101215744.709178-1-jhs@mojatatu.com>
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

It is possible that an error in processing may occur in tcf_classify() which
will result in res.classid being some garbage value. Example of such a code path
is when the classifier goes into a loop due to bad policy. See patch 1/2
for a sample splat.
While the core code reacts correctly and asks the caller to drop the packet
(by returning TC_ACT_SHOT) some callers first intepret the res.class as
a pointer to memory and end up dropping the packet only after some activity with
the pointer. There is likelihood of this resulting in an exploit. So lets fix
all the known qdiscs that behave this way.

Jamal Hadi Salim (2):
  net: sched: atm: dont intepret cls results when asked to drop
  net: sched: cbq: dont intepret cls results when asked to drop

 net/sched/sch_atm.c | 5 ++++-
 net/sched/sch_cbq.c | 4 ++--
 2 files changed, 6 insertions(+), 3 deletions(-)

-- 
2.34.1

