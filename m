Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F153D4769
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 13:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbhGXKpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 06:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbhGXKpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 06:45:18 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99151C061575;
        Sat, 24 Jul 2021 04:25:49 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id f20-20020a9d6c140000b02904bb9756274cso4733159otq.6;
        Sat, 24 Jul 2021 04:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wmho9+Wg/RJHAISJdsior3XXLcEk7YEvFee8MxRP09k=;
        b=sBD4JZJyWmX6lsJDfGpjMimE5kudyumm+g9ej2RbDy+wldPtx+AOWP1CP9pzLNSnCt
         fniZmpcjSyXySqZMR+CI7yIbOq6xNSpN7pz71BmiK4TJfTF8hKm9GVP8buPkk4nWuimA
         yvgd5GfIp6GEfVcYkg5tSUf2i+2jpOXoLqhMox93HF0V528bcDtlaG4/cE2Zshf5tdfW
         88Som5LckR0nEdi+wwwVL2uo5KYN7CPpZRgVvuxM6c8QEu/FVXW2BhZOnB5HpwqYqndy
         uVvluUxjBI53gK+1dPEDmKefXtkMymgMoacRCF1AwItOycd0FteeVK1bTVXxAkR8pHo3
         Bd+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wmho9+Wg/RJHAISJdsior3XXLcEk7YEvFee8MxRP09k=;
        b=f3oCgdAygLb+G/KJjZFHCKJ4sBuMqpJcL5FkCHlrmjGD6zQ+Xh3DDV7K8yZ3J2CSD9
         A8Nk/KhdCC2EWmtah3v79EE3Wn/CL0JuOxqaLIOwXhAYQ3SGcWRIyu08XTAL4P0k1g+2
         A+ISeSIrVkVB6b+RnEDO7Ig21grdpSDabW5WmbFzFKihoXwPMZI1myzEIwRem5Egb1OK
         B2lzwXOpSdFuculpqetfHVKocmyEiIG8Cl6zFhWlhBvmcvjhBaEErxAk8NdDAKNBFDnp
         US3gCbp4PNPDr+EZNk76TX6euLPupl7v2Sos4/ZatZ1mjwSI4tOg1jCd8kIBjoXUivxy
         +09w==
X-Gm-Message-State: AOAM532eWDBXqWDevStAaBJcebfbthX0DSjVbUXCruoTEDIZmXY9n85T
        95OYMCA3UJ/uYfeIcZcQeKpoOapnkXhrgnMvFNk=
X-Google-Smtp-Source: ABdhPJxWgrDKgFnxb3wKdHMq7ugLW3b0qOd75IBA+QSiFRt4LAmH1DY21+1lfsI6y1v/C7JczAcLz3MBghtlQjbR88E=
X-Received: by 2002:a9d:6d83:: with SMTP id x3mr5656396otp.110.1627125949017;
 Sat, 24 Jul 2021 04:25:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210719145317.79692-1-stephan@gerhold.net> <20210719145317.79692-5-stephan@gerhold.net>
 <CAMZdPi8oxRMo0erfd0wrUPzD2UsbexoR=86u2N75Fd9RpXHoKg@mail.gmail.com> <YPmRcBXpRtKKSDl8@gerhold.net>
In-Reply-To: <YPmRcBXpRtKKSDl8@gerhold.net>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 24 Jul 2021 14:25:59 +0300
Message-ID: <CAHNKnsQr4Ys8q3Ctru-H=L3ZDwb__2D3E08mMZchDLAs1KetAg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 4/4] net: wwan: Add Qualcomm BAM-DMUX WWAN
 network driver
