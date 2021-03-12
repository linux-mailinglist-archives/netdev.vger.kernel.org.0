Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A72C3398E5
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 22:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbhCLVLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 16:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbhCLVLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 16:11:14 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58F0C061574;
        Fri, 12 Mar 2021 13:11:13 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id gb6so5753304pjb.0;
        Fri, 12 Mar 2021 13:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wz7DsDh9in1WQ8szNmEgdOyLhNi2EeCu5C/ACTNPo9U=;
        b=qLfwf/C+s6b8IixldJWT2CBWm5O3NiwsoHnQCRPa+ctPdpl3rSv0xXRGf+w5KoVvbp
         1BVn3YU0S1FEdpQx5BgDJItFt8iNIQ1EFfCv6vx/j1muM1eKeMeZ5jrjgGbfCuh5nbNc
         b6yVS3dqks+Ey0/1jPtGX6jdmuogG4aQi/2gnXNDwWO2Gj4HtxNgzIqQ9bSTyR5YPAVB
         iMiOjTF0u7Rav8MWsKpR0BZAj54z2jbgTzb38fdcGIGHV+xkAzOi4Ehpzkcq4K0smWzx
         KU77hJnPChSxVFtwn8F61+VCpUltKWN7NyIHKT/9UsHO/4t/SF8eavVRpwSbjYQa6Fl7
         7TEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wz7DsDh9in1WQ8szNmEgdOyLhNi2EeCu5C/ACTNPo9U=;
        b=extL8IDXv13G64cPoGv/J7sW/de9HK7Ys4i5c6vmQD8TLV1paIGX+7n5SsqS4u/j/Q
         BbH+dTfb1AbnGP1AOCs1nxjZ0tbyostlQxLhuuVun2BQ6pzF7ofkBmvdXGyttjDknKZP
         KVa8tskkEXlxPkpXXbhiwW2mN+NpmAshvUAO1rPFO7zXt830Iox6X+rRc2pbA/CthNYg
         64I6hwRJ2xvMdCKNBLfN2p+/MqfV4G3hqkuRM9fH7N2vYhPREq/C5EjOymb4i5hSxZoc
         i2B8q4VYOSOLqMxYWrsSSeMYTHRRfGvWkoex7Fn4dMfwOk5FGDzcghG8bWog++Heub/X
         eETw==
X-Gm-Message-State: AOAM530AWNUvXrxLH5VpECS0ULhhhqUCoFrojKV22A4MDOFHKGTOSVUf
        QMsIGVmAfDZBKOk1IJtHiDADW+6A1Og=
X-Google-Smtp-Source: ABdhPJzP5j8G5Q1nTRmqPQ6pqv8fZyFzxMAaR9N48HRdcnMrQcsZx4fJ7g/xCcQrMe8c1X004LFUTw==
X-Received: by 2002:a17:902:ab8b:b029:e5:ea3a:3d61 with SMTP id f11-20020a170902ab8bb02900e5ea3a3d61mr371524plr.71.1615583473070;
        Fri, 12 Mar 2021 13:11:13 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o13sm6559634pgv.40.2021.03.12.13.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 13:11:12 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     zajec5@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: bcm_sf2: Fill in BCM4908 CFP entries
Date:   Fri, 12 Mar 2021 13:11:01 -0800
Message-Id: <20210312211102.3545866-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BCM4908 switch has 256 CFP entrie, update that setting so CFP can be
used.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index f277df922fcd..60a004f8465d 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1151,7 +1151,7 @@ static const struct bcm_sf2_of_data bcm_sf2_4908_data = {
 	.type		= BCM4908_DEVICE_ID,
 	.core_reg_align	= 0,
 	.reg_offsets	= bcm_sf2_4908_reg_offsets,
-	.num_cfp_rules	= 0, /* FIXME */
+	.num_cfp_rules	= 256,
 };
 
 /* Register offsets for the SWITCH_REG_* block */
-- 
2.25.1

