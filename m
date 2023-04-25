Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E096EDA2C
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 04:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbjDYCMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 22:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjDYCMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 22:12:53 -0400
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7F4A253;
        Mon, 24 Apr 2023 19:12:51 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R371e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0VgxqdjV_1682388766;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgxqdjV_1682388766)
          by smtp.aliyun-inc.com;
          Tue, 25 Apr 2023 10:12:47 +0800
Message-ID: <1682388702.2032197-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Date:   Tue, 25 Apr 2023 10:11:42 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     <netdev@vger.kernel.org>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <bpf@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
 <ZDzKAD2SNe1q/XA6@infradead.org>
 <1681711081.378984-2-xuanzhuo@linux.alibaba.com>
 <20230417115610.7763a87c@kernel.org>
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
 <20230420071349.5e441027@kernel.org>
 <1682062264.418752-2-xuanzhuo@linux.alibaba.com>
 <20230421065059.1bc78133@kernel.org>
 <5ec6f5e4-7b6a-17b3-492c-44364644f155@intel.com>
In-Reply-To: <5ec6f5e4-7b6a-17b3-492c-44364644f155@intel.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Apr 2023 17:28:01 +0200, Alexander Lobakin <aleksander.lobakin@intel.com> wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Fri, 21 Apr 2023 06:50:59 -0700
>
> > On Fri, 21 Apr 2023 15:31:04 +0800 Xuan Zhuo wrote:
> >> I am not particularly familiar with dma-bufs. I want to know if this mechanism
> >> can solve the problem of virtio-net.
> >>
> >> I saw this framework, allowing the driver do something inside the ops of
> >> dma-bufs.
> >>
> >> If so, is it possible to propose a new patch based on dma-bufs?
> >
> > I haven't looked in detail, maybe Olek has? AFAIU you'd need to rework
>
> Oh no, not me. I suck at dma-bufs, tried to understand them several
> times with no progress :D My knowledge is limited to "ok, if it's
> DMA + userspace, then it's likely dma-buf" :smile_with_tear:
>
> > uAPI of XSK to allow user to pass in a dma-buf region rather than just
> > a user VA. So it may be a larger effort but architecturally it may be
> > the right solution.
> >
>
> I'm curious whether this could be done without tons of work. Switching
> Page Pool to dma_alloc_noncoherent() is simpler :D But, as I wrote
> above, we need to extend DMA API first to provide bulk allocations and
> NUMA-aware allocations.
> Can't we provide a shim for back-compat, i.e. if a program passes just a
> user VA, create a dma-buf in the kernel already?


Yes

I think so too. If this is the case, will the workload be much smaller? Let me
try it.

Thanks.


>
> Thanks,
> Olek
