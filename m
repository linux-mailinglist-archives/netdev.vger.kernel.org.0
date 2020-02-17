Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 829D8161C55
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 21:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbgBQUeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 15:34:20 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39178 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgBQUeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 15:34:19 -0500
Received: by mail-wm1-f65.google.com with SMTP id c84so628696wme.4
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 12:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=q1766iwbie+Q38zRxH2SRD2akW1NwT6qFOBnY2Nv0Ss=;
        b=KwCJisVlBElKtM8HQ7LyW9FovkDS06cqjfTuTlQpBoAF9THClyhyFLwlZQZreIDP1V
         1AySiswnKLgcdojoSX8E+dORrJ/yvuw5VnzwBqZbQenmBotPEvz7GA0jW13Lhdabbh/v
         2+GHLSlqEK+S/c23QEU1uSeCcDGUJZ1h8WUfCMWUtAKL3VlH55QhoYUHlVbOhsz8r8Ta
         MW4bSUMjuOHDOx3jAS20vrQM7fjhfS1ZAVhorU4kjBRqgkqchIkG/u3m/jFHRh41e2o+
         OrNdKkij29v+W5na5ew72465WhciBcTZ1rAJyyVTjID9hTdP4+kXLXn7vChCiPYYB/Bc
         elZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=q1766iwbie+Q38zRxH2SRD2akW1NwT6qFOBnY2Nv0Ss=;
        b=gtf3oxtdqrmD+H8KZBBKNMjU79NyL8iFb6Hxe3L5KVEre1+dnQl8oeVYOUFjhbaGl6
         1eDmO/Fv5hxjxLkyzC6Y+plo0CFdC+j/O29OI0ZOPBk4tGjfCS2AKOP3KvyLy6bc+y3H
         RmlBC3mpc5SwqS6+u728HH06+rTj3jupZ6ks0q4vrfxGPcl3xwy9bN6ALjIPu++AKeA5
         V+uwxD0xNmYccqbh0tnfEjCan9UMMmXN71v8mNCYDQh+lGjmMhZil19u0maEOxBxujFE
         PWvr3obQrHpFIIaEZ/rX7+h+TKZrUsKwFLaKct6oTjizb5aZk+ZLZFRcl3ZIP+mNpckH
         uf3A==
X-Gm-Message-State: APjAAAWZgl0+cUJ8tHtoGOqmOdz0AV80LWXAtTN5oWoCvAAXD7iAQrCE
        IjnoJDQbD1KSLinqVS9xvkgW4QHz
X-Google-Smtp-Source: APXvYqwa+3RAhLUtRCtS1I7EyOITdUr3XV5ENjl3S4mAuVHTIn0Qo0t+uk78bzXiUgYqlWNDu4hJBg==
X-Received: by 2002:a1c:20d6:: with SMTP id g205mr786749wmg.38.1581971656965;
        Mon, 17 Feb 2020 12:34:16 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:41c6:31a6:d880:888? (p200300EA8F29600041C631A6D8800888.dip0.t-ipconnect.de. [2003:ea:8f29:6000:41c6:31a6:d880:888])
        by smtp.googlemail.com with ESMTPSA id l2sm735132wme.1.2020.02.17.12.34.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 12:34:16 -0800 (PST)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] net: phy: unregister MDIO bus in
 _devm_mdiobus_free if needed
Message-ID: <15ee7621-0e74-a3c1-0778-ca4fa6c2e3c6@gmail.com>
Date:   Mon, 17 Feb 2020 21:34:10 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If using managed MDIO bus handling (devm_mdiobus_alloc et al) we still
have to manually unregister the MDIO bus. For drivers that don't depend
on unregistering the MDIO bus at a specific, earlier point in time we
can make driver author's life easier by automagically unregistering
the MDIO bus. This extension is transparent to existing drivers.

Heiner Kallweit (2):
  net: phy: unregister MDIO bus in _devm_mdiobus_free if needed
  r8169: let managed MDIO bus handling unregister the MDIO bus

 drivers/net/ethernet/realtek/r8169_main.c | 11 ++---------
 drivers/net/phy/mdio_bus.c                |  7 ++++++-
 2 files changed, 8 insertions(+), 10 deletions(-)

-- 
2.25.0

