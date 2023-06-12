Return-Path: <netdev+bounces-9980-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E35F72B8BD
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E99942810FD
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 07:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14ACBD2FD;
	Mon, 12 Jun 2023 07:38:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C392F26
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:38:58 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788FA10DA
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 00:38:07 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f81b449357so6713495e9.0
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 00:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686555298; x=1689147298;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dh3m5EnGq8oDqy/skIsgoVVe8sQWqfH3fJBF1zMWlPI=;
        b=Jk+s6RcVLIJCJdjRRcxoGEOhrvDtUR9eKnBOnn2/dPo3eIjpMQSRumE3CbJlSTvDuZ
         Wm5scQ0LDp9WPaU3K5XjGUTlpLjWjqsvS5Upd9ObZFPyWw4TyrlHduz/9i4U2Vu+m3ep
         Mhk+yxbkquIl94TvO34HxFuS85ToC/4PbiGyRyk84LLOgGAvkveEIHz8FCtRa6GuLd8l
         Zlvhm/PYILg9Aih3q0WgUCkc7lyuXtiQwuyWe19GPcXnBFYR7t+Xr+NNMFBQOEXFhvRB
         ujnOwKECEkqnUdzrKj5TISzkQ3av3Y2+jFPY4sNbJbrnx5yzUuYF+vZ34mUKIQiNBb9Q
         fuIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686555298; x=1689147298;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dh3m5EnGq8oDqy/skIsgoVVe8sQWqfH3fJBF1zMWlPI=;
        b=jAVRIyZQwbrHfrqSsu708/ixEGkhdbnoirbcqGNltxI6l0PYI7WqDOUjZVtkELeHRY
         VZ5KQnyGz7MI2rjGksHK/56kb5abYmLYGXxBo8L2MvPlRHFAXX2e0QpyldPUO8wSI5Sh
         K3FK5IQcuwi1Y2pXAZci1hY0x2stP4KPM9l8ajmYZinBslQwOWkETve+7ky9u+PoLns+
         jU6+cA4k7dm+evYDmC0XMrT1UcObtzrWjfehP1GNsjz+3uRoXWJHYEjeyYO/j2T+jZrF
         FZs1Lv6tuVHpe01ZJvQZ2ILzHLFB9F9aPXynzOrmrvHfQJ/uyC3DDZOnVskAjlp/wz68
         bISA==
X-Gm-Message-State: AC+VfDxr/4GDbKBZI9PtuVwNm/I8OLD8lmnDqyV/qKZup7n3Qb6snSph
	g2luUPV9VtrPwh/FuhEsPQtTDXgX+RZnb/WOhOw=
X-Google-Smtp-Source: ACHHUZ5NOulkn52aJFVhJpPQjfRvd4WRSv9OntbZbQl/v5lKtkgZnVS8/sISV9nt3mxXMuAR4iLnTg==
X-Received: by 2002:adf:e551:0:b0:30f:c6f9:dc0f with SMTP id z17-20020adfe551000000b0030fc6f9dc0fmr216207wrm.63.1686554338123;
        Mon, 12 Jun 2023 00:18:58 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id e16-20020adffc50000000b0030fbb834074sm3838418wrs.15.2023.06.12.00.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 00:18:56 -0700 (PDT)
Date: Mon, 12 Jun 2023 10:18:50 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Siddharth Vadapalli <s-vadapalli@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Roger Quadros <rogerq@kernel.org>, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: ethernet: ti: am65-cpsw: Call of_node_put() on
 error path
Message-ID: <e3012f0c-1621-40e6-bf7d-03c276f6e07f@kili.mountain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
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

This code returns directly but it should instead call of_node_put()
to drop some reference counts.

Fixes: dab2b265dd23 ("net: ethernet: ti: am65-cpsw: Add support for SERDES configuration")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 11cbcd9e2c72..bebcfd5e6b57 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2068,7 +2068,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		/* Initialize the Serdes PHY for the port */
 		ret = am65_cpsw_init_serdes_phy(dev, port_np, port);
 		if (ret)
-			return ret;
+			goto of_node_put;
 
 		port->slave.mac_only =
 				of_property_read_bool(port_np, "ti,mac-only");
-- 
2.39.2


