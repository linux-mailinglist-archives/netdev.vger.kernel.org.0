Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64389623643
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 23:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiKIWBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 17:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiKIWBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 17:01:52 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7179D186E6
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 14:01:51 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 96C111FFFB;
        Wed,  9 Nov 2022 22:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1668031309;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YVdE+KBakYEPhRW2LJiVjMpFVZTHFUKTKX9sYfaoTkU=;
        b=JkfsXOcnwaKq+Suz5qbNpK5XFLquQZtk/+LGFnqyJA1903P+6KQD/mhU7Q9w7S2fB4xuh+
        dgbkQuLJyY+78MmhtG+2wT072U2X7WlQahQTxbIYySdlbpS+wuwZ75H5M/RWFr7ZsB2H2p
        s6Mvw//Bc2YRU0nvMF/eJh1TE0Y/80o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1668031309;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YVdE+KBakYEPhRW2LJiVjMpFVZTHFUKTKX9sYfaoTkU=;
        b=wvGUwXmuRVyBoP5u747T4wvSLBV3s2YCt/MqIPjHXDGdwQcYMsmH+ptyuZlq4e6mQo91bB
        s3s8ll7NLLdHqcAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3EBB5139F1;
        Wed,  9 Nov 2022 22:01:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wYiIDU0jbGNeFgAAMHmgww
        (envelope-from <pvorel@suse.cz>); Wed, 09 Nov 2022 22:01:49 +0000
Date:   Wed, 9 Nov 2022 23:01:47 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xin Long <lucien.xin@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Sami Kerola <kerolasa@iki.fi>
Subject: Re: ping (iputils) review (call for help)
Message-ID: <Y2wjS/xkCtRrKXhs@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <Y2OmQDjtHmQCHE7x@pevik>
 <d47c3f41-2977-3ffb-5c99-953088727a4b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d47c3f41-2977-3ffb-5c99-953088727a4b@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

first, thanks a lot for having a look!

> On 11/3/22 5:30 AM, Petr Vorel wrote:
> > Hi,

> > I'm sorry to bother you about userspace. I'm preparing new iputils release and
> > I'm not sure about these two patches.  As there has been many regressions,
> > review from experts is more than welcome.

> > If you have time to review them, it does not matter if you post your
> > comments/RBT in github or here (as long as you keep Cc me so that I don't
> > overlook it).

> > BTW I wonder if it make sense to list Hideaki YOSHIFUJI as NETWORKING
> > IPv4/IPv6 maintainer. If I'm not mistaken, it has been a decade since he was active.

> > * ping: Call connect() before sending/receiving
> > https://github.com/iputils/iputils/pull/391
> > => I did not even knew it's possible to connect to ping socket, but looks like
> > it works on both raw socket and on ICMP datagram socket.

> no strong opinion on this one. A command line option to use connect
> might be better than always doing the connect.
I was thinking about it, as it'd be safer in case of some regression.
If there is no other opinion I'll probably go this way, although I generally
prefer not adding more command line options.

> > * ping: revert "ping: do not bind to device when destination IP is on device
> > https://github.com/iputils/iputils/pull/396
> > => the problem has been fixed in mainline and stable/LTS kernels therefore I
> > suppose we can revert cc44f4c as done in this PR. It's just a question if we
> > should care about people who run new iputils on older (unfixed) kernels.


> I agree with this change. If a user opts for device binding, the command
> should not try to guess if it is really needed.

I guess Sami Kerola (the patch author) preferred ping functionality on wrongly
used ping's -I option. I've seen it the same even it causes kselftest
regressions and wait a bit longer. But ok, anybody who would care should
update kernel. I'll include this in upcoming iputils release.

Kind regards,
Petr
