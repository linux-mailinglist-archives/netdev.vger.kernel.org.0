Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03392CACB7
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbgLATtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgLATtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 14:49:31 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59062C061A04;
        Tue,  1 Dec 2020 11:48:22 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id 7so6789531ejm.0;
        Tue, 01 Dec 2020 11:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2kwiJbYURYRlDKL0Dl0F6lgZz50z35k9U64Ijz0yS0o=;
        b=Opbrawig6mFmleXuY1P+B83LRZNj4sNJXs7oaAxpLmpo4wp4GXKE+U/R+1mxOXYXmX
         GtlReRAiZURSf9Ngi9kVSjY4hDIDtzftPAZcaoqqEJ6s1wp3koCzAb/FlguMCCx0vQhW
         buWev2urlkSVwpwPzdSaJdclTxh6V7V8ZD9UVERS3rHlvGmT6MSkdq7rE7M8UJiLP7Nk
         dqHN3f4M5anxXvTsdD/thoUEr1sJb353mHa5QqbRovuEUXVWbg0vBI6MovQr+C8//UVG
         uMNoviT+wxW2E6IEHH1uQ+ga3zxzbz8bZf8eQg/B8FpKPMNG/tZ0sNds6IcIbI5nwEdI
         fMdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2kwiJbYURYRlDKL0Dl0F6lgZz50z35k9U64Ijz0yS0o=;
        b=Cl0L7THhevcWg5Ci6UL/WrCJpvfYxgjG86irKEdH4xfzoA4AeO3NuI+TuLxGxHBWpq
         brxfveoEZYmIntflZevLVeZsjrVUZflT4Z+SElrXUnRHvqT1LhAax9/6dvDJsgDWlZNd
         LnYWZ/mv6IK3Lu89Zw/HPPlxK6dFO1GV+63Y1qcHilDLnWBRvuur3Lkfynk7XdsRF0kA
         WgSt6XEsiyibn0rMYjxWikNE3li2//rzXpo1UxuWsw2cbS7RH/iyQIublx+GXFQ6b6+d
         I7ppdTnXhMFJHJ/KWxhm9Uw0amspqmjIktfAeAmCEHI6Vf66lZ9weAdpQJIdUrkwLiQW
         CIfA==
X-Gm-Message-State: AOAM531ieZQHb06eca24jr0RjhY7L4gl3rnE6PRryxck+R9fr8Ou7HfW
        05ylGkRFmXmyUWzdHF0GDNY=
X-Google-Smtp-Source: ABdhPJxrBHDd/hb8dFbUdgmMJCueKYj3ZNtr4OeECL/Icf67UGtAwRDYRwBVs8KhMhgxxm3Q3q98rQ==
X-Received: by 2002:a17:906:6b82:: with SMTP id l2mr4547576ejr.241.1606852100971;
        Tue, 01 Dec 2020 11:48:20 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id oz19sm317711ejb.28.2020.12.01.11.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 11:48:20 -0800 (PST)
Date:   Tue, 1 Dec 2020 21:48:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jean Pihet <jean.pihet@newoldbits.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ryan Barnett <ryan.barnett@rockwellcollins.com>,
        Conrad Ratschan <conrad.ratschan@rockwellcollins.com>,
        Hugo Cornelis <hugo.cornelis@essensium.com>,
        Arnout Vandecappelle <arnout.vandecappelle@essensium.com>
Subject: Re: [PATCH v2] net: dsa: ksz8795: adjust CPU link to host interface
Message-ID: <20201201194819.ygmrdwcpvywkszat@skbuf>
References: <20201201083408.51006-1-jean.pihet@newoldbits.com>
 <20201201184100.GN2073444@lunn.ch>
 <CAORVsuXv5Gw18EeHwP36EkzF4nN5PeGerBQQa-6ruWAQRX+GoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAORVsuXv5Gw18EeHwP36EkzF4nN5PeGerBQQa-6ruWAQRX+GoQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jean,

On Tue, Dec 01, 2020 at 07:58:01PM +0100, Jean Pihet wrote:
> Hi Andrew,
>
> On Tue, Dec 1, 2020 at 7:41 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Tue, Dec 01, 2020 at 09:34:08AM +0100, Jean Pihet wrote:
> > > Add support for RGMII in 100 and 1000 Mbps.
> > >
> > > Adjust the CPU port settings from the host interface settings: interface
> > > MII type, speed, duplex.
> >
> > Hi Jean
> >
> > You have still not explained why this is needed. Why? is always the
> > important question to answer in the commit message. The What? is
> > obvious from reading the patch. Why does you board need this, when no
> > over board does?
>
> I reworked the commit description about the What and thought it was
> enough. Do you need a cover letter to describe it more?
>
> The Why is:
> "
> Configure the host port of the switch to match the host interface
> settings. This is useful when the switch is directly connected to the
> host MAC interface.
> "
> Thank you for reviewing the patch.

First of all, I am not clear if you want the patch merged or not. If you
do, then I don't understand why you did not use the ./scripts/get_maintainer.pl
tool to get the email addresses of the people who can help you with
that. No one from Microchip, not the DSA maintainers, not the networking
maintainer.

Secondly, don't you get an annoying warning that you should not use
.adjust_link and should migrate to .phylink_mac_link_up? Why do you
ignore it? Did you even see it?

Thirdly, your patch is opaque and has three changes folded into one. You
refactor some code from ksz8795_port_setup into a separate function, you
add logic for the speeds of 100 and 10 for RGMII, and you call this
function from .adjust_link. You must justify why you need all of this,
and cannot just add 3 lines to ksz8795_port_setup. You must explain that
the ksz8795_port_setup function does not use information from device
tree. Then you must explain why the patch is correct.
The code refactored out of ksz8795_port_setup, plus the changes you've
added to it, looks now super weird. Half of ksz8795_mii_config treats
p->phydev.speed as an output variable, and half of it as an input
variable. To the untrained eye this looks like a hack. I'm sure you can
clarify. This is what Andrew wants to see.

Fourth, seriously now, could you just copy Microchip people to your
patches? The phylink conversion was done this summer, I'm sure they can
help with some suggestions.
