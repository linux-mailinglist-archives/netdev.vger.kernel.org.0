Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29385A8BC9
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 05:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiIADHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 23:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbiIADH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 23:07:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA187E8698
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 20:07:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66306B823D9
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 03:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AE5C433C1;
        Thu,  1 Sep 2022 03:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662001646;
        bh=LahCQU1Yp63NFF6hiKZaYkZaJGq5KeO/cKvqx+TbI6o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tXN1ju4OGcD6pgPUXmSN0IRN/OOyZaFlb0N6EkxUYL6pGx2fsaL/Bz+3KG2kJXUPl
         Yzi2FaqBSktHhrvO5Izo4jrInpwE3Gs0hw3stxvTeRrVUJJ3PxZ/ob508s0qpl2VHe
         YzfGLqX1Go4V+vClOqeDHHHqvU95JNukHeaXrIJxrAoUfP/lDQvtBdfy73G9/0wsB0
         vUrPjl15XzvNd/6nTjbfAhr65nv9WpQ5zgeKplOvFX4GiSDv10WlrYMNKnlHEeLcsY
         M1BoMXex919U+ZwDCAWdipkpay95M4jWdDzez2BrVSCPvneAxkb6fK+nliFa7H668r
         P8hEgZAYdfkIw==
Date:   Wed, 31 Aug 2022 20:07:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        cake@lists.bufferbloat.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] sch_cake: Return __NET_XMIT_STOLEN when consuming
 enqueued skb
Message-ID: <20220831200724.45cb3b99@kernel.org>
In-Reply-To: <87wnao2ha3.fsf@toke.dk>
References: <20220831092103.442868-1-toke@toke.dk>
        <166198321517.20200.12054704879498725145.git-patchwork-notify@kernel.org>
        <87wnao2ha3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 01 Sep 2022 00:13:24 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Ah, crossed streams (just sent v2[0]).

Sorry about that, traveling knocked out my sense of time and I kept
thinking it's Thursday, and the discussion happened yesterday :S

> Hmm, okay, so as noted in the changelog to v2, just this patch will
> break htb+cake (because htb will now skip htb_activate()); do you prefer
> that I send a follow-up to fix HTB in this mode, or to revert this and
> apply the fix to sfb in v2 instead?

Reverted. Let's review v2 as if v1 was not applied.
