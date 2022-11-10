Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2DB9623D34
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 09:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbiKJIPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 03:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbiKJIPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 03:15:45 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE531B1D0
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 00:15:44 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id AE559320097B;
        Thu, 10 Nov 2022 03:15:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 10 Nov 2022 03:15:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1668068142; x=1668154542; bh=j6849V1DTHJJWQGOaGeps23RvBOx
        AZHB1/WMoyeU9As=; b=gHGMuQ0p29L9K+AdGrvrcrMsXH6x4PPmRMM2MCbTNjbM
        rwASlADv4ERREsoduzA3nYDZSrCLxql9JHxPJf6nyHpHZJalBz5MtuZYxCaAzcnZ
        fV8GJBtN9Imjdkuq9u4kMx0tUpeobHVTH7cisCF+GvCxxZz3M9Ak6oLL73ji0XEQ
        2XgJ2ej9kDFsGgpgvIesJjLqdMKifyJ1wBNBIjcHxA5Ffdjk8XWbvM8Hf2cC2fHE
        SR5UdBoHO6Np9K4kAXcCDun/OuxLkNfBVSyQgtPwfFnda7oFS/9NPH3nPL22/NwO
        ekaVeyJO4+u6gJeAEXIwBUyfqUyu1MlOqcGeHuw8Ww==
X-ME-Sender: <xms:LrNsYx3n3HuiadZ6wStLXE34y2ZlqPOhdei9N74n9zAK3XN2Li7usg>
    <xme:LrNsY4GRZLFERSqGv3fTFfUDX_g-TlWA6grSnkUZ-bVna69GwLDRKYI7y6ng3p6uA
    yTctHEpsTba6eE>
X-ME-Received: <xmr:LrNsYx4y2NrGYK7rGED7hFL3S-gs9BbAcsWHqxUi3OCe-c8TduGn4Bh8NRnhsATc9RZ-pM70ziF8XG65hcKyf3t2018>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfeefgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:LrNsY-22n-fp68ICugT0bnZwQC2UW97xgE29aT7uUqbOh0zUp3NsfQ>
    <xmx:LrNsY0GVGYJ432z-mrs67aPbgDPBLyhc-CwsUigC7faDJz2fFOL6lA>
    <xmx:LrNsY_-Oz9fM9KXJIbJI1U2oCjKA_jmenitb4IAo4BnmApmavM5LTQ>
    <xmx:LrNsY-PSy8y0Cb7EqXmmnfrfQvq5ph4Sp71XVVcgwjdXTTN5vHAZfQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Nov 2022 03:15:41 -0500 (EST)
Date:   Thu, 10 Nov 2022 10:15:37 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Leonid Komaryanskiy <lkomaryanskiy@gmail.com>
Cc:     netdev@vger.kernel.org, dmytro_firsov@epam.com, petrm@nvidia.com
Subject: Re: ip_forward notification for driver
Message-ID: <Y2yzKfSPJ7h2arO/@shredder>
References: <CAHRDKfRZEw3Mq9GP3rCf2U10Y7X7N61BNZCa95tKESZkVD2qAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHRDKfRZEw3Mq9GP3rCf2U10Y7X7N61BNZCa95tKESZkVD2qAg@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 09:51:35AM +0200, Leonid Komaryanskiy wrote:
> I'm working on L3 routing offload for switch device and have a
> question about ip_forwarding. I want to disable/enable forwarding on
> the hardware side according to changing value in
> /proc/sys/net/ipv4/ip_forward. As I see, inet_netconf_notify_devconf
> just sends rtnl_notify for userspace. Could I ask you for advice, on
> how can I handle updating value via some notifier or some other Linux
> mechanism in driver?

You can look into netevents. See NETEVENT_IPV4_MPATH_HASH_UPDATE and
NETEVENT_IPV4_FWD_UPDATE_PRIORITY_UPDATE, for example.
