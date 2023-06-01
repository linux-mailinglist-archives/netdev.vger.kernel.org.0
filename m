Return-Path: <netdev+bounces-6954-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 17FEF719044
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 03:54:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 543021C20F92
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 01:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD10B186F;
	Thu,  1 Jun 2023 01:54:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A7A1101
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 01:54:27 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C705A3;
	Wed, 31 May 2023 18:54:26 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64d3bc502ddso473695b3a.0;
        Wed, 31 May 2023 18:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685584465; x=1688176465;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PFuYwyFBcWrT5mue1dYYY+Cg2zEWocJdVmRUK721EAY=;
        b=Eo+L8FR5w4IVrh50+mjZbbIKGEoWzThvxeryn150Uj7iuj29kUkZ8bkTyHu7UxykiV
         MJ87rke5qBpO3WgWnzdcjzOgDyQr5g2MAV9w5qvHfS+hii/JkWKpEvVSZIcFAoGOnPj5
         ftkJ3Jj5zbVKyY3E4aPNpbr38yH3ybSPeDKeeGj7OqpJmUWPPMR2HsWoTOJFYDQZjnvL
         62GnU7BLl9eZzOgXEoTRLYPbi5fsGnNHW3t8uKJKf8comMurHRTVjE2xNBq0QksAjhK2
         1PnjRjvutoqbukvts5u5bp+g+tj5IguDDWy/8bl4PqAQ0OSubhSYDVipZ1k29uHMspGm
         xVng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685584465; x=1688176465;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PFuYwyFBcWrT5mue1dYYY+Cg2zEWocJdVmRUK721EAY=;
        b=j5VwuhvsVw8BH0dJPXoxhdkXpCsw6gcJxiqRNexHzj6kHimKt7LnH5OUIjsm4fXKW6
         ssw0e3yGo8noYqiUSd8+9aLTeofQFRRPaKh2ntMD/U9gsUDvjPSSm9IzmGvPFj1vRDNQ
         RSQdXcC2eQMbnXXlVHMMCY/d2JnSD9gWcM7jbQo5bowf4atAffkJj1MoHJm6UIOLsP57
         J+RrK3NhTvzaEtb+oWmy6kMKx0Th1I5TwgjhCwSyvuqblm2oN048HZ68vUgteFBHZsdz
         4HVYlggp3GYdvcNthCg9ZOcuKvBHExbja3A0n30sCsY7I8408OIH0geIi0L1oVREILTK
         m33w==
X-Gm-Message-State: AC+VfDxPkDEUgl9QQiBOLSO3mzyC4qx15IcNm3o7JKBsft8ItuErWt9a
	9U6XHrJ+JNmeAPRBVhFNbxBrvaEKGPbAsEHc
X-Google-Smtp-Source: ACHHUZ7S9n+qUfCvkYHxAINOiUjk3ra3BccTYx/4bGtDp06qetX0Jgsgvf7vpr1md2NRqSOCbQ24Hg==
X-Received: by 2002:a05:6a00:856:b0:64b:f03b:2642 with SMTP id q22-20020a056a00085600b0064bf03b2642mr9556866pfk.23.1685584465511;
        Wed, 31 May 2023 18:54:25 -0700 (PDT)
Received: from DESKTOP-4R0U3NR.siflower.com ([180.164.63.52])
        by smtp.gmail.com with ESMTPSA id e14-20020aa78c4e000000b0064381853bfcsm3928430pfd.89.2023.05.31.18.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 18:54:24 -0700 (PDT)
From: Qingfang DENG <dqfext@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
	Masahide NAKAMURA <nakam@linux-ipv6.org>,
	Ville Nuorvala <vnuorval@tcs.hut.fi>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Qingfang DENG <qingfang.deng@siflower.com.cn>
Subject: [PATCH net v2] neighbour: fix unaligned access to pneigh_entry
Date: Thu,  1 Jun 2023 09:54:32 +0800
Message-Id: <20230601015432.159066-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CANn89iKRX2QTgS44Ky6Jua-+UNrFY3E7RCT_7OfG=GnFvAzdFQ@mail.gmail.com>
References: <CANn89iKRX2QTgS44Ky6Jua-+UNrFY3E7RCT_7OfG=GnFvAzdFQ@mail.gmail.com>
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

From: Qingfang DENG <qingfang.deng@siflower.com.cn>

After the blamed commit, the member key is longer 4-byte aligned. On
platforms that do not support unaligned access, e.g., MIPS32R2 with
unaligned_action set to 1, this will trigger a crash when accessing
an IPv6 pneigh_entry, as the key is cast to an in6_addr pointer.

Change the type of the key to u32 to make it aligned.

Fixes: 62dd93181aaa ("[IPV6] NDISC: Set per-entry is_router flag in Proxy NA.")
Signed-off-by: Qingfang DENG <qingfang.deng@siflower.com.cn>
---
v2: remove the ifdef, and use u32 type

 include/net/neighbour.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 3fa5774bddac..f6a8ecc6b1fa 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -180,7 +180,7 @@ struct pneigh_entry {
 	netdevice_tracker	dev_tracker;
 	u32			flags;
 	u8			protocol;
-	u8			key[];
+	u32			key[];
 };
 
 /*
-- 
2.34.1


