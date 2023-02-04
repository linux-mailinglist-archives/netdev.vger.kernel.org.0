Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4A168AAD6
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 16:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbjBDPMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 10:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbjBDPMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 10:12:01 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D3921963
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 07:12:00 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id n13so8006691plf.11
        for <netdev@vger.kernel.org>; Sat, 04 Feb 2023 07:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tNbz1uIGRVakRv55mSIq8aw2cUDYvf9rovjf9oVrQ1Y=;
        b=bV7fOs5BXzIrO60QFUR1ETPMVBb7oI4iq9+OUr30NnBLjoKTU1qwNX1HQZYz5OvUIC
         OpAcVgYJOUKZvUTlKfTIzMe2MBjZs/XZdDmYpr+G9v25AzyOg18iBF6vBqH2TIkWqesn
         SkjyuG/aaItILQ5hCome0vT2wgFj6Lzb8SjNptpHHiYV5yMKbpTfGR/3GD/hKlWne78S
         6/K8Q/7JoxBlisqXhqObYXTKTDDUbz0IYmh49ESGZM++YB0ysNE7+PxJpj4pV2ffvpGU
         Jm0OG6XkBLF9EjyTSZHBzn5zlavOM8XuJStIST3zRoFnz47+Y6e8aNVOjSBKjI2YbfQG
         K+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tNbz1uIGRVakRv55mSIq8aw2cUDYvf9rovjf9oVrQ1Y=;
        b=Reamv5KmePIg54nR17xHzxgcnhn2GaI+QvxEvia56rn9fAuRlKJDSPyFkpCDO9nBqC
         JP7DJWiRt95Fht22pOyMVQgnRhptFO3GPvI1N42z8qalR32t8FAcLvU3i1E6pfHuEadx
         +6t+QUjnNOMOmgGNndMjPmbYqviEc8a8lgK05RWvgd3JfxJ5TPPiTUnXN4uDAl9e0vkf
         MkPoiXpRqO+hXqtHNpLZNJLE3AAs0r2a2ocStc2jPl+O0DmER1izSBYo2CT11c/Cquy/
         BBrmXXpnFOvD79RUZJ3J38X5OImtSdqRytd2DAEb45lFAz2AVtukiu8nHVSjNDVAZwO4
         0iuw==
X-Gm-Message-State: AO0yUKX5cCFYc0c2qDqX9O85O4tr2qlwFNXAstug3SGGYBPg0OegItTV
        hMUkCK7XwHz/1HZeT7mVfek4hTP60OJeTNkJ
X-Google-Smtp-Source: AK7set+g+Eb1yYiplbHvbO3TQ5IZB5+0mXLyiijhcD0HGKFg2vgI1a0HL4venzbDgxkBPFkh27+F/g==
X-Received: by 2002:a17:90b:218c:b0:228:de0e:c8af with SMTP id ku12-20020a17090b218c00b00228de0ec8afmr15116133pjb.16.1675523519650;
        Sat, 04 Feb 2023 07:11:59 -0800 (PST)
Received: from localhost ([23.129.64.145])
        by smtp.gmail.com with ESMTPSA id e3-20020a633703000000b004e28be19d1csm3397164pga.32.2023.02.04.07.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 07:11:59 -0800 (PST)
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH net v3 0/2] xdp_rxq_info_reg fixes for mlx5e
Date:   Sat,  4 Feb 2023 17:11:37 +0200
Message-Id: <20230204151139.222900-1-maxtram95@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two small fixes that add parameters to xdp_rxq_info_reg missed in older
commits.

v2 changes:

Let en/params.c decide the right size for xdp_frag_size, rather than
make en_main.c aware of the implementation details.

v3 changes:

Set xdp_frag_size in all successful flows of mlx5e_build_rq_frags_info.

Maxim Mikityanskiy (2):
  net/mlx5e: XDP, Allow growing tail for XDP multi buffer
  net/mlx5e: xsk: Set napi_id to support busy polling on XSK RQ

 drivers/net/ethernet/mellanox/mlx5/core/en/params.c    | 8 ++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/params.h    | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c      | 7 ++++---
 4 files changed, 12 insertions(+), 6 deletions(-)

-- 
2.39.1

