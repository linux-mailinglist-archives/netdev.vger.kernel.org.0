Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5F6352F14
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 20:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbhDBSSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 14:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234821AbhDBSSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 14:18:40 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC972C0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 11:18:38 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id j25so4071533pfe.2
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 11:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gMxIAmle9WVJYEKuo7xpyoTW8swuhRGgp4Lsoqrp5NQ=;
        b=qlYEN8VRlDf4BiCDkBm2CulaWbA08nvW4VYD8Ft9gQbpLuj5E6ZBFLxU7vTArwcbyI
         ws+YBk2Au6SuLyxgnLgoWcn50Ugk8VbM6NboMsFZqxI/dr/cHQLOaPuNxH9xjapwRTIc
         vXbf7c7/SHP/98K9i/7J96ZDXPVMFdnxtf1zNGGMVa4oK3FLWTauOl/1WZSavmsUnPKv
         beOiN0aS4vz8j1ADAhSVzJS/MgWs5FBp1u2JVZaxzt+ETeBOEq8SjFgzduUXAmbw3Yta
         T/D+YwA/o7dDX/adC8SREqNsH+hIG5JePE99oNZXNR+3/+jzGyIlqBulXzI4duuVANvK
         kRVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gMxIAmle9WVJYEKuo7xpyoTW8swuhRGgp4Lsoqrp5NQ=;
        b=bpHhTAoVVB2r1NCdHEDAIczWV5+UqVsbFZrhnFsZ5/JWvdcAON9A3D6u7wRbB6tBWF
         F8gg/NJIOxvBFb4LurvezDKCfWXKLGI1lAxTpO07TTcJMeo86oKqyucT+zxF9dpjWiwr
         rdVLUwlb5fcqjWUZQLiwsrwcTm6FWmyhqgLHavB6xz5GCyYL+SiAzTxiEpJNCAgUwmQr
         bWfwiYZSM258Me7Ub+wY+EC+lG/8AMkqU1XLPem4YJpaOkzep3zLyYF+T5Q9Jwn1cfBn
         8So7kw/8AgHmqChMtlLaALGPG3f3MDt4VGcJ8gIrVvUghR2aLOZ1oaASC9Dfu/oY9esj
         TP6Q==
X-Gm-Message-State: AOAM530dGF0GYTBD+lOFKLvkBW4lOmJJIvc07ktc+SzuxvN9cGVqVGIm
        +HMWFggb1QUI70fc3HmChP6NNgZ80bKCkw5y4iif5w==
X-Google-Smtp-Source: ABdhPJxk75V8FqlZqvS4hcREYRb4z+X8ygJ+EXw0zRgEwgueBDvvTiBt/faitthVttas8fk1WFKgvGEsgu2ZoLGcO0w=
X-Received: by 2002:a63:f903:: with SMTP id h3mr12521640pgi.443.1617387517896;
 Fri, 02 Apr 2021 11:18:37 -0700 (PDT)
MIME-Version: 1.0
References: <1617372397-13988-1-git-send-email-loic.poulain@linaro.org>
 <1617372397-13988-2-git-send-email-loic.poulain@linaro.org>
 <YGckvGqSmmVjhZII@kroah.com> <CAMZdPi_yZARCzMcs1137UPWpLxjFzQfbMkmSMhuwnfKvAdKX6g@mail.gmail.com>
 <YGc7j1tOyKWA++7U@kroah.com>
