Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8B2390450
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 16:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbhEYOxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 10:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbhEYOxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 10:53:08 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD04C061574
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 07:51:39 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id v12so16463910plo.10
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 07:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RSZEkKJrV/LHI7BU/ePLGbBAxE3IeWqvLd7t1iFYGAQ=;
        b=kl7lwTlvg/r5aaF9+vylxPo7KmxKd0GB+6zAlVvNeZKja7WaFDPDQW/597ulcusmFS
         xWnk+QF2EIsScu/m0teVPdXTHLhitK7pXUwBWVoYoWDPTa6/K2Bf9Vw4z/3guDqSwIM/
         F75IpZHg9aL26p3c4f/SRBcvNet6ZeqMywqrVvrgGLL2AI5L6eHHDCkgLRo05nT6llkn
         +5rzVoAUn9FOgZIF89yA5+gWAfQmljJ5BlMUxS7h5iAqmbV/EiVuCVJUAp5mcHzFYFUT
         zeBSUJipC9RYEeTfhd2LlVTJvxPXqlsq4zAZ60vi5YV3IFd0BXeLuEXwQpLg7PI0sckq
         CYGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RSZEkKJrV/LHI7BU/ePLGbBAxE3IeWqvLd7t1iFYGAQ=;
        b=fHjO9n4qI2fdGQbrGbFifJJix/LNxyioY+sbE4XmLhTH0pTSZUpYy+yMiznFg9FEW1
         FhkPraQU/KLbQRW/tSH3j7Rp0CzLtdiPG/blendSxGVPgc3OTk/Rd19/d2RBWB9Kt/tG
         kcAAOmH2Ij9ST+NCMET2LbAq4VukPotRuHnlZkCzeigUpGbp3M0g8IL76xaKMcKr4A23
         W/3x4ZjawTQEhcmfKDQw43fFyF8zggeco4XSCXpC5XQmo8GYnz31a2ERo7KdMT584ZXd
         zOqYIfSm+9RAlvDEFsAP5PwOQnJY9veFIbLA7NE5ijh2o0rcv/Mk+VidFttIuO0DmmCx
         XS7w==
X-Gm-Message-State: AOAM531jFefrClqddtMi0/d0Xm4l0b9KiQfI+Q4wPQswZGRjhk8lb53h
        pr4cmtJTOw7q54G1aXCgzTFDXBcFqyDBhSJqWGrIPg==
X-Google-Smtp-Source: ABdhPJyy9YTHDJiXCElhm3T8qxVioyDQq/zsQCwYlKCOnHRAIUBH8eZ72XmvNEVTCARXULpJdkqqh/X719t7g43kaa0=
X-Received: by 2002:a17:90a:17ce:: with SMTP id q72mr31465073pja.18.1621954298700;
 Tue, 25 May 2021 07:51:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210520140158.10132-1-m.chetan.kumar@intel.com>
 <20210520140158.10132-16-m.chetan.kumar@intel.com> <CAMZdPi-Xs00vMq-im_wHnNE5XkhXU1-mOgrNbGnExPbHYAL-rw@mail.gmail.com>
 <90f93c17164a4d8299d17a02b1f15bfa@intel.com> <CAMZdPi_VbLcbVA34Bb3uBGDsDCkN0GjP4HmHUbX95PF9skwe2Q@mail.gmail.com>
 <c7d2dd39e82ada5aa4e4d6741865ecb1198959fe.camel@sipsolutions.net>
In-Reply-To: <c7d2dd39e82ada5aa4e4d6741865ecb1198959fe.camel@sipsolutions.net>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 25 May 2021 16:59:56 +0200
Message-ID: <CAMZdPi99Un=AQeUMZUWzudubr2kR6=YciefdaXxYbhebSy+yVQ@mail.gmail.com>
Subject: Re: [PATCH V3 15/16] net: iosm: net driver
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "Kumar, M Chetan" <m.chetan.kumar@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        linuxwwan <linuxwwan@intel.com>, Dan Williams <dcbw@redhat.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

