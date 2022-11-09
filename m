Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97EF46235BC
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 22:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbiKIVXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 16:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbiKIVXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 16:23:44 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3C21BEBA
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 13:23:42 -0800 (PST)
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id DA006412C1
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 21:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1668029019;
        bh=Ov7k+t2/09xryDxMuZcgiFy9/YaxP3Crjgy/dUiWN54=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=E516XLzF/j+uHzfCNWms6u09JKW0xheFXF8v4PGF0sehDWsmPge2XFCIlnQx+LU2c
         Ze05LhlYba32mLwQrUr8wGKG/DFR3O9G53OoTdueCQ/V+g+7z5412NR5Agkopn8w/a
         gKd4ZXCSiLUzutGsCXggXMDeNeObBBdNVdAQtBNHAdmly4+da/ZcFC00avxZzvS9ze
         1IyMJ8wB6E5VSJMSJ197HHAFpxtxIwHoJuwE5bHakgqHC6O9vXceiP+SKXvpof8F1M
         ScWRgF2L1dDSS0BD0svLQbLb5I7MlKHn2iGHPy0C+7pSpKa+8AjfsuFsKvPWyT/fuy
         Az5IUrxnF2WsQ==
Received: by mail-pl1-f197.google.com with SMTP id s15-20020a170902ea0f00b00187050232fcso14103598plg.3
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 13:23:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ov7k+t2/09xryDxMuZcgiFy9/YaxP3Crjgy/dUiWN54=;
        b=eR+VQJA5XWbXbRJBuaOWWDMEpE1tBoyevw+J1rlG3H4ewPDePGpLKec7q8RRJ2RNAX
         hJwWuBsSJYpwboKIqIntzQp+0RFnK8vZNN7JAs9MUOyVPYijCUkr+W7PEEDTKSxj2iIt
         suKaz9M50EstHb9NVyNKolo+bfrMsZ1X+i4M2CwfSJdWM8p630fq3jdf+0SPi/7tyJPO
         rIWUCoL6jcPsXrAjL7BHhIVKribgn3/ersTlVU8N1slGI5MaxcHXhkGSVPFcxX5ljLcG
         9F7NZn1oeHR+LH5rI5OT58wgrdXkQEHYhQcWwb/6cwaDa+R3n/6DqHIDn/1BZeiN1lPJ
         6fSA==
X-Gm-Message-State: ACrzQf00hy0bTvIkAZc9aEchJCJJverVZFFEjL3Yn0VRB064xb6Tr5RZ
        4B6HtnihrejDVJKhcfXuA4Jv68qSVH8JAaVop87n42DwK/oj5YB+5B/cTEyV1pHEOvkJdDynFJr
        GOuFSGzjiLr8AlKM+5JOtqm/+YfUcKiuEGA==
X-Received: by 2002:a63:6c06:0:b0:46f:cd2d:2be4 with SMTP id h6-20020a636c06000000b0046fcd2d2be4mr43414557pgc.101.1668029018404;
        Wed, 09 Nov 2022 13:23:38 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4NKkIhbtIpO0IFyyUHrrYuC8laM6TjW2YqlWKRr5HmArAztQ6ge40IhV4zxyOV+W/VNFUIfA==
X-Received: by 2002:a63:6c06:0:b0:46f:cd2d:2be4 with SMTP id h6-20020a636c06000000b0046fcd2d2be4mr43414536pgc.101.1668029018131;
        Wed, 09 Nov 2022 13:23:38 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id u2-20020a17090341c200b001766a3b2a26sm9599382ple.105.2022.11.09.13.23.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Nov 2022 13:23:28 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 50E245FEAC; Wed,  9 Nov 2022 13:23:24 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 49B849F890;
        Wed,  9 Nov 2022 13:23:24 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Eric Dumazet <edumazet@google.com>
cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv3 net] bonding: fix ICMPv6 header handling when receiving IPv6 messages
In-reply-to: <CANn89i+eZwb3+JO6oKavj5yTi74vaUY-=Pu4CaUbcq==ue9NCw@mail.gmail.com>
References: <20221109014018.312181-1-liuhangbin@gmail.com> <49594248-1fd7-23e2-1f17-9af896cd25b0@gmail.com> <17540.1668026368@famine> <CANn89i+eZwb3+JO6oKavj5yTi74vaUY-=Pu4CaUbcq==ue9NCw@mail.gmail.com>
Comments: In-reply-to Eric Dumazet <edumazet@google.com>
   message dated "Wed, 09 Nov 2022 12:45:15 -0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19548.1668029004.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 09 Nov 2022 13:23:24 -0800
