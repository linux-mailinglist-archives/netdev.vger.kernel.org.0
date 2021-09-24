Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AD2417BD5
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 21:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345352AbhIXThL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 15:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344824AbhIXThJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 15:37:09 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EDDC061571
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 12:35:36 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id p80so14021389iod.10
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 12:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=agN1ub4iErmLCQnGfQtnV5T+5eCnJgXeeyL+wOb3r2k=;
        b=TGnbGUwH4ADy2irJU6AR5T+SLunEHBgKK6fYJ2rID8wpzf57yqu8bYh+V+dv/gsN+Y
         42VXyq6aTZGtX6ppQJ1cBIcObk1LVKnypKU13YKEQfKNr3genf0ESCSsF7gDsvnaJRyy
         zM3tbyAVnjauEHPvnhXlmmyZL6YJ7cL7YJh6gYeVygn7tZQ+wVTIY0DeeN+0bR/g7Uqv
         n1ShTrEyT9TvLrDCh5fkLiVBKy220A8SXh+iu4Ox8KOvX9OcwZfLkbmi4qz+hmDFfd5w
         j7Ab7aoX6qclR2JRonpUT1b447DABWEzzbKHp863oyWPlur2XcSdk8zqc7BLLMtuL4hs
         uatA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=agN1ub4iErmLCQnGfQtnV5T+5eCnJgXeeyL+wOb3r2k=;
        b=JU6d6rtccJzBNhUB3NllYt4p+URBp1bSsqMFMjMsgU5gGSWtg2zZ6fiXpl0aCpVmAc
         DuTN2ZjNEJp56yKNmiF0MS37vnWPjbW/W05SJzAOtMvyybh+kf6gWZQMNLRcdxMx/mmT
         30zyXtRTnsl810e+qnb+/RIDNilzDAxluzrDlxotMN4a/Tx02gIJNu2GUzPJHaVEHvnA
         u4YwhaWo315kanAvlfmCJenDqFSJc51NilLWNmQyb2gmLSrqhDqCaRO4OnWvBESOOfK7
         UjQWuhcuWKtvExe9nOk6vWZX/CspXeasyVWExeJ6sD35B7/4420a4yQmWyFfD7vd0fM9
         YyhQ==
X-Gm-Message-State: AOAM532wvQToNori9LdyF2oWkx5OdXsI5h6ShD3MiUD823E8U2XFBZ0A
        6jAEJvNAW9cWx846djOoEIV7IULC7q87Lk6WE0KFW2vrI8FobXTDuXI=
X-Google-Smtp-Source: ABdhPJyouJJxu2bzYoNanl4MKP7oFaKH7SyDcbt/AzzVU4+SXGX9mZjrekFxihJXf3V7B8vVVGS7+3Wavzqm7kpdRrw=
X-Received: by 2002:a5d:9ad2:: with SMTP id x18mr10626327ion.182.1632512135884;
 Fri, 24 Sep 2021 12:35:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210831193425.26193-1-gerhard@engleder-embedded.com>
 <20210831193425.26193-4-gerhard@engleder-embedded.com> <YS6lQejOJJCATMCp@lunn.ch>
 <CANr-f5zXWrqPxWV81CT6=4O6PoPRB0Qs0T=egJ3q8FMG16f6xw@mail.gmail.com> <YS/qQdmjT/X0tiEt@lunn.ch>
In-Reply-To: <YS/qQdmjT/X0tiEt@lunn.ch>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Fri, 24 Sep 2021 21:35:24 +0200
Message-ID: <CANr-f5w85XGg6XT8tOrB17+cHJMPv+fhMGe1gx9qrZNAHPo7AQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] tsnep: Add TSN endpoint Ethernet MAC driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > +static int tsnep_ethtool_set_priv_flags(struct net_device *netdev,
> > > > +                                     u32 priv_flags)
> > > > +{
> > > > +     struct tsnep_adapter *adapter = netdev_priv(netdev);
> > > > +     int retval;
> > > > +
> > > > +     if (priv_flags & ~TSNEP_PRIV_FLAGS)
> > > > +             return -EINVAL;
> > > > +
> > > > +     if ((priv_flags & TSNEP_PRIV_FLAGS_LOOPBACK_100) &&
> > > > +         (priv_flags & TSNEP_PRIV_FLAGS_LOOPBACK_1000))
> > > > +             return -EINVAL;
> > > > +
> > > > +     if ((priv_flags & TSNEP_PRIV_FLAGS_LOOPBACK_100) &&
> > > > +         adapter->loopback != SPEED_100) {
> > > > +             if (adapter->loopback != SPEED_UNKNOWN)
> > > > +                     retval = phy_loopback(adapter->phydev, false);
> > > > +             else
> > > > +                     retval = 0;
> > > > +
> > > > +             if (!retval) {
> > > > +                     adapter->phydev->speed = SPEED_100;
> > > > +                     adapter->phydev->duplex = DUPLEX_FULL;
> > > > +                     retval = phy_loopback(adapter->phydev, true);
> > >
> > > This is a pretty unusual use of private flags, changing loopback at
> > > runtime. ethtool --test generally does that.
> > >
> > > What is your use case which requires loopback in normal operation, not
> > > during testing?
> >
> > Yes it is unusual. I was searching for some user space interface for loopback
> > and found drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c which uses
> > private flags.
>
> Ah, that passed my by. I would of probably said something about it.
>
> > Use case is still testing and not normal operation. Testing is done mostly with
> > a user space application, because I don't want to overload the driver with test
> > code and test frameworks can be used in user space. With loopback it is
> > possible to execute a lot of tests like stressing the MAC with various frame
> > lengths and checking TX/RX time stamps. These tests are useful for every
> > integration of this IP core into an FPGA and not only for IP core development.
>
> I did a quick search. CAN has something interesting:
>
> https://wiki.rdu.im/_pages/Application-Notes/Software/can-bus-in-linux.html
> $ sudo ip link set can0 down
> $ sudo ip link set can0 type can loopback on
> $ sudo ip link set can0 up type can bitrate 1000000
>
> Also
>
> https://www.kernel.org/doc/Documentation/networking/can.txt
>
> The semantics are maybe slightly different. It appears to loopback can
> messages, but also send out the wire. I think many can transcievers
> can do this in hardware, but this seems to be a software feature for
> when the hardware cannot do it? I have seen Ethernet PHYs which do
> send out the wire when in loopback, so it does seem like a reasonable
> model. Also i like that you need to down the interface before you can
> put it into loopback. Saves a lot of surprises.
>
> Maybe you can look at this, see if it can be made generic, and could
> be used here?

CAN loopback is defined in include/uapi/linux/can/netlink.h and iproute2
uses it in ip/iplink_can.c. I did not see any ethernet specific implementation
in this area. I have no idea how to make that generic. Ethernet link
configuration is done with ethtool. Is it a good idea to add link configuration
capabilities to netlink?

What about restricting the usage of the loopback flags? They could
be restricted to AUTONEG_DISABLE. So at least the link would be in
defined start when loopback is activated.

Gerhard
