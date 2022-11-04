Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B3D619B81
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbiKDPZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbiKDPYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:24:52 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6253A2B25C
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 08:24:29 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id a13so8177155edj.0
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 08:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JVU7TnXd5cogkDgCDXra7nnkaaEFn78CxwiCWNKiLHE=;
        b=WA+t5n/vbTIKaQfHMLkPNWqUlNX56cat+oF/BOX/wpc3od6g+jVbVQI/eDvqnwZvio
         nKS85x4aeslwFcaRGr9BDPVIxlF3rIUfj8Zkc8wZWbE/qikD8Mx+O1Bvs0vIq1eUT9hI
         77uteI4GADBTLPY/aecgdYD+clneNCm8xC6vQ/K28xn9VjNI5NjGGOhVCfzvHUJHMSis
         qkVDcY12FMzqf9ehAFIyDpp3ib/hcjdnpwF6271EMMi9C3ffTt/1/P15OdYIn/ufCLDA
         R/KBXDE9Tf4bGyp1qYNF75px49zIcVZy2lPeSaH0ZR2puLlH/cIl3/DEbyeiYi4lLwp1
         uxlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JVU7TnXd5cogkDgCDXra7nnkaaEFn78CxwiCWNKiLHE=;
        b=gcUtE0Gr+tt6/bZ/cUCYRgOJ0mjGwoeM8NqFop2GUC3JXDoydDeKXEE0DCS6h+Ze6L
         h1GQ6/KivjLFcXFPGd65dKsHfACAyrT5u2FeNIvOkOyslR2t0FJ4H50QAqs36JgOBLgJ
         tfPJ9m//OAYO6+zgxSLXoMAYMbbVkEJFQe8ruMhALcGk+rJIRxbFbPs2JJtbeZib0RAw
         TORkLVidWkxp6efGkzNshGjsfTUMggS1jliQoBqG7zX7bNykLBBnRZO22ioLw//z5dD2
         oj+9ymDisZFEO8cWeoYjwWbYXPHgNbkdfXWxUEHbL4UUphjs9bDh+TwhKs6FONyUtVTG
         YwOQ==
X-Gm-Message-State: ACrzQf2ub5FlJSGTcMSE4lKnE66+fsUait5W60U/UnTR3oLBtmrkCuzI
        mHctJ/ZocWpW2u3QRtN/fgkWPzFsfk8fe9sH
X-Google-Smtp-Source: AMsMyM46j8bdz+GmKlUIReaiBV3eR4uS8W2wcVvmGm2rGD1kdiFR+uLxadtNtpbKx9U2ZovDmTk+Ig==
X-Received: by 2002:a05:6402:50d3:b0:461:ba8a:8779 with SMTP id h19-20020a05640250d300b00461ba8a8779mr36801244edb.411.1667575467823;
        Fri, 04 Nov 2022 08:24:27 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 1-20020a170906310100b007933047f923sm1941259ejx.118.2022.11.04.08.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 08:24:27 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Subject: [patch net-next] net: devlink: expose the info about version representing a component
Date:   Fri,  4 Nov 2022 16:24:25 +0100
Message-Id: <20221104152425.783701-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
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

From: Jiri Pirko <jiri@nvidia.com>

If certain version exposed by a driver is marked to be representing a
component, expose this info to the user.

Example:
$ devlink dev info
netdevsim/netdevsim10:
  driver netdevsim
  versions:
      running:
        fw.mgmt 10.20.30
      flash_components:
        fw.mgmt

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/uapi/linux/devlink.h | 2 ++
 net/core/devlink.c           | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 2f24b53a87a5..7f2874189188 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -607,6 +607,8 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_SELFTESTS,			/* nested */
 
+	DEVLINK_ATTR_INFO_VERSION_IS_COMPONENT,	/* u8 0 or 1 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2dcf2bcc3527..31bca879f9cf 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6621,6 +6621,11 @@ static int devlink_info_version_put(struct devlink_info_req *req, int attr,
 	if (err)
 		goto nla_put_failure;
 
+	err = nla_put_u8(req->msg, DEVLINK_ATTR_INFO_VERSION_IS_COMPONENT,
+			 version_type == DEVLINK_INFO_VERSION_TYPE_COMPONENT);
+	if (err)
+		goto nla_put_failure;
+
 	nla_nest_end(req->msg, nest);
 
 	return 0;
-- 
2.37.3

