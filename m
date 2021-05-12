Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B2437B8CB
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 11:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhELJFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 05:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbhELJFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 05:05:31 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C0DC061574
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 02:04:21 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id f75-20020a9d03d10000b0290280def9ab76so19936128otf.12
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 02:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6HL7aExGIyOB4S03ad5IXySNnc97aDK3bfycG2wO8KA=;
        b=BNAJtKBuk8f0VdJ2XVAnuhAT5/74HUVMKW2Y1/e18klUS2TvyjK6LJe3oODmuuTR8U
         ABcQkZ6yFU20nD9z0PSeJBRUKEm/lSXxghpvB0R/hfWY9HEjtGymc6BSnrYd3VKP5r60
         PyrGFVn799mz39FqSak795D7Mi+IumGlsY9agPPnxdeA/qXHnTSRS2jM8sCYDuZBPOr8
         9Q/jUAnwfDg1h18LLWIlH6/6YBIDPt47pZRj2/gS3xX977bnUNfk+I6GPoVbB/NMindd
         6cpvmPYMD30BIS8Ecmtyg8XXU5V1pUrSP9z/0RF7IYNwkrYU7DXA6+H09ot5xo1pCc/X
         +4XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6HL7aExGIyOB4S03ad5IXySNnc97aDK3bfycG2wO8KA=;
        b=VKBviOzV8ztpz+ZHlrETcz6bJ1Yyk0nRy7vf39U9AJL5OSzAWdVUxuxfceGE/deZA4
         6EynclQyhcw3Fb1QxU9KeoMXAh/iTKFTok9YgcDWmmPidjYkKlKNJTUWyajKZKjjF1UY
         RZDVZX8cYfpNGRF68GYE30fGvksTASrkreCn/u2w6gEhedYNvwaWcbXnqveixmk/zWBR
         v5HNGbIq3EILb28Dxyxv1I/gWoYFuaQXWI6tB7aKRH0TbTpkp3pRjHRmAo2Tq8HsHl2T
         K9AS0cnJ8f3JgswLhxUf3xZd5FPl795ScYHoGbdrV/w4ao/0/IH+hXiEnQvGZEf7XTrW
         /MTg==
X-Gm-Message-State: AOAM531ezYzofLVdan62djoME8cufHLYrcsleVE3DmWx/XoH/d501Ocw
        TF/sUfeFFHBsC2DHuwHWWfh7cPRUL3KZjEDsXRPi5Q==
X-Google-Smtp-Source: ABdhPJzP626q72Bt0YLKDCh4fUwhCUD8aCdSb6nk8PjS0qd47gR9hVXxEY9/bTAliAqqWwJ+xEjljpQ1HTWS4J5ZmqI=
X-Received: by 2002:a9d:2f66:: with SMTP id h93mr24940766otb.188.1620810260725;
 Wed, 12 May 2021 02:04:20 -0700 (PDT)
MIME-Version: 1.0
References: <1620744143-26075-1-git-send-email-loic.poulain@linaro.org>
 <1620744143-26075-2-git-send-email-loic.poulain@linaro.org>
 <CAAP7ucJah5qJXpjyP9gYmnYDyBWS7Qe3ck2SCBonJhJB2NgS5A@mail.gmail.com> <CAMZdPi_2PdM9+_RQi0hL=eQauXfN3wFJVyHwSWGsfnK2QBaHbw@mail.gmail.com>
In-Reply-To: <CAMZdPi_2PdM9+_RQi0hL=eQauXfN3wFJVyHwSWGsfnK2QBaHbw@mail.gmail.com>
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Wed, 12 May 2021 11:04:09 +0200
Message-ID: <CAAP7ucLb=e-mV6YM3LEh_OvttJVnAN+awRpEQGNt9y_grw+Hqw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/2] usb: class: cdc-wdm: WWAN framework integration
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Oliver Neukum <oliver@neukum.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Network Development <netdev@vger.kernel.org>,
        dcbw@gapps.redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey,

> > On Tue, May 11, 2021 at 4:33 PM Loic Poulain <loic.poulain@linaro.org> wrote:
> > >
> > > The WWAN framework provides a unified way to handle WWAN/modems and its
> > > control port(s). It has initially been introduced to support MHI/PCI
> > > modems, offering the same control protocols as the USB variants such as
> > > MBIM, QMI, AT... The WWAN framework exposes these control protocols as
> > > character devices, similarly to cdc-wdm, but in a bus agnostic fashion.
> > >
> > > This change adds registration of the USB modem cdc-wdm control endpoints
> > > to the WWAN framework as standard control ports (wwanXpY...).
> > >
> > > Exposing cdc-wdm through WWAN framework normally maintains backward
> > > compatibility, e.g:
> > >     $ qmicli --device-open-qmi -d /dev/wwan0p1QMI --dms-get-ids
> > > instead of
> > >     $ qmicli --device-open-qmi -d /dev/cdc-wdm0 --dms-get-ids
> > >
> >
> > I have some questions regarding how all this would be seen from userspace.
> >
> > Does the MBIM control port retain the ability to query the maximum
> > message size with an ioctl like IOCTL_WDM_MAX_COMMAND? Or is that
> > lost? For the libmbim case this may not be a big deal, as we have a
> > fallback mechanism to read this value from the USB descriptor itself,
> > so just wondering.
>
> There is no such ioctl but we can add a sysfs property file as
> proposed by Dan in the Intel iosm thread.
>

Yeah, that may be a good thing to add I assume.

