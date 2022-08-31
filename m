Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE725A742A
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 04:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbiHaCxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 22:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiHaCxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 22:53:48 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0B8B531A
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 19:53:46 -0700 (PDT)
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B15283F0C3
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 02:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1661914421;
        bh=09OcBZSk3c8Sm08Wm2Xfk2PNKZD8l9xuc5LRaaUBkBg=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=KavYXBnP1hKuV3KDSxc7ZrlRM4JQzopBQQoh1gXQrLCyS4fZNdh8LUeo3/Lf7G1dO
         3mgtbhewFx0h3tTAzM7p55ZvHhaWhHtaTJ7cPsFZ1adfoyMprKxBXC+ZHu8Qb2sccQ
         1CuP1uQpESUS/BMEDdKhuwMD7zqAa34nzHCbOZ15fxuCiPg7WzdZDxL2O1fqcnyvj/
         DTGGku5c3uT/I1QHhAA+a497ZZc6EAmdsm5O3TXPLuKNFm/ywHXi+KHdXaUDx7eeh/
         rXPCuWgwEqT3+2ARKhDnbtlo0KBQhE+rmjMoDg8LFlMcTIjyqSSIE+RE4yCD0NlwmJ
         UJJ2kZyxG40Ug==
Received: by mail-io1-f70.google.com with SMTP id o10-20020a6b5a0a000000b0068aba769d73so7907787iob.4
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 19:53:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=09OcBZSk3c8Sm08Wm2Xfk2PNKZD8l9xuc5LRaaUBkBg=;
        b=SAL61pIPmyn12Z5LFdZ7wcO4jNuJFEoqSD48QYQaAhiIn4ZterJYodGrg3H4ezyJto
         PGXNhncJQ54MdFCj4OfXT3P7IN2ox0ZWYNUg/PUKUViJpxM9sRW0CK6IEDtLb/Z+EqA2
         2XGeXX1454P64WZ993codAKmR7yBNoQbNYKG8JN6e854VGpymLg95HmSlxc0MI5u2dO4
         0C9nIeIcRu47fdN9/IQMFwy1OhaRIejWasOPyNm+JMjnEV3fspmyxli3gsY0wXhdQm1l
         Y7FPK8Cmnr62x46Jx1RHtjpObnBxgWYqvAXJ3TcQ3n58l2HAcgpJKbe8T4hBDV2BtIpJ
         a07w==
X-Gm-Message-State: ACgBeo01L4XCb98A6bIOCMMdyoLt+X1Xm7qHgyTwAKEWf6M5m7qV592S
        kaj0nwvD46kgFgnWE8y6t17p3BIVwwwSrh8BmLZXruLq/23M3FdkR7jIi8EixqT55AvVNtlKwCF
        pQ+0D2hLPvkx6mI2WwxScMDY0K9CSf6NhRQ==
X-Received: by 2002:a92:db04:0:b0:2e5:dbb6:1285 with SMTP id b4-20020a92db04000000b002e5dbb61285mr13613666iln.275.1661914420312;
        Tue, 30 Aug 2022 19:53:40 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5vj+NSE4S7Os9IYNEYUk608sRSgwn+eSJJ31WC/m0Y/boLuIBJXkR2Wc5O5hwnbYxdXPVkLw==
X-Received: by 2002:a92:db04:0:b0:2e5:dbb6:1285 with SMTP id b4-20020a92db04000000b002e5dbb61285mr13613648iln.275.1661914420094;
        Tue, 30 Aug 2022 19:53:40 -0700 (PDT)
Received: from nyx.localdomain ([204.77.137.230])
        by smtp.gmail.com with ESMTPSA id y6-20020a056602178600b0068baa94eafbsm2555686iox.16.2022.08.30.19.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 19:53:39 -0700 (PDT)
Received: by nyx.localdomain (Postfix, from userid 1000)
        id 218072410F8; Tue, 30 Aug 2022 19:53:39 -0700 (PDT)
Received: from nyx (localhost [127.0.0.1])
        by nyx.localdomain (Postfix) with ESMTP id 190972808B5;
        Tue, 30 Aug 2022 19:53:39 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, LiLiang <liali@redhat.com>
Subject: Re: [PATCH net] bonding: fix lladdr finding and confirmation
In-reply-to: <YwyNNsaD8+QYd4Ot@Laptop-X1>
References: <20220825041327.608748-1-liuhangbin@gmail.com> <191411.1661728843@nyx> <YwyNNsaD8+QYd4Ot@Laptop-X1>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Mon, 29 Aug 2022 17:56:06 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.7.1; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <194688.1661914419.1@nyx>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 30 Aug 2022 19:53:39 -0700
Message-ID: <194689.1661914419@nyx>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

[...]
>> 	I'm not exactly sure which change matches which of the three
>> above fixes; should this be three separate patches?
>
>The 1st case(send side) is fixed in function bond_ns_send_all().
>The 2nd case(receive side) is fixed in addrconf_notify().
>The 3rd case(validating side) is fixed in bond_validate_ns/na()
>
>> =

