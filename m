Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED9C51E32B
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 03:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356392AbiEGBmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 21:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbiEGBmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 21:42:42 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C265D67E
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 18:38:57 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VCUAvP6_1651887533;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VCUAvP6_1651887533)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 07 May 2022 09:38:54 +0800
Message-ID: <1651887524.8548894-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next 5/6] net: virtio: switch to netif_napi_add_weight()
Date:   Sat, 7 May 2022 09:38:44 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        davem@davemloft.net
References: <20220506170751.822862-1-kuba@kernel.org>
 <20220506170751.822862-6-kuba@kernel.org>
In-Reply-To: <20220506170751.822862-6-kuba@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 May 2022 10:07:50 -0700, Jakub Kicinski <kuba@kernel.org> wrote:
> virtio netdev driver uses a custom napi weight, switch to the new
> API for setting custom weight.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

> ---
> CC: mst@redhat.com
> CC: jasowang@redhat.com
> CC: virtualization@lists.linux-foundation.org
> ---
>  drivers/net/virtio_net.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ebb98b796352..db05b5e930be 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3313,8 +3313,8 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
>  	INIT_DELAYED_WORK(&vi->refill, refill_work);
>  	for (i = 0; i < vi->max_queue_pairs; i++) {
>  		vi->rq[i].pages = NULL;
> -		netif_napi_add(vi->dev, &vi->rq[i].napi, virtnet_poll,
> -			       napi_weight);
> +		netif_napi_add_weight(vi->dev, &vi->rq[i].napi, virtnet_poll,
> +				      napi_weight);
>  		netif_napi_add_tx_weight(vi->dev, &vi->sq[i].napi,
>  					 virtnet_poll_tx,
>  					 napi_tx ? napi_weight : 0);
> --
> 2.34.1
>
