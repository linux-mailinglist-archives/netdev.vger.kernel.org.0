Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B401365F6E6
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 23:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbjAEWgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 17:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236157AbjAEWgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 17:36:47 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B766A1B1DD
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 14:36:45 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id g16so31182346plq.12
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 14:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vTnS8YGkz+TFlaH5VylWTT81FwP8SacJ4LHArMeisg0=;
        b=Od3RSE6LiX0RDr6NqBn7rCVN/9DDDXs0q+tdT8jFQncP6Urx8T2WMJHv89zDyEDp7O
         4gyuEjWhxh3h7/iqTPH5ceEQX64JBhrM5b5kHvdfaEVQ9hRdLJRNOppjlomjTaI3BIGf
         w+3D8bNOlw2KFUDHvYyOVXVe4LphI3IDQbgjc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vTnS8YGkz+TFlaH5VylWTT81FwP8SacJ4LHArMeisg0=;
        b=mt+LzA0IBkKhxe/517gqBSEr8DtWeWnieR6Wk8oqylGi85TSy3TWDMGecrktQPXpn5
         HkNgKdI94Z0qxnySqJWijDND9CQkfbmwvYJ5QnEtDQYt7DlvJKYnGqxOE2W93zAmsRnX
         bQ2RXtNACulbnHN2bS3MJBhDEhM9rLBwdW9K+m70C2zaHNpiYWoc1NtnkKX3z33r3/VC
         jqts8Fk36CwmV8s+xLobscwPWsr4o4lwPXvcq9wmUJLB8cy2YZuFY455/BQb2uPVbQty
         lFHlZqqx8QA0kEB60c71Oo9719SyDfgeX2srqnl9KMWh/L7fK9K7hR6+M7javUQnaB9+
         pLXg==
X-Gm-Message-State: AFqh2kqxy6ivXfjnlJ6y+XlSLGTBJgazZLGX56fC8Ij3DguCJgix/9Kl
        Ga+jfH3UChfVqwif8DM6K2TzkA==
X-Google-Smtp-Source: AMrXdXux9e5NuZPpnskqtYB+XoAQpaU8Ilr5HfAMj1CxdM9IDVskpvaO076O8SqFOoZhA8EsUBypdw==
X-Received: by 2002:a17:902:f08a:b0:189:efe8:1e with SMTP id p10-20020a170902f08a00b00189efe8001emr51337863pla.68.1672958205276;
        Thu, 05 Jan 2023 14:36:45 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a11-20020a63e40b000000b00478ca052819sm22392159pgi.47.2023.01.05.14.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 14:36:44 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] net/mlx5e: Replace 0-length array with flexible array
Date:   Thu,  5 Jan 2023 14:36:43 -0800
Message-Id: <20230105223642.never.980-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2058; h=from:subject:message-id; bh=z9zLbe924cMlc9bCRVzAk3TMTpuiLHM3ITNjTKxLEL0=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjt1D68KpUigmLbVjgVr7qwolklCRIkWm8FyY1lEal zrIwQ0OJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY7dQ+gAKCRCJcvTf3G3AJszwD/ 40sd9lxHmJk2Jotmcy0c7sImQsz4M/iSxCz1Jpo1Acu/9tBXHYG1WSg/JM6HXMs25zbP83WqwZz0ta ScdPosftzA9wgmMXb8/vXf5cULI/T6DCXW0ZjMmLqmCK/rwtV3r7z6oheW3142vbpRV16KcUPEG3cd I4F56O0hNGAOds3VxCtoqEVp7piVlUf8dB0bVyBEmFpdaXdPqRdyAOwEq3YODbu6OA/FoiGnHHpg3I ydu80/WoZOPdRL6PkOS3k+bHThq6R5S3STEcXo1ZzL3p9pg5gO2oD73XIWp+O+5oEdQ44XJ5IeQlRB C83oU0jwWetg8xUaErm2gxRVENDxW7kkm3f9H5ua/0O0HqjXbIWmIGe/IW/U7zAS7n0LJihh/aarM5 eBN190UCobxYYRfBwBgDKNaOhyVpdGloA2ctVsKl73uBOYVh22Uiyxdf1kTHlq8jdZXHY4F7c3lcnx V3hmmqzjd9J5X1mX2UixvWWgYi2tElBFI6QWnp826wGAbGWWmo2k/Az3EuzS6KU9Zigo49zT2DPfV2 pCcEPuUsbIXEii75tbJ+5iL0Drqc9BeOHZengIsBO37yKw0hkbNI8ICcqNhFpUR2Y7lvFAOQ2eJy9+ TWP/koLD8R1zAvnL6ic+lKbJeF13un/q+KpvgSiiUvs1+7ynM31ceE79ROkg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays are deprecated[1]. Replace struct mlx5e_rx_wqe_cyc's
"data" 0-length array with a flexible array. Detected with GCC 13,
using -fstrict-flex-arrays=3:

drivers/net/ethernet/mellanox/mlx5/core/en_main.c: In function 'mlx5e_alloc_rq':
drivers/net/ethernet/mellanox/mlx5/core/en_main.c:827:42: warning: array subscript f is outside array bounds of 'struct mlx5_wqe_data_seg[0]' [-Warray-bounds=]
  827 |                                 wqe->data[f].byte_count = 0;
      |                                 ~~~~~~~~~^~~
In file included from drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h:11,
                 from drivers/net/ethernet/mellanox/mlx5/core/eswitch.h:48,
                 from drivers/net/ethernet/mellanox/mlx5/core/en_main.c:42:
drivers/net/ethernet/mellanox/mlx5/core/en.h:250:39: note: while referencing 'data'
  250 |         struct mlx5_wqe_data_seg      data[0];
      |                                       ^~~~

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays

Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 2d77fb8a8a01..37cf3b1bb144 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -247,7 +247,7 @@ struct mlx5e_rx_wqe_ll {
 };
 
 struct mlx5e_rx_wqe_cyc {
-	struct mlx5_wqe_data_seg      data[0];
+	DECLARE_FLEX_ARRAY(struct mlx5_wqe_data_seg, data);
 };
 
 struct mlx5e_umr_wqe {
-- 
2.34.1

