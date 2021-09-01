Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E493FD5D9
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 10:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241682AbhIAIr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 04:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237776AbhIAIr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 04:47:26 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DD4C061575;
        Wed,  1 Sep 2021 01:46:29 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 79-20020a1c0452000000b002e6cf79e572so4172359wme.1;
        Wed, 01 Sep 2021 01:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3MqjrXv7k3uuko/eQ/lGNHIjBDo+94vpoWI76Pj0sR8=;
        b=eOSOCO4YqfN5KUTyr7mS7jPAyhQSODgLopOH4xBqiBQEBDCXJpR+sbz69iC/Trx8CX
         xvdRdhg1FSuFxkJO4X404bmr4E7pC1ktHsrqI48IxutANJTu/hIIjfmu99vzA7AXr45A
         P2nQCbhxMQ5BUcNa9Z5JazNwYbvLyeJuSiigLXSG1Mvf75IYZRXsReLVw8bw/m17lEBn
         YrVyQNJaIJA9KHHsivB9lOig74VA+nNCOPFgQmIPtjKFNIE4Blg2RYX39ynd3XJK6Cq5
         5eHXR4ptNfkgXOTrecLj4BHAGD6HH854H8wMPaQCJXAjA5l0lHRDK78h8GdUL14+hQja
         ufJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3MqjrXv7k3uuko/eQ/lGNHIjBDo+94vpoWI76Pj0sR8=;
        b=Cq3GNIjcSljiXRMA5L0UDUlnJANIRrtKKhgIkSTHiPxzWi7OMMwY7vd2UtvOzRd3rF
         6jkKU83+06t7qToSfuOdCcHjlqFnIXVmahASrIL2GPvN21Qc19vsXnxLe8JsEJNdH3Bk
         AhMj7EKG8yCT5lK9EMVW6Dl4w4rLqozQlqa0Yl7/XnICiLB7N+GOU3+B3GwD4AELJW4M
         N3I+b9JwpJBHmF0wib6EU9lSxpyKZgzxe9GJq8W6RbGAfAO86FeH+IfhZhq5Vsz8zPFu
         F3ppnJS6gOh9wbHhTOl9xhZr9+HD14YXgl9t7BmsPSWa7vGrdyIcGTglVnl7DK2pL/By
         /ERQ==
X-Gm-Message-State: AOAM533ETPveM9+RPIQI9IWruk3nYFhx8inDdJGWQlnV3xqU9u3+beSU
        4/dZquWhR0YtGN0r8c2wsLk=
X-Google-Smtp-Source: ABdhPJwS8JofpHU3SjfWn8wvkG3n+JFB2TP+Gh7MHX/8EiGC072RBDhhczqf8J8mzyGI7KjiffMcMg==
X-Received: by 2002:a05:600c:3b9c:: with SMTP id n28mr8539044wms.184.1630485987703;
        Wed, 01 Sep 2021 01:46:27 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id n18sm4587967wmc.22.2021.09.01.01.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 01:46:27 -0700 (PDT)
Date:   Wed, 1 Sep 2021 11:46:25 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <20210901084625.sqzh3oacwgdbhc7f@skbuf>
References: <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch>
 <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch>
 <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch>
 <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
 <YS608fdIhH4+qJsn@lunn.ch>
 <20210831231804.zozyenear45ljemd@skbuf>
 <CAGETcx-ktuU1RqXwj_qV8tCOLAg3DXU-wCAm6+NukyxRencSjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx-ktuU1RqXwj_qV8tCOLAg3DXU-wCAm6+NukyxRencSjw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 07:00:58PM -0700, Saravana Kannan wrote:
