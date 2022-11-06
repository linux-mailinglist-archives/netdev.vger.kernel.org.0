Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB5361DFE8
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 02:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiKFBjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 21:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiKFBjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 21:39:17 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA80FAE2
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 18:39:16 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id bk15so11642553wrb.13
        for <netdev@vger.kernel.org>; Sat, 05 Nov 2022 18:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=u2aTv47BmgT4WaRXKN3sKOx2F3407bBEgRO7zZ1+mEQ=;
        b=OkK0002XOljN6cp5qEjZhUXtc/1GBxd4Blpu4fKxcYw/UwxHw1h8Ld2pnOUu0wE5l9
         CedvKF2Q+kQHlwgs7vbvGbqdKdJbdGQT1OFZjoy2qiOHHW1U5Ii4JePPUH6o/WNv7/gv
         cFj6LIANhWPH499sLpswpoQwfdB75qkDlm93lYfE9cBeNifouzHIK6QUwXd3A0YiZt9X
         q6WLEqNe9mBOE0z84KSR+ks17wTZGPtn5mp53T6YcUdGHU7tCVyOaNnvAxtqTvZmwHLB
         tXmG3NdS8cWggy+i74aCEEr7PKOWJFdSexprWnioXIYrHOpbrelW8IHOWrgK2HF9G3+b
         8Amw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u2aTv47BmgT4WaRXKN3sKOx2F3407bBEgRO7zZ1+mEQ=;
        b=eAG4munAMp7uyyukenFmueXHB6cNB4xiPAZ58EfIGAb71YG8ktGMyn+Vw+oneD9AyD
         0Vmbmr0BsI6UZIwlM8dfo+hFiWT1iN86eFnfWKym0Qpop12jxcg7rSOTbt60K8txlfpk
         2tmJrbRZpP6xjk52uEMbtcCI8H5KuK7K3mRREKDmvKQP54nOq8GxzUDlHPtkk9m/t2j7
         w/LlXTsDjjUfH6pWn//+MN3wyGPhuixG5wvoRkyVNh6zPl0wvH2Eszmo/mZWiI2WFrgO
         +3j/YN4jKHpofEBlODbIfAZQWil1IlSoqOfL9DkICz1b0DGVLd5ve5oa+3Z441wSfwSw
         Kdew==
X-Gm-Message-State: ACrzQf1iqupyWWAgoTpJxeh8BCMkOvT5RRYap2/pgY41uNbgSCNptY9I
        baY2dpwowDzWfMZdZDccD20KrUo9VIfAVQ==
X-Google-Smtp-Source: AMsMyM4qv3fD1hRquP/B7ehHMO5mzf4QFQm7X92ozmNiPVshhfsRq8lW2s5r/TH6LEmhnI2asfr4Hw==
X-Received: by 2002:a5d:4811:0:b0:236:7077:e3c3 with SMTP id l17-20020a5d4811000000b002367077e3c3mr26376129wrq.368.1667698754421;
        Sat, 05 Nov 2022 18:39:14 -0700 (PDT)
Received: from zbpt9gl1 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id p14-20020adff20e000000b0022e344a63c7sm3435910wro.92.2022.11.05.18.39.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Nov 2022 18:39:13 -0700 (PDT)
From:   <piergiorgio.beruto@gmail.com>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <netdev@vger.kernel.org>
References: <026701d8f13d$ef0c2800$cd247800$@gmail.com> <Y2b0cK541R8qQrKf@lunn.ch>
In-Reply-To: <Y2b0cK541R8qQrKf@lunn.ch>
Subject: RE: Adding IEEE802.3cg Clause 148 PLCA support to Linux
Date:   Sun, 6 Nov 2022 02:39:18 +0100
Message-ID: <027901d8f180$96886a20$c3993e60$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIkukaByH4maS1tffwWlBx1lV4jaQKQlWvRrYT3OzA=
Content-Language: en-us
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,
Thank you for your kind reply.

Please see my answers interleaved below.

Kind Regards,
Piergiorgio

-----Original Message-----
From: Andrew Lunn <andrew@lunn.ch> 
Sent: 6 November, 2022 00:41
To: piergiorgio.beruto@gmail.com
Cc: netdev@vger.kernel.org
Subject: Re: Adding IEEE802.3cg Clause 148 PLCA support to Linux

On Sat, Nov 05, 2022 at 06:42:10PM +0100, piergiorgio.beruto@gmail.com
wrote:
>> Hello,
>> I would like to add IEEE 802.3cg-2019 PLCA support to Linux.

> Could you recommend any introductory document? 802.3 can be heavy going.

