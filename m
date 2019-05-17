Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A82221C12
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 18:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfEQQ66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 12:58:58 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42786 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbfEQQ66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 12:58:58 -0400
Received: by mail-io1-f68.google.com with SMTP id g16so6035316iom.9;
        Fri, 17 May 2019 09:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=25VNczWuptEWYgXOl4vV+bCkNxc25zGJb812eV/WGMY=;
        b=rmoA0u10E+DtjIHjlxyG3qiXINdnKGOLEnBlCJvKkxXV4Rl6jdqmhKtgy2RCnF9C+6
         M5yOaCoS/OSGWcdPn17qMhTKp4rMnXGVbwLdGsw2Ex74WtZiQSsMOCrAvpSXeHWXhzOQ
         GNgl4DoLd9nLDX/qqVkYiyXXTSAgJTTZXRlqwVjjsH9DOYnej+BFJOYyvkRo0d6t5cUD
         nX6Fz3N27LqCkd6KXicxkxI8AB6/zvzKr7mcyICVUAq3jhtnHJIHsCzjvfQwCoek45hb
         9dKo5oYwYwk/R/Fq3C0Ci2W7tQQugKh4WUDYVWYF+9r1/AP6s3i6yiXKvpLmQAnZq3sz
         CtBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=25VNczWuptEWYgXOl4vV+bCkNxc25zGJb812eV/WGMY=;
        b=MqebMIw7lihnCG1B0ig8bG7bIEhLzVa72UVt++pCCKh2oPpHG3C8oe8yp1eUcmGDjn
         ke5kgFRBqKrYIPbTgObGcNW3IldZs8JHrgCpW+0ZpyeM13i/DP5cl+wKc++o4FPoRggu
         DJchWzkrA66+hD40RPspagJZfuZ9aCs73CwFKziFq9BrySa+MoKRUqmyC45ArYh+9KZS
         N0w0L0Y7m/Aka67WiwZSd2yH58j8yBDi6Q7/cnRj22ut4++leoEl9qUqYNQyqHJZcSfo
         g0qS5BxR2oyFAKLEUt/sFXMD/Z53y0PZ6KXGvG+U3IAa2WK/k2vybjsUJw/pHKEl1iN6
         L+CQ==
X-Gm-Message-State: APjAAAVNtd4v6zrtHutnt2h88vYKbcGzUcXMdfN7tBNfGSAh9hYW/3Nx
        iLlv+VVf0WEv1yurNTNBgA3sDcDL73nFDkW6Mu0=
X-Google-Smtp-Source: APXvYqxUIJzAr/gytocISvpMMLmJJBpKo+o0RChc616DzUobTYLUQZ1B3VMFoAJwOA88AnyNEVWl8H9ikp+QwzyettA=
X-Received: by 2002:a5e:c60b:: with SMTP id f11mr1090167iok.42.1558112337376;
 Fri, 17 May 2019 09:58:57 -0700 (PDT)
MIME-Version: 1.0
References: <1557357269-9498-1-git-send-email-nkela@cisco.com>
 <9be117dc6e818ab83376cd8e0f79dbfaaf193aa9.camel@intel.com>
 <76B41175-0CEE-466C-91BF-89A1CA857061@cisco.com> <4469196a-0705-5459-8aca-3f08e9889d61@gmail.com>
 <20190517010330.2wynopuhsqycqzuq@zorba> <bd9e6a93-c8e8-a90e-25b0-26ccbf65b7c4@gmail.com>
 <CAKgT0Uev7sfpOOhusAg9jFLkFeE9JtTntyTd0aAHz2db69L13g@mail.gmail.com> <20190517163643.7tlch7xqplxohoq7@zorba>
In-Reply-To: <20190517163643.7tlch7xqplxohoq7@zorba>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 17 May 2019 09:58:46 -0700
Message-ID: <CAKgT0Ue0b1QxG2ijegbHFz-2Wpxga0ffvhsfDg4VLDRaDSFvdw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH] igb: add parameter to ignore nvm
 checksum validation
