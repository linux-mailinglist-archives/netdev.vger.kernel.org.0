Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFFE5857F5
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 04:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbiG3CWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 22:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiG3CWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 22:22:09 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC0678DDC;
        Fri, 29 Jul 2022 19:22:08 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id p14-20020a17090a74ce00b001f4d04492faso633330pjl.4;
        Fri, 29 Jul 2022 19:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=qvlSFDuVcQPe2p0wkv4esqHUa+wl6CPqM/sYrzmNhGU=;
        b=atcUj8Zj1KTXktZ9QtZDtVOMLD+wIgTB4dcVks8OTQpLNoj2QLy/fxRHkILV89lfeP
         PrSFWciKs7bl/LHqA2g0sQFGsvevnle5vHPPZ/I27jRQmJ/jo1obg3D0RLGzsNElQw1n
         Wa2zMYSh5fo47RBG++1V0apR0P2Hr10z6XY3OVCuYVJLlCOaNjCdNXp+w3e5z7/3Xi69
         RnUhb+5R8yeh9SrcQahZmd2MczvKm1iOnukP6mGTutKsvpJlHg+jeUkMmRAEAKZtDfth
         kCf4M9Vi3dXjYUoUZNyvGy6Iyeur04eipuY2RmJusxcUyuG3MArNYXZ9CaSFhxNY6gbT
         aPcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=qvlSFDuVcQPe2p0wkv4esqHUa+wl6CPqM/sYrzmNhGU=;
        b=Jw0Vwmn+reGpE0CBP7ABDRwJmueOy7x5PU/bcX0zZG1uK6k9geMdSzL8Ca5Tv8JMiX
         s6IDRoU4avi4bFVTb42Tp6FzKSkGqnC+MbfbAlOy2+885zbn3UK+B3a9HeSCcxQEP8ch
         9FL0VBR6/tk1KLMsYAjVXnzBmlebaxjgpnjir4gnZ6/JagVFdQMH/q4LCLuK0MSHz/d7
         bvPWHiZIanSKnSvHrc3WJqvsjrpsKVM81Y06j0/nQqSNdxBBTBEBRUISg7EljWNIBAD/
         j5xKAouQhjrE55iUNYCf14Vveluhp8p/uGbryj8V+aPQ65yVytOSNMtutGMRAQz7h6z3
         NnDA==
X-Gm-Message-State: ACgBeo0it89MyPkzbW6yu0FlZ2PO86MEYApn9ndN8ARdvg33Irl+EUok
        UQoEU0KOSlL8Ov5YwL2nwvc=
X-Google-Smtp-Source: AA6agR5/NqhgsA5YXYUibbZAKLuh8ntUvo92HXKUk6pLDvfnQJuY4Yohu25+jtwPDIQcUCz6V6Q8mg==
X-Received: by 2002:a17:902:cccf:b0:168:c4c3:e8ca with SMTP id z15-20020a170902cccf00b00168c4c3e8camr6643718ple.40.1659147727930;
        Fri, 29 Jul 2022 19:22:07 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-86.three.co.id. [180.214.233.86])
        by smtp.gmail.com with ESMTPSA id o24-20020a170902779800b0016bd8f66ca0sm4283096pll.162.2022.07.29.19.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 19:22:07 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 1C9C210495F; Sat, 30 Jul 2022 09:21:13 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     netdev@vger.kernel.org, linux-doc@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] Documentation: devlink: add add devlink-selftests to the table of contents
Date:   Sat, 30 Jul 2022 09:20:57 +0700
Message-Id: <20220730022058.16813-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 08f588fa301bef ("devlink: introduce framework for selftests") adds
documentation for devlink selftests framework, but it is missing from
table of contents.

Add it.

Link: https://lore.kernel.org/linux-doc/202207300406.CUBuyN5i-lkp@intel.com/
Fixes: 08f588fa301bef ("devlink: introduce framework for selftests")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/networking/devlink/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 85071551229362..e3a5f985673efd 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -38,6 +38,7 @@ general.
    devlink-region
    devlink-resource
    devlink-reload
+   devlink-selftests
    devlink-trap
    devlink-linecard
 

base-commit: 6957730e20389a63eb333afb6fcf38b45f549ea8
-- 
An old man doll... just what I always wanted! - Clara

