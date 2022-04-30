Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D677A515AFC
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 09:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382282AbiD3Hf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 03:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346476AbiD3Hfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 03:35:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A8EB18BD
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 00:32:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A788EB81A52
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 07:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCED5C385AA;
        Sat, 30 Apr 2022 07:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651303951;
        bh=DQ6WOzxMeLwnTLK9t4EyQeSkurSdpNbJ4qmwWJCUbq0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=O80uBjJNemAFmQ0JYdbKMQF+id9MzpejBEOi53Gz0muw2DYvwRr+MFuAj/bbHc+FE
         wAXrGHKA1D+PqNqeV0Ti68fJityOBRjyRR+z7SDecGbB9DvgAvvp6JS81bJRjvGopP
         k7y8bDeAIDhd2BMSthsMXtQYX1nqjtZMVUXoMefAz1Zfy+0L+vlS8uC7w+QhIAsbpr
         FxuMp/++ffaj45/2DT4DQWS1FD/Ibfrh0EAgHYPzppxqiy2RtE1DHbLBXDGyMGs1Rp
         6MLTHXJ9/Wi8Rds1ffkQ0FTZvEJk3OZVHSw2JENE1wULkYGeO9USh2C3pMXqUPx04G
         rJFXnNJELSJgQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com
Subject: Re: [PATCH net-next 1/3] rtnl: allocate more attr tables on the heap
In-Reply-To: <20220429235508.268349-2-kuba@kernel.org> (Jakub Kicinski's
        message of "Fri, 29 Apr 2022 16:55:06 -0700")
References: <20220429235508.268349-1-kuba@kernel.org>
        <20220429235508.268349-2-kuba@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Sat, 30 Apr 2022 10:32:25 +0300
Message-ID: <87pmkzc9h2.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> Commit a293974590cf ("rtnetlink: avoid frame size warning in rtnl_newlink()")
> moved to allocating the largest attribute array of rtnl_newlink()
> on the heap. Kalle reports the stack has grown above 1k again:
>
>   net/core/rtnetlink.c:3557:1: error: the frame size of 1104 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
>
> Move more attrs to the heap, wrap them in a struct.
> Don't bother with linkinfo, it's referenced a lot and we take
> its size so it's awkward to move, plus it's small (6 elements).
>
> Reported-by: Kalle Valo <kvalo@kernel.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

I don't see the warning anymore, thanks!

Tested-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
