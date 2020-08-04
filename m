Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D282123B884
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 12:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgHDKOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 06:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgHDKOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 06:14:05 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D3BC06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 03:14:05 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id b30so22051329lfj.12
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 03:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LktSD0GDAmnkBmBwptIgps9F92P71iAP/NC7BG6uhsw=;
        b=Li8yWgFgXSfBF5hINl+KxWV+Orl1QmxwKDUgyXW2Im9OvkncU8s0Se8k1lgzBNnNH4
         +U6GBYpDgWBqYIWOgfqCBb4bDMOcsh2k4oRBcpAj3YhsIW7bFGZ6HOk/qqab6ei352Hh
         b8vYTpBNyC/irtMdq7omLR9P/9Z4S0TJLdy/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LktSD0GDAmnkBmBwptIgps9F92P71iAP/NC7BG6uhsw=;
        b=Hx2yu/IAXeh0FDGi4CgjzLRVvi9t90OUda0WSQyl2mjIbzSW3IcTFuyS8ygLcddk6Q
         DKiGGqw89BJ9sYnf5es0KBGigY/z+DRGcdcOV60GYUFMYO1/O+IJU83qaOmA/QMV75cs
         pMAsOuYuS0r296ezKPZyQQwuVEpx4718xR8qg/DsYhy0h5E9d5g7Px4UaumTclpM4xt2
         oI3sJCvrhKyG3ilZXj9qRl+HJ48SEkb1VyzavEReyQpiqfEtP8wIGexDTUNvtM6S2VJl
         F48qeNbG5ZsNCTX7ANqzczIykgRKpaebX/0/nxBs1nU4hbQJpLQ+dep4PhzhWmdI/9Nt
         +gGA==
X-Gm-Message-State: AOAM532Dd1pYAjGT+2C1AzPS6IBb3LqKJGq+m6FdcSkdRwAFj5v81wt/
        brn5OivbLEOZ1F/EGFHf5zximcqaIZP94YCwPfpAIQOa
X-Google-Smtp-Source: ABdhPJyW+uYQRJhhgXAVBvh6Tu9btpAQM4uWbOhrNdM2FOnO8dZkjhsRmorOBZCbjSH5c6gF4bRQND7acKgtweih4OY=
X-Received: by 2002:a19:4c57:: with SMTP id z84mr10945520lfa.92.1596536043506;
 Tue, 04 Aug 2020 03:14:03 -0700 (PDT)
MIME-Version: 1.0
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
 <CAACQVJqNXh0B=oe5W7psiMGc6LzNPujNe2sypWi_SvH5sY=F3Q@mail.gmail.com>
 <a3e20b44-9399-93c1-210f-e3c1172bf60d@intel.com> <CAACQVJo+bAr_k=LjgdTKbOxFEkpbYAsaWbkSDjUepgO7_XQfNA@mail.gmail.com>
 <7a9c315f-fa29-7bd5-31be-3748b8841b29@mellanox.com> <CAACQVJpZZPfiWszZ36E0Awuo2Ad1w5=4C1rgG=d4qPiWVP609Q@mail.gmail.com>
 <7fd63d16-f9fa-9d55-0b30-fe190d0fb1cb@mellanox.com>
