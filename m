Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02396B9CA1
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjCNRMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjCNRMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:12:38 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BD592F23;
        Tue, 14 Mar 2023 10:12:34 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 806FF32002D8;
        Tue, 14 Mar 2023 13:12:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 14 Mar 2023 13:12:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1678813950; x=1678900350; bh=lD84THYsqEBrd
        kTK8693PxozPe7E1dZJ3/wYEhXCQVs=; b=S53bDOrd96WOVHHFk8WwRRyNR1Ihc
        s9/oA11McHWye2Zt/sj6AnrUDRSeu3aH/fR9vYCfQJ0YfgB+AOqJ34svl4cWI8G7
        1zfYjva83yGi5yuqFUH4bx3juWSZFnw9n3kufjTlBlahaF/lUHwZbrLneev7yWdc
        47iu2mYl9iQKDPIw6Y3LiPTgUlZYb+O7c6hoaZazag7nep2yUiK6VDrrYfGxw+B+
        3WTMFM7Ljcfhw6KnHgRSkuUulpSVqR8IPVPSSwGifFqyxXiCrGOZcU2fdVBCPnkn
        1dErgTKTzC5+fetxzrcdI093/GGeypfE6U8oSBt4qnsNInRtAfVKgqNfA==
X-ME-Sender: <xms:_aoQZPOYKuLzl3nrLYwH0HlbwvdDj-Kr2of3DDq3q96nM2MRz8IEvw>
    <xme:_aoQZJ-Nh5M3iTqKF9nmIrDHVDwQBZd11UKHnBVEA1BS6ke8gLpJpE-8MqX7Rv6we
    HdGBLXyZJiR_8w>
X-ME-Received: <xmr:_aoQZOR-6AHCq3vaggBA1_rmwrmbDeUtGjsrZ3ebtv_L17llL8TTOzWvTILLyqX5b1Jec0zyzQFfeQesy23sKRLJazA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddviedguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesth
    dtredttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehi
    ughoshgthhdrohhrgheqnecuggftrfgrthhtvghrnhepvddufeevkeehueegfedtvdevfe
    fgudeifeduieefgfelkeehgeelgeejjeeggefhnecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:_aoQZDtLEqnHuCmGga4tAGEVQa6riF0mQOqBsWNW3L8o2uKGYJ1Azg>
    <xmx:_aoQZHfOCC0teAU5QquKduJWy8zfgQQ15WHEaqxkEOhHxJWBoNV9oA>
    <xmx:_aoQZP1u2R7GFEeozsQbeoFH632u4snehy90qYQIyUEVuB4HcJ36lA>
    <xmx:_qoQZJu9-0JG8ClX3L4TpAUV_19y5QtHKRCakwCXVuihfaPL-_VU7w>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Mar 2023 13:12:28 -0400 (EDT)
Date:   Tue, 14 Mar 2023 19:12:24 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     gaoxingwang <gaoxingwang1@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, liaichun@huawei.com,
        yanan@huawei.com
Subject: Re: ipv4:the same route is added repeatedly
Message-ID: <ZBCq+KXtxWXLPFNF@shredder>
References: <20230314144159.2354729-1-gaoxingwang1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314144159.2354729-1-gaoxingwang1@huawei.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 10:41:59PM +0800, gaoxingwang wrote:
> When i add default route in /etc/sysconfig/static-routes, and then restart network service, it appears to add two same default route:
> [root@localhost ~]# ip r
> default via 9.82.0.1 dev eth0 
> default via 9.82.0.1 dev eth0 
> 
> The static-routes file contents are as follows:
> any net 0.0.0.0 netmask 0.0.0.0 gw 110.1.62.1
> 
> This problem seems to be related to patch f96a3d7455(ipv4: Fix incorrect route flushing when source address is deleted). When I revert this patch, the problem gets fixed.
> Is that a known issue?

'fi->fib_tb_id' is initialized from 'cfg->fc_table' which is not
initialized in the IOCTL path which I guess is what you are using given
the syntax of the file. You can therefore end up having two identical
routes that only differ in their FIB info due to its associated table
ID.

Can you try this fix [1]? Seems to be working for me. Tested using this
reproducer [2].

With f96a3d7455:

 # ./ioctl_repro.sh
 default via 192.0.2.2 dev dummy10
 default via 192.0.2.2 dev dummy10

With f96a3d7455 reverted:

 # ./ioctl_repro.sh
 SIOCADDRT: File exists
 default via 192.0.2.2 dev dummy10

With the fix:

 # ./ioctl_repro.sh
 SIOCADDRT: File exists
 default via 192.0.2.2 dev dummy10

Thanks

[1]
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index b5736ef16ed2..390f4be7f7be 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -576,6 +576,9 @@ static int rtentry_to_fib_config(struct net *net, int cmd, struct rtentry *rt,
 			cfg->fc_scope = RT_SCOPE_UNIVERSE;
 	}
 
+	if (!cfg->fc_table)
+		cfg->fc_table = RT_TABLE_MAIN;
+
 	if (cmd == SIOCDELRT)
 		return 0;
 
[2]
#!/bin/bash

ip link del dev dummy10 &> /dev/null
ip link add name dummy10 up type dummy
ip address add 192.0.2.1/24 dev dummy10

ip route add default via 192.0.2.2
route add default gw 192.0.2.2
ip -4 r show default
