Return-Path: <netdev+bounces-701-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F32616F91DC
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 14:08:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF00A1C21B0D
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 12:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 019D48493;
	Sat,  6 May 2023 12:08:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BE81FAF;
	Sat,  6 May 2023 12:08:12 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2051.outbound.protection.outlook.com [40.107.100.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B79F120AB;
	Sat,  6 May 2023 05:08:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXE8ff3hUPEGyTimDfKA/IpTq3WpPU6jIGYmxydZP+gfEyNJAvtrm4wCAGvnCP0GRa3m03vKYPqp83USZtCR7U7jA+NrZIDoc2/npcxi4SrP/aq2uVmslsPuHhiQODje6jDWdBuoxTqS9AF/XDu5/hKgZKniVh1rM1ygIYKRO3Izix9viq/ZECyo457kveLFpM86YRDcHETq28iHeAxDc3bHf3O0UjdeL9Uhae4mqiOv7YCZuG7OTXxdsXF3xSoYza/1X7lkqagCwO9HUBsTwtO+gOMsgaJEM2qgmvOXU/FntDAQI5ZOZCSiU5gO4/VXZ95Xi6sBUh9dJ/C5TMO96Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0uZbdqij7ky3yBnJTqb6eXQqTAglrPVfDaC43XBFx4=;
 b=QUzDFbOchl2RDaiDr6132Zq8iEJDl8LhkQUmwScjiu8sanKGjqRGA6/bjSxfiKsMt9/1bYwHMHDylB0xwiy2Mj5eBYDQI8USmG2WfwHPraH8aC6n8AFV0/ACRx6bIn1eztJchGvCMphk/klIqGLs7YMGYr2dMgsuBnr4vG9wnFLN/XBuikGefkp09bJ8zsLWivjOg9WWhQgBiumUUmjXzyjSK8rIAtTRKef9xtvESvkO6vHqk1nuRrj8elnu25RUKUGa52UViI3LTOxjwoUn1j4fkyNTq1qFa8K9tug8HqntqRl8RFMMHBBJT8vrAQ/OvXIRaLxTFu2wErWHCOK/+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0uZbdqij7ky3yBnJTqb6eXQqTAglrPVfDaC43XBFx4=;
 b=oLMmTQrXo8oHOU6aDEQWU6MHr6nG265RnKTQZYBnUjnQywraNz/qPAiElYPe6q1ELujMv+ct5J7mWnu8+Pzehp+5H0sOqyxP6QY/m47tDXlyeVd4GqUH2k0e63euw0HfCHI1gFEEVOMieTIpYPSvs9cCxx17rU53tbo42SABcx7cN6YhbK52D6Y8iaGOPSJCStVV7CBfMqAouTPwgT8+VwqvDaCWNomqdIWui1chKw7g9gelLwnAunqfWgBi8ISmCd6bU97b1C6IyABBps6dQ92DpqtWurTTYeKiwev/3zJ5ZaDkXHVXP2Z3AIs/fQoTtxnE9WnoWng+kK1wSJATuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6201.namprd12.prod.outlook.com (2603:10b6:930:26::16)
 by MW3PR12MB4491.namprd12.prod.outlook.com (2603:10b6:303:5c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.29; Sat, 6 May
 2023 12:08:06 +0000
Received: from CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::a7a3:1d9d:1fa:5136]) by CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::a7a3:1d9d:1fa:5136%6]) with mapi id 15.20.6363.029; Sat, 6 May 2023
 12:08:06 +0000
