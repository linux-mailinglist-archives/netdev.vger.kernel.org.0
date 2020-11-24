Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD052C306D
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 20:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404388AbgKXTFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 14:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404185AbgKXTFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 14:05:13 -0500
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573D9C0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 11:05:13 -0800 (PST)
Received: by mail-ua1-x944.google.com with SMTP id t15so7170295ual.6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 11:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+W7jJwGCb4X3aPAYb2bHPal61y/DMNXzXOlkAo3IyKk=;
        b=dhla6vIb81DplBpzZLwmgSqIMb8/g00dQOHCA8f7CzfLhqNexO5v1F9qzMupZ/M44P
         JDyHyiO1hLjhNR86YyCqljUxDMrfYV0ZHB5zX8efRxxgVDl4JEfFDEvOYJSK+Aq5VWk1
         iQYuKHw1wr+jCurwMWlFlJs+R16OqgXWjn7vE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+W7jJwGCb4X3aPAYb2bHPal61y/DMNXzXOlkAo3IyKk=;
        b=H33+SqBpj+1WZPI8piaJOkGygvlIM8GYolF7+DtURffnY6iUW99Vm/Zyqht8pJkBDh
         3TQ+vB3b8hgSbi+tialKaLzQv+uMFz9U4ZvW9QyOtnNKWjK+hO2oi9rhRuc6saC7Sj9J
         5rv7H42wAULL8rQ9+U179+SMnZ0yO31Ip5GPArUkKdHvgPaEjfz7EMnlsK1o2l13KDQC
         IXcqoLmjgWYJKDg6SOZDfUrLVUP8ji3VyCOQv9GC2prMX2VpMZb3PgWsbzYq5NT9OyV5
         2uBuZcHFXGQ46LRtU0egTppWWTct0CTSCFZ4FXyEs1FMDygqsxL8SUxbdJCXEDQo0Pxi
         cWFw==
X-Gm-Message-State: AOAM530oJNDkghNyf7Sl/9a6yUKd4B0XcHLe2xjE37z+IQLUMujhKAfA
        ZAqVnFs5Z5YfBGEoFqwE2t/kumdCJQiXCQIC9V18Dw==
X-Google-Smtp-Source: ABdhPJyHTtIH9cQFnt3Xhe+ipjomhQWZ5hH5ArFW70nlKMDCzYjQRa9WqWHfKD2+DwU4kKasH0oOSf7Cdzg9e/Slh/c=
X-Received: by 2002:ab0:104c:: with SMTP id g12mr4823113uab.136.1606244710878;
 Tue, 24 Nov 2020 11:05:10 -0800 (PST)
MIME-Version: 1.0
References: <20201118234352.2138694-1-abhishekpandit@chromium.org>
 <7235CD4E-963C-4BCB-B891-62494AD7F10D@holtmann.org> <CANFp7mVSGNbwCkWCj=bVzbE8L38nwu0+UMR9jkOYcYQmGBaAEw@mail.gmail.com>
In-Reply-To: <CANFp7mVSGNbwCkWCj=bVzbE8L38nwu0+UMR9jkOYcYQmGBaAEw@mail.gmail.com>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Tue, 24 Nov 2020 11:04:59 -0800
Message-ID: <CANFp7mU_5rU1VdgBFcyWtNH-TD1n3wOpAh5o_aAN_3s1+AkaFw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Bluetooth: Power down controller when suspending
To:     Marcel Holtmann <marcel@holtmann.org>, chin-ran.lo@nxp.com,
        amitkumar.karwar@nxp.com
Cc:     BlueZ development <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Daniel Winkler <danielwinkler@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Re-send to NXP email addresses for Chin-Ran Lo and Amitkumar Karwar
(Marvell wireless IP acquired by NXP)



