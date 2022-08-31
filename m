Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393B35A87AC
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 22:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiHaUoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 16:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiHaUoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 16:44:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7ED5E9930;
        Wed, 31 Aug 2022 13:44:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EDE2619D7;
        Wed, 31 Aug 2022 20:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95363C433D6;
        Wed, 31 Aug 2022 20:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661978660;
        bh=9Bwpo1D89MJ/hVSIxu/hVkgK4U0pG9f7PNtDAmOTW9s=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=PI2Eqy829urvjjVUfqmZ4dEvzt5cErNpfQMg1PaWJ6qxrz3mvWKIc95raJyuEl1t3
         lw45DwV3P3IemhDpGh+ewaeLRD0fG8vha2YGVdd3ra8Dvy4hwRHP12VgQckLDdw8CR
         evwbME9UY0N8NFw33+z2pMcMhp+jydcZXxoyX/7CUWoGE4qTFZzyUAovGWziFi+1H+
         MqMWYHKzvFM7Baabpcsn0wGF/a7N0MWgngojcjJKzLkZlItTxyIIvPXt2FMi4sIaoa
         olTiOeeku74gteazj8LtehQwxbpgNCVpJtCypme5Bmohz9S8fsldKdJRuAq46KBJbS
         4OGZ88+9bg1Iw==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 34119588B6F; Wed, 31 Aug 2022 22:44:18 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
In-Reply-To: <20220831152624.GA15107@breakpoint.cc>
References: <20220831101617.22329-1-fw@strlen.de> <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc> <87o7w04jjb.fsf@toke.dk>
 <20220831135757.GC8153@breakpoint.cc> <87ilm84goh.fsf@toke.dk>
 <20220831152624.GA15107@breakpoint.cc>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 31 Aug 2022 22:44:18 +0200
Message-ID: <87edww3zz1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> But, all things considered, what about this:
>
> I'll respin, with the FILENAME attribute removed, so user says
> 'ebpf pinned bla', and on listing nft walks /sys/bpf/nft/ to see if
> it can find the name again.
>
> If it can't find it, print the id instead.
>
> This would mean nft would also have to understand
> 'ebpf id 12' on input, but I think thats fine. We can document that
> this is not the preferred method due to the difficulty of determining
> the correct id to use.
>
> With this, no 'extra' userspace-sake info needs to be stored.
> We can revisit what do with 'ebpf file /bla/foo.o' once/if that gets
> added.
>
> What do you think?
> Will take a while because I'll need to extend the nft side first to cope
> with lack of 'FILENAME' attribute.

To the extend it's still relevant, yeah, this seems like a reasonable
plan to me :)

-Toke
