Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB551C97B8
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 19:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgEGR1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 13:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726222AbgEGR1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 13:27:52 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6C4C05BD43;
        Thu,  7 May 2020 10:27:51 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id v63so3307695pfb.10;
        Thu, 07 May 2020 10:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sI6MW+ENUHkNJh2ieEfqb2bnhAZ3RCNTWxJcYdnJPQ0=;
        b=fw6712JF9/XP6LQunEFLYb0L3Hu5ZvOjiwZaYjUOYARWSTU6cUpPwT1mREY73Q0lcz
         Ux/KeXELOEUHJXhu+fQdD2m+PvZLEgLRXD9LHp5MtiJP9eimFksIXjI/cy3nfvc3vo6c
         EnHUBiCI3w93ddm9j9zO6dnfk9CkchHGY/+2IAZNTQoXNwBPgeZyh71Spr8dvDJIyw/+
         UbXKl1uzTrdWUsPYYMIzS4tnSCKePPqGcXUK7g5HcX9zheTZs6yjaODjo8LMj7+RYfuG
         Z0ayJgokLlO3FWlitIERjSFHHzD510h8OGBamTktyIiycyrQAc/XdIxYy0AJQpUE4o6R
         lJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sI6MW+ENUHkNJh2ieEfqb2bnhAZ3RCNTWxJcYdnJPQ0=;
        b=Fo3tyPYzLH09wk65N029Gl23MuTtFwe8juh7+QRzBV/XCGrV7fKqG5oS5JbAznQAMp
         4XziOia+nCLZsOUOZYgPxpglTHhWpmalCuhCZXmMq1eMw+z4XMjUHcLokSk8YaOaZAGd
         hqWp71FWc/2dA8bgEyBNNzGxvM1E+hvR08Q1+Xt6u67lNKt7c+HY7g8Q8EhVoPSa/Vze
         Aqrov8i7lr9OsjYA0B51R1WVW9MrWHnwQU8MPwT2LJA4JZb/Q7/sh8U/r4iHCTwkkLJw
         kUqYXzjOJ7PlvkV/vS1Pa1d1CLHo25RWIfCWSzhaxE4wMF2LKNcEVg4mkpE5d+jndaMD
         kLWQ==
X-Gm-Message-State: AGi0PubCWR604p4UBy0gWOgsAc6ZasAqwacVQbQg+lreVLPLWTx2XNdA
        +n5IymJZKAU7qvFsz+GI8yGSlHxGJjgzsllOYG4=
X-Google-Smtp-Source: APiQypI7YgiQ9vvHBaf8ZcHCNpabxiuE+6U2dZsbLwFTkafu86kfC64HTxUYw0xpEU0ELMf7TkAsxj3N30X42MNPPSc=
X-Received: by 2002:aa7:8f26:: with SMTP id y6mr15059528pfr.36.1588872471304;
 Thu, 07 May 2020 10:27:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200505132905.10276-1-calvin.johnson@oss.nxp.com>
 <20200505132905.10276-5-calvin.johnson@oss.nxp.com> <67e263cf-5cd7-98d1-56ff-ebd9ac2265b6@arm.com>
In-Reply-To: <67e263cf-5cd7-98d1-56ff-ebd9ac2265b6@arm.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 7 May 2020 20:27:44 +0300
Message-ID: <CAHp75Vew8Fh6HEoOACk+J9KCpw+AE2t2+oFnXteK1eShopfYAA@mail.gmail.com>
Subject: Re: [net-next PATCH v3 4/5] net: phy: Introduce fwnode_get_phy_id()
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        linux.cj@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 7, 2020 at 4:26 PM Jeremy Linton <jeremy.linton@arm.com> wrote:
> On 5/5/20 8:29 AM, Calvin Johnson wrote:

> > +             if (sscanf(cp, "ethernet-phy-id%4x.%4x",
> > +                        &upper, &lower) == 2) {
> > +                     *phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
> > +                     return 0;
> > +             }

> Isn't the ACPI _CID() conceptually similar to the DT compatible
> property?

Where?

> It even appears to be getting used in a similar way to
> identify particular phy drivers in this case.

_CID() is a string. It can't be used as pure number.

-- 
With Best Regards,
Andy Shevchenko
