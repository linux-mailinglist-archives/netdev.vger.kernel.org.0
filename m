Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C93D3D69AA
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 00:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbhGZV7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 17:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbhGZV7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 17:59:33 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60761C061757;
        Mon, 26 Jul 2021 15:40:00 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 19-20020a9d08930000b02904b98d90c82cso11572453otf.5;
        Mon, 26 Jul 2021 15:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fyYS83TJhhxVOfsNmu5c001LjoG5UgZ/hJ8MDBaDVrk=;
        b=ax0x11gYfKsrv5i8QpmztTa8rW81guRfm6vJ9GoNpNGMhjpJlwvWlmkjrykyNYd4qt
         CDC8rgfh//cXjINJ1Rsnh553J+QQOHDiBlxr1fTQsbT6ufjzDWUae93YxOLwoXL1KdW4
         pVybN4jHUxkCZeLnE3lPAL+jsUe9pDRIgYoxRUrvbfTk3fPPThzwtztr8npwTxsXjsMa
         9UXdRWsV9KmTLHKVGL1Wg8whYZQWNxPHrHS0jY4a5su8RbiR9PcBbdQid9HcbqX9du9n
         K518pKRvgSLU5SjOMdjehY3TDotw7dnTth0K2euObdN/NoQGSWYctjHdyJXrsdeCH9EH
         K9zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fyYS83TJhhxVOfsNmu5c001LjoG5UgZ/hJ8MDBaDVrk=;
        b=radkGYOQtCzDpc9QD7CwgtyFR/Yc5qsOvk1hiHRmvttudkF2VgH/TqzrwByi1Mhkch
         /cmwUTBZwO8SfRPbNUJZPoUtwY2axkWQnTHOrcBtiPVUykOxbZZ/SSIvBMDFiwVK/Ol4
         DM8EPFjnDY++NVjgzPvyXc//7irvq+bDmU0bxDK1GWtxfye7Nj4eGZyEzAq9PKj04nf0
         PBO6JFuS6uqmeAusBSCC4Ne3s4wKhYXZA9MJLvzKOHa8cGTiLyWoiexajIkLr6nELNXR
         2VPLGKUMuZXSHJJSmQwTSdBfcBoEEaIOV9koz/rAybmljC73zkp8aIf30v5TVvuQdN5+
         CcLg==
X-Gm-Message-State: AOAM533PnQXB0zrl74gvt9psPxaT9imZ8FkY7zAwH9nOy3WododdRVVh
        kCqkZ1NFFtWJw292goE1R6rCD7HxBemMKGlKA54=
X-Google-Smtp-Source: ABdhPJwDiHLckB0JbibpoC/Qkq6c662oX2jEeuzB25zfWmbxwwssxd71D586oKFQCzcpzw5AqtAookmewbmv48f+oEg=
X-Received: by 2002:a9d:6d83:: with SMTP id x3mr12761570otp.110.1627339199143;
 Mon, 26 Jul 2021 15:39:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210719145317.79692-1-stephan@gerhold.net> <20210719145317.79692-5-stephan@gerhold.net>
 <CAMZdPi8oxRMo0erfd0wrUPzD2UsbexoR=86u2N75Fd9RpXHoKg@mail.gmail.com>
 <YPmRcBXpRtKKSDl8@gerhold.net> <CAHNKnsQr4Ys8q3Ctru-H=L3ZDwb__2D3E08mMZchDLAs1KetAg@mail.gmail.com>
 <CAAP7ucLDEoJzwNvWLCWyCNE+kKBDn4aBU-9XT_Uv_yetnX4h-g@mail.gmail.com>
In-Reply-To: <CAAP7ucLDEoJzwNvWLCWyCNE+kKBDn4aBU-9XT_Uv_yetnX4h-g@mail.gmail.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 27 Jul 2021 01:40:10 +0300
Message-ID: <CAHNKnsSeX00+oL7uuKw83fRb0zSJWndQXyQH8PvoKf59mFUYgg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 4/4] net: wwan: Add Qualcomm BAM-DMUX WWAN
 network driver
