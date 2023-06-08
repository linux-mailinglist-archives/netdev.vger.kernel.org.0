Return-Path: <netdev+bounces-9222-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44CF1728122
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 15:21:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F382228162F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD23012B7C;
	Thu,  8 Jun 2023 13:21:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8BD12B73
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:21:13 +0000 (UTC)
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B1B1BD6
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 06:21:11 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-30ae4ec1ac7so426043f8f.2
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 06:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686230470; x=1688822470;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JrLkSqBXuXFaPtOlLMxDD4QQOh/SbBZYNkY7RLKJl40=;
        b=Yg8gZkNTI+QaGC7zmMGDlRLZgD+hwa9fiSskHeCXWMpONvKCeHrMare89xI66O5SLi
         qK+YB2/pCdU2ZcvhUwk/heyho8yvRwZT3jCm/sW9Zvmyu/Axl2MVVJtDNK23i88wzdOT
         ES0wozDmJ/BiEVMCeoMnk/gi+EiFTYBlT0osi/kW/uICdpFx8gH+qKC5+ERA4tZQrQzf
         eTUeXdpalDjJSGGq0a1bSHlmQ1NHGUAZnhAmBwxlUSjVi/XvltuABc7Pf/hPDMPf35+Q
         Y9V9Mgtaaii6YKY/VmUhattjBomXD10zXYdruNnycw+7Pe137H6WvT/12qe5id1OnlsD
         vXQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686230470; x=1688822470;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JrLkSqBXuXFaPtOlLMxDD4QQOh/SbBZYNkY7RLKJl40=;
        b=Ec9ZNObnwTkY57Yz0jWxdRAD6Rl8inEQari8uZkOsCTiiKicz4tgYubYZgAIKNgWPm
         I/AwbdwR5wFuY12HG2+FyjLkF7RgVDc3D1ero4I1W5DOtu47zyVWTGsE0bS/h9gAFFGg
         XW77kfKzNXvlyhosarqzBtD9QHWrnKUtuQXGLuWLF5dP/KFa7S3JDNQl3WPVvvfpQJJ6
         Gt5BOB40i18/NLnHcSTop7FCAkQ+1ORW/wyaRBnWPxcZmwjKo7ofsNPeiUXph9//RPH6
         I/A/qdPHVfiFCW3lK6iZt6pFWo353Dz9sCg2YXLH+/vBolnYD0RZ8mCJmKacufKsf0DX
         mSRQ==
X-Gm-Message-State: AC+VfDzUhjoQL+Q4YLzh7mbhM74upVDGicC1R+TdhRSnG0iSCZEWdfuA
	8G8uJOSp6s0uRmn1Zdg0A4fca8kvOCJcLeR9YH7Ksw==
X-Google-Smtp-Source: ACHHUZ4OOQXSdAgl30N4JRXHi0RCBmxm5KUs8n+YpjgHEKZlHmzL2uB9axV7caQ1xk9lUpBU5h/LNA==
X-Received: by 2002:adf:edcb:0:b0:309:41d8:eec4 with SMTP id v11-20020adfedcb000000b0030941d8eec4mr7124852wro.39.1686230470319;
        Thu, 08 Jun 2023 06:21:10 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id 16-20020a05600c021000b003f7f1b3aff1sm5001100wmi.26.2023.06.08.06.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 06:21:10 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net-next 0/4] mptcp: unify PM interfaces
Date: Thu, 08 Jun 2023 15:20:48 +0200
Message-Id: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-0-b301717c9ff5@tessares.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALDVgWQC/z2OzQ6CMBCEX4Xs2Y0VK/68ivFQylb2wNp0i8EQ3
 t1igoc5fJnkm5lBKTEp3KoZEr1Z+SUFDrsKfO/kSchdYahNfTSNueAYNSdyAwrlkinjvxpi9hF
 H4fDBOCBLphScJ0V7PYdw6sg2lqCoW6eEbXLi+1We95t1LWOiwNPv0x22FXgsyxfvJHDsrQAAA
 A==
To: mptcp@lists.linux.dev, Mat Martineau <martineau@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Geliang Tang <geliang.tang@suse.com>, 
 Matthieu Baerts <matthieu.baerts@tessares.net>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1112;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=PksWG9xpjpNR6taGD8lcKubOv6ngqDUSLnkTPjYnXCc=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkgdXFQUslVvsp15U+xKqFpBZ7y2jt7uScqvHmy
 fcsE86kucmJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZIHVxQAKCRD2t4JPQmmg
 czyqD/9HRQx7w5GuMDuHNwmVsIBetoSufo+y5mLulkSMoxJtMUL/PDvEJL5s00rHTqFdjiIGpzK
 hDk065KHpY7AeVH8GZX6IhkyMTYkN/XOuAc7hO9gZrh8s1AXxNb2MidpHd6Bphaq706NvaBI1U6
 kmewaDEdPjCcQJG456ORjGdqsnxBCZpqjC1tP6mMk1E7+HiINBGPh9Qm/3wGsNArLz3Ust64X6E
 4DLTI34hNnTyIIkhTdDWXhfZmleIRzlRVkffF6xieuhboYVLD15n78vjWmUdLWI2hE+d/Et7aB/
 HfaDrYyeaigUUKT4rC+UXbJk2dgjsFteWj2FJr4/gUyh4bmpzAR+30vsav/SqMjDjorb8FVMoEF
 iHwum99/9D2IXnSzlt4l62H3BOqXClacc0nTUCypurP/L71gF07FMpW120avJrUqIlhi8ICaFWQ
 +79mjUuj0v7UWG3DoBmIdmIuv2/ZkMDWkSlvCIYUQTJQpMVWrYDT/xLrG6+LZKm6z0rYozFyddW
 gT1Q+f6UcwMjxN8x+ag/vgQZad7Q3GyZTGeu145qjgAZ6mI9ncZQdyJvtlZNpcFSbKHWDXCephp
 6Om4+lAmSFPDwk8VJ+be0PyY935h8dzFX1WFvdJOK9FG5lrwfw22CAa1tXVpVtuVSM7egc3NzyZ
 dEhZY/hzSWreDjw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

These patches from Geliang better isolate the two MPTCP path-managers by
avoiding calling userspace PM functions from the in-kernel PM. Instead,
new functions declared in pm.c directly dispatch to the right PM.

In addition to have a clearer code, this also avoids a bit of duplicated
checks.

This is a refactoring, there is no behaviour change intended here.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
Geliang Tang (4):
      mptcp: export local_address
      mptcp: unify pm get_local_id interfaces
      mptcp: unify pm get_flags_and_ifindex_by_id
      mptcp: unify pm set_flags interfaces

 net/mptcp/pm.c           |  41 ++++++++++++++-
 net/mptcp/pm_netlink.c   | 132 ++++++++++++++++++++---------------------------
 net/mptcp/pm_userspace.c |   3 --
 net/mptcp/protocol.h     |   9 +++-
 4 files changed, 103 insertions(+), 82 deletions(-)
---
base-commit: 4a56212774acf71a7356026fb11b78228a7ad24d
change-id: 20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-497ff5de464e

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>


