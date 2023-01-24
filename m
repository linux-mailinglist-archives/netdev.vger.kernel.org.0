Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61351679F9C
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbjAXRFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233688AbjAXRFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:05:41 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5F4402E0
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:17 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-5063029246dso59431467b3.6
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QAT4Ji26McrOf8UEVabzWZhhaqB5tgWmmew2tKOuC5Y=;
        b=bI7MX+zgBMy5bXCNG5gu2rpF2cEq819dJuEkbVNo7Da+8TMbUvdEo19/fKwn/HBNI6
         PXA7s02ZwS0e6koTmykyU1lDDlejE+6KE7cqiJ3yoffmHWH8DqXitMjt7xeYAjTAG65m
         zpLEP7zUfYd6GfUmY/7OVjKl6UCeGQTSAeuSEjtXaWDs+hbP+Hg+imNruIQ2mR5w49a3
         78P9j8QkeaN3xGIyFOcJCjovsXtFNs2b45eloa0+idTZQnyzxC3EHM5KdcwUJ0RjmAz9
         YG1Z/psRfRLQzT1eg5UZxR8WHwQZ51ohnyWQCk1kzT56N+T5WSUmwCZ5S8U+wiqXc3l8
         sxAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QAT4Ji26McrOf8UEVabzWZhhaqB5tgWmmew2tKOuC5Y=;
        b=CNGwhc/BaKNeISUyOvt9b1xd7artES/TyXS9Z6vQgTSnMR0qfwaec0T3xJyVM8C4+F
         7d0atXyQ4SOV/DLSFXhCLnO92LANpCJ0TBS+dy+p0TTdCG7Hw3rAy8ySJSA7f6CaBpqp
         Ja7v36483ss9uLAJtwDk9+s6EhWQWkMy6HBYHbOFAvwEJu9Yc4PCNle7zEblBOqmTDZ/
         bJw6Dt2Mmha1nS2QjNlsO62bJoHZXy3pOZ0rFwo9484L4cURdaeWYM8AGq5JRRTlwyXD
         D/Wzte+Bsdikr1HiB3+E2gqAyGGsbZPIsKFbV24lZYQVUmJvmthA25vRRAd+ZKDFSPxA
         +nXg==
X-Gm-Message-State: AO0yUKVJa0Xkou5CEpIF7SvNPme1iuIfvnvzZp8ygxxAE4sIvilqFeQY
        uRUjHLVQoJAHH/zIn8D81gm2DytanPFmStlk
X-Google-Smtp-Source: AK7set9LSf2PnkB5VCd/oqDiFtM3gu5PVZRWeRucqdv7cAmEg0HreEy8CMkQRvY++vis0BZWTnHqaw==
X-Received: by 2002:a05:7500:6715:b0:f3:2bd5:46bb with SMTP id jd21-20020a057500671500b000f32bd546bbmr348309gab.16.1674579914096;
        Tue, 24 Jan 2023 09:05:14 -0800 (PST)
Received: from localhost.localdomain (bras-base-kntaon1618w-grc-10-184-145-9-64.dsl.bell.ca. [184.145.9.64])
        by smtp.gmail.com with ESMTPSA id t5-20020a05620a0b0500b007063036cb03sm1700208qkg.126.2023.01.24.09.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 09:05:13 -0800 (PST)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com
Subject: [PATCH net-next RFC 03/20] net/sched: act_api: increase TCA_ID_MAX
Date:   Tue, 24 Jan 2023 12:04:53 -0500
Message-Id: <20230124170510.316970-3-jhs@mojatatu.com>
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

Increase TCA_ID_MAX from 255 to 1023

Given P4TC dynamic actions required new IDs (dynamically) and 30 of those are
already taken by the standard actions (such as gact, mirred and ife) we are left
with 225 actions to create, which seems like a small number.

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/uapi/linux/pkt_cls.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 5b66df3ec..5d6e22f2a 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -142,7 +142,7 @@ enum tca_id {
 	TCA_ID_GATE,
 	TCA_ID_DYN,
 	/* other actions go here */
-	__TCA_ID_MAX = 255
+	__TCA_ID_MAX = 1023
 };
 
 #define TCA_ID_MAX __TCA_ID_MAX
-- 
2.34.1

