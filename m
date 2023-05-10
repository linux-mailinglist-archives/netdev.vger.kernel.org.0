Return-Path: <netdev+bounces-1320-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CF566FD4AE
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 05:55:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06EEA281322
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 03:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E632112;
	Wed, 10 May 2023 03:54:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBE120F0
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 03:54:37 +0000 (UTC)
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7F54EFE;
	Tue,  9 May 2023 20:54:35 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1aaef97652fso46478255ad.0;
        Tue, 09 May 2023 20:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683690875; x=1686282875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Bksri3u+2ou45ymklEGdo+3VOZCYOTumAp0Ryz1FdA=;
        b=EooubZ2VKqSN/12+BCYDM79baPLfy3nlIouj+oJ/D+gXMVC9pAQfgyQDiHBwkJs0ip
         srUtmMJHmwA1Kj4Y8zzpo82gGZUNkqP9Now2KmZFG2+vxPPNNmG5S6pitipsVKYojcJy
         tjRLOBpFilaEN7z7WEFM93UYi2ZLp39bP37A8Eb7f0ILbG+kacrlAJ0GkxLY5+hiRSzy
         epdQvo8CHIGJSGZ3wkLWhFfR+76JhJL13Mdvc9iNELrtZDBqfbjysvWv/ccwv/3DWmbb
         V+VXlWnzox3THZ0TPUTO5vjRzRmVyVE9QWa7Jy9zohx1DB2Bd+hQ03LpFB+Jo7CZZoB2
         ezfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683690875; x=1686282875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Bksri3u+2ou45ymklEGdo+3VOZCYOTumAp0Ryz1FdA=;
        b=GNUZNC6Amdo4tx0cSp7kT74+qGt7Q3nTxUmXxGKJBOkHf8jQ/Q4EWELQdPIvLRk3v4
         FAdOWNAVnXTpClNOnj31XkwqB+9S4aXbiPjPoukMjVOXUQHLFAROT36ycrs2nIJUlvWn
         c6QrnVOx6rbyktiz6hf2a7xSumjV5n6ImBK+5uXL8pOJdIRPfE5nhx9SP3H5n2HGK4Ta
         QYO6Pw9JY7ofiXgpTaZQScoLEDE/jiNcHvDCFtmhxSi7nK11ZA2q/Td/iiMDyDBpW3/k
         yZ+f1d5VnAOfPr5rYwKtWxQTzpV1j0wEYstU6CR5fjd/Yg98X8iJ6yHl7mQa2/zWk/Mv
         SaNw==
X-Gm-Message-State: AC+VfDyQlO+s/xxD6OnzgEGuba1BkZ12gdWKk6kduTi+PVFPORslLgYc
	T7GseNK9maWfz9AXHLvExqc=
X-Google-Smtp-Source: ACHHUZ7VhzmbNMlSO14YvlGNTgX4G+2oJJOBGDaU8NLBWdQE2DLFPByKUrOh3G/lO43KkONMvHoaNg==
X-Received: by 2002:a17:902:c1cd:b0:1a9:40d5:b0ae with SMTP id c13-20020a170902c1cd00b001a940d5b0aemr16980105plc.12.1683690875088;
        Tue, 09 May 2023 20:54:35 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-21.three.co.id. [116.206.28.21])
        by smtp.gmail.com with ESMTPSA id az7-20020a170902a58700b001a212a93295sm2471278plb.189.2023.05.09.20.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 20:54:34 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 61D0F106AA3; Wed, 10 May 2023 10:54:29 +0700 (WIB)
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
Subject: [PATCH net v2 1/4] Documentation: net/mlx5: Wrap vnic reporter devlink commands in code blocks
Date: Wed, 10 May 2023 10:54:12 +0700
Message-Id: <20230510035415.16956-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230510035415.16956-1-bagasdotme@gmail.com>
References: <20230510035415.16956-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2123; i=bagasdotme@gmail.com; h=from:subject; bh=O0gb1djqqGlVnpw0BLHtEz7rG+DhvvWYMeRgnv2afG0=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCnRomnL/wm/fB9dnr71bcNuOZlDKROXpDMsvdyzxezbx 2nLl0gs7ChlYRDjYpAVU2SZlMjXdHqXkciF9rWOMHNYmUCGMHBxCsBE3BMYGe6JHXGffVul8FCj zmsbtrneb3qlf5rlZDGFb8/gab88o57hf8XKTqMDr8KdZu/245vnYurzWcjo4cJbYilqdStXzey UYQMA
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
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
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


