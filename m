Return-Path: <netdev+bounces-1188-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F8C36FC88B
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 16:08:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7175B280D19
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:08:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8819C19516;
	Tue,  9 May 2023 14:08:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1F515495;
	Tue,  9 May 2023 14:08:25 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2625D40C8;
	Tue,  9 May 2023 07:08:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mygzo/C1SgfAAqQVZIaBlT3Mcs0RqKLUmSRE4vgxV0HI2izBep33we5sgdYVOovef7sam/G/ugbJEn3HUS89yQfthctwPLbCb6ci6DVD52YNaDoUJCe2p4xOqMtxf6P04IW0Nhy9eOsDEpTYz7R03dtuylaSmvytmOUM0Ua4D9C1xHXYUaWZkJS53FvilmmLrsx9rlCpZRxk9YPX0QUfSILNImqWvYsQS1/chIIruq5q3BZVm89Cq9Kp4ZTWDS7+z2QIg9NTjwzE1w77ZCvhL4P4o9vE8PR+H50tKYvborvz0VkFScPJyxvTbNdDuR47GLBFaxcHPC06+mbDSgs0fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PS1JWJ6uyP+zkaVfokwG0FAYk7bpUkRFkP/ufeBVCk8=;
 b=dj3pUNPslUbKctorK6VVXkQDaJSvms12Wyg4/j61htV8Lz6WjwKXuoCiGn+h62eSoTiCwKB3qNXaRe2t2iC/mQs47YohNiceBbC9SCT/fWEwZHfqRj4uEUbD/XuY4ppP5Uh3Jdf0PIyhbH7SNXR/lO5Gy6blBMGSCLefR1VmLnkJoKYLAQA4Sr+eAszYu0F2+JAwiW8g3akHtyKMzw7AqduyeKXxk788hgFPrSeSMkM23w9fMC9G8foySzGV1+P88Chby2cQkSA7zQaCIfUfeBqErplzR86qoQStm6bg30A9iS9ZLr1pcauOJ8UBBiWKGEhdN8ERwNscmF/J4wcEmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PS1JWJ6uyP+zkaVfokwG0FAYk7bpUkRFkP/ufeBVCk8=;
 b=j/tmxShGpKDyMkZHSKsswIleOdPc6wa5fNZT9IbbaZaR0WiRGXkpjNQ8MGJIcohlus85NbNEmf2QIzhUJlHhxWLKukFtyCaYnLKOe/u2jip0CwaE9kPlA8m373hz078BJCB1pjlqJMeac+64gjkahcq3UDUNnWtarAdma2NLQUoV35UmEF8T/Gwfd8GFF6LflR4+YNcdOEWcFg0eFxoi0EgCLlLCiHf/+MzP9UUdshRXKpXh1Mmm6YL8q5fe6YBfRm/RvcdNBAtTnK725UdKYUlM5H42GXRBnXYAvMy+SKM3avF8365IqXTrZFlLv26iNuvX1zpjvYd2eyr0H/Fz7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6201.namprd12.prod.outlook.com (2603:10b6:930:26::16)
 by IA0PR12MB8746.namprd12.prod.outlook.com (2603:10b6:208:490::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 14:08:18 +0000
Received: from CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::a7a3:1d9d:1fa:5136]) by CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::a7a3:1d9d:1fa:5136%6]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 14:08:18 +0000
Message-ID: <7ffb8783-a102-afb6-5f9d-a744bbfbbbe6@nvidia.com>
Date: Tue, 9 May 2023 10:08:14 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH net v4] virtio_net: Fix error unwinding of XDP
 initialization
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Simon Horman <simon.horman@corigine.com>, Bodong Wang <bodong@nvidia.com>,
 Jiri Pirko <jiri@nvidia.com>
References: <20230508222708.68281-1-feliu@nvidia.com>
 <20230509004010-mutt-send-email-mst@kernel.org>