In-Reply-To: <YGc7j1tOyKWA++7U@kroah.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 2 Apr 2021 20:18:01 +0200
Message-ID: <CAMZdPi_6rkpC=0GGS6TJ8SfL1kvUSwz4KYHmut-Uxu7fqVWdAA@mail.gmail.com>
Subject: Re: [PATCH net-next v8 2/2] net: Add Qcom WWAN control driver
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        open list <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Apr 2021 at 17:43, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Apr 02, 2021 at 05:41:01PM +0200, Loic Poulain wrote:
> > On Fri, 2 Apr 2021 at 16:05, Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Fri, Apr 02, 2021 at 04:06:37PM +0200, Loic Poulain wrote:
> > > > The MHI WWWAN control driver allows MHI QCOM-based modems to expose
> > > > different modem control protocols/ports via the WWAN framework, so that
> > > > userspace modem tools or daemon (e.g. ModemManager) can control WWAN
> > > > config and state (APN config, SMS, provider selection...). A QCOM-based
> > > > modem can expose one or several of the following protocols:
> > > > - AT: Well known AT commands interactive protocol (microcom, minicom...)
> > > > - MBIM: Mobile Broadband Interface Model (libmbim, mbimcli)
> > > > - QMI: QCOM MSM/Modem Interface (libqmi, qmicli)
> > > > - QCDM: QCOM Modem diagnostic interface (libqcdm)
> > > > - FIREHOSE: XML-based protocol for Modem firmware management
> > > >         (qmi-firmware-update)
> > > >
> > > > Note that this patch is mostly a rework of the earlier MHI UCI
> > > > tentative that was a generic interface for accessing MHI bus from
> > > > userspace. As suggested, this new version is WWAN specific and is
> > > > dedicated to only expose channels used for controlling a modem, and
> > > > for which related opensource userpace support exist.
> > > >
> > > > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > > > ---
> > > >  v2: update copyright (2021)
> > > >  v3: Move driver to dedicated drivers/net/wwan directory
> > > >  v4: Rework to use wwan framework instead of self cdev management
> > > >  v5: Fix errors/typos in Kconfig
> > > >  v6: - Move to new wwan interface, No need dedicated call to wwan_dev_create
> > > >      - Cleanup code (remove legacy from mhi_uci, unused defines/vars...)
> > > >      - Remove useless write_lock mutex
> > > >      - Add mhi_wwan_wait_writable and mhi_wwan_wait_dlqueue_lock_irq helpers
> > > >      - Rework locking
> > > >      - Add MHI_WWAN_TX_FULL flag
> > > >      - Add support for NONBLOCK read/write
> > > >  v7: Fix change log (mixed up 1/2 and 2/2)
> > > >  v8: - Implement wwan_port_ops (instead of fops)
> > > >      - Remove all mhi wwan data obsolete members (kref, lock, waitqueues)
> > > >      - Add tracking of RX buffer budget
> > > >      - Use WWAN TX flow control function to stop TX when MHI queue is full
> > > >
> > > >  drivers/net/wwan/Kconfig         |  14 +++
> > > >  drivers/net/wwan/Makefile        |   2 +
> > > >  drivers/net/wwan/mhi_wwan_ctrl.c | 253 +++++++++++++++++++++++++++++++++++++++
> > > >  3 files changed, 269 insertions(+)
> > > >  create mode 100644 drivers/net/wwan/mhi_wwan_ctrl.c
> > > >
> > > > diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
> > > > index 545fe54..ce0bbfb 100644
> > > > --- a/drivers/net/wwan/Kconfig
> > > > +++ b/drivers/net/wwan/Kconfig
> > > > @@ -19,4 +19,18 @@ config WWAN_CORE
> > > >         To compile this driver as a module, choose M here: the module will be
> > > >         called wwan.
> > > >
> > > > +config MHI_WWAN_CTRL
> > > > +     tristate "MHI WWAN control driver for QCOM-based PCIe modems"
> > > > +     select WWAN_CORE
> > > > +     depends on MHI_BUS
> > > > +     help
> > > > +       MHI WWAN CTRL allows QCOM-based PCIe modems to expose different modem
> > > > +       control protocols/ports to userspace, including AT, MBIM, QMI, DIAG
> > > > +       and FIREHOSE. These protocols can be accessed directly from userspace
> > > > +       (e.g. AT commands) or via libraries/tools (e.g. libmbim, libqmi,
> > > > +       libqcdm...).
> > > > +
> > > > +       To compile this driver as a module, choose M here: the module will be
> > > > +       called mhi_wwan_ctrl
> > > > +
> > > >  endif # WWAN
> > > > diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
> > > > index 934590b..556cd90 100644
> > > > --- a/drivers/net/wwan/Makefile
> > > > +++ b/drivers/net/wwan/Makefile
> > > > @@ -5,3 +5,5 @@
> > > >
> > > >  obj-$(CONFIG_WWAN_CORE) += wwan.o
> > > >  wwan-objs += wwan_core.o
> > > > +
> > > > +obj-$(CONFIG_MHI_WWAN_CTRL) += mhi_wwan_ctrl.o
> > > > diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
> > > > new file mode 100644
> > > > index 0000000..f2fab23
> > > > --- /dev/null
> > > > +++ b/drivers/net/wwan/mhi_wwan_ctrl.c
> > > > @@ -0,0 +1,253 @@
> > > > +// SPDX-License-Identifier: GPL-2.0-only
> > > > +/* Copyright (c) 2021, Linaro Ltd <loic.poulain@linaro.org> */
> > > > +#include <linux/kernel.h>
> > > > +#include <linux/mhi.h>
> > > > +#include <linux/mod_devicetable.h>
> > > > +#include <linux/module.h>
> > > > +#include <linux/wwan.h>
> > > > +
> > > > +/* MHI wwan flags */
> > > > +#define MHI_WWAN_DL_CAP              BIT(0)
> > > > +#define MHI_WWAN_UL_CAP              BIT(1)
> > > > +#define MHI_WWAN_STARTED     BIT(2)
> > > > +
> > > > +#define MHI_WWAN_MAX_MTU     0x8000
> > > > +
> > > > +struct mhi_wwan_dev {
> > > > +     /* Lower level is a mhi dev, upper level is a wwan port */
> > > > +     struct mhi_device *mhi_dev;
> > > > +     struct wwan_port *wwan_port;
> > > > +
> > > > +     /* State and capabilities */
> > > > +     unsigned long flags;
> > > > +     size_t mtu;
> > > > +
> > > > +     /* Protect against concurrent TX and TX-completion (bh) */
> > > > +     spinlock_t tx_lock;
> > > > +
> > > > +     struct work_struct rx_refill;
> > > > +     atomic_t rx_budget;
> > >
> > > Why is this atomic if you have a real lock already?
> >
> > Access to rx_budget value is not under any locking protection and can
> > be modified (dec/inc) from different and possibly concurrent places.
>
> Then use the lock you have instead of creating a "fake lock" with the
> atomic value.  If that's really even working (you can't check it and do
> something based on it as it could change right afterward).
>
> > > > +};
> > > > +
> > > > +static bool mhi_wwan_ctrl_refill_needed(struct mhi_wwan_dev *mhiwwan)
> > > > +{
> > > > +     if (!test_bit(MHI_WWAN_STARTED, &mhiwwan->flags))
> > > > +             return false;
> > > > +
> > > > +     if (!test_bit(MHI_WWAN_DL_CAP, &mhiwwan->flags))
> > > > +             return false;
> > >
> > > What prevents these bits from being changed right after reading them?
> >
> > Nothing, I've think (maybe wrongly) it's not a problem in the current code.
>
> Why not?  Why isn't the lock being used here?
>
> Where is the lock used?
>
> > > > +
> > > > +     if (!atomic_read(&mhiwwan->rx_budget))
> > > > +             return false;
> > >
> > > Why is this atomic?  What happens if it changes right after returning?
> >
> >
> > If rx_budget was null and becomes non-null, it has been incremented by
> > __mhi_skb_destructor() which will anyway call
> > mhi_wwan_ctrl_refill_needed() again, so that's not a problem. On the
> > other hand, if rx_budget was non-null and becomes null, the
> > refill_work that will be unnecessarily scheduled will check the value
> > again and will just return without doing anything.
>
> You should document the heck out of this as it's not obvious :(
>
> > >
> > > This feels really odd.
> > >
> > > > +
> > > > +     return true;
> > > > +}
> > > > +
> > > > +void __mhi_skb_destructor(struct sk_buff *skb)
> > > > +{
> > > > +     struct mhi_wwan_dev *mhiwwan = skb_shinfo(skb)->destructor_arg;
> > > > +
> > > > +     /* RX buffer has been consumed, increase the allowed budget */
> > > > +     atomic_inc(&mhiwwan->rx_budget);
> > >
> > > So this is a reference count?  What is this thing?
> >
> > This represents the remaining number of buffers that can be allocated
> > for RX. It is decremented When a buffer is allocated/queued and
> > incremented when a buffer is consumed (e.g. on WWAN port reading).
>
> Why have any budget at all?
>
> That being said, budgets are fine, but properly lock things please.
>
> > > > +
> > > > +     if (mhi_wwan_ctrl_refill_needed(mhiwwan))
> > > > +             schedule_work(&mhiwwan->rx_refill);
> > >
> > > What if refill is needed right after this check?  Did you just miss the
> > > call?
> >
> > In running condition, refill is allowed when rx_budget is non-zero,
> > and __mhi_skb_destructor() is the only path that increments the budget
> > (and so allow refill) and schedules the refill,  so for this scenario
> > to happen it would mean that a parallel  __mhi_skb_destructor() is
> > executed (and incremented rx_budget), so this second parallel call
> > will schedule the refill.
> >
> > I realize it's probably odd, but I don't see any scenario in which we
> > can end badly (e.g. missing refill scheduling, queueing too many
> > buffers), but I admit it would be certainly simpler and less
> > error-prone with regular locking.
>
> Document this all please.
>
> > > > +static const struct mhi_device_id mhi_wwan_ctrl_match_table[] = {
> > > > +     { .chan = "DUN", .driver_data = WWAN_PORT_AT },
> > > > +     { .chan = "MBIM", .driver_data = WWAN_PORT_MBIM },
> > > > +     { .chan = "QMI", .driver_data = WWAN_PORT_QMI },
> > > > +     { .chan = "DIAG", .driver_data = WWAN_PORT_QCDM },
> > > > +     { .chan = "FIREHOSE", .driver_data = WWAN_PORT_FIREHOSE },
> > >
> > > Wait, I thought these were all going to be separate somehow.  Now they
> > > are all muxed back together?
> >
> > A WWAN 'port driver' abstracts the method for accessing WWAN control
> > protocols, so that userspace can e.g. talk MBIM to the port without
> > knowledge of the underlying bus. Here this is just about abstracting
> > the MHI/PCI transport, a  MHI modem can support one or several of
> > these protocols. So this MHI driver binds all MHI control devices, and
> > each one is registered as a WWAN port. Other 'port drivers' can be
> > created for different busses or vendors.
>
> ok, feels odd, I'll review it again for your next submission as this
> seems like just a "raw pipe" to the device and is not actually
> standardizing anything, but I could be totally wrong.

It's kind of a raw pipe since modems expose various high-level
protocols that are directly accessed by user space tools (AT/MBIM...).
There is really nothing to do from the kernel side here except using
this class for standardizing the way these protocols are accessed
(chardev read/write), and grouping them under the same 'virtual WWAN'
node.

Because of their history, modems are quite different from other pieces
of hardware such as WiFi, Bluetooth, etc... that are usually
represented through a unique device (e.g. wireless_dev, hci...) and a
well-defined API.
Modems were only voice at the beginning and only one
simple serial/uart was necessary for control purpose (via AT
commands), then data support was added (GPRS), using the existing
or secondary serial to send network data (by attaching e.g. ppp line
discipline),
Next step was the USB WWAN devices (either as regular USB stick, or
via PCMCIA with integrated USB), that initially re-used the existing
architecture by simply exposing the serial(s)/tty(s) over USB.
Later, some moved to more modern and optimized data and control
interfaces/protocols (such as QMAP, MBIM, QMI....).
At the end, it it's not surprising that you end today with several
ttyUSB*/ttyACM*, character devices, and netdev when you
plug a USB modem, all of them contributing to the whole WWAN feature,
and it's up to the user (well... ModemManager) to deal with that.
In the MHI/PCI case, the USB concept of interfaces/endpoints has simply
been translated to 'MHI channels', and we also end with a bunch of MHI
devices for network data (netdev) and controls (chardev)... How to
expose these controls channels is the question, we can either go with a
new bus specific MHI character driver (what we've tried with mhi_uci)
or initiate a bus agnostic WWAN chardev driver via this new WWAN
framework, which I agree is not much more than a factorized
passthrough layer for now.

Regards,
Loic
