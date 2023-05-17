Return-Path: <netdev+bounces-3250-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E04DC70638E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:04:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D42E281168
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:04:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF8C71095A;
	Wed, 17 May 2023 09:04:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3F710796
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:04:26 +0000 (UTC)
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C264A7;
	Wed, 17 May 2023 02:04:25 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1ae54b623c2so3213005ad.3;
        Wed, 17 May 2023 02:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684314265; x=1686906265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AEkf8gWG96+9b1qBPiSXz5T2EndzrX4ufiHLwT0g7bA=;
        b=SbGDAIakWROfgnYElpLZK9rV6g4PdXCds6BP2sYnW5uJ1Cl+BhOK6EmSx1yHcXlVcs
         tBQ+FoQXXKOlqu1XPK+PXSMSgyA9hl3NnmZaIqpAeEFGJyL0tclIMv6PGY7Gv79bTykw
         YFS7BG3kD8AQscA5l7punlQ8lzVX82q5j2qYWhLMtaQ9aTbCUGT8hCx6uDxCh6U3dH/k
         k/ly3rVlKk9VM0G8LTS/Qf7m3cj+U+WC3afdsH47bQrmGvGkaHoWenjaoNwJQ8BtKH2q
         y2XS2SgPd/SIktblfE/gOE91e6Bw2vbLgJ1kl9y64uibv8hJYVHR15sZ3zjsZU6Jj2GU
         GNGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684314265; x=1686906265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AEkf8gWG96+9b1qBPiSXz5T2EndzrX4ufiHLwT0g7bA=;
        b=gst9uRNR7H6jztMJvVnAvyZLWYh1Bpuwhik5QW8yI53IhTSo7lBXkfcQ5CbBhgYJS8
         slG3/yZxlt4A0i26IThcMO4BybCXIVyXwMu37bnAerVZzSwcxkMFXz1SCPixMJO77c5o
         qLLCoSFMsxcDEu9n0uymg94fTVxLat7SZJb/PoAY0MD5yTdR8lVl2mjNjoebHh/d5R68
         48ljSwQxKd31SOkxgOQey/MHPCDZeQ7SyUNNiD9E8wsHhG6A5X2DNexUJ4iTJx9M2NnF
         NXugQfVjX69LERzFKPqKLHO+Id3sf0b/Xu5Gw6yLugHfoq0dgfyhWHaC6syvd5X1wd1K
         yocA==
X-Gm-Message-State: AC+VfDxLgiCLqkKG+nE0SQtU7zOg7z29vrx7jOhCuZUcs1FmxgOMsJjs
	Y/XTqM6zVnt/TfoO/xC+36A=
X-Google-Smtp-Source: ACHHUZ7t0/RQfYyMq41AqIGvxIMDuFkHn6at8SENhxnEYq4oIvHD7s8nLvlufw1gaSyIy1QihOZYKg==
X-Received: by 2002:a17:903:280b:b0:1ab:197d:2de1 with SMTP id kp11-20020a170903280b00b001ab197d2de1mr35817406plb.2.1684314264858;
        Wed, 17 May 2023 02:04:24 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-22.three.co.id. [180.214.233.22])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902c3cd00b001a6cd1e4205sm16925753plj.279.2023.05.17.02.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 02:04:23 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 39536106280; Wed, 17 May 2023 16:04:21 +0700 (WIB)
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
	Dan Carpenter <error27@gmail.com>
Subject: [PATCH v3 4/4] include: synclink: Replace GPL license notice with SPDX identifier
Date: Wed, 17 May 2023 16:04:18 +0700
Message-Id: <20230517090418.1093091-5-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230517090418.1093091-1-bagasdotme@gmail.com>
References: <20230517090418.1093091-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=881; i=bagasdotme@gmail.com; h=from:subject; bh=PkQY9HnKXIwg0IaXpF33XHuRDzB1ZRiNQ1FLD5oV4q4=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCkpMybJzvK0OCn3T61kx1IWV9ftKo/2i53immRftnV+e 5q5hmluRykLgxgXg6yYIsukRL6m07uMRC60r3WEmcPKBDKEgYtTACZybxnDPxujkg3bbTRW5fBd +852O0noRG1l89E9q34vZ4/Zzlzne4iRoUn5aEL/zGVCWw90LHop42umf3daimPH3PhL78qcE3w msQEA
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


