Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FEA3388FB
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 10:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbhCLJsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 04:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233152AbhCLJsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 04:48:30 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FC5C061761
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 01:48:30 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so10502621pjh.1
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 01:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tSU5JZNqo+LpLrL2J51K9EjU+XyoQGqUAnrQL7MEH1A=;
        b=BSO27GPbEPW3Y0DxHwpWJXPbfk/efqUoz0Ts35dPQpg3azwscSr3PyX6Yvg1k5/Vvu
         rrrKcjRhyk3g9vbulgwJ+N5Snq3ZMDz+Yfzm5q4as7sqj2xhSh3jRLERoymuwTZaHmGQ
         O470J/wbp0z+szFwzPzJruJlo2PA7kZ75ZS7szfch+9Y127uDd1aSJvvqElBJWFCIf30
         EOqG672RXJKBBrRSlnLfGzZhidgoyLob8Y+/2ZFdABSbWS75rLEc6WL8M+p+wEcL7kNe
         nH26iT8xLXYiPICHd41uyOYR4e4BMA/QWgP3JsWJoQUlEebA0qx3xde1XG0p/VsH0nx/
         Pybw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tSU5JZNqo+LpLrL2J51K9EjU+XyoQGqUAnrQL7MEH1A=;
        b=qbt+HVkhqvji4cm2sVyTG1PbULNU6aA3nHJaufug6wMVz7BPOevnnro7wZHUV+jxj8
         gjlJzTr3kdnx5i7ckK+WiohpJ2nXBFzOhPpRLJoNhOCIY8+KjxHnH1P0H8uVnXy3px7V
         HPTRFhhi6FccehwhFUv5mtnAXIBpRCyudjSPcY3NO0H0dAV4rS+D95rkB3MOQhLVRbcB
         WbWdf10gnYYh7HnnQqCG7s9UbBiG3gPf1FxjA/LbvWNuSBG8bHtBckKwaQrWXTOnmDXv
         33Xk6pQ0zseXYUwR1UYNrkTdmpZOZj3LWKOkeDMHUZBaVZPKSnT1z/Ay4bOPmKbKaQHh
         l/oQ==
X-Gm-Message-State: AOAM532Z5eWwG0nWF1jh//V3C7QUk2VZGlQ0XAV9/x3Pu7d5gxYJKw8a
        lvrreTXZhM0gEshVXQ9zCblkLfyla1dzRe6qHK5Hzw==
X-Google-Smtp-Source: ABdhPJw36o2X0nO0HlNpiC9Gns3o1MZJQZ1G66o2rNmvzS6qI9yLSWVNqK2hTXy0D/2zAf4BkSxNTx323LRQ7k7BbX8=
X-Received: by 2002:a17:90a:1463:: with SMTP id j90mr13526493pja.205.1615542510061;
 Fri, 12 Mar 2021 01:48:30 -0800 (PST)
MIME-Version: 1.0
References: <1615495264-6816-1-git-send-email-loic.poulain@linaro.org>
 <1615495264-6816-2-git-send-email-loic.poulain@linaro.org> <YEsjbnOPihKPJYpx@kroah.com>
