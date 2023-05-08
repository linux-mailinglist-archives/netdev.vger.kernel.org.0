Return-Path: <netdev+bounces-924-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FD0E6FB633
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 20:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A05821C20A0B
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D7B10952;
	Mon,  8 May 2023 18:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C4A524E
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 18:10:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F3A19D
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 11:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683569419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xgNVzoHB5qPigrpPQ7go/TrIsJOwIwgQ8Ks/ppylKsI=;
	b=ATWee/PpSZ8birYYfb/9e3n/KovM3/6SaWnu+rFT/hmh53V1XFJamhODuM9F+lT34lS5sm
	kd5mMOS1zrqjSpVRcfxnicYLV8eNcrSHf6SL7QS+yJqO5XVDTif2+VzPy39yjzCoGWYo8a
	sCh9qI7tmz4qJHyb/x9AL80SqaTq1Yw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-yqvKJ2UFOv2X1QEldbdVZw-1; Mon, 08 May 2023 14:10:17 -0400
X-MC-Unique: yqvKJ2UFOv2X1QEldbdVZw-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7577727a00eso573001285a.1
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 11:10:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683569417; x=1686161417;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xgNVzoHB5qPigrpPQ7go/TrIsJOwIwgQ8Ks/ppylKsI=;
        b=gzn9oe2Dp97F89JdotV44O8wGbhfHYpG72PeEYiOe17wX3ZRBy5bOquVB7D6Xd3cNs
         tp3jJDeqAsVzLJH3K7nvoa+XMX0NpoJuPrNefoVbs3cZ5SHP1kuA25IG8VtXTCV9VV/i
         KcxX7PfIyctZXqvndLDlUQRJ3Rrqdf/aF5WsGk9N9WqSuj0YulkLlS3+7rKqHlLDbbfj
         SvefX8AeLdMwM2/9xuLpzURRrpIn9mMPkCkxRnPkmZp+mqtn0ANvt5ebcYo8RW7PU4cE
         9c0CwWkHgPi98UDxVY4JLJjCyJ9NM7OgVsavPUmH09KDw7L04wXWKJqjsDOMTJs98Prt
         jVbA==
X-Gm-Message-State: AC+VfDwwms991avK/ZdT/IBkaO91BZdGG0sk5Y9ortBy30VRcqaQxCCz
	TAJpVFtpKLY8Md8hXPcXnOeYnXTbqmSA+XKkgh/QizReGMgvj5qmvA5Q4LZoa/Hj9QkF0WxwiPc
	0mVVeUHdGNEp9h2ho
X-Received: by 2002:ad4:5f0c:0:b0:5ef:5503:d41c with SMTP id fo12-20020ad45f0c000000b005ef5503d41cmr25153927qvb.15.1683569417206;
        Mon, 08 May 2023 11:10:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Lq7OZAVzmXVCW5f4cqHto6UaJGOJ1GoX0WMEjEVCmLq6SBVcEwpI3XStDPAy8HaCpKxsqmg==
X-Received: by 2002:ad4:5f0c:0:b0:5ef:5503:d41c with SMTP id fo12-20020ad45f0c000000b005ef5503d41cmr25153902qvb.15.1683569416907;
        Mon, 08 May 2023 11:10:16 -0700 (PDT)
Received: from redhat.com ([185.187.243.116])
        by smtp.gmail.com with ESMTPSA id w10-20020a0ce10a000000b006039f5a247esm151943qvk.78.2023.05.08.11.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 11:10:15 -0700 (PDT)
Date: Mon, 8 May 2023 14:10:07 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>, huangml@yusur.tech,
	zy@yusur.tech, Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"open list:VIRTIO CORE AND NET DRIVERS" <virtualization@lists.linux-foundation.org>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	Hao Chen <chenh@yusur.tech>, hengqi@linux.alibaba.com
Subject: Re: [PATCH] virtio_net: set default mtu to 1500 when 'Device maximum
 MTU' bigger than 1500
Message-ID: <20230508140640-mutt-send-email-mst@kernel.org>
References: <1683341417.0965195-4-xuanzhuo@linux.alibaba.com>
 <07b6b325-9a15-222f-e618-d149b57cbac2@yusur.tech>
 <20230507045627-mutt-send-email-mst@kernel.org>
 <1683511319.099806-2-xuanzhuo@linux.alibaba.com>
 <20230508020953-mutt-send-email-mst@kernel.org>
 <1683526688.7492425-1-xuanzhuo@linux.alibaba.com>
 <20230508024147-mutt-send-email-mst@kernel.org>
 <1683531716.238961-1-xuanzhuo@linux.alibaba.com>
 <20230508062928-mutt-send-email-mst@kernel.org>
 <20230508092548.5fc8f078@hermes.local>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508092548.5fc8f078@hermes.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 09:25:48AM -0700, Stephen Hemminger wrote:
> On Mon, 8 May 2023 06:30:07 -0400
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > > > > I don't know, in any scenario, when the hardware supports a large mtu, but we do
> > > > > not want the user to use it by default.  
> > > >
> > > > When other devices on the same LAN have mtu set to 1500 and
> > > > won't accept bigger packets.  
> > > 
> > > So, that depends on pmtu/tcp-probe-mtu.
> > > 
> > > If the os without pmtu/tcp-probe-mtu has a bigger mtu, then it's big packet
> > > will lost.
> > > 
> > > Thanks.
> > >   
> > 
> > pmtu is designed for routing. LAN is supposed to be configured with
> > a consistent MTU.
> 
> Virtio is often used with bridging or macvlan which can't support PMTU.
> PMTU only works when forwarding at layer 3 (ie routing) where there is
> a IP address to send the ICMP response. If doing L2 forwarding, the
> only thin the bridge can do is drop the packet.
> 
> TCP cab recover but detecting an MTU blackhole requires retransmissions.

Exactly. That's why we basically use the MTU advice supplied by device
by default - it's designed for use-cases of software devices where
the device might have more information about the MTU than the guest.
If hardware devices want e.g. a way to communicate support for
jumbo frames without communicating any information about the LAN,
a new feature will be needed.

-- 
MST


