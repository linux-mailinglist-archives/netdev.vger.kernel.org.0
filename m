Return-Path: <netdev+bounces-1806-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E11A6FF316
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:36:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B32F1C20FD8
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D001D2A6;
	Thu, 11 May 2023 13:34:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440FC1D2A5
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:34:36 +0000 (UTC)
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E76410A08;
	Thu, 11 May 2023 06:34:19 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1a516fb6523so80950385ad.3;
        Thu, 11 May 2023 06:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683812058; x=1686404058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FYUYLtbs7KfpLD4I5Dqpb8BMTQvZKnVJ8qVnL1hB5C8=;
        b=at6ka6jNGjd4UsPayk9jEy1oDKwDu1ittNtsmOXT6qcnBSsGsR2izC3GWnK37KP+Hm
         rYaEQ/kR1edGF1qztqgQ1QR6/uRsGcB1tPG2wj6Y90u+/eTnbvykrY21zfxA2xdiK1cX
         MTDVeYEFXMY7zJhSAyhgD6tFvpsIbCdlPJ3RH+jAI6ZaIvo+O8XJ0dbEqwwGw+icrK4j
         Cl0Xum9N2KrxofQ+QzrPS7wAzNueHVaPpxxe1XcCDhnE3LHaNmJ+fzzhhch99G7IbyM6
         YDv7jf/9Paew6HAiuzUnr5WpmxretGw15dZwru+CVY20o5v6MaIkVpfuVqns9M1fTyUK
         rOKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683812058; x=1686404058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FYUYLtbs7KfpLD4I5Dqpb8BMTQvZKnVJ8qVnL1hB5C8=;
        b=j1uH5E5/pGSlIP8mlmFrQcnKDOrg4TizFxEzOx7oYI3iYDm8tiTM4Potpyo0dQJbyN
         nG2h/opkyhDqnSbev8H7EIf1FtStbhzhGsgOrc6wltiuOQ22oCjBAwPqg2aVxi5eC3Zc
         3Sk20+RTukTQLj/CLP1eu1kCC7c82qD0o9nVmf5VkV3hcyJ05iExGyynWnJmzq/QOFna
         gvUWOEFYMxRLiF6Q2HOdspVIsCKS6ZIqLfkU0ibC+HPAaBshin46Gaya2WB9JC5vew/v
         tAO3FwNUSkc4xheSzp1WAG9KaYlk6ySGA4mTgwKmMkB1RobtV1pluY/ViFNOH/nKOIPx
         lgNA==
X-Gm-Message-State: AC+VfDwDgtSZlil1YuQqgITjstYv4d+E3tn5cYjmgwieTr4lSpgr+jYw
	zI+9BMZjbseQPnmhk5rUjIE=
X-Google-Smtp-Source: ACHHUZ4ZCa3MPyTZWwhE0hr8Onh5crSmnn9r3Df3rija7+vx/kqL4xMF4JqUIaOPGaMpaopRBNbInw==
X-Received: by 2002:a17:903:32c7:b0:1ac:7345:f254 with SMTP id i7-20020a17090332c700b001ac7345f254mr20259399plr.33.1683812058459;
        Thu, 11 May 2023 06:34:18 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-92.three.co.id. [180.214.232.92])
        by smtp.gmail.com with ESMTPSA id t1-20020a170902a5c100b001a9581ed7casm5904903plq.141.2023.05.11.06.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 06:34:18 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 840A5106881; Thu, 11 May 2023 20:34:09 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Staging Drivers <linux-staging@lists.linux.dev>,
	Linux Watchdog Devices <linux-watchdog@vger.kernel.org>,
	Linux Kernel Actions <linux-actions@lists.infradead.org>
Cc: Diederik de Haas <didi.debian@cknow.org>,
	Kate Stewart <kstewart@linuxfoundation.org>,
	David Airlie <airlied@redhat.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Jay Vosburgh <j.vosburgh@gmail.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sam Creasey <sammy@sammy.net>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Jan Kara <jack@suse.com>,
	=?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Tom Rix <trix@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Pavel Machek <pavel@ucw.cz>,
	Minghao Chi <chi.minghao@zte.com.cn>,
	Kalle Valo <kvalo@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Deepak R Varma <drv@mailo.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Dan Carpenter <error27@gmail.com>,
	Archana <craechal@gmail.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 01/10] agp/amd64: Remove GPL distribution notice
Date: Thu, 11 May 2023 20:33:57 +0700
Message-Id: <20230511133406.78155-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511133406.78155-1-bagasdotme@gmail.com>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=810; i=bagasdotme@gmail.com; h=from:subject; bh=cTXyfFqh4XIWuVIHAAZjFpEqWqW9DnmtbLxCr872mbU=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCkx747te/M8Vo+lMJXzhvjKUKFq1Vs3W55/lkz/JrGk2 vKBf+eHjlIWBjEuBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAEykUoORYbnT/G8dH37kx7V4 bal3cy17/G/1BsF7nrM1gmOy7G8W/WZkuH5xZ8eJt5tjJjr89OdpK/lTU6G01P7gsZC38zZ3zLm 5jhkA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There is already SPDX tag which does the job, so remove the redundant
notice.

Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/char/agp/amd64-agp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index ce8651436609fc..b93b0f836e52ba 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright 2001-2003 SuSE Labs.
- * Distributed under the GNU public license, v2.
  *
  * This is a GART driver for the AMD Opteron/Athlon64 on-CPU northbridge.
  * It also includes support for the AMD 8151 AGP bridge,
-- 
An old man doll... just what I always wanted! - Clara


