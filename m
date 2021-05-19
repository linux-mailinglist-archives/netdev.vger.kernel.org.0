Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0681F388A53
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 11:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344449AbhESJSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 05:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343716AbhESJSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 05:18:46 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890A6C06175F
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 02:17:24 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id v14so6281184pgi.6
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 02:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lC0/0TeTVxh+izmemw5dpiDjfn8iYHm/4aAbQIQTNPg=;
        b=uDzLgNpy5cRzh6GauhaBm2TqS3tTXvRrAogUpjGNPqNNtZcSLaxO9zEDtZE5W0iFGd
         jTiNAuUv0mB1K3pjy8V036XwqWdUpakxJpxgjePr3bFXeNkYFqobWdhrqaMqShzLm69k
         9qPWffs5zVeMBPgBzgWVyBH2ms29cf8TCXNRVVEU0Hpp5ypGR3+6vbtYGA2vVZW2RoqZ
         KSyyVCZp7EinigkEG8RY/Ge/7xaXTntocve8F9KdaKVpQuh8+ktsQHGKKtaugEEbkrrV
         r3hk2xLjBEPVCzkYN+wZ+1Tx7lS0+yClOtDpeOpSqbRSk4pxw2BVN8Mh/McsqguOd4SE
         Q5mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lC0/0TeTVxh+izmemw5dpiDjfn8iYHm/4aAbQIQTNPg=;
        b=kdoCZ13hZHB3KG5cqPPy101T3iqvstpaiTwQ/PBS4goghgNFTkmS9LxWBQBk/pc+4Q
         fNjn0YHpBP3CSO6TmC0au0RlSeWGgRsqQXgwZ50JlAmejnY+SQMEyDaCbM4raU76wRNE
         Jy8i0FrctF/nU1ARLfIhitiGP8Hnfc0fweiY7tF33mNfjrcZZj7Ie1nIue5FFA75DVRo
         vP4KGJeP1c64Gx/3dGifjfONsk3RgVRezImVhyS+UE4USFurT+9+23ntKnY1hTkmDCTZ
         lD5jgwVWZgVpau+Gk2MC3CCyric8ZGEls+9RFl1y7x8FWOBRNEeEz9T8uuASBBuCgVsc
         p1rA==
X-Gm-Message-State: AOAM530lC65qsTMjHR2JnQWMVBxkiAdXc7Y6dV3jbniOLw5gpZBSLNTB
        d39NBSuEsIonaU7HbhyJsJQW9AhSOL+keFRUbz4MWg==
X-Google-Smtp-Source: ABdhPJzYGMWc/g8Ql6dibhKPWTCiCkJ7GPqJvMbpY7/rRrvnjBtpOLb16SVR/JGS5Gh8AqrwwHi/wlywlNRRk8zgk8A=
X-Received: by 2002:a63:1906:: with SMTP id z6mr1668067pgl.173.1621415843670;
 Wed, 19 May 2021 02:17:23 -0700 (PDT)
MIME-Version: 1.0
References: <1620744143-26075-1-git-send-email-loic.poulain@linaro.org>
 <1620744143-26075-2-git-send-email-loic.poulain@linaro.org>
 <CAAP7ucJah5qJXpjyP9gYmnYDyBWS7Qe3ck2SCBonJhJB2NgS5A@mail.gmail.com>
 <CAMZdPi_2PdM9+_RQi0hL=eQauXfN3wFJVyHwSWGsfnK2QBaHbw@mail.gmail.com>
 <CAAP7ucLb=e-mV6YM3LEh_OvttJVnAN+awRpEQGNt9y_grw+Hqw@mail.gmail.com>
 <CAMZdPi9zABtXoKiUuE9mmbnYsSmZoVWR+nLAdq0O5b7=Ghh-rg@mail.gmail.com> <45436a3b8904d08a0835f9a7973c28bc46010f20.camel@gapps.redhat.com>
In-Reply-To: <45436a3b8904d08a0835f9a7973c28bc46010f20.camel@gapps.redhat.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 19 May 2021 11:25:46 +0200
Message-ID: <CAMZdPi-p13nk8OES-Fdc2hjTak8Ywk-TabYaeJBhS=kF0QFyag@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/2] usb: class: cdc-wdm: WWAN framework integration
To:     Dan Williams <dcbw@gapps.redhat.com>
Cc:     Aleksander Morgado <aleksander@aleksander.es>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,





