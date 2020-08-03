Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9DF23ADEA
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgHCUEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbgHCUEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:04:06 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E780C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 13:04:06 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o5so2695662pgb.2
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 13:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EldVOy+QJIUng9Vai17ILIFgbD/qmlvnl8hO2VV5nAQ=;
        b=rc7Xij9YXdMEjQZ/kPWOhMxqVLuEp5ebItse6DOHQlWjRtShv79JOIfgiy36Kv08M+
         gh4i/ueZ3SET6keaf9oqKpXx+MTftrJvFq01JnOr6gQLCXUGGS91onE9uajndQx3Atkq
         EYo4bmMS2aGtRrDHyTpgJxhrdu60Nre1ltMT7B8oqXPwnDoGa0nCMs6C15SL0gWvbzY2
         xBqa/fN7msb0/ddFoZ2HwzMLpwEHZktka1s+vGYYwmRF2GQTzftWHEJpmeokT/sQ/lbE
         MgxnybkTt6bKYXds2igxOO275KQwCU7FL1HVPGmNNTSlVVPm0sdoxTWORgbCwM1zZNGN
         vBFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EldVOy+QJIUng9Vai17ILIFgbD/qmlvnl8hO2VV5nAQ=;
        b=k3Ezlz39TUtxUOxMRlmpTKiW8srMCcqLjABrVdoQeNweFwb7FvOXiCAlSOZ6hJO1G8
         mF6buudChIdjO6Bmh0CNlYe15qWFtenL57Iw/wXhReMzbXyRZv2VepkKujTV8xZ7Txtv
         11RZBFxs8FGQpWRMCufcrccVjYHCZEIUdfuKbB9olfEf8813/jPHN42KlYnwDxVoGkpq
         yTiPh6LHzk3FmIILhcuVIyVy77wR0I0A2NdVz4694A3WP+FQqY1WOgUdASOnbbKZ5lfe
         e6AMe7v1c8La+9QGROaXE/u8PC/qDXFzY23SYRlAAlu97xXAiM+NpzFLS8gaIgMIuKvF
         ivCw==
X-Gm-Message-State: AOAM531lUxwbMe6euNVK8otOn+qXEsSiDFZxkLz1+MrTX6jQCyWF+UO0
        FFGhp4M/SpjPyb0LzbcUU5WHOnzp
X-Google-Smtp-Source: ABdhPJyz6ew7TiurmKuFmITYV1MRKKsJs9tYzWSJhae7fmyBBHyB2XDhqZc8GEVCVxvRlb9rfPD5YQ==
X-Received: by 2002:a63:1d51:: with SMTP id d17mr5495514pgm.162.1596485045806;
        Mon, 03 Aug 2020 13:04:05 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u24sm20017521pfm.211.2020.08.03.13.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 13:04:05 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/5] net: dsa: loop: Set correct number of ports
Date:   Mon,  3 Aug 2020 13:03:54 -0700
Message-Id: <20200803200354.45062-6-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200803200354.45062-1-f.fainelli@gmail.com>
References: <20200803200354.45062-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We only support DSA_LOOP_NUM_PORTS in the switch, do not tell the DSA
core to allocate up to DSA_MAX_PORTS which is nearly the double (6 vs.
11).

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/dsa_loop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index 6a7d661b5a59..eb600b3dbf26 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -275,7 +275,7 @@ static int dsa_loop_drv_probe(struct mdio_device *mdiodev)
 		return -ENOMEM;
 
 	ds->dev = &mdiodev->dev;
-	ds->num_ports = DSA_MAX_PORTS;
+	ds->num_ports = DSA_LOOP_NUM_PORTS;
 
 	ps = devm_kzalloc(&mdiodev->dev, sizeof(*ps), GFP_KERNEL);
 	if (!ps)
-- 
2.25.1

