Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E84A253A6D
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgHZW4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgHZW4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:56:46 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25EDC061756;
        Wed, 26 Aug 2020 15:56:45 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id d2so1883574lfj.1;
        Wed, 26 Aug 2020 15:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IczZFezy4iUgpT57xY22u6EXZy2MKKM2x/4edFQQN1E=;
        b=olyPMGQS/MuBkv49XJ/YQcFtzuDmJzmYugIzuzqQRTGKlU9CKJhd3m9Ot8UpB2xcnx
         nw7JuNBH6l7IMDOaG37jvjuEFFWToP7V016/nGrbNnoJfm7YRs+RwdDkdSb5mZ27ULXp
         vDLTpXkM5Z1sK1UsFdpEJirxLkINgHCuYUonCpLAM0iSEEQxI8PSfH+F9fN5VY/9Aq14
         vDTyH4avHkVOyQz6JMD/rNCLmnWzdvfWzDUhTkz8BFrQeXwbI+9afWN1w9BPRwnf5maj
         ILfbYrdAPmXwASwDvHGctG7J0qFRMqcY95fi1P5SfNkKyQH5d8Iv4/ao7GFtJw+MU8/6
         /4/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IczZFezy4iUgpT57xY22u6EXZy2MKKM2x/4edFQQN1E=;
        b=Of67z7XDSqws1XGoGx1ucU8bo7x12vS7TOvWERjLghixuvvOFLj9qCS3DVOlXsI30G
         X+P1A1fIPCpCq1A7tlPSxTrHJsVxNV1PcdI/s7RF0jIK9fcvzKAOg++BzfV59LfBVoi9
         bDlWTJ5MCYSs5q1NKpaXKlh+4tKqxhDTT2WD6rXodejYWNAFn7r3QgoMUA17u6Dw/ssO
         sMs0Z3j3XrvwruDk1sdqO4Z5gjbvYJoR+Q0LXFJoi3uGQnGFQK5KQpXs76J8nnKFslfR
         gBEZABS375lKQA9+QElISa9a4VbXMFFWkNo7XcBPLka/lB0UqkVsLhFipbD6yt2kprZg
         i8XQ==
X-Gm-Message-State: AOAM533EiIwiWmgdHssJZpzrhkWTCSdttF44wy8qk0UcFY7GB8mUWnHP
        W4H1ADfnTWp0MOrnTcrUZ/A=
X-Google-Smtp-Source: ABdhPJyKx+56/SHAfVbE0yslIhtVZETXi3wxIzyRovjepBa8prVJDIfrrMu3ljkMagjI9hGy6iIgVQ==
X-Received: by 2002:a19:3fc9:: with SMTP id m192mr431848lfa.36.1598482604326;
        Wed, 26 Aug 2020 15:56:44 -0700 (PDT)
Received: from localhost.localdomain (h-82-196-111-59.NA.cust.bahnhof.se. [82.196.111.59])
        by smtp.gmail.com with ESMTPSA id u28sm49075ljd.39.2020.08.26.15.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 15:56:43 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH net-next 5/6] net: phy: mscc: macsec: constify vsc8584_macsec_ops
Date:   Thu, 27 Aug 2020 00:56:07 +0200
Message-Id: <20200826225608.90299-6-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826225608.90299-1-rikard.falkeborn@gmail.com>
References: <20200826225608.90299-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only usage of vsc8584_macsec_ops is to assign its address to the
macsec_ops field in the phydev struct, which is a const pointer. Make it
const to allow the compiler to put it in read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/net/phy/mscc/mscc_macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index 1d4c012194e9..6cf9b798b710 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -958,7 +958,7 @@ static int vsc8584_macsec_del_txsa(struct macsec_context *ctx)
 	return 0;
 }
 
-static struct macsec_ops vsc8584_macsec_ops = {
+static const struct macsec_ops vsc8584_macsec_ops = {
 	.mdo_dev_open = vsc8584_macsec_dev_open,
 	.mdo_dev_stop = vsc8584_macsec_dev_stop,
 	.mdo_add_secy = vsc8584_macsec_add_secy,
-- 
2.28.0