In-Reply-To: <YEsjbnOPihKPJYpx@kroah.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 12 Mar 2021 10:56:30 +0100
Message-ID: <CAMZdPi83Bzo=ucLr_PFshRJqAeUqcnTwR-eJ3f1WAOaA1ZoDQw@mail.gmail.com>
Subject: Re: [PATCH net-next v5 2/2] net: Add Qcom WWAN control driver
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        open list <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>, rdunlap@infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On Fri, 12 Mar 2021 at 09:16, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Mar 11, 2021 at 09:41:04PM +0100, Loic Poulain wrote:
> > The MHI WWWAN control driver allows MHI QCOM-based modems to expose
> > different modem control protocols/ports to userspace, so that userspace
> > modem tools or daemon (e.g. ModemManager) can control WWAN config
> > and state (APN config, SMS, provider selection...). A QCOM-based
> > modem can expose one or several of the following protocols:
> > - AT: Well known AT commands interactive protocol (microcom, minicom...)
> > - MBIM: Mobile Broadband Interface Model (libmbim, mbimcli)
> > - QMI: QCOM MSM/Modem Interface (libqmi, qmicli)
> > - QCDM: QCOM Modem diagnostic interface (libqcdm)
> > - FIREHOSE: XML-based protocol for Modem firmware management
> >         (qmi-firmware-update)
> >
> > The different interfaces are exposed as character devices through the
> > WWAN subsystem, in the same way as for USB modem variants.
> >
> > Note that this patch is mostly a rework of the earlier MHI UCI
> > tentative that was a generic interface for accessing MHI bus from
> > userspace. As suggested, this new version is WWAN specific and is
> > dedicated to only expose channels used for controlling a modem, and
> > for which related opensource user support exist. Other MHI channels
> > not fitting the requirements will request either to be plugged to
> > the right Linux subsystem (when available) or to be discussed as a
> > new MHI driver (e.g AI accelerator, WiFi debug channels, etc...).
> >
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > ---
> >  v2: update copyright (2021)
> >  v3: Move driver to dedicated drivers/net/wwan directory
> >  v4: Rework to use wwan framework instead of self cdev management
> >  v5: Fix errors/typos in Kconfig
> >
> >  drivers/net/wwan/Kconfig         |  14 ++
> >  drivers/net/wwan/Makefile        |   1 +
> >  drivers/net/wwan/mhi_wwan_ctrl.c | 497 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 512 insertions(+)
> >  create mode 100644 drivers/net/wwan/mhi_wwan_ctrl.c
> >
> > diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
> > index 545fe54..ce0bbfb 100644
> > --- a/drivers/net/wwan/Kconfig
> > +++ b/drivers/net/wwan/Kconfig
> > @@ -19,4 +19,18 @@ config WWAN_CORE
> >         To compile this driver as a module, choose M here: the module will be
> >         called wwan.
> >
> > +config MHI_WWAN_CTRL
> > +     tristate "MHI WWAN control driver for QCOM-based PCIe modems"
> > +     select WWAN_CORE
> > +     depends on MHI_BUS
> > +     help
> > +       MHI WWAN CTRL allows QCOM-based PCIe modems to expose different modem
> > +       control protocols/ports to userspace, including AT, MBIM, QMI, DIAG
> > +       and FIREHOSE. These protocols can be accessed directly from userspace
> > +       (e.g. AT commands) or via libraries/tools (e.g. libmbim, libqmi,
> > +       libqcdm...).
> > +
> > +       To compile this driver as a module, choose M here: the module will be
> > +       called mhi_wwan_ctrl
> > +
> >  endif # WWAN
> > diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
> > index ca8bb5a..e18ecda 100644
> > --- a/drivers/net/wwan/Makefile
> > +++ b/drivers/net/wwan/Makefile
> > @@ -6,3 +6,4 @@
> >  obj-$(CONFIG_WWAN_CORE) += wwan.o
> >  wwan-objs += wwan_core.o wwan_port.o
> >
> > +obj-$(CONFIG_MHI_WWAN_CTRL) += mhi_wwan_ctrl.o
> > diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
> > new file mode 100644
> > index 0000000..abda4b0
> > --- /dev/null
> > +++ b/drivers/net/wwan/mhi_wwan_ctrl.c
> > @@ -0,0 +1,497 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright (c) 2018-2021, The Linux Foundation. All rights reserved.*/
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/mhi.h>
> > +#include <linux/mod_devicetable.h>
> > +#include <linux/module.h>
> > +#include <linux/poll.h>
> > +
> > +#include "wwan_core.h"
> > +
> > +#define MHI_WWAN_CTRL_DRIVER_NAME "mhi_wwan_ctrl"
> > +#define MHI_WWAN_CTRL_MAX_MINORS 128
> > +#define MHI_WWAN_MAX_MTU 0x8000
> > +
> > +/* MHI wwan device flags */
> > +#define MHI_WWAN_DL_CAP              BIT(0)
> > +#define MHI_WWAN_UL_CAP              BIT(1)
> > +#define MHI_WWAN_CONNECTED   BIT(2)
> > +
> > +struct mhi_wwan_buf {
> > +     struct list_head node;
> > +     void *data;
> > +     size_t len;
> > +     size_t consumed;
> > +};
> > +
> > +struct mhi_wwan_dev {
> > +     unsigned int minor;
>
> You never use this, why is it here?
>
> {sigh}
>
> Who reviewed this series before sending it out?

I clearly moved too fast on the wwan/mhi split and overlooked
the refactoring, I'll ensure to get a proper internal review before
resubmitting a new version.

Thanks,
Loic

>
> greg k-h
