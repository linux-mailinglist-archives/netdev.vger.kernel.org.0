Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B7B6B9E59
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjCNS2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjCNS2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:28:42 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA824B4215;
        Tue, 14 Mar 2023 11:28:13 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id fm20-20020a05600c0c1400b003ead37e6588so13812723wmb.5;
        Tue, 14 Mar 2023 11:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678818490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uCZkrMLZx8ZVMQLFuANkNwADh4tGUpOBmEXyzie1B/E=;
        b=UarJ3AuQtgdT97POi2QL4jhEBe0WUGNTBL9LOFoKiy5WPNaL6vER6d6ibVrQIAmjlL
         DDfARMnIDTGFvCAd3DqhXAe44PBm5frJHA1s0/zqr+zMAbeDcpXvibgSPlpM5/rZgKSR
         iUIQKlOp3QIwPt0NS0vQ7szqSi5vvFkA6Uh53hal4F1lYAGBJ/QBvDwWoccPpAuIW2Vm
         NC4/EjVYiVKw4RC43f9xGHFi8/wDFWL//QIW5JoVAJgnCndFqwaHEAHJFBn5CYlamf28
         13IqIpbvm7Jmty7Yl8l2xmSjX4s1qpnQt2Zek9q1Rq4orLMVHqjHdXxkiYrRy7iH6Asx
         wC1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678818490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uCZkrMLZx8ZVMQLFuANkNwADh4tGUpOBmEXyzie1B/E=;
        b=YCSTzlN3x+wdVjSCfHWU8RO8bl0y8REJJl/+4cZW4Bjokj5TFk+h2/uT7bI63dNxHp
         CcJlF5ykbHwI83w4LXLFfis9x9f254D7y9ylx1/v976L+xme/3kSYj8RJOmPZswqFCGx
         SB70saJfdaOHC8gUPqudIeiEJfe0nJmYQCRC20wPffbcwwDN4iukj0un1A7j/WGfRzat
         GP1VnAEBsEvjpuSixZwrHrJ6bogm+Rc0ujboB/7XNPkvlkhaZzFjskkAKy6qYe/gcyeK
         dO4W4A+YRyFVOKs3RjIjaw6ahZSHlOkQpB6DuaA2pZlv288JwqpnEk1/dS1It+PY1qUl
         p6Jg==
X-Gm-Message-State: AO0yUKXxyH3YaLyGstSXJO33/wE/MCJeB+cpQJLCmt4gJL6zR2/hSdNu
        VX0KwG389+8/2Lt3L3P9iRA=
X-Google-Smtp-Source: AK7set+lUkWThuG1N23QJqHPUBSaOk5Y13PSBdLBj0pekiBWwf/CEnjZKJzslUlaJPscTptKfZRI5Q==
X-Received: by 2002:a05:600c:3c89:b0:3eb:38e6:f659 with SMTP id bg9-20020a05600c3c8900b003eb38e6f659mr15820259wmb.15.1678818490700;
        Tue, 14 Mar 2023 11:28:10 -0700 (PDT)
Received: from mars.. ([2a02:168:6806:0:5862:40de:7045:5e1b])
        by smtp.gmail.com with ESMTPSA id u7-20020a7bc047000000b003e206cc7237sm3443490wmc.24.2023.03.14.11.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 11:28:10 -0700 (PDT)
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Klaus Kudielka <klaus.kudielka@gmail.com>
Subject: [PATCH net-next v3 4/4] net: dsa: mv88e6xxx: mask apparently non-existing phys during probing
Date:   Tue, 14 Mar 2023 19:26:59 +0100
Message-Id: <20230314182659.63686-5-klaus.kudielka@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314182659.63686-1-klaus.kudielka@gmail.com>
References: <20230314182659.63686-1-klaus.kudielka@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To avoid excessive mdio bus transactions during probing, mask all phy
addresses that do not exist (there is a 1:1 mapping between switch port
number and phy address).

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
---
v2: Patch is new
v3: No change

 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 29b0f3bb1c..c52798d9ce 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3797,6 +3797,7 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 	bus->read_c45 = mv88e6xxx_mdio_read_c45;
 	bus->write_c45 = mv88e6xxx_mdio_write_c45;
 	bus->parent = chip->dev;
+	bus->phy_mask = GENMASK(31, mv88e6xxx_num_ports(chip));
 
 	if (!external) {
 		err = mv88e6xxx_g2_irq_mdio_setup(chip, bus);
-- 
2.39.2

