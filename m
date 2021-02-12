Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0407631A388
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 18:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhBLRZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 12:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbhBLRZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 12:25:26 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A5AC061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 09:24:45 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id t5so558576eds.12
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 09:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o1Uh/a5lGOIR/LX0Oz//MViZJIn2v1/D7AeQ2eNArOw=;
        b=Jk0HjQJxwWK4a0h+DUBloYkcahgYdWwNkCeUcKVsqNutXQBQQ75wgKMLlpjRHp6wVT
         BVtt+WNgcEFsP/c+5aTMFfb4fGcso8lzk6rtuxiG665TcX8So3eq8Xsxzg5vF8O8m/W/
         PhzLgegv9XH/2npm3lz7DNti7nY1QPARNPbUW6WmVPELquODAftkCJ7TPb6+VV5ouPtR
         fR4bNFllXHrYlStpgntzzNtjdSQwVjhiQT+ja09F1KaguD2rCd6rPPFXu3vl1fV8UY8t
         RASwKJ4W3fhhtDNzRfn2fu9f0nSurufyKlx3NwAYhp4UgZrMxWoep+zLAZ/nZ4xNMbn8
         jpAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o1Uh/a5lGOIR/LX0Oz//MViZJIn2v1/D7AeQ2eNArOw=;
        b=QldROWSmilxxQ24MMtF1qLXo3nNZA4PybUrxOn+fdj373yo2K5JKljIgEiHLcdniON
         HJVDYHle8A4Irg3xR5xT67fcw3+n3r1+v/0onjGETLumtS0u/YDxBkxJ6pSzWYkj0Y9l
         +nd2IHEBd9qltkGk5qspTGfwcP2Pp22Cls8UXXvZQcs3lp6i/M6TzLpEw2WMcOwoLSym
         CMAdTUPCG4hBXB6iiVu4vvMUlwux+psBBEFXMqYIjckbSV4j2/hoqvotBNyjZakk5xIo
         smRKvLxIgFo01xlE6ZImHOWcbLpn1SXuMeypO6pT4llXL400pB1dDJDP0WgfNqzLdUgv
         knnA==
X-Gm-Message-State: AOAM533R6zstvLWMHXxNVg52lki5O0jZ/3aCj0JY/FoDgsOiZS4QXKWv
        4yRCLXbs7YJUU2rccNtJLbY=
X-Google-Smtp-Source: ABdhPJyGEn8y69SaXlF/nmzVfIwOHmIH5sNr+5XZj+/jK5L1fQhvTnv0yi0aWlGC7JKAKdJxLH45OQ==
X-Received: by 2002:aa7:da55:: with SMTP id w21mr4651223eds.138.1613150684462;
        Fri, 12 Feb 2021 09:24:44 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x25sm6061616edv.65.2021.02.12.09.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 09:24:44 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 0/2] Let phylink manage in-band AN for the PHY
Date:   Fri, 12 Feb 2021 19:23:39 +0200
Message-Id: <20210212172341.3489046-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This small series creates a configuration knob for PHY drivers which use
serial MII-side interfaces and support clause 37 in-band auto-negotiation
there.

Vladimir Oltean (2):
  net: phylink: explicitly configure in-band autoneg for PHYs that
    support it
  net: phy: mscc: configure in-band auto-negotiation for VSC8514

 drivers/net/phy/mscc/mscc.h      |  2 ++
 drivers/net/phy/mscc/mscc_main.c | 13 +++++++++++++
 drivers/net/phy/phy.c            | 12 ++++++++++++
 drivers/net/phy/phylink.c        |  8 ++++++++
 include/linux/phy.h              |  8 ++++++++
 5 files changed, 43 insertions(+)

-- 
2.25.1