> >
> > Is the sysfs hierarchy maintained for this new port type? i.e. if
> > doing "udevadm info -p /sys/class/wwan/wwan0p1QMI -a", would we still
> > see the immediate parent device with DRIVERS=="qmi_wwan" and the
> > correct interface number/class/subclass/protocol attributes?
>
> Not an immediate parent since a port is a child of a logical wwan
> device, but you'll still be able to get these attributes:
> Below, DRIVERS=="qmi_wwan".
>
> $ udevadm info -p /sys/class/wwan/wwan0p1QMI -a
>
>   looking at device
> '/devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.2/wwan/wwan0/wwan0p1QMI':
>     KERNEL=="wwan0p1QMI"
>     SUBSYSTEM=="wwan"
>     DRIVER==""
>
>   looking at parent device
> '/devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.2/wwan/wwan0':
>     KERNELS=="wwan0"
>     SUBSYSTEMS=="wwan"
>     DRIVERS==""
>
>   looking at parent device '/devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.2':
>     KERNELS=="2-3:1.2"
>     SUBSYSTEMS=="usb"
>     DRIVERS=="qmi_wwan"
>     ATTRS{authorized}=="1"
>     ATTRS{bInterfaceNumber}=="02"
>     ATTRS{bInterfaceClass}=="ff"
>     ATTRS{bNumEndpoints}=="03"
>     ATTRS{bInterfaceProtocol}=="ff"
>     ATTRS{bAlternateSetting}==" 0"
>     ATTRS{bInterfaceSubClass}=="ff"
>     ATTRS{interface}=="RmNet"
>     ATTRS{supports_autosuspend}=="1"
>

Ok, that should be fine, and I think we would not need any additional
change to handle that. The logic looking for what's the driver in use
should still work.

>
> > > However, some tools may rely on cdc-wdm driver/device name for device
> > > detection. It is then safer to keep the 'legacy' cdc-wdm character
> > > device to prevent any breakage. This is handled in this change by
> > > API mutual exclusion, only one access method can be used at a time,
> > > either cdc-wdm chardev or WWAN API.
> >
> > How does this mutual exclusion API work? Is the kernel going to expose
> > 2 different chardevs always for the single control port?
>
> Yes, if cdc-wdm0 is open, wwan0p1QMI can not be open (-EBUSY), and vice versa.
>

Oh... but then, what's the benefit of adding the new wwan0p1QMI port?
I may be biased because I have always the MM case in mind, and in
there we'll need to support both things, but doesn't this new port add
more complexity than making it simpler? I would have thought that it's
either a cdc-wdm port or a wwan port, but both? Wouldn't it make more
sense to default to the new wwan subsystem if the wwan subsystem is
built, and otherwise fallback to cdc-wdm? (i.e. a build time option).
Having two chardevs to manage exactly the same control port, and
having them mutually exclusive is a bit strange.

> > really want to do that?
>
> This conservative way looks safe to me, but feel free to object if any issue.
>

I don't think adding an additional control port named differently
while keeping the cdc-wdm name is adding any simplification in
userspace. I understand your point of view, but if there are users
setting up configuration with fixed cdc-wdm port names, they're
probably not doing it right. I have no idea what's the usual approach
of the kernel for this though, are the port names and subsystem
considered "kernel API"? I do recall in between 3.4 and 3.6 I think
that the subsystem of QMI ports changed from "usb" to "usbmisc"; I
would assume your change to be kind of equivalent and therefore not a
big deal?

> > How would we know from userspace that the 2
> > chardevs apply to the same port?
>
> They share the same USB interface, and if one is open the other is busy.
>

Not sure I personally like that complication.

> > And, which of the chardevs would be
> > exposed first (and notified first by udev), the wwan one or the
> > cdc-wdm one?
>
> cdc-wdm is registered first, though when I run MM with changes to
> handle 'WWAN ports', MM is trying to probe wwan first.

Maybe because you're manually running MM and the "wwan" subsystem is
being iterated first? That would mean that when relying on udev events
(i.e. MM is already running when the device is detected) we would get
the cdc-wdm port notified first, and we would be using the other
chardev. If we were to keep this logic, and if the cdc-wdm port is
always created first (and notified first by udev), I would suggest to
always keep using the cdc-wdm port in ModemManager, because it's
easier to discard "the second" port in the logic :/

> MM is then unable to open /dev/cdc-wdm0, and simply discards that port:
>   System   |                  device:
> /sys/devices/pci0000:00/0000:00:14.0/usb2/2-3
>                  |                 drivers: option, qmi_wwan
>                  |                  plugin: telit
>                  |            primary port: wwan0p1QMI
>                  |                   ports: ttyUSB0 (ignored), ttyUSB1 (ignored), ttyUSB2 (at),
>                  |                          ttyUSB3 (at), ttyUSB4 (ignored), wwan0 (net), wwan0p1QMI (qmi)
>

If this logic is kept we could improve this a bit more; e.g. by
detecting whether the ports are really the same (e.g. looking at what
USB interface number they apply to) and fully discard the second port
reported. As said above, if the cdc-wdm port is the first one
notified, we would be discarding the wwan port :/

> But before enabling WWAN probe for USB devices in MM, some changes will be requested, such as:
> https://gitlab.freedesktop.org/loicpoulain/ModemManager/-/commit/ca3befb464aacc6175820c06c16b2b4b120c1923
>

That's fine, yes. And we'd also require some changes like those for
the cdc-wdm AT ports in the huawei plugin.

-- 
Aleksander
https://aleksander.es
