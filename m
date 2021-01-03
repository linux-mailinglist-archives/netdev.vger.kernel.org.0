Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D553C2E8A04
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 03:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbhACC0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jan 2021 21:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbhACC0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jan 2021 21:26:15 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799F1C061573;
        Sat,  2 Jan 2021 18:25:35 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id r17so22104743ilo.11;
        Sat, 02 Jan 2021 18:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0jnY7stFhm9t4TjU9Aq4Io3pgb+YBt5XgxkVKWhc1Ak=;
        b=i+hPiT72YyRU02aWOTP77TDM6vYagiL/+6dTQ2nXGJ1Rz7cQC+LZhqWH+LNiTkTbMY
         cEC0nvGDZSvZ8yxEZ39K1jlQ2srSbcU8jIf5eiE8iBTi2JnrrZTn2Rt6RKWZWHLKAidR
         CrbKaX42kYZuaX4FUmdoFj/WPofqbI7SsurzXtu51Xc4vJPXi3eXvNujYbg31HLwPHhH
         ftJ8W1ZUzJoRr01UxMQ11+OsGfx0Qo4JbvNLAuShpbpncD7JFPdXodMzJIeYkMutswqn
         cOPnTKsr7z0Rjs0pQXEUohO4bqhXzKfMJOmcfJttR4BLseMCl3pa3WLFGhOwGVI2Q398
         bAqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0jnY7stFhm9t4TjU9Aq4Io3pgb+YBt5XgxkVKWhc1Ak=;
        b=pTK1vXk53X+AsjmiU2T/HeGA47gQe++0AGc76+9fmWXV74xU63XE7YBgsLFkU8hGwi
         blN0k20wBpsFk/rddXBa/qbn7Mlji054ipkStzSJlFGqBQO/Q7u2z/6GSGmJWPcUSV/r
         FFRtNp2STOUR9eh74vPe/xT/TBBpHI+pXSGMTouYHzQV13zT/tLT3Rb11ILVQMuO8dYR
         tXCFTk6nWmEeTUiTCXZa1IA/WtYm7NfTnuXOTvkU1FZgDDKufOg1Q37vqcCeAxam9mhQ
         UHyHOiaEVjkVp4x6SRn6gkznopLkCHhKJo/uPqv4kBBdeR9iSJshUUt3xOQvWEPaByR/
         8kUQ==
X-Gm-Message-State: AOAM5312mZKdywJCL0JQEkf5jXdqy/RJnQy16YUx6nbZQdIdNm4WcSzh
        NJk/f9jR1e802Kp6eiHZSvyV2NZCky5UQ8uWHD3I+JSPSmpbyA==
X-Google-Smtp-Source: ABdhPJzi8z1dvmgepVDhZETqtwu9iVbjrbMU5rPIxJbH0R50f9WS4FEJREbHYWG4IQrOOyfX3t32jVC3EuT32koHCWg=
X-Received: by 2002:a92:7f02:: with SMTP id a2mr54601602ild.204.1609640734572;
 Sat, 02 Jan 2021 18:25:34 -0800 (PST)
MIME-Version: 1.0
References: <20201230161036.GR1551@shell.armlinux.org.uk> <20201230165634.c4ty3mw6djezuyq6@pali>
 <20201230170546.GU1551@shell.armlinux.org.uk> <X+y1K21tp01GpvMy@lunn.ch>
 <20201230174307.lvehswvj5q6c6vk3@pali> <20201230190958.GW1551@shell.armlinux.org.uk>
 <20201231121410.2xlxtyqjelrlysd2@pali> <X+3ume1+wz8HXHEf@lunn.ch>
 <20201231170039.zkoa6mij3q3gt7c6@pali> <X+4GwpFnJ0Asq/Yj@lunn.ch> <20210102014955.2xv27xla65eeqyzz@pali>
In-Reply-To: <20210102014955.2xv27xla65eeqyzz@pali>
From:   Thomas Schreiber <tschreibe@gmail.com>
Date:   Sun, 3 Jan 2021 03:25:23 +0100
Message-ID: <CALQZrspktLr3SfVRhBrVK2zhjFzJMm9tQjWXU_07zjwJytk7Cg@mail.gmail.com>
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
To:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pali,
I have a CarlitoxxPro module and I reported an issue about RX_LOS pin
to the manufacturer.
It looks to me that the module asserts "inverted LOS" through EEPROM
but does not implement it. Consequently, the SFP state machine of my
host router stays in check los state and link is not set up for the
host interface.

Below is a dump of the module's EEPROM:

