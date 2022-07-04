Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F600565C38
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 18:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbiGDQew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 12:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234690AbiGDQev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 12:34:51 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1187FB7E7
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 09:34:51 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7F7BD5C00E7;
        Mon,  4 Jul 2022 12:34:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 04 Jul 2022 12:34:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1656952489; x=
        1657038889; bh=3Up3m6alZgk2R346C+qiS5Tifw1UQ7YlcKyEcw7kJsE=; b=q
        uRsgs1672RNe8Niomlo6ppvcPe/By90t9I0WnUNDVKpMlxVE7lv6jgGrn4ajaDvr
        iSSAgQSlkoR+x6Kd5kNw5EJSmLai02ZR28QgJw93y4MHwfM0uunLsgnX4690jYB2
        5SiyeZr3/hJ2TrlQVsOrpoiOdHdK31yPtYFaFFBQu8Nrx3IfpIdZxJOqbCjaqfut
        w6o53p/bKeHuTW31T4e33xl4bznA1qCvJUVDa1yWsAJRqOGyiCrhp3KMlBju2FgP
        akeSOVWVy6KiLNiOquPvRux1Iq4tM35HujxJbZJCspIIp8h7X/n9ZDo8ttzZmWwp
        J9Kd1zJrs67HUT6pkXHDQ==
X-ME-Sender: <xms:qRbDYu76BHVXr58dj4Hg8pQZL3Yed6CMsviKRyVnaO1iiwCOywshFg>
    <xme:qRbDYn7H7kuEDiMGDCZMy7bjXt1h3j01BmQD_oLZp6M_la6o9t3ocx4fPnqUlF2W-
    LrJydHFV-xxsDA>
X-ME-Received: <xmr:qRbDYtd8bv8qztNc-lpsy1uMdbTwAbs4by9fm_d4dlTaVL9K7qxd0dl3dX5Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudehledguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepkfgu
    ohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrf
    grthhtvghrnhepudelvdejjeehgfdvteehfeehteejjeefteejveeijefgueejffelffeg
    keffueeinecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdho
    rhhg
X-ME-Proxy: <xmx:qRbDYrK9S9PWoyjsusHpFEgoTikEqluzNWdhq_S6su9kZ2VcYXcsEg>
    <xmx:qRbDYiJ1CXy-xdZve4CeFZ20SD5YmsG-4PaQAAS3TSQlx0QyhW5FUQ>
    <xmx:qRbDYswHgkf7H87YJ6S7Ojw4GUgqXE_dQwmHAnhlEGIK_cm2N2qQ-g>
    <xmx:qRbDYpVEraXrD-r36LImdyYHQlYuLPt93UF2YKzdVd0X8j3neZHGoQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 4 Jul 2022 12:34:48 -0400 (EDT)
Date:   Mon, 4 Jul 2022 19:34:46 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Petr Machata <petrm@nvidia.com>, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: Report: iproute2 build broken?
Message-ID: <YsMWpgwY/9GzcMC8@shredder>
References: <CAM0EoMkWjOYRuJx3ebY-cQr5odJekwCtxeM5_Cmu1G4vxZ5dpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM0EoMkWjOYRuJx3ebY-cQr5odJekwCtxeM5_Cmu1G4vxZ5dpw@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 11:51:39AM -0400, Jamal Hadi Salim wrote:
> I have to admit i am being lazy here digging into the
> root cause but normally iproute2 should just build
> standalone regardless especially when it is a stable
> version:
> 
> $ cat include/version.h
> static const char version[] = "5.18.0";
> 
> $make
> ..
> ....
> .....
>   CC       iplink_bond.o
> iplink_bond.c:935:10: error: initializer element is not constant
>   .desc = ipstats_stat_desc_bond_tmpl_lacp,
>           ^
> iplink_bond.c:935:10: note: (near initialization for
> ‘ipstats_stat_desc_xstats_bond_lacp.desc’)
> iplink_bond.c:957:10: error: initializer element is not constant
>   .desc = ipstats_stat_desc_bond_tmpl_lacp,
>           ^
> iplink_bond.c:957:10: note: (near initialization for
> ‘ipstats_stat_desc_xstats_slave_bond_lacp.desc’)
> ../config.mk:40: recipe for target 'iplink_bond.o' failed
> make[1]: *** [iplink_bond.o] Error 1
> Makefile:77: recipe for target 'all' failed
> make: *** [all] Error 2

Petr is OOO, not sure he will see your mail till later this week so I
will try to help. Can you try with current main branch [1] or just take
this patch [2] ?

[1] https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/log/
[2] https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=11e41a635cfab54e8e02fbff2a03715467e77ae9

> 
> There's more if you fix that one given a whole lot
> of dependencies
> 
> cheers,
> jamal
