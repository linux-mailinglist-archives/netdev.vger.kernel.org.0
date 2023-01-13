Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE26866A71B
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 00:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjAMXb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 18:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbjAMXb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 18:31:56 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7628D5C3
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 15:31:55 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id w2so1874046pfc.11
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 15:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n2JPmaBmBWVFUUKvWDRn7yx1c4SeQbapiAvfOAswM6I=;
        b=gr9NPpY3fDws8iyJ8FPsZ0emg26hpIScr8BVNO1xPkXSVxu8uq1JCprbrdIPGrg5at
         1H6Jm8hAAnvD5BqsR7u01C1SbicybwyTQlC9C+EPzH+ZsZsANzaanE5bsLWor30zEUBH
         cM7TeUvEcKUzjNjNZ2VZCCxkITNhasOule3APU/YwkMQvRI6XqG3ZhRehdlj37PJODDS
         WCV5W+Yx1M8jteZJgr+VtlpXual/8Sv1WqReJK4CxV4Zs/OkPhROfSMQH7xOh1TKkCQH
         GuqdICz59UeLHxCOWf5wJUrjptkyA7rLgYExqR+qAnX2Ys5m7WnoyLTYq3Jysh22LpAs
         z/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n2JPmaBmBWVFUUKvWDRn7yx1c4SeQbapiAvfOAswM6I=;
        b=5gKtvo35k8l16eg92BxOaJWu8v7HKb7f9Co3gKk8px0P5dqDYL1KlNQRQqrrD9INfP
         ycsO3MeFVPuXSEz1HSAe41ZmhMOeZ1o3yngnqL4b1RxaAwawaw0PU0YAzZoonG8NwRt5
         kAvdblyAK3bqSAJfz/1Flrt+JM6ViXralnDvFqkf4+xyHBNlHHAq4QUkyQhfnhAe9ht4
         CyXluUmOr5GgMF0a+9fygqzQ9JcsgngdtiY5gCF2nmyOEt4POkfcZHAOKU+vDCEi0xJz
         FN7QKWwIvcTl6xMWTAWSvjAeW43jcHjkUyj///muqRiSa+ej/F4MO/fjONyoNul1pLwA
         Qtxw==
X-Gm-Message-State: AFqh2kpjPx9gLy8zQ5EHF7ONJAKx0ylSSMIhMOCJVhboFJ/P4WcUzKLj
        O/+qfB61ZC47VwZt23cfjH+oXSapp+A=
X-Google-Smtp-Source: AMrXdXtNvOVZ35gBSRD0/lC8Q6An25by8ory3594XRDMBTtYzeBAknHbSSeS4ZCpl2ngYdK2wFX0xw==
X-Received: by 2002:a05:6a00:1906:b0:580:9d4a:4e1c with SMTP id y6-20020a056a00190600b005809d4a4e1cmr92506260pfi.3.1673652714748;
        Fri, 13 Jan 2023 15:31:54 -0800 (PST)
Received: from localhost.localdomain (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id r4-20020aa79624000000b0056bd1bf4243sm14253244pfg.53.2023.01.13.15.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 15:31:54 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Markus Mayer <mmayer@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH ethtool 0/3] Build fixes for older kernel headers and musl
Date:   Fri, 13 Jan 2023 15:31:45 -0800
Message-Id: <20230113233148.235543-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
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

Hi Michal,

These 3 patches fix build issues encountered in the 6.1 release with
either older kernel headers (pre v4.11) or with musl-libc.

In case you want to add a prebuilt toolchain with your release procedure
you can use those binaries:

https://github.com/Broadcom/stbgcc-8.3/releases/tag/stbgcc-8.3-0.4

Florian Fainelli (3):
  misc: Fix build with kernel headers < v4.11
  netlink: Fix maybe uninitialized 'meters' variable
  marvell.c: Fix build with musl-libc

 internal.h       | 1 +
 marvell.c        | 2 +-
 netlink/parser.c | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.34.1

