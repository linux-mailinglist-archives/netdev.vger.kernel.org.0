Return-Path: <netdev+bounces-6163-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9C10715001
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 21:52:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67E491C20A9F
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 19:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF4F2D309;
	Mon, 29 May 2023 19:52:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FFD7C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 19:52:44 +0000 (UTC)
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A5A92;
	Mon, 29 May 2023 12:52:43 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-75b14216386so199715885a.0;
        Mon, 29 May 2023 12:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685389962; x=1687981962;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z1dUZSHVQhEtOuDH3VaKyipYbrN9drARN4zUz4dByZM=;
        b=kX0jX/JgLb4DILaeytE2ajbjulyxARy8zRicxzulgBVhSAqwQ7RhYL5Xw+55c0lHn6
         teTzWV00eLvwOcfdIFQhYe5IVJLbNOhFUFlMoG6TfyxdNVfMuWaXCBJcpWLlR25f4wOx
         5CebWRolvb6bXsmDRAwiYbdxcpmMJoeO9BK3Zzne4V6Q0D7f2vWYMGtIzdFDwxxtPkBW
         JlRuWfZt8/J5a/kG+DhQRDom6EZ8JY7ST0hy0Kqn/9trgE8T685QBZi3zbS/YiYpHl1r
         HpZo0Yh0oXUeS+TmnI6MQh32JjEnJK0zfElFv7/wQWZtVr+OWOQMnhm/NwGnaRcLBqXP
         P+Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685389962; x=1687981962;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z1dUZSHVQhEtOuDH3VaKyipYbrN9drARN4zUz4dByZM=;
        b=IwrRHKqG3KGspc7mcssRd53ty2rVza0NQX0V59FZHCA2+3jeS2L4mIw2MG1PxKxZWQ
         eYtpZF6tW6Yhj9U1MCrufYwSJQG+b8Bax3Yd2son+CLZwvYZ76FK3CGLvap2ZDXDh/bz
         ztuxAV5aRZ8W1CyWlu/5i6ySJ3ODh+BTqIkxqn/MDtdQdT+Hyq8zxuKz8a3PPVeWQ8KQ
         cmm44yN9kwlm2j67RerSvGK7pQJ5sJGLwaGkGAcQBDF4sSeX89p9Hj64noH0o1MvHt45
         O+ID+4D41UQVQ1ttKxNQ8QyyIxAl1bphadiqzuoPOy0L6fbaoBh95Lj4zOb+9+vwZTXE
         dQNA==
X-Gm-Message-State: AC+VfDy68am/ceQkpUMbmxAa8V3BCSX5QllmaItCkHQSrQHOSoUJRz1y
	LrguDoEAYfr4nrNw4jnyLA==
X-Google-Smtp-Source: ACHHUZ7cNQUq6xOFSGH5grc7BgTC9ihncUnfb1Blh4w3rDVuIAFFI1fMX9A44ttqf5bXg+3Jp6l6pw==
X-Received: by 2002:a05:620a:4c97:b0:75b:23a0:e7be with SMTP id to23-20020a05620a4c9700b0075b23a0e7bemr8305996qkn.31.1685389962102;
        Mon, 29 May 2023 12:52:42 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:d860:12b0:e554:e6:7140:9e6b])
        by smtp.gmail.com with ESMTPSA id a4-20020a05620a124400b0075b1c6f9628sm3583334qkl.71.2023.05.29.12.52.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 May 2023 12:52:41 -0700 (PDT)
From: Peilin Ye <yepeilin.cs@gmail.com>
X-Google-Original-From: Peilin Ye <peilin.ye@bytedance.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Peilin Ye <peilin.ye@bytedance.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>,
	Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH v6 net 0/4] net/sched: Fixes for sch_ingress and sch_clsact
Date: Mon, 29 May 2023 12:52:31 -0700
Message-Id: <cover.1685388545.git.peilin.ye@bytedance.com>
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
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Link to v5: https://lore.kernel.org/r/cover.1684887977.git.peilin.ye@bytedance.com/
Link to v4: https://lore.kernel.org/r/cover.1684825171.git.peilin.ye@bytedance.com/
Link to v3 (incomplete): https://lore.kernel.org/r/cover.1684821877.git.peilin.ye@bytedance.com/
Link to v2: https://lore.kernel.org/r/cover.1684796705.git.peilin.ye@bytedance.com/
Link to v1: https://lore.kernel.org/r/cover.1683326865.git.peilin.ye@bytedance.com/

Hi all,

These are v6 fixes for ingress and clsact Qdiscs, including only first 4
patches (already tested and reviewed) from v5.  Patch 5 and 6 from
previous versions are still under discussion and will be sent separately.
Per-patch changelog omitted.

Change in v6:
  - only include first 4 patches from previous versions

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
Peilin Ye (4):
  net/sched: sch_ingress: Only create under TC_H_INGRESS
  net/sched: sch_clsact: Only create under TC_H_CLSACT
  net/sched: Reserve TC_H_INGRESS (TC_H_CLSACT) for ingress (clsact)
    Qdiscs
  net/sched: Prohibit regrafting ingress or clsact Qdiscs

 net/sched/sch_api.c     | 12 +++++++++++-
 net/sched/sch_ingress.c | 16 ++++++++++++++--
 2 files changed, 25 insertions(+), 3 deletions(-)

-- 
2.20.1


