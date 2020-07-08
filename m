Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB8C218AA2
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbgGHPAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:00:54 -0400
Received: from mail-vi1eur05on2079.outbound.protection.outlook.com ([40.107.21.79]:6226
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730050AbgGHPAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 11:00:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g4OFEPMDMQhsydJUB2q36hJzzYPLs6R7kx0ilJ53SZvCaVqnNjHjngsjFBgNLtpeKlRTnHHf33iA6RLPUR6LW+rHA3HPxaA/TJfVLZLJ8GhAWtxQn1bI0Gx1XxmgLVy9no8wQ0L2sKx46hBQMoW/ef4PKfGebhrEzKvtkeo14dhNzsKsqDcXKdgodlE3NR53ESG5bJAiFWcSinjFotk31xy92hFXwE+iH4EqWaLkoGgO0yt5gAJZ+nW/3qi2zYYld/SqEHprc2ZBVRIr5zcswSMXyUDMjrLWWQpNdA1z382bkTA4l8EV4dn9LMky1W18lnENgKZD+B41mEEMp8/CxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eEd1ixA1SfdQp5UgDTyausyaZU0mNIevFQVIotNFpIs=;
 b=N2auKLD+SPjNJuNB+vqhtwG09JhkHnWuNvHb4r8XUp9Q6PBUL0qZEtz6IUL3YcTiyUjESQz4BRmwRa95oQKe9c9SMvjtgtHjkMjq5qmjmfH9M490G1nUES+b4bfIvGxPWOr4FUJLqiEx30cZtUCFmPJeHnjttlz7B6/UrTyr/rHblB2MkE1OYuYpfyK9O5JqXHqGkm/2mulD4pszvD8kM1oH6Fj1gwsphVfsxoAa3pL5njXH4PJgA5vP+VQqln0jUbve+J0k4pSpnkkCWQzVRWtplUSYq6DkvrmQhxDe2VqR+noT4Y0tgsuHs9gouE9sG/VMGdaWIdv+Kh40jyyzrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eEd1ixA1SfdQp5UgDTyausyaZU0mNIevFQVIotNFpIs=;
 b=UZI/gdkJiZj5wEI4eRisMzwVcYh2RoMf5AnluOlKuQBtE4FbANTN+Gb1dMVRxh7BCNVVKWALVPVQbIz605Cgyh4aV01UwWvFdmB2Nrx4RWuUfQuakaIILxmx3T/PliZoBblRLvDfl07CNDmIvPyiplI2NnCdnfJ9j8ozGrvk9dc=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR05MB5365.eurprd05.prod.outlook.com (2603:10a6:20b:3c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Wed, 8 Jul
 2020 15:00:47 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2%7]) with mapi id 15.20.3153.029; Wed, 8 Jul 2020
 15:00:47 +0000
