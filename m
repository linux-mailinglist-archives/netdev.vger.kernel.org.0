Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E8651420C
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 07:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238246AbiD2Fzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 01:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345638AbiD2Fzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 01:55:51 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA96B82E3;
        Thu, 28 Apr 2022 22:52:34 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id e15so5051973qtp.3;
        Thu, 28 Apr 2022 22:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JC3gAOVtyar8r7B0FmZVo83iTqm/cSJvOukGohskpvA=;
        b=U/o7Rv143/JYGZsKVzORlbo0+H8wYncpzuJm5ymKEumCeLt+hgRiKslnafGDiY3WBr
         AnFFd6ReEXHIBAOkcy5pGWDqkPETXnWEJh/QgvnxCq0cZrpaoUJk0lPonZEdIPXmi10r
         s3VWoj1paDDjdbDeCqtrPm/ZRXHWH4rMB8fjiqWYcWrd+cy8DpkxQrw0CXSZL079rphp
         PbEU1OnvssS2T1tzcTymOi0VtBC+ORs7SumL3STW4ZK2gK5QNL7wnqpkX5aymwz/Mxhn
         3XvqKehysLn/RJ5lGD5DIMzKhzjFsAB3U2QG17Me+Q94H1l6nnIhUy97hhGONWDqOdWY
         vhgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JC3gAOVtyar8r7B0FmZVo83iTqm/cSJvOukGohskpvA=;
        b=rUb2vbpvl4a73yYhCmuQgr0BkdMqxP1Cqtq993iaa4mIZ1KjEp0xgNYcO4AefVZzhl
         zug+pci7cfgg3JlZ7LtTGY2cvMtuosZBcDRZ5YV8eD2RtZaPgAK464/B3ZQrOJW9L9En
         N42HJactgTy3JkZbAPpY8jlrXYitbCIu8kEGbOaXPvSxhh9i6bMW3wq93GBgF0A6zanA
         egtFz0GhCcvCAs7AK9sz3G2YUWwk41TyabOOWThwn0DMn7UEOYKra8sKRWakIgzUdQ3I
         tflbQYvxlQR3PDO58P59oNiTvVCRR88NqUI+bIiyYNh3Gm4VzxKTiygQ98dtF5FWzl4H
         7eng==
X-Gm-Message-State: AOAM532LxxvU4CNki/KuHi9gVm5R3HVCAcTChD6TBrgyKxxqgOJ7LXWS
        94K+oibclwVRBh+vHkUsYs0=
X-Google-Smtp-Source: ABdhPJyd5PWeuodON1ywIUeRQKF+Xle1mrQagnHngi0wx7pJot/YY/V/lakNDqOnbRrqqfE17neAZQ==
X-Received: by 2002:a05:622a:413:b0:2f3:7c4e:4303 with SMTP id n19-20020a05622a041300b002f37c4e4303mr11877167qtx.57.1651211553800;
        Thu, 28 Apr 2022 22:52:33 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id j1-20020a37a001000000b0069f9e4bd8b9sm985532qke.17.2022.04.28.22.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 22:52:33 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: dsa: sja1105: simplify the return expression of sja1105_cls_flower_stats()
Date:   Fri, 29 Apr 2022 05:52:26 +0000
Message-Id: <20220429055226.3852334-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Simplify the return expression.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/net/dsa/sja1105/sja1105_flower.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index fad5afe3819c..16c93159e475 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -501,7 +501,6 @@ int sja1105_cls_flower_stats(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_rule *rule = sja1105_rule_find(priv, cls->cookie);
-	int rc;
 
 	if (!rule)
 		return 0;
@@ -509,12 +508,8 @@ int sja1105_cls_flower_stats(struct dsa_switch *ds, int port,
 	if (rule->type != SJA1105_RULE_VL)
 		return 0;
 
-	rc = sja1105_vl_stats(priv, port, rule, &cls->stats,
+	return sja1105_vl_stats(priv, port, rule, &cls->stats,
 			      cls->common.extack);
-	if (rc)
-		return rc;
-
-	return 0;
 }
 
 void sja1105_flower_setup(struct dsa_switch *ds)
-- 
2.25.1


