Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E7F681806
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbjA3RuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjA3RuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:50:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D88A302A9;
        Mon, 30 Jan 2023 09:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A34960F15;
        Mon, 30 Jan 2023 17:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607D9C433D2;
        Mon, 30 Jan 2023 17:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675101011;
        bh=1VBfxkrJ2jG7gVZ5bzrTzKycDwCYzooR1eYXc8bkWjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q4NwZmbm5DGxLaDRzc97uWryRvRm74rNOeUP4N3v/ZP6ca6IUz4i/YnNv+UDxzNxZ
         nuTWsPOSOWYUfNGv7pz6VCnBsDv7APDGoOn2fJo17ClkgCFA2zVbjr03EJbN3HLH04
         uW49Vetpo5fANZiQBXTs1dxIro0eQm4DFSkvz90Yv31H34QkHusqSqk8JbVSOaKnUj
         a8n+JU8Nm6pZUIWGqqb5jv/pyd1eBA8PxyJiSmPCCguuZTyfC0YrynqVAkBs+pIEY1
         R6cR7lfmD2H9h+DgY2WSqtRZ7UooQ9PtzLCW/m+Eks5xUhz9Elg8xiYwjYqUqdMbYs
         5G+Rzv4T6R/AA==
Date:   Mon, 30 Jan 2023 11:50:10 -0600
From:   Seth Forshee <sforshee@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <Y9gDUi79peQwf1MS@do-x1extreme>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley>
 <Y9LswwnPAf+nOVFG@do-x1extreme>
 <20230127044355.frggdswx424kd5dq@treble>
 <Y9OpTtqWjAkC2pal@hirez.programming.kicks-ass.net>
 <20230127165236.rjcp6jm6csdta6z3@treble>
 <20230127170946.zey6xbr4sm4kvh3x@treble>
 <20230127221131.sdneyrlxxhc4h3fa@treble>
 <Y9e6ssSHUt+MUvum@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9e6ssSHUt+MUvum@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 01:40:18PM +0100, Peter Zijlstra wrote:
> Both ways this seems to make KLP 'depend' (or at least work lots better)
> when PREEMPT_DYNAMIC=y. Do we want a PREEMPT_DYNAMIC=n fallback for
> _cond_resched() too?

I would like this, as we have no other need for PREEMPT_DYNAMIC=y and
currently have it disabled.

Thanks,
Seth
