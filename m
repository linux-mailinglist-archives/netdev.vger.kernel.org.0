Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E1923BCBA
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 16:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbgHDOyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 10:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgHDOyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 10:54:33 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA27C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 07:54:32 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t18so34457340ilh.2
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 07:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eI0IoQb54jlb8XjmEDGDSiEuiWMJ5pMoAs41fh5JaPw=;
        b=DFRtFnmU/34jUD7akRp+y3drCyJs7N3Dfx9+fZj92VhjuVVW9dKttBaJ5DIqDdGeMe
         K4QCMwRWCb6Tq9he18kK2OhMA1nzhQ8Hisy7lliRLDL9k3VPQfaQCkHcNR4Q9IlZK6si
         NCTFG3dIbi6WJ32tnld+o7uSXi4ZJQjN5ol4lTNSeudi60xh9gtKkZGMjUpp3B/XdTrM
         j3lyzs8vb9pFRSuXpeh9xH2ZNi8Dd6jRPvdKr/iK+FC6rnJfMrSWcKxLwImgDXaTHx5R
         N+E7FaYSxk+iBNS/B3akjAdx8WXxAHOQCEsJJyr/GjuxuSMDFaGTP+VjYOqRMQPUSuDC
         5gJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eI0IoQb54jlb8XjmEDGDSiEuiWMJ5pMoAs41fh5JaPw=;
        b=B+Oy0Br4GIWnhDdveYKLGPhcB4MGj24jQApAgEX55N6vJ1bzu8ZY1fT8/ZG77nCDBt
         6O7JCKskxGZTtQxdn7fbvKNro1FJLcF6XfpTFhAM1iX/7iOCtHuwJYFtN/MNRpRd4n2L
         INkai04f2tbarDzu6gnin+NUQwaWCv2Q2a3daorKWOSshHHhX+5KEGKZSpgqHeYEF06M
         mRVn1Zs6JnmMY0629BmsCfcWxxzGEkoGAEtNlUQ1MJ5/NPXGkDHlDJP/PdENQFTtnyOr
         XsylqEpHEqvy9gNy+07DejOVYLnZKT8kMck0gTp8kjySIi/XCHSkRvfv836Mcj0qYJ+Y
         SsyA==
X-Gm-Message-State: AOAM5300gEdFX8ORIDjXZ4wX4KFkTjt/4H56tdDeNYkW5ek6ZeoJOl8m
        GVP8sO7fkYM/cUC8eE3kIPIoxWFfNtlOBoGbbkVemw==
X-Google-Smtp-Source: ABdhPJxk2vpbp9XouEsBNthzGfdCmrngvI0/0uavkqDvYVC+rJlKVMz7Yy40hn/9grK8durcqEZQu3vxYdRqtWe0xXU=
X-Received: by 2002:a05:6e02:88:: with SMTP id l8mr5277525ilm.69.1596552869874;
 Tue, 04 Aug 2020 07:54:29 -0700 (PDT)
MIME-Version: 1.0
References: <ad09e947263c44c48a1d2c01bcb4d90a@BK99MAIL02.bk.local>
 <c531bf92-dd7e-0e69-8307-4c4f37cb2d02@gmail.com> <f8465c4b8db649e0bb5463482f9be96e@BK99MAIL02.bk.local>
 <b5ad26fe-e6c3-e771-fb10-77eecae219f6@gmail.com> <020a80686edc48d5810e1dbf884ae497@BK99MAIL02.bk.local>
 <20200804142708.zjos3b6jvqjj7uas@skbuf>
In-Reply-To: <20200804142708.zjos3b6jvqjj7uas@skbuf>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Aug 2020 07:54:18 -0700
Message-ID: <CANn89iKD1H9idd-TpHQ-KS7vYHnz+6VhymrgD2cuGAUHgp2Zpg@mail.gmail.com>
Subject: Re: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 4, 2020 at 7:27 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Tue, Aug 04, 2020 at 02:14:33PM +0000, Gaube, Marvin (THSE-TL1) wrote:
> > Hello,
> > I looked into it deeper, the driver does rxvlan offloading.
> > By disabling it manually trough ethtool, the behavior becomes as
> > expected.
> >
> > I've taken "net: dsa: sja1105: disable rxvlan offload for the DSA
> > master" from
> > (https://lore.kernel.org/netdev/20200512234921.25460-1-olteanv@gmail.com/)
> > and also applied it to the KSZ9477-Driver, which fixes the problem.
> > It's probably a workaround, but fixes the VLAN behavior for now. I
> > would suggest also applying "ds->disable_master_rxvlan = true;" to
> > KSZ9477 after the mentioned patch is merged.
> >
> > Best Regards
> > Marvin Gaube
> >
>
> And I wanted to suggest that, but it seemed too freaky to be what's
> going on.... But since ksz9477 uses a tail tag, it makes perfect sense.
>
> My patch is in limbo because Eric, who started zeroing the skb offloaded
> VLAN data in the first place, hasn't said anything.

I said nothing because I was not aware you were expecting something
special from me ;)

I receive hundreds of emails per day.

My 2013 commit was a bug fix, and hinted that in the future (eg in
net-next tree) the stop-the-bleed could be refined.

+               /* Note: we might in the future use prio bits
+                * and set skb->priority like in vlan_do_receive()
+                * For the time being, just ignore Priority Code Point
+                */
+               skb->vlan_tci = 0;

If you believe this can be done, this is great.
