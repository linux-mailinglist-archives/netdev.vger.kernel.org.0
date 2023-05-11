Return-Path: <netdev+bounces-1809-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 305376FF31D
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E3D81C20FA9
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4958E1D2BB;
	Thu, 11 May 2023 13:34:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299381D2A4
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:34:39 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918C410E69;
	Thu, 11 May 2023 06:34:20 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-643bb9cdd6eso6252609b3a.1;
        Thu, 11 May 2023 06:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683812060; x=1686404060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+qd85DAYUoVARV/UQur45Soj2gLrv6sKgolbKo4DNkY=;
        b=ZCDul+K7uLaQUZcXDKjVmbjfoExTphoXNgcqea3sH4Mq2pae9JTgDXEapkrH4LBnCh
         koFeeQfJmQ/FOkKcsWd4DY+MU7XEE8CM9bYo3QzTCAxZj8nHJpu2Ojmzcx4x7dMdaKRi
         r42UuJpeDO16/vpnGD3bIfCUOHKLECsNnlnSY0IUpA3UjbR/qkFQ37AKt572PdaDlIj+
         a6jSyVhx6NBA24M+nI19A2Xg/+hij072amXHVqmZNjr2RISKa95pBQKmpVN9s1rSFb93
         XRkPKcrigM+U77/k7SlYt0i2NmGnpGi8yYDR6z2VXLyJPJQm2duIWIbEZPSeSYNASCoS
         7bsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683812060; x=1686404060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+qd85DAYUoVARV/UQur45Soj2gLrv6sKgolbKo4DNkY=;
        b=A57HjP1itB+zs9RDAKUiH7LO71NU621PTaNSqp/+HHGA7tm7V9LfCL4sLF+GKtfOeU
         A31J/p/yDk+ag0Zz2abD3nqvxetIwD9fHpElelf5uX2ITBk9W99roHoCmu/qenyuOcPM
         SFQ3vL3m/MRKmxetPDTm+CT99D75YVRldU1AHUEoAR08HsQfcNUJLU9ePl0amBCOxxas
         FGv51jvCp7x891eUUVe/QMWIufIPzl2UQkK0rdLe/vSABGRnKJ+PH7odCdjjG13Eexot
         H0rBE586yHi0iizVWcfqo93sEPcmmpGc2njJSC9NYvvFzQdvtpvH3IGPf7Xe0nqz0v/U
         0mAQ==
X-Gm-Message-State: AC+VfDx1UBLJL7/vm6SaJK/pgHVGgVa+1A9QNFHJhCnd97R663PNz6mf
	K1IOWLjjX6S6Q0cv0Rx8w4E=
X-Google-Smtp-Source: ACHHUZ6D1SmSibupox7jsjkuLOX/BB/O6IqNdA+Os6V+bkJDhi1wS+hKNMOJm73kAVRAOMQT58zlbA==
X-Received: by 2002:a05:6a00:248f:b0:634:970e:ca09 with SMTP id c15-20020a056a00248f00b00634970eca09mr26611634pfv.30.1683812059896;
        Thu, 11 May 2023 06:34:19 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-92.three.co.id. [180.214.232.92])
        by smtp.gmail.com with ESMTPSA id b26-20020aa7871a000000b00641114ef2dbsm5497963pfo.90.2023.05.11.06.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 06:34:18 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id E53961068BF; Thu, 11 May 2023 20:34:11 +0700 (WIB)
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
	Archana <craechal@gmail.com>
Subject: [PATCH 10/10] include: synclink: Replace GPL license notice with SPDX identifier
Date: Thu, 11 May 2023 20:34:06 +0700
Message-Id: <20230511133406.78155-11-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511133406.78155-1-bagasdotme@gmail.com>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=834; i=bagasdotme@gmail.com; h=from:subject; bh=hknv61wvlrkkgOugXTBTgrVsX3ozvkcF0YqHFnV1tm8=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCkx706mnu9+bem1/mXJ3iyvGzNfCv0wiV53KaXoSk6/8 jqzUoPFHaUsDGJcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZgIgzkjw6aA6292CMWIVB2c 9u2Mg8RUF/vsKTt1a0IW2F+WdlrdpcTIcGjZ7ygRkU//zwUuvxuUsYZRqtz4vqDKvpnWvMreTmW JPAA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Replace unversioned GPL license notice with appropriate SPDX
identifier, which is GPL 1.0+.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 include/linux/synclink.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/synclink.h b/include/linux/synclink.h
index f1405b1c71ba15..2c8436f08da44a 100644
--- a/include/linux/synclink.h
+++ b/include/linux/synclink.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
 /*
  * SyncLink Multiprotocol Serial Adapter Driver
  *
@@ -5,8 +6,6 @@
  *
  * Copyright (C) 1998-2000 by Microgate Corporation
  *
- * Redistribution of this file is permitted under
- * the terms of the GNU Public License (GPL)
  */
 #ifndef _SYNCLINK_H_
 #define _SYNCLINK_H_
-- 
An old man doll... just what I always wanted! - Clara


