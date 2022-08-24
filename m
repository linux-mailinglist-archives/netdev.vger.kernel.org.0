Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B596259F840
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 12:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236262AbiHXK7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 06:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236189AbiHXK7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 06:59:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A6E6613F
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 03:59:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F23A920539;
        Wed, 24 Aug 2022 10:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661338744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4S/CnmR5vI3wq2fmClpwFjobmqPL/cm4I7V+2GM9KSU=;
        b=qz4WewNQcvc1dEKeqj0cn/dyWoMBez+NfgLeu7mWRXoLD4hSFxI1lwaSy4JWCcm3TTSFSJ
        THNuC7gEIl734C6xWx3VAOmk5QUFtv2tU0DBzpd9JWF/nWfPbmMHWuDowEoyiZNYtNbf18
        93l6aor5OTlBAU9zkqZ0fpNVrdE6XNc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661338744;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4S/CnmR5vI3wq2fmClpwFjobmqPL/cm4I7V+2GM9KSU=;
        b=Tj59XWmU0Q19VxKK2nLgB/4pfYWeoLHC7RxqZOPUgMq2Mm6j4VNH6TPWCjIwfRVFS5lXSJ
        FKkXunAB8O8GW+Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8A8C313780;
        Wed, 24 Aug 2022 10:59:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NygOH3gEBmPeKAAAMHmgww
        (envelope-from <iluceno@suse.de>); Wed, 24 Aug 2022 10:59:04 +0000
Date:   Wed, 24 Aug 2022 12:59:01 +0200
From:   Ismael Luceno <iluceno@suse.de>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: Netlink NLM_F_DUMP_INTR flag lost
Message-ID: <20220824125901.21a28927@pirotess>
In-Reply-To: <b0246015-7fe6-7f30-c5ae-5531c126366f@gmail.com>
References: <20220615171113.7d93af3e@pirotess>
 <20220615090044.54229e73@kernel.org>
 <20220616171016.56d4ec9c@pirotess>
 <20220616171612.66638e54@kernel.org>
 <20220617150110.6366d5bf@pirotess>
 <9598e112-55b5-a8c0-8a52-0c0f3918e0cd@gmail.com>
 <20220617082225.333c5223@kernel.org>
 <b0246015-7fe6-7f30-c5ae-5531c126366f@gmail.com>
Organization: SUSE
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/Jun/2022 10:28, David Ahern wrote:
> On 6/17/22 9:22 AM, Jakub Kicinski wrote:
<...>
> > FWIW what I think is strange is that we record the gen id before the
> > dump and then check if the recorded version was old. Like.. what's
> > the point of that? Nothing updates cb->seq while dumping AFAICS, so
> > the code is functionally equivalent to this right?
<...> 
> FWIW, net/ipv4/nexthop.c sets cb->seq at the end of the loop and the
> nl_dump_check_consistent follows that.

[CCing Florian Westphal because he gave a related talk at netdev 2.2,
 maybe he can add something]

It seems to me now that most of the calls to nl_dump_check_consistent
are redundant.

Either the rtnl lock is explicitly taken:
- ethnl_tunnel_info_dumpit

Or are implicitly called with the rtnl lock held:
- rtnl_dump_ifinfo
- rtnl_dump_all
- in_dev_dump_addr
- inet_netconf_dump_devconf
- rtm_dump_nexthop
- rtm_dump_nexthop_bucket
- mpls_netconf_dump_devconf

Except:
- inet6_netconf_dump_devconf
- inet6_dump_addr

I assume the ones that rely on rcu_read_lock are safe too.

Also, the following ones set cb->seq just before calling it:
- rtm_dump_nh_ctx
- rtm_dump_res_bucket_ctx

Does it make sense to remove these calls or is anyone looking forward
to convert the functions to run without the rtnl lock?

Am I missing something here?

-- 
Ismael Luceno
SUSE - Support Level 3
