Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3BC96362F0
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238494AbiKWPK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238173AbiKWPKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:10:02 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350AD64A1D
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:10:00 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id q186so19287339oia.9
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ExnGTVMMNiFtze7Bd8iEwyGOgzukqiGGWc1bustV60E=;
        b=a3SiHT+Too49ktyQRM1ViyOYggGH9usf1XTtbjW2sQ1yguUcDXNivSP0SWu7IqiyAj
         3kltyXLIQVXAguEQrv9N7fB2HLl8sVH1czgxwe807umSIxEYoBPRKIlGkuZGUdkadOF6
         sOjBPHey4LFK6n29qUDzRFp5CbGXlUwwGtNDyR9OlmLmHcuPvKrMeOgYfkgofOVByS87
         LBtSoOGCg+wN/zSTk8dWT1bSrM/ZYPflu/UK9jEgQZ7lruLZuDWwCz4N3x/Y8UxDcsLA
         /Y/pbOIwUbkiHg5eXkx3YPrXyfOrAW6Y9E0wRMLCS6+WoRovY3OTVjTtbKI1JjR8mahg
         EpMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ExnGTVMMNiFtze7Bd8iEwyGOgzukqiGGWc1bustV60E=;
        b=V8EPzuMqYunU6CN6rv4i9WBbH9CRroKhtIMwADKyygPcgSmJ0bEsL6XMeBcL9jMzHn
         /yhROVT7F7kQR8qmc6DN1DxoywMtwmwaHZod7R2RkdV3+Ooq/rHF4AsciwWyXVRQSS6H
         xDc225qB049HyhjSg86NfoRBl+LXUjLSYKF39pDA9cpiQZaq1xC/5MsnU+BdLVIDCPGr
         Rbovel5zA54NPySDITxaa3+MLRwdYtEg4ufynd1j4SYBPwuXQNeV1WbiUoG6ZsSov6v+
         Nfd2EvgtKlo77xPNMnkxjlG3zVGiD9us99HdJbubYEh3v7xzibeEgNi6QVDz2vVCdwYc
         1R6Q==
X-Gm-Message-State: ANoB5pn6mDi+jldcJTnh1onfaFXiuHxTHb9TkBF7hHjkN0teYgbUZPr2
        KExU5SiUM4r/zSy2KnglmQI=
X-Google-Smtp-Source: AA0mqf7UcM6xqsrVDUI0AWXTESbqWrWkLr7AK6t+Z5tnWwgrXdwdLB+TlvbXXiGNe6mGh146uqahjw==
X-Received: by 2002:a05:6808:199:b0:359:dc34:5b51 with SMTP id w25-20020a056808019900b00359dc345b51mr4228837oic.292.1669216198560;
        Wed, 23 Nov 2022 07:09:58 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:5412:fa8e:2d33:bd7c:54c7])
        by smtp.gmail.com with ESMTPSA id m33-20020a4a9524000000b0049faebecee2sm6242697ooi.35.2022.11.23.07.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 07:09:57 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id AF4D6459CCB; Wed, 23 Nov 2022 12:09:55 -0300 (-03)
Date:   Wed, 23 Nov 2022 12:09:55 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org, davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCHv2 net-next 5/5] net: move the nat function to nf_nat_ovs
 for ovs and tc
Message-ID: <Y343wyO20XUvwuvg@t14s.localdomain>
References: <cover.1669138256.git.lucien.xin@gmail.com>
 <bf19487f4dfc8cd91a4395672d9905b10917128d.1669138256.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf19487f4dfc8cd91a4395672d9905b10917128d.1669138256.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 12:32:21PM -0500, Xin Long wrote:
