Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B064B6D9E
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 14:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbiBONfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 08:35:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiBONfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 08:35:15 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7BF106CAA;
        Tue, 15 Feb 2022 05:35:05 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DFBE05C02F4;
        Tue, 15 Feb 2022 08:35:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 15 Feb 2022 08:35:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=MqEd8VO3pWd8SQKjx
        AoofoUTvP3sevVVpQLDzXC7wFE=; b=Pz+oyQxsNY3rMYGN2rUE8Q/ggVHBOL389
        VPPg6q4vxv1/NB5s1IFK6IvK2F+gN0mYWxciGiORo9QCBfL0QKdQYw8zpwcLA/Rm
        ylmUHvu1g2dUrtWoV+1lgT7RRyTZQ6azCc9MdwAHuZ2wc2cf+kHZUa7mTSBFp+GR
        QsPA1yuwLoOjlRAtIGlBJ77vnBKyhZjXKLdDhOq4hnyWxikoK+2Gt629AWMdWIpM
        0eYF6pV/gVz+TWla6ocFX0uQmny1P6BLnzxpoYsrgC8UPFQglhULmRvQgznaKB8z
        SFDnWqphhZyOYmCap08dwCoA1V+6OIdYcfiMgqv6g6xVbGJ1V2t3A==
X-ME-Sender: <xms:BawLYo8EBx_jRMog3T9Tku2muQqLbSNNt3FaxQgq6Z32GDmK9IeyHQ>
    <xme:BawLYguH3wH-v6UxtDi3bkVE50PY2g_2vfnubMsL1-wx8h5Yy376Mxcg5N4ozyjXZ
    ZMns7PWJcvytao>
X-ME-Received: <xmr:BawLYuC5BJ9tjNWxVBJ23BRLkX5_SwV-0M8RuAR7BjDtYnMPkhrIEB3hFQh4hKm3J9z9A-VkM7qFZx6nvp5Q2fg9T5g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjeeggdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:BawLYofQZdPdGm9tAINYRMvAUBRKNSvuje8rRXxQ9TbLCN3NgZV8Hg>
    <xmx:BawLYtPXagadaZzZEWEehaICbtHMD-Xy9X1A4EkV7QwoKbzH9QNe9w>
    <xmx:BawLYikT0Cq0yQdHvAXwiXov_1cLxd37o7hPC6WdCx-kTpTSIDn0YA>
    <xmx:BawLYg0LCk-IXsQ-uwquKCqS1k7Lqc-586uGuwIyXndR2B10mq-Ekg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Feb 2022 08:35:00 -0500 (EST)
Date:   Tue, 15 Feb 2022 15:34:56 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bridge: multicast: notify switchdev driver whenever
 MC processing gets disabled
Message-ID: <YgusADHmOIwQiI3a@shredder>
References: <20220211131426.5433-1-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211131426.5433-1-oleksandr.mazur@plvision.eu>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 03:14:26PM +0200, Oleksandr Mazur wrote:
> Whenever bridge driver hits the max capacity of MDBs, it disables
> the MC processing (by setting corresponding bridge option), but never
> notifies switchdev about such change (the notifiers are called only upon
> explicit setting of this option, through the registered netlink interface).
> 
> This could lead to situation when Software MDB processing gets disabled,
> but this event never gets offloaded to the underlying Hardware.
> 
> Fix this by adding a notify message in such case.
> 
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> ---
>  net/bridge/br_multicast.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index de2409889489..d53c08906bc8 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -82,6 +82,9 @@ static void br_multicast_find_del_pg(struct net_bridge *br,
>  				     struct net_bridge_port_group *pg);
>  static void __br_multicast_stop(struct net_bridge_mcast *brmctx);
>  
> +static int br_mc_disabled_update(struct net_device *dev, bool value,
> +				 struct netlink_ext_ack *extack);
> +
>  static struct net_bridge_port_group *
>  br_sg_port_find(struct net_bridge *br,
>  		struct net_bridge_port_group_sg_key *sg_p)
> @@ -1156,6 +1159,8 @@ struct net_bridge_mdb_entry *br_multicast_new_group(struct net_bridge *br,
>  		return mp;
>  
>  	if (atomic_read(&br->mdb_hash_tbl.nelems) >= br->hash_max) {
> +		err = br_mc_disabled_update(br->dev, false, NULL);
> +		WARN_ON(err && err != -EOPNOTSUPP);

What is the purpose of the WARN_ON()? There are a lot of operations that
can fail in rollback paths, but we never WARN_ON() there

I suggest:

br_mc_disabled_update(br->dev, false, NULL);

>  		br_opt_toggle(br, BROPT_MULTICAST_ENABLED, false);
>  		return ERR_PTR(-E2BIG);
>  	}
> -- 
> 2.17.1
> 
