Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B8460BE8C
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 01:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiJXXaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 19:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiJXX3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 19:29:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE8E52DF7
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:51:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF00CB810B2
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 21:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C934C433D7;
        Mon, 24 Oct 2022 21:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666648250;
        bh=/ENvohpluG/XaH83DTw5yDWU4oCfHJULqK/EPnnj+G0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dkE24BHp0qxk7PFe9gSvgoaJugXtWyk/4dSWv//RbF5KLnGKM6XJOZbTghbiJdRyx
         n6HLj/7weJOTeUgYfwGMvFOiYz2xpbja7Tj449pDQmN6E+4db16WRk0Yd3Kw/TjGF8
         43NAZjkCmKrTnOKyEULP8AAbpzBDNGZ8MntOo1oUyxEgwlTTBdxhVLeTXA+FzWVDF6
         lkrxjZMlzdkykEKl04Ou8aEpGIalMvSrqfxllUn23qV9dIiABbCmLRfvpMbDcFnDTG
         Grnu0Esm6AwyGW8jSbxgxMLgTVNZVjVZEUo4+UNA6WK9H8xr7MqHece9A4rK3ck2TZ
         /40dahpjXRJCg==
Date:   Mon, 24 Oct 2022 14:50:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>, Arnd Bergmann <arnd@kernel.org>
Cc:     Liang He <windhl@126.com>, davem@davemloft.net, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] appletalk: Fix potential refcount leak
Message-ID: <20221024145048.2b679a59@kernel.org>
In-Reply-To: <CANn89iL==crwYiOpcgx=zVG1porMpMt23RCp=_JGpQmxOwK04w@mail.gmail.com>
References: <20221024144753.479152-1-windhl@126.com>
        <CANn89iL==crwYiOpcgx=zVG1porMpMt23RCp=_JGpQmxOwK04w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Oct 2022 08:36:13 -0700 Eric Dumazet wrote:
> IMO appletalk is probably completely broken.
> 
> atalk_routes_lock is not held while other threads might use rt->dev
> and would not expect rt->dev to be changed under them
> (atalk_route_packet() )
> 
> I would vote to remove it completely, unless someone is willing to
> test any change in it.

+1 for killing all of appletalk.

Arnd, I think you suggested the removal in the past as well, or were
you just saying to remove localtalk ?
