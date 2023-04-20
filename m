Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7436E9959
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbjDTQSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbjDTQSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:18:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445242139;
        Thu, 20 Apr 2023 09:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WriYvcEYXKuK/u58ncTN0aOBy6C3Ot7CD4a8g8BQ4+4=; b=2l58lpIsSDMv9cBpyQ1xOmrKYd
        GY1YczBXm1i8BazJ2u7OC8T0xxiRCgKPwwenqlQwPF3bypZsMmd+nJcMGl7IZeNexgNrdWdhTkjYK
        jPCEmKIxtYAtxy45FpQ+PEgJ3ZC3XPgnTEDhygBY5E3UOACDCxNAtmxx6jG/lTBQ1k/Bui7KAUSTy
        QGbTVB/8cLEuFxt3wxOe0Xx3P5MVpc96vWpAZyA1Un9xrOlwVgzZDozxqE6WWNnz/4AdbkNNAs4Uy
        nRWNqOPipvvhyY6a0XiqKJ4ZYNBKfkd9FiK41saU96nD/BXapbES0ypRc7j2CuzPyjQnRfty0viil
        cy5VTR7w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1ppWzF-008WWw-0D;
        Thu, 20 Apr 2023 16:18:21 +0000
Date:   Thu, 20 Apr 2023 09:18:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Christoph Hellwig <hch@infradead.org>, netdev@vger.kernel.org,
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
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Message-ID: <ZEFlzdiyu2IAyX7a@infradead.org>
References: <CACGkMEtPNPXFThHt4aNm4g-fC1DqTLcDnB_iBWb9-cAOHMYV_A@mail.gmail.com>
 <20230417181950.5db68526@kernel.org>
 <1681784379.909136-2-xuanzhuo@linux.alibaba.com>
 <20230417195400.482cfe75@kernel.org>
 <ZD4kMOym15pFcjq+@infradead.org>
 <20230417231947.3972f1a8@kernel.org>
 <ZD95RY9PjVRi7qz3@infradead.org>
 <20230419094506.2658b73f@kernel.org>
 <ZEDZaitjcX+egzvf@infradead.org>
 <1681981908.9700203-3-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1681981908.9700203-3-xuanzhuo@linux.alibaba.com>
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

On Thu, Apr 20, 2023 at 05:11:48PM +0800, Xuan Zhuo wrote:
> I know that the current design of DMA API only supports some physical hardware,
> but can it be modified or expanded?

I think the important point is that for some cases there is no need
to dma map at all, and upper layers should be fine by that by just
doing the dma mapping in helpers called by the driver.

The virtio drivers then check if platform_access is set, then call the
generic dma mapping helper, or if not just allocate memory using
alloc_pages and also skip all the sync calls.
