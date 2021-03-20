Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18433342FFD
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 23:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhCTWgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 18:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhCTWf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 18:35:27 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210DEC061574;
        Sat, 20 Mar 2021 15:35:27 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id b9so15301428ejc.11;
        Sat, 20 Mar 2021 15:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FX/gpTHurZv94BWIowZaJ3czNzkfeitN+oQL7QnMW9c=;
        b=tL4oFig3Pkr6OVUSg/g0NtF9GTJ4U4F6h/XL2uRANZ/LskhtE+ul50rXwwL8FpU8WV
         hD/0JX9LbH36w4dxToBWM1Ufq6TSiYphYRu4qakOynWMGHineNodCHu22xZvhWwOuKC3
         OHLGNf0GmoVjaCJiE38UBVAgFTEfDcuV5wZKxJvpAJlnNHGM8DOJ6KShTDadEqvhV/Ya
         /4EIUrSUTEvqDkLE1E1pItVN7KISOBh5rDsMZPFuqBH8JjLyEOzMT8qREWf+pvFOBjTQ
         YGM9RdFl2nciNbW2IrZ43oqCa/tlytLWMdfUBA9GzZnv7WRrPwQhCgRq+lYV6VqFCb4s
         fluw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FX/gpTHurZv94BWIowZaJ3czNzkfeitN+oQL7QnMW9c=;
        b=ToRpBza+VTfDFAEG9KXJ6AwEr+bcX+pNSoBQQbVvfOKTm8ZZzk6EuyawBgdGz0Ooc3
         WcTb2E2n0nGxaTuRwmnL9bTJrHYqO7liJk7lHTWsIEvNMOpa22NStkbJhetmddrC0K7v
         UPjfwh08fAo4Gpmg0t/Ec5u9HeajFThj8uUV3d29+bzJGSVLTGDgc927lMC/HipJ6Z58
         HCzE0hHymoknZ++4q9QtO9uD0nUJK5V18ba2+fwJdCKbFvpk3WpSV4JGcAyGvTCpFbSg
         OjLHhaF02ypEKgSUhMHTcQs0fIimi4eH1EbAwZ5Pmo+Ml0lzYt33lNnaJ+AeA7ZrCDRU
         xbpQ==
X-Gm-Message-State: AOAM532OLx5o5w5ntBIxG6iNX5bdPCKFXNFRBB3ivAPtg3AXQn7tRH+A
        ndj4RZmo+vK++a58KltGTqo=
X-Google-Smtp-Source: ABdhPJy0rzK1nxpNTmRU/uDFvHDZ1kuicf8drxlE3WopPx6BeZiz+yqfB2jE8PfHRD8xK4EaP8uE/w==
X-Received: by 2002:a17:906:19d9:: with SMTP id h25mr12087622ejd.453.1616279725936;
        Sat, 20 Mar 2021 15:35:25 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id n2sm6090850ejl.1.2021.03.20.15.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 15:35:25 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 05/12] net: dsa: sync up VLAN filtering state when joining the bridge
Date:   Sun, 21 Mar 2021 00:34:41 +0200
Message-Id: <20210320223448.2452869-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210320223448.2452869-1-olteanv@gmail.com>
References: <20210320223448.2452869-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is the same situation as for other switchdev port attributes: if we
join an already-created bridge port, such as a bond master interface,
then we can miss the initial switchdev notification emitted by the
bridge for this port.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

 net/dsa/port.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 2ecdc824ea66..3f938c253c99 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -172,6 +172,7 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 				   struct netlink_ext_ack *extack)
 {
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
+	struct net_device *br = dp->bridge_dev;
 	u8 stp_state;
 	int err;
 
@@ -184,6 +185,10 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
+	err = dsa_port_vlan_filtering(dp, br, extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	return 0;
 }
 
@@ -205,6 +210,8 @@ static void dsa_port_switchdev_unsync(struct dsa_port *dp)
 	 * so allow it to be in BR_STATE_FORWARDING to be kept functional
 	 */
 	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
+
+	/* VLAN filtering is handled by dsa_switch_bridge_leave */
 }
 
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
-- 
2.25.1

