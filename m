Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6E836D162F
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 06:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCaECs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 00:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCaECq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 00:02:46 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72386EC76
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 21:02:45 -0700 (PDT)
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B5BFE3F20F
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 04:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1680235363;
        bh=4yyPvCUsMNZQ1ROrWpH6d5JSFBxxAuRO1CE8CGiYGw8=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=nhlBmRFR3S8OTbGYhDO68XeZCIXbXZhpjlFH/ggvM0nf5DMMFdTwgHqSdFrLjFg1l
         NFhyWLvmqP6NUIwQ3/1k76koR1S98Mw4C1TCnLjo87cxJHLYdLKSYTZfH1niPJl/DZ
         h9hJ5uphwtgwkpnputjFoAafamfIw21289RtCH5o7jLBOqMLBUz0sL3Px8GCdpiHOg
         q72bGULoiT5pP0nGIrOS9vuXc3em15862qWUtSYwUDy9yz+VxDBjaorL3nnbXJJlr2
         QUJHj7w8eYmBUkXIzBqXnsAsicCVwbyYte0xZxd4cTUmAH98yXxBj5GR/0MtRbj9+q
         QnhG8YTnCzQIg==
Received: by mail-pl1-f199.google.com with SMTP id u18-20020a170902e5d200b001a1d70ea3b6so12186372plf.6
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 21:02:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680235362;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4yyPvCUsMNZQ1ROrWpH6d5JSFBxxAuRO1CE8CGiYGw8=;
        b=XY6kvtUDtwSdC3Clq7fnI2tuMOYzXpxFdajr0cvgD3ewbmh+rtQ3j41Wbu1tSt9fyL
         2XNtvlWTQvevEMEBlnQLvJ+PlDXE2+mAvhyayPGjVZrTZ4TOcS60Dbm4OSL6ee/dtIGY
         LQtWL9q+Uh2OOQUPFvjlUKjXhIKsT7qf5XfRHB7eFwetROhphGPi45Y0Fp3PZGFWDOcX
         7BBLAvLPq9HNblUgQSstqmWTukPuIdVrHyNpBrcTxDrLAitnh0a6KwNYqzSmeo/jzlG2
         fI3JCSLEC4nUnMGDh5PGtt5xUUTThsj8YlaUsvJQdoZ9MFQ5qjAii6Nvgn0rni3xze4z
         v0hg==
X-Gm-Message-State: AAQBX9dSeadyBU7YLl3hUzaB/gvNa77Q5L0VhLFgO5gh+Te/LQR04JcM
        xx7g8+74n1py2Nj3NLP5WPuhO01ci/QtzdYljvytF/gTcfk5QNpUVe3js2pZmWTrvr+jUIUSJzT
        YueWMdP8OaXpOAJZhqgCwQwLca3QDGSzAUw==
X-Received: by 2002:a17:902:d411:b0:1a2:85f0:e73f with SMTP id b17-20020a170902d41100b001a285f0e73fmr4913902ple.35.1680235362432;
        Thu, 30 Mar 2023 21:02:42 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZJdc/e2SWhZtwXsL8uRI8bhxg9LPyw2+jT22mlyNU7+WR0yAOAA00KMPL9Rew4xNm0Db3J8w==
X-Received: by 2002:a17:902:d411:b0:1a2:85f0:e73f with SMTP id b17-20020a170902d41100b001a285f0e73fmr4913888ple.35.1680235362146;
        Thu, 30 Mar 2023 21:02:42 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id t16-20020a170902b21000b0019a997bca5csm473084plr.121.2023.03.30.21.02.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Mar 2023 21:02:41 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 6457060080; Thu, 30 Mar 2023 21:02:41 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 5CF999FB79;
        Thu, 30 Mar 2023 21:02:41 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Liang Li <liali@redhat.com>
