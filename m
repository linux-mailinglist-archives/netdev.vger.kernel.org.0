Return-Path: <netdev+bounces-648-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 035936F8D0E
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 02:10:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3599281112
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 00:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AA7A19A;
	Sat,  6 May 2023 00:10:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A79180
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 00:10:06 +0000 (UTC)
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D6B65AB;
	Fri,  5 May 2023 17:10:05 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-55d2e87048cso35886777b3.1;
        Fri, 05 May 2023 17:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683331804; x=1685923804;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z1tFG7m2xfEcAcR8LZf/choHnP0WMR/Vlxqt/wj5I9k=;
        b=Y1BAYKAZPrs/r9CdIQJ4lL/ATT93ESaJ8SStXZHLiUp+eEJBc2P5/x3DKuJE7NzV8S
         kKOkQMinSf9ffc308+ftL8tChQaEUlc3j/Kz1+Z+rLDFdIx67rQfrLbQN+DK6Jw9E/hd
         DCfG7flWsAAAM94A9upHXkqA1AskeBXV33AZfpZS5v2S57gNP1cSLOOd+9b3wb137WXU
         a+nDr9lxYBJdrV9Gx2psyMth769F7G1kdwHhVJuRmzemZa1FkTodLXXK1T7jMMeZDana
         OgdcoWkhFQjyQ7AFMlSty+/XF/W0lgMl++5giQjyzKMddV2DfmitZryrMTxwa45sx2ma
         QyfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683331804; x=1685923804;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z1tFG7m2xfEcAcR8LZf/choHnP0WMR/Vlxqt/wj5I9k=;
        b=bq1evU4xMIiqGyud2Uv2Xs6UT+QfmRg0iwsbxD7acMf920NiF9Brev1gdwGnewh4QK
         cWha4Wzl7ZV1d+dgFBUhKaxO3Oi9Ubvl67F4b+EskG8c5O84yeH+QLB81/Mwb4a/oGT0
         W1bge7wPvghVGwJNgQK9apYF5fDOcTPGj4R4gvaSX9e5cFSawHSkGwHc5FrMofU+9HXm
         EdFL4wvIIZyIqE6Is8Q0G5P2jv7+iUj/2Cn6HiDu/WVIK7qzGKBEDdwq3pGqcxEaW7aj
         NXquB0FrKB6gV74jYK92aH1l1bsJxNtHJhwUPMYNB9/lg80hCzEO6xPpi1AaJhOElayp
         J5MQ==
X-Gm-Message-State: AC+VfDwh3LLSicJl3PKCcjnVaipyVTBlNYHQFyP2xa6d16EJykxShfBz
	XNcaHmn038lOytm6+l3o1Q==
X-Google-Smtp-Source: ACHHUZ4oGgd4Xq/7+oOsavrRNHE/OlQjlTQqlzR1En9/fVxHPdXD9nZ7eF3Z6+lgJp9s7ZOFvCs+0g==
X-Received: by 2002:a0d:d703:0:b0:55a:8b02:1d8f with SMTP id z3-20020a0dd703000000b0055a8b021d8fmr3411898ywd.49.1683331804016;
        Fri, 05 May 2023 17:10:04 -0700 (PDT)
Received: from C02FL77VMD6R.attlocal.net ([2600:1700:d860:12b0:5c3e:e69d:d939:4053])
        by smtp.gmail.com with ESMTPSA id h188-20020a0dc5c5000000b00545c373f7c0sm791849ywd.139.2023.05.05.17.10.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 May 2023 17:10:03 -0700 (PDT)
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
Subject: [PATCH net 0/6] net/sched: Fixes for sch_ingress and sch_clsact
Date: Fri,  5 May 2023 17:09:39 -0700
Message-Id: <cover.1683326865.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20230426233657.GA11249@bytedance>
References: <20230426233657.GA11249@bytedance>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi all,

These are fixes for ingress and clsact Qdiscs:

[1,2/6]: ingress and clsact Qdiscs should only be created under ffff:fff1
  [3/6]: Under ffff:fff1, only create ingress and clsact Qdiscs (for now,
         at least)
  [4/6]: After creating ingress and clsact Qdiscs under ffff:fff1, do not
         graft them again to anywhere else (e.g. as the inner Qdisc of a
         TBF Qdisc)
  [5/6]: Prepare for [6/6], do not reuse that for-loop in qdisc_graft()
         for ingress and clsact Qdiscs
  [6/6]: Fix use-after-free [a] in mini_qdisc_pair_swap()

Please review (especially [6/6]), thanks!  Other tasks, including:

  - prohibiting sch_ingress, sch_clsact etc. in default_qdisc
  - more cleanups for qdisc_graft()

Will be done in separate patches.

[a] https://syzkaller.appspot.com/bug?extid=b53a9c0d1ea4ad62da8b

Thanks,
Peilin Ye (6):
  net/sched: sch_ingress: Only create under TC_H_INGRESS
  net/sched: sch_clsact: Only create under TC_H_CLSACT
  net/sched: Reserve TC_H_INGRESS (TC_H_CLSACT) for ingress (clsact)
    Qdiscs
  net/sched: Prohibit regrafting ingress or clsact Qdiscs
  net/sched: Refactor qdisc_graft() for ingress and clsact Qdiscs
  net/sched: qdisc_destroy() old ingress and clsact Qdiscs before
    grafting

 include/net/sch_generic.h |  8 ++++++
 net/sched/sch_api.c       | 54 +++++++++++++++++++++++++++++----------
 net/sched/sch_generic.c   | 14 +++++++---
 net/sched/sch_ingress.c   | 10 ++++++--
 4 files changed, 67 insertions(+), 19 deletions(-)

-- 
2.20.1


