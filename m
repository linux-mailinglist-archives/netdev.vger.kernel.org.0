Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D279F558D44
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 04:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiFXClO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 22:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiFXClM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 22:41:12 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE50F563AE;
        Thu, 23 Jun 2022 19:41:10 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VHErnnD_1656038467;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VHErnnD_1656038467)
          by smtp.aliyun-inc.com;
          Fri, 24 Jun 2022 10:41:07 +0800
Message-ID: <1656038444.6413577-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net] net: fix IFF_TX_SKB_NO_LINEAR definition
Date:   Fri, 24 Jun 2022 10:40:44 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
References: <YrRrcGttfEVnf85Q@kili>
In-Reply-To: <YrRrcGttfEVnf85Q@kili>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jun 2022 16:32:32 +0300, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> The "1<<31" shift has a sign extension bug so IFF_TX_SKB_NO_LINEAR is
> 0xffffffff80000000 instead of 0x0000000080000000.
>
> Fixes: c2ff53d8049f ("net: Add priv_flags for allow tx skb without linear")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Thanks.

> ---
> Before IFF_CHANGE_PROTO_DOWN was added then this issue was not so bad.
>
>  include/linux/netdevice.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 89afa4f7747d..1a3cb93c3dcc 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1671,7 +1671,7 @@ enum netdev_priv_flags {
>  	IFF_FAILOVER_SLAVE		= 1<<28,
>  	IFF_L3MDEV_RX_HANDLER		= 1<<29,
>  	IFF_LIVE_RENAME_OK		= 1<<30,
> -	IFF_TX_SKB_NO_LINEAR		= 1<<31,
> +	IFF_TX_SKB_NO_LINEAR		= BIT_ULL(31),
>  	IFF_CHANGE_PROTO_DOWN		= BIT_ULL(32),
>  };
>
> --
> 2.35.1
>
