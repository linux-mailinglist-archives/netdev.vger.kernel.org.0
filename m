Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D32A4FFCE5
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237258AbiDMRiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237395AbiDMRiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:38:12 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B2A6BDCF
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:35:51 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id y6so2561770plg.2
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1n7XF4EK1COQmNBKdJvgodHgwPn24h/uUlLb7DVlY2c=;
        b=ZTRzFaxASfU4MQ5/ogxF8uqpR8YjCLtdPT5LkJrz+qSiVHgIQgkZ+Sdg3pO2T11otC
         2WjwYebN1quW9rsG0bsj4P8rhxBQIG3f46ljKhbBPcASGgbAp7+o7Mm8zTSXw+Teh1h8
         AnbNIpheNOcg3Z/Sjdr09URx38WoUMyA4mOmrSNA+4QX5WUJDzcQ6MNWZNt6oP6Mlpsm
         c4EkB2YkGW345HxV2sYjip7Qqv63GLRDbUiCtnDZr/mWvSl4+zpEn1yW0BJLlVeFN3aF
         sESyWio6JkYIvHYfXetlFlhL7hEaBYykMeYt1E0urN/G2ooOrQm+JGIV8OMcTVg1Y16E
         nQ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1n7XF4EK1COQmNBKdJvgodHgwPn24h/uUlLb7DVlY2c=;
        b=mhmnUCi45/QxYIn5o24Q+cTEl6hNxwI3tKC6iDb6ycErqntbTmCmr2stFvS3WDFxBP
         hO3EVe5PqZW+3WX8uoPhylooBzukJugHrugN7i9UXYPEcz08ROUp8lidgGO3iZaAdJV1
         168Q9xPFuFyzrBMvxSW8DHedkD97upuMTQpWOQObk1GY2NPrFkfB0xVd3UqEO/5n1dGV
         wwM3PjXKsF1vYUvEd+7WpuUfFFgNithqtB8wtwipdiMrmsi/bzHV4mU0m6PJ9KhCn+5c
         V2U7e+v1TLmu0kUk3vRJimCR6c3hswkaZV6h2fuqGqAw2FhdKB7h4ImE0+O0Dvask44J
         U7KQ==
X-Gm-Message-State: AOAM533JjvZaKdOaXWStzzScakxu13IXilJn3D6sJVKgaotX5mdkBt+C
        fFeJnWxE0mPK5oum3ajFt9k=
X-Google-Smtp-Source: ABdhPJz7tfUhtPhjd8L4cEt1Gn9VHohe2kBntCbiMSmnS3ndun2QyzQfnb+NmnWHWksQqvsXfjztqQ==
X-Received: by 2002:a17:90a:6781:b0:1cb:11f0:9c51 with SMTP id o1-20020a17090a678100b001cb11f09c51mr11999951pjj.243.1649871350816;
        Wed, 13 Apr 2022 10:35:50 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:bfb5:153b:b727:ea])
        by smtp.gmail.com with ESMTPSA id s3-20020a056a00194300b004f6da3a1a3bsm48546402pfk.8.2022.04.13.10.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 10:35:49 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net 0/2] net/sched: two fixes for cls_u32
Date:   Wed, 13 Apr 2022 10:35:40 -0700
Message-Id: <20220413173542.533060-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
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

One syzbot report brought my attention to cls_u32.

This series addresses the syzbot report, and an additional
issue discovered in code review.

Eric Dumazet (2):
  net/sched: cls_u32: fix netns refcount changes in u32_change()
  net/sched: cls_u32: fix possible leak in u32_init_knode()

 net/sched/cls_u32.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

-- 
2.35.1.1178.g4f1659d476-goog

