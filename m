Return-Path: <netdev+bounces-1805-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4D306FF312
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:36:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00BAD1C20F78
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6222419E7E;
	Thu, 11 May 2023 13:34:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF7419E78
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:34:35 +0000 (UTC)
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521FF10E7B;
	Thu, 11 May 2023 06:34:17 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1ab267e3528so61399755ad.0;
        Thu, 11 May 2023 06:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683812057; x=1686404057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HZ3upDxXKQPznQvDk/K2B4NOrJJu1zi3pUMhmFKO8DM=;
        b=R4l7uzvCItypVc3mtHMfHlcdEOc0TNvyMPVr3heUdV++clXfbFz+mxep8GtPdXV0ob
         ZiFqKSR2lqb6nmNHG7ZMRat6rhDxG9qH9VXnA7PpI3zzJrkKNmUq1PdWcnGobIVKzYEx
         8i4vmU85jQh+8RGXzx27n6RoFQSIbQ20Zj6A/fYfOq+uZ48txq7L3Wo4oh+ZmPcK20CR
         U6psH8zE0tK53OUhFccOz/BExTm2HX0PO9m2ctf13YD2pkRmYxiRUmeSij8PZsdcRE1+
         qlkI8a0ntvMe5iQlpFLOGBv4NPI2j8YfompKOuEVzUoORKz6TbVMyFQtGLsNPsnk/vCK
         Bu0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683812057; x=1686404057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HZ3upDxXKQPznQvDk/K2B4NOrJJu1zi3pUMhmFKO8DM=;
        b=B/li6uw6hjd6S3X3HNXJuWi7npnzw50F8P1Q97I6qMawb89vf9he6XG7lK7oOZf3Gf
         iK294Zi3CUhjoIXnL+QgJn1f81yCzFWx1BFRL8+ZFSGd7q0w5FZthDwXtVOyxxNCPHHg
         9CY2grHKx4IYbP69ZRobmq9zum/ImLm8p9Hhmkod0q2uWN0uE36gzJxmB+5yIXqZQ2Z/
         02i0miPwZsk3aJYITXbFJ0Djdlg+yV62kzIgh2pQDvP9VODJWIZKnVVNJwaXVNsNcB8E
         T/cdg8SHjgt0TVctqktIcNKvb+0Sx3OtZ1DudFkVE9vdQ0ENksr+iCGu53lw9Exl6Imt
         8Fwg==
X-Gm-Message-State: AC+VfDwuwwBimY/8XwVuKZsmgYF5jjGta+AzHTf0FNpxWamHHeVHfIyP
	nrxX7kUYKxuCaSdNTfRBJPw=
X-Google-Smtp-Source: ACHHUZ4pfS8ZxidbidUXAvqMhr3C9+JMMe+rRX92nxKZLXoMf+33ohdfBn567UWxZXKd8OfqntQIiQ==
X-Received: by 2002:a17:902:ce84:b0:1ac:a030:c30a with SMTP id f4-20020a170902ce8400b001aca030c30amr11952021plg.19.1683812056155;
        Thu, 11 May 2023 06:34:16 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-92.three.co.id. [180.214.232.92])
        by smtp.gmail.com with ESMTPSA id f6-20020a170902ab8600b001a6a6169d45sm5928904plr.168.2023.05.11.06.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 06:34:15 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 58BFD106798; Thu, 11 May 2023 20:34:10 +0700 (WIB)
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
Subject: [PATCH 07/10] drivers: staging: wlan-ng: Remove GPL/MPL boilerplate
Date: Thu, 11 May 2023 20:34:03 +0700
Message-Id: <20230511133406.78155-8-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511133406.78155-1-bagasdotme@gmail.com>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=35920; i=bagasdotme@gmail.com; h=from:subject; bh=b+I9iJ8kvzVJEtWuc3mgSwrekYCLyUIQCUl7CbM+UpA=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCkx707MNhB95PPHvvtfnfMXXoE6K+YLTap160W2OtzWj mBcYjC/o5SFQYyLQVZMkWVSIl/T6V1GIhfa1zrCzGFlAhnCwMUpABPpk2T4Z9DBt/3Lh0ief2J9 lwVO7plyKPuEhXmwy+Y/wswSXhPrdzIyLA99/8rX0e2n8gJ19afN1r8c47L/V1ktmxy1IsJ835d fzAA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Remove the license boilerplate as there is already SPDX license
identifier which fulfills the same intention as the boilerplate.

