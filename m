Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF735492702
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 14:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242492AbiARNVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 08:21:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43076 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235530AbiARNVA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jan 2022 08:21:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+0L1vGkv7QyC1GibGB67PjNxvpPnAN50mE8aqAqpKcI=; b=JQ9eArgdTrhBe/MleN/alTmGmL
        SO4vciIkZAmKSS7/BlE1yMNVVbft/0Lm3/bssUk/FlrUQtjQ7xRWW8IYwvFlp4ikEXrIZ30V5OR20
        ZMt8EJspxLhlLS7r/itsZTqv1X5QP+59PWDKqJ9xfgRSMyMCjAm459+NmTusWvI+4pzE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n9oPx-001luv-Pu; Tue, 18 Jan 2022 14:20:57 +0100
Date:   Tue, 18 Jan 2022 14:20:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: Re: Re: Re: [PATCH net-next v4 11/11] net: dsa: realtek:
 rtl8365mb: multiple cpu ports, non cpu extint
Message-ID: <Yea+uTH+dh9/NMHn@lunn.ch>
References: <20220105031515.29276-1-luizluca@gmail.com>
 <20220105031515.29276-12-luizluca@gmail.com>
 <87ee5fd80m.fsf@bang-olufsen.dk>
 <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
 <87r19e5e8w.fsf@bang-olufsen.dk>
 <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
 <87v8ynbylk.fsf@bang-olufsen.dk>
 <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 01:58:39AM -0300, Luiz Angelo Daros de Luca wrote:
> > the problem is checksum offloading on the gmac (soc-side)
> 
> I suggested it might be checksum problem because I'm also affected. In
> my case, I have an mt7620a SoC connected to the rtl8367s switch. The
> OS offloads checksum to HW but the mt7620a cannot calculate the
> checksum with the (EtherType) Realtek CPU Tag in place. I'll try to
> move the CPU tag to test if the mt7620a will then digest the frame
> correctly.

Some MAC hardware you can tell it where the ether type value is in the
frame. This is often used to skip over the VLAN header, but it can
also be used to skip DSA headers. Check the datasheet for the hardware
and see if there is anything like that.

    Andrew
