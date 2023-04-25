Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11DF6EDDB9
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbjDYINC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjDYINB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:13:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E3649D4
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682410334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t71HgcdOLz2lcyahjqtdGmdShpS9YMcQtrEy3utJDfI=;
        b=LfcYlBBCNzXU72aBCdvqldkn0QieedfFwE7NATIcqP2gXnw1uKSXFCdkR9KQeFX15+d48a
        1iBGWgIukZP7uL7cjY8qTE8Zb3/2N3mXQHYZ4pHZj4DUTAMfNWkKUtNN9q70DsvygQlrhX
        Q1q+JRz3mzempDO0mImKWj+oNjZSzJ4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-x5gnEEvGMH-PEL06Y-Xzkg-1; Tue, 25 Apr 2023 04:12:12 -0400
X-MC-Unique: x5gnEEvGMH-PEL06Y-Xzkg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f195c06507so52009155e9.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:12:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682410331; x=1685002331;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t71HgcdOLz2lcyahjqtdGmdShpS9YMcQtrEy3utJDfI=;
        b=RSwEiEZw05cm4S7h1w7fQ6teNcs8bQmiO6yXqumaEGLkpuVAjhKKRywjm7a+fuZGeH
         wrLhBtRARdHhQnaMJXnRUgaRBtq2y+RErWZ3odaIwRGLrNJXGsDKoGjkru0UMDsNOXvc
         gKECNaPsK20+Bq6HLKfhG22Bdwu7iUVj9l8k/erbYNJFXrO9vcmMEHWxBbf2tcn7Ksvn
         3pNkObntNRApRGPIbs4AaPaiyRBy9UsolfG6PbwST82b+UvP212EvK5nbsUS/mLQyQRl
         yz7WyfKBbgefJmsu/LbOk2xznFqwMtjdPN+OcdP0MLjLWK6rwae9+Yf1SmypWcVitivF
         hnZQ==
X-Gm-Message-State: AAQBX9f8DQi1Ocln1fSJ2mHuar9Snlaw8qlNpn2D5s7MKZa0iVNi+r7q
        /+lIyEftvAPk9Alf33CSD/R5kjAA7N0VciTDLSQWuy9tZ/kDztD+Iwi+y9Tf3d0TdUWa0HM9X7Z
        Sd3L3ZmP3IyBbx0Az
X-Received: by 2002:a05:6000:c:b0:304:6d34:8fc9 with SMTP id h12-20020a056000000c00b003046d348fc9mr6841496wrx.2.1682410331249;
        Tue, 25 Apr 2023 01:12:11 -0700 (PDT)
X-Google-Smtp-Source: AKy350YROM05Vji85jKML5EORZKXj7LBcybOF+TFqDsboJo9RpXcWM26KHTCi4FZ8x7JjzgYf8PVYg==
X-Received: by 2002:a05:6000:c:b0:304:6d34:8fc9 with SMTP id h12-20020a056000000c00b003046d348fc9mr6841476wrx.2.1682410330931;
        Tue, 25 Apr 2023 01:12:10 -0700 (PDT)
Received: from redhat.com ([2.55.17.255])
        by smtp.gmail.com with ESMTPSA id p17-20020a056000019100b002fda1b12a0bsm12594181wrx.2.2023.04.25.01.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:12:10 -0700 (PDT)
Date:   Tue, 25 Apr 2023 04:12:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
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
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Message-ID: <20230425035259-mutt-send-email-mst@kernel.org>
References: <20230417181950.5db68526@kernel.org>
 <1681784379.909136-2-xuanzhuo@linux.alibaba.com>
 <20230417195400.482cfe75@kernel.org>
 <ZD4kMOym15pFcjq+@infradead.org>
 <20230417231947.3972f1a8@kernel.org>
 <ZD95RY9PjVRi7qz3@infradead.org>
 <20230419094506.2658b73f@kernel.org>
 <ZEDZaitjcX+egzvf@infradead.org>
 <1681981908.9700203-3-xuanzhuo@linux.alibaba.com>
 <ZEFlzdiyu2IAyX7a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEFlzdiyu2IAyX7a@infradead.org>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 09:18:21AM -0700, Christoph Hellwig wrote:
> On Thu, Apr 20, 2023 at 05:11:48PM +0800, Xuan Zhuo wrote:
> > I know that the current design of DMA API only supports some physical hardware,
> > but can it be modified or expanded?
> 
> I think the important point is that for some cases there is no need
> to dma map at all, and upper layers should be fine by that by just
> doing the dma mapping in helpers called by the driver.
> 
> The virtio drivers then check if platform_access is set, then call the
> generic dma mapping helper, or if not just allocate memory using
> alloc_pages and also skip all the sync calls.

In theory, absolutely. In practice modern virtio devices are ok,
the reason we are stuck supporting old legacy ones is because legacy
devices are needed to run old guests. And then people turn
around and run a new guest on the same device,
for example because they switch back and forth e.g.
for data recovery? Or because whoever is selling the
host wants to opt for maximum compatibility.

Teaching all of linux to sometimes use dma and sometimes not
is a lot of work, and for limited benefit of these legacy systems.
We do it in a limited number of cases but generally
making DMA itself DTRT sounds more attractive.

So special DMA ops for these makes some sense: yes the
firmware described DMA is wrong on these boxes but
buggy firmware is not so unusual, is it?
Given virtio devices actually are on a virtual bus (the virtio bus)
sticking the fake DMA ops on this bus seems to make sense
as a way to express this quirk.

No?

-- 
MST

