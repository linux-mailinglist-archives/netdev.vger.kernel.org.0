Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7C84E4E16
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 09:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242625AbiCWIWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 04:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242609AbiCWIWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 04:22:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7DF566CA61
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 01:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648023661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vqk26j7GPt6tpaNBmnZBuv0WdpMn55RPsz9Eg2gtLzU=;
        b=aGchXGOr7ktww9sinjp4Mplyx7kMdM3qlZgMNmyQP8MLYzAi7fYM0qtK2s/2GA0zPu8lh5
        ICcE2x7e52j7bLx01Ocw2kt08SHbAzaPCiE0UPJn6/ZuvalxPqlMvxbDmTPaeUeLgCTlDv
        Mwj/+gw20U3OM0S2inHXKChLUhZ3O4I=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-zZaxuu2yP7u6x7nO16PD3A-1; Wed, 23 Mar 2022 04:21:00 -0400
X-MC-Unique: zZaxuu2yP7u6x7nO16PD3A-1
Received: by mail-qk1-f200.google.com with SMTP id v22-20020a05620a0a9600b0067e87a1ff57so516497qkg.14
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 01:21:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Vqk26j7GPt6tpaNBmnZBuv0WdpMn55RPsz9Eg2gtLzU=;
        b=QxYm6PQl+mygYHUmzcq/m9sEhEtERRgeTGMhpnJx+KI9AxU0TBu4929uo3bI97JpUg
         efJhJMRKcDtb3nmiTJamTvA65fGVqmAn52m/kyVUtw1Z9APdGTrXXTQEZipdvljAHy2m
         3vThNWqyHmWkOHMoqtEmqvgoRAwRN9NkCpkmLmEJ7jpXs7ecLAkEp0TY5LUVG9DOsqdm
         w/KaZAaLMO67AC+o5wS7EbcqZYrnAia9MGjc3HeshwB9UBUXbrJiy5K/EARaDTJnLeyO
         3z4kqa3wTmpKN9CMeueeC7+PFfGHcMfxagp+8zh9mPcrphkNwUy5U4AYagBvFWjiPYTv
         P4Eg==
X-Gm-Message-State: AOAM533weQHleTn/mLw60HGgRJY0845Uq5m9cgqUr3kQ1mosu2/w0DuU
        os0Pl6sg2yYu0vOkmZp55HMOoG06nigOcl5X3S7wM3iX5c8+V59xb4Uq0yNcAqo8Sy0U93T58Qc
        YZGb7q4/64fLJnpay
X-Received: by 2002:a37:a18c:0:b0:67b:2d46:4db5 with SMTP id k134-20020a37a18c000000b0067b2d464db5mr17764226qke.67.1648023659489;
        Wed, 23 Mar 2022 01:20:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4n3qE43FHHavcLRTxT+2AkpO+gQUIrIWi2gkLhhFoTbdr0vHSfrSar769ZcLk0WlsulDPDw==
X-Received: by 2002:a37:a18c:0:b0:67b:2d46:4db5 with SMTP id k134-20020a37a18c000000b0067b2d464db5mr17764214qke.67.1648023659177;
        Wed, 23 Mar 2022 01:20:59 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-135.dyn.eolo.it. [146.241.232.135])
        by smtp.gmail.com with ESMTPSA id z15-20020a05622a060f00b002e2070bf899sm9937266qta.90.2022.03.23.01.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 01:20:58 -0700 (PDT)
