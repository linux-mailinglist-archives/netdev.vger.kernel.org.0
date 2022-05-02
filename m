Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBAF516AD0
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 08:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353733AbiEBGWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 02:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240599AbiEBGWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 02:22:48 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDC545784
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 23:19:20 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 887E85C00DD;
        Mon,  2 May 2022 02:19:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 02 May 2022 02:19:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1651472356; x=
        1651558756; bh=s1iC6UU/u5jwEk2ZAzHf9qgut01yQxgxh4bpVxYR9z4=; b=X
        qhOHF8Y3j6RTmV+Tdnv4P+5HfXPR6bEPHphBzy/eYteWQ7sTnQtI3rfhUpf2l/iT
        E3buAjh5OOjj7X0bKpEKNvm3EBmTahND2gd6YO2A1S3iIeZq9+AMjV4YzwJOuJXr
        yhhDJIo64zwwwpv8A7tsok9r68nSOJX76URW5ulMFQc/rucG72fqyFM+YEW1K5Tk
        71cPvjhA38mKxS3yckfooxOUciWRPL7RR2GfMwaOC8IkfORJUkY50aWiyI8PwaX/
        cTUVXrkzuHX0zJFJBAMyACpA0tkJd5+wH5YazePBTFiGTPcp0k/lxAW0wjlLL+k8
        8JNjWwIhuJWjZRe0Dk36A==
X-ME-Sender: <xms:5HdvYtDKj_Voea0jpi51PKbpFteGjdulfFe1DAV0WmCK0FRC9iW1-A>
    <xme:5HdvYrhWJl5qobfjDHu_sysv3HvBu3Z-GhNZGrc-iOUdRzg5taADrGASt7053vL6j
    5k2v9RS4sK9Qys>
X-ME-Received: <xmr:5HdvYomUPAGrHUyU0_KXRJ9tpLjTKNm6cPNTt-VQWcnx8246LQ7d-oBiuCGc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeggddutdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhephefhtdejvdeiffefudduvdffgeetieeigeeugfduffdvffdtfeehieejtdfh
    jeeknecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:5HdvYnzAbfUDao2xXaayblz8cKt0Mms_up50sRJGDpfxz_Jdv_4iTQ>
    <xmx:5HdvYiQhPlEmKnMK-I84wK4SbMGCXDAFe8NFtpS4pm5jwVSyP-cdew>
    <xmx:5HdvYqYQUa-Ohe5ufs1DktmpyAiBsQbcaUZGMlqq1E8tG8DDhthP7w>
    <xmx:5HdvYteulvK89O7DooUbh3bbNOHTBczFShhvnT3-tQuoBefQSUXpng>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 May 2022 02:19:15 -0400 (EDT)
Date:   Mon, 2 May 2022 09:19:12 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH iproute2-next 06/11] ipstats: Add a group "link"
Message-ID: <Ym934BkT7TAsu2kZ@shredder>
References: <cover.1650615982.git.petrm@nvidia.com>
 <c361fce0960093e31aabbc0b45bb0c870896339e.1650615982.git.petrm@nvidia.com>
 <Ym6ek66a6kMH3ZEu@shredder>
 <c64a4c79-03e3-9286-1b45-29d5dfaa0502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c64a4c79-03e3-9286-1b45-29d5dfaa0502@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 01, 2022 at 09:56:16PM -0700, David Ahern wrote:
> On 5/1/22 8:52 AM, Ido Schimmel wrote:
> > When I tested this on 5.15 / 5.16 everything was fine, but now I get:
> > 
> > $ ip stats show dev lo group link
> > 1: lo: group link
> > Error: attribute payload too short
> > 
> 
> ...
> 
> > 
> > Note the difference in size of IFLA_STATS_LINK_64 which carries struct
> > rtnl_link_stats64: 196 bytes vs. 204 bytes
> > 
> > The 8 byte difference is most likely from the addition of
> > rx_otherhost_dropped at the end:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=794c24e9921f32ded4422833a990ccf11dc3c00e
> > 
> > I guess it worked for me because I didn't have this member in my copy of
> > the uAPI file, but it's now in iproute2-next:
> > 
> > https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=bba95837524d09ee2f0efdf6350b83a985f4b2f8
> > 
> > I was under the impression that such a size increase in a uAPI struct is
> > forbidden, which is why we usually avoid passing structs over netlink.
> 
> extending structs at the end is typically allowed.

In this case, the iproute2 check needs to be modified as new iproute2
should work with old kernels.

> The ABI breakage is when an entry is added in the middle.

Sure, that's well understood.

Thanks!

> 
> 
> > 
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	open_json_object("stats64");
> >> +	print_stats64(stdout, stats, NULL, NULL);
> >> +	close_json_object();
> >> +	return 0;
> >> +}
> 