> On Tue, Aug 31, 2021 at 4:18 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Wed, Sep 01, 2021 at 01:02:09AM +0200, Andrew Lunn wrote:
> > > Rev B is interesting because switch0 and switch1 got genphy, while
> > > switch2 got the correct Marvell PHY driver. switch2 PHYs don't have
> > > interrupt properties, so don't loop back to their parent device.
> >
> > This is interesting and not what I really expected to happen. It goes to
> > show that we really need more time to understand all the subtleties of
> > device dependencies before jumping on patching stuff.
> >
> > In case the DSA tree contains more than one switch, different things
> > will happen in dsa_register_switch().
> > The tree itself is only initialized when the last switch calls
> > dsa_register_switch(). All the other switches just mark themselves as
> > present and exit probing early. See this piece of code in dsa_tree_setup:
> >
> >         complete = dsa_tree_setup_routing_table(dst);
> >         if (!complete)
> >                 return 0;
> >
> > So it should be a general property of cross-chip DSA trees that all
> > switches except the last one will have the specific PHY driver probed
> > properly, and not the genphy.
> >
> > Because all (N - 1) switches of a tree exit early in dsa_register_switch,
> > they have successfully probed by the time the last switch brings up the
> > tree, and brings up the PHYs on behalf of every other switch.
> >
> > The last switch can connect to the PHY on behalf of the other switches
> > past their probe ending, and those PHYs should not defer probing because
> > their supplier is now probed. It is only that the last switch cannot
> > connect to the PHYs of its own ports.
> 
> I'm not saying this with any intention of making things easier for me
> (I'm not even sure it does). But your description about how multiple
> switches are handled by DSA has me even more convinced than before
> that DSA needs to use a component device model. This is like the
> textbook example for component devices.

In this example, I guess the component master would be the "struct dsa_switch_tree",
but there is no struct device associated with it.

How many "struct dsa_switch_tree" instances there are in a system
depends on whether OF is used or not.

If we use OF, the device tree needs to be parsed, and every unique first
cell (tree-id) of:
	dsa,member = <tree-id switch-id>;
constitutes a different "struct dsa_switch_tree".

If we do not use OF, the number of switch trees in a system is one, see dsa_switch_parse.

It seems to me like the compare function for component_match (where each
component is a "struct dsa_switch" should look at dev->of_node and parse
the "dsa,member" property again, and match on the same tree-id as the
component master itself?

There's also the question of how to do the component_match in a way that
also works for the pdata/non-OF based DSA systems (of which I have none to test).

All of this to move dsa_tree_setup() outside of the probe calling
context of any individual struct dsa_switch, and into the "bind" calling
context of the component master associated with the struct dsa_switch_tree.
This would allow the phy_connect()/phy_attach_direct() calls to find the
PHY device already bound to the specific driver, which would avoid
binding genphy as a last resort?

Two questions:

- Why would it now be more guaranteed that the PHY drivers are bound to
  the internal PHY devices exactly during the time span between events
  (a) Switch driver (a component of the switch tree) finishes probing
  (b) Switch tree (the component master) starts binding
  I mean in lack of any guarantee, we can still end up in a situation
  where the specific PHY driver still is not bound early enough to the
  internal PHY to be available by the time we call phylink_of_phy_connect,
  and we have all those component device goodies but they don't help.
  I'm sure I'm misunderstanding something but I don't know what.

- What if the internal PHY has other suppliers beyond the interrupt-parent?
  What if, say, it has a reset-gpios = <&gpio1>, where gpio1 is provided
  by some other thing on some other slow bus, which is equally slow (or
  slower) to probe to the DSA switch itself. So the temporary absence of
  this other supplier is causing the specific PHY driver to defer probing,
  just enough for a concurrent call to phylink_of_phy_connect -> phy_attach_direct
  to say "ok, I've waited enough and there is no driver, genphy it is".
  How would this be avoided? Or are you thinking of some kind of two-level
  component driver system:
  - the DSA switch is a component master, with components being its
    sub-devices such as internal PHYs etc
  - the DSA switch is also a component of the DSA switch tree
  But in that case, why is it even relevant to model the DSA switch tree
  probing as a component master, and why does it help? I don't care if
  it's a "textbook example" or not if it doesn't help.
