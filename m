Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EBC3FE106
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 19:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344667AbhIARRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 13:17:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232491AbhIARRL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 13:17:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91C66600CD;
        Wed,  1 Sep 2021 17:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630516574;
        bh=/IkrxD0NyHwEqcn1/UCISCByn4ljPsspczHZ7KyNNsg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oc4itryjPY/CdbnT4I71YjX59TNZpw2ugLEa6YrarpShfofb0K/m8AWcXtTOp5zft
         oJw0BhsUDl3xzmklW4UpslthQx15swe3hqOxKu3KCqKmKnmEOTZld99GerfSf6Dhe7
         AQtyAnNIoivqLGX1FIy8PklAw+ud8wp4/YwcMkbfDBc+WdET2JhH/w/Evg37yyTh0C
         1/qqafyWZ/ahTDTre37oAm+okUFIRFmQgV35klpPTh5swTXkB7J351k0cEDPKfNt57
         rvmFXCxHvLPPbSXmEtoCMiYij2sn2WYfj9/g5hUs+10JwG3oppj2CljSpy+zU483/P
         RR2GEx74Yzsdw==
Date:   Wed, 1 Sep 2021 10:16:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     "David S. Miller" <davem@davemloft.net>, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net v2 0/2] mptcp: Prevent tcp_push() crash and selftest
 temp file buildup
Message-ID: <20210901101613.50a11581@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b9fa6f74-e0b6-0f61-fc5a-954137db1314@tessares.net>
References: <20210831171926.80920-1-mathew.j.martineau@linux.intel.com>
        <b9fa6f74-e0b6-0f61-fc5a-954137db1314@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Sep 2021 18:09:52 +0200 Matthieu Baerts wrote:
> Hi David, Jakub,
> 
> On 31/08/2021 19:19, Mat Martineau wrote:
> > These are two fixes for the net tree, addressing separate issues.
> > 
> > Patch 1 addresses a divide-by-zero crash seen in syzkaller and also
> > reported by a user on the netdev list. This changes MPTCP code so
> > tcp_push() cannot be called with an invalid (0) mss_now value.
> > 
> > Patch 2 fixes a selftest temp file cleanup issue that consumes excessive
> > disk space when running repeated tests.
> > 
> > 
> > v2: Make suggested changes to lockdep check and indentation in patch 1  
> 
> We recently noticed this series has been marked as "Not Applicable" on
> Patchwork.
> 
> It looks like we can apply these patches:
> 
>   $ git checkout netdev-net/master # 780aa1209f88
>   $ git-pw series apply 539963
>   Applying: mptcp: fix possible divide by zero
>   Using index info to reconstruct a base tree...
>   M       net/mptcp/protocol.c
> 
>   Falling back to patching base and 3-way merge...
>   Auto-merging net/mptcp/protocol.c
> 
>   Applying: selftests: mptcp: clean tmp files in simult_flows
> 
> Git auto-resolves conflicts. Is it why it is considered as "Not
> Applicable" or did we miss something else?

We don't enable 3-way merges for patches applied from the list, usually.

> Do we just need to resend these patches after a rebase?

Yes please.
