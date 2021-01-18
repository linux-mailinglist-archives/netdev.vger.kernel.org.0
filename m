Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673612FA605
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406276AbhARQXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406319AbhARQTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 11:19:17 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86894C061786
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:55 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id r12so13108872ejb.9
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i38Sp631MM4/rR/8brp5CxbjJ0pFDmXFoy3JLlZIThs=;
        b=BMeyJH1DJQ9C/ymPdvokoTxI6TfustaJm5z/A9C1KjcTjm7KsjTNJW777qM00HquP4
         H2GtvzMK0dpbvMt/OyeR8jjET05371fjqukKOLuEQPVYfzmRh9mB3q4d4l57MNJyVkUM
         RLeK2Ewuk924P6mqO9rzuxpMy411nysul+v53UkoDwZXhY1Lh1YAST/4GaFPc+2Ktoxx
         GjYQaIOFzTw+OuOZXJ9k69ykT8RINm9uizCpS+R5rq+6WF4nfXSCxZ7QKo1wX9+IDzN0
         cnIr/8wDaam+JS3PPjcqhVI36bBonxoY37jSBRrSH5elpcY40iWmICakWMZsyJ0hEljm
         +D2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i38Sp631MM4/rR/8brp5CxbjJ0pFDmXFoy3JLlZIThs=;
        b=Nqt3Ilvz4prLlFC3PnjblzrzWn+d1oKM8IkceZPxt0DcIEzeWoF5/YSv7rZrgd1elZ
         PzmT86sZVUskT1cuj6KrwgJphnQHb4CQBhwcRVVmIShk14wJv8juyRPWEqIb2wi78U0Z
         EVp+tMQgILQgAAbgG9PlK+BfaQpMJjFFD5ltP7VyPflS/vES05R+Qza3D3thPRiON/rP
         4X29EApTKA0fZGFPSbF2ghoXr0x2dN6u5tVH34XJ7acTntHD1YiaB9L3h+BE49PUzCl9
         L7N8EnEjjI+FZNKuhGcMH6o25xCU+9VD33Jt0Cb9SQOwCY8kcVIirHNParA6Q7//V82X
         N0Uw==
X-Gm-Message-State: AOAM530MR3+EWc54zuMDvfCLo9+E5EcAT/2OBvGyjtArG8cgifeb816t
        Q+Sb3IP8VuGPH1Yy+EpFODM=
X-Google-Smtp-Source: ABdhPJxPbzWtSRY0PrJapBiieSqSzGVBo/QRQeCWrQKTz2vlr2Tk4sa2j44zr7DKpM4v2cTvDKmVdw==
X-Received: by 2002:a17:906:26ca:: with SMTP id u10mr291808ejc.165.1610986674310;
        Mon, 18 Jan 2021 08:17:54 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u23sm6093781edt.78.2021.01.18.08.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 08:17:53 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 09/15] net: mscc: ocelot: use DIV_ROUND_UP helper in ocelot_port_inject_frame
Date:   Mon, 18 Jan 2021 18:17:25 +0200
Message-Id: <20210118161731.2837700-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118161731.2837700-1-olteanv@gmail.com>
References: <20210118161731.2837700-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This looks a bit nicer than the open-coded "(x + 3) % 4" idiom.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 9535a75b1c84..55847d2a83e1 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -563,7 +563,7 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 		ocelot_write_rix(ocelot, (__force u32)cpu_to_be32(ifh[i]),
 				 QS_INJ_WR, grp);
 
-	count = (skb->len + 3) / 4;
+	count = DIV_ROUND_UP(skb->len, 4);
 	last = skb->len % 4;
 	for (i = 0; i < count; i++)
 		ocelot_write_rix(ocelot, ((u32 *)skb->data)[i], QS_INJ_WR, grp);
-- 
2.25.1

