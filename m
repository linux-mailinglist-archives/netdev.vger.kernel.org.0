Return-Path: <netdev+bounces-1319-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB3206FD4AD
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 05:55:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F0921C20C89
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 03:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4296520F5;
	Wed, 10 May 2023 03:54:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299D8814
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 03:54:37 +0000 (UTC)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC995B96;
	Tue,  9 May 2023 20:54:35 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64115eef620so47259703b3a.1;
        Tue, 09 May 2023 20:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683690875; x=1686282875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XXgB95iPLzJ/tlk3w3xSxODJBuQl2H1bImz8SZLBe2U=;
        b=fppuMHunGM3ALMUmv/eD3q1g4ZabQLzf4xTipRpcr9DrJbjJWNH/uZ40bTGb986QDg
         b0Q3Gb76I4mFqXrVqYs7TK+5itfDARNJmbWdBnfgJbVgcN+31OEEnGlOJEZ4qLE9QRyq
         YrMDkbkdOdymuiSlLiSPKBYsknIRdwvk1K+uuiFGihyR1nnpkUIK5HmgHNN4KR/xG1Ps
         cAmFC10sEOTV31W5224OK52gS4vbWsJN718DRyUR9u3LjXY+0PTHfid+r+SGnjRQfL02
         2YvpumxK8dZOyYVksOI6tYlsVlvKHmXjqSHP47rkm10icKGEUoJUzkXDGKeYYCa4nMqG
         Rx4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683690875; x=1686282875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XXgB95iPLzJ/tlk3w3xSxODJBuQl2H1bImz8SZLBe2U=;
        b=YX6PM3OnLz1rsMvqP1PfLR4RhgZinIzuZO/GVJBCpO+oDxCWNSkI/QrB4CxOBJEZHZ
         zOT9965rAQn7KviwWyJ7XLg+3xMEDkW3/PGCIsVfK+iPfhhrAHzf2bemqCx8A37CDYf9
         H6379ZDv7XB0++g4MYtaB6QZX2MyKV76ZEt59x1/+nrrt3SLECVxmoLZ5AQWROAcqpz+
         OFb7g5VxqPcJLOpG0IPbx4LNB99mkkWp4q+WU1P86t/msh7O0JP2o5MWrNbl2mclynTk
         dGA4KGQSqAwiieve3ItSa9TDJWVKJI3Eb/AF8Ci/yoZJmLAhTK94cyM2zt/1OhuGHGp+
         zfYA==
X-Gm-Message-State: AC+VfDyrufzi4VHEmF5OM7HESNmWRaMSZ4xql8j5l5ZvJoz9RAt4Y6TP
	PMTli2gPovBZdDZ4gTG2W9E=
X-Google-Smtp-Source: ACHHUZ5+C8CORNN8mfRtmU81gVQChpXWShxrVMo3TdIHre4tjcD/02Nl2Yp0Br5jZ4aAj5/N3RREMg==
X-Received: by 2002:a17:902:ecd0:b0:1ac:76a6:a1f with SMTP id a16-20020a170902ecd000b001ac76a60a1fmr11462613plh.16.1683690875346;
        Tue, 09 May 2023 20:54:35 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-21.three.co.id. [116.206.28.21])
        by smtp.gmail.com with ESMTPSA id a2-20020a170902ecc200b0019cbe436b87sm2504224plh.81.2023.05.09.20.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 20:54:34 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 38D00106AA2; Wed, 10 May 2023 10:54:29 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Networking <netdev@vger.kernel.org>,
	Remote Direct Memory Access Kernel Subsystem <linux-rdma@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Gal Pressman <gal@nvidia.com>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net v2 3/4] Documentation: net/mlx5: Add blank line separator before numbered lists
Date: Wed, 10 May 2023 10:54:14 +0700
Message-Id: <20230510035415.16956-4-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230510035415.16956-1-bagasdotme@gmail.com>
References: <20230510035415.16956-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1636; i=bagasdotme@gmail.com; h=from:subject; bh=lHfWy6PKdcXAMfDKFqmfoQvlo1/8l2cm35LI5C7u80A=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCnRomlt174edNw8Q+xiQM70kyy/pV4UPeYO6I4WX2/Fo Ws0i9Oso5SFQYyLQVZMkWVSIl/T6V1GIhfa1zrCzGFlAhnCwMUpABNhSmFk+PSFVen/o38vY0rX H3goc0EwXXNhnMompaKFNhNUCg45f2b4X5E1+1yNochbcaG5bTvin+jM7vn2bO80trNKb2ZZT/v awAIA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The doc forgets to add separator before numbered lists, which causes the
lists to be appended to previous paragraph inline instead.

Add the missing separator.

Fixes: f2d51e579359b7 ("net/mlx5: Separate mlx5 driver documentation into multiple pages")
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 .../device_drivers/ethernet/mellanox/mlx5/devlink.rst           | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
index 00687425d8b72d..f962c0975d8428 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
@@ -40,6 +40,7 @@ flow_steering_mode: Device flow steering mode
 ---------------------------------------------
 The flow steering mode parameter controls the flow steering mode of the driver.
 Two modes are supported:
+
 1. 'dmfs' - Device managed flow steering.
 2. 'smfs' - Software/Driver managed flow steering.
 
@@ -99,6 +100,7 @@ between representors and stacked devices.
 By default metadata is enabled on the supported devices in E-switch.
 Metadata is applicable only for E-switch in switchdev mode and
 users may disable it when NONE of the below use cases will be in use:
+
 1. HCA is in Dual/multi-port RoCE mode.
 2. VF/SF representor bonding (Usually used for Live migration)
 3. Stacked devices
-- 
An old man doll... just what I always wanted! - Clara


