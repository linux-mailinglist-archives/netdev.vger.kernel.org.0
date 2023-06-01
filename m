Return-Path: <netdev+bounces-7025-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C4B6719511
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:09:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3B6A1C20FD7
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E556D30A;
	Thu,  1 Jun 2023 08:09:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003065392
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 08:09:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34317AA
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 01:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685606974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pDVmBRHQleLMTi+Z7D0Zv8qBsfmNlFbYk+Fn+QOciuw=;
	b=a5qhxxS6EJYDxM8Q27KGJqOBjne1sGXiMY4/9A+bAe6MFFPZdjh3dhofQ6WIhNvh2Aw2G0
	xqs8aNWgTITulTS7y3z9kW+IqneKUz35RO0ci/8ryD591hqukHiDbvJUO3jeOS/DLHVH6e
	iUdr4DPGl20ZlDpgBRja79ZXNH0zT7g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-EwHbpVLPMKmEQb9taITf0w-1; Thu, 01 Jun 2023 04:09:33 -0400
X-MC-Unique: EwHbpVLPMKmEQb9taITf0w-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f08900caadso918535e9.0
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 01:09:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685606972; x=1688198972;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pDVmBRHQleLMTi+Z7D0Zv8qBsfmNlFbYk+Fn+QOciuw=;
        b=EySAxfBVa3YzHePicxCI2/6xdRcoJhfz0VJ6hQSB+gkwH7thMm2UGdB762XPtdQylm
         d3pGR/tRmbfd+s4q0zulIl4y85Nr9rh22WpdB6j+axmPzPJGSxKEJX9wnIoeQlpmU6Cp
         DZqMiAVDp/U/FL1Jqfa0PG7n4ubTLTSSQHY5vF6mXlWmVSm+mKDffsyVs79VrURODIuG
         0WvGjxTVGLVIijkurTD2J1VleKyFM7lJt4gJv161kLsvQWzXVikA8opHC86YKAnn8zyj
         EdqsUqWMCe21Yx2DPEJoR7NyMwLovFe2rGiFuhWorXEtjyDaA7573ApCyZNO6KY7AxmJ
         tbKA==
X-Gm-Message-State: AC+VfDy7rtF25VN7TLDGQzNiHOXVpRzEvC6KIiOoVgqdZerKdEUqWi5k
	RcjGiLBz/vAingQ59EIWAAv/pXMmjC4EVRNl09ia8h3A71kCMGrE5GqeDApXwxH3LkE9ypIeiDe
	I4h7zHFc1wEDgJ2Ba
X-Received: by 2002:adf:f34d:0:b0:2fa:b265:a010 with SMTP id e13-20020adff34d000000b002fab265a010mr5589753wrp.7.1685606972183;
        Thu, 01 Jun 2023 01:09:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7btuoTXIuS7dg9++Dm3sJtRubRCgOMM0uvp8Ej1HQa7dk1CnCAUxdL2fUJIdPo3clHT5D+vg==
X-Received: by 2002:adf:f34d:0:b0:2fa:b265:a010 with SMTP id e13-20020adff34d000000b002fab265a010mr5589733wrp.7.1685606971861;
        Thu, 01 Jun 2023 01:09:31 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-242-89.dyn.eolo.it. [146.241.242.89])
        by smtp.gmail.com with ESMTPSA id u6-20020adfeb46000000b0030ae53550f5sm9259931wrn.51.2023.06.01.01.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 01:09:31 -0700 (PDT)
Message-ID: <d7820e8eb82ca1cca93678c88da002e6bee0ca7f.camel@redhat.com>
Subject: Re: [PATCH net-next v3 2/2] usbnet: ipheth: add CDC NCM support
From: Paolo Abeni <pabeni@redhat.com>
To: Foster Snowhill <forst@pen.gy>, "David S. Miller" <davem@davemloft.net>,
  Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>
Cc: Georgi Valkov <gvalkov@gmail.com>, Simon Horman
 <simon.horman@corigine.com>,  Jan Kiszka <jan.kiszka@siemens.com>,
 linux-usb@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 01 Jun 2023 10:09:30 +0200
In-Reply-To: <581e4f2e-c6e3-026b-7a51-968afb616a7e@pen.gy>
References: <20230527130309.34090-1-forst@pen.gy>
	 <20230527130309.34090-2-forst@pen.gy>
	 <Hpg7Nwtv7aepWNQuwyGiCoXT2ScF0xBHsfvNBP7ytjXH6O-UIgpz_V7NoHsO00bS5bzlq_W5LUeEOhRO4eZd6w==@protonmail.internalid>
	 <e7159f2e39e79e51da123d09cfbcc21411dad544.camel@redhat.com>
	 <581e4f2e-c6e3-026b-7a51-968afb616a7e@pen.gy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 2023-05-31 at 17:10 +0200, Foster Snowhill wrote:
> >=20
> > > 	memcpy(dev->tx_buf, skb->data, skb->len);
> > > -	if (skb->len < IPHETH_BUF_SIZE)
> > > -		memset(dev->tx_buf + skb->len, 0, IPHETH_BUF_SIZE - skb->len);
> > >=20
> > >  	usb_fill_bulk_urb(dev->tx_urb, udev,
> > >  			  usb_sndbulkpipe(udev, dev->bulk_out),
> > > -			  dev->tx_buf, IPHETH_BUF_SIZE,
> > > +			  dev->tx_buf, skb->len,
> > >  			  ipheth_sndbulk_callback,
> > >  			  dev);
> > >  	dev->tx_urb->transfer_flags |=3D URB_NO_TRANSFER_DMA_MAP;
> >=20
> > This chunk looks unrelated from NCM support, and unconditionally
> > changes the established behaviour even with legacy mode, why?
> >=20
> > Does that works even with old(er) devices?
>=20
> I see Georgi Valkov said he tested v3 of the patch on older iOS devices
> and confirmed it working. I'll chat with him to get some USB traffic
> captures, to check what is macOS' behaviour with such devices (to make
> sure we behave the same way as the official driver). I also wanted to
> investigate a bit, when was NCM support even added to iOS.
>=20
> Personally I remember testing this in legacy mode a while ago, before
> I implemented NCM. I will re-test it again in legacy mode in addition
> to Georgi's efforts.
>=20
> From my side, I think it's reasonable to split this out into a separate
> patch, since it technically applies to the legacy mode as well, and
> doesn't (directly) relate to NCM support, as you pointed out.

I think that would be the best option, so we have a clear separation
between what is needed for NCM support and other improvements.

Thanks!

Paolo


