Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47D862D135
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 03:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbiKQCor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 21:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbiKQCoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 21:44:46 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011283FBAC
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 18:44:44 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id m14so465279pji.0
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 18:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8y7mAPAWKkrq2Hcc0NThS7AiX4ryCOd2Vsq1Ol2JLBo=;
        b=nj+iRmojuZ3Jfxz1p9uIir6fdfMfxE1CAcDuWbZ+EkwoQLThgx+eftbvtkYIyuFpE7
         /fCLCmBbMybNs/AP19QpBbI2fOeYFcLzqSPD34C5nMWRdpVJIAWr6bNKEXBXeJCP9+oD
         SAijogaaCpZip2sQn6Z7hIT1n8OEsxSF7Y9btXpO0EexXb7xSzbfOuwgIRuwLcLRRmJD
         aIreBeiWOMbJDIeUMPpRLqnvx057xUFw7Vr+bas8TDv/yYKKNQgEHNhVC/H1h7bSSZt7
         Fx3PqP5ItNX5SbZrlS4ZdfOp7Jiogbx0b7rlgqj1If+54ct3NiIMOqPx+yvnQV/dg7Ez
         ppTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8y7mAPAWKkrq2Hcc0NThS7AiX4ryCOd2Vsq1Ol2JLBo=;
        b=bTKmBMoVRlonN3rgtzbwKYxLj9JCfjUzgnEgVn+t9BXlI5bXxiHynEcJQB0GlQ1pL8
         aacBq4V2/u6PAaYMsiwTYYnZBPdcAuj2Oj7gs3kVwH6Qq7Z9Y9YA5mDhbg1KEU6ixFsl
         2IbiV17FedUeFrYrOe3jAJkTF8tD5W31GQNCMVRFy6qu7iE+vhBBuDPyDv9IgID7IgAQ
         hJbWUoNyD75Tz7x90qiRmjDYm9DrLcjU7s6lZQcyzGVvMHfReOH129laZgswwU/AHKMb
         qqnnwzjDZab8N5bq5No/qveX52DrJBOMvs9mv3x2WNBgwM8lCiB10E0RnGzSfENl6Jyb
         wbUg==
X-Gm-Message-State: ANoB5pkqCHzdwcoj2mKilnVHuk5oZyrG0cfJ6NZflRpBbIvderqDbCLn
        2swEqA9gW0sgEImkBIzY/iY=
X-Google-Smtp-Source: AA0mqf5WuOVUF1mvlJiLPd7R+AdDklCFHB49a37AYKtUQ6Z7vjIE7rr2qHDU5e84OYR8Q7kkZvoCxw==
X-Received: by 2002:a17:902:bd96:b0:181:b55a:f987 with SMTP id q22-20020a170902bd9600b00181b55af987mr805107pls.67.1668653084326;
        Wed, 16 Nov 2022 18:44:44 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id g3-20020a170902868300b00186ac812ab0sm12972921plo.83.2022.11.16.18.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 18:44:43 -0800 (PST)
Date:   Thu, 17 Nov 2022 10:44:38 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv3 net] bonding: fix ICMPv6 header handling when receiving
 IPv6 messages
Message-ID: <Y3WgFgLlRQSaguqv@Laptop-X1>
References: <20221109014018.312181-1-liuhangbin@gmail.com>
 <49594248-1fd7-23e2-1f17-9af896cd25b0@gmail.com>
 <17540.1668026368@famine>
 <CANn89i+eZwb3+JO6oKavj5yTi74vaUY-=Pu4CaUbcq==ue9NCw@mail.gmail.com>
 <19557.1668029004@famine>
 <CANn89iKW60QdMRbpyaYry4Vdfxm41ifh4qFt1azU5FCYkUJBiA@mail.gmail.com>
 <Y3SEXh0x4G7jNSi9@Laptop-X1>
 <17663.1668611774@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17663.1668611774@famine>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 07:16:14AM -0800, Jay Vosburgh wrote:
> >Hi David,
> >
> >The patch state[1] is Changes Requested, but I think Eric has no object on this
> >patch now. Should I keep waiting, or re-send the patch?
> >
> >[1] https://patchwork.kernel.org/project/netdevbpf/patch/20221109014018.312181-1-liuhangbin@gmail.com/
> 
> 	The excerpt above is confirming that using skb_header_pointer()
> is the correct implementation to use.
> 
> 	However, the patch needs to change to call skb_header_pointer()
> sooner, to insure that the IPv6 header is available.  I've copied the
> relevant part of the discussion below:
> 
> >>   	struct slave *curr_active_slave, *curr_arp_slave;
> >> -	struct icmp6hdr *hdr = icmp6_hdr(skb);
> >>   	struct in6_addr *saddr, *daddr;
> >> +	const struct icmp6hdr *hdr;
> >> +	struct icmp6hdr _hdr;
> >>     	if (skb->pkt_type == PACKET_OTHERHOST ||
> >>   	    skb->pkt_type == PACKET_LOOPBACK ||
> >> -	    hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
> >> +	    ipv6_hdr(skb)->nexthdr != NEXTHDR_ICMP)
> >
> >
> >What makes sure IPv6 header is in skb->head (linear part of the skb) ?
> 
> 	The above comment is from Eric.  I had also mentioned that this
> particular problem already existed in the code being patched.

Yes, I also saw your comments. I was thinking to fix this issue separately.
i.e. in bond_rcv_validate(). With this we can check both IPv6 header and ARP
header. e.g.

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2c6356232668..ae4c30a25b76 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3278,8 +3278,10 @@ int bond_rcv_validate(const struct sk_buff *skb, struct bonding *bond,
 {
 #if IS_ENABLED(CONFIG_IPV6)
 	bool is_ipv6 = skb->protocol == __cpu_to_be16(ETH_P_IPV6);
+	struct ipv6hdr ip6_hdr;
 #endif
 	bool is_arp = skb->protocol == __cpu_to_be16(ETH_P_ARP);
+	struct arphdr arp_hdr;
 
 	slave_dbg(bond->dev, slave->dev, "%s: skb->dev %s\n",
 		  __func__, skb->dev->name);
@@ -3293,10 +3295,10 @@ int bond_rcv_validate(const struct sk_buff *skb, struct bonding *bond,
 		    !slave_do_arp_validate_only(bond))
 			slave->last_rx = jiffies;
 		return RX_HANDLER_ANOTHER;
-	} else if (is_arp) {
+	} else if (is_arp && skb_header_pointer(skb, 0, sizeof(arp_hdr), &arp_hdr)) {
 		return bond_arp_rcv(skb, bond, slave);
 #if IS_ENABLED(CONFIG_IPV6)
-	} else if (is_ipv6) {
+	} else if (is_ipv6 && skb_header_pointer(skb, 0, sizeof(ip6_hdr), &ip6_hdr)) {
 		return bond_na_rcv(skb, bond, slave);
 #endif
 	} else {

What do you think?

Thanks
Hangbin
