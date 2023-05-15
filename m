Return-Path: <netdev+bounces-2501-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC575702426
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:09:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 802151C20A80
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7624D8466;
	Mon, 15 May 2023 06:08:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658924C9C
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:08:32 +0000 (UTC)
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0EE3598;
	Sun, 14 May 2023 23:08:16 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-24df4ef05d4so10510413a91.2;
        Sun, 14 May 2023 23:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684130895; x=1686722895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hfguBYqH7ezFanFXbeyqdFX+oI6iArq407jK+4Ezaak=;
        b=YwXJZ5F9gOSCnPbRDSo+YC2z8mVPsmRq0aBg0r+D4h+HeSFcym4sFmBPYQPR9AfSz/
         bA2TKXd1Aw9sGVa/e2Oj9aXQ5zurUwaNwr5XDkiS3RtWVmW8+SuU6JK+8RcDaSMyhKUr
         ro5N8Ji3Sv4FSNF9zB3T6w0vPsyNSRjzFv9yLjFqqjyg4ea62YLu9tD2PNe8lrK2akEn
         KeKJxo8P4RVG78iRoR5X7x4mAHGMpwtPihy/xQlpW87GaROL3T3iFfaDpT8uwivtrspE
         FCcT4p7Rcfnu6L52YiHdZWiLR9O6qWmimFVqpm10Up8UEj+hLkgZkiqCWidQoT2JaSx5
         Z+4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684130895; x=1686722895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hfguBYqH7ezFanFXbeyqdFX+oI6iArq407jK+4Ezaak=;
        b=UBEN0nVOrHdLGM6CsYyRxzTgAR69PYifUWuv3Hr2ofvLshySqt9T6YGlxrrb+uIj1o
         7flBrpEQ27OGr+gIpqU/1ETBEu0SlkOSjwd1mE4KeKzdt3I1+xWeXlyrrw3WcYY1goHl
         yyxXyKVpu5kpvt1nodOsipcR3FvxR8TA8FbP1oZKeQVlLBfK2K2Af7rUIzM1btdaqKTt
         thpan36RRzOQkwbKN8Eq1D8LugJgX+nvAKCFqEG8F4vHaB0FYqUtnKpyG1RbPDOVn0sW
         nUgST45RghdpORGnYlvDD6N5XRklJX4qlZkx/tMHBDFNFCDn+ViEIzivIANQk59GiHlV
         0CNA==
X-Gm-Message-State: AC+VfDzoBkXt1dE/muUM4inmNlm5cYucq+TnBWHHaeJ+wAGXlQST/Mbe
	kR9hH+tNGhk+RfOkgVqfepY=
X-Google-Smtp-Source: ACHHUZ4C5c+SnFrXxJYudXtKVYZKSsGrX6qMIjVhf67/qQeg5aHW4cMqA+LuMnzplakA3MM7ZF6AVw==
X-Received: by 2002:a17:90b:2354:b0:24e:df1:df8 with SMTP id ms20-20020a17090b235400b0024e0df10df8mr30191616pjb.49.1684130895593;
        Sun, 14 May 2023 23:08:15 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-77.three.co.id. [180.214.232.77])
        by smtp.gmail.com with ESMTPSA id q22-20020a656256000000b005287a0560c9sm10241532pgv.1.2023.05.14.23.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 23:08:13 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id DC073106757; Mon, 15 May 2023 13:08:07 +0700 (WIB)
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michael Hipp <hippm@informatik.uni-tuebingen.de>
Subject: [PATCH net 5/5] net: ethernet: i825xx: sun3_8256: Add SPDX license identifier
Date: Mon, 15 May 2023 13:07:15 +0700
Message-Id: <20230515060714.621952-6-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515060714.621952-1-bagasdotme@gmail.com>
References: <20230515060714.621952-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1221; i=bagasdotme@gmail.com; h=from:subject; bh=EvtqHdDdbXt8y8pYC5PpBUPs5rIxtePgE9WAtfdyb04=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCmJZ4QuauX6vLi35rvrGa3FP75P+CCckHlXzK9muU9N0 bMDN+cqd5SyMIhxMciKKbJMSuRrOr3LSORC+1pHmDmsTCBDGLg4BWAiPzYxMpwr/7Li8IcbRtLc /+ce4rGISdzmsnHD+a/SMzem11c+vPOLkeFN6cMdxhWpf5kVf30JufR6pjK/hDCTyaqlb37otHE obWEEAA==
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The boilerplate reads that sun3_8256 driver is an extension to Linux
kernel core, hence add SPDX license identifier for GPL 2.0.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michael Hipp <hippm@informatik.uni-tuebingen.de>
Cc: Sam Creasey <sammy@sammy.net>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/net/ethernet/i825xx/sun3_82586.c | 1 +
 drivers/net/ethernet/i825xx/sun3_82586.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/i825xx/sun3_82586.c b/drivers/net/ethernet/i825xx/sun3_82586.c
index 3909c6a0af89f9..5e27470c6b1ef3 100644
--- a/drivers/net/ethernet/i825xx/sun3_82586.c
+++ b/drivers/net/ethernet/i825xx/sun3_82586.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Sun3 i82586 Ethernet driver
  *
diff --git a/drivers/net/ethernet/i825xx/sun3_82586.h b/drivers/net/ethernet/i825xx/sun3_82586.h
index d82eca563266a1..d8e249d704a76e 100644
--- a/drivers/net/ethernet/i825xx/sun3_82586.h
+++ b/drivers/net/ethernet/i825xx/sun3_82586.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Intel i82586 Ethernet definitions
  *
-- 
An old man doll... just what I always wanted! - Clara


