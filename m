Return-Path: <netdev+bounces-3468-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D293707479
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 23:42:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A67A281662
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95090107BE;
	Wed, 17 May 2023 21:42:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AE233F6
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 21:42:10 +0000 (UTC)
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0495E40
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:42:08 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2ac7462d9f1so13809931fa.2
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20221208.gappssmtp.com; s=20221208; t=1684359726; x=1686951726;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=y/r4psW/paqyy4VF8aHPIrSrZcfy04h+Vz2SggJmbHQ=;
        b=AUU79xUi6nQyok8a6qKZ5xCvnzQNfHklBrQFi4OAparANS9+JCwlYZsGuCABCAI74g
         TqULXRQHxwY6fqjPw5zfbosZmyVh5PHAoObSv3d5LNY+MyEoM0mWRfmLPW+iAryjLg5c
         OV2tuza1PO/ayNVQhT89R4Y7W0vBmhIRAIcr6zV0boCpmxrEiUcLCdeuLrxZyHBU2QSl
         hDyyRs7W6RK1lXeWN6j/z0fW1NZJ43fASecC1anCrUCI8m3i2cgRAajBfpo6IplXRbHg
         iZag5Pj0UcyE+wELG6k4lgobeZKT+GJYzsQgX1IBgIJIbzge+gCVWT0SKPJT++zXW3Lh
         RwiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684359726; x=1686951726;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y/r4psW/paqyy4VF8aHPIrSrZcfy04h+Vz2SggJmbHQ=;
        b=IcFJbDJ9b8yt+j/XWW5TnDHMGxFgojnoYnd85NRD3pOGfV5w3WdVBDPVkUlxp+Bwey
         IGZlnB/2QAAZsoR0eP9fMHQqXbobIzRsZr+Y/ziCYW14P4rgYuxiSdc9t5suywSabaDN
         2L1LXuSksC0JJA0wrpb8G5Usp81TW0DKzPmqz99wBpcjcAlv7gVp8P2KIVzL49IHuFQM
         C8ZvLGFd1m6ouYU7QxHuS9nN5IqdX+u59EFG3m+dgEfog/rmOK2ZmucXydWBha0TN1J2
         Vx6S21F8Q22pqg+ZROyfch2bwCKSyRPfUW4LN06CzpLVo+eKw7EZMfmZkYYD5b+bCkuP
         wgbg==
X-Gm-Message-State: AC+VfDw/Dg2r6TA4UCBV+nvtNzKCjt1aKSH0Zxi6mXRGKshRO+35sID0
	xsLHslTIPisBnD4MEwd5NZB8k9kIdB9z4hEp1KE=
X-Google-Smtp-Source: ACHHUZ5HjEKufs5V5AFeEIjo589kidP49++xgP1lbOh7aRS8ctE2sEvY5YnDEXLZOpyjqKtbJLXdMg==
X-Received: by 2002:a2e:b172:0:b0:2a7:8150:82c1 with SMTP id a18-20020a2eb172000000b002a7815082c1mr9728123ljm.38.1684359726334;
        Wed, 17 May 2023 14:42:06 -0700 (PDT)
Received: from wkz-x13 (h-176-10-137-178.NA.cust.bahnhof.se. [176.10.137.178])
        by smtp.gmail.com with ESMTPSA id w5-20020a2e9985000000b002ad8fc8dda6sm4188083lji.17.2023.05.17.14.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 14:42:05 -0700 (PDT)
From: Tobias Waldekranz <tobias@waldekranz.com>
To: Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc: Fabio Estevam <festevam@gmail.com>, Florian Fainelli
 <f.fainelli@gmail.com>, Steffen =?utf-8?Q?B=C3=A4tz?=
 <steffen@innosonix.de>, netdev
 <netdev@vger.kernel.org>
Subject: Re: mv88e6320: Failed to forward PTP multicast
In-Reply-To: <41d7d1e8-19b8-4025-a1eb-0fbb0f54fe15@lunn.ch>
References: <7b8243a3-9976-484c-a0d0-d4f3debbe979@lunn.ch>
 <CAOMZO5DXH1wS9YYPWXYr-TvM+9Tj8F0bY0_kd_EAjrcCpEJJ7A@mail.gmail.com>
 <CAOMZO5Dk44QSTg2rh_HPHXg=H7BJ+x1h95M+t8nr2CLW+8pABw@mail.gmail.com>
 <5e21a8da-b31f-4ec8-8b46-099af5a8b8af@lunn.ch>
 <CAOMZO5DSSQY5fa5vTmDbCxu1x2ZRdyB2kTqrkw5bRg94_-34zg@mail.gmail.com>
 <87pm77dg5i.fsf@waldekranz.com>
 <CAOMZO5CZoy12WrBEQFMupv5sPh2EjSPm+UmGz=-WkS7A97CtqQ@mail.gmail.com>
 <87wn1foze1.fsf@waldekranz.com>
 <CAOMZO5AQtL1BNk2sm2v=c5fLbukkZSi6HSJXexp4QB4JjAyw-g@mail.gmail.com>
 <20230517165335.o2hvnz7ymi3nh7sy@skbuf>
 <41d7d1e8-19b8-4025-a1eb-0fbb0f54fe15@lunn.ch>
Date: Wed, 17 May 2023 23:42:04 +0200
Message-ID: <87sfbuprdf.fsf@waldekranz.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On ons, maj 17, 2023 at 19:07, Andrew Lunn <andrew@lunn.ch> wrote:
>> Slightly unrelated to the original topic and probably completely
>> unrelated to Fabio's actual issue.
>> 
>> I'm completely inapt when it comes to IP multicast. Tobias, does the
>> fact that br0 have mcast_router 1 mean that the CPU port should be a
>> recipient of all multicast traffic, registered or unregistered?

If the bridge is the elected querier, then yes, br0 should receive _all_
IP multicast.  However, I believe that mcast_router=1 only means that
the bridge is allowed to take part in the election, if you have another
querier/router somewhere on the LAN, then that might be elected.

Assuming that br0 is the elected querier, Fabio is probably hitting a
long-standing issue with the MDB-implementation in the DSA/mv88e6xxx
layers.  Typically, drivers will ensure that router ports (and host
mrouter) receive _unknown_ multicast.  However, existing _registered_
groups still won't reach these ports.

In all hardware that I've seen, this must be handled by iterating over
all known (IP) groups in the MDB, ORing in the new router port (which
could be the CPU port in the host mrouter case).  Conversely, when new
groups are registered, you must also make sure to OR in all existing
router ports.

Deletions are even more perilous, because now each bit in a hardware MDB
(ATU) entry might have been set for either one or both of two reasons:

1. Because an IGMP/MLD report or a static configuration said so.
2. Because a router/querier is located behind it.

This means that you need to cache all this information in software to
know when it is safe to clear a bit in the hardware.

I have made a draft implementation of this, which I do not have access
to at the moment.  I'll poke around and see if I can find it.

> It is a long time since i did much with multicast. But my
> understanding is that a multicast router should be taking part in
> IGMP. If there is a group member on the other side of the gateway, the
> router should indicate it has interest in the group so traffic flows
> to it. It can then forward the traffic between its multicast
> interfaces, based on that interest.

Yes, that would have been the sane thing to do.  Indeed, if you're
running a protocol like PIM-SM, it could have been done that way.  Alas,
we also have flood-and-prune based protocols like DVMRP to deal with,
where the router has to flood all groups to all other routers until it
receives a prune message.  This is why, AFAIK, the standard says that a
router port needs to also receive unregistered groups.

