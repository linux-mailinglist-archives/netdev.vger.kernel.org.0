Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1EB261FA8F
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 17:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbiKGQw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 11:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbiKGQwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 11:52:16 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DB222B0A
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 08:52:13 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 018035C0178;
        Mon,  7 Nov 2022 11:52:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 07 Nov 2022 11:52:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1667839932; x=1667926332; bh=k64nfsYMGf824CA8APuypxYKux6C
        rag3AwfOp7+0wlI=; b=JrN8O7GT4/2EKMeIYNzRM7C86hAfaigieemyQsLysUrg
        XB6kkfNUTLiKNwrLIq+bnrdND4Eab0OCZY6zFf7Zfb27QprzZ2txT0Vn4uA3Jr58
        /I15wN4bnNFbLuWoN91kSyHJQ5ddnjlJN9LrV+z4tKxv4wKacVIkNps7h772XlFD
        MyRvomSMvzXxGiRX4iJOWy131IJdOYM0uCuQ8iBaNM02BAnT35O/1Xa4YCj36d9z
        JGzvfw7bw7FBHzPQfWtc8RTGtqf7IaLMdWIQ8xOi96EAjZJJuLcKa11w7e8X7pcN
        EJhhibF1rAT6eU3aZjVX1T8gS37i5oJnDttNvBvisw==
X-ME-Sender: <xms:uzdpY_pebjdVmnYw07Cql9rBQx83NpwdWk14xK-WRDHPcRYKTm-IKw>
    <xme:uzdpY5oowWUZYOM6jsW1C1gb8Xum65pkEDo2BClkuD6wlI7OCMoLqRBG8WjWkUOKS
    o711vojtOWYwmU>
X-ME-Received: <xmr:uzdpY8P9EM849MrNGIuVkgPNjwdLnydwEnaRyTjvxhxJnFCcJ6gf47jJokaX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvdekgdelvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeejgeeg
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:vDdpYy6q4LxUnzJ4O7Vvi6zwPWOJoV0raDKWqRuqUcuRM6x7Jlmy1Q>
    <xmx:vDdpY-6NOUdyMpXMlBzpSnZTLI4fjF0XnX0qu9yGVz43qmqfMzb2gg>
    <xmx:vDdpY6jeU8U-DU1wYaSj8_Z4KhG2CI_dqcjAipCAaeaj1JeRDue5dw>
    <xmx:vDdpY1YNjnCgFR9PjMVdj5BWeaiwjPiaP_eKg8_0XR-kfBTe3XG82Q>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Nov 2022 11:52:11 -0500 (EST)
Date:   Mon, 7 Nov 2022 18:52:08 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, bigeasy@linutronix.de,
        imagedong@tencent.com, kuniyu@amazon.com, petrm@nvidia.com
Subject: Re: [patch net-next 2/2] net: devlink: move netdev notifier block to
 dest namespace during reload
Message-ID: <Y2k3uIMn2R42AH6q@shredder>
References: <20221107145213.913178-1-jiri@resnulli.us>
 <20221107145213.913178-3-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107145213.913178-3-jiri@resnulli.us>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 03:52:13PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> The notifier block tracking netdev changes in devlink is registered
> during devlink_alloc() per-net, it is then unregistered
> in devlink_free(). When devlink moves from net namespace to another one,
> the notifier block needs to move along.
> 
> Fix this by adding forgotten call to move the block.
> 
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Fixes: 02a68a47eade ("net: devlink: track netdev with devlink_port assigned")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Does not trigger with my reproducer. Will test the fix tonight in
regression and report tomorrow morning.

> ---
>  net/core/devlink.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 40fcdded57e6..ea0b319385fc 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -4502,8 +4502,11 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>  	if (err)
>  		return err;
>  
> -	if (dest_net && !net_eq(dest_net, curr_net))
> +	if (dest_net && !net_eq(dest_net, curr_net)) {
> +		move_netdevice_notifier_net(curr_net, dest_net,
> +					    &devlink->netdevice_nb);
>  		write_pnet(&devlink->_net, dest_net);
> +	}

I suggest adding this:

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 83fd10aeddd5..3b5aedc93335 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9843,8 +9843,8 @@ void devlink_free(struct devlink *devlink)
 
        xa_destroy(&devlink->snapshot_ids);
 
-       unregister_netdevice_notifier_net(devlink_net(devlink),
-                                         &devlink->netdevice_nb);
+       WARN_ON(unregister_netdevice_notifier_net(devlink_net(devlink),
+                                                 &devlink->netdevice_nb));
 
        xa_erase(&devlinks, devlink->index);

This tells about the failure right away. Instead, we saw random memory
corruptions in later tests.

>  
>  	err = devlink->ops->reload_up(devlink, action, limit, actions_performed, extack);
>  	devlink_reload_failed_set(devlink, !!err);
> -- 
> 2.37.3
> 
