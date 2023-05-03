Return-Path: <netdev+bounces-126-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83FC36F54FF
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 11:43:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5E692812DA
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5599C7477;
	Wed,  3 May 2023 09:43:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF90EA5
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 09:43:26 +0000 (UTC)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48444EEA;
	Wed,  3 May 2023 02:43:09 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-643557840e4so125396b3a.2;
        Wed, 03 May 2023 02:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683106989; x=1685698989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YDPdE1XfunQuIWf3y/jI9wckA1ok4K+KpzHULl9/uio=;
        b=HL/GfVZ1j0oM8h89CjN4LkrI5tvOMRtAg/+7+kXwp1OWEq8ugwhTv/zxOsUSPPsz1J
         0sRhx2D1DKB+BswYH9qJxd/DDgsbyZXHlQgWN7oLD79MkxoI032udyTMzkBrgtrB6o50
         gd9ZZaz9OpLG3gWTbkkXn+31f1GTXo0nrHxp31RVvPR7MvciYHYJrJ8EVEpSCxf/zFKl
         W/q8aUN7NG/0zL62+N6TZWSlFSnFBjwAian6Bg/xj7WgG54+5KFJ6U6Wzw6+6whxMRCR
         6K9K31f3eWQDumMdikCjGk+wC4KZ1jcG7y8XkXZWlFLqnIsiyXXQvhDtCnOKqEoND7eg
         b/wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683106989; x=1685698989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YDPdE1XfunQuIWf3y/jI9wckA1ok4K+KpzHULl9/uio=;
        b=K2mnyg49GZS1D2ngYoTZI+PBdjcgh8r3gEuqnvs597mK8iEuoQ/o2Pi3vvYITYqhgX
         wiGg/vVpWJWA2IC+4L0IKzeg0pgzm1yZuDvsbDIby+6G2DZLcuOWYAyr72g7MdOpNUqO
         NICKnEERgM9U9EXeMkK3imfb+EOxKu1o3OTxJL1n5FoRHy/NfNT+mEk1rGt+X9DPEhoU
         IEGfyypDS9GK5+SCsHFvL4OI6ReJk1PfoHRBQArsUp5j2wDFYdUMXNbVACHKVbGHUBGp
         TmIUlwjydSFsUVQ6nYqPpzK43wGBIX/FKm0uNaXBGxehbpSL8e5SmsoSHtxvLl+7LUm8
         9K0g==
X-Gm-Message-State: AC+VfDw9IHvaGWRetdgBacWFrEOYgLAFLDu3mKzp7qO6MAIwcAoKECih
	qCDr+czY9iJe8kb5aX18kKM=
X-Google-Smtp-Source: ACHHUZ6xRNyfm7gpGVKaUHMZJ7cSmuq4Z8ooUCKyV4KAI7QHB/0nJ6BiXsACOMDXzMYCIJ7kwjsjxg==
X-Received: by 2002:a05:6a00:2d1b:b0:63b:854c:e0f6 with SMTP id fa27-20020a056a002d1b00b0063b854ce0f6mr30151178pfb.21.1683106989056;
        Wed, 03 May 2023 02:43:09 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-11.three.co.id. [180.214.233.11])
        by smtp.gmail.com with ESMTPSA id g10-20020a62f94a000000b00640df8c536csm16903809pfm.12.2023.05.03.02.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 02:43:08 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 0857D10624F; Wed,  3 May 2023 16:43:04 +0700 (WIB)
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
Subject: [PATCH net 2/4] Documentation: net/mlx5: Use bullet and definition lists for vnic counters description
Date: Wed,  3 May 2023 16:42:47 +0700
Message-Id: <20230503094248.28931-3-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230503094248.28931-1-bagasdotme@gmail.com>
References: <20230503094248.28931-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2727; i=bagasdotme@gmail.com; h=from:subject; bh=o+hJBFwjrfn3zz2fGYB3tCdijJYNrT6XMKn3YVD2Ts4=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDClBOtM5w48VX3rWwS4yYemDwhrD01LnNvXGfPVmOW81f eFStoAlHaUsDGJcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZjIOTmG/xFlUvv2dh87Pl3n y5rZbyxKWt+pyKTd/h7Oei8lYN/zaWcY/hczM95pvsSxUUrj8v2W9dXsJ7+0Z7GXae0w2cq781W NExMA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

"vnic reporter" section contains unformatted description for vnic
counters, which is rendered as one long paragraph instead of list.

Use bullet and definition lists to match other lists.

Fixes: b0bc615df488ab ("net/mlx5: Add vnic devlink health reporter to PFs/VFs")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 .../ethernet/mellanox/mlx5/devlink.rst        | 36 ++++++++++---------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
index 0f0598caea145f..00687425d8b72d 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
@@ -265,22 +265,26 @@ It is responsible for querying the vnic diagnostic counters from fw and displayi
 them in realtime.
 
 Description of the vnic counters:
-total_q_under_processor_handle: number of queues in an error state due to
-an async error or errored command.
-send_queue_priority_update_flow: number of QP/SQ priority/SL update
-events.
-cq_overrun: number of times CQ entered an error state due to an
-overflow.
-async_eq_overrun: number of times an EQ mapped to async events was
-overrun.
-comp_eq_overrun: number of times an EQ mapped to completion events was
-overrun.
-quota_exceeded_command: number of commands issued and failed due to quota
-exceeded.
-invalid_command: number of commands issued and failed dues to any reason
-other than quota exceeded.
-nic_receive_steering_discard: number of packets that completed RX flow
-steering but were discarded due to a mismatch in flow table.
+
+- total_q_under_processor_handle
+        number of queues in an error state due to
+        an async error or errored command.
+- send_queue_priority_update_flow
+        number of QP/SQ priority/SL update events.
+- cq_overrun
+        number of times CQ entered an error state due to an overflow.
+- async_eq_overrun
+        number of times an EQ mapped to async events was overrun.
+        comp_eq_overrun number of times an EQ mapped to completion events was
+        overrun.
+- quota_exceeded_command
+        number of commands issued and failed due to quota exceeded.
+- invalid_command
+        number of commands issued and failed dues to any reason other than quota
+        exceeded.
+- nic_receive_steering_discard
+        number of packets that completed RX flow
+        steering but were discarded due to a mismatch in flow table.
 
 User commands examples:
 
-- 
An old man doll... just what I always wanted! - Clara


