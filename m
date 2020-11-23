Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565352C1905
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388006AbgKWWzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387788AbgKWWzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 17:55:47 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35ABEC0613CF;
        Mon, 23 Nov 2020 14:55:47 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id d18so18845416edt.7;
        Mon, 23 Nov 2020 14:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EFk0nJ4z1D5JbLIY8TqRxM5y3KT+VTwAl77Ny6IlPqg=;
        b=Dc3rEbK7XCvA71Jg+hUh6cPr7ZAsFWaPYkBwuFsb1XiAB6Q9yxAb4gak2gI+FchyG1
         AM8xjoGNkKyBGPYtLFgiQrpiAa1voF+c53J0oPe9MzF+SpIz12uGtlrTwAK0W8vm9PLN
         C7bg8jU/n8pLy0l2l9R5mO1cY7lmyhlggUfZYaPZLaznuwJTGx9o+54jkemUWDCRVana
         f2kA1uVu/ok55W6WGBJ2FGr4rLra5aSJ5/59nKM3FEqEvDA49R4Oz45dmWYX50rgZ88L
         etOVR0JudoP8ugIabe8VHVbJ9cKw0GROruVvqsIg+jDTeQFT7UIHMNl1TK66x2jaJdIA
         GY/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EFk0nJ4z1D5JbLIY8TqRxM5y3KT+VTwAl77Ny6IlPqg=;
        b=TYiZkTWys5vsBvRgyPI2Wre/8tCIjkr8wXJotHk5IrJFjFNSvfRalXIhocAZaa2Wg1
         plv+QeV5MSqG5D35BO4EhSqVW4DgNCyYvvESu7o5h1r94AY3cdkNXY7z1RTM9AYYom3a
         9zYQs1sV6Yd1yJWQa4ZklnTJr0Sndy4QYx3oezrikcuA6WqLKL0Zyr7Kq4mzmNL7vfYX
         6F0eMVKXvjCOGteIrAucEdFx/lILNzdO3uaB2PTJSqQfQRUb6MZc2UIObXDZ5BGNpoDg
         4ECCcn4OKbUUcoQxzfrVtUT2RUEZ/ufvLsjppUpIUojOyJnzbkDOL4DeGRHHqS+ZYtVR
         jlcg==
X-Gm-Message-State: AOAM5317Vx89s19tUowr4gS8hf1ON00Ckv5ozJQfUjrXCNFXmn5lF+gf
        YStggHWjXBR0BxqKbKe+2Y4=
X-Google-Smtp-Source: ABdhPJwiXGuZBCQvzN/kDyDf2ONIRRegWP7tMpmvsh+S8w2cH6t1+Ad0Pf5LV2T7vb7iN2009tTecA==
X-Received: by 2002:a50:ed8d:: with SMTP id h13mr1378936edr.180.1606172145920;
        Mon, 23 Nov 2020 14:55:45 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rs27sm5108616ejb.34.2020.11.23.14.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 14:55:45 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Tue, 24 Nov 2020 00:55:44 +0200
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Ioana Ciornei <ciorneiioana@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/15] net: phy: add support for shared
 interrupts (part 3)
Message-ID: <20201123225544.bywwgcoa75kmapad@skbuf>
References: <20201123153817.1616814-1-ciorneiioana@gmail.com>
 <CAFBinCBhWKzQFwERW9cy7T4JdOdFwNOqn2qPqFpqdjbat=-DwA@mail.gmail.com>
 <20201123143713.6429c056@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123143713.6429c056@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 02:37:13PM -0800, Jakub Kicinski wrote:
> On Mon, 23 Nov 2020 23:13:11 +0100 Martin Blumenstingl wrote:
> > > Ioana Ciornei (15):
> > >   net: phy: intel-xway: implement generic .handle_interrupt() callback
> > >   net: phy: intel-xway: remove the use of .ack_interrupt()
> > >   net: phy: icplus: implement generic .handle_interrupt() callback
> > >   net: phy: icplus: remove the use .ack_interrupt()
> > >   net: phy: meson-gxl: implement generic .handle_interrupt() callback
> > >   net: phy: meson-gxl: remove the use of .ack_callback()  
> > I will check the six patches above on Saturday (due to me being very
> > busy with my daytime job)
> > if that's too late for the netdev maintainers then I'm not worried
> > about it. at first glance this looks fine to me. and we can always fix
> > things afterwards (but still before -rc1).
> 
> That is a little long for patches to be hanging around. I was planning
> to apply these on Wed. If either Ioana or you would prefer to get the
> testing performed first, please split those patches out and repost once
> they get validated.

If there is no issue reported in the meantime, I would say to apply the
series. I can always quickly fixup any problems that Martin might find.

Ioana
