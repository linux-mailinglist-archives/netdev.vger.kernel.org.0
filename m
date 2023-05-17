Return-Path: <netdev+bounces-3252-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D8AB706395
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:05:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14F4B2814B4
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:05:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4913179D5;
	Wed, 17 May 2023 09:04:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C56156D9
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:04:30 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4943A133;
	Wed, 17 May 2023 02:04:26 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-643b7b8f8ceso333220b3a.1;
        Wed, 17 May 2023 02:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684314266; x=1686906266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=91yi06xLF2ixkxLxpr3QLIL+JikkiNbbtse+nlfJyhw=;
        b=d47ANN5H80Z/g3BetX2abUlwhLfzTybONIQJbkRW6yAFaEGjec1AvbEHgyfCWumW3H
         kI/du1DtP8FkmU91gllj0D3qzgrHGo7LlyNkLzopBXuUibmSXJN7CvbN7QwefEbJsj/u
         ZoG5OADzD+DJDk6nCDLDfuHIN3zKk4jOFIqyoSJxj3GtkikpYpokjDP0gPN7WN+iWtsy
         +3ty7jLsPhD5qMXFVusqkheG1QylzgBAmOCv5tr6d6hOrga8ztnjivSRR9K1wZl13Cpc
         b/GR7BEMoO2ylHKzTHEN1XX8+4AAOO7BzZA/a7V02y2SG3Vq5T19KiGuQnJ+Jj+0iRav
         1zqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684314266; x=1686906266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=91yi06xLF2ixkxLxpr3QLIL+JikkiNbbtse+nlfJyhw=;
        b=L6m11rwlLk030tmv+giSV/cXUG5JlLyEXBNZyEMhRD+Sor7t9DG4+l3wn/bobIIyCO
         NC6lLPa3Ci3EIKcyBtkrtguCl7lQ7q3iFUrau+F5oN2Jo7cKYw7fngwLGmERdH5S4ahs
         XZ1i6Mp7X0jiLuJ1vOL2B15BLFhgdGxceyyb7YqFwh1KaIIfjEg+E26pMmMdU3o67/n0
         i/5+JIMTvhX1OZgk9rhwuqB7ih5Q+U2lP4tPz+iKAV8rDHLtuX8lJC05TqtagcFDctXq
         dta7J/0KD9/sg/8/Ky84vJ5qcjOxyl9xY4Orh4DB+o5I0wvisx/pOg3lFeFy1Ns2Ca8g
         x50A==
X-Gm-Message-State: AC+VfDxCCaDg7qc+i/BQGBgYzdF6bHLJQFWU48CRTjwAl72QgbaFQNVw
	+99O/c4TnAEBaoJn48EGGXA=
X-Google-Smtp-Source: ACHHUZ65TMd/WbFhrTaBdgrI8Jp9mEZXmVg2CKDwTz/9JbKqzuAgYiKru0sQEkEHzDr8BIdtFV8tLw==
X-Received: by 2002:a05:6a00:198e:b0:64a:f8c9:a421 with SMTP id d14-20020a056a00198e00b0064af8c9a421mr1734pfl.32.1684314265601;
        Wed, 17 May 2023 02:04:25 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-22.three.co.id. [180.214.233.22])
        by smtp.gmail.com with ESMTPSA id c18-20020aa781d2000000b0063b73e69ea2sm4645732pfn.42.2023.05.17.02.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 02:04:25 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 164EB106276; Wed, 17 May 2023 16:04:20 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux Staging Drivers <linux-staging@lists.linux.dev>
Cc: David Airlie <airlied@redhat.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Deepak R Varma <drv@mailo.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Archana <craechal@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Kate Stewart <kstewart@linuxfoundation.org>,
	Philippe Ombredanne <pombredanne@nexb.com>
Subject: [PATCH v3 3/4] drivers: staging: wlan-ng: Remove GPL/MPL boilerplate
Date: Wed, 17 May 2023 16:04:17 +0700
Message-Id: <20230517090418.1093091-4-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230517090418.1093091-1-bagasdotme@gmail.com>
References: <20230517090418.1093091-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=36222; i=bagasdotme@gmail.com; h=from:subject; bh=pDKND6kxrMZMIgikM89EZnWyHuNOrHokIVM19TuzgCU=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCkpMybNyZXTldgq7/zlc0pSTnVA/a3aZCaeJUuObbVfv erG6g8nOkpZGMS4GGTFFFkmJfI1nd5lJHKhfa0jzBxWJpAhDFycAjARIR6GfxrOIcHySwPeKxz1 0LBRUlkucc5w+y/zKx3xP86mHgtk+szI8P3raVvtmZF9xopS9Qsfcumvlvh/1S/Zb1prea/qxTN FTAA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
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


