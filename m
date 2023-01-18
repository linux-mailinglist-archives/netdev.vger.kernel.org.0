Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2F46723D4
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 17:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjARQoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 11:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjARQnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 11:43:24 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1172222E4
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:43:11 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id 123so5645862ybv.6
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oANpR+IEr+HXBbuEuOCWBjBiryhz3ADGFGJOFyyjqGY=;
        b=fU6OeL1COy/rLIHqW84ssNeMDewowxorpiY6IXRChcoBdwmo2TH2hNDqLDUOBcP+3c
         ZnKE6+V3DGZau7obJUAVY2yhDFPspzuPm15sE/SLNCJ+rwECBZShOZoCWoTkVHW0rn4U
         OGRt4GMhoKXdflf+l21Sx/l3gBPlq8H0PYb+nipE+z6D1wH1MVyIV2YHXmbeYM3KPYhe
         iqJ48Z6n0cIWgWQNbxXYcPH3IwlVX3ZqPLlwod9is4PNCpfkw9uD7PCdh2RJrBidOiiv
         cWHwmblxYECFmKw7Zrng9aroMdxcHbG8uNfPs+SMSkIfIhHttqvY3M7Zh1YxSwlHRZbx
         0YXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oANpR+IEr+HXBbuEuOCWBjBiryhz3ADGFGJOFyyjqGY=;
        b=fAhl6nq6NfAhK+dgyy6sPQFrqhV+D/6GNoyOJT4obqU+znuEQLP7ahp4BwnzVrOcAY
         +BI5SJb6qOx3bIzVie3FIzZVc+JiBTZ8tEZK9abqLnwEcmA+xT/wUUfhq7oZYnOfExkO
         sN/8pDi/wAsUvEZCSB08CECY00r8oGBNGb9V23dRvPVaEsqM6CPdYRt7+boGFADYnn3v
         ZBta4zr3aOcVI4nlPEaRUXUaBICcfZRnVlJ+OxEteK+6NPok5HAo0z9X03RoNHZ/3hN+
         tP2o48s339p26EdnC63HUtxne2iWFjT7Dls8UVuCQerQE9yDNZS0Qs0xdh2jsLSjBd7s
         Ev8w==
X-Gm-Message-State: AFqh2krqYYMenrcZPzkOcyCyZq9mUXweKK5WQrRLbxS2Uw3AIFUntNFh
        CX2WCh3DoHRGD7qV0af10Hw8iXWQDmTLnps4IhU3bg==
X-Google-Smtp-Source: AMrXdXuuuwQy5BqKsXS1leZq/AjybebDPp5Xm98hKEZKY1uR13hyu0kPZNyowfgLb+g0QpcZ0gsSTMmm7f9VdlEjZ58=
X-Received: by 2002:a05:6902:683:b0:7e3:553a:11fb with SMTP id
 i3-20020a056902068300b007e3553a11fbmr732234ybt.387.1674060190633; Wed, 18 Jan
 2023 08:43:10 -0800 (PST)
MIME-Version: 1.0
References: <167361788585.531803.686364041841425360.stgit@firesoul>
 <167361792462.531803.224198635706602340.stgit@firesoul> <CANn89i+POvkrx-RW3WNA2-1oQSdHt2-0sOddQWwtGQkAbW9RFQ@mail.gmail.com>
 <9b290dd9-3729-2371-b3ad-ac6570279027@redhat.com>
In-Reply-To: <9b290dd9-3729-2371-b3ad-ac6570279027@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 18 Jan 2023 17:42:59 +0100
Message-ID: <CANn89iL_Wi0Qwqg8=X9zO09=eY9srnF8XjmL9t=P9kn=GR_aGw@mail.gmail.com>
Subject: Re: [PATCH net-next V2 2/2] net: kfree_skb_list use kmem_cache_free_bulk
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 5:42 PM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 18/01/2023 17.05, Eric Dumazet wrote:
> > On Fri, Jan 13, 2023 at 2:52 PM Jesper Dangaard Brouer
> > <brouer@redhat.com> wrote:
> >>
> >> The kfree_skb_list function walks SKB (via skb->next) and frees them
> >> individually to the SLUB/SLAB allocator (kmem_cache). It is more
> >> efficient to bulk free them via the kmem_cache_free_bulk API.
> >>
> >> This patches create a stack local array with SKBs to bulk free while
> >> walking the list. Bulk array size is limited to 16 SKBs to trade off
> >> stack usage and efficiency. The SLUB kmem_cache "skbuff_head_cache"
> >> uses objsize 256 bytes usually in an order-1 page 8192 bytes that is
> >> 32 objects per slab (can vary on archs and due to SLUB sharing). Thus,
> >> for SLUB the optimal bulk free case is 32 objects belonging to same
> >> slab, but runtime this isn't likely to occur.
> >>
> >> The expected gain from using kmem_cache bulk alloc and free API
> >> have been assessed via a microbencmark kernel module[1].
> >>
> >> The module 'slab_bulk_test01' results at bulk 16 element:
> >>   kmem-in-loop Per elem: 109 cycles(tsc) 30.532 ns (step:16)
> >>   kmem-bulk    Per elem: 64 cycles(tsc) 17.905 ns (step:16)
> >>
> >> More detailed description of benchmarks avail in [2].
> >>
> >> [1] https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/mm
> >> [2] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/kfree_skb_list01.org
> >>
> >> V2: rename function to kfree_skb_add_bulk.
> >>
> >> Reviewed-by: Saeed Mahameed <saeed@kernel.org>
> >> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> >> ---
> >
> > According to syzbot, this patch causes kernel panics, in IP fragmentation logic.
> >
> > Can you double check if there is no obvious bug ?
>
> Do you have a link to the syzbot issue?

Not yet, I will release it, with a repro.
