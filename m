Return-Path: <netdev+bounces-6854-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE5C67186F4
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:01:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62F401C20EDC
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:01:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3B581772C;
	Wed, 31 May 2023 16:01:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64FE171B8
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:01:52 +0000 (UTC)
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8B512E
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:01:47 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id af79cd13be357-75b076babc3so387399185a.3
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685548907; x=1688140907;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hPadyalwEIplJmU4cFCfoOtstQH2mCTmJAS0pltpVVg=;
        b=SsAObMdtfqZqE9biaC+tDI5oDnZKpXsRNnFnODO3b0QsQPj2sqXJPlQQuHpxFjv1o/
         PBuoxbQV/1KOFKPR5FjZnBzH5Ca5PzGgcaBCnoWGh5PMz29g/EO98cSqOERvCN/dTBnd
         DNGa/Nw+KeXnhcHtQgzFRW20ApQV3kLffVSlqkM1BWd7GyTyndwF4Qm74roFwDqI0dTZ
         y13/qcN+/R9yojtvo0GhWfqHRl2OOGr25utO248jqnurLx4D92QrC3LmDt/0baX8R4xP
         lHsyuqMYVa5DXyCLEbJzlEzw1QLJyACXit0mUxwt8HgOLSPvhS6hJz18G+waKKoptbe2
         IxXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685548907; x=1688140907;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hPadyalwEIplJmU4cFCfoOtstQH2mCTmJAS0pltpVVg=;
        b=X66e6EnVRnC3h2KQBFYmjKSvK/JPnF0dsiIRgw5dG4QYokiYMpSz3aWzwibRVRSAsx
         68X6CSsUqNAiH0r3eyJWY9Sr0+JnrEkO7cUkVh3jkdKNI+z8zVgFlqhrUmIMSKrGQ8rU
         SZrqP3/a85CJu44A+4ItVqPLuTK2zNrKhms72e871zaCtepoQT68i391aFUjjifM+CF4
         MApQrFiO0rlUkLqgW9+6RbyCodLfJpM84fYt5Xc3laWUx6z1aEqc3KZXPkPypp5sGW//
         OKZCQljOwgpYUpQs59lQX5X4wnE95WESm4U2/C9h7jilT9exCBQ7ZGWz8d8/AokPitKN
         c+BA==
X-Gm-Message-State: AC+VfDy/OQlNLj/+QCah/CQhWto9fRMfZ7aknSJA0MA1sTdpIRn74F/o
	tNovzoeyR/vctRiNCMAl4ry7+Fiur17J0g==
X-Google-Smtp-Source: ACHHUZ5y3Na3hk/PVX/S2zLSBGsj8tCDzG5uA80XuqUP8Nc/agzRG+iVLfIKyQaloBNnFe8ytSToLw==
X-Received: by 2002:a05:620a:8a83:b0:75b:23a1:366a with SMTP id qu3-20020a05620a8a8300b0075b23a1366amr5055455qkn.43.1685548906724;
        Wed, 31 May 2023 09:01:46 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id s11-20020ae9f70b000000b007594a7aedb2sm5261050qkg.105.2023.05.31.09.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 09:01:46 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Thomas Graf <tgraf@infradead.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCHv2 net 0/3] rtnetlink: a couple of fixes in linkmsg validation
Date: Wed, 31 May 2023 12:01:41 -0400
Message-Id: <cover.1685548598.git.lucien.xin@gmail.com>
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

Add validate_linkmsg() check for link creating in Patch 1, and add more
tb checks into validate_linkmsg() in Patch 2 and 3.

v2:
- not improve the multiple times validating in patch 1, and will do it
  in net-next, as Jakub suggested.

Xin Long (3):
  rtnetlink: call validate_linkmsg in rtnl_create_link
  rtnetlink: move IFLA_GSO_ tb check to validate_linkmsg
  rtnetlink: add the missing IFLA_GRO_ tb check in validate_linkmsg

 net/core/rtnetlink.c | 54 +++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 16 deletions(-)

-- 
2.39.1