> +int nf_ct_nat(struct sk_buff *skb, struct nf_conn *ct,
> +	      enum ip_conntrack_info ctinfo, int *action,
> +	      const struct nf_nat_range2 *range, bool commit)
> +{
> +	enum nf_nat_manip_type maniptype;
> +	int err, ct_action = *action;
> +
> +	*action = 0;
> +
> +	/* Add NAT extension if not confirmed yet. */
> +	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
> +		return NF_ACCEPT;   /* Can't NAT. */
> +
> +	if (ctinfo != IP_CT_NEW && (ct->status & IPS_NAT_MASK) &&
> +	    (ctinfo != IP_CT_RELATED || commit)) {
> +		/* NAT an established or related connection like before. */
> +		if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
> +			/* This is the REPLY direction for a connection
> +			 * for which NAT was applied in the forward
> +			 * direction.  Do the reverse NAT.
> +			 */
> +			maniptype = ct->status & IPS_SRC_NAT
> +				? NF_NAT_MANIP_DST : NF_NAT_MANIP_SRC;
> +		else
> +			maniptype = ct->status & IPS_SRC_NAT
> +				? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST;
> +	} else if (ct_action & (1 << NF_NAT_MANIP_SRC)) {
> +		maniptype = NF_NAT_MANIP_SRC;
> +	} else if (ct_action & (1 << NF_NAT_MANIP_DST)) {
> +		maniptype = NF_NAT_MANIP_DST;
> +	} else {
> +		return NF_ACCEPT;
> +	}
> +
> +	err = nf_ct_nat_execute(skb, ct, ctinfo, action, range, maniptype);
> +	if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
> +		if (ct->status & IPS_SRC_NAT) {
> +			if (maniptype == NF_NAT_MANIP_SRC)
> +				maniptype = NF_NAT_MANIP_DST;
> +			else
> +				maniptype = NF_NAT_MANIP_SRC;
> +
> +			err = nf_ct_nat_execute(skb, ct, ctinfo, action, range,
> +						maniptype);
> +		} else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
> +			err = nf_ct_nat_execute(skb, ct, ctinfo, action, NULL,
> +						NF_NAT_MANIP_SRC);
> +		}
> +	}
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(nf_ct_nat);
> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index cc643a556ea1..d03c75165663 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -726,144 +726,27 @@ static void ovs_nat_update_key(struct sw_flow_key *key,
>  	}
>  }
>  
> -/* Modelled after nf_nat_ipv[46]_fn().
> - * range is only used for new, uninitialized NAT state.
> - * Returns either NF_ACCEPT or NF_DROP.
> - */
> -static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
> -			      enum ip_conntrack_info ctinfo,
> -			      const struct nf_nat_range2 *range,
> -			      enum nf_nat_manip_type maniptype, struct sw_flow_key *key)
> -{
> -	int hooknum, err = NF_ACCEPT;
> -
> -	/* See HOOK2MANIP(). */
> -	if (maniptype == NF_NAT_MANIP_SRC)
> -		hooknum = NF_INET_LOCAL_IN; /* Source NAT */
> -	else
> -		hooknum = NF_INET_LOCAL_OUT; /* Destination NAT */
> -
> -	switch (ctinfo) {
> -	case IP_CT_RELATED:
> -	case IP_CT_RELATED_REPLY:
> -		if (IS_ENABLED(CONFIG_NF_NAT) &&
> -		    skb->protocol == htons(ETH_P_IP) &&
> -		    ip_hdr(skb)->protocol == IPPROTO_ICMP) {
> -			if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
> -							   hooknum))
> -				err = NF_DROP;
> -			goto out;
> -		} else if (IS_ENABLED(CONFIG_IPV6) &&
> -			   skb->protocol == htons(ETH_P_IPV6)) {
> -			__be16 frag_off;
> -			u8 nexthdr = ipv6_hdr(skb)->nexthdr;
> -			int hdrlen = ipv6_skip_exthdr(skb,
> -						      sizeof(struct ipv6hdr),
> -						      &nexthdr, &frag_off);
> -
> -			if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
> -				if (!nf_nat_icmpv6_reply_translation(skb, ct,
> -								     ctinfo,
> -								     hooknum,
> -								     hdrlen))
> -					err = NF_DROP;
> -				goto out;
> -			}
> -		}
> -		/* Non-ICMP, fall thru to initialize if needed. */
> -		fallthrough;
> -	case IP_CT_NEW:
> -		/* Seen it before?  This can happen for loopback, retrans,
> -		 * or local packets.
> -		 */
> -		if (!nf_nat_initialized(ct, maniptype)) {
> -			/* Initialize according to the NAT action. */
> -			err = (range && range->flags & NF_NAT_RANGE_MAP_IPS)
> -				/* Action is set up to establish a new
> -				 * mapping.
> -				 */
> -				? nf_nat_setup_info(ct, range, maniptype)
> -				: nf_nat_alloc_null_binding(ct, hooknum);
> -			if (err != NF_ACCEPT)
> -				goto out;
> -		}
> -		break;
> -
> -	case IP_CT_ESTABLISHED:
> -	case IP_CT_ESTABLISHED_REPLY:
> -		break;
> -
> -	default:
> -		err = NF_DROP;
> -		goto out;
> -	}
> -
> -	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
> -out:
> -	/* Update the flow key if NAT successful. */
> -	if (err == NF_ACCEPT)
> -		ovs_nat_update_key(key, skb, maniptype);
> -
> -	return err;
> -}
> -
>  /* Returns NF_DROP if the packet should be dropped, NF_ACCEPT otherwise. */
>  static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
>  		      const struct ovs_conntrack_info *info,
>  		      struct sk_buff *skb, struct nf_conn *ct,
>  		      enum ip_conntrack_info ctinfo)
>  {
> -	enum nf_nat_manip_type maniptype;
> -	int err;
> +	int err, action = 0;
>  
>  	if (!(info->nat & OVS_CT_NAT))
>  		return NF_ACCEPT;
> +	if (info->nat & OVS_CT_SRC_NAT)
> +		action |= (1 << NF_NAT_MANIP_SRC);
> +	if (info->nat & OVS_CT_DST_NAT)
> +		action |= (1 << NF_NAT_MANIP_DST);

I'm wondering why this dance at this level with supporting multiple
MANIPs while actually only one can be used at a time.

act_ct will reject an action using both:
        if ((p->ct_action & TCA_CT_ACT_NAT_SRC) &&
            (p->ct_action & TCA_CT_ACT_NAT_DST)) {
                NL_SET_ERR_MSG_MOD(extack, "dnat and snat can't be enabled at the same time");
                return -EOPNOTSUPP;

I couldn't find this kind of check in ovs code right now (didn't look much, I
confess :)), but even the code here was already doing:

-	} else if (info->nat & OVS_CT_SRC_NAT) {
-		maniptype = NF_NAT_MANIP_SRC;
-	} else if (info->nat & OVS_CT_DST_NAT) {
-		maniptype = NF_NAT_MANIP_DST;

And in case of tuple conflict, maniptype will be forcibly updated in
[*] below.

Anyhow, if really needed, it would be nice to use BIT(NF_NAT_MANIP_..)
instead.

>  
> -	/* Add NAT extension if not confirmed yet. */
> -	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
> -		return NF_ACCEPT;   /* Can't NAT. */
> +	err = nf_ct_nat(skb, ct, ctinfo, &action, &info->range, info->commit);
>  
> -	/* Determine NAT type.
> -	 * Check if the NAT type can be deduced from the tracked connection.
> -	 * Make sure new expected connections (IP_CT_RELATED) are NATted only
> -	 * when committing.
> -	 */
> -	if (ctinfo != IP_CT_NEW && ct->status & IPS_NAT_MASK &&
> -	    (ctinfo != IP_CT_RELATED || info->commit)) {
> -		/* NAT an established or related connection like before. */
> -		if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
> -			/* This is the REPLY direction for a connection
> -			 * for which NAT was applied in the forward
> -			 * direction.  Do the reverse NAT.
> -			 */
> -			maniptype = ct->status & IPS_SRC_NAT
> -				? NF_NAT_MANIP_DST : NF_NAT_MANIP_SRC;
> -		else
> -			maniptype = ct->status & IPS_SRC_NAT
> -				? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST;
> -	} else if (info->nat & OVS_CT_SRC_NAT) {
> -		maniptype = NF_NAT_MANIP_SRC;
> -	} else if (info->nat & OVS_CT_DST_NAT) {
> -		maniptype = NF_NAT_MANIP_DST;
> -	} else {
> -		return NF_ACCEPT; /* Connection is not NATed. */
> -	}
> -	err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype, key);
> -
> -	if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
> -		if (ct->status & IPS_SRC_NAT) {
> -			if (maniptype == NF_NAT_MANIP_SRC)
> -				maniptype = NF_NAT_MANIP_DST;
> -			else
> -				maniptype = NF_NAT_MANIP_SRC;

[*]

> -
> -			err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range,
> -						 maniptype, key);
> -		} else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
> -			err = ovs_ct_nat_execute(skb, ct, ctinfo, NULL,
> -						 NF_NAT_MANIP_SRC, key);
> -		}
> -	}
> +	if (action & (1 << NF_NAT_MANIP_SRC))
> +		ovs_nat_update_key(key, skb, NF_NAT_MANIP_SRC);
> +	if (action & (1 << NF_NAT_MANIP_DST))
> +		ovs_nat_update_key(key, skb, NF_NAT_MANIP_DST);
>  
>  	return err;
>  }
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index c7782c9a6ab6..0c410220239f 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -863,90 +863,6 @@ static void tcf_ct_params_free_rcu(struct rcu_head *head)
>  	tcf_ct_params_free(params);
>  }
>  
> -#if IS_ENABLED(CONFIG_NF_NAT)
> -/* Modelled after nf_nat_ipv[46]_fn().
> - * range is only used for new, uninitialized NAT state.
> - * Returns either NF_ACCEPT or NF_DROP.
> - */
> -static int ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
> -			  enum ip_conntrack_info ctinfo,
> -			  const struct nf_nat_range2 *range,
> -			  enum nf_nat_manip_type maniptype)
> -{
> -	__be16 proto = skb_protocol(skb, true);
> -	int hooknum, err = NF_ACCEPT;
> -
> -	/* See HOOK2MANIP(). */
> -	if (maniptype == NF_NAT_MANIP_SRC)
> -		hooknum = NF_INET_LOCAL_IN; /* Source NAT */
> -	else
> -		hooknum = NF_INET_LOCAL_OUT; /* Destination NAT */
> -
> -	switch (ctinfo) {
> -	case IP_CT_RELATED:
> -	case IP_CT_RELATED_REPLY:
> -		if (proto == htons(ETH_P_IP) &&
> -		    ip_hdr(skb)->protocol == IPPROTO_ICMP) {
> -			if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
> -							   hooknum))
> -				err = NF_DROP;
> -			goto out;
> -		} else if (IS_ENABLED(CONFIG_IPV6) && proto == htons(ETH_P_IPV6)) {
> -			__be16 frag_off;
> -			u8 nexthdr = ipv6_hdr(skb)->nexthdr;
> -			int hdrlen = ipv6_skip_exthdr(skb,
> -						      sizeof(struct ipv6hdr),
> -						      &nexthdr, &frag_off);
> -
> -			if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
> -				if (!nf_nat_icmpv6_reply_translation(skb, ct,
> -								     ctinfo,
> -								     hooknum,
> -								     hdrlen))
> -					err = NF_DROP;
> -				goto out;
> -			}
> -		}
> -		/* Non-ICMP, fall thru to initialize if needed. */
> -		fallthrough;
> -	case IP_CT_NEW:
> -		/* Seen it before?  This can happen for loopback, retrans,
> -		 * or local packets.
> -		 */
> -		if (!nf_nat_initialized(ct, maniptype)) {
> -			/* Initialize according to the NAT action. */
> -			err = (range && range->flags & NF_NAT_RANGE_MAP_IPS)
> -				/* Action is set up to establish a new
> -				 * mapping.
> -				 */
> -				? nf_nat_setup_info(ct, range, maniptype)
> -				: nf_nat_alloc_null_binding(ct, hooknum);
> -			if (err != NF_ACCEPT)
> -				goto out;
> -		}
> -		break;
> -
> -	case IP_CT_ESTABLISHED:
> -	case IP_CT_ESTABLISHED_REPLY:
> -		break;
> -
> -	default:
> -		err = NF_DROP;
> -		goto out;
> -	}
> -
> -	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
> -out:
> -	if (err == NF_ACCEPT) {
> -		if (maniptype == NF_NAT_MANIP_SRC)
> -			tc_skb_cb(skb)->post_ct_snat = 1;
> -		if (maniptype == NF_NAT_MANIP_DST)
> -			tc_skb_cb(skb)->post_ct_dnat = 1;
> -	}
> -	return err;
> -}
> -#endif /* CONFIG_NF_NAT */
> -
>  static void tcf_ct_act_set_mark(struct nf_conn *ct, u32 mark, u32 mask)
>  {
>  #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
> @@ -986,52 +902,22 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
>  			  bool commit)
>  {
>  #if IS_ENABLED(CONFIG_NF_NAT)
> -	int err;
> -	enum nf_nat_manip_type maniptype;
> +	int err, action = 0;
>  
>  	if (!(ct_action & TCA_CT_ACT_NAT))
>  		return NF_ACCEPT;
> +	if (ct_action & TCA_CT_ACT_NAT_SRC)
> +		action |= (1 << NF_NAT_MANIP_SRC);
> +	if (ct_action & TCA_CT_ACT_NAT_DST)
> +		action |= (1 << NF_NAT_MANIP_DST);
>  
> -	/* Add NAT extension if not confirmed yet. */
> -	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
> -		return NF_ACCEPT;   /* Can't NAT. */
> -
> -	if (ctinfo != IP_CT_NEW && (ct->status & IPS_NAT_MASK) &&
> -	    (ctinfo != IP_CT_RELATED || commit)) {
> -		/* NAT an established or related connection like before. */
> -		if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
> -			/* This is the REPLY direction for a connection
> -			 * for which NAT was applied in the forward
> -			 * direction.  Do the reverse NAT.
> -			 */
> -			maniptype = ct->status & IPS_SRC_NAT
> -				? NF_NAT_MANIP_DST : NF_NAT_MANIP_SRC;
> -		else
> -			maniptype = ct->status & IPS_SRC_NAT
> -				? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST;
> -	} else if (ct_action & TCA_CT_ACT_NAT_SRC) {
> -		maniptype = NF_NAT_MANIP_SRC;
> -	} else if (ct_action & TCA_CT_ACT_NAT_DST) {
> -		maniptype = NF_NAT_MANIP_DST;
> -	} else {
> -		return NF_ACCEPT;
> -	}
> +	err = nf_ct_nat(skb, ct, ctinfo, &action, range, commit);
> +
> +	if (action & (1 << NF_NAT_MANIP_SRC))
> +		tc_skb_cb(skb)->post_ct_snat = 1;
> +	if (action & (1 << NF_NAT_MANIP_DST))
> +		tc_skb_cb(skb)->post_ct_dnat = 1;
>  
> -	err = ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> -	if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
> -		if (ct->status & IPS_SRC_NAT) {
> -			if (maniptype == NF_NAT_MANIP_SRC)
> -				maniptype = NF_NAT_MANIP_DST;
> -			else
> -				maniptype = NF_NAT_MANIP_SRC;
> -
> -			err = ct_nat_execute(skb, ct, ctinfo, range,
> -					     maniptype);
> -		} else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
> -			err = ct_nat_execute(skb, ct, ctinfo, NULL,
> -					     NF_NAT_MANIP_SRC);
> -		}
> -	}
>  	return err;
>  #else
>  	return NF_ACCEPT;
> -- 
> 2.31.1
> 
