Return-Path: <netdev+bounces-5481-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7924711986
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 23:49:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65AC11C20F44
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 21:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9942624EA9;
	Thu, 25 May 2023 21:49:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8265120982
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 21:49:40 +0000 (UTC)
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7C910EC
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:49:21 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id af79cd13be357-75b2a2bf757so17050785a.2
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685051360; x=1687643360;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eweSh9vtISosgcEBIw4xDdvPcCI3hZ6h8pWgOnj1omY=;
        b=nF1+mkW11gkrsSIsh1O5xRBHDyedWbFhacs4IA4jqoXGSJEruj28yLNk/yLvCo5RGL
         Q+y0sSwFsxeaMgxTJNHRdtHqEYOe06HjVdhx4jMyGPelHUaJOY5CsgKmlnNxG3QbxSEL
         9Bsm2x+NwgCeUx3eZiUaDyqdd1UrF9tAnsHDeAyeTgXKpfKqAS8uekxIFz2q+YGeDCZ1
         aIioXp1uAByqOI9R8Ieq+zaWNRT0zopNKLFtWDpDsH10RpQdsWGA+FipqFBJ5y1dj8yt
         CAr2ENPIfrdxD9LrV7mqizvNwv5eahv9Bq9OsTO8OT9S9qokW0MjQJCQSjjhNBASNNCm
         6/uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685051360; x=1687643360;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eweSh9vtISosgcEBIw4xDdvPcCI3hZ6h8pWgOnj1omY=;
        b=YEYsJ93v7FqDSJr0FKjbHBb+/vQlOPNcaUnIPakXz87gw3cz3qlaM6zZvZryep5mgK
         m1zhUTPpUBEvO3OQn4dfNZg3j4YNgNvGL6/qM6JmRiV7I/Z2K63f8vRTXPQ7IdmPWsjU
         jTV+0sRiPOe+oSNlwxruGRigK8kqHqTUzJ63tSZ/GkerWltjMjOCeTVs5cQXY/qSysU4
         Ws9aEhWn7h39X2UkIvOEDqYlnMGaFlHe3czUY9kIImJ91t0qcKm1MrBjtTwVtrb4kK8x
         M3sYYZviReevWtACyxAIZdh3Qgeebsy9P3pDc/B2R0JDaqqSqMo3xaIY9nI3X2k97iVE
         AoqA==
X-Gm-Message-State: AC+VfDxEocrmWm/Q3bWYUsW5FiyET1+1Ch7uc/2SCCdYft8dmgxXMnPC
	KIMbXu51qvqZYgiFECBmODQTAknJo0Q=
X-Google-Smtp-Source: ACHHUZ4XdweM292r3ep4oTdn/HgU/lalKw6f4R6f5AI0HToTk+dawWxiCu2EhzDNRbAtN7XYj6w2Xw==
X-Received: by 2002:a05:622a:115:b0:3f6:a888:5152 with SMTP id u21-20020a05622a011500b003f6a8885152mr1148014qtw.38.1685051359835;
        Thu, 25 May 2023 14:49:19 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x7-20020ac81207000000b003f7f66d5a0esm735742qti.44.2023.05.25.14.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 14:49:19 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Graf <tgraf@infradead.org>,
	Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH net 0/3] rtnetlink: a couple of fixes in linkmsg validation
Date: Thu, 25 May 2023 17:49:14 -0400
Message-Id: <cover.1685051273.git.lucien.xin@gmail.com>
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

validate_linkmsg() was introduced to do linkmsg validation for existing
links. However, the new created links also need this linkmsg validation.

Move it to the correct place in Patch 1, and add more tb checks in
Patch 2 and 3.

Xin Long (3):
  rtnetlink: move validate_linkmsg into rtnl_create_link
  rtnetlink: move IFLA_GSO_ tb check to validate_linkmsg
  rtnetlink: add the missing IFLA_GRO_ tb check in validate_linkmsg

 net/core/rtnetlink.c | 70 +++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 27 deletions(-)

-- 
2.39.1