Subject: Re: [PATCH net 1/3] bonding: fix ns validation on backup slaves
In-reply-to: <20230329101859.3458449-2-liuhangbin@gmail.com>
References: <20230329101859.3458449-1-liuhangbin@gmail.com> <20230329101859.3458449-2-liuhangbin@gmail.com>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Wed, 29 Mar 2023 18:18:57 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21416.1680235361.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 30 Mar 2023 21:02:41 -0700
Message-ID: <21417.1680235361@famine>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>When arp_validate is set to 2, 3, or 6, validation is performed for
>backup slaves as well. As stated in the bond documentation, validation
>involves checking the broadcast ARP request sent out via the active
>slave. This helps determine which slaves are more likely to function in
>the event of an active slave failure.
>
>However, when the target is an IPv6 address, the NS message sent from
>the active interface is not checked on backup slaves. Additionally,
>based on the bond_arp_rcv() rule b, we must reverse the saddr and daddr
>when checking the NS message.
>
>Note that when checking the NS message, the destination address is a
>multicast address. Therefore, we must convert the target address to
>solicited multicast in the bond_get_targets_ip6() function.
>
>Prior to the fix, the backup slaves had a mii status of "down", but
>after the fix, all of the slaves' mii status was updated to "UP".
>
>Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

>---
> drivers/net/bonding/bond_main.c | 5 +++--
> include/net/bonding.h           | 8 ++++++--
> 2 files changed, 9 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 236e5219c811..8cc9a74789b7 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -3269,7 +3269,8 @@ static int bond_na_rcv(const struct sk_buff *skb, s=
truct bonding *bond,
> =

> 	combined =3D skb_header_pointer(skb, 0, sizeof(_combined), &_combined);
> 	if (!combined || combined->ip6.nexthdr !=3D NEXTHDR_ICMP ||
>-	    combined->icmp6.icmp6_type !=3D NDISC_NEIGHBOUR_ADVERTISEMENT)
>+	    (combined->icmp6.icmp6_type !=3D NDISC_NEIGHBOUR_SOLICITATION &&
>+	     combined->icmp6.icmp6_type !=3D NDISC_NEIGHBOUR_ADVERTISEMENT))
> 		goto out;
> =

> 	saddr =3D &combined->ip6.saddr;
>@@ -3291,7 +3292,7 @@ static int bond_na_rcv(const struct sk_buff *skb, s=
truct bonding *bond,
> 	else if (curr_active_slave &&
> 		 time_after(slave_last_rx(bond, curr_active_slave),
> 			    curr_active_slave->last_link_up))
>-		bond_validate_na(bond, slave, saddr, daddr);
>+		bond_validate_na(bond, slave, daddr, saddr);
> 	else if (curr_arp_slave &&
> 		 bond_time_in_interval(bond, slave_last_tx(curr_arp_slave), 1))
> 		bond_validate_na(bond, slave, saddr, daddr);
>diff --git a/include/net/bonding.h b/include/net/bonding.h
>index ea36ab7f9e72..c3843239517d 100644
>--- a/include/net/bonding.h
>+++ b/include/net/bonding.h
>@@ -761,13 +761,17 @@ static inline int bond_get_targets_ip(__be32 *targe=
ts, __be32 ip)
> #if IS_ENABLED(CONFIG_IPV6)
> static inline int bond_get_targets_ip6(struct in6_addr *targets, struct =
in6_addr *ip)
> {
>+	struct in6_addr mcaddr;
> 	int i;
> =

>-	for (i =3D 0; i < BOND_MAX_NS_TARGETS; i++)
>-		if (ipv6_addr_equal(&targets[i], ip))
>+	for (i =3D 0; i < BOND_MAX_NS_TARGETS; i++) {
>+		addrconf_addr_solict_mult(&targets[i], &mcaddr);
>+		if ((ipv6_addr_equal(&targets[i], ip)) ||
>+		    (ipv6_addr_equal(&mcaddr, ip)))
> 			return i;
> 		else if (ipv6_addr_any(&targets[i]))
> 			break;
>+	}
> =

> 	return -1;
> }
>-- =

>2.38.1
>
