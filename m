Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF7452AC17
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 21:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352799AbiEQTlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 15:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352797AbiEQTkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 15:40:52 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39B564E7;
        Tue, 17 May 2022 12:40:50 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id n10so36660421ejk.5;
        Tue, 17 May 2022 12:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4MA9rL+NU5i49GzNZ6NnsLkOYe+sC2puAxmvZM/H6Yo=;
        b=YOc9JNDglor1ZP3qT+ECLUFK4kOhKiOt6DJlQkI7VvNUrcMjJP5/4tZTuChoXkjLSc
         oXLFg2dxj9v0fu8+aY6CQ51e5e1TgOlnyHbRGzZe8ap7ETH0ekibPU2VKdlDgJKQSgk2
         dcuc512R9oeKY1Bbj/jQAWevfSCpZDYJA4f9RWbM3097brwkYsxQ50Eyon1e0CtWDIAb
         1CUxjVBe2k22MYq5/7FK9MT5PJPNa/zAzpTx4Zsi3a4RIjTm+GpnsTa2DwBBc0C7cZV+
         s9xFcpNDyrC2SNGVBzQnaVVcaxyE0HXmvmnfnNJo8bXRAo0SjOP/KRO+SEbrh8NI/8pR
         AjiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4MA9rL+NU5i49GzNZ6NnsLkOYe+sC2puAxmvZM/H6Yo=;
        b=0cO24TbXfLBZELgL3benkydVlOsRtsjYJ6HIIpqU0E4aJ98tJZ2yHeoqyRTWlFAw62
         +PkYTldlKPTjG0kKR3NBpwdN4Dau6J4lC94FEz831wzhZkJRZamqF0wuu7M/heFRRbeY
         tvbZjLmJi1chRNTQikccm/2vJDsmgm41Jizucw2gvyUkIZhzwabVkci7Vnnl2ZuiMzlM
         z2KlVA98YBexlJDnb3w4kWGClFAzgYtYC+Sfg/jAJGmnIyVBR/8XhynAN3YYCxNoWjpX
         Sp2JbaVUwjUbiYa+GremKjjywTXQG6N/Svhv6KeqA4/Uz3QSxhZiydVcOPiq5tkHh30p
         LoHQ==
X-Gm-Message-State: AOAM532xEB93SKuuG8J/H/59OVYGALR01cmLTKatjiyrV0q899qXp1Ra
        9tftubx4bMoxHie4DnopOuoNuU3/ufc=
X-Google-Smtp-Source: ABdhPJyJSXY5eQMWRjXP1pKnBQj3y7qNlC+isfx/q9g2gTpHXb7BrFJnGb3MhqjfQDEP62uqzBLjBA==
X-Received: by 2002:a17:906:c14c:b0:6f4:fdf3:4a3a with SMTP id dp12-20020a170906c14c00b006f4fdf34a3amr20905486ejc.525.1652816449252;
        Tue, 17 May 2022 12:40:49 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-118-074-246.95.118.pool.telefonica.de. [95.118.74.246])
        by smtp.googlemail.com with ESMTPSA id 25-20020a17090600d900b006fe0abb00f0sm40669eji.209.2022.05.17.12.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 12:40:48 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH net v1 1/2] net: dsa: lantiq_gswip: Fix start index in gswip_port_fdb()
Date:   Tue, 17 May 2022 21:40:14 +0200
Message-Id: <20220517194015.1081632-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220517194015.1081632-1-martin.blumenstingl@googlemail.com>
References: <20220517194015.1081632-1-martin.blumenstingl@googlemail.com>
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

The first N entries in priv->vlans are reserved for managing ports which
are not part of a bridge. Use priv->hw_info->max_ports to consistently
access per-bridge entries at index 7. Starting at
priv->hw_info->cpu_port (6) is harmless in this case because
priv->vlan[6].bridge is always NULL so the comparison result is always
false (which results in this entry being skipped).

Fixes: 58c59ef9e930c4 ("net: dsa: lantiq: Add Forwarding Database access")
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/dsa/lantiq_gswip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 12c15da55664..0c313db23451 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1360,7 +1360,7 @@ static int gswip_port_fdb(struct dsa_switch *ds, int port,
 	struct net_device *bridge = dsa_port_bridge_dev_get(dsa_to_port(ds, port));
 	struct gswip_priv *priv = ds->priv;
 	struct gswip_pce_table_entry mac_bridge = {0,};
-	unsigned int cpu_port = priv->hw_info->cpu_port;
+	unsigned int max_ports = priv->hw_info->max_ports;
 	int fid = -1;
 	int i;
 	int err;
@@ -1368,7 +1368,7 @@ static int gswip_port_fdb(struct dsa_switch *ds, int port,
 	if (!bridge)
 		return -EINVAL;
 
-	for (i = cpu_port; i < ARRAY_SIZE(priv->vlans); i++) {
+	for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
 		if (priv->vlans[i].bridge == bridge) {
 			fid = priv->vlans[i].fid;
 			break;
-- 
2.36.1

