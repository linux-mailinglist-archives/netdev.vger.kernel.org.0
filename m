Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A76F5ED26D
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 03:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiI1BGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 21:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbiI1BFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 21:05:52 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF8D71728
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 18:05:49 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4McdV44dMfzlXPL;
        Wed, 28 Sep 2022 09:01:16 +0800 (CST)
Received: from kwepemm600008.china.huawei.com (7.193.23.88) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 09:05:32 +0800
Received: from [10.174.176.230] (10.174.176.230) by
 kwepemm600008.china.huawei.com (7.193.23.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 09:05:31 +0800
Message-ID: <d45ccb47-1bd1-8078-04c1-81a6f5f5c062@huawei.com>
Date:   Wed, 28 Sep 2022 09:05:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH -next v2] nfp: Use skb_put_data() instead of
 skb_put/memcpy pair
To:     <simon.horman@corigine.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <niklas.soderlund@corigine.com>,
        <oss-drivers@corigine.com>, <netdev@vger.kernel.org>
References: <20220927141835.19221-1-shangxiaojing@huawei.com>
From:   shangxiaojing <shangxiaojing@huawei.com>
In-Reply-To: <20220927141835.19221-1-shangxiaojing@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.230]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600008.china.huawei.com (7.193.23.88)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/9/27 22:18, Shang XiaoJing wrote:
> Use skb_put_data() instead of skb_put() and memcpy(), which is clear.
> 
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
> changes in v2:
> - no change
> ---
>   drivers/net/ethernet/netronome/nfp/nfd3/xsk.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c b/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
> index 65e243168765..5d9db8c2a5b4 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
> @@ -84,7 +84,7 @@ static void nfp_nfd3_xsk_rx_skb(struct nfp_net_rx_ring *rx_ring,
>   		nfp_net_xsk_rx_drop(r_vec, xrxbuf);
>   		return;
>   	}
> -	memcpy(skb_put(skb, pkt_len), xrxbuf->xdp->data, pkt_len);
> +	skb_put_data(skb, xrxbuf->xdp->data, pkt_len);
>   
>   	skb->mark = meta->mark;
>   	skb_set_hash(skb, meta->hash, meta->hash_type);

forgot to add the reviewed tag, sorry.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

Thanks,
Shang XiaoJing
