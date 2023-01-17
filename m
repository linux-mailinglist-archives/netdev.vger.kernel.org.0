Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33A666D9E1
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236419AbjAQJ2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236601AbjAQJ1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:27:36 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558591E1ED;
        Tue, 17 Jan 2023 01:26:02 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o17-20020a05600c511100b003db021ef437so2549514wms.4;
        Tue, 17 Jan 2023 01:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lf+DfBr7EiMoGbNIDvvLlIXu7J9dT9iJQIWXw6brQfg=;
        b=bPFSAcWHTn+xs92Sh1lDRG6xAyGayL0MRYw5UGd3RHdEYEUk6obwfMQS3RClnrNJl4
         4fPcGGnbEB3ja/5aFsxgltIARJxHiDS8H7uUPCmCFb1BU+fT9mxP64ySh94tnRi62hh1
         hrYRwaQ5fRMgvRG0GFlhV4Dhj8zZCEuYhsMywAbdql8pBY2FeiV+BbMsLjnz2v28ZJ8t
         Xz4NIy1qjBeBwXrwPVPQWRuQ80yRC9Zo+gCv77X1bOnJXeEP369HzzLztlzlfmmP/VVq
         axrRKf4H2YbTPgOdaVZx8pQHNYcADg/iaKQ5hv1YbVlcBj/hWBr880eqYGvXIvLd/87n
         SPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lf+DfBr7EiMoGbNIDvvLlIXu7J9dT9iJQIWXw6brQfg=;
        b=vFgI1IO2cAQKYA/AFaTxjftXpW4IR0lsIXHgmWmvh0TaQLBM09+/Oghmd1DaFcZUcC
         bSBzwfGZ9W9XK/L9iUksWOu5ct3yFLIzSUo0ZIvlWONJUran8oRcDHAeIQlimLHK5eQo
         p+pOnyn75E/qC6vRcyvfhLMEhHV1MMwLQXgTQlOfqMGg1qw+m4UWSuf8szAiBlBSj3ac
         k91cQY/krqlHAJ7WMB3VtAJOR7Ltr/ktgcfPqcM0VdhSdbykj5NP8yladQ9DHZyfEUeD
         NlqFYeIv15er1/EAfqqbiwurgsq1bHd2F7ei1Z6bYkTREnTvS4SRbNpj/M7j36Dm4EUG
         VbiA==
X-Gm-Message-State: AFqh2kp+ZULxUcbBXPH8NPvGxq/nHZH1ZhMJVsA06Y4XEdMEWiD17jJW
        X4Qhk2MvPzDPdS3g3FEka/w=
X-Google-Smtp-Source: AMrXdXsbGElYmFMwcKgfKSb/g0qJNV9oeYIXA1MZkaJB57yzw2vwFUS0+0EMZAZLWd9y+SElwx5NGw==
X-Received: by 2002:a1c:cc17:0:b0:3d9:fb8a:b2c5 with SMTP id h23-20020a1ccc17000000b003d9fb8ab2c5mr2364821wmb.16.1673947560649;
        Tue, 17 Jan 2023 01:26:00 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id u21-20020a7bc055000000b003d9aa76dc6asm48008881wmc.0.2023.01.17.01.25.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Jan 2023 01:25:59 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, toke@redhat.com, pabeni@redhat.com,
        davem@davemloft.net, aelior@marvell.com, manishc@marvell.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        mst@redhat.com, jasowang@redhat.com, ioana.ciornei@nxp.com,
        madalin.bucur@nxp.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH net 2/5] lan966x: execute xdp_do_flush() before napi_complete_done()
Date:   Tue, 17 Jan 2023 10:25:30 +0100
Message-Id: <20230117092533.5804-3-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117092533.5804-1-magnus.karlsson@gmail.com>
References: <20230117092533.5804-1-magnus.karlsson@gmail.com>
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

From: Magnus Karlsson <magnus.karlsson@intel.com>

Make sure that xdp_do_flush() is always executed before
napi_complete_done(). This is important for two reasons. First, a
redirect to an XSKMAP assumes that a call to xdp_do_redirect() from
napi context X on CPU Y will be follwed by a xdp_do_flush() from the
same napi context and CPU. This is not guaranteed if the
napi_complete_done() is executed before xdp_do_flush(), as it tells
the napi logic that it is fine to schedule napi context X on another
CPU. Details from a production system triggering this bug using the
veth driver can be found following the first link below.

The second reason is that the XDP_REDIRECT logic in itself relies on
being inside a single NAPI instance through to the xdp_do_flush() call
for RCU protection of all in-kernel data structures. Details can be
found in the second link below.

Fixes: a825b611c7c1 ("net: lan966x: Add support for XDP_REDIRECT")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
Link: https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/
---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 5314c064ceae..55b484b10562 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -608,12 +608,12 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
 		lan966x_fdma_rx_reload(rx);
 	}
 
-	if (counter < weight && napi_complete_done(napi, counter))
-		lan_wr(0xff, lan966x, FDMA_INTR_DB_ENA);
-
 	if (redirect)
 		xdp_do_flush();
 
+	if (counter < weight && napi_complete_done(napi, counter))
+		lan_wr(0xff, lan966x, FDMA_INTR_DB_ENA);
+
 	return counter;
 }
 
-- 
2.34.1

