Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EB734BD69
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 19:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhC1RAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 13:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbhC1RAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 13:00:32 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0FC2C061756;
        Sun, 28 Mar 2021 10:00:31 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id u5so15844641ejn.8;
        Sun, 28 Mar 2021 10:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iFleiHqMvSW0dwaax0zr0sTVJIq2DCcesrbPBuTNPqA=;
        b=TXs7T7vcVfexe/mb3vs67nh2EDXR8vrfwW8CYcdLxZMZftEbW5uKzQK1l4OiZf0bJb
         fLN5N4beeDqz7iy7YIwgviPx/c0PoPqThf5jGS/hlQ4domEnd2b+/VkFrC4BieeQxemw
         PEXf9vxKPqeXnCJ5grz9yYOgXKUGFHD7Ov1iItbwSASrqR5Idf1wgC83yB8nzEyxs5xZ
         z++6WCOhHhLIGX5j8O9ufqJKVmwcXWylcw3MLtz6JNMLSNPtfMgYMzQ8UTbbrcURR2US
         AFIPFyU7lVKLFztd49rP3XyJ10GUe03Vx2pX+N4cee/BMYy8hC/rsvZSzloQj7vtfKzF
         l4NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iFleiHqMvSW0dwaax0zr0sTVJIq2DCcesrbPBuTNPqA=;
        b=h+k2/Wsvx7fzKYE0um/r5MVSmza+NlimBUCxK24I8qJ0rfLqsrOJer6x1EFvr0rafC
         zKQeACmzQSyRETCk0BFV9EaeiVIDH3f6a9BRxnWkfnIRe6oF+hU4jTxrwLiiuElYxrit
         hr/e7W6kyR7a/RXcA/ChnxtNiGbBsT33/bB8Irbw7mWVrxNUxIsFfvOFzvIyg2bwPcxG
         FxpPhrwxkfIHEmYq9Gog22paQ1xgO3fCbbEOa1GsJ0WLHBrh5VIjFwZjuW7TffnbY3nw
         4mm9DkKzcAg9E+SBxR33QlydOl1tLKMAmQvbIG0rvtTG8i4LEH9vOLKkST8PtSo6/KKr
         Xz+w==
X-Gm-Message-State: AOAM533k+rCzapr+E15dZ6tTtih+y7s/BAIuTfd+yW3aocU+ZgrYc+Hd
        FJHv3GK5Gd3SwgjObR8PRjhdtyqqAYjIYh5jWjo=
X-Google-Smtp-Source: ABdhPJwfoJzT0o+Gfkt/vy/UAy7F2Or9RgOc2NhejR6MvtqcmLoHrtiTcFWmtwQYVmyhXmVvTCVg1D/odxx3qWD/gwc=
X-Received: by 2002:a17:906:6bd1:: with SMTP id t17mr25375308ejs.319.1616950830572;
 Sun, 28 Mar 2021 10:00:30 -0700 (PDT)
MIME-Version: 1.0
References: <MWHPR18MB14217B983EFC521DAA2EEAD2DE649@MWHPR18MB1421.namprd18.prod.outlook.com>
 <YFpO7n9uDt167ANk@lunn.ch> <CA+sq2CeT2m2QcrzSn6g5rxUfmJDVQqjYFayW+bcuopCCoYuQ6Q@mail.gmail.com>
 <YFyHKqUpG9th+F62@lunn.ch> <CA+sq2CfvscPPNTq4PR-6hjYhQuj=u2nmLa0Jq2cKRNCA-PypGQ@mail.gmail.com>
 <YFyOW5X0Nrjz8w/v@lunn.ch>
In-Reply-To: <YFyOW5X0Nrjz8w/v@lunn.ch>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Sun, 28 Mar 2021 22:30:18 +0530
Message-ID: <CA+sq2CeRjJNaNbZhs17LDrBtyvR_fb3uN=Wd=j9sLHJapVB50A@mail.gmail.com>
Subject: Re: [net-next PATCH 0/8] configuration support for switch headers & phy
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Hariprasad Kelam <hkelam@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 6:51 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Mar 25, 2021 at 06:32:12PM +0530, Sunil Kovvuri wrote:
> > On Thu, Mar 25, 2021 at 6:20 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > > So you completely skipped how this works with mv88e6xxx or
> > > > > prestera. If you need this private flag for some out of mainline
> > > > > Marvell SDK, it is very unlikely to be accepted.
> > > > >
> > > > >         Andrew
> > > >
> > > > What we are trying to do here has no dependency on DSA drivers and
> > > > neither impacts that functionality.
> > >
> > > So this is an indirect way of saying: Yes, this is for some out of
> > > mainline Marvell SDK.
> > >
> > > > Here we are just notifying the HW to parse the packets properly.
> > >
> > > But the correct way for this to happen is probably some kernel
> > > internal API between the MAC and the DSA driver. Mainline probably has
> > > no need for this private flag.
> > >
> > >    Andrew
> >
> > Didn't get why you say so.
> > HW expects some info from SW to do the packet parsing properly and
> > this is specific to this hardware.
>
> Anything which needs out of mainline code is going to be rejected,
> unless you can show there is an in mainline use case as well. Which is
> why i keep pointing you to mv88e6xxx and prestira. That provides the
> necessary {E}DSA tags. You have an mv88e6xxx and prestira switch being
> controlled by Linux with DSA tagged frames flowing out of it into your
> MAC driver. What is the big picture use case that requires this
> private flag to enable DSA parsing? Why don't the MAC driver and the
> DSA driver just talk to each other, and setup the parsing?
>
>         Andrew

The usecase is simple, unlike DSA tag, this 4byte FDSA tag doesn't
have a ethertype,
so HW cannot recognize this header. If such packers arise, then HW parsing will
fail and RSS will not work.

Hypothetically if we introduce some communication between MAC driver
and DSA driver,
wouldn't that also become specific to the device, what generic usecase
that communication
will have ?

Thanks,
Sunil.
