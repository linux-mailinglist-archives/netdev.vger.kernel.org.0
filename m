Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CAF32728F
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 15:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhB1ONg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 09:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhB1ONe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 09:13:34 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3533C06174A
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 06:12:53 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id h22so13915155otr.6
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 06:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2FusiFiz0X86EPMHGdKHS7UxChtJqFIAQKwqNSegRJI=;
        b=kuqs/varyC0CfTq+gxGmOMXaztlbrXePfmB2FleBx3n1SkuYpluH3XMLBMedDMcVwk
         Cl5rTxhhuvWHLNZzL3vfsK0Xd+C0KaSRpJjjOVPGuyix0yYihLCUPxdXSi5ZyP5rg4mg
         F6xSBRYyIzLN1h86tEwNcTxuxTmKJXCiPcuA193BLmPBaZXC3EpJjHd1J4OWdKKOHtWY
         7dsPqo4A56Ngd2y8mnyAknhr3nEgczxx736+mNJQMDTAh8JdgEjeOJG8tf1Uv/8gfC98
         1k4uhctwtdIlpqZdXDKYuPFzwD5fVqvMbpAggN7clrIEf1593IqlbojZt1+ybWoDWT8+
         YlQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2FusiFiz0X86EPMHGdKHS7UxChtJqFIAQKwqNSegRJI=;
        b=XFPBoedm3eQYIikcAQ7V4G2M9zYTo7fXb+4U0UMQ2/PqB1gjejOSJLMim5K/L702ky
         DIIWi8Albf9ibbBmhPphWlF9lPJf7jfhRE9iWU0Ep1sn8wmvl4SD/bwSBM6abTJ2vSJj
         +9OnK+SC/J/FvZ0j6djffIvAp18Fm8MTi2egbgAvdaN9A60OkuRN8Qj5+HcwfnwKB66A
         wq+lcTyPUtL3jxu9ZG7pfuCJ92CxVE3UMyhcDzb9GjcjdPDvNDeEFp5Kmw5qdxLvQLJI
         BIxkGFO1QDFeoZQeeVWaMbwLDYgvFQFBDbcBILUj6Ornv6L1feRCbZhoolLSWAEql9lJ
         j3xg==
X-Gm-Message-State: AOAM530esJ6d3BwiaZJN2mT1YD6DdOv5BaX6FxuVr3YPQQarHIkiAVUx
        4tp4+nC2M+XVHKpFCsSzoxZ0R0eMJN4ajLgHFNG8UQ==
X-Google-Smtp-Source: ABdhPJxbAVFinsYw6ljwDBh6vBidfD1MwQjl+p3XMISJMExPhTMIPnKo7bYd1V0jz5Nk4OkPPQe2y8BBJxvdyTKhAsc=
X-Received: by 2002:a05:6830:151:: with SMTP id j17mr10155633otp.252.1614521573376;
 Sun, 28 Feb 2021 06:12:53 -0800 (PST)
MIME-Version: 1.0
References: <YBfi573Bdfxy0GBt@kroah.com> <20210201121322.GC108653@thinkpad>
 <20210202042208.GB840@work> <20210202201008.274209f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <835B2E08-7B84-4A02-B82F-445467D69083@linaro.org> <20210203100508.1082f73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMZdPi8o44RPTGcLSvP0nptmdUEmJWFO4HkCB_kjJvfPDgchhQ@mail.gmail.com>
 <20210203104028.62d41962@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAAP7ucLZ5jKbKriSp39OtDLotbv72eBWKFCfqCbAF854kCBU8w@mail.gmail.com>
 <20210209081744.43eea7b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20210210062531.GA13668@work>
In-Reply-To: <20210210062531.GA13668@work>
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Sun, 28 Feb 2021 15:12:42 +0100
Message-ID: <CAAP7uc+Q=ToKVNz4wDv0JWHK4NTniSLE1QwMbP0eXEqVMTUwwQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Manivannan, Jakub & all,

>
> So please let us know the path forward on this series. We are open to
> any suggestions but you haven't provided one till now.
>

I just found out that Sierra Wireless also provides their own version
of mhi-net and mhi-uci in precompiled binaries for several Ubuntu
kernel versions and other setups; and that made me extremely unhappy.
They're not the only manufacturer doing that; most of them are doing
it, because we don't have yet a common solution in upstream Linux. Not
the first time we've seen this either, see the per-vendor GobiNet
implementations vs the upstream qmi_wwan one. I was hoping we could
avoid that mess again with the newer Qualcomm modules! :)

In ModemManager we've always *forced* all manufacturers we interact
with to first do the work in upstream Linux, and then we integrate
support in MM for those drivers. We've never accepted support for
vendor-specific proprietary kernel drivers, and that's something I
would personally like to keep on doing. The sad status right now is
that any user that wants to use the newer 5G modules with Qualcomm
chipsets, they need to go look for manufacturer-built precompiled
drivers for their specific kernel, and also then patch ModemManager
and the tools themselves. Obviously almost no one is doing all that,
except for some company with resources or a lot of interest. Some of
these new 5G modules are PCIe-only by default, unless some pin in the
chipset is brought up and then some of them may switch to USB support.
No one is really doing that either, as tampering with the hardware
voids warranty.

The iosm driver is also stalled in the mailing list and there doesn't
seem to be a lot of real need for a new common wwan subsystem to
rework everything...

I'm not involved with the mhi-uci driver development at all, and I
also don't have anything to say on what goes in the upstream kernel
and what doesn't. But as one of the ModemManager/libqmi/libmbim
maintainers I would like to represent all the users of these modules
that are right now forced to look for shady binary precompiled drivers
out there... that is no better solution than this proposed mhi-uci
common driver.

Manivannan, are you attempting to rework the mhi-uci driver in a
different way, or have you given up? Is there anything I could help
with?

Jakub, is there really no way you can be convinced that this mhi-uci
driver isn't that bad after all? :) All the mhi-net bits are already
integrated I think, even the MBIM support over MHI in the net device,
but all that is truly useless without a way to control the modem
sending and receiving messages.

Sorry for being back again with this discussion :)

Cheers!


--
Aleksander
https://aleksander.es
