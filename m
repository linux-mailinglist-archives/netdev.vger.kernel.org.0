Return-Path: <netdev+bounces-8327-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79022723B6A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:24:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 082FB2814FC
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4189F28C28;
	Tue,  6 Jun 2023 08:24:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3632C5660
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:24:53 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B516E78
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 01:24:43 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f7378a74faso20714635e9.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 01:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686039882; x=1688631882;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ulda920MoEBfiQNDSTKpW6DY53+RA5BrFUBbmLU+FA0=;
        b=AxDLlKVDNuDGgr1PV6+6IhHrLPrS7727qHradhZ7q9MeKsG8e14HO89q3SbyJGNURh
         h5lnGX1gjGI6TTTe/TPxF4pQTnlYctWL9e1b/6VNFC7TuOu45bOjoF7tl9rDl33R/iDz
         xTonI0+0FMh23vX25QQ7ePcHyTUPsD3q5/e3zi0jcgMC7S9XvL+jHxzZnpj7ldCQHv0Z
         xP4W6f8recthfKJwVvQRjiStaG+OuCO9xg8SEd/sIE6GUL5sT0wvzaXzl7U/Jtrc8HmF
         S5g6jsn9aAWeVwOf4z3vRYowICUzqtwFD7UgDtOM3bZoBgoBrpDWOP/nJkmYS+i+nKbV
         56kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686039882; x=1688631882;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ulda920MoEBfiQNDSTKpW6DY53+RA5BrFUBbmLU+FA0=;
        b=dXg+YuQ4PHlLyPDOBkinePkN7zoT0Z2QzBBGEA3s4fHp0zoPOF97Hw2joW9gPFAgyh
         cmdQ9eyM+hroHsRNfrdhnOG2Mrvx06ak29ZJEFc4YRcxuKVB3amm0sB6MIExzfyfWb2V
         tAUSuEazAXykFF+UVzG1ossEsQO9w05/uubSwLn/573yudoabrD+d6Z0U1wqQRxPMqi7
         6sr5nikRQ2E6x8Xz3A19FccZ7TFmZK3WHl1527reroQEKjQYKIgO77cuox8clW5RGAnW
         t12BV+SZ+eHa2e+JwrSrTSkfFd9UGYJVHBg+59YiYfxz/WJ9weCyr4T7kn/cfZpt8Yei
         suTw==
X-Gm-Message-State: AC+VfDz/+t+WJU0aRnEsU1G9Mwg6kgxG90HOGpA8CrVg0ZkXGSuSsKiR
	mlW2DUPowhPJGtYkAlTrf1/mJw==
X-Google-Smtp-Source: ACHHUZ52toXt1UWuUbI3LD+6T1MtXylmTGTlpvsFH4LmxGIWTLg1+uJ+sOsiCv1/osqHD0mDTgxh7Q==
X-Received: by 2002:a7b:c7d4:0:b0:3f6:3497:aaaf with SMTP id z20-20020a7bc7d4000000b003f63497aaafmr1315611wmk.9.1686039882546;
        Tue, 06 Jun 2023 01:24:42 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id b11-20020a05600010cb00b0030ae973c2e7sm11962020wrx.83.2023.06.06.01.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 01:24:41 -0700 (PDT)
Date: Tue, 6 Jun 2023 11:24:37 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Claudiu Manoil <claudiu.manoil@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: dsa: ocelot: unlock on error in
 vsc9959_qos_port_tas_set()
Message-ID: <ZH7tRX2weHlhV4hm@moroto>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This error path needs call mutex_unlock(&ocelot->tas_lock) before
returning.

Fixes: 2d800bc500fb ("net/sched: taprio: replace tc_taprio_qopt_offload :: enable with a "cmd" enum")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 5de6a27052fc..903532ea9fa4 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1424,7 +1424,8 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 		mutex_unlock(&ocelot->tas_lock);
 		return 0;
 	} else if (taprio->cmd != TAPRIO_CMD_REPLACE) {
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto err_unlock;
 	}
 
 	ret = ocelot_port_mqprio(ocelot, port, &taprio->mqprio);
-- 
2.39.2


