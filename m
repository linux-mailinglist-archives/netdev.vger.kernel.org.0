Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B32B23A2C0
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 12:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgHCKdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 06:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgHCKdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 06:33:16 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFE7C06174A;
        Mon,  3 Aug 2020 03:33:15 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id b2so6494595qvp.9;
        Mon, 03 Aug 2020 03:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YnS4YPYVbbPD8yeFGwoNK1rU8483nEjuo7rdM0x6jOk=;
        b=cl0K9SvlfIfe7CQZ8vKrzFv6PsQkR4nWrnuI1FE4Hb5mrG1/q+Eimm3vyKOm9AxbuS
         +iZVAt27Ce8AFL/W2jKd6KI+STPI6rq+3RCbnt71wI1a6mCcDYFbij2MXCFOXKgxyfYX
         uSUNL4E+Yu0iKD2p7Vd6HLFj83meOxz6/fr7CEiGbL6rs2dmd1M1bhqT7ca8f1WJz0Qa
         A/2H6woWfAqt3EGoCFs9OvI/JghW2uqxKyAt8lVDwdijJdJ3g54cSXeRxUH5e1p2RXoo
         HpM/xzJNWgxbawrDGtY+6jFGdgC5KZuQ/pPmQ+sr2hp5R/cZbaRwj4NrA3SpVgkYkPCY
         +qrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YnS4YPYVbbPD8yeFGwoNK1rU8483nEjuo7rdM0x6jOk=;
        b=fYeHsV1bTN+SCKOefsU46pzp0XEzXhltF8e369jnDBfE1cS+puuQBlTrdgSqyYYLDj
         7cuBuiWtuqT4y4PVlEJ9dNdp5D6O/9T9j3t0WNWaa5wYNVuNS4YpTlVbNBLgbSwTnQb6
         V+vChucAfuLp4rmwCDZZPQiB8LfF1KXcL1PM6MgatUNxh3YlM+tuO9YIit4xoTAG+y6x
         1C9derXDTLmqYQasBa9thQzCa3DcA7LrzYX5dOk5BK4tvWzBrktm7Etz28gwhfTzI6u7
         jbv2HLfIWE5VYnXp8T2+zdG0OqwY5Ns1ozCl/WPPrty5R624cEZWyStYLLjs99ymYcgS
         GvUw==
X-Gm-Message-State: AOAM532XqjDjcM4eQPwGHPud8bf/dB2aEgHg0XohGMdvTCWMst6V5I26
        5IJyDMxu30Z2UfvIRLcsu0bQFBHP+qii5CSiQlk=
X-Google-Smtp-Source: ABdhPJzqY1v59zbSRjIorIhiZ/jFPc5DWQz7JHRTRnOO5LiFRATAQfmloRK6C1uPpV/uc8DflfSlO/w7tHjqwbOItys=
X-Received: by 2002:a0c:f207:: with SMTP id h7mr15287933qvk.99.1596450794775;
 Mon, 03 Aug 2020 03:33:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200803065105.8997-1-yzc666@netease.com> <20200803081604.GC493272@kroah.com>
 <CAGRyCJE-BF=0tWakreObGv-skahDp-ui8zP1TPPkX48sMFk4-w@mail.gmail.com> <20200803094931.GD635660@kroah.com>
In-Reply-To: <20200803094931.GD635660@kroah.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Mon, 3 Aug 2020 12:33:03 +0200
Message-ID: <CAGRyCJER3J4BkLohcPumdKUkQ9g39YsjERac5CSrY2-8jj+N7A@mail.gmail.com>
Subject: Re: [PATCH] qmi_wwan: support modify usbnet's rx_urb_size
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     yzc666@netease.com, =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb <linux-usb@vger.kernel.org>,
        carl <carl.yin@quectel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il giorno lun 3 ago 2020 alle ore 11:49 Greg KH
