Return-Path: <netdev+bounces-129-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D47CC6F5513
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 11:44:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 376611C20D4B
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8732BA42;
	Wed,  3 May 2023 09:43:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC84ABA3F
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 09:43:27 +0000 (UTC)
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC9649F2;
	Wed,  3 May 2023 02:43:10 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b60365f53so5567457b3a.0;
        Wed, 03 May 2023 02:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683106990; x=1685698990;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sqvmzpSfh7BOiDMlgneo0+djsuuObhP2Z0rVZr4lDOg=;
        b=UwZnD9/fcZrkqOZCSC4bWh3iltR4zy8emhX+MwX88jpqXu9K4Shg2M1HnVL0Q+0/Iq
         E37lv5Aw1Rc4Zfq1bnwyTl9sSK7fjYIPashCAKyCYub7ExiqBQhKa72+acewDM1LAOWA
         dTO8nu1LkJd6SX0fZ3TF2iBWC2QwXATraPdlM4Dno/IwF0KnVB/8wlO+h/JWP/u45D2O
         Ui/jXm1HfjHsxrRI05+vK4Fb8Qz11EI74TpMyEWmzQKbkvpo65vKoHH+NIfBoPUQG+Sl
         fKbyczCRGx2WFq+WcwmrcK6lgM1s+abjL1yls/I8D/S+cSj9gx1PDzlW9c7GIflpKLo9
         ohMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683106990; x=1685698990;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sqvmzpSfh7BOiDMlgneo0+djsuuObhP2Z0rVZr4lDOg=;
        b=jpN+cJDJxx94C/Ki+9L8DOGZCf2LxvJCeI+EMP0lOf+GU9BDi2Ahq7QTKDj/XDwirL
         BIIHfZJpLwF+atmn+oAwSuFp4ylOFHc67k42j4u2RwiBygKdE5k6oKRcXptxua1WUvQC
         s1VaxDW/Z8DyFa/ZwVz01/h63Ys2mBeqPXpdfgvDdK8Vaw6rSxevO/GQMfCjcDmsLCpw
         hpobKRa1JWFonv2kwqo3H0SaeKIh5TxnnvNG1dDJMHypmTcD2eGVHix9sbeFEeZoKxSx
         galu4MIefw5ZDWHQ8q1Dwtl5pEcPI3tYC6NQDd1CJl5E16Evc3dpGHzxU81dtKgbmfWs
         Ygew==
X-Gm-Message-State: AC+VfDyFl19offU6SyGWhNizxp7bu1VpssdopBA18u6D2tc9R1z15OtS
	BJQaxTMaKBE5kjPHQXbVMdkQYgYmn9Y=
X-Google-Smtp-Source: ACHHUZ68zLDVQf2eKV+GWEFtaAUCrBh4nVjOqbrBcNzLH77grDT5QnN10SAIAwuYdcVOs3f2UdcPKA==
X-Received: by 2002:a05:6a00:140e:b0:63d:3f74:9df7 with SMTP id l14-20020a056a00140e00b0063d3f749df7mr26228464pfu.34.1683106990046;
        Wed, 03 May 2023 02:43:10 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-11.three.co.id. [180.214.233.11])
        by smtp.gmail.com with ESMTPSA id a10-20020aa780ca000000b00642ea56f06dsm4714307pfn.26.2023.05.03.02.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 02:43:08 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 72091106250; Wed,  3 May 2023 16:43:04 +0700 (WIB)
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
Subject: [PATCH net 0/4] Documentation fixes for Mellanox mlx5 devlink info
Date: Wed,  3 May 2023 16:42:45 +0700
Message-Id: <20230503094248.28931-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=727; i=bagasdotme@gmail.com; h=from:subject; bh=aer6HOi8fhrQqjCrvQO5H7xohlct7D9hbyMhJQSmMaE=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDClBOt0c/+q31OZdnq4UzW/CxJX4Y5n/r6tWx70fJq04t NjRd5ZkRykLgxgXg6yYIsukRL6m07uMRC60r3WEmcPKBDKEgYtTACayNpqRYdbFvP67ryc1a231 ly4WXvO+Izayq3xe20enoNxcufRjAYwMTTteXTn0tDhCb5p9lf9O26zbMt859AQuccqKtpWceHu OAQA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Here is fixes for mlx5 devlink info documentation. The first fixes
htmldocs warnings on the mainline, while the rest is formatting fixes.

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


base-commit: c6d96df9fa2c1d19525239d4262889cce594ce6c
-- 
An old man doll... just what I always wanted! - Clara


