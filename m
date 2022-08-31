Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076765A82EA
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 18:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbiHaQTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 12:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiHaQTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 12:19:14 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B809DD2E8E;
        Wed, 31 Aug 2022 09:19:13 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id jm11so14565029plb.13;
        Wed, 31 Aug 2022 09:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=IDuruBXPZyRpW8WGVSo/zI+lfAagsc1gmhwpLs9zMR0=;
        b=BJf4BqZJJFq55/bNNWWPEeMFVJDFfFmCBzIF8E8kgum69JveHcigjWKL32B9dsqd1O
         0PXEILqNTo8DWARlVnU5Y9LAgDY3VYInXJ8ac1crJODNlzblwKQK6ZFuBTZ6DGtRyhXZ
         naOTIH8St/UUzaWcBD1R0PoRjhHPaQTuMs/7RubPsNJal1ihgDJUyWYJeA/qZONv/yeH
         i7s60bqRzz5lAJ+HR+sZp9aDUJA6hTrsmTxF6gBKARtq7deP+5xYwb+lml3BhcyJJkbA
         mthYBJq8Vl0cG40jQYt3D39BzRPlaCxWwXZC7KblkuYOS6o8Wt+yEAamUM1Gw+e3JFbs
         WVKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=IDuruBXPZyRpW8WGVSo/zI+lfAagsc1gmhwpLs9zMR0=;
        b=Tj9O5JbBWBrchiG/ptFKzpiFYjdAnAqgpER1OfRnWx/HXRfWO/+ycDqKpsQm0kJA+V
         jV4ezqiwb3qWTvRNpRYfiSp2/NdggTD4UbNFBt/xCPUM7lwSLG5vvVBdJ2z0p0QyGpeG
         gNB9rkgpu7AUdUgWbSy/67/OjAGg9nh946N1DvvZdXO3dMNWNYqHITf9J4QrO1du2e4+
         PiLzf6Sth//rbXY8nBP1pxaM1vjOtlWBODWdHxWgdsAiQbjchLGE84KD9aH7tf9R4wQX
         mIyqIY35usG/7tXP/vn9+ZimtTFWmiw0aowwbjU2V9OmDJKjemExd+1+OjShQOcm98Oj
         dRDA==
X-Gm-Message-State: ACgBeo1E7zlAaHGBEtxhSJjNgOhZRtFiv5iizTxoeXkU7ZhZxSl0dEzL
        gs1XOYYF6Ix3ouy1jCDn2Tk=
X-Google-Smtp-Source: AA6agR4PdcHOIiPhNW3UlboI8HviUh7nmNM1UGp4buynYZ56FU/Vv1XUJ6F+pboYdadfPc+WBQT7EQ==
X-Received: by 2002:a17:90a:b007:b0:1f1:d31e:4914 with SMTP id x7-20020a17090ab00700b001f1d31e4914mr4120537pjq.36.1661962753308;
        Wed, 31 Aug 2022 09:19:13 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id z15-20020aa7958f000000b00536aa488062sm7418869pfj.163.2022.08.31.09.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 09:19:12 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: cui.jinpeng2@zte.com.cn
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com
Cc:     kuba@kernel.org, pabeni@redhat.com, mailhol.vincent@wanadoo.fr,
        stefan.maetje@esd.eu, socketcan@hartkopp.net,
        biju.das.jz@bp.renesas.com, cui.jinpeng2@zte.com.cn,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] can: sja1000: remove redundant variable ret
Date:   Wed, 31 Aug 2022 16:18:35 +0000
Message-Id: <20220831161835.306079-1-cui.jinpeng2@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

Return value directly from register_candev() instead of
getting value from redundant variable ret.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
---
 drivers/net/can/sja1000/sja1000.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 98dfd5f295a7..1bb1129b0450 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -661,8 +661,6 @@ static const struct ethtool_ops sja1000_ethtool_ops = {
 
 int register_sja1000dev(struct net_device *dev)
 {
-	int ret;
-
 	if (!sja1000_probe_chip(dev))
 		return -ENODEV;
 
@@ -673,9 +671,7 @@ int register_sja1000dev(struct net_device *dev)
 	set_reset_mode(dev);
 	chipset_init(dev);
 
-	ret =  register_candev(dev);
-
-	return ret;
+	return register_candev(dev);
 }
 EXPORT_SYMBOL_GPL(register_sja1000dev);
 
-- 
2.25.1

