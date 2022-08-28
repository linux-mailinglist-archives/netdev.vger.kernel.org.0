Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EE85A4025
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 01:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiH1XUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 19:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiH1XUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 19:20:49 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80FAD133
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 16:20:47 -0700 (PDT)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E92A33F0C8
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 23:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1661728846;
        bh=p9PcOId8CVnJ5ezXOu/o72E0GBfIcrDq4iBwQQHuaKo=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=bpQ4FKqCJSr7b3QejFA1ZI9aIK8QnD8H6PrpEBSgDOcfhP2DDCXGScK7i6/MFp4nL
         fB7xgJUTOVqfKfQw/U+salBrRcnkNzhukU5uRq0EiIoi5n8lsBRiVUYhcsyv7l/ME2
         rODramzCZl6ZaVRqhrmUDqwdnW1OiSfqXrfuyO+Zu2vo/RZLyjrFKa0QRSweG2FCUv
         Gt2eZwKNpLWI3N6+uWJtKFeA3k730xMUJuhq8ekfYSrqrqHYSy9r0DBMvDYKsLRw2h
         Yj5kBqVeNIezWDzqPIAJ/CAz9NJi+CFtVnB2jLJkQIdMP9tSVoC7VJpxKrLs3bpWhw
         O8EyntvVq7OSw==
Received: by mail-qv1-f69.google.com with SMTP id cz3-20020a056214088300b00498f11a6d8aso3289061qvb.11
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 16:20:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=p9PcOId8CVnJ5ezXOu/o72E0GBfIcrDq4iBwQQHuaKo=;
        b=BX4Ap5AL940bM1ob0OGNoyq0994Z/lJwVyz/xD5nSDmyN+4Z3Panna8RhrH7eGyBDo
         pDpk7DTKKh4S4JNsMeISp7CZ8t7Lr9iQgI5I8iEAt6kkMT0DhrOtaY0OJzQ6Sq85OT5g
         R1q4n3YUz5XEtJYfUqL73pDZIlJxJh+vxQ3vIEfuG7uBjKmmmj9ksP1uFM6uTpzVA2Kx
         tpLa5fKhWYleTSo605zqBnxYaCeqpGoYOyR1dq4aq7f7FIuj+bO+MKbNTAGQtNHqMGQE
         zqH+89M9EBwBG1Zl4NyVq6f6glE3vZMWX15tP7IZ4xFiLvzZ/06WI1iYP0WFokX22qIV
         yGJQ==
X-Gm-Message-State: ACgBeo3XcM9v4ExmqP3SguRFUe8h39eV0lGm7fVeIHV/fCHdA9h66/gs
        OEq+biiUl3UKY6vhBQZcphaMsWGcZ991yr8t8alZYEWcoVMQQz2Xk3XC9xG7OFTJ12DFs+UtfXP
        lI6k7xDrpH1kyDp1YQ4uUGFmAwLpwkL0feg==
X-Received: by 2002:ac8:7f53:0:b0:343:652:ce62 with SMTP id g19-20020ac87f53000000b003430652ce62mr7914647qtk.514.1661728844936;
        Sun, 28 Aug 2022 16:20:44 -0700 (PDT)
X-Google-Smtp-Source: AA6agR74tJv3RV+dUZuWnaw5X5MlXLwVtvUBKntnVDvam+9Ib+Rc5ZH+AmU3IXbG+Y23O1S9mPCsmw==
X-Received: by 2002:ac8:7f53:0:b0:343:652:ce62 with SMTP id g19-20020ac87f53000000b003430652ce62mr7914628qtk.514.1661728844637;
        Sun, 28 Aug 2022 16:20:44 -0700 (PDT)
Received: from nyx.localdomain (097-085-172-131.biz.spectrum.com. [97.85.172.131])
        by smtp.gmail.com with ESMTPSA id u3-20020a37ab03000000b006bc68cfcdf7sm4599993qke.13.2022.08.28.16.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 16:20:44 -0700 (PDT)
Received: by nyx.localdomain (Postfix, from userid 1000)
        id 5C15E2410F8; Sun, 28 Aug 2022 16:20:43 -0700 (PDT)
Received: from nyx (localhost [127.0.0.1])
        by nyx.localdomain (Postfix) with ESMTP id 54003280934;
        Sun, 28 Aug 2022 16:20:43 -0700 (PDT)
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
In-reply-to: <20220825041327.608748-1-liuhangbin@gmail.com>
References: <20220825041327.608748-1-liuhangbin@gmail.com>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Thu, 25 Aug 2022 12:13:27 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.7.1; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <191410.1661728843.1@nyx>
Content-Transfer-Encoding: quoted-printable
Date:   Sun, 28 Aug 2022 16:20:43 -0700
Message-ID: <191411.1661728843@nyx>
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

>There are 3 issues when setting lladdr as bonding IPv6 target
>
>1. On the send side. When ns_ip6_target was set, the ipv6_dev_get_saddr()
>   will be called to get available src addr and send IPv6 neighbor solici=
t
>   message.
>
>   If the target is global address, ipv6_dev_get_saddr() will get any
>   available src address. But if the target is link local address,
>   ipv6_dev_get_saddr() will only get available address from out interace=
,

	Should this be "our interface"?

