Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3260A20AD81
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 09:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgFZHr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 03:47:29 -0400
Received: from verein.lst.de ([213.95.11.211]:50706 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728111AbgFZHr2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 03:47:28 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9C65868B02; Fri, 26 Jun 2020 09:47:25 +0200 (CEST)
Date:   Fri, 26 Jun 2020 09:47:25 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: the XSK buffer pool needs be to reverted
Message-ID: <20200626074725.GA21790@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Björn,

you addition of the xsk_buff_pool.c APIs in commit 2b43470add8c
("xsk: Introduce AF_XDP buffer allocation API") is unfortunately rather
broken by making lots of assumptions and poking into dma-direct and
swiotlb internals that are of no business to outside users and clearly
marked as such.   I'd be glad to work with your doing something proper
for pools, but that needs proper APIs and probably live in the dma
mapping core, but for that you'd actually need to contact the relevant
maintainers before poking into internals.

The commit seems to have a long dove tail of commits depending on it
despite only being a month old, so maybe you can do the revert for now?

Note that this is somewhat urgent, as various of the APIs that the code
is abusing are slated to go away for Linux 5.9, so this addition comes
at a really bad time.
