Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C31641BBE
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 10:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiLDJF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 04:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiLDJF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 04:05:27 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AFE15A2C
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 01:05:25 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4DCB75C00A4;
        Sun,  4 Dec 2022 04:05:23 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 04 Dec 2022 04:05:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1670144723; x=1670231123; bh=lsMlg+nMOAoGyXJiGA9BuKoPOtzB
        U01frgsFoEFodQ0=; b=s82YG0/dWILhk42KJP4ogCfKqRIkVNt65GmgxHdVxmlN
        iuOv0V6jvsXaQUWGQ9UD3VquycL1wo9PBt9Wnzl/rF1Y+9vW4BLR2erVL2LbQKRu
        MikeduMzfJCInE5kkHLdOJ3sactyOQxqtz/Gj/Vtm3i/9+gi/wFX6nlVwP0Hhesb
        4bxnNsSnutaoZO845iK11Y4iQEO0APjGf9vBAnhPnZpon8p32OP7Y14LAEf2aBx/
        KFR3xwtOszVZUtLjV2KUFurgPeQ1xB4DgifUZXjmKgPTBvyr0K9/6AjuRpkdi3o0
        JEvWIgybRfTsySvKMz3bhrB75VM6y/xwxllDrfDJ4A==
X-ME-Sender: <xms:0mKMY-j-nHuqK93so-MUzq75n8vaabJ1ogtqC3ZGA1YkSp-hscbuEg>
    <xme:0mKMY_AUsySXne5oQoT2ut3DrR8O4yTWF7mA8fdshQ20TQgIkEryQEd48Ekd49MyH
    HDPbnzt-uh-KsY>
X-ME-Received: <xmr:0mKMY2Hir-lF1teJpdyFum1hT6hGeJJ4ylrsC3KHRwLM2JDbuY5gU-MAtBo_>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddvucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgthhhi
    mhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvghrnh
    ephefhtdejvdeiffefudduvdffgeetieeigeeugfduffdvffdtfeehieejtdfhjeeknecu
    ffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:0mKMY3T1lZn9p88jDGaPnt-7rFhT6obX_tA35eovFHNOdX-mr-gStA>
    <xmx:0mKMY7x-kzqU95yfx97ghCkjv5DP9KO0MuYPavacrnUgxaCsARVdYg>
    <xmx:0mKMY1564NK3qaWYvVrUHnbi8MlE03UK8M06HMhtqwrtjtQfJFCl8A>
    <xmx:02KMY9uT0zdVJI8s-U_oz0Fe-j1PLvhWJCPD-byGxBAc56OAhllchA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 4 Dec 2022 04:05:21 -0500 (EST)
Date:   Sun, 4 Dec 2022 11:05:18 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Leonid Komaryanskiy <lkomaryanskiy@gmail.com>
Cc:     netdev@vger.kernel.org, dmytro_firsov@epam.com, petrm@nvidia.com,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Subject: Re: ip_forward notification for driver
Message-ID: <Y4xizqncq1JTvNMu@shredder>
References: <CAHRDKfRZEw3Mq9GP3rCf2U10Y7X7N61BNZCa95tKESZkVD2qAg@mail.gmail.com>
 <Y2yzKfSPJ7h2arO/@shredder>
 <CAHRDKfSoNdWWjv8X6-fBvaaaJ7wFekvKAYkfD01JBcqrMiLtUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHRDKfSoNdWWjv8X6-fBvaaaJ7wFekvKAYkfD01JBcqrMiLtUA@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 05:21:10PM +0200, Leonid Komaryanskiy wrote:
> We checked netevents (NETEVENT_IPV4_MPATH_HASH_UPDATE and
> NETEVENT_IPV4_FWD_UPDATE_PRIORITY_UPDATE) but unfortunately, netevents
> notifier doesn't trigger at all in case of changing value in
> /proc/sys/net/ipv4/ip_forward. We see, that these events come in the
> case of modifying /proc/sys/net/ipv4/fib_multipath_hash_policy, but
> not for ip_forward. Shell we prepare an upstream patch with notifier
> for ip_forward modify netevent?

I believe this is the correct interface to use for this notification,
but if you are going to submit such a patch, then it needs to be
submitted together with a patch for a driver that listens to the event
an acts upon it. New APIs without an upstream user are not allowed.
Also, please make sure you add a test under
tools/testing/selftests/net/forwarding/.

P.S. Please avoid top-posting as explained here:
https://docs.kernel.org/process/2.Process.html#mailing-lists
