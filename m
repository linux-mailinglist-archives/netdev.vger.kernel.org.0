Return-Path: <netdev+bounces-128-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9F116F5512
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 11:44:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D7791C20D1E
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF74BA3E;
	Wed,  3 May 2023 09:43:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1982BA2B
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 09:43:27 +0000 (UTC)
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1AA5263;
	Wed,  3 May 2023 02:43:10 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-24df4ecdb87so2530739a91.0;
        Wed, 03 May 2023 02:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683106989; x=1685698989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lf1muhsbXKVkAwjXlKT/F7FUM0glVIhlYmlwBoDu1aY=;
        b=YM2916vWfm7x9AMOkdWOmzG7o1YqSh7s6l13OGUlMKGKTJyEHUVKWOM8ufj9V5kGxG
         SMyufMgf0+DpWUzDcvkWrZ/H4Itx+Xcwm2u9Jh5Z2iDrVhq+0vnevfZPzuPAfqwDYkph
         tBQ2mUauBjlpMdfihD3aFsniVPRxhu16sPa35HS/wX3yG/3+lG/jnKSCx4HHDp/Ma5Ad
         WQHWHtcwWoXShw824+Hx3TQ9GNlX2a6VZgV1Z6WQDGDdu+Zj7cQXrl0YC6tj8dFHLFN+
         EGgXcikNnR5N52veoo3UmYAG5+CUK6cmw+Ohkfiafw4mg+nDVOUJmo1vcxiqhwwgthIy
         CzUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683106989; x=1685698989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lf1muhsbXKVkAwjXlKT/F7FUM0glVIhlYmlwBoDu1aY=;
        b=WUbW//fzFsMc0J/GDRZsi+lGI/ckEYZUehzLj1b6rXyUfaCLoA0L9GgIhpwuQhbK7J
         Iwvd3Bq/vVysp3WHyxsCmovcFAzUvufp8YsPyTQwP+STx+HAmmRaSNTwP6YfZeXyWBgy
         nbeE3iK9UVaSMuEwISOldoGXenzfxZBx1zsbC5P/qjFD8an8tkAAyS6pme5t8mgn+Tm/
         HUgKLQRLkX7AvlOTj/anfkY5j5yvbrXSyFhGB15tmTNfFKuzd42ZH85vSRpk2XImgVB2
         UqhJe+ILLwFK3yaJlL3A7RQY+TRrULVmlgjPJVicjDxyl9jOMa06ybm6wLYp+2yCfD95
         gYjw==
X-Gm-Message-State: AC+VfDwDYtNNNpKwxtreQxGefeXtlG110Ri/G2CvnitDmkz9OLLsUGPe
	fCTfyAbdUC50o4kMs7u45DM=
X-Google-Smtp-Source: ACHHUZ6D3bEwAna5pJ35KiqvNz1/3tcxtz47rD6lwT8t6NI81BCMEJ7K454Tv1UfL8Rgdp0GnF9Xkw==
X-Received: by 2002:a17:90a:7f82:b0:23a:ad68:25a7 with SMTP id m2-20020a17090a7f8200b0023aad6825a7mr20214530pjl.2.1683106989559;
        Wed, 03 May 2023 02:43:09 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-11.three.co.id. [180.214.233.11])
        by smtp.gmail.com with ESMTPSA id pf8-20020a17090b1d8800b00247abbb157fsm942966pjb.31.2023.05.03.02.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 02:43:08 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id A25321055AC; Wed,  3 May 2023 16:43:04 +0700 (WIB)
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
Subject: [PATCH net 1/4] Documentation: net/mlx5: Wrap vnic reporter devlink commands in code blocks
Date: Wed,  3 May 2023 16:42:46 +0700
Message-Id: <20230503094248.28931-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230503094248.28931-1-bagasdotme@gmail.com>
References: <20230503094248.28931-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2073; i=bagasdotme@gmail.com; h=from:subject; bh=tMWudNgiUasGarVpCzAepBusDqbWwgKJHD+hWHPr4uY=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDClBOtMEvaW5Txo2aX94pLHw1pwXE+R+/np0NVBwkYSE1 Kzl0w24O0pZGMS4GGTFFFkmJfI1nd5lJHKhfa0jzBxWJpAhDFycAjCRqc4M/2OcC4RdFe7dFnE/ 670zTYTvotamKcni+QFFfydv2HcpUZWRYeexBza9y8Ryz6r/9P2UtIrdNHjR8g2ianyTTFzecl5 I5AQA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Sphinx reports htmldocs warnings:

Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst:287: WARNING: Unexpected indentation.
Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst:288: WARNING: Block quote ends without a blank line; unexpected unindent.
Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst:290: WARNING: Unexpected indentation.

Fix above warnings by wrapping diagnostic devlink commands in "vnic
reporter" section in code blocks to be consistent with other devlink
command snippets.

Fixes: b0bc615df488ab ("net/mlx5: Add vnic devlink health reporter to PFs/VFs")
Fixes: cf14af140a5ad0 ("net/mlx5e: Add vnic devlink health reporter to representors")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 .../device_drivers/ethernet/mellanox/mlx5/devlink.rst     | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
index 3a7a714cc08f0a..0f0598caea145f 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
@@ -283,10 +283,14 @@ nic_receive_steering_discard: number of packets that completed RX flow
 steering but were discarded due to a mismatch in flow table.
 
 User commands examples:
-- Diagnose PF/VF vnic counters
+
+- Diagnose PF/VF vnic counters::
+
         $ devlink health diagnose pci/0000:82:00.1 reporter vnic
+
 - Diagnose representor vnic counters (performed by supplying devlink port of the
-  representor, which can be obtained via devlink port command)
+  representor, which can be obtained via devlink port command)::
+
         $ devlink health diagnose pci/0000:82:00.1/65537 reporter vnic
 
 NOTE: This command can run over all interfaces such as PF/VF and representor ports.
-- 
An old man doll... just what I always wanted! - Clara


