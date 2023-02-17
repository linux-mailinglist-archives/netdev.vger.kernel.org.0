Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE3E69AE2C
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 15:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjBQOh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 09:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBQOh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 09:37:57 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2212597F;
        Fri, 17 Feb 2023 06:37:56 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id r25so2274850wrr.5;
        Fri, 17 Feb 2023 06:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zMMpGaN6QWbzTRcPVdro8tbh9ePBSBaMYiMkSVlh21Q=;
        b=qC3104Tpmdugz9ncIXE3hsiAjDnTCuJp7X9wZS08TOzS204WC2GFyXw5xlDy/nh2tt
         6CyljXuFnqOhYsDZk8Bzw0MreMzJDMWAfG1AowmQ8yZPb/5BsyT639CRuiPgxbSzM3Ep
         FeG8i2qBigdV49bK5bnIHsNCDsBexV8ghmxXvuSmHx4QyAUuQY99g1DaMLv9X2BfBo4T
         GEoWWTpDkxBBzXqgHSSTQy72W5Xu0wXX7iE2c+ZChaFBeqsyNH9JJolzHr8CAVre/gfL
         sm4DwnWlUyroVSEyN1aovpvAjy6duAMw6HUIPAN33W9BjW4AT48T+SoR28Cys2f/IS/q
         VA+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zMMpGaN6QWbzTRcPVdro8tbh9ePBSBaMYiMkSVlh21Q=;
        b=oX+reJzpPQk38HzaZBzC6XwDjqKYjg3Vxf99TKAAjRx1DY0LlcBYISwUfUBDbLCqPu
         OkjQruiwjoVWY357CdGj7XGN8FvdcBGkgOkcVrlVN6Vq8UWZiVys9baslP4esiYf88Zs
         z+Ks0SNugoJ16Cb27fXQby3GVQCSE0pIXgddYDm0Yh9iSaw5bv+ZqtUNlXv3h3qs1QBM
         jyv7LoEUkc+t1FP/yNvjzxPxMe9eIOSMPDwZ+6eosUki9a2WllDwwatXqiuHG4em64H3
         aYgvCX1da6/gyUW0P9rUmD3APX/Awmepl0bYOOSOVhh1+toUL378+QItaunFEqvOx+NU
         m+VQ==
X-Gm-Message-State: AO0yUKV6WKqKKya3Vanxxd8Xj/0TfMxSJO+1BAclT3sacQ1rY+ZBlEMB
        MXDek+Eu1XbCubaDsajmgR4oeQ7vTAMT6g==
X-Google-Smtp-Source: AK7set/cQGo7srW5T+ROyvIgkOS5WNVaqexfIqUUjy9Jjto0CW/ilZ3xJvsN/MnXJSRifmm9OpEIZw==
X-Received: by 2002:adf:e452:0:b0:2c5:594a:a4f0 with SMTP id t18-20020adfe452000000b002c5594aa4f0mr7876214wrm.58.1676644674506;
        Fri, 17 Feb 2023 06:37:54 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id b7-20020a5d5507000000b002c550eb062fsm4483507wrv.14.2023.02.17.06.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 06:37:54 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH][next][V2] sfc: Fix spelling mistake "creationg" -> "creation"
Date:   Fri, 17 Feb 2023 14:37:53 +0000
Message-Id: <20230217143753.599629-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

There is a spelling mistake in a pci_warn message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by:  Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
V2: Fix subject to match the actual spelling mistake fix
---
 drivers/net/ethernet/sfc/efx_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index d2eb6712ba35..52fe2b2658f3 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -655,7 +655,7 @@ static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
 				 "devlink port creation for PF failed.\n");
 		else
 			pci_warn(efx->pci_dev,
-				 "devlink_port creationg for VF %u failed.\n",
+				 "devlink_port creation for VF %u failed.\n",
 				 idx);
 		return NULL;
 	}
-- 
2.30.2