To:     Daniel Walker <danielwa@cisco.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "Nikunj Kela (nkela)" <nkela@cisco.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 17, 2019 at 9:36 AM Daniel Walker <danielwa@cisco.com> wrote:
>
> On Fri, May 17, 2019 at 08:16:34AM -0700, Alexander Duyck wrote:
> > On Thu, May 16, 2019 at 6:48 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
> > >
> > >
> > >
> > > On 5/16/2019 6:03 PM, Daniel Walker wrote:
> > > > On Thu, May 16, 2019 at 03:02:18PM -0700, Florian Fainelli wrote:
> > > >> On 5/16/19 12:55 PM, Nikunj Kela (nkela) wrote:
> > > >>>
> > > >>>
> > > >>> On 5/16/19, 12:35 PM, "Jeff Kirsher" <jeffrey.t.kirsher@intel.com> wrote:
> > > >>>
> > > >>>     On Wed, 2019-05-08 at 23:14 +0000, Nikunj Kela wrote:
> > > >>>    >> Some of the broken NICs don't have EEPROM programmed correctly. It
> > > >>>    >> results
> > > >>>    >> in probe to fail. This change adds a module parameter that can be
> > > >>>    >> used to
> > > >>>    >> ignore nvm checksum validation.
> > > >>>    >>
> > > >>>    >> Cc: xe-linux-external@cisco.com
> > > >>>    >> Signed-off-by: Nikunj Kela <nkela@cisco.com>
> > > >>>    >> ---
> > > >>>    >>  drivers/net/ethernet/intel/igb/igb_main.c | 28
> > > >>>    >> ++++++++++++++++++++++------
> > > >>>    >>  1 file changed, 22 insertions(+), 6 deletions(-)
> > > >>>
> > > >>>     >NAK for two reasons.  First, module parameters are not desirable
> > > >>>     >because their individual to one driver and a global solution should be
> > > >>>     >found so that all networking device drivers can use the solution.  This
> > > >>>     >will keep the interface to change/setup/modify networking drivers
> > > >>>     >consistent for all drivers.
> > > >>>
> > > >>>
> > > >>>     >Second and more importantly, if your NIC is broken, fix it.  Do not try
> > > >>>     >and create a software workaround so that you can continue to use a
> > > >>>     >broken NIC.  There are methods/tools available to properly reprogram
> > > >>>     >the EEPROM on a NIC, which is the right solution for your issue.
> > > >>>
> > > >>> I am proposing this as a debug parameter. Obviously, we need to fix EEPROM but this helps us continuing the development while manufacturing fixes NIC.
> > > >>
> > > >> Then why even bother with sending this upstream?
> > > >
> > > > It seems rather drastic to disable the entire driver because the checksum
> > > > doesn't match. It really should be a warning, even a big warning, to let people
> > > > know something is wrong, but disabling the whole driver doesn't make sense.
> > >
> > > You could generate a random Ethernet MAC address if you don't have a
> > > valid one, a lot of drivers do that, and that's a fairly reasonable
> > > behavior. At some point in your product development someone will
> > > certainly verify that the provisioned MAC address matches the network
> > > interface's MAC address.
> > > --
> > > Florian
> >
> > The thing is the EEPROM contains much more than just the MAC address.
> > There ends up being configuration for some of the PCIe interface in
> > the hardware as well as PHY configuration. If that is somehow mangled
> > we shouldn't be bringing up the part because there are one or more
> > pieces of the device configuration that are likely wrong.
> >
> > The checksum is being used to make sure the EEPROM is valid, without
> > that we would need to go through and validate each individual section
> > of the EEPROM before enabling the the portions of the device related
> > to it. The concern is that this will become a slippery slope where we
> > eventually have to code all the configuration of the EEPROM into the
> > driver itself.
>
>
> I don't think you can say because the checksum is valid that all data contained
> inside is also valid. You can have a valid checksum , and someone screwed up the
> data prior to the checksum getting computed.

If someone screwed up the data prior to writing the checksum then that
is on them. In theory we could also have a multi-bit error that could
similarly be missed. However if the checksum is not valid then the
data contained in the NVM does not match what was originally written,
so we know we have bad data. Why should we act on the data if we know
it is bad?

> > We need to make the checksum a hard stop. If the part is broken then
> > it needs to be addressed. Workarounds just end up being used and
> > forgotten, which makes it that much harder to support the product.
> > Better to mark the part as being broken, and get it fixed now, than to
> > have parts start shipping that require workarounds in order to
> > function.o
>
> I don't think it's realistic to define the development process for large
> corporations like Cisco, or like what your doing , to define the development
> process for all corporations and products which may use intel parts. It's better
> to be flexible.
>
> Daniel

This isn't about development. If you are doing development you can do
whatever you want with your own downstream driver. What you are
attempting to do is update the upstream driver which is used in
production environments.

What concerns me is when this module parameter gets used in a
development environment and then slips into being required for a
production environment. At that point it defeats the whole point of
the checksum in the first place.
