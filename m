Return-Path: <netdev+bounces-2118-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEACB7004EA
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 12:10:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6513E1C211D7
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3240910799;
	Fri, 12 May 2023 10:07:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A1A1078A
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:07:11 +0000 (UTC)
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAE3E4B;
	Fri, 12 May 2023 03:07:04 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1ab05018381so90185175ad.2;
        Fri, 12 May 2023 03:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683886024; x=1686478024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=91yi06xLF2ixkxLxpr3QLIL+JikkiNbbtse+nlfJyhw=;
        b=UnbpswQJRWvRzMcbluMbM8TeE2waO6BN/OyUBrA4lA/sYx8Svp3o9Tc+iSJvCEf0+e
         v7UkX+wg0JD7nkVpKLwLjHC9ThtWjJPEyHnKhfVPhCgFUc+S+MXpPLJ2lzHU5Z7F+O+t
         eOcCZxnZA/Y+JUQ3eV739S7BE+APuVg5P1Z8F9BlmdE227yvYD+L/QzkqqKRDCrrg4QF
         /RvrJuRCvH5GxAxKBnuixRv3RrSzGyGGsUSyOQ+56JfuJyH33l1cEi/+fNMOADDDZwL+
         xn99REELqSdClTAkv7odXx3CZ5ZaOeZG6KbzDH8SZdiIWTxC6VHyWpR/tZXKMpJvysKp
         l80A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683886024; x=1686478024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=91yi06xLF2ixkxLxpr3QLIL+JikkiNbbtse+nlfJyhw=;
        b=HgWRPYqDYz61L0O/Zg3Qq11JbScBRc2mwX1xT0d9fjBO6GbRd0AJUy7ah7DGIKv/cX
         38kb/AsT2Z09njejmr8hBJu/nM9zDcrjcynJCrXwxHYryxa1EMXIBCoFzPrk9Pjv7NpZ
         d6t0g5cKO2rB0oEExuTM6j4/J7N9rILQqsdQfP02C9c82vPlvebYXCJeceKJKm+Z9UvZ
         +N37Y4Nh6UB3Vgsf+Ew5pgRPlsaraYFfEE+6I8mL/qliQTSBlHPEY/8bVzv95kmThm/o
         sEmqhzrLEEdb0CIhXNwBqufSMh7ynqjzpebsZYHXvrbaCWNG4iD5Qil+aFSSGAAa1Sfy
         xQyA==
X-Gm-Message-State: AC+VfDyHCv2FKnsKifVSQ6d5BKNwkDzJ4LESLW6G/BtzrgtW5WbzlxRm
	Wer9caKwq3EPfJSouRAxKxo=
X-Google-Smtp-Source: ACHHUZ7n0t32yMOYWRvZuuT/OzDaSwA+wYobk0k0kMWFO+/YCVLDSoAWxBstY0ckRQKHirEC+MlElA==
X-Received: by 2002:a17:902:ea12:b0:1ad:e2b6:d292 with SMTP id s18-20020a170902ea1200b001ade2b6d292mr2078501plg.4.1683886023553;
        Fri, 12 May 2023 03:07:03 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-58.three.co.id. [116.206.12.58])
        by smtp.gmail.com with ESMTPSA id n18-20020a170902d2d200b001aaeba5ce0fsm7514313plc.68.2023.05.12.03.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 03:07:03 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id AF8CB106B42; Fri, 12 May 2023 17:06:55 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux SPDX Licenses <linux-spdx@vger.kernel.org>,
	Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Staging Drivers <linux-staging@lists.linux.dev>,
	Linux Watchdog Devices <linux-watchdog@vger.kernel.org>,
	Linux Kernel Actions <linux-actions@lists.infradead.org>
Cc: Diederik de Haas <didi.debian@cknow.org>,
	Kate Stewart <kstewart@linuxfoundation.org>,
	Philippe Ombredanne <pombredanne@nexb.com>,
	Thomas Gleixner <tglx@linutronix.de>,
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
	Dan Carpenter <error27@gmail.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 07/10] drivers: staging: wlan-ng: Remove GPL/MPL boilerplate
Date: Fri, 12 May 2023 17:06:18 +0700
Message-Id: <20230512100620.36807-8-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230512100620.36807-1-bagasdotme@gmail.com>
References: <20230512100620.36807-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=36222; i=bagasdotme@gmail.com; h=from:subject; bh=pDKND6kxrMZMIgikM89EZnWyHuNOrHokIVM19TuzgCU=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDClx/DPm5MrpSmyVd/7yOSUppzqg/lZtMhPPkiXHttqvX nVj9YcTHaUsDGJcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZgI00eG/6nH2vTlM72OfOph b0qxvTF90x01K7ZpExQ+1p8Kf9wWO4WR4UlK3cXWD9dnaLzZU2YY+/ds5SPerF/9DQkJJ3Pre/X nMAEA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Remove the license boilerplate as there is already SPDX license
identifier added in b24413180f5600 ("License cleanup: add SPDX GPL-2.0
license identifier to files with no license") which fulfills the same
intention as the boilerplate.

Cc: Dan Carpenter <error27@gmail.com>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
Cc: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
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


