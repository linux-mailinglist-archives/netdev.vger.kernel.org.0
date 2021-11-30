Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F014462E16
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 08:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbhK3ICy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 03:02:54 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:43821 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234489AbhK3ICx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 03:02:53 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7D5B958040A;
        Tue, 30 Nov 2021 02:59:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 30 Nov 2021 02:59:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xwfysu
        v5362TwpmMRE7HSBpUkmNbT2YC5WgTz6+F76o=; b=IOhel0CaZt5/PaFQEcYXdW
        dz+NamLWdpEyyrmXCsM1g1a3sHahVczJaFoaKDJQh4MGEemJnQM+gOhKCBr4HGU6
        tgWALySlkhiIXYEYw0A/RpUZJL5wY9++vCbbRasTuAMTkCIBTwvg1TP8uSmrebEq
        5wCD5Sbrp0Fg/+VHLKtR19csO5e1X8Hso3OnCvXU4AiK6RFI3bqCmzWdRgNrs31T
        1Yf0gunjiEBgRSc/Lqi94TdAoWotGn/rz5w5xH3dcwp7nJkHn1dmPAOPSYCpp415
        TnMpem8uockIz72RjSdasgIw5m9BSzG/ZS/5/iuqQQA+h5e68KELIuxXPyra6y3Q
        ==
X-ME-Sender: <xms:4dmlYXTB_re6AuFiQ0YAL2RZw1c8WOQzYLIG8C6acxmeFv_rIO0ZhA>
    <xme:4dmlYYyyLHAKRASSwQJaUN4aaTak4Q8o8AQMX1R5eypaK9YpoylUBA3Vmyq8PmcOA
    koCvvN4FKICj6w>
X-ME-Received: <xmr:4dmlYc0l4uP3qN9VvpqC5H6Ogq3NmAMf2lhP4gX_zdvi_-OXlOUUfjr2x5uf0l1R0E-hfZ1wQX46WDAYU0xHNImPhr_ESg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddriedtgdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:4dmlYXCyHxklEl4Gv6ir9z9Hd1JHBvUAL_ozwA9y3pSOT7gGHPaUZA>
    <xmx:4dmlYQheUwjLlX40nbluEB1Lit_OMHU1ia5LuVpa8qiEEdG3HlA_2A>
    <xmx:4dmlYbrVQJIRASCGhUbFreAMLOFgjLqmgrxZ841fEYbUfAIJmzVEPg>
    <xmx:4tmlYZUbStkVvO9S342Sk0-_WhI77U0yT52XSAcklj77wuCB2LKqHg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 Nov 2021 02:59:28 -0500 (EST)
Date:   Tue, 30 Nov 2021 09:59:25 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCH net-next] rtnetlink: add RTNH_REJECT_MASK
Message-ID: <YaXZ3WdgwdeocakQ@shredder>
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211126134311.920808-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211126134311.920808-2-alexander.mikhalitsyn@virtuozzo.com>
 <YaOLt2M1hBnoVFKd@shredder>
 <e3d13710-2780-5dff-3cbf-fa0fd7cb5d32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3d13710-2780-5dff-3cbf-fa0fd7cb5d32@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 28, 2021 at 05:19:38PM -0700, David Ahern wrote:
> On 11/28/21 7:01 AM, Ido Schimmel wrote:
> > On Fri, Nov 26, 2021 at 04:43:11PM +0300, Alexander Mikhalitsyn wrote:
> >> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> >> index 5888492a5257..9c065e2fdef9 100644
> >> --- a/include/uapi/linux/rtnetlink.h
> >> +++ b/include/uapi/linux/rtnetlink.h
> >> @@ -417,6 +417,9 @@ struct rtnexthop {
> >>  #define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | \
> >>  				 RTNH_F_OFFLOAD | RTNH_F_TRAP)
> >>  
> >> +/* these flags can't be set by the userspace */
> >> +#define RTNH_REJECT_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN)
> >> +
> >>  /* Macros to handle hexthops */
> >>  
> >>  #define RTNH_ALIGNTO	4
> >> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> >> index 4c0c33e4710d..805f5e05b56d 100644
> >> --- a/net/ipv4/fib_semantics.c
> >> +++ b/net/ipv4/fib_semantics.c
> >> @@ -685,7 +685,7 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
> >>  			return -EINVAL;
> >>  		}
> >>  
> >> -		if (rtnh->rtnh_flags & (RTNH_F_DEAD | RTNH_F_LINKDOWN)) {
> >> +		if (rtnh->rtnh_flags & RTNH_REJECT_MASK) {
> >>  			NL_SET_ERR_MSG(extack,
> >>  				       "Invalid flags for nexthop - can not contain DEAD or LINKDOWN");
> >>  			return -EINVAL;
> >> @@ -1363,7 +1363,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
> >>  		goto err_inval;
> >>  	}
> >>  
> >> -	if (cfg->fc_flags & (RTNH_F_DEAD | RTNH_F_LINKDOWN)) {
> >> +	if (cfg->fc_flags & RTNH_REJECT_MASK) {
> >>  		NL_SET_ERR_MSG(extack,
> >>  			       "Invalid rtm_flags - can not contain DEAD or LINKDOWN");
> > 
> > Instead of a deny list as in the legacy nexthop code, the new nexthop
> > code has an allow list (from rtm_to_nh_config()):
> > 
> > ```
> > 	if (nhm->nh_flags & ~NEXTHOP_VALID_USER_FLAGS) {
> > 		NL_SET_ERR_MSG(extack, "Invalid nexthop flags in ancillary header");
> > 		goto out;
> > 	}
> > ```
> > 
> > Where:
> > 
> > ```
> > #define NEXTHOP_VALID_USER_FLAGS RTNH_F_ONLINK
> > ```
> > 
> > So while the legacy nexthop code allows setting flags such as
> > RTNH_F_OFFLOAD, the new nexthop code denies them. I don't have a use
> > case for setting these flags from user space so I don't care if we allow
> > or deny them, but I believe the legacy and new nexthop code should be
> > consistent.
> > 
> > WDYT? Should we allow these flags in the new nexthop code as well or
> > keep denying them?
> > 
> >>  		goto err_inval;
> 
> I like the positive naming - RTNH_VALID_USER_FLAGS.

I don't think we can move the legacy code to the same allow list as the
new nexthop code without potentially breaking user space. The legacy
code allows for much more flags to be set in the ancillary header than
the new nexthop code.

Looking at the patch again, what is the motivation to expose
RTNH_REJECT_MASK to user space? iproute2 already knows that it only
makes sense to set RTNH_F_ONLINK. Can't we just do:

diff --git a/ip/iproute.c b/ip/iproute.c
index 1447a5f78f49..0e6dad2b67e5 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -1632,6 +1632,8 @@ static int save_route(struct nlmsghdr *n, void *arg)
        if (!filter_nlmsg(n, tb, host_len))
                return 0;
 
+       r->rtm_flags &= ~RTNH_F_ONLINK;
+
        ret = write(STDOUT_FILENO, n, n->nlmsg_len);
        if ((ret > 0) && (ret != n->nlmsg_len)) {
                fprintf(stderr, "Short write while saving nlmsg\n");

> 
> nexthop API should allow the OFFLOAD flag to be consistent; separate
> change though.
> 
