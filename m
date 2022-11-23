Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0012C634F40
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235676AbiKWEz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbiKWEzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:55:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A76E0685
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:55:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92638B81EA1
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAB5C43146;
        Wed, 23 Nov 2022 04:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179313;
        bh=iVpNL4ZdQVbg5k5TiocvWucQSS530ONdakGLBRKiBjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUNkH5T0P+khq2//ukHqYJtumADiurRTg2bdBuIrevhBISEHGIJFuAbGjcWKeEpIK
         vEwR2+ai+jRlz1uuIbwQeT9wtnP6/jDwWEtz8KYHm5wZdZXg+1VSdDZHF963hae31C
         8TPe3Eo2ZGLWcYs6ONu7J1ag1YIBqtEgVk4SToWwjiNMie5QzCCq4m+yOnqh3L+1Vy
         4bzcCL8UOZo/ecvuC3od4RqyaUHQ1EEQqKlzr2RID4SK8gI0jthzfkq6TKMSr/GNf/
         UC8kyDie3A7Oa8BhcCF3PIB3SqPOnFi3XyhtYIAiLyC+QfvLqC9IzN8miYIGOiGaMX
         QUmhiR0h9Df9A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 04/12] net/mlxsw: Convert to i2c's .probe_new()
Date:   Tue, 22 Nov 2022 20:54:59 -0800
Message-Id: <20221123045507.2091409-5-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123045507.2091409-1-kuba@kernel.org>
References: <20221123045507.2091409-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

.probe_new() doesn't get the i2c_device_id * parameter, so determine
that explicitly in the probe function.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/i2c.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/i2c.c b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
index f5f5f8dc3d19..2c586c2308ae 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/i2c.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
@@ -632,9 +632,9 @@ static const struct mlxsw_bus mlxsw_i2c_bus = {
 	.cmd_exec		= mlxsw_i2c_cmd_exec,
 };
 
-static int mlxsw_i2c_probe(struct i2c_client *client,
-			   const struct i2c_device_id *id)
+static int mlxsw_i2c_probe(struct i2c_client *client)
 {
+	const struct i2c_device_id *id = i2c_client_get_device_id(client);
 	const struct i2c_adapter_quirks *quirks = client->adapter->quirks;
 	struct mlxsw_i2c *mlxsw_i2c;
 	u8 status;
@@ -751,7 +751,7 @@ static void mlxsw_i2c_remove(struct i2c_client *client)
 
 int mlxsw_i2c_driver_register(struct i2c_driver *i2c_driver)
 {
-	i2c_driver->probe = mlxsw_i2c_probe;
+	i2c_driver->probe_new = mlxsw_i2c_probe;
 	i2c_driver->remove = mlxsw_i2c_remove;
 	return i2c_add_driver(i2c_driver);
 }
-- 
2.38.1

