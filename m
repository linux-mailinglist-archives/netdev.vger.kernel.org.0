Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4766E4D4C4D
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237026AbiCJOym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237951AbiCJOoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:44:02 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752AE13AA35
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:42:55 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id u7so7987194ljk.13
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oX+0+0DrmOoX0UExiTkiHRjD/PO3ZH5Ft00ctb+zEKI=;
        b=BPRxLuF7n9XtXKwdeuqh95S7kLErSQclSFQdNbqGbFJzJDWmH3Wb/7tEyV1xG95wMw
         3kfJn51SgR+rTE1KpBjnUHqhhPoUXLJkWK+2Sf6IzO+SXdPbgjlz4oTP4PumMIuY1Kh9
         82W408Q+3DHPUpvvBOA94keBEAhpUUShpbH0B+Pc+PJD2Ftg49ukCTKAiwNEOvfhD/Lf
         0TMEKTsBipQwuvdQH7hRdmkTpVhg84LKl76WgqErn7VycOpPuBNIXbyTdgEBwpCnlBB1
         VmWf2fE/wBz0r3YFwYTUg3Bg7BE2NJX8UgNpaxHiC/UtDM0JXF4h6uIS0ZkI0vC+k1zS
         cKeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oX+0+0DrmOoX0UExiTkiHRjD/PO3ZH5Ft00ctb+zEKI=;
        b=BX67FwOxXnHBsBNMrhb95scnkbwkJNhjO6QIy7ozoD8LizYuiazgeRieXPsdatSHks
         mAHG1EkI6ikFQZHzMc2i4nKynVeEf+rnokbaSNtykVS7Y0On+KnxrgJWONII4naNzsBu
         Tl+W5dekQM3o4KxJG/UheaLGDqm0EIFs6HAjsAqxvm0UB+Tw3ECY04mw/bPl7DGK8Yfe
         cbPD3uZXl74aVn6NNh/tNhY9VCBA5vcVH/aMC1po6cm1Xxt/aD93QHNlNP6P9+uHekyL
         KWql+WSQkl0CJxEtjtO5tJ+nIr1skPZA1M/Win5727SUaqtAdj06XutC2iLkmJpHM7cS
         KaQQ==
X-Gm-Message-State: AOAM531j0ke4TO5aWXBfTm+CLGFgPn2JrQNqRpkBPNtkxwxguHR0V029
        W/SUBxdH6KHRLjAMKwtdGVDrIA==
X-Google-Smtp-Source: ABdhPJzP722lajsvMrc+HnxWeW8vAyZEGMHRiNsgRflMATS3Pym4yKLaKJpYUjtyELBKGe+n4wy8BQ==
X-Received: by 2002:a2e:8745:0:b0:248:600:6649 with SMTP id q5-20020a2e8745000000b0024806006649mr3207422ljj.63.1646923373450;
        Thu, 10 Mar 2022 06:42:53 -0800 (PST)
Received: from [192.168.51.243] ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id t2-20020a2e2d02000000b00244dc8ba5absm1100714ljt.117.2022.03.10.06.42.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 06:42:53 -0800 (PST)
Message-ID: <0eeaf59f-e7eb-7439-3c0a-17e7ac6741f0@blackwall.org>
Date:   Thu, 10 Mar 2022 16:42:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 1/3] net: bridge: add fdb flag to extent locked
 port feature
Content-Language: en-US
To:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
 <20220310142320.611738-2-schultz.hans+netdev@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220310142320.611738-2-schultz.hans+netdev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/03/2022 16:23, Hans Schultz wrote:
> Add an intermediate state for clients behind a locked port to allow for
> possible opening of the port for said clients. This feature corresponds
> to the Mac-Auth and MAC Authentication Bypass (MAB) named features. The
> latter defined by Cisco.
> 
> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
> ---
>   include/uapi/linux/neighbour.h |  1 +
>   net/bridge/br_fdb.c            |  6 ++++++
>   net/bridge/br_input.c          | 11 ++++++++++-
>   net/bridge/br_private.h        |  3 ++-
>   4 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> index db05fb55055e..83115a592d58 100644
> --- a/include/uapi/linux/neighbour.h
> +++ b/include/uapi/linux/neighbour.h
> @@ -208,6 +208,7 @@ enum {
>   	NFEA_UNSPEC,
>   	NFEA_ACTIVITY_NOTIFY,
>   	NFEA_DONT_REFRESH,
> +	NFEA_LOCKED,
>   	__NFEA_MAX
>   };

Hmm, can you use NDA_FLAGS_EXT instead ?
That should simplify things and reduce the nl size.

>   #define NFEA_MAX (__NFEA_MAX - 1)
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index 6ccda68bd473..396dcf3084cf 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -105,6 +105,7 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
>   	struct nda_cacheinfo ci;
>   	struct nlmsghdr *nlh;
>   	struct ndmsg *ndm;
> +	u8 ext_flags = 0;
>   
>   	nlh = nlmsg_put(skb, portid, seq, type, sizeof(*ndm), flags);
>   	if (nlh == NULL)
> @@ -125,11 +126,16 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
>   		ndm->ndm_flags |= NTF_EXT_LEARNED;
>   	if (test_bit(BR_FDB_STICKY, &fdb->flags))
>   		ndm->ndm_flags |= NTF_STICKY;
> +	if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags))
> +		ext_flags |= 1 << NFEA_LOCKED;
>   
>   	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->key.addr))
>   		goto nla_put_failure;
>   	if (nla_put_u32(skb, NDA_MASTER, br->dev->ifindex))
>   		goto nla_put_failure;
> +	if (nla_put_u8(skb, NDA_FDB_EXT_ATTRS, ext_flags))
> +		goto nla_put_failure;
> +
>   	ci.ndm_used	 = jiffies_to_clock_t(now - fdb->used);
>   	ci.ndm_confirmed = 0;
>   	ci.ndm_updated	 = jiffies_to_clock_t(now - fdb->updated);
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index e0c13fcc50ed..897908484b18 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -75,6 +75,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>   	struct net_bridge_mcast *brmctx;
>   	struct net_bridge_vlan *vlan;
>   	struct net_bridge *br;
> +	unsigned long flags = 0;

Please move this below...

>   	u16 vid = 0;
>   	u8 state;
>   
> @@ -94,8 +95,16 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>   			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
>   
>   		if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
> -		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
> +		    test_bit(BR_FDB_LOCAL, &fdb_src->flags)) {
> +			if (!fdb_src) {

... here where it's only used.

> +				set_bit(BR_FDB_ENTRY_LOCKED, &flags);
> +				br_fdb_update(br, p, eth_hdr(skb)->h_source, vid, flags);
> +			}
>   			goto drop;
> +		} else {
> +			if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb_src->flags))
> +				goto drop;
> +		}
>   	}
>   
>   	nbp_switchdev_frame_mark(p, skb);
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 48bc61ebc211..f5a0b68c4857 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -248,7 +248,8 @@ enum {
>   	BR_FDB_ADDED_BY_EXT_LEARN,
>   	BR_FDB_OFFLOADED,
>   	BR_FDB_NOTIFY,
> -	BR_FDB_NOTIFY_INACTIVE
> +	BR_FDB_NOTIFY_INACTIVE,
> +	BR_FDB_ENTRY_LOCKED,
>   };
>   
>   struct net_bridge_fdb_key {

