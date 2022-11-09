Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3ABF6234B7
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 21:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiKIUjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 15:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiKIUjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 15:39:36 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA1E13E14
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 12:39:34 -0800 (PST)
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 6FD07423E1
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 20:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1668026372;
        bh=Ff195CcAAagNX0m92EaNVCYbn7Hgh7WUt9/mtQ9NuM0=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=VuWwrVJkd1cjujTAa03mMsth7Skkq+EtFSzgnccnQ5F4sV+fWctuLxqk2Gd5nsVBW
         itcUFDGsc/F/Q1+rpeHh55osQkZM4hrGPmMhRCUoD+zeJ58S+L3MusjmndvfPldNvD
         peW4328eeG3VwIh4A6FJb3fkdQO8ZpIzhhduwb8ZG2rjwj9Om916XGkn7FH1rFCyVa
         0+mUxK/mt1wOJ8TiPrPPP7d31BUv0XK10DqYmEFg33zHZj5gLvTjO/VugD+B3LDfqt
         9e/fEcp6XSLaCWfKqF4ooRLNjcLPaHfIRbDZDV0Hrof+Xpe1IPVQUhkjVbswsMT5Ae
         niKPC75kXiQSw==
Received: by mail-pg1-f197.google.com with SMTP id s16-20020a632c10000000b0047084b16f23so4036521pgs.7
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 12:39:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ff195CcAAagNX0m92EaNVCYbn7Hgh7WUt9/mtQ9NuM0=;
        b=H/TOBiDN3B91fiS0Vrs5wLIs/g/8ElS6q6tYIYs5xXTIauBQQ+M9lgsEoankx+Lv1w
         e/ioZRT5kPCxRoWFBTQKuwPkMj1BdASs6ECaoH6DcJRJ3KXx7zM3STPjUs+54RfptOZU
         ihs/GWZy883YdCCjHPlkPK3N1OHrlDG8cgBcUKUVkB4kdgbrppXwaPa09ZpcsGhRbC1A
         VDuv2C7oB4GUnMHxA0OBxfTD6bvNxUym7nb+dDuqTeWP2pbYP18zAqARBg2gQ3iGWlxp
         72eTDo0DfBBmNPwNMxz4Zp2ohOEOOvXxd461/2CZfNddzxOhPJSZiaD554Mwsk7ZJtm7
         9t6A==
X-Gm-Message-State: ACrzQf0SUk9k5qMSpTfwPNiyBTqNVPO9WADv9XqDBNiIGFqBZKveYih7
        Le8RD4bTwlKEIrgLHJzQ2SAqACq1JYfg1bsWvhWbUSuAffUoWzY+gP3U8bP0D58TJpu4/GfKw4c
        zDvHxEl/CMgJSrk3Puu7pJifY/+zCh/TsBQ==
X-Received: by 2002:a17:902:d409:b0:186:af8d:4029 with SMTP id b9-20020a170902d40900b00186af8d4029mr61234574ple.78.1668026371105;
        Wed, 09 Nov 2022 12:39:31 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4JXAWra/tVZcXAw3AmKxWcBRN2xk/R4h2tcde8pq4PUjEldJ6J/h9WvoNX4EQ5ceVLiSpR3w==
X-Received: by 2002:a17:902:d409:b0:186:af8d:4029 with SMTP id b9-20020a170902d40900b00186af8d4029mr61234563ple.78.1668026370825;
        Wed, 09 Nov 2022 12:39:30 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id n9-20020a17090a394900b0021282014066sm1645118pjf.9.2022.11.09.12.39.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Nov 2022 12:39:29 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 0CEAD5FEAC; Wed,  9 Nov 2022 12:39:29 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 06CDA9F890;
        Wed,  9 Nov 2022 12:39:29 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        edumazet@google.com, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv3 net] bonding: fix ICMPv6 header handling when receiving IPv6 messages
In-reply-to: <49594248-1fd7-23e2-1f17-9af896cd25b0@gmail.com>
References: <20221109014018.312181-1-liuhangbin@gmail.com> <49594248-1fd7-23e2-1f17-9af896cd25b0@gmail.com>
Comments: In-reply-to Eric Dumazet <eric.dumazet@gmail.com>
   message dated "Wed, 09 Nov 2022 12:17:10 -0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17539.1668026368.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 09 Nov 2022 12:39:28 -0800
Message-ID: <17540.1668026368@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:

>
>
>On 11/8/22 17:40, Hangbin Liu wrote:
>> Currently, we get icmp6hdr via function icmp6_hdr(), which needs the sk=
b
>> transport header to be set first. But there is no rule to ask driver se=
t
>> transport header before netif_receive_skb() and bond_handle_frame(). So
>> we will not able to get correct icmp6hdr on some drivers.
>>
>> Fix this by checking the skb length manually and getting icmp6 header b=
ased
>> on the IPv6 header offset.
>>
>> Reported-by: Liang Li <liali@redhat.com>
>> Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
>> Acked-by: Jonathan Toppins <jtoppins@redhat.com>
>> Reviewed-by: David Ahern <dsahern@kernel.org>
>> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>> ---
>> v3: fix _hdr parameter warning reported by kernel test robot
>> v2: use skb_header_pointer() to get icmp6hdr as Jay suggested.
>> ---
>>   drivers/net/bonding/bond_main.c | 9 +++++++--
>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond=
_main.c
>> index e84c49bf4d0c..2c6356232668 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -3231,12 +3231,17 @@ static int bond_na_rcv(const struct sk_buff *sk=
b, struct bonding *bond,
>>   		       struct slave *slave)
>>   {
>>   	struct slave *curr_active_slave, *curr_arp_slave;
>> -	struct icmp6hdr *hdr =3D icmp6_hdr(skb);
>>   	struct in6_addr *saddr, *daddr;
>> +	const struct icmp6hdr *hdr;
>> +	struct icmp6hdr _hdr;
>>     	if (skb->pkt_type =3D=3D PACKET_OTHERHOST ||
>>   	    skb->pkt_type =3D=3D PACKET_LOOPBACK ||
>> -	    hdr->icmp6_type !=3D NDISC_NEIGHBOUR_ADVERTISEMENT)
>> +	    ipv6_hdr(skb)->nexthdr !=3D NEXTHDR_ICMP)
>
>
>What makes sure IPv6 header is in skb->head (linear part of the skb) ?

	Ah, missed that; skb_header_pointer() will take care of that
(copying if necessary, not that it pulls the header), but it has to be
called first.

	This isn't a problem new to this patch, the original code
doesn't pull or copy the header, either.

	The equivalent function for ARP, bond_arp_rcv(), more or less
inlines skb_header_pointer(), so it doesn't have this issue.

	-J

>
>> +		goto out;
>> +
>> +	hdr =3D skb_header_pointer(skb, sizeof(struct ipv6hdr), sizeof(_hdr),=
 &_hdr);
>> +	if (!hdr || hdr->icmp6_type !=3D NDISC_NEIGHBOUR_ADVERTISEMENT)
>>   		goto out;
>>     	saddr =3D &ipv6_hdr(skb)->saddr;

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
