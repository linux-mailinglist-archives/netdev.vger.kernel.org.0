Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26EEF5A468F
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiH2J4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiH2J4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:56:18 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362D04D83D
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 02:56:17 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u9-20020a17090a1f0900b001fde6477464so988661pja.4
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 02:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=4puvxp4NasGiCkk6TT4/GuLNqUhsCyJE+FTPyVrKYIY=;
        b=PbLtLG5Y28pMVZX3nQACKcRK5guzs7XpGBkAXLaXv0P+D/9EnsUSnxKDygusj6c7Ld
         mwB2CrSqL7lACMu5nEhkWAdzZu1n3gN/3SwNOoqYlAVjWIY32j0XTxXeNUzAMNnofHGK
         gECTKuzzwub+rIOomHWJKhDx+fWEpZifDaCrWBiNcW5spJYc4DBkYhBwRyD9jDk9cbph
         oGkM4pGh6XgtWKmw+7zciw+EhAMDIs6F5wrh5GBighR1EYXvZLp9t0dc0OmAzOPN3uDL
         LNhyfqcM8RIXA4PAq/36IUV80hqvyqcOQGeEgkG0JStrUK5yA7TjkI9RKz/C7VLSgSHS
         iUXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=4puvxp4NasGiCkk6TT4/GuLNqUhsCyJE+FTPyVrKYIY=;
        b=gLUKuA6HBsskXR6G4fZR644WsS5H2zoGdzQcj2gabyRG7RIdeSndlJYRUhtB92qDGr
         gHuthql8iHpWsM12IpGZDkgir5NLSdUqZnHqDxez88U0DyOrrM3uyHCduZqgru9IQQJl
         tn8Pljbgn9GGOCrpT9KH1nSTso1awF7RLbS1Mi0MaReur10KoAlAtVMbkZPhDy9L6P/8
         MoUBgsoUmVSayFPYWGMpDe045vkd8Tbh5k70lKSvUuVeZCipbcRDtLXd3YTmejM2E1+E
         XRmF1QLo0tRdlYaaMlQehzKaBGyGcaoiOS/uTIDiWl/kfqDHxjH9BigN5Zd6D3LPECFY
         GxVw==
X-Gm-Message-State: ACgBeo3phN/ku7LtO32z/C73RISjPb97UJc7Gx4RI4NByEqP6C60m4Ym
        L9qLC1PUCQ2Ir9p1B6y1uds=
X-Google-Smtp-Source: AA6agR74TqIjvzFpEAgbpU6PqZni8vq017omLdjc1MmmumKPg2CiifigiQ9tWpWdkF3WJvvW10iTjw==
X-Received: by 2002:a17:902:f790:b0:170:d401:66d2 with SMTP id q16-20020a170902f79000b00170d40166d2mr15734842pln.124.1661766976712;
        Mon, 29 Aug 2022 02:56:16 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g6-20020aa79f06000000b0052dce4edceesm6808940pfr.169.2022.08.29.02.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 02:56:15 -0700 (PDT)
Date:   Mon, 29 Aug 2022 17:56:06 +0800
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
Message-ID: <YwyNNsaD8+QYd4Ot@Laptop-X1>
References: <20220825041327.608748-1-liuhangbin@gmail.com>
 <191411.1661728843@nyx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <191411.1661728843@nyx>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 28, 2022 at 04:20:43PM -0700, Jay Vosburgh wrote:
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> >There are 3 issues when setting lladdr as bonding IPv6 target
> >
> >1. On the send side. When ns_ip6_target was set, the ipv6_dev_get_saddr()
> >   will be called to get available src addr and send IPv6 neighbor solicit
> >   message.
> >
> >   If the target is global address, ipv6_dev_get_saddr() will get any
> >   available src address. But if the target is link local address,
> >   ipv6_dev_get_saddr() will only get available address from out interace,
> 
> 	Should this be "our interface"?

Ah, yes.

