Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5381C6DB5
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 11:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgEFJy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 05:54:58 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34113 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726935AbgEFJyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 05:54:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588758892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IQgpC6M6Fr0QXYCApTnYcfdrhwDOylYbkH9y+/KvXfc=;
        b=hmbXPHaj7wcMFWHWhLB+KyzYOJ3kYIra2QN6R7vzel9ao4Jb9DjGLwKBctklHGViF46tRu
        ogsW7rM0r9JtpjXQbu4xikgRiPr3vbWMvVgiL3dtEluRbYwuqjrsP2Wv8+hBTMsju3fF+r
        uGjV5GiG7YYSlxezm4JItFopsjPenmM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-pSPmLzh2MUicxmCaPCLQow-1; Wed, 06 May 2020 05:54:51 -0400
X-MC-Unique: pSPmLzh2MUicxmCaPCLQow-1
Received: by mail-wr1-f71.google.com with SMTP id z5so1027537wrt.17
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 02:54:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=IQgpC6M6Fr0QXYCApTnYcfdrhwDOylYbkH9y+/KvXfc=;
        b=SDK8qmE8cXKwQg7vrWufHGQ3RqxPVgtcv0wkcbCaGL7WV0eWGNNdwuFBvp+FRD4M8R
         Y8JN/DllVsIPGz/5fm/um/uWREOdIBc+FKZ8JiJ8gtAts6zw/zXsdQsAKxK198CkOMfX
         gy5ARjF/0j+St8uAS2YAGgxKhmQEtkpkXmbuwQWHQlRZhCLDnSZcDWqLanWvuQynS3xD
         ecyfPZh5I24mb4s4LEGJTBXHJXH7fT6dnbE7fFgNRl5P6rlPzHJPmhfTaecNPrcuL7KM
         fqM9UwkwBjyng+qOyyb+X3u7Dwr/0jUbaNcB/+ay2AwYqfk/K9sNILlluZWmVb8FbWrL
         cswA==
X-Gm-Message-State: AGi0PuYPFL2aScnbKGyj5AG6D+8X8pUoHRVPCb0j2WMtI6ponyRyM/sN
        8hs4M4t2KpaTcdUKYH9IomzMPQ3460rdHAOEF5o70kyeyYG8Oyg5enzTFE1GnuDFVHpEK8hxYbd
        X0sSnzMpv9ClHFCFi
X-Received: by 2002:a1c:2383:: with SMTP id j125mr3560320wmj.6.1588758889753;
        Wed, 06 May 2020 02:54:49 -0700 (PDT)
X-Google-Smtp-Source: APiQypKtmLaaSMrbt2AgLvxUJBNSQPFDRBWOY4wRUCKhGIWK+KiuCn92js4GGRYIiEgbL9ZdbdY9GA==
X-Received: by 2002:a1c:2383:: with SMTP id j125mr3560305wmj.6.1588758889563;
        Wed, 06 May 2020 02:54:49 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id r3sm1922605wrx.72.2020.05.06.02.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 02:54:49 -0700 (PDT)
Date:   Wed, 6 May 2020 05:54:46 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH net-next 1/2] virtio-net: don't reserve space for vnet
 header for XDP
Message-ID: <20200506055436-mutt-send-email-mst@kernel.org>
References: <20200506061633.16327-1-jasowang@redhat.com>
 <20200506033834-mutt-send-email-mst@kernel.org>
 <7a169b06-b6b9-eac1-f03a-39dd1cfcce57@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7a169b06-b6b9-eac1-f03a-39dd1cfcce57@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 04:19:40PM +0800, Jason Wang wrote:
> 
> On 2020/5/6 下午3:53, Michael S. Tsirkin wrote:
> > On Wed, May 06, 2020 at 02:16:32PM +0800, Jason Wang wrote:
> > > We tried to reserve space for vnet header before
> > > xdp.data_hard_start. But this is useless since the packet could be
> > > modified by XDP which may invalidate the information stored in the
> > > header and there's no way for XDP to know the existence of the vnet
> > > header currently.
> > What do you mean? Doesn't XDP_PASS use the header in the buffer?
> 
> 
> We don't, see 436c9453a1ac0 ("virtio-net: keep vnet header zeroed after
> processing XDP")
> 
> If there's other place, it should be a bug.
> 
> 
> > 
> > > So let's just not reserve space for vnet header in this case.
> > In any case, we can find out XDP does head adjustments
> > if we need to.
> 
> 
> But XDP program can modify the packets without adjusting headers.
> 
> Thanks

Then what's the problem?

> 
> > 
> > 
> > > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > >   drivers/net/virtio_net.c | 6 +++---
> > >   1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 11f722460513..98dd75b665a5 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -684,8 +684,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
> > >   			page = xdp_page;
> > >   		}
> > > -		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
> > > -		xdp.data = xdp.data_hard_start + xdp_headroom;
> > > +		xdp.data_hard_start = buf + VIRTNET_RX_PAD;
> > > +		xdp.data = xdp.data_hard_start + xdp_headroom + vi->hdr_len;
> > >   		xdp.data_end = xdp.data + len;
> > >   		xdp.data_meta = xdp.data;
> > >   		xdp.rxq = &rq->xdp_rxq;
> > > @@ -845,7 +845,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
> > >   		 * the descriptor on if we get an XDP_TX return code.
> > >   		 */
> > >   		data = page_address(xdp_page) + offset;
> > > -		xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
> > > +		xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM;
> > >   		xdp.data = data + vi->hdr_len;
> > >   		xdp.data_end = xdp.data + (len - vi->hdr_len);
> > >   		xdp.data_meta = xdp.data;
> > > -- 
> > > 2.20.1

