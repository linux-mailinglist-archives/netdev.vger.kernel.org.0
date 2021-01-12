Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D332F34C7
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404061AbhALPzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392072AbhALPzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 10:55:45 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD09CC061575;
        Tue, 12 Jan 2021 07:55:05 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id q7so1712115pgm.5;
        Tue, 12 Jan 2021 07:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cAG/VZYg1tbBVWV56Yza/FNpS4EtYQ911pPNLEyfbHs=;
        b=Ys1KzpZ+2UTQ9MULoo45Xeb2yGMin33tUSG8zraaH36nWyUwv4nhZfAbh3dQ9pBXSz
         rJa79m6ncPB8kZaHaNws7medrUAqpVMgX1IV2V8qkCTtzxs+geeHlrMf0wcY3QD6gkUt
         KD7u47jhGWw9uPdsJ8w/n/yz0ZZGV/1vXFmvwokvDTSgmTLo410s57X/3Qe2Z5jx1i3m
         lKkHq9HMd46wAQYciF72BEUH4tW6R0U2G6oYOg5dAVd/AESkKb0h71yZ3/34vynd6UxX
         JR15TiJOCkRp0ZXNJNqM78O/0GwSymOOSay/aZwTM1dmreGn1IaDvnEmo1t1LRgDacuZ
         ciXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cAG/VZYg1tbBVWV56Yza/FNpS4EtYQ911pPNLEyfbHs=;
        b=G/+3hp7H+aVDRyfdhQxHyt1vP+PMZrUWRi3q1Hc4uc36h20AEkNY4CDo2pP/aqH+r7
         FotAyLdTFu0pbAqhBozCJQVwn6wN1iMO+ePxE4oH2AK7ADOQBq7afm0/YT2ky3KwyQ9f
         c4tAIRcZSszo+fUxhVg1cfLAyjrHSUhmep0chW1J2TTC32CTNHOZktHgTw/tUQ4PVuHW
         0jHKRV3ygOrUDSOBwatDF6BCclNovnQcHVAM//rFs4ZMR9p+cSyUZ5bvyhNPHlFp4SJn
         u5pjKgYcFtvAHovItoxFvauoY1UlgE2pH9S+x6EXdSnSP2XkhaGUuV4GSm06KNGD9hYU
         uXtQ==
X-Gm-Message-State: AOAM530Ch3TQPVVUWq+UxscbGJP74ZMSgZCkcsRq9vOZ4B0ZsNgiW/pI
        OVq//b57D4dhVADIjLsoOGRpciX8+0ayd9ExpA8y7qzYvSY=
X-Google-Smtp-Source: ABdhPJylnNJb6p4QzUYV3be4VtwabqmTCYGcKZSPdOV//Zdu55bPMDH5jJjFhHWb1hGfAsS5f44HwiOdLy2oHUC3ZvY=
X-Received: by 2002:a63:74b:: with SMTP id 72mr5405532pgh.4.1610466905294;
 Tue, 12 Jan 2021 07:55:05 -0800 (PST)
MIME-Version: 1.0
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com> <20210112134054.342-14-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210112134054.342-14-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 12 Jan 2021 17:55:54 +0200
Message-ID: <CAHp75VcRDmQGfJ6ADJO8m4NvvenMaamNn8AYbYAyXV8JDy_b3w@mail.gmail.com>
Subject: Re: [net-next PATCH v3 13/15] phylink: introduce phylink_fwnode_phy_connect()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 3:43 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Define phylink_fwnode_phy_connect() to connect phy specified by
> a fwnode to a phylink instance.

...

> +       phy_dev = fwnode_phy_find_device(phy_fwnode);
> +       /* We're done with the phy_node handle */
> +       fwnode_handle_put(phy_fwnode);
> +       if (!phy_dev)
> +               return -ENODEV;
> +
> +       ret = phy_attach_direct(pl->netdev, phy_dev, flags,
> +                               pl->link_interface);
> +       if (ret)

Hmm... Shouldn't you put phy_dev here?

> +               return ret;

-- 
With Best Regards,
Andy Shevchenko
