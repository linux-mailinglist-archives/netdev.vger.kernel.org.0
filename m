Return-Path: <netdev+bounces-1317-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 55EBC6FD4A9
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 05:54:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 544041C20CB1
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 03:54:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C6CA65A;
	Wed, 10 May 2023 03:54:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F95963C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 03:54:36 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E593AB1;
	Tue,  9 May 2023 20:54:35 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-643557840e4so7262403b3a.2;
        Tue, 09 May 2023 20:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683690874; x=1686282874;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=c7VfK4HmZZECZTc8y6PXzxcQ+L1k1OBzevJBYhlk87o=;
        b=gaGdt28RcEpkgfk5GFzurtmArKfRYnu6pEdKCjfjsy9niCtJd4Gz2Bh2fGXcyQFYR9
         u0Z0AykqnECM+9pfe/+NKE/uLaagxLuGJfeueBS+arjRhCUwOBsdxdbsuIDD5F4jJUH1
         xqLiDHd2unyx6iADRqN4sBWL6Z5vES+kL3sMGOCfMr/jnfQmQxKmkHJu4kBVtLHGHTe3
         tE40r7gXuOvY1XuVsAH485ZqhWJAC8+YJf+1Jow0QY4kRXxMkyP4CwSrkZrNDpasJzek
         AYV4bUdr4v9aS5ZAMbEphFq8TnWUcTu+VG8KcOmHPNZS/vEhXzOUPRAyaDlfDnYb1Oml
         9atA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683690874; x=1686282874;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c7VfK4HmZZECZTc8y6PXzxcQ+L1k1OBzevJBYhlk87o=;
        b=jwxhN5+VNrLYydZNAM1fH6bOeie1PdwrgQsddup5BJ5KcWDL732W5tTDSUv0kpGB17
         TDJTozhzJ79yZyTNxjsz5Hb/zj5Is3as59BQxnH1z6dmHbL8LrGauOk66dcKINCGAHID
         WmEl1knaUfq0u9rxjXJBRqDcMkXXzz34q9Ua/FtIf84puON3uZ4br8BhCbgF+a2EDyDd
         YX5OfIhqK7LOSUCmnRAaLQOXZHc3coe9EwV47BBWvItn9dS2C02RetUlvBEsJR6N7HrB
         l6OmJCug8L21FlZPSc/ZSGyCCbsa41nHSbosHOKxkDqFJz34P4lc2GqajLkskRF/S15t
         5uBg==
X-Gm-Message-State: AC+VfDxDiWxrnc4KtUTqR8izThbGrV5aifZ/E7N81EkCGFhxjrN3E0+5
	mpUVHXNX8qtFa8OIZcpMO+3/OxX3sNw=
X-Google-Smtp-Source: ACHHUZ61odxsumH5leyGMsZ34hnHK9BEErNzNUPT3fzJH0vkclEldYH16tylwJmy8KD1dWBCVtzTvw==
X-Received: by 2002:a05:6a00:1915:b0:647:e45f:1a49 with SMTP id y21-20020a056a00191500b00647e45f1a49mr2265962pfi.4.1683690874616;
        Tue, 09 May 2023 20:54:34 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-21.three.co.id. [116.206.28.21])
        by smtp.gmail.com with ESMTPSA id bm17-20020a056a00321100b0063b54ccc123sm2495273pfb.196.2023.05.09.20.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 20:54:34 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id BB0CD106AA6; Wed, 10 May 2023 10:54:29 +0700 (WIB)
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
	Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net v2 0/4] Documentation fixes for Mellanox mlx5 devlink info
Date: Wed, 10 May 2023 10:54:11 +0700
Message-Id: <20230510035415.16956-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=925; i=bagasdotme@gmail.com; h=from:subject; bh=vGIotmQ0XAH1YOV1sWVtot5K851N4Z7SeyiHpdnYFh0=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCnRolEXIj9qV7y9N2PGueXP551Z/dSYf43widwLXn617 yt/HLr/tKOUhUGMi0FWTJFlUiJf0+ldRiIX2tc6wsxhZQIZwsDFKQATKbViZFjivkVAM9Zzm+f8 dTsDzh4zPlDItJPb4ZhRxMP/5/Zs7V3B8E/3SoDgxIvyN/w0L6v/OfmK6+p8g3LjpN6szKWNNyQ 1KtgB
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Here are fixes for mlx5 devlink info documentation. The first fixes
htmldocs warnings on the mainline, while the rest is formatting fixes.

Changes since v1 [1]:

  * Pick up Reviewed-by tags from Leon Romanovsky
  * Rebase on current net tree

[1]: https://lore.kernel.org/linux-doc/20230503094248.28931-1-bagasdotme@gmail.com/

Bagas Sanjaya (4):
  Documentation: net/mlx5: Wrap vnic reporter devlink commands in code
    blocks
  Documentation: net/mlx5: Use bullet and definition lists for vnic
    counters description
  Documentation: net/mlx5: Add blank line separator before numbered
    lists
  Documentation: net/mlx5: Wrap notes in admonition blocks

 .../ethernet/mellanox/mlx5/devlink.rst        | 60 ++++++++++++-------
 1 file changed, 37 insertions(+), 23 deletions(-)


base-commit: 582dbb2cc1a0a7427840f5b1e3c65608e511b061
-- 
An old man doll... just what I always wanted! - Clara


