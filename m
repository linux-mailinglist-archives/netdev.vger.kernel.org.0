Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D7762D257
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 05:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbiKQEaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 23:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233900AbiKQEaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 23:30:06 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A31E1B9EC
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 20:30:04 -0800 (PST)
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 0203F3F176
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1668659402;
        bh=vPeWXgLbIR5lcRtq8Sq+1wvn+lY8o88ff7uy/NPEQAc=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=QOlMdv9ft9i3PDaOIL6VoqV4AFly0Ifk2FKU4wA0tK1KZP/Mqu4QeDk5ozxC6MsHv
         ZQ/zUJoLatMbcrNGF8jq6AeLhH36SY/OsLz3JwcKpZ+JlkkcxHZgL9rXu4IBGgdQDK
         jWL/3ebYepR0ApB2pLAVhzC21KdOVcrddFiX3X+PP3gw4pnTPjdQjb5WYnVrGnonqP
         lQkAqe+4DE/8X+tTfK/6EW7R0I2ZbSAD6htfsIVyjLcPcRbRQ7mZfp2RqiH6MWM8Aa
         imDlc8XO1HSfWDZYb+P8u759RFL65z6ZvmYZtahjal0RaXldcw4kskcLcl2twXxOQy
         +rXuknWlvO9+g==
Received: by mail-pg1-f198.google.com with SMTP id g193-20020a636bca000000b00476a2298bd1so595387pgc.12
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 20:30:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vPeWXgLbIR5lcRtq8Sq+1wvn+lY8o88ff7uy/NPEQAc=;
        b=6OmHrI9ztwPuUnC+nqtKpXsl69gd6uC6YPF8SzySBBI50Bs/DRLOJ+U4h+WfZX+Tu+
         K8tsLRe+0K41iUVGoa14uV/e1WnSAY54nOarVWjhTWjdGFH2jeKwlUNvoAlNEKlq5Jla
         C9dYYaw8ou3Gz1JlibXzn5CLoJPTaUv9CLMHtsgTOmm/t2LRBqSzDKcV893J7en0kmk8
         /Vyn9rDqM6/iOV+Gen3Kfhh6wqRVcjb/JWxAe+oW7VxTNmklS6Mw0XNgIP87/CKnQjCs
         YuhNYd/F0lYJgApQ84dN19AlpfCxytl/zo+ccXSEO28WOtWjwfnVe2HqbqAh4GwnU4Qo
         EDtQ==
X-Gm-Message-State: ANoB5pk14IxTBbJxR+adMx6YXMMbLMQwRkyk6qeSvS2dTyoTrkwn+e3A
        5g4NNTS21AOHAA+9/NGB4LRncQiQw260EsDewl5xxxfVe4zfhXd0C+SGpyAQE7ayZnM/3njtkcG
        Ql6MN9/+06GKD17aNera8nAgx1VpVoLvMlA==
X-Received: by 2002:a05:6a00:408b:b0:56b:ca57:ba8c with SMTP id bw11-20020a056a00408b00b0056bca57ba8cmr1264193pfb.43.1668659400478;
        Wed, 16 Nov 2022 20:30:00 -0800 (PST)
X-Google-Smtp-Source: AA0mqf71MKJG32aVWMUPssbrXMMeOJd1F2XPMjtl+nFm0m5XEKm1RgZWEWujtvMM1EZ1tOMUUW3v6g==
X-Received: by 2002:a05:6a00:408b:b0:56b:ca57:ba8c with SMTP id bw11-20020a056a00408b00b0056bca57ba8cmr1264174pfb.43.1668659400183;
        Wed, 16 Nov 2022 20:30:00 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id a14-20020a1709027e4e00b0018685257c0dsm27094pln.58.2022.11.16.20.29.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Nov 2022 20:29:59 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id EE6805FF12; Wed, 16 Nov 2022 20:29:58 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id E8F7C9F890;
        Wed, 16 Nov 2022 20:29:58 -0800 (PST)
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
In-reply-to: <Y3WgFgLlRQSaguqv@Laptop-X1>
References: <20221109014018.312181-1-liuhangbin@gmail.com> <49594248-1fd7-23e2-1f17-9af896cd25b0@gmail.com> <17540.1668026368@famine> <CANn89i+eZwb3+JO6oKavj5yTi74vaUY-=Pu4CaUbcq==ue9NCw@mail.gmail.com> <19557.1668029004@famine> <CANn89iKW60QdMRbpyaYry4Vdfxm41ifh4qFt1azU5FCYkUJBiA@mail.gmail.com> <Y3SEXh0x4G7jNSi9@Laptop-X1> <17663.1668611774@famine> <Y3WgFgLlRQSaguqv@Laptop-X1>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Thu, 17 Nov 2022 10:44:38 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22984.1668659398.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 16 Nov 2022 20:29:58 -0800
Message-ID: <22985.1668659398@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>On Wed, Nov 16, 2022 at 07:16:14AM -0800, Jay Vosburgh wrote:
[...]
>> 	The above comment is from Eric.  I had also mentioned that this
>> particular problem already existed in the code being patched.
>
>Yes, I also saw your comments. I was thinking to fix this issue separatel=
y.
>i.e. in bond_rcv_validate(). With this we can check both IPv6 header and =
ARP
>header. e.g.
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 2c6356232668..ae4c30a25b76 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -3278,8 +3278,10 @@ int bond_rcv_validate(const struct sk_buff *skb, s=
truct bonding *bond,
> {
> #if IS_ENABLED(CONFIG_IPV6)
> 	bool is_ipv6 =3D skb->protocol =3D=3D __cpu_to_be16(ETH_P_IPV6);
>+	struct ipv6hdr ip6_hdr;
> #endif
> 	bool is_arp =3D skb->protocol =3D=3D __cpu_to_be16(ETH_P_ARP);
>+	struct arphdr arp_hdr;
> =

> 	slave_dbg(bond->dev, slave->dev, "%s: skb->dev %s\n",
> 		  __func__, skb->dev->name);
>@@ -3293,10 +3295,10 @@ int bond_rcv_validate(const struct sk_buff *skb, =
struct bonding *bond,
> 		    !slave_do_arp_validate_only(bond))
> 			slave->last_rx =3D jiffies;
> 		return RX_HANDLER_ANOTHER;
>-	} else if (is_arp) {
>+	} else if (is_arp && skb_header_pointer(skb, 0, sizeof(arp_hdr), &arp_h=
dr)) {
> 		return bond_arp_rcv(skb, bond, slave);
> #if IS_ENABLED(CONFIG_IPV6)
>-	} else if (is_ipv6) {
>+	} else if (is_ipv6 && skb_header_pointer(skb, 0, sizeof(ip6_hdr), &ip6_=
hdr)) {
> 		return bond_na_rcv(skb, bond, slave);
> #endif
> 	} else {
>
>What do you think?

	I don't see how this solves the icmp6_hdr() / ipv6_hdr() problem
in bond_na_rcv(); skb_header_pointer() doesn't do a pull, it just copies
into the supplied struct (if necessary).

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