Cc: Dan Carpenter <error27@gmail.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x.h          | 21 ---------------------
 drivers/staging/wlan-ng/hfa384x_usb.c      | 21 ---------------------
 drivers/staging/wlan-ng/p80211conv.c       | 21 ---------------------
 drivers/staging/wlan-ng/p80211conv.h       | 21 ---------------------
 drivers/staging/wlan-ng/p80211hdr.h        | 21 ---------------------
 drivers/staging/wlan-ng/p80211ioctl.h      | 21 ---------------------
 drivers/staging/wlan-ng/p80211metadef.h    | 21 ---------------------
 drivers/staging/wlan-ng/p80211metastruct.h | 21 ---------------------
 drivers/staging/wlan-ng/p80211mgmt.h       | 21 ---------------------
 drivers/staging/wlan-ng/p80211msg.h        | 21 ---------------------
 drivers/staging/wlan-ng/p80211netdev.c     | 21 ---------------------
 drivers/staging/wlan-ng/p80211netdev.h     | 21 ---------------------
 drivers/staging/wlan-ng/p80211req.c        | 21 ---------------------
 drivers/staging/wlan-ng/p80211req.h        | 21 ---------------------
 drivers/staging/wlan-ng/p80211types.h      | 21 ---------------------
 drivers/staging/wlan-ng/p80211wep.c        | 21 ---------------------
 drivers/staging/wlan-ng/prism2fw.c         | 21 ---------------------
 drivers/staging/wlan-ng/prism2mgmt.c       | 21 ---------------------
 drivers/staging/wlan-ng/prism2mgmt.h       | 21 ---------------------
 drivers/staging/wlan-ng/prism2mib.c        | 21 ---------------------
 drivers/staging/wlan-ng/prism2sta.c        | 21 ---------------------
 21 files changed, 441 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x.h b/drivers/staging/wlan-ng/hfa384x.h
