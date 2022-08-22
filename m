Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C167D59B88E
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 06:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiHVExU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 00:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiHVExT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 00:53:19 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2ABDF8;
        Sun, 21 Aug 2022 21:53:16 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id v23so3604840plo.9;
        Sun, 21 Aug 2022 21:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=C3Cjrjk6xyl2vW7AF8zcOGqP/d2kVrvPGE4x2bwbhnI=;
        b=IfgQgo/wCyRF8eF4A4vvbHsHB+RZxtccVX/zUuxM6Z1W66CRaQ9EMCR/r6TGHcIO0w
         uQUCuJ29ZiqxjRmWaUxP4ANLwuLwGzuOJIDgK3BQLoFCNlsrhUssgKL5hmrMhrdBcjuR
         YTeW/2VxieCLJPC8ugLaCrUJzDHH5Bl0DJ/WrZUQ/sy/995Qy+RPmu00/O39ULRxkIGH
         zhNfRvzURYzCtWu4JfsA9CavtlD+dfVWwDc39nNykImWgZulJT5KSCJRAhqhBivPu7n6
         5WkxYCSUWZZGYBSpD08K81bgAX+qPUDTg8FnNfJry/crk8DGpHrYVtZsELgnVc4e9M6b
         3Ihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=C3Cjrjk6xyl2vW7AF8zcOGqP/d2kVrvPGE4x2bwbhnI=;
        b=6WwYPCr0ox5o5xtm57acYmAfebyb1qAaL496UHDcCilVHxW4M8tpUxheMnfC9ErX1p
         bSgGwp//Gaxq+Opz6Tr7MoYpJMCjlhiUnbf+UXdH1zG0ssD1VBao6LBRlCT6rXrjiGlf
         8Fbl51eELX3zJnw4BHR2vdSS0iZ17wRrgt3bn/GpwMN5epm+zVavCNznAFjMx6CkrJuv
         dcz47zrPWNVJN9Kqw1q24ilyTgCFHnanomatBDkdPHFdZvT3WAmBYRMZnZJzC38rQWug
         wwB4jrkyBhSqCvR4Iv2yCgPwM0Rabp/KbYIfVOrm7GO85xQDMR+BATRMh5KBhyfa/4a0
         gAyw==
X-Gm-Message-State: ACgBeo3sMqoOwvZHkkiA5ZLjC0ZvUy2CBReeb2lpqgbsMjZyD1D+/NaG
        lLqiy2Hwi2f2d5pUgq6MtzgPpOA9B94=
X-Google-Smtp-Source: AA6agR6GYcbxs49o/zfPfQ7IRZDf8jFD+guSZNnWBsnL4/EgCAJIVlzIJIxRv5tu6Sgjljy3Q4FHpA==
X-Received: by 2002:a17:90a:8911:b0:1fa:c8f7:1450 with SMTP id u17-20020a17090a891100b001fac8f71450mr20765973pjn.123.1661143996409;
        Sun, 21 Aug 2022 21:53:16 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id w6-20020a170902e88600b0016bf803341asm3846233plg.146.2022.08.21.21.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 21:53:15 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linl@vger.kernel.org, xu.xin16@zte.com.cn
Subject: [PATCH 0/3] Namespaceify two sysctls related with route
Date:   Mon, 22 Aug 2022 04:53:10 +0000
Message-Id: <20220822045310.203649-1-xu.xin16@zte.com.cn>
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

With the rise of cloud native, more and more container applications are
deployed. The network namespace is one of the foundations of the container.
The sysctls of error_cost and error_burst are important knobs to control
the sending frequency of ICMP_DEST_UNREACH packet for ipv4. When different
containers has requirements on the tuning of error_cost and error_burst,
for host's security, the sysctls should exist per network namespace.

Different netns has different requirements on the setting of error_cost
and error_burst, which are related with limiting the frequency of sending
ICMP_DEST_UNREACH packets. Enable them to be configured per netns.

*** BLURB HERE ***

xu xin (3):
  ipv4: Namespaceify route/error_cost knob
  ipv4: Namespaceify route/error_burst knob
  ipv4: add documentation of two sysctls about icmp

 Documentation/networking/ip-sysctl.rst | 17 ++++++++++
 include/net/netns/ipv4.h               |  2 ++
 net/ipv4/route.c                       | 45 ++++++++++++++------------
 3 files changed, 44 insertions(+), 20 deletions(-)

-- 
2.25.1

