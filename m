Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532F555EDFD
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbiF1To3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiF1Tn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:43:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA5A3C482
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 12:36:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DAB861F970;
        Tue, 28 Jun 2022 19:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1656444990; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VZs8Q61SFyV147q9I2vsb2nRYt3Il8NuVtOT6GvqwtA=;
        b=d9UHVzeVbrgjsgec21/a8AiWbZr1/PVeqj9E6NuOxH9+6JHMlIf4k2qh+actzxd6RhpEUP
        lCJwlzo11z/gUWQTH/2Il+r9xjZONdWkmruBMR9SMkxjcgxDqR1algEHLQhKHtsyyiyztn
        iW00nbVxnzgZs1gagZXWdjd0QdAxtko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1656444990;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VZs8Q61SFyV147q9I2vsb2nRYt3Il8NuVtOT6GvqwtA=;
        b=wst6OaKim+vfeh+O3wRPA4oxO7wnrohI3+f0e5q3yzy1dME+OqbdZN3vYRYkJBpN/KTUIl
        4ZHRJEOAQbwxqrAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 834BA13ACA;
        Tue, 28 Jun 2022 19:36:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DFAlHT5Yu2IpWQAAMHmgww
        (envelope-from <iluceno@suse.de>); Tue, 28 Jun 2022 19:36:30 +0000
Date:   Tue, 28 Jun 2022 21:38:37 +0200
From:   Ismael Luceno <iluceno@suse.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Netlink NLM_F_DUMP_INTR flag lost
Message-ID: <20220628213837.4502080a@pirotess>
In-Reply-To: <20220623120307.602e1d10@kernel.org>
References: <20220615171113.7d93af3e@pirotess>
        <20220615090044.54229e73@kernel.org>
        <20220616171016.56d4ec9c@pirotess>
        <20220616171612.66638e54@kernel.org>
        <20220617150110.6366d5bf@pirotess>
        <20220622131218.1ed6f531@pirotess>
        <20220622165547.71846773@kernel.org>
        <fef8b8d5-e07d-6d8f-841a-ead4ebee8d29@gmail.com>
        <20220623090352.69bf416c@kernel.org>
        <bd76637b-0404-12e3-37b6-4bdedd625965@gmail.com>
        <20220623093609.1b104859@kernel.org>
        <da0875aa-6829-c396-0577-2e400c1041c7@gmail.com>
        <20220623120307.602e1d10@kernel.org>
Organization: SUSE
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jun 2022 12:03:07 -0700
Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 23 Jun 2022 11:31:34 -0600 David Ahern wrote:
> > >> All of the dumps should be checking the consistency at the end
> > >> of the dump - regardless of any remaining entries on a
> > >> particular round (e.g., I mentioned this what the nexthop dump
> > >> does). Worst case then is DONE and INTR are set on the same
> > >> message with no data, but it tells explicitly the set of data
> > >> affected.  
> > > 
> > > Okay, perhaps we should put a WARN_ON_ONCE(seq && seq != prev_seq)
> > > in rtnl_dump_all() then, to catch those who get it wrong.  
> > 
> > with '!(nlh->msg_flags & INTR)' to catch seq numbers not matching
> > and the message was not flagged?
> 
> Yup.
> 
> Ismael, do you want to send a patch for either version of the solution
> or do you expect one of us to do it?

I'll prepare a patch; thanks for the feedback.

-- 
Ismael Luceno
SUSE L3 Support
