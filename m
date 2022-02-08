Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101EC4AD287
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 08:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348621AbiBHHwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 02:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235478AbiBHHwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 02:52:04 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8960AC0401EF;
        Mon,  7 Feb 2022 23:52:03 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id B729F320209C;
        Tue,  8 Feb 2022 02:52:00 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 08 Feb 2022 02:52:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=CpObZswqDowwOx77NiQV1IhLqQ3/YYHk/8qYQOtLW
        SY=; b=FOhwphY1RCs7OL4P897HcCxindLpk/o2q7oZP/nUuZIdlqj4taWeHOXpW
        OSOwxqOKraovMGq5hEk+qm69V32Dkz5sRKKaXJeymsVg4Ju0qCA+UHSzGOktWPpR
        Ikj2/Dp/FLOZhx7u9cMPV39WrEogqhJNAuNUV36T42qpCoQDE6ijIj/eNRcGbebd
        aBW+6urYzFX8Uz7gIPZZ9Qxj5ZwHoM2AuvIXAbhdEhm9j4abUWFJ0r5emhXRYEiY
        s+esRTMZJiWtYCebsppH1DJnKnX6iyM529J5PcL1cKMb/Qe3ypTBLPFnIE5PVeTY
        0fyuuZyXd4Nfwl3ufIPngiGLwO52g==
X-ME-Sender: <xms:HyECYsWZR81C0dg1htAOeO-3_F3cBwDWYzSrJ55R0MaBxbAOa5Edqg>
    <xme:HyECYgmTNZtkMEQSbzB2Ncyrji-4UMnqHjT73S5SAur3lMpwAMSRu4i2LBwcbYuF0
    YEuiVWIAXvJQQA>
X-ME-Received: <xmr:HyECYgYJlol44EXstsWZt08KUjjbOyXltuXD65Ki8hNJms8kp2X422e93qtHW-RdNmi0G5ozRkbrWQgaGDXdqcW9HwRS7A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheeigdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdffveekfeeiieeuieetudefkeevkeeuhfeuieduudetkeegleefvdegheej
    hefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:HyECYrWnaCvHF8AuDMo5n7CKsw3pXwt-VAFOiAU2UYcD1zamSsm2ew>
    <xmx:HyECYmnKW09JYpyWy6EY7LXOwCivXZOwI6ym6IEqyaPK8VIMPWjnag>
    <xmx:HyECYgchomkp4Zm2fXItMi0dc9dOe9Nb2nasnen3XB5UbGLxnGgbpQ>
    <xmx:ICECYtuaepj1iEDr9AiPGkvccAKsR3jDCx5AuW7Poo3JE20HaruJ4Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Feb 2022 02:51:58 -0500 (EST)
Date:   Tue, 8 Feb 2022 09:51:54 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     "wanghai (M)" <wanghai38@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, edumazet@google.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] net: ipv4: The sent udp broadcast message may be converted
 to an arp request message
Message-ID: <YgIhGhh75mR5uLaS@shredder>
References: <55a04a8f-56f3-f73c-2aea-2195923f09d1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <55a04a8f-56f3-f73c-2aea-2195923f09d1@huawei.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 10:09:49PM +0800, wanghai (M) wrote:
> Hello,
> 
> I found a bug, but I don't know how to fix it. Anyone have some good ideas?
> 
> This bug will cause udp broadcast messages not to be sent, but instead send
> non-expected arp request messages.
> 
> Deleting the ip while sending udp broadcast messages and then configuring
> the ip again will probably trigger the bug.
> 
> The following is the timing diagram of the bug, cpu0 sends a broadcast
> message and cpu1 deletes the routing table at the appropriate time.
> 
> cpu0                                        cpu1
> send()
>   udp_sendmsg()
>     ip_route_output_flow()
>     |  fib_lookup()
>     udp_send_skb()
>       ip_send_skb()
>         ip_finish_output2()
> 
>                                             ifconfig eth0:2 down
>                                               fib_del_ifaddr
>                                                 fib_table_delete // delete
> fib table
> 
>           ip_neigh_for_gw()
>           |  ip_neigh_gw4()
>           |    __ipv4_neigh_lookup_noref()
>           |    __neigh_create()
>           |      tbl->constructor(n) --> arp_constructor()
>           |        neigh->type = inet_addr_type_dev_table(); // no route,
> neigh->type = RTN_UNICAST
>           neigh_output() // unicast, send an arp request and create an
> exception arp entry
> 
> After the above operation, an abnormal arp entry will be generated. If
> the ip is configured again(ifconfig eth0:2 12.0.208.0), the abnormal arp
> entry will still exist, and the udp broadcast message will be converted
> to an arp request message when it is sent.

Can you try the below? Not really happy with it, but don't have a better
idea at the moment. It seemed better to handle it from the control path
than augmenting the data path with more checks

diff --git a/include/net/arp.h b/include/net/arp.h
index 031374ac2f22..9e6a1961b64c 100644
--- a/include/net/arp.h
+++ b/include/net/arp.h
@@ -64,6 +64,7 @@ void arp_send(int type, int ptype, __be32 dest_ip,
 	      const unsigned char *dest_hw,
 	      const unsigned char *src_hw, const unsigned char *th);
 int arp_mc_map(__be32 addr, u8 *haddr, struct net_device *dev, int dir);
+int arp_invalidate(struct net_device *dev, __be32 ip);
 void arp_ifdown(struct net_device *dev);
 
 struct sk_buff *arp_create(int type, int ptype, __be32 dest_ip,
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 4db0325f6e1a..b81665ce2b57 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1116,7 +1116,7 @@ static int arp_req_get(struct arpreq *r, struct net_device *dev)
 	return err;
 }
 
-static int arp_invalidate(struct net_device *dev, __be32 ip)
+int arp_invalidate(struct net_device *dev, __be32 ip)
 {
 	struct neighbour *neigh = neigh_lookup(&arp_tbl, &ip, dev);
 	int err = -ENXIO;
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 4d61ddd8a0ec..2d7085232cb5 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1112,9 +1112,11 @@ void fib_add_ifaddr(struct in_ifaddr *ifa)
 		return;
 
 	/* Add broadcast address, if it is explicitly assigned. */
-	if (ifa->ifa_broadcast && ifa->ifa_broadcast != htonl(0xFFFFFFFF))
+	if (ifa->ifa_broadcast && ifa->ifa_broadcast != htonl(0xFFFFFFFF)) {
 		fib_magic(RTM_NEWROUTE, RTN_BROADCAST, ifa->ifa_broadcast, 32,
 			  prim, 0);
+		arp_invalidate(dev, ifa->ifa_broadcast);
+	}
 
 	if (!ipv4_is_zeronet(prefix) && !(ifa->ifa_flags & IFA_F_SECONDARY) &&
 	    (prefix != addr || ifa->ifa_prefixlen < 32)) {
@@ -1128,6 +1130,7 @@ void fib_add_ifaddr(struct in_ifaddr *ifa)
 		if (ifa->ifa_prefixlen < 31) {
 			fib_magic(RTM_NEWROUTE, RTN_BROADCAST, prefix | ~mask,
 				  32, prim, 0);
+			arp_invalidate(dev, prefix | ~mask);
 		}
 	}
 }
