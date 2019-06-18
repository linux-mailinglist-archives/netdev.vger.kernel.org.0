Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A08A44AB7A
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 22:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730592AbfFRUJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 16:09:58 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36753 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729331AbfFRUJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 16:09:57 -0400
Received: by mail-qt1-f196.google.com with SMTP id p15so17049557qtl.3;
        Tue, 18 Jun 2019 13:09:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gnX6xKMGivJziLWPy0MXzH36uFV6fP8h9GWYY0vF4dQ=;
        b=m61DGYRiH4zZ9hFgpxAh13UTMN3/FEYp7iVKeDYmpZp9omXoPgZheRm9uFKZI2mwAD
         i/z4cEFGIgdQkzcuuBnp+FtTJB87cwcENcag6ZzaB2b1y+Te7hLrB48rnb/H8mgWNpoJ
         HMDBlyzbta3tMDsUXAGfaHKT+KruOjRfrKXc2fq+R+Bg3c0asrSPtgiGQS1mn6FvqEnQ
         PfECf7HoGAxufv/kBNz/kL3BGsYtbmnuVXCLIQ7q2u5XSa1TyjS0MfzgFwY33USOa41B
         MdHv5kU3Vg2WuIXel2MiHiQIo4+Ue3d0w4x562T961l5aie3V4dalNHgBMp+v0G0IKE2
         xNow==
X-Gm-Message-State: APjAAAUj76xd2VFLUYN+1lUVtUJWmBVGNP67tn0ZkPfiaW8Ecro4p4df
        xxOfChfC3YNbfz8zGayJgV0h8reS1pgbzhuXhtw=
X-Google-Smtp-Source: APXvYqzMxSZbNKZMyYx2SIWSteQCuWwP6hDYpVFmbIVCBXlz3S9dXHNlAfNiln2W3gebm9oJkPV+di6FaYLU9Wb0Sxs=
X-Received: by 2002:a0c:87ab:: with SMTP id 40mr28470984qvj.93.1560888596401;
 Tue, 18 Jun 2019 13:09:56 -0700 (PDT)
MIME-Version: 1.0
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
 <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
 <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
 <fc0d08912bc10ad089eb74034726308375279130.camel@redhat.com>
 <36bca57c999f611353fd9741c55bb2a7@codeaurora.org> <153fafb91267147cf22e2bf102dd822933ec823a.camel@redhat.com>
 <CAK8P3a2Y+tcL1-V57dtypWHndNT3eDJdcKj29c_v+k8o1HHQig@mail.gmail.com>
 <f4249aa5f5acdd90275eda35aa16f3cfb29d29be.camel@redhat.com>
 <CAK8P3a2nzZKtshYfomOOSYkqx5HdU15Wr9b+3va0B1euNhFOAg@mail.gmail.com>
 <dbb32f185d2c3a654083ee0a7188379e1f88d899.camel@sipsolutions.net>
 <d533b708-c97a-710d-1138-3ae79107f209@linaro.org> <abdfc6b3a9981bcdef40f85f5442a425ce109010.camel@sipsolutions.net>
In-Reply-To: <abdfc6b3a9981bcdef40f85f5442a425ce109010.camel@sipsolutions.net>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 18 Jun 2019 22:09:38 +0200
Message-ID: <CAK8P3a3ksrFTo2+dLB+doLeY+kPP7rYxv2O7BwvjYgK2cwCTuQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Alex Elder <elder@linaro.org>, Dan Williams <dcbw@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        abhishek.esse@gmail.com, Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        syadagir@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 9:03 PM Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2019-06-18 at 08:45 -0500, Alex Elder wrote:

> Really there are two possible ways (and they intersect to some extent).
>
> One is the whole multi-function device, where a single WWAN device is
> composed of channels offered by actually different drivers, e.g. for a
> typical USB device you might have something like cdc_ether and the
> usb_wwan TTY driver. In this way, we need to "compose" the WWAN device
> similarly, e.g. by using the underlying USB device "struct device"
> pointer to tie it together.
>
> The other is something like IPA or the Intel modem driver, where the
> device is actually a single (e.g. PCIe) device and just has a single
> driver, but that single driver offers different channels.

I would hope we can simplify this to expect only the second model,
where you have a 'struct device' corresponding to hardware and the
driver for it creates one wwan_device that user space talks to.

Clearly the multi-function device hardware has to be handled somehow,
but it would seem much cleaner in the long run to do that using
a special workaround rather than putting this into the core interface.

E.g. have a driver that lets you create a wwan_device by passing
netdev and a tty chardev into a configuration interface, and from that
point on use the generic wwan abstraction.

> Now, it's not clear to me where IPA actually falls, because so far we've
> been talking about the IPA driver only as providing *netdevs*, not any
> control channels, so I'm not actually sure where the control channel is.

The IPA driver today only handles the data path, because Alex removed
the control channel. IPA is the driver that needs to talk to the hardware,
both for data and control when finished. rmnet is a pure software construct
that also contains both a data and control side and is designed to be
independent of the lower hardware.

      Arnd
