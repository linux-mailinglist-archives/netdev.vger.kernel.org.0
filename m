Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAB856AF70
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 02:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236795AbiGHAVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 20:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGHAVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 20:21:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DD16EEB5;
        Thu,  7 Jul 2022 17:21:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF5AC625F6;
        Fri,  8 Jul 2022 00:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3220C3411E;
        Fri,  8 Jul 2022 00:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657239670;
        bh=iD66a2yH3e2FOfE8f244TwVOk+3Qw5uIbPlG/hJAAD0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hJ+c+4OJnlVAlrCvcbqfXqF4aInqz7rLVLnBaGVy7r0MAFbx8ffXwLmG4llFbcqRo
         CJf470wtA/VVB+M0xhl2WB9OgPlXPQ13Yzon4kV/sQDpuL+DANt40OhSpLufb8Gljb
         baojrDmYDaHnejNX22gKnjKkY39hz3IEnVx3mz7tkTXVF1XC4pB1R7BenUpkOwMIkK
         kcQbH8g38IoMCW2SeF3r1JjJSMKIQc7noP2Vh6H4iwALcqLh1N5Bm7Q4aE3kQGxcEh
         yjn5PVc3KqmyE2hTmleMLKOufBiiewE+DhkM5Ba+p7zIzCb9PBX6LUZPC1IpVvfAqy
         sOwpvSBIQkiIA==
Date:   Thu, 7 Jul 2022 17:21:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] neighbor: tracing: Have neigh_create event use
 __string()
Message-ID: <20220707172101.25ae51c8@kernel.org>
In-Reply-To: <20220705183741.35387e3f@rorschach.local.home>
References: <20220705183741.35387e3f@rorschach.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jul 2022 18:37:41 -0400 Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The dev field of the neigh_create event uses __dynamic_array() with a
> fixed size, which defeats the purpose of __dynamic_array(). Looking at the
> logic, as it already uses __assign_str(), just use the same logic in
> __string to create the size needed. It appears that because "dev" can be
> NULL, it needs the check. But __string() can have the same checks as
> __assign_str() so use them there too.
> 
> Cc: David Ahern <dsahern@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> 
> [ This is simpler logic than the fib* events, so I figured just
>   convert to __string() instead of a static __array() ]

This one is also going via your tree?
