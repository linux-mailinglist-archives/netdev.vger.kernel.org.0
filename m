Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4638675B2D
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 18:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjATRXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 12:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjATRXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 12:23:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F0883879;
        Fri, 20 Jan 2023 09:23:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EDC3B82941;
        Fri, 20 Jan 2023 17:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A67C433D2;
        Fri, 20 Jan 2023 17:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674235405;
        bh=ZoJTq9hlxE+EeSPEihPl6kgJ4aNV/ot2y2HKzEndKfI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=twuzMgUIVujvvvqUl+Jq3VnFeviR345kCrBQLb/875O9vasUiNHmY2HO9017OcsJH
         L7QRMuOJjwsNVrsOjC3/9Y0RFiWA6apQ6xWkehnxvrlCeQluypOgvcga+7+0ywyybv
         bnQ66JPSX84uMJpeouBzHtuSWaJfg4qEpJkurCilgchWeM2pL0folT4cmU5P3bFt0u
         Lfx4yBwY56NBBuDzj2GNkjsRv7F7H5vREMMR6MHOBCb0ggacQBFdR8ccOj7aa2OEwx
         FvODJvK7vhPqToT6S8hBKrv0tAtdaQJoqDppMWP8XasczWd640HEj1mn7PqpZ8nBjG
         Q2bRc/GefaQww==
Date:   Fri, 20 Jan 2023 09:23:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh@kernel.org, stephen@networkplumber.org,
        ecree.xilinx@gmail.com, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        nicolas.dichtel@6wind.com, Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH net-next v3 1/8] docs: add more netlink docs (incl. spec
 docs)
Message-ID: <20230120092323.39d3787e@kernel.org>
In-Reply-To: <2b7f7f76aac4fcf2a51eb5588e64316b62f27d65.camel@sipsolutions.net>
References: <20230119003613.111778-1-kuba@kernel.org>
        <20230119003613.111778-2-kuba@kernel.org>
        <96618285a772b5ef9998f638ea17ff68c32dd710.camel@sipsolutions.net>
        <20230119181306.3b8491b1@kernel.org>
        <2b7f7f76aac4fcf2a51eb5588e64316b62f27d65.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Jan 2023 10:15:39 +0100 Johannes Berg wrote:
> > > > +Support dump consistency
> > > > +------------------------
> > > > +
> > > > +If iterating over objects during dump may skip over objects or repeat
> > > > +them - make sure to report dump inconsistency with ``NLM_F_DUMP_INTR``.    
> > > 
> > > That could be a bit more fleshed out on _how_ to do that, if it's not
> > > somewhere else?  
> > 
> > I was thinking about adding a sentence like "To avoid consistency
> > issues store your objects in an Xarray and correctly use the ID during
> > iteration".. but it seems to hand-wavy. Really the coder needs to
> > understand dumps quite well to get what's going on, and then the
> > consistency is kinda obvious. IDK. Almost nobody gets this right :(  
> 
> Yeah agree, it's tricky one way or the other. To be honest I was
> thinking less of documenting the mechanics of the underlying code to
> ensure that, but rather of the mechanics of using the APIs to ensure
> that, i.e. how to use cb->seq and friends.

I see. Let me add that.
My hope was to steer people towards data structures with stable
indexes, so the problem doesn't occur. But I'll add a mention of 
the helpers.

> > > Unrelated to this particular document, but ...
> > > 
> > > I'm all for this, btw, but maybe we should have a way of representing in
> > > the policy that an attribute is used as multi-attr for an array, and a
> > > way of exposing that in the policy export? Hmm. Haven't thought about
> > > this for a while.  
> > 
> > Informational-only or enforced? Enforcing this now would be another
> > backward-compat nightmare :(  
> 
> More informational - for userspace to know from policy dump that certain
> attributes have that property. With nested it's easy to know (there's a
> special nested-array type), but multi-attr there's no way to distinguish
> "is this one" and "is this multiple".

Makes sense.

> Now ... you might say you don't really care now since you want
> everything to be auto-generated and then you have it in the docs
> (actually, do you?), and that's a fair point.

Have in the docs that we want everything to be auto-generated?

> > FWIW I have a set parked on a branch to add "required" bit to policies,
> > so for per-op policies one can reject requests with missing attrs
> > during validation.  
> 
> Nice. That might yet convince me of per-op policies ;-)
> 
> Though IMHO the namespace issue remains - I'd still not like to have 100
> definitions of NL80211_ATTR_IFINDEX or similar.

Yeah, there's different ways of dealing with it. The ethtool way is
pretty neat - have a nest in each command for "common attrs" with
ifindex and stuff in it.
