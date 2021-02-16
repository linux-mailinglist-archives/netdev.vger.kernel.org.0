Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A7C31CBDA
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 15:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhBPO0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 09:26:16 -0500
Received: from mga18.intel.com ([134.134.136.126]:63131 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhBPO0M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 09:26:12 -0500
IronPort-SDR: cM+xPrJUHPXHAZ2GoppKml4sbF6V3KSFCvnrmhTM1Iwte8GZVCxRKcQyNRQMApAwXr9ARp2KUl
 nJhZJRnpP2bg==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="170560091"
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="170560091"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 06:25:28 -0800
IronPort-SDR: uoPq3kaWWEgMuJUQNOSfy+dcO2DD6L8GDDjIdJpu/wvsaa3qiNFdFv7FwA+5swkhRJhd/NxQBO
 DqJ6rq93eW2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="384408460"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 16 Feb 2021 06:25:26 -0800
Date:   Tue, 16 Feb 2021 15:15:34 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Cc:     John Fastabend <john.fastabend@gmail.com>, daniel@iogearbox.net,
        ast@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        andrii@kernel.org, toke@redhat.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com
Subject: Re: [PATCH bpf-next 3/3] samples: bpf: do not unload prog within
 xdpsock
Message-ID: <20210216141534.GB14725@ranger.igk.intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-4-maciej.fijalkowski@intel.com>
 <602ad895e1810_3ed41208b6@john-XPS-13-9370.notmuch>
 <2e9b5266-047c-95d0-f056-03457e485862@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2e9b5266-047c-95d0-f056-03457e485862@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 10:22:15AM +0100, Björn Töpel wrote:
> On 2021-02-15 21:24, John Fastabend wrote:
> > Maciej Fijalkowski wrote:
> > > With the introduction of bpf_link in xsk's libbpf part, there's no
> > > further need for explicit unload of prog on xdpsock's termination. When
> > > process dies, the bpf_link's refcount will be decremented and resources
> > > will be unloaded/freed under the hood in case when there are no more
> > > active users.
> > > 
> > > While at it, don't dump stats on error path.
> > > 
> > > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > ---
> > 
> > Can we also use it from selftests prog so we have a test that is run there
> > using this? Looks like xdpxceiver.c could do the link step as well?
> > 
> 
> Yes! Good point!

Somehow John's mail didn't end up in my inbox.
xdpxceiver is using libbpf API for socket handling (create/delete), so
with that set included it is working on bpf_link.

> 
> 
> Björn
