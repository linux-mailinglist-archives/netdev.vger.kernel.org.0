Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B63E23C641
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 08:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgHEGzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 02:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728091AbgHEGzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 02:55:17 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB69FC06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 23:55:15 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id i10so11656498ljn.2
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 23:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JzOtpPJGzpk27qLUM9ywxcX4QZa0HVAQQ/bWzHU7nKE=;
        b=MxfExJLbBqi8zM89C2o7I6zk5aDRHW8HQoOMKQfJ5QxzzMpYOLu5dKMtpLpcYgBwx2
         GgbFpMOP/udHpuKFTPxNVEbxrRizO5xo/xPzd93DWy5oJ4UpJplUDTIs/d5wjgJdnxz2
         DrL8BNs8MUBCQr7RhOx20UqGMf1W1UuC6zxT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JzOtpPJGzpk27qLUM9ywxcX4QZa0HVAQQ/bWzHU7nKE=;
        b=LmoDtbZfkiL9rbRSSX27wqQ+THmybPG4AOz34i2sQ0qKraucmuppeOcS0HLTy3Tst6
         zckYRjqW/vNbn/LtLVeehN48YorHt2l3TOz/U426ARt85GV7etx8SyKZesi4MkDARevo
         GcPxSC/fMaHuizbn5WHlEGKRi+LDQtyyuUWqrLz3gP2dQB06XuMBmSs0NMMmA+hWyNB/
         cRSov+ae7AHqgduPVgAYQK6XRyAL1n+tNmT+8JUktH29Q/XUH0ybggvo82ahMUPUgc4o
         fpgqLGCu4WFE0pna4KSA/IMN0RTcwuON9XyEPOp6PpvSfRY0XFwBGtiOTUADSRRhZEGt
         e2sA==
X-Gm-Message-State: AOAM533aMTB3bwV3wmc4X8rKmRJx3w6LmiuJuSN95wjuQN3j9DfWwoMF
        qS9hdhGZbrnNPPl9nj6rzcWHHQGhmYUPrXZ44HYxCvsD
X-Google-Smtp-Source: ABdhPJyP3hxVOtUiojqCuVUAe79LusZ/8z9+u42jOdj1jGaS6vCskKQ2Rd/Yv0RqPuFHfQCDy3QFjLq7RULdaXOHslQ=
X-Received: by 2002:a2e:2f02:: with SMTP id v2mr759796ljv.391.1596610513852;
 Tue, 04 Aug 2020 23:55:13 -0700 (PDT)
MIME-Version: 1.0
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
 <CAACQVJqNXh0B=oe5W7psiMGc6LzNPujNe2sypWi_SvH5sY=F3Q@mail.gmail.com>
 <a3e20b44-9399-93c1-210f-e3c1172bf60d@intel.com> <CAACQVJo+bAr_k=LjgdTKbOxFEkpbYAsaWbkSDjUepgO7_XQfNA@mail.gmail.com>
 <7a9c315f-fa29-7bd5-31be-3748b8841b29@mellanox.com> <CAACQVJpZZPfiWszZ36E0Awuo2Ad1w5=4C1rgG=d4qPiWVP609Q@mail.gmail.com>
 <7fd63d16-f9fa-9d55-0b30-fe190d0fb1cb@mellanox.com> <CAACQVJqXa-8v4TU+M1DWA2Tfv3ayrAobiH9Fajd=5MCgsfAA6A@mail.gmail.com>
 <da0e4997-73d7-9f3c-d877-f2d3bcc718b9@mellanox.com>
In-Reply-To: <da0e4997-73d7-9f3c-d877-f2d3bcc718b9@mellanox.com>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Wed, 5 Aug 2020 12:25:02 +0530
Message-ID: <CAACQVJofS2B3y40H=QxBzNaccsa+gNnSqfmoATyML_S686ykfw@mail.gmail.com>
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

