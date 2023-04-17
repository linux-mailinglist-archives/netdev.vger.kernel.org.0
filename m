Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFF66E438F
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 11:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjDQJVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 05:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjDQJVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 05:21:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A587040FD
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 02:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681723217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vNVnMNLujGbpw5r7sYnlsLlVBFalrrcN8dNsOuZXTw0=;
        b=LvSWET45AKADXPG2360TOKh/wZ0nwHafApESXq4iCJn4EJwaOJHsHkfl+8gwdyAbxArc40
        XuzNDHAxTdA5kz0gZha8v9TTzwBMZavdtROwvhETxDYqCKUha5NalqR0WfVofUGDj5CTIl
        t62f/sSRcisTirF29swZVEM/Oru4aTY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-vCJPLSAoP-yscsrtY9q6Dg-1; Mon, 17 Apr 2023 05:20:16 -0400
X-MC-Unique: vCJPLSAoP-yscsrtY9q6Dg-1
Received: by mail-qt1-f200.google.com with SMTP id l20-20020a05622a051400b003e6d92a606bso12799561qtx.14
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 02:20:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681723216; x=1684315216;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vNVnMNLujGbpw5r7sYnlsLlVBFalrrcN8dNsOuZXTw0=;
        b=eUYeeN+ZqQRcO44r1/B2EndC0LekDdE8BIKFzbwNlzCKQ34+8/vWUsee65nyeMNWJW
         8yBFbiwLxdPE2pTZhc2ILPkSyXoxazc5FZoASVioGXNY7zkrxt1SorwBvgbTSlc4vYYL
         AJeif/HFJyVzIz0LVDdkwofDuEt8BIaOSTXrzEOWRDt5R1W2OMSNrRj77am7XIpK/WAH
         myRxI9zQs7oo68IODbKSHnM9QsSbz/WDHZ/KvQwc8kYQtP3SQ5R7PE0/x2JCs0W90cJW
         z2DZROaqEoc+pqGxbjW+3e/VZCnOt4ekWF8hjhBU6vrcaaHKpycEYKOhggU/FLvyS4n9
         NB4Q==
X-Gm-Message-State: AAQBX9fXIXRjTJXgcQ8NmYaJ6DP7iK+mav1HNC0PSiIXyKGFN1FsUaAr
        uE15WaEuG2skj/K0YcCnlRLoUF3n9VLMpoCWGkGDoDeQdMbgH1k7ebeb7c/o7hT0gBkPY4DXyHN
        DkGM1yXI1/qN7DX6j
X-Received: by 2002:a05:622a:550:b0:3e6:35d9:2c14 with SMTP id m16-20020a05622a055000b003e635d92c14mr25324985qtx.19.1681723216016;
        Mon, 17 Apr 2023 02:20:16 -0700 (PDT)
X-Google-Smtp-Source: AKy350b2JvceDDe59kay7fdrE1cUYDltBYRWJcjOLEX8d+sK0DHfxcKJlAzVlK4Jy62gtSq9j6RpqQ==
X-Received: by 2002:a05:622a:550:b0:3e6:35d9:2c14 with SMTP id m16-20020a05622a055000b003e635d92c14mr25324970qtx.19.1681723215756;
        Mon, 17 Apr 2023 02:20:15 -0700 (PDT)
Received: from redhat.com ([185.199.103.251])
        by smtp.gmail.com with ESMTPSA id bp11-20020a05620a458b00b0074cf9d16cb0sm1481988qkb.14.2023.04.17.02.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 02:20:15 -0700 (PDT)
Date:   Mon, 17 Apr 2023 05:20:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Message-ID: <20230417051816-mutt-send-email-mst@kernel.org>
References: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
 <AM0PR04MB4723C6E99A217F51973710F5D49F9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230416164453-mutt-send-email-mst@kernel.org>
 <CACGkMEvFhVyWb5+ET_akPvnjUq04+ZbJC8o_GtNBWqSMGNum8A@mail.gmail.com>
 <20230417021725-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723B8489F8F9AE547393697D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417023911-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237BFB8BB3A3606CE6A408D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417030713-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723F3E6AE381AEC36D1AEFED49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB4723F3E6AE381AEC36D1AEFED49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 07:33:58AM +0000, Alvaro Karsz wrote:
> > > > > > Actually, I think that all you need to do is disable NETIF_F_SG,
> > > > > > and things will work, no?
> > > > >
> > > > > I think that this is not so simple, if I understand correctly, by disabling NETIF_F_SG we will never receive a chained skbs to transmit, but we still have more functionality to address, for example:
> > > > > * The TX timeouts.
> > > >
> > > > I don't get it. With a linear skb we can transmit it as long as there's
> > > > space for 2 entries in the vq: header and data. What's the source of the
> > > > timeouts?
> > > >
> > >
> > > I'm not saying that this is not possible, I meant that we need more changes to virtio-net.
> > > The source of the timeouts is from the current implementation of virtnet_poll_tx.
> > >
> > > if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
> > >       netif_tx_wake_queue(txq);
> > 
> > Oh right. So this should check NETIF_F_SG then.
> > BTW both ring size and s/g can be tweaked by ethtool, also
> > needs handling.
> > 
> 
> Good point.
> 
> > >
> > > > > * Guest GSO/big MTU (without VIRTIO_NET_F_MRG_RXBUF?), we can't chain page size buffers anymore.
> > > >
> > > > I think we can.  mergeable_min_buf_len will just be large.
> > > >
> > >
> > > I meant that we can't just by clearing NETIF_F_SG, we'll need to change virtio-net a little bit more, for example, the virtnet_set_big_packets function.
> > >
> > 
> > Right - for RX, big_packets_num_skbfrags ignores ring size and that's
> > probably a bug if mtu is very large.
> > 
> 
> So, what do you think, we should fix virtio-net to work with smaller rings? we should fail probe?
> 
> I think that since this never came up until now, there is no big demand to such small rings.

The worry is that once we start failing probe there's just a tiny chance
hosts begin to rely on us failing probe then we won't be able to fix it.
So it depends on the size of the patch I think. So far it seems small enough
that wasting code on failing probe isn't worth it.

-- 
MST

