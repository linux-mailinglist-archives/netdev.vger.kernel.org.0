Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7318D598AAC
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245424AbiHRRpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345082AbiHRRpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:45:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D44C7172B;
        Thu, 18 Aug 2022 10:45:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D15F9CE2245;
        Thu, 18 Aug 2022 17:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBD4C433D6;
        Thu, 18 Aug 2022 17:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660844707;
        bh=Yy+ZnKIzuSTYizYHaXdO9bWgHRUoHQWc79KX44UlvY4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DH2c+E+iUEBbOPOkg3JnkMIfh2S9eUN+Ph2tqIo7cnYaoMvXzKjwg2PvcSxggEyWA
         xDeJAejwcJPD8pZ3xuJ7bXMxXIfjKxNEtGy96/yXsYb5U5Bc106kr/y/P4hYbkdOAy
         OhwQ5O4ImY4ap94LKkm15HQphjZDS8KOuMcystSwpopcP7j3t0ObIdCeo9+yZbDETs
         kkTgnYuSyfjbq14PHiZ9z3dds9CIYihMEnppb1gNBSSGIP5fqrM5xaHfDKydKMWtUK
         MmIu/y8g5jlm43FO7k9gmOwEp9ko0UQc49D1uWmCvKElcP5xoyOWAM6bQC/0j/RU0e
         i4rW8G2pylAQQ==
Date:   Thu, 18 Aug 2022 10:45:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 9/9] u64_stat: Remove the obsolete fetch_irq() variants
Message-ID: <20220818104505.010ff950@kernel.org>
In-Reply-To: <Yv5v1E6mfpcxjnLV@linutronix.de>
References: <20220817162703.728679-1-bigeasy@linutronix.de>
        <20220817162703.728679-10-bigeasy@linutronix.de>
        <20220817112745.4efd8217@kernel.org>
        <Yv5aSquR9S2KxUr2@linutronix.de>
        <20220818090200.4c6889f2@kernel.org>
        <Yv5v1E6mfpcxjnLV@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Aug 2022 18:59:00 +0200 Sebastian Andrzej Siewior wrote:
> On 2022-08-18 09:02:00 [-0700], Jakub Kicinski wrote:
> > No ack, I'd much rather you waited for after the next merge window 
> > and queued this refactoring to net-next. Patch 9 is changing 70
> > files in networking. Unless I'm missing something and this is time
> > sensitive.  
> 
> It started with the clean up of the mess that has been made in the merge
> and then it went on a little.
> 
> Any opinion on 8/9? It could wait for the next merge window if you want
> to avoid a feature branch to pull from.

A question of priority, hard for me to judge how urgent any of it is.
But practically speaking the chances of a conflict on that one header
are pretty small, so ack if needed.

> Regarding 9/9. This is a clean up, which is possible after 8/9. It can
> definitely be applied later.
> I assume you want only see the networking bits so I would split the
> other subsystem out. I guess instead the big net patch I split them on
> per driver vendor basis + net/ subsys?

Oh, don't care for per vendor split on a big refactoring like that.
You can split out the SPI patch and maybe BPF, the rest can be one 
big chunk AFAICT.

BTW, I have a hazy memory of people saying they switched to the _irq()
version because it reduced the number of retries significantly under
traffic. Dunno how practical that is but would you be willing to scan
the git history to double check that's not some of the motivation?
