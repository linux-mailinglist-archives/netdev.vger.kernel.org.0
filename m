Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3706BC4FB
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjCPDxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjCPDxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:53:11 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9754DE1B
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:53:09 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso3891779pjb.3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678938789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sU26Dg4ggrvhrzGmTqPw5WDInv7gXZb5PSIjlbyR27g=;
        b=fmW9r8tmcSypD9sAFMAMtB5IKkRJJSVevb+huYTGs6MOVX5/ZM7JoAAtAayoQGgm0I
         IdVpQU+y4aaSEQZyhlHsT/je5Lf2VmRviyoi6ZpxEd1K46tN+X2ZNphD71DhApoTJ+BO
         CM4uMNfhQE6r0+p1rL6HZ/3In5zcxsz2p3P5N0ThCRMcNaQ8JbbFQs943u7JyFnqxehT
         NQw8TDNOyGGU9iDILWXojyJOr1Q15A7ARBZz+TH/C6gJ1Dz+pC1WvXqOCZnVH28PqZ7K
         uiPzXMv/prCp2wR4sQbDKZA7YAPAn8AymRW8+r5VzgqOsWiJDVOwmLCvKUwFNUx4TYGi
         VQ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678938789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sU26Dg4ggrvhrzGmTqPw5WDInv7gXZb5PSIjlbyR27g=;
        b=oMg0vgMcYIItHqxNW+An5AnfmPdrl2j4F10cZHpYHPrTgO84hPeXlalyBHzH7s+7Q5
         OElGMxpkFCrB/Nmo+Ln6eyR/yvFtaEiS0TJAoTwfAlFSLwJcNQ+yFGiddEnKxuRpL+6c
         tyrWDN2fNjtldEhveHGSD0Pr0NnCIzAvTyIlU5gbMORfdDArO7ZiDBND7AO2B/dzna4t
         hQKvZNfpwQAZ5Bst6Me98NoYYSr8ACdBzHO2KDc2dhIbng6FzmpDa4pb463+CoRi631U
         lb/hpn7EH2npFEiCNV9mpr3Yzm7sys649djlH4IbVCeiM4tMfS8SDzrd493XmNCabTKi
         YypA==
X-Gm-Message-State: AO0yUKUELCVPJChyV+J42z4Fh2JD3pm3F2srzS5hTP5B4qdFD9vWREaB
        C8+4nU9EDe8Q4ElBIxeb+2rA0F1NMXkFDTAL
X-Google-Smtp-Source: AK7set99E2g5WL/6wM7tBV8oqgRdwmXobbKT0ahYnVLWfgQPYvGMa4WrKn9x7lzGl1osgPanjzAPmg==
X-Received: by 2002:a17:903:1c6:b0:19e:6659:90db with SMTP id e6-20020a17090301c600b0019e665990dbmr1759528plh.45.1678938788923;
        Wed, 15 Mar 2023 20:53:08 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id kb14-20020a170903338e00b001990028c0c9sm4393923plb.68.2023.03.15.20.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 20:53:08 -0700 (PDT)
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
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Andrea Claudi <aclaudi@redhat.com>
Subject: [PATCHv2 iproute2 2/2] tc: m_action: fix parsing of TCA_EXT_WARN_MSG by using different enum
Date:   Thu, 16 Mar 2023 11:52:42 +0800
Message-Id: <20230316035242.2321915-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230316035242.2321915-1-liuhangbin@gmail.com>
References: <20230316035242.2321915-1-liuhangbin@gmail.com>
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

We can't use TCA_EXT_WARN_MSG directly in tc action as it's using different
enum with filter. Let's use a new TCA_ROOT_EXT_WARN_MSG for tc action
specifically.

Fixes: 6035995665b7 ("tc: add new attr TCA_EXT_WARN_MSG")
Reviewed-by: Andrea Claudi <aclaudi@redhat.com>
Reported-and-tested-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: rename TCA_ACT_EXT_ to TCA_ROOT_EXT_
---
 include/uapi/linux/rtnetlink.h | 1 +
 tc/m_action.c                  | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 217b25b9..2132e941 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -787,6 +787,7 @@ enum {
 	TCA_ROOT_FLAGS,
 	TCA_ROOT_COUNT,
 	TCA_ROOT_TIME_DELTA, /* in msecs */
+	TCA_ROOT_EXT_WARN_MSG,
 	__TCA_ROOT_MAX,
 #define	TCA_ROOT_MAX (__TCA_ROOT_MAX - 1)
 };
diff --git a/tc/m_action.c b/tc/m_action.c
index 0400132c..a446cabd 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -586,7 +586,13 @@ int print_action(struct nlmsghdr *n, void *arg)
 
 	open_json_object(NULL);
 	tc_dump_action(fp, tb[TCA_ACT_TAB], tot_acts ? *tot_acts:0, false);
-	print_ext_msg(tb);
+
+	if (tb[TCA_ROOT_EXT_WARN_MSG]) {
+		print_string(PRINT_ANY, "warn", "%s",
+			     rta_getattr_str(tb[TCA_ROOT_EXT_WARN_MSG]));
+		print_nl();
+	}
+
 	close_json_object();
 
 	return 0;
-- 
2.38.1

