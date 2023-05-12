Return-Path: <netdev+bounces-2115-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F40E7004E7
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 12:09:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33B311C211B1
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:09:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66EE1D308;
	Fri, 12 May 2023 10:07:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A428DF6D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:07:08 +0000 (UTC)
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C13BE55;
	Fri, 12 May 2023 03:07:04 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-52079a12451so6962099a12.3;
        Fri, 12 May 2023 03:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683886024; x=1686478024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AEkf8gWG96+9b1qBPiSXz5T2EndzrX4ufiHLwT0g7bA=;
        b=NtT2Weul5m/pMpgN7JMgRZwAS7itAs93/P0LzS4vUShEcK4Wgq6OBo6+Iatwn9wpVD
         gjwOOVQF9lpQUpgZtCaIQd72ZQugKVSyWb/PZE3vbwTwZfVQOVRMM5yFDD9yOMR8F8v9
         Q6mqq6T2rl9lqGnp0ASIgno/r7T1raas8x36CbHSlmTglCyt796jfNmZNms+AHHWvurY
         bpdR4yzAgfnxl9sTBuFoAQ83WYpg4uDnVq+BVTki6Qok27DFkNkCpOj+hRAet1+egzhD
         pOlOJRvO3bBmkfuIVwyM2IrmdnbNpKYJ1dCyJSgwjBaFgR6C5YpCvelGbphwVnKpkpl7
         XTUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683886024; x=1686478024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AEkf8gWG96+9b1qBPiSXz5T2EndzrX4ufiHLwT0g7bA=;
        b=gesSp8UOjlWGm2zdMhLJAIvCpMrIkfSNthQCQ6nsPEgUTbTyJKslHca7PK6X4meJjd
         lNQtsEO4PUIbLtRDkJceaUzZ0MW3O5r0ReJhyfy7o1mZxykha/C6TVC/MU5R6SkHmpgy
         HPLgnv+GUb8BMCkA6OO2EulGQ1PzeZtUStCjQBg668i0RM1lYExnAzhWjoXWivfyWzun
         4KQ41XdDShsWhQ3EsQTquOeL8ta6tI0CwagmWJ5OBRg66O5TiL0VihiDcN0ngo45woMM
         rK/tWhgSTqNzkQzlRQpBjkAs63Wtn56OsfgCiISDGgG799Sh9hK2wbVHM6jlqgcLSIFj
         G2bQ==
X-Gm-Message-State: AC+VfDx4G/Xesf3bJx5kFOzJtEmkl2m63Vi3dpRl0/608iBHPwOg5Awf
	0y99EL8I7852raN1dFpvUls=
X-Google-Smtp-Source: ACHHUZ7imq7bgHR/sJmRlazsESDion5s8yIT3WhCK3D8T5obXOuXCzu+YMDtulbCky0jUvuEXkpPNA==
X-Received: by 2002:a17:902:a609:b0:1ac:946e:4690 with SMTP id u9-20020a170902a60900b001ac946e4690mr12908005plq.49.1683886023679;
        Fri, 12 May 2023 03:07:03 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-58.three.co.id. [116.206.12.58])
        by smtp.gmail.com with ESMTPSA id n21-20020a170902969500b001a634e79af0sm7528924plp.283.2023.05.12.03.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 03:07:03 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 49702106B43; Fri, 12 May 2023 17:06:56 +0700 (WIB)
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
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 10/10] include: synclink: Replace GPL license notice with SPDX identifier
Date: Fri, 12 May 2023 17:06:21 +0700
Message-Id: <20230512100620.36807-11-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230512100620.36807-1-bagasdotme@gmail.com>
References: <20230512100620.36807-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=881; i=bagasdotme@gmail.com; h=from:subject; bh=PkQY9HnKXIwg0IaXpF33XHuRDzB1ZRiNQ1FLD5oV4q4=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDClx/DNlZ3lanJT7p1ayYymLq+t2lUf7xU5xTbIv2zq/P c1cwzS3o5SFQYyLQVZMkWVSIl/T6V1GIhfa1zrCzGFlAhnCwMUpABPZwsnI0DSB1bvrwoZSud8H 0ne/3frdnuH0pjxjmXVPMvvE5m9y3cPwP/SEaKC5kN1FhVtfGU8aFdcIxYbGRS4xOZrN1MAp9PA sNwA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Replace unversioned GPL license notice with appropriate SPDX
identifier, which is GPL 1.0+.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 include/linux/synclink.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/synclink.h b/include/linux/synclink.h
index f1405b1c71ba15..85195634c81dfa 100644
--- a/include/linux/synclink.h
+++ b/include/linux/synclink.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-1.0+ */
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


