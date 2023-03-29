Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1EEC6CEC4F
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 17:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjC2PBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 11:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjC2PBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:01:54 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5374272A
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:01:47 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-17fcc07d6c4so2443224fac.8
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680102107; x=1682694107;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PL/MziMN1siN83vtIEtm9b9KmvOZZ2R/OSDVgxgM3+Q=;
        b=lPn1Gjs/+YsrcCk7rEhX+MyA/tybUZ10R7qqvxXe0s0dRhdpf2xK4M58j4Bf4B1sGw
         lhVmMx2ShJPIL8/uP/gM5WxkSXStk1Q/7cnAiGSzkRbh0rEcbhrDcUyxZ2rgmUi+L5Oj
         4Gl8Yegt/JAggURlPYcimHAlmXCMBHuNLupj+xpyvMDWqbNqzkGQ2KCi1MYplW6Ccfbj
         yZgy5KP6EeVTvJK0iR17dfS2eT+EB6F0yIL78MP8ORnuULCOhWVXrtANQymh/vJUmlNr
         rG8btvrxiIZAMhsB2lG9F0Wjc+7ZMo9a6PYdACr/1LW6Af9we01fu6MsJQdcDhz+azl7
         /LXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680102107; x=1682694107;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PL/MziMN1siN83vtIEtm9b9KmvOZZ2R/OSDVgxgM3+Q=;
        b=xJIaUe/qZVa4bP+dy3DHz16WSSFvvg59gtDO0iDypvylACyr1IYBw3NxLxFQg4FQdT
         xDUUJyzeCYvLTK1ShAPN0LaUNKKzrvAbAGKe1U/mpgC6nZiUaVFcHWc0IcDrzqbasdxv
         v+Gxiab6l/ispkvh8hQSTeRgR/emhtpsFZUU4Be3N4A5zsBotd0oYBXwYBD7+eAGvDMy
         QEPKMezb4aqRKf/52+XpjAo45wC4xTqc9yo1rwZSZh7P1Wky8hAF8aZcC0yF4ujWgjU2
         /hUaDMMd1sKf/q0twubPwVPnG7FOnU4y4Et8ipPOcgkcj8BqsR24s8OLYLc0SMterJwl
         q8dw==
X-Gm-Message-State: AAQBX9cfJihQ6txaw71oqC2HIHwNrgTZTXS7A+b0+QTpz7oGpKArF2Gy
        H3hgZ/IArFFo2PdWCCOK7+Gy6rJRE6+OiA==
X-Google-Smtp-Source: AK7set9bGVdaXhzzdkHnOIVZOvnaPudTkp+9W5JSSp3s73vhxtvQLFgIFxMqZ7IzvHFHQbBMOlOakA==
X-Received: by 2002:a05:6870:891f:b0:17a:d300:fd1a with SMTP id i31-20020a056870891f00b0017ad300fd1amr9208813oao.2.1680102107202;
        Wed, 29 Mar 2023 08:01:47 -0700 (PDT)
Received: from fabio-Precision-3551.. ([2804:14c:485:4b69:1c2d:271:d34:84ea])
        by smtp.gmail.com with ESMTPSA id az15-20020a05687c230f00b0016a37572d17sm11927000oac.2.2023.03.29.08.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 08:01:46 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     kuba@kernel.org
Cc:     andrew@lunn.ch, olteanv@gmail.com, netdev@vger.kernel.org,
        steffen@innosonix.de, Fabio Estevam <festevam@denx.de>
Subject: [PATCH net] net: dsa: mv88e6xxx: Enable IGMP snooping on user ports only
Date:   Wed, 29 Mar 2023 12:01:40 -0300
Message-Id: <20230329150140.701559-1-festevam@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Bätz <steffen@innosonix.de>

Do not set the MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP bit on CPU or DSA ports.

This allows the host CPU port to be a regular IGMP listener by sending out
IGMP Membership Reports, which would otherwise not be forwarded by the
mv88exxx chip, but directly looped back to the CPU port itself.

Fixes: 54d792f257c6 ("net: dsa: Centralise global and port setup code into mv88e6xxx.")
Signed-off-by: Steffen Bätz <steffen@innosonix.de>
Signed-off-by: Fabio Estevam <festevam@denx.de>
---
Changes since RFC:
- Use dsa_is_user_port() to decide when to set the snoop bit (Andrew).
- Reword the commit message to differentiate between IGMP snooping and an IGMP listener on
the bridge.

 drivers/net/dsa/mv88e6xxx/chip.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b73d1d6747b7..62a126402983 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3354,9 +3354,14 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	 * If this is the upstream port for this switch, enable
 	 * forwarding of unknown unicasts and multicasts.
 	 */
-	reg = MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP |
-		MV88E6185_PORT_CTL0_USE_TAG | MV88E6185_PORT_CTL0_USE_IP |
+	reg = MV88E6185_PORT_CTL0_USE_TAG | MV88E6185_PORT_CTL0_USE_IP |
 		MV88E6XXX_PORT_CTL0_STATE_FORWARDING;
+	/* Forward any IPv4 IGMP or IPv6 MLD frames received
+	 * by a USER port to the CPU port to allow snooping.
+	 */
+	if (dsa_is_user_port(ds, port))
+		reg |= MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP;
+
 	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
 	if (err)
 		return err;
-- 
2.34.1

