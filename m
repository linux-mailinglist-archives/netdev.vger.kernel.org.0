Return-Path: <netdev+bounces-1460-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 859816FDD33
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:55:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6960E1C20D03
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01AAE12B61;
	Wed, 10 May 2023 11:54:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA68F20B58;
	Wed, 10 May 2023 11:54:57 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB3030F4;
	Wed, 10 May 2023 04:54:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Usz6mtHTTIbaXQ5UYQGsmQqdmuqQgPv/AWz/ljr1R7EibBm9fkogL6c0mPOFguVHQC8t47QgKLEJsJHLx99t8KVkFd0xFrRyJAV8Iksis3ryD5Ve9uyW8w6ib+YQnVhGiDRfOhpXc4LM7ghaUKGebEiskwEkfQJ5wGlgsHMCSNMWNuLZMvg8WdtR2m1b+3UFu7LJQvslstb2a7pfT+qCbmO1cQx4g9ld2Mz7R2+zWvPAu2ApxIYvmd86OMca+DkqRKhHDdazowMAzI4eZA6b9j2psYN1/nETNgrA4tfEE0f0ZaQf+GENV2MCOzPRPxyDgv+dz/IiTr0DUe2WrbV7DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=24YTFnAawxJmC8TNFkdBYfeoT+QrdwGEaf6CrOD04j8=;
 b=VaGx2NhipLbFjDSh6fUzQftveuaFoAmdrFZYdO3aDn2dqZCFvwSBFoQ2gB8hhsZp7lL9ej140Y/2WfC4b4ZwcnsVmVF2Uzr6bWSJCJTFCwzyscHcktby5x4bpeTW+EIVG6YGNb2jQAVJ4IEPk2trgYwhuhFBcA5JoVF2Y89h5xG+FpYzMcUAJ6uzPzUvxsHt4UfnmaLl4I6EDYyFZ3Ye5/umQesm9B6mVUDUxdcZ3k800NFM7uXmZxu1OScAkc7OfWvgWo2FEfhMRb4+wcmUE+UNX9rmueJbogm85tIR7qLNpBzbgkw2ZHJZkXYFYCtaLMX0kZssHbNN9BqY1UKauw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24YTFnAawxJmC8TNFkdBYfeoT+QrdwGEaf6CrOD04j8=;
 b=EuTW4/fEyKxz2nWCbbL9GTvtsvXTP5CWV+0mKRBwKZQccaAglZS3TLhdKla32rFD72wO+lHH98DYnsBg9uc4iDx61B6YlUC8qAuMZ9gasFDf68k6ZCbT5f2eR8o8fTi5ANReqdOFAtWaqyJgxj7825eLGxkIIOAYYxlURa4k/A6UtcRkIiuMYBGjUtX7nWWqS8fdzset07/OsEy7bz5F1fklzSG66ER3MjutMVHF1UdUwqtGg5Ge5gTanQ9XkcugVNMfCm3f0qDuhIgxjw6exdUEP6IA/Gk2iEFTxdEkUwxl674c6akRUmyFyRrRi4Mkg8LC4F4L2fnZ3rjsvE6rRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6201.namprd12.prod.outlook.com (2603:10b6:930:26::16)
 by DM6PR12MB4419.namprd12.prod.outlook.com (2603:10b6:5:2aa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 11:54:52 +0000
Received: from CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::a7a3:1d9d:1fa:5136]) by CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::a7a3:1d9d:1fa:5136%6]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 11:54:52 +0000
Message-ID: <17f9d4ef-9493-3fcd-65ff-beb92f99f854@nvidia.com>
Date: Wed, 10 May 2023 07:54:49 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH net v3] virtio_net: Fix error unwinding of XDP
 initialization
To: Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>,
 Simon Horman <simon.horman@corigine.com>, Bodong Wang <bodong@nvidia.com>,
 William Tu <witu@nvidia.com>, Parav Pandit <parav@nvidia.com>,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20230503003525.48590-1-feliu@nvidia.com>
 <1683340417.612963-3-xuanzhuo@linux.alibaba.com>
 <559ad341-2278-5fad-6805-c7f632e9894e@nvidia.com>
 <1683510351.569717-1-xuanzhuo@linux.alibaba.com>
 <c2c2bfed-bdf1-f517-559c-f51c9ca1807a@nvidia.com>
 <1683596602.483001-1-xuanzhuo@linux.alibaba.com>
 <a13a2d3f-e76e-b6a6-3d30-d5534e2fa917@redhat.com>
