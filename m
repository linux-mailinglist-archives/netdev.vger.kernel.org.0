Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75326181CD
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 23:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbfEHVvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 17:51:51 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36683 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbfEHVvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 17:51:51 -0400
Received: by mail-lj1-f193.google.com with SMTP id z1so235853ljb.3;
        Wed, 08 May 2019 14:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z7zi0z6P4GKEXwWV7x1PGifLNYhn60SR2kPXRCLn8SA=;
        b=qVEA7XAHx1epY0O1YUS1wsPGzJasjS8UX+IGJ26YFEAOn3JQzBi7TmM038R5zDTG+h
         ZszIQm+61yj2zvYA6h1zIIm7OPXZPgzpux0kBnje7iqgL+B5S6JXtZapLdcR0E740P7+
         zW6ncS0hDpKRf+sZwl+EnIi4fXReJMg01sxXO32z79v3wiM/ufGgDIOGsw0OTlcAKScG
         yyFAPPnZb6IxE+DOiPC17TdQaVxpg/PDXsNWEoqPPzvqQ8+nlc8T0L6NOZ0erkQbZsrR
         DFNlEa7sUn4QYsv1/vhsVtsCycnIRgcutbmXnnxh0LSknvPKT/1fH+R41pF7API8AX6P
         tDVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z7zi0z6P4GKEXwWV7x1PGifLNYhn60SR2kPXRCLn8SA=;
        b=Ag8EZO9FKlTjH9sDEhIo2ydO9lELUJDwHN26WgjypD0JzdFis6GI6RLWywk9M3Rshk
         nNglyKUzg3hdsqAAeaQ2zlJfAmAflED3amUrXoXOAni8w2yjkzoY1Pm2FfkfjTDtuWlD
         Gho5MOTiSgLtYATmnDUHTXIUJqu++V3ks0ESscZHSysrobQEdaVUfbjsd6WdFNHZCQg5
         ko+5I36/rkUkwa5IjQy8I8+BKSFdHn5TOizvsM6ByAx41TIN5ZlhLJvpEw6iLUj8yFQi
         fFnJz/sF1TTrpegEMnJwj3B/8141XyWJdMT5f/HVMw1N86pPNeHaQKjF4EG4toZdpq/L
         4GEw==
X-Gm-Message-State: APjAAAW6jo4cOxRcvzooFqhBlv4PsOes+7WYXBtrwk+xfNhJCrfFBe9X
        vKwQtI+AHUb/YN7SX7IkUBoHiUAaN1U=
X-Google-Smtp-Source: APXvYqy1BOHXERcPEOmNARYdvxiMVQVAnAIuz5fVfu/8YZg4APtrk07GvJAbbs/AkxWcPBD58UzMVA==
X-Received: by 2002:a2e:8602:: with SMTP id a2mr77270lji.21.1557352309171;
        Wed, 08 May 2019 14:51:49 -0700 (PDT)
Received: from localhost.localdomain ([5.164.217.122])
        by smtp.gmail.com with ESMTPSA id l5sm28279lfh.70.2019.05.08.14.51.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 14:51:47 -0700 (PDT)
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] net: phy: realtek: Fix RGMII TX/RX-delays initial config of rtl8211(e|f)
Date:   Thu,  9 May 2019 00:51:13 +0300
Message-Id: <20190508215115.19802-1-fancer.lancer@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190508012920.13710-1-fancer.lancer@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It has been discovered that RX/TX delays of rtl8211e ethernet PHY
can be configured via a MDIO register hidden in the extension pages
layout. Particularly the extension page 0xa4 provides a register 0x1c,
which bits 1 and 2 control the described delays. They are used to
implement the "rgmii-{id,rxid,txid}" phy-mode support in patch 1.

The second patch makes sure the rtl8211f TX-delay is configured only
if RGMII interface mode is specified including the rgmii-rxid one.
In other cases (most importantly for NA mode) the delays are supposed
to be preconfigured by some other software or hardware and should be
left as is without any modification. The similar thing is also done
for rtl8211e in the patch 1 of this series.

Signed-off-by: Serge Semin <fancer.lancer@gmail.com>

Changelog v3
- Add this cover-letter.
- Add Andrew' Reviewed-by tag to patch 1.
- Accept RGMII_RXID interface mode for rtl8211f and clear the TX_DELAY
  bit in this case.
- Initialize ret variable with 0 to prevent the "may be used uninitialized"
  warning in patch 1.

Changelog v4
- Rebase onto net-next


Serge Semin (2):
  net: phy: realtek: Add rtl8211e rx/tx delays config
  net: phy: realtek: Change TX-delay setting for RGMII modes only

 drivers/net/phy/realtek.c | 70 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 4 deletions(-)

-- 
2.21.0

