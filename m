Return-Path: <netdev+bounces-747-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D18C6F97CD
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 10:59:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D64D12810CF
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 08:59:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D15D23A8;
	Sun,  7 May 2023 08:59:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483157C
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 08:59:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58B5156A7
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 01:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683449946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yeeGTjp1K1OeCb3ZIEFft75WO1ELEw08OZwAFoljYwY=;
	b=FEiRz3sAHv5D+7nGbQKsodCr+xeB57Re3R606Ff4bRRHH2WmPkUxUEJtI7jZ+x17VN2bQI
	zUQv86bSjhNWyvqMiw/d0sBZbqOxFXhMAG1esxV+SW0iZOXgVtIRptpiaL58Ee6SpKBisK
	+3q3Xtxp9gDjZrj0e7on7+etdOfxzko=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-MMULoCF_Mie3cf9mCorrTg-1; Sun, 07 May 2023 04:59:05 -0400
X-MC-Unique: MMULoCF_Mie3cf9mCorrTg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f33f8ffa95so13851995e9.3
        for <netdev@vger.kernel.org>; Sun, 07 May 2023 01:59:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683449943; x=1686041943;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yeeGTjp1K1OeCb3ZIEFft75WO1ELEw08OZwAFoljYwY=;
        b=aj0V01CwF1osDBkIlq7xmp2oz9zdOjdzA/31B+cIySW08NS8cEbP9uWMTmxuGrt9KU
         Zlk+doAxNm/efNg4rfcy2vl2LDHr+FOWyo6sG/78iBStv2qKMoSyIijPS7G6Svjnze02
         VxkMOpMdLMp9Y2pkNloGqsQcAnYCPyyqO8l9lajnn5hrcmNggUtzdR75/2Cw3j+Y9TB4
         DaxOTOADdg3p6CJnTCdQGX6ta38VfZByVSiIYYdJdLLW5YVuaveI1NszBGcFOV6T2ATI
         dmtvnpOL61/FRL2msSr40LRGxptZA9nbubUfrHZy/vinOcApRs//3NVKC3zIfhxn0pDN
         qZ7Q==
X-Gm-Message-State: AC+VfDx6xM0edNmj0lY6v/Y5gItkJoQiarhUnNFmoIq84YraSwXYJE3R
	y5WSNRRdsXRJUzY7g+FiJ5V/8Se9GVTYGtXXRjcwHJqHCfwpnEhkuFzpa8xkMjjD6nhzoZZ7q8J
	ZHMiZDjFfNVbGGk0f8p/kyfLs
X-Received: by 2002:a05:600c:b4b:b0:3f2:73a:32fc with SMTP id k11-20020a05600c0b4b00b003f2073a32fcmr4521785wmr.32.1683449943589;
        Sun, 07 May 2023 01:59:03 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7a9eutfAfd8aF4Cg4js80tavVGTVSzB9sy+7qygN//4rj17mi5XdK64Z91HAiqV/PL3Wlj8A==
X-Received: by 2002:a05:600c:b4b:b0:3f2:73a:32fc with SMTP id k11-20020a05600c0b4b00b003f2073a32fcmr4521773wmr.32.1683449943324;
        Sun, 07 May 2023 01:59:03 -0700 (PDT)
Received: from redhat.com ([2.52.158.28])
        by smtp.gmail.com with ESMTPSA id e19-20020a05600c219300b003f173419e7asm12993148wme.43.2023.05.07.01.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 01:59:02 -0700 (PDT)
Date: Sun, 7 May 2023 04:58:58 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Hao Chen <chenh@yusur.tech>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>, huangml@yusur.tech,
	zy@yusur.tech, Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"open list:VIRTIO CORE AND NET DRIVERS" <virtualization@lists.linux-foundation.org>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] virtio_net: set default mtu to 1500 when 'Device maximum
 MTU' bigger than 1500
Message-ID: <20230507045627-mutt-send-email-mst@kernel.org>
References: <20230506021529.396812-1-chenh@yusur.tech>
 <1683341417.0965195-4-xuanzhuo@linux.alibaba.com>
 <07b6b325-9a15-222f-e618-d149b57cbac2@yusur.tech>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <07b6b325-9a15-222f-e618-d149b57cbac2@yusur.tech>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 06, 2023 at 04:56:35PM +0800, Hao Chen wrote:
> 
> 
> 在 2023/5/6 10:50, Xuan Zhuo 写道:
> > On Sat,  6 May 2023 10:15:29 +0800, Hao Chen <chenh@yusur.tech> wrote:
> > > When VIRTIO_NET_F_MTU(3) Device maximum MTU reporting is supported.
> > > If offered by the device, device advises driver about the value of its
> > > maximum MTU. If negotiated, the driver uses mtu as the maximum
> > > MTU value. But there the driver also uses it as default mtu,
> > > some devices may have a maximum MTU greater than 1500, this may
> > > cause some large packages to be discarded,
> > 
> > You mean tx packet?
> Yes.
> > 
> > If yes, I do not think this is the problem of driver.
> > 
> > Maybe you should give more details about the discard.
> > 
> In the current code, if the maximum MTU supported by the virtio net hardware
> is 9000, the default MTU of the virtio net driver will also be set to 9000.
> When sending packets through "ping -s 5000", if the peer router does not
> support negotiating a path MTU through ICMP packets, the packets will be
> discarded. If the peer router supports negotiating path mtu through ICMP
> packets, the host side will perform packet sharding processing based on the
> negotiated path mtu, which is generally within 1500.
> This is not a bugfix patch, I think setting the default mtu to within 1500
> would be more suitable here.Thanks.

I don't think VIRTIO_NET_F_MTU is appropriate for support for jumbo packets.
The spec says:
	The device MUST forward transmitted packets of up to mtu (plus low level ethernet header length) size with
	gso_type NONE or ECN, and do so without fragmentation, after VIRTIO_NET_F_MTU has been success-
	fully negotiated.
VIRTIO_NET_F_MTU has been designed for all kind of tunneling devices,
and this is why we set mtu to max by default.

For things like jumbo frames where MTU might or might not be available,
a new feature would be more appropriate.

> > > so I changed the MTU to a more
> > > general 1500 when 'Device maximum MTU' bigger than 1500.
> > > 
> > > Signed-off-by: Hao Chen <chenh@yusur.tech>
> > > ---
> > >   drivers/net/virtio_net.c | 5 ++++-
> > >   1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 8d8038538fc4..e71c7d1b5f29 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -4040,7 +4040,10 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >   			goto free;
> > >   		}
> > > 
> > > -		dev->mtu = mtu;
> > > +		if (mtu > 1500)
> > 
> > s/1500/ETH_DATA_LEN/
> > 
> > Thanks.
> > 
> > > +			dev->mtu = 1500;
> > > +		else
> > > +			dev->mtu = mtu;
> > >   		dev->max_mtu = mtu;
> > >   	}
> > > 
> > > --
> > > 2.27.0
> > > 


