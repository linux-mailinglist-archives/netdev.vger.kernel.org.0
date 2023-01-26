Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6A567D51E
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 20:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbjAZTLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 14:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjAZTLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 14:11:12 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA825246
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 11:11:10 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id x10so2773753edd.10
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 11:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a/GOt17sTr2fpJFS7F8GPliUevuEgTXeRKP7Fd5WLrY=;
        b=PhbGhXCSEYR2Tx752xbC8K0JH9TVe9yEY8WrrffOAyrPg+T/e9iO7BAhY2IV9gBAAW
         s1/TOt9seFvXcd615QfxrMBuw9VBvYvc8KCUfJb+rkNtU36RzeYK09R9pABeKvV76aQ2
         l+XY7TNWchoeKpmeHuM3V0uYLac1Ioj7EJFN9cpFm3GyCFHzr+r/rE5OqECwPbMPXY6b
         Wnmhqur4jTqDiouaSoeAQSITBE1NEyy2OD5TjEYJvctTOEN7PjfdW58HtFR7X/OTDM6w
         AuAC0z0FEoFX0v0uZ106YKDfRavkjvh4gOzLPwmznm/nZJJBVtjVbmtDwakbDKOcXLHK
         eQTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a/GOt17sTr2fpJFS7F8GPliUevuEgTXeRKP7Fd5WLrY=;
        b=SGZYktpR0GP5hyyiT7i6e4iqWfZ+qEJDA2Jtat2XX7vWx1MZONbDJqEkAzJACuTcjV
         77qcitNuRli7y+U2Tv90dxi4WHmnvxbKcnwV08ANcG1l7BZr5ohQGSdnJjMKJR8pDL49
         zhPcnkDim2Z0LmpLreS81j9I6sp4nxGg4N+/ie3Ov2u2dpMJe4Hf7Z35yQu0z2T4M7G9
         8l7e+HrhIksc6zHpW+JM3aM/k3BEpNe4Is3uHGD4DEWraCGew0y+DluZZwFDizZ7rHy8
         ZnPM5nXgRmLSXvmlT60gVtoLlVWnFDE4Ub4s6CDPgOluFLKhgDHFlluW4JJVX03l73D5
         uP0A==
X-Gm-Message-State: AFqh2kqHTG4EGB2bbdmb7UpSoaWi+R3QvqqGSH7EVFcwtBVy/WT6Yjlu
        T1ptUJYAIMg2Odyhaxi/TeQsqNVgfUEuAIS+thY=
X-Google-Smtp-Source: AMrXdXvFiqyAJmratfrk6jl2DCC+VL1q0v//2bUA491ESuZFAbLH+51Kl7IX+6quUgnykTJEdEoMMQ==
X-Received: by 2002:a05:6402:141:b0:46f:a6ea:202 with SMTP id s1-20020a056402014100b0046fa6ea0202mr39898825edu.37.1674760269081;
        Thu, 26 Jan 2023 11:11:09 -0800 (PST)
Received: from localhost (tor-exit-relay-3.anonymizing-proxy.digitalcourage.de. [185.220.102.249])
        by smtp.gmail.com with ESMTPSA id op27-20020a170906bcfb00b0084cb4d37b8csm985740ejb.141.2023.01.26.11.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 11:11:08 -0800 (PST)
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH net 0/2] xdp_rxq_info_reg fixes for mlx5e
Date:   Thu, 26 Jan 2023 21:10:48 +0200
Message-Id: <20230126191050.220610-1-maxtram95@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two small fixes that add parameters to xdp_rxq_info_reg missed in older
commits.

Maxim Mikityanskiy (2):
  net/mlx5e: XDP, Allow growing tail for XDP multi buffer
  net/mlx5e: xsk: Set napi_id to support busy polling on XSK RQ

 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c     | 11 ++++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

-- 
2.39.1

