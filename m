Return-Path: <netdev+bounces-2497-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03289702421
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:08:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36DCB1C20A26
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CAEF3D64;
	Mon, 15 May 2023 06:08:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2680B4414
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:08:30 +0000 (UTC)
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BB740F5;
	Sun, 14 May 2023 23:08:14 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-64a9335a8e7so18142720b3a.0;
        Sun, 14 May 2023 23:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684130894; x=1686722894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GGQN+IFzyHGFwqOlfR1U58HtbwWoZK/17aspQ8tsf60=;
        b=Q1Cgu2wlHY5eN6wxzurVVbRS5RN9wRDa5A49GNKD86YqXzVUMQgWGUT8PsT5tNf+jk
         Zq0e+50cJDFS84Js5FqsA1b6zNPg7MEgGxz0XVUX0dg9uV+czeYCEhIaCnhNSSAGTY7k
         7lhiVMTcSv+LOG7pJ6W6JGWQBVLQ65+9F1l+HGrFxVUXYYr+Bt24X9b/Ja/VW+y9hUsP
         qn/UEukFKj/2u+sx2+TonTM+fnXsnmhu5WH7WleInx0QmYz+wjVYXGaba6IHw9fChqUQ
         DrsJX1kuWfUYfbamlfeoow91odElVVzLdyDKDVcSKt57hpWH075g5aGQxcGIc74YcrHA
         RsZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684130894; x=1686722894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GGQN+IFzyHGFwqOlfR1U58HtbwWoZK/17aspQ8tsf60=;
        b=btOaO6rXZO4LQIil5vJGVFozluMWS4UFWvI0OiRZgv3cOGFIBNAQk5lmCZ6sgRyBIv
         qwffV94IpyfPff6r1/5mqBjLb5z20jJhLqijUxItLr6eamO5DmPd2Uqql3H1b2q1gfxD
         lIpQl7bzAuMYT1RCo032p53PUEiO+6DgL8NxOMohESEjuyGeZkHj5vcMfN/N1V35o1pl
         NSdRW62zHQuI61aN3D+X13jnzpOh1uViDsfdPEWvZIeQsbwjwTX6guxXZxwN0RUEUhOP
         REICWTM/qmP/4IwKbO1x2JxfvrLzaIQ34V0GHl9AJn8kUcCGZ1TRAWINBSj/Eml8Pfk0
         KKkw==
X-Gm-Message-State: AC+VfDwSvThOuYZSRPshr04tZbJVUOzMveVLr/DUHvuHOA1SWBWptvZz
	1cpZCPAIbSvmnhetVv6l1tw=
X-Google-Smtp-Source: ACHHUZ4/UEun26pGUZqq6DT4kU1Kj1WoNtxMe53I8qFdL+ScEdmrJWFY/w0skH/6lZWeANhL8KlXIQ==
X-Received: by 2002:a05:6a20:72ab:b0:ee:9647:45fa with SMTP id o43-20020a056a2072ab00b000ee964745famr34775912pzk.20.1684130893951;
        Sun, 14 May 2023 23:08:13 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-77.three.co.id. [180.214.232.77])
        by smtp.gmail.com with ESMTPSA id c19-20020a62e813000000b0063b806b111csm10914151pfi.169.2023.05.14.23.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 23:08:13 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 10FC71069A9; Mon, 15 May 2023 13:08:06 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Networking <netdev@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sam Creasey <sammy@sammy.net>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Simon Horman <simon.horman@corigine.com>,
	Tom Rix <trix@redhat.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Thomas Davis <tadavis@lbl.gov>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net 1/5] net: bonding: Add SPDX identifier to remaining files
Date: Mon, 15 May 2023 13:07:11 +0700
Message-Id: <20230515060714.621952-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515060714.621952-1-bagasdotme@gmail.com>
References: <20230515060714.621952-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2509; i=bagasdotme@gmail.com; h=from:subject; bh=dti2QBePSyBHOzwqWzrlBSPRr5TgVdD7vsNTmsN5N94=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCmJZwRO/FtrM21W5UteZxHNfDYbiZSX2b+ajnmW/Pdy+ Mv6Myimo5SFQYyLQVZMkWVSIl/T6V1GIhfa1zrCzGFlAhnCwMUpABPpymb4X7w/4rmbbOCaQ598 rU0viF968nL6iitTn0e4iq2x8vuT9YPhf925h9kbmnnfKz8MV32pnFJuuL3rJpNIOtd+gcwXGu9 2cgMA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Previous batches of SPDX conversion missed bond_main.c and bonding_priv.h
because these files doesn't mention intended GPL version. Add SPDX identifier
to these files, assuming GPL 1.0+.

Cc: Thomas Davis <tadavis@lbl.gov>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/net/bonding/bond_main.c    | 3 ++-
 drivers/net/bonding/bonding_priv.h | 4 +---
 include/net/bonding.h              | 4 +---
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 3fed888629f7b5..73059bff425729 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1,8 +1,9 @@
+// SPDX-License-Identifier: GPL-1.0+
 /*
  * originally based on the dummy device.
  *
  * Copyright 1999, Thomas Davis, tadavis@lbl.gov.
- * Licensed under the GPL. Based on dummy.c, and eql.c devices.
+ * Based on dummy.c, and eql.c devices.
  *
  * bonding.c: an Ethernet Bonding driver
  *
diff --git a/drivers/net/bonding/bonding_priv.h b/drivers/net/bonding/bonding_priv.h
index 48cdf3a49a7d74..fef6288c6944fb 100644
--- a/drivers/net/bonding/bonding_priv.h
+++ b/drivers/net/bonding/bonding_priv.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-1.0+ */
 /*
  * Bond several ethernet interfaces into a Cisco, running 'Etherchannel'.
  *
@@ -7,9 +8,6 @@
  * BUT, I'm the one who modified it for ethernet, so:
  * (c) Copyright 1999, Thomas Davis, tadavis@lbl.gov
  *
- *	This software may be used and distributed according to the terms
- *	of the GNU Public License, incorporated herein by reference.
- *
  */
 
 #ifndef _BONDING_PRIV_H
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 0efef2a952b79e..d46af0571758af 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-1.0+ */
 /*
  * Bond several ethernet interfaces into a Cisco, running 'Etherchannel'.
  *
@@ -7,9 +8,6 @@
  * BUT, I'm the one who modified it for ethernet, so:
  * (c) Copyright 1999, Thomas Davis, tadavis@lbl.gov
  *
- *	This software may be used and distributed according to the terms
- *	of the GNU Public License, incorporated herein by reference.
- *
  */
 
 #ifndef _NET_BONDING_H
-- 
An old man doll... just what I always wanted! - Clara


