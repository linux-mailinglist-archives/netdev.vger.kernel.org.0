Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2720A2F4179
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 03:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbhAMCBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 21:01:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:35062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726653AbhAMCBg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 21:01:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 146B52310F;
        Wed, 13 Jan 2021 02:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610503256;
        bh=s2CEl17DdkeOubQ0hIVDwS90BOq+yvNu7OP51GCARzc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jeaqy6Q4q3z9jtVti2EUPZVnmF1BinbBwr/oaEH4q0r4hmU/wJdznaYgN94ffRnLB
         iR6NIOt3/5X92m4ZZHprbkdPelaltC4rLGr2jjqVOR5s0gqfInPcxCoEEFj04Me5Pa
         O9TKHtEBzgAms/IK17ahlwGC5BojW5g31K+6wAWEOP1FEDNkfRIBrQo3I6RUCZtohN
         Sn6e4A+RSdlOr7iVDUfryaGNa5gJYgGuo49Forqdc20nqZOF+h8Icbf/PNmbQhMkf5
         2DvDbjwEHDhNKscNTBQz6Zha21Cr+kZ7bGaEozyhZ9nH8bTaH4HlTM5LvFAuGvgDuy
         yzyed/arMPJ8Q==
Date:   Tue, 12 Jan 2021 18:00:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next v2 0/7] ibmvnic: Use more consistent locking
Message-ID: <20210112180054.28ebcd1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210112181441.206545-1-sukadev@linux.ibm.com>
References: <20210112181441.206545-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 10:14:34 -0800 Sukadev Bhattiprolu wrote:
> Use more consistent locking when reading/writing the adapter->state
> field. This patch set fixes a race condition during ibmvnic_open()
> where the adapter could be left in the PROBED state if a reset occurs
> at the wrong time. This can cause networking to not come up during
> boot and potentially require manual intervention in bringing up
> applications that depend on the network.

Apologies for not having enough time to suggest details, but let me
state this again - the patches which fix bugs need to go into net with
Fixes tags, the refactoring needs to go to net-next without Fixes tags.
If there are dependencies, patches go to net first, then within a week
or so the reset can be posted for net-next, after net -> net-next merge.
