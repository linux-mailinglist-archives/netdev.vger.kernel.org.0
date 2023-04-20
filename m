Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D156D6E8A40
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 08:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbjDTGT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 02:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbjDTGTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 02:19:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051D5469B;
        Wed, 19 Apr 2023 23:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iio26VJpJRdZbT3LCeDlyblhDb21r5nBGeAdJ5hJHCA=; b=CchdnWCr9CoA9dNOaN+BPu7viz
        H7/xVIId2VWy2+Axj09fAVt9qFvn9p7inlFjF7xopbDdzlGJcaT6IfYX4r1yJbgmcn98vwcsMl/kI
        GW/wKr3C9H6Y7xdQNPX8jvEf/kGEvGEfPZ+gzrIKUZVcJZrSpdKAvBSp2lMjaO/U9ySItCRHQzmMX
        /X1mNz7Q3ZUNhf/rzZ9LylJj20eEmb2nNTXGcokaebCF1jlQJXQqEsAhJuMve5EmeTxtG6Zdj+PaI
        ZInes1YaR2hPLg/unIxVTqOk7upRieNtQsvCUDR9QFO+hq6BYh3Uz3GRAqJ4Dww84AmxNnHY5D1cM
        egFZojtQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1ppNda-007Aah-2E;
        Thu, 20 Apr 2023 06:19:22 +0000
Date:   Wed, 19 Apr 2023 23:19:22 -0700
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
Message-ID: <ZEDZaitjcX+egzvf@infradead.org>
References: <20230417115610.7763a87c@kernel.org>
 <20230417115753.7fb64b68@kernel.org>
 <CACGkMEtPNPXFThHt4aNm4g-fC1DqTLcDnB_iBWb9-cAOHMYV_A@mail.gmail.com>
 <20230417181950.5db68526@kernel.org>
 <1681784379.909136-2-xuanzhuo@linux.alibaba.com>
 <20230417195400.482cfe75@kernel.org>
 <ZD4kMOym15pFcjq+@infradead.org>
 <20230417231947.3972f1a8@kernel.org>
 <ZD95RY9PjVRi7qz3@infradead.org>
 <20230419094506.2658b73f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419094506.2658b73f@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 09:45:06AM -0700, Jakub Kicinski wrote:
> > Can you explain what the actual use case is?
> > 
> > From the original patchset I suspect it is dma mapping something very
> > long term and then maybe doing syncs on it as needed?
> 
> In this case yes, pinned user memory, it gets sliced up into MTU sized
> chunks, fed into an Rx queue of a device, and user can see packets
> without any copies.

How long is the life time of these mappings?  Because dma_map_*
assumes a temporary mapping and not one that is pinned bascically
forever.

> Quite similar use case #2 is upcoming io_uring / "direct placement"
> patches (former from Meta, latter for Google) which will try to receive
> just the TCP data into pinned user memory.

I don't think we can just long term pin user memory here.  E.g. for
confidential computing cases we can't even ever do DMA straight to
userspace.  I had that conversation with Meta's block folks who
want to do something similar with io_uring and the only option is an
an allocator for memory that is known DMAable, e.g. through dma-bufs.

You guys really all need to get together and come up with a scheme
that actually works instead of piling these hacks over hacks.