<gregkh@linuxfoundation.org> ha scritto:
>
> On Mon, Aug 03, 2020 at 10:26:18AM +0200, Daniele Palmas wrote:
> > Hi Greg,
> >
> > Il giorno lun 3 ago 2020 alle ore 10:18 Greg KH
> > <gregkh@linuxfoundation.org> ha scritto:
> > >
> > > On Mon, Aug 03, 2020 at 02:51:05PM +0800, yzc666@netease.com wrote:
> > > > From: carl <carl.yin@quectel.com>
> > > >
> > > >     When QMUX enabled, the 'dl-datagram-max-size' can be 4KB/16KB/3=
1KB depend on QUALCOMM's chipsets.
> > > >     User can set 'dl-datagram-max-size' by 'QMI_WDA_SET_DATA_FORMAT=
'.
> > > >     The usbnet's rx_urb_size must lager than or equal to the 'dl-da=
tagram-max-size'.
> > > >     This patch allow user to modify usbnet's rx_urb_size by next co=
mmand.
> > > >
> > > >               echo 4096 > /sys/class/net/wwan0/qmi/rx_urb_size
> > > >
> > > >               Next commnds show how to set and query 'dl-datagram-m=
ax-size' by qmicli
> > > >               # qmicli -d /dev/cdc-wdm1 --wda-set-data-format=3D"li=
nk-layer-protocol=3Draw-ip, ul-protocol=3Dqmap,
> > > >                               dl-protocol=3Dqmap, dl-max-datagrams=
=3D32, dl-datagram-max-size=3D31744, ep-type=3Dhsusb, ep-iface-number=3D4"
> > > >               [/dev/cdc-wdm1] Successfully set data format
> > > >                                       QoS flow header: no
> > > >                                   Link layer protocol: 'raw-ip'
> > > >                      Uplink data aggregation protocol: 'qmap'
> > > >                    Downlink data aggregation protocol: 'qmap'
> > > >                                         NDP signature: '0'
> > > >               Downlink data aggregation max datagrams: '10'
> > > >                    Downlink data aggregation max size: '4096'
> > > >
> > > >           # qmicli -d /dev/cdc-wdm1 --wda-get-data-format
> > > >               [/dev/cdc-wdm1] Successfully got data format
> > > >                                  QoS flow header: no
> > > >                              Link layer protocol: 'raw-ip'
> > > >                 Uplink data aggregation protocol: 'qmap'
> > > >               Downlink data aggregation protocol: 'qmap'
> > > >                                    NDP signature: '0'
> > > >               Downlink data aggregation max datagrams: '10'
> > > >               Downlink data aggregation max size: '4096'
> > > >
> > > > Signed-off-by: carl <carl.yin@quectel.com>
> > > > ---
> > > >  drivers/net/usb/qmi_wwan.c | 39 ++++++++++++++++++++++++++++++++++=
++++
> > > >  1 file changed, 39 insertions(+)
> > > >
> > > > diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.=
c
> > > > index 07c42c0719f5b..8ea57fd99ae43 100644
> > > > --- a/drivers/net/usb/qmi_wwan.c
> > > > +++ b/drivers/net/usb/qmi_wwan.c
> > > > @@ -400,6 +400,44 @@ static ssize_t raw_ip_store(struct device *d, =
 struct device_attribute *attr, co
> > > >       return ret;
> > > >  }
> > > >
> > > > +static ssize_t rx_urb_size_show(struct device *d, struct device_at=
tribute *attr, char *buf)
> > > > +{
> > > > +     struct usbnet *dev =3D netdev_priv(to_net_dev(d));
> > > > +
> > > > +     return sprintf(buf, "%zd\n", dev->rx_urb_size);
> > >
> > > Why do you care about this?
> > >
> > > > +}
> > > > +
> > > > +static ssize_t rx_urb_size_store(struct device *d,  struct device_=
attribute *attr,
> > > > +                              const char *buf, size_t len)
> > > > +{
> > > > +     struct usbnet *dev =3D netdev_priv(to_net_dev(d));
> > > > +     u32 rx_urb_size;
> > > > +     int ret;
> > > > +
> > > > +     if (kstrtou32(buf, 0, &rx_urb_size))
> > > > +             return -EINVAL;
> > > > +
> > > > +     /* no change? */
> > > > +     if (rx_urb_size =3D=3D dev->rx_urb_size)
> > > > +             return len;
> > > > +
> > > > +     if (!rtnl_trylock())
> > > > +             return restart_syscall();
> > > > +
> > > > +     /* we don't want to modify a running netdev */
> > > > +     if (netif_running(dev->net)) {
> > > > +             netdev_err(dev->net, "Cannot change a running device\=
n");
> > > > +             ret =3D -EBUSY;
> > > > +             goto err;
> > > > +     }
> > > > +
> > > > +     dev->rx_urb_size =3D rx_urb_size;
> > > > +     ret =3D len;
> > > > +err:
> > > > +     rtnl_unlock();
> > > > +     return ret;
> > > > +}
> > > > +
> > > >  static ssize_t add_mux_show(struct device *d, struct device_attrib=
ute *attr, char *buf)
> > > >  {
> > > >       struct net_device *dev =3D to_net_dev(d);
> > > > @@ -505,6 +543,7 @@ static DEVICE_ATTR_RW(add_mux);
> > > >  static DEVICE_ATTR_RW(del_mux);
> > > >
> > > >  static struct attribute *qmi_wwan_sysfs_attrs[] =3D {
> > > > +     &dev_attr_rx_urb_size.attr,
> > >
> > > You added a driver-specific sysfs file and did not document in in
> > > Documentation/ABI?  That's not ok, sorry, please fix up.
> > >
> > > Actually, no, this all should be done "automatically", do not change =
the
> > > urb size on the fly.  Change it at probe time based on the device you
> > > are using, do not force userspace to "know" what to do here, as it wi=
ll
> > > not know that at all.
> > >
> >
> > the problem with doing at probe time is that rx_urb_size is not fixed,
> > but depends on the configuration done at the userspace level with
> > QMI_WDA_SET_DATA_FORMAT, so the userspace knows that.
>
> Where does QMI_WDA_SET_DATA_FORMAT come from?
>

This is a request of Qualcomm proprietary protocol used, among other
things, to configure data aggregation for modems. There's an open
source userspace implementation in the libqmi project
(https://cgit.freedesktop.org/libqmi/tree/data/qmi-service-wda.json)

> And the commit log says that this "depends on the chipset being used",
> so why don't you know that at probe time, does the chipset change?  :)
>

Me too does not understand this, I let the author explain...

> > Currently there's a workaround for setting rx_urb_size i.e. changing
> > the network interface MTU: this is fine for most uses with qmap, but
> > there's the limitation that certain values (multiple of the endpoint
> > size) are not allowed.
>
> Why not just set it really high to start with?  That should not affect
> any older devices, as the urb size does not matter.  The only thing is
> if it is too small that things can not move as fast as they might be
> able to.
>

Yes, this was proposed in the past by Bj=C3=B8rn
(https://lists.freedesktop.org/archives/libqmi-devel/2020-February/003221.h=
tml),
but I was not sure about issues with old modems.

Now I understand that there are no such issues, then I agree this is
the simplest solution: I've seen modems requiring as much as 49152,
but usually the default for qmap is <=3D 16384.

And, by the way, increasing the rx urb size is required also in
non-qmap mode, since the current value leads to babbling issues with
some chipsets (mine
https://www.spinics.net/lists/linux-usb/msg198025.html and Paul's
https://lists.freedesktop.org/archives/libqmi-devel/2020-February/003217.ht=
ml),
so I think we should definitely increase this also for non-qmap mode.

Bj=C3=B8rn, what do you think?

Thanks,
Daniele

> thanks,
>
> greg k-h
