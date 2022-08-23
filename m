Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E679959D1A8
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 09:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240804AbiHWHCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 03:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiHWHCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 03:02:19 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E474661B10
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 00:02:17 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id c39so16823653edf.0
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 00:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=jIMj0+R4wgnHSrudZyh2WR6IRM8Q8UYFong476gNgIA=;
        b=rfW5OkmffQbojq4XroKzFhYSxgewhgtAzqAljHoMVvfo2wj+YSOO0y0a3KacHuwCDG
         JDHtHYW5c7ZFj2nWSQs+eSAtDXBwcn+igmome7r4atEAenDt9vIuxdK8H8VfBmFG/yKb
         RufY/FobdnhWveE8JK7RDGJR6fGQ18oMruMJG7WAev8xcAeO2PAhwrZnuewQklyQxUp0
         l1q9cq9BrEpZKDKl2Xodgaurxuj0yvXmCgBIi4Xbw3EIid3WJeN6TK2PC0I2hfxnyUfc
         Y7uEHAywID5R6noZb2yR0GoKFnUMHLSY3XuU2me+P3NCm9Vw+vbc8+RosRznCi114AYF
         385g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=jIMj0+R4wgnHSrudZyh2WR6IRM8Q8UYFong476gNgIA=;
        b=u33QOpbWriQFp52BhGzsAom62DvBnCHa6I5GCzFVPfniv9Tq23xKjwtUBFipyevS13
         tzs34JtjhpgZfucFCo0OMcgG0QnrxcUDxvBy+hbe2TAnTcZ43SmX2x7kRZwySI2R/sN1
         iB6QYEJsX4pwUYYstegpXnS8LSQ3CDcJL0Rs1jyXjFa+doPxKbPvZwx/mHjXina+DHXh
         XpapcVQJX+bQOO7REU3ZsHfW895Kzhrvn11h6D0+R+ynLpr/LDL4zUu7gH8kioH+hnko
         0rysCFRFG+slASUyAv2k+iHh/AlUANY5fcY4vvqkkoVlCJeN2WzAnf/X3bhncHZGSX8D
         LnHA==
X-Gm-Message-State: ACgBeo2bBDNmqg+4PSyrnEWflKmqpgfRHVrx7U6ieuw9k7/wmC1UPIg2
        jxzZCYXzzxHl5uxUkM06xYzzb3ArT/Q1vQKT
X-Google-Smtp-Source: AA6agR72GLODubFxFWUvhsBHcRUDR8eT3nMvWdNRC4eWzxty20i+Hm6OPNRjSPM0erYmJr138GZ0+Q==
X-Received: by 2002:a50:fe91:0:b0:43d:c97d:1b93 with SMTP id d17-20020a50fe91000000b0043dc97d1b93mr2502744edt.67.1661238136447;
        Tue, 23 Aug 2022 00:02:16 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c19-20020a056402159300b0043bba5ed21csm915975edv.15.2022.08.23.00.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 00:02:15 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Subject: [patch net-next] Documentation: devlink: fix the locking section
Date:   Tue, 23 Aug 2022 09:02:13 +0200
Message-Id: <20220823070213.1008956-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

As all callbacks are converted now, fix the text reflecting that change.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 Documentation/networking/devlink/index.rst | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index e3a5f985673e..4b653d040627 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -13,10 +13,8 @@ new APIs prefixed by ``devl_*``. The older APIs handle all the locking
 in devlink core, but don't allow registration of most sub-objects once
 the main devlink object is itself registered. The newer ``devl_*`` APIs assume
 the devlink instance lock is already held. Drivers can take the instance
-lock by calling ``devl_lock()``. It is also held in most of the callbacks.
-Eventually all callbacks will be invoked under the devlink instance lock,
-refer to the use of the ``DEVLINK_NL_FLAG_NO_LOCK`` flag in devlink core
-to find out which callbacks are not converted, yet.
+lock by calling ``devl_lock()``. It is also held all callbacks of devlink
+netlink commands.
 
 Drivers are encouraged to use the devlink instance lock for their own needs.
 
-- 
2.37.1

