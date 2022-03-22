Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAB04E3BAF
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 10:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbiCVJYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 05:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbiCVJYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 05:24:23 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C102181E
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 02:22:56 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 80F273200368;
        Tue, 22 Mar 2022 05:22:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 22 Mar 2022 05:22:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=c/+asNdNCbKe0hC7T
        zw0evUhVpTdbBGzS7uhOJ38vHE=; b=HDQ5EniC6PZl1c21MU6Sz2PljIATOi8kq
        snuY8ZJzhlLuBY5Jdl4CYWj8EFIg7ruXkiIVWG60rsbMQs2IufIyj8Dq5aosooTU
        nZUbBF7fR9tHvUnkEDXPWjATQGdzoK7XWT+1/7GsxjXftt9AkwqZ9ZTU9lgNTXBB
        1rrr9TgysDfcwE+pPU8EvIP7XAz+3aabTyvnT5giCiPVCaMYYA1UPLXzIscwcFfh
        2hAv85lZdjLhcRKJDV++Altw1y4IsJI6mZq/W7mnqjOLTqYOfUkqZ30VIpIMwQtu
        b9yE9yPK72+UX++c8uc5eSiZmQyARe3VBMj0P1Iwi9UyfTe7F07jA==
X-ME-Sender: <xms:bJU5YlL8QH7kCwUywRcQzTQpNryUfS96gopQFITSliBRIYLgXxULcg>
    <xme:bJU5YhI36yPG0G1zfkpPMedih2NoX0FOphsxqowuiUFVBUPlEhQ3Bxo-0aEV1gJXo
    xFmmh5AkBbGsVk>
X-ME-Received: <xmr:bJU5Ytv2mPYxwzg6ueJBkc-JXDhPY-P9lzo33gMQ4rvG9Q6TBw6taiaI8Z7DbEAgmNqJJLIVH6Imn42fLRGzL4fMM4c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeghedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:bJU5YmZJsS0qwUoIeiZHAHaoX2ofaZ_AzXLpZZ4wCyXAIDjMgmH6iw>
    <xmx:bJU5YsaouRZUbNTc7NNyeozPbX-8_UTrT-9z9wB4VMhSlnUobnF7VQ>
    <xmx:bJU5YqBcHUaQwQGPwM0PpOL4nsExp0JlWcKuHJoDOy7w3b8iDM5ckw>
    <xmx:bZU5YrnIKllrRFpnvPGyzyiw06VWjA44sIypMYdmQ_VmEwXE1NVg2A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Mar 2022 05:22:52 -0400 (EDT)
Date:   Tue, 22 Mar 2022 11:22:47 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        greearb@candelatech.com
Subject: Re: [PATCH net-next] net: Add l3mdev index to flow struct and avoid
 oif reset for port devices
Message-ID: <YjmVZzwE3XY750v6@shredder>
References: <20220314204551.16369-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314204551.16369-1-dsahern@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 02:45:51PM -0600, David Ahern wrote:
> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> index 2af2b99e0bea..fb0e49c36c2e 100644
> --- a/net/ipv4/fib_trie.c
> +++ b/net/ipv4/fib_trie.c
> @@ -1429,11 +1429,8 @@ bool fib_lookup_good_nhc(const struct fib_nh_common *nhc, int fib_flags,
>  	    !(fib_flags & FIB_LOOKUP_IGNORE_LINKSTATE))
>  		return false;
>  
> -	if (!(flp->flowi4_flags & FLOWI_FLAG_SKIP_NH_OIF)) {
> -		if (flp->flowi4_oif &&
> -		    flp->flowi4_oif != nhc->nhc_oif)
> -			return false;
> -	}
> +	if (flp->flowi4_oif && flp->flowi4_oif != nhc->nhc_oif)
> +		return false;

David, we have several test cases that are failing which I have tracked
down to this patch.

Before the patch, if the original output interface was enslaved to a
VRF, the output interface in the flow struct would be updated to the VRF
and the 'FLOWI_FLAG_SKIP_NH_OIF' flag would be set, causing the above
check to be skipped.

After the patch, the check is no longer skipped, as original output
interface is retained and the flag was removed.

This breaks scenarios where a GRE tunnel specifies a dummy device
enslaved to a VRF as its physical device. The purpose of this
configuration is to redirect the underlay lookup to the table associated
with the VRF to which the dummy device is enslaved to. The check fails
because 'flp->flowi4_oif' points to the dummy device, whereas
'nhc->nhc_oif' points to the interface via which the encapsulated packet
should egress.

Skipping the check when an l3mdev was set seems to solve the problem:

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index fb0e49c36c2e..cf1164e05d92 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1429,7 +1429,8 @@ bool fib_lookup_good_nhc(const struct fib_nh_common *nhc, int fib_flags,
            !(fib_flags & FIB_LOOKUP_IGNORE_LINKSTATE))
                return false;
 
-       if (flp->flowi4_oif && flp->flowi4_oif != nhc->nhc_oif)
+       if (!flp->flowi4_l3mdev &&
+           flp->flowi4_oif && flp->flowi4_oif != nhc->nhc_oif)
                return false;
 
        return true;

AFAICT, this scenario does not break with ip6gre/ip6gretap tunnels
because 'RT6_LOOKUP_F_IFACE' is not set in
ip6_route_output_flags_noref() in this case.

WDYT? I plan to test this patch in our regression, but I'm not sure if I
missed other cases that might remain broken.
