Return-Path: <netdev+bounces-805-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7472D6F9FC1
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:22:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FABE280EA7
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 06:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E8213AF9;
	Mon,  8 May 2023 06:15:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB658320A
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 06:15:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E719B17FFB
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 23:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683526554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a16qsR25aXRVKPUMu4eumPHJGCumyCFazBn+gGGgB/I=;
	b=h9uN7lDtC/T9VTHB+a8+b4Br7OxKXsTDguJ7TdwS4zeE40jDSi1rvqlso25a3Tu4OzDuzI
	1C8n1T6kYOHAg64doJSQ0aF0cKBqe+jEP4lqDyzI0hveCSd1tFyeYGeqGxXCG1FnW6mjw8
	fVw7UUuP3GUj42T6Islgu5QuwIqaLVM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-NktkuJhrO0avUl0yfiLWeA-1; Mon, 08 May 2023 02:15:52 -0400
X-MC-Unique: NktkuJhrO0avUl0yfiLWeA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-306286b3573so2522393f8f.2
        for <netdev@vger.kernel.org>; Sun, 07 May 2023 23:15:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683526551; x=1686118551;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a16qsR25aXRVKPUMu4eumPHJGCumyCFazBn+gGGgB/I=;
        b=PrPRIuuxl8wZ8EUk75ND8512VMiVeFZOK/Obfh99oUweWR4iYUH4FYblPHMW0Xx/hm
         NFayzOpv25oAMJpCEDHehGbclLUPQ/s7TU25U8+KxZ3zLKUlhtMyZz4sKWI+OMrgh2mG
         SdH+/lRd0PKdR1ISectfXNoZFRff1f5Fvj93EGvAlP2F6/7uDQvUzaLVyEOhlETCYfdl
         Ry3H4rrtGUwMgdkoMO9tW0jp26HBNC/X2rMO6s2ZxawBcavlzLQKK+hLx9S0yZ8MX47w
         OAP1NJip9/mH45xCCCwh3tDUV2yrEzcf8NdnovjQQ4OUYEPYhrG86w/ALZqvOOTXuedu
         hnIg==
X-Gm-Message-State: AC+VfDxmIGlFcq0zZvYlOBS/xIX/j9pIJl4S/xre+67Lont/FI9wYM6c
	6pNUpl2/i6OQFhEyOrCAwp5wE33z37qaBToG25Gy3Nj++gXorLJ+4rZN5GVILHMWazqPhHrYkeR
	j8cPTfaNAthtTHMdD
X-Received: by 2002:adf:fccd:0:b0:2f5:7e67:9c68 with SMTP id f13-20020adffccd000000b002f57e679c68mr6231382wrs.30.1683526551627;
        Sun, 07 May 2023 23:15:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ51aIif9Zzf71VSyESMCs9ojU26BNYa4ExPKWLDuG2PEVBUuxy/OQj9y3Xq+EYvx0RZfh2HcQ==
X-Received: by 2002:adf:fccd:0:b0:2f5:7e67:9c68 with SMTP id f13-20020adffccd000000b002f57e679c68mr6231373wrs.30.1683526551304;
        Sun, 07 May 2023 23:15:51 -0700 (PDT)
Received: from redhat.com ([2.52.158.28])
        by smtp.gmail.com with ESMTPSA id b13-20020a05600010cd00b00306299be5a2sm10289776wrx.72.2023.05.07.23.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 23:15:50 -0700 (PDT)
Date: Mon, 8 May 2023 02:15:46 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: huangml@yusur.tech, zy@yusur.tech, Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"open list:VIRTIO CORE AND NET DRIVERS" <virtualization@lists.linux-foundation.org>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	Hao Chen <chenh@yusur.tech>, hengqi@linux.alibaba.com
Subject: Re: [PATCH] virtio_net: set default mtu to 1500 when 'Device maximum
 MTU' bigger than 1500
