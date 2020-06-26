Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24D020B17C
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 14:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgFZMlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 08:41:08 -0400
Received: from verein.lst.de ([213.95.11.211]:51619 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgFZMlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 08:41:07 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E4C1A68B02; Fri, 26 Jun 2020 14:41:04 +0200 (CEST)
Date:   Fri, 26 Jun 2020 14:41:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        bpf <bpf@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Subject: Re: the XSK buffer pool needs be to reverted
Message-ID: <20200626124104.GA8835@lst.de>
References: <20200626074725.GA21790@lst.de> <f1512c3e-79eb-ba75-6f38-ca09795973c1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f1512c3e-79eb-ba75-6f38-ca09795973c1@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 02:22:41PM +0200, Björn Töpel wrote:
> Thanks for clarifying that. Let's work on a solution that can reside in
> the dma mapping core.
>
>> The commit seems to have a long dove tail of commits depending on it
>> despite only being a month old, so maybe you can do the revert for now?
>>
>
> Reverting the whole series sounds a bit too much. Let's focus on the
> part that breaks the dma api abstraction. I'm assuming that you're
> referring to the
>
>   static bool xp_check_cheap_dma(struct xsk_buff_pool *pool)
>
> function (and related functions called from that)?

Yes.

>
>> Note that this is somewhat urgent, as various of the APIs that the code
>> is abusing are slated to go away for Linux 5.9, so this addition comes
>> at a really bad time.
>>
>
> Understood. Wdyt about something in the lines of the diff below? It's
> build tested only, but removes all non-dma API usage ("poking
> internals"). Would that be a way forward, and then as a next step work
> on a solution that would give similar benefits, but something that would
> live in the dma mapping core?

Yes, that would solve the immediate issues.
