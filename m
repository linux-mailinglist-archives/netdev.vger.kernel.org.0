Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219BF4B0A7B
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 11:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239523AbiBJKY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 05:24:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239433AbiBJKY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 05:24:28 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBD3B88
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 02:24:29 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id E4724320204A;
        Thu, 10 Feb 2022 05:24:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 10 Feb 2022 05:24:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LrIRn5VKhkaIelBUd
        5QgSMt4jSPL/f+s0cnZksi2sbs=; b=Nhp9fI8dCnBj0uOXebOJd52pGXdnxLSWo
        YxPTq9XgRrzwWzPKvOfSi+4L6Hxwk+uMngNyXIKib4IaPX6IvGJl/QP+o3qHQtwI
        0JQU2pquZFcKN6XFzovNMykBgvXfjYbVkHYo0F9eiZyor5Xy3vJcYNm3XDEaVOUe
        jIYx3Xsill6keKPElLaVfZbIRJrynrXEGyAZ1ip7wOJsnQ4v7c8nhASI0qO1JF36
        g3HgvHnt2ia6WvaHZdYbUUoNz0zK06E33akmGOZQXqZ1VRAgxjXUnfxIz76dIfek
        b9HyKDEGWtCdbRoyIwYCk12KsqF+4lPNuXb/pi2+38DWpj6ia97rw==
X-ME-Sender: <xms:3OcEYrE6KjMTPTVCCSCXAZbiPKvwxZ6wJ1vR-XRLtq75kwbdSvODZA>
    <xme:3OcEYoUf2Jr5dKhrSJ-61aFyF9ASnzwnq3IWz_0QQZqOFMFAc9ZpZRNIsVWK4zxJY
    WWrNOeO1U7m5K0>
X-ME-Received: <xmr:3OcEYtJBU3aA1vO8Y8kaijtdcto7TZcK1BT4Jyd87pqZ7Dg8J5vn7eJB0Uyc_PtUKi-xXcrOfsKDmCSRqy-VToNZ9XHksg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddriedugdduhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:3OcEYpEeET33AE2L85zHCFPwAstbflQH1H0ej882EENqx0bd_mCwcw>
    <xmx:3OcEYhUOsImsfhM2T6YRn5TR15riBDxaE2knadcN89JSrba2ysMm9Q>
    <xmx:3OcEYkN53357J07SBasjaML-jxglduzH6bGvJ06A2339Q7jemiEVDQ>
    <xmx:3OcEYgcLfRYfTRuMO6zvI1u6r-RKvBkkUvuih4ERIP5NvJpnnFAxEA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Feb 2022 05:24:27 -0500 (EST)
Date:   Thu, 10 Feb 2022 12:24:25 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/5] Add support for locked bridge ports (for
 802.1X)
Message-ID: <YgTn2T9y3qW8Cgvw@shredder>
References: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
 <YgPsY6KrbDo2QHgX@shredder>
 <86r18bum2q.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86r18bum2q.fsf@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 10:07:09AM +0100, Hans Schultz wrote:
> On ons, feb 09, 2022 at 18:31, Ido Schimmel <idosch@idosch.org> wrote:
> > On Wed, Feb 09, 2022 at 02:05:32PM +0100, Hans Schultz wrote:
> >> This series starts by adding support for SA filtering to the bridge,
> >> which is then allowed to be offloaded to switchdev devices. Furthermore
> >> an offloading implementation is supplied for the mv88e6xxx driver.
> >
> > [...]
> >
> >> Hans Schultz (5):
> >>   net: bridge: Add support for bridge port in locked mode
> >>   net: bridge: Add support for offloading of locked port flag
> >>   net: dsa: Add support for offloaded locked port flag
> >>   net: dsa: mv88e6xxx: Add support for bridge port locked mode
> >>   net: bridge: Refactor bridge port in locked mode to use jump labels
> >
> > I think it is a bit weird to add a static key for this option when other
> > options (e.g., learning) don't use one. If you have data that proves
> > it's critical, then at least add it in patch #1 where the new option is
> > introduced.
> 
> Do you suggest that I drop patch #5 as I don't have data that it is
> critical?

Yes. That way all the bridge options are consistent. In the future, if
someone reports a performance degradation (unlikely), all the options
can be converted to use a static key.

> 
> >
> > Please add a selftest under tools/testing/selftests/net/forwarding/. It
> > should allow you to test both the SW data path with veth pairs and the
> > offloaded data path with loopbacks. See tools/testing/selftests/net/forwarding/README
> 
> I will do that.

Thanks!
