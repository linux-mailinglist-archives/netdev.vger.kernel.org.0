Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB89640A26
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 17:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbiLBQFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 11:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbiLBQFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 11:05:34 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FB02872F;
        Fri,  2 Dec 2022 08:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669997134; x=1701533134;
  h=from:to:subject:date:message-id:mime-version;
  bh=xD4uZu3i37XFWjIhQlvkmX1Fzfem6pzq7ZnrtxVdaMU=;
  b=t5suCTKSlsz1isLC88euGuAafWnscukusdNGw4BQsb8KliF6U6tcD7mk
   9IUFRs2UEkMKAQiXjwoBIw/FLCxECrjGXlbAJ5iXgubeYD/XPbXrPovTb
   NA6svQKQYu1vGm8aqcoxwFonmI+igpGDaTMD5Y58Y3pvlII9L/6RHbmtG
   tIepVZFLgbhmc0RcfXWgd/5LMvJRbEq08QinStcVMw3iy2PFei7/jsOdu
   5OQZszn/PwRrUXz0ulglZZXsQlrhRWXlFy/mxnZtmaPExqXaVLUDHOZnL
   49koMP3tHY1jZBXm8nEZkPeOgPn2rqQSSgvsCW91bosPUGvSg6bAsJJUn
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="191476205"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Dec 2022 09:05:33 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Dec 2022 09:05:31 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 2 Dec 2022 09:05:30 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next 0/2] dsa: lan9303: Move to PHYLINK
Date:   Fri, 2 Dec 2022 10:05:27 -0600
Message-ID: <20221202160529.30010-1-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series moves the lan9303 driver to use the phylink
api away from phylib.

1) adds port_max_mtu api support.
2) Replace .adjust_link with .phylink_get_caps dsa api

At this point, I do not see anything this driver needs from the other
phylink APIs.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>

 drivers/net/dsa/lan9303-core.c | 93 ++++++++++++--------
 1 file changed, 56 insertions(+), 37 deletions(-)

