Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B12F5F6F28
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 22:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiJFU30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 16:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbiJFU3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 16:29:23 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10928BEF87
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 13:29:23 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 66BF55C015A;
        Thu,  6 Oct 2022 16:29:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 06 Oct 2022 16:29:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1665088162; x=1665174562; bh=uLy5n75toIIJPmhQURl2VFRA4Hy5
        q63RNkKn7R+7sqg=; b=r2Pd1iTo1VeFQpnFkHQ9Pbh4O570H5XFc89zq0vJuHgW
        jKjI2Q+Hg4Ml4U8ih3+8+qT3gyWha03ScUeplo6xCVBXzHhKSrQOnk7E+w5d/cMJ
        VNMa8ahBF1VD6t+6pu0fTk+P3mAq3+ZIRa8T+VchEgWFXm0+e/8Jo4X3Fn1msZey
        DlJ/iTpQ3tEr01mLRkkxILNTwbB13/wGwvFp1BzkndK5SypHykZTtVscfLxzqQCb
        UgOmKbOPBlsNLS28W6hXop6IYwvMVdypAalOIog4efje6H79xzRxdjzBh6wHO06z
        Quf9+od1XMVB4YCZR2EWiVKq1g+2IN1UbQfmvuJPLQ==
X-ME-Sender: <xms:ojo_Y9Nr931xOnc3toqrjF0PsaihafeNdjKTVOYjIr6mQFHh2FXqqw>
    <xme:ojo_Y_-WspWTVVzhQGEv_xjjWwEXNvAaRZeOjuqWYKfJUkPhtOD-0hWTl45HpOej4
    hot3yzjTUoZK04>
X-ME-Received: <xmr:ojo_Y8S8J30HIXTmsdlGjq5JonAHFtCKrjBqOzoRO3Mw6EuNOWWtobKDhDQsUOIAHTwhtO3INmhKqBBkRolFFftfwy8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeeihedgudeglecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeej
    geeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ojo_Y5vjFj9eiuhX3aLl4g2KKmj4iPu8Crm6TyyKzzr_evXQAE1ZlQ>
    <xmx:ojo_Y1fvY-ZrWPZqrLt98QG0LhmlSpXT4heda5mAPtCNKD0D0apUqQ>
    <xmx:ojo_Y12ur3h1iqBN1FXBbxtuLpkg82DkFPZordi7LtYdioYmZzbw5Q>
    <xmx:ojo_Y56iCogesmlIGiuXoHMF1jSTedVVSFTlCZU11w_hl15QOV5AmQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 6 Oct 2022 16:29:21 -0400 (EDT)
Date:   Thu, 6 Oct 2022 23:29:18 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        netdev@vger.kernel.org, Gwangun Jung <exsociety@gmail.com>
Subject: Re: [PATCH v3 net] ipv4: Handle attempt to delete multipath route
 when fib_info contains an nh reference
Message-ID: <Yz86njFh5pfpVwPS@shredder>
References: <20221006164849.9386-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221006164849.9386-1-dsahern@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 06, 2022 at 10:48:49AM -0600, David Ahern wrote:
> Gwangun Jung reported a slab-out-of-bounds access in fib_nh_match:
>     fib_nh_match+0xf98/0x1130 linux-6.0-rc7/net/ipv4/fib_semantics.c:961
>     fib_table_delete+0x5f3/0xa40 linux-6.0-rc7/net/ipv4/fib_trie.c:1753
>     inet_rtm_delroute+0x2b3/0x380 linux-6.0-rc7/net/ipv4/fib_frontend.c:874
> 
> Separate nexthop objects are mutually exclusive with the legacy
> multipath spec. Fix fib_nh_match to return if the config for the
> to be deleted route contains a multipath spec while the fib_info
> is using a nexthop object.
> 
> Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
> Fixes: 6bf92d70e690 ("net: ipv4: fix route with nexthop object delete warning")
> Reported-by: Gwangun Jung <exsociety@gmail.com>
> Signed-off-by: David Ahern <dsahern@kernel.org>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
