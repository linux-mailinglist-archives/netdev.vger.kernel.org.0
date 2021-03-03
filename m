Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9208F32C45F
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236691AbhCDANb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:13:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384332AbhCCPmG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 10:42:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31E8A6023B;
        Wed,  3 Mar 2021 15:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614785978;
        bh=4+6rJ2LNy+cgojuXrtm+pVpJ3c3NNt6BHn320N4+CD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L8AWaZX0bK9HlwfcQdD26J351/ZOGJ6ztApwLeveSQbNBG/78cId3ttrxOnYmu0iS
         EzM4McDGDY9+jGCuA2nZMSK7rPBRHG09lhZ8ah5Fnv50IaocGmloBAIHpF8+Hb/xlv
         qn8bub35UQivfbcPD+EBxHY8OV14MCq9CcAj2FIqs830zQxM3An8gph7VQ3x8GkG4Q
         jHtwDRtBrlNfVJ4Z5BSlCN4LaxHKUgBoIiYPtr16O/Ml27bUF9m/sJUX05f/HlezEX
         1Dln90f4MZ1vwfyH9dS/kWuG6dNk4eVnNMz9MMxL1X5MfoPpqYlvEuINGmJ5pqrNnA
         qQpKxq9JW+fZQ==
Date:   Wed, 3 Mar 2021 15:39:32 +0000
From:   Will Deacon <will@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        maximmi@nvidia.com, andrii@kernel.org
Subject: Re: [PATCH bpf-next 2/2] libbpf, xsk: add libbpf_smp_store_release
 libbpf_smp_load_acquire
Message-ID: <20210303153932.GB19247@willie-the-truck>
References: <20210301104318.263262-1-bjorn.topel@gmail.com>
 <20210301104318.263262-3-bjorn.topel@gmail.com>
 <87k0qqx3be.fsf@toke.dk>
 <e052a22a-4b7b-fe38-06ad-2ad04c83dda7@intel.com>
 <12f8969b-6780-f35f-62cd-ed67b1d8181a@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12f8969b-6780-f35f-62cd-ed67b1d8181a@iogearbox.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 02, 2021 at 10:13:21AM +0100, Daniel Borkmann wrote:
> On 3/2/21 9:05 AM, Björn Töpel wrote:
> > On 2021-03-01 17:10, Toke Høiland-Jørgensen wrote:
> > > Björn Töpel <bjorn.topel@gmail.com> writes:
> > > > From: Björn Töpel <bjorn.topel@intel.com>
> > > > 
> > > > Now that the AF_XDP rings have load-acquire/store-release semantics,
> > > > move libbpf to that as well.
> > > > 
> > > > The library-internal libbpf_smp_{load_acquire,store_release} are only
> > > > valid for 32-bit words on ARM64.
> > > > 
> > > > Also, remove the barriers that are no longer in use.
> > > 
> > > So what happens if an updated libbpf is paired with an older kernel (or
> > > vice versa)?
> > 
> > "This is fine." ;-) This was briefly discussed in [1], outlined by the
> > previous commit!
> > 
> > ...even on POWER.
> 
> Could you put a summary or quote of that discussion on 'why it is okay and does not
> cause /forward or backward/ compat issues with user space' directly into patch 1's
> commit message?
> 
> I feel just referring to a link is probably less suitable in this case as it should
> rather be part of the commit message that contains the justification on why it is
> waterproof - at least it feels that specific area may be a bit under-documented, so
> having it as direct part certainly doesn't hurt.
> 
> Would also be great to get Will's ACK on that when you have a v2. :)

Please stick me on CC for that and I'll take a look as I've forgotten pretty
much everything about this since last time :)

Will