Subject: Re: [PATCH bpf-next 00/14] xsk: support shared umems between devices
 and queues
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
References: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <5cf948fe-be1c-a639-2c58-377ef31d28fa@mellanox.com>
Date:   Wed, 8 Jul 2020 18:00:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR08CA0006.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::19) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.44.1.235] (37.57.128.233) by AM0PR08CA0006.eurprd08.prod.outlook.com (2603:10a6:208:d2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Wed, 8 Jul 2020 15:00:46 +0000
X-Originating-IP: [37.57.128.233]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dea28e08-da0e-4c7f-be99-08d8234fb24b
X-MS-TrafficTypeDiagnostic: AM6PR05MB5365:
X-Microsoft-Antispam-PRVS: <AM6PR05MB536501A4DF0F52CB6C656D4AD1670@AM6PR05MB5365.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5jbbolEVLX+QEIUWqvdol8rRthxzJKJTkQuLFMkEFH8l3WGIDEWOT1Lb+nz9u6dVRLiMmww6NnNkcB7sDLN6JrGGa1ydA/wQjTAc06NblaYkMZZqfEvYN/mWU0b90JXpy33QO+s3RuNwan4TKvrZZA6RWpZ9dH7xbJuFod8GgO/VFq/69NBc3/k2wXv9YqHnIIfmhXHS+nKCU22ggUfrownjETnw+15Uc2S6TFBbLAOpQU4FiL2F1iU5PUuZF81Z0Ib8p9T0KLOLyntDdYmTua1vcHSRrKEtRytffji8LZ2uM18Y2v1XnyZ3goko1sqLBJ++/nwNccGhfqxoJ5IhqhNrJoGh7ix/mIP8YlX7XoIvw2z0fMvf8Dy17jAq8YN4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(5660300002)(16526019)(26005)(7416002)(6916009)(478600001)(31696002)(86362001)(956004)(186003)(4326008)(316002)(16576012)(66946007)(31686004)(66476007)(66556008)(2906002)(83380400001)(30864003)(36756003)(55236004)(2616005)(53546011)(8936002)(6486002)(52116002)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ftFxIy+zAFUuhT4URtcIULheUbtZ7vLshQglS4WswkDaJxGJGw9keq31WM4rAzK1GvEIIjI+aPF3bibH9T3ly5uTuzodl9DykPFc+gkWA6QWa8RRLxPd4Su5FPyZVJQdhAsxHWjKj3hZFcOw+aTlm797jbSdsY+knn2F/EFpjtzKvbSm/Io/UtucV5QmaTZFFekqazbJ8uksCEnEf+5l+ERsU0l9RWT+3lKKZ30kGz0ct3WGIFILkm6pcviyRPBv5hCPHoflPlBoCNXxzI0viYfMKVFIU+TRC/m0xQK54lYbBR5h5UINzpKGhCjCwtlo9iIo/FJBuyxX/PJ+3IquGrJp9hEyshNgAJucDOFFHQZ/Hjt42/EB1kIn0NH5sBwzhbE+XPOkMSNSpfRMttoyerTnnxpH/rnvz9EL2g2tjEu+OYLXV/6InLcSCoTBPTwOY4r1KwL7VOTK14at9NvY0fJCfSuEdMC5TASxVfbKwvc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dea28e08-da0e-4c7f-be99-08d8234fb24b
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 15:00:47.5351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GFxViLhERrfBo8iwPAYX2RfvBZDHx6VRocT1N7yRCk63o+CNxhMjoC95ajA34gGitA+6chPeKHa1k4Z1M2Ow9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5365
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-02 15:18, Magnus Karlsson wrote:
> This patch set adds support to share a umem between AF_XDP sockets
> bound to different queue ids on the same device or even between
> devices. It has already been possible to do this by registering the
> umem multiple times, but this wastes a lot of memory. Just imagine
> having 10 threads each having 10 sockets open sharing a single
> umem. This means that you would have to register the umem 100 times
> consuming large quantities of memory.

Just to clarify: the main memory savings are achieved, because we don't 
need to store an array of pages in struct xdp_umem multiple times, right?

I guess there is one more drawback of sharing a UMEM the old way 
(register it multiple times): it would map (DMA) the same pages multiple 
times.

> Instead, we extend the existing XDP_SHARED_UMEM flag to also work when
> sharing a umem between different queue ids as well as devices. If you
> would like to share umem between two sockets, just create the first
> one as would do normally. For the second socket you would not register
> the same umem using the XDP_UMEM_REG setsockopt. Instead attach one
> new fill ring and one new completion ring to this second socket and
> then use the XDP_SHARED_UMEM bind flag supplying the file descriptor of
> the first socket in the sxdp_shared_umem_fd field to signify that it
> is the umem of the first socket you would like to share.
> 
> One important thing to note in this example, is that there needs to be
> one fill ring and one completion ring per unique device and queue id
> bound to. This so that the single-producer and single-consumer semantics
> of the rings can be upheld. To recap, if you bind multiple sockets to
> the same device and queue id (already supported without this patch
> set), you only need one pair of fill and completion rings. If you bind
> multiple sockets to multiple different queues or devices, you need one
> fill and completion ring pair per unique device,queue_id tuple.
> 
> The implementation is based around extending the buffer pool in the
> core xsk code. This is a structure that exists on a per unique device
> and queue id basis. So, a number of entities that can now be shared
> are moved from the umem to the buffer pool. Information about DMA
> mappings are also moved from the buffer pool, but as these are per
> device independent of the queue id, they are now hanging off the
> netdev.

Basically, you want to map a pair of (netdev, UMEM) to DMA info. The 
current implementation of xp_find_dma_map stores a list of UMEMs in the 
netdev and goes over that list to find the corresponding DMA info. It 
would be more effective to do it vice-versa, i.e. to store the list of 
netdevs inside of a UMEM, because you normally have fewer netdevs in the 
system than sockets, and you'll have fewer list items to traverse. Of 
course, it has no effect on the data path, but it will improve the time 
to open a socket (i.e. connection rate).

> In summary after this patch set, there is one xdp_sock struct
> per socket created. This points to an xsk_buff_pool for which there is
> one per unique device and queue id. The buffer pool points to a DMA
> mapping structure for which there is one per device that a umem has
> been bound to. And finally, the buffer pool also points to a xdp_umem
> struct, for which there is only one per umem registration.
> 
> Before:
> 
> XSK -> UMEM -> POOL
> 
> Now:
> 
> XSK -> POOL -> DMA
>              \
> 	     > UMEM
> 
> Patches 1-8 only rearrange internal structures to support the buffer
> pool carrying this new information, while patch 9 improves performance
> as we now have rearrange the internal structures quite a bit. Finally,
> patches 10-14 introduce the new functionality together with libbpf
> support, samples, and documentation.
> 
> Libbpf has also been extended to support sharing of umems between
> sockets bound to different devices and queue ids by introducing a new
> function called xsk_socket__create_shared(). The difference between
> this and the existing xsk_socket__create() is that the former takes a
> reference to a fill ring and a completion ring as these need to be
> created. This new function needs to be used for the second and
> following sockets that binds to the same umem. The first one can be
> created by either function as it will also have called
> xsk_umem__create().
> 
> There is also a new sample xsk_fwd that demonstrates this new
> interface and capability.
> 
> Note to Maxim at Mellanox. I do not have a mlx5 card, so I have not
> been able to test the changes to your driver. It compiles, but that is
> all I can say, so it would be great if you could test it. Also, I did
> change the name of many functions and variables from umem to pool as a
> buffer pool is passed down to the driver in this patch set instead of
> the umem. I did not change the name of the files umem.c and
> umem.h. Please go through the changes and change things to your
> liking.

I looked through the mlx5 patches, and I see the changes are minor, and 
most importantly, the functionality is not broken (tested with xdpsock). 
I would still like to make some cosmetic amendments - I'll send you an 
updated patch.

> Performance for the non-shared umem case is unchanged for the xdpsock
> sample application with this patch set.

I also tested it on mlx5 (ConnectX-5 Ex), and the performance hasn't 
been hurt.

> For workloads that share a
> umem, this patch set can give rise to added performance benefits due
> to the decrease in memory usage.
> 
> This patch has been applied against commit 91f77560e473 ("Merge branch 'test_progs-improvements'")
> 
> Structure of the patch set:
> 
> Patch 1: Pass the buffer pool to the driver instead of the umem. This
>           because the driver needs one buffer pool per napi context
>           when we later introduce sharing of the umem between queue ids
>           and devices.
> Patch 2: Rename the xsk driver interface so they have better names
>           after the move to the buffer pool
> Patch 3: There is one buffer pool per device and queue, while there is
>           only one umem per registration. The buffer pool needs to be
>           created and destroyed independently of the umem.
> Patch 4: Move fill and completion rings to the buffer pool as there will
>           be one set of these per device and queue
> Patch 5: Move queue_id, dev and need_wakeup to buffer pool again as these
>           will now be per buffer pool as the umem can be shared between
>           devices and queues
> Patch 6: Move xsk_tx_list and its lock to buffer pool
> Patch 7: Move the creation/deletion of addrs from buffer pool to umem
> Patch 8: Enable sharing of DMA mappings when multiple queues of the
>           same device are bound
> Patch 9: Rearrange internal structs for better performance as these
>           have been substantially scrambled by the previous patches
> Patch 10: Add shared umem support between queue ids
> Patch 11: Add shared umem support between devices
> Patch 12: Add support for this in libbpf
> Patch 13: Add a new sample that demonstrates this new feature by
>            forwarding packets between different netdevs and queues
> Patch 14: Add documentation
> 
> Thanks: Magnus
> 
> Cristian Dumitrescu (1):
>    samples/bpf: add new sample xsk_fwd.c
> 
> Magnus Karlsson (13):
>    xsk: i40e: ice: ixgbe: mlx5: pass buffer pool to driver instead of
>      umem
>    xsk: i40e: ice: ixgbe: mlx5: rename xsk zero-copy driver interfaces
>    xsk: create and free context independently from umem
>    xsk: move fill and completion rings to buffer pool
>    xsk: move queue_id, dev and need_wakeup to context
>    xsk: move xsk_tx_list and its lock to buffer pool
>    xsk: move addrs from buffer pool to umem
>    xsk: net: enable sharing of dma mappings
>    xsk: rearrange internal structs for better performance
>    xsk: add shared umem support between queue ids
>    xsk: add shared umem support between devices
>    libbpf: support shared umems between queues and devices
>    xsk: documentation for XDP_SHARED_UMEM between queues and netdevs
> 
>   Documentation/networking/af_xdp.rst                |   68 +-
>   drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |    2 +-
>   drivers/net/ethernet/intel/i40e/i40e_main.c        |   29 +-
>   drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   10 +-
>   drivers/net/ethernet/intel/i40e/i40e_txrx.h        |    2 +-
>   drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   79 +-
>   drivers/net/ethernet/intel/i40e/i40e_xsk.h         |    4 +-
>   drivers/net/ethernet/intel/ice/ice.h               |   18 +-
>   drivers/net/ethernet/intel/ice/ice_base.c          |   16 +-
>   drivers/net/ethernet/intel/ice/ice_lib.c           |    2 +-
>   drivers/net/ethernet/intel/ice/ice_main.c          |   10 +-
>   drivers/net/ethernet/intel/ice/ice_txrx.c          |    8 +-
>   drivers/net/ethernet/intel/ice/ice_txrx.h          |    2 +-
>   drivers/net/ethernet/intel/ice/ice_xsk.c           |  142 +--
>   drivers/net/ethernet/intel/ice/ice_xsk.h           |    7 +-
>   drivers/net/ethernet/intel/ixgbe/ixgbe.h           |    2 +-
>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   34 +-
>   .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |    7 +-
>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   61 +-
>   drivers/net/ethernet/mellanox/mlx5/core/en.h       |   19 +-
>   drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |    5 +-
>   .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |   10 +-
>   .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   12 +-
>   .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.h |    2 +-
>   .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   12 +-
>   .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.h    |    6 +-
>   .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.c  |  108 +-
>   .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.h  |   14 +-
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   46 +-
>   drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   16 +-
>   include/linux/netdevice.h                          |   13 +-
>   include/net/xdp_sock.h                             |   28 +-
>   include/net/xdp_sock_drv.h                         |  115 ++-
>   include/net/xsk_buff_pool.h                        |   47 +-
>   net/core/dev.c                                     |    3 +
>   net/ethtool/channels.c                             |    2 +-
>   net/ethtool/ioctl.c                                |    2 +-
>   net/xdp/xdp_umem.c                                 |  221 +---
>   net/xdp/xdp_umem.h                                 |    6 -
>   net/xdp/xsk.c                                      |  213 ++--
>   net/xdp/xsk.h                                      |    3 +
>   net/xdp/xsk_buff_pool.c                            |  314 +++++-
>   net/xdp/xsk_diag.c                                 |   14 +-
>   net/xdp/xsk_queue.h                                |   12 +-
>   samples/bpf/Makefile                               |    3 +
>   samples/bpf/xsk_fwd.c                              | 1075 ++++++++++++++++++++
>   tools/lib/bpf/libbpf.map                           |    1 +
>   tools/lib/bpf/xsk.c                                |  376 ++++---
>   tools/lib/bpf/xsk.h                                |    9 +
>   49 files changed, 2327 insertions(+), 883 deletions(-)
>   create mode 100644 samples/bpf/xsk_fwd.c
> 
> --
> 2.7.4
> 