In-Reply-To: <7fd63d16-f9fa-9d55-0b30-fe190d0fb1cb@mellanox.com>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Tue, 4 Aug 2020 15:43:52 +0530
Message-ID: <CAACQVJqXa-8v4TU+M1DWA2Tfv3ayrAobiH9Fajd=5MCgsfAA6A@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/13] Add devlink reload level option
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 3, 2020 at 7:23 PM Moshe Shemesh <moshe@mellanox.com> wrote:
>
>
> On 8/3/2020 3:47 PM, Vasundhara Volam wrote:
> > On Mon, Aug 3, 2020 at 5:47 PM Moshe Shemesh <moshe@mellanox.com> wrote:
> >>
> >> On 8/3/2020 1:24 PM, Vasundhara Volam wrote:
> >>> On Tue, Jul 28, 2020 at 10:13 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
> >>>>
> >>>> On 7/27/2020 10:25 PM, Vasundhara Volam wrote:
> >>>>> On Mon, Jul 27, 2020 at 4:36 PM Moshe Shemesh <moshe@mellanox.com> wrote:
> >>>>>> Introduce new option on devlink reload API to enable the user to select the
> >>>>>> reload level required. Complete support for all levels in mlx5.
> >>>>>> The following reload levels are supported:
> >>>>>>     driver: Driver entities re-instantiation only.
> >>>>>>     fw_reset: Firmware reset and driver entities re-instantiation.
> >>>>> The Name is a little confusing. I think it should be renamed to
> >>>>> fw_live_reset (in which both firmware and driver entities are
> >>>>> re-instantiated).  For only fw_reset, the driver should not undergo
> >>>>> reset (it requires a driver reload for firmware to undergo reset).
> >>>>>
> >>>> So, I think the differentiation here is that "live_patch" doesn't reset
> >>>> anything.
> >>> This seems similar to flashing the firmware and does not reset anything.
> >>
> >> The live patch is activating fw change without reset.
> >>
> >> It is not suitable for any fw change but fw gaps which don't require reset.
> >>
> >> I can query the fw to check if the pending image change is suitable or
> >> require fw reset.
> > Okay.
> >>>>>>     fw_live_patch: Firmware live patching only.
> >>>>> This level is not clear. Is this similar to flashing??
> >>>>>
> >>>>> Also I have a basic query. The reload command is split into
> >>>>> reload_up/reload_down handlers (Please correct me if this behaviour is
> >>>>> changed with this patchset). What if the vendor specific driver does
> >>>>> not support up/down and needs only a single handler to fire a firmware
> >>>>> reset or firmware live reset command?
> >>>> In the "reload_down" handler, they would trigger the appropriate reset,
> >>>> and quiesce anything that needs to be done. Then on reload up, it would
> >>>> restore and bring up anything quiesced in the first stage.
> >>> Yes, I got the "reload_down" and "reload_up". Similar to the device
> >>> "remove" and "re-probe" respectively.
> >>>
> >>> But our requirement is a similar "ethtool reset" command, where
> >>> ethtool calls a single callback in driver and driver just sends a
> >>> firmware command for doing the reset. Once firmware receives the
> >>> command, it will initiate the reset of driver and firmware entities
> >>> asynchronously.
> >>
> >> It is similar to mlx5 case here for fw_reset. The driver triggers the fw
> >> command to reset and all PFs drivers gets events to handle and do
> >> re-initialization.  To fit it to the devlink reload_down and reload_up,
> >> I wait for the event handler to complete and it stops at driver unload
> >> to have the driver up by devlink reload_up. See patch 8 in this patchset.
> >>
> > Yes, I see reload_down is triggering the reset. In our driver, after
> > triggering the reset through a firmware command, reset is done in
> > another context as the driver initiates the reset only after receiving
> > an ASYNC event from the firmware.
>
>
> Same here.
>
> >
> > Probably, we have to use reload_down() to send firmware command to
> > trigger reset and do nothing in reload_up.
> I had that in previous version, but its wrong to use devlink reload this
> way, so I added wait with timeout for the event handling to complete
> before unload_down function ends. See mlx5_fw_wait_fw_reset_done(). Also
> the event handler stops before load back to have that done by devlink
> reload_up.
But "devlink dev reload" will be invoked by the user only on a single
dev handler and all function drivers will be re-instantiated upon the
ASYNC event. reload_down and reload_up are invoked only the function
which the user invoked.

Take an example of a 2-port (PF0 and PF1) adapter on a single host and
with some VFs loaded on the device. User invokes "devlink dev reload"
on PF0, ASYNC event is received on 2 PFs and VFs for reset. All the
function drivers will be re-instantiated including PF0.

If we wait for some time in reload_down() of PF0 and then call load in
reload_up(), this code will be different from other function drivers.

> >   And returning from reload
> > does not mean that reset is complete as it is done in another context
> > and the driver notifies the health reporter once the reset is
> > complete. devlink framework may have to allow drivers to implement
> > reload_down only to look more clean or call reload_up only if the
> > driver notifies the devlink once reset is completed from another
> > context. Please suggest.