On Tue, 25 May 2021 at 14:55, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Tue, 2021-05-25 at 10:24 +0200, Loic Poulain wrote:
> > >
>
> > > Can you please share us more details on wwan_core changes(if any)/how we should
> > > use /sys/class/wwan0 for link creation ?
> >
> > Well, move rtnetlink ops to wwan_core (or wwan_rtnetlink), and parse
> > netlink parameters into the wwan core. Add support for registering
> > `wwan_ops`, something like:
> > wwan_register_ops(wwan_ops *ops, struct device *wwan_root_device)
> >
> > The ops could be basically:
> > struct wwan_ops {
> >     int (*add_intf)(struct device *wwan_root_device, const char *name,
> > struct wwan_intf_params *params);
> >     int (*del_intf) ...
> > }
> >
> > Then you could implement your own ops in iosm, with ios_add_intf()
> > allocating and registering the netdev as you already do.
> > struct wwan_intf_params would contain parameters of the interface,
> > like the session_id (and possibly extended later with others, like
> > checksum offload, etc...).
> >
> > What do you think?
>
> Note that I kind of tried this in my version back when:
>
> https://lore.kernel.org/netdev/20200225105149.59963c95aa29.Id0e40565452d0d5bb9ce5cc00b8755ec96db8559@changeid/#Z30include:net:wwan.h
>
> See struct wwan_component_device_ops.
>
> I had a different *generic* netlink family rather than rtnetlink ops,
> but that's mostly an implementation detail. I tend to like genetlink
> better, but having rtnetlink makes it easier in iproute2 (though it has
> some generic netlink code too, of course.)
>
> Nobody really seemed all that interested back then.
>
> And frankly, I'm really annoyed that while all of this played out we let
> QMI enter the tree with their home-grown stuff (and dummy netdevs,
> FWIW), *then* said the IOSM driver has to go to rtnetlink ops like them,
> instead of what older drivers are doing, and *now* are shifting
> goalposts again towards something like the framework I started writing
> early on for the IOSM driver, while the QMI driver was happening, and
> nobody cared ...

Yes, I guess it's all about timings... At least, I care now...
I've recently worked on the mhi_net driver, which is basically the
netdev driver for Qualcomm PCIe modems. MHI being similar to IOSM
(exposing logical channels over PCI). Like QCOM USB variants, data can
be transferred in QMAP format (I guess what you call QMI), via the
`rmnet` link type (setup via iproute2).

>
> Yeah, life's not fair and all that, but it does kind of feel like
> arbitrary shifting of the goal posts, while QMI is already in tree. Of
> course it's not like we have a competition with them here, but having
> some help from there would've been nice. Oh well.
>
> Not that I disagree with any of this, it does technically make sense.
>
> However, I think at this point it'd be good to see some comments here
> from DaveM/Jakub that they're going to force Qualcomm to also go down
> this route, because they're now *heavily* invested in their own APIs,
> and inventing a framework just for the IOSM driver is fairly pointless.

This a legitimate point, but it's not too late to do the 'right'
thing, + It should not be too much change in the IOSM driver.

Regarding Qualcomm, I think it should be possible to fit QCOM Modem
drivers into that solution. It would consist of creating a simple
wrapper in QMAP/rmnet so that the rmnet link can (also) be created
from the kernel side (e.g. from mhi_net driver):
wwan_new_link() => wwan->add_intf_cb() => mhi_net_add_intf() => rmnet_newlink()

That way mhi_net driver would comply with the new hw agnostic wwan link
API, without breaking backward compatibility if someone wants to
explicitly create a rmnet link. Moreover, it could also be applicable
to USB modems based on MBIM and their VLAN link types.

That's my guess, but maybe I do not have the whole picture and miss
something... Anyway, I'll not blame the IOSM driver for not doing
this. But If you decide to go with the wwan link type, I'll do my best
to adapt that to QCOM mhi_net as well.

> > I also plan to submit a change to add a wwan_register_netdevice()
> > function (similarly to WiFi cfg80211_register_netdevice), that could
> > be used instead of register_netdevice(), basically factorizing wwan
> > netdev registration (add "wwan" dev_type, add sysfs link to the 'wwan'
> > device...).
>
> Be careful with that, I tend to think we made some mistakes in this
> area, look at the recent locking things there. We used to do stuff from
> a netdev notifier, and that has caused all kinds of pain recently when I
> reworked the locking to not be so overly dependent on the RTNL all the
> time (which really has become the new BKL, at least for desktop work,
> sometimes I can't even type in the UI when the RTNL is blocked). So
> wwan_register_netdevice() is probably fine, doing netdev notifier I'd
> now recommend against.
> But in any case, that's just a side thread.

Sure, thanks for pointing this.

Regards,
Loic
