Return-Path: <netdev+bounces-1002-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F8EE6FBCCA
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 03:54:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5267F280AAF
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 01:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A13CC37F;
	Tue,  9 May 2023 01:54:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FD47C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 01:54:51 +0000 (UTC)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B773D2D2;
	Mon,  8 May 2023 18:54:30 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Vi8pzhn_1683597247;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vi8pzhn_1683597247)
          by smtp.aliyun-inc.com;
          Tue, 09 May 2023 09:54:08 +0800
Message-ID: <1683597099.3423615-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH] virtio_net: set default mtu to 1500 when 'Device maximum MTU' bigger than 1500
Date: Tue, 9 May 2023 09:51:39 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: huangml@yusur.tech,
 zy@yusur.tech,
 Jason Wang <jasowang@redhat.com>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 "open list:VIRTIO CORE AND NET DRIVERS" <virtualization@lists.linux-foundation.org>,
 "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>,
 Hao Chen <chenh@yusur.tech>,
 hengqi@linux.alibaba.com,
 Stephen Hemminger <stephen@networkplumber.org>
References: <20230506021529.396812-1-chenh@yusur.tech>
 <1683341417.0965195-4-xuanzhuo@linux.alibaba.com>
 <07b6b325-9a15-222f-e618-d149b57cbac2@yusur.tech>
 <20230507045627-mutt-send-email-mst@kernel.org>
 <1683511319.099806-2-xuanzhuo@linux.alibaba.com>
 <20230508020953-mutt-send-email-mst@kernel.org>
 <1683526688.7492425-1-xuanzhuo@linux.alibaba.com>
 <20230508024147-mutt-send-email-mst@kernel.org>
 <1683531716.238961-1-xuanzhuo@linux.alibaba.com>
 <20230508062928-mutt-send-email-mst@kernel.org>
 <20230508092548.5fc8f078@hermes.local>
 <20230508140640-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230508140640-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

On Mon, 8 May 2023 14:10:07 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Mon, May 08, 2023 at 09:25:48AM -0700, Stephen Hemminger wrote:
> > On Mon, 8 May 2023 06:30:07 -0400
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >
> > > > > > I don't know, in any scenario, when the hardware supports a large mtu, but we do
> > > > > > not want the user to use it by default.
> > > > >
> > > > > When other devices on the same LAN have mtu set to 1500 and
> > > > > won't accept bigger packets.
> > > >
> > > > So, that depends on pmtu/tcp-probe-mtu.
> > > >
> > > > If the os without pmtu/tcp-probe-mtu has a bigger mtu, then it's big packet
> > > > will lost.
> > > >
> > > > Thanks.
> > > >
> > >
> > > pmtu is designed for routing. LAN is supposed to be configured with
> > > a consistent MTU.
> >
> > Virtio is often used with bridging or macvlan which can't support PMTU.
> > PMTU only works when forwarding at layer 3 (ie routing) where there is
> > a IP address to send the ICMP response. If doing L2 forwarding, the
> > only thin the bridge can do is drop the packet.
> >
> > TCP cab recover but detecting an MTU blackhole requires retransmissions.
>
> Exactly. That's why we basically use the MTU advice supplied by device
> by default - it's designed for use-cases of software devices where
> the device might have more information about the MTU than the guest.
> If hardware devices want e.g. a way to communicate support for
> jumbo frames without communicating any information about the LAN,
> a new feature will be needed.


Let's think this question carefully. If necessary, we will try to introduce a
new feature for virtio-net spec to support Jumbo Frame.

Thanks.


>
> --
> MST
>

