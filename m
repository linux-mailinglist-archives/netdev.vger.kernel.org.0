Return-Path: <netdev+bounces-4565-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0EDC70D3D0
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:19:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 558F71C20CCD
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 582C11C748;
	Tue, 23 May 2023 06:18:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF361B919
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:18:57 +0000 (UTC)
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE0C132;
	Mon, 22 May 2023 23:18:55 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id af79cd13be357-75b2726f04cso27069285a.3;
        Mon, 22 May 2023 23:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684822735; x=1687414735;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dQ6xsxSTLkO7Rnk+6PIH2xki1IufV5f5DazCokcyAas=;
        b=n6t6P+54GlaB9B5/WU/pRGmMpbfpI0fr8wHKLkADwGEsXnz/LAK3aHaW292ADV/9oI
         VzK4vXGh86UB5e0Eug1llKrjOV8TaCZPtdkU43IGcTKT0/WlP2WtHfW7dc8uwHCI18M3
         cKguZUDZy1q5Tf/LWExYcQw7DGGU+Gk1NrDhcF34fzloKmNTyfBaVpKkQLzKCJgtTPKO
         Lp6++xr4xEuD3FwEvlRB60RgW5zORZ8F053IOAm9ezZiI9RmvmXYk6CKkXerVICY0ZvO
         6o6zlucVX0cXHnOfdctWSAYE39qc6OqzvE9WoTqDl1b1MlK3e8rxkjjZQQNFZ6G60UyY
         y3pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684822735; x=1687414735;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dQ6xsxSTLkO7Rnk+6PIH2xki1IufV5f5DazCokcyAas=;
        b=iiGvU5JHVsaY1XbErAqKM+Vhbjh8FKq/a/Q6QzmITUSeklaFEKxtFJaCmXBgAqWjdd
         oC5zJ1Inuv8V9g5WMnKtTVnVR3xNWFqN9blI6vwSEsbySm/Jy8lpjtcsmvo5ZszrHqMs
         PqXKV6TwUKOWqnkahw6wan+bRkuqrJ98LPZsqEB0Zt8T78IztUQcrO3fqUmmicLjb8/9
         ZRyxiC8vPVIkRTFHwGlDGtrMErU93U4Jwy+noJcUdJxb9Alt6FIIbrJp0QuMia/7KPAv
         TYKtu5EZLwT7KhHs83tYdhNbeAJEZ7+BkHcUO6ZboJJM1bFKrU7DVYstCwOk2S9laAS7
         5PaA==
X-Gm-Message-State: AC+VfDycW6FxgnKGlPnhZ4qh2KPosdEgr2UbseQ3hzEfC3//ekRfgV0R
	QqX72g+TRTJjgPZ40zqFuw==
X-Google-Smtp-Source: ACHHUZ6TV9bylKcqnTq63+IkSlhlA4RaCxQflGA5AYGRd9iZwXIb4kNmG+zlRMTqfSdu9mgXfL6hUA==
X-Received: by 2002:a05:620a:1a10:b0:75b:23a1:8e7a with SMTP id bk16-20020a05620a1a1000b0075b23a18e7amr3301687qkb.75.1684822734802;
        Mon, 22 May 2023 23:18:54 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:d860:12b0:18c1:dc19:5e29:e9a0])
        by smtp.gmail.com with ESMTPSA id x19-20020ae9f813000000b00757882b0224sm2281393qkh.49.2023.05.22.23.18.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 May 2023 23:18:54 -0700 (PDT)
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
Subject: [PATCH v3 net 0/6] net/sched: Fixes for sch_ingress and sch_clsact
Date: Mon, 22 May 2023 23:18:21 -0700
Message-Id: <cover.1684821877.git.peilin.ye@bytedance.com>
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

Link to v2: https://lore.kernel.org/r/cover.1684796705.git.peilin.ye@bytedance.com/
Link to v1: https://lore.kernel.org/r/cover.1683326865.git.peilin.ye@bytedance.com/

Hi all,

These are v3 fixes for ingress and clsact Qdiscs.

Change in v3:
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

 include/net/sch_generic.h |  8 ++++++
 net/sched/sch_api.c       | 60 +++++++++++++++++++++++++++++----------
 net/sched/sch_generic.c   | 14 +++++++--
 net/sched/sch_ingress.c   | 10 +++++--
 4 files changed, 72 insertions(+), 20 deletions(-)

-- 
2.20.1


