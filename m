Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11FFD59262
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 06:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbfF1EPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 00:15:12 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36040 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfF1EPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 00:15:11 -0400
Received: by mail-ot1-f67.google.com with SMTP id r6so4655640oti.3;
        Thu, 27 Jun 2019 21:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=alHSV6X/0jYcdmtS8pNTXOWz4fHsYwIu+SIRyai8F4U=;
        b=mwWKHR4gsiFZhFc+g9iiDBf3ria3CPGJBcUKNVbrOil9jxBOb15bPSedkQ6i24jHB2
         kgq9cPIPT5bdCFJOdW4vK/Cj6Q28b75Jdtg4+A+nn49Ju0ZMez/bP3llj4+yZRpmC4m1
         OAilLA/8XG4laGNg6ziCWw8QLmX1BfNw/A3dGxRtKF5WhMpH3wnILuAUhnDo3Ldro3Ja
         oQqbhOTpK+MN0Xu75Uru15bz0iInVn95zDCzLcEIjC1zcbaU8cbBCd6DeFDEM46JNzad
         JE8vF0BXoRqPNCBw1IJndTkL244uCMNW7mfJvMaJLegyUECwNOQD0lWoch5vlqqg5d+D
         avLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=alHSV6X/0jYcdmtS8pNTXOWz4fHsYwIu+SIRyai8F4U=;
        b=KczRuowlkAG5IfRkmDYMrnwv5ectJUUmwdGjrswWJUPwqcK9Y/hsmkHLKyehTlDrqB
         4LVnDJmDW/5yHxoeAtUjSdI2b31m1Zatwju/DIZhBn/WZD3+jWZEWLVrgXAmRwINLRpQ
         ufYYzt3qNoamjJuFLxpKPPwyuHeopzEsPnMBLk5OUJBdMADwXeaZGy68B1N7noKZp/7C
         FMwxaCP9On+eNCjGUmNQ1RfjtHsN8UaFiVTpIwqEbw8u/AWo9qmJr/iPVE1S8Nlu+Dsm
         MzO2w0zL4y23G5o3wkIOfIDf2lchBQzo5u1oYUgEvOQVg/B5ef7/tk4ry45L+whoUwpr
         IOqQ==
X-Gm-Message-State: APjAAAV+7tPUUPGAOR2sPWytWQwojOu4THdlh31B68K5FfoafyVrgpqM
        04u1+QMmV/A7kue8h5MonD56+jKJ2p0dHVnlA0w=
X-Google-Smtp-Source: APXvYqzoN5kA1YyGVtcEAFkQBTUlTjcCxJhJ1rQg63DQ4NxitIRUZ2Osuk9gZslYzS51V4HANDD59jPadH78m0yUWGw=
X-Received: by 2002:a9d:6d8d:: with SMTP id x13mr6286370otp.6.1561695310932;
 Thu, 27 Jun 2019 21:15:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190617165836.4673-1-colin.king@canonical.com>
 <20190619051308.23582-1-martin.blumenstingl@googlemail.com>
 <92f9e5a6-d2a2-6bf2-ff8a-2430fe977f93@canonical.com> <CAFBinCDmYVPDMcwAAYhMfxxuTsG=xunduN58_8e20zE_Mhmb7Q@mail.gmail.com>
 <CAFBinCC-LLpfXQRFcKBbUpCfKc0S9Xtt60QrhEThsOFV-T7vFw@mail.gmail.com> <c46d2d17-c35b-46f0-0674-0c55bea3a272@canonical.com>
In-Reply-To: <c46d2d17-c35b-46f0-0674-0c55bea3a272@canonical.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Fri, 28 Jun 2019 06:15:00 +0200
Message-ID: <CAFBinCBk5aPVE+vq5px3QKS1T_R=WGXXxEJMC9X676KGvi9jdg@mail.gmail.com>
Subject: Re: [PATCH] net: stmmac: add sanity check to device_property_read_u32_array
 call
To:     Colin Ian King <colin.king@canonical.com>
Cc:     alexandre.torgue@st.com, davem@davemloft.net, joabreu@synopsys.com,
        kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        peppe.cavallaro@st.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 9:58 AM Colin Ian King <colin.king@canonical.com> wrote:
>
> On 25/06/2019 05:44, Martin Blumenstingl wrote:
> > Hi Colin,
> >
> > On Thu, Jun 20, 2019 at 3:34 AM Martin Blumenstingl
> > <martin.blumenstingl@googlemail.com> wrote:
> >>
> >> Hi Colin,
> >>
> >> On Wed, Jun 19, 2019 at 8:55 AM Colin Ian King <colin.king@canonical.com> wrote:
> >>>
> >>> On 19/06/2019 06:13, Martin Blumenstingl wrote:
> >>>> Hi Colin,
> >>>>
> >>>>> Currently the call to device_property_read_u32_array is not error checked
> >>>>> leading to potential garbage values in the delays array that are then used
> >>>>> in msleep delays.  Add a sanity check to the property fetching.
> >>>>>
> >>>>> Addresses-Coverity: ("Uninitialized scalar variable")
> >>>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >>>> I have also sent a patch [0] to fix initialize the array.
> >>>> can you please look at my patch so we can work out which one to use?
> >>>>
> >>>> my concern is that the "snps,reset-delays-us" property is optional,
> >>>> the current dt-bindings documentation states that it's a required
> >>>> property. in reality it isn't, there are boards (two examples are
> >>>> mentioned in my patch: [0]) without it.
> >>>>
> >>>> so I believe that the resulting behavior has to be:
> >>>> 1. don't delay if this property is missing (instead of delaying for
> >>>>    <garbage value> ms)
> >>>> 2. don't error out if this property is missing
> >>>>
> >>>> your patch covers #1, can you please check whether #2 is also covered?
> >>>> I tested case #2 when submitting my patch and it worked fine (even
> >>>> though I could not reproduce the garbage values which are being read
> >>>> on some boards)
> > in the meantime I have tested your patch.
> > when I don't set the "snps,reset-delays-us" property then I get the
> > following error:
> >   invalid property snps,reset-delays-us
> >
> > my patch has landed in the meantime: [0]
> > how should we proceed with your patch?
>
> I'm out of the office today. I'll get back to you on this tomorrow.
gentle ping
(I will be away for the weekend but I can reply on Monday)
