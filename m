Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1B637BB4F
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 12:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhELKym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 06:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbhELKyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 06:54:38 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C544AC061574
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 03:53:27 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id p17so12297961plf.12
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 03:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y9jyRBdGVuQrbRQaGRd08Gzbky1Wa3w2+6Tbf1IDTy4=;
        b=boD9UOFBTRYUuExDb91rBpuaIeRL5YjPjyYFM2zkH+N8V5Px2+BS8qW71SOOEbAW/e
         +IOOT8omjM5D5O0wyp+5kJK59u7PMwDAGuthKLV+8iHH7ZyEmHQf5ioW8auAtDfwR2sz
         mbfiwSvWIrVHclUMO3VUC32xv33uCHV3jLBYNvbn4GgnuXKeTftDr1hxTXsH3+jm/iX6
         B1D8ECAJnWzDS3RlpKTXhaITqd//EmIvRUbdMiCnndkRAOw6elxXEtSFHVxVdYOLid2+
         TGPS/Hd7dLvyLJ7AxgvEYpvRvc2foj3B+8w7xROZugadtOCQNhIYUhkvVfcYz2PZl6Zw
         fibw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y9jyRBdGVuQrbRQaGRd08Gzbky1Wa3w2+6Tbf1IDTy4=;
        b=GGrwRJHf93sFPjsGfVEBKJYF/kEV6hz/J8Ef+F3ZKim18wm00qXWii29eYlUMTjzSa
         KA7jz1AEGTzHbOxOUjT/8199UcQG9xZ44zF2dLGFoxL9UOqfJ7WxNM+Libju6nxGVCFz
         tMHFGMkn/qsfBJVd9qoFTf+QYSmJiJew6lLV/1/xO3KheaXUeuSiRSBJWefkrIeYBOXq
         SxaffXHoKLy1fFgrx7KddiWx+x+wQhV39g5LwqOZTnk2werTgD6UKpivm7P12ai1RMe0
         xx2v7AicjNh/NZC+M3aojJ+x3fsThth7VPY5M5mc3kM2Vn736+SQ6hB8hzxpr53j9HT1
         DLAA==
X-Gm-Message-State: AOAM530Dx0vX//wavwy7PfdEJVQZn57ZhoJSBe+G1AuimF4uaay653P4
        +U7BZbGBM73ws7YaTiruSjTbWIBMVS8I8GJTmM3xEQ==
X-Google-Smtp-Source: ABdhPJwWrdxX+BfmiTkgJkBOmRD7M7PlOyJIIXXUTikoa8G/ni7/+2V+1giFP59TcvgceVLnbhmuKWnV5aoessoq5CA=
X-Received: by 2002:a17:90a:c096:: with SMTP id o22mr1283893pjs.231.1620816807040;
 Wed, 12 May 2021 03:53:27 -0700 (PDT)
MIME-Version: 1.0
References: <1620744143-26075-1-git-send-email-loic.poulain@linaro.org>
 <1620744143-26075-2-git-send-email-loic.poulain@linaro.org>
 <CAAP7ucJah5qJXpjyP9gYmnYDyBWS7Qe3ck2SCBonJhJB2NgS5A@mail.gmail.com>
 <CAMZdPi_2PdM9+_RQi0hL=eQauXfN3wFJVyHwSWGsfnK2QBaHbw@mail.gmail.com> <CAAP7ucLb=e-mV6YM3LEh_OvttJVnAN+awRpEQGNt9y_grw+Hqw@mail.gmail.com>
In-Reply-To: <CAAP7ucLb=e-mV6YM3LEh_OvttJVnAN+awRpEQGNt9y_grw+Hqw@mail.gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 12 May 2021 13:01:55 +0200
Message-ID: <CAMZdPi9zABtXoKiUuE9mmbnYsSmZoVWR+nLAdq0O5b7=Ghh-rg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/2] usb: class: cdc-wdm: WWAN framework integration
To:     Aleksander Morgado <aleksander@aleksander.es>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oliver@neukum.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Network Development <netdev@vger.kernel.org>,
        dcbw@gapps.redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 May 2021 at 11:04, Aleksander Morgado
