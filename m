Return-Path: <netdev+bounces-4835-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D40070EA9D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 03:16:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 637EE1C20ACA
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 01:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1D3C1360;
	Wed, 24 May 2023 01:16:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A139FED5
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 01:16:34 +0000 (UTC)
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286CDDA;
	Tue, 23 May 2023 18:16:33 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-3f392680773so3569171cf.0;
        Tue, 23 May 2023 18:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684890992; x=1687482992;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8Lfp3+dMXCvts3RRtwZyL54uqMM5sA4kXWO4EIcMZJo=;
        b=VrAWuyX3D6A+MD/zUNY15G2S7wPKifPsc9GWv8BS9Op3UDJ3izFSGCnxvPRa44DVUl
         TjYC/HSvS2SCUaKd2HEVs4DxpMooJD1P1Ensp1kt8mlKlbo2fvWgCiILivMjtpZZNy1m
         42QcxzGX3buObKded9kE8Ubz/+lBJDpyNmpGwjJoAjaLDG0ka+YAydTTY9dj0zKUBtaZ
         BQCP6iSr3D2BBvWAQkIXIKUCqbRQI1euymeN/URQ1wLwlw956mj76Y5DGKW8nUmaw9RK
         ZNiAVGwLajt7Fz+RpOs0pr/5sZeKcSbgzm7BPw/+650dl2dCHZNpm5G5fows1k055NY7
         gatw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684890992; x=1687482992;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Lfp3+dMXCvts3RRtwZyL54uqMM5sA4kXWO4EIcMZJo=;
        b=D//TwcCRzvzBTxwb2Pon4HWwHxJB9MByCkWUNakjzrUUE35Jci09LHSLkUVyGa68ie
         9ApVKDl2ZINhUDI9ouf0H7RWkuk/03TycecS272UjOgKalgyLfcJxbz5OlvVLwUhmwwl
         u13FPNOEct5DlqiqapwlN6cstCV/f16raPr3VKxyC/tYhoc7JQpNTLO4uEd0YhOse/E/
         tn3NolWWtCiKmxCTFkS6Yy3VSEzi3gWyMeEyYK3Pz3TdUrOS0+3zGP1/Pfks3rnKkXnN
         gePFZAZJmw79Qc3c4oOJdhCjBbd9pCBVplHpuloGFnOfTuW4sycDFDD1f7X1cfC7vJDA
         ZuIw==
X-Gm-Message-State: AC+VfDyhPjmpyzkbg/vRTQLhmOQ3bed7Rr8stAgF6uoyJbShw408bN00
	Bm2F5GX7Nct1NvbPl1QC9TlTOlKhtg==
X-Google-Smtp-Source: ACHHUZ7vUNjFQKSCTIpsNn7yfOHKt+Ecv4xJhamO7806Xjb9LT8pHXNyOY7Wrl0Ox2skLoA1HCZBeg==
X-Received: by 2002:a05:622a:1487:b0:3f6:9bcc:4885 with SMTP id t7-20020a05622a148700b003f69bcc4885mr19979131qtx.50.1684890992209;
        Tue, 23 May 2023 18:16:32 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:d860:12b0:c32:b55:eaec:a556])
        by smtp.gmail.com with ESMTPSA id z28-20020a05620a101c00b007579f89c0ccsm2930151qkj.29.2023.05.23.18.16.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 18:16:31 -0700 (PDT)
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
	John Fastabend <john.fastabend@gmail.com>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>,
	Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH v5 net 0/6] net/sched: Fixes for sch_ingress and sch_clsact
Date: Tue, 23 May 2023 18:16:21 -0700
Message-Id: <cover.1684887977.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
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

Link to v4: https://lore.kernel.org/r/cover.1684825171.git.peilin.ye@bytedance.com/
Link to v3 (incomplete): https://lore.kernel.org/r/cover.1684821877.git.peilin.ye@bytedance.com/
Link to v2: https://lore.kernel.org/r/cover.1684796705.git.peilin.ye@bytedance.com/
Link to v1: https://lore.kernel.org/r/cover.1683326865.git.peilin.ye@bytedance.com/

Hi all,

These are v5 fixes for ingress and clsact Qdiscs.  Please take another
look at patch 1, 2 and 6, thanks!

Changes in v5:
  - for [6/6], reinitialize @q, @p (suggested by Vlad) and @tcm after the
    "replay:" tag
  - for [1,2/6], do nothing in ->destroy() if ->parent isn't ffff:fff1, as
    reported by Pedro

Change in v3, v4:
  - add in-body From: tags

Changes in v2:
  - for [1-5/6], include tags from Jamal and Pedro
  - for [6/6], as suggested by Vlad, replay the request if the current
    Qdisc has any ongoing (RTNL-unlocked) filter requests, instead of
    returning -EBUSY to the user
  - use Closes: tag as warned by checkpatch

[1,2/6]: ingress and clsact Qdiscs should only be created under ffff:fff1
  [3/6]: Under ffff:fff1, only create ingress and clsact Qdiscs (for now,
         at least)
  [4/6]: After creating ingress and clsact Qdiscs under ffff:fff1, do not
         graft them again to anywhere else (e.g. as the inner Qdisc of a
         TBF Qdisc)
  [5/6]: Prepare for [6/6], do not reuse that for-loop in qdisc_graft()
         for ingress and clsact Qdiscs
  [6/6]: Fix use-after-free [a] in mini_qdisc_pair_swap()

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

 include/net/sch_generic.h |  8 +++++
 net/sched/sch_api.c       | 68 ++++++++++++++++++++++++++++-----------
 net/sched/sch_generic.c   | 14 ++++++--
 net/sched/sch_ingress.c   | 16 +++++++--
 4 files changed, 83 insertions(+), 23 deletions(-)

-- 
2.20.1


