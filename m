Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859106480B4
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 11:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiLIKN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 05:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiLIKNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 05:13:21 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185242FA49
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 02:13:17 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id f3so3237964pgc.2
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 02:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QWawOyGFlVcNCGguhbqYmqBXno/PmVD2Yuel8m/nJfE=;
        b=Q4yKkV3Stuxlf+Gz2JmPXWLrbt7siq10qNylV71EXsDmHrSf1CLmAD21F1WpIRNUtz
         05uAFGLyOQlaWY55QJ1M+z4gd37DECPTdf13+OOUEfY4KQ/CSbvqxcamr6/4joC/bAsw
         7AIoLtX1CUemDAr7x/oRHfx8WB9kja2hiDsAGKRYF1ZzP4xjXNdvRGIIUL2y5Ox8i/m5
         rBuzKJgRT5br+OQeMWY+1cn06AqP/J7XkyzgCzNcBjKV5riglTOmz30ZGpHSE3iTw4v5
         ZsYcCudcU0No/Re73SUZlTxxQe7SlcnhbAeDHnR8t2+vzhsdOaNboefkV6dQg3qjNIN9
         7lLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QWawOyGFlVcNCGguhbqYmqBXno/PmVD2Yuel8m/nJfE=;
        b=ixB3rlRyVvSZju5mUu6fUh2kFUsYVQ3UFICMwhkhaQymssuPnGrNrXZpoPBewLA5yc
         UPl8KLELVtLGNZ0BxbW7qRtUmvDxHl6YBdxC+g3pTtTdbdkuYpfhsH6GxJJz00y/8U5x
         7QugipN8f8gFqR8kT1uFMNPyhkbtWMulRKgHPK/TW1WR6O7IsSPF7NMNIVxwHMHSVFXN
         l1G6Q5mayZ0H1lwg3yZc2aB63ZYLtNrQ2L7yjrM3oGnzUJ11OCQ0MGSBHesS9zJjoVSZ
         QrKYOx3msuI3bcePnNviXBlZgKzqs34ijbWiCo5Z7vO31gYCR0DS1Va3MZczM6YvQSmD
         l/hA==
X-Gm-Message-State: ANoB5pnKBrFiMjf8LOV5bgp1/XWTDAJcZ2DdIarwIYzig94GNtNiUxaT
        YP+y6Qb9/FKMj6C4jbOL9Vv2caGdXw9NR5EV
X-Google-Smtp-Source: AA0mqf72l6S0h55dlpnR83ZL5vap9zzI7eM3S3008sYzgX7ihWPbCUoIUodx9/UH7lshj6VRtXOKKw==
X-Received: by 2002:aa7:95b5:0:b0:576:df1d:423d with SMTP id a21-20020aa795b5000000b00576df1d423dmr5925687pfk.31.1670580796049;
        Fri, 09 Dec 2022 02:13:16 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g204-20020a6252d5000000b00561d79f1064sm936677pfb.57.2022.12.09.02.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 02:13:14 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, liali <liali@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 0/3] Bonding: fix high prio not effect issue
Date:   Fri,  9 Dec 2022 18:13:02 +0800
Message-Id: <20221209101305.713073-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a high prio link up, if there has current link, it will not do
failover as we missed the check in link up event. Fix it in this patchset
and add a prio option test case.

Hangbin Liu (2):
  bonding: access curr_active_slave with rtnl_dereference
  bonding: do failover when high prio link up

Liang Li (1):
  selftests: bonding: add bonding prio option test

 drivers/net/bonding/bond_main.c               |   6 +-
 .../selftests/drivers/net/bonding/Makefile    |   3 +-
 .../drivers/net/bonding/option_prio.sh        | 246 ++++++++++++++++++
 3 files changed, 252 insertions(+), 3 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/option_prio.sh

-- 
2.38.1

