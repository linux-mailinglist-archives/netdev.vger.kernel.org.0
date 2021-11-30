Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1525462F9C
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 10:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235744AbhK3Jb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 04:31:59 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:45581 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234664AbhK3Jb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 04:31:58 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 430F658041B;
        Tue, 30 Nov 2021 04:28:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 30 Nov 2021 04:28:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=If0sk0
        BuhoHvULN//NSFVEzPOVSOcpcvkBdOvLbc3D8=; b=Sk4xlLuxVdXEql3JJu/O0n
        SPk70FFOMkjDO8LIoWQV/IejcDgfde02uKYLpTGkXE9A6OJ0YdR6XgnmhrS/x83K
        0tllsO1USlUYIqc9iSWhHyzmz/NB4cLD3NLTEUanSQ1YaZ1d9SllzGsolRFD3Tyc
        yI/Q3Ipdp6DHDv6Bl5rnSWk+xsoigQO23pAD+9ChX+5wvM6B7drgCzXqxe/YCKh/
        ouXtlyNXMIbxvvElOD3vZYfmiIgZJDMGjPVkI1gT0TqtOHiEMvKBvvh0nbwTWtlN
        6ssJLg60cdTFb1ixLf6ER5uVwHt6fVEtIqZb0EKU0k26Qt+sWqvP6ucoLYuoYSJQ
        ==
X-ME-Sender: <xms:xe6lYUjvOuzPuAdZtuuTj9bM7mvw1R6Qmhr983xF23Z5qTEKJ7KCIw>
    <xme:xe6lYdCtaNbTqhW5VKWdNNBuCudv-8sDL6R8nVVJ9PeDtUvn1UMgJllV4TJi0FO24
    S8lc0E2LbEQlvY>
X-ME-Received: <xmr:xe6lYcE52-lQoGaEhZ-yV9sM862D1T8iHg6_3LoFhAXutJdcKN4TU2rvovXYNiLTeoyFHXbRbU-lrpf_7T2S9RnHfQxFdQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddriedugddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdduhedmnecujfgurhepfffhvffukfhfgggtuggjsehttdertddttddv
    necuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrd
    horhhgqeenucggtffrrghtthgvrhhnpeetgfejteefuefhkeeuveefvdelveejfeelgeei
    udefjeevveevieffieettdegveenucffohhmrghinheptghouggvtggrvhgvrdgttgenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:xe6lYVRpCmmVTbXmt5h5pIuK3RAMqARgHYPAkFGh-7VZgcuzaW9xQQ>
    <xmx:xe6lYRwVxEE1SrEfqk6NV8iKzv9JzFt_2yqMuMLkP8gw6_8MTJzhVg>
    <xmx:xe6lYT7BKmoXyS5ml5TEShOZqk1SM9kO963xOveW_7aTtOtZPCWamw>
    <xmx:xu6lYYkUQNoOWDYuSpdZjxzwLymSYSPtZCd3SUGy77pepu9oyVmAkA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 Nov 2021 04:28:36 -0500 (EST)
Date:   Tue, 30 Nov 2021 11:28:32 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCH net-next] rtnetlink: add RTNH_REJECT_MASK
Message-ID: <YaXuwEg/hdkwNYEN@shredder>
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211126134311.920808-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211126134311.920808-2-alexander.mikhalitsyn@virtuozzo.com>
 <YaOLt2M1hBnoVFKd@shredder>
 <e3d13710-2780-5dff-3cbf-fa0fd7cb5d32@gmail.com>
 <YaXZ3WdgwdeocakQ@shredder>
 <20211130113517.35324af97e168a9b0676b751@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211130113517.35324af97e168a9b0676b751@virtuozzo.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 11:35:17AM +0300, Alexander Mikhalitsyn wrote:
> On Tue, 30 Nov 2021 09:59:25 +0200
> Ido Schimmel <idosch@idosch.org> wrote:
> > Looking at the patch again, what is the motivation to expose
> > RTNH_REJECT_MASK to user space? iproute2 already knows that it only
> > makes sense to set RTNH_F_ONLINK. Can't we just do:
> 
> Sorry, but that's not fully clear for me, why we should exclude RTNH_F_ONLINK?
> I thought that we should exclude RTNH_F_DEAD and RTNH_F_LINKDOWN just because
> kernel doesn't allow to set these flags.

I don't think we should exclude RTNH_F_ONLINK. I'm saying that it is the
only flag that it makes sense to send to the kernel in the ancillary
header of RTM_NEWROUTE messages. The rest of the RNTH_F_* flags are
either not used by the kernel or are only meant to be sent from the
kernel to user space. Due to omission, they are mistakenly allowed.

Therefore, I think that the only necessary patch is an iproute2 patch
that makes sure that during save/restore you are clearing all the
RTNH_F_* flags but RTNH_F_ONLINK.

BTW, looking at save_route() in iproute2, I think the patch only clears
these flags from the ancillary header, but not from 'struct rtnexthop'
that is nested in RTA_MULTIPATH for multipath routes. See this blog post
for depiction of the message:
http://codecave.cc/multipath-routing-in-linux-part-1.html

> 
> I'd also thought about another approach - "offload" this flags filtering
> problems to the kernel side for better iproute dump images compatibility.
> 
> Now we dump all routes using netlink message like this
> 	struct {
> 		struct nlmsghdr nlh;
> 		struct rtmsg rtm;
> 		char buf[128];
> 	} req = {
> 		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct rtmsg)),
> 		.nlh.nlmsg_type = RTM_GETROUTE,
> 		.nlh.nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST,
> ...
> 	};
> 
> But we can introduce some "special" flag like NLM_F_FILTERED_DUMP (or something like that)
> 	} req = {
> 		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct rtmsg)),
> 		.nlh.nlmsg_type = RTM_GETROUTE,
> 		.nlh.nlmsg_flags = NLM_F_FILTERED_DUMP | NLM_F_REQUEST,
> ...
> 	};
> 
> The idea here is that the kernel nows better which flags should be omitted from the dump
> (<=> which flags is prohibited to set directly from the userspace side).
> 
> But that change is more "global". WDYT about this?
> 
> I'm ready to implement any of the approaches with your kind advice.

Having the kernel filter RO flags upon RTM_GETROUTE with a new special
flag / attribute would be easiest to implement in iproute2 (especially
if my comment about RTA_MULTIPATH is correct), but it's a quite invasive
change that requires new uAPI.

Personally, I think that if something can be done in user space, then I
would do it in user space instead of adding new uAPI.
