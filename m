Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81BE6A0BBB
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 15:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbjBWOSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 09:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234816AbjBWORr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 09:17:47 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CE2584BA
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 06:17:29 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id l13-20020a0568301d6d00b0068f24f576c5so2272258oti.11
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 06:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aOU8xNj//HSRlxwsJ2XsaILVRQ3NoR7U1O1mBMCAtz0=;
        b=bVg3HoVcxQF0Zv6JMxuRrfFHvE9pIMv9/NpUkZap3RhjI+565ekc1Qp9cgwAscBuKt
         3+Zxt4Kw9dII68l4JH01MxPUJnOBlxT6HQTuNpqb7mcgcsIJ79Pfj7fg3vowZxwDy0n3
         FjITnf5kLMaIDrO7PXl7WXOqJ9C+epIbKCpByadn14Btnl+FoZDn1JF/QntQaepDclZI
         0Rn3WPMah8eYaGLVtB7oNUmIFfP6CJTShTDz+e0yfxoXeaDO/2Xke4oZ7R993zPVFLZx
         RfNNqHUUEdroGZKqHPIZYepSOS021TReH5LMtfRaois5ZvPXyZN4ywIAMuA/x1zWsE+z
         lJtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aOU8xNj//HSRlxwsJ2XsaILVRQ3NoR7U1O1mBMCAtz0=;
        b=JhcHm3/lD5h/nQ1y7rzgABbwPHvkea4b/tePWiKPv8ji9uueHWuyCCeBAnKCb7QWKh
         6IjiQ4/VqgfkrhFYrVyREzSQ5iW8A8ZHHtOdU/VBq7CWg/uln73+2joz9kPpH+VOj/DN
         rXPqBjpmxkvh/54vlNHvqe9SvOsaObKZi6eu2aSl9DNw2W5xTci3JKO+cj/7poMz2MVK
         DZQyREgWR0j1O9ELLtm0SWg4nP5dD1vlhLW29emv+D3taFSSC7V33VxGc0Q8R2GoPT3r
         NOCDUFiNohKVQ8+nrq6Np/KWi3wNHAYYOFDEmuLcWOBg2dA/NzAc7kkWAHn8s9tf1P2q
         sTRg==
X-Gm-Message-State: AO0yUKVvJP0IoIIBQrK0n5yEAxW5xylletoLxC4thTikRacPBcgZQ0AF
        rR+KzkxdtmVTlNljpvH/Kz1Ag6FkQAAAxp8I
X-Google-Smtp-Source: AK7set9918FdDtdwmtXTrBZeJk9uaB7Lzl7yEPo4SnJM4GKti1e2JKa9PYaZ4M9iB+3mQfHXlSW4hw==
X-Received: by 2002:a9d:2ac:0:b0:693:d927:645e with SMTP id 41-20020a9d02ac000000b00693d927645emr145626otl.6.1677161848537;
        Thu, 23 Feb 2023 06:17:28 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:a085:92da:6e98:9c14])
        by smtp.gmail.com with ESMTPSA id h17-20020a056830035100b0068bd922a244sm2812832ote.20.2023.02.23.06.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 06:17:28 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, error27@gmail.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net] net/sched: act_connmark: handle errno on tcf_idr_check_alloc
Date:   Thu, 23 Feb 2023 11:16:39 -0300
Message-Id: <20230223141639.13491-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
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

Smatch reports that 'ci' can be used uninitialized.
The current code ignores errno coming from tcf_idr_check_alloc, which
will lead to the incorrect usage of 'ci'. Handle the errno as it should.

Fixes: 288864effe33 ("net/sched: act_connmark: transition to percpu stats and rcu")
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_connmark.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 8dabfb52ea3d..cf4086a9e3c0 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -125,6 +125,7 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 	if (!nparms)
 		return -ENOMEM;
 
+	ci = to_connmark(*a);
 	parm = nla_data(tb[TCA_CONNMARK_PARMS]);
 	index = parm->index;
 	ret = tcf_idr_check_alloc(tn, &index, a, bind);
@@ -137,14 +138,11 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 			goto out_free;
 		}
 
-		ci = to_connmark(*a);
-
 		nparms->net = net;
 		nparms->zone = parm->zone;
 
 		ret = ACT_P_CREATED;
 	} else if (ret > 0) {
-		ci = to_connmark(*a);
 		if (bind) {
 			err = 0;
 			goto out_free;
@@ -158,6 +156,9 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 		nparms->zone = parm->zone;
 
 		ret = 0;
+	} else {
+		err = ret;
+		goto out_free;
 	}
 
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
-- 
2.34.1