>> >Reported-by: LiLiang <liali@redhat.com>
>> >Fixes: 5e1eeef69c0f ("bonding: NS target should accept link local addr=
ess")
>> =

>> 	Is this fixes tag correct for all the fixes?  Number 2 cites a
>> different commit (c2edacf80e15). =

>
>Before we support link local target for bonding. Commit (c2edacf80e15) wo=
rks
>as bond device could up and add the all node multicast correctly.
>
>After we adding the link local target for bonding. The bond could not up
>and not able to add node multicast address. So I think the fixes tag shou=
ld
>not be commit (c2edacf80e15).
>
>> Again, should these be three separate patches?
>
>I thought these 3 parts are all to fix lladdr target. So I put them toget=
her.
>If you think it's easier to review. I can separate the patches of course.

	I see the set of three posted separately, thanks.

>> =

>> >@@ -3246,14 +3256,14 @@ static int bond_na_rcv(const struct sk_buff *s=
kb, struct bonding *bond,
>> > 	 * see bond_arp_rcv().
>> > 	 */
>> > 	if (bond_is_active_slave(slave))
>> >-		bond_validate_ns(bond, slave, saddr, daddr);
>> >+		bond_validate_na(bond, slave, saddr, daddr);
>> > 	else if (curr_active_slave &&
>> > 		 time_after(slave_last_rx(bond, curr_active_slave),
>> > 			    curr_active_slave->last_link_up))
>> >-		bond_validate_ns(bond, slave, saddr, daddr);
>> >+		bond_validate_na(bond, slave, saddr, daddr);
>> > 	else if (curr_arp_slave &&
>> > 		 bond_time_in_interval(bond, slave_last_tx(curr_arp_slave), 1))
>> >-		bond_validate_ns(bond, slave, saddr, daddr);
>> >+		bond_validate_na(bond, slave, saddr, daddr);
>> =

>> 	Is this logic correct?  If I'm not mistaken, there are two
>> receive cases:
>> =

>> 	1- We receive a reply (Neighbor Advertisement) to our request
>> (Neighbor Solicitation).
>> =

>> 	2- We receive a copy of our request (NS), which passed through
>> the switch and was received by another interface of the bond.
>
>No, we don't have this case for IPv6 because I did a check in
>
>static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
>                       struct slave *slave)
>{
>	[...]
>
>        if (skb->pkt_type =3D=3D PACKET_OTHERHOST ||
>            skb->pkt_type =3D=3D PACKET_LOOPBACK ||
>            hdr->icmp6_type !=3D NDISC_NEIGHBOUR_ADVERTISEMENT)
>                goto out;
>
>Here we will ignore none NA messages.

	Is there a reason to implement this differently from the ARP
monitor with regard to the "passed request through switch to backup
interface" logic?  Are the backup interfaces then always down until the
active interface fails (in other words, what do they receive)?

	Assuming that there is a good reason, the commentary in
bond_na_rcv() is misleading, as it says to "see bond_arp_rcv()" for the
logic.  Again, assuming there's a good reason for it, can you amend this
comment to mention that the "Note: for (b)" in the bond_arp_rcv()
commentary does not apply to bond_na_rcv() for whatever the good reason
is?

	-J

>Thanks
>Hangbin
>> =

>> 	For the ARP monitor implementation, in the second case, the
>> source and target IP addresses are swapped for the validation.
>> =

>> 	Is such a swap necessary for the NS/NA monitor implementation?
>> I would expect this to be in the second block of the if (inside the
>> "else if (curr_active_slave &&" block).
>> =

>> 	-J
>> =

>> > out:
>> > 	return RX_HANDLER_ANOTHER;
>> >diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>> >index e15f64f22fa8..77750b6327e7 100644
>> >--- a/net/ipv6/addrconf.c
>> >+++ b/net/ipv6/addrconf.c
>> >@@ -3557,11 +3557,14 @@ static int addrconf_notify(struct notifier_blo=
ck *this, unsigned long event,
>> > 		fallthrough;
>> > 	case NETDEV_UP:
>> > 	case NETDEV_CHANGE:
>> >-		if (dev->flags & IFF_SLAVE)
>> >+		if (idev && idev->cnf.disable_ipv6)
>> > 			break;
>> > =

>> >-		if (idev && idev->cnf.disable_ipv6)
>> >+		if (dev->flags & IFF_SLAVE) {
>> >+			if (event =3D=3D NETDEV_UP && !IS_ERR_OR_NULL(idev))
>> >+				ipv6_mc_up(idev);
>> > 			break;
>> >+		}
>> > =

>> > 		if (event =3D=3D NETDEV_UP) {
>> > 			/* restore routes for permanent addresses */
>> >-- =

>> >2.37.1

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
