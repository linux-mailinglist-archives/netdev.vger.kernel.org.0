Return-Path: <netdev+bounces-6848-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9492B718681
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:38:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFB731C20C2E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 492BB174C6;
	Wed, 31 May 2023 15:38:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B79F14289
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:38:01 +0000 (UTC)
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BC79D;
	Wed, 31 May 2023 08:37:59 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-52cb78647ecso3662809a12.1;
        Wed, 31 May 2023 08:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685547479; x=1688139479;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=x09q4V7XQ8tGv39HcU1XOFn4TdsznzmNLwgqf5c45o0=;
        b=Dw+kB6wDsxUnFbut6TXa9W8Vi58mvUX04CMY61FEPF4i6py8V8S4Q+SiHXh2i02/kz
         7UMf0eLFl9FUgGJIhWXtdgDxU7n9z9JGfLNFH4oF8O1vytsyYBDc0Gl9pUefWYXwBHK2
         kwgxi1YRc1h4fKoB6vfKxCEtPntPafH35p13xW4FXrYmCPPPN4/zoH4ejmjAaoITsPNd
         UlmOE6dBBdB1Sk1LW1rT+W5/PcLw/mhgbRlTacxve6KvPCv2rqmtvpwV6fGve66nQk8y
         zibAOCrafRW90stiJR7/lHfHI/kfsSrTbiOdIJ4QHcbLtS1GMz+BCL1CI4HqYKwOlE3t
         3m7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685547479; x=1688139479;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x09q4V7XQ8tGv39HcU1XOFn4TdsznzmNLwgqf5c45o0=;
        b=PcUtq87nGdHNjfWf/jGTcbaiwmL/t7rk6LWwqfoYxSCFQ50fe6rT8GXkt2BrzX04Bu
         ++JZUErtGquL1m/l/CT2OFedVOJE0DIkygVqNBcdOW6KGzfTTfYkL6nKePWcugj2+F4E
         rCiqVROGue5HhFpzPZFHBUlkL/ZKOOsBl+KOKv/plVc+uSRlEdo1AYXhMVYuWtYTprh+
         Th02/fCWgeFnnF3WUL6I/S8TtoPe3FRiM51DYyTiznZTByTJeF0aQrlO9Tscf7eA1Tq5
         iiedg8kjYTv1RZKNhYsdqN2ALBx4R5uXNtHm93Q21zg/bkGywJuoPCKCtdbzvfW5IIPI
         RyCQ==
X-Gm-Message-State: AC+VfDzy1LKhvVIrpAIasldYV3TLqJbOeMbXSNEg0gud3dZDWKwDOady
	rrEq4YaUiCLpWFs2S5dw2rg=
X-Google-Smtp-Source: ACHHUZ4jhnC21Wc6o9lmMCq+lJCM+uuKu7p7gyH1bCwjQER7bVhggI8/qx8wqQOO6F8hW8ml6jmcnA==
X-Received: by 2002:a05:6a20:a122:b0:105:66d3:8538 with SMTP id q34-20020a056a20a12200b0010566d38538mr5353248pzk.8.1685547478984;
        Wed, 31 May 2023 08:37:58 -0700 (PDT)
Received: from ?IPv6:2605:59c8:448:b800:82ee:73ff:fe41:9a02? ([2605:59c8:448:b800:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id fe13-20020a056a002f0d00b0063f1430dd57sm3440014pfb.49.2023.05.31.08.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 08:37:58 -0700 (PDT)
Message-ID: <9523677f696a6376c79d32cbec7d6e7ceb1b0500.camel@gmail.com>
Subject: Re: [PATCH net-next v3 03/12] iavf: optimize Rx buffer allocation a
 bunch
From: Alexander H Duyck <alexander.duyck@gmail.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>, "David S. Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Magnus Karlsson
 <magnus.karlsson@intel.com>, Michal Kubiak <michal.kubiak@intel.com>,
 Larysa Zaremba <larysa.zaremba@intel.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Christoph Hellwig <hch@lst.de>, Paul Menzel <pmenzel@molgen.mpg.de>,
 netdev@vger.kernel.org,  intel-wired-lan@lists.osuosl.org,
 linux-kernel@vger.kernel.org
Date: Wed, 31 May 2023 08:37:56 -0700
In-Reply-To: <20230530150035.1943669-4-aleksander.lobakin@intel.com>
References: <20230530150035.1943669-1-aleksander.lobakin@intel.com>
	 <20230530150035.1943669-4-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 2023-05-30 at 17:00 +0200, Alexander Lobakin wrote:
> The Rx hotpath code of IAVF is not well-optimized TBH. Before doing any
> further buffer model changes, shake it up a bit. Notably:
>=20
> 1. Cache more variables on the stack.
>    DMA device, Rx page size, NTC -- these are the most common things
>    used all throughout the hotpath, often in loops on each iteration.
>    Instead of fetching (or even calculating, as with the page size) them
>    from the ring all the time, cache them on the stack at the beginning
>    of the NAPI polling callback. NTC will be written back at the end,
>    the rest are used read-only, so no sync needed.
> 2. Don't move the recycled buffers around the ring.
>    The idea of passing the page of the right-now-recycled-buffer to a
>    different buffer, in this case, the first one that needs to be
>    allocated, moreover, on each new frame, is fundamentally wrong. It
>    involves a few o' fetches, branches and then writes (and one Rx
>    buffer struct is at least 32 bytes) where they're completely unneeded,
>    but gives no good -- the result is the same as if we'd recycle it
>    inplace, at the same position where it was used. So drop this and let
>    the main refilling function take care of all the buffers, which were
>    processed and now need to be recycled/refilled.
> 3. Don't allocate with %GPF_ATOMIC on ifup.
>    This involved introducing the @gfp parameter to a couple functions.
>    Doesn't change anything for Rx -> softirq.
> 4. 1 budget unit =3D=3D 1 descriptor, not skb.
>    There could be underflow when receiving a lot of fragmented frames.
>    If each of them would consist of 2 frags, it means that we'd process
>    64 descriptors at the point where we pass the 32th skb to the stack.
>    But the driver would count that only as a half, which could make NAPI
>    re-enable interrupts prematurely and create unnecessary CPU load.
> 5. Shortcut !size case.
>    It's super rare, but possible -- for example, if the last buffer of
>    the fragmented frame contained only FCS, which was then stripped by
>    the HW. Instead of checking for size several times when processing,
>    quickly reuse the buffer and jump to the skb fields part.
> 6. Refill the ring after finishing the polling loop.
>    Previously, the loop wasn't starting a new iteration after the 64th
>    desc, meaning that we were always leaving 16 buffers non-refilled
>    until the next NAPI poll. It's better to refill them while they're
>    still hot, so do that right after exiting the loop as well.
>    For a full cycle of 64 descs, there will be 4 refills of 16 descs
>    from now on.
>=20
> Function: add/remove: 4/2 grow/shrink: 0/5 up/down: 473/-647 (-174)
>=20
> + up to 2% performance.
>=20
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>

What is the workload that is showing the performance improvement?

<...>

> @@ -1350,14 +1297,6 @@ static bool iavf_is_non_eop(struct iavf_ring *rx_r=
ing,
>  			    union iavf_rx_desc *rx_desc,
>  			    struct sk_buff *skb)

I am pretty sure the skb pointer here is an unused variable. We needed
it for ixgbe to support RSC. I don't think you have any code that uses
it in this function and I know we removed the variable for i40e, see
commit d06e2f05b4f18 ("i40e: adjust i40e_is_non_eop").




