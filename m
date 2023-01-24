Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DAC678F09
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 04:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjAXDfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 22:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjAXDfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 22:35:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3B62C65A;
        Mon, 23 Jan 2023 19:35:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53837B80FF1;
        Tue, 24 Jan 2023 03:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1D1C433D2;
        Tue, 24 Jan 2023 03:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674531328;
        bh=6v776oDmiY1T8tt5r/hH/NeXosDTIpZCnrup9qoj41k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nrw6mqmdFGdpFjdBeYzRG0t8kI4jH95Zip/8oP/6NOSJZr5Em+19LZCIa9G0jNSrS
         5ZAbAhGE7iOtCs3zcpx1FPRDER/x9wZMBbqbr5fOtSm++BMiXJUd16tXy1x7nvFfTp
         mw5sp5vAXADvqQl6j9Jxt4XDlkcSHvnA831e8ANIioqNMHl0nZueX38Dnt87i6eGl0
         MXUkFvUTiBfWjdjfLhuBCgW0JfC5CBFb47W5rS8BNxOZlZjk748pWAY6wVwDOVdtoX
         DvLfN37Gi1pZvipGL/9ohp41mE2c1AsomX8FhDDvHXBrF63EPxYip1WMN+2O/bs/mP
         W9ezC/YbB0Fvg==
Date:   Mon, 23 Jan 2023 19:35:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Neal Cardwell <ncardwell@google.com>, selinux@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, kernel-team@cloudflare.com,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCH net-next v4 1/2] inet: Add IP_LOCAL_PORT_RANGE socket
 option
Message-ID: <20230123193526.065a9879@kernel.org>
In-Reply-To: <87sfg1vuqj.fsf@cloudflare.com>
References: <20221221-sockopt-port-range-v4-0-d7d2f2561238@cloudflare.com>
        <20221221-sockopt-port-range-v4-1-d7d2f2561238@cloudflare.com>
        <Y87IRq1ITGcWIh3F@unreal>
        <87sfg1vuqj.fsf@cloudflare.com>
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

On Mon, 23 Jan 2023 21:48:06 +0100 Jakub Sitnicki wrote:
> >> v1 -> v2:
> >>  * Fix the corner case when the per-socket range doesn't overlap with the
> >>    per-netns range. Fallback correctly to the per-netns range. (Kuniyuki)  
> >
> > Please put changelog after "---" trailer, so it will be stripped while
> > applying patch.  
> 
> I've put the changelog above the "---" on purpose. AFAIK, it is (was?)
> preferred by netdev maintainers to keep the changelog in the
> description.
> 
> Do you know if this convention is now a thing of the past? I might have
> missed something.

It used to be, the jury is still out on which way is better.
When Paolo/I apply the patch we add a lore link, so the changelog 
can be found easily even if it's cut off from git history.
OTOH DaveM/Linus are not fans of slapping the lore links on every 
single patch, so DaveM may still prefer the changelog above ---.
Sorry, that's not very helpful, you're both right in a way.