Message-ID: <559ad341-2278-5fad-6805-c7f632e9894e@nvidia.com>
Date: Sat, 6 May 2023 08:08:02 -0400
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
From: Feng Liu <feliu@nvidia.com>
In-Reply-To: <1683340417.612963-3-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::23) To CY5PR12MB6201.namprd12.prod.outlook.com
 (2603:10b6:930:26::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6201:EE_|MW3PR12MB4491:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f90a787-3e77-4643-d04a-08db4e2a8ced
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dGSwnioJ5yDT+VoD77EL1OodEFumLf4+RN1InXfr/C5jbs3g6gv/B077h8s7AVaKh1r666ZMtsaSiB2rwxbAmjLfSCUTjp8vAEBlmgvVr4+jf89p6Q2ttRW8gV82NgPdzvxRv5Q9v+GyJ5prG+bGdyXxJTyLfOiV7mbl+RqSW7lbvFzeRNWmwF31xZ+UAVDKpdC2Gc6zs5bwe+nKViDfbGrJMyqL6JiCR5iRwUptUv/r6lz1oZ82vMpyrFNnFNG5sNlCYCbae4RX1ixnG+K1+0hUON9vU7DXnNIT80zWOEm7vBCPuylLgE/7gs7CaRxiWX+8y/FxSOuNeF9T2ySNXB1poN0cYBxyq/wAO7UGFruZyw60skHP8EOCU/p+10YBkkzIRbtfFfAmi8jRi9BYQT1hOnLngZpk0iiJ4Cn4AfKB3x/q/hYAaaL8c4zHjYGkIzUeq7Opf04kuRYGjXUeNLqnNOgmz1uDZ1gBZE+fLUIUJ8biscYAJk+B/7S+CCJhodFbMfDNQdoK3kFfjUIVTw0BnDc47xhP7Uz8WXKWPBnbX4A5/ZyipO1g+xBzbBo6XWLrC6RafrRmNjAW667fFEWMf4YvH+LoVDf+f33Udzf6qtC3Pinwli3ffJaIpLAoB3emeXOUKd0QOHgIi1wpBw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(451199021)(86362001)(8676002)(8936002)(6916009)(6486002)(66946007)(66476007)(66556008)(4326008)(5660300002)(31696002)(36756003)(38100700002)(478600001)(83380400001)(2616005)(26005)(41300700001)(2906002)(186003)(316002)(6512007)(6506007)(54906003)(31686004)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QnFzQkVDMU9tNzMwKy9DM2tIUEJsWHhwRCtnQ0dGNXRmR2VPZG1DbkVySzRq?=
 =?utf-8?B?QUszNDE4b1NDemNsd3VaNU1XMFQxaXB6NytxRWdLMUdKbEdiTWFoL1lCbTUv?=
 =?utf-8?B?RGQrT0JuZGpZQVN3Si9sMTFpemxNc0h5TS9MU1dZMmhTK2ErRzBnYlR1cEMx?=
 =?utf-8?B?SFBqdVp6eGxEeUo5WkdIU3J3MWVWeWxoMk9KQitjc1lnK2hqM1AvWG5KVFY4?=
 =?utf-8?B?WG5rc29CQWFab2xPU09HTytMVUFQVVpObnBIdHg1MUxrRDRmRDBjSTQ0TTF4?=
 =?utf-8?B?ak03L1hrTHJ6S3BTVCt0elRvQVhmd1MzRHBJT0Y5YjNjN0w4Q0FKbFEwRDBt?=
 =?utf-8?B?LzBsMDJkaTdzUnpScjV1a2VrWGRhak9SVEJQczBjREFrckF4R2laOXg4Z2xB?=
 =?utf-8?B?TUdPbXBsUktKSHFKL1hPYW4yWk8wVkQwN0o2cFNTRSs3UUxLWmgyUmgyNllP?=
 =?utf-8?B?ZzByNkNuM2JDYjQ1RlVjTE9taG1kNUlsd1hSaVdiVE1TenJYZUhrdURUZUdN?=
 =?utf-8?B?emp5czNUOERTTStuMmZLMnYyUVd6NkZEVS9hQ1JFQS8xQWEvT1A0QW5CeXdr?=
 =?utf-8?B?Q2xOWk4vS2FWcmJRZXIyNjltQ05aNWpicDEreFR6SExBWDNtbEp5QzZ0ZGIx?=
 =?utf-8?B?K25WS2MwOFA4dWc5T05ra2x2NGtCc3YycWtVdUY1aE5hYWJpMTQzclpIaUx3?=
 =?utf-8?B?UVpMbjhBSVhDTm1GNUc4NE5DK2swc0VNK2hFWUlPeVFzUnRzZ1dZaDhFSjYw?=
 =?utf-8?B?VDduVXdSakw3Rlh4eUJkZFVDZjhJUmlmN25IOWRpZjFHeGo2eHllZmNzVnFN?=
 =?utf-8?B?cjFSM2FjN1hwNDJSRldnZEhrTmh4Ri9xRU43dlFnbiszM2VuV0FpQWc1Mklu?=
 =?utf-8?B?OTRLQldySzAvVHl2UHVITkF0Qm5OZFpFdTJ0TUxvYllvOWMxaHRiRmtycEto?=
 =?utf-8?B?K05mckZDWEVRYXBYWTFKZ3JROWxNVWJoUVdENHIrcXREbXRaZldkaWJlLzlx?=
 =?utf-8?B?RFZLcVFGWDk1cTZrYkt2c3dqOElHSC96TE1jYTVSQVlpUkQ5Q053NkFma2Q0?=
 =?utf-8?B?dlV4emhKekZhaHVneEh2ZCtqSG1tdm8wSG1qbTlaQ3FWSTMzRGlRa3VZOXQ5?=
 =?utf-8?B?dnNacy9ZRjIxeDluenQ3aTNTTW01dGNvVGxjaTZSNHdLNm5ZMTluNVVPbVRr?=
 =?utf-8?B?bldENE1Yc2s5eDJ2MEswcENIVktUNDJIcW9wWjE3RjZjb0srTlEwdkNCVG5H?=
 =?utf-8?B?OGw2UFRGWVZGNWtiakZBM1J3NjV0TTJ0bVorQnJucjhyVjlDbWlOc1NPNGtC?=
 =?utf-8?B?Ti9HM1B5NkI5aXQraEJwVkU1MCszOCtIdTI4NmlBM1NzRnkrTXdmbUNCWlRn?=
 =?utf-8?B?YzhvQmgxaUN4ZDEveURqNjQwMmhlVzBCLzArRFZmdHQzZktsOC95VlVtWEtG?=
 =?utf-8?B?ZVFtOXZWdnE5aFdHcVUza040UjJFcVJEdTZrQ0xPcjB3Uk16THh1ZTlObWpa?=
 =?utf-8?B?dWFBS3hvNVFIREp5RXM3Q0w4cVFWOEYvUk1yM2laSTV1ekVXVmg5b0M4Ukhv?=
 =?utf-8?B?MUhldDhhWVRuOFJSZm1JNVdabGZ0RGtmV0Fob1NqMkFpODJsUklBdWd3UDNJ?=
 =?utf-8?B?WEtTSlJlVmlOVTJUV2VtSk5UbnJsZHJ1WXNEdUlIMUlNNkdEZEFBS09jSDNo?=
 =?utf-8?B?OUZkNnJ0Y2wrUkJmQUptY2J6WDErUWRva0hURmVueFhCTExwWHRkQlFKc1hq?=
 =?utf-8?B?cXpJbjdUR09hTzM5YThkYmNxWmp5RktxamIxdDJ0WThjOXFLb29JM3ltbmEr?=
 =?utf-8?B?MzBoNG1IdWdjWHlSSHV4cFNmUHVOQVlpamZ5SlluMWRidnpHeVZKb2NRTzhn?=
 =?utf-8?B?emRxZ3RxTkxoS0t4MnJOOGdiSzQ4MWREUUM5SG0rRDZZWGMyRmphd21iSkhY?=
 =?utf-8?B?NzdpNHZOcVJMQmtNOWd1WFpFSmpORHdXZUxZVGt5cjA1V1lJYUVkOE1JZEt1?=
 =?utf-8?B?STNjWTArMGIyU05WMGN0bTdXQnpnWS8yS3dKV2FCNFpYcnBkd01adGpPWVZn?=
 =?utf-8?B?ekhpQWxiRm5lRU5mMTAxeFdXWDRTVEFRVG1sc0JxU0FVVU9ZVW45MTVmRDE5?=
 =?utf-8?Q?wESGpbZqGFiDUGAceedy00Qwn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f90a787-3e77-4643-d04a-08db4e2a8ced
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2023 12:08:06.6772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iMXt3A6k1oOmPTGnSdHcg0g5iyH6nTCqpdNbX9gv0/r7s3uv5wndoF0PHHDjyRvQH13OsvVahoSO1MBOn8ZJIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4491
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023-05-05 p.m.10:33, Xuan Zhuo wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Tue, 2 May 2023 20:35:25 -0400, Feng Liu <feliu@nvidia.com> wrote:
>> When initializing XDP in virtnet_open(), some rq xdp initialization
>> may hit an error causing net device open failed. However, previous
>> rqs have already initialized XDP and enabled NAPI, which is not the
>> expected behavior. Need to roll back the previous rq initialization
>> to avoid leaks in error unwinding of init code.
>>
>> Also extract a helper function of disable queue pairs, and use newly
>> introduced helper function in error unwinding and virtnet_close;
>>
>> Issue: 3383038
>> Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
>> Signed-off-by: Feng Liu <feliu@nvidia.com>
>> Reviewed-by: William Tu <witu@nvidia.com>
>> Reviewed-by: Parav Pandit <parav@nvidia.com>
>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>> Change-Id: Ib4c6a97cb7b837cfa484c593dd43a435c47ea68f
>> ---
>>   drivers/net/virtio_net.c | 30 ++++++++++++++++++++----------
>>   1 file changed, 20 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 8d8038538fc4..3737cf120cb7 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -1868,6 +1868,13 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
>>        return received;
>>   }
>>
>> +static void virtnet_disable_qp(struct virtnet_info *vi, int qp_index)
>> +{
>> +     virtnet_napi_tx_disable(&vi->sq[qp_index].napi);
>> +     napi_disable(&vi->rq[qp_index].napi);
>> +     xdp_rxq_info_unreg(&vi->rq[qp_index].xdp_rxq);
>> +}
>> +
>>   static int virtnet_open(struct net_device *dev)
>>   {
>>        struct virtnet_info *vi = netdev_priv(dev);
>> @@ -1883,20 +1890,26 @@ static int virtnet_open(struct net_device *dev)
>>
>>                err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i, vi->rq[i].napi.napi_id);
>>                if (err < 0)
>> -                     return err;
>> +                     goto err_xdp_info_reg;
>>
>>                err = xdp_rxq_info_reg_mem_model(&vi->rq[i].xdp_rxq,
>>                                                 MEM_TYPE_PAGE_SHARED, NULL);
>> -             if (err < 0) {
>> -                     xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
>> -                     return err;
>> -             }
>> +             if (err < 0)
>> +                     goto err_xdp_reg_mem_model;
>>
>>                virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
>>                virtnet_napi_tx_enable(vi, vi->sq[i].vq, &vi->sq[i].napi);
>>        }
>>
>>        return 0;
>> +
>> +err_xdp_reg_mem_model:
>> +     xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
>> +err_xdp_info_reg:
>> +     for (i = i - 1; i >= 0; i--)
>> +             virtnet_disable_qp(vi, i);
> 
> 
> I would to know should we handle for these:
> 
>          disable_delayed_refill(vi);
>          cancel_delayed_work_sync(&vi->refill);
> 
> 
> Maybe we should call virtnet_close() with "i" directly.
> 
> Thanks.
> 
> 
Can’t use i directly here, because if xdp_rxq_info_reg fails, napi has 
not been enabled for current qp yet, I should roll back from the queue 
pairs where napi was enabled before(i--), otherwise it will hang at napi 
disable api

>> +
>> +     return err;
>>   }
>>
>>   static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>> @@ -2305,11 +2318,8 @@ static int virtnet_close(struct net_device *dev)
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
>>

