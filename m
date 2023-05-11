Return-Path: <netdev+bounces-1803-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 037566FF300
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 210971C20F7B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F309F19E7A;
	Thu, 11 May 2023 13:34:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13C519E6F
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:34:32 +0000 (UTC)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1EA100D6;
	Thu, 11 May 2023 06:34:16 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6439bbc93b6so5926202b3a.1;
        Thu, 11 May 2023 06:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683812056; x=1686404056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HoKyuHLfT/Y/QsL6VxzM/0MIfBb45C0FJHVlIVZz104=;
        b=kkVZKiYfEcCdoefsHaMhY1LIJItNpc1tc2IkQ/P+y072+Ftr3ATNGwAODW9yC5oabG
         lEVaDH26i2znzLMUxRJPlsSCkYKqfolieTzP6Op/omkT7lGqQNPID45STOHP88j40PHE
         puk1llPOZExeQrW5GiXQmUvCU68ptpxpzfambpAih93AlGWzJXCamE4pEMGY6qBxi0/N
         zX5gKuRwM5LL7wVXU6dm8aK+rKng53ZDCsV6QLz9opk7Gl8I2gx3cad5YOuCQ1OBYycl
         y1ZR0SEmToaFBNROxpc8cIoUbIQfEQ5lbLJZbtSRWlIpPfcakFPxkySVAmqnm2WFEtJD
         hP1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683812056; x=1686404056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HoKyuHLfT/Y/QsL6VxzM/0MIfBb45C0FJHVlIVZz104=;
        b=hbTkkP0IiRgqJtXGZwgzEyRd1v0xI0WHJnkBTMbeDgm2v11sirL/2WIERMZCX942cV
         R+xJDvd54pq1q3H9XkTamRPEmrHLRD4OUNwtTl0w9Mu/pnCtkuwHvA9I2OuKZ3KjmeEV
         PTIGPQcRh8lTLUtaFyxGuOk3Pq75C5nywg93M69HwsJez9OxLezkFyOrakwMlj1Rs/Yc
         7IX5ZCM3teR6XnWg9AHv4/gZ9CV7aBrOUOfkovog1OjUZvWoz+arRP3zs0SeexeVlWJS
         v6IZaXovlnm+Mf4hpQ7R/TfI2+0nvSRMhQ5Ljo3py2sEikStQraV3ApW8a7z7Sx61NWq
         DSTA==
X-Gm-Message-State: AC+VfDxMEtHuvaVrABhmzo0VqYLexGcXxmCq+UbqAdSpK0Jf5zY0pWC9
	Zim61AzfjGG8lufSVjvqjxI=
X-Google-Smtp-Source: ACHHUZ4262YHOoAdK0Uxg1/cglS/7wigxDC7J/l5c10IuMlaf9GDBAHt/NGAsZh1zd2FtAkAw0wtWA==
X-Received: by 2002:a05:6a00:14c8:b0:63b:4e99:807d with SMTP id w8-20020a056a0014c800b0063b4e99807dmr30877582pfu.8.1683812055845;
        Thu, 11 May 2023 06:34:15 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-92.three.co.id. [180.214.232.92])
        by smtp.gmail.com with ESMTPSA id t23-20020a62ea17000000b0062cf75a9e6bsm5304247pfh.131.2023.05.11.06.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 06:34:15 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 1E783106796; Thu, 11 May 2023 20:34:09 +0700 (WIB)
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
	Thomas Davis <tadavis@lbl.gov>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 03/10] net: bonding: Add SPDX identifier to remaining files
Date: Thu, 11 May 2023 20:33:59 +0700
Message-Id: <20230511133406.78155-4-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511133406.78155-1-bagasdotme@gmail.com>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2266; i=bagasdotme@gmail.com; h=from:subject; bh=AbejYIDoCHeefbQ32iun0DrWErMv9kzK4SAlm6OQaX4=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCkx747PkA9/cfxz2Ifqa3XbZI53SLo7dFo4Oppqt3OfP Ggdve1YRykLgxgXg6yYIsukRL6m07uMRC60r3WEmcPKBDKEgYtTACbi/4CRoe3mvdbgL1GSWv5G P7/8TQrJdrn+UtAjeFv6ncg1f632X2Vk2Cwokqki0NzUGPFRxdqA694fs0/OHL+elKf5NGY18m9 kAwA=
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
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/net/bonding/bond_main.c    | 1 +
 drivers/net/bonding/bonding_priv.h | 4 +---
 include/net/bonding.h              | 4 +---
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 3fed888629f7b5..93fc7b38835c07 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
 /*
  * originally based on the dummy device.
  *
diff --git a/drivers/net/bonding/bonding_priv.h b/drivers/net/bonding/bonding_priv.h
index 48cdf3a49a7d74..9570ceb0830327 100644
--- a/drivers/net/bonding/bonding_priv.h
+++ b/drivers/net/bonding/bonding_priv.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
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
index a60a24923b5599..09053e1107d095 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
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


