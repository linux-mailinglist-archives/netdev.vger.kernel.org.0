Return-Path: <netdev+bounces-893-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 673716FB359
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 17:00:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 876841C209F7
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 15:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2ABD17F7;
	Mon,  8 May 2023 15:00:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A25F15BD;
	Mon,  8 May 2023 15:00:19 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AD12720;
	Mon,  8 May 2023 08:00:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3KepO+1e5+2VjDXFpbY0szQocZhtraS9ALDjcz28ve5FplwMil397EOJMw/S2zVJZ5kkg008QRmWxaM6cVukQwmGnQa6mCeoQ9ICsEmgBgqeTTPkBzIcKr2lvqCI9XH+gkAi+DiZakqdXcTZXwlQkb93Y6V6v/h7nCq7Cs7UtK4v1VI544a+EFXnTHbaNg2teOzxffg0rTFa0x7bIZPzRPdVZ3Xj115VyqqpizoILNDXhg8MOxw5DbVl6FF4J61lgLhu+0uUym1zWjVpTdIjT+BtmVUr8CoQwSLxdAWMP0zRSvO/1oE4nkri1q4AJw/o5FXLeMOFgzEQ60Ru+Uqjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ffok8hIsQW63zsYqbPR/sS5crKXEVo1At1D5Gg+QDY4=;
 b=UL41smXlYz/nqo0NH9lp2nj9gvVrc5zExrppmPEwIVV/Cr6G0HzTBz0zzxfriRj6APxjvZUn9sDN/3NYoh3j6HdmL1poLN4ln1lIdXPIhlbYB2jqgHgRKVIeEoFY/cPfI8x0DpsoZqp6aDYyH3GrHKQgw10U7Ifj2M9u0sRhvvk3tJLslwqaPebdh3NIlgAAMyWMlI7y5BESYzDPKEsoJpZDQY8Vp8VVW0Ap7laIh8TCHF1JH19TskgMvHmo/czwscYOHFkyPKJQqBUhWK0TxLnFWMzQHrNC+Bxc2GKFi2DMJLHSLQp/krYP5ImrREmp569Gf6+oPKRNOXTfkzTtqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffok8hIsQW63zsYqbPR/sS5crKXEVo1At1D5Gg+QDY4=;
 b=mPV53RzJwm79SvjBqfawv7QXhzD57cJ0KOHp9j9VN/PHOXPd+3HwBhe3F5riaKRR3MuJ+5XLxLyJixAoPFKbjTFVDEdnAP3407Mczq3RjgfDhZa7B+ZvjwjV64GjQ0czKiuxe1HxzCSl0/JApb/1+bguMy5CKMVJbkowO5sIrN1AcHTUOQQKud22cysdwKcEz2v3QuMoBS8ykf+2cml8mAGEXFdXLO0JwcP+5EJhhHiKQeWt+NoYJ0cvRhWmvQ2Ia1GwU7d4bKJSqHB2IRB35vYZWIOLnL8ViMkexc5SNI9wnGmFSa57OAFiYEHXWILY++OwnRiq582r1588U3vkJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6201.namprd12.prod.outlook.com (2603:10b6:930:26::16)
 by MN0PR12MB5788.namprd12.prod.outlook.com (2603:10b6:208:377::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 15:00:15 +0000
Received: from CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::a7a3:1d9d:1fa:5136]) by CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::a7a3:1d9d:1fa:5136%6]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 15:00:14 +0000
Message-ID: <c2c2bfed-bdf1-f517-559c-f51c9ca1807a@nvidia.com>
Date: Mon, 8 May 2023 11:00:10 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH net v3] virtio_net: Fix error unwinding of XDP
 initialization
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Jason Wang <jasowang@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Simon Horman <simon.horman@corigine.com>, Bodong Wang <bodong@nvidia.com>,
 William Tu <witu@nvidia.com>, Parav Pandit <parav@nvidia.com>,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20230503003525.48590-1-feliu@nvidia.com>
 <1683340417.612963-3-xuanzhuo@linux.alibaba.com>
 <559ad341-2278-5fad-6805-c7f632e9894e@nvidia.com>
 <1683510351.569717-1-xuanzhuo@linux.alibaba.com>
