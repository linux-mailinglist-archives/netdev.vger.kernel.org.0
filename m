Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F3C59C48E
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 19:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236816AbiHVRDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 13:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236319AbiHVRC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 13:02:57 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D39419AF
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:02:56 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id w10so2637515edc.3
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=hE3TQw40VsNVsq40Dxz5mY7v5/vs4c2dK5Xb3FNaFbo=;
        b=w9CRBRdQdXHl9tKMqAnFGYelqQHzctwthGq055QErkagbtq3sJE9pjnUs0ZbhuSw0P
         IzuARJMyhEC2y2l7twxBdM+sqYPlppKNjfKUoH55g0OfuWeJco9T6HNezBfkL+4IvW7M
         5etAYhaBQ1O0U4i4HGXQwGusVuE+KfDM+hjZJzCP3Q/rxXektE8BW3yevdRE1wsChRNu
         mEYufKVLakSEquIfoIlpQ7BSbMH8TcQJAlc2b9BIj+eAYbYehykngYd46EgfTe8sufmn
         SDU4G0DEtK6eJgvO0XSwlIA7pPcUqg5ee4ZFnH2Fo3testJiwdU9kL22CnMvINUh7bIF
         py8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=hE3TQw40VsNVsq40Dxz5mY7v5/vs4c2dK5Xb3FNaFbo=;
        b=QGUrwlJlfX5izfUD7mDzgjOJ7lN0BwGwfUNLQWiVPnSgc3HZQocIjkFT9lm/5zcQFm
         KqWaAOUnFZlbMBm7bYXjOhSjkztm12Ug6ApqxPCezGClS2J+xIg2i0vUh+r/tXqxHyps
         bwfUkggY/CGBemog7ebgZy/Cvd9ij45qS+kDKTTJH2/q6tOlb5torpMjuVrWNvZZ4bVS
         HT9TaxFlyy9gvpLYgXARQzIlsGZY3JzQKb0WR7gfyOO+n+41siq9OU9W3EXp3/b+9e/t
         91W9TCcth0tT2KwklTsCaBwlCl4JiG4FPw5M54+qm2BJ4Mg1oVqrUnAaj7vAHBokGKEo
         MNAA==
X-Gm-Message-State: ACgBeo08pMIO1OtN0oCA17aH1kgAGXMLTlRGFWGu+ZH5/OG7jD+da4iN
        tWGKrCrVIH1uDed7z3plTvnPXxv/PHaWEDGD
X-Google-Smtp-Source: AA6agR4NI+5Spb/tn57UQRxuUDE7y8rpXEcR6EvWv3WTKlnZPmLddLMV/+n0jR+rcSWhEh0//D4NZA==
X-Received: by 2002:a05:6402:206b:b0:446:ce5d:3e60 with SMTP id bd11-20020a056402206b00b00446ce5d3e60mr97523edb.139.1661187775308;
        Mon, 22 Aug 2022 10:02:55 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c15-20020a170906694f00b0073d6cfdc44dsm3102589ejs.115.2022.08.22.10.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 10:02:54 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: [patch net-next v2 4/4] net: devlink: expose the info about version representing a component
Date:   Mon, 22 Aug 2022 19:02:47 +0200
Message-Id: <20220822170247.974743-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220822170247.974743-1-jiri@resnulli.us>
References: <20220822170247.974743-1-jiri@resnulli.us>
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
index 17b78123ad9d..23a5fd92ecaa 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6670,6 +6670,11 @@ static int devlink_info_version_put(struct devlink_info_req *req, int attr,
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
2.37.1

