Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5176A499D
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjB0SXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjB0SXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:23:46 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FAD20682
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:23:41 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id t22so5906623oiw.12
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QgLgwE47wCCTHzHj23xoncikSrN5wZRuWk6YhkOMAV0=;
        b=3HXQAthDRJepV0EkpGLhWTtyxGCeD2fow0EHcts9yHkhG+LTEL0YtTCsKZO+dx/MVr
         Hoca8avQOsEDYHK+8ba/hixgMFpeHpBMb0m1TXwUJf8sgWHwQWpPP2o71W601DShKEvC
         SC/fzspp5FeYPAbiz5YouGM2U+Vf/iX9rw0kXbETZmZqL3gQcTyEPIREHJadCuey70/W
         ZEJbH9zZP9B8lnqytLJXDqPeUK2su2Bz8yAiPJmALTDJpmUg4iv9C3VzkAMCKF8DGqGp
         tCMYDgAsV1iVesRd1k04Ho/GXz4zzI6sKkABWzu0Gn8tqOhov8rf7gNsRrj1IXLa2uAs
         vu2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QgLgwE47wCCTHzHj23xoncikSrN5wZRuWk6YhkOMAV0=;
        b=1gXowBbsbXiWH9lc6AErpPmNGXViOxyTE3rI31HP46WWJ57D/Tyn4Lun1qiwz7Lu0M
         zCMjTOKeGkrL1VRN9W+wL4DZyDIekrTo92HRF0V8SODBRJpNGtb/DAv+J80QnRq99XFS
         YSnuydhe/C/mmv2oCbFqOfJP0ywAfHbUkr7L/O/R08TExWKBPFlh80bqJHwBN9YY/IVb
         F4hR4b/kmEisaaVmuKN4LW/lrEWZ5YmFxeAmjapuipzIateAkO5Qa9GQvBXuygCuaIfm
         vq9G2z2shbcGKfqbDVWqLvwc1J4m6WAN/O0egtrn050op38lHG6YYRVWulaiuULTiUK4
         5YOA==
X-Gm-Message-State: AO0yUKVJVdVAB4MBanYgLZGc1F2uahWOpER7iHiveJ/fer3hMxnIWPVL
        lOJMPjN4dTBarPo5VwewScMLKozE26KFrGLK
X-Google-Smtp-Source: AK7set/6W7HrK7bkOxE7dk05YnWVecrhvbPaOb24jfUX4BYZPkZSSbViJ82/7IZgaK6ZqFxwwUvp7w==
X-Received: by 2002:aca:1c16:0:b0:384:23f0:21b7 with SMTP id c22-20020aca1c16000000b0038423f021b7mr55047oic.14.1677522220453;
        Mon, 27 Feb 2023 10:23:40 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:4174:ef7a:c9ab:ab62])
        by smtp.gmail.com with ESMTPSA id a6-20020a056808120600b0037d59e90a07sm3403381oil.55.2023.02.27.10.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 10:23:40 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, amir@vadai.me, dcaratti@redhat.com,
        willemb@google.com, ozsh@nvidia.com, paulb@nvidia.com,
        Pedro Tammela <pctammela@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net v2 3/3] net/sched: act_sample: fix action bind logic
Date:   Mon, 27 Feb 2023 15:22:57 -0300
Message-Id: <20230227182256.275816-4-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230227182256.275816-1-pctammela@mojatatu.com>
References: <20230227182256.275816-1-pctammela@mojatatu.com>
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

The TC architecture allows filters and actions to be created independently.
In filters the user can reference action objects using:
tc action add action sample ... index 1
tc filter add ... action pedit index 1

In the current code for act_sample this is broken as it checks netlink
attributes for create/update before actually checking if we are binding to an
existing action.

tdc results:
1..29
ok 1 9784 - Add valid sample action with mandatory arguments
ok 2 5c91 - Add valid sample action with mandatory arguments and continue control action
ok 3 334b - Add valid sample action with mandatory arguments and drop control action
ok 4 da69 - Add valid sample action with mandatory arguments and reclassify control action
ok 5 13ce - Add valid sample action with mandatory arguments and pipe control action
ok 6 1886 - Add valid sample action with mandatory arguments and jump control action
ok 7 7571 - Add sample action with invalid rate
ok 8 b6d4 - Add sample action with mandatory arguments and invalid control action
ok 9 a874 - Add invalid sample action without mandatory arguments
ok 10 ac01 - Add invalid sample action without mandatory argument rate
ok 11 4203 - Add invalid sample action without mandatory argument group
ok 12 14a7 - Add invalid sample action without mandatory argument group
ok 13 8f2e - Add valid sample action with trunc argument
ok 14 45f8 - Add sample action with maximum rate argument
ok 15 ad0c - Add sample action with maximum trunc argument
ok 16 83a9 - Add sample action with maximum group argument
ok 17 ed27 - Add sample action with invalid rate argument
ok 18 2eae - Add sample action with invalid group argument
ok 19 6ff3 - Add sample action with invalid trunc size
ok 20 2b2a - Add sample action with invalid index
ok 21 dee2 - Add sample action with maximum allowed index
ok 22 560e - Add sample action with cookie
ok 23 704a - Replace existing sample action with new rate argument
ok 24 60eb - Replace existing sample action with new group argument
ok 25 2cce - Replace existing sample action with new trunc argument
ok 26 59d1 - Replace existing sample action with new control argument
ok 27 0a6e - Replace sample action with invalid goto chain control
ok 28 3872 - Delete sample action with valid index
ok 29 a394 - Delete sample action with invalid index

Fixes: 5c5670fae430 ("net/sched: Introduce sample tc action")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_sample.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index f7416b5598e0..4c670e7568dc 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -55,8 +55,8 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 					  sample_policy, NULL);
 	if (ret < 0)
 		return ret;
-	if (!tb[TCA_SAMPLE_PARMS] || !tb[TCA_SAMPLE_RATE] ||
-	    !tb[TCA_SAMPLE_PSAMPLE_GROUP])
+
+	if (!tb[TCA_SAMPLE_PARMS])
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_SAMPLE_PARMS]);
@@ -80,6 +80,13 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 		tcf_idr_release(*a, bind);
 		return -EEXIST;
 	}
+
+	if (!tb[TCA_SAMPLE_RATE] || !tb[TCA_SAMPLE_PSAMPLE_GROUP]) {
+		NL_SET_ERR_MSG(extack, "sample rate and group are required");
+		err = -EINVAL;
+		goto release_idr;
+	}
+
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
 	if (err < 0)
 		goto release_idr;
-- 
2.34.1

