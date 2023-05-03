Return-Path: <netdev+bounces-130-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BF3C6F5515
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 11:44:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E4341C20D94
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42967BA55;
	Wed,  3 May 2023 09:43:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3539ABA4F
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 09:43:28 +0000 (UTC)
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047784EEC;
	Wed,  3 May 2023 02:43:11 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-643557840e4so125413b3a.2;
        Wed, 03 May 2023 02:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683106990; x=1685698990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0VT+PW1nO1R4tbtjQ+6VtJRHvR6DUPI/6keo1qQXgds=;
        b=EPuarUAyUlqvUaDzHr6GrG4a4tL+2ZIF4xM80RmPeqWLVNfnTiRxn82GfYUhEfagai
         wJw8ORzY03w0R6zdN8ToafRrgBNek0cYB4LMFLfOF2WnhhGAcb7IT2Jlw8xe6JnF/S0n
         vO32sxJgdQfRfPhoGmOXgJMd1OkmDgNyCwWf366382fratxHTLyqrjqsKdjPAWyvKTYG
         QIJ/mEEcdQTe+wnorS2oi5qmTtRWaB6XS/kbUSScgkOI1MBoB7mA8gnJLklbK/6mM3T9
         eZRR21usZ988+muYdL0kxRYpqv3VdxG04JLTDeLn8p9GCDxxNZHDrw63pOFolObAqh9W
         LBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683106990; x=1685698990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0VT+PW1nO1R4tbtjQ+6VtJRHvR6DUPI/6keo1qQXgds=;
        b=DPc4CV7WsQMAXllBsylCsVH9GxWxi64wLAz+Gh2G2MjVejRRpZny7RjgCcMKNhsUuI
         +YEeC34l30R7Su6+F+RbwQpqq5HDg6j8QTCZC6gbgQ1HLUymhgX3n8wTQ9cx3hI33m4+
         es335S7C4OiC+6jqfhJTC6DdbvmqSGr785/t1C8TapWNsddAvoiPMk4Hvavk9e9ffqhR
         1uJ8w7AW5us6oKS3/Z1H+nXtqClzKgOA0IZrhX+vXlbEuvNzPuWAM4BsKZuig2AomoMu
         ThaDkn/v+NOGkD8asPkWbGPFvZgedfYOGjHWfAVG8bIma/A6wMB6FlvkqRtRK+LDRVM4
         JIyQ==
X-Gm-Message-State: AC+VfDwjyV7FIfq9iSnujKE9ShjyE2a9YbKH1ZFGa8B+LwfBxKaJBbKP
	qF+VoIGe643snLTiq7sIlmo=
X-Google-Smtp-Source: ACHHUZ7azennRTEMmDQZzC7RF31mRJNNMNHg8ghhGKKriy+OXImzVMZjCi09fcePVE2svjrD/G4uFA==
X-Received: by 2002:aa7:888f:0:b0:63d:254a:3900 with SMTP id z15-20020aa7888f000000b0063d254a3900mr26121053pfe.5.1683106990331;
        Wed, 03 May 2023 02:43:10 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-11.three.co.id. [180.214.233.11])
        by smtp.gmail.com with ESMTPSA id y189-20020a62cec6000000b00640defda6d2sm16512867pfg.207.2023.05.03.02.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 02:43:08 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 210D610624E; Wed,  3 May 2023 16:43:04 +0700 (WIB)
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
Subject: [PATCH net 4/4] Documentation: net/mlx5: Wrap notes in admonition blocks
Date: Wed,  3 May 2023 16:42:49 +0700
Message-Id: <20230503094248.28931-5-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230503094248.28931-1-bagasdotme@gmail.com>
References: <20230503094248.28931-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2404; i=bagasdotme@gmail.com; h=from:subject; bh=z7BlSEzjQe903TqQZUDLwk/+XO0cRAPBx+0vN2jCDQs=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDClBOtO15qdsdy7eYSozd5lemVv8bvll782kWCOMgnq/L lB0DEjvKGVhEONikBVTZJmUyNd0epeRyIX2tY4wc1iZQIYwcHEKwETc1RgZFl/5kNLYVl4SnxW/ aonWbvdp6ppzmyf6ytwUVdHbqDBJlZHhTOybe0uec6qeeaO8Z6J4i9qc1mj+JaKnumdtY65Z6Rz CDwA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wrap note paragraphs in note:: directive as it better fit for the
purpose of noting devlink commands.

Fixes: f2d51e579359b7 ("net/mlx5: Separate mlx5 driver documentation into multiple pages")
Fixes: cf14af140a5ad0 ("net/mlx5e: Add vnic devlink health reporter to representors")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 .../ethernet/mellanox/mlx5/devlink.rst             | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
index f962c0975d8428..3354ca3608ee67 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
@@ -182,7 +182,8 @@ User commands examples:
 
     $ devlink health diagnose pci/0000:82:00.0 reporter tx
 
-NOTE: This command has valid output only when interface is up, otherwise the command has empty output.
+.. note::
+   This command has valid output only when interface is up, otherwise the command has empty output.
 
 - Show number of tx errors indicated, number of recover flows ended successfully,
   is autorecover enabled and graceful period from last recover::
@@ -234,8 +235,9 @@ User commands examples:
 
     $ devlink health dump show pci/0000:82:00.0 reporter fw
 
-NOTE: This command can run only on the PF which has fw tracer ownership,
-running it on other PF or any VF will return "Operation not permitted".
+.. note::
+   This command can run only on the PF which has fw tracer ownership,
+   running it on other PF or any VF will return "Operation not permitted".
 
 fw fatal reporter
 -----------------
@@ -258,7 +260,8 @@ User commands examples:
 
     $ devlink health dump show pci/0000:82:00.1 reporter fw_fatal
 
-NOTE: This command can run only on PF.
+.. note::
+   This command can run only on PF.
 
 vnic reporter
 -------------
@@ -299,4 +302,5 @@ User commands examples:
 
         $ devlink health diagnose pci/0000:82:00.1/65537 reporter vnic
 
-NOTE: This command can run over all interfaces such as PF/VF and representor ports.
+.. note::
+   This command can run over all interfaces such as PF/VF and representor ports.
-- 
An old man doll... just what I always wanted! - Clara


