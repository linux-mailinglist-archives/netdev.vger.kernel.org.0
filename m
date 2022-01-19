Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB2B4931B9
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 01:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346945AbiASAQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 19:16:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48108 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346805AbiASAQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 19:16:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A355B8185D
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 00:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1F5C340E0;
        Wed, 19 Jan 2022 00:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642551391;
        bh=AitsHu+WMhK0BVLOcbZShetcsz7yWoOP9XsU3jBt8fs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qy+5aPQ8bLTJ4NQgwGtrimwa23MbYfL+Y1DHr6XxIw9sspJLgr93udvoF6jHPkxss
         daeuOJJ0W6LLUVMYmlCf0i0haHDObT1/swAI0JhI0WmkClSOvoO6gjS4qsN7NS84Y9
         mF0G4oGYjZNXU4fq8Xkuqc40dWEoHUUU0NKzAMnV4LbZnGkWyQJkR+9W1ZKUQSgegn
         sOniV4QXv2bMHe3r5Ew0j+9Kx1840uXOwcaGG40RgkeSnVZIOMgP6mRMjSP1DJ4+gA
         Yn0oEE6zRzUZCHxYY3dFmK/Gli6nZg+jz8ZMixYyCGAl8ISosWW6HNsDMfICXziUlf
         Tu4ID4Au0QyXg==
Date:   Tue, 18 Jan 2022 16:16:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>, Parav Pandit <parav@nvidia.com>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Message-ID: <20220118161629.478a9d06@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220118223328.tq5kopdrit5frvap@sx1>
References: <PH0PR12MB5481E3E9D38D0F8DE175A915DC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111115704.4312d280@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB5481E33C9A07F2C3DEB77F38DC529@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220112163539.304a534d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB54813B900EF941852216C69BDC539@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220113204203.70ba8b54@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB54815445345CF98EAA25E2BCDC549@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220114183445.463c74f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220115061548.4o2uldqzqd4rjcz5@sx1>
        <20220118100235.412b557c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220118223328.tq5kopdrit5frvap@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jan 2022 14:33:28 -0800 Saeed Mahameed wrote:
> On 18 Jan 10:02, Jakub Kicinski wrote:
> >On Fri, 14 Jan 2022 22:15:48 -0800 Saeed Mahameed wrote:  
> >> I think the term privilege is misused here, due to the global knob proposed
> >> initially. Anyway the issue is exactly as I explained above, SW steering requires
> >> FW pre-allocated resources and initializations, for VFs it is disabled
> >> since there was no demand for it and FW wanted to save on resources.
> >>
> >> Now as SW steering is catching up with FW steering in terms of
> >> functionality, people want it also on VFs to help with rule insertion rate
> >> for use cases other than switchdev and TC, e.g TLS, connection tracking,
> >> etc ..  
> >
> >Sorry long weekend here, thanks for the explanation!
> >
> >Where do we stand? Are you okay with an explicit API for enabling /
> >disabling VF features? If SMFS really is about conntrack and TLS maybe  
> 
> I am as skeptical as you are. But what other options do we have ? It's a
> fact that "Smart" VFs have different use-cases and customization is
> necessary to allow full scalability and better system resource
> utilization.
> 
> As you already said, PTP for instance makes total sense as a VF feature
> knob

To be clear when I was talking about PTP initially I was thinking
about real PTP clocks. "Modern" NICs sometimes do shenanigans in 
the FW to pretend they have more clocks that they really have.
There is a difference between delegating the PHC to the VF and
allowing the VF to use some SW pretend clock. I'm not sure which
camp your PTP falls into.

> for the same reason I would say any standard stateful
> feature/offloads (e.g Crypto) also deserve own knobs.
> 
> If we agree on the need for a VF customization API, I would use one API
> for all features. Having explicit enable/disable API for some then implicit
> resources re-size API for other features is a bit confusing.
> 
> e.g.
> 
> # Enable ptp on specific vf
> devlink port function <port idx> set feature PTP ON/OFF
> 
> # disable TLS on specific vf
> devlink resource set <DEV> TLS size 0
> 
> And I am pretty sure resource API is not yet available for port functions (e.g
> before VF instantiation, which is one of the main points of this RFC, so some
> plumbing is necessary to expose resource API for port functions.
> 
> TBH, I actually like your resources idea, i would
> like to explore that more with Parav, see what we can do about it .. 

Right, that'd be great, although I'd imagine if the resource is very
flexible (e.g. memory) delegating N bytes to a function does not tell
the device how to perform the "diet". Obviously that's pure speculation
I don't know how things work on your SmartNIC :)

> >it can be implied by the delegation of appropriate bits meaningful to
> >netdev world?  
> 
> I don't get this point, netdev bits are known only after the VF has been fully
> initialized.

I meant this as a simple starting point to enumerate the features.
It was an off-cuff suggestion, really. Reusing some approximation of
existing bits with clear code-driven semantics is simpler than defining
and documenting new ones.

We can start a new enum.

I hope you didn't mean "PTP" to be a string carried all the way to 
the driver in your example command?

> And sometimes users want TLS without the optimization of SMFS, so as a vendor
> driver maintainer i would prefer having control knobs per feature, instead of
> maintaining some weird driver feature discovery and brokerage logic..

Shifting the "weird feature discovery" onto the user really does not
solve the problem. Enable SMFS is not a meaningful knob, the devops
engineer setting up the infra will have to guess. If we want something
like SMFS to be directly controlled it should be a clearly vendor
specific knob, IMO.
