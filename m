Return-Path: <netdev+bounces-7826-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60F60721BD7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 04:13:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B56272810E9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 02:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E03B038D;
	Mon,  5 Jun 2023 02:12:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC30E19B;
	Mon,  5 Jun 2023 02:12:57 +0000 (UTC)
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A893B1;
	Sun,  4 Jun 2023 19:12:54 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VkIJNup_1685931170;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VkIJNup_1685931170)
          by smtp.aliyun-inc.com;
          Mon, 05 Jun 2023 10:12:51 +0800
Message-ID: <1685931044.5893385-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v10 10/10] virtio_net: support dma premapped
Date: Mon, 5 Jun 2023 10:10:44 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: virtualization@lists.linux-foundation.org,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>,
 Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John  Fastabend <john.fastabend@gmail.com>,
 netdev@vger.kernel.org,
 bpf@vger.kernel.org
References: <20230602092206.50108-1-xuanzhuo@linux.alibaba.com>
 <20230602092206.50108-11-xuanzhuo@linux.alibaba.com>
 <20230602233152.4d9b9ba4@kernel.org>
In-Reply-To: <20230602233152.4d9b9ba4@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

On Fri, 2 Jun 2023 23:31:52 -0700, Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri,  2 Jun 2023 17:22:06 +0800 Xuan Zhuo wrote:
> >  drivers/net/virtio_net.c | 163 +++++++++++++++++++++++++++++++++------
>
> ack for this going via the vhost tree, FWIW, but you'll potentially
> need to wait for the merge window to move forward with the actual
> af xdp patches, in this case.


My current plan is to let virtio support premapped dma first, and then implement
virtio-net to support af-xdp zerocopy.

This will indeed involve two branches. But most of the implementations in this
patch are virtio code, so I think it would be more appropriate to commit to
vhost. Do you have any good ideas?


Thanks.

