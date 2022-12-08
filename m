Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837E764722A
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiLHOsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiLHOsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:48:37 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2289B788;
        Thu,  8 Dec 2022 06:48:36 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id b2so4586379eja.7;
        Thu, 08 Dec 2022 06:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=00p7rONc2FkqSf20UtrjB58mPIeQEEbiYn3obv5eTxY=;
        b=K9TOfSutGmKyR3W8mmUSWFqgX1rzGMRCRLdqWBjByh8biL990XcU8tRsgwWkAvkk2Q
         ZcUp7QptmgWpFBON/09MHdaw+SfmZORqJz431zZRxB/QdVVZA37RgJj6PNORDVaGtn49
         h1oaMywAj4/DqJINkjpHcaniKcGm8UB+AmDUFnpYWy5IobeBpKiQfm0TKFEf7CcAMo1V
         X4+wbfg4E47lNnDnmtmUaC3UlNB9MZJM8XVvsEJfaCOen6wlJ+s4cLX9iex5DNeWmbGZ
         W6oeQgQ7bl+XOPqBwuXs4QQ10TSftCLkQh4KO70mhomoqqtHidB8qvfnnf1gv8ZH9B7Q
         DwLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=00p7rONc2FkqSf20UtrjB58mPIeQEEbiYn3obv5eTxY=;
        b=uAniQpvYEDjuGdHoTA0oxtSZGsoX5yQPXSCFchNz7fkQfx0x69xiicLNrT2DGRltFZ
         ZDnLPJMGV9BtMpMW4BFDJcJ+pSSR5A3VstD1gxYzvXupAxazvXShTzCOJYHEXByGG+IR
         XZ4L+qLBfX5EM7HKDDRozWcA4RWaSJbQWaJUZ/T3ZmUzwIWLfhsvFj/0LwChnBu1gNCU
         ry2c18oeFHC6X1qzyMaj9/+K6Sf6aarxssIadbahXa6MkN8VPXclHoOS5RTg/356jIc/
         bOAK9Bl6pkig908JNJtDLI0ckW/SveRIkWgSQuktoKVilwP75mgL2zpUfMem4/CjYa4H
         4sqQ==
X-Gm-Message-State: ANoB5pnKATLB9DZnsoaty+1JrwFOReQLQ+9kqh+JKZfBa0wqImTejDnR
        RlmpN9ZQTPYZZcZ8pmZZ+Us=
X-Google-Smtp-Source: AA0mqf45zQwV75WmD2T2GxL1vHS9gvntk9mpDT+8urBxhaxB5DhQ8E9tpJyyrQ7atb0IPwSnrRhsfQ==
X-Received: by 2002:a17:907:3ac2:b0:7c1:765:9cfc with SMTP id fi2-20020a1709073ac200b007c107659cfcmr1464382ejc.34.1670510914948;
        Thu, 08 Dec 2022 06:48:34 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id v1-20020a1709063bc100b007ad84cf1346sm9708761ejf.110.2022.12.08.06.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 06:48:34 -0800 (PST)
Date:   Thu, 8 Dec 2022 15:48:48 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v5 net-next 1/5] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y5H5UJ3BSNdxkNJ4@gvm01>
References: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
 <350e640b5c3c7b9c25f6fd749dc0237e79e1c573.1670371013.git.piergiorgio.beruto@gmail.com>
 <20221206195014.10d7ec82@kernel.org>
 <Y5CQY0pI+4DobFSD@gvm01>
 <20221207181056.121cdf34@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207181056.121cdf34@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > 
