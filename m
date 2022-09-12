Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362425B555E
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 09:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiILHaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 03:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiILHaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 03:30:01 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD0B1F628;
        Mon, 12 Sep 2022 00:29:55 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so7343140pjl.0;
        Mon, 12 Sep 2022 00:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=i/w8c1xKOSAuyskQENWzqnLbDpJZE0osAWdxMG+atXc=;
        b=cLdMSuZ+xU07/FuUG+TZWlhV0PjtGyybA2RgIplZBM+YOxgiG08luMFr5eNk1gxmfx
         olHbS2Ia2dPMuI7DhL8l0X/nb+0H5SISrrTfLHcamqzpq2JMj9czsR03vC/xM33xY+qn
         SaYfr7wkbhee2zfXD+8dMVuDOJIdTw8YBVPK4GAWVxaEjJdj7C5ItpheZIVodKZYir5Y
         W8SL3iflj4vss+WZ1oF7l7hpz881bU8R9UAWFQykEU44K9DdTWI2VsWcTa/hlxGKy+Ny
         hKjC287NffM6zv52FYvkqp5zEN27JqIPgWAKx8aB4chlyPI0nPDB6IWrVjY4fNtEh07/
         mghA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=i/w8c1xKOSAuyskQENWzqnLbDpJZE0osAWdxMG+atXc=;
        b=QkzHThq0583/q5U2y/T684U3afJxtLLiny6K3k8bRctjFYE9b1f7yZkzqpGY5BJd/L
         T6gXL8cu+m7e1slhO2DbGj3VL4Y7Cq7lwkEXEFZVwo0joBdc1hdP1JSS2hDXtPBX3YQe
         CJrgQsuDlKVpiSbRLegExo+IeiVbE8HHRRrEzOb+yb8RT+XptvhenkvvNcI0lMn2IM82
         qQm+usCPO2HhyWS/3BwL0XYnfW6NaZHrQQ6MRD5ZyqXd11YScCWGSOwSIiEW9YWqoaxs
         t8YxxtBIetpLrKLK8gO3E/glm+aJR9tk6KdudXdmd1kL9Lg0iyLxChK46DPcxZqGfgvu
         /kdw==
X-Gm-Message-State: ACgBeo1Qi01tpQbij73QNSIEzIZdowzrtcl+yjV0TnZNQlhA7wPKi5fc
        KVAdFNqKKbwnwnWsgiDKQM4=
X-Google-Smtp-Source: AA6agR5Qd9DnjJ0MQsl9Pf8Dhd+zFzfIBNUnVK8cBkhC46UodN0IRp7e6f2kwH6xNdkdxfBmKq5Pzw==
X-Received: by 2002:a17:903:32d1:b0:178:1cf0:5081 with SMTP id i17-20020a17090332d100b001781cf05081mr10260678plr.54.1662967795077;
        Mon, 12 Sep 2022 00:29:55 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id cp19-20020a170902e79300b0016ef87334aesm5143642plb.162.2022.09.12.00.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 00:29:53 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.panda@zte.com.cn
To:     idosch@nvidia.com
Cc:     petrm@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xu Panda <xu.panda@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] mlxsw: core: remove the unneeded result variable
Date:   Mon, 12 Sep 2022 07:29:34 +0000
Message-Id: <20220912072933.16994-1-xu.panda@zte.com.cn>
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

From: Xu Panda <xu.panda@zte.com.cn>

Return the value mlxsw_core_bus_device_register() directly instead of
storing it in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index e2a985ec2c76..8daedf6c4496 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1513,15 +1513,13 @@ mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_re
                                        struct netlink_ext_ack *extack)
 {
        struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
-       int err;

        *actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
                             BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE);
-       err = mlxsw_core_bus_device_register(mlxsw_core->bus_info,
-                                            mlxsw_core->bus,
-                                            mlxsw_core->bus_priv, true,
-                                            devlink, extack);
-       return err;
+       return mlxsw_core_bus_device_register(mlxsw_core->bus_info,
+                                             mlxsw_core->bus,
+                                             mlxsw_core->bus_priv, true,
+                                             devlink, extack);
 }

 static int mlxsw_devlink_flash_update(struct devlink *devlink,
-- 
2.15.2

