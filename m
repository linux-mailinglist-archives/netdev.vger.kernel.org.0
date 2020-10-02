Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7074A281697
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388168AbgJBP24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBP24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:28:56 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F54CC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 08:28:56 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOMzO-00FJKS-2j; Fri, 02 Oct 2020 17:28:54 +0200
Message-ID: <a5d78d7a54c684a0d23d2af7e21826ae87414bf5.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 00/10] genetlink: support per-command policy
 dump
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org
Date:   Fri, 02 Oct 2020 17:28:53 +0200
In-Reply-To: <20201002082517.31e644ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201001225933.1373426-1-kuba@kernel.org>
         <20201001173644.74ed67da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <d26ccd875ebac452321343cc9f6a9e8ef990efbf.camel@sipsolutions.net>
         <20201002074001.3484568a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <1dacbe07dc89cd69342199e61aeead4475f3621c.camel@sipsolutions.net>
         <20201002075538.2a52dccb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <e350fbdadd8dfa07bef8a76631d8ec6a6c6e8fdf.camel@sipsolutions.net>
         <20201002080308.7832bcc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <a69c92aac65c718b1bd80c8dc0cbb471cdd17d9b.camel@sipsolutions.net>
         <20201002080944.2f63ccf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <db56057454ee3338a7fe13c8d5cc450b22b18c3b.camel@sipsolutions.net>
         <20201002082517.31e644ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-02 at 08:25 -0700, Jakub Kicinski wrote:
> 
> > I suppose, I thought you wanted to change it to have separate dump/do
> > policies? Whatever you like there, I don't really care much :)
> 
> I just want to make the uAPI future-proof for now.

Yeah, makes sense.

> At a quick look ethtool doesn't really accept any attributes but
> headers for GET requests. DO and DUMP are the same there so it's 
> not a priority for me.

OK.

> > But I can also change my patches later to separately advertise dump/do
> > policies, and simply always use the same one for now.
> 
> Right that was what I was thinking. Basically:
> 
> 	if ((op.doit && nla_put_u32(skb, CTRL_whatever_DO, idx)) ||
> 	    (op.dumpit && nla_put_u32(skb, CTRL_whatever_DUMP, idx)))
> 		goto nla_put_failure;

Right, easy enough.

> > But this series does conflict with the little bugfix I also sent, could
> > you please take a look?
> > 
> > https://lore.kernel.org/netdev/20201002094604.480c760e3c47.I7811da1539351a26cd0e5a10b98a8842cfbc1b55@changeid/
> > 
> > I'm not really sure how to handle.
> 
> Yeah, just noticed that one now :S

Yeah, sorry ... The conflicts indeed weren't difficult, but non-trivial
unless you know what's going on in each side. I pushed them to my
mac80211-next tree, in the genetlink-op-policy-export branch (not sure
you saw my patches and cover letter yet :) )

I'll wait for this to get resolved and then respin my patches with the
above doit/dumpit after your series is in, and will also respin the
userspace side then.

johannes

