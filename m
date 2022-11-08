Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972EA620C71
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 10:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbiKHJkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 04:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbiKHJkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 04:40:13 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5112C67F
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 01:40:12 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id DDFCB320092D;
        Tue,  8 Nov 2022 04:40:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 08 Nov 2022 04:40:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1667900410; x=1667986810; bh=uMjjANNaLOOv9SWMIXjvBglaHGnM
        qGIGwHfKQwUNn7A=; b=v95cUEyNuABQM9lHjkP2lBqL/p4MQOA9vm+NdpTjNMp0
        z7HkSijdFsJTOJF3gXW0h3ZhBZOEO6HfzIr51BBLOPbQeyIrJYY2lIzjUg3DVE0i
        LoLI1Kd0LMuMFVXia7enio+c3AipMP60fShcp+8mtswLvZTbwhN4oLGJFnvKU5Sb
        Gfl6jFq7rXnb1ebbIYrStrfzasxpzzlbJHP4sxuRThZp4+O7n7kEhFrV+U6xh45Z
        ukWG6ygvTrbWUEA7zHamWDcw9UGQNz6u3bU/0GpFOPQZssMxAF5FEo7u7oZ1TL45
        4KZE7CeRN856JGowxzk60gH7fJHPZhhVvHPM/cbeVQ==
X-ME-Sender: <xms:-iNqY1x5NRYMx3aIdAqEU9sUR2uyobb7DsPeRw-epRnm8kBmcauRCg>
    <xme:-iNqY1Rwk3Ag92Plah2COKD4YbZafvKiHzPkzQAhGhdHIjOz2scvbL93C_ZtJQqif
    lxQ__7zwnGevnc>
X-ME-Received: <xmr:-iNqY_WjgsLWK3DPt2BmrQ5WjQZiG3mmNeSp1BWNJURO1WRufIHhQVenjVLbzCIrC48A4xqo2CbJceK3ulvysbXPaeI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfedtgddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeejgeeg
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:-iNqY3hZrRHrecb_irN_4kUnIgYf7GNRL8z6SxmMlISU7CFgiDgYHA>
    <xmx:-iNqY3CsFAwpVk63ZZk4qDAmNFan2WLXiYeeAqDZchXFIHmp74-1Sg>
    <xmx:-iNqYwKo4E8mHaF1gCh5jNLio6blBE23MkP8Ni_XGj1NVGX9CXHoxQ>
    <xmx:-iNqY6PXvp7yaSjnLJ0aVvUxW4rtdy25c7AJkxBHYuyTHXWnHTsohw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Nov 2022 04:40:09 -0500 (EST)
Date:   Tue, 8 Nov 2022 11:40:06 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCHv3 iproute2-next] rtnetlink: add new function
 rtnl_echo_talk()
Message-ID: <Y2oj9gNmsy0LhvjA@shredder>
References: <20220929081016.479323-1-liuhangbin@gmail.com>
 <Y2oWDRIIR6gjkM4a@shredder>
 <Y2ocsXykgqIHCcrF@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2ocsXykgqIHCcrF@Laptop-X1>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 05:09:05PM +0800, Hangbin Liu wrote:
> On Tue, Nov 08, 2022 at 10:40:45AM +0200, Ido Schimmel wrote:
> > > +	return rtnl_talk(&rth, &req.n, NULL);
> > >  }
> > 
> > Hangbin,
> > 
> > This change breaks the nexthop selftest:
> > tools/testing/selftests/net/fib_nexthops.sh
> > 
> > Which is specifically checking for "2" as the error code. Example:
> 
> Hi Ido,
> 
> Thanks for the report.
> 
> > 
> > # attempt to create nh without a device or gw - fails
> > run_cmd "$IP nexthop add id 1"
> > log_test $? 2 "Nexthop with no device or gateway"
> > 
> > I think it's better to restore the original error code than "fixing" all
> > the tests / applications that rely on it.
> 
> I can fix this either in iproute2 or in the selftests.
> I'd perfer ask David's opinion.

Sure, but note that:

1. Other than the 4 selftests that we know about and can easily patch,
there might be a lot of other applications that invoke iproute2 and
expect this return code. It is used by iproute2 since at least 2004.

2. There is already precedence for restoring the original code. See
commit d58ba4ba2a53 ("ip: return correct exit code on route failure").

> 
> > 
> > The return code of other subcommands was also changed by this patch, but
> > so far all the failures I have seen are related to "nexthop" subcommand.
> 
> I grep "log_test \$? 2" in selftest/net folder and found the following tests
> would use it
> 
> fib_tests.sh
> test_vxlan_vnifiltering.sh
> fcnal-test.sh
> fib_nexthops.sh
> 
> Thanks
> Hangbin
