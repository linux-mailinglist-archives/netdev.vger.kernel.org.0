Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB0551E044
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 22:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443567AbiEFUwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 16:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240336AbiEFUwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 16:52:04 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D158245ACB
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 13:48:20 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c14so7186314pfn.2
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 13:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=QPNSvaeAcSAe6kZtVI57FqRttxDaH1Z7B89eDthX1Ag=;
        b=diVbPpOUCblMeU5cAYd8lyfmFiI0tEWrCTSe83v/7o5D9lfj93gbjvo42NaqcqbXKo
         D2NNp4zKfxn1fRhubZ9PJ2GGrslbGfoaGWJhHj6wWDekJNx846XANIJbK1GEqmNz07DG
         qawsaIm7cL7DTGakKgQNYM2FDBO6da9U3ZOby2wqC4OKKY0rcBUxJ+3dEYdtRtFxwFY8
         5o1aZdd36t++cLyjEVuyl+9l1X2pqIorHdCmPMc7XxYHD36LFp66pVvHUk5mQxcXDYOL
         0rCQEHB2Fqs55H2uDxThK1pSo1dRt4VOLocfukDFGZZXZtQrsdR/3C6rS+9Jxx7iavsM
         WT0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QPNSvaeAcSAe6kZtVI57FqRttxDaH1Z7B89eDthX1Ag=;
        b=4CT7KBVRdlfybyToK6CHHPZwpoPmnNvjG7nXecjtIBqhr51tQMTCRURWVLXo+qSXfj
         PanE6b+6PxNiVzE6MNV3d/bOvG8CuvX6D7Uzzifmy3f2eIx/vm3xOFiWGzZmnZAMgatw
         aJ/iCPonJarwroxypM5u4UeazWBU61277m7lGoFMi/6+uMI4s97OL8yHBiPV8leQhBHA
         0fEgNOgEjONqjdr3+O297mU8rU2XvcpL3CXawr65berjsRKP/RfXTmTFVG+ew/j8hn14
         CBYsHMYUqsjlt6vPBDi1tUPN+xj+JsinAeQ4GZQVUT00sqEjiTyXPGlHN2QcY0VNFw0B
         a7UA==
X-Gm-Message-State: AOAM531WfWeK9ZZQ2UNGNcgc0xEJpUQPltDqnHvtnhE/EH/erMWQz/YF
        rEX9y+ycAZ6L4g1OE24Oe+c=
X-Google-Smtp-Source: ABdhPJylRLV9p2tENUuYqMIVvq5Cc/aFEf7Fs277AaFPlVtW6hyA8Rmu5c3rlMGpgid+mn6kbTnJ2g==
X-Received: by 2002:a63:2ad0:0:b0:3c1:5f7e:fd78 with SMTP id q199-20020a632ad0000000b003c15f7efd78mr4219105pgq.56.1651870100205;
        Fri, 06 May 2022 13:48:20 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.39.30])
        by smtp.googlemail.com with ESMTPSA id r20-20020aa79634000000b0050dc7a3e88asm3892636pfg.9.2022.05.06.13.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 13:48:19 -0700 (PDT)
Message-ID: <e582432dbe85e743cc18d358d020711db5ddbf82.camel@gmail.com>
Subject: Re: [PATCH v4 net-next 02/12] ipv6: add IFLA_GSO_IPV6_MAX_SIZE
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>
Date:   Fri, 06 May 2022 13:48:18 -0700
In-Reply-To: <20220506153048.3695721-3-eric.dumazet@gmail.com>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
         <20220506153048.3695721-3-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-3.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-05-06 at 08:30 -0700, Eric Dumazet wrote:
> From: Coco Li <lixiaoyan@google.com>
> 
> This enables ipv6/TCP stacks to build TSO packets bigger than
> 64KB if the driver is LSOv2 compatible.
> 
> This patch introduces new variable gso_ipv6_max_size
> that is modifiable through ip link.
> 
> ip link set dev eth0 gso_ipv6_max_size 185000
> 
> User input is capped by driver limit (tso_max_size)
> 
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

