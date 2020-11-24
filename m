Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33912C3062
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 20:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404354AbgKXTCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 14:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404289AbgKXTCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 14:02:15 -0500
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B4FC061A4D
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 11:02:15 -0800 (PST)
Received: by mail-vs1-xe44.google.com with SMTP id f7so11668115vsh.10
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 11:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kc8KsgesSQBcYK6Gf282xpdD2zcj++JCOXz1+UYSV2k=;
        b=IjcDFxlfcHV4pz4eTgNuT8AouoGXtbtDX16v7bgZ20+KdKkXUG565iyB1gSAbLBIS9
         o00eH5ygcnQ5EU91bEdZep8QGzdCDZLJM/7GbSGkkvdyV1/DVs4+QIM4ZBxHSsUNEVMy
         HNyfKouSspCNkAN+qbmSyv86Solcpejg3l6h0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kc8KsgesSQBcYK6Gf282xpdD2zcj++JCOXz1+UYSV2k=;
        b=Xm0v4ZMe1zxms4qj1hSRaZ7NMLgEl5ykmVGow0Hpo+7B2vepEiSX48dlWdlgoKjzfP
         csNobGuCaN+1uSnVAJ3rOABpdRR7xkXaRTawOkN4/VYjeugh1YNXNGcXlEONvL2TSoVG
         GNLzf5JkXBHz+414C3iOvs8DB/EAFZaF57qnTtxG5VU9rn3TTianp54ZtE678Vh9VFPl
         P5azfGhuEVFkyaMmB4da+mhcFF3Zk72+ylJ4MKgNiMWiPK1/uAkiJuVA5fxoGVPXQQHv
         hsBtHvEY6LSgaGkBvF5J6IqooERTDCDjYqjGiDF44VfiUuxC4ywT6WhXg3pbJ7IvIhk1
         UrLw==
X-Gm-Message-State: AOAM530yF+pjJm8/PvB9X8Ek7JShy3ndRFDceilKHaLErm6OtVWNE+jy
        W196XD96dzLVUcjVHpbjBdhMitdW58AOygTMHux6Pw==
X-Google-Smtp-Source: ABdhPJz0msw3gheojDTN1y1Or7/pFfuAmO/78wVkNcKJjiVo7yDwZMTuFngQgn4FkhABj8BMb6xzyFieHO+AkXj7v14=
X-Received: by 2002:a67:fb8f:: with SMTP id n15mr5701991vsr.30.1606244534393;
 Tue, 24 Nov 2020 11:02:14 -0800 (PST)
MIME-Version: 1.0
References: <20201118234352.2138694-1-abhishekpandit@chromium.org> <7235CD4E-963C-4BCB-B891-62494AD7F10D@holtmann.org>
In-Reply-To: <7235CD4E-963C-4BCB-B891-62494AD7F10D@holtmann.org>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Tue, 24 Nov 2020 11:02:03 -0800
Message-ID: <CANFp7mVSGNbwCkWCj=bVzbE8L38nwu0+UMR9jkOYcYQmGBaAEw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Bluetooth: Power down controller when suspending
To:     Marcel Holtmann <marcel@holtmann.org>, crlo@marvell.com,
        akarwar@marvell.com
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

Hi Marcel,


On Mon, Nov 23, 2020 at 3:46 AM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> Hi Abhishek,
>
> > This patch series adds support for a quirk that will power down the
> > Bluetooth controller when suspending and power it back up when resuming=
.
> >
> > On Marvell SDIO Bluetooth controllers (SD8897 and SD8997), we are seein=
g
> > a large number of suspend failures with the following log messages:
> >
> > [ 4764.773873] Bluetooth: hci_cmd_timeout() hci0 command 0x0c14 tx time=
out
> > [ 4767.777897] Bluetooth: btmrvl_enable_hs() Host sleep enable command =
failed
> > [ 4767.777920] Bluetooth: btmrvl_sdio_suspend() HS not actived, suspend=
 failed!
> > [ 4767.777946] dpm_run_callback(): pm_generic_suspend+0x0/0x48 returns =
-16
> > [ 4767.777963] call mmc2:0001:2+ returned -16 after 4882288 usecs
> >
> > The daily failure rate with this signature is quite significant and
> > users are likely facing this at least once a day (and some unlucky user=
s
> > are likely facing it multiple times a day).
> >
> > Given the severity, we'd like to power off the controller during suspen=
d
> > so the driver doesn't need to take any action (or block in any way) whe=
n
> > suspending and power on during resume. This will break wake-on-bt for
> > users but should improve the reliability of suspend.
> >
> > We don't want to force all users of MVL8897 and MVL8997 to encounter
> > this behavior if they're not affected (especially users that depend on
> > Bluetooth for keyboard/mouse input) so the new behavior is enabled via
> > module param. We are limiting this quirk to only Chromebooks (i.e.
> > laptop). Chromeboxes will continue to have the old behavior since users
> > may depend on BT HID to wake and use the system.
>
> I don=E2=80=99t have a super great feeling with this change.
>
> So historically only hciconfig hci0 up/down was doing a power cycle of th=
e controller and when adding the mgmt interface we moved that to the mgmt i=
nterface. In addition we added a special case of power up via hdev->setup. =
We never had an intention that the kernel otherwise can power up/down the c=
ontroller as it pleases.

Aside from the powered setting, the stack is resilient to the
controller crashing (which would be akin to a power off and power on).
From the view of bluez, adapter lost and power down should be almost
equivalent right? ChromeOS has several platforms where Bluetooth has
been reset after suspend, usually due USB being powered off in S3, and
the stack is still well-behaving when that occurs.

>
> Can we ask Marvell first to investigate why this is fundamentally broken =
with their hardware?

+Chin-Ran Lo and +Amitkumar Karwar (added based on changes to
drivers/bluetooth/btmrvl_main.c)

Could you please take a look at the original cover letter and comment
(or add others at Marvell who may be able to)? Is this a known issue
or a fix?

>Since what you are proposing is a pretty heavy change that might has side =
affects. For example the state machine for the mgmt interface has no concep=
t of a power down/up from the kernel. It is all triggered by bluetoothd.
>
> I am careful here since the whole power up/down path is already complicat=
ed enough.
>

That sounds reasonable. I have landed this within ChromeOS so we can
test whether a) this improves stability enough and b) whether the
power off/on in the kernel has significant side effects. This will go
through our automated testing and dogfooding over the next few weeks
and hopefully identify those side-effects. I will re-raise this topic
with updates once we have more data.

Also, in case it wasn't very clear, I put this behind a module param
that defaults to False because this is so heavy handed. We're only
using it on specific Chromebooks that are exhibiting the worst
behavior and not disabling it wholesale for all btmrvl controllers.

Thanks
Abhishek

> Regards
>
> Marcel
>
