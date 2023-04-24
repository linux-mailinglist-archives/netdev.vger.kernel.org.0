Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6658C6ED14C
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 17:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbjDXP3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 11:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjDXP3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 11:29:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9ABD768D;
        Mon, 24 Apr 2023 08:28:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FC5F61ED7;
        Mon, 24 Apr 2023 15:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B745AC4339B;
        Mon, 24 Apr 2023 15:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682350138;
        bh=AMMx5HgjbNIwyJ8KKn8Vrdz90FOmouBRO1eH/1NOp8Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RMCcpMdGYYCBfmNvTm2EfrijNCMmrmmipIf1quso+iliJpt4BZ6cNFIk94A3KT2l0
         m04r6wQGncW1NsdTFt7/ivXjgT1RLrlXXhfHSy27A41B2hPAezLPs0OpgrAQZ5hbjZ
         3s9tcCp5YwrVhzfEIHRP4FHnfrDsqcNhrZrvSMTG0j3bDqBlNWOwVHk6iOLoQZOrAW
         OmKv3R4n/OJHRbjtkbHERmyzzWxqCxzzZu1b2nfcYwSEcxw18JjC8XVsGO/fwaDVV7
         ejRs0f0PGuD5Mk2nxFrL351EAbkS+WyfFHyHo08JQtacyW6pElihmIgvIEL4FADpJf
         FM0+QdivPSjKg==
Date:   Mon, 24 Apr 2023 08:28:56 -0700
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
Message-ID: <20230424082856.15c1e593@kernel.org>
In-Reply-To: <1682214868.0321188-1-xuanzhuo@linux.alibaba.com>
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
        <1682214868.0321188-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Apr 2023 09:54:28 +0800 Xuan Zhuo wrote:
> On Fri, 21 Apr 2023 06:50:59 -0700, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 21 Apr 2023 15:31:04 +0800 Xuan Zhuo wrote:  
> > > I am not particularly familiar with dma-bufs. I want to know if this mechanism
> > > can solve the problem of virtio-net.
> > >
> > > I saw this framework, allowing the driver do something inside the ops of
> > > dma-bufs.
> > >
> > > If so, is it possible to propose a new patch based on dma-bufs?  
> >
> > I haven't looked in detail, maybe Olek has? AFAIU you'd need to rework
> > uAPI of XSK to allow user to pass in a dma-buf region rather than just
> > a user VA.  
> 
> This seems to be a big job. Can we first receive this patch.

To me it looks like a very obvious workaround for the fact that virtio
does not make normal use of the DMA API, and (for reasons which perhaps
due to my meager intellect I do not grasp) you are not allowed to fix
that. Regardless, we have a path forward so I vote "no" to the patch
under discussion.
