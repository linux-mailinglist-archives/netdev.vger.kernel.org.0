Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B5763631A
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238481AbiKWPRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238633AbiKWPQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:16:54 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7FD903B9
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:16:51 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 2911F32007F1;
        Wed, 23 Nov 2022 10:16:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 23 Nov 2022 10:16:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669216608; x=1669303008; bh=ozCnub5NuHlLqyVg7HCfim+VI2kK
        +szqF0RKIgA9Kt4=; b=ikXPahXh0ieRC/i1/7e1wj7EsFEIdKvPJJGWiYzzvikZ
        Utj8MJXLxGIWTQWIZiXzoZR2izGe/cVuEfjEpoZi8JPwUrN7H9EHP9NUHuxf4KZ/
        4z2V8CuxZhPz/QliZQsUcv2FvJ8hzkbqFvb/3fOaKp6W+v4j9DGdkUAvTWXh+Lez
        wfXKf5OAbaVTpm+4W0z4OlOp2fMKCxSgHXY282LC2/r7IZ8Sb03p9gi2DIiaT+5v
        LBwkYSq0lPh/C52zz818Hqugf/7gRTDpYZOIJaPIRDJyhvt9opicrUqxltRMAg9t
        7+2RjmpJwVQYa1Br9B2AnD6Ugp3OhhtKYvWRveWDbA==
X-ME-Sender: <xms:YDl-Y1Sc2CHVD02eHf1_B7tkz1Zuf54G2PbAfrsBzRLuvFGz9kcqiQ>
    <xme:YDl-Y-wjFENbwrrdD3S0t366WoYkwMTiItcvkWFNJNkgOZ1XBnVnD2dmMHn9PhOvz
    MZ0EWxeQnB6xcI>
X-ME-Received: <xmr:YDl-Y62ryWQZcQl7YVpz_ySJdc1QaBiIauePBEx5-3R_BvdHdXUaG5aJw2yNpHvlcBPQIVZM0YBe-9FU28QscwQ8-_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedriedugdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeejgeeg
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:YDl-Y9Dyeqg-UXUsGDg7lwmViD9BpUzYgZMc-vbm2gmFAkVLly3hqg>
    <xmx:YDl-Y-gGhKYaESeIs-ivAj8ewpajv8OoWozh64P88tV9Dpn2UcrKbg>
    <xmx:YDl-Yxr9MZPK4LVb_c5MePs3ZyMfDisbVuLtsRgnv5C-W1iqmlsEpQ>
    <xmx:YDl-Y2fb8GPC5M416l9nxpeMOoI1McgvuD4yWzAHyNmntUW3aDmIdg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Nov 2022 10:16:47 -0500 (EST)
Date:   Wed, 23 Nov 2022 17:16:43 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Borisov <nikolay.borisov@virtuozzo.com>
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, kernel@virtuozzo.com
Subject: Re: [PATCH net-next v2 1/3] drop_monitor: Implement namespace
 filtering/reporting for software drops
Message-ID: <Y345WyXayWF/2eDJ@shredder>
References: <20221123142817.2094993-1-nikolay.borisov@virtuozzo.com>
 <20221123142817.2094993-2-nikolay.borisov@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123142817.2094993-2-nikolay.borisov@virtuozzo.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 04:28:15PM +0200, Nikolay Borisov wrote:
>  static void trace_drop_common(struct sk_buff *skb, void *location)
>  {
>  	struct net_dm_alert_msg *msg;
> @@ -219,7 +233,11 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
>  	int i;
>  	struct sk_buff *dskb;
>  	struct per_cpu_dm_data *data;
> -	unsigned long flags;
> +	unsigned long flags, ns_id = 0;
> +
> +	if (skb->dev && net_dm_ns &&
> +	    dev_net(skb->dev)->ns.inum != net_dm_ns)

I don't think this is going to work, unfortunately. 'skb->dev' is in a
union with 'dev_scratch' so 'skb->dev' does not necessarily point to a
valid netdev at all times. It can explode when dev_net() tries to
dereference it.

__skb_flow_dissect() is doing something similar, but I believe there the
code paths were audited to make sure it is safe.

Did you consider achieving this functionality with a BPF program
attached to skb::kfree_skb tracepoint? I believe BPF programs are run
with page faults disabled, so it should be safe to attempt this there.