Message-ID: <2ef6b0571179c75636830bd9810a777d197738f4.camel@redhat.com>
Subject: Re: [PATCH] ipv6: fix locking issues with loops over idev->addr_list
From:   Paolo Abeni <pabeni@redhat.com>
To:     Niels Dossche <dossche.niels@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Wed, 23 Mar 2022 09:20:55 +0100
In-Reply-To: <20220322213406.55977-1-dossche.niels@gmail.com>
References: <20220322213406.55977-1-dossche.niels@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-03-22 at 22:34 +0100, Niels Dossche wrote:
> idev->addr_list needs to be protected by idev->lock. However, it is not
> always possible to do so while iterating and performing actions on
> inet6_ifaddr instances. For example, multiple functions (like
> addrconf_{join,leave}_anycast) eventually call down to other functions
> that acquire the idev->lock. The current code temporarily unlocked the
> idev->lock during the loops, which can cause race conditions. Moving the
> locks up is also not an appropriate solution as the ordering of lock
> acquisition will be inconsistent with for example mc_lock.
> 
> This solution adds an additional field to inet6_ifaddr that is used
> to temporarily add the instances to a temporary list while holding
> idev->lock. The temporary list can then be traversed without holding
> idev->lock. This change was done in two places. In addrconf_ifdown, the
> list_for_each_entry_safe variant of the list loop is also no longer
> necessary as there is no deletion within that specific loop.
> 
> The remaining loop in addrconf_ifdown that unlocks idev->lock in its
> loop body is of no issue. This is because that loop always gets the
> first entry and performs the delete and condition check under the
> idev->lock.
> 
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
> ---
> 
> This was previously discussed in the mailing thread of
> [PATCH v2] ipv6: acquire write lock for addr_list in dev_forward_change
> 
>  include/net/if_inet6.h |  7 +++++++
>  net/ipv6/addrconf.c    | 29 +++++++++++++++++++++++------
>  2 files changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
> index f026cf08a8e8..a17f29f75e9a 100644
> --- a/include/net/if_inet6.h
> +++ b/include/net/if_inet6.h
> @@ -64,6 +64,13 @@ struct inet6_ifaddr {
>  
>  	struct hlist_node	addr_lst;
>  	struct list_head	if_list;
> +	/*
> +	 * Used to safely traverse idev->addr_list in process context
> +	 * if the idev->lock needed to protect idev->addr_list cannot be held.
> +	 * In that case, add the items to this list temporarily and iterate
> +	 * without holding idev->lock. See addrconf_ifdown and dev_forward_change.
> +	 */
> +	struct list_head	if_list_aux;
>  
>  	struct list_head	tmp_list;
>  	struct inet6_ifaddr	*ifpub;
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index f908e2fd30b2..72790d1934c7 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -800,6 +800,7 @@ static void dev_forward_change(struct inet6_dev *idev)
>  {
>  	struct net_device *dev;
>  	struct inet6_ifaddr *ifa;
> +	LIST_HEAD(tmp_addr_list);
>  
>  	if (!idev)
>  		return;
> @@ -818,14 +819,23 @@ static void dev_forward_change(struct inet6_dev *idev)
>  		}
>  	}
>  
> +	read_lock_bh(&idev->lock);
>  	list_for_each_entry(ifa, &idev->addr_list, if_list) {
>  		if (ifa->flags&IFA_F_TENTATIVE)
>  			continue;
> +		list_add_tail(&ifa->if_list_aux, &tmp_addr_list);
> +	}
> +	read_unlock_bh(&idev->lock);
> +
> +	while (!list_empty(&tmp_addr_list)) {
> +		ifa = list_first_entry(&tmp_addr_list, struct inet6_ifaddr, if_list_aux);
> +		list_del(&ifa->if_list_aux);
>  		if (idev->cnf.forwarding)
>  			addrconf_join_anycast(ifa);
>  		else
>  			addrconf_leave_anycast(ifa);
>  	}
> +
>  	inet6_netconf_notify_devconf(dev_net(dev), RTM_NEWNETCONF,
>  				     NETCONFA_FORWARDING,
>  				     dev->ifindex, &idev->cnf);
> @@ -3730,10 +3740,11 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
>  	unsigned long event = unregister ? NETDEV_UNREGISTER : NETDEV_DOWN;
>  	struct net *net = dev_net(dev);
>  	struct inet6_dev *idev;
> -	struct inet6_ifaddr *ifa, *tmp;
> +	struct inet6_ifaddr *ifa;
>  	bool keep_addr = false;
>  	bool was_ready;
>  	int state, i;
> +	LIST_HEAD(tmp_addr_list);

Very minot nit: I guess it's better to try to enforce the reverse x-mas
tree order for newly added variables - that is: this declaration should
me moved up, just after 'ifa'.

>  	ASSERT_RTNL();
>  
> @@ -3822,16 +3833,23 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
>  		write_lock_bh(&idev->lock);
>  	}
>  
> -	list_for_each_entry_safe(ifa, tmp, &idev->addr_list, if_list) {
> +	list_for_each_entry(ifa, &idev->addr_list, if_list) {
> +		list_add_tail(&ifa->if_list_aux, &tmp_addr_list);
> +	}


Other minor nit: the braces are not required here.

Otherwise LGTM:

Acked-by: Paolo Abeni <pabeni@redhat.com>

However this looks like net-next material, and we are in the merge
window right now. I think you should re-post in (slighly less) than 2w.
Please add the target tree into the subj.

Side note: AFAICS after this patch, there is still the suspicious
tempaddr_list usage in addrconf_ifdown to be handled.

Cheers,

Paolo

