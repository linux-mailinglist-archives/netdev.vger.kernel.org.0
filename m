Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C073A3EF3
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 11:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbhFKJTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 05:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbhFKJTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 05:19:48 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BC5C061574;
        Fri, 11 Jun 2021 02:17:36 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id og14so3538292ejc.5;
        Fri, 11 Jun 2021 02:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tT/Yhme4HpUxJW8MmdpDHTWwIDpMbpzEcGbpZ+AnSGE=;
        b=oqrGz3C4XTzBWyPPlCOe7wKQomXhQCEyJTjuBZuI5ImLQ3TJD4Vh/LWqTMpeJ9iQXm
         4z++kNx0JE0vNMMXFfs6ozDm+zULaVpgIlZlb4zwvkrSeoIGtSiM1DYZu4PWz2Cr0wSm
         iB7LMHcATjL+sRL/4cnQVBXvLnnnyyPCjZBojIRZ4/tqldOsJaae+EZtMYIoOu7ddbtC
         +uiWcGCT0p5NbuBNhAQ+HsCUWyqmStS2JTVxA0h7pkXH331RNXNmjCwyTrLdsaHCeEmE
         lj8BMQw5Y4VBsEnDXusm65/nFHwQgwQhuvhtfPfkbZd6xMr+xTsqkhyTZn/G6m3Fxso4
         CxDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tT/Yhme4HpUxJW8MmdpDHTWwIDpMbpzEcGbpZ+AnSGE=;
        b=csIJG5+u+NjhwHCJORE3kdP+ouvIUvcWomY58m2agGnAbltOWIf22NZaQiImy8Kfgz
         hdHsCLVUMCtbiheE2hjG5DXp+iENnWzmqORmPBAVJlnl+LuDk9gMt19C0uycI8LJ22rV
         UqBn/id2vC4i+c/kD/C1uZzIhZV5zkqlnB2TZA9a4clKBtU4s00IvCoAEIdL1gBKbTDj
         pUVDiapEuNkHbJAnJe1qwtX0D3plpXo/1FOdCMBQsIr7Yc/V42Ue6WRblLGhlRQJZ5lj
         S/W0af7QEBBSOf7Uzz6Ov8gNk6vlH7A8HWazUkwvPJ+QrKDpOfjmrf2nzDCaU+CND1CD
         v+Yw==
X-Gm-Message-State: AOAM533pU/YELcdlJH/adjp8UPqU1dn7+w3fRUBAcn7sJu5PTxDttXJT
        Bte6TyHLXImmHIPUJS7LbqE=
X-Google-Smtp-Source: ABdhPJxL1EBhK72LCCLBXOmmSrmvpfplT+xDm4HCNYeQEmXEWq0ih+Xhk9nUoE0D3oE45Uf22v7chQ==
X-Received: by 2002:a17:906:c010:: with SMTP id e16mr2793715ejz.214.1623403055047;
        Fri, 11 Jun 2021 02:17:35 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id dy19sm2337908edb.68.2021.06.11.02.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 02:17:34 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Fri, 11 Jun 2021 12:17:32 +0300
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Calvin Johnson <calvin.johnson@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v8 00/15] ACPI support for dpaa2 driver
Message-ID: <20210611091732.wms3g3mnghvmcw3n@skbuf>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
 <CAHp75VfeyWYKRYuufd8CkCwjCWPRssuQVNfCSknnJWB9HvUcMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfeyWYKRYuufd8CkCwjCWPRssuQVNfCSknnJWB9HvUcMA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 12:00:02PM +0300, Andy Shevchenko wrote:
> On Thu, Jun 10, 2021 at 7:40 PM Ioana Ciornei <ciorneiioana@gmail.com> wrote:
> >
> > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> >
> > This patch set provides ACPI support to DPAA2 network drivers.
> >
> > It also introduces new fwnode based APIs to support phylink and phy
> > layers
> >     Following functions are defined:
> >       phylink_fwnode_phy_connect()
> >       fwnode_mdiobus_register_phy()
> >       fwnode_get_phy_id()
> >       fwnode_phy_find_device()
> >       device_phy_find_device()
> >       fwnode_get_phy_node()
> >       fwnode_mdio_find_device()
> >       acpi_get_local_address()
> >
> >     First one helps in connecting phy to phylink instance.
> >     Next three helps in getting phy_id and registering phy to mdiobus
> >     Next two help in finding a phy on a mdiobus.
> >     Next one helps in getting phy_node from a fwnode.
> >     Last one is used to get local address from _ADR object.
> >
> >     Corresponding OF functions are refactored.
> 
> In general it looks fine to me. What really worries me is the calls like
> 
> of_foo -> fwnode_bar -> of_baz.
> 
> As I have commented in one patch the idea of fwnode APIs is to have a
> common ground for all resource providers. So, at the end it shouldn't
> be a chain of calls like above mentioned. Either fix the name (so, the
> first one will be in fwnode or device namespace) or fix the API that
> it will be fwnode/device API.


These types of cyclic calls do not exist anymore.
The fwnode_mdio does not call back into of_mdio but instead it directly
implements any necessary operations using the fwnode_handle.

The only calls happening are 'of_mdio -> fwnode_mdio' so that we
leverage the common fwnode handling and do not duplicate code.

Ioana
