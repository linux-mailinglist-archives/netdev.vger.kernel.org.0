Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFADE95424
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 04:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbfHTCO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 22:14:57 -0400
Received: from verein.lst.de ([213.95.11.211]:52455 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729012AbfHTCO5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 22:14:57 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B85B468B02; Tue, 20 Aug 2019 04:14:52 +0200 (CEST)
Date:   Tue, 20 Aug 2019 04:14:52 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Nicolin Chen <nicoleotsuka@gmail.com>
Cc:     Hillf Danton <hdanton@sina.com>,
        Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>,
        Christoph Hellwig <hch@lst.de>, kvalo@codeaurora.org,
        davem@davemloft.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, iommu@lists.linux-foundation.org,
        tobias.klausmann@freenet.de
Subject: Re: regression in ath10k dma allocation
Message-ID: <20190820021452.GA22792@lst.de>
References: <8fe8b415-2d34-0a14-170b-dcb31c162e67@mni.thm.de> <20190816164301.GA3629@lst.de> <af96ea6a-2b17-9b66-7aba-b7dae5bcbba5@mni.thm.de> <20190816222506.GA24413@Asurada-Nvidia.nvidia.com> <20190818031328.11848-1-hdanton@sina.com> <acd7a4b0-fde8-1aa2-af07-2b469e5d5ca7@mni.thm.de> <20190820015852.GA15830@Asurada-Nvidia.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820015852.GA15830@Asurada-Nvidia.nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 06:58:52PM -0700, Nicolin Chen wrote:
> Right...the condition was in-between. However, not every caller
> of dma_alloc_contiguous() is supposed to have a coherent check.
> So we either add a 'bool coherent_ok' to the API or revert the
> dma-direct part back to the original. Probably former option is
> better?
> 
> Thank you for the debugging. I have been a bit distracted, may
> not be able to submit a fix very soon. Would you like to help?

Yeah, it turns out that while the idea for the dma_alloc_contiguous
helper was neat it didn't work out at all, and me pushing Nicolin
down that route was not a very smart idea.  Sorry for causing this
mess.

I think we'll just need to open code it for dma-direct for 5.3.
Hillf do you want to cook up a patch or should I do it?
