Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF6C66D6C9
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 08:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235527AbjAQHTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 02:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235021AbjAQHTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 02:19:43 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4164C23309
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 23:19:42 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id v3so21294891pgh.4
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 23:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UDdGPkOGC5l/xGfxqZfBI3fry823oIzZmfvwZH/7SLI=;
        b=Y/gUzbREagdG926Re2LiSAhulMNm36siRyHizeq2YL8pUZ1hM96dzmoWr+11fyRzGW
         ajmvs67adMm/XQBm1U1LGqz49krcyv9MGtus7NHG5tnyJwqXEv7xxPLpH6S1kgE0HuDL
         xvpNeg4UVbebYYoCDPaJdbigi3cVGpy1+Z5OposUx0UhXojIyLboOxNO7sveHMOi0Ey4
         /ZNiKl9BDArUfqfTjGxAH9QbXTlZ3CujEBxGdZ9z49kTSFM3rkErIEq6w0O5rm92rY0e
         LIz8CAuNWKwby9aKMP8PyRw3jkN5j7gtCo4lRWJdXeRSZxgjiELVQPFAFaX5kLLQ33YC
         YIPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UDdGPkOGC5l/xGfxqZfBI3fry823oIzZmfvwZH/7SLI=;
        b=JnZsbHTEjeDm2SG0JQlwIRrWR1e/WLBSec6rSjb4MX6EEzSmEAvpfFQHYy5d9q8FNL
         Ecl2DWDKjLX2cNwlRW8r43yfpEV1O95bvQW8/uPFocyrvZM/CS9rPf97FB7LfbNf74+D
         GgAO0BtbAh1pfBwn9mdDxyVNe/sgh9t/1GE6CJTvRqOkN5t/zMGN/tmkewGS/lY/k0EM
         AzQrbgaiJd683sbk5eCTd80uMyiX8G4xdv6LNgxlgVwuiCHX0qwNOgIXJUvi0t22VFsw
         L49Kce61p2Laicc7cy/yfyG1rABadVQmyPyAk/ae5ZQDUeo+Tt2+hiE28Z3ws57ebVGm
         g+Mg==
X-Gm-Message-State: AFqh2kqUAVmk9zLh9n+xuKa0fKepyv/YPdGrysaj0Sc1yyvfayUnANfo
        CSdXXYHqX999Z94ApztoO4hGP326AGHAHQPE
X-Google-Smtp-Source: AMrXdXsJ1mdXpc75XfgGfmsSCeZU3wrTxCO63jnSKM+S9CjrK9k4kSPC/1WR+Bv2br8viQDGAo+ONw==
X-Received: by 2002:aa7:9a50:0:b0:589:b85:1e32 with SMTP id x16-20020aa79a50000000b005890b851e32mr2556623pfj.16.1673939981193;
        Mon, 16 Jan 2023 23:19:41 -0800 (PST)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id f12-20020aa7968c000000b005871b73e27dsm5972552pfk.33.2023.01.16.23.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 23:19:40 -0800 (PST)
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
        Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 iproute2-next 2/2] tc: add new attr TCA_EXT_WARN_MSG
Date:   Tue, 17 Jan 2023 15:19:25 +0800
Message-Id: <20230117071925.3707106-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230117071925.3707106-1-liuhangbin@gmail.com>
References: <20230113034353.2766735-1-liuhangbin@gmail.com>
 <20230117071925.3707106-1-liuhangbin@gmail.com>
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

Currently, when the rule is not to be exclusively executed by the
hardware, extack is not passed along and offloading failures don't
get logged. Add a new attr TCA_EXT_WARN_MSG to log the extack message
so we can monitor the HW failures. e.g.

  # tc monitor
  added chain dev enp3s0f1np1 parent ffff: chain 0
  added filter dev enp3s0f1np1 ingress protocol all pref 49152 flower chain 0 handle 0x1
    ct_state +trk+new
    not_in_hw
          action order 1: gact action drop
           random type none pass val 0
           index 1 ref 1 bind 1

  mlx5_core: matching on ct_state +new isn't supported.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: Add a helper to print the warn message. I still print the msg in
json ojbect given the disscuss in
https://lore.kernel.org/all/20230114090311.1adf0176@hermes.local/
---
 include/uapi/linux/rtnetlink.h | 1 +
 tc/m_action.c                  | 1 +
 tc/tc_filter.c                 | 1 +
 tc/tc_qdisc.c                  | 2 ++
 tc/tc_util.c                   | 9 +++++++++
 tc/tc_util.h                   | 2 ++
 6 files changed, 16 insertions(+)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index f4a540c0..217b25b9 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -635,6 +635,7 @@ enum {
 	TCA_INGRESS_BLOCK,
 	TCA_EGRESS_BLOCK,
 	TCA_DUMP_FLAGS,
+	TCA_EXT_WARN_MSG,
 	__TCA_MAX
 };
 
diff --git a/tc/m_action.c b/tc/m_action.c
index b3fd0193..b45c4936 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -590,6 +590,7 @@ int print_action(struct nlmsghdr *n, void *arg)
 
 	open_json_object(NULL);
 	tc_dump_action(fp, tb[TCA_ACT_TAB], tot_acts ? *tot_acts:0, false);
+	print_ext_msg(tb);
 	close_json_object();
 
 	return 0;
diff --git a/tc/tc_filter.c b/tc/tc_filter.c
index 71be2e81..cfc72c00 100644
--- a/tc/tc_filter.c
+++ b/tc/tc_filter.c
@@ -371,6 +371,7 @@ int print_filter(struct nlmsghdr *n, void *arg)
 		print_nl();
 	}
 
+	print_ext_msg(tb);
 	close_json_object();
 	fflush(fp);
 	return 0;
diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
index 33a6665e..faa8daed 100644
--- a/tc/tc_qdisc.c
+++ b/tc/tc_qdisc.c
@@ -346,6 +346,8 @@ int print_qdisc(struct nlmsghdr *n, void *arg)
 			print_nl();
 		}
 	}
+
+	print_ext_msg(tb);
 	close_json_object();
 	fflush(fp);
 	return 0;
diff --git a/tc/tc_util.c b/tc/tc_util.c
index d2622063..aee25f0b 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -848,3 +848,12 @@ void print_masked_be16(const char *name, struct rtattr *attr,
 	print_masked_type(UINT16_MAX, __rta_getattr_be16_u32, name, attr,
 			  mask_attr, newline);
 }
+
+void print_ext_msg(struct rtattr **tb)
+{
+	if (!tb[TCA_EXT_WARN_MSG])
+		return;
+
+	print_string(PRINT_ANY, "warn", "%s", rta_getattr_str(tb[TCA_EXT_WARN_MSG]));
+	print_nl();
+}
diff --git a/tc/tc_util.h b/tc/tc_util.h
index a3fa7360..c535dccb 100644
--- a/tc/tc_util.h
+++ b/tc/tc_util.h
@@ -133,4 +133,6 @@ void print_masked_u8(const char *name, struct rtattr *attr,
 		     struct rtattr *mask_attr, bool newline);
 void print_masked_be16(const char *name, struct rtattr *attr,
 		       struct rtattr *mask_attr, bool newline);
+
+void print_ext_msg(struct rtattr **tb);
 #endif
-- 
2.38.1

