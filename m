Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAA94A8B4F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 19:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353249AbiBCSOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 13:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353149AbiBCSOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 13:14:11 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D2FC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 10:14:11 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id m6so11425613ybc.9
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 10:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wh1/UBhsxQfAyZPiDn6haF7FMvKbR0Cv+cjxuxp0Kkk=;
        b=SxjlFK6E6+hOvZ/ebXzmpB43cqVC4bK8dIHkyGbzPyH4oMrYiMicy8q813/QFXfqJ4
         QQv8t1AVV6OTvvI0dd7hk2JjqcCldLDvsVWJKH3NArGmSXGTOPEc0MvgbX7gNHKN5tOB
         G5ZHCGLjmKfExbFWDT91pAhRKujxwkU02dxaJW0z7DZR68PgPkjn8Mnbto6BddNI/T2W
         yJldLw7Em/Yjg31egGVgHHWEnqb0euiMBlSfaBI2T6+9WAnmXMvI9ZI0EuwlOaS2iIP0
         ZTc0vHh+cr0tOY7RbeNN46nv0CxC0MfYEOHEglMTtoeLGjWhbHb4aLp3vZ+dP2seHFHF
         fGlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wh1/UBhsxQfAyZPiDn6haF7FMvKbR0Cv+cjxuxp0Kkk=;
        b=vcX7VlJwYMF1TT8TuKxOcf204m6tF4ShKQFcYeH96fcCzdFHMdO/TrM+5LbE5oMGgK
         iaZOWYOodYOMMsCbGEXtbJFHgbmIUYP/rc/iycmEF/UdmzZBu1zjbOwSRDM0aUfYFg58
         kFWtasRn9Sxf5XJ+i3jcin8fTkJ0J0pP9tG8VZxdmmlCBBPKJs6yP5qU+lITyafMZVZ3
         /g1dw2fLkh/COx/dbJLetxq8kYYio10sD1Dt4OfFjI6650baSt5uaDYLhJthjjY5Rljn
         RY0ZJI3lFwqP+A/EnpjFfVlNUpp7hkEYjyKtHfKKo7alxhWweTSeMKaC7MuAGiZjWUbt
         3bkQ==
X-Gm-Message-State: AOAM532lsWuC1exdgqEICmRpiMI61zM/tL49KO0KrRe0OagULEBA5VQe
        MW5l14dpadp9pvQNKg21X6UGJfiOksRhygfVxaLGVw==
X-Google-Smtp-Source: ABdhPJw+VP4F5DVWpaDA8eCSsLzADEh0Q8C+A0HmybOnpEjDCSFV5MP+VkhgvJXAiyzNPFN4bs+9b/KR07sE/J7VBOI=
X-Received: by 2002:a81:9808:: with SMTP id p8mr5244856ywg.531.1643912050354;
 Thu, 03 Feb 2022 10:14:10 -0800 (PST)
MIME-Version: 1.0
References: <20220201222845.3640041-1-jeffreyji@google.com> <20220202205916.58f4a592@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220202205916.58f4a592@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 10:13:59 -0800
Message-ID: <CANn89iJqQwUVnh3SPZ7j4RGMhEZsBk3uT3wosAbb1aFSzoyS+A@mail.gmail.com>
Subject: Re: [PATCH v6 net-next] net-core: add InMacErrors counter
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jeffrey Ji <jeffreyjilinux@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Brian Vazquez <brianvv@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, jeffreyji <jeffreyji@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 8:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue,  1 Feb 2022 22:28:45 +0000 Jeffrey Ji wrote:
> > From: jeffreyji <jeffreyji@google.com>
> >
> > Increment InMacErrors counter when packet dropped due to incorrect dest
> > MAC addr.
> >
> > An example when this drop can occur is when manually crafting raw
> > packets that will be consumed by a user space application via a tap
> > device. For testing purposes local traffic was generated using trafgen
> > for the client and netcat to start a server
> >
> > example output from nstat:
> > \~# nstat -a | grep InMac
> > Ip6InMacErrors                  0                  0.0
> > IpExtInMacErrors                1                  0.0
>
> I had another thing and this still doesn't sit completely well
> with me :(
>
> Shouldn't we count those drops as skb->dev->rx_dropped?
> Commonly NICs will do such filtering and if I got it right
> in struct rtnl_link_stats64 kdoc - report them as rx_dropped.
> It'd be inconsistent if on a physical interface we count
> these as rx_dropped and on SW interface (or with promisc enabled
> etc.) in the SNMP counters.

I like to see skb->dev->rx_dropped as a fallback-catch-all bucket
for all cases we do not already have a more specific counter.

> Or we can add a new link stat that NICs can use as well.

Yes, this could be done, but we have to be careful about not hitting
a single cache line, for the cases we receive floods of such messages
on multiqueue NIC.
(The single atomic in dev->rx_dropped) is suffering from this issue btw)

>
> In fact I'm not sure this is really a IP AKA L3 statistic,
> it's the L2 address that doesn't match.
>
>
> If everyone disagrees - should we at least rename the MIB counter
> similarly to the drop reason? Experience shows that users call for
> help when they see counters with Error in their name, I'd vote for
> IpExtInDropOtherhost or some such. The statistic should also be
> documented in Documentation/networking/snmp_counter.rst
