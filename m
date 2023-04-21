Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5CF76EAC11
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 15:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbjDUNvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 09:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjDUNvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 09:51:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B043CB4;
        Fri, 21 Apr 2023 06:51:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45951650C6;
        Fri, 21 Apr 2023 13:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF72EC433EF;
        Fri, 21 Apr 2023 13:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682085061;
        bh=UZmACbPgK0i7don5rOKHICey7yvxKk6T3PddjssercA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C1ffogJwCc4Atpp+aBB4NifII1GW/MESG6Z+5NEkDVn3vuTBM2h0PFVsF/5cs+l9H
         kUohNi+jmTEw+FIccMkj85/IBlm9m96dOgxY1p2Dpo3gAzjlsX5InMtlJ+pqkPKeCN
         xriomvKo4x4SlGCHr+4TucWnksaWi4/yCSDPqfhXAgXOKknl/ZLN5nrG9d04tnU10i
         cjTzwtpQBKW+zOg3QWFRdt/CxlQwopO0bsfqVirZfr5twbA9WJmOx2lq1zanlzJyU0
         U+9hiapKUB22PzQ6e5SfM67dO1d46UNW6LPTnrCTOdQ13RYH/a+pHB7+Y6+Q/uhFeM
         c0bS2YgP4JiAA==
Date:   Fri, 21 Apr 2023 06:50:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org,
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
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Message-ID: <20230421065059.1bc78133@kernel.org>
In-Reply-To: <1682062264.418752-2-xuanzhuo@linux.alibaba.com>
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

On Fri, 21 Apr 2023 15:31:04 +0800 Xuan Zhuo wrote:
> I am not particularly familiar with dma-bufs. I want to know if this mechanism
> can solve the problem of virtio-net.
> 
> I saw this framework, allowing the driver do something inside the ops of
> dma-bufs.
> 
> If so, is it possible to propose a new patch based on dma-bufs?

I haven't looked in detail, maybe Olek has? AFAIU you'd need to rework
uAPI of XSK to allow user to pass in a dma-buf region rather than just
a user VA. So it may be a larger effort but architecturally it may be
the right solution.
