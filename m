Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25E069A811
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 10:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjBQJZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 04:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjBQJZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 04:25:35 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88D05CF27;
        Fri, 17 Feb 2023 01:25:31 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id ja15-20020a05600c556f00b003dc52fed235so371000wmb.1;
        Fri, 17 Feb 2023 01:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hfv8pNhpvIlz1d8dy78P9h3OnVq3+w0YDz5WQ/jittM=;
        b=N/oI/0KPkC3GxCjn2AkIqalsLak2mEXfpblyZvKT4kxeTGnFMm+6zqrlxpHXUPloU9
         5OqE7drkWQIQtCzhVybaC9mcxsItKme0R3A9AbUmyKMx/sXWryOH3e1TJ5cBU3UUwXYl
         5+SQjS6LTGhuLd4rMKCKQarrnwMEJPcbq3HjNdz9b7RQV9M8kew7VBCLm6mjDPTa5yQm
         SXf4TAWKJCJYgu7dQIL4CleEkXwB9dCWiNJKkF50x4PKTw+Pl7HZplhsg786WsZHVxVR
         tP1c/+NQGJe/rNA5sdsHfHqX72MTbm17X6hanUwjMa5/dOAny6yP3PoUaXsyBr/2oYwh
         IpCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hfv8pNhpvIlz1d8dy78P9h3OnVq3+w0YDz5WQ/jittM=;
        b=VHxSByX7NKAE3lIfbjQ9/Y0Xcl4cWp1fExX8PZqJkLb4sRul5QGOy9OW6viWXBnQPY
         4bmgO4lJZ6QgEtk2ApXluTG83VtAh2nUVtEhQbjkYBmCr9KENzEOVxM6e0zPpKVHp/RB
         XEEjksyfUYlXmGSZ/UR65iAAGl99tUyW+vCU9yxvXAOQ7XJ8EdI8hp92/cwaAO8hRIQD
         rjsMoMo6NiDv87O0huam5zeGg1HOvtkRcjVNKecTtj+Qc6r/WZP/GZTF6ZcW5it+uEyn
         x7IrQBR/OIf5jyDALjZPu9usOlNp1LC0BAG1iuLhSU0JKsPtA4f2UB66Gqw2PsZqTwYf
         7NoA==
X-Gm-Message-State: AO0yUKXT0mvJglQXoUadR74omfD2A0ijQ3sbE8ri8L6SITaVhtqo3X19
        mWTCUWioIbSJYPpJJ4QW11M=
X-Google-Smtp-Source: AK7set94K+QQT8K9J8A/GCN8UvOIJoCENp1z+zznF12KfNTRFstmaghcuQG8r0oHTzi4E8T1BPM3Kg==
X-Received: by 2002:a05:600c:1688:b0:3e2:2304:c7b3 with SMTP id k8-20020a05600c168800b003e22304c7b3mr1102918wmn.34.1676625930177;
        Fri, 17 Feb 2023 01:25:30 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id n2-20020a05600c3b8200b003e22508a343sm1152098wms.12.2023.02.17.01.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 01:25:29 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] sfc: Fix spelling mistake "creationg" -> "creating"
Date:   Fri, 17 Feb 2023 09:25:28 +0000
Message-Id: <20230217092528.576105-1-colin.i.king@gmail.com>
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

