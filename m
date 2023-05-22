Return-Path: <netdev+bounces-4437-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28CEB70CEC6
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 01:51:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE0751C20BCC
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 23:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E32717739;
	Mon, 22 May 2023 23:51:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E396174E8
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 23:51:55 +0000 (UTC)
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B209CFD;
	Mon, 22 May 2023 16:51:52 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 5614622812f47-39425ea8e1fso3894513b6e.3;
        Mon, 22 May 2023 16:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684799512; x=1687391512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u3CYQ8eoIXMrRZaPgS+nlxvKXLt4zXlm3Geu0X4USU8=;
        b=L+HOSPm9x3ux1/Lm43bQy3Rrnl/JsrsIH1E+QxXq4kl/T1TW2aOZUBJ1s53qA5QPZp
         E4qDks4emrQjMzNc9byD/9c25gKZJ2xMrhf6ZXfu3iGT/3yyM/nm2uiu1EERuryt7Cky
         K0WgXj441FnW9CP6ksu+nqMFhJZgLDDp6fHYrbqs1ZtIprOvntoSQuGZ3Srl5GG2NEn5
         WQHKyMABm1HljLT8gyFgOfpgrh+osskuamsw3auFcU5US/ICsggjKTSESb2DiUNG5KeT
         7rcY074l7TVl8/8ELFNddv+m6YcwSx2ZMHzLOzp2cuBBnNWtpAksv1b3ifyqFQrddsyA
         2+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684799512; x=1687391512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u3CYQ8eoIXMrRZaPgS+nlxvKXLt4zXlm3Geu0X4USU8=;
        b=OsbrVSprZbamPpPPS1uYM7gtAwFRvcl1h4PxKh1FIMZqQbBbrWOXcUWG8N1rsSLGFI
         CRy1r2pImSo0J6i4wl9uxvYSCsK70pMnLYZQsHgelx4eibljDUeXGbLvD+iuYamktf+P
         IdOYgkt7hB7Cl0q105DDjItdC5F3LJv2mXz5eX8tBwNwxGcI63kP4+5Jwd/tf/v0HyP7
         xhg4Ke3dRQ1JRk/+sK+rMPcSFZDVofjZMfGGvtThNRbz/2zNiSGyCwo73MuimM64hv36
         oujkSP/LjNC+tZu0xeQohj1WGGw1azjbHcSfP8VzyW/SQD5rXh1G161eoIHdSHwoDi3S
         c4qQ==
X-Gm-Message-State: AC+VfDz0nA0tnIiqBYHbQOgpsy5pMDONmXGvg0Kz3ir5VDt8bywivABp
	KdXZyeXTlqlpCkGsg9qR0g==
X-Google-Smtp-Source: ACHHUZ6B2Jo/V/vFJqsHEZIbxqzN2Yzv3mYc9z6/Iuo9L7Lgr97x+JEYRLtaL8G54gMGmmvOUlrePg==
X-Received: by 2002:aca:1a0b:0:b0:394:5402:14cb with SMTP id a11-20020aca1a0b000000b00394540214cbmr6076788oia.21.1684799511943;
        Mon, 22 May 2023 16:51:51 -0700 (PDT)
Received: from C02FL77VMD6R.bytedance.net ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id b63-20020aca3442000000b0038934c5b400sm3299226oia.25.2023.05.22.16.51.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 May 2023 16:51:51 -0700 (PDT)
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
Subject: [PATCH v2 net 0/6] net/sched: Fixes for sch_ingress and sch_clsact
Date: Mon, 22 May 2023 16:51:06 -0700
Message-Id: <cover.1684796705.git.peilin.ye@bytedance.com>
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

Link to v1: https://lore.kernel.org/r/cover.1683326865.git.peilin.ye@bytedance.com/

Hi all,

These are v2 fixes for ingress and clsact Qdiscs.  Changes in v2:
  - for [1-5/6], include tags from Jamal and Pedro
  - for [6/6], as suggested by Vlad, replay the request if the current
    Qdisc has any ongoing (RTNL-unlocked) filter requests, instead of
    returning -EBUSY to the user
  - use Closes: tag as warned by checkpatch

Jamal, Pedro, would you like to take another look at [6/6]?  Thanks!

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


