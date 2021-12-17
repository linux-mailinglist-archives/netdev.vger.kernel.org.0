Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D77E478AD2
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 13:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbhLQMGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 07:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235845AbhLQMGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 07:06:40 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47652C061574;
        Fri, 17 Dec 2021 04:06:40 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id fo11so2109570qvb.4;
        Fri, 17 Dec 2021 04:06:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NwgjbNTF2AWawWSd7aciZMtjNd2TAYgTWjwPPG2Ao+k=;
        b=WLDcyhSUVMyrmIGZVETG9Wal7qkdSO780y5q60sYc9FufGb/O32XqI9O/lOaVGIyMs
         0AIgCVT1OzT4EOv9cczRYi8ZIc0KsygZDCZ5cGVI8Cg6I0KWUJY6zVJ3WFlUr2UM4RrJ
         IZAyOrqfOaW0rUquoO0ImR9e4xbrqMhWirlRLzn8cqrQIcAEtCCUFv4wXH+h6EehUPBg
         k7RtjdXFPVcIsEp3z3EmIfu0AYSYxAhGOxyyJZyfE107bHBFSi2S9aGc3YlI42Qn2vnL
         d2Pbm8O+wZjknX9eqpwlF0itqPEMrYgdmPnKNtSANsnCcxP7Yb0U+e5TunVKf2MdoNs2
         umqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NwgjbNTF2AWawWSd7aciZMtjNd2TAYgTWjwPPG2Ao+k=;
        b=XrF9ic0pJN3wFlzfPH3zISymIigw8gO404x1VMVbWM89JW+XX0zqBpfYUlFbrFWRMg
         cYjs27VEfHtDX1Yr7smpYGMjYbObkHOdXBvPYZMOtWNMUbwC9ccNwU3x+aAB4TqcLd2y
         czmUyVfuLLZ5RZDWxiiXJyYmnaWZjdMGTMYk/danitwT+9NjCGcNlAexlq1/d8NBJWUT
         r+Fc78JnsmtM36ro2fLzWrni36xAOSOezz4Lq1z+/QJVoo9O+xl0OqBIqrvalz4/f18+
         hdQ7l122lmSnQDcB9Mlyx9cYt476Uk8NU47YdXWnC+j9hx6glLAK3FOrnhf0reSwx7U/
         Szlg==
X-Gm-Message-State: AOAM533gNPJB1dbRo7HH6SDtmYfnCJ9Ybk8RHpLYRvtudnVBdYQY+zqE
        2M0EhQVZ4k1GGD90mL3cRbM/bMAWVANilwlr3bg=
X-Google-Smtp-Source: ABdhPJwe96itCmXKag5ptWEiDyxw39VJXuH5D00/SrEDhhWF8d6dkOji7lVebUQhnuDBQ24ULsyNs3z2PAHJgCRYjoI=
X-Received: by 2002:a0c:e808:: with SMTP id y8mr2009792qvn.48.1639742798029;
 Fri, 17 Dec 2021 04:06:38 -0800 (PST)
MIME-Version: 1.0
References: <20211009221711.2315352-1-robimarko@gmail.com> <163890036783.24891.8718291787865192280.kvalo@kernel.org>
 <CAOX2RU5mqUfPRDsQNSpVPdiz6sE_68KN5Ae+2bC_t1cQzdzgTA@mail.gmail.com> <09a27912-9ea4-fe75-df72-41ba0fa5fd4e@gmail.com>
In-Reply-To: <09a27912-9ea4-fe75-df72-41ba0fa5fd4e@gmail.com>
From:   Robert Marko <robimarko@gmail.com>
Date:   Fri, 17 Dec 2021 13:06:26 +0100
Message-ID: <CAOX2RU6qaZ7NkeRe1bukgH6OxXOPvJS=z9PRp=UYAxMfzwD2oQ@mail.gmail.com>
Subject: Re: [PATCH] ath10k: support bus and device specific API 1 BDF selection
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     Kalle Valo <kvalo@kernel.org>, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Thibaut <hacks@slashdirt.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 at 15:07, Christian Lamparter <chunkeey@gmail.com> wrote:
>
> On 08/12/2021 13:21, Robert Marko wrote:
> > On Tue, 7 Dec 2021 at 19:06, Kalle Valo <kvalo@kernel.org> wrote:
> >>
> >> Robert Marko <robimarko@gmail.com> wrote:
> >>
> >>> Some ath10k IPQ40xx devices like the MikroTik hAP ac2 and ac3 require the
> >>> BDF-s to be extracted from the device storage instead of shipping packaged
> >>> API 2 BDF-s.
> >>>
> >>> This is required as MikroTik has started shipping boards that require BDF-s
> >>> to be updated, as otherwise their WLAN performance really suffers.
> >>> This is however impossible as the devices that require this are release
> >>> under the same revision and its not possible to differentiate them from
> >>> devices using the older BDF-s.
> >>>
> >>> In OpenWrt we are extracting the calibration data during runtime and we are
> >>> able to extract the BDF-s in the same manner, however we cannot package the
> >>> BDF-s to API 2 format on the fly and can only use API 1 to provide BDF-s on
> >>> the fly.
> >>> This is an issue as the ath10k driver explicitly looks only for the
> >>> board.bin file and not for something like board-bus-device.bin like it does
> >>> for pre-cal data.
> >>> Due to this we have no way of providing correct BDF-s on the fly, so lets
> >>> extend the ath10k driver to first look for BDF-s in the
> >>> board-bus-device.bin format, for example: board-ahb-a800000.wifi.bin
> >>> If that fails, look for the default board file name as defined previously.
> >>>
> >>> Signed-off-by: Robert Marko <robimarko@gmail.com>
> >>
> >> Can someone review this, please? I understand the need for this, but the board
> >> handling is getting quite complex in ath10k so I'm hesitant.
> >>
> >> What about QCA6390 and other devices. Will they still work?
> > Hi Kalle,
> > everything else should just continue working as before unless the
> > board-bus-device.bin file
> > exists it will just use the current method to fetch the BDF.
> >
> > Also, this only applies to API1 BDF-s.
> >
> > We are really needing this as currently there are devices with the
> > wrong BDF being loaded as
> > we have no way of knowing where MikroTik changed it and dynamic
> > loading would resolve
> > all of that since they are one of the rare vendors that embed the
> > BDF-s next to calibration data.
>
> Isn't the only user of this the non-upstreamable rb_hardconfig
> mikrotik platform driver? So, in your case the devices in question
> needs to setup a detour through the userspace firmware (helper+scripts)
> to pull on the sysfs of that mikrotik platform driver? Wouldn't it
> be possible to do this more directly?

Yes, its the sole current user as its the only vendor shipping the BDF
as part of the
factory data and not like a userspace blob.

I don't see how can it be more direct, its the same setup as when
getting pre-cal
data for most devices currently.

I am adding Thibaut who is the author of the platform driver.

Regards,
Robert
>
> Cheers,
> Christian
