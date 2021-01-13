Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2482F52E1
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 20:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbhAMS6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 13:58:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728108AbhAMS6R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 13:58:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54C372222B;
        Wed, 13 Jan 2021 18:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610564256;
        bh=qZFi6ryb+vhY4oCT91YYTkvbJrGzvmAMJqs2Al9CNVA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VIQogbjK2yJChdjaTu+oKq/osc0QdGWnmzU3YprGepadcQjHNTnH5bAA+TEd+HYOE
         x/D0PUgAuXrS3aDBymatrUYV9eE8J5m1G1V2n7kKLyBL3ZPwn0ZtqiS2AlKsL7qDGq
         IsJ8ifazTe6gdh+X2SL/WL0bikjS2JOuVjNOMedXS0/Wq2g2OyBJ4j+ZuSUzmgFkYw
         nklnPSTW/MndmIvVqcR14/IIPATEhDAnA7Id8aOwoH9eKpWH8hOoDgYpKO3oyRfgPt
         STiDdRjh71Llme7riG6YHdXCJsQyM+VtCDdn001UrRj7+v0YBAoDSEHd+7IBOrpMye
         x5D/8KNd/kbEQ==
Date:   Wed, 13 Jan 2021 10:57:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next v2 0/7] ibmvnic: Use more consistent locking
Message-ID: <20210113105735.20853d1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210113044247.GA224486@us.ibm.com>
References: <20210112181441.206545-1-sukadev@linux.ibm.com>
        <20210112180054.28ebcd1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210113044247.GA224486@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 20:42:47 -0800 Sukadev Bhattiprolu wrote:
> Jakub Kicinski [kuba@kernel.org] wrote:
> > On Tue, 12 Jan 2021 10:14:34 -0800 Sukadev Bhattiprolu wrote:  
> > > Use more consistent locking when reading/writing the adapter->state
> > > field. This patch set fixes a race condition during ibmvnic_open()
> > > where the adapter could be left in the PROBED state if a reset occurs
> > > at the wrong time. This can cause networking to not come up during
> > > boot and potentially require manual intervention in bringing up
> > > applications that depend on the network.  
> > 
> > Apologies for not having enough time to suggest details, but let me
> > state this again - the patches which fix bugs need to go into net with
> > Fixes tags, the refactoring needs to go to net-next without Fixes tags.
> > If there are dependencies, patches go to net first, then within a week
> > or so the reset can be posted for net-next, after net -> net-next merge.  
> 
> Well, the patch set fixes a set of bugs - main one is a locking bug fixed
> in patch 6. Other bugs are more minor or corner cases. Fixing the locking
> bug requires some refactoring/simplifying/reordering checks so lock can be
> properly acquired.
> 
> Because of the size/cleanup, should we treat it as "next" material? i.e
> should I just drop the Fixes tag and resend to net-next?
> 
> Or can we ignore the size of patchset and treat it all as bug fixes?

No, focus on doing this right rather than trying to justify why your
patches deserve special treatment.

Throw this entire series out and start over with the goal of fixing 
the bugs with minimal patches.
