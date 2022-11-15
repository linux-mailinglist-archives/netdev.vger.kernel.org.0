Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0616299CA
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 14:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiKONOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 08:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbiKONOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 08:14:30 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBE8C65;
        Tue, 15 Nov 2022 05:14:25 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id bs21so24197789wrb.4;
        Tue, 15 Nov 2022 05:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VjbZZt6k/m4st8VDM4ovyYHidxFXvNCvhopAFLorMH8=;
        b=CiZ/oLB3x+YXdUKTWEK6QZV+TY50Mx/MqIOI/6e+iK6+RJCxTOQbNRAQaaawOefdQi
         +AI9oj94DXc5B5QQjxPsD497IzJha73+BfiB6LMBUVE5G0/Nk9tcmBQDSMqLMLzLs339
         T+eTot5hoJspBRJRM7jUxIMk5DU2uq13E2+Gyjq1PntfrtFddmwhpeWwcvuZBB1Crrvp
         WFGTxkfRWWERnmQCXF0Xs4dNTbORVspn5b/CRltIUwR7GiZEayhLzaDwJG+ZGp1oiTIp
         mVcWpyf7vXItMi/HZTvmuF+GIAEL5Yc0wEvBwPCJ5e7bCBtsR8txNd9I6/hXjzk+pAUL
         Aarg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VjbZZt6k/m4st8VDM4ovyYHidxFXvNCvhopAFLorMH8=;
        b=WnQHUfk7lStyKPS0O4/JMxZl+bkl8k4rP5uoOzd9nz2rV7BkDc50EydNDvTXoCXq65
         qqYx6DPN+r3Fedu40xtCAK7Cg55jfRCrXRG/v7Lp3x6F29bCuCq+ixIwy0jW4npDiFmM
         LKkVSnL85eB8awAemcuP2tYvm3eNIMbNKuma4i+mQfV03dnBoxHIemKT7pvwbAnXKdnn
         8E4gpzV04AUDcpz98ApPqVxgfcH0/JD2c7Wu7ZdC9O0qXgXM17b2rzczjoYoY1xSRjm8
         Y7lQUQ2MqeI2ZwKXuwEAhd8vesyh+XtgY4kYnIrObUWaD21bnwPzxKT3rf3kKFTl92CX
         g4AA==
X-Gm-Message-State: ANoB5pkDhBbgFVUIX9R+cctcmdngkIw3R4FZCIMJoCYVSqYBMH0JxK8S
        Y5fMrSdS2UNLuk2o2Gs8IelJBC9wgcaJcw==
X-Google-Smtp-Source: AA0mqf4VZQsNOGnRNu69rOYF/qrC2Pd2yRDwJ6W5ZVsFjOt9PbtiQpEjwK47YwpwvjuK6KmxA/Cerg==
X-Received: by 2002:a5d:68d1:0:b0:22e:37ba:41c7 with SMTP id p17-20020a5d68d1000000b0022e37ba41c7mr10756844wrw.173.1668518064114;
        Tue, 15 Nov 2022 05:14:24 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id p1-20020a1c5441000000b003b4868eb71bsm20548106wmi.25.2022.11.15.05.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 05:14:23 -0800 (PST)
From:   Dan Carpenter <error27@gmail.com>
X-Google-Original-From: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Tue, 15 Nov 2022 16:14:20 +0300
To:     "David S. Miller" <davem@davemloft.net>,
        Daniel Machon <daniel.machon@microchip.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: microchip: sparx5: prevent uninitialized
 variable
Message-ID: <Y3OQrGoFqvX2GkbJ@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch complains that:

    drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c:112
    sparx5_dcb_apptrust_validate() error: uninitialized symbol 'match'.

This would only happen if the:

	if (sparx5_dcb_apptrust_policies[i].nselectors != nselectors)

condition is always true (they are not equal).  The "nselectors"
variable comes from dcbnl_ieee_set() and it is a number between 0-256.
This seems like a probably a real bug.

Fixes: 23f8382cd95d ("net: microchip: sparx5: add support for apptrust")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
index 8108f3767767..74abb946b2a3 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
@@ -90,7 +90,7 @@ static int sparx5_dcb_app_validate(struct net_device *dev,
 static int sparx5_dcb_apptrust_validate(struct net_device *dev, u8 *selectors,
 					int nselectors, int *err)
 {
-	bool match;
+	bool match = false;
 	int i, ii;
 
 	for (i = 0; i < ARRAY_SIZE(sparx5_dcb_apptrust_policies); i++) {
-- 
2.35.1

