Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085635F3AA2
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 02:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiJDAaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 20:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiJDA35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 20:29:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287A0222
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 17:29:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8F7C61155
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 00:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4364C433D6;
        Tue,  4 Oct 2022 00:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664843395;
        bh=UNZ4IcHQ8FXT87CoTJ9Kjy6ewQVaBpl70nKZe+hKT/M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T5judg5ktMFhZMMMiqG7EUfLLR0k6CYO9qXhcCn/jsxGufUA9TsHELmgjw7uHoRQd
         OUa9Z7iBapRZuR1H8GjMaq5PSJgF/in13373eUsGXm9R0oZIUqWm3w0xyAwZUHVtAP
         yA9l29Xqd3Ykhxjy2dgSEJKQUuGaPnm36igJMvpgHRFTbzNlLZOEz0K8Kc3w8NjwO9
         LvGfyQB+yQg/XpM1uX4jNlvuK6RjLx+jn9yxja4KxxKvK3D3kx2nplNO2sMtiFEYTA
         H9/w4jKh3r67+n/CXaBWaZui+texV9NCAhXeQgk75gXLn5F4ht1RvpnnJYsr3cuMoi
         xGmhGoU/wu4lw==
Date:   Mon, 3 Oct 2022 17:29:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>
Subject: Re: [PATCH 0/4] net: drop netif_attrmask_next*()
Message-ID: <20221003172953.128735bf@kernel.org>
In-Reply-To: <Yzt5Q6G8v5xuYD7s@yury-laptop>
References: <20221002151702.3932770-1-yury.norov@gmail.com>
        <20221003095048.1a683ba7@kernel.org>
        <YzsluT4ET0zyjCtp@yury-laptop>
        <20221003162556.10a80858@kernel.org>
        <Yzt5Q6G8v5xuYD7s@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Oct 2022 17:07:31 -0700 Yury Norov wrote:
> > I see. Is that patch merged and on it's way?  
> 
> This patch is already in pull request.
> 
> > Perhaps we can just revert it and try again after the merge window?  
> 
> I don't understand this. To me it looks fairly normal - the check has
> been fixed and merged (likely) in -rc1. After that we have 2 month to
> spot, fix and test all issues discovered with correct cpumask_check().
> 
> I'm not insisting in moving this series in -rc1. Let's give it review
> and careful testing, and merge in -rc2, 3 or whatever is appropriate.
> 
> Regarding cpumask_check() patch - I'd like to have it in -rc1 because
> it will give people enough time to test their code...

AFAIU you can keep the cpumask_check() patch, we just need to revert
the netdev patch from your earlier series?

If so I strongly prefer that we revert the broken cleanup rather than
try to pile on more re-factoring. The trees are not going anywhere, we 
can queue the patches for 6.2.
