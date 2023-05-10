Return-Path: <netdev+bounces-1321-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FDF06FD4AF
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 05:55:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C693B1C20CD6
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 03:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 261453D9E;
	Wed, 10 May 2023 03:54:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24E83FFF
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 03:54:37 +0000 (UTC)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B8C5FC1;
	Tue,  9 May 2023 20:54:36 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-64115eef620so47259750b3a.1;
        Tue, 09 May 2023 20:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683690876; x=1686282876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RrruFyLLgJJMJgx5u7sEynKf36MmMk0i/j9iaoKs+9E=;
        b=A/r04JqUZep5KvkgYVpgT8GvIxTLL5xMq1m8jz2fbJMyc+Tn2NeK9zK2UVsyuf//pD
         HXe1n1zUJBeIZ3kpjMTJ6U05UNQM4Cfj+1dneYS17EnMZDhSuWDRHMwGeYuVna2DnUHC
         UZ1SFrvKwb7XFnpOeNT8ihdfvN/MEYhlumRqMRecTPSaAcngngthUEVAf5j7ccZrD6LP
         5ImyIzG+XVb7gUeb2nj/+tO0Pj1bCHZP5HPfZQVhMELFQ3S6y9vxq3QPu9zuOoqon18C
         GOgoyafz7hJl0mRaHdWUqsSs8jw17iJtH1Iq9gCMk5CNt6Bmba7CnyDRxdne8NXmhKS7
         3CVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683690876; x=1686282876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RrruFyLLgJJMJgx5u7sEynKf36MmMk0i/j9iaoKs+9E=;
        b=UCbwO1h+CcnW9Fx+JW9joyKsmNXsR76CGy0VwbIRXw0jB9cLNaKlkWNPwKuurR+m2i
         Mvvl+i000VPK03rqCwqvA6DReWsP4e8yXoYbEmcBqV/gLx2jxCC5gSPL7uCEsWs/XF3L
         P/COOfApelF2IQfETpQfr7mN6JnYr6kaFOSg/WI8LEEE+dA9tl1B0nf/SqYuZ9OaLzQV
         oCBMxgz9sxDSJjEBKwjhIwAbpnIdZ8mHe9LO5szAjfJsoqL1CL65roH9MeqVh6+/q/rA
         48RELz8k3mEZc/yC7nc9MdfOahCDg6mPF4lIIuYbQjM+QTk+z/kX4CLEBtiWw0Vup1vw
         XVhQ==
X-Gm-Message-State: AC+VfDy35r/7a6zRZz6JHocfrzPrdwpVE/M2LwPEW+IHYJ3kFpla0LO4
	TnWNjFTNoNoPmS523adWZ94=
X-Google-Smtp-Source: ACHHUZ5yOZmYLWXZY122w/MJgciElXT98GlE1D13KqOurL+OEM0S8WnDY2Fsm3I+elnnfuSIjch1fQ==
X-Received: by 2002:a17:902:e848:b0:1a9:5674:281c with SMTP id t8-20020a170902e84800b001a95674281cmr21389486plg.23.1683690876007;
        Tue, 09 May 2023 20:54:36 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-21.three.co.id. [116.206.28.21])
        by smtp.gmail.com with ESMTPSA id h11-20020a170902b94b00b00194d14d8e54sm2491291pls.96.2023.05.09.20.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 20:54:34 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 109A4106868; Wed, 10 May 2023 10:54:29 +0700 (WIB)
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
Subject: [PATCH net v2 2/4] Documentation: net/mlx5: Use bullet and definition lists for vnic counters description
Date: Wed, 10 May 2023 10:54:13 +0700
Message-Id: <20230510035415.16956-3-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230510035415.16956-1-bagasdotme@gmail.com>
References: <20230510035415.16956-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2777; i=bagasdotme@gmail.com; h=from:subject; bh=NEIhd+5K/G8nrmt5Y9QAggc3+/Jm4hr2uEYbbziVrlI=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCnRomnsljt3uUY2G63fmvDDwshZ+0OIqOSfkLxckXd7m y7OeWPbUcrCIMbFICumyDIpka/p9C4jkQvtax1h5rAygQxh4OIUgInwH2D4Z1bzqPd12GzbnWd3 u+fOcUiTN2iLPnlnbq/W7UubWrPXzWJk6J/jxPhUYxXjnmf2vrpKCdPPBDs+riq2P960q/TEirX TeAE=
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
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
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