[root@clearfog-gt-8k ~]# ethtool -m eth0
Identifier                                : 0x03 (SFP)
Extended identifier                       : 0x04 (GBIC/SFP defined by
2-wire interface ID)
Connector                                 : 0x01 (SC)
Transceiver codes                         : 0x00 0x00 0x00 0x00 0x00
0x00 0x00 0x00 0x00
Encoding                                  : 0x03 (NRZ)
BR, Nominal                               : 1200MBd
Rate identifier                           : 0x00 (unspecified)
Length (SMF,km)                           : 20km
Length (SMF)                              : 20000m
Length (50um)                             : 0m
Length (62.5um)                           : 0m
Length (Copper)                           : 0m
Length (OM3)                              : 0m
Laser wavelength                          : 1310nm
Vendor name                               : VSOL
Vendor OUI                                : 00:00:00
Vendor PN                                 : V2801F
Vendor rev                                : 1.0
Option values                             : 0x00 0x1c
Option                                    : RX_LOS implemented, inverted
Option                                    : TX_FAULT implemented
Option                                    : TX_DISABLE implemented
BR margin, max                            : 0%
BR margin, min                            : 0%
Vendor SN                                 : CP202003180377
Date code                                 : 200408
Optical diagnostics support               : Yes
Laser bias current                        : 0.000 mA
Laser output power                        : 0.0000 mW / -inf dBm
Receiver signal average optical power     : 0.0000 mW / -inf dBm
Module temperature                        : 31.00 degrees C / 87.80 degrees=
 F
Module voltage                            : 0.0000 V
Alarm/warning flags implemented           : Yes
Laser bias current high alarm             : Off
Laser bias current low alarm              : On
Laser bias current high warning           : Off
Laser bias current low warning            : Off
Laser output power high alarm             : Off
Laser output power low alarm              : On
Laser output power high warning           : Off
Laser output power low warning            : Off
Module temperature high alarm             : Off
Module temperature low alarm              : Off
Module temperature high warning           : Off
Module temperature low warning            : Off
Module voltage high alarm                 : Off
Module voltage low alarm                  : Off
Module voltage high warning               : Off
Module voltage low warning                : Off
Laser rx power high alarm                 : Off
Laser rx power low alarm                  : Off
Laser rx power high warning               : Off
Laser rx power low warning                : Off
Laser bias current high alarm threshold   : 74.752 mA
Laser bias current low alarm threshold    : 0.000 mA
Laser bias current high warning threshold : 0.000 mA
Laser bias current low warning threshold  : 0.000 mA
Laser output power high alarm threshold   : 0.0000 mW / -inf dBm
Laser output power low alarm threshold    : 0.0000 mW / -inf dBm
Laser output power high warning threshold : 0.0000 mW / -inf dBm
Laser output power low warning threshold  : 0.0000 mW / -inf dBm
Module temperature high alarm threshold   : 90.00 degrees C / 194.00 degree=
s F
Module temperature low alarm threshold    : 0.00 degrees C / 32.00 degrees =
F
Module temperature high warning threshold : 0.00 degrees C / 32.00 degrees =
F
Module temperature low warning threshold  : 0.00 degrees C / 32.00 degrees =
F
Module voltage high alarm threshold       : 0.0000 V
Module voltage low alarm threshold        : 0.0000 V
Module voltage high warning threshold     : 0.0000 V
Module voltage low warning threshold      : 0.0000 V
Laser rx power high alarm threshold       : 0.1536 mW / -8.14 dBm
Laser rx power low alarm threshold        : 0.0000 mW / -inf dBm
Laser rx power high warning threshold     : 0.0000 mW / -inf dBm
Laser rx power low warning threshold      : 0.0000 mW / -inf dBm


Le sam. 2 janv. 2021 =C3=A0 02:49, Pali Roh=C3=A1r <pali@kernel.org> a =C3=
=A9crit :
>
> On Thursday 31 December 2020 18:13:38 Andrew Lunn wrote:
> > > > Looking at sfp_module_info(), adding a check for i2c_block_size < 2
> > > > when determining what length to return. ethtool should do the right
> > > > thing, know that the second page has not been returned to user spac=
e.
> > >
> > > But if we limit length of eeprom then userspace would not be able to
> > > access those TX_DISABLE, LOS and other bits from byte 110 at address =
A2.
> >
> > Have you tested these bits to see if they actually work? If they don't
> > work...
>
> On Ubiquiti module that LOS bit does not work.
>
> I think that on CarlitoxxPro module LOS bit worked. But I cannot test it
> right now as I do not have access to testing OLT unit.
>
> Adding Thomas to loop. Can you check if CarlitoxxPro GPON ONT module
> supports LOS or other bits at byte offset 110 at address A2?
