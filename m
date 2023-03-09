Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7526B24A0
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 13:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbjCIMzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 07:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjCIMzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 07:55:09 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42048838A9;
        Thu,  9 Mar 2023 04:55:08 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 5CCBB85EA1;
        Thu,  9 Mar 2023 13:55:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1678366506;
        bh=ZAWUOiGdw0sgMfodR0TUZMQrdR2wpZb4WCLp4NtJrls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJ/wx9NrSe8fus6T7eQJIs1SUgKTdJjvE5QXlsRPKYxjMz8aoMOc5hB3TJ7frnj9Z
         Nt3jH+/49u8jPL57trCnZ8BMmM1pHWqAOI5Ha6GeK1D6GjhdX+MgatLpQx30UVyBGr
         4fI28wRa3t0F19jwhRtV4+xQz0iNFYvYRdexaH+bhKNeZycKJFP6lfcNb5ujlVDWhv
         Tdkg3gF2z87Sjdul+rkQeOncoVDVhRX08vbGh8qQ4Uyay+pNR/SGo5YRDflNmYeGG5
         F0yTN0YZpKMO5bpzaafehYA1/EFB5BwoaABXcSHt9NVaO/Wt+BEtWNmM0l5ufnsKJz
         xinIvcO0v0S6A==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Majewski <lukma@denx.de>
Subject: [PATCH 4/7] dsa: marvell: Define .set_max_frame_size() function for mv88e6250 SoC family
Date:   Thu,  9 Mar 2023 13:54:18 +0100
Message-Id: <20230309125421.3900962-5-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230309125421.3900962-1-lukma@denx.de>
References: <20230309125421.3900962-1-lukma@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switches from mv88e6250 family (the marketing name - "Link Street",
including mv88e6020 and mv88e6071) need the possibility to setup the
maximal frame size, as they support frames up to 2048 bytes.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
Changes for v5:
- New patch
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 26ab4d676615..9695a1af45a9 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5018,6 +5018,7 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6250_ptp_ops,
 	.phylink_get_caps = mv88e6250_phylink_get_caps,
+	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
 static const struct mv88e6xxx_ops mv88e6290_ops = {
-- 
2.20.1