From: Feng Liu <feliu@nvidia.com>
In-Reply-To: <1683510351.569717-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0177.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::32) To CY5PR12MB6201.namprd12.prod.outlook.com
 (2603:10b6:930:26::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6201:EE_|MN0PR12MB5788:EE_
X-MS-Office365-Filtering-Correlation-Id: 9601a02a-732b-4660-dbff-08db4fd4edd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pAuyZ/rqrqhMx8DOtzU704LcZ4WZIq1jYRFHWtEs6B7qbTIbskHix2Ru58RwSuweIYVL2HWOylpvZqzhM8V9aXHZivRJOBn9VqwO4ekNXkrNbKukIPmsYidlZOzRJ9ZecinykipjgJbBmHLRGBeHoODZ2QC1ml2vLrz5czVnvAKZWL9oQ2V3Fm2galB/f/VfJXwSlczb2MQX1z71Mq68ntnhjcxl55Z2pqEIPR+jonbkJhyaaRDhZHejI94XVa1hO+bKD1Rv8dQcn3oIqRU3Tx2x7vyXenobceIjFvlq4/alemNC07+VQZCQ+QQ4BIbRqXWYdYV+wD+r2ViFAht0rK6/u/xdZ36OrOsOzUZItWly3jE5ZQvGJfQBycMJcmFOi0WomJpVgP6e6Hl9z1Kxe1XYKFkcNBOMDhcQJuIN4GLTpJXQWs5r+AOPlq2C4hbpZbio06DaLoR+mn1j5aNaZk1kKRDDT2Nx7Ra31PxWZT+QUMOHFpk82eOghoUSMdXgT5h0a5UGmWAI//GYfVQRy2sGWIubsaVB7uQ5B0ZV81GjyX+yzcgi1J9Uf/ngvLp9LeXrAqavayRpeAsMicnXcMUuvhgFl3iCGiz60n9SKLq5HQIbsWIbFoeyMjHf17hWS5gFYTkRWRhoYw3rkxJ7Ig==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199021)(83380400001)(2616005)(186003)(36756003)(38100700002)(31696002)(86362001)(2906002)(6486002)(8936002)(8676002)(316002)(6666004)(41300700001)(5660300002)(54906003)(31686004)(66946007)(6916009)(66556008)(4326008)(66476007)(478600001)(26005)(6506007)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0c3ZkhDV0IzU293QjRSR2lUMysxTEhkRDZJbThkUDFoZ1BsNVlHUmx0eER2?=
 =?utf-8?B?SWRBNWFOeFI2L2ViOXJ5S2FJM2VEeHdwZ1hIT1I3TlNMS1pEVTk4d010M0dx?=
 =?utf-8?B?bE9NdmpNYXA0Mk1qdHdhY1RhY1ZrNEczZFlIa0VlcXVwcFVWRk5UelpvRXBE?=
 =?utf-8?B?RGl4WmlkVk1aQTU5OElleXo5Q3ZmOWlrNllOK1QwTnd2aDFZMVVJRkFPRFdj?=
 =?utf-8?B?ZnFGVHE5b25UWHFoaFB6SDhHQzl1cHk4TmFoa3dobjkzYi9yd3VxNkp1Mnlr?=
 =?utf-8?B?WXNNdmxzcCtUK3BldVJMQzh1WTVIOTZ6QUNVY2p5Y1dMUkJML0Rsd1orc09E?=
 =?utf-8?B?Q09uL0ZzYTd3djBNNDlrcEt0MS9xOU5mQ3RCcjZnVm9nOWdQckJXaE5mVnh2?=
 =?utf-8?B?d3VyT3NXcFNqNGVMenRza3dyazVmYjc0Q0kzTlFzOFBycG1zZHp6NDBIY1U5?=
 =?utf-8?B?YXN3TjJVdjkwRC9zd3hqdnJhaE5PTXExQ0s3Mlh3MkpuY09tc3pSZ1RYY3dK?=
 =?utf-8?B?SXkvcFY3dTF5dGlFcnBFQlAvNm5rU1FkblRIWTZBblBzeUZ5MDlSZWJMaDJk?=
 =?utf-8?B?QVdpSjloU1RMWml3aS9SdlBFalVxbTJlM1hmWmw4cHRlMTNJOExZSC9zeStL?=
 =?utf-8?B?eDYzaHdNYlgyc295aHNrRkppMHpjVXBoeVR2by9XYW1LZzZTdlJJK1dxUTFq?=
 =?utf-8?B?SGZENUF2RzVCOFRVdlVzOUhFRG0vYWNRd3MzZEpFT1BObXZkNjlMeVBONTNh?=
 =?utf-8?B?Q1FsY1llRU9SUkNvK0gvczNDdHI4N2IyNDV4OENCQUFjWDlDbVJ6VGVVQWdM?=
 =?utf-8?B?YndDZ1E2ZWcwNWdsVW1CN044dFYrTDcyVUlQMlNIRjhkNVBLNkFrMTRaS2JW?=
 =?utf-8?B?SXA3VXE3RXd5aDVXR0JRRUdSZjIwS1JiWWQrYUxGZndnWmpwYStuRVA4SnpW?=
 =?utf-8?B?YXowMjhjalpHTm1BUFRXemhSVm1oNUtkZ1VMMU5PSVNKdHdvKzVkdEpmaVJN?=
 =?utf-8?B?a2c4bjRQT3hTTzBDMGVHbmRIR21HUlhZbFVEdXU3SmxlbGlZa3JQVW9iYVBx?=
 =?utf-8?B?WnJyK3Uwa3UxTnBpQ0ZFdUp1VU41SVduMkF1YjVRU3dPYlk4aW5jdlJFME9z?=
 =?utf-8?B?VVRtcEZ1elBYT1pWVXFnbms1c1RaV1JBQVFJRVhSMlV6U2lyVDF1M3NJLzZn?=
 =?utf-8?B?TFcxV0ZIdzZxYmZIQXdLaEVtcEg2ZGNyd0gzSGFNbkFkTkJmU3FqVklzZVpQ?=
 =?utf-8?B?Q3kxUGw5YWpSMXhCMENVam5Ga1FjV2t4OHhWaGMvci9VbG4yQSt4ZVo4YTBF?=
 =?utf-8?B?ekhxNEpSM3EzQ3ZTQTcvbnpVeXlsWWY4azJZd2NWUFdaSTljTEIvMlE5WVh4?=
 =?utf-8?B?QjFFN3NiNFJFYlZyRUhmb2VTUWpJYzlzV3l1ZjIwNk9rVUpDQmxiZC9TVmlE?=
 =?utf-8?B?U29xNEtTd0JiTER4YXpYUlN5VUQ3bEh4YlIxeWdZMDl6d1lRSnpHZWNhSnhK?=
 =?utf-8?B?TFdadWpqNlJ6Q3F6V3NrYm5PREI4cE9VRzA0TFFUY2xJSmdtVE5mR21ZWVBD?=
 =?utf-8?B?M2d6VG9Za2dWQmlMU1c3SVhtN2pDV0NyY2loaXdyOFphM214bmxTOXQ4eXNo?=
 =?utf-8?B?OXlVN0NCMFRaclZVeWEzS0dQQ1NZMnY5Qmw2dXhkYXhBdWVXVnd6anVrcnJO?=
 =?utf-8?B?VDVTM1BNN25tRW9ETnZadEN5bmRKaUU2anBibEhRVzRGUm4xaUJRRUliSi9K?=
 =?utf-8?B?NkNYRlNOUEt5TTBJSmYxai9RQ1dxMDVJS0NEekdLR2o5UnllTnUrdEd3NjRw?=
 =?utf-8?B?aXN3SENMNlBoUFNvODFsVUdFTmJaVTVvclhQNzlERzkveDBOZ0pJcGdpajBI?=
 =?utf-8?B?YktJNE9LSnA4WmlVM0t6Z2xLQ2lSTGZwb3J5eDIwSHVOTGZ4RFl0NFFUL2Fm?=
 =?utf-8?B?d1hkWGhaRUVQTklFMU9xSVlVSnNTQ1ZONzcrMlhHWURpdHcwcWpWZVQ5bHhL?=
 =?utf-8?B?NjRZeGxyMzZ0enBOYUVjOWhuWkZoZkFXVzlJTjN2UnZpV2VnTFFIMzZJTldi?=
 =?utf-8?B?YWdlMENROWU4SndBNzVvdTVKNk5lNnZid1JHQmZUcnN1OTU1clNWTEpuTHBn?=
 =?utf-8?Q?lhef6/GV9XMTXt1rphl+t61Hm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9601a02a-732b-4660-dbff-08db4fd4edd4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 15:00:14.6984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3zKaBRYj82nPSqdgz5nTBrTFN/U+KeZcOI3NqqHdpzD9YJjPvFK64bgsLo0OVxeCDQMy6R8R19qKsa7uWXVCvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5788
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023-05-07 p.m.9:45, Xuan Zhuo wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Sat, 6 May 2023 08:08:02 -0400, Feng Liu <feliu@nvidia.com> wrote:
>>
>>
>> On 2023-05-05 p.m.10:33, Xuan Zhuo wrote:
>>> External email: Use caution opening links or attachments
>>>
>>>
>>> On Tue, 2 May 2023 20:35:25 -0400, Feng Liu <feliu@nvidia.com> wrote:
>>>> When initializing XDP in virtnet_open(), some rq xdp initialization
>>>> may hit an error causing net device open failed. However, previous
>>>> rqs have already initialized XDP and enabled NAPI, which is not the
>>>> expected behavior. Need to roll back the previous rq initialization
>>>> to avoid leaks in error unwinding of init code.
>>>>
>>>> Also extract a helper function of disable queue pairs, and use newly
>>>> introduced helper function in error unwinding and virtnet_close;
>>>>
>>>> Issue: 3383038
>>>> Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
>>>> Signed-off-by: Feng Liu <feliu@nvidia.com>
>>>> Reviewed-by: William Tu <witu@nvidia.com>
>>>> Reviewed-by: Parav Pandit <parav@nvidia.com>
>>>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>>>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>>>> Change-Id: Ib4c6a97cb7b837cfa484c593dd43a435c47ea68f
>>>> ---
>>>>    drivers/net/virtio_net.c | 30 ++++++++++++++++++++----------
>>>>    1 file changed, 20 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>> index 8d8038538fc4..3737cf120cb7 100644
>>>> --- a/drivers/net/virtio_net.c
>>>> +++ b/drivers/net/virtio_net.c
>>>> @@ -1868,6 +1868,13 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
>>>>         return received;
>>>>    }
>>>>
>>>> +static void virtnet_disable_qp(struct virtnet_info *vi, int qp_index)
>>>> +{
>>>> +     virtnet_napi_tx_disable(&vi->sq[qp_index].napi);
>>>> +     napi_disable(&vi->rq[qp_index].napi);
>>>> +     xdp_rxq_info_unreg(&vi->rq[qp_index].xdp_rxq);
>>>> +}
>>>> +
>>>>    static int virtnet_open(struct net_device *dev)
>>>>    {
>>>>         struct virtnet_info *vi = netdev_priv(dev);
>>>> @@ -1883,20 +1890,26 @@ static int virtnet_open(struct net_device *dev)
>>>>
>>>>                 err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i, vi->rq[i].napi.napi_id);
>>>>                 if (err < 0)
>>>> -                     return err;
>>>> +                     goto err_xdp_info_reg;
>>>>
>>>>                 err = xdp_rxq_info_reg_mem_model(&vi->rq[i].xdp_rxq,
>>>>                                                  MEM_TYPE_PAGE_SHARED, NULL);
>>>> -             if (err < 0) {
>>>> -                     xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
>>>> -                     return err;
>>>> -             }
>>>> +             if (err < 0)
>>>> +                     goto err_xdp_reg_mem_model;
>>>>
>>>>                 virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
>>>>                 virtnet_napi_tx_enable(vi, vi->sq[i].vq, &vi->sq[i].napi);
>>>>         }
>>>>
>>>>         return 0;
>>>> +
>>>> +err_xdp_reg_mem_model:
>>>> +     xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
>>>> +err_xdp_info_reg:
>>>> +     for (i = i - 1; i >= 0; i--)
>>>> +             virtnet_disable_qp(vi, i);
>>>
>>>
>>> I would to know should we handle for these:
>>>
>>>           disable_delayed_refill(vi);
>>>           cancel_delayed_work_sync(&vi->refill);
>>>
>>>
>>> Maybe we should call virtnet_close() with "i" directly.
>>>
>>> Thanks.
>>>
>>>
>> Can’t use i directly here, because if xdp_rxq_info_reg fails, napi has
>> not been enabled for current qp yet, I should roll back from the queue
>> pairs where napi was enabled before(i--), otherwise it will hang at napi
>> disable api
> 
> This is not the point, the key is whether we should handle with:
> 
>            disable_delayed_refill(vi);
>            cancel_delayed_work_sync(&vi->refill);
> 
> Thanks.
> 
> 

