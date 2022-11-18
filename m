Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B153562ECE6
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 05:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbiKREgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 23:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235090AbiKREgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 23:36:13 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F7A92B72
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 20:36:12 -0800 (PST)
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 6625C3F328
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 04:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1668746170;
        bh=ZRksBWV8DSPTet60hFqNK9J9jha+Eo0BlaTXYRVtL+4=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=Jd7Sl/nQNl7ho1i4J/EFFza8VwMfNP2N/sObXZ9q20DBOIz1i2F1jgk0CfxxFyEAa
         sL75oispJE5fgGRCQoXNQzD+iC8jNIalBpLGu2amCsRoIrfeU3IW3luOx9rZyPgg+C
         7cu0gxwyp5wqSKi3J8eFfPOMTHtC/C5hPcplUjAL51IC2cQSRU5GlmnCieLbIm4Eq5
         PbdxEIo+SMl3JWGNcgBaEi+2+5cuVrtmJYt/9RNK/foUaVm8qv1GOy49fhH+sQCR5G
         UsWkqAlM8tKqgsZmKlHSbRUoe0Qocq7YK1UiDevn9dWgPI2RCVM0pi36d912qP4pR6
         bNlpqW99hr7Gw==
Received: by mail-pf1-f197.google.com with SMTP id f19-20020a056a001ad300b0056dd07cebfcso2354896pfv.3
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 20:36:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRksBWV8DSPTet60hFqNK9J9jha+Eo0BlaTXYRVtL+4=;
        b=r4fYef7iOtHNhwkJxBLaW8KJwk0hcHTJRQ2B2rJ/B/nl51tQ39ytdGq0D1vyGLaK9K
         F0XO3XVVj5AobyAemDKkf2Q2WNRXXmfrfi+5WFCGQqgllW4JQM0yYaZ68fNNu8Y6WItI
         vbkF1Bi57DD6SlFXvMXi8doB6udVf/sh/EeWMvZwhtwp2CDhlQ6OHEE/x6zT1M7JqCuv
         howDUTUmj2i6m5FCMCWYU51Vn4l+mGDXe5deZWeQMZH+qqatXgqChWmlLC6cMNf5UWs5
         IpNN+5uZh4YZdoJ4z0NLlAy96ZgUS65fH1WTdd16Z9ljo4mBjDbGH66sndyf1u85nfJL
         chSw==
X-Gm-Message-State: ANoB5plXe7AE/z27zCbz7Y7nFgIuUqXNTyH3+K5yczr+KpIIf4cVxG/g
        WCg7ptOFeuuAlTZtCSGNSgwRkGGsb8HPGv7fFhZiMI3CKMx3zNnd7+W1d3ozk9XJT1uCEOR0PqH
        Ju5b9baXouJY2wEQf84ATkYPPnk7Tkhu86g==
X-Received: by 2002:a17:902:76c9:b0:186:9ef1:647e with SMTP id j9-20020a17090276c900b001869ef1647emr5713091plt.143.1668746168806;
        Thu, 17 Nov 2022 20:36:08 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6z6alGWr6vp/Xkb7aPhE+DWqKiFBJdEf0UdhCaJvC2JT2wzWVY9a0ZfDt7w0i6UXIQeE+OAQ==
X-Received: by 2002:a17:902:76c9:b0:186:9ef1:647e with SMTP id j9-20020a17090276c900b001869ef1647emr5713073plt.143.1668746168546;
        Thu, 17 Nov 2022 20:36:08 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id p17-20020a170902e35100b00178b77b7e71sm2289817plc.188.2022.11.17.20.36.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Nov 2022 20:36:08 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 6E0535FF12; Thu, 17 Nov 2022 20:36:07 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 6641A9F890;
        Thu, 17 Nov 2022 20:36:07 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Tom Herbert <tom@herbertland.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCHv4 net] bonding: fix ICMPv6 header handling when receiving IPv6 messages
In-reply-to: <20221118034353.1736727-1-liuhangbin@gmail.com>
References: <20221118034353.1736727-1-liuhangbin@gmail.com>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Fri, 18 Nov 2022 11:43:53 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12964.1668746167.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 17 Nov 2022 20:36:07 -0800
Message-ID: <12965.1668746167@famine>
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
>Fix this by using skb_header_pointer to get the IPv6 and ICMPV6 headers.
>
>Reported-by: Liang Li <liali@redhat.com>
>Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
>Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>


>---
>v4: get the full ipv6+icmp6 hdr in case the skb is not lineared
>v3: fix _hdr parameter warning reported by kernel test robot
>v2: use skb_header_pointer() to get icmp6hdr as Jay suggested.
>---
> drivers/net/bonding/bond_main.c | 17 ++++++++++++-----
> 1 file changed, 12 insertions(+), 5 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index e84c49bf4d0c..f298b9b3eb77 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -3231,16 +3231,23 @@ static int bond_na_rcv(const struct sk_buff *skb,=
 struct bonding *bond,
> 		       struct slave *slave)
> {
> 	struct slave *curr_active_slave, *curr_arp_slave;
>-	struct icmp6hdr *hdr =3D icmp6_hdr(skb);
> 	struct in6_addr *saddr, *daddr;
>+	struct {
>+		struct ipv6hdr ip6;
>+		struct icmp6hdr icmp6;
>+	} *combined, _combined;
> =

> 	if (skb->pkt_type =3D=3D PACKET_OTHERHOST ||
>-	    skb->pkt_type =3D=3D PACKET_LOOPBACK ||
>-	    hdr->icmp6_type !=3D NDISC_NEIGHBOUR_ADVERTISEMENT)
>+	    skb->pkt_type =3D=3D PACKET_LOOPBACK)
>+		goto out;
>+
>+	combined =3D skb_header_pointer(skb, 0, sizeof(_combined), &_combined);
>+	if (!combined || combined->ip6.nexthdr !=3D NEXTHDR_ICMP ||
>+	    combined->icmp6.icmp6_type !=3D NDISC_NEIGHBOUR_ADVERTISEMENT)
> 		goto out;
> =

>-	saddr =3D &ipv6_hdr(skb)->saddr;
>-	daddr =3D &ipv6_hdr(skb)->daddr;
>+	saddr =3D &combined->ip6.saddr;
>+	daddr =3D &combined->ip6.saddr;
> =

> 	slave_dbg(bond->dev, slave->dev, "%s: %s/%d av %d sv %d sip %pI6c tip %=
pI6c\n",
> 		  __func__, slave->dev->name, bond_slave_state(slave),
>-- =

>2.38.1
>
