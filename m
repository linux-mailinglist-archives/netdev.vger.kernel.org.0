Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBF8C28B33
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 22:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387649AbfEWUBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 16:01:39 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37232 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387414AbfEWUBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 16:01:39 -0400
Received: by mail-ed1-f67.google.com with SMTP id w37so10908171edw.4
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 13:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=80zf75DdX5M3jvMYUCTei7zky28CQX5+iLZa0ltqO78=;
        b=Ad74pGSaQTvbbkd84Drq16Rsvx6+eF6OOFve7QkHMCeuUgf5K38D7h9aQQGRapEryT
         DJrFTJDZe+++bjGbT796RGOF9gfP+lZyN2Jl4Qojs33lVq+WLtVM0miK/WpqD12IC9MG
         8QMDNxk6cLCB50P4AmuFIDA1ZDbx6j5fiMZYQz1whomFfrvLc6M0gzhzELlQaXmXZ8L8
         RLUJOCpAEEc10gOrdMLS2alNvET0Xh1CzzHIWTQXGWr9UhggUGqp3UyeCruA7bqg5Vip
         97+rsrugNJgR702OvHVCuiutUNUNm0DmpgyB5UfaPahHp8HipaHTmUBfE/TuC2j2titA
         d6bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=80zf75DdX5M3jvMYUCTei7zky28CQX5+iLZa0ltqO78=;
        b=sIaun/GA/LVai2LiPRU3eq9DGPaR5PyvaoIJN4ZDl5d7rYFp6PvD3NOAVgoYITfvsn
         KzAzrXUKJHKxmPwQmvU+BKLmPFHRm+RcbTvmCiEj949ZIMKWAI6dBpgN9N1dYYSVRIvH
         tFNKhKcLi+ZrsAHxdqXXfWD7YQBiZVXihth8+fy4lm0i4WFhvKz6ejy8BygjXrU9sJ96
         7xJ+J/t7QtimmMnUbRoH8eK7UnOScb6YZ2GWA3M7kuD4UUeUh6ZnjdC5AMXVVmAvlWza
         qlypVxN0FjiwA3Zc8HSxlxW3ncYDqi0Xdb8Tc0frQ1uSpeBANp8xhPP8jK2HLja21IAq
         /Iug==
X-Gm-Message-State: APjAAAXirk7FEY3F0+SoNAP5sysoHXZhqVWXs7tlGgJa7bw0nqZ5h9XW
        T5CU9QzRR/nL+gx9egtRQfLVyn7ZKPH53ItvY9g=
X-Google-Smtp-Source: APXvYqwdhnc0Fxf9lpDKS7kWZuoXlqM1X2JzOJvVk06msCej66qRxt0lO3eoOQ8hTOf/I9BFr5x0dFWgol1fsrOqK/s=
X-Received: by 2002:a17:906:69cb:: with SMTP id g11mr35246591ejs.29.1558641697318;
 Thu, 23 May 2019 13:01:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190523011958.14944-1-ioana.ciornei@nxp.com> <20190523011958.14944-9-ioana.ciornei@nxp.com>
 <9c953f4f-af27-d87d-8964-16b7e32ce80f@gmail.com>
In-Reply-To: <9c953f4f-af27-d87d-8964-16b7e32ce80f@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 23 May 2019 23:01:26 +0300
Message-ID: <CA+h21hpPyk=BYxBXDH5-SGfJdS-E+X9PfZHAMLYNwhL-1stumA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 8/9] net: dsa: Use PHYLINK for the CPU/DSA ports
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 at 05:17, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 5/22/2019 6:20 PM, Ioana Ciornei wrote:
> > This completely removes the usage of PHYLIB from DSA, namely for the
> > aforementioned switch ports which used to drive a software PHY manually
> > using genphy operations.
> >
> > For these ports, the newly introduced phylink_create_raw API must be
> > used, and the callbacks are received through a notifier block registered
> > per dsa_port, but otherwise the implementation is fairly
> > straightforward, and the handling of the regular vs raw PHYLINK
> > instances is common from the perspective of the driver.
> >
> > What changes for drivers:
> >
> > The .adjust_link callback is no longer called for the fixed-link CPU/DSA
> > ports and drivers must migrate to standard PHYLINK operations (e.g.
> > .phylink_mac_config).  The reason why we can't do anything for them is
> > because PHYLINK does not wrap the fixed link state behind a phydev
> > object, so we cannot wrap .phylink_mac_config into .adjust_link unless
> > we fabricate a phy_device structure.
>
> Can't we offer a slightly nicer transition period for DSA switch drivers:
>
> - if adjust_link and phylink_mac_ops are both supported, prefer
> phylink_mac_ops
> - if phylink_mac_ops is defined alone use it, we're good
> - if adjust_link alone is defined, keep using it with the existing code
> but print a warning inviting to migrate?
>
> The changes look fine but the transition path needs to be a little more
> gentle IMHO.
> --
> Florian

Hi Florian,

Yes we could, but since most of the adjust_link -> phylink_mac_ops
changes appear trivial, and we have the knowledge behind b53 right
here, can't we just migrate everything in the next patchset and remove
adjust_link altogether from DSA?
...So why does b53 configure the SGMII SerDes in phylink_mac_config,
and RGMII delays for the CPU port in adjust_link? Why are pause frames
only configured for the CPU port?
A migration from my side would be rather mechanical, so could you
please share some suggestions?

-Vladimir