On Wed, 12 May 2021 at 18:34, Dan Williams <dcbw@gapps.redhat.com> wrote:
>
> On Wed, 2021-05-12 at 13:01 +0200, Loic Poulain wrote:
> > On Wed, 12 May 2021 at 11:04, Aleksander Morgado
> > <aleksander@aleksander.es> wrote:
> > >
> > > Hey,
> > >
> > > > > On Tue, May 11, 2021 at 4:33 PM Loic Poulain <
> > > > > loic.poulain@linaro.org> wrote:
> > > > > >
> > > > > > The WWAN framework provides a unified way to handle
> > > > > > WWAN/modems and its
> > > > > > control port(s). It has initially been introduced to support
> > > > > > MHI/PCI
> > > > > > modems, offering the same control protocols as the USB
> > > > > > variants such as
> > > > > > MBIM, QMI, AT... The WWAN framework exposes these control
> > > > > > protocols as
> > > > > > character devices, similarly to cdc-wdm, but in a bus
> > > > > > agnostic fashion.
> > > > > >
> > > > > > This change adds registration of the USB modem cdc-wdm
> > > > > > control endpoints
> > > > > > to the WWAN framework as standard control ports (wwanXpY...).
> > > > > >
> > > > > > Exposing cdc-wdm through WWAN framework normally maintains
> > > > > > backward
> > > > > > compatibility, e.g:
> > > > > >     $ qmicli --device-open-qmi -d /dev/wwan0p1QMI --dms-get-
> > > > > > ids
> > > > > > instead of
> > > > > >     $ qmicli --device-open-qmi -d /dev/cdc-wdm0 --dms-get-ids
> > > > > >
> > > > >
> > > > > I have some questions regarding how all this would be seen from
> > > > > userspace.
> > > > >
> > > > > Does the MBIM control port retain the ability to query the
> > > > > maximum
> > > > > message size with an ioctl like IOCTL_WDM_MAX_COMMAND? Or is
> > > > > that
> > > > > lost? For the libmbim case this may not be a big deal, as we
> > > > > have a
> > > > > fallback mechanism to read this value from the USB descriptor
> > > > > itself,
> > > > > so just wondering.
> > > >
> > > > There is no such ioctl but we can add a sysfs property file as
> > > > proposed by Dan in the Intel iosm thread.
> > > >
> > >
> > > Yeah, that may be a good thing to add I assume.
> > >
> > > > >
> > > > > Is the sysfs hierarchy maintained for this new port type? i.e.
> > > > > if
> > > > > doing "udevadm info -p /sys/class/wwan/wwan0p1QMI -a", would we
> > > > > still
> > > > > see the immediate parent device with DRIVERS=="qmi_wwan" and
> > > > > the
> > > > > correct interface number/class/subclass/protocol attributes?
> > > >
> > > > Not an immediate parent since a port is a child of a logical wwan
> > > > device, but you'll still be able to get these attributes:
> > > > Below, DRIVERS=="qmi_wwan".
> > > >
> > > > $ udevadm info -p /sys/class/wwan/wwan0p1QMI -a
> > > >
> > > >   looking at device
> > > > '/devices/pci0000:00/0000:00:14.0/usb2/2-3/2-
> > > > 3:1.2/wwan/wwan0/wwan0p1QMI':
> > > >     KERNEL=="wwan0p1QMI"
> > > >     SUBSYSTEM=="wwan"
> > > >     DRIVER==""
> > > >
> > > >   looking at parent device
> > > > '/devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.2/wwan/wwan0':
> > > >     KERNELS=="wwan0"
> > > >     SUBSYSTEMS=="wwan"
> > > >     DRIVERS==""
> > > >
> > > >   looking at parent device
> > > > '/devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.2':
> > > >     KERNELS=="2-3:1.2"
> > > >     SUBSYSTEMS=="usb"
> > > >     DRIVERS=="qmi_wwan"
> > > >     ATTRS{authorized}=="1"
> > > >     ATTRS{bInterfaceNumber}=="02"
> > > >     ATTRS{bInterfaceClass}=="ff"
> > > >     ATTRS{bNumEndpoints}=="03"
> > > >     ATTRS{bInterfaceProtocol}=="ff"
> > > >     ATTRS{bAlternateSetting}==" 0"
> > > >     ATTRS{bInterfaceSubClass}=="ff"
> > > >     ATTRS{interface}=="RmNet"
> > > >     ATTRS{supports_autosuspend}=="1"
> > > >
> > >
> > > Ok, that should be fine, and I think we would not need any
> > > additional
> > > change to handle that. The logic looking for what's the driver in
> > > use
> > > should still work.
> > >
> > > >
> > > > > > However, some tools may rely on cdc-wdm driver/device name
> > > > > > for device
> > > > > > detection. It is then safer to keep the 'legacy' cdc-wdm
> > > > > > character
> > > > > > device to prevent any breakage. This is handled in this
> > > > > > change by
> > > > > > API mutual exclusion, only one access method can be used at a
> > > > > > time,
> > > > > > either cdc-wdm chardev or WWAN API.
> > > > >
> > > > > How does this mutual exclusion API work? Is the kernel going to
> > > > > expose
> > > > > 2 different chardevs always for the single control port?
> > > >
> > > > Yes, if cdc-wdm0 is open, wwan0p1QMI can not be open (-EBUSY),
> > > > and vice versa.
> > > >
> > >
> > > Oh... but then, what's the benefit of adding the new wwan0p1QMI
> > > port?
> > > I may be biased because I have always the MM case in mind, and in
> > > there we'll need to support both things, but doesn't this new port
> > > add
> > > more complexity than making it simpler? I would have thought that
> > > it's
> > > either a cdc-wdm port or a wwan port, but both? Wouldn't it make
> > > more
> > > sense to default to the new wwan subsystem if the wwan subsystem is
> > > built, and otherwise fallback to cdc-wdm? (i.e. a build time
> > > option).
> > > Having two chardevs to manage exactly the same control port, and
> > > having them mutually exclusive is a bit strange.
> > >
> > >
> > > > > really want to do that?
> > > >
> > > > This conservative way looks safe to me, but feel free to object
> > > > if any issue.
> > > >
> > >
> > > I don't think adding an additional control port named differently
> > > while keeping the cdc-wdm name is adding any simplification in
> > > userspace. I understand your point of view, but if there are users
> > > setting up configuration with fixed cdc-wdm port names, they're
> > > probably not doing it right. I have no idea what's the usual
> > > approach
> > > of the kernel for this though, are the port names and subsystem
> > > considered "kernel API"? I do recall in between 3.4 and 3.6 I think
> > > that the subsystem of QMI ports changed from "usb" to "usbmisc"; I
> > > would assume your change to be kind of equivalent and therefore not
> > > a
> > > big deal?
> >
> >
> > The ultimate objective is to have a unified view of WWAN devices,
> > whatever the underlying bus or driver is. Accessing /dev/wwanXpY to
> > submit/receive control packets is strictly equivalent to
> > /dev/cdc-wdmX, the goal of keeping the 'legacy' cdc-wdm chardev, is
> > only to prevent breaking of tools relying on the device name. But, as
> > you said, the point is about considering chardev name/driver change
> > as
> > UAPI change or not. From my point of view, this conservative
> > dual-support approach makes sense, If the user/tool is WWAN framework
> > aware, it uses the /dev/wwanXpY port, otherwise /dev/cdc-wdmX can be
> > used (like using DRM/KMS vs legacy framebuffer).
>
> Names change and have changed in the past. It's sometimes painful but
> tools *already* should not be relying on a specific device name. eg if
> you have a tool that hardcodes /dev/cdc-wdm0 there is already no
> guarantee that you'll get the same port next time, especially with USB.
>
> Ethernet devices have never been stable, which is why udev and systemd
> have renamed them to enp0s31f6 and wlp61s0. We also change WWAN
> ethernet port device names whenever a new device gets tagged with the
> WWAN hint.
>
> I agree with Aleksander here, I think having two different devices is
> not a great solution and will be more confusing.
>
> I do realize that changing the name can break existing setups but
> again, names are already not stable.
>
> > I'm however open discussing other strategies:
> > - Do not change anything, keep USB WWAN devices out of the WWAN
> > subsystem.
>
> -1 from me, consistency is better.
>
> > - Migrate cdc-wdm completely to WWAN and get rid of the cdc-wdm
> > chardev
>
> +1 from me
>
> > - Build time choice, if CONFIG_WWAN, registered to WWAN, otherwise
> > exposed through cdc-wdm chardev.
>
> Agree with Bjorn, -1
>
> > - Run time choice, use either the new WWAN chardev or the legacy
> > cdc-wdm chardev (this patch)
>
> Agree with Aleksander, -1. This is even more confusing than a name
> change.
>
> > - ...
> >
> > I would be interested in getting input from others/maintainers on
> > this.
>
> Input from Oliver and Greg KH would be useful, since Greg was heavily
> involved with the ethernet/wifi etc device renaming in the past IIRC.
>
> But another thought: why couldn't wwan_create_port() take a devname
> template like alloc_netdev() does and cdc-wdm can just pass "cdc-
> wdm%d"? eg, why do we need to change the name?
> Tools that care about
> finding WWAN devices should be looking at sysfs attributes/links and
> TYPE=XXXX in uevent, not at the device name. Nothing should be looking
> at device name really.

Right, passing the legacy cdc-wdm dev-name as a parameter seems to be
a fair solution, making the transition smoother.

Regards,
Loic
