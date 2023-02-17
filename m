Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967DD69AE26
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 15:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjBQOfh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Feb 2023 09:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjBQOfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 09:35:36 -0500
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB000644FB;
        Fri, 17 Feb 2023 06:35:33 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id cz7so1615874edb.12;
        Fri, 17 Feb 2023 06:35:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VAtWfhUxp/y51fIF98YnXZ9xOiDTElEXrZ+N1L15ZSs=;
        b=H/3H0vDifQrxKSEPjmRi4rZmvNb6dqy8McGanUceBJt4aqTFJAyxFfFeyivQGyuza5
         b0T4vLtX1b+0flAORmhoFzLi1gIDJ9VqoRlFBecn60NeR/AZ4GIOHZ7toiQjWzx3Jn3r
         PiWS303/sA5IRr7b25wiVitpe8pfUcQujWRCQAytMtzNOTaI8YX3sGwSGtxYR0HZVtKc
         l0Tq1jaXuhTroYHRB1WGs7p/6W74bZVVA6FuJiYDIK8upLSS4RxduG9m8EdZ0HVSMJmU
         Rh+MGHb2+0PukJ22107zH1sfNQ59O3j2BlLb/ISVabV2PIIUemoZ1dp2fEhXBxR2dcyj
         VMlw==
X-Gm-Message-State: AO0yUKUf87611V+o5jxVo3A/Z9EEWsNd9QVs7toGDlk2eyzp5fYRPlOn
        f429+B1WEBGpL/6LwDKyirE=
X-Google-Smtp-Source: AK7set/ADUMEMWkLHo9rV5fNdEI96nMQ1kZODSixiV/YG0eHOEB3enGP0Pn5977UNAENvhFRy0kn4g==
X-Received: by 2002:a17:907:8c89:b0:8b1:779c:a8ac with SMTP id td9-20020a1709078c8900b008b1779ca8acmr4635735ejc.13.1676644532128;
        Fri, 17 Feb 2023 06:35:32 -0800 (PST)
Received: from [10.148.80.132] ([195.228.69.10])
        by smtp.gmail.com with ESMTPSA id z7-20020a1709060ac700b008b17fe9ac6csm1161167ejf.178.2023.02.17.06.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 06:35:31 -0800 (PST)
Message-ID: <d94011783946c2e5be0b346a95a40c365c2e8ede.camel@inf.elte.hu>
Subject: Re: [PATCH v2 net-next] selftests: forwarding: add Per-Stream
 Filtering and Policing test for Ocelot
From:   Ferenc Fejes <fejes@inf.elte.hu>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     peti.antal99@gmail.com, "andrew@lunn.ch" <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "gerhard@engleder-embedded.com" <gerhard@engleder-embedded.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>, "jiri@nvidia.com" <jiri@nvidia.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Date:   Fri, 17 Feb 2023 15:35:30 +0100
In-Reply-To: <20230217130739.flqby6ok3wh5mklw@skbuf>
References: <20220501112953.3298973-1-vladimir.oltean@nxp.com>
         <302dc1fb-18aa-1640-dfc7-6a3a7bc6d834@ericsson.com>
         <20220506120153.yfnnnwplumcilvoj@skbuf>
         <c2730450-1f2b-8cb9-d56c-6bb8a35f0267@ericsson.com>
         <20220526005021.l5motcuqdotkqngm@skbuf>
         <cd0303b16e0052a119392ed021d71980db63e076.camel@ericsson.com>
         <20220526093036.qtsounfawvzwbou2@skbuf>
         <009e968cc984b563c375cb5be1999486b05db626.camel@inf.elte.hu>
         <20230216155813.un3icarhi2h6aga2@skbuf>
         <1284d04958725d772750d6e3908301c8f8a379c1.camel@inf.elte.hu>
         <20230217130739.flqby6ok3wh5mklw@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir!

On Fri, 2023-02-17 at 15:07 +0200, Vladimir Oltean wrote:
> Hi Ferenc,
> 
> On Fri, Feb 17, 2023 at 09:03:30AM +0100, Ferenc Fejes wrote:
> > I agree, it takes time to guess what the intention behind the
> > wording
> > of the standard in some cases. I have the standard in front of me
> > right
> > now and its 2163 pages... Even if I grep to IPV, the context is
> > overwhelmingly dense.
> > 
> (...)
> > I'll try to ask around too, thanks for pointing this out. My best
> > understanding from the IPV that the standard treat it as skb-
> > >priority.
> > It defines IPV as a 32bit signed value, which clearly imply similar
> > semantics as skb->priority, which can be much larger than the
> > number of
> > the queues or traffic classes.
> 
> What would you say if we made the software act_gate implementation
> simply alter skb->priority, which would potentially affect more stuff
> including the egress-qos-map of a VLAN device in the output path of
> the
> skb? It would definitely put less pressure on the networking data
> structures, at the price of leaving an exceedingly unlikely case
> uncovered.

This is exactly what I just started to write in my reply! Yes, this
would be the right choice. The key here is the "exceedingly unlikely
case" what you just mentioned.

If you are lucky enough to have the luxury to think about cases where
the IPV mapping should only affect the queueing and not the egress-qos-
map, it would be nice to have options. Sadly mqprio and taprio
classless, so you can't do the following as far as I understand it:

1. Configure tc act_gate with IPV-s like 0, 1, 2, etc.
2. Configure mqprio/taprio with prio to tc mapping for 0, 1, 2, etc.
3. As mqprio/taprio leaf-s you can apply tc skbedit/bpf direct actions
which altering the skb->priority to values you would like to see at
egress-to-qos mapping
4. The egress-to-qos mapping act on the new skb->priority

However what if mqprio/taprio can read prio:tc map like:
tc qdisc add dev eth0 root mqprio num_tc 4 map 1000:0 1001:1 1000:2
1003:3 queues 1@0 1@1 1@2 1@3 hw 0
I think that dont necessarily break the existing script since we can
check if ":" if in the map parameters or not.
That way skb->priority ---> tc would be flexible (as in egress-qos-
map), the tc ---> queue mapping flexible too, and the original skb-
>priority can control the egress-qos-map differently than the queueing
that way.
I miss something fundamental here?


> 
> > Oh, alright. I continue to think about alternatives over
> > introducing
> > new members into sk_buff. It would be very nice to have proper
> > act_gate
> > IPV handling without hardware offload. Its great to see the support
> > of
> > frame preemption and PSFP support in more and more hardware but on
> > the
> > other hand it makes the lack of the proper software mode operation
> > more
> > and more awkward.
> 
> I'm not sure that cyclic queuing and forwarding done with software
> forwarding is going to be that practical anyway?

VNFs can perform PSFP as well or at least reprioritize the packets.
Also it would be handy for selftests too. Other than that future driver
implementers can verify their operation with the software behavior.

Best,
Ferenc

