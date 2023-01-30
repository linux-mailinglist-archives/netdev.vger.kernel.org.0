Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA8C681B22
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 21:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjA3UNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 15:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjA3UNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 15:13:41 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3649A34016
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 12:13:40 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id dr8so13700136ejc.12
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 12:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jb0dSbZwcfsQ6j6Qz7am1GJKQCOw1HGmBIJRs12uzfA=;
        b=ILjgkQF5Lx+gN+VgXrpad9VzafZzeJVGOHmCpo87J8SLwV1jHmLubZJgh9bD3MiZp1
         N7jybB3nkzfdaRRXIXzLsmVboJ/3GedUj7jPV0WB58WhWbhjrh19q7ltsOKPCGJHfRzC
         y8HpGxMo4REjnz8ROxn46xs9yyYb188t28SwSkVvwiSmP0kgMQQRqc+8M+MXVSVbTG/4
         Iu4GbhGtupj+Se1WCA+3yR7V2gfFkuu1a32jn/Xy0Aq3+YyDhCm7McVlkTUjobudE5bq
         14GnHOBAfgJY4RZOu16P1g6If0ZaoQQQaIel/GDvV8s6s7I40r3nQMSF5LQ75lB32u3o
         ie2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jb0dSbZwcfsQ6j6Qz7am1GJKQCOw1HGmBIJRs12uzfA=;
        b=A4JMmzwN3nU7fG4894UUctOB1SEc93G+v4PDMi8NmnFtGlO4ip0O5lRkIRhRvx2/i5
         azaRaw3oa4hqFDnETxxYpN2bzVIapIIB0b9gZFZOpLMWnRAfh+8utw8nXFi2it3ekUGt
         ej/fLjs8SKIF4Ixc0HJCPpc6Mx7ZFStmt24F07Tmzdsf6xwOQQEZMxFaPCHKckSgf8rH
         z0eQdNIGSiHKk2P7AwWIqWpzQ2HohhF7StqhynzIbYV4ax8H+QI01cIJwCaPbHDQchb8
         yT6WUvIFeIigwBDIVJELdaFzMEEVVe4wTFVIJDLTGFR7+fP7xO+j5zO73tgNWoUfZuYw
         8DTw==
X-Gm-Message-State: AFqh2kqiLAJuxC9KnnWNsJj+gfvnLiil5PuromLCOOL5KS6o0mNklfDJ
        FWfjvtFOuCpeQBsPrVUrBk77VyGeBEjC+KPa//M=
X-Google-Smtp-Source: AMrXdXsCYVtmS1bvBNGBtoqX2PuXKnROd+gmTgS5Zf0DDiEDkI9YwIkwqVQdLqk8P/BEGvE48V0d6w==
X-Received: by 2002:a17:906:1485:b0:7d3:c516:6ef4 with SMTP id x5-20020a170906148500b007d3c5166ef4mr53139817ejc.20.1675109618303;
        Mon, 30 Jan 2023 12:13:38 -0800 (PST)
Received: from localhost (onion.xor.sc. [185.56.83.83])
        by smtp.gmail.com with ESMTPSA id n2-20020a170906164200b0086a4bb74cf7sm7397938ejd.212.2023.01.30.12.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 12:13:37 -0800 (PST)
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH net v2 0/2] xdp_rxq_info_reg fixes for mlx5e
Date:   Mon, 30 Jan 2023 22:13:26 +0200
Message-Id: <20230130201328.132063-1-maxtram95@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL,
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

Maxim Mikityanskiy (2):
  net/mlx5e: XDP, Allow growing tail for XDP multi buffer
  net/mlx5e: xsk: Set napi_id to support busy polling on XSK RQ

 drivers/net/ethernet/mellanox/mlx5/core/en/params.c    | 9 +++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/params.h    | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c      | 7 ++++---
 4 files changed, 13 insertions(+), 6 deletions(-)

-- 
2.39.1

