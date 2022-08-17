Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C363D596C86
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 12:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238872AbiHQJ6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 05:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238849AbiHQJ5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 05:57:53 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175C681690;
        Wed, 17 Aug 2022 02:57:32 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CB0471C0006;
        Wed, 17 Aug 2022 09:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1660730251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=O8jbKEQBySAhMgHnENNc4dgpfRxZV1zLQF89bHQhhIA=;
        b=VlBak11SJoxZLo4bubcX7gE6J8VXefDbQqrTG0i5dASfp78ntWeq2dlNH6zLRPsv655g1a
        IwwS3RfdlAzALW0pa6FalnjsRTwo/5r2gru6NdgIxxDbq72vL+2EWnHowTtJ3qo1SxkdpO
        dx8t88SFoD2k246sXyisuxnJlVO2CFHt0cCWIXkrI3oRLTECsxGtMehAchp4FfsgMx9g5k
        mDFxotRfGiINIntRkgM2j7b9foq1jdYTRL/r4zCxa6RaLjfaECeJ+NJYqYfSnjGWteFjsC
        b66QdduiyrgdBIuYJ8zIVNc5VzhTkHOYQa0EG0tIy49v45wVDyl/O8XZQu3+1w==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com,
        Richard Cochran <richardcochran@gmail.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] net: ethernet: altera: Add use of ethtool_op_get_ts_info
Date:   Wed, 17 Aug 2022 11:57:25 +0200
Message-Id: <20220817095725.97444-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the ethtool_op_get_ts_info() callback to ethtool ops, so that we can
at least use software timestamping.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/altera/altera_tse_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/altera/altera_tse_ethtool.c b/drivers/net/ethernet/altera/altera_tse_ethtool.c
index 4299f1301149..3081e5874ac5 100644
--- a/drivers/net/ethernet/altera/altera_tse_ethtool.c
+++ b/drivers/net/ethernet/altera/altera_tse_ethtool.c
@@ -233,6 +233,7 @@ static const struct ethtool_ops tse_ethtool_ops = {
 	.set_msglevel = tse_set_msglevel,
 	.get_link_ksettings = phy_ethtool_get_link_ksettings,
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
+	.get_ts_info = ethtool_op_get_ts_info,
 };
 
 void altera_tse_set_ethtool_ops(struct net_device *netdev)
-- 
2.37.1