From: Feng Liu <feliu@nvidia.com>
In-Reply-To: <a13a2d3f-e76e-b6a6-3d30-d5534e2fa917@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0029.namprd11.prod.outlook.com
 (2603:10b6:806:d3::34) To CY5PR12MB6201.namprd12.prod.outlook.com
 (2603:10b6:930:26::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6201:EE_|DM6PR12MB4419:EE_
X-MS-Office365-Filtering-Correlation-Id: 9abe5c1d-240e-453e-4d87-08db514d5d50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Kn48QLzNiDu4trRAF6XG7SBe+EPYfdKKJDf1YIA9jqL5Y0V6qAEcTK/gKgdRI2Yj2IjW2vnKTMDRuxJCYC6sLERRIXbEwoZuwA4h47dHVXueeorKfNbbjiELlDmsucPuCV7N/KXi5CFJsaXiRvLRgHvfJyhXACyM8XtJl18DdQEJM4aduvULKGOZjZgOMHFE4Qh2+CNwhyiiQoZbxVMeQnYSL1g/KjhCp43Xkxy7XUWUnQpQft+R8bk8xQo644mmhsaulGqePCxlgezWE0ej2qhH7xQsB/0HaHUZnig4oT3u4RnHeIQv2QEARPpbLK/xelCLObU8Qg5q1xKJhc5mZC6rWM94aBMBCXlpH0p9IYpUoy3A/YcP76SKZ4WkP+NGSArWiCXg/NfInkarmN86TG8S37cKloZ1tdtElaEe7Dxz5DEEPQh0ONYV4eZvwln88TKtqdLibrtqlhkTg9pKivecT75ej88fCrGUtxZ2ikdcktPqvTV27KNFttv8zYfsLU7s36d+aq8Vxz4GdgqmZ74ECvabUFOyzWI2PI9jOHxhu8/mcPg3HCnMsP7j1jGqbhNwBFKVLKgmfMTjILxB3enGCMGnoGRkEGnXHUzcVeIKbxoKk62CD6kP1/rXXoB2yz0vqo760yu2y/Ol0FA20w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(451199021)(2906002)(31686004)(41300700001)(8676002)(316002)(8936002)(478600001)(66476007)(5660300002)(54906003)(4326008)(110136005)(6666004)(66556008)(66946007)(6486002)(6512007)(6506007)(26005)(186003)(2616005)(36756003)(83380400001)(38100700002)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TkRvVzAwTURwZ2dyTURVMmZ4Rmg5em5uVmFEMHBpT2Q0TiszY0tmRWErVEpR?=
 =?utf-8?B?UG80RkZNVm9lc0IyUGFwczJhY3dTWVI5dHE0eXpHMGpmM2gvcTE4U093UFo0?=
 =?utf-8?B?VGNsSTYva25WbWpDL3U4ckpnQ1VLeS93d2NJdlNEcU1zL09WNzNVQVlSYmI2?=
 =?utf-8?B?M2U4ME95bGcwQW4vbFNicEdIQW5iNGJweS8yYmhxa1JHSnZWdnY1YkU5TGEy?=
 =?utf-8?B?TGpnYjZOSVVMRG1JN2xBQWpLMjkxaVRUTnBIMndSQ2t0SXFpSlVaQnBaN1Ns?=
 =?utf-8?B?RDdJYXF0VGVQbkIxWVMvWHdiRkswZFdIS21SMXY0UVJYQ0R0dlV3Q1hyQVBG?=
 =?utf-8?B?SFBlbVJJWU1oS1F4ZFY5REQyUUd4eElrUHRLdlZpenBmZjJNeEc2YWFvdmdw?=
 =?utf-8?B?bjRZQU9WMVVZbVZwcVpjV3JicXRvRFBpV09SN3lqVUpTcko5VHBNbTlMckFW?=
 =?utf-8?B?aFo1WkpKZzhYSlFLcWJEdkQxaE9DWVY5VElCM2hkN0NyTWNQcmxhOVQyRER2?=
 =?utf-8?B?Uzl6OXFxZVlpSm9XbE42VGNWRmlENkxQSFpGS2ZmOURQalhLVGV0Qkg2Unhs?=
 =?utf-8?B?U2hQQmRJc0ZOU0lhTmtrdHBHRVFELyttNkF5SUl4NUZzUHpXQ1pyYS9CRjI4?=
 =?utf-8?B?RXNJLytnZEp0cWNlYjVHVEhIYWdCZVlRQTR3TTVDTUxXcUVVRXRhOXp6NU5U?=
 =?utf-8?B?cEFMZkxYT3Z4alJOSGZId1RFMkwyOUtNdlF5ZWcwR3c1Y1VjbVlib0lwbVZ0?=
 =?utf-8?B?blpyczNjUzJkY1NFMWJ0RUVMbHF0OEgwTkdlNUVwRXNScTAxcWlqZXlTREUr?=
 =?utf-8?B?OHdhRlNPLzJ6dDdpQ0VRQVhNazFsTFg3d1NqNFhSNkI4amdnZnZWb3RKcFFQ?=
 =?utf-8?B?WVJZSmRDZXlEVkNZOEFpb2NPaEEwanU2YmJneEkrTTlsNU1FNkJUbm5LSEQ0?=
 =?utf-8?B?TWpYRUdVdkJCZTBiOTZoazVQWS9IZ1N4bHZIVFlWWjI1dnk4OU5tVzlIVG9B?=
 =?utf-8?B?OHpQVXQ1SVoxaFZsS1dBeG9ESlFZV3FNMm9HTVZaT3doTnRnakJQc29tcHNZ?=
 =?utf-8?B?N2lWZk5zOUFZcTVCZnYrdW91S2gzN2tkN2hLNExBQTlhdnNkdTlyYXFjZG13?=
 =?utf-8?B?WElQRlF2aWVtU2RHUy9WOFV4QjN0eVJTMDgzcXBzdWF3TG1Jdk05OC83VU8v?=
 =?utf-8?B?MFpGYWJOMERlQUZJOHhGSGJQUm9DSFFvY1lxMER1QmM5eHROdFdIRDlrK1I2?=
 =?utf-8?B?ZnFrWFNnak9lL3hqVTkzRXFmM3J0dWppVm5YN0kvU0dkazdZR1FZTUl5SldW?=
 =?utf-8?B?OU5WZFRxeGdwL010MS84M1J3Rng4RFJ0Q0lVUUdSRzRudTk2aUFrTURhTHJo?=
 =?utf-8?B?K0VXbDFWNzdQODZMVkVmdy9LT2RHb3BsN3VtbVU3MWt4NSszMkZyZ2NmaENM?=
 =?utf-8?B?VHBLdFl6YWl0dDdxZHlMSGtwbWtJaWxhekM4Ty9MV0s1RWF2K0pDZWgzV2Nh?=
 =?utf-8?B?RWpRNlE4RUhXV3dBU2ZQMCs1RExpQWowdjhUZzRIbFc3cEVjV3R3bXVXUkxO?=
 =?utf-8?B?T29xMXowK0JEMnZxbmdYMDFLd3hzSjBxaTNVUnlFTW5zOGdQUXoxenVnQ3FN?=
 =?utf-8?B?WnNZZjVtQVJtbjAwTS80THZML1pMT0V4S3JRUWJxOERwSW1wbTN2MndQRzY1?=
 =?utf-8?B?RjcyL3g2V3RrL1RJblp0c1ZUVjRLQ3NDa2R0TUVKZzBPV24yNUkwbWl1dlFv?=
 =?utf-8?B?Wmk1V0ZCeTRyZjVjbFc2VjhjbGxNNCt5SGlraTZLVlJjak1Yb3ZKT2NlL2dU?=
 =?utf-8?B?YVh2Z3dvM0VxbFNTeGJOZWFzam5oQnptdXpuZ05XdU82U29jcjFldGplNjlp?=
 =?utf-8?B?MHFpdWpOWHFQU2JxcWFBRGwvWmZiVDVka2FsQ3lSeWMzYnFtRE1IMWljdzdr?=
 =?utf-8?B?Z2RINldIaU5VRm9xdW5CeTFJL01ERWpNSW5zZ1FLN01LZmltejBNL29nektJ?=
 =?utf-8?B?dHd2dWR1eU1GZmpESVpPMllHSCtGWUpycG5vRktMdE1CT2hURTJsdXJuTXMz?=
 =?utf-8?B?T3k2a0lGY1RuQVVxYXpxakRaK1hSRTVZUWFBSmZ3Q3AzU2poVVBJakFwbFlN?=
 =?utf-8?Q?bTrwbCCHvzckWYn3MIz6IGhGY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9abe5c1d-240e-453e-4d87-08db514d5d50
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 11:54:52.4656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n6dC4+Vq6IABLEHx4go4shDcshEupPOPgkMaq2dD+haG4Kgwthm6ORTxgJA/Dx7OOpK3yxcWTzu7u0dVjaSi9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4419
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023-05-10 a.m.1:00, Jason Wang wrote:
> External email: Use caution opening links or attachments
> 
> 
> 在 2023/5/9 09:43, Xuan Zhuo 写道:
>> On Mon, 8 May 2023 11:00:10 -0400, Feng Liu <feliu@nvidia.com> wrote:
>>>
>>> On 2023-05-07 p.m.9:45, Xuan Zhuo wrote:
>>>> External email: Use caution opening links or attachments
>>>>
>>>>
>>>> On Sat, 6 May 2023 08:08:02 -0400, Feng Liu <feliu@nvidia.com> wrote:
>>>>>
>>>>> On 2023-05-05 p.m.10:33, Xuan Zhuo wrote:
>>>>>> External email: Use caution opening links or attachments
>>>>>>
>>>>>>
>>>>>> On Tue, 2 May 2023 20:35:25 -0400, Feng Liu <feliu@nvidia.com> wrote:
>>>>>>> When initializing XDP in virtnet_open(), some rq xdp initialization
>>>>>>> may hit an error causing net device open failed. However, previous
>>>>>>> rqs have already initialized XDP and enabled NAPI, which is not the
>>>>>>> expected behavior. Need to roll back the previous rq initialization
>>>>>>> to avoid leaks in error unwinding of init code.
>>>>>>>
>>>>>>> Also extract a helper function of disable queue pairs, and use newly
>>>>>>> introduced helper function in error unwinding and virtnet_close;
>>>>>>>
>>>>>>> Issue: 3383038
>>>>>>> Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
>>>>>>> Signed-off-by: Feng Liu <feliu@nvidia.com>
>>>>>>> Reviewed-by: William Tu <witu@nvidia.com>
>>>>>>> Reviewed-by: Parav Pandit <parav@nvidia.com>
>>>>>>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>>>>>>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>>>>>>> Change-Id: Ib4c6a97cb7b837cfa484c593dd43a435c47ea68f
>>>>>>> ---
>>>>>>>     drivers/net/virtio_net.c | 30 ++++++++++++++++++++----------
>>>>>>>     1 file changed, 20 insertions(+), 10 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>>>>> index 8d8038538fc4..3737cf120cb7 100644
>>>>>>> --- a/drivers/net/virtio_net.c
>>>>>>> +++ b/drivers/net/virtio_net.c
>>>>>>> @@ -1868,6 +1868,13 @@ static int virtnet_poll(struct napi_struct 
>>>>>>> *napi, int budget)
>>>>>>>          return received;
>>>>>>>     }
>>>>>>>
>>>>>>> +static void virtnet_disable_qp(struct virtnet_info *vi, int 
>>>>>>> qp_index)
>>>>>>> +{
>>>>>>> +     virtnet_napi_tx_disable(&vi->sq[qp_index].napi);
>>>>>>> +     napi_disable(&vi->rq[qp_index].napi);
>>>>>>> +     xdp_rxq_info_unreg(&vi->rq[qp_index].xdp_rxq);
>>>>>>> +}
>>>>>>> +
>>>>>>>     static int virtnet_open(struct net_device *dev)
>>>>>>>     {
>>>>>>>          struct virtnet_info *vi = netdev_priv(dev);
>>>>>>> @@ -1883,20 +1890,26 @@ static int virtnet_open(struct net_device 
>>>>>>> *dev)
>>>>>>>
>>>>>>>                  err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, 
>>>>>>> i, vi->rq[i].napi.napi_id);
>>>>>>>                  if (err < 0)
>>>>>>> -                     return err;
>>>>>>> +                     goto err_xdp_info_reg;
>>>>>>>
>>>>>>>                  err = 
>>>>>>> xdp_rxq_info_reg_mem_model(&vi->rq[i].xdp_rxq,
>>>>>>>                                                   
>>>>>>> MEM_TYPE_PAGE_SHARED, NULL);
>>>>>>> -             if (err < 0) {
>>>>>>> -                     xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
>>>>>>> -                     return err;
>>>>>>> -             }
>>>>>>> +             if (err < 0)
>>>>>>> +                     goto err_xdp_reg_mem_model;
>>>>>>>
>>>>>>>                  virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
>>>>>>>                  virtnet_napi_tx_enable(vi, vi->sq[i].vq, 
>>>>>>> &vi->sq[i].napi);
>>>>>>>          }
>>>>>>>
>>>>>>>          return 0;
>>>>>>> +
>>>>>>> +err_xdp_reg_mem_model:
>>>>>>> +     xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
>>>>>>> +err_xdp_info_reg:
>>>>>>> +     for (i = i - 1; i >= 0; i--)
>>>>>>> +             virtnet_disable_qp(vi, i);
>>>>>>
>>>>>> I would to know should we handle for these:
>>>>>>
>>>>>>            disable_delayed_refill(vi);
>>>>>>            cancel_delayed_work_sync(&vi->refill);
>>>>>>
>>>>>>
>>>>>> Maybe we should call virtnet_close() with "i" directly.
>>>>>>
>>>>>> Thanks.
>>>>>>
>>>>>>
>>>>> Can’t use i directly here, because if xdp_rxq_info_reg fails, napi has
>>>>> not been enabled for current qp yet, I should roll back from the queue
>>>>> pairs where napi was enabled before(i--), otherwise it will hang at 
>>>>> napi
>>>>> disable api
>>>> This is not the point, the key is whether we should handle with:
>>>>
>>>>             disable_delayed_refill(vi);
>>>>             cancel_delayed_work_sync(&vi->refill);
>>>>
>>>> Thanks.
>>>>
>>>>
>>> OK, get the point. Thanks for your careful review. And I check the code
>>> again.
>>>
>>> There are two points that I need to explain:
>>>
>>> 1. All refill delay work calls(vi->refill, vi->refill_enabled) are based
>>> on that the virtio interface is successfully opened, such as
>>> virtnet_receive, virtnet_rx_resize, _virtnet_set_queues, etc. If there
>>> is an error in the xdp reg here, it will not trigger these subsequent
>>> functions. There is no need to call disable_delayed_refill() and
>>> cancel_delayed_work_sync().
>> Maybe something is wrong. I think these lines may call delay work.
>>
>> static int virtnet_open(struct net_device *dev)
>> {
>>       struct virtnet_info *vi = netdev_priv(dev);
>>       int i, err;
>>
>>       enable_delayed_refill(vi);
>>
>>       for (i = 0; i < vi->max_queue_pairs; i++) {
>>               if (i < vi->curr_queue_pairs)
>>                       /* Make sure we have some buffers: if oom use 
>> wq. */
>> -->                   if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
>> -->                           schedule_delayed_work(&vi->refill, 0);
>>
>>               err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i, 
>> vi->rq[i].napi.napi_id);
>>               if (err < 0)
>>                       return err;
>>
>>               err = xdp_rxq_info_reg_mem_model(&vi->rq[i].xdp_rxq,
>>                                                MEM_TYPE_PAGE_SHARED, 
>> NULL);
>>               if (err < 0) {
>>                       xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
>>                       return err;
>>               }
>>
>>               virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
>>               virtnet_napi_tx_enable(vi, vi->sq[i].vq, &vi->sq[i].napi);
>>       }
>>
>>       return 0;
>> }
>>
>>
>> And I think, if we virtnet_open() return error, then the status of 
>> virtnet
>> should like the status after virtnet_close().
>>
>> Or someone has other opinion.
> 
> 
> I agree, we need to disable and sync with the refill work.
> 
> Thanks
> 
> 
OK，got it.
Thanks Jason & Xuan
>>
>> Thanks.
>>
>>> The logic here is different from that of
>>> virtnet_close. virtnet_close is based on the success of virtnet_open and
>>> the tx and rx has been carried out normally. For error unwinding, only
>>> disable qp is needed. Also encapuslated a helper function of disable qp,
>>> which is used ing error unwinding and virtnet close
>>> 2. The current error qp, which has not enabled NAPI, can only call xdp
>>> unreg, and cannot call the interface of disable NAPI, otherwise the
>>> kernel will be stuck. So for i-- the reason for calling disable qp on
>>> the previous queue
>>>
>>> Thanks
>>>
>>>>>>> +
>>>>>>> +     return err;
>>>>>>>     }
>>>>>>>
>>>>>>>     static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>>>>>>> @@ -2305,11 +2318,8 @@ static int virtnet_close(struct net_device 
>>>>>>> *dev)
>>>>>>>          /* Make sure refill_work doesn't re-enable napi! */
>>>>>>>          cancel_delayed_work_sync(&vi->refill);
>>>>>>>
>>>>>>> -     for (i = 0; i < vi->max_queue_pairs; i++) {
>>>>>>> -             virtnet_napi_tx_disable(&vi->sq[i].napi);
>>>>>>> -             napi_disable(&vi->rq[i].napi);
>>>>>>> -             xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
>>>>>>> -     }
>>>>>>> +     for (i = 0; i < vi->max_queue_pairs; i++)
>>>>>>> +             virtnet_disable_qp(vi, i);
>>>>>>>
>>>>>>>          return 0;
>>>>>>>     }
>>>>>>> -- 
>>>>>>> 2.37.1 (Apple Git-137.1)
>>>>>>>
> 

