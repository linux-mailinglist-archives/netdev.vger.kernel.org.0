Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A896E7293
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 07:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjDSFRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 01:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjDSFRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 01:17:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31BC30DC;
        Tue, 18 Apr 2023 22:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3TYzjVAO8lFOigoxzvnuNLGE5Ej5y2RKbRN7nPAZnQc=; b=GZsS8wOzLRu165JMIeJQWnqCrJ
        cFugFrh3LbSdfvJz1Z3udGZWBk+BVAZOz/zaz3027PrNh7I7H8vtfpmNDUwzp+Dek7cHaGoXRxlg+
        N2vaKfChTbLEndgPdUy55MG7J48x/9JAdhttQ+YlYP5EIe57jWyFZPkVSsBR3YbZU1MMoAi1viRiJ
        qMXnObMVXkIrqVmv7Dz8s+TWjJ0T6a0/YA2l9Q+WlIXS4cma2t2zwYmGcC1VB3rxY5dDB2IB/iG31
        o3oeOAJ1e2SBbb++bbW7afi+MeVPZpH/idmWCOwbxgG7ppHdtDxUyY66DaY9ifrVbfFFgZxmPxlbd
        4uQUixrw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pp0BZ-0045Qx-0m;
        Wed, 19 Apr 2023 05:16:53 +0000
Date:   Tue, 18 Apr 2023 22:16:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Message-ID: <ZD95RY9PjVRi7qz3@infradead.org>
References: <ZDzKAD2SNe1q/XA6@infradead.org>
 <1681711081.378984-2-xuanzhuo@linux.alibaba.com>
 <20230417115610.7763a87c@kernel.org>
 <20230417115753.7fb64b68@kernel.org>
 <CACGkMEtPNPXFThHt4aNm4g-fC1DqTLcDnB_iBWb9-cAOHMYV_A@mail.gmail.com>
 <20230417181950.5db68526@kernel.org>
 <1681784379.909136-2-xuanzhuo@linux.alibaba.com>
 <20230417195400.482cfe75@kernel.org>
 <ZD4kMOym15pFcjq+@infradead.org>
 <20230417231947.3972f1a8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417231947.3972f1a8@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 11:19:47PM -0700, Jakub Kicinski wrote:
> > You can't just do dma mapping outside the driver, because there are
> > drivers that do not require DMA mapping at all.  virtio is an example,
> > but all the classic s390 drivers and some other odd virtualization
> > ones are others.
> 
> What bus are the classic s390 on (in terms of the device model)?

I think most of them are based on struct ccw_device, but I'll let the
s390 maintainers fill in.

Another interesting case that isn't really relevant for your networking
guys, but that caused as problems is RDMA.  For hardware RDMA devices
it wants the ULPs to DMA map, but it turns out we have various software
drivers that map to network drivers that do their own DMA mapping
at a much lower layer and after potentially splitting packets or
even mangling them.

> 
> > > I don't think it's reasonable to be bubbling up custom per-subsystem
> > > DMA ops into all of them for the sake of virtio.  
> > 
> > dma addresses and thus dma mappings are completely driver specific.
> > Upper layers have no business looking at them.
> 
> Damn, that's unfortunate. Thinking aloud -- that means that if we want 
> to continue to pull memory management out of networking drivers to
> improve it for all, cross-optimize with the rest of the stack and
> allow various upcoming forms of zero copy -- then we need to add an
> equivalent of dma_ops and DMA API locally in networking?

Can you explain what the actual use case is?

From the original patchset I suspect it is dma mapping something very
long term and then maybe doing syncs on it as needed?