Message-ID: <19557.1668029004@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> wrote:

>On Wed, Nov 9, 2022 at 12:39 PM Jay Vosburgh <jay.vosburgh@canonical.com>=
 wrote:
>>
>> Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>> >
>> >
>> >On 11/8/22 17:40, Hangbin Liu wrote:
>> >> Currently, we get icmp6hdr via function icmp6_hdr(), which needs the=
 skb
>> >> transport header to be set first. But there is no rule to ask driver=
 set
>> >> transport header before netif_receive_skb() and bond_handle_frame().=
 So
>> >> we will not able to get correct icmp6hdr on some drivers.
>> >>
>> >> Fix this by checking the skb length manually and getting icmp6 heade=
r based
>> >> on the IPv6 header offset.
>> >>
>> >> Reported-by: Liang Li <liali@redhat.com>
>> >> Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
>> >> Acked-by: Jonathan Toppins <jtoppins@redhat.com>
>> >> Reviewed-by: David Ahern <dsahern@kernel.org>
>> >> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>> >> ---
>> >> v3: fix _hdr parameter warning reported by kernel test robot
>> >> v2: use skb_header_pointer() to get icmp6hdr as Jay suggested.
>> >> ---
>> >>   drivers/net/bonding/bond_main.c | 9 +++++++--
>> >>   1 file changed, 7 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/b=
ond_main.c
>> >> index e84c49bf4d0c..2c6356232668 100644
>> >> --- a/drivers/net/bonding/bond_main.c
>> >> +++ b/drivers/net/bonding/bond_main.c
>> >> @@ -3231,12 +3231,17 @@ static int bond_na_rcv(const struct sk_buff =
*skb, struct bonding *bond,
>> >>                     struct slave *slave)
>> >>   {
>> >>      struct slave *curr_active_slave, *curr_arp_slave;
>> >> -    struct icmp6hdr *hdr =3D icmp6_hdr(skb);
>> >>      struct in6_addr *saddr, *daddr;
>> >> +    const struct icmp6hdr *hdr;
>> >> +    struct icmp6hdr _hdr;
>> >>      if (skb->pkt_type =3D=3D PACKET_OTHERHOST ||
>> >>          skb->pkt_type =3D=3D PACKET_LOOPBACK ||
>> >> -        hdr->icmp6_type !=3D NDISC_NEIGHBOUR_ADVERTISEMENT)
>> >> +        ipv6_hdr(skb)->nexthdr !=3D NEXTHDR_ICMP)
>> >
>> >
>> >What makes sure IPv6 header is in skb->head (linear part of the skb) ?
>>
>>         Ah, missed that; skb_header_pointer() will take care of that
>> (copying if necessary, not that it pulls the header), but it has to be
>> called first.
>>
>>         This isn't a problem new to this patch, the original code
>> doesn't pull or copy the header, either.
>
>Quite frankly I would simply use
>
>if (pskb_may_pull(skb, sizeof(struct ipv6hdr) + sizeof(struct icmp6hdr))
> instead of  skb_header_pointer()
>because chances are high we will need the whole thing in skb->head later.

	Well, it was set up this way with skb_header_pointer() instead
of pskb_may_pull() by you in de063b7040dc ("bonding: remove packet
cloning in recv_probe()") so the bonding rx_handler wouldn't change or
clone the skb.  Now, I'm not sure if we should follow your advice to go
against your advice.

	Also, we'd have to un-const the skb parameter through the call
chain from bond_handle_frame().

	-J

>>
>>         The equivalent function for ARP, bond_arp_rcv(), more or less
>> inlines skb_header_pointer(), so it doesn't have this issue.
>>
>>         -J
>>
>> >
>> >> +            goto out;
>> >> +
>> >> +    hdr =3D skb_header_pointer(skb, sizeof(struct ipv6hdr), sizeof(=
_hdr), &_hdr);
>> >> +    if (!hdr || hdr->icmp6_type !=3D NDISC_NEIGHBOUR_ADVERTISEMENT)
>> >>              goto out;
>> >>      saddr =3D &ipv6_hdr(skb)->saddr;

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
