Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A04C014C8AD
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 11:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgA2KTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 05:19:39 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37130 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgA2KTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 05:19:39 -0500
Received: by mail-ed1-f66.google.com with SMTP id cy15so18072573edb.4
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 02:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vrj9dbnUhss/hzn6XROJ7YN3qw/ZDcpeOghwoUGgMRQ=;
        b=MyiQ4PyE1CXY17yxm+7I/IgXCmR8dbGkSlkFuFhQFT05bVfebJM0s7y3B/B6PRW40L
         QKP7rvsYqzr8WAA3tDjkIO3HdF+/HWuyAFoB4u764ufa036QdCaERrTJd0lMHf+dwOmN
         OtB8KX2ZXz0Jn+tcr2jhBc7Ve5LHYcuGyruZC+v3Kex/FPZiZiU75FqRXgsro/uXAIaE
         mAuWQUGAM/pRsCGYyEZvPeMQnT6J/JhODe8bWAIayzR5cn+T76TxGlzLeImhb5XTnhIl
         zspcgRt4eJuU2GyxkXDaldCVL6UFjvkKxgGyOWlFudluWXjCYpV99qEzdY00rD7iBO+U
         hfnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vrj9dbnUhss/hzn6XROJ7YN3qw/ZDcpeOghwoUGgMRQ=;
        b=CDKGMD8leS+3qlGsEcpFE/iRUXYXFfL0L13up1T8yKuUlK/UMBdo54qLNJDqrjaG7b
         r3t2MHzC+mktobQatEpJSH/E1zWPyrW0Nfwrv0g44bDMoGV+uGkhi2Rq4lTXy0X+m8wL
         QFPyWQsJiHFkD6GsUy8tzZpw8ee3lc7YPfi1MEOa27Qicva48CHHsHfahwGlaa6x8Fs3
         qP8OAfX04vJu5koQaP6oy/A+gP7e4yRMcbkW/tiSEoncfme0ka/ijXWZdoKIjp+zh2n/
         sPEDV4Eskrm6OrditiD6c1UUQX5rHvp87P2fzG1C+Kes7n3Wn3anJTVLFm9++INEcx4t
         H1CQ==
X-Gm-Message-State: APjAAAWHEfCRRw/KDx2nGHjjuT/VylVb68wyjvAA+DDXWLwC/MRmA+Mu
        iNk+fgkonGm6vUAnx+nsdbARIjgz7SMjI/pQQFE=
X-Google-Smtp-Source: APXvYqyvZW6XIXssb7s9MCGozRqakVpV7mmuVa+XzlNMKLdqxeXpVtDtbSMoqVFkD/g45WfY3GFn7C3Hm57Z1wj9cUk=
X-Received: by 2002:a05:6402:19b2:: with SMTP id o18mr7265552edz.368.1580293177238;
 Wed, 29 Jan 2020 02:19:37 -0800 (PST)
MIME-Version: 1.0
References: <1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1580137671-22081-3-git-send-email-madalin.bucur@oss.nxp.com>
 <CA+h21hqzR72v9=dWGk1zBptNHNst+kajh6SHHSUMp02fAq5m5g@mail.gmail.com>
 <20200127160413.GI13647@lunn.ch> <CA+h21hoZVDFANhzP5BOkZ+HxLMg9=pcdmLbaavg-1CpDEq=CHg@mail.gmail.com>
 <DB8PR04MB698504E07E288BB5BD79BD38EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB698504E07E288BB5BD79BD38EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 29 Jan 2020 12:19:26 +0200
Message-ID: <CA+h21hpQ48x8mm5JNOH5ijZg-EnFxXAd8RoX4eizhr96BycKPA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] dpaa_eth: support all modes with rate adapting PHYs
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "ykaukab@suse.de" <ykaukab@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Madalin,

On Wed, 29 Jan 2020 at 11:09, Madalin Bucur (OSS)
<madalin.bucur@oss.nxp.com> wrote:
>
> > -----Original Message-----
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Sent: Tuesday, January 28, 2020 5:42 PM
> > To: Andrew Lunn <andrew@lunn.ch>
> > Cc: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>; David S. Miller
> > <davem@davemloft.net>; Florian Fainelli <f.fainelli@gmail.com>; Heiner
> > Kallweit <hkallweit1@gmail.com>; netdev <netdev@vger.kernel.org>;
> > ykaukab@suse.de
> > Subject: Re: [PATCH v2 2/2] dpaa_eth: support all modes with rate
> > adapting PHYs
> >
> > Hi Andrew,
> >
> > On Mon, 27 Jan 2020 at 18:04, Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > Is this sufficient?
> > > > I suppose this works because you have flow control enabled by
> > default?
> > > > What would happen if the user would disable flow control with
> > ethtool?
> > >
> > > It will still work. Network protocols expect packets to be dropped,
> > > there are bottlenecks on the network, and those bottlenecks change
> > > dynamically. TCP will still be able to determine how much traffic it
> > > can send without too much packet loss, independent of if the
> > > bottleneck is here between the MAC and the PHY, or later when it hits
> > > an RFC 1149 link.
> >
> > Following this logic, this patch isn't needed at all, right? The PHY
> > will drop frames that it can't hold in its small FIFOs when adapting a
> > link speed to another, and higher-level protocols will cope. And flow
> > control at large isn't needed.
>
> I'm afraid you missed the patch description that explains there will be
> no link with a 1G partner without this change:
>

So why not just remove that linkmode_and() at all, then?
What is it trying to accomplish, anyway? Avoiding the user from
shooting themselves in the foot maybe?

> << After this
> commit, the modes removed by the dpaa_eth driver were no longer
> advertised thus autonegotiation with 1G link partners failed.>>
>
> > What I was trying to see Madalin's opinion on was whether in fact we
> > want to keep the RX flow control as 'fixed on' if the MAC supports it
> > and the PHY needs it, _as a function of the current phy_mode and maybe
> > link speed_ (the underlined part is important IMO).
>
> That's a separate concern, by default all is fine, should the user want to
> shoot himself in the foot, we may need to allow him to do it.
>> > >
> > >     Andrew
> > >
> >
> > Thanks,
> > -Vladimir

-Vladimir
