Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4226EF5D7
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 15:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240732AbjDZNxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 09:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240717AbjDZNxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 09:53:07 -0400
Received: from mail.kernel-space.org (unknown [IPv6:2a01:4f8:c2c:5a84::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C245C618E
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 06:53:05 -0700 (PDT)
Received: from ziongate (localhost [127.0.0.1])
        by ziongate (OpenSMTPD) with ESMTP id bfbef1af;
        Wed, 26 Apr 2023 13:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=kernel-space.org; h=from:to
        :cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=default; bh=Pja+rsDrK/Brucf6FsHyaK
        Bn+Wo=; b=gEfwxuKO1R9ZxrUUerh7WfJkWlzcQIxWlYQmv6Z3qeeD1YHLyQU2KX
        EVjkQX2P0KpxARPLUB4pUD3RRA5XuUjeGxFYEy9+Vb3X6vwekaqX1XiogWJmNMdV
        C5+QK/rK9gpTG/MLpw+n2FuWtmz7xc8ANaRYRw0GgMc0X0L9/1EB4=
DomainKey-Signature: a=rsa-sha1; c=simple; d=kernel-space.org; h=from:to
        :cc:subject:date:message-id:mime-version
        :content-transfer-encoding; q=dns; s=default; b=e184LtQX/h/Nq1N9
        BAoWFwNe3mcchtBPi2QaYzgv7H7YJv8V7Y3gd93L9CCOoDmPphBwov82UCXxwv0J
        V6fLV7LErCpKov6YJNM61fCtxmVL5X4sqIk97PyvPO307FaeoRoqTuOWsOISBGpo
        XoFdYPLbxOFNUQ1RvhReDf+7xPY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel-space.org;
        s=20190913; t=1682517183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RZREPLAl1Zrn6/gKPwpdPVztdckQURJNkXSzYZvM4CA=;
        b=pOpH2wEm6LICMwB/Fb2DzfvEZMlNlDaMtLEaKVw3dNUPb0pLeRDKkWjDmCxpCbZV4A2702
        5UeAmZV9Vifz3jvRx0vYR74fp0Y6ehkg4YxQArnebpe5fsSO1/jRTgFPIynk3P0zNLIHlc
        hBBizi3izpGgJKMZM9T6bYu8b+DZzp0=
X-Spam: yes
X-Spam-Score: 6.4 / 15
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
Received: from localhost.localdomain (host-79-40-239-218.business.telecomitalia.it [79.40.239.218])
        by ziongate (OpenSMTPD) with ESMTPSA id 10798f21 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 26 Apr 2023 13:53:03 +0000 (UTC)
From:   Angelo Dureghello <angelo@kernel-space.org>
To:     andrew@lunn.ch, vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org,
        Angelo Dureghello <angelo.dureghello@timesys.com>
Subject: [PATCH] net: dsa: mv88e6xxx: add mv88e6321 rsvd2cpu
Date:   Wed, 26 Apr 2023 15:52:59 +0200
Message-Id: <20230426135259.2486610-1-angelo@kernel-space.org>
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
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7108f745fbf0..75741ff922b4 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5182,6 +5182,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.set_cpu_port = mv88e6095_g1_set_cpu_port,
 	.set_egress_port = mv88e6095_g1_set_egress_port,
 	.watchdog_ops = &mv88e6390_watchdog_ops,
+	.mgmt_rsvd2cpu = mv88e6185_g2_mgmt_rsvd2cpu,
 	.reset = mv88e6352_g1_reset,
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
-- 
2.40.0

