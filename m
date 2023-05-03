Return-Path: <netdev+bounces-127-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B8176F5510
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 11:43:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7D551C20CD8
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:43:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2551ABA2C;
	Wed,  3 May 2023 09:43:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAF5BA2B
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 09:43:27 +0000 (UTC)
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393D9525E;
	Wed,  3 May 2023 02:43:10 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-63b60366047so3517270b3a.1;
        Wed, 03 May 2023 02:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683106989; x=1685698989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VdsI+hHV1SMet6yGeXUXOJdAJPqVlRG1VZCMzWt5U/M=;
        b=RUGLltaJzJHfMlOrUd7mLzmkL+OCnUg8YTR4vdy9KmncZFHMf27GhuScl9aFI9cpnX
         oMEIOWxz8M4uAnRbiA8JjcTtzC2hFo1oO9FSaCtXniYO2Qtv536bGWmI+ps3pKSbhtDZ
         4GAouanyptWEIWyES8oGEbJdBucmuRMzp9gqTBGuOSD6NLQSoSuwyhs4BYzxa1zmHP+S
         l5DIBFZyuQ6aFGk5YxjTgrb+uvndEMdaE8Yk27OppRECTHaVuEci/88lqt1X1R541kdU
         XAmgjhlZIRc9qMG6gOobcg/41yA6xj+bwEmRlVSCipW1uiAIvbqU9avyMPXACuv9zfbF
         JabA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683106989; x=1685698989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VdsI+hHV1SMet6yGeXUXOJdAJPqVlRG1VZCMzWt5U/M=;
        b=gfkZrfEeTNJYVVsuJIN/QAviBAihwH+juOXS7YLwmhqid8l2dw7to5NrhipQeiU8Jk
         2Qbl8qK/zUCdWzr6ztJsr5aUf83RQOl9a6hEjB3gCq4iAvARqDtVLtqNvpW8itUXQeN/
         9awH3Xfda7ceSHiPU+BIbvw4s5fPuvhMf0woPeZBviAfmfVzbXFJy3/VyGRiztL1U+xP
         op12S2QtSAur/x6sm/7dlwHEpv2pBTNGApR1/7X3Pysc0/pEXESCL5BbZYNfR3WBbzwZ
         gdEnRNNPKRChh/qppwnHRMNoTZU+VgBeJpmZhjwnsWP5X3USnhIztcHYMZTZuBicdSfV
         rRVQ==
X-Gm-Message-State: AC+VfDymNdDez5o8T4TJbSu9KweCespIGDRRShMwnxWoQwYcIpeJf/2T
	ArCjaEXPP1M8QSvF2sUi4Ag=
X-Google-Smtp-Source: ACHHUZ5IqNxLGOmjmTTtU8NedjrsbKCHPIyEkw64UhHFJJMJAy5lwynVr/PZaidTFYzXNcSTzEfHVw==
X-Received: by 2002:a05:6a00:1a55:b0:63b:7ac8:1be4 with SMTP id h21-20020a056a001a5500b0063b7ac81be4mr29927714pfv.25.1683106989398;
        Wed, 03 May 2023 02:43:09 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-11.three.co.id. [180.214.233.11])
        by smtp.gmail.com with ESMTPSA id j12-20020a056a00174c00b00634b91326a9sm23972464pfc.143.2023.05.03.02.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 02:43:08 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id DBE1A10624C; Wed,  3 May 2023 16:43:04 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Networking <netdev@vger.kernel.org>,
	Linux Random Direct Memory Access <linux-rdma@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux Networking <linux-kernel@vger.kernel.org>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net 3/4] Documentation: net/mlx5: Add blank line separator before numbered lists
Date: Wed,  3 May 2023 16:42:48 +0700
Message-Id: <20230503094248.28931-4-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230503094248.28931-1-bagasdotme@gmail.com>
References: <20230503094248.28931-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1586; i=bagasdotme@gmail.com; h=from:subject; bh=cqUxta75B9+HXP24ZKCVQuvthnc3qFBlG7NEmCz80qo=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDClBOtNF3U1EZXzdRfxevsi99FO5cGf6/CW3rK5++H2e4 Qa/R65rRykLgxgXg6yYIsukRL6m07uMRC60r3WEmcPKBDKEgYtTACZyUpnhn+3XVNfrgR4iRba6 LMuLjbmCv570XD5bP0gw9tDUydLeLYwM051yVz4tSxWZu3mPUuNRgzcMu/O/1hsfEzkqJXqT30m IDwA=
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