On Wed, Aug 5, 2020 at 12:02 PM Moshe Shemesh <moshe@mellanox.com> wrote:
>
>
> On 8/4/2020 1:13 PM, Vasundhara Volam wrote:
> > On Mon, Aug 3, 2020 at 7:23 PM Moshe Shemesh <moshe@mellanox.com> wrote:
> >>
> >> On 8/3/2020 3:47 PM, Vasundhara Volam wrote:
> >>> On Mon, Aug 3, 2020 at 5:47 PM Moshe Shemesh <moshe@mellanox.com> wrote:
> >>>> On 8/3/2020 1:24 PM, Vasundhara Volam wrote:
> >>>>> On Tue, Jul 28, 2020 at 10:13 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
> >>>>>> On 7/27/2020 10:25 PM, Vasundhara Volam wrote:
> >>>>>>> On Mon, Jul 27, 2020 at 4:36 PM Moshe Shemesh <moshe@mellanox.com> wrote:
> >>>>>>>> Introduce new option on devlink reload API to enable the user to select the
> >>>>>>>> reload level required. Complete support for all levels in mlx5.
> >>>>>>>> The following reload levels are supported:
> >>>>>>>>      driver: Driver entities re-instantiation only.
> >>>>>>>>      fw_reset: Firmware reset and driver entities re-instantiation.
> >>>>>>> The Name is a little confusing. I think it should be renamed to
> >>>>>>> fw_live_reset (in which both firmware and driver entities are
> >>>>>>> re-instantiated).  For only fw_reset, the driver should not undergo
> >>>>>>> reset (it requires a driver reload for firmware to undergo reset).
> >>>>>>>
> >>>>>> So, I think the differentiation here is that "live_patch" doesn't reset
> >>>>>> anything.
> >>>>> This seems similar to flashing the firmware and does not reset anything.
> >>>> The live patch is activating fw change without reset.
> >>>>
> >>>> It is not suitable for any fw change but fw gaps which don't require reset.
> >>>>
> >>>> I can query the fw to check if the pending image change is suitable or
> >>>> require fw reset.
> >>> Okay.
> >>>>>>>>      fw_live_patch: Firmware live patching only.
> >>>>>>> This level is not clear. Is this similar to flashing??
> >>>>>>>
> >>>>>>> Also I have a basic query. The reload command is split into
> >>>>>>> reload_up/reload_down handlers (Please correct me if this behaviour is
> >>>>>>> changed with this patchset). What if the vendor specific driver does
> >>>>>>> not support up/down and needs only a single handler to fire a firmware
> >>>>>>> reset or firmware live reset command?
> >>>>>> In the "reload_down" handler, they would trigger the appropriate reset,
> >>>>>> and quiesce anything that needs to be done. Then on reload up, it would
> >>>>>> restore and bring up anything quiesced in the first stage.
> >>>>> Yes, I got the "reload_down" and "reload_up". Similar to the device
> >>>>> "remove" and "re-probe" respectively.
> >>>>>
> >>>>> But our requirement is a similar "ethtool reset" command, where
> >>>>> ethtool calls a single callback in driver and driver just sends a
> >>>>> firmware command for doing the reset. Once firmware receives the
> >>>>> command, it will initiate the reset of driver and firmware entities
> >>>>> asynchronously.
> >>>> It is similar to mlx5 case here for fw_reset. The driver triggers the fw
> >>>> command to reset and all PFs drivers gets events to handle and do
> >>>> re-initialization.  To fit it to the devlink reload_down and reload_up,
> >>>> I wait for the event handler to complete and it stops at driver unload
> >>>> to have the driver up by devlink reload_up. See patch 8 in this patchset.
> >>>>
> >>> Yes, I see reload_down is triggering the reset. In our driver, after
> >>> triggering the reset through a firmware command, reset is done in
> >>> another context as the driver initiates the reset only after receiving
> >>> an ASYNC event from the firmware.
> >>
> >> Same here.
> >>
> >>> Probably, we have to use reload_down() to send firmware command to
> >>> trigger reset and do nothing in reload_up.
> >> I had that in previous version, but its wrong to use devlink reload this
> >> way, so I added wait with timeout for the event handling to complete
> >> before unload_down function ends. See mlx5_fw_wait_fw_reset_done(). Also
> >> the event handler stops before load back to have that done by devlink
> >> reload_up.
> > But "devlink dev reload" will be invoked by the user only on a single
> > dev handler and all function drivers will be re-instantiated upon the
> > ASYNC event. reload_down and reload_up are invoked only the function
> > which the user invoked.
> >
> > Take an example of a 2-port (PF0 and PF1) adapter on a single host and
> > with some VFs loaded on the device. User invokes "devlink dev reload"
> > on PF0, ASYNC event is received on 2 PFs and VFs for reset. All the
> > function drivers will be re-instantiated including PF0.
> >
> > If we wait for some time in reload_down() of PF0 and then call load in
> > reload_up(), this code will be different from other function drivers.
>
>
> I see your point here, but the user run devlink reload command on one
> PF, in this case of fw-reset it will influence other PFs, but that's a
> result of the fw-reset, the user if asked for params change or namespace
> change that was for this PF.
Right, if any driver is implementing only fw-reset have to leave
reload_up as an empty function.

>
> >>>    And returning from reload
> >>> does not mean that reset is complete as it is done in another context
> >>> and the driver notifies the health reporter once the reset is
> >>> complete. devlink framework may have to allow drivers to implement
> >>> reload_down only to look more clean or call reload_up only if the
> >>> driver notifies the devlink once reset is completed from another
> >>> context. Please suggest.
