Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1FC4930F5
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 23:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346363AbiARWnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 17:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237704AbiARWnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 17:43:13 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FDFC061574;
        Tue, 18 Jan 2022 14:43:13 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id l12-20020a7bc34c000000b003467c58cbdfso9582422wmj.2;
        Tue, 18 Jan 2022 14:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n+u7w/7GVsZ+QwFRY2Vg+1iMWsu/gCEDhvco83Mij8Y=;
        b=AsGi5WPciR9ITbzUs5gPwDnZmLyh9vXu/blPRMwgohYeFGAL/Sr2LyZ+9UGV1eRdDh
         C+gDOleFGWtOaz5VrwwI/2x4in5xI+vXd6HeMoD5a4j31AxRC1kJ3Ai1JhLUqvS9LRaO
         jpH3Ha5luK5jWvYMNHVqWxA6l9kiTz8/wS85R/Omps3unvfTzlT8EOXNRuHtl8wfZ/KS
         E5++Wz5Bdm5KuNQQt1DXXLrUCJlP68jD8blaYQR3jWwJrcpYs4qEJEopFChIjGHf82E9
         kLT06pFbUGD9ssGnLlJ6SQVeMRcQd9Ep9f9EXrLS61oa1CYy9MgXcr5ZKpxwf5jwKmYe
         7iSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n+u7w/7GVsZ+QwFRY2Vg+1iMWsu/gCEDhvco83Mij8Y=;
        b=GlcD4DnhuDcJV3EQsGGe85lLtMrHQUhcbPFK0tqJsfYteumhuiKWjsK8oqfezTo1YD
         dHUuG9mWtTQXDr3NnCoyVayQp/HCTm1yN3R7Ja2lYCim6lGmXXw9OiM0IpblMH1PO1K6
         K6xIHk60XoCWy/OJ2vxofJDpfdIrBexlM2Wewj9Lzyk0OK6mrTJSYedjqgtE7EXXi5BT
         RPQjiiLyen7nEMLiZ+3WFNfmyzkq+/7yg/VFzC5sap+WcJXnzDZ2m0c+IJhAU5BRlw65
         ++W7azTpk8L3JoLXRbVbpzL4DYclJqHhQD9ZLJctN1nxXoXlqfY2BB4niIM8zgovPGz2
         VeuQ==
X-Gm-Message-State: AOAM532KKOYzXzArp4xelbHxpj9nFjD1RWF9zIDKils2lIAXsGfwkaa7
        Y73JBjKj+9259gS66fdgcFlCRhoRTNpo879pdGw=
X-Google-Smtp-Source: ABdhPJyBVQ6zi7siC+AQnnyCU1O4yjgYsCwZgA8nAS7/FvaKV0S16T7miqtr65XwF+ghmi2aMf4tEWb8GuBlFo06WPg=
X-Received: by 2002:a05:6000:1686:: with SMTP id y6mr15695960wrd.205.1642545791614;
 Tue, 18 Jan 2022 14:43:11 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
 <20220112173312.764660-9-miquel.raynal@bootlin.com> <CAB_54W5QU5JCtQYwvTKREd6ZeQWmC19LF4mj853U0Gz-mCObVQ@mail.gmail.com>
 <20220113121645.434a6ef6@xps13> <CAB_54W5_x88zVgSJep=yK5WVjPvcWMy8dmyOJWcjy=5o0jCy0w@mail.gmail.com>
 <20220114112113.63661251@xps13> <CAB_54W77d_PjX_ZfKJdO4D4hHsAWjw0jWgRA7L0ewNnqApQhcQ@mail.gmail.com>
 <20220117101245.1946e474@xps13> <CAB_54W4rqXxSrTY=fqbt6o41a2SAEY_suqyqZ3hymheCgzRqTQ@mail.gmail.com>
 <20220118113833.0185f564@xps13>
In-Reply-To: <20220118113833.0185f564@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 18 Jan 2022 17:43:00 -0500
Message-ID: <CAB_54W4Z0H5ubvOBjpnCpGOWYrNXYOJvxB4_kZsp8LqdJrTLkg@mail.gmail.com>
Subject: Re: [wpan-next v2 08/27] net: ieee802154: Drop symbol duration
 settings when the core does it already
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 18 Jan 2022 at 05:38, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> > > > btw:
> > > > Also for testing with hwsim and the missing features which currently
> > > > exist. Can we implement some user space test program which replies
> > > > (active scan) or sends periodically something out via AF_PACKET raw
> > > > and a monitor interface that should work to test if it is working?
> > >
> > > We already have all this handled, no need for extra software. You can
> > > test active and passive scans between two hwsim devices already:
> > >
> > > # iwpan dev wpan0 beacons send interval 15
> > > # iwpan dev wpan1 scan type active duration 1
> > > # iwpan dev wpan0 beacons stop
> > >
> > > or
> > >
> > > # iwpan dev wpan0 beacons send interval 1
> > > # iwpan dev wpan1 scan type passive duration 2
> > > # iwpan dev wpan0 beacons stop
> > >
> > > > Ideally we could do that very easily with scapy (not sure about their
> > > > _upstream_ 802.15.4 support). I hope I got that right that there is
> > > > still something missing but we could fake it in such a way (just for
> > > > hwsim testing).
> > >
> > > I hope the above will match your expectations.
> > >
> >
> > I need to think and read more about... in my mind is currently the
> > following question: are not coordinators broadcasting that information
> > only? Means, isn't that a job for a coordinator?
>
> My understanding right now:
> - The spec states that coordinators only can send beacons and perform
>   scans.

ok.

> - I don't yet have the necessary infrastructure to give coordinators
>   more rights than regular devices or RFDs (but 40+ patches already,
>   don't worry this is something we have in mind)
> - Right now this is the user to decide whether a device might answer
>   beacon requests or not. This will soon become more limited but it
>   greatly simplifies the logic for now.
>

There was always the idea behind it to make an "coordinator" interface
type and there is a reason for that because things e.g. filtering
becomes different than a non-coordinator interface type (known as node
interface in wpan).
At the end interface types should make a big difference in how the
"role" inside the network should be, which you can also see in
wireless as "station"/"access point" interface devices.

A non full functional device should then also not be able to act as a
coordinator e.g. it cannot create coordinator types.

However we can still make some -EOPNOTSUPP if something in a different
way should be done. This clearly breaks userspace and I am not sure if
we should worry or not worry about it in the current state of
802.15.4...

- Alex
