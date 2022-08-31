Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002765A7885
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 10:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiHaIG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 04:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiHaIGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 04:06:54 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68BC13D15
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 01:06:52 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c2so13447500plo.3
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 01:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=j2M9TNgE6hl05c1UgnQ/eQrkf9ROe5l/EvG2lHKdCmc=;
        b=HcnOP5nCyOJPoInSzUQEKLEchWY4dscQ718e2u+TvJfZMZmfFB/AOa84Q3xBGXZq5C
         L5Pi8/3w75khc+8cvbAGBvZbZ/FnfBFsFbi6phhLD4hAOr31E6AVS4VhqYEcGOqB+kIO
         AFQ1PnkF3IjdAZBY715iHU/851p+cq+uIclAyGkAkFlVdKXh6k+SECh2aQxqy+1LCDQ7
         EDkjptdPItfEtUUYQGRGuAy1BwYz+pIlJG9TSrukknHZ2ox+2sAnH+9AX3qy9U2tU3hn
         5BspCcWP7xGRx2h73ur6lSnJS33t3HAY9VYShfj5Gi1S8dpOevarUtLOy9G0awcfruaG
         ecSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=j2M9TNgE6hl05c1UgnQ/eQrkf9ROe5l/EvG2lHKdCmc=;
        b=Nrh/gDPgPaB0vUu544WV9OSDYg20dzsLizIQuIXmrj+OOPHbb+GlraEsDoUL4selvb
         fj9enhSPmJNbZxvpPLH6LNTsbEoNEmc6EImEC0pu7c11w/FFZHUyhfU2vDzdAchsbCXh
         tHPaYPf8dDQenWnukAYlZsoUJFG3iIeTZQ7pawEfE19MOmG5sEUOxaMT5h7IN+C/Rq81
         r2HiBW+RU0mSPjfbuh/4Q3w0lXy2YsnWDPnoidSUfeM5OjVxNZXm9bwDO7MlAaT1EaTl
         dkpkFxPkkVAS7rOjmZDwHFTeDmBx79d33n/3CklbBN2G29WBeb3/JNww1fXgCMwtINbB
         KBIw==
X-Gm-Message-State: ACgBeo0rrnM+kOBIdPCzK5j/Eje5ZEiKNE223B1h+MWutUybkbHkltv5
        P13teea1DohK9Ri32aDXQmE=
X-Google-Smtp-Source: AA6agR4oNUr0ltRLLocQRUaE6MHS/SGhBhUlf6uG7BfrtgUSEEWMc9/O5Zw3c/V02I5NZqLNn6M0Gw==
X-Received: by 2002:a17:90a:4d82:b0:1fb:6497:e071 with SMTP id m2-20020a17090a4d8200b001fb6497e071mr2057582pjh.166.1661933212229;
        Wed, 31 Aug 2022 01:06:52 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b4-20020a17090a7ac400b001fd9c63e56bsm763158pjl.32.2022.08.31.01.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 01:06:51 -0700 (PDT)
Date:   Wed, 31 Aug 2022 16:06:44 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, LiLiang <liali@redhat.com>
Subject: Re: [PATCH net] bonding: fix lladdr finding and confirmation
Message-ID: <Yw8WlFEJ4ZlF3VIt@Laptop-X1>
References: <20220825041327.608748-1-liuhangbin@gmail.com>
 <191411.1661728843@nyx>
 <YwyNNsaD8+QYd4Ot@Laptop-X1>
 <194689.1661914419@nyx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <194689.1661914419@nyx>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 07:53:39PM -0700, Jay Vosburgh wrote:
