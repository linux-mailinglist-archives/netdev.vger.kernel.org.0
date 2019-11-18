Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9074010047A
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 12:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbfKRLl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 06:41:28 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35447 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbfKRLl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 06:41:27 -0500
Received: by mail-pl1-f196.google.com with SMTP id s10so9673268plp.2;
        Mon, 18 Nov 2019 03:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y3dNvZGOTXHcwszhaSWaecoVEi7Q+cvDM3heVVZqOJg=;
        b=Gm6zRK0PEAuSnXmueVoIk7R0Vg6pkNCYcWQpO5nxbzU/hruF6Ou2tHv5IocAFc1HlB
         Vugo8BvFrz8kBMfgtONaJlHsIAeN+DAYWoArivrHDbrXDa0Ly+eGhmHfGtB2df7m1JJY
         Gwk7uppd0rRlPfJCYGzbLrE8D/Vu/lfnxmeJKnXJX/IlkuY0nOSqNbEYXN8gho2zJtkp
         MK60tua+o/kgRutSu5lgTnXfNIX9zmBNHI8xY9WThF48wr0OpjE/9zkKwSNfQMqb87xF
         iRXdv2MunyU3ssfscV7E84s9yJ8tIqt/lmXjvfhjlEvhIsUU/0c3qJflgrOZFovy21vS
         S4Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y3dNvZGOTXHcwszhaSWaecoVEi7Q+cvDM3heVVZqOJg=;
        b=lXfKKYEgU92PFy2tRp1RCh+ohZqnPvUPYGQxjSYC1sScHr3ZguqkYbfmAqIH2S7wzC
         c/yIisp4MRcO86tK82gbhL4MDBIsvPuoAhziWg00rjbp3gS3cruNcTY47+33Vg1Z2jqY
         WBvLNRtr5OtcMMAlv1yQgbe1hiiM8miJNfTgcbYnHT027+JPSR1FtuSGG/SO0kpAtXdH
         /dozuH4RZBSzrD97UVTE/kavEKi73ekicfPPps50wWSF9nhpmhYswPu5J0iO7MoONght
         2xCpbV9cThdmsmwvx81NLOpIKNdUHCTBqVr+6Auus3oBhLk0+dy6Ol8iZbCYYjbsvxMS
         8Bvg==
X-Gm-Message-State: APjAAAUlEJm89nUafKqEIwBnmPdewxSTMfJFK8x3c+KZriteKgJaiNNN
        LvkVyGVyEzjfcIT9DWKS839dQw12IXQ=
X-Google-Smtp-Source: APXvYqxkb+Di6ZGVFvNAuyKzeK5xAMC329UbduP0YsF1FEoBa/nqARtsD7TnIOAOrl6I/wMrI+DF3g==
X-Received: by 2002:a17:90a:bd95:: with SMTP id z21mr39237600pjr.10.1574077287005;
        Mon, 18 Nov 2019 03:41:27 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id x192sm23480122pfd.96.2019.11.18.03.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 03:41:26 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] phy: mdio-sun4i: add missed regulator_disable in remove
Date:   Mon, 18 Nov 2019 19:41:15 +0800
Message-Id: <20191118114115.25608-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver forgets to disable the regulator in remove like what is done
in probe failure.
Add the missed call to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/phy/mdio-sun4i.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/mdio-sun4i.c b/drivers/net/phy/mdio-sun4i.c
index 58d6504495e0..f798de3276dc 100644
--- a/drivers/net/phy/mdio-sun4i.c
+++ b/drivers/net/phy/mdio-sun4i.c
@@ -145,8 +145,11 @@ static int sun4i_mdio_probe(struct platform_device *pdev)
 static int sun4i_mdio_remove(struct platform_device *pdev)
 {
 	struct mii_bus *bus = platform_get_drvdata(pdev);
+	struct sun4i_mdio_data *data = bus->priv;
 
 	mdiobus_unregister(bus);
+	if (data->regulator)
+		regulator_disable(data->regulator);
 	mdiobus_free(bus);
 
 	return 0;
-- 
2.24.0

