Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7181D679FA2
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbjAXRGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234101AbjAXRGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:06:03 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1CB3D0AB
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:25 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-5063029246dso59437897b3.6
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rIwanKgo4E0WAR8BL+PVZb2lS2OMYRxhD+8AZsvu/3A=;
        b=Epob+MP1pP79V1PEGk72vyW/SpDbckrr1g13LtMsvW9SnV9cd2qut/BOsbdilRS2aQ
         0m7TCH7LirEnHnvchqxqRUjMdyQNb96QZ5wsKYRNH7PhwNe2mlPNwP4wE0yESrDwvUVG
         ooFcn7fd3IemitR5FJxjAgmNZyVwgomoOxLsvnEDXkBVsmJykb/mShjmJwljylxdEQLz
         pkRjNfUj8MOsULu6gkDaGEu8jaabyu3kxvYQpJ+nubE7IeVue1RIdxGp2JG0NEJUr7DW
         TD4szAo9AGFQsYJUBO/4ZHSPfqs5nOCdGkGQ8jWfYhIAno2LkESfcxTQm1EHDl6d4ZQ+
         Kgaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rIwanKgo4E0WAR8BL+PVZb2lS2OMYRxhD+8AZsvu/3A=;
        b=lB4tv+h7ZdgUeDQzlHWyXlgoVMp8lClqNr6WlIyMCfbiIemYel7XRNxEiPtOS9NqA5
         086J4EoD0bPbLtutsk+NKd+fJa6LPELrotCn6uvfvUypezdvrbO5V1o29XAU/YDjtR2m
         wxKXwYD3Bp7BuIIK9vKYCrfyRz04FiMZ9eAQU08b1eg2aOPfLp/0YLb9mCt76k+9hZNB
         SXwknIqq5+1t3CkeyLQgnMsLqa15B1RCykOm+dXetuTIjxOmTqqtTMmtMx2SPRB6P/l+
         ox+KG0j7uin7oCLm/6Z4eTqlsdNLPKgGA6dn4nUICqyLw8YduAw3qCoPTUh8225PxofO
         78FA==
X-Gm-Message-State: AFqh2kp1L30+FozAeJvYKrAPGy4KPvHDPowvaJmGWr1fZeWKklRi4DA/
        y+l7yqwpUWHaLswCKyA9nvj347IZPsVPd8vV
X-Google-Smtp-Source: AMrXdXtf5DgL+RxVo4VHy9JAK/5cm32PLRo7cqyOBEwA2K4Wu7JpSBadNDUZoN2Yp+ybULnjOqTstQ==
X-Received: by 2002:a05:7500:5449:b0:f1:cbd8:62fa with SMTP id e9-20020a057500544900b000f1cbd862famr2370932gac.12.1674579921804;
        Tue, 24 Jan 2023 09:05:21 -0800 (PST)
Received: from localhost.localdomain (bras-base-kntaon1618w-grc-10-184-145-9-64.dsl.bell.ca. [184.145.9.64])
        by smtp.gmail.com with ESMTPSA id t5-20020a05620a0b0500b007063036cb03sm1700208qkg.126.2023.01.24.09.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 09:05:21 -0800 (PST)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com
Subject: [PATCH net-next RFC 09/20] net: introduce rcu_replace_pointer_rtnl
Date:   Tue, 24 Jan 2023 12:04:59 -0500
Message-Id: <20230124170510.316970-9-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124170510.316970-1-jhs@mojatatu.com>
References: <20230124170510.316970-1-jhs@mojatatu.com>
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

We use rcu_replace_pointer(rcu_ptr, ptr, lockdep_rtnl_is_held()) throughout the
P4TC infrastructure code.

It may be useful for other use cases, so we create a helper.

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/linux/rtnetlink.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index 92ad75549..56a1e80fe 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -71,6 +71,18 @@ static inline bool lockdep_rtnl_is_held(void)
 #define rcu_dereference_bh_rtnl(p)				\
 	rcu_dereference_bh_check(p, lockdep_rtnl_is_held())
 
+/**
+ * rcu_replace_pointer_rtnl - replace an RCU pointer under rtnl_lock, returning
+ * its old value
+ * @rcu_ptr: RCU pointer, whose old value is returned
+ * @ptr: regular pointer
+ *
+ * Perform a replacement under rtnl_lock, where @rcu_ptr is an RCU-annotated
+ * pointer. The old value of @rcu_ptr is returned, and @rcu_ptr is set to @ptr
+ */
+#define rcu_replace_pointer_rtnl(rcu_ptr, ptr) \
+	rcu_replace_pointer(rcu_ptr, ptr, lockdep_rtnl_is_held())
+
 /**
  * rtnl_dereference - fetch RCU pointer when updates are prevented by RTNL
  * @p: The pointer to read, prior to dereferencing
-- 
2.34.1

