Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B134D1D9C
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 17:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240747AbiCHQnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 11:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348901AbiCHQnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 11:43:14 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5385133C
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 08:42:09 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B00A05C01E5;
        Tue,  8 Mar 2022 11:42:00 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 08 Mar 2022 11:42:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7yj26ohyDdcKx1mkO
        Az2MDvrBl9ahXsAz/9D3NPDx60=; b=U0CY9uFgmir3iLDyu/0WdR4E18rKmcKWa
        8HZNpzCabObHBKFVrgAEslgTV+AMHQQU6yf/WgJgkljpl1oQ5EYc6YB/1+sv4lMq
        VG1BgWF/acwJVABOYhtHhCCcwvjlvdHNAT2jxN06GzJ6UDS6r1X1K7+L3LhXEZF+
        F4q2Zn7g8muqPopJdHeyfCsBsbHkv8HRgFhXj+WUIGKrAM1lzujlX+glu0lO1coA
        i4c8YQax4fTEApDPySgnsn9BnYYeaUg4zFNlhf2x/cAJ7W6G9t8fmKHr+IFg70D7
        eVKrFT9JiBBYXPqw9uBlAP+yqbb8+Kb17RR1NgtJQeHOhWYgWtAtg==
X-ME-Sender: <xms:WIcnYgiwIZ5k0GpX2iwVHQ8EzsqFgSo7x-ulUPYgQCnsAp6MMV5u3g>
    <xme:WIcnYpA_1RfVfopr47tNafPWsapzlIAVL72o5mWdIetRIKGA5lzIdz3PvoxyS69cT
    aMKnq97PNn3FBM>
X-ME-Received: <xmr:WIcnYoHIBy3fpnBSLk3FOe3muINH1iFev6YVV53v9V9vVsdYSmlrZhSt5b8JRBFQNENywZFxI8PpkFV-721S1qVzoUY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudduiedgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeffuedukeeljeefvdeftefgveduudekieeludegleekjeethfevgeehkeejgedt
    tdenucffohhmrghinhepfhgvughorhgrphhrohhjvggtthdrohhrghenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:WIcnYhSxQySXBeVUIEX4JGJsjNJX1ynrENgYktquW9ezVvKow8SCAg>
    <xmx:WIcnYtwhnhQ93yCb-KJWuwwmtBCk_ucpVACb3RXQQWehiChZbFycRA>
    <xmx:WIcnYv6udlnz2v4TPhRdcAXu0DF-ELF3anHYrCr4OXY4c3kkkhWwRQ>
    <xmx:WIcnYrYUe-VKtCf_EfN7dv7dD76s8ftbUVFiImCXaWsGqsfCYhxa-Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Mar 2022 11:41:59 -0500 (EST)
Date:   Tue, 8 Mar 2022 18:41:56 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
Subject: Re: [PATCH iproute2-next] configure: Allow command line override of
 toolchain
Message-ID: <YieHVALfKnVbqYru@shredder>
References: <20220228015435.1328-1-dsahern@kernel.org>
 <Yh93f0XP0DijocNa@shredder>
 <dfe64c90-88ea-9d85-412e-d2064f3f5e52@kernel.org>
 <YiYgPnn9wtXbOm0a@shredder>
 <8882d949-35bb-8fad-c047-92fb5091c33b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8882d949-35bb-8fad-c047-92fb5091c33b@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 09:26:49AM -0700, David Ahern wrote:
> On 3/7/22 8:09 AM, Ido Schimmel wrote:
> > 
> > I realize it was already merged (wasn't asking for academic purposes),
> > but rather wanted you to verify that the patch is not needed on your end
> > so that I could revert it. I can build with gcc/clang even without the
> > patch. With the patch, the build is broken on Fedora as "yacc" is not a
> > build dependency [1]. Verified this with a clean install of Fedora 35:
> > Can't build iproute with this patch after running "dnf builddep
> > iproute". Builds fine without it.
> > 
> > [1] https://src.fedoraproject.org/rpms/iproute/blob/rawhide/f/iproute.spec#_22
> 
> I booted a Fedora 35 VM and see what you mean. I can not find the
> difference as to why Ubuntu 20.04 is ok and Fedora 35 is not, so I
> reverted the patch.

I tested with Ubuntu 21.10 yesterday and it worked for me as well.
There 'yacc' eventually points to '/usr/bin/bison.yacc'.

Anyway, thanks for taking care of that
