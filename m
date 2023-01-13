Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D5C668A5F
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 04:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbjAMDrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 22:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbjAMDq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 22:46:56 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5239F5BA3E
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 19:46:53 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id v23so17300427plo.1
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 19:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGY0Ud7lxEA2K2nFB1bOa84NTcJFNuyNcaeOborJ0W0=;
        b=Q1I2kR0MxiClEawHNzam/F4ffVp2b6SD71vlW5hyM8lZ9VuaTXvJMFL1T42wP5sv4N
         4WrCRnmD+sdjhJChPgPyoOLiNSHAUsZBBL2vOTQRcsZDIgfF2JOwwg2IVG7bN/mhyA5g
         x2ZJC4ExovLsD05K5J0oIqKl0p1fzgviWnMHmzsDx4tcYFsgppxczwPE7aFRnysi2Gmm
         RJ/u8GV8zXjZuBBvvKXBkko0ke5T4W53knA5oKdpwO/hVtI2duSg203BJO5sVcXLOlW7
         X23O92HDnwABYXh8ia8WwbjhpuSN9VQwun1jdnP5kl0OHl6GzLZnJEP546r21yWu13d0
         oFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oGY0Ud7lxEA2K2nFB1bOa84NTcJFNuyNcaeOborJ0W0=;
        b=yzw0iU4fU38KOWDLwDmUVooGlDph0vjVhrV+nlpbv76gHgTM2LpmMIH3n0Khef1eDU
         pIvSKFEeqXrAE9830hwzOrmr0XdRpjTmMb0bMzdVWhLoEe5crKSpjudQk/rh+UcEh6EM
         B/YT7exYzF1un15EXbHMVD5oDuyA8QC23mCsh43KodlykQmzEQLw3hi9r0569fyRApgs
         K5hVqgtmwL4Bdf8hcjIkkXWpUzRyG0b1wTSDE/pvItrN8KZndgN75kMb+Qqd5LrWIgja
         M3GBwzkaFM77r7+6C6ckiia2xoKlJHAtkFDGJcHaHBrPXLmhKoAg0kKjfQWpoQuWl6XB
         iMYg==
X-Gm-Message-State: AFqh2kpbh5NxZTKsNt6ViFvNUJI0tcC5MjshcUAnY2yzr+CpjOMh74nH
        WFphBqUrg+j2PRImIw/A5vtOJI2FDYfOWsNi
X-Google-Smtp-Source: AMrXdXspTzWnpYDnF2FusNU0JNwQx0Yz1kfgXLxhNfw/JEVtAfNuMJLa+V10akRLuvPEbhjmgaPHuw==
X-Received: by 2002:a17:902:ec89:b0:185:441e:2314 with SMTP id x9-20020a170902ec8900b00185441e2314mr104749570plg.10.1673581612488;
        Thu, 12 Jan 2023 19:46:52 -0800 (PST)
Received: from localhost.localdomain ([2409:8a02:781c:2330:c2cc:a0ba:7da8:3e4b])
        by smtp.gmail.com with ESMTPSA id u6-20020a170902e80600b0019251e959b1sm12897497plg.262.2023.01.12.19.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 19:46:51 -0800 (PST)
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
Subject: [PATCH iproute2-next 2/2] tc: add new attr TCA_EXT_WARN_MSG
Date:   Fri, 13 Jan 2023 11:46:17 +0800
Message-Id: <20230113034617.2767057-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230113034617.2767057-1-liuhangbin@gmail.com>
References: <20230113034353.2766735-1-liuhangbin@gmail.com>
 <20230113034617.2767057-1-liuhangbin@gmail.com>
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

  Warning: mlx5_core: matching on ct_state +new isn't supported.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/uapi/linux/rtnetlink.h | 1 +
 tc/m_action.c                  | 6 ++++++
 tc/tc_filter.c                 | 5 +++++
 tc/tc_qdisc.c                  | 6 ++++++
 4 files changed, 18 insertions(+)

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
index b3fd0193..7121c2fb 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -590,6 +590,12 @@ int print_action(struct nlmsghdr *n, void *arg)
 
 	open_json_object(NULL);
 	tc_dump_action(fp, tb[TCA_ACT_TAB], tot_acts ? *tot_acts:0, false);
+
+	if (tb[TCA_EXT_WARN_MSG]) {
+		print_string(PRINT_ANY, "Warn", "%s ", rta_getattr_str(tb[TCA_EXT_WARN_MSG]));
+		print_nl();
+	}
+
 	close_json_object();
 
 	return 0;
diff --git a/tc/tc_filter.c b/tc/tc_filter.c
index 71be2e81..dac74f58 100644
--- a/tc/tc_filter.c
+++ b/tc/tc_filter.c
@@ -371,6 +371,11 @@ int print_filter(struct nlmsghdr *n, void *arg)
 		print_nl();
 	}
 
+	if (tb[TCA_EXT_WARN_MSG]) {
+		print_string(PRINT_ANY, "Warn", "%s ", rta_getattr_str(tb[TCA_EXT_WARN_MSG]));
+		print_nl();
+	}
+
 	close_json_object();
 	fflush(fp);
 	return 0;
diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
index 33a6665e..a84602b4 100644
--- a/tc/tc_qdisc.c
+++ b/tc/tc_qdisc.c
@@ -346,6 +346,12 @@ int print_qdisc(struct nlmsghdr *n, void *arg)
 			print_nl();
 		}
 	}
+
+	if (tb[TCA_EXT_WARN_MSG]) {
+		print_string(PRINT_ANY, "Warn", "%s ", rta_getattr_str(tb[TCA_EXT_WARN_MSG]));
+		print_nl();
+	}
+
 	close_json_object();
 	fflush(fp);
 	return 0;
-- 
2.38.1

