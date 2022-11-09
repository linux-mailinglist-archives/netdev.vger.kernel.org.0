Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0289F6233AC
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 20:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiKITmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 14:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbiKITmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 14:42:46 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC192CC85
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 11:42:44 -0800 (PST)
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id AAA36412C4
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 19:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1668022960;
        bh=6kw+DNoAGZSSdx4i+phBnVBjA1GgATaVVb7CvTrQ2ck=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=GM03Y4R7KbZvNLfxWhBA2pz4oSgXby5CaIo/SeALkv58rD2z6FbePqP49bThaH4kI
         vVjd8H2fWavL+vy46WJEBd/hmA5lA3SPTw4Vso7ddZX9AIeDsI+h9uzvDRjGyq7hWR
         GmxMD780KieUltmcU+mt17xlFNxu6XZWBGdFmlMvgwPLBNKVHJOQZNpWbXQlOJOBua
         ev1ZFx1MOzZCmajH4WGjaMLqol9YmByJwH2V2o3CH2ey86wkHpEgg+CaqUir32ynpz
         FnHYu5FfL4pRgAMHxJBYuwIvsfAXxsGC088s3ReWWINB4PjttAsuf2zxd4yktM2TJY
         F1NtMpgTm7RRw==
Received: by mail-pj1-f72.google.com with SMTP id oo18-20020a17090b1c9200b0020bdba475afso1928037pjb.4
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 11:42:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6kw+DNoAGZSSdx4i+phBnVBjA1GgATaVVb7CvTrQ2ck=;
        b=MRKEb/Lm95VVGEk75xbd1agl3bw1ZHC0RlB+OVeOGyzb5YgI574Yi8JLvE8AnD47Wo
         uqIFFnbLbh/adH0sTvFpv4QzuL2HQU43U1qy2MInmRzx/hnF9UobeDcloepb9rIToNdb
         xZJkzn/6sUGEWeoc9nWRo22zls5YQqlkJBI6YAw+BYbW4hIWIqVzqxCXERnTm9JE3FFT
         8qPCYHSf7q37avTPj/9Z4nkGzBg+ffWcuk2+0UzTuwYiX+i5HPL75JReZU+AC+bKND2x
         5DFEWdqm6ZlSVpqWfILxVQxHiBgHVnc/VzODPZDadlsWg4B9jkq0Pz2qQCNWL9f4KYmF
         2KKQ==
X-Gm-Message-State: ACrzQf2P5OGBimNQMa1P4cxzO0KmTQZK34qdtJctNzLwWmJvrenkUx3K
        3oqXFnT/YaFQl3v6kP/jvuiRijkgONBLbbqAN2idD8cr33I2BtOSAxuPmWmB9JLPSFlbnKVHFVE
        +P8sb6IxXIh+RB2KjWCEhJbc6qxAecg4gJA==
X-Received: by 2002:a62:2703:0:b0:56d:60f2:97 with SMTP id n3-20020a622703000000b0056d60f20097mr53913597pfn.10.1668022959020;
        Wed, 09 Nov 2022 11:42:39 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5F1qU8dK/Ayf7IKrKsx829eW7a6yrf5U2M19BRApS02oieI+IXUNXwjNnRhif2Bn0P6C5Byw==
X-Received: by 2002:a62:2703:0:b0:56d:60f2:97 with SMTP id n3-20020a622703000000b0056d60f20097mr53913585pfn.10.1668022958737;
        Wed, 09 Nov 2022 11:42:38 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id x10-20020a17090a46ca00b002131a9f8dcbsm1570411pjg.46.2022.11.09.11.42.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Nov 2022 11:42:38 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 6EB405FEAC; Wed,  9 Nov 2022 11:42:37 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 676C19F890;
        Wed,  9 Nov 2022 11:42:37 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv3 net] bonding: fix ICMPv6 header handling when receiving IPv6 messages
In-reply-to: <20221109014018.312181-1-liuhangbin@gmail.com>
References: <20221109014018.312181-1-liuhangbin@gmail.com>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Wed, 09 Nov 2022 09:40:18 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15495.1668022957.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 09 Nov 2022 11:42:37 -0800
Message-ID: <15496.1668022957@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>Currently, we get icmp6hdr via function icmp6_hdr(), which needs the skb
>transport header to be set first. But there is no rule to ask driver set
>transport header before netif_receive_skb() and bond_handle_frame(). So
>we will not able to get correct icmp6hdr on some drivers.
>
>Fix this by checking the skb length manually and getting icmp6 header bas=
ed
>on the IPv6 header offset.
>
>Reported-by: Liang Li <liali@redhat.com>
>Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
>Acked-by: Jonathan Toppins <jtoppins@redhat.com>
>Reviewed-by: David Ahern <dsahern@kernel.org>
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

>---
>v3: fix _hdr parameter warning reported by kernel test robot
>v2: use skb_header_pointer() to get icmp6hdr as Jay suggested.
>---
> drivers/net/bonding/bond_main.c | 9 +++++++--
> 1 file changed, 7 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index e84c49bf4d0c..2c6356232668 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -3231,12 +3231,17 @@ static int bond_na_rcv(const struct sk_buff *skb,=
 struct bonding *bond,
> 		       struct slave *slave)
> {
> 	struct slave *curr_active_slave, *curr_arp_slave;
>-	struct icmp6hdr *hdr =3D icmp6_hdr(skb);
> 	struct in6_addr *saddr, *daddr;
>+	const struct icmp6hdr *hdr;
>+	struct icmp6hdr _hdr;
> =

> 	if (skb->pkt_type =3D=3D PACKET_OTHERHOST ||
> 	    skb->pkt_type =3D=3D PACKET_LOOPBACK ||
>-	    hdr->icmp6_type !=3D NDISC_NEIGHBOUR_ADVERTISEMENT)
>+	    ipv6_hdr(skb)->nexthdr !=3D NEXTHDR_ICMP)
>+		goto out;
>+
>+	hdr =3D skb_header_pointer(skb, sizeof(struct ipv6hdr), sizeof(_hdr), &=
_hdr);
>+	if (!hdr || hdr->icmp6_type !=3D NDISC_NEIGHBOUR_ADVERTISEMENT)
> 		goto out;
> =

> 	saddr =3D &ipv6_hdr(skb)->saddr;
>-- =

>2.38.1
>