index e33dd1b9c40e58..a4799589e46945 100644
--- a/drivers/staging/wlan-ng/hfa384x.h
+++ b/drivers/staging/wlan-ng/hfa384x.h
@@ -8,27 +8,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *    implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index c7cd54171d9943..3e8c92675c8234 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -8,27 +8,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/p80211conv.c b/drivers/staging/wlan-ng/p80211conv.c
index cd271b1da69f64..048e1c3fe19b32 100644
--- a/drivers/staging/wlan-ng/p80211conv.c
+++ b/drivers/staging/wlan-ng/p80211conv.c
@@ -8,27 +8,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/p80211conv.h b/drivers/staging/wlan-ng/p80211conv.h
index dfb762bce84d07..45234769f45d6e 100644
--- a/drivers/staging/wlan-ng/p80211conv.h
+++ b/drivers/staging/wlan-ng/p80211conv.h
@@ -8,27 +8,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/p80211hdr.h b/drivers/staging/wlan-ng/p80211hdr.h
index 93195a4c5b014a..7ea1c8ec05ed05 100644
--- a/drivers/staging/wlan-ng/p80211hdr.h
+++ b/drivers/staging/wlan-ng/p80211hdr.h
@@ -8,27 +8,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/p80211ioctl.h b/drivers/staging/wlan-ng/p80211ioctl.h
index b50ce11147dd78..176e327a45bc4b 100644
--- a/drivers/staging/wlan-ng/p80211ioctl.h
+++ b/drivers/staging/wlan-ng/p80211ioctl.h
@@ -8,27 +8,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/p80211metadef.h b/drivers/staging/wlan-ng/p80211metadef.h
index 1b91b64c12ed1a..1cbb4b67a9a6a6 100644
--- a/drivers/staging/wlan-ng/p80211metadef.h
+++ b/drivers/staging/wlan-ng/p80211metadef.h
@@ -6,27 +6,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/p80211metastruct.h b/drivers/staging/wlan-ng/p80211metastruct.h
index 4adc64580185a1..ea8b7ee108171f 100644
--- a/drivers/staging/wlan-ng/p80211metastruct.h
+++ b/drivers/staging/wlan-ng/p80211metastruct.h
@@ -6,27 +6,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/p80211mgmt.h b/drivers/staging/wlan-ng/p80211mgmt.h
index fc23fae5651b9e..7ffc202d90074b 100644
--- a/drivers/staging/wlan-ng/p80211mgmt.h
+++ b/drivers/staging/wlan-ng/p80211mgmt.h
@@ -8,27 +8,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/p80211msg.h b/drivers/staging/wlan-ng/p80211msg.h
index f68d8b7d5ad883..d56bc6079ed4f8 100644
--- a/drivers/staging/wlan-ng/p80211msg.h
+++ b/drivers/staging/wlan-ng/p80211msg.h
@@ -8,27 +8,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index 6bef419e8ad0c8..8634fc89a6c22f 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -8,27 +8,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/p80211netdev.h b/drivers/staging/wlan-ng/p80211netdev.h
index 1cee51a1075ed6..f5186380b6290a 100644
--- a/drivers/staging/wlan-ng/p80211netdev.h
+++ b/drivers/staging/wlan-ng/p80211netdev.h
@@ -8,27 +8,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/p80211req.c b/drivers/staging/wlan-ng/p80211req.c
index 809cf3d480e952..6ec559ffd2f991 100644
--- a/drivers/staging/wlan-ng/p80211req.c
+++ b/drivers/staging/wlan-ng/p80211req.c
@@ -8,27 +8,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/p80211req.h b/drivers/staging/wlan-ng/p80211req.h
index bc45cd5f91e464..39213f73913c56 100644
--- a/drivers/staging/wlan-ng/p80211req.h
+++ b/drivers/staging/wlan-ng/p80211req.h
@@ -8,27 +8,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/p80211types.h b/drivers/staging/wlan-ng/p80211types.h
index b2ed969604133e..5e4ea5f92058e5 100644
--- a/drivers/staging/wlan-ng/p80211types.h
+++ b/drivers/staging/wlan-ng/p80211types.h
@@ -9,27 +9,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/p80211wep.c b/drivers/staging/wlan-ng/p80211wep.c
index 3ff7ee7011df35..e7b26b057124ab 100644
--- a/drivers/staging/wlan-ng/p80211wep.c
+++ b/drivers/staging/wlan-ng/p80211wep.c
@@ -8,27 +8,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index 11658865ca5050..5d03b2b9aab40a 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -8,27 +8,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
index 9030a8939a9bf3..e7820b212b4fa1 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -8,27 +8,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/prism2mgmt.h b/drivers/staging/wlan-ng/prism2mgmt.h
index 7132cec2d7eb80..083a055ee98662 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.h
+++ b/drivers/staging/wlan-ng/prism2mgmt.h
@@ -8,27 +8,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism2mib.c
index fcf8313870af48..4346b90c1a770e 100644
--- a/drivers/staging/wlan-ng/prism2mib.c
+++ b/drivers/staging/wlan-ng/prism2mib.c
@@ -8,27 +8,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index daa7cc4e897c91..57180bb71699f7 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -8,27 +8,6 @@
  *
  * linux-wlan
  *
- *   The contents of this file are subject to the Mozilla Public
- *   License Version 1.1 (the "License"); you may not use this file
- *   except in compliance with the License. You may obtain a copy of
- *   the License at http://www.mozilla.org/MPL/
- *
- *   Software distributed under the License is distributed on an "AS
- *   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
- *   implied. See the License for the specific language governing
- *   rights and limitations under the License.
- *
- *   Alternatively, the contents of this file may be used under the
- *   terms of the GNU Public License version 2 (the "GPL"), in which
- *   case the provisions of the GPL are applicable instead of the
- *   above.  If you wish to allow the use of your version of this file
- *   only under the terms of the GPL and not to allow others to use
- *   your version of this file under the MPL, indicate your decision
- *   by deleting the provisions above and replace them with the notice
- *   and other provisions required by the GPL.  If you do not delete
- *   the provisions above, a recipient may use your version of this
- *   file under either the MPL or the GPL.
- *
  * --------------------------------------------------------------------
  *
  * Inquiries regarding the linux-wlan Open Source project can be
-- 
An old man doll... just what I always wanted! - Clara


