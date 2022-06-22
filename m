Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77865554651
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244997AbiFVLKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 07:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbiFVLKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 07:10:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0A73C481
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 04:10:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 362611F8CF;
        Wed, 22 Jun 2022 11:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655896248; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F2WNIxFaMF2KIOAie5EuOE7wF5zeDB8KVeSzlfKCYks=;
        b=0iPCFBHVdvrcMzbXrIItRWUWCoWr6kQMD4TppNPeuVhX7yfNeJgnhsZbpG/AknMyDXg/U+
        gtluKXV9R9m8tFnwVxJQWm5GglDaURescg8m1hrgK4omABKixw6cmQI+xQUbZfCWCJCBOG
        f9VY7wB2JtReL5FQus17798y1CbmVFw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655896248;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F2WNIxFaMF2KIOAie5EuOE7wF5zeDB8KVeSzlfKCYks=;
        b=V67zF5A3Jg37/o4FzYxLQmO+8YujfG/vnjdN3CIr+xPqjVIhwCm1E1gx2jbl4aD71vZ2RJ
        N6xbZYZEqKMqrlBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D4D68134A9;
        Wed, 22 Jun 2022 11:10:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Zaj/MLf4smJPYwAAMHmgww
        (envelope-from <iluceno@suse.de>); Wed, 22 Jun 2022 11:10:47 +0000
Date:   Wed, 22 Jun 2022 13:12:18 +0200
From:   Ismael Luceno <iluceno@suse.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Netlink NLM_F_DUMP_INTR flag lost
Message-ID: <20220622131218.1ed6f531@pirotess>
In-Reply-To: <20220617150110.6366d5bf@pirotess>
References: <20220615171113.7d93af3e@pirotess>
        <20220615090044.54229e73@kernel.org>
        <20220616171016.56d4ec9c@pirotess>
        <20220616171612.66638e54@kernel.org>
        <20220617150110.6366d5bf@pirotess>
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

On Fri, 17 Jun 2022 15:01:10 +0200
Ismael Luceno <iluceno@suse.de> wrote:
> On Thu, 16 Jun 2022 17:16:12 -0700
> Jakub Kicinski <kuba@kernel.org> wrote:
<...>
> > That's iterating over protocols, AFAICT, we don't guarantee
> > consistency across protocols.  
> 
> That's reasonable, I was just wondering about it because it does seem
> reasonable that the flags affect only the packets describing the table
> whose dump got interrupted...

So, just for clarification:


Scenario 1:
- 64 KB packet is filled.
- protocol table shrinks
- Next iteration finds it's done
- next protocol clears the seq, so nothing is flaged
- ...
- NLMSG_DONE (not flagged)

Scenario 2:
- 64 KB packet is filled.
- protocol table shrinks
- Next iteration finds it's done
- NLMSG_DONE (flagged with NLM_F_DUMP_INTR)

So, in order to break as little as possible, I was thinking about
introducing a new packet iff it happens we have to signal INTR between
protocols.

Does that sound good?

-- 
Ismael Luceno
SUSE L3 Support