To:     Stephan Gerhold <stephan@gerhold.net>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        dmaengine@vger.kernel.org, devicetree <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 6:40 PM Stephan Gerhold <stephan@gerhold.net> wrote:
> On Mon, Jul 19, 2021 at 06:01:33PM +0200, Loic Poulain wrote:
>> On Mon, 19 Jul 2021 at 17:01, Stephan Gerhold <stephan@gerhold.net> wrote:
>>> I'm not sure how to integrate the driver with the WWAN subsystem yet.
>>> At the moment the driver creates network interfaces for all channels
>>> announced by the modem, it does not make use of the WWAN link management
>>> yet. Unfortunately, this is a bit complicated:
>>>
>>> Both QMAP and the built-in multiplexing layer might be needed at some point.
>>> There are firmware versions that do not support QMAP and the other way around
>>> (the built-in multiplexing was disabled on very recent firmware versions).
>>> Only userspace can check if QMAP is supported in the firmware (via QMI).
>>>
>>> I could ignore QMAP completely for now but I think someone will show up
>>> who will need this eventually. And if there is going to be common code for
>>> QMAP/rmnet link management it would be nice if BAM-DMUX could also make
>>> use of it.
>>
>> I have this on my TODO list for mhi-net QMAP.
>
> Great, thanks!
>
>>> But the question is, how could this look like? How do we know if we should
>>> create a link for QMAP or a BAM-DMUX channel? Does it even make sense
>>> to manage the 1-8 channels via the WWAN link management?
>>
>> Couldn't it be specified via dts (property or different compatible
>> string)?
>
> It would probably work in most cases, but I have to admit that I would
> prefer to avoid this for the following reason: This driver is used on
> some smartphones that have different variants for different parts of the
> world. As far as Linux is concerned the hardware is pretty much
> identical, but the modem firmware is often somewhat device-specific.
>
> This means that the same device tree is often used with different
> firmware versions. Perhaps we are lucky enough that the firmware
> versions have the same capabilities, but I'm not fully sure about that.
>
> I think at the end the situation is fairly similar to qmi_wwan/USB.
> There the kernel also does not know if the modem supports QMAP or not.
> The way it's solved there at the moment is that ModemManager tries to
> enable it from user space and then the mode of the network interface
> can be switched through a sysfs file ("qmi/pass_through").
>
> Something like this should probably also work in my case. This should
> also allow me to ignore QMAP for now and deal with it if someone really
> needs it at some point since it's quite complicated for BAM-DMUX.
> (I tried QMAP again today and listed the problems in [1] for reference,
>  but it's all BAM-DMUX specific...)
>
> [1] https://lore.kernel.org/netdev/YPmF8bzevuabO2K9@gerhold.net/
>
>> would it make sense to have two drivers (with common core) to
>> manage either the multi-bam channel or newer QMAP based single
>> bam-channel modems.
>
> There should be fairly little difference between those two usage modes,
> so I don't think it's worth splitting the driver for this. Actually
> right now (ignoring the link management of the WWAN subsystem),
> it's already possible to use both.
>
> I can use the network interfaces as-is in Raw-IP mode or I do
> "sudo ip link add link rmnet0 name rmnet0_qmap type rmnet mux_id 1"
> on top and use QMAP. The BAM-DMUX driver does not care, because it
> just hands over sent/received packets as-is and the modem data format
> must be always configured via QMI from user space.
>
>>> Another problem is that the WWAN subsystem currently creates all network
>>> interfaces below the common WWAN device. This means that userspace like
>>> ModemManager has no way to check which driver provides them. This is
>>> necessary though to decide how to set it up via QMI (ModemManager uses it).
>>
>> Well, I have quite a similar concern since I'm currently porting
>> mhi-net mbim to wwan framework, and I was thinking about not making
>> wwan device parent of the network link/netdev (in the same way as
>> wlan0 is not child of ieee80211 device), but not sure if it's a good
>> idea or not since we can not really consider driver name part of the
>> uapi.
>
> Hm, I think the main disadvantage of that would be that the network
> interface is no longer directly related to the WWAN device, right?
> Userspace would then need some special matching to find the network
> interfaces that belong to a certain control port.
>
> With the current setup, e.g. ModemManager can simply match the WWAN
> device and then look at its children and find the control port and
> network interfaces. How would it find the network interfaces if they are
> no longer below the WWAN device?
>
> > The way links are created is normally abstracted, so if you know which
> > bam variant you have from wwan network driver side (e.g. via dts), you
> > should have nothing to check on the user side, except the session id.
>
> In a perfect world it would probably be like this, but I'm afraid the
> Qualcomm firmware situation isn't as simple. User space needs to know
> which setup it is dealing with because all the setup happens via QMI.
>
> Let's take the BAM-DMUX channels vs QMAP mux-IDs for example:
>
> First, user space needs to configure the data format. This happens with
> the QMI WDA (Wireless Data Administrative Service) "Set Data Format"
> message. Parameter would be link layer format (Raw-IP in both cases)
> but also the uplink/downlink data aggregation protocol. This is either
> one of many QMAP versions (qmap|qmapv2|qmapv3|qmapv4|qmapv5), or simply
> "none" when using BAM-DMUX without QMAP.
>
> Then, the "session ID" (= BAM-DMUX channel or QMAP mux-ID) must be bound
> to a WDS (Wireless Data Service) session. The QMI message for that is
> different for BAM-DMUX and QMAP:
>
>   - BAM-DMUX: WDS "Bind Data Port"
>       (Parameter: SIO port number, can be derived from channel ID)
>
>   - QMAP: WDS "Bind MUX Data Port" (note the "MUX", different message!)
>       (Parameter: MUX ID, port type (USB/embedded/...), port number)
>
> My point here: Since userspace is responsible for QMI at the moment
> we will definitely need to make it aware of the setup that it needs to
> apply. Just having an abstract "session ID" won't be enough to set up
> the connection properly. :/

Stephan, Loic, I have a polemic question related to a drivers model
that we should build to smoothly support qualcomm hardware by the
kernel. I would depict the situation as I see it and then ask the
question. Please correct me if I am misunderstanding something or
simply wrong. Or maybe you will be gracious once more and point me to
earlier discussions :)

We always talk that a userspace software should take care of
multiplexing configuration to make data communication possible at all.
The motivation here is simple - management protocol (QMI) is complex,
userspace software must implement it anyway to manage network
connectivity, so why not implement the multiplexing management there
too?

This way the userspace software that should simply command a "modem"
to establish a data connection and poll a "modem" for a signal level
became a self contained device manager that knows all modem-to-host
interconnection details and even must to perform an initial
modem-to-host interfaces negotiation and configuration. The last task
is what userspace software usually expects to be performed by an OS
kernel.

But what if we implement the QMI multiplexing management part in the
kernel? This way the kernel will take care about modem-to-host
communication protocols and interfaces, and provides userspace with a
single WWAN device (possibly with multiple network and network
management interfaces).

I do not propose to fully implement QMI protocol inside the kernel,
but implement only a mux management part, while passing all other
messages between a "modem" and a userspace software as-is.

What pros and cons of such a design do you see?

-- 
Sergey
