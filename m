Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0F557BDE8
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiGTSgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiGTSgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:36:23 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68EF24F32;
        Wed, 20 Jul 2022 11:36:22 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id i4so4485272qvv.7;
        Wed, 20 Jul 2022 11:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HPeYSdLMZT+6W1Gp0j/AA9ejO/vKKFcG0EGruC4oxBs=;
        b=S3A9m6TpEfdtkhsqZJmEjb656ZP4EaQCjAO814g97J4LyB1h056UU56aIu1mTH+l39
         mL0NhJamHPCw2YJuWSIz/UrZNgbeb1uJ/w1HdTpA5A9HkSrfVP0Vfaghj/0F6ALEDIub
         lwL/i+t8EFUE+GSIrxxNtAq74CI6oxp+y0ooJP+fxWdszXZtHl5f24jpUx7WnCb0YxnE
         8ssWvgHLi58K480NUAhjQat320062zr/gUASS3Dx54+piCWpWA89cm0g0edQsLq0u73C
         8ozx7PHVHz3Os+PrX63HHuR4BQ+jImeBUvq6ey3I3e+nNbQS6tueHi618fcCdPXXTCn1
         3/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HPeYSdLMZT+6W1Gp0j/AA9ejO/vKKFcG0EGruC4oxBs=;
        b=YBbcbwQT8lqnZv/AKUlsBiK8T5rm8lZNopY3L7QcMDME90bdi18zqKXa2iMv+WpZSs
         n1vh0rLxUCfhNPnnwtxjyBRZCWIlP+8ouSAtKxUjKJVQkSGEpAS/dj4PRMH5uCXE2VaD
         EfPRqQ8Zc4AH8Y3b2/52HvHzTWaS0affuM5ZndYty64ExVdjP8qTXF8dCFRUBT1idd7R
         +jofnvJzmNavy4pwQFy9Qag32/O2BHvWAk0pU5X9rey72zt3b4L2vhEXRgVItwerKT/G
         5NkktR3rMb4TJonU6H6PBFzulsz7llio4nkN5We45WTff+F0ZykHqkspAibm00pFmEBW
         Lbjw==
X-Gm-Message-State: AJIora/z5G7HTNSkDqDfX/c2tuW5xHpAUTded7f6Dy5qdtcH3cskmj+Y
        vyKixc8IGlYnImTYPVATD/9V2FkOY+8xmvRT
X-Google-Smtp-Source: AGRyM1taQ2C4BC6EckZId+axoYQ6k+9+KpfusR1XS68Irmw/kAP+HZaPiQ5VMvCO3q78bNWXHhsrfQ==
X-Received: by 2002:a05:6214:f27:b0:474:b51:1a82 with SMTP id iw7-20020a0562140f2700b004740b511a82mr1163643qvb.114.1658342181012;
        Wed, 20 Jul 2022 11:36:21 -0700 (PDT)
Received: from debian.nc.rr.com (2603-6080-6501-6000-7ddc-2220-f20b-c436.res6.spectrum.com. [2603:6080:6501:6000:7ddc:2220:f20b:c436])
        by smtp.gmail.com with ESMTPSA id d3-20020ac851c3000000b0031ecb90454fsm12718402qtn.70.2022.07.20.11.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 11:36:20 -0700 (PDT)
From:   Jaehee Park <jhpark1013@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        dsahern@gmail.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, linux-kernel@vger.kernel.org,
        aajith@arista.com, roopa@nvidia.com, roopa.prabhu@gmail.com,
        aroulin@nvidia.com, sbrivio@redhat.com, jhpark1013@gmail.com,
        nicolas.dichtel@6wind.com
Subject: [PATCH v2 net-next] net: ipv6: avoid accepting values greater than 2 for accept_untracked_na
Date:   Wed, 20 Jul 2022 14:36:32 -0400
Message-Id: <20220720183632.376138-1-jhpark1013@gmail.com>
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
v2
- got rid of unnecessary void cast in extra1 and extra2

 net/ipv6/addrconf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6ed807b6c647..b624e3d8c5f0 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7042,9 +7042,9 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.data		= &ipv6_devconf.accept_untracked_na,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-		.extra1		= (void *)SYSCTL_ZERO,
-		.extra2		= (void *)SYSCTL_ONE,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_TWO,
 	},
 	{
 		/* sentinel */
-- 
2.30.2

