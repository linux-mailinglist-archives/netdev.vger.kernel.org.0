Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B60A54F809
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 15:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382424AbiFQNAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 09:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235059AbiFQNAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 09:00:04 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C45A5468A
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 06:00:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 34A0621DFC;
        Fri, 17 Jun 2022 13:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655470802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m27bqkhPWBkWqGci77bZ9vTpwsu6ToM/LTOx8XWw5NU=;
        b=ZEhGcKaTA/R7Kur07365e8q3915Ou/VpCToPh5Hl9BCrz5Xu7OlgZL2AD0YeQUR+LRYa2U
        klkuwI02sV/7qUyaErTqB+oPMv62VHkMOGu8hfHO8fZSegCcvn2VtNjSWe1CEA/aC1YrKX
        Oa927wElFteoiMIeiGVA50jB2oA6KoM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655470802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m27bqkhPWBkWqGci77bZ9vTpwsu6ToM/LTOx8XWw5NU=;
        b=2R1K+KN9BM/G2X83RCV8D967eq+TzFiL0dNTxqebbdFrjzeDQj2uiNd2YaSukLe92OxJkz
        K3SjUYyETOJRyMDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CC2F21348E;
        Fri, 17 Jun 2022 13:00:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id px/eLdF6rGIPCQAAMHmgww
        (envelope-from <iluceno@suse.de>); Fri, 17 Jun 2022 13:00:01 +0000
Date:   Fri, 17 Jun 2022 15:01:10 +0200
From:   Ismael Luceno <iluceno@suse.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Netlink NLM_F_DUMP_INTR flag lost
Message-ID: <20220617150110.6366d5bf@pirotess>
In-Reply-To: <20220616171612.66638e54@kernel.org>
References: <20220615171113.7d93af3e@pirotess>
        <20220615090044.54229e73@kernel.org>
        <20220616171016.56d4ec9c@pirotess>
        <20220616171612.66638e54@kernel.org>
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

On Thu, 16 Jun 2022 17:16:12 -0700
Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 16 Jun 2022 17:10:16 +0200 Ismael Luceno wrote:
> > On Wed, 15 Jun 2022 09:00:44 -0700
> > Jakub Kicinski <kuba@kernel.org> wrote:  
> > > On Wed, 15 Jun 2022 17:11:13 +0200 Ismael Luceno wrote:    
> > > > It seems a RTM_GETADDR request with AF_UNSPEC has a corner case
> > > > where the NLM_F_DUMP_INTR flag is lost.
> > > > 
> > > > After a change in an address table, if a packet has been fully
> > > > filled just previous, and if the end of the table is found at
> > > > the same time, then the next packet should be flagged, which
> > > > works fine when it's NLMSG_DONE, but gets clobbered when
> > > > another table is to be dumped next.    
> > > 
> > > Could you describe how it gets clobbered? You mean that prev_seq
> > > gets updated somewhere without setting the flag or something
> > > overwrites nlmsg_flags? Or we set _INTR on an empty skb which
> > > never ends up getting sent? Or..    
> > 
> > It seems to me that in most functions, but specifically in the case
> > of net/ipv4/devinet.c:in_dev_dump_addr or inet_netconf_dump_devconf,
> > nl_dump_check_consistent is called after each address/attribute is
> > dumped, meaning a hash table generation change happening just after
> > it adds an entry, if it also causes it to find the end of the table,
> > wouldn't be flagged.
> > 
> > Adding an extra call at the end of all these functions should fix
> > that, and spill the flag into the next packet, but would that be
> > correct?  
> 
> The whole _DUMP_INTR scheme does indeed seem to lack robustness.
> The update side changes the atomic after the update, and the read
> side validates it before. So there's plenty time for a race to happen.
> But I'm not sure if that's what you mean or you see more issues.

No, I'm concerned that while in the dumping loop, the table might
change between iterations, and if this results in the loop not finding
more entries, because in most these functions there's no
consistency check after the loop, this will go undetected.

> > It seems this condition is flagged correctly when NLM_DONE is
> > produced, I couldn't see why, but I'm guessing another call to
> > nl_dump_check_consistent...
> > 
> > Also, I noticed that in net/core/rtnetlink.c:rtnl_dump_all: 
> > 
> > 	if (idx > s_idx) {
> > 		memset(&cb->args[0], 0, sizeof(cb->args));
> > 		cb->prev_seq = 0;
> > 		cb->seq = 0;
> > 	}
> > 	ret = dumpit(skb, cb);
> > 
> > This also prevents it to be detect the condition when dumping the
> > next table, but that seems desirable...  
> 
> That's iterating over protocols, AFAICT, we don't guarantee
> consistency across protocols.

That's reasonable, I was just wondering about it because it does seem
reasonable that the flags affect only the packets describing the table
whose dump got interrupted...

-- 
Ismael Luceno
SUSE L3 Support
