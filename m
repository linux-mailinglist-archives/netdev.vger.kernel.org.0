Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D8A53E286
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiFFGKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 02:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiFFGKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 02:10:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B9D167F2
        for <netdev@vger.kernel.org>; Sun,  5 Jun 2022 23:10:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E138721A0C;
        Mon,  6 Jun 2022 06:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654495803;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u5VJj8kziE5hzYpzkMm1jidTfqorfW6tFCJibXgjnEQ=;
        b=sjF2jQ207HWJ4Jxf2rEHngQ44vNXLi7lRhDKbhhOIUbhCKdDkMk7ztTSL+c5kyYLFUAOcY
        iuToP7BoEZaj1V5hNF/uarP6sMbtO5lUXdNmwperXPkXJjkUU4XXyNL/uuIQSKBSFt2TZC
        Sw5x+DNXwY4h/32fl3DLGH2lw23TsLU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654495803;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u5VJj8kziE5hzYpzkMm1jidTfqorfW6tFCJibXgjnEQ=;
        b=PX2yTvhSfum4deOg1STexQ5HMR+aBaGMwYi18U0JDxxxwIKPoKheOJKg2SR6eMcbU1V2vl
        Gcga1+wIJy1t6vAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9DA6F139F5;
        Mon,  6 Jun 2022 06:10:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TyGlJDuanWIhPgAAMHmgww
        (envelope-from <pvorel@suse.cz>); Mon, 06 Jun 2022 06:10:03 +0000
Date:   Mon, 6 Jun 2022 08:10:01 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [RFC] Backporting "add second dif to raw, inet{6,}, udp,
 multicast sockets" to LTS 4.9
Message-ID: <Yp2aOQtK9uY+mSg+@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <YppqNtTmqjeR5cZV@pevik>
 <YpsvAludRUxuK22U@kroah.com>
 <d33dbbe6-57b0-85a1-83f8-435dd0a7c8c9@gmail.com>
 <YpuV7QnQNf3C2m3j@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YpuV7QnQNf3C2m3j@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Greg, all,

> On Sat, Jun 04, 2022 at 10:55:12AM -0600, David Ahern wrote:
> > On 6/4/22 4:08 AM, Greg Kroah-Hartman wrote:
> > > On Fri, Jun 03, 2022 at 10:08:22PM +0200, Petr Vorel wrote:
> > >> Hi all,

> > >> David (both), would it be possible to backport your commits from merge
> > >> 9bcb5a572fd6 ("Merge branch 'net-l3mdev-Support-for-sockets-bound-to-enslaved-device'")
> > >> from v4.14-rc1 to LTS 4.9?

> > >> These commits added second dif to raw, inet{6,}, udp, multicast sockets.
> > >> The change is not a fix but a feature - significant change, therefore I
> > >> understand if you're aginast backporting it.

> > >> My motivation is to get backported to LTS 4.9 these fixes from v5.17 (which
> > >> has been backported to all newer stable/LTS trees):
> > >> 2afc3b5a31f9 ("ping: fix the sk_bound_dev_if match in ping_lookup")
> > >> 35a79e64de29 ("ping: fix the dif and sdif check in ping_lookup")
> > >> cd33bdcbead8 ("ping: remove pr_err from ping_lookup")

> > >> which fix small issue with IPv6 in ICMP datagram socket ("ping" socket).

> > >> These 3 commits depend on 9bcb5a572fd6, particularly on:
> > >> 3fa6f616a7a4d ("net: ipv4: add second dif to inet socket lookups")
> > >> 4297a0ef08572 ("net: ipv6: add second dif to inet6 socket lookups")

> > > Can't the fixes be backported without the larger api changes needed?

> > > If not, how many commits are you trying to backport here?  And there's
> > > no need for David to do this work if you need/want these fixes merged.


> > I think you will find it is a non-trivial amount of work to backport the
> > listed patches and their dependencies to 4.9. That said, the test cases
> > exist in selftests to give someone confidence that it works properly
> > (you will have to remove tests that are not relevant for the
> > capabilities in 4.9).

> And 4.9.y is only going to be supported for 6 more months.  Why not just
> move to 4.14 or newer?  Peter, what is preventing you from doing that if
> you want this issue resolved on your systems?

Thanks a lot both for your input.

I'm sorry to not having check 4.9 EOL before. 6 months till EOL probably does
not justify non-trivial changes to fix this minor issue.

The motivation for me would be to get fixes for SLES15-SP2 LTSS,
afterwards (it's based on 4.12, thus it'd be some more extra work).

I'll might have second look on that, but It's probably not worth of investing lots of time.

Kind regards,
Petr

> thanks,

> greg k-h
