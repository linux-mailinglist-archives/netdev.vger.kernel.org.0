Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08DB5EBF9A
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 12:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbiI0KVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 06:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiI0KVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 06:21:18 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08259B7ECA
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 03:21:17 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id y11so8822487pjv.4
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 03:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=vOvcaWFYw/BuL8kew0j3eOoLAAOi7zmndpgkmSX9zXI=;
        b=NmY+GYaXjLCfCSv7JiyWQakGohEFdimfWPp9vlgwCWGXXt7SBpgWBhl3BCYJ6XNAQN
         o3bbnFJenFUKOzLCsNZ0RhL4F0jhSNLZ+pqb2b+hLeBAPF+I/IVYUs8ZdQhXOUbHINkY
         9OyJ2wLQWW9i/eoobBI3VKK57eIsI1cTczYF0GUeecEnoYeG3saXWxWRsUaj+19sJZI8
         S3SH+9didrMwUW/yOKkVfYTTCodVifchk4aETOTsvWNJl8rN9mc3f1EAQUrmwYrkmUBX
         blvf3bGFEfGYXpzI8dI9IeHVVbcrd/YxCSxGZr9ZSbzw1l3eERA4w20V+PkA78p3+GaN
         zukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=vOvcaWFYw/BuL8kew0j3eOoLAAOi7zmndpgkmSX9zXI=;
        b=DN/xtF2UW4BzH8AStlRr/cMpLtul7VC6l8tmEJcVWJiQcz5IZ4jTBkHdN/T4yQwr7M
         GjOVeZpVifXZoACXN6bv2oIutI2/a4EbvaNEOmATYM76sUlqonWPuYyw/WFEep071fVB
         kAXe+aUSF6ChzRAQ2KzIKVysNgVdC2S+0VSagywBOSkgMVerIexfcarE1YU5lNY9lSYt
         NaChGi1ZuJbwkhKWf7scMLoUJY62p4DPeMsSpVSxTmhGt471JARl9TJhtW7RkME5cQKO
         Mg+m1qbIXb1wP3FLvQHZ+iza5SQzjawp5XpSItE/XPpnmMBhV+4QGog65Jv8whoZi9ur
         ru8g==
X-Gm-Message-State: ACrzQf1B+UNZ0yOooxXJZhmvPtQOt5vQcFVqREh0//r2RzluKGw1DuFp
        fTK2g1F1PzyYJGBBBJHz6tVQp5cNGJBQlQ==
X-Google-Smtp-Source: AMsMyM75rXO/W0OIuaWG7YyoEj8GqxyXl6Nd1psKD0P+RkmXno+SdpwsL90KM0fXZq7aDClFdn7kuQ==
X-Received: by 2002:a17:902:ecc6:b0:178:3c7c:18ad with SMTP id a6-20020a170902ecc600b001783c7c18admr26387143plh.112.1664274076371;
        Tue, 27 Sep 2022 03:21:16 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n7-20020a170902e54700b001768517f99esm1132258plf.244.2022.09.27.03.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 03:21:16 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2-next 1/2] libnetlink: add offset for nl_dump_ext_ack_done
Date:   Tue, 27 Sep 2022 18:21:06 +0800
Message-Id: <20220927102107.191852-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220927101755.191352-1-liuhangbin@gmail.com>
References: <20220927101755.191352-1-liuhangbin@gmail.com>
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

There is no rule to have an error code after NLMSG_DONE msg. The only reason
we has this offset is that kernel function netlink_dump_done() has an error
code followed by the netlink message header.

Making nl_dump_ext_ack_done() has an offset parameter. So we can adjust
this for NLMSG_DONE message without error code.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/libnetlink.h | 2 +-
 lib/libnetlink.c     | 9 ++++-----
 lib/mnl_utils.c      | 2 +-
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/libnetlink.h b/include/libnetlink.h
index a7b0f352..1c49920d 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -185,7 +185,7 @@ int rtnl_send(struct rtnl_handle *rth, const void *buf, int)
 int rtnl_send_check(struct rtnl_handle *rth, const void *buf, int)
 	__attribute__((warn_unused_result));
 int nl_dump_ext_ack(const struct nlmsghdr *nlh, nl_ext_ack_fn_t errfn);
-int nl_dump_ext_ack_done(const struct nlmsghdr *nlh, int error);
+int nl_dump_ext_ack_done(const struct nlmsghdr *nlh, unsigned int offset, int error);
 
 int addattr(struct nlmsghdr *n, int maxlen, int type);
 int addattr8(struct nlmsghdr *n, int maxlen, int type, __u8 data);
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index c27627fe..1461b1ca 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -129,13 +129,12 @@ int nl_dump_ext_ack(const struct nlmsghdr *nlh, nl_ext_ack_fn_t errfn)
 	return 0;
 }
 
-int nl_dump_ext_ack_done(const struct nlmsghdr *nlh, int error)
+int nl_dump_ext_ack_done(const struct nlmsghdr *nlh, unsigned int offset, int error)
 {
 	struct nlattr *tb[NLMSGERR_ATTR_MAX + 1] = {};
-	unsigned int hlen = sizeof(int);
 	const char *msg = NULL;
 
-	if (mnl_attr_parse(nlh, hlen, err_attr_cb, tb) != MNL_CB_OK)
+	if (mnl_attr_parse(nlh, offset, err_attr_cb, tb) != MNL_CB_OK)
 		return 0;
 
 	if (tb[NLMSGERR_ATTR_MSG])
@@ -159,7 +158,7 @@ int nl_dump_ext_ack(const struct nlmsghdr *nlh, nl_ext_ack_fn_t errfn)
 	return 0;
 }
 
-int nl_dump_ext_ack_done(const struct nlmsghdr *nlh, int error)
+int nl_dump_ext_ack_done(const struct nlmsghdr *nlh, unsigned int offset, int error)
 {
 	return 0;
 }
@@ -747,7 +746,7 @@ static int rtnl_dump_done(struct nlmsghdr *h,
 			return 0;
 
 		/* check for any messages returned from kernel */
-		if (nl_dump_ext_ack_done(h, len))
+		if (nl_dump_ext_ack_done(h, sizeof(int), len))
 			return len;
 
 		switch (errno) {
diff --git a/lib/mnl_utils.c b/lib/mnl_utils.c
index 79bac5cf..f8e07d2f 100644
--- a/lib/mnl_utils.c
+++ b/lib/mnl_utils.c
@@ -79,7 +79,7 @@ static int mnlu_cb_stop(const struct nlmsghdr *nlh, void *data)
 
 	if (len < 0) {
 		errno = -len;
-		nl_dump_ext_ack_done(nlh, len);
+		nl_dump_ext_ack_done(nlh, sizeof(int), len);
 		return MNL_CB_ERROR;
 	}
 	return MNL_CB_STOP;
-- 
2.37.2

