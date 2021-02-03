Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CA630E267
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 19:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbhBCSWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 13:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbhBCSWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 13:22:01 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2ABAC061788
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 10:21:20 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id z22so735027edb.9
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 10:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m8wNkVQjjY9NrEsHNt1lfmAWPFTD4+i4OieQgWONqJs=;
        b=RsKoW3gSRDiwBP+hDKNnUSSrgnuP2rDLFh1WHXZWbc3xuVETCiZ78LVI8bdXyTaFO2
         coLQIyv3iZQ3EOWc7Fi7KcTRtb9v4vNPQJTZ+Dm7umdriDuDVpCXFBu6PDAVN0KIdcoP
         G8KebZ0m9nK0HAa64YuucXx9GWtqM6lp6hPFeiElJ7xMNI4IZ1emzp83oesPjYwitLb5
         9V3pYhmwRlRS15f28wj3/TjK5/1KxyH2MSaTfB4yz/d2NnKrgQT/7v9rxMU55wybc4Ju
         XBLH+CBGnKw8Q1JOoPJYYBIAfFUKRqkZAiUqiZpcPlkRf2RlIWB/yUFaYaaLJWwTwBlj
         F7EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m8wNkVQjjY9NrEsHNt1lfmAWPFTD4+i4OieQgWONqJs=;
        b=FcaWg1CMiRq0hw19F49SKVB/f2N6N9k5njaFyvM96bEd5Luwg8bTSfjtbWUKwV/nbP
         oKfhNuUHjiU439UbBQBY6z3nIQ2JySFAEMe3RsmXSrbu9BhbRxNCIiycshogs+x63Pft
         UGiYlcBQQ0Tu6uy5+1f0VLpzxz7UXr6S4Ts0Q1a5jp4ojRZ6cr1+nnwgaHw1iYKy5Zw0
         5ZuIHgrZ+g5nOAyiRFRk19dUya+04/B80i+xZ0qy33E/3qKSO67AbDSLXdacdwnAiYQ6
         Pi0xJ/wGCAaG373l32by0iBh3gw/urhQZBBwJcp0xbtRCMa4LhCCrrh05b4iAbLibTpe
         rIbg==
X-Gm-Message-State: AOAM531BAReg9v9pXTZVk9dhbusWopYnlalygKxrtaQNcL6fM8DbI8Ux
        e0FfKajbiawElOpHqmNUfEe7GTG4g3k8OXt0dlAaGA==
X-Google-Smtp-Source: ABdhPJwCScNW96RHyG2xst74E//ExKGdIs09sTJ+ldXs2Lcc9gHDp9E4BK3S3tvxeVNlRXWjihFHFTQ5N1fl4YP94ww=
X-Received: by 2002:aa7:c895:: with SMTP id p21mr4384983eds.165.1612376479543;
 Wed, 03 Feb 2021 10:21:19 -0800 (PST)
MIME-Version: 1.0
References: <1609958656-15064-1-git-send-email-hemantk@codeaurora.org>
 <20210113152625.GB30246@work> <YBGDng3VhE1Yw6zt@kroah.com>
 <20210201105549.GB108653@thinkpad> <YBfi573Bdfxy0GBt@kroah.com>
 <20210201121322.GC108653@thinkpad> <20210202042208.GB840@work>
 <20210202201008.274209f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <835B2E08-7B84-4A02-B82F-445467D69083@linaro.org> <20210203100508.1082f73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203100508.1082f73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 3 Feb 2021 19:28:28 +0100
Message-ID: <CAMZdPi8o44RPTGcLSvP0nptmdUEmJWFO4HkCB_kjJvfPDgchhQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
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

Hi Jakub,

On Wed, 3 Feb 2021 at 19:05, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 03 Feb 2021 09:45:06 +0530 Manivannan Sadhasivam wrote:
> > >> Jakub, Dave, Adding you both to get your reviews on this series. I've
> > >> provided an explanation above and in the previous iteration [1].
> > >
> > >Let's be clear what the review would be for. Yet another QMI chardev
> > >or the "UCI" direct generic user space to firmware pipe?
> >
> > The current patchset only supports QMI channel so I'd request you to
> > review the chardev node created for it. The QMI chardev node created
> > will be unique for the MHI bus and the number of nodes depends on the
> > MHI controllers in the system (typically 1 but not limited).
>
> If you want to add a MHI QMI driver, please write a QMI-only driver.
> This generic "userspace client interface" driver is a no go. Nobody will
> have the time and attention to police what you throw in there later.

Think it should be seen as filtered userspace access to MHI bus
(filtered because not all channels are exposed), again it's not
specific to MHI, any bus in Linux offers that (i2c, spi, usb, serial,
etc...). It will not be specific to QMI, since we will also need it
for MBIM (modem control path), AT commands, and GPS (NMEA frames), all
these protocols are usually handled by userspace tools and not linked
to any internal Linux framework, so it would be better not having a
dedicated chardev for each of them.

Regards,
Loic
