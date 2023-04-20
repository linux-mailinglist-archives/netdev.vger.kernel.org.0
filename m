Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE8B6E96BD
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbjDTONz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbjDTONy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:13:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CA03C30;
        Thu, 20 Apr 2023 07:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E980649C9;
        Thu, 20 Apr 2023 14:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BAEC433D2;
        Thu, 20 Apr 2023 14:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682000031;
        bh=3AagU/3CGgraP4LY7Y6jN4XiIlaZaJ8VAejPSDMjULk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l2KqgWavr0vy4SkvbDlm0oRFVa/tAUiuHIlDu6skjXbiqfnVQ6GJGItpsz1dOCcbI
         XhLwqwRiLuztOP6LmSVBCi53mhbhRE2JHCVQJ1+Npo1Wif4vY3c3nxFHXBy2YGThlc
         JGFPElJXNC0dDSU1dLU5OTZYG6my7awS31Ova6knERTJ7MtVGvT2SGdbWza0UROHdQ
         PHqFeXbyID1hSlAtDOO8SJpKhY4xzhkx5JC4i6WUYoMyrx1qJc8qG21J95LqFZBxLM
         44aHkPCHTp3NOW0RPsA5MZn3M+2eyZjbUGy2+m7KcCCd7HeZoGESZm+ZeQ6W5m3Hx8
         B4eO6y/Jtk+1A==
Date:   Thu, 20 Apr 2023 07:13:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
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
Message-ID: <20230420071349.5e441027@kernel.org>
In-Reply-To: <ZEDZaitjcX+egzvf@infradead.org>
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
        <ZEDZaitjcX+egzvf@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Apr 2023 23:19:22 -0700 Christoph Hellwig wrote:
> > In this case yes, pinned user memory, it gets sliced up into MTU sized
> > chunks, fed into an Rx queue of a device, and user can see packets
> > without any copies.  
> 
> How long is the life time of these mappings?  Because dma_map_*
> assumes a temporary mapping and not one that is pinned bascically
> forever.

Yeah, this one is "for ever".

> > Quite similar use case #2 is upcoming io_uring / "direct placement"
> > patches (former from Meta, latter for Google) which will try to receive
> > just the TCP data into pinned user memory.  
> 
> I don't think we can just long term pin user memory here.  E.g. for
> confidential computing cases we can't even ever do DMA straight to
> userspace.  I had that conversation with Meta's block folks who
> want to do something similar with io_uring and the only option is an
> an allocator for memory that is known DMAable, e.g. through dma-bufs.
> 
> You guys really all need to get together and come up with a scheme
> that actually works instead of piling these hacks over hacks.

Okay, that simplifies various aspects. We'll just used dma-bufs from
the start in the new APIs.
