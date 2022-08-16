Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8B1595337
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiHPHBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiHPHAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:00:06 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562A24DB6A;
        Mon, 15 Aug 2022 19:25:27 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id s5-20020a17090a13c500b001f4da9ffe5fso16079394pjf.5;
        Mon, 15 Aug 2022 19:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=YqGB9CXBfhSDOkzqxXoDEol6hXhBNCh+lrkmU/ndAoQ=;
        b=ZiSkeKL+cqpkiyBA+iGv3k61zbMXBZ4NMX6flZvm7wFBKFSfUbbI+7BrtUqZGrXTSi
         /vblphRZbpSFkELKwZ9r0qqRIiQmqWL6D2Cp3dX9WZbhz6m5fDZNKx92h2h1qie43eLP
         FNd8mln26aHo03bJIPW70yxbhZsgt0HAUIFGyJc+0J0zmyhe973YfwTL46kky6OYgSxh
         /puy6G9bdB4tjv39b1zQRqRN2JS/yM4pV/OyonmskhwEGmr0LsNynPE60kClZ7DpIT2v
         1BAahO+tnv9fNgWEhg2zBmZVUGIVjaKzWwcJmI0H5AksuUKMCdanEFT8lFp10am5Nqcz
         HVgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=YqGB9CXBfhSDOkzqxXoDEol6hXhBNCh+lrkmU/ndAoQ=;
        b=FAlHcFv8CQitK5k/RG8vHNZUvi+YEPbtn7T085TlIJh5Cg9WEGc9dZN6G1hRogTjll
         GKH6EqqAHeDt6LotGIaINEwCjV+TzYTICoeNxs7PQXTGEhVTmTMqxwvNy9QeImvDGIkP
         Dg/7lQpI/4VD1IkKr9o68Xxo4ADRD9eQ/R6DxScs+em0O1Dgs4P8F7dVvtPxfLNmI8SA
         rfV7Lt86rVTPT/oUpYAhvijz4eOLE5IUTJ8ZeSMS4VkwGx9sBPLwirf0JywxfAE9oc2L
         OI1wfvfLx1+NIpaVktZdbJzhDhLvr7zZbXKSJcQpj7Jxw7l+Ntp8+qaYNk4JEymJRpwf
         GaPg==
X-Gm-Message-State: ACgBeo0Pb4c1Rtos3jIn3Qe2NLGNKstJ44E+cBXMBBdL69qwZQUOSqFE
        t3UTnmBg7pOhpwy0MVBS37g=
X-Google-Smtp-Source: AA6agR7VpFQG0OT8uaIKX0Xfg51PHa5eRJJiRj/pqSx4918cCHGf56zUPEmCgq2EBcaCDMpn/5kRig==
X-Received: by 2002:a17:903:22d0:b0:16f:7754:1e99 with SMTP id y16-20020a17090322d000b0016f77541e99mr19204787plg.150.1660616726810;
        Mon, 15 Aug 2022 19:25:26 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id p6-20020a170902780600b0016efa52d428sm7657631pll.218.2022.08.15.19.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 19:25:26 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu.xin16@zte.com.cn
Subject: [PATCH 0/2] Namespaceify two sysctls related with route
Date:   Tue, 16 Aug 2022 02:25:22 +0000
Message-Id: <20220816022522.81772-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: xu xin <xu.xin16@zte.com.cn>

Different netns has different requirements on the setting of error_cost
and error_burst, which are related with limiting the frequency of sending
ICMP_DEST_UNREACH packets or outputing error message to dmesg.

xu xin (2):
  ipv4: Namespaceify route/error_cost knob
  ipv4: Namespaceify route/error_burst knob

 include/net/netns/ipv4.h |  2 ++
 net/ipv4/route.c         | 41 ++++++++++++++++++++--------------------
 2 files changed, 23 insertions(+), 20 deletions(-)

-- 
2.25.1