To:     Aleksander Morgado <aleksander@aleksander.es>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Stephan Gerhold <stephan@gerhold.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
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

Hello Aleksander,

On Mon, Jul 26, 2021 at 11:11 AM Aleksander Morgado
<aleksander@aleksander.es> wrote:
>> But what if we implement the QMI multiplexing management part in the
>> kernel? This way the kernel will take care about modem-to-host
>> communication protocols and interfaces, and provides userspace with a
>> single WWAN device (possibly with multiple network and network
>> management interfaces).
>>
>> I do not propose to fully implement QMI protocol inside the kernel,
>> but implement only a mux management part, while passing all other
>> messages between a "modem" and a userspace software as-is.
>>
>> What pros and cons of such a design do you see?
>
> The original GobiNet driver already provided some QMI protocol
> implementation in the driver itself. In addition to initial device
> setup as you suggest, it also allowed userspace applications to
> allocate and release QMI clients for the different services that could
> be used independently by different processes. Not going to say that
> was the wrong way to do it, but the implementation is definitely not
> simple. The decision taken in qmi_wwan to make the driver as simple as
> possible and leave all the QMI management to userspace was quite an
> important one; it made the driver extremely simple, leaving all the
> complexity of managing the protocol to userspace, and while it had
> some initial drawbacks (e.g. only one process could talk QMI at a
> time) the userspace tools have evolved to avoid them (e.g. the
> qmi-proxy).
>
> I wrote some time ago about this, maybe it's still relevant today:
> Blogpost https://sigquit.wordpress.com/2014/06/11/qmiwwan-or-gobinet/,
> Article in PDF https://aleksander.es/data/Qualcomm%20Gobi%20devices%20on%20Linux.pdf
>
> Making the driver talk QMI just for device setup would require the
> kernel to know how the QMI protocol works, how QMI client allocations
> and releases are done, how errors are reported, how is the format of
> the requests and responses involved; it would require the kernel to
> wait until the QMI protocol endpoint in the modem is capable of
> returning QMI responses (this could be up to 20 or 30 secs after the
> device is available in the bus), it would require to have possibly
> some specific rules on how the QMI clients are managed after a
> suspend/resume operation. It would also require to sync the access to
> the CTL service, which is the one running QMI service allocations and
> releases, so that both kernel and userspace can perform operations
> with that service at the same time. It would need to know how
> different QMI capable devices behave, because not all devices support
> the same services, and some don't even support the WDA service that
> would be the one needed to setup data aggregation. There is definitely
> some overlap on what the kernel could do and what userspace could do,
> and I'd say that we have much more flexibility in userspace to do all
> this leaving all the complexity out of the kernel driver.
>
> ModemManager already provides a unified API to e.g. setup multiplexed
> data sessions, regardless of what the underlying kernel implementation
> is (qmi_wwan only, qmi_wwan+rmnet, ipa+rmnet, bam-dmux, cdc_mbim...) .
> The logic doing all that is extremely complex and possibly full of
> errors, I would definitely not want to have all that logic in the
> kernel itself, let the errors be in userspace! Unifying stuff in the
> kernel is a good idea, but if you ask me, it should be done in a way
> that is as simple as possible, leaving complexity to userspace, even
> if that means that userspace still needs to know what type of device
> we have behind the wwan subsystem, because userspace will anyway need
> to know all that.

Ouch! All these QMI internals are like a can of worms. Each time I
start thinking that I learned something I face another complexity.
Many thanks for your detailed reply and for your blogpost, for me it
was quite helpful for understanding to see a side by side comparison
of approaches!

The argument for keeping drivers minimalistic to keep the system
stable sounds reasonable. But I am still feeling uncomfortable when a
userspace software manages a device at such a low level. Maybe it is a
matter of taste, or maybe I still do not realize the whole complexity.
Anyway, in the context of your clarification, I should be more careful
in the future with calls to implement QMI in the kernel :)

--
Sergey
