Return-Path: <netdev+bounces-9869-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F16972B01E
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 05:29:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA2AA1C20AA1
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 03:29:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C631A139B;
	Sun, 11 Jun 2023 03:29:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73BC15BC
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 03:29:55 +0000 (UTC)
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5046B131;
	Sat, 10 Jun 2023 20:29:54 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-75ec6ae7ffaso245187985a.2;
        Sat, 10 Jun 2023 20:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686454192; x=1689046192;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rdbwCfJP0fRhUMDyPqmQQA9434sxRWUVYDLaUn3QYpA=;
        b=JdBnK8RWMwzM9FvTKYnYU+l7dKyIDGgBpEb3IuWMGMH04P2z4usCkiYHF1tMTv5Rqg
         9vy4dOVceZKFjtG9CNMhAJdslHedaYg55wn/0C7oEC5bBxAtySJCNJAPaZWSmErOuNpy
         k8jbqiJKgboR0rrs8csVBBaWte0CXjUGvwXxXG3Ry4AgFYxVWYKsdJ79+ryIHs+L8Gn0
         36nVxTtAQ/SCmFV0wyZr9kRFlNj2tNj5N/Z7AD3tpEqnHdoEfJvffT/nZB+fSzOtKVNe
         uOHpfppr4QEGaoUpZVSq7S4FlSOyYJlMD867EBwuMLhBHOaIZMnEIYR1SjcFEMwwCTfx
         +X9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686454192; x=1689046192;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rdbwCfJP0fRhUMDyPqmQQA9434sxRWUVYDLaUn3QYpA=;
        b=kGUyZ5YbjyaLx5KBSr9ttbdCziwxZsEbjXtdDr1dZltPk/SUG4ALfO6Axae1Z4YY3C
         Xq67PJsKrwGv6SgGItO3XawhfrBEliUJ9X2m8EP8tGW/wnFTLOin6xjVqvcTYPQY/y3Y
         oRAujBRaXX5tTHAV7kAdL/7UMpo0kY/PvAtJQOcC57DOY8IDsB9LZ+DZSt4xP0UMj6j5
         X+QNoluDPRaElrV00zZvD98ZBKL+F3X41ud2KAeNOWwBEWglB4s9CbUBpEFm8aKAwcQS
         pKItXZtczn+oUWQSc7APLYFrROb8qf7u+HSPktHhTRGO1u05TO57w6nwk+a8A3yns/3b
         qRBg==
X-Gm-Message-State: AC+VfDyjFyOw6K71AllXX8lmoO0ZZVW+VzWi0s2OG9hbs6rp1m+a86To
	drygfhdwWUWS1lZuLP9xxQ==
X-Google-Smtp-Source: ACHHUZ7zwFQVlMPRzcQ3EirGzfjPA/YHz7J+nHQgsB7b4HVPeDleJh0Cp+nEbA8afuW9yTaw/cLt6A==
X-Received: by 2002:a05:620a:8c90:b0:75e:ba84:ecca with SMTP id ra16-20020a05620a8c9000b0075eba84eccamr5396290qkn.40.1686454192214;
        Sat, 10 Jun 2023 20:29:52 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:65a5:6400:a53e:60df:7509:de6])
        by smtp.gmail.com with ESMTPSA id c16-20020a05620a135000b0075aff6f835bsm2045161qkl.19.2023.06.10.20.29.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Jun 2023 20:29:51 -0700 (PDT)
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
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Hillf Danton <hdanton@sina.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>,
	Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net 0/2] net/sched: Fix race conditions in mini_qdisc_pair_swap()
Date: Sat, 10 Jun 2023 20:29:41 -0700
Message-Id: <cover.1686355297.git.peilin.ye@bytedance.com>
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

Hi all,

These 2 patches fix race conditions for ingress and clsact Qdiscs as
reported [1] by syzbot, split out from another [2] series (last 2 patches
of it).  Per-patch changelog omitted.

Patch 1 hasn't been touched since last version; I just included
everybody's tag.

Patch 2 bases on patch 6 v1 of [2], with comments and commit log slightly
changed.  We also need rtnl_dereference() to load ->qdisc_sleeping since
commit d636fc5dd692 ("net: sched: add rcu annotations around
qdisc->qdisc_sleeping"), so I changed that; please take yet another look,
thanks!

Patch 2 has been tested with the new reproducer Pedro posted [3].

[1] https://syzkaller.appspot.com/bug?extid=b53a9c0d1ea4ad62da8b
[2] https://lore.kernel.org/r/cover.1684887977.git.peilin.ye@bytedance.com/
[3] https://lore.kernel.org/r/7879f218-c712-e9cc-57ba-665990f5f4c9@mojatatu.com/

Thanks,
Peilin Ye (2):
  net/sched: Refactor qdisc_graft() for ingress and clsact Qdiscs
  net/sched: qdisc_destroy() old ingress and clsact Qdiscs before
    grafting

 include/net/sch_generic.h |  8 +++++++
 net/sched/sch_api.c       | 44 +++++++++++++++++++++++++++------------
 net/sched/sch_generic.c   | 14 ++++++++++---
 3 files changed, 50 insertions(+), 16 deletions(-)

-- 
2.20.1


