Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273284DC250
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 10:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbiCQJIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 05:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbiCQJIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 05:08:34 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513301D304B
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:07:16 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id z26so6333344lji.8
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=YsJJhr893l7v+/N/c3HScAvTwn9XGeYWM1bIRA+h98s=;
        b=EQKjea3QT0ebBISwykXFq+UKyf9FJV55M82iCvs/QbZaeaRnimhIl9z5S8RB7f8niQ
         OZ5VSxI29C6N6o1GGZy95IRHqYHpxPy9+lCHhAChIbR824KNt/RKrp1H89VRFnAMsZMc
         j68OUJ4AKbul0gwVGrCOOCHPnQwLxjo2NGRbHY+VVuT+KzO919abdTCs5uT51mF05nLt
         0f9QaG6Swh/gRYF3Fmv5pRitCrYdw3iIWuvF9kl4mXB0nWh8bJYTVtBrPPs4GmxfwXvJ
         Atqq0Bd0tQj+3URv+m5LY+AFsaCOeZtMw/jEgVJmPK7gHUe8hU01Ge2gKESxu3w45wPI
         uD2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YsJJhr893l7v+/N/c3HScAvTwn9XGeYWM1bIRA+h98s=;
        b=RWQDN7VkWhhdxhdInWv0Jqg6VC0UuaIwPAHb4jMrjR+raT0tjdXPUCnETNGRFIFtis
         2J+clKO/WtKhzEDVyYhE4SHhCl8Ncxy/Fa3AygauuO34RpEn7VDTZNcIfWuXlG3oTpg9
         nGKZ6Ju/95lX59SRJmPsrOU43hYMLM8nH4NGcflyODvuZ9hpy1ACxPBasnE3BfUaUznE
         cDZppNGyw+hxvXhoQ21++3FPOaW1JchfVvSqim0Um5EJDy8G4e0AnkUkyYehVIiM6V+t
         kay0YorG3LfFyaTcfrDb7M2EFOOt99HEIkysw+jxXGeQ1iTlR3nN4nxqIxnsMiEs/Vzx
         9e4g==
X-Gm-Message-State: AOAM531fmO+X12wxWYfJ8X9ObDz8wKZ7k04PvhTNx8TG/uQjXLEPWJ64
        Bjvg/ynSUXT5YzhNhM46SSA=
X-Google-Smtp-Source: ABdhPJx+Hto/gPVGwDQsLLDFaeasPm1AX7nIZAOKr1uuX8cjAvq6h5m03VOQe4nfZaztvDsmZMM3nQ==
X-Received: by 2002:a2e:80cc:0:b0:244:ddb5:52b5 with SMTP id r12-20020a2e80cc000000b00244ddb552b5mr2234796ljg.435.1647508034437;
        Thu, 17 Mar 2022 02:07:14 -0700 (PDT)
