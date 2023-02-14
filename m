Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC183696F19
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbjBNVRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbjBNVQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:16:59 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357C72DE43
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:16:19 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id bx13so14093852oib.13
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e1Zm9keMbX1AlG1gFM/l24C6S2yseq0lFTPbduKO2Pg=;
        b=Vj6acigu89E3+qEAK2CUkep/iWi1TJ+sx11VCQg/OwQd2FLQty3UHwGmrlAfljEJGE
         941JbyfX4lDiMC20kkdiMtRG/A6bfW+5kOWIHzSgPwogUMNuSqyBK6HlRHKJpcvwCCYc
         3agdI7p0cSlY2eoxJ6mVD0nhV3SCscEx+vsyX/m3D1Uyql/+C4ZvP08h5LNHVb9bRu3X
         dYwFCEwP/msmHciuD/fgUalvPM1l7EnPPijMEBxeSeaaHHKvT9s3uFKzVLFA9qRWJVnK
         iFhHBFhajfxjdunCOgANwEADZy+/4kQBScRV2Fs5C5jwxfQSiWo6RkI8TE0c6nyIHef1
         VGUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e1Zm9keMbX1AlG1gFM/l24C6S2yseq0lFTPbduKO2Pg=;
        b=5bO8RzGD0dm2yjgoxmWIINgX7/aB77yc5M4LSS//qryaaeGGOHeIYk/dUcvdwc3h24
         Z60FJ70vScQ8CQP1Ns+JYLU7dKbRDThrR2vYY553ns3jUWGT7Mbs3bKv7EiBgHEqo8Z5
         Gi9CmetuEyzRZA4UFKScYa5UM6ubMI6DD6ilhUwed9jK6yqS/1kxFVyWEQrntNI2LQIK
         yJ/D3hNeM8Q+rzDfdySi2dp8ah1LoJg/LgRXN9TXJgxF/GJkYEI2GUD76X8B/dBOoru7
         vrRMVtvCWz92B/qFCPcTBSzQbg3W2XtdAOQ7R10uu4zCZXxHG5JsUHE5+ESNFOegUrC6
         iQ0Q==
X-Gm-Message-State: AO0yUKVmnSS8dL8PfouyV0ej4fU+nr8Ht3R5nrv9Y7SHJnE5PWPnQgYP
        zjYI2YSHP4y3k/G9tucLhO6Ya9RXFljrpbhJ
X-Google-Smtp-Source: AK7set9QvgvjNmDmVMXIoqyDEOzfCEny0rTBBfe9kqgCdfAZo7SizSWfYaJzMC3lPCTIhnmCrCkrqw==
X-Received: by 2002:a05:6808:6c8:b0:378:9c1:514e with SMTP id m8-20020a05680806c800b0037809c1514emr1839873oih.42.1676409363864;
        Tue, 14 Feb 2023 13:16:03 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:565a:c0a1:97af:209b])
        by smtp.gmail.com with ESMTPSA id b6-20020a9d5d06000000b0068bd3001922sm6949754oti.45.2023.02.14.13.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:16:03 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 4/4] net/sched: act_pedit: use percpu overlimit counter when available
Date:   Tue, 14 Feb 2023 18:15:34 -0300
Message-Id: <20230214211534.735718-5-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230214211534.735718-1-pctammela@mojatatu.com>
References: <20230214211534.735718-1-pctammela@mojatatu.com>
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

Since act_pedit now has access to percpu counters, use the
tcf_action_inc_overlimit_qstats wrapper that will use the percpu
counter whenever they are available.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 35ebe5d5c261..77d288d384ae 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -443,9 +443,7 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 	goto done;
 
 bad:
-	spin_lock(&p->tcf_lock);
-	p->tcf_qstats.overlimits++;
-	spin_unlock(&p->tcf_lock);
+	tcf_action_inc_overlimit_qstats(&p->common);
 done:
 	return p->tcf_action;
 }
-- 
2.34.1

