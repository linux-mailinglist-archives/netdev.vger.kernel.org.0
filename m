Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964B73EF5C3
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 00:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbhHQWbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 18:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhHQWbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 18:31:37 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238CDC061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 15:31:04 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id n12so33717015edx.8
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 15:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5AqRswzpdfeCArGx75Klfv3MqK4XkpjK6Z1jQxgCBjc=;
        b=hoTzic6rqE0eK4CrIAYt8rQkeT8xO6uV/00duduog6aGueyCZTKz4HbpF14NTl8aYI
         TusnAGID6m+QOs6rVvP6zhrRWiWoOscJn19xVwERhcQuNAQHWMavhQZCJmHsDnzi5tt2
         Gg1fJjgZGmnHPAq3y8zK9OOGNKNbkDlmRnpxH0ynXNj8uSBauXPWIj5SQKQucmzY33zw
         nE7tPehaIYXZ/eOPcK4jIFqJ5AP7nsTo0KXMZ4K+hTuL9zdp4nr3bwb6r5Lc8A4iaEe9
         QYSxhKsS0SF/u56TgClWadRc8Y8n1rWKbhQi3AJBQd5FzmVIuE5hlV/K/Y1Ks54z3HIh
         eNag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5AqRswzpdfeCArGx75Klfv3MqK4XkpjK6Z1jQxgCBjc=;
        b=PgspHheEG3njI6A3kOEjMQMa1thY/1kVsKH+CAeQsGMhnTUeYKwsThPiCFJuaEPoz1
         QN8MZsQa9pTv3SM6U3fhAd4nYymr8jr5CP/GJjBZEQMvXlOwusk3c5fJX2e/vp5NrqC6
         2ZG9RqY6jZygIkcdvBIpSYkH6GXz37ahURu6qCtbfLpGTQXBF+HzN3KHqeC40uiqXZF9
         ds4TZbhKuU1Cz+z8Jm5mloqzrFr6K+hpBm4pe9EuIzIek3yfpwJeqx/R1Gl62Mo0yVMr
         tNa29RhwqCx1S65/+p1XqiIUKokiXEz23sZY3rpWncmdw/rF1T6NYSlV5NiR3wg3ga1T
         TrSg==
X-Gm-Message-State: AOAM531Q4+hjIO1ZqktJrwX1l2QB0FpWtWA9V5F+SZitgcvTRQO2tIMR
        0YWWpuIof9D3c1Rep0owtbw=
X-Google-Smtp-Source: ABdhPJxZb8TSbsFJ46TU857N2wfPPJ2BdcTGk1WfDcqrHfRrZOJPiH9ST+I56RmLDuiVr94MmEo7bQ==
X-Received: by 2002:aa7:d54f:: with SMTP id u15mr3808696edr.178.1629239462682;
        Tue, 17 Aug 2021 15:31:02 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id ck17sm1631776edb.88.2021.08.17.15.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 15:31:02 -0700 (PDT)
Date:   Wed, 18 Aug 2021 01:31:01 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
Message-ID: <20210817223101.7wbdofi7xkeqa2cp@skbuf>
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
 <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alvin,

On Tue, Aug 17, 2021 at 09:25:28PM +0000, Alvin Šipraga wrote:
> I have an observation that's slightly out of the scope of your patch,
> but I'll post here on the off chance that you find it relevant.
> Apologies if it's out of place.
>
> Do these integrated NXP PHYs use a specific PHY driver, or do they just
> use the Generic PHY driver?

They refuse to probe at all with the Generic PHY driver. I have been
caught off guard a few times now when I had a kernel built with
CONFIG_NXP_C45_TJA11XX_PHY=n and their probing returns -22 in that case.

> If the former is the case, do you experience that the PHY driver fails
> to get probed during mdiobus registration if the kernel uses
> fw_devlink=on?

I don't test with "fw_devlink=on" in /proc/cmdline, this is the first
time I do it. It behaves exactly as you say.

>
> In my case I am writing a new subdriver for realtek-smi, a DSA driver
> which registers an internal MDIO bus analogously to sja1105, which is
> why I'm asking. I noticed a deferred probe of the PHY driver because the
> supplier (ethernet-switch) is not ready - presumably because all of this
> is happening in the probe of the switch driver. See below:
>
> [   83.653213] device_add:3270: device: 'SMI-0': device_add
> [   83.653905] device_pm_add:136: PM: Adding info for No Bus:SMI-0
> [   83.654055] device_add:3270: device: 'platform:ethernet-switch--mdio_bus:SMI-0': device_add
> [   83.654224] device_link_add:843: mdio_bus SMI-0: Linked as a sync state only consumer to ethernet-switch
> [   83.654291] libphy: SMI slave MII: probed
> ...
> [   83.659809] device_add:3270: device: 'SMI-0:00': device_add
> [   83.659883] bus_add_device:447: bus: 'mdio_bus': add device SMI-0:00
> [   83.659970] device_pm_add:136: PM: Adding info for mdio_bus:SMI-0:00
> [   83.660122] device_add:3270: device: 'platform:ethernet-switch--mdio_bus:SMI-0:00': device_add
> [   83.660274] devices_kset_move_last:2701: devices_kset: Moving SMI-0:00 to end of list
> [   83.660282] device_pm_move_last:203: PM: Moving mdio_bus:SMI-0:00 to end of list
> [   83.660293] device_link_add:859: mdio_bus SMI-0:00: Linked as a consumer to ethernet-switch
> [   83.660350] __driver_probe_device:736: bus: 'mdio_bus': __driver_probe_device: matched device SMI-0:00 with driver RTL8365MB-VC Gigabit Ethernet
> [   83.660365] device_links_check_suppliers:1001: mdio_bus SMI-0:00: probe deferral - supplier ethernet-switch not ready
> [   83.660376] driver_deferred_probe_add:138: mdio_bus SMI-0:00: Added to deferred list

So it's a circular dependency? Switch cannot finish probing because it
cannot connect to PHY, which cannot probe because switch has not
finished probing, which....

So how is it supposed to be solved then? Intuitively the 'mdio_bus SMI-0:00'
device should not be added to the deferred list, it should have everything
it needs right now (after all, it works without fw_devlink). No?

It might be the late hour over here too, but right now I just don't
know. Let me add Saravana to the discussion too, he made an impressive
analysis recently on a PHY probing issue with mdio-mux, so the PHY
library probing dependencies should still be fresh in his mind, maybe he
has an idea what's wrong.

>
> It's not necessarily fatal because phy_attach_direct will just use the
> Generic PHY driver as a fallback, but it's obviously not the intended
> behaviour.
>
> Perhaps this affects your driver too? Due to lack of hardware I am not
> in a position to test, but a static code analysis suggests it may be if
> you are expecting anything but Generic PHY.

Yeah, rest assured, you're not the only one.
