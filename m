Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20F75CBDA1
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 16:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389221AbfJDOns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 10:43:48 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56999 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388724AbfJDOns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 10:43:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id AF05E22053;
        Fri,  4 Oct 2019 10:43:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 04 Oct 2019 10:43:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=owUA1Z
        pjp+x4/g0JFT8auxrSKERepQlK+SlKKMcrKSA=; b=PjG78ril2mVb5msWnt+uxU
        k4Ql+H6C31tn1kCftu8nmx8sOoh1X88Szn3pjZY08bGmGwZs+cYXp3a0EQb+sDpH
        D9nFGwGlyIaJXjRRa+TAb+Y2aRlFFk5Rsa9oIPcksmiCEeyUyUVpcHhkWG+ilCMX
        +s+PH75mb9XyYrLCPYUERZ8aq+l808HIJFXr7/Mx5a36cFfD/QOpUDRUTw054pJc
        E5+bhi9Z452qTa/KbRntrgsKH1DHVKTazE1lHbMTUsFh9m+7y5JLwDEjD+0qrjus
        aFd8wHjHtUEYSj8rrUnJrDzgKpjbH2VJNj09fE34d7jJhkv1zUWZ2t4guhKXEcOQ
        ==
X-ME-Sender: <xms:oVqXXWemfh0yIZnM9KAm72YhmI2pZ32ODs_4OOt0Bhbd7j4QbZRA8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrhedugdejfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepjeelrd
    dujeejrdefkedrvddtheenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehi
    ughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:oVqXXT6l0giHn2tYjcnv0OmXDl3jhhtkSdqZ6frbsFtJZMPOPrNY4g>
    <xmx:oVqXXRVqEWQFXkW59hvoKKby2krRBL4ebQFIJzpgxUR0YkAy4cB3lw>
    <xmx:oVqXXa54AiaY0_vNnO1lvTCYZdweKo2Fcf4skehG6YXxzvvNuvTUeQ>
    <xmx:olqXXTuYCYrPqS9ZmgTR8quWRHnRk2ULHK1Ug6TZgDU5OV9sZmbQPA>
Received: from localhost (bzq-79-177-38-205.red.bezeqint.net [79.177.38.205])
        by mail.messagingengine.com (Postfix) with ESMTPA id DE515D60062;
        Fri,  4 Oct 2019 10:43:44 -0400 (EDT)
Date:   Fri, 4 Oct 2019 17:43:40 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>, roopa@cumulusnetworks.com
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 12/15] ipv4: Add "in hardware" indication to
 routes
Message-ID: <20191004144340.GA15825@splinter>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002084103.12138-13-idosch@idosch.org>
 <CAJieiUiEHyU1UbX_rJGb-Ggnwk6SA6paK_zXvxyuYJSrah+8vg@mail.gmail.com>
 <20191002182119.GF2279@nanopsycho>
 <1eea9e93-dbd9-8b50-9bf1-f8f6c6842dcc@gmail.com>
 <20191003053750.GC4325@splinter>
 <e4f0dbf6-2852-c658-667b-65374e73a27d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4f0dbf6-2852-c658-667b-65374e73a27d@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 03, 2019 at 07:55:16PM -0600, David Ahern wrote:
> On 10/2/19 11:37 PM, Ido Schimmel wrote:
> >>>>> The new indication is dumped to user space via a new flag (i.e.,
> >>>>> 'RTM_F_IN_HW') in the 'rtm_flags' field in the ancillary header.
> >>>>>
> >>>>
> >>>> nice series Ido. why not call this RTM_F_OFFLOAD to keep it consistent
> >>>> with the nexthop offload indication ?.
> >>>
> >>> See the second paragraph of this description.
> >>
> >> I read it multiple times. It does not explain why RTM_F_OFFLOAD is not
> >> used. Unless there is good reason RTM_F_OFFLOAD should be the name for
> >> consistency with all of the other OFFLOAD flags.
> > 
> > David, I'm not sure I understand the issue. You want the flag to be
> > called "RTM_F_OFFLOAD" to be consistent with "RTNH_F_OFFLOAD"? Are you
> > OK with iproute2 displaying it as "in_hw"? Displaying it as "offload" is
> > really wrong for the reasons I mentioned above. Host routes (for
> > example) do not offload anything from the kernel, they just reside in
> > hardware and trap packets...
> > 
> > The above is at least consistent with tc where we already have
> > "TCA_CLS_FLAGS_IN_HW".
> > 
> >> I realize rtm_flags is overloaded and the lower 8 bits contains RTNH_F
> >> flags, but that can be managed with good documentation - that RTNH_F
> >> is for the nexthop and RTM_F is for the prefix.
> > 
> > Are you talking about documenting the display strings in "ip-route" man
> > page or something else? If we stick with "offload" and "in_hw" then they
> > should probably be documented there to avoid confusion.
> > 
> 
> Sounds like there are 2 cases for prefixes that should be flagged to the
> user -- "offloaded" (as in traffic is offloaded) and  "in_hw" (prefix is
> in hardware but forwarding is not offloaded).

Sounds good. Are you and Roopa OK with the below?

RTM_F_IN_HW - route is in hardware
RTM_F_OFFLOAD - route is offloaded

For example, host routes will have the first flag set, whereas prefix
routes will have both flags set.

Together with the existing offload flags for nexthops and neighbours
this provides great visibility into the entire offload process.
