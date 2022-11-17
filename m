Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D8062DFD5
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 16:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbiKQP3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 10:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiKQP3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 10:29:11 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1846387;
        Thu, 17 Nov 2022 07:29:10 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id ay14-20020a05600c1e0e00b003cf6ab34b61so5396054wmb.2;
        Thu, 17 Nov 2022 07:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EjPZaOMtuKe23SeFdm/TIAsT7WjJxj/M2GE2J82l5uw=;
        b=M2TT7J4/rElf9VClVN1UnYpTUp7NYEAcuaGolqpBImFCuGmSkpgH3yfM4qKQdlkulr
         spl0SnYmG+EJ5CIkewNt/u5FUGrbLJ9oe4qFa30EAiuYHv7aSv2xOZ2G/SVYGtOgnGrl
         Ha3z/ryCrhay9yPncBtubhzrqNbRKRfSzbgc/G4NHM5w4jxG+3fKCCn5K7BxuS+noIJz
         XDPPkE1TIiAZ8T4nL7i6Tw/l+KA9oF7TkFCdHLdUX2dwaSqNHEmTi2SLVd8Ely/GFkY9
         XNr91qQcoU07rJ/zQIe+eBvYZUuirv0PefY1BGW29y8/OwqocqBMzdwEWnM47tFsV/sa
         stZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EjPZaOMtuKe23SeFdm/TIAsT7WjJxj/M2GE2J82l5uw=;
        b=pRVctBx3XoZjefLYt/8/OJqKl8vhkyK5Wyd9x5qJeS2h4O8zekpsz9VCnKGhrR9AOK
         HtZ4T9MqIs5JS4IY4D/9ZBUcuBis2JVWXPc8s8Fx2+7ZPXxBB84yqZxvrysWV3V34Cph
         jyQF1iT+UI4lzfEUCRoAm/1XiuRJFv95fY89goIvHskjYC60CttTZxDPppMZZTPhGK4g
         QRaGmVG6yX1YJAaPNtH0mDZaHv7JdNtQDPTZAiCG8JBYdiBX0cLNjoij+XbFl8QgTWub
         DYrxJFoQgkArBGlqUsKParf4qUOm5gFg7gVCSO+p0dWzDOCjXfztXmCeiC2rrl6pvR3F
         Z6zQ==
X-Gm-Message-State: ANoB5pk6ygLFPArmHczU12Mt48iZGQIrOxBSaIVnNVK+ZnhXEoGeAmN5
        rvsEpp3WN/35DaT/Z0/rgdI=
X-Google-Smtp-Source: AA0mqf6bdjhfZSrbrUzGxBYT42mxIKzDvWBu+XwAYRK29x6hKNEIISHUmLiPXaLeh2zQUz3qUzTkQQ==
X-Received: by 2002:a05:600c:4e12:b0:3cf:d4f7:e70d with SMTP id b18-20020a05600c4e1200b003cfd4f7e70dmr2074095wmq.187.1668698949330;
        Thu, 17 Nov 2022 07:29:09 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id i3-20020a1c5403000000b003cfc02ab8basm6282357wmb.33.2022.11.17.07.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 07:29:08 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:29:05 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Daniel Machon <daniel.machon@microchip.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next v2] net: microchip: sparx5: prevent uninitialized
 variable
Message-ID: <Y3ZTQZYz5zz5nMg2@kadam>
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
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
---
v2: Update my email address.  Also add Daniel's R-b tag.

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
