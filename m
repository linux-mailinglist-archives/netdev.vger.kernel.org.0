Return-Path: <netdev+bounces-10645-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5804272F88A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:01:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1344F28136E
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36BB0525D;
	Wed, 14 Jun 2023 09:01:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C0917E3;
	Wed, 14 Jun 2023 09:01:10 +0000 (UTC)
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6B51BDB;
	Wed, 14 Jun 2023 02:01:08 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f6255ad8aeso8230267e87.2;
        Wed, 14 Jun 2023 02:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686733267; x=1689325267;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Fi7jYiyIuxrBpP64V4qKjFbM9+nUEfmzh6+nGoNO0Ms=;
        b=BToOLcfQM9i29CjpqtpOTXIlr9sz2LOsrGxPCM9xQ5aP9eIazRLilcBkQKBh//qknJ
         qQrC3QQYVzPcb1lVAfvv2BaAzpNFxB3caOpvfvmx4Sp2zcS7+AxCeL7a8iyxxLvrGu3C
         5ref+cbf2XIvQFHEDydQFpPy/l8TLWNiXIR4d/jwva8/6IbraeJfWxJG0668VK7UqjP1
         BCoVva9JsURVZH8aNdmW2I216iS5718HVmuffPCzXrowEBIZZj6Q5DmCUJaaCHSJmfxv
         GNFFe1Bzs9a6MlGvLiEL6z099J6lp12klOmEtWRQlI1wtN4ljrIVBAUP80ozIQXYRa5v
         MINA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686733267; x=1689325267;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fi7jYiyIuxrBpP64V4qKjFbM9+nUEfmzh6+nGoNO0Ms=;
        b=kQCduT21JeDEx6prvSgzir6LtNYaAeCNNHubvDphc5bjKAKCgWgVElYwxAmXddr8xJ
         aRU/UuI5dlnF/1zONphtI6ZXUSGlT39aTI+y1k4IFrd3edpptl/cgB0cora8bZtKarVd
         mJXWZV9V5FQMIvq5zPTy5zKX8XpWsK4HQNKz/QzluzNUP/x1QqADe8KEJCXSeSMloQn4
         uoo2UmUAm/F8e2nOI6Yp7uK3yOaFBEegnczqgU/LWkJ9FbRn8R7G4vIVUcMV/y/EqMBN
         L6usotVBAOx5Uxb9o6XaN+W69LEq6/sUZM52CNDgBcbYi6sLfqqBIhnUmHzll1omKaQi
         XffA==
X-Gm-Message-State: AC+VfDxXJkh2vWLCQV8gdzRDci6fcmNqUele9fT/JW0jQv9tR3hyObKr
	pOjoKAsAZKrIoYJQLz5Ir5saYn0Lfbi6A/st
X-Google-Smtp-Source: ACHHUZ6GZE/uirClxrxvCsgzLgdqzCFRJV1+T7XpnYZ4KsUWBCBpnDn8eH0Q8EBJwvuY9IxtFjv35g==
X-Received: by 2002:a19:6407:0:b0:4ec:9ef9:e3d with SMTP id y7-20020a196407000000b004ec9ef90e3dmr6738274lfb.26.1686733266430;
        Wed, 14 Jun 2023 02:01:06 -0700 (PDT)
Received: from localhost (tor-project-exit5.dotsrc.org. [185.129.61.5])
        by smtp.gmail.com with ESMTPSA id x12-20020a19f60c000000b004efe8991806sm2034457lfe.6.2023.06.14.02.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 02:01:06 -0700 (PDT)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	bpf@vger.kernel.org,
	Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH net-next v4 0/2] xdp_rxq_info_reg fixes for mlx5e
Date: Wed, 14 Jun 2023 12:00:04 +0300
Message-ID: <20230614090006.594909-1-maxtram95@gmail.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Resending the patches, as I'm afraid they were lost eventually:

https://lore.kernel.org/all/ZDFPCxBz0u6ClXnQ@mail.gmail.com/

Marked for net-next, as I'm not sure what the consensus was, but they
can be applied cleanly to net as well.

--

Two small fixes that add parameters to xdp_rxq_info_reg missed in older
commits.

v2 changes:

Let en/params.c decide the right size for xdp_frag_size, rather than
make en_main.c aware of the implementation details.

v3 changes:

Set xdp_frag_size in all successful flows of mlx5e_build_rq_frags_info.

v4 changes:

No changes, rebased over the latest net-next.

Maxim Mikityanskiy (2):
  net/mlx5e: XDP, Allow growing tail for XDP multi buffer
  net/mlx5e: xsk: Set napi_id to support busy polling on XSK RQ

 drivers/net/ethernet/mellanox/mlx5/core/en/params.c    | 8 ++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/params.h    | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c      | 7 ++++---
 4 files changed, 12 insertions(+), 6 deletions(-)

-- 
2.41.0


