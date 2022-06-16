Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8B954E5B8
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 17:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377852AbiFPPJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 11:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377857AbiFPPJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 11:09:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C3640A0D
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 08:09:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 58B4C21D14;
        Thu, 16 Jun 2022 15:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655392160; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PrKklGjZV+/+S6olpVpuw+i5kBkdW6bisGmsz3rQ96w=;
        b=LKXKYfZ7uhY/UkeUPRXRe3dz5BtsTSOYLCbM0QydqFe1FM1cGeU59ucEJyK4eECHjBH7zU
        g7ULcdqCZlvmtHAIsy3TESocFrGURFOHrG1VKLKPTH/GXECsF2ItiNmG/9+DNOzbrDCd1C
        IdKM0azggyrOTj/CrYdX4Hky/gg9pb8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655392160;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PrKklGjZV+/+S6olpVpuw+i5kBkdW6bisGmsz3rQ96w=;
        b=HEA2LazosVhG1i5SoMSBkaBklns443EPlKOp6hXl99d47njD20VLAs8Zwnxv9TsGBEClBT
        5HpITb2vn1n98mBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 00B2C1344E;
        Thu, 16 Jun 2022 15:09:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wYC7OJ9Hq2JBPQAAMHmgww
        (envelope-from <iluceno@suse.de>); Thu, 16 Jun 2022 15:09:19 +0000
Date:   Thu, 16 Jun 2022 17:10:16 +0200
From:   Ismael Luceno <iluceno@suse.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Netlink NLM_F_DUMP_INTR flag lost
Message-ID: <20220616171016.56d4ec9c@pirotess>
In-Reply-To: <20220615090044.54229e73@kernel.org>
References: <20220615171113.7d93af3e@pirotess>
        <20220615090044.54229e73@kernel.org>
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

On Wed, 15 Jun 2022 09:00:44 -0700
Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed, 15 Jun 2022 17:11:13 +0200 Ismael Luceno wrote:
> > It seems a RTM_GETADDR request with AF_UNSPEC has a corner case
> > where the NLM_F_DUMP_INTR flag is lost.
> > 
> > After a change in an address table, if a packet has been fully
> > filled just previous, and if the end of the table is found at the
> > same time, then the next packet should be flagged, which works fine
> > when it's NLMSG_DONE, but gets clobbered when another table is to
> > be dumped next.
> 
> Could you describe how it gets clobbered? You mean that prev_seq gets
> updated somewhere without setting the flag or something overwrites
> nlmsg_flags? Or we set _INTR on an empty skb which never ends up
> getting sent? Or..

It seems to me that in most functions, but specifically in the case of
net/ipv4/devinet.c:in_dev_dump_addr or inet_netconf_dump_devconf,
nl_dump_check_consistent is called after each address/attribute is
dumped, meaning a hash table generation change happening just after it
adds an entry, if it also causes it to find the end of the table,
wouldn't be flagged.

Adding an extra call at the end of all these functions should fix that,
and spill the flag into the next packet, but would that be correct?

It seems this condition is flagged correctly when NLM_DONE is produced,
I couldn't see why, but I'm guessing another call to
nl_dump_check_consistent...

Also, I noticed that in net/core/rtnetlink.c:rtnl_dump_all: 

	if (idx > s_idx) {
		memset(&cb->args[0], 0, sizeof(cb->args));
		cb->prev_seq = 0;
		cb->seq = 0;
	}
	ret = dumpit(skb, cb);

This also prevents it to be detect the condition when dumping the next
table, but that seems desirable...

Am I grasping it correctly?

Some functions like net/core/rtnetlink.c:rtnl_dump_ifinfo do call
nl_dump_check_consistent when finishing, but I'm seeing most others
don't do that, instead doing it only when adding an entry to the packet
(another example is: rtnl_stats_dump).

Again, while adding the check at the end of each function would solve
these inconsistencies, it isn't so clear to me that spilling this flag
into the next packet when it's going to be from another table is a good
idea.

It might make more sense to emit a new packet type just for the flag,
that way, in the sequence of packets, the client can reliably tell the
dump of which tables was interrupted, and make some decision based on
that, vs having to deem all tables affected...

-- 
Ismael Luceno
SUSE L3 Support