Message-ID: <20230508020953-mutt-send-email-mst@kernel.org>
References: <20230506021529.396812-1-chenh@yusur.tech>
 <1683341417.0965195-4-xuanzhuo@linux.alibaba.com>
 <07b6b325-9a15-222f-e618-d149b57cbac2@yusur.tech>
 <20230507045627-mutt-send-email-mst@kernel.org>
 <1683511319.099806-2-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1683511319.099806-2-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 10:01:59AM +0800, Xuan Zhuo wrote:
> On Sun, 7 May 2023 04:58:58 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Sat, May 06, 2023 at 04:56:35PM +0800, Hao Chen wrote:
> > >
> > >
> > > 在 2023/5/6 10:50, Xuan Zhuo 写道:
> > > > On Sat,  6 May 2023 10:15:29 +0800, Hao Chen <chenh@yusur.tech> wrote:
> > > > > When VIRTIO_NET_F_MTU(3) Device maximum MTU reporting is supported.
> > > > > If offered by the device, device advises driver about the value of its
> > > > > maximum MTU. If negotiated, the driver uses mtu as the maximum
> > > > > MTU value. But there the driver also uses it as default mtu,
> > > > > some devices may have a maximum MTU greater than 1500, this may
> > > > > cause some large packages to be discarded,
> > > >
> > > > You mean tx packet?
> > > Yes.
> > > >
> > > > If yes, I do not think this is the problem of driver.
> > > >
> > > > Maybe you should give more details about the discard.
> > > >
> > > In the current code, if the maximum MTU supported by the virtio net hardware
> > > is 9000, the default MTU of the virtio net driver will also be set to 9000.
> > > When sending packets through "ping -s 5000", if the peer router does not
> > > support negotiating a path MTU through ICMP packets, the packets will be
> > > discarded. If the peer router supports negotiating path mtu through ICMP
> > > packets, the host side will perform packet sharding processing based on the
> > > negotiated path mtu, which is generally within 1500.
> > > This is not a bugfix patch, I think setting the default mtu to within 1500
> > > would be more suitable here.Thanks.
> >
> > I don't think VIRTIO_NET_F_MTU is appropriate for support for jumbo packets.
> > The spec says:
> > 	The device MUST forward transmitted packets of up to mtu (plus low level ethernet header length) size with
> > 	gso_type NONE or ECN, and do so without fragmentation, after VIRTIO_NET_F_MTU has been success-
> > 	fully negotiated.
> > VIRTIO_NET_F_MTU has been designed for all kind of tunneling devices,
> > and this is why we set mtu to max by default.
> >
> > For things like jumbo frames where MTU might or might not be available,
> > a new feature would be more appropriate.
> 
> 
> So for jumbo frame, what is the problem?
> 
> We are trying to do this. @Heng
> 
> Thanks.

It is not a problem as such. But VIRTIO_NET_F_MTU will set the
default MTU not just the maximum one, because spec seems to
say it can.


> 
> >
> > > > > so I changed the MTU to a more
> > > > > general 1500 when 'Device maximum MTU' bigger than 1500.
> > > > >
> > > > > Signed-off-by: Hao Chen <chenh@yusur.tech>
> > > > > ---
> > > > >   drivers/net/virtio_net.c | 5 ++++-
> > > > >   1 file changed, 4 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index 8d8038538fc4..e71c7d1b5f29 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -4040,7 +4040,10 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > > >   			goto free;
> > > > >   		}
> > > > >
> > > > > -		dev->mtu = mtu;
> > > > > +		if (mtu > 1500)
> > > >
> > > > s/1500/ETH_DATA_LEN/
> > > >
> > > > Thanks.
> > > >
> > > > > +			dev->mtu = 1500;
> > > > > +		else
> > > > > +			dev->mtu = mtu;
> > > > >   		dev->max_mtu = mtu;
> > > > >   	}
> > > > >
> > > > > --
> > > > > 2.27.0
> > > > >
> >


