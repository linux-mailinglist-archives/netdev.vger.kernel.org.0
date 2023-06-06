Return-Path: <netdev+bounces-8484-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3326372440B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AC411C20F4F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3F4D17739;
	Tue,  6 Jun 2023 13:13:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A8937B6F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:13:56 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D981BE6
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 06:13:32 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-561ceb5b584so101296397b3.3
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 06:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686057211; x=1688649211;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mNb1g7nlkD1Or5TkWfUaK5tWAL/8Frsv9xzITrQ1tt0=;
        b=jzjwYeJA61bBkL7nwPPX5dZ880DA2cDdCzixnPDKnxwI1rpMTt5/gxeRcJAbGZ5iZP
         eYOLW3wsMK4YSM0FuOCtttaoOuQz4nmcFrqmuMSXqvcpqZ8iaVDuHWWAhtSGbcHc8OGp
         +kSHRI1ffB1Cfb41FphZZTJebnZ+8Dmve/9nwTq7TnLEorjqRC41TZ1GfCPdQA4lYPr/
         HE59YoJL2K8dbi4OWiGUnTj/hBN9ogZKHbXtooRH8/P79hBJmXFOA2zzJa8nmO9MtnIc
         hNaynew5SszjDeAfMdGntC4+X8sTce7eKf1e/JzddGPq6s/9saCtROsiSX2xJjihk24a
         BkZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686057211; x=1688649211;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mNb1g7nlkD1Or5TkWfUaK5tWAL/8Frsv9xzITrQ1tt0=;
        b=LpjuU+4gkr9MBF+jRXh4rackv9A7tkUgMEsLhBOyNBT+F8V+l6bTTvIAEOQSq2N/7Z
         5DCBwktPF17UvskYRz00hUtOyjZo7SJpHw2uCyJfZft6ogf0Z0MDr5fr9sllS0Fe6FJq
         OBxKfdE+qWAqAuJC0kagzDT3ZZWv+aBbalKY0NHrHom2L+1q5SGK9hQGnsyYNNO8BiNO
         kq7UPrZ4K0NkwmeRPWW0++dB8jbwuIwZ3eJBqxr7rSKdHsT60XqC/l107XP3FKdVZQuv
         VCIOUAVkPOodCC30YWgUie0G1jJhf4agK+S0D2SyakbKC/Geiz2+5G+BOjSKcMqFE6KP
         u14Q==
X-Gm-Message-State: AC+VfDz92jSX/ZggrYEiIZwGAYOcze22VVjP7Ai/0DTWGRy0T+tqZw8Q
	5LIPU7oIIONcNfIQ+K/4LnlRskCFPz1GEA==
X-Google-Smtp-Source: ACHHUZ47M5g7ZLJSk63ch/LpcJAt6f1mKIJqTSoNlV9lzVRHbJBS1d0/hy4SoDuHW/+mT+we5+62VcShBGJsFw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:4415:0:b0:569:43f7:75b4 with SMTP id
 r21-20020a814415000000b0056943f775b4mr1086444ywa.5.1686057211752; Tue, 06 Jun
 2023 06:13:31 -0700 (PDT)
Date: Tue,  6 Jun 2023 13:13:04 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230606131304.4183359-1-edumazet@google.com>
Subject: [PATCH net] net: sched: act_police: fix sparse errors in tcf_police_dump()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>, 
	Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fixes following sparse errors:

net/sched/act_police.c:360:28: warning: dereference of noderef expression
net/sched/act_police.c:362:45: warning: dereference of noderef expression
net/sched/act_police.c:362:45: warning: dereference of noderef expression
net/sched/act_police.c:368:28: warning: dereference of noderef expression
net/sched/act_police.c:370:45: warning: dereference of noderef expression
net/sched/act_police.c:370:45: warning: dereference of noderef expression
net/sched/act_police.c:376:45: warning: dereference of noderef expression
net/sched/act_police.c:376:45: warning: dereference of noderef expression

Fixes: d1967e495a8d ("net_sched: act_police: add 2 new attributes to support police 64bit rate and peakrate")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/act_police.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 227cba58ce9f30539ead12d1ca5258cbc69dc340..2e9dce03d1eccf4666b40fd6d8c04ff40f2d0780 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -357,23 +357,23 @@ static int tcf_police_dump(struct sk_buff *skb, struct tc_action *a,
 	opt.burst = PSCHED_NS2TICKS(p->tcfp_burst);
 	if (p->rate_present) {
 		psched_ratecfg_getrate(&opt.rate, &p->rate);
-		if ((police->params->rate.rate_bytes_ps >= (1ULL << 32)) &&
+		if ((p->rate.rate_bytes_ps >= (1ULL << 32)) &&
 		    nla_put_u64_64bit(skb, TCA_POLICE_RATE64,
-				      police->params->rate.rate_bytes_ps,
+				      p->rate.rate_bytes_ps,
 				      TCA_POLICE_PAD))
 			goto nla_put_failure;
 	}
 	if (p->peak_present) {
 		psched_ratecfg_getrate(&opt.peakrate, &p->peak);
-		if ((police->params->peak.rate_bytes_ps >= (1ULL << 32)) &&
+		if ((p->peak.rate_bytes_ps >= (1ULL << 32)) &&
 		    nla_put_u64_64bit(skb, TCA_POLICE_PEAKRATE64,
-				      police->params->peak.rate_bytes_ps,
+				      p->peak.rate_bytes_ps,
 				      TCA_POLICE_PAD))
 			goto nla_put_failure;
 	}
 	if (p->pps_present) {
 		if (nla_put_u64_64bit(skb, TCA_POLICE_PKTRATE64,
-				      police->params->ppsrate.rate_pkts_ps,
+				      p->ppsrate.rate_pkts_ps,
 				      TCA_POLICE_PAD))
 			goto nla_put_failure;
 		if (nla_put_u64_64bit(skb, TCA_POLICE_PKTBURST64,
-- 
2.41.0.rc0.172.g3f132b7071-goog


