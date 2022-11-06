Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A8761E12C
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 10:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiKFJJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 04:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiKFJJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 04:09:52 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7F8DB0;
        Sun,  6 Nov 2022 01:09:50 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8879F5C00A1;
        Sun,  6 Nov 2022 04:09:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 06 Nov 2022 04:09:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1667725788; x=1667812188; bh=V9M+riJJZ5c0y38qp0ZRfmZOmaLh
        sAfQzSgfFST4nEk=; b=bpYQH/giy5whRoKuKTQjDAlXAZMM4XxYkdD/4afN/1ha
        Tc3rC9tJT1szyvaMfgdJJvWJbbBkj9kDPzSBeap4cNIrRNdsEImdC6ueiIWMtCV4
        8fYp4vNQvqfpzP49oIqbE9Wu2HPPx/kw9gZpo0nkO2mZuv5A4fMgviwyxutKfpdf
        NGXbKzmhnDk92/Y3TVzBU5SysRw/PrNxNkgm/dbRXPfonxJgp1rIrrhI+mXYUWXt
        XuONU+Ne7YWPgKm9YE1B7NRmjeDEHIAq1pPPJ/62YFT99yfsCumesFvyIKRMZwEv
        /GRDP95u7qlqLjne72x2R+oIYFrDD515PPWTdZhEFA==
X-ME-Sender: <xms:3HlnY4Hg_gMnd_EQ0Zxco37pdOd8kdhyScb_Gcd4ZZAiPeV8bhibvg>
    <xme:3HlnYxWZG854vlv-Nb34sopgl45OZuS48zyYDPVuRFcX1jQMe0nG3ZCuX7v24Lnkj
    2mV1htgazxu_CU>
X-ME-Received: <xmr:3HlnYyJkBdreR4_0WevaPfMoJzj1EDaEC_OPYn_8D2yw-a4ZgUyTJXyQtVcF>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvdehgdduvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:3HlnY6Gafbyn8oWDShuDWtn2VjLvxuYXCsOWUlHR-bVje6_zdKkU0Q>
    <xmx:3HlnY-VAF4F6ToCX357NQeME17tkdh2sRv7WWESznLxPHUG2VfcJtQ>
    <xmx:3HlnY9P7NsUgefIQ1C-ZU6g-4Eo7cQBsW_wM73UWwioT6jc9nIsVRQ>
    <xmx:3HlnY5GSIbzSy-OJL7-2JNYwI3vF9QK1E9dM8KLn4Ks-wKU64WmjXg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 6 Nov 2022 04:09:46 -0500 (EST)
Date:   Sun, 6 Nov 2022 11:09:42 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [patch net-next v4 05/13] net: devlink: track netdev with
 devlink_port assigned
Message-ID: <Y2d51izTZV1rThOc@shredder>
References: <20221102160211.662752-1-jiri@resnulli.us>
 <20221102160211.662752-6-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102160211.662752-6-jiri@resnulli.us>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 02, 2022 at 05:02:03PM +0100, Jiri Pirko wrote:
> @@ -9645,10 +9649,13 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
>  
>  	ret = xa_alloc_cyclic(&devlinks, &devlink->index, devlink, xa_limit_31b,
>  			      &last_id, GFP_KERNEL);
> -	if (ret < 0) {
> -		kfree(devlink);
> -		return NULL;
> -	}
> +	if (ret < 0)
> +		goto err_xa_alloc;
> +
> +	devlink->netdevice_nb.notifier_call = devlink_netdevice_event;
> +	ret = register_netdevice_notifier_net(net, &devlink->netdevice_nb);
> +	if (ret)
> +		goto err_register_netdevice_notifier;
>  
>  	devlink->dev = dev;
>  	devlink->ops = ops;
> @@ -9675,6 +9682,12 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
>  	init_completion(&devlink->comp);
>  
>  	return devlink;
> +
> +err_register_netdevice_notifier:
> +	xa_erase(&devlinks, devlink->index);
> +err_xa_alloc:
> +	kfree(devlink);
> +	return NULL;
>  }
>  EXPORT_SYMBOL_GPL(devlink_alloc_ns);
>  
> @@ -9828,6 +9841,10 @@ void devlink_free(struct devlink *devlink)
>  	WARN_ON(!list_empty(&devlink->port_list));
>  
>  	xa_destroy(&devlink->snapshot_ids);
> +
> +	unregister_netdevice_notifier_net(devlink_net(devlink),
> +					  &devlink->netdevice_nb);
> +
>  	xa_erase(&devlinks, devlink->index);
>  
>  	kfree(devlink);

The network namespace of the devlink instance can change throughout the
lifetime of the devlink instance, but the notifier block is always
registered in the initial namespace. This leads to
unregister_netdevice_notifier_net() failing to unregister the notifier
block, which leads to use-after-free. Reproduce (with KASAN enabled):

# echo "10 0" > /sys/bus/netdevsim/new_device
# ip netns add bla
# devlink dev reload netdevsim/netdevsim10 netns bla
# echo 10 > /sys/bus/netdevsim/del_device
# ip link add dummy10 up type dummy

I see two possible solutions:

1. Use register_netdevice_notifier() instead of
register_netdevice_notifier_net().

2. Move the notifier block to the correct namespace in devlink_reload().