OK, get the point. Thanks for your careful review. And I check the code 
again.

There are two points that I need to explain:

1. All refill delay work calls(vi->refill, vi->refill_enabled) are based 
on that the virtio interface is successfully opened, such as 
virtnet_receive, virtnet_rx_resize, _virtnet_set_queues, etc. If there 
is an error in the xdp reg here, it will not trigger these subsequent 
functions. There is no need to call disable_delayed_refill() and 
cancel_delayed_work_sync(). The logic here is different from that of 
virtnet_close. virtnet_close is based on the success of virtnet_open and 
the tx and rx has been carried out normally. For error unwinding, only 
disable qp is needed. Also encapuslated a helper function of disable qp, 
which is used ing error unwinding and virtnet close
2. The current error qp, which has not enabled NAPI, can only call xdp 
unreg, and cannot call the interface of disable NAPI, otherwise the 
kernel will be stuck. So for i-- the reason for calling disable qp on 
the previous queue

Thanks

>>
>>>> +
>>>> +     return err;
>>>>    }
>>>>
>>>>    static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>>>> @@ -2305,11 +2318,8 @@ static int virtnet_close(struct net_device *dev)
>>>>         /* Make sure refill_work doesn't re-enable napi! */
>>>>         cancel_delayed_work_sync(&vi->refill);
>>>>
>>>> -     for (i = 0; i < vi->max_queue_pairs; i++) {
>>>> -             virtnet_napi_tx_disable(&vi->sq[i].napi);
>>>> -             napi_disable(&vi->rq[i].napi);
>>>> -             xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
>>>> -     }
>>>> +     for (i = 0; i < vi->max_queue_pairs; i++)
>>>> +             virtnet_disable_qp(vi, i);
>>>>
>>>>         return 0;
>>>>    }
>>>> --
>>>> 2.37.1 (Apple Git-137.1)
>>>>