The 10BASE-T1S specifications span over Clauses 147 and 148. 802.3cg is an
amendment over 802.3 adding these clauses and further amending Clause 22, 45
and 30. Please, be aware that 802.3cg amends more clauses related to
10BASE-T1L (long-reach, point-to-point PHY), T1 autoneg and power over data
lines. However, these are not in scope for 10BASE-T1S and PLCA. The standard
is relatively new (2019) therefore there isn't a lot of whitepapers
available yet.
I can recommend presentations posted on the IEEE 802.3cg website
(https://www.ieee802.org/3/cg/). This one is contains a general overview of
PLCA: https://www.ieee802.org/3/cg/public/July2018/PLCA%20overview.pdf.
I can also send you a few presentations on a separate e-mail.
Finally, I'm drafting a Wikipedia page on T1S
(https://en.wikipedia.org/wiki/Draft:10BASE-T1S) but it is really work in
progress.

>> PLCA (Physical Layer Collision Avoidance) is an enhanced media-access 
>> protocol for multi-drop networks, and it is currently specified for 
>> the 10BASE-T1S PHY defined in Clause 147 of the same standard.

>> This feature is fully integrated into PHY and MACPHY implementations 
>> such as the onsemi NCN26010 and Microchip LAN867x, which are available 
>> on the market.

> Do the MAC and PHY need to negotiate this feature? Does the MAC need to
know if the PHY is PLCA capable? Ideally,
> genphy_c45_pma_read_abilities() can determine if a PHY is PLCA capable?
And the MAC can then check the result of this and enable its part of PLCA?

PLCA was intentionally designed NOT to change the MAC. It is similar to EPON
in this regard (but way simpler). So the straight answer is no, the MAC does
not need to know that the PHY is PLCA capable.
However, PLCA can only work if the MAC supports half-duplex mode.
PLCA support can be tested by probing dedicated registers. Unfortunately,
because of "political/philosophical" fights we could not specify the PLCA
registers in Standard Clause 45 at the time the standard was sent for
review. This is why we ended up having a separate document. We do have
Clause 30 parameters, which maps directly to the registers defined in the
OPEN Alliance.

IMPORTANT: if you look at the IEEE specifications, the PLCA RS is defined to
be on top of the MII interface (but still below the MAC, in the Physical
layer). This is due to how the IEEE layering is structured, but it is NOT
how everybody implements PLCA. As I said, the intention was not to require
modifications to the MAC. You can see this explained in
https://www.ieee802.org/3/cg/public/July2018/PLCA%20overview.pdf and
https://www.ieee802.org/3/cg/public/Jan2019/Tutorial_cg_0119_final.pdf. In
short, there is an "internal" MII between the RS and the PCS layers, plus an
exposed MII which connects to the MAC (formally it is an implementation of
Clause 4 and 6 primitives that matches the existing MII interface). This
external MII allows to connect to any MAC, In fact, it was tested
successfully even against MAC belonging to 1990's.

>> In practice, what we need to do is configuring some additional 
>> parameters of the PHY: PLCA ID, TO_TIMER, NODE_COUNT, BURST.

> Are these purely PHY configuration values? Is the MAC involved at all?
They are PHY attributes, the MAC is unaware of the underlying PLCA layer.

>> The PHY registers for PLCA configuration are further documented in the 
>> OPEN alliance SIG public specifications (see 
>> https://www.opensig.org/about/specifications/ -> PLCA Management
>> Registers)

> Nice. But do the available PHYs actually follow this? Ideally you should
provide a set of helpers which implement these registers. But you have to
assume that silicon vendors will ignore the standard and implement it
differently. They often do. So the helpers are just helpers, and the PHY
driver
> needs to be able to implement these values in there own way.

The Si vendors are actually following this specification. I work for one of
those companies, and you can see that implemented in these datasheets:
https://www.onsemi.com/download/data-sheet/pdf/ncn26010-d.pdf
https://ww1.microchip.com/downloads/aemtest/AIS/ProductDocuments/DataSheets/
DS-LAN8670-1-2-60001573C.pdf
I am also personally aware of more implementations that are coming to the
market from different suppliers and they are all going to follow this
standard.  In fact, it is required by our customers and there is just no
reason not to follow those.
Just to cite an example, during the automotive Ethernet congress in Munich
(June 2022) there was a big show where products from Analog Devices, Marvell
and others have been demonstrated and tested for interoperability. All of
those are OPEN compliant.

>> The parameters I mentioned has to be configured dynamically.

> How dynamically? And what is setting them? Do you see the need for a user
space daemon? Are values placed in /etc/network/interfaces?

At the moment, the actual method for setting these parameters is not
mandated by the standard. In my understanding, people will use different
approaches based on their application. For engineered networks, they will
likely be set according to some HW configuration (EEPROM, GPIOs, board
slot/connector, switch port, etc.). In other use cases, the network will
start in "normal" CSMA/CD mode to negotiate the PLCA configuration using
LLDP and/or DHCP.

So, back to your questions, I don't really know yet. I believe we are going
to have different approaches, some of which may require a user-space daemon.
But eventually, everything comes down to writing the appropriate values in
the PHY registers. For a start, that will be sufficient.
I don't mean to create confusion, but there is another standard,
IEEE802.3da, that is further extending PLCA to implement a fully automated
way to assign the PLCA IDs in HW (we call this D-PLCA). However, it is still
work in progress and I'd rather not mix the two things here and now.
Existing products implement PLCA, not D-PLCA. I mentioned this just to give
you the bigger picture.

> Ethtool does seems like one option. But i would like to understand the
bigger picture before making a definitive answer.
Sure, I totally understand. And I'll be happy to answer any question you
might have.

       Andrew

