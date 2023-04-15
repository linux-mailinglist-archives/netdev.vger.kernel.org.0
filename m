Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5146E321E
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 17:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjDOPdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 11:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjDOPdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 11:33:31 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B764C46BF
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 08:33:29 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-187bee46f9dso3960077fac.11
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 08:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681572809; x=1684164809;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xPC7PI/F78iVWdrHUJczCGjYFCY7tR+RLobV70v2dcY=;
        b=0z1SZFYzh5owEfKL7GDmSjSjXgIC8T56vY2HqZQ0STTnQSNRh+Y0jUE2uWCVhWyp+5
         5U7bzkn8RIG8GRaWb0NWtDwxk/jlOSrJBD/jsVQ0Y8TSm9evDCWeOUmWxqjlb0U7BgnD
         LC20ZSVZZYZ57zKzLy/oGMU547ss3KyLo+sgXWFimqGpkI27pDuAh8L+nU5t3iZZ/bZM
         u0qIT0oYFfRmaRKf/x1XzMxnvL/dgprTVpW6R6taMdjLPVJg6mi4pI6FUVpnjWrepUL3
         0J0rc6W3gUNA1/uLYbxniWxzrK/CyudYCF1lnhmmRK10pq3v1bI77t2XU4kTnezCCYIw
         fNTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681572809; x=1684164809;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xPC7PI/F78iVWdrHUJczCGjYFCY7tR+RLobV70v2dcY=;
        b=BC80znjIrs+FoUbA37zwXLz4/6Vw2Lqcvt2kJ699II2VufFmcrepR1dOc9PyXKsWgA
         1wc8OhVZy4dZXROcqy4M0XiNvjr0Jg9AB7H5D6RD2d1bpm7We+3K5GKYpguZxXyZsCdd
         7djR7SdBfis7JUHxoV7wixgR581cs6YcgkShbvcTNua1m5Rr2x9vmcCwlMFVz9H3bwL6
         fQbysjC6sIDcGc6QdxXlLN4iDmKkGjF8nWJaWlzljYnGveITqoZroyYcO6rDpqNq3JSz
         p0v7myAj9gXXUuvDAo29xYgiz9JzuSrXlaA5yUx/gT2+DEWPpwq3SRCYH0DFlv+1UJQi
         uBRg==
X-Gm-Message-State: AAQBX9f+xeoto09uWf7d7obPB6wloiOFuoACRVNdCnVC3KgvU+Q1xHtG
        3dKmWN/9F3p0JA0DLmIjF7MVGN9bFlAv+ksG9TU=
X-Google-Smtp-Source: AKy350b1e6XfbthWAnxJiaQ9TMgHS+qIezdYEx5XX88faH/krSf5/eTR2X0xdkJvVfqo7hAV65Fc4A==
X-Received: by 2002:a05:6870:e0d3:b0:17a:d153:f952 with SMTP id a19-20020a056870e0d300b0017ad153f952mr6324268oab.52.1681572808989;
        Sat, 15 Apr 2023 08:33:28 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:d74d:4b50:b12:b3bc])
        by smtp.gmail.com with ESMTPSA id n11-20020a9d4d0b000000b0069dc250cb24sm2797472otf.3.2023.04.15.08.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 08:33:28 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, marcelo.leitner@gmail.com, paulb@nvidia.com,
        simon.horman@corigine.com, Pedro Tammela <pctammela@mojatatu.com>,
        Palash Oswal <oswalpalash@gmail.com>
Subject: [PATCH net v2] net/sched: clear actions pointer in miss cookie init fail
Date:   Sat, 15 Apr 2023 12:33:09 -0300
Message-Id: <20230415153309.241940-1-pctammela@mojatatu.com>
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

Palash reports a UAF when using a modified version of syzkaller[1].

When 'tcf_exts_miss_cookie_base_alloc()' fails in 'tcf_exts_init_ex()'
a call to 'tcf_exts_destroy()' is made to free up the tcf_exts
resources.
In flower, a call to '__fl_put()' when 'tcf_exts_init_ex()' fails is made;
Then calling 'tcf_exts_destroy()', which triggers an UAF since the
already freed tcf_exts action pointer is lingering in the struct.

Before the offending patch, this was not an issue since there was no
case where the tcf_exts action pointer could linger. Therefore, restore
the old semantic by clearing the action pointer in case of a failure to
initialize the miss_cookie.

[1] https://github.com/cmu-pasta/linux-kernel-enriched-corpus

v1->v2: Fix compilation on configs without tc actions (kernel test robot)

Fixes: 80cd22c35c90 ("net/sched: cls_api: Support hardware miss to tc action")
Reported-by: Palash Oswal <oswalpalash@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/cls_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2a6b6be0811b..35785a36c802 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3235,6 +3235,9 @@ int tcf_exts_init_ex(struct tcf_exts *exts, struct net *net, int action,
 
 err_miss_alloc:
 	tcf_exts_destroy(exts);
+#ifdef CONFIG_NET_CLS_ACT
+	exts->actions = NULL;
+#endif
 	return err;
 }
 EXPORT_SYMBOL(tcf_exts_init_ex);
-- 
2.34.1