On Tue, Nov 24, 2020 at 11:02 AM Abhishek Pandit-Subedi
<abhishekpandit@chromium.org> wrote:
>
> Hi Marcel,
>
>
> On Mon, Nov 23, 2020 at 3:46 AM Marcel Holtmann <marcel@holtmann.org> wro=
te:
> >
> > Hi Abhishek,
> >
> > > This patch series adds support for a quirk that will power down the
> > > Bluetooth controller when suspending and power it back up when resumi=
ng.
> > >
> > > On Marvell SDIO Bluetooth controllers (SD8897 and SD8997), we are see=
ing
> > > a large number of suspend failures with the following log messages:
> > >
> > > [ 4764.773873] Bluetooth: hci_cmd_timeout() hci0 command 0x0c14 tx ti=
meout
> > > [ 4767.777897] Bluetooth: btmrvl_enable_hs() Host sleep enable comman=
d failed
> > > [ 4767.777920] Bluetooth: btmrvl_sdio_suspend() HS not actived, suspe=
nd failed!
> > > [ 4767.777946] dpm_run_callback(): pm_generic_suspend+0x0/0x48 return=
s -16
> > > [ 4767.777963] call mmc2:0001:2+ returned -16 after 4882288 usecs
> > >
> > > The daily failure rate with this signature is quite significant and
> > > users are likely facing this at least once a day (and some unlucky us=
ers
> > > are likely facing it multiple times a day).
> > >
> > > Given the severity, we'd like to power off the controller during susp=
end
> > > so the driver doesn't need to take any action (or block in any way) w=
hen
> > > suspending and power on during resume. This will break wake-on-bt for
> > > users but should improve the reliability of suspend.
> > >
> > > We don't want to force all users of MVL8897 and MVL8997 to encounter
> > > this behavior if they're not affected (especially users that depend o=
n
> > > Bluetooth for keyboard/mouse input) so the new behavior is enabled vi=
a
> > > module param. We are limiting this quirk to only Chromebooks (i.e.
> > > laptop). Chromeboxes will continue to have the old behavior since use=
rs
> > > may depend on BT HID to wake and use the system.
> >
> > I don=E2=80=99t have a super great feeling with this change.
> >
> > So historically only hciconfig hci0 up/down was doing a power cycle of =
the controller and when adding the mgmt interface we moved that to the mgmt=
 interface. In addition we added a special case of power up via hdev->setup=
. We never had an intention that the kernel otherwise can power up/down the=
 controller as it pleases.
>
> Aside from the powered setting, the stack is resilient to the
> controller crashing (which would be akin to a power off and power on).
> From the view of bluez, adapter lost and power down should be almost
> equivalent right? ChromeOS has several platforms where Bluetooth has
> been reset after suspend, usually due USB being powered off in S3, and
> the stack is still well-behaving when that occurs.
>
> >
> > Can we ask Marvell first to investigate why this is fundamentally broke=
n with their hardware?
>
> +Chin-Ran Lo and +Amitkumar Karwar (added based on changes to
> drivers/bluetooth/btmrvl_main.c)
>
> Could you please take a look at the original cover letter and comment
> (or add others at Marvell who may be able to)? Is this a known issue
> or a fix?
>
> >Since what you are proposing is a pretty heavy change that might has sid=
e affects. For example the state machine for the mgmt interface has no conc=
ept of a power down/up from the kernel. It is all triggered by bluetoothd.
> >
> > I am careful here since the whole power up/down path is already complic=
ated enough.
> >
>
> That sounds reasonable. I have landed this within ChromeOS so we can
> test whether a) this improves stability enough and b) whether the
> power off/on in the kernel has significant side effects. This will go
> through our automated testing and dogfooding over the next few weeks
> and hopefully identify those side-effects. I will re-raise this topic
> with updates once we have more data.
>
> Also, in case it wasn't very clear, I put this behind a module param
> that defaults to False because this is so heavy handed. We're only
> using it on specific Chromebooks that are exhibiting the worst
> behavior and not disabling it wholesale for all btmrvl controllers.
>
> Thanks
> Abhishek
>
> > Regards
> >
> > Marcel
> >
