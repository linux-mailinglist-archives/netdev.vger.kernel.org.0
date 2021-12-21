Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0B547C832
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 21:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbhLUUVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 15:21:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34116 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbhLUUVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 15:21:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF989B817D0;
        Tue, 21 Dec 2021 20:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A1CC36AE8;
        Tue, 21 Dec 2021 20:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640118110;
        bh=W/xKcGz9hVPblpB16ROkpU7To/atMV0hIDh0EVixtyo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gz5azwoxr7sGkGC+0101GVwj274sxuy/RA+nYITuVhwO82lBdQ4nrk4vaL4YfQFlx
         QZEDUoGjCs2elTk/H/DHfF1fM8czfn7h4Q99mbyPYowVzOzd63/umqGhvxy8QXgqsr
         Z4E7CT1ydRP3riG1J99+hRLJHl3n+eSMceHJ7n5X9wLkJUZAvHdUCIGWUqTRqbzDZ6
         XCIzfaljiXVdBKCNDMJc37pMsqVN66icduO3tk0KbrnPJWqU6c9FkzrcA9H4s+D8ew
         omRHNvrJGVtWDCm6cHABxWs6V7lhVuJ7ARXlvgAR+8QS+XXysPZ8/pluKAy3ssnBIM
         7tLD2liFKWS7w==
Date:   Tue, 21 Dec 2021 12:21:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Loftus, Ciara" <ciara.loftus@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf] xsk: Initialise xskb free_list_node
Message-ID: <20211221122149.72160edc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJ8uoz3HYUO_NK+GCHtDWiczp-pDqpk6V+f5X5KkAJqN70nAnQ@mail.gmail.com>
References: <20211220155250.2746-1-ciara.loftus@intel.com>
        <CAJ8uoz2-jZTqT_XkP6T2c0VAzC=QcENr2dJrE5ZivUx8Ak_6ZA@mail.gmail.com>
        <PH0PR11MB479171AF2D4CE0B118B47A208E7C9@PH0PR11MB4791.namprd11.prod.outlook.com>
        <CAJ8uoz3HYUO_NK+GCHtDWiczp-pDqpk6V+f5X5KkAJqN70nAnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Dec 2021 10:00:13 +0100 Magnus Karlsson wrote:
> On Tue, Dec 21, 2021 at 9:32 AM Loftus, Ciara <ciara.loftus@intel.com> wrote:
> > > Thank you for this fix Ciara! Though I do think the Fixes tag should
> > > be the one above: 199d983bc015 ("xsk: Fix crash on double free in
> > > buffer pool"). Before that commit, there was no test for an empty list
> > > in the xp_free path. The entry was unconditionally put on the list and
> > > "initialized" in that way, so that code will work without this patch.
> > > What do you think?  
> >
> > Agree - that makes sense.
> > Can the fixes tag be updated when pulled into the tree with:
> > Fixes: 199d983bc015 ("xsk: Fix crash on double free in buffer pool")  
> 
> On the other hand, this was a fix for 2b43470add8c ("xsk: Introduce
> AF_XDP buffer allocation API"), the original tag you have in your
> patch. What should the Fixes tag point to in this case? Need some
> advice please.

My $0.02 would be that if all relevant commits form a chain of fixes
it doesn't matter much which one you put in the tag. To me your
suggestion of going with 199d983bc015 makes most sense since from a
cursory look the direct issue doesn't really exist without that commit.

Plus we probably don't want 199d983bc015 to be backported until we
apply this fix, so it'd be good if "Fixes: 199d983bc015" appeared in
linux-next.

You can always put multiple Fixes tags on the commit, if you're unsure.
