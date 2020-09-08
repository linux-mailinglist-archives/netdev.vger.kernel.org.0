Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3972B260E3C
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 10:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgIHI7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 04:59:41 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17145 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgIHI7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 04:59:40 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5747ee0000>; Tue, 08 Sep 2020 01:59:26 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 08 Sep 2020 01:59:40 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 08 Sep 2020 01:59:40 -0700
Received: from [172.27.14.146] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 8 Sep
 2020 08:59:30 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [net-next 04/10] net/mlx5e: Unify constants for
 WQE_EMPTY_DS_COUNT
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
References: <20200903210022.22774-1-saeedm@nvidia.com>
 <20200903210022.22774-5-saeedm@nvidia.com>
 <CA+FuTSczxJXJuRDKRrMHpQdqjCJLhbujhrzAQZkS=0GO6oJ7ww@mail.gmail.com>
Message-ID: <250f08af-b02b-f88b-85c7-12ab6d66c874@nvidia.com>
Date:   Tue, 8 Sep 2020 11:59:26 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSczxJXJuRDKRrMHpQdqjCJLhbujhrzAQZkS=0GO6oJ7ww@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599555566; bh=bXr5G2exfK/fjE+7EuwX81cQBUEURP6+P5/Hkuxc82s=;
        h=X-PGP-Universal:From:Subject:To:CC:References:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=ne5tFxJTJJWisQwP6xAmvarB9ULMfjH+eqlGQlfxq/1Oos3LBgHcylMXU5FBv083e
         cMU0RDPLFY9rXJvSlVJN+039aBeI8GZGrqWVCjT+UQYjx1GyaAHpKbXwAP4EAeSgEs
         0O3NvysRMUYw79xVTqBag10GHLYIvCScbtbqQ1UKv2vHLNunSaH0IySUt4VZd4BHAT
         JxGqUQmeRmk6X/KwmbfC4IVAY08h63ynSSSp7hl/et0rl7wnGftGVuKAB1C7QRcjqS
         NLTNZ/XEjPIbU5N/Do620VqIL9ccId++wudv43AlhCtuJHuEkGvYkiUi889JECEndX
         PWQS9vQhnX7Aw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-04 18:05, Willem de Bruijn wrote:
> On Thu, Sep 3, 2020 at 11:01 PM Saeed Mahameed <saeedm@nvidia.com> wrote:
>>
>> From: Maxim Mikityanskiy <maximmi@mellanox.com>
>>
>> A constant for the number of DS in an empty WQE (i.e. a WQE without data
>> segments) is needed in multiple places (normal TX data path, MPWQE in
>> XDP), but currently we have a constant for XDP and an inline formula in
>> normal TX. This patch introduces a common constant.
>>
>> Additionally, mlx5e_xdp_mpwqe_session_start is converted to use struct
>> assignment, because the code nearby is touched.
>>
>> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
>> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>> ---
>>   .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  2 ++
>>   .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 13 +++++++-----
>>   .../net/ethernet/mellanox/mlx5/core/en/xdp.h  | 21 +++++++------------
>>   .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  2 +-
>>   4 files changed, 19 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
>> index d4ee22789ab0..155b89998891 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
>> @@ -7,6 +7,8 @@
>>   #include "en.h"
>>   #include <linux/indirect_call_wrapper.h>
>>
>> +#define MLX5E_TX_WQE_EMPTY_DS_COUNT (sizeof(struct mlx5e_tx_wqe) / MLX5_SEND_WQE_DS)
>> +
> 
> Out of curiosity, what is the logic for dividing this struct by 16?

The hardware needs the size of a WQE in DS units (16 bytes). An empty 
WQE takes 2 DS (for the ctrl and eth segments), and this macro is this 
initial size of an empty WQE (2 DS). As data segments are added to the 
WQE, it grows, and its size in DS also grows.

> struct mlx5e_tx_wqe {
>          struct mlx5_wqe_ctrl_seg ctrl;
>          struct mlx5_wqe_eth_seg  eth;
>          struct mlx5_wqe_data_seg data[0];
> };
> 
>>   #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline_hdr.start))
>>
>>   enum mlx5e_icosq_wqe_type {
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
>> index 7fccd2ea7dc9..81cd9a04bcb0 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
>> @@ -196,16 +196,19 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_xdpsq *sq)
>>   {
>>          struct mlx5e_xdp_mpwqe *session = &sq->mpwqe;
>>          struct mlx5e_xdpsq_stats *stats = sq->stats;
>> +       struct mlx5e_tx_wqe *wqe;
>>          u16 pi;
>>
>>          pi = mlx5e_xdpsq_get_next_pi(sq, MLX5E_XDP_MPW_MAX_WQEBBS);
>> -       session->wqe = MLX5E_TX_FETCH_WQE(sq, pi);
>> -
>> +       wqe = MLX5E_TX_FETCH_WQE(sq, pi);
>>          net_prefetchw(session->wqe->data);
> 
> Is this prefetch still valid?

It should be:

net_prefetchw(wqe->data);

Probably a bad rebase.

> And is the temporary variable wqe still
> needed at all?

We want to prefetch as early as possible (before filling *session).

> 
>> -       session->ds_count  = MLX5E_XDP_TX_EMPTY_DS_COUNT;
>> -       session->pkt_count = 0;
>>
>> -       mlx5e_xdp_update_inline_state(sq);
>> +       *session = (struct mlx5e_xdp_mpwqe) {
>> +               .wqe = wqe,
>> +               .ds_count = MLX5E_TX_WQE_EMPTY_DS_COUNT,
>> +               .pkt_count = 0,
>> +               .inline_on = mlx5e_xdp_get_inline_state(sq, session->inline_on),
>> +       };
>>
>>          stats->mpwqe++;
>>   }

