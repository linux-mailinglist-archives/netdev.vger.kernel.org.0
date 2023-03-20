Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435626C0B42
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 08:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjCTHSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 03:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjCTHSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 03:18:30 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B36F1EBD0;
        Mon, 20 Mar 2023 00:18:21 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VeDTvO2_1679296697;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VeDTvO2_1679296697)
          by smtp.aliyun-inc.com;
          Mon, 20 Mar 2023 15:18:17 +0800
Message-ID: <1679296680.3679774-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [RFC net-next 0/8] virtio_net: refactor xdp codes
Date:   Mon, 20 Mar 2023 15:18:00 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20230315041042.88138-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230315041042.88138-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 12:10:34 +0800, Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:

Ping

Thanks.


> Due to historical reasons, the implementation of XDP in virtio-net is relatively
> chaotic. For example, the processing of XDP actions has two copies of similar
> code. Such as page, xdp_page processing, etc.
>
> The purpose of this patch set is to refactor these code. Reduce the difficulty
> of subsequent maintenance. Subsequent developers will not introduce new bugs
> because of some complex logical relationships.
>
> In addition, the supporting to AF_XDP that I want to submit later will also need
> to reuse the logic of XDP, such as the processing of actions, I don't want to
> introduce a new similar code. In this way, I can reuse these codes in the
> future.
>
> This patches are developed on the top of another patch set[1]. I may have to
> wait to merge this. So this patch set is a RFC.
>
> Please review.
>
> Thanks.
>
> [1]. https://lore.kernel.org/netdev/20230315015223.89137-1-xuanzhuo@linux.alibaba.com/
>
>
> Xuan Zhuo (8):
>   virtio_net: mergeable xdp: put old page immediately
>   virtio_net: mergeable xdp: introduce mergeable_xdp_prepare
>   virtio_net: introduce virtnet_xdp_handler() to seprate the logic of
>     run xdp
>   virtio_net: separate the logic of freeing xdp shinfo
>   virtio_net: separate the logic of freeing the rest mergeable buf
>   virtio_net: auto release xdp shinfo
>   virtio_net: introduce receive_mergeable_xdp()
>   virtio_net: introduce receive_small_xdp()
>
>  drivers/net/virtio_net.c | 615 +++++++++++++++++++++++----------------
>  1 file changed, 357 insertions(+), 258 deletions(-)
>
> --
> 2.32.0.3.g01195cf9f
>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