From: Feng Liu <feliu@nvidia.com>
In-Reply-To: <20230509004010-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0105.namprd04.prod.outlook.com
 (2603:10b6:805:f2::46) To CY5PR12MB6201.namprd12.prod.outlook.com
 (2603:10b6:930:26::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6201:EE_|IA0PR12MB8746:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a29a218-198a-4961-1a34-08db5096d70b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GEdoBdXUmLN1eTmU4Un0y1O3uyahU6gAZi3x2tWO/fK8Dm5UatRwX85fJBvZCkDkLO61v5lkwcyBYLT6AMGEElis/mNlrM1k1XoAN/oWycj3ltyIcr+Ghx05tmn7RaA88dXSv9DcW6IV9lzbAZUivzIYX9MRVfnxeYtR+1SJC03aEs53VjNx4rSEqDEZG+aUdGlc60rdxiXnPKMNpBgEuoQy4M3tRQ47QVCt8Xf/1ZLek11utR48cRbQmJsT0E4qzksLKR9F/YEW48LeblC4IPJqyD3oqrfary29AmsgHVPe0++71XsnOmT5V94SR4ooyWuaUbEjXCHev80UU8NILH7cKgHWK2yf01CzYJ/pRQS9J8x4DGQlpal3PXehjLi4M8jYAUctNpCYE+9F2+tfmW22qTl8TcaATy3bIfbbiwlfkN+kG6idaiSPGkv73oxolb1t5NHJwNOyRvpIdU4siYs+pMJw1sYFQmZFSiIuYpIzCTn3dmkAtm8puod/l9BEDoeBFmKqAQG+oaEMS1b8Q+l8KEMcb0v4s+pu71cjGsFbM1GDILzxAZMo/7mcBCsBaaXS1olmjM9j8BRvvK83Jc/f1xBe8gQtP7AHJutmkuaoqUKZKGJrqU8WIawNKZ34oxW77c/FqEXheKJsV8y1Zg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(451199021)(31686004)(36756003)(66556008)(38100700002)(2906002)(8936002)(5660300002)(316002)(86362001)(8676002)(66946007)(4326008)(66476007)(41300700001)(6916009)(31696002)(83380400001)(186003)(107886003)(6506007)(26005)(6512007)(478600001)(6666004)(2616005)(54906003)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SzFwVDJFV3RaR0dpZDNvWmVIbXBTdERDZmZBZStTZW80TGlyVktaRk1rZDQ5?=
 =?utf-8?B?cmpvQUt6aFlta3FPOFlRemVCM2ZsRlhXYWtQQlIwQXFYWmMvYmtiSHZJbjVN?=
 =?utf-8?B?MExkelhsVG95RnlNSldGQk9KdG52NnExaVhHOVl5K3o0SjlyN3d3b2E5Y2pL?=
 =?utf-8?B?YlBZazB2WUpsUTBkNEpXUUNpZ2JqTVltdHVWK1daczJaUytaaGRKVlZDQzVW?=
 =?utf-8?B?ODVjeEFydkV0SzMzWE1RN2FzSFA4YWU2N0R4VDl5OVJmaU1LT01RbXoxUG5Y?=
 =?utf-8?B?WnNBcERzNDJ2WG12TUVxeFhibHVTWU5BTjdkU0RwVldqb1NHMllzLzhVYmJE?=
 =?utf-8?B?SzJ2alNNVUluK0k3T3kxblkyazVDM0xacSsvKzhGT1BNUVJEejRsNUtCcjQ4?=
 =?utf-8?B?K2hHMEpjbXpMczRWazRYUjVhNDk1ai90TkVCdkhmU1AwWkkvdzlVbHAxOUdS?=
 =?utf-8?B?L2tBYWFIL0lIbElsVGRnYkxFZnRDV1Z1ODZ3SFJCOXpFQVhSRXc1RGdHbHFM?=
 =?utf-8?B?LytmR01PUC92Vy9BV0QrbkVXTHdqV0ZFMk9tbC93QmQxOFhuaDlFanFqMVlV?=
 =?utf-8?B?VW83dDNYT0VtQjcrNDNBdXU4aHZSS21xNElYWWtYRVZFcWJJdXZtdXU1NXFs?=
 =?utf-8?B?ZVpLSnJlTDdGWHE4K1I4UzFNSlYvdlpWVkFUZjVGQkFDV3RvTDhiTlY1V0RP?=
 =?utf-8?B?TDgvSE9waTRaWFVxY0ViaWJoUUZBRnhYTDZ6b1QyWVhkOHFDVE5wZkx6dU1D?=
 =?utf-8?B?QWVnSE9tUE8yUXQ2TGZXb2JSY1lDcWd4OWJkdTl0MGIvdGNMMzh4MzJBTHBI?=
 =?utf-8?B?OFZ0bkpTM2tFVjY5dlJ2eGhLYXFIYmYrQXA2c1lsQUJpNlUwOEQ5NjczL3h0?=
 =?utf-8?B?Z1VpNEdxanRpMlZNcDF0eEZwMEh2dFFOQ1Y5bm9pVjJ3YUlOd3RhcUlEcmhJ?=
 =?utf-8?B?R2ZXeXRuVUVOV3NqdFV5cnJhUEFteVRwcnFJSHZqVXgyUWdTS0xrLzdOcWhC?=
 =?utf-8?B?eXhJMy8xQVpJaVRzbjhoL0VkckVOVnVMWVZsYzBNMjUydGlwc1BxazliaDZ3?=
 =?utf-8?B?OUN3U2VsQWtBMjJQRXByVlpHYnBYcTNZS2FreStBeEhSdFNBcEhZYm9ra2xa?=
 =?utf-8?B?MHBNR0g4ZDFZWlBHWkpJYURjYmZpbHJXK2JIYkZVYVFBcXYvRDcvR1YzQWkv?=
 =?utf-8?B?TW5seFNQdVp3b0IwOWFXMU1wOTlpSFk3V3dhNUdzcFNpNjY4aVlrUHlZeTds?=
 =?utf-8?B?UHpiYUNoQWx1Z09aajEweVp4K3ZXQW50alltcE42d3E4UTBScGdESzFhNW9Y?=
 =?utf-8?B?V2kyWldIcXlRNlVoRW1KRWV2R09vSk1WbEhLV2t1cFZIeHRtRkJLa1dRc0xl?=
 =?utf-8?B?UGVyK3Z0K0RxUEQ3eGRTdEx2MEw1VU9pczFhMEpEdDI2OS9tbjNjY2VFaUx0?=
 =?utf-8?B?ODIzNGx4SnFXTW5ZSWtBY0F2MlRNZkFqdm5NT0NlaGZnV3ZKMHFTbW4wNk5n?=
 =?utf-8?B?NXdMMk9FUWR5cUdLOFV0NEdMNHc3dWdVM1JiUFdVZThLazFWU0MrLzl6d0VL?=
 =?utf-8?B?WE1rbzk1SHVXM3NQYzM1MGVpWUtieWdLaGpQQnNoK0RtRi9YcWlNcWdLbldp?=
 =?utf-8?B?eEJLU0hJZHc5Yk83TzBEbkxNbndJa3RnQURCNnpoK2dpNGdaOGo0dURzeUJi?=
 =?utf-8?B?bFFTYkIwTDUveEdqd2dkZzl2YjZreEZxRUc5dFRmbCtna2doM0o1ZGhHVjZa?=
 =?utf-8?B?Y1FVdEtTMC9YWXJVRDZ1aGVaSEtzSlk0TW52MUdGM0daUjBRaGVNeTZqbXZh?=
 =?utf-8?B?b0lFRFFyZlVVN2VFbTV4NTRES2tyVG1mWGdQZ1JQVG5JdmFEOUlXUDVYRUJo?=
 =?utf-8?B?ZGJtV05PRW9hbHhjT3l3Smo3UVIvamVNb0ppdFlUbHkyQjRIc2pTd0dFczhI?=
 =?utf-8?B?cU9ZcHRDcFgzeEVrMVgvdHA2TGU3RExCdlhGNkxUUjhyeWxSQmlWUldOM3Jq?=
 =?utf-8?B?d3Y3Y3c5WmIwb0lrRFFEUkcwZUEyVkdVY3o1RFg5WFBHVytBUDdPblliZS9j?=
 =?utf-8?B?Y2lZeGVCZXZwRk03T2pkcGhQZ0xwUFIxdG5RZXlaNDhNSkdXVmUxZDBMeTEv?=
 =?utf-8?Q?nvJc/TOzzkcVgujISGwEdqcGo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a29a218-198a-4961-1a34-08db5096d70b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 14:08:18.7763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X90vMWd/EyLylvMXVIuLnXGQ5a39cN7644h6ujmhtAhXuTpinZBre7yoQlU+B7Qw0jxALd/mhWzLiEH9bgC2KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8746
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023-05-09 a.m.12:42, Michael S. Tsirkin wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Mon, May 08, 2023 at 06:27:08PM -0400, Feng Liu wrote:
>> When initializing XDP in virtnet_open(), some rq xdp initialization
>> may hit an error causing net device open failed. However, previous
>> rqs have already initialized XDP and enabled NAPI, which is not the
>> expected behavior. Need to roll back the previous rq initialization
>> to avoid leaks in error unwinding of init code.
>>
>> Also extract helper functions of disable and enable queue pairs.
>> Use newly introduced disable helper function in error unwinding and
>> virtnet_close. Use enable helper function in virtnet_open.
>>
>> Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
>> Signed-off-by: Feng Liu <feliu@nvidia.com>
>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>
>> v3 -> v4
>> feedbacks from Jiri Pirko
>> - Add symmetric helper function virtnet_enable_qp to enable queues.
>> - Error handle:  cleanup current queue pair in virtnet_enable_qp,
>>    and complete the reset queue pairs cleanup in virtnet_open.
>> - Fix coding style.
>> feedbacks from Parav Pandit
>> - Remove redundant debug message and white space.
>>
>> v2 -> v3
>> feedbacks from Michael S. Tsirkin
>> - Remove redundant comment.
>>
>> v1 -> v2
>> feedbacks from Michael S. Tsirkin
>> - squash two patches together.
>>
>> ---
>>   drivers/net/virtio_net.c | 58 ++++++++++++++++++++++++++++------------
>>   1 file changed, 41 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 8d8038538fc4..df7c08048fa7 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -1868,6 +1868,38 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
>>        return received;
>>   }
>>
>> +static void virtnet_disable_qp(struct virtnet_info *vi, int qp_index)
> 
> 
> I am guessing _qp stands for queue pair? Let's call it
> virtnet_disable_queue_pair please, consistently with max_queue_pairs.
> 
Yes, qp stands for queue pair
will do, thanks