> >
> >2. On the receive side. The slave was set down before enslave to bond.
> >   This makes slaves remove mcast address 33:33:00:00:00:01( The IPv6
> >   maddr ff02::1 is kept even when the interface down). When bond set
> >   slave up, the ipv6_mc_up() was not called due to commit c2edacf80e15
> >   ("bonding / ipv6: no addrconf for slaves separately from master").
> >   This makes the slave interface never add the all node mcast address
> >   33:33:00:00:00:01. So there is no way to accept unsolicited NA with
> >   dest ff02::1.
> >
> >   Fix this by adding all node mcast address 33:33:00:00:00:01 back when
> >   the slave interface up.
> >
> >3. On the validating side. The NA message with all-nodes multicast dest
> >   address should also be valid.
> >
> >   Also rename bond_validate_ns() to bond_validate_na().
> 
> 	I'm not exactly sure which change matches which of the three
> above fixes; should this be three separate patches?

The 1st case(send side) is fixed in function bond_ns_send_all().
The 2nd case(receive side) is fixed in addrconf_notify().
The 3rd case(validating side) is fixed in bond_validate_ns/na()

> 
> >Reported-by: LiLiang <liali@redhat.com>
> >Fixes: 5e1eeef69c0f ("bonding: NS target should accept link local address")
> 
> 	Is this fixes tag correct for all the fixes?  Number 2 cites a
> different commit (c2edacf80e15). 

Before we support link local target for bonding. Commit (c2edacf80e15) works
as bond device could up and add the all node multicast correctly.

After we adding the link local target for bonding. The bond could not up
and not able to add node multicast address. So I think the fixes tag should
not be commit (c2edacf80e15).

> Again, should these be three separate patches?

I thought these 3 parts are all to fix lladdr target. So I put them together.
If you think it's easier to review. I can separate the patches of course.

> 
> >@@ -3246,14 +3256,14 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
> > 	 * see bond_arp_rcv().
> > 	 */
> > 	if (bond_is_active_slave(slave))
> >-		bond_validate_ns(bond, slave, saddr, daddr);
> >+		bond_validate_na(bond, slave, saddr, daddr);
> > 	else if (curr_active_slave &&
> > 		 time_after(slave_last_rx(bond, curr_active_slave),
> > 			    curr_active_slave->last_link_up))
> >-		bond_validate_ns(bond, slave, saddr, daddr);
> >+		bond_validate_na(bond, slave, saddr, daddr);
> > 	else if (curr_arp_slave &&
> > 		 bond_time_in_interval(bond, slave_last_tx(curr_arp_slave), 1))
> >-		bond_validate_ns(bond, slave, saddr, daddr);
> >+		bond_validate_na(bond, slave, saddr, daddr);
> 
> 	Is this logic correct?  If I'm not mistaken, there are two
> receive cases:
> 
> 	1- We receive a reply (Neighbor Advertisement) to our request
> (Neighbor Solicitation).
> 
> 	2- We receive a copy of our request (NS), which passed through
> the switch and was received by another interface of the bond.

No, we don't have this case for IPv6 because I did a check in

static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
                       struct slave *slave)
{
	[...]

        if (skb->pkt_type == PACKET_OTHERHOST ||
            skb->pkt_type == PACKET_LOOPBACK ||
            hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
                goto out;

Here we will ignore none NA messages.

Thanks
Hangbin
> 
> 	For the ARP monitor implementation, in the second case, the
> source and target IP addresses are swapped for the validation.
> 
> 	Is such a swap necessary for the NS/NA monitor implementation?
> I would expect this to be in the second block of the if (inside the
> "else if (curr_active_slave &&" block).
> 
> 	-J
> 
> > out:
> > 	return RX_HANDLER_ANOTHER;
> >diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> >index e15f64f22fa8..77750b6327e7 100644
> >--- a/net/ipv6/addrconf.c
> >+++ b/net/ipv6/addrconf.c
> >@@ -3557,11 +3557,14 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
> > 		fallthrough;
> > 	case NETDEV_UP:
> > 	case NETDEV_CHANGE:
> >-		if (dev->flags & IFF_SLAVE)
> >+		if (idev && idev->cnf.disable_ipv6)
> > 			break;
> > 
> >-		if (idev && idev->cnf.disable_ipv6)
> >+		if (dev->flags & IFF_SLAVE) {
> >+			if (event == NETDEV_UP && !IS_ERR_OR_NULL(idev))
> >+				ipv6_mc_up(idev);
> > 			break;
> >+		}
> > 
> > 		if (event == NETDEV_UP) {
> > 			/* restore routes for permanent addresses */
> >-- 
> >2.37.1
> >
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
