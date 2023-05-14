Return-Path: <netdev+bounces-2436-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1568701F4F
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 21:52:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6F4F1C209BE
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 19:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2074BA34;
	Sun, 14 May 2023 19:52:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26F21877
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 19:52:33 +0000 (UTC)
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6521DCE
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 12:52:32 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id af79cd13be357-75774360e46so441799385a.2
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 12:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684093951; x=1686685951;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OSTE2EBzjtyK1nC8QYLZAUhuBEohE0E+dS8BewQx3HM=;
        b=miXcUjXY7SD9AlRlv5PLIXswujvul1bWGqHGDou99qrvu8a0yMFfq4X4EEL4gUZWA8
         m0HyXb0GtcevTXO4o8oIxnHqKFr0E0ykAK9wEzEEXphTd0csq+YxHcUzt2nWRbQGGsJF
         XF0TMq20ubW1lMD8aLw4SQOQC36GD9hjLii/uvRz116fdyFwW1chv542Uwi5EqpwgZ8i
         NUZLNdb9LMF62zTmNS04LkjdZvMDKwQDy1EWkw7sdyfaBSCd7AlgmbV+YW3WKW3IGwJe
         kaj75eMrTuAW9QX4+l58J9GJitJVSOPO106KWwubRLcmX/UZL1SWihZ+PMmBnbCV4HhF
         MSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684093951; x=1686685951;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OSTE2EBzjtyK1nC8QYLZAUhuBEohE0E+dS8BewQx3HM=;
        b=XtMZ6Ks1EHxjpJz3FquqSdLpXOAiOU+G+8KoRg1v3wDAEMSODWXWB23nxzJuq63K9k
         9OZ0M/fUuIs8XVsmhrhKDO1XPurmzLGkm4UfKqeO+cL4SvYwL7f9+0TBxTuRyczNffpv
         Oy7C5BTloi+J7bmkVKCyKS4POLLDztB4pfAOlMC8AWAIQYhgNpKHTKHTYXe4Oc0EB5zm
         OzzDOnYSCWdPtHGlPToi90EBgJsS9SJkxploXelUxvQD8nFRqdilGAsH7yZUqglFy9Z0
         xFQAWFfXKEBBkSmkwQL/jBVLZRAHjj6Q4LvciEyiPLBpCc1YvV7h69WPmWVz4gzEGOtk
         CyGQ==
X-Gm-Message-State: AC+VfDyVVZFNbHgO5uXKlT2Crxw92PhspHSl4UH3yllQpyokiaiNHU1F
	1SC0bzXSPHi2uzSuPROMCra/JpIPe5kT4Q==
X-Google-Smtp-Source: ACHHUZ6GFy+ge9X0Ec5T70Wr+aNFhiEgoHC6P/cZeBfbrBk2+3ZzGx6FD0LCQWp4UQMLCQxfw2AAnw==
X-Received: by 2002:ac8:5b01:0:b0:3ef:413b:71be with SMTP id m1-20020ac85b01000000b003ef413b71bemr46859040qtw.68.1684093951173;
        Sun, 14 May 2023 12:52:31 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id fa11-20020a05622a4ccb00b003f517e1fed2sm1069444qtb.15.2023.05.14.12.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 12:52:30 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	tipc-discussion@lists.sourceforge.net
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Tung Nguyen <tung.q.nguyen@dektech.com.au>
Subject: [PATCHv3 net 0/3] tipc: fix the mtu update in link mtu negotiation
Date: Sun, 14 May 2023 15:52:26 -0400
Message-Id: <cover.1684093873.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
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

This patchset fixes a crash caused by a too small MTU carried in the
activate msg. Note that as such malicious packet does not exist in
the normal env, the fix won't break any application

The 1st patch introduces a function to calculate the minimum MTU for
the bearer, and the 2nd patch fixes the crash with this helper. While
at it, the 3rd patch fixes the udp bearer mtu update by netlink with
this helper.

Xin Long (3):
  tipc: add tipc_bearer_min_mtu to calculate min mtu
  tipc: do not update mtu if msg_max is too small in mtu negotiation
  tipc: check the bearer min mtu properly when setting it by netlink

 net/tipc/bearer.c    | 17 +++++++++++++++--
 net/tipc/bearer.h    |  3 +++
 net/tipc/link.c      |  9 ++++++---
 net/tipc/udp_media.c |  5 +++--
 4 files changed, 27 insertions(+), 7 deletions(-)

-- 
2.39.1