>> +{
>> +     virtnet_napi_tx_disable(&vi->sq[qp_index].napi);
>> +     napi_disable(&vi->rq[qp_index].napi);
>> +     xdp_rxq_info_unreg(&vi->rq[qp_index].xdp_rxq);
>> +}
>> +
>> +static int virtnet_enable_qp(struct virtnet_info *vi, int qp_index)
> 
> Similarly, virtnet_enable_queue_pair
> 
will do, thanks

>> +{
>> +     struct net_device *dev = vi->dev;
>> +     int err;
>> +
>> +     err = xdp_rxq_info_reg(&vi->rq[qp_index].xdp_rxq, dev, qp_index,
>> +                            vi->rq[qp_index].napi.napi_id);
>> +     if (err < 0)
>> +             return err;
>> +
>> +     err = xdp_rxq_info_reg_mem_model(&vi->rq[qp_index].xdp_rxq,
>> +                                      MEM_TYPE_PAGE_SHARED, NULL);
>> +     if (err < 0)
>> +             goto err_xdp_reg_mem_model;
>> +
>> +     virtnet_napi_enable(vi->rq[qp_index].vq, &vi->rq[qp_index].napi);
>> +     virtnet_napi_tx_enable(vi, vi->sq[qp_index].vq, &vi->sq[qp_index].napi);
>> +
>> +     return 0;
>> +
>> +err_xdp_reg_mem_model:
>> +     xdp_rxq_info_unreg(&vi->rq[qp_index].xdp_rxq);
>> +     return err;
>> +}
>> +
>>   static int virtnet_open(struct net_device *dev)
>>   {
>>        struct virtnet_info *vi = netdev_priv(dev);
>> @@ -1881,22 +1913,17 @@ static int virtnet_open(struct net_device *dev)
>>                        if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
>>                                schedule_delayed_work(&vi->refill, 0);
>>
>> -             err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i, vi->rq[i].napi.napi_id);
>> +             err = virtnet_enable_qp(vi, i);
>>                if (err < 0)
>> -                     return err;
>> -
>> -             err = xdp_rxq_info_reg_mem_model(&vi->rq[i].xdp_rxq,
>> -                                              MEM_TYPE_PAGE_SHARED, NULL);
>> -             if (err < 0) {
>> -                     xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
>> -                     return err;
>> -             }
>> -
>> -             virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
>> -             virtnet_napi_tx_enable(vi, vi->sq[i].vq, &vi->sq[i].napi);
>> +                     goto err_enable_qp;
>>        }
>>
>>        return 0;
>> +
>> +err_enable_qp:
>> +     for (i--; i >= 0; i--)
>> +             virtnet_disable_qp(vi, i);
>> +     return err;
>>   }
>>
>>   static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>> @@ -2305,11 +2332,8 @@ static int virtnet_close(struct net_device *dev)
>>        /* Make sure refill_work doesn't re-enable napi! */
>>        cancel_delayed_work_sync(&vi->refill);
>>
>> -     for (i = 0; i < vi->max_queue_pairs; i++) {
>> -             virtnet_napi_tx_disable(&vi->sq[i].napi);
>> -             napi_disable(&vi->rq[i].napi);
>> -             xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
>> -     }
>> +     for (i = 0; i < vi->max_queue_pairs; i++)
>> +             virtnet_disable_qp(vi, i);
>>
>>        return 0;
>>   }
>> --
>> 2.37.1 (Apple Git-137.1)
> 

