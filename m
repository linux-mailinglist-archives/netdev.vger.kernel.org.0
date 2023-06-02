Return-Path: <netdev+bounces-7499-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08B5972079D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:31:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 895DE1C2121C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 678B11B8E2;
	Fri,  2 Jun 2023 16:31:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDFC1DDF8
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:31:45 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F98DB4
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 09:31:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bb1e332f648so2321020276.0
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 09:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685723502; x=1688315502;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xlqqFN1N3rVCnY6AUfOw9K2CwKWKacY7NYVrRa3An0Q=;
        b=M3C4Zw/8dlLZJj3k8DVGcQiyDJVoUqSnHarsI6bXP/1+HgJUa4RC7TlRd4MVxtw5Bn
         nap2kRzpFSPYK5dnkzZxm8TebKC+WPRCWSlWAWaq9cyp+2HAuNVPRVMyZDuObw8PZDbc
         W2OIIX5xRvby8XpR9M6pmLJ/AMimy3NlyWhUhNhJB+BP3imsy9w6gfhM9EkZnMzqUItb
         2gtLbRrC+gQfNVYDhGPCMIZxnxpMJiIxBTw7mK/in328bwebHxHDEtK/IjffUA32xbrC
         Lk5MJXLEX6LtjNyjOD1pTBhIDHWlLfixJvlPvXlmlDTMcb6BbytZ8c5Mk/3R3ox35kRp
         TVDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685723502; x=1688315502;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xlqqFN1N3rVCnY6AUfOw9K2CwKWKacY7NYVrRa3An0Q=;
        b=NwTee0dUFfwb53UJS+4DahPFxESejgVnzoXENqPI/1b0+/vSnipnEIa6w8vnFBATTl
         A9BxXC4jNNGK3GPBEMaqm6o5Jpe2oY1RCcrBSBGipe1j3aPYIPnPZNSR8XxRJFvGGoKD
         Ep/ZC6Z6qmEJlWu37hpeJRrL0EZxTuw9Nl15hYnQNBsUf8YmATQZLPtxIfJy4ya/C0HM
         1L5rgULG/26YuHyqz67sNGFp/ktNwuEQD9ckVg1ivM5zfY88Le1le5ruN1WEJdCGqi/F
         jpzLluR2yDlT17pkwv98bNGMFCtO53TAtmp62ZrccynehSXL8i7OSV4DIxer6bTJi1qM
         51Ew==
X-Gm-Message-State: AC+VfDxXslpJctKiJIXHH6jUwNOm/AtiGtFD4rbW24oBtbv8oOtw3IFH
	11gENC42gvF+lBeP6IkezIVBN/+srduYaA==
X-Google-Smtp-Source: ACHHUZ5UdESuBbwDDrFsXQbwgpo6NKdHSyFNi32rN8gofPutgtrtwTW0xmV12G5xk9xpyaZW1iytnTyPE9glyg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1545:b0:ba8:181b:2558 with SMTP
 id r5-20020a056902154500b00ba8181b2558mr2289602ybu.4.1685723502747; Fri, 02
 Jun 2023 09:31:42 -0700 (PDT)
Date: Fri,  2 Jun 2023 16:31:39 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602163141.2115187-1-edumazet@google.com>
Subject: [PATCH net 0/2] rfs: annotate lockless accesses
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

rfs runs without locks held, so we should annotate
read and writes to shared variables.

It should prevent compilers forcing writes
in the following situation:

  if (var != val)
     var = val;

A compiler could indeed simply avoid the conditional:

    var = val;

This matters if var is shared between many cpus.

Eric Dumazet (2):
  rfs: annotate lockless accesses to sk->sk_rxhash
  rfs: annotate lockless accesses to RFS sock flow table

 include/linux/netdevice.h |  7 +++++--
 include/net/sock.h        | 18 +++++++++++++-----
 net/core/dev.c            |  6 ++++--
 3 files changed, 22 insertions(+), 9 deletions(-)

-- 
2.41.0.rc0.172.g3f132b7071-goog