<aleksander@aleksander.es> wrote:
>
> Hey,
>
> > > On Tue, May 11, 2021 at 4:33 PM Loic Poulain <loic.poulain@linaro.org> wrote:
> > > >
> > > > The WWAN framework provides a unified way to handle WWAN/modems and its
> > > > control port(s). It has initially been introduced to support MHI/PCI
> > > > modems, offering the same control protocols as the USB variants such as
> > > > MBIM, QMI, AT... The WWAN framework exposes these control protocols as
> > > > character devices, similarly to cdc-wdm, but in a bus agnostic fashion.
> > > >
> > > > This change adds registration of the USB modem cdc-wdm control endpoints
> > > > to the WWAN framework as standard control ports (wwanXpY...).
> > > >
> > > > Exposing cdc-wdm through WWAN framework normally maintains backward
> > > > compatibility, e.g:
> > > >     $ qmicli --device-open-qmi -d /dev/wwan0p1QMI --dms-get-ids
> > > > instead of
> > > >     $ qmicli --device-open-qmi -d /dev/cdc-wdm0 --dms-get-ids
> > > >
> > >
> > > I have some questions regarding how all this would be seen from userspace.
> > >
> > > Does the MBIM control port retain the ability to query the maximum
> > > message size with an ioctl like IOCTL_WDM_MAX_COMMAND? Or is that
> > > lost? For the libmbim case this may not be a big deal, as we have a
> > > fallback mechanism to read this value from the USB descriptor itself,
> > > so just wondering.
> >
> > There is no such ioctl but we can add a sysfs property file as
> > proposed by Dan in the Intel iosm thread.
> >
>
> Yeah, that may be a good thing to add I assume.
>
> > >
> > > Is the sysfs hierarchy maintained for this new port type? i.e. if
> > > doing "udevadm info -p /sys/class/wwan/wwan0p1QMI -a", would we still
> > > see the immediate parent device with DRIVERS=="qmi_wwan" and the
> > > correct interface number/class/subclass/protocol attributes?
> >
> > Not an immediate parent since a port is a child of a logical wwan
> > device, but you'll still be able to get these attributes:
> > Below, DRIVERS=="qmi_wwan".
> >
> > $ udevadm info -p /sys/class/wwan/wwan0p1QMI -a
> >
> >   looking at device
> > '/devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.2/wwan/wwan0/wwan0p1QMI':
> >     KERNEL=="wwan0p1QMI"
> >     SUBSYSTEM=="wwan"
> >     DRIVER==""
> >
> >   looking at parent device
> > '/devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.2/wwan/wwan0':
> >     KERNELS=="wwan0"
> >     SUBSYSTEMS=="wwan"
> >     DRIVERS==""
> >
> >   looking at parent device '/devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.2':
> >     KERNELS=="2-3:1.2"
> >     SUBSYSTEMS=="usb"
> >     DRIVERS=="qmi_wwan"
> >     ATTRS{authorized}=="1"
> >     ATTRS{bInterfaceNumber}=="02"
> >     ATTRS{bInterfaceClass}=="ff"
> >     ATTRS{bNumEndpoints}=="03"
> >     ATTRS{bInterfaceProtocol}=="ff"
> >     ATTRS{bAlternateSetting}==" 0"
> >     ATTRS{bInterfaceSubClass}=="ff"
> >     ATTRS{interface}=="RmNet"
> >     ATTRS{supports_autosuspend}=="1"
> >
>
> Ok, that should be fine, and I think we would not need any additional
> change to handle that. The logic looking for what's the driver in use
> should still work.
>
> >
> > > > However, some tools may rely on cdc-wdm driver/device name for device
> > > > detection. It is then safer to keep the 'legacy' cdc-wdm character
> > > > device to prevent any breakage. This is handled in this change by
> > > > API mutual exclusion, only one access method can be used at a time,
> > > > either cdc-wdm chardev or WWAN API.
> > >
> > > How does this mutual exclusion API work? Is the kernel going to expose
> > > 2 different chardevs always for the single control port?
> >
> > Yes, if cdc-wdm0 is open, wwan0p1QMI can not be open (-EBUSY), and vice versa.
> >
>
> Oh... but then, what's the benefit of adding the new wwan0p1QMI port?
> I may be biased because I have always the MM case in mind, and in
> there we'll need to support both things, but doesn't this new port add
> more complexity than making it simpler? I would have thought that it's
> either a cdc-wdm port or a wwan port, but both? Wouldn't it make more
> sense to default to the new wwan subsystem if the wwan subsystem is
> built, and otherwise fallback to cdc-wdm? (i.e. a build time option).
> Having two chardevs to manage exactly the same control port, and
> having them mutually exclusive is a bit strange.
>
>
> > > really want to do that?
> >
> > This conservative way looks safe to me, but feel free to object if any issue.
> >
>
> I don't think adding an additional control port named differently
> while keeping the cdc-wdm name is adding any simplification in
> userspace. I understand your point of view, but if there are users
> setting up configuration with fixed cdc-wdm port names, they're
> probably not doing it right. I have no idea what's the usual approach
> of the kernel for this though, are the port names and subsystem
> considered "kernel API"? I do recall in between 3.4 and 3.6 I think
> that the subsystem of QMI ports changed from "usb" to "usbmisc"; I
> would assume your change to be kind of equivalent and therefore not a
> big deal?


The ultimate objective is to have a unified view of WWAN devices,
whatever the underlying bus or driver is. Accessing /dev/wwanXpY to
submit/receive control packets is strictly equivalent to
/dev/cdc-wdmX, the goal of keeping the 'legacy' cdc-wdm chardev, is
only to prevent breaking of tools relying on the device name. But, as
you said, the point is about considering chardev name/driver change as
UAPI change or not. From my point of view, this conservative
dual-support approach makes sense, If the user/tool is WWAN framework
aware, it uses the /dev/wwanXpY port, otherwise /dev/cdc-wdmX can be
used (like using DRM/KMS vs legacy framebuffer).

I'm however open discussing other strategies:
- Do not change anything, keep USB WWAN devices out of the WWAN subsystem.
- Migrate cdc-wdm completely to WWAN and get rid of the cdc-wdm chardev
- Build time choice, if CONFIG_WWAN, registered to WWAN, otherwise
exposed through cdc-wdm chardev.
- Run time choice, use either the new WWAN chardev or the legacy
cdc-wdm chardev (this patch)
- ...

I would be interested in getting input from others/maintainers on this.

Regards,
Loic
