Return-Path: <netdev+bounces-2002-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B66026FFE91
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 03:55:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B4E61C20F14
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:55:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F067803;
	Fri, 12 May 2023 01:55:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3E97F0;
	Fri, 12 May 2023 01:55:04 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73C959DC;
	Thu, 11 May 2023 18:54:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkO74yVTGFncmaXmjXg6mD6Lr+3dMPsnb4ByRgrZJxnNpPkRkH0e16srf15Vgm6dBXAXKeYvBqP0JFbZEocJ5i7RExQFOawejhhpsa7ODcHQfAtEFSJSDNbmXr2RdFoA3JEGnElAaMWQGZ3GAorkaw30nybKbdCLx7bDpF0fMCgfIQ0xDzpyHLn5Hu6h+1RCQWUQ8pGLitK6tgheP+NNUmS/CFVn0dlOavJdYjz2+IZtUUDTJMZYw7w6FYJ9tIMjO5L609pSGYltsVBndZ5JiNOL1v0qj93zeSKsnFqNqOT4pYLI/YbJzv7cCJGOQDbxAlhjy5mtyoISQLYyWlMrJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFJCOwLfaEsBeDfMW38N6UO6M/iNKabrOf5p3/gnH5Q=;
 b=JBK6Dq7FpmdH6y5ZSc2GqCiRwcLIw7V8A10dLOrX2mba+tMRJ+Xkv/5kH2fLFVaWvUYEFk5NVuXRFTk5usk4ZWlTS7AlPl0HZElve1IRnEQl/Sq1MLQkxl1Jq8pi6hKBL4dsP6wmwKKjOsHJC+5wcGSKOdeAAePR7lGfrkSHP9ueyv4EjhM8Xcd1RShAHdHRozOmSMCBJR1BupxyfArnB9u/Tl2RuW0TqJIAtK1w98aBOpY8yYomfm5Ho0JbvUqbcD6AZOp1Af1jmc84goWuodZQtOzxC+1WRTNUyVSN+9vzhEhzhe7I7Mis515Kte14wwndri0j72mb5S4GWwqdYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFJCOwLfaEsBeDfMW38N6UO6M/iNKabrOf5p3/gnH5Q=;
 b=COzywk3YxyCBEgJnXvyBJg1tl7HI7nGT8U3b8KkFJUPX7capLlO/rhCBBXaEjbk62ddXyWPr9QaVW+vdPupu5hL2J+HZQll8qipnGTir5bVTp2o3CxAa2lhOVs5YiXjAlw/jCdKwkW+LRxIR3y+7TxxbV+xQ5jfPzDtc7OIk0S3UdGxuawxvGpdkoGFpNYdyJCtRR3v/w0iZ3czZiIxQ5XEPMWeiP4jsC3Fd6if9YESXfRqc1Zo9DIpDcM4tp/KT6m1V+jBQFHPfoCWXTLWAZotnp4dY7GzHNQvDJoWroV1Z0sdG8pnVAe0noXBNp0wBjtMvAWtDZWL3vcKRPk7udA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB6207.namprd12.prod.outlook.com (2603:10b6:8:a6::10) by
 IA0PR12MB9011.namprd12.prod.outlook.com (2603:10b6:208:488::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.33; Fri, 12 May 2023 01:54:45 +0000
Received: from DM4PR12MB6207.namprd12.prod.outlook.com
 ([fe80::b886:ed22:51ce:fd53]) by DM4PR12MB6207.namprd12.prod.outlook.com
 ([fe80::b886:ed22:51ce:fd53%6]) with mapi id 15.20.6363.033; Fri, 12 May 2023
 01:54:45 +0000
Message-ID: <af272d2c-e952-1c13-80da-b5ce751e834b@nvidia.com>
Date: Thu, 11 May 2023 21:54:40 -0400
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
X-ClientProxiedBy: SA1P222CA0172.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::28) To DM4PR12MB6207.namprd12.prod.outlook.com
 (2603:10b6:8:a6::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB6207:EE_|IA0PR12MB9011:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c95a171-76bd-4c11-84d0-08db528bdbef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VbsfmNN+R6IJas2UvUOb4GYYM8v9Poc/vR1WUg5HnpP6XNVDhLSUlFaghNm4VklAMNB7cgBecF3a3+LHaJvJ6VznkOwxVHtf7eNWCzyYBOrNj5NyOdlfs+yAfMyLVL4oDXipvC6OBiFw47sgxlG2Q1/+qBwqqBV/Vlt2vSETDbhdZIF8kG15PmWUiaFE+ZAw0f8sFAtnLgr5UXnw2vT18gJGN2egSvxoADyD8x5w+VRMG4oZIFodf9+/Ww1rGnku5Ci7xp2CAbmKCNHy3Xhu59ZsXtZtaqR/YoEAeRbwsxMp1BUGw+O/gdZTLfMXA4YK8MQTu9kfQZXUynYn7J6D7lQQUH5oOPiQ97LsFL4AMdu5aWsSgYNxkumJc3iIj4A7DVNFVYz6vJ3SNmSGg7DdxtOdOOD7A14qCeZhMekk7woaa4voNFSF6YtVzT2c7e8/pomVOQfE5rajdw2nIF93FF2clLRaW3YBWytQtxUMdUc3esYi83cImtR3zzV1vbJWtgCxVC0TnK949j9b7ytLhjh5ktoXtEEfkOITLUeV5FZi+1SHsHkVbwvIEFLcXkxAWarDTQ0lO2yE+7Xj3d3c3j/DMgpRJRcY7F2KTW6vPuLPvYjx58pRttrOF8VnsGL5hAtgd1gzsslSPr21PmtMgg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB6207.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199021)(36756003)(478600001)(6486002)(2616005)(83380400001)(38100700002)(41300700001)(4326008)(31696002)(5660300002)(6506007)(110136005)(66556008)(6512007)(54906003)(66946007)(66476007)(86362001)(26005)(6666004)(316002)(8936002)(8676002)(31686004)(186003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUNTN0Myb0EybVZjbUkvTVlMMDF5aDVxcUdsQUpuSUVydEZsaXAvQjNIWWdu?=
 =?utf-8?B?N2gxbTBMS3F4TjZhUWtudHpzcXBwajhnc1ZkY0NjNklpaEtKNWc4VmhTTVU4?=
 =?utf-8?B?NVc1c3lhcmR5a3BUb2gxVk90NHFoM3M3bHlkS2VJbXRzZnd4cnBjZS9lMVMr?=
 =?utf-8?B?M0NzbENTL2VBOGVoSWJhZmF0TTgzUnFwWlI1dnl6VDhEZGdNRC8rUmZkSlFl?=
 =?utf-8?B?eW93a3Z6QUVsYVF3UGM5elcxUklYOWRSVHhzenl5NE9FTE41c1poWlNiOERF?=
 =?utf-8?B?MWVtSk8yQ0diT21ZTkFGQUZKY2xtMEhScU5lT20vVkFSa2hSZkdsTks0WnhV?=
 =?utf-8?B?OFZObDIyUUxicnVuQVZLdCt1TDNHQzhxYkZvckJqdjJ2allpbmcwQWkyaEpx?=
 =?utf-8?B?VUR0c3FVcDhOVzF0R3BGMUVoc1kyQzQ4MEVZR2NYSWdjZHI1Z081anFxenli?=
 =?utf-8?B?d3pFVlErbjd3dUw0RWpIcnlXOU5DRDRCdlIwR1ZPUzBCMXkvYzd6OUErMXNV?=
 =?utf-8?B?bmN4eHRSS0tKWUxwTk93SWxuTzZvME9KbkpIZFQ5RFozOG12VDVtTG1yQkRS?=
 =?utf-8?B?ZDM3djRzRzZtTmpwYWtPczZsbFZmWjRqZVFibDRCbS9La0RNOEF3bGRhK01E?=
 =?utf-8?B?UGpKZU9NWW1sakF4NFo3SmRzSlp4NmgvQ3hDN0JtZ1VaSXRoT3lWcUI4cEJH?=
 =?utf-8?B?VXBTb3VSYlR2Yzl6VHNVUklCMEhaSHU0SXBJMndJZnNIMDZXN0hUVGw2TW5r?=
 =?utf-8?B?aElRdVVxQ2hXTVdjUnM0SERHOW9yWFVtTlFtWWZJc2k0bUdVdnVVTGdrWWVx?=
 =?utf-8?B?SG1Yb1pndVJ6aENzQ3RySTRPNGFQNjkzK1ZCUks2dHYzR2JPWXNjd2h5UitI?=
 =?utf-8?B?dnhwOHVuL0djM0F1MjVMU1prVXFCRElWK2xiSWo0eGJYSzFZeGM1a0hNcjdq?=
 =?utf-8?B?MzZDelJpVXlTeUxpUkJPS0daZVFJK2xQVE56NkUrcDUxb1R1TEV2MkxiV1JM?=
 =?utf-8?B?cHlrcEl4cVpjdi84c0pSajdQdmphSVRlQko5eWhickJ1dUdCTmlnY2FJdnEy?=
 =?utf-8?B?TDhYS0E2dC94Y3JaZmVEc2gyVmhKSUh3ZHYzZTVGdTg3Qm9ZWHJxYk9FbXEv?=
 =?utf-8?B?R1FCdG1vNG0zbWRGSzJkMXRma1pGbWRvYUtZQmRaYUYwMTlIWDJ5TlEyK01m?=
 =?utf-8?B?di9mQ3djaHpnZW1pVXUvVHJsNEs5SHRwWEx5cFhOeVM3Y0pZY1kxSUxESTN3?=
 =?utf-8?B?YXluMmZLRXRCK29EMHVJWVhkaTM5UXg4YnZsdjdqS1p6RHhEQVJHUFplRGM0?=
 =?utf-8?B?a09CaEFiU3ZaMEhUVjRrM1pKUThnYm5QKzBlUTFKLzY5azJCSHlKMFZGVTU3?=
 =?utf-8?B?ZW90RFdCSEZ2VTFXZkhqQThoVGp6aGh0dW90TzJITGlWc1NFdU1aQ0J1R2Yw?=
 =?utf-8?B?NnR5T3BwOWFFNVd4Y2RBdzdzN25kQUg1UGd2MzJFTjRNczdGY0JETEZSdWFo?=
 =?utf-8?B?N2IxcnlaN1JUVVdwRzdRUWpub3lJNyt4YXJNR2wyNEsyaFF0dnlOQmg4WkNy?=
 =?utf-8?B?Z0FkWmFsOUZUanA4UEpLTUxna1Fod2dQdngzbE1YMWk0NGowZUJHNmFzU0xI?=
 =?utf-8?B?Y01Qcm1lUFhZaWV0NnVpcnFNWU1QSmFtdlkzdklycnBQWlpJU0syc3V5dHNR?=
 =?utf-8?B?bEZBS2J3TWRHbGVWSlNac08ycGs0cHVDWlVWeTFIVVU5MGVEQk9hL2V4MDFZ?=
 =?utf-8?B?MklMVFl0UkptWkI4ZWZ6eERMUGpkNys2QWF2N0diejVZNURQbENGK3lYVkZY?=
 =?utf-8?B?Vkp3N3JBc2hJemVsQXE3WDJjVm0ybkV5dmY0amVSZDNQdldCalFOUmF5dlQz?=
 =?utf-8?B?cEF5NlVIalJPcy9sa2VzZFNYUHdmbVJvVXdSTEZWUW8zT0hnU0NlMU12aUlJ?=
 =?utf-8?B?TnlzRytyaWJXY2wzQlFWaTJCVTlwL0JGNXdFNTFjL1VSRktaUml6eXoyaFA3?=
 =?utf-8?B?RkVVSmtUajErTklSUGlUOHRoVm54bmx6UG1DMk9uVW0vUE52QXQ2ckNtVDE3?=
 =?utf-8?B?em1uQ28yZWU1UEhRSFNLNG5RT0h1TDdtdXg0TmovTmRyRXdEQWtpOStmRFpw?=
 =?utf-8?Q?dxP8sFAWXdh15vbJ4rW8cJWuD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c95a171-76bd-4c11-84d0-08db528bdbef
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB6207.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 01:54:44.8814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ul/V1/K5CRhyWzR1hXDOJDkpZZ/zUO9b1y/hCnz6nePbxTriUx++asTFnso0dw/cNvLfqRv4muu7hxuiYdkOKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9011
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Hi, Jason & Xuan

I will modify the patch according to the comments.

But cannot call virtnet_close(), since virtnet_close cannot disable 
queue pairs from the specified error one. so still need to use disable 
helper function. The reason is as mentioned in the previous email, we 
need to roll back from the specified error queue,  otherwise the queue 
pairs which has not been enabled napi will hang up at napi disable api.

According to the comments, I will call disable_delayed_refill() and 
cancel_delayed_work_sync() in error unwinding, then call the disable 
helper function one by one for the queue pairs before the error one.

Do you have any other comments about these?

Thanks

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

