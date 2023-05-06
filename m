Return-Path: <netdev+bounces-650-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 599A76F8D11
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 02:13:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B7B4281107
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 00:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 720A619A;
	Sat,  6 May 2023 00:13:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674AC180
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 00:13:51 +0000 (UTC)
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E921C65A5;
	Fri,  5 May 2023 17:13:49 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-55a5e0f5b1aso23125127b3.0;
        Fri, 05 May 2023 17:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683332029; x=1685924029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LpQnycD4NBJS2K7bUxjOFhm2fk8qfStWlOlna9WRdZw=;
        b=gHOOwYnGC3x7wKGcS5bH5zVlnyCwlFzmfpKYUNl8Xoi1jNkiau1YcNvRO7t0WDk+S3
         j2Nn94jyo9yu7U+2iFOr/rSwTMHfuzKFCWKUbwu6eqjsJyKwzFZsi4JeGbKNzjmGKvbZ
         1gIZqOTmU5slKs2lWbOKYN5QUDGnk8CwNo4wsCAknE80c6ZAlpZm/4mRi8naN2yxiW8L
         PJ2YE4wkqG1DqMbbthU9qBrxSlxzUWy8DYtmZZUJY+4rDw0GvHD9wX0hTcmIH17y/C06
         Bg92/rWiT1dnNCAMRsvaaclugYK/WfsHyhJomevuM83/6lvYG9lYpx6o+ruSO850uL0D
         IiHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683332029; x=1685924029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LpQnycD4NBJS2K7bUxjOFhm2fk8qfStWlOlna9WRdZw=;
        b=b8ncejNpfNRDct0YuGrUpUTOoZc69gEG/0Sff6Fln9Ak6M0FVQ08mwBVPSS/qLSF+6
         Vp1ip5v0gw4ypvPZPQ8dT3fKcMPMA5oTFhC5GITzHusaXdwnnZE4GsGp0jQanuSIewDt
         LKmtNAAip56QM1xfCbYjhBHeoEYsYEYA1ODoLkCllXYDCdKWK2U4fDDvsQ8H1FwRN/+Y
         JsxogolTLLm8rAdvxEwdIDWrl1DD6+Vntz3PXi0q+NwZdfWBbb7v4pOI01jj/pCUWYyN
         QmWSkQTxeWEcRypJV9Mh/tEn7/gDrYSuqAxu2mqmvy18vHZ1Ugj++TU4tAt0G94s0JO2
         pmXg==
X-Gm-Message-State: AC+VfDwUBZJZF36iPxrc4coP3D9crClCFV2TvGDO5h/6zevxj3q5QS9q
	nwaP9SarW+252Q2FhqyW0w==
X-Google-Smtp-Source: ACHHUZ6iPQ2Vncmcg0zeVwBoqAqhA6kd1WfImwDk6YG7tRIFi/HTzsXUkHEn1VHCPzPrJAvKPI7zDQ==
X-Received: by 2002:a0d:d916:0:b0:556:b11e:ec34 with SMTP id b22-20020a0dd916000000b00556b11eec34mr3429474ywe.50.1683332029141;
        Fri, 05 May 2023 17:13:49 -0700 (PDT)
Received: from C02FL77VMD6R.attlocal.net ([2600:1700:d860:12b0:5c3e:e69d:d939:4053])
        by smtp.gmail.com with ESMTPSA id u185-20020a8160c2000000b00552ccda9bb3sm802377ywb.92.2023.05.05.17.13.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 May 2023 17:13:48 -0700 (PDT)
From: Peilin Ye <yepeilin.cs@gmail.com>
X-Google-Original-From: Peilin Ye <peilin.ye@bytedance.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>
Cc: Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.r.fastabend@intel.com>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>,
	Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net 2/6] net/sched: sch_clsact: Only create under TC_H_CLSACT
Date: Fri,  5 May 2023 17:13:41 -0700
Message-Id: <21f1455040137e531f64fdc4edc3d36840e076ed.1683326865.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <cover.1683326865.git.peilin.ye@bytedance.com>
References: <cover.1683326865.git.peilin.ye@bytedance.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

clsact Qdiscs are only supposed to be created under TC_H_CLSACT (which
equals TC_H_INGRESS).  Return -EOPNOTSUPP if 'parent' is not
TC_H_CLSACT.

Fixes: 1f211a1b929c ("net, sched: add clsact qdisc")
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/sched/sch_ingress.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index 3d71f7a3b4ad..13218a1fe4a5 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -222,6 +222,9 @@ static int clsact_init(struct Qdisc *sch, struct nlattr *opt,
 	struct net_device *dev = qdisc_dev(sch);
 	int err;
 
+	if (sch->parent != TC_H_CLSACT)
+		return -EOPNOTSUPP;
+
 	net_inc_ingress_queue();
 	net_inc_egress_queue();
 
-- 
2.20.1


