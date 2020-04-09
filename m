Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC6E31A31C9
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 11:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgDIJdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 05:33:47 -0400
Received: from mail-db8eur05on2071.outbound.protection.outlook.com ([40.107.20.71]:6167
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726561AbgDIJdq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 05:33:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qxs90vYbQDV8kKFA3cSRLPYRCCeMr0S91BUUMLrsa/haUYRBQZeM0r7ppq4NNELOEkTTk+PD6gsTrikUCjeWY23w7otRvQAiMF+NTIoEZ7IVDKOeyHKUhSRt+nm1SwXRqk2zWW9U84/3NPYL48+00IcXvHeYr5DgldJh1knlu/EvQYZ0zMxen2HRva9Km1Kvls9B2km/3ImwPIdYCvWB2OOPOE5Wog2waMN1i+iLc6fK7si2ecLX2u5rwQnXq/RBppHqolVgA28z5jcH+sKbpGR4ivj5xpj0hqjgRkAGUGyXHbAWA/eM9WSZCcOoO/MKP2GPYzav81kJ22OWQiRxVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/O1vZwEiRoNobvRsR1qziTH42kCuWGQZQoW2AXibCI=;
 b=eMk4U3UkRmYNbpc+zY91+V1oocxFDtvUn4LjrFQS9yE1YScY7gSo3yIPn7nHDYruYxQ1Y2M0ObaXu5/GGLB1+Q76Y9wKmN4/xoJZeA/qinaUVvT4mSshOwwTNEpcaseDT1VsWv38rWEfrpZjL4NFqU54zgBc1cpLIfFZVMSp2EzKpdKp2fTMTLKjcnvSwrIDyKQXVS8N251KJPFOeKYnz7PfNstJYX8YUzQnXVUPFmRmUQMikpK6F8YCgzDE0+zxQfUHBBEYU6suZ++rIwfkj/B+JhJ+btgf+zX+zq2KgCAvbkiqxOXDFUQwnrbCNh5BedmdpkMZbx+yME6Xs8Fyzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/O1vZwEiRoNobvRsR1qziTH42kCuWGQZQoW2AXibCI=;
 b=Rb4lV4dfUdpJZxWg12x8mE2L63Y2hX3iphx72NLmkZfcZXqNNlCnuzL0/JKveEtrOg5rQTBIucSuefonT3lwt5nB8tnFIMu0KXq6VWTNTl6hZE1GsexmYQ+yeilQJ85UaJR8Dd/SyKQ4KZ/NvpjEYstl805tg9P9/xrmYTV2df8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
Received: from HE1PR0501MB2570.eurprd05.prod.outlook.com (2603:10a6:3:6c::17)
 by HE1PR0501MB2395.eurprd05.prod.outlook.com (2603:10a6:3:71::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17; Thu, 9 Apr
 2020 09:33:41 +0000
Received: from HE1PR0501MB2570.eurprd05.prod.outlook.com
 ([fe80::60c4:f0b4:dc7b:c7fc]) by HE1PR0501MB2570.eurprd05.prod.outlook.com
 ([fe80::60c4:f0b4:dc7b:c7fc%10]) with mapi id 15.20.2878.021; Thu, 9 Apr 2020
 09:33:41 +0000
Subject: Re: [PATCH RFC v2 28/33] xdp: for Intel AF_XDP drivers add XDP
 frame_sz
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        sameehj@amazon.com
Cc:     intel-wired-lan@lists.osuosl.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
 <158634677661.707275.17823370564281193008.stgit@firesoul>
 <55b6684d-9097-e2c1-c939-bf3273bd70f6@intel.com>
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <efb24e4f-610e-5793-dde4-76b42ebca826@mellanox.com>
Date:   Thu, 9 Apr 2020 12:33:37 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <55b6684d-9097-e2c1-c939-bf3273bd70f6@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM6PR10CA0099.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::40) To HE1PR0501MB2570.eurprd05.prod.outlook.com
 (2603:10a6:3:6c::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.57.1.235] (159.224.90.213) by AM6PR10CA0099.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17 via Frontend Transport; Thu, 9 Apr 2020 09:33:39 +0000
X-Originating-IP: [159.224.90.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 351300be-296c-4f83-de05-08d7dc6916df
X-MS-TrafficTypeDiagnostic: HE1PR0501MB2395:|HE1PR0501MB2395:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0501MB239599B5032E58ACC5D2C825D1C10@HE1PR0501MB2395.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0368E78B5B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0501MB2570.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(52116002)(86362001)(54906003)(107886003)(66574012)(7416002)(4326008)(316002)(81166007)(66476007)(16576012)(66946007)(31686004)(31696002)(55236004)(8676002)(6486002)(53546011)(110136005)(66556008)(5660300002)(81156014)(8936002)(186003)(956004)(16526019)(2616005)(478600001)(36756003)(2906002)(26005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qR7MKsbM/qVy3k1SrbuD867c31zkGjCg9yLUN2dVQ7Ig4/s1YC7MiaUYIZkgzdH8a8dW88Qdk4Ncm2uPMniHN3G/ncB+X19+DKgUEvVVVeNMCY2c8xY2DeFbPpDBVDLVZ0/+d42K2t575dvlo1pIWmWTou5SW9sP3MhIUDM9KQ8e2HtLnIXH/YS52svfdKlAbC9im6CJKDGuErNUWkyBKZenmtEy986xLjYuP8bEr158ucDANkeGJnRTaQ9k4ouon8okKQ1z4uWzBUBm5Xa9SsTeNJ/cUAxG65YOO8IBoni4wbT6tP+8jBbsJLzQGFrsWBjBokpilMjDFvCzVzqjtte+wKgBCp5e1H04bJ4EtjOgrjtQeJ5ngfjd4Fv0cHAnoL1TrlpWSb6xgCWkUhE1FC1LoXhxrgv8yAk4P/RMMZ7bjFPWKA4/Pm4a8f8YH4Et
X-MS-Exchange-AntiSpam-MessageData: sAmVyDafSvrzjkDutOttLmOaq2hyBT92ET84IR0B3iMM8bBq44pPPLsv2x4KS5hYf3xk5RtjDiITBoBTxD2bvXsvaJniVmWgeR56V4Dibtz4+jG7EkL+kelOtFvuWVzqmt1hrYD+KFv1XQkD/khlnA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 351300be-296c-4f83-de05-08d7dc6916df
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2020 09:33:41.0960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tXn7b+g1BcykjYGhNnuFyemlIx7pspByCHe7HOMplbmo2IAItOv2uOiOrI02RR0Tne2Ku3mKvZJZdVCsXTtZlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2395
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-08 20:31, Björn Töpel wrote:
> On 2020-04-08 13:52, Jesper Dangaard Brouer wrote:
>> Intel drivers implement native AF_XDP zerocopy in separate C-files,
>> that have its own invocation of bpf_prog_run_xdp(). The setup of
>> xdp_buff is also handled in separately from normal code path.
>>
>> This patch update XDP frame_sz for AF_XDP zerocopy drivers i40e, ice
>> and ixgbe, as the code changes needed are very similar.  Introduce a
>> helper function xsk_umem_xdp_frame_sz() for calculating frame size.
>>
>> Cc: intel-wired-lan@lists.osuosl.org
>> Cc: Björn Töpel <bjorn.topel@intel.com>
>> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> Thanks for the patch, Jesper! Note that mlx5 has AF_XDP support as well,
> and might need similar changes. Adding Max for input!

Thanks for drawing my attention to this series, Björn! I commented 
regarding frame_sz calculation under the mlx5 patch (17/33).

> For the Intel drivers, and core AF_XDP:
> Acked-by: Björn Töpel <bjorn.topel@intel.com>
> 
>> ---
>>   drivers/net/ethernet/intel/i40e/i40e_xsk.c   |    2 ++
>>   drivers/net/ethernet/intel/ice/ice_xsk.c     |    2 ++
>>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c |    2 ++
>>   include/net/xdp_sock.h                       |   11 +++++++++++
>>   4 files changed, 17 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c 
>> b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>> index 0b7d29192b2c..2b9184aead5f 100644
>> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>> @@ -531,12 +531,14 @@ int i40e_clean_rx_irq_zc(struct i40e_ring 
>> *rx_ring, int budget)
>>   {
>>       unsigned int total_rx_bytes = 0, total_rx_packets = 0;
>>       u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
>> +    struct xdp_umem *umem = rx_ring->xsk_umem;
>>       unsigned int xdp_res, xdp_xmit = 0;
>>       bool failure = false;
>>       struct sk_buff *skb;
>>       struct xdp_buff xdp;
>>       xdp.rxq = &rx_ring->xdp_rxq;
>> +    xdp.frame_sz = xsk_umem_xdp_frame_sz(umem);
>>       while (likely(total_rx_packets < (unsigned int)budget)) {
>>           struct i40e_rx_buffer *bi;
>> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c 
>> b/drivers/net/ethernet/intel/ice/ice_xsk.c
>> index 8279db15e870..23e5515d4527 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
>> @@ -840,11 +840,13 @@ int ice_clean_rx_irq_zc(struct ice_ring 
>> *rx_ring, int budget)
>>   {
>>       unsigned int total_rx_bytes = 0, total_rx_packets = 0;
>>       u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
>> +    struct xdp_umem *umem = rx_ring->xsk_umem;
>>       unsigned int xdp_xmit = 0;
>>       bool failure = false;
>>       struct xdp_buff xdp;
>>       xdp.rxq = &rx_ring->xdp_rxq;
>> +    xdp.frame_sz = xsk_umem_xdp_frame_sz(umem);
>>       while (likely(total_rx_packets < (unsigned int)budget)) {
>>           union ice_32b_rx_flex_desc *rx_desc;
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c 
>> b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> index 74b540ebb3dc..a656ee9a1fae 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> @@ -431,12 +431,14 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector 
>> *q_vector,
>>       unsigned int total_rx_bytes = 0, total_rx_packets = 0;
>>       struct ixgbe_adapter *adapter = q_vector->adapter;
>>       u16 cleaned_count = ixgbe_desc_unused(rx_ring);
>> +    struct xdp_umem *umem = rx_ring->xsk_umem;
>>       unsigned int xdp_res, xdp_xmit = 0;
>>       bool failure = false;
>>       struct sk_buff *skb;
>>       struct xdp_buff xdp;
>>       xdp.rxq = &rx_ring->xdp_rxq;
>> +    xdp.frame_sz = xsk_umem_xdp_frame_sz(umem);
>>       while (likely(total_rx_packets < budget)) {
>>           union ixgbe_adv_rx_desc *rx_desc;
>> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
>> index e86ec48ef627..1cd1ec3cea97 100644
>> --- a/include/net/xdp_sock.h
>> +++ b/include/net/xdp_sock.h
>> @@ -237,6 +237,12 @@ static inline u64 xsk_umem_adjust_offset(struct 
>> xdp_umem *umem, u64 address,
>>       else
>>           return address + offset;
>>   }
>> +
>> +static inline u32 xsk_umem_xdp_frame_sz(struct xdp_umem *umem)
>> +{
>> +    return umem->chunk_size_nohr + umem->headroom;
>> +}
>> +

This new function may be used in mlx5 for mlx5e_build_xsk_param.

>>   #else
>>   static inline int xsk_generic_rcv(struct xdp_sock *xs, struct 
>> xdp_buff *xdp)
>>   {
>> @@ -367,6 +373,11 @@ static inline u64 xsk_umem_adjust_offset(struct 
>> xdp_umem *umem, u64 handle,
>>       return 0;
>>   }
>> +static inline u32 xsk_umem_xdp_frame_sz(struct xdp_umem *umem)
>> +{
>> +    return 0;
>> +}
>> +
>>   static inline int __xsk_map_redirect(struct xdp_sock *xs, struct 
>> xdp_buff *xdp)
>>   {
>>       return -EOPNOTSUPP;
>>
>>

