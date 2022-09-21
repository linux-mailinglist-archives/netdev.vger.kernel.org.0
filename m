Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D535BFDA5
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiIUMSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIUMSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:18:24 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBCB95AE8;
        Wed, 21 Sep 2022 05:18:23 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id x21so1307331edd.11;
        Wed, 21 Sep 2022 05:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:date:from:message-id:from:to:cc:subject:date;
        bh=X2RSkGTaerMARbSS7PmeBhX+cBl2v+Mh6pmBgaMwj3U=;
        b=nkG0SZPenYdjH0kwG5W6zdUTfMj29lrGIhRRpFgkjCy4DyTd2Bw77rr5aM7SLYAvep
         UCFtEFH0NotsrAvE8fm7W/612Mc3wnWtlGl0b2/nxipjZzmbYf7idCGuX60eDbIpKCyQ
         dKTu/YRfoEJrx3/8oGgi03BTdhVuuhQvXnul0CQxPsj4ymHq/Pon+kpbAnCN3+aBwxdo
         3z9xpqpYHI+ggkjKxr9PxgHx9y+ylnHSun8nttPJ3bpE1dFWfmbNWq/lU9YgBAjh3MHq
         0CcW150Qhs1puYiey75r6owLqmOs+A67/ksI89mjbSuYfBvDuzT191CnW1DNa+lhLTsf
         aj3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=subject:date:from:message-id:x-gm-message-state:from:to:cc:subject
         :date;
        bh=X2RSkGTaerMARbSS7PmeBhX+cBl2v+Mh6pmBgaMwj3U=;
        b=5E9pPFl5VjI1bdnRxLB4Vds9kZqKADkEg+nbsPKmG+GXfiA/IWIKdPVWOGOlOvN8P9
         Z8dTj3DxbmmtGCEfGHWfx1FvEQ4OmZKQ2hHxwpt//2kXSc0LujTWRjrs4eczjOV36ypx
         PRkIoZIa7WLEkoahbrxlCCiVlVyJSp+LTqfxZT1McL6oyUAu/GuIg13vWS8MuphHlzII
         nXHy2nfRP20fnYWS4qoH7WUFpp/laxm81WJfAK0xanmo1Pzsp3lsBm9lhxlKF719PcTx
         hf+rahn/4Q3/glI3rxArPzuhe0+vUHnAi3izpnD+3Mw0ejlIYaNJdS5Y47aQ7RRGtO0d
         qC7Q==
X-Gm-Message-State: ACrzQf1pKtOQgjJOXgGo+CFaEKHazhseT397MpfGRiGOxBfZ9fAaX+tn
        B9iF5nmqdln8PGE+hRHfYGmiqynVr6Fz5rk3HD4=
X-Google-Smtp-Source: AMsMyM6WXWjtGCB/+MMKIwDuQJDJ5qWGOT32wpI7weEUdB9qMrXe/dzlz/Ia5HySw72N/bKIdY9D7w==
X-Received: by 2002:a05:6402:1e8d:b0:454:79a9:201f with SMTP id f13-20020a0564021e8d00b0045479a9201fmr6938244edf.176.1663762701652;
        Wed, 21 Sep 2022 05:18:21 -0700 (PDT)
Received: from alexandru.andrei.tachici (89-24-97-34.customers.tmcz.cz. [89.24.97.34])
        by smtp.gmail.com with ESMTPSA id d9-20020a170906304900b0078128c89439sm1230787ejd.6.2022.09.21.05.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 05:18:21 -0700 (PDT)
Message-ID: <632b010d.170a0220.78d62.3138@mx.google.com>
From:   Alexandru Tachici <alexandru.andrei.tachici@gmail.com>
X-Google-Original-From: Alexandru Tachici <alexandru.tachici@analog.com>
Received: by alexandru.andrei.tachici (sSMTP sendmail emulation); Wed, 21 Sep 2022 15:18:19 +0300
Date:   Wed, 21 Sep 2022 10:16:26 +0300
Subject: [net-next] net: ethernet: adi: Fix invalid parent name length
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        MISSING_HEADERS,MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MII_BUS_ID_SIZE is larger than MAX_PHYS_ITEM_ID_LEN
so we use the former here to set the parent port id.

Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/ethernet/adi/adin1110.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index 4dacb98e7e0a..4f3c372292f3 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -1028,7 +1028,7 @@ static int adin1110_port_get_port_parent_id(struct net_device *dev,
 	struct adin1110_port_priv *port_priv = netdev_priv(dev);
 	struct adin1110_priv *priv = port_priv->priv;
 
-	ppid->id_len = strnlen(priv->mii_bus_name, MII_BUS_ID_SIZE);
+	ppid->id_len = strnlen(priv->mii_bus_name, MAX_PHYS_ITEM_ID_LEN);
 	memcpy(ppid->id, priv->mii_bus_name, ppid->id_len);
 
 	return 0;
-- 
2.34.1

