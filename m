Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7375EF8D
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 01:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfGCXNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 19:13:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:54942 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfGCXNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 19:13:14 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hioQv-0007XS-EI; Thu, 04 Jul 2019 01:13:01 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hioQv-000FfC-8k; Thu, 04 Jul 2019 01:13:01 +0200
Subject: Re: pull-request: bpf-next 2019-07-03
To:     Saeed Mahameed <saeedm@dev.mellanox.co.il>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        bpf@vger.kernel.org
References: <20190703224740.15354-1-daniel@iogearbox.net>
 <CALzJLG9vsv3A=SAGA97_HUZxdCr7gAMET8yTWofD6Wsq_7sCuA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <95cfea78-964c-d6bb-cf94-ac888b17c1e5@iogearbox.net>
Date:   Thu, 4 Jul 2019 01:13:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CALzJLG9vsv3A=SAGA97_HUZxdCr7gAMET8yTWofD6Wsq_7sCuA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25499/Wed Jul  3 10:03:10 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/04/2019 01:11 AM, Saeed Mahameed wrote:
> On Wed, Jul 3, 2019 at 3:47 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> Hi David,
>>
>> The following pull-request contains BPF updates for your *net-next* tree.
>>
>> There is a minor merge conflict in mlx5 due to 8960b38932be ("linux/dim:
>> Rename externally used net_dim members") which has been pulled into your
>> tree in the meantime, but resolution seems not that bad ... getting current
>> bpf-next out now before there's coming more on mlx5. ;) I'm Cc'ing Saeed
>> just so he's aware of the resolution below:
>>
>> ** First conflict in drivers/net/ethernet/mellanox/mlx5/core/en_main.c:
>>
>>   <<<<<<< HEAD
>>   static int mlx5e_open_cq(struct mlx5e_channel *c,
>>                            struct dim_cq_moder moder,
>>                            struct mlx5e_cq_param *param,
>>                            struct mlx5e_cq *cq)
>>   =======
>>   int mlx5e_open_cq(struct mlx5e_channel *c, struct net_dim_cq_moder moder,
>>                     struct mlx5e_cq_param *param, struct mlx5e_cq *cq)
>>   >>>>>>> e5a3e259ef239f443951d401db10db7d426c9497
>>
>> Resolution is to take the second chunk and rename net_dim_cq_moder into
>> dim_cq_moder. Also the signature for mlx5e_open_cq() in ...
>>
>>   drivers/net/ethernet/mellanox/mlx5/core/en.h +977
>>
>> ... and in mlx5e_open_xsk() ...
>>
>>   drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c +64
>>
>> ... needs the same rename from net_dim_cq_moder into dim_cq_moder.
>>
>> ** Second conflict in drivers/net/ethernet/mellanox/mlx5/core/en_main.c:
>>
>>   <<<<<<< HEAD
>>           int cpu = cpumask_first(mlx5_comp_irq_get_affinity_mask(priv->mdev, ix));
>>           struct dim_cq_moder icocq_moder = {0, 0};
>>           struct net_device *netdev = priv->netdev;
>>           struct mlx5e_channel *c;
>>           unsigned int irq;
>>   =======
>>           struct net_dim_cq_moder icocq_moder = {0, 0};
>>   >>>>>>> e5a3e259ef239f443951d401db10db7d426c9497
>>
>> Take the second chunk and rename net_dim_cq_moder into dim_cq_moder
>> as well.
>>
> 
> Thank you Daniel, Looks Good,
> I didn't test this since i am traveling, will double check tomorrow.
> but basically all you need is to pass the build.

That was definitely the case for me, thanks!
