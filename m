Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33BAF57B13F
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 08:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbiGTGwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 02:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiGTGwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 02:52:15 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443EF3A493;
        Tue, 19 Jul 2022 23:52:14 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id t7so2655384qvz.6;
        Tue, 19 Jul 2022 23:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tOBUTJLgGxZreh8rvCKXID5SvHUIxRAuHlPy6Fm0wQU=;
        b=qXC6u5YtWyNVFjx39s1HO958XmfiW/SSpFNSeWtLPOrkm0olK5kQhLpWfBs2nIKlfa
         YuZUS8F0xoyWh2s9QyBm8YeKOWzbW9TMgHJq9SG4W9QagubBf5j3zYU4TRMmiNpzUMdA
         Jb922GUf9PgfrLoEby0O3vHbFrvpeXTUnWgxZTkHKraJwfOqjbWXGDPpGLOcDGi+ILIe
         0qixFf7s7kwlL6GFxCZ/gRrneBcAoH3Mv81pH8EE5BCaGr6rNcAbxhxnKdJSnKghZJzh
         0FSkl7P123L4lRlM6YLVdWOXEC+PDX7xTwNn5hjONovlrhBnDY5wTsVE3oMOOQV2+99Y
         pt6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tOBUTJLgGxZreh8rvCKXID5SvHUIxRAuHlPy6Fm0wQU=;
        b=TfcZIAM4Zr9OqV3GgkoQZsf12wOB+RsQzNNseM4pdrnOTrpl8CK/Pi4t7BI+Ii0isq
         yYh/FrbVBoQ9uKhHiBjxFZtVm40baHdQqcxj78VaUpehztRAmaQg4k34OL5h5YLp3B0W
         +kpKSoGp5Xbwz5eSTOREg+298IiXIpZgbkiUX+eFzfhO2ScEOF0bf4r2YQenO9CcARuc
         JI0Txd+sxC5kX6buWIkK8A8yL2u2/eHxp95QmG02Gu0wUGcX8RQXUJ7wObxKrGgly0Lg
         fX5EAm+mBT5UOgjyp/ZyC/VfXKBxl81FOKDwN3EyGLOynx0TopaYezpQAMpmNpsDLPue
         28mg==
X-Gm-Message-State: AJIora+K+pxD+smH6mRzXPyM5jD5z54VyxS+FdEFjH1g3B+WXRDC0fwI
        5rbe1YSEvmgZ0LkIhxSS+P41E6X9RQ+d13DH
X-Google-Smtp-Source: AGRyM1uZHPGmzWW4RwOvsjD5QIwUFZJqm4QGhwzVkjJvSj+R7UYgyRDas+Rbp7Yj/L6XajoJ5m0F+A==
X-Received: by 2002:a05:6214:29e9:b0:473:63b:5c61 with SMTP id jv9-20020a05621429e900b00473063b5c61mr28194454qvb.99.1658299933070;
        Tue, 19 Jul 2022 23:52:13 -0700 (PDT)
Received: from debian.nc.rr.com (2603-6080-6501-6000-7ddc-2220-f20b-c436.res6.spectrum.com. [2603:6080:6501:6000:7ddc:2220:f20b:c436])
        by smtp.gmail.com with ESMTPSA id h11-20020a05620a400b00b006b60c965024sm1448862qko.113.2022.07.19.23.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 23:52:12 -0700 (PDT)
From:   Jaehee Park <jhpark1013@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        dsahern@gmail.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, linux-kernel@vger.kernel.org,
        aajith@arista.com, roopa@nvidia.com, roopa.prabhu@gmail.com,
        aroulin@nvidia.com, sbrivio@redhat.com, jhpark1013@gmail.com,
        nicolas.dichtel@6wind.com
Subject: [PATCH net-next] net: ipv6: avoid accepting values greater than 2 for accept_untracked_na
Date:   Wed, 20 Jul 2022 02:52:11 -0400
Message-Id: <20220720065211.369241-1-jhpark1013@gmail.com>
X-Mailer: git-send-email 2.30.2
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

The accept_untracked_na sysctl changed from a boolean to an integer
when a new knob '2' was added. This patch provides a safeguard to avoid
accepting values that are not defined in the sysctl. When setting a
value greater than 2, the user will get an 'invalid argument' warning.

Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
Suggested-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Suggested-by: Roopa Prabhu <roopa@nvidia.com>
---
 net/ipv6/addrconf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6ed807b6c647..d3e77ea24f05 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7042,9 +7042,9 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.data		= &ipv6_devconf.accept_untracked_na,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= (void *)SYSCTL_ZERO,
-		.extra2		= (void *)SYSCTL_ONE,
+		.extra2		= (void *)SYSCTL_TWO,
 	},
 	{
 		/* sentinel */
-- 
2.30.2

