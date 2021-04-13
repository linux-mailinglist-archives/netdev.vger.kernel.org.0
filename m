Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335BC35E72C
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237673AbhDMTiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:38:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52797 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346157AbhDMTiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 15:38:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618342705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5KnGoDFAv6bKDXPJG6SYr7UZf9+Lclu6UjzMKtgboCI=;
        b=EfB3ygclNrxIzxSh4owcUIEIIcEWfK+bjwIPnsdrdW0Rr2lGtSPCJGxXBz2bio5KyD0vri
        elC1ztzDTnMtnHJ9VuA1IqFkHnUQYOvIiTipSyUb2GMMf3WTq86bbevJPT2eFVafIyQEjY
        ddn9XXanyrex79AMDYbuzNoueJhQmLA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182--QmoFqBLMCa5R66zgfL4tw-1; Tue, 13 Apr 2021 15:38:24 -0400
X-MC-Unique: -QmoFqBLMCa5R66zgfL4tw-1
Received: by mail-wm1-f69.google.com with SMTP id u11-20020a05600c00cbb029012a3f52677dso1545905wmm.8
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 12:38:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5KnGoDFAv6bKDXPJG6SYr7UZf9+Lclu6UjzMKtgboCI=;
        b=BNFtJKwET19jfj6+/TGiu8OJ1965+MVras1V/J9hlrg3S64PJpQVf5izcewPeKNaCL
         ZpCDRaMBmRCNyA9FYGthk3qSteucEf3sKVUwqUt1zN1Nr96p93hFfC/DhZSLd3DnOEuS
         l8pqbv70Xo69jeX/6/0SGKNK6pJSDH6vrvrmZZLr0XI71cviO9vLvyI6exwVEgMlAmo0
         UnfGzcvNCSSdVgPfZEhVv9/YEKeHkceoe19PlK7HLda55eqZY6xiZxYt1HIjJsIK6Fzq
         tG7JweQU832svK+M9GO3kzO83kn1u1HDHXI7RozL+uljpqcK2y+4vlMQY24A1dKU4kkm
         +Ehw==
X-Gm-Message-State: AOAM533PQuEG0x3AizJ9B6g0O9XyaY9kXB6KKyeHAhj1OTzR9bU9195G
        POe4YtNEkrFSDt6COiVwPSg+u0fMb/TezaLcEbrd7lWjAIDy+8EGPeAa68KrfWHYaQ2oAjTZIt2
        3le4AxauL+7lgCqQb
X-Received: by 2002:a1c:bb46:: with SMTP id l67mr1483567wmf.103.1618342703114;
        Tue, 13 Apr 2021 12:38:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsyBoIOrK8jLYHlfy//zbHQzTjiDZw65hyrrkhQTF1B81u43o0GIascvITlEoglSzyEJwJ+A==
X-Received: by 2002:a1c:bb46:: with SMTP id l67mr1483554wmf.103.1618342702959;
        Tue, 13 Apr 2021 12:38:22 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id u4sm3188906wml.0.2021.04.13.12.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 12:38:22 -0700 (PDT)
Date:   Tue, 13 Apr 2021 15:38:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC v2 3/4] virtio_net: move tx vq operation under tx
 queue lock
Message-ID: <20210413153619-mutt-send-email-mst@kernel.org>
References: <20210413054733.36363-1-mst@redhat.com>
 <20210413054733.36363-4-mst@redhat.com>
 <805053bf-960f-3c34-ce23-012d121ca937@redhat.com>
 <20210413100222-mutt-send-email-mst@kernel.org>
 <CA+FuTSe=3cAkhwjSDDt1U8mSiVj5BKgJ7DJGxAAoF22kac3CMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+FuTSe=3cAkhwjSDDt1U8mSiVj5BKgJ7DJGxAAoF22kac3CMQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 10:20:39AM -0400, Willem de Bruijn wrote:
> On Tue, Apr 13, 2021 at 10:03 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Apr 13, 2021 at 04:54:42PM +0800, Jason Wang wrote:
> > >
> > > 在 2021/4/13 下午1:47, Michael S. Tsirkin 写道:
> > > > It's unsafe to operate a vq from multiple threads.
> > > > Unfortunately this is exactly what we do when invoking
> > > > clean tx poll from rx napi.
> 
> Actually, the issue goes back to the napi-tx even without the
> opportunistic cleaning from the receive interrupt, I think? That races
> with processing the vq in start_xmit.
> 
> > > > As a fix move everything that deals with the vq to under tx lock.
> > > >
> 
> If the above is correct:
> 
> Fixes: b92f1e6751a6 ("virtio-net: transmit napi")
> 
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > ---
> > > >   drivers/net/virtio_net.c | 22 +++++++++++++++++++++-
> > > >   1 file changed, 21 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 16d5abed582c..460ccdbb840e 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -1505,6 +1505,8 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
> > > >     struct virtnet_info *vi = sq->vq->vdev->priv;
> > > >     unsigned int index = vq2txq(sq->vq);
> > > >     struct netdev_queue *txq;
> > > > +   int opaque;
> 
> nit: virtqueue_napi_complete also stores as int opaque, but
> virtqueue_enable_cb_prepare actually returns, and virtqueue_poll
> expects, an unsigned int. In the end, conversion works correctly. But
> cleaner to use the real type.
> 
> > > > +   bool done;
> > > >     if (unlikely(is_xdp_raw_buffer_queue(vi, index))) {
> > > >             /* We don't need to enable cb for XDP */
> > > > @@ -1514,10 +1516,28 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
> > > >     txq = netdev_get_tx_queue(vi->dev, index);
> > > >     __netif_tx_lock(txq, raw_smp_processor_id());
> > > > +   virtqueue_disable_cb(sq->vq);
> > > >     free_old_xmit_skbs(sq, true);
> > > > +
> > > > +   opaque = virtqueue_enable_cb_prepare(sq->vq);
> > > > +
> > > > +   done = napi_complete_done(napi, 0);
> > > > +
> > > > +   if (!done)
> > > > +           virtqueue_disable_cb(sq->vq);
> > > > +
> > > >     __netif_tx_unlock(txq);
> > > > -   virtqueue_napi_complete(napi, sq->vq, 0);
> > >
> > >
> > > So I wonder why not simply move __netif_tx_unlock() after
> > > virtqueue_napi_complete()?
> > >
> > > Thanks
> > >
> >
> >
> > Because that calls tx poll which also takes tx lock internally ...
> 
> which tx poll?

Oh. It's virtqueue_poll actually. I confused it with
virtnet_poll_tx. Right. We can put it back the way it was.

-- 
MST