> >> >@@ -3246,14 +3256,14 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
> >> > 	 * see bond_arp_rcv().
> >> > 	 */
> >> > 	if (bond_is_active_slave(slave))
> >> >-		bond_validate_ns(bond, slave, saddr, daddr);
> >> >+		bond_validate_na(bond, slave, saddr, daddr);
> >> > 	else if (curr_active_slave &&
> >> > 		 time_after(slave_last_rx(bond, curr_active_slave),
> >> > 			    curr_active_slave->last_link_up))
> >> >-		bond_validate_ns(bond, slave, saddr, daddr);
> >> >+		bond_validate_na(bond, slave, saddr, daddr);
> >> > 	else if (curr_arp_slave &&
> >> > 		 bond_time_in_interval(bond, slave_last_tx(curr_arp_slave), 1))
> >> >-		bond_validate_ns(bond, slave, saddr, daddr);
> >> >+		bond_validate_na(bond, slave, saddr, daddr);
> >> 
> >> 	Is this logic correct?  If I'm not mistaken, there are two
> >> receive cases:
> >> 
> >> 	1- We receive a reply (Neighbor Advertisement) to our request
> >> (Neighbor Solicitation).
> >> 
> >> 	2- We receive a copy of our request (NS), which passed through
> >> the switch and was received by another interface of the bond.
> >
> >No, we don't have this case for IPv6 because I did a check in
> >
> >static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
> >                       struct slave *slave)
> >{
> >	[...]
> >
> >        if (skb->pkt_type == PACKET_OTHERHOST ||
> >            skb->pkt_type == PACKET_LOOPBACK ||
> >            hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
> >                goto out;
> >
> >Here we will ignore none NA messages.
> 
> 	Is there a reason to implement this differently from the ARP
> monitor with regard to the "passed request through switch to backup
> interface" logic?  Are the backup interfaces then always down until the
> active interface fails (in other words, what do they receive)?

Hmm... There do have some differences between the ARP monitor and NS/NA monitor.

For ARP monitor
"""
	For an active slave, the validation checks ARP replies to confirm
	that they were generated by an arp_ip_target.  Since backup slaves
	do not typically receive these replies, the validation performed
	for backup slaves is on the broadcast ARP request sent out via the
	active slave.  
"""

But IPv6 NS message is a little different. For our solicited NS message, the
dest mac is set to correspond solicited-node multicast address instead of
broadcast address. So the backup slave will not receive the NS message that
send from active slave.

When we send unsolicited NS with in6addr_any. The target will reply NA with
dest addr ff02::1. This is the only time the backup salve could receive NA
message.

If you think this is OK, I can update the comments.

Thanks
Hangbin

> 
> 	Assuming that there is a good reason, the commentary in
> bond_na_rcv() is misleading, as it says to "see bond_arp_rcv()" for the
> logic.  Again, assuming there's a good reason for it, can you amend this
> comment to mention that the "Note: for (b)" in the bond_arp_rcv()
> commentary does not apply to bond_na_rcv() for whatever the good reason
> is?
> 
> 	-J
> 
> >Thanks
> >Hangbin
> >> 
> >> 	For the ARP monitor implementation, in the second case, the
> >> source and target IP addresses are swapped for the validation.
> >> 
> >> 	Is such a swap necessary for the NS/NA monitor implementation?
> >> I would expect this to be in the second block of the if (inside the
> >> "else if (curr_active_slave &&" block).
> >> 
> >> 	-J
> >> 
> >> > out:
> >> > 	return RX_HANDLER_ANOTHER;
> >> >diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> >> >index e15f64f22fa8..77750b6327e7 100644
> >> >--- a/net/ipv6/addrconf.c
> >> >+++ b/net/ipv6/addrconf.c
> >> >@@ -3557,11 +3557,14 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
> >> > 		fallthrough;
> >> > 	case NETDEV_UP:
> >> > 	case NETDEV_CHANGE:
> >> >-		if (dev->flags & IFF_SLAVE)
> >> >+		if (idev && idev->cnf.disable_ipv6)
> >> > 			break;
> >> > 
> >> >-		if (idev && idev->cnf.disable_ipv6)
> >> >+		if (dev->flags & IFF_SLAVE) {
> >> >+			if (event == NETDEV_UP && !IS_ERR_OR_NULL(idev))
> >> >+				ipv6_mc_up(idev);
> >> > 			break;
> >> >+		}
> >> > 
> >> > 		if (event == NETDEV_UP) {
> >> > 			/* restore routes for permanent addresses */
> >> >-- 
> >> >2.37.1
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
