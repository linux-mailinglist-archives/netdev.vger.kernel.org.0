Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6747C62C212
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 16:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbiKPPQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 10:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiKPPQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 10:16:24 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927CC4D5FD
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 07:16:23 -0800 (PST)
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 9BD293F11B
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 15:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1668611778;
        bh=lNYpkx5jnLmiqGOqHDfXo7UFVJp4g6K91cYoGiOeshE=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=CJn2KjSzGmtRxhgn81synRj2ZMGnkigqjp2iRmmEXAygYHJfqPjGnnNKANIBDAhzj
         heBHYVWI8cAvlf1afSQl0GFgInnumvGOG7bRgTR8kSzhS6Xr9z1bDCWX3gBX8c8PaW
         tlZ5hbWOQ387fuJzdYWjgiaIWDEEd4T9MKj885zP37kxTsL9jGtWjgvIfj17WxAntd
         En78zAYo9XpKcAEsmP8ppXxqiGGrpUuf5KF+4BtfySPJQcX5Nh2MjU0avEPKCgah2m
         GrqowHdMN1IWEzPK5kWoi60A3UvLvCfu2Wlm53zd38bXVVwix40xaJuq14PuIPIv9E
         zyb+adNaaBNfg==
Received: by mail-pl1-f198.google.com with SMTP id q6-20020a170902dac600b001873ef77938so14052188plx.18
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 07:16:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lNYpkx5jnLmiqGOqHDfXo7UFVJp4g6K91cYoGiOeshE=;
        b=c+Utt/ktnWEMnVgtIgRFk6WBQfLp3gI72J4bw5Gpk52nAmLAk6tljg6eV0Jq3CHcuc
         RzlTyrwClAQPubRV6/57PkkbgAFY2CVCmItE3bHrL+eG7PE3m1sEu3OJHhAd8iH4oVZ/
         G6WgxeHz33vsFe8NW/g+k5VVV+R/x7w+RfGN0Sc0ZsVP/SqUrdNJE08yP/ERbbSs0lUK
         JME/YxNdodItQ4UNUqcB2JKDx0YXaPsd2CBLcVZg6Odx6SfrO23QtWSbazOHdnEKoQBO
         8XV0N5JVufFwpYtKCyLhWfBSGnreBwXbEN1zrPGqLFCxdB4BE7fvO6oaxBZG9f8f3wlM
         13qQ==
X-Gm-Message-State: ANoB5pn/ctAQvVE6njklTewxTgCCIevRyXa7KCF8VNHFpsSgE45Ukg+K
        dDj/FxDhb/nkIBDmXPHsCzyBQGBu8DofTkOjkeeYDS4D4gOaS3HVqEacbFgXJAMB++o5TVxVOuG
        MqWTXHizykmIKGxts/GWz6exXCjzdLtkV/A==
X-Received: by 2002:a63:f1e:0:b0:470:88:8c18 with SMTP id e30-20020a630f1e000000b0047000888c18mr20852543pgl.23.1668611777222;
        Wed, 16 Nov 2022 07:16:17 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7CDit223aG1Bz/XM03o0pMCrzYxX82Ys+okzsp28jyotmUf/GMOJ0NHNNDpPegVZvl37MK7w==
X-Received: by 2002:a63:f1e:0:b0:470:88:8c18 with SMTP id e30-20020a630f1e000000b0047000888c18mr20852527pgl.23.1668611776991;
        Wed, 16 Nov 2022 07:16:16 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id m6-20020a17090a668600b0020d3662cc77sm1692196pjj.48.2022.11.16.07.16.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Nov 2022 07:16:16 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id EADFE5FF12; Wed, 16 Nov 2022 07:16:14 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id E56F39F890;
        Wed, 16 Nov 2022 07:16:14 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv3 net] bonding: fix ICMPv6 header handling when receiving IPv6 messages
In-reply-to: <Y3SEXh0x4G7jNSi9@Laptop-X1>
References: <20221109014018.312181-1-liuhangbin@gmail.com> <49594248-1fd7-23e2-1f17-9af896cd25b0@gmail.com> <17540.1668026368@famine> <CANn89i+eZwb3+JO6oKavj5yTi74vaUY-=Pu4CaUbcq==ue9NCw@mail.gmail.com> <19557.1668029004@famine> <CANn89iKW60QdMRbpyaYry4Vdfxm41ifh4qFt1azU5FCYkUJBiA@mail.gmail.com> <Y3SEXh0x4G7jNSi9@Laptop-X1>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Wed, 16 Nov 2022 14:34:06 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17662.1668611774.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 16 Nov 2022 07:16:14 -0800
Message-ID: <17663.1668611774@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>On Wed, Nov 09, 2022 at 01:48:11PM -0800, Eric Dumazet wrote:
>> On Wed, Nov 9, 2022 at 1:23 PM Jay Vosburgh <jay.vosburgh@canonical.com=
> wrote:
>> >
>> > Eric Dumazet <edumazet@google.com> wrote:
>> > >Quite frankly I would simply use
>> > >
>> > >if (pskb_may_pull(skb, sizeof(struct ipv6hdr) + sizeof(struct icmp6h=
dr))
>> > > instead of  skb_header_pointer()
>> > >because chances are high we will need the whole thing in skb->head l=
ater.
>> >
>> >         Well, it was set up this way with skb_header_pointer() instea=
d
>> > of pskb_may_pull() by you in de063b7040dc ("bonding: remove packet
>> > cloning in recv_probe()") so the bonding rx_handler wouldn't change o=
r
>> > clone the skb.  Now, I'm not sure if we should follow your advice to =
go
>> > against your advice.
>> =

>> Ah... I forgot about this, thanks for reminding me it ;)
>
>Hi David,
>
>The patch state[1] is Changes Requested, but I think Eric has no object o=
n this
>patch now. Should I keep waiting, or re-send the patch?
>
>[1] https://patchwork.kernel.org/project/netdevbpf/patch/20221109014018.3=
12181-1-liuhangbin@gmail.com/

	The excerpt above is confirming that using skb_header_pointer()
is the correct implementation to use.

	However, the patch needs to change to call skb_header_pointer()
sooner, to insure that the IPv6 header is available.  I've copied the
relevant part of the discussion below:

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

	The above comment is from Eric.  I had also mentioned that this
particular problem already existed in the code being patched.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