So I am still not a fan of adding all this extra tooling to make an
attribute that is just being applied to one protocol. Why not just
allow gso_max_size to extend beyond 64K and only limit it by
tso_max_size?

Doing that would make this patch much simpler as most of the code below
could be dropped.

> ---
>  include/linux/netdevice.h          |  2 ++
>  include/uapi/linux/if_link.h       |  1 +
>  net/core/dev.c                     |  2 ++
>  net/core/rtnetlink.c               | 23 +++++++++++++++++++++++
>  net/core/sock.c                    |  8 ++++++++
>  tools/include/uapi/linux/if_link.h |  1 +
>  6 files changed, 37 insertions(+)

<snip>

> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 512ed661204e0c66c8dcfaddc3001500d10f63ab..847cf80f81754451e5f220f846db734a7625695b 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c

<snip>

> @@ -2820,6 +2831,15 @@ static int do_setlink(const struct sk_buff *skb,
>  		}
>  	}
>  
> +	if (tb[IFLA_GSO_IPV6_MAX_SIZE]) {
> +		u32 max_size = nla_get_u32(tb[IFLA_GSO_IPV6_MAX_SIZE]);
> +
> +		if (dev->gso_ipv6_max_size ^ max_size) {
> +			netif_set_gso_ipv6_max_size(dev, max_size);
> +			status |= DO_SETLINK_MODIFIED;
> +		}
> +	}
> +
>  	if (tb[IFLA_GSO_MAX_SEGS]) {
>  		u32 max_segs = nla_get_u32(tb[IFLA_GSO_MAX_SEGS]);
>  

So the this code wouldn't be needed but the block above where we are
doing the check for max_size > GSO_MAX_SIZE could be removed.

> @@ -3283,6 +3303,9 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
>  		netif_set_gso_max_segs(dev, nla_get_u32(tb[IFLA_GSO_MAX_SEGS]));
>  	if (tb[IFLA_GRO_MAX_SIZE])
>  		netif_set_gro_max_size(dev, nla_get_u32(tb[IFLA_GRO_MAX_SIZE]));
> +	if (tb[IFLA_GSO_IPV6_MAX_SIZE])
> +		netif_set_gso_ipv6_max_size(dev,
> +			nla_get_u32(tb[IFLA_GSO_IPV6_MAX_SIZE]));
>  
>  	return dev;
>  }
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 6b287eb5427b32865d25fc22122fefeff3a4ccf5..4a29c3bf6b95f76280d8e32e903a0916322d5c4f 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2312,6 +2312,14 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
>  			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
>  			/* pairs with the WRITE_ONCE() in netif_set_gso_max_size() */
>  			sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_max_size);
> +#if IS_ENABLED(CONFIG_IPV6)
> +			if (sk->sk_family == AF_INET6 &&
> +			    sk_is_tcp(sk) &&
> +			    !ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr)) {
> +				/* Paired with WRITE_ONCE() in netif_set_gso_ipv6_max_size() */
> +				sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_ipv6_max_size);
> +			}
> +#endif
>  			sk->sk_gso_max_size -= (MAX_TCP_HEADER + 1);
>  			/* pairs with the WRITE_ONCE() in netif_set_gso_max_segs() */
>  			max_segs = max_t(u32, READ_ONCE(dst->dev->gso_max_segs), 1);

This block here could then be rewritten as:
if (sk->sk_gso_max_size > GSO_MAX_SIZE &&
    (!IS_ENABLED(CONFIG_IPV6) || sk->sk_family != AF_INET6 || 
     !skb_is_tcp(sk) || ipv6_addr_v4mapped(&sk->sk_v6_rcf_saddr))
	sk->sk_gso_max_size = GSO_MAX_SIZE;

Then if we need protocol specific knobs in the future we could always
come back and make them act as caps instead of outright replacements
for the gso_max_size value.