>   i.e. the corresponding bond interface.
>
>   But before bond interface up, all the address is tentative, while
>   ipv6_dev_get_saddr() will ignore tentative address. This makes we can'=
t
>   find available link local src address, then bond_ns_send() will not be
>   called and no NS message was sent. Thus no NA message received and bon=
d
>   interface will keep in down state.
>
>   Fix this by sending NS with unspecified address if there is no availab=
le
>   source address.
>
>2. On the receive side. The slave was set down before enslave to bond.
>   This makes slaves remove mcast address 33:33:00:00:00:01( The IPv6
>   maddr ff02::1 is kept even when the interface down). When bond set
>   slave up, the ipv6_mc_up() was not called due to commit c2edacf80e15
>   ("bonding / ipv6: no addrconf for slaves separately from master").
>   This makes the slave interface never add the all node mcast address
>   33:33:00:00:00:01. So there is no way to accept unsolicited NA with
>   dest ff02::1.
>
>   Fix this by adding all node mcast address 33:33:00:00:00:01 back when
>   the slave interface up.
>
>3. On the validating side. The NA message with all-nodes multicast dest
>   address should also be valid.
>
>   Also rename bond_validate_ns() to bond_validate_na().

	I'm not exactly sure which change matches which of the three
above fixes; should this be three separate patches?

>Reported-by: LiLiang <liali@redhat.com>
>Fixes: 5e1eeef69c0f ("bonding: NS target should accept link local address=
")

	Is this fixes tag correct for all the fixes?  Number 2 cites a
different commit (c2edacf80e15).  Again, should these be three separate
patches?

>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>---
> drivers/net/bonding/bond_main.c | 20 +++++++++++++++-----
> net/ipv6/addrconf.c             |  7 +++++--
> 2 files changed, 20 insertions(+), 7 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 2f4da2c13c0a..5c2febe94428 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -3167,6 +3167,9 @@ static void bond_ns_send_all(struct bonding *bond, =
struct slave *slave)
> found:
> 		if (!ipv6_dev_get_saddr(dev_net(dst->dev), dst->dev, &targets[i], 0, &=
saddr))
> 			bond_ns_send(slave, &targets[i], &saddr, tags);
>+		else
>+			bond_ns_send(slave, &targets[i], &in6addr_any, tags);
>+
> 		dst_release(dst);
> 		kfree(tags);
> 	}
>@@ -3198,12 +3201,19 @@ static bool bond_has_this_ip6(struct bonding *bon=
d, struct in6_addr *addr)
> 	return ret;
> }
> =

>-static void bond_validate_ns(struct bonding *bond, struct slave *slave,
>+static void bond_validate_na(struct bonding *bond, struct slave *slave,
> 			     struct in6_addr *saddr, struct in6_addr *daddr)
> {
> 	int i;
> =

>-	if (ipv6_addr_any(saddr) || !bond_has_this_ip6(bond, daddr)) {
>+	/* Ignore NAs that:
>+	 * 1. Source address is unspecified address.
>+	 * 2. Dest address is neither all-nodes multicast address nor
>+	 *    exist on bond interface.
>+	 */
>+	if (ipv6_addr_any(saddr) ||
>+	    (!ipv6_addr_equal(daddr, &in6addr_linklocal_allnodes) &&
>+	     !bond_has_this_ip6(bond, daddr))) {
> 		slave_dbg(bond->dev, slave->dev, "%s: sip %pI6c tip %pI6c not found\n"=
,
> 			  __func__, saddr, daddr);
> 		return;
>@@ -3246,14 +3256,14 @@ static int bond_na_rcv(const struct sk_buff *skb,=
 struct bonding *bond,
> 	 * see bond_arp_rcv().
> 	 */
> 	if (bond_is_active_slave(slave))
>-		bond_validate_ns(bond, slave, saddr, daddr);
>+		bond_validate_na(bond, slave, saddr, daddr);
> 	else if (curr_active_slave &&
> 		 time_after(slave_last_rx(bond, curr_active_slave),
> 			    curr_active_slave->last_link_up))
>-		bond_validate_ns(bond, slave, saddr, daddr);
>+		bond_validate_na(bond, slave, saddr, daddr);
> 	else if (curr_arp_slave &&
> 		 bond_time_in_interval(bond, slave_last_tx(curr_arp_slave), 1))
>-		bond_validate_ns(bond, slave, saddr, daddr);
>+		bond_validate_na(bond, slave, saddr, daddr);

	Is this logic correct?  If I'm not mistaken, there are two
receive cases:

	1- We receive a reply (Neighbor Advertisement) to our request
(Neighbor Solicitation).

	2- We receive a copy of our request (NS), which passed through
the switch and was received by another interface of the bond.

	For the ARP monitor implementation, in the second case, the
source and target IP addresses are swapped for the validation.

	Is such a swap necessary for the NS/NA monitor implementation?
I would expect this to be in the second block of the if (inside the
"else if (curr_active_slave &&" block).

	-J

> out:
> 	return RX_HANDLER_ANOTHER;
>diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>index e15f64f22fa8..77750b6327e7 100644
>--- a/net/ipv6/addrconf.c
>+++ b/net/ipv6/addrconf.c
>@@ -3557,11 +3557,14 @@ static int addrconf_notify(struct notifier_block =
*this, unsigned long event,
> 		fallthrough;
> 	case NETDEV_UP:
> 	case NETDEV_CHANGE:
>-		if (dev->flags & IFF_SLAVE)
>+		if (idev && idev->cnf.disable_ipv6)
> 			break;
> =

>-		if (idev && idev->cnf.disable_ipv6)
>+		if (dev->flags & IFF_SLAVE) {
>+			if (event =3D=3D NETDEV_UP && !IS_ERR_OR_NULL(idev))
>+				ipv6_mc_up(idev);
> 			break;
>+		}
> =

> 		if (event =3D=3D NETDEV_UP) {
> 			/* restore routes for permanent addresses */
>-- =

>2.37.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
