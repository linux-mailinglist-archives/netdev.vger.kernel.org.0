Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD47614786
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 11:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiKAKMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 06:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiKAKMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 06:12:51 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5D111C3D
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 03:12:49 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 17052412D9
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 10:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1667297565;
        bh=J8vfky3Qylps8OMqQ8ZcbmW3mdMqJcDpCzHtW3LZzvE=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=IgFI1v8ImA376c8bTxfuSdq3Upepl31hzIA8wM8SoJvgSexZ/ogFyeCf0vyv3USr9
         x01sglRSy1n1DQl85TyvhwXFokbb4H2B8TG1qvLIBSWgI4vjnfIb3h4XMmxMyR3Pb2
         Wewbv1DCqmkrB29NyaVsdqoABdCPh3IQauRXQBkWicwCXZ9hp/CkdZWHLHb5yWLfb0
         58icBu9JPal7ZS6XrlFChwNPopG502azmecgL+R5wwPhkolaPlpkm13fhW2lXk+YdK
         gyFi0IruWSHT+aazSyFULFpwKFBrQx40NSRXo3Gpc+4wpXdyNkzfyYe4J7To/cSfwI
         rLnn7XMLscvUQ==
Received: by mail-ej1-f71.google.com with SMTP id hd11-20020a170907968b00b0078df60485fdso7594492ejc.17
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 03:12:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J8vfky3Qylps8OMqQ8ZcbmW3mdMqJcDpCzHtW3LZzvE=;
        b=qY+XqGQJWwncIKAH8MvNjPkHf743k/4ceOeRgP3AoOjLAEpD9HlL+M5ahichUt25S5
         CwmlE2+u1wFiGueoHM2+GWOhRApCIjl6tu02peIDbxoW8IeeSHz7qheiIk5lk3Ytt0pU
         ZOuDmqhmY9Jdkb6sfnya0PI+SVN4PmMnDq6Djw/rcprgQTTRDf6uQLyF6mzfZDemPq2M
         WRTEAWnZ+iR6YPsKHQFjCR2715k925h/H43N6w2u9lbJrWzEMZFFjG/E7N8cU+LT1oJO
         Z4CapQCT5CI2H4X5iBO6v45+ZNOgtgZdto6EysuewFtoHynXxpBmZekzLSE3N3LFTH7X
         Uk0Q==
X-Gm-Message-State: ACrzQf1K9KR/4hfo5ZU2YQU529o1L0CaRgEuXUYUbLV73ipKJMD5UQRe
        Wzj+VM082D7YJ3s6Wmu6dL1cyctDDk67dzK8hABTJmFpvtel1luRVAlUpLv7rNtuuyol6ZwsSAe
        2kBYI2TPNop86pjy7ZhB6b/pVbSGYt7PTSw==
X-Received: by 2002:a05:6402:378c:b0:458:8053:6c5f with SMTP id et12-20020a056402378c00b0045880536c5fmr17944187edb.9.1667297564836;
        Tue, 01 Nov 2022 03:12:44 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM61hBCJiuAe9A47gdjr3llGRA1PTkGUr600Ik1086+XAAfHQfTTYvUrg788CJPFNtuRvTDFOw==
X-Received: by 2002:a05:6402:378c:b0:458:8053:6c5f with SMTP id et12-20020a056402378c00b0045880536c5fmr17944161edb.9.1667297564530;
        Tue, 01 Nov 2022 03:12:44 -0700 (PDT)
Received: from vermin.localdomain ([213.29.99.90])
        by smtp.gmail.com with ESMTPSA id vq7-20020a170907a4c700b007ad96726c42sm4035464ejc.91.2022.11.01.03.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 03:12:43 -0700 (PDT)
Received: by vermin.localdomain (Postfix, from userid 1000)
        id 1B5081C9B08; Tue,  1 Nov 2022 03:12:43 -0700 (PDT)
Received: from vermin (localhost [127.0.0.1])
        by vermin.localdomain (Postfix) with ESMTP id 1938C1C9B05;
        Tue,  1 Nov 2022 11:12:43 +0100 (CET)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>
Subject: Re: [PATCH net] bonding: fix ICMPv6 header handling when receiving IPv6 messages
In-reply-to: <20221101091356.531160-1-liuhangbin@gmail.com>
References: <20221101091356.531160-1-liuhangbin@gmail.com>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Tue, 01 Nov 2022 17:13:56 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.7+dev; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <72466.1667297563.1@vermin>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 01 Nov 2022 11:12:43 +0100
Message-ID: <72467.1667297563@vermin>
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>Some drivers, like bnx2x, will call ipv6_gro_receive() and set skb
>IPv6 transport header before bond_handle_frame(). But some other drivers,
>like be2net, will not call ipv6_gro_receive() and skb transport header
>is not set properly. Thus we can't use icmp6_hdr(skb) to get the icmp6
>header directly when dealing with IPv6 messages.

	I don't understand this explanation, as ipv6_gro_receive() isn't
called directly by the device drivers, but from within the GRO
processing, e.g., by dev_gro_receive().

	Could you explain how the call paths actually differ?  =


	-J

>Fix this by checking the skb length manually and getting icmp6 header bas=
ed
>on the IPv6 header offset.
>
>Reported-by: Liang Li <liali@redhat.com>
>Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>---
> drivers/net/bonding/bond_main.c | 15 +++++++++++++--
> 1 file changed, 13 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index e84c49bf4d0c..08b5f512f5fb 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -3231,12 +3231,23 @@ static int bond_na_rcv(const struct sk_buff *skb,=
 struct bonding *bond,
> 		       struct slave *slave)
> {
> 	struct slave *curr_active_slave, *curr_arp_slave;
>-	struct icmp6hdr *hdr =3D icmp6_hdr(skb);
>+	const struct icmp6hdr *icmp6_hdr;
> 	struct in6_addr *saddr, *daddr;
>+	const struct ipv6hdr *hdr;
>+	u16 pkt_len;
>+
>+	/* Check if the length is enough manually as we can't use pskb_may_pull=
 */
>+	hdr =3D ipv6_hdr(skb);
>+	pkt_len =3D ntohs(hdr->payload_len);
>+	if (hdr->nexthdr !=3D NEXTHDR_ICMP || pkt_len < sizeof(*icmp6_hdr) ||
>+	    skb_headlen(skb) < sizeof(*hdr) + pkt_len)
>+		goto out;
>+
>+	icmp6_hdr =3D (const struct icmp6hdr *)(skb->data + sizeof(*hdr));
> =

> 	if (skb->pkt_type =3D=3D PACKET_OTHERHOST ||
> 	    skb->pkt_type =3D=3D PACKET_LOOPBACK ||
>-	    hdr->icmp6_type !=3D NDISC_NEIGHBOUR_ADVERTISEMENT)
>+	    icmp6_hdr->icmp6_type !=3D NDISC_NEIGHBOUR_ADVERTISEMENT)
> 		goto out;
> =

> 	saddr =3D &ipv6_hdr(skb)->saddr;
>-- =

>2.38.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