Received: from wbg (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id j11-20020a056512108b00b004486eef2a63sm392253lfg.194.2022.03.17.02.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 02:07:13 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: Re: [PATCH 2/5] net: bridge: Implement bridge flood flag
In-Reply-To: <20220317065031.3830481-3-mattias.forsblad@gmail.com>
References: <20220317065031.3830481-1-mattias.forsblad@gmail.com> <20220317065031.3830481-3-mattias.forsblad@gmail.com>
Date:   Thu, 17 Mar 2022 10:07:12 +0100
Message-ID: <87r1717xrz.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 07:50, Mattias Forsblad <mattias.forsblad@gmail.com> wrote:
> This patch implements the bridge flood flags. There are three different
> flags matching unicast, multicast and broadcast. When the corresponding
> flag is cleared packets received on bridge ports will not be flooded
> towards the bridge.

If I've not completely misunderstood things, I believe the flood and
mcast_flood flags operate on unknown unicast and multicast.  With that
in mind I think the hot path in br_input.c needs a bit more eyes.  I'll
add my own comments below.

Happy incident I saw this patch set, I have a very similar one for these
flags to the bridge itself, with the intent to improve handling of all
classes of multicast to/from the bridge itself.

> [snip]
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index e0c13fcc50ed..fcb0757bfdcc 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -109,11 +109,12 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  		/* by definition the broadcast is also a multicast address */
>  		if (is_broadcast_ether_addr(eth_hdr(skb)->h_dest)) {
>  			pkt_type = BR_PKT_BROADCAST;
> -			local_rcv = true;
> +			local_rcv = true && br_opt_get(br, BROPT_BCAST_FLOOD);

Minor comment, I believe the preferred style is more like this:

	if (br_opt_get(br, BROPT_BCAST_FLOOD))
        	local_rcv = true;

>  		} else {
>  			pkt_type = BR_PKT_MULTICAST;
> -			if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
> -				goto drop;
> +			if (br_opt_get(br, BROPT_MCAST_FLOOD))
> +				if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
> +					goto drop;

Since the BROPT_MCAST_FLOOD flag should only control uknown multicast,
we cannot bypass the call to br_multicast_rcv(), which helps with the
classifcation.  E.g., we want IGMP/MLD reports to be forwarded to all
router ports, while the mdb lookup (below) is what an tell us if we
have uknown multicast and there we can check the BROPT_MCAST_FLOOD
flag for the bridge itself.

>  		}
>  	}
>  
> @@ -155,9 +156,13 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  			local_rcv = true;
>  			br->dev->stats.multicast++;
>  		}
> +		if (!br_opt_get(br, BROPT_MCAST_FLOOD))
> +			local_rcv = false;

We should never set local_rcv to false, only ever use constructs that
set it to true.  Here the PROMISC flag (above) condition would be
negated, which would be a regression.

Instead, for multicast I believe we should ensure that we reach the
else statement for unknown IP multicast, preventing mcast_hit from
being set, and instead flood unknown multicast using br_flood().

This is a bigger change that involves:

  1) dropping the mrouters_only skb flag for unknown multicast,
     keeping it only for IGMP/MLD reports
  2) extending br_flood() slightly to flood unknown multicast
     also to mcast_router ports

As I mentioned above, I have some patches, including selftests, for
forwarding known/unknown multicast using the mdb and mcast_flood +
mcast_router flags.  Maybe we should combine efforts here somehow?

>  		break;
>  	case BR_PKT_UNICAST:
>  		dst = br_fdb_find_rcu(br, eth_hdr(skb)->h_dest, vid);
> +		if (!br_opt_get(br, BROPT_FLOOD))
> +			local_rcv = false;

Again, never set it to false, invert the check instead, like this:

		if (!dst && br_opt_get(br, BROPT_FLOOD))
			local_rcv = true;

>  		break;
>  	default:
>  		break;
> @@ -166,7 +171,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  	if (dst) {
>  		unsigned long now = jiffies;
>  
> -		if (test_bit(BR_FDB_LOCAL, &dst->flags))
> +		if (test_bit(BR_FDB_LOCAL, &dst->flags) && local_rcv)
>  			return br_pass_frame_up(skb);

I believe this would break both the flooding of unknown multicast and
the PROMISC case.  Down here we are broadcast or known/unknown multicast
land, so the local_rcv flag should be sufficient.

>  		if (now != dst->used)
> @@ -190,6 +195,16 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  }
>  EXPORT_SYMBOL_GPL(br_handle_frame_finish);
>  
> +bool br_flood_enabled(const struct net_device *dev)
> +{
> +	struct net_bridge *br = netdev_priv(dev);
> +
> +	return !!(br_opt_get(br, BROPT_FLOOD) ||
> +		   br_opt_get(br, BROPT_MCAST_FLOOD) ||
> +		   br_opt_get(br, BROPT_BCAST_FLOOD));

Minor nit, don't know what the rest of the list feels about this, but
maybe the BROPT_FLOOD option should be renamed to BR_UCAST_FLOOD or
BR_UNICAST_FLOOD?

Best regards
 /Joachim
