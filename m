Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A859E21A64
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 17:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbfEQPQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 11:16:46 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37137 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729164AbfEQPQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 11:16:46 -0400
Received: by mail-io1-f68.google.com with SMTP id u2so5777908ioc.4;
        Fri, 17 May 2019 08:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O7EJOOciNikkf5PiuE4H3WoYPiyHO7ThOU93whUfBug=;
        b=VoNWRhyTiUpJGTcZo1DtkVlKLGI/9YYMnnX6vEykzx5I/hvbqm+Bp0N1y+la0Te5rh
         zhK3l3qLAtzsppcK3AA/GwIBDccL92xQcfedpg+Mn9qcHHXqQn3Y1S4qJjFQbpcxkJ2r
         K96LMQGlceMLUSCmocBIpM2nK7HB2AVWcUOzEspl0+rlX9BSe04wDRwe23qzcMLxawgI
         TLmubmLQc9a5jJaL6Z3ZvpffNVlqGTSCcZ0Xecl4fMWI2+lkosmnrt+EO1wLApiTc2ZD
         ZRKnwjIAVJeLxKFCEpmIosN+LwRGSCcc5grteFogXctLtY7rzz++Moukthhumj1Tx/Kw
         Gx6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O7EJOOciNikkf5PiuE4H3WoYPiyHO7ThOU93whUfBug=;
        b=ZCdliEPGTKWMR85DP1+cXCBnagItryuev4VOc6PUYC2xLk4mIgPtelFnFS3cUY1iO3
         GCSqO8k7kXpxFPMkiTAng3PHy6g98Ogj4h5XDZ4W6U0isYDeo7QJK41m9BiuFxMFJBdD
         wKsu/VIXLHuCEatyvMFT7akKcmWA0RhHuN97CNByOBWIzW4BCBJ0T54++FaXumo5ozCE
         Jz6zIctOObR1riEJUTrsrkQ0C4RjdmfVy/7EtJD0wCy4e2DMKGCEjjtNi7DYGPuWqDu5
         zjZ3l+zq7A0hhiJAV8ttNywhbKVw/7OoZUtIThFOWki+JTLOicUoyuT1R9vdKUaVVxVP
         jRXQ==
X-Gm-Message-State: APjAAAWnIyvQo7h2+PYjbIFAJPxVOCMn6+JzzR12vzZNFr/xryopQo+C
        l2DOhDcewZVE8RSCgrsh8SM27cPqix0EHlBfG8g=
X-Google-Smtp-Source: APXvYqw8t8xC+aNND57aUm26LmEwNT3jvC+cE1+OL9mdPzhwEpes5kmIIvl0zaN+QSJyxEXGF8GGzNzL/Ol3ZRLqu4o=
X-Received: by 2002:a5e:c60b:: with SMTP id f11mr718296iok.42.1558106205472;
 Fri, 17 May 2019 08:16:45 -0700 (PDT)
MIME-Version: 1.0
References: <1557357269-9498-1-git-send-email-nkela@cisco.com>
 <9be117dc6e818ab83376cd8e0f79dbfaaf193aa9.camel@intel.com>
 <76B41175-0CEE-466C-91BF-89A1CA857061@cisco.com> <4469196a-0705-5459-8aca-3f08e9889d61@gmail.com>
 <20190517010330.2wynopuhsqycqzuq@zorba> <bd9e6a93-c8e8-a90e-25b0-26ccbf65b7c4@gmail.com>
In-Reply-To: <bd9e6a93-c8e8-a90e-25b0-26ccbf65b7c4@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 17 May 2019 08:16:34 -0700
Message-ID: <CAKgT0Uev7sfpOOhusAg9jFLkFeE9JtTntyTd0aAHz2db69L13g@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH] igb: add parameter to ignore nvm
 checksum validation
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Daniel Walker <danielwa@cisco.com>,
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

On Thu, May 16, 2019 at 6:48 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/16/2019 6:03 PM, Daniel Walker wrote:
> > On Thu, May 16, 2019 at 03:02:18PM -0700, Florian Fainelli wrote:
> >> On 5/16/19 12:55 PM, Nikunj Kela (nkela) wrote:
> >>>
> >>>
> >>> On 5/16/19, 12:35 PM, "Jeff Kirsher" <jeffrey.t.kirsher@intel.com> wrote:
> >>>
> >>>     On Wed, 2019-05-08 at 23:14 +0000, Nikunj Kela wrote:
> >>>    >> Some of the broken NICs don't have EEPROM programmed correctly. It
> >>>    >> results
> >>>    >> in probe to fail. This change adds a module parameter that can be
> >>>    >> used to
> >>>    >> ignore nvm checksum validation.
> >>>    >>
> >>>    >> Cc: xe-linux-external@cisco.com
> >>>    >> Signed-off-by: Nikunj Kela <nkela@cisco.com>
> >>>    >> ---
> >>>    >>  drivers/net/ethernet/intel/igb/igb_main.c | 28
> >>>    >> ++++++++++++++++++++++------
> >>>    >>  1 file changed, 22 insertions(+), 6 deletions(-)
> >>>
> >>>     >NAK for two reasons.  First, module parameters are not desirable
> >>>     >because their individual to one driver and a global solution should be
> >>>     >found so that all networking device drivers can use the solution.  This
> >>>     >will keep the interface to change/setup/modify networking drivers
> >>>     >consistent for all drivers.
> >>>
> >>>
> >>>     >Second and more importantly, if your NIC is broken, fix it.  Do not try
> >>>     >and create a software workaround so that you can continue to use a
> >>>     >broken NIC.  There are methods/tools available to properly reprogram
> >>>     >the EEPROM on a NIC, which is the right solution for your issue.
> >>>
> >>> I am proposing this as a debug parameter. Obviously, we need to fix EEPROM but this helps us continuing the development while manufacturing fixes NIC.
> >>
> >> Then why even bother with sending this upstream?
> >
> > It seems rather drastic to disable the entire driver because the checksum
> > doesn't match. It really should be a warning, even a big warning, to let people
> > know something is wrong, but disabling the whole driver doesn't make sense.
>
> You could generate a random Ethernet MAC address if you don't have a
> valid one, a lot of drivers do that, and that's a fairly reasonable
> behavior. At some point in your product development someone will
> certainly verify that the provisioned MAC address matches the network
> interface's MAC address.
> --
> Florian

The thing is the EEPROM contains much more than just the MAC address.
There ends up being configuration for some of the PCIe interface in
the hardware as well as PHY configuration. If that is somehow mangled
we shouldn't be bringing up the part because there are one or more
pieces of the device configuration that are likely wrong.

The checksum is being used to make sure the EEPROM is valid, without
that we would need to go through and validate each individual section
of the EEPROM before enabling the the portions of the device related
to it. The concern is that this will become a slippery slope where we
eventually have to code all the configuration of the EEPROM into the
driver itself.

We need to make the checksum a hard stop. If the part is broken then
it needs to be addressed. Workarounds just end up being used and
forgotten, which makes it that much harder to support the product.
Better to mark the part as being broken, and get it fixed now, than to
have parts start shipping that require workarounds in order to
function.

- Alex