> > > This is 30.16.1.1.3 aPLCANodeCount ? The phrasing of the help is quite
> > > different than the standard. Pure count should be max node + 1 (IOW max
> > > of 256, which won't fit into u8, hence the question)
> > > Or is node 255 reserved?  
> > This is indeed aPLCANodeCount. What standard are you referring to
> > exactly? This is the excerpt from IEEE802.3cg-2019
> > 
> > "
> > 30.16.1.1.3 aPLCANodeCount
> > ATTRIBUTE
> > APPROPRIATE SYNTAX:
> > INTEGER
> > BEHAVIOUR DEFINED AS:
> > This value is assigned to define the number of nodes getting a transmit opportunity before a new
> > BEACON is generated. Valid range is 0 to 255, inclusive. The default value is 8.;
> 
> FWIW this is what I was referring to. To a layperson this description
> reads like a beacon interval. While the name and you documentation
> sounds like the define max number of endpoints.
I agree, the description is not friendly to the average user, it mostly
comes from IEEE jargon. What it really means is that the coordinator
(master) will count up to aPLCANodeCount TOs before generating a new
BEACON. This means that nodes shall have IDs from 1 to plcaNodeCount - 1
to get a TO. ID = 0 is reserved for the coordinator.

> 
> > And this is what I can read in the OPEN Alliance documentation:
> > 
> > "
> > 4.3.1 NCNT
> > This field sets the maximum number of PLCA nodes supported on the multidrop
> > network. On the node with PLCA ID = 0 (see 4.3.2), this value must be set at
> > least to the number of nodes that may be plugged to the network in order for
> > PLCA to operate properly. This bit maps to the aPLCANodeCount object in [1]
> > Clause 30.
> > "
> > 
> > So the valid range is actually 1..255. A value of 0 does not really mean
> > anything. PHYs would just clamp this to 1. So maybe we should set a
> > minimum limit in the kernel?
> 
> SG, loosing limits is easy. Introducing them once they are in 
> a released kernel is almost impossible.
Ok, so let's set the lower limit to 1.

> 
> > Please, feel free to ask more questions here, it is important that we
> > fully understand what this is. Fortunately, I am the guy who invented
> > PLCA and wrote the specs, so I should be able to answer these questions :-D.
> 
> I am a little curious why beacon interval == node count here, but don't
> want to take up too much of your time for explaining things I could
> likely understand by reading the spec, rather than fuzzy-mapping onto
> concepts I comprehend :(
See also my answer above. The basic idea is that you have a concept of
'cycle', similar to a TDMA system, and each node has a chance to
transmit in turn (round-robin). The difference with a TDMA system is that
the TO is only TO_TIMER bits by default, but once a node "commits" to
the TO by initiating a transmission, the TO itself can be extended up to
the MTU multiplied by the configured burst counter (which by default is
0, meaning 1 as it is 0-based). In other words, the end of a TO is
determined by the detection of the end-of-frame. Note that PLCA is a
fully distributed system, meaning that each node counts the TOs on its
own and no PLCA information is ever shared over the media. It is a full
Layer 1 protocol.

So the coordinator node is the one periodically sending a BEACON *which
is a layer 1 signal) which indicates the start of a cycle, and its
coding is made as such that it is easy to detect in noisy environments,
and you can detect the end of it with a high precision.

The node count is the only parameter that the coordinat shall know in
order to send a new BEACON periodically (tracking the TOs based on what
nodes transmit ofc).

I am writing a wikipedia article as well to better explain all of these
concepts. I will keep you posted if you're interested.

In the meantime, you can check this for a general overview:
https://www.dropbox.com/s/ao9m23s6fd7ytns/AEC2019%2010BASE-T1S%20Highlights%20on%20Key%20Figures%20of%20the%2010BASE-T1S%20Multidrop%20PHY.pptx?dl=0

>
> This is completely unrelated to the series - do you know if any of
> the new 10BASE stuff can easily run over a DC power rail within
> a server rack? :)
Well, the 10BASE-T1S does.
I recall DELL presenting exactly this use-case in the IEEE.

All xBASE-T1* PHYs support PoDL (power over data line).


> > Are you referring to this?
> > 
> > "
> > 45.2.3.68f.1 CorruptedTxCnt (3.2294.15:0)
> > Bits 3.2294.15:0 count up at each positive edge of the MII signal COL.
> > When the maximum allowed value (65 535) is reached, the count stops until
> > this register is cleared by a read operation.
> > "
> > 
> > This is the only one statistic counter I can think of. Although, it is a
> > 10BASE-T1S PHY related register, it is not specific to PLCA, even if its
> > main purpose is to help the user distinguish between logical and
> > physical collisions.
> > 
> > I would be inclined to add this as a separate feature unrelated to PLCA.
> > Please, let me know what you think.
> 
> Fair point, I just opened the standard and searched counters.
> Indeed outside of the scope here.
Ok, but still a thing to keep in mind, thanks for pointing this out.

> > > extack is usually the last argument  
> > I actually copied from the cable_test_tdr callback below. Do you still
> > want me to change the order? Should we do this for cable test as well?
> > (as a different patch maybe?). Please, let me know.
> 
> Let's not move it in the existing callbacks but yes, cable_test_tdr
> is more of an exception than a rule here, I reckon.
Ok, so I will change the order for the plca functions.

