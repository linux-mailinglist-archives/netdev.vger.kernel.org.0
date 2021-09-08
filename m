Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F85404012
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 22:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352524AbhIHULv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 16:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352423AbhIHULn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 16:11:43 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90840C061575
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 13:10:35 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id x11so6683239ejv.0
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 13:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition;
        bh=BJOCgrwBsSUozRYsCO1HrTV541p4Ovk41dPL636xOm4=;
        b=UghjdGl9LhFIMry0EIbpJbmHNUOZCro5p+NfEvXVbIe8jYWAzHZvAjDHHRl2OAqam4
         cq+ejo1XD4lkXAKJQSDFVq3ZVrvscwL2jPkkD1X2FKuAJNX1UMBAAloG4Dl9U6OJ7cC1
         aMtucgqYz79EKugVJfHiyAwit4r6WrrYLcLZMeWMs2dfjL1PI2oa+J51T6LdG+YzdsaM
         VrlyBoKFOW3g+W0Ot6o9do1K1LmhYAJU0Fq3OFBgNU/14/fRqq4OidabMlTfNiEhNlXR
         55B+iJXpmFDuaoAJg5ZzP/CiQvk38wvxgeGmlsyj7XSpcAQT0t3zGH1diBVU6bEbmtqT
         3Fcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition;
        bh=BJOCgrwBsSUozRYsCO1HrTV541p4Ovk41dPL636xOm4=;
        b=4r0g3MTyk3dcxPoubZqsCbf1mWy/FclTO3bFj+hcQ1Cs9g6JiSIlaqfss/NhoF//ZW
         VwmK2WL1yiohlXwZgVjECgbcsLtFumcN/BEZe1+H7la1br8q2T2OTR0j5teGP4XoCveF
         pnQqKLIDJGIVCy7h1GThHHy5lH+yy05GMZPYDONHFrwtepVr7Pno4SZ/DjEMl6UcqjBG
         pLxtaxT3ss5HU3eBHQwfZ8aFwyxnYNVBrX00ICA/g6NheUpHm8cZ+D6Ff2ZaUdVQZ1et
         etANeBnLpcM1G4BeAK7ppnGOOSBIAlLoAA6rsJYqDftrtw3RFS7VCBzbq+qGgHwTgTnK
         oZhQ==
X-Gm-Message-State: AOAM533dnct8gVR+nJMt97F6/NzTXsq9ZizXmmDPzJpF4zVQVvdsGOky
        agdfNqxJ6Mky8lCCFE+KsXU=
X-Google-Smtp-Source: ABdhPJxRS5xGKuXUYBG8mzpgUsn4h2PRolkM9q8zK2fnUDNElSkKN9eZ/xoDmRgt6CwzdTnFpkoN2g==
X-Received: by 2002:a17:906:1913:: with SMTP id a19mr1725282eje.390.1631131834076;
        Wed, 08 Sep 2021 13:10:34 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id a11sm11193ejy.87.2021.09.08.13.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 13:10:33 -0700 (PDT)
Date:   Wed, 8 Sep 2021 23:10:32 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 5/5 v2] net: dsa: rtl8366rb: Support fast aging
Message-ID: <20210908201032.nzej3btytfhfta2u@skbuf>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-6-linus.walleij@linaro.org>
 <20210830224626.dvtvlizztfaazhlf@skbuf>
 <CACRpkdb7yhraJNH=b=mv=bE7p6Q_k-Yy0M9YT9QctKC1GLhVEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 07, 2021 at 07:48:43PM +0200, Linus Walleij wrote:
> On Tue, Aug 31, 2021 at 12:46 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> > > +     /* This will age out any L2 entries */
> >
> > Clarify "any L2 entries". The fdb flushing process should remove the
> > dynamically learned FDB entries, it should keep the static ones. Did you
> > say "any" because rtl8366rb does not implement static FDB entries via
> > .port_fdb_add, and therefore all entries are dynamic, or does it really
> > delete static FDB entries?
> 
> It's what Realtek calls "L2 entries" sadly I do not fully understand
> their lingo.
> 
> The ASIC can do static L2 entries as well, but I haven't looked into
> that. The (confused) docs for the function that set these bits is
> the following:
> 
> "ASIC will age out L2 entry with fields Static, Auth and IP_MULT are 0.
>  Aging out function is for new address learning LUT update because
>  size of LUT is limited, old address information should not be kept and
>  get more new learning SA information. Age field of L2 LUT is updated
>  by following sequence {0b10,0b11,0b01,0b00} which means the LUT

This is {3, 2, 1, 0} in 2-bit Gray code, really curious why they went
for that coding scheme. It is common to designate the states of an FSM
in Gray code because of the single bit change required on state
transitions, but in this case, every ageing state should have a
transition path back to 3 when a packet with that {MAC DA, VLAN ID} is
received on the port, and the L2 entry is refreshed. The Gray code
is a micro-optimization that doesn't seem to help for the primary state
transition there. Anyway, doesn't make a difference.

>  entries with age value 0b00 is free for ASIC. ASIC will use this aging
>  sequence to decide which entry to be replace by new SA learning
>  information. This function can be replace by setting STP state each
>  port."
> 
> Next it sets the bit for the port in register
> RTL8366RB_SECURITY_CTRL.
> 
> Realtek talks about "LUT" which I think is the same as "FDB"
> (which I assume is forwarding database, I'm not good with this stuff).

LUT is "look-up table", any piece of memory which translates between a
key and a value is a look-up table. In this case, the forwarding database
would qualify as a look-up table where the key is the {MAC DA, VLAN ID}
tuple, and the value is the destination port mask.

> My interpretation of this convoluted text is that static, auth and ip_mult
> will *not* be affected ("are 0"), but only learned entries in the LUT/FDB
> will be affected.

Same interpretation here. This behavior is to be expected.

> The sequence listed in the comment I interpret as a reference to what
> the ASIC is doing with the age field for the entry internally to
> achieve this. Then I guess they say that one can also do fast aging by
> stopping the port (duh).
> 
> I'll update the doc to say "any learned L2 entries", but eager to hear
> what you say about it too :)

Your interpretation seems correct (I can't think of anything else being meant),
but I don't know why you say "duh" about the update of STP state
resulting in the port losing its dynamic L2 entries. Sure, it makes
sense, but many other vendors do not do that automatically, and DSA
calls .port_fast_age whenever the STP state transitions from a value
capable of learning (LEARNING, FORWARDING) to one incapable of learning
(DISABLED, BLOCKING, LISTENING).

To prove/disprove, it would be interesting to implement port STP states,
without implementing .port_fast_age, force a port down and then back up,
and then run "bridge fdb" and see whether it is true that STP state
changes also lead to FDB flushing but at a hardware level (whether there
is any 'self' entry being reported).

By this logic, the hardware should also auto-age its dynamically learned
L2 entries when address learning is turned off, and there would be no
purpose at all in implementing the .port_fast_age method. Also curious
if that is the case.
