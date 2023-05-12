Return-Path: <netdev+bounces-2111-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67FEB7004DF
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 12:07:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 752401C21128
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:07:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41CEAD30A;
	Fri, 12 May 2023 10:07:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD45D513
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:07:03 +0000 (UTC)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DB61162B;
	Fri, 12 May 2023 03:07:01 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64ab2a37812so3590097b3a.1;
        Fri, 12 May 2023 03:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683886020; x=1686478020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NkLNdeDn6hMP5F0r+T8wUttQQ19WSpWtWoPCipbjjYk=;
        b=C2+j8v8rPTIb6HnSvnFUQwRZ66d3mXZZSmgIfsh6FVupo5JbwYPTQxueQITyQhUyTE
         XwDGChK3UNv+U1yJxKtNWgdNH59S1wnnb41F5rM5S4lZGFGbL2Vk0EgF+rzxZJydj74u
         d6Jk4j0yuBZn+Ia57JZxzq1D7JXICpZG03MRJhZD+dcsewY1jruPow6YZRNSFRaCJFsv
         6x+yo/3iVJhPuv/fvu2hMT0F4OrD+DWMCuLCPqt0Fzygq/E9VfhsedqCVUDYddgRWsw9
         vV8dxqqeq9tItBeaKZfHNLW9omhOjhh1aTduDjMAKPQv2LssIWhToyNxoodHXrI/tdwF
         BbgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683886020; x=1686478020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NkLNdeDn6hMP5F0r+T8wUttQQ19WSpWtWoPCipbjjYk=;
        b=iqSANpzDXTeAZ1MDPb501P8YEar+BJ3IcvVQqjV1LYsltqhorG5Be1Ej3oHP4afAYM
         e9G4ECBn00Lwf+okcRi94zw1SSKgXnnOnD5Wx9pb9EsZhF4DPoUgd5pDdLegvFJhK71Q
         LyJeTe4uJPUZb7NOfkyWmDLROcJ6uwv4MH8ITBR7FForEz07qZFdT0PTHgNh1lBo3ky4
         6qG8FxG0wxd/J1uDRhiNIzBs3UR1VSIoQ/ZpxRij3FWldVTd7EeXdA9KHN+8axynCbn1
         oFSqVtDsXt5NDVs4R4v0kyj0b77K8LUwANRxU8Cf7DsGSsuKM6QWKbebzvRi1OB7Qm+H
         oNqA==
X-Gm-Message-State: AC+VfDzlzWCtjQOwiK7ThNKUawYwfC548Kwn+MWKmNLY5ELa9KT8SgiR
	cgtFXLoSqERlCIzN2yYC1yw=
X-Google-Smtp-Source: ACHHUZ6aNdgEG2xNAjNjCSF7H8MeFm2CvViH4BalJUiUcf1A7xoIMDscaLxs+Ef+R6vxs1eys44OGw==
X-Received: by 2002:a17:902:da92:b0:1ac:94b3:3ab4 with SMTP id j18-20020a170902da9200b001ac94b33ab4mr15640725plx.27.1683886020395;
        Fri, 12 May 2023 03:07:00 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-58.three.co.id. [116.206.12.58])
        by smtp.gmail.com with ESMTPSA id k25-20020a63ba19000000b0050f93a3586fsm6141726pgf.37.2023.05.12.03.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 03:06:59 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 762BF106B36; Fri, 12 May 2023 17:06:54 +0700 (WIB)
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
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 01/10] agp/amd64: Remove GPL distribution notice
Date: Fri, 12 May 2023 17:06:12 +0700
Message-Id: <20230512100620.36807-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230512100620.36807-1-bagasdotme@gmail.com>
References: <20230512100620.36807-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=865; i=bagasdotme@gmail.com; h=from:subject; bh=BnhAyHqAAXZPpElC1S7AamhQL42pHpYqVocWHPx47Os=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDClx/NO3Lfyz29rtyKsS8//3lktmcG+LcrlZPfXRzne6r BeWG8sf7ihlYRDjYpAVU2SZlMjXdHqXkciF9rWOMHNYmUCGMHBxCsBEpksz/E+ZHn/97Pa1mcsX SRe79U8LfWr+1jyuJsSJ9dwmz6+TtfUY/ilqCr+WT7wnuHO1tmnp0jLPvboarTN8C/QeXSxye3Z oLw8A
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There is already SPDX tag which does the job, so remove the redundant
notice.

Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
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


