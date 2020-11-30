Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4262C89FB
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 17:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbgK3Qx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 11:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgK3Qx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 11:53:28 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E1FC0613D4;
        Mon, 30 Nov 2020 08:52:48 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id 11so11905842oty.9;
        Mon, 30 Nov 2020 08:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3WA540gSHh8kQNe0lWG+yli/wrKJPqlogKyvN8EdAR0=;
        b=KTWXa6hK5yeoleLSGEzoPfOiFalYXKt2bSNkbLFYPcRQIsZt+JdyjG++UWPySpxpQ+
         5TXPQcRXjv0DvLrZ3gGwHRXLmmCSiKwCPvdqkc2n9jplKmEOfTrmkjCEzmeI/iGMhy3J
         zDgxn0BZ4JBFyhAoPJOCFPieYnfIENezF/8PADY9HBAd6Vpo4jMhPzNPY/rZCuFXoLb2
         n7rqFzSh8yJPu1amSqOwer9+jgV+1NMSe5VeOsVJxCFC90PtDiyGvJDgGd5Y5hgi9kaS
         QW9ykI29mhYIdGY6yZ3WZWZKBGunxov1xkm2G1+GjDHMYGMlD5A5h/s7VKSAdyi1GicF
         xp8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3WA540gSHh8kQNe0lWG+yli/wrKJPqlogKyvN8EdAR0=;
        b=jkjXn4/2iZpTij1eEpwJcxoajTvjXZaCYcljQnzQ5jmlGfriNgqkDq3j8LcA41TI6P
         1j9OFkFRU/4AnE/y8ChnR2+dpGR5Qww2WO16rOt5A+rM2fcs9ks8qg0Ox1F/1VZODfBA
         eEWiFBoOwvPGc2GINs4wp/nAusd+DjwD5CxcydCJkmW/kIgeiXjLS3xntHP+Ak5y2lri
         7mNSqUwgEOA7+HH3x+DHPIRc/h3do1cbTYZn8gXCX+WeM7ZdlI2YcX8N97nYF4RHF208
         NYJh7Yh9ECX8lBXbinq4KM/p4i5nEV16kcn//feoA8Lm+0FaavmU3bGyx8Da/lQCRdg9
         fM8w==
X-Gm-Message-State: AOAM532H2+3SR1VyOoZY++d2CdR2942ecqYMc4YkPihKM2evJQJARfGG
        1xyAkCYTOAF2BhMY+qeh/yoVEXK93MiG07/TyeE2KsfV2g==
X-Google-Smtp-Source: ABdhPJy2y/TGo8SvnA68QX0kOXVSSywHbstLw2XAyMQNOLwB1TnHZb6CwaZo4HB3Jk1cbHjd/yhDtb+EXiWOIamw3JA=
X-Received: by 2002:a9d:4713:: with SMTP id a19mr17913519otf.132.1606755168216;
 Mon, 30 Nov 2020 08:52:48 -0800 (PST)
MIME-Version: 1.0
References: <20201126220500.av3clcxbbvogvde5@skbuf> <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAFSKS=MAdnR2jzmkQfTnSQZ7GY5x5KJE=oeqPCQdbZdf5n=4ZQ@mail.gmail.com>
 <20201127195057.ac56bimc6z3kpygs@skbuf> <CAFSKS=Pf6zqQbNhaY=A_Da9iz9hcyxQ8E1FBp2o7a_KLBbopYw@mail.gmail.com>
 <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201127233048.GB2073444@lunn.ch> <20201127233916.bmhvcep6sjs5so2e@skbuf>
 <20201128000234.hwd5zo2d4giiikjc@skbuf> <20201128003912.GA2191767@lunn.ch>
 <20201128014106.lcqi6btkudbnj3mc@skbuf> <20201127181525.2fe6205d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201127181525.2fe6205d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 30 Nov 2020 10:52:35 -0600
Message-ID: <CAFSKS=O-TDPax1smCPq=b1w3SVqJokesWx02AUGUXD0hUwXbAg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 8:15 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 28 Nov 2020 03:41:06 +0200 Vladimir Oltean wrote:
> > Jakub, I would like to hear more from you. I would still like to try
> > this patch out. You clearly have a lot more background with the code.
>
> Well, I've seen people run into the problem of this NDO not being able
> to sleep, but I don't have much background or knowledge of what impact
> the locking will have on real systems.
>
> We will need to bring this up with Eric (probably best after the turkey
> weekend is over).
>
> In the meantime if you feel like it you may want to add some tracing /
> printing to check which processes are accessing /proc/net/dev on your
> platforms of interest, see if there is anything surprising.
>
> > You said in an earlier reply that you should have also documented that
> > ndo_get_stats64 is one of the few NDOs that does not take the RTNL. Is
> > there a particular reason for that being so, and a reason why it can't
> > change?
>
> I just meant that as a way of documenting the status quo. I'm not aware
> of any other place reading stats under RCU (which doesn't mean it
> doesn't exist :)).
>
> That said it is a little tempting to add a new per-netdev mutex here,
> instead of congesting RTNL lock further, since today no correct driver
> should depend on the RTNL lock.

Another possible option could be replacing for_each_netdev_rcu with
for_each_netdev_srcu and using list_for_each_entry_srcu (though it's
currently used nowhere else in the kernel). Has anyone considered
using sleepable RCUs or thought of a reason they wouldn't work or
wouldn't be desirable? For more info search for SRCU in
Documentation/RCU/RTFP.txt
