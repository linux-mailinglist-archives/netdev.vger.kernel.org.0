Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD5E6E9494
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 14:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbjDTMgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 08:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbjDTMgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 08:36:20 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDBA6EB9
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 05:36:12 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f18ece69dbso733205e9.3
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 05:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681994171; x=1684586171;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3hSX2fmCFCihe+R33pGv8iDJF/tV2h7Nkftwg8NDNMs=;
        b=f28imxuzg9/10x8el0IW/Mf7sow5Tnv6+zvXTlk2lgApAZr8oh3RSHi1p91Itxv5Bg
         BvGvsWp2mhX4WtE9HoVrenYQG7rvAPxGRk97BdgNhI6OG3iBgfdRm2BKd9vTheVK7TSZ
         Ceca1j8A/QlXMKECk4jSDrto/5JuRUPl/6OP6b9egqdQ9i0+bY3SDkbkPyTY1WngBAoz
         95B/J8yrwtO/AiXFtficyI3rBztnpMQ9rNm6hC19ypUj+mXDTr5/vP3YgjrAUISpfv0L
         po4i7wtaEUydA1MeP7l2M4TBZwCGEHGIdlyfgi56nwA2MfVyL852ERChJSZwzyZpsVhG
         T05g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681994171; x=1684586171;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3hSX2fmCFCihe+R33pGv8iDJF/tV2h7Nkftwg8NDNMs=;
        b=T7EemPm1MOUzPafO/ALUxJmX5tPrPOqXOQVnhYS/7X1+PBtQ+yTxynmPSOICV1MS2y
         IGOtOHDLvHHKbJfpXlZ3B086nRAaNK0iZClsX4LZ2ZDnwdFzjK/Vi22ehfxFSzwX/SUB
         OtMoNxB/Yi5oc8PpI+bPUSwD1/zswevN8QJ1M5KhL5h9SrE7k7DYBABw3LuK9oErVv3m
         97Lac+qk2KuM1jkSwssH5HrDmmNU5P3hFmihTigHsOnU63HxdCNZVDEaZov58q0/bdK2
         9a+lTsahWW8w2whnxVRC6rctVbLWG4EtXYS1QxlGyXTpPCERnUorBwEWH9EvkBmqgsEc
         ciUA==
X-Gm-Message-State: AAQBX9ee+U3p5GvqQWKat7gMJLodGilVw75yBIVsdoZ+h8pj5u6ri7U5
        S16J7opETD71w0wtTiu+aNloXt9VQOUGkTMA0/yE3HQH
X-Google-Smtp-Source: AKy350YgyKfS3WPDEkeAYMJ3E+mv6XAE8rMtoNO5vpyWD4fGe868gzOgZa6lWSyhh83AAq6ea0+9SA==
X-Received: by 2002:adf:e3c1:0:b0:2cf:ebaa:31a0 with SMTP id k1-20020adfe3c1000000b002cfebaa31a0mr1262406wrm.54.1681994170827;
        Thu, 20 Apr 2023 05:36:10 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id iv18-20020a05600c549200b003f17b91c3adsm5427166wmb.28.2023.04.20.05.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 05:36:10 -0700 (PDT)
Date:   Thu, 20 Apr 2023 15:36:07 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Groza <camelia.groza@nxp.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: dpaa: Fix uninitialized variable in dpaa_stop()
Message-ID: <8c9dc377-8495-495f-a4e5-4d2d0ee12f0c@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value is not initialized on the success path.

Fixes: 901bdff2f529 ("net: fman: Change return type of disable to void")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
Applies to net.

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 9318a2554056..f96196617121 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -299,7 +299,8 @@ static int dpaa_stop(struct net_device *net_dev)
 {
 	struct mac_device *mac_dev;
 	struct dpaa_priv *priv;
-	int i, err, error;
+	int i, error;
+	int err = 0;
 
 	priv = netdev_priv(net_dev);
 	mac_dev = priv->mac_dev;
-- 
2.39.2

