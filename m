Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071576EFBA4
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 22:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235251AbjDZU2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 16:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbjDZU2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 16:28:51 -0400
Received: from mail.kernel-space.org (unknown [IPv6:2a01:4f8:c2c:5a84::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3291FDE
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 13:28:50 -0700 (PDT)
Received: from ziongate (localhost [127.0.0.1])
        by ziongate (OpenSMTPD) with ESMTP id 7acfa37f;
        Wed, 26 Apr 2023 20:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=kernel-space.org; h=from:to
        :cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=default; bh=5y0aG+ZaSHvPsGfHmntw/C
        tBn4E=; b=LkyGv5xZSLlLczyQBkwx6HU+niqsSwB1FxDT6Injg6iPZPBdxPBA6h
        /Se2n4DS89KTc8bUONTda0/EZAaFJmtCKt1L3ZiXdgMV9DT6pNwF6Tjr6I8W2LII
        IWTH+vGyKbJkE+wXExjkCR6CspG/MYlk9k6WtdLZUb34rH08hmWCA=
DomainKey-Signature: a=rsa-sha1; c=simple; d=kernel-space.org; h=from:to
        :cc:subject:date:message-id:mime-version
        :content-transfer-encoding; q=dns; s=default; b=SslpPEphHTdPh53H
        kfJrc46sv7bAlMb3bWf9yJaJrKZ1PPBrynvtlVwXW787s0G0ZmYnhnlfb0oe2m0H
        vwen0RDh+DZhgJmjRG7vCTLtHnEyxDXzN794gbtfMudIW8z0EhFD83vzIFDA/+Zw
        KnSfRr3f10+Ma/t8xtkDlDKLjns=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel-space.org;
        s=20190913; t=1682540927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=q35JoJqOMXC3J9HqGDnGrjbACe43bdtNYJNraq7TQ0s=;
        b=N9a52W8XBTxubmMT1iO9BLDbrp2Ajw49rvhD0pQ540OBvSrv8F6swnmX8g3AgNq1V2Rusk
        hsE94FFBEsPEm/UqsApBUGk6sXyn6hqmQLQSaQcjiHkiBoGysh7onYaBaOSEGJpz6ARit5
        kWUAX50J3lgvaQrBw5Jcp14frNWxrc0=
X-Spam: yes
X-Spam-Score: 6.4 / 15
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
Received: from localhost.localdomain (host-79-40-239-218.business.telecomitalia.it [79.40.239.218])
        by ziongate (OpenSMTPD) with ESMTPSA id defd4889 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 26 Apr 2023 20:28:47 +0000 (UTC)
From:   Angelo Dureghello <angelo@kernel-space.org>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com
Cc:     netdev@vger.kernel.org,
        Angelo Dureghello <angelo.dureghello@timesys.com>
Subject: [PATCH v2] net: dsa: mv88e6xxx: add mv88e6321 rsvd2cpu
Date:   Wed, 26 Apr 2023 22:28:15 +0200
Message-Id: <20230426202815.2991822-1-angelo@kernel-space.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Angelo Dureghello <angelo.dureghello@timesys.com>

Add rsvd2cpu capability for mv88e6321 model, to allow proper bpdu
processing.

Signed-off-by: Angelo Dureghello <angelo.dureghello@timesys.com>
Fixes: 51c901a775621 ("net: dsa: mv88e6xxx: distinguish Global 2 Rsvd2CPU")
---
Changes for v2:
- use mv88e6352_g2_mgmt_rsvd2cpu instead of mv88e6185_g2_mgmt_rsvd2cpu
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7108f745fbf0..902f40721340 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5182,6 +5182,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.set_cpu_port = mv88e6095_g1_set_cpu_port,
 	.set_egress_port = mv88e6095_g1_set_egress_port,
 	.watchdog_ops = &mv88e6390_watchdog_ops,
+	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.reset = mv88e6352_g1_reset,
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
-- 
2.40.0

