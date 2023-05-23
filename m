Return-Path: <netdev+bounces-4579-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7085670D497
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:13:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E992A1C20BF4
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25F701C77E;
	Tue, 23 May 2023 07:13:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130221C747
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:12:59 +0000 (UTC)
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1505109;
	Tue, 23 May 2023 00:12:58 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-75affe9d7feso284133585a.0;
        Tue, 23 May 2023 00:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684825978; x=1687417978;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xZio8i4os+gLoYXTEzFCmPH/ORb8tIGBKsfZ/7cCq7c=;
        b=JWw9npV1kf2wKf7B+Jw4ftA08GL1o2tZ04iTcoa93iBqVTLDGkBX8UGWRB7Tpizwkw
         laQjJFgGI2oAqiNkcAPXAw7+uP230SgwH6xMECF3u+h+IxOCGOUP+VskIG7xxplZReJK
         J2IrKYN4ccB4DZVfvo3hUTrPrtkAsxKiyY+WssNI4joPzXMccgWG0jU/rH9s4mUg526q
         EYpzlUt2OZX1WAg4i28hoMI57bLj5BK1qVhTJCRk4xOeXWiTsKsvW5keN1XI7T04VY0a
         c7Y8Po0Del6DNrnKpnZ03uPFPKJO5OAeKZldFojN9Iu9I3+wAJKw94hxecKiSAAfrJpV
         /bYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684825978; x=1687417978;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xZio8i4os+gLoYXTEzFCmPH/ORb8tIGBKsfZ/7cCq7c=;
        b=MvXFDPN8dn3mXogQOg7gYv8BHtoq6b+K1V4+kmA3biN3Wvamhf6yaTOab+zcrRYlAY
         qU9fdnMrVM09s9GpLyPVXnpwK36nw2YwxG4yYmu5MPdffGn8+a1HV8VpvY8MvlpgnwSr
         G+5ngEaqq2aWZgsLAhLMO4JYthKe+lfwEXwlh8JdD8Wmx6pDcnThvfwhe/Q59at7oHDs
         ezd8sU1h7a0aIZWzTP64un1MuiNlrLAVPaj9ZGZAKMgmXTDwVgPstn7ZlhwL2DnI7wWq
         f8ZZyHACR20rgxq66os6TdF6E+YNm08QqiMtYeDYmlFrWoi5SJ0gGgOgK7lnmCXyPD5o
         N+Pg==
X-Gm-Message-State: AC+VfDwC3P3/Y57gJtIRJu45Lc4XSHmGvEIQHRXFnlxMMH3Q01Iu3QtM
	OW3bQ/uU7GLhd9Ch1ZDsCg==
X-Google-Smtp-Source: ACHHUZ4bKn6c0cGvb8XoCuxJIx1z5ZufZMLTCw5EGwuwjRbps/XikWFVh1iZ574IYItLkMeWc8KDHQ==
X-Received: by 2002:a37:6c7:0:b0:75b:23a0:de9c with SMTP id 190-20020a3706c7000000b0075b23a0de9cmr3193975qkg.26.1684825977798;
        Tue, 23 May 2023 00:12:57 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([2600:1700:d860:12b0:18c1:dc19:5e29:e9a0])
        by smtp.gmail.com with ESMTPSA id d24-20020a05620a159800b0074fb15e2319sm2307342qkk.122.2023.05.23.00.12.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 00:12:57 -0700 (PDT)
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
Subject: [PATCH v4 net 0/6] net/sched: Fixes for sch_ingress and sch_clsact
Date: Tue, 23 May 2023 00:12:39 -0700
Message-Id: <cover.1684825171.git.peilin.ye@bytedance.com>
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

Link to v3 (incomplete): https://lore.kernel.org/r/cover.1684821877.git.peilin.ye@bytedance.com/
Link to v2: https://lore.kernel.org/r/cover.1684796705.git.peilin.ye@bytedance.com/
Link to v1: https://lore.kernel.org/r/cover.1683326865.git.peilin.ye@bytedance.com/

Hi all,

These are v4 fixes for ingress and clsact Qdiscs.

Change since v2:
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


