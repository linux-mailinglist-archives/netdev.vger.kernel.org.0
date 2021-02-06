Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09884312049
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 23:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhBFWaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 17:30:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBFWaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 17:30:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAB9C64DA1;
        Sat,  6 Feb 2021 22:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612650565;
        bh=5whCFGTXa3J1746EODCwZovMzZz+QDWnX+nqhWJoo8Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KVbBniO58u4QFUB32f9KRwF91AQ+EOH3Kx8zSld2dTKeS6bbVngC8lN72bAzfjChU
         YUyZhRLKOKOXDO5gxQCDAz3mX29oH29sevZ8Uq7CBif+qhiyCNbQFVq2+7gS0lWpII
         4OOIAnMrjzqqky0uF+yK1je0plwSI4cGz8QhkwRWJEnaulhQHOWyLAJE1L3uaSdWzt
         pMjZse5mPqyzYrP+8JcAYBI/6qGeasmvWuDb5Qg4t3+daMlPMNbG/ULsmZwMHMmmBv
         WoQRsmkyFf/9YN+81bLJKOeuDc7LqZ8GvFworFp2kV9jIXY7gtX9/lNMetjRU+CLPe
         bWI29EbUd4ilg==
Date:   Sat, 6 Feb 2021 14:29:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     NeilBrown <neilb@suse.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix some seq_file users that were recently broken
Message-ID: <20210206142924.2bfc3cf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210205143550.58d3530918459eafa918ad0c@linux-foundation.org>
References: <161248518659.21478.2484341937387294998.stgit@noble1>
        <20210205143550.58d3530918459eafa918ad0c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Feb 2021 14:35:50 -0800 Andrew Morton wrote:
> On Fri, 05 Feb 2021 11:36:30 +1100 NeilBrown <neilb@suse.de> wrote:
> 
> > A recent change to seq_file broke some users which were using seq_file
> > in a non-"standard" way ...  though the "standard" isn't documented, so
> > they can be excused.  The result is a possible leak - of memory in one
> > case, of references to a 'transport' in the other.
> > 
> > These three patches:
> >  1/ document and explain the problem
> >  2/ fix the problem user in x86
> >  3/ fix the problem user in net/sctp
> 
> 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and
> interface") was August 2018, so I don't think "recent" applies here?
> 
> I didn't look closely, but it appears that the sctp procfs file is
> world-readable.  So we gave unprivileged userspace the ability to leak
> kernel memory?
> 
> So I'm thinking that we aim for 5.12-rc1 on all three patches with a cc:stable?

I'd rather take the sctp patch sooner, we'll send another batch 
of networking fixes for 5.11, anyway. Would that be okay with you?
