Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC2A492BCF
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 18:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236887AbiARRCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 12:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236675AbiARRCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 12:02:12 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20F7C061574;
        Tue, 18 Jan 2022 09:02:11 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id c71so82458649edf.6;
        Tue, 18 Jan 2022 09:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t4VS+844/s3c/SVFK110m3TmMIP45+ZI1bs8dsZpnqA=;
        b=DiE/Sx5EKcVRYBuu3GI1maZ8+9DrRUOTbO4kj8L8v3drZQ5vDYcebnD2l8rkk+kUPu
         85jbhNWfQ7NY3u3o0oXE2mMpb5OH0aKMKhNFVegsAkqJGXcgzuG725NiSrOdsjN8IpWz
         5HLr/HZ21d7LhvPEql6WqrVepEk1Kcx8n7HrEUNacLIdCDx0262YYUDrC7cjf2BJpuiq
         3h1KmitzhGbJGeBI7vhSmf/ywbiS5Ia+FJkuIQDqL9VwqLWxeV+6iYSD+9e/AudXvm5M
         wlzKx1m0Y1bh4S3kmcnMkiEmZ3q8HE13PeSvWAtkW1Pj5JjjY0GmenYv++/jwk3c0l7I
         qvOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t4VS+844/s3c/SVFK110m3TmMIP45+ZI1bs8dsZpnqA=;
        b=VGx0bZi4XUOmeKtCuBaku7kcr1UllEj3yGhOXzKyi+qyw6zUIcwy7WZMmuv+RNGUrg
         2PVradYGz/RVGkjj+k648qBYMVc8FRu4CyvBQI3aH7MIoUa3D+sTrZROCaeb/bmHGSGO
         xvPABRqpJX7VU/ZWZfn2dZkbz6TLeBmlEq3mPRhbrO9GTcUV4K4M125r0Sjf1EpC5xcB
         NqgnQrgDud11rSRgk2EXgWAJ7x/97+MZ4RTAfSPCHUD5RIKLMlrWPLm0JGBsDAf6bC7k
         LzDTl+uVfriHRHgw5epTSbXv0l0Rkvulg82HwUqTsrEm6JOsUlsPiIVa1L3YPXipQ8GZ
         gzCg==
X-Gm-Message-State: AOAM531QoUh30nQYnq0EYA4dxC8kJEluafrr/vHnb8OsxMo5NMvvufXv
        2XE505RtQnzdsAuoXUORl/l88fK+f+5wds5oyfw=
X-Google-Smtp-Source: ABdhPJwjL5/U9atRUwKah1nVHi2Tz36ttxQPPKgTZStjY2ox97/ZV7PBDQj4lMISk2cYHqzmlBfYCAWRqklRfGUGPpI=
X-Received: by 2002:a17:907:6e0b:: with SMTP id sd11mr21916858ejc.132.1642525330273;
 Tue, 18 Jan 2022 09:02:10 -0800 (PST)
MIME-Version: 1.0
References: <20220117142919.207370-1-marcan@marcan.st> <CAHp75VfRiFokdTQ9cnEEH596mM7cb4FXQk4eXVt37cG4FcFMyA@mail.gmail.com>
 <e956e500-a59a-a03b-6be1-c7eca85c8741@marcan.st>
In-Reply-To: <e956e500-a59a-a03b-6be1-c7eca85c8741@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 18 Jan 2022 19:01:32 +0200
Message-ID: <CAHp75Vcp_cFEDZC4LoqVkNBypX1R74MVOhKKw8-2iRCF-MuYTg@mail.gmail.com>
Subject: Re: [PATCH v3 0/9] misc brcmfmac fixes (M1/T2 series spin-off)
To:     Hector Martin <marcan@marcan.st>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 5:32 PM Hector Martin <marcan@marcan.st> wrote:
> On 18/01/2022 19.43, Andy Shevchenko wrote:
> > On Mon, Jan 17, 2022 at 4:30 PM Hector Martin <marcan@marcan.st> wrote:
> >>
> >> Hi everyone,
> >>
> >> This series contains just the fixes / misc improvements from the
> >> previously submitted series:
> >>
> >> brcmfmac: Support Apple T2 and M1 platforms
> >>
> >> Patches 8-9 aren't strictly bugfixes but rather just general
> >> improvements; they can be safely skipped, although patch 8 will be a
> >> dependency of the subsequent series to avoid a compile warning.
> >
> > Have I given you a tag? If so, I do not see it applied in the patches...
>
> I didn't see any review tags from you in the previous thread. Did I miss
> any?

I checked myself and indeed it seems my memory is about something
else, I'll check v3, last time I remember I found no (big) issues with
the fixes patches, I believe they are in shape.

-- 
With Best Regards,
Andy Shevchenko
