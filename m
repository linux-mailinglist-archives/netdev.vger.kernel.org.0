Return-Path: <netdev+bounces-3051-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C484705413
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 18:38:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 111BD1C20EA5
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 118C3882C;
	Tue, 16 May 2023 16:38:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCA3881E
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:38:51 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0EF18E
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 09:38:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G1OfVPBFTKxowqcpyltRuhOb3H/OCgNHOq2pqROBG8Vf+Ki3ekaY27nT19HVU2wm9sneFvzj0ONc+K/bCGtXDUoASMORY2b2GmFGXfOs+p1bx4/e+wT6/r3iM4pqlli3KYEPCLweUbr1dVist0svoaFj+2OWIeqEbqEL4lfLwP3tFbCY4LD2LFkQK+Km6UsnZyRxqzUTlJLK6tTyrJNtYm7ZlXQLTCbP2pJPWo/IoYv+yneIxCbgV10vipM9KQ3S/QhNGiMQMQts986Ybs15L3QsrX5r0ZYNhMWRqJWWmy9c+Dtbktjm16U+V1gpHDVNL4wYhu1tanEDGYHBm+Ga4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ldi34/4cWsX80hniFkZ5Z9upM7J22cMbJ0lnZMi4e7Q=;
 b=g/KA97VfOvRaL6SXUNnD19nEfjYEKoFm2bIzIpFGJWG1fAKIa76R5J1jc3GAwdOXlf0P+hbOavJM+sWKCQh49TYNDDJPI2pZ1S5kjoSMsZj67Netnx5Mnz0NtqdM8ATkok+oi7DJsQki52TYuXzG0P4WsY5HMIoeDr8lKMO3pAcHsDz9mdJSWByECfHEOeOxPEZBYbFUZnXH+wb0oVEGW1+4gnEIWIWtefEdT2hQshWNL0AOw+j7UnWtWFktEfoGgmw59gYAUsl4d3x+j0ErUxixvAwJcZYeQfnkdmgofWs86xkXCXajDYa6vBs1IJZBw0exK1GmB7nYnyIO9Hx3Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ldi34/4cWsX80hniFkZ5Z9upM7J22cMbJ0lnZMi4e7Q=;
 b=D7yhdJ2W3vI9EXei/pdW0iCWDE6AKjUEkkTl/XiEarhRWw1xvbIBWQYUWXTv6U+kRbFodR3hU5KZMuBkaWn49ThIJJZpoc3786rqsAQXW8/AVBw+8NhI45ehYyMvicrezorsqq4rr5WtsHaD6dumMJ5XkBLubvCfR4CXzwzpi5A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CH3PR12MB8186.namprd12.prod.outlook.com (2603:10b6:610:129::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 16:38:38 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc%5]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 16:38:38 +0000
Message-ID: <913aa1eb-2af2-cce9-29b0-d872b1986ac5@amd.com>
Date: Tue, 16 May 2023 09:38:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH v6 virtio 04/11] pds_vdpa: move enum from common to adminq
 header
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: jasowang@redhat.com, virtualization@lists.linux-foundation.org,
 brett.creeley@amd.com, netdev@vger.kernel.org, simon.horman@corigine.com,
 drivers@pensando.io
References: <20230516025521.43352-1-shannon.nelson@amd.com>
 <20230516025521.43352-5-shannon.nelson@amd.com>
 <20230516020938-mutt-send-email-mst@kernel.org>
From: Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230516020938-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0178.namprd03.prod.outlook.com
 (2603:10b6:a03:338::33) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CH3PR12MB8186:EE_
X-MS-Office365-Filtering-Correlation-Id: c8157b64-7179-43d4-301e-08db562bffb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JjFZn6deOTpMt1Flc93AIUGToj/QZ2G9l2ejUz0lAVWeauZW1LjP6CONxFwg01H28tBXSyavva1PXrHITPOrs/1m8AntbTPfL5R+AhN5ZsiLy6FPbeHvcl143+HdLQyfuzaK1cZW7vOZ4XvJcqqp0h+qrUqkfk9yAVNv602s0G8sE78ZsNLYKRohgw9f9QoKDGUlFXmrlUkO8PV9dke1+whHSQ4Eq2dvn16d+LVtY9jpeV2AtDmlQ0kgLIcs1HEWrgVrcBDLwK/3w0LjRtCmbkjVR7c3pTHABQX9aQr5STb5Ax9JJ1tImLmuT5bx70WBqNoAV+F06LC1+cA4+ilB5SFg2wHjHZ6sZxXybuc/dMhbgpsZmexOGKUOb4MxrXabs7LeheU/wnhB2zrCNerASgAU/7VvGFiCD4d9v88rkKxAzc8ShiZCVlkKQEvfC/qF2X51nI13CiVNUNorPKhLTi+UpWPOql64nc3eOnDcRRlD5Lfr0MlnOWEds5d9YLaVFsXQtWOygyLxp4VdZqzUbpbveNhJ8wa8LMg0TIOrB2id1GWExWmOAu9h8x6QRZ08Kcjre5ERY60qQ7aOcFayFAs+C2zLehmHaTLFCgGtnCNOg+o9pFURCnuGxCBn64m8Y3ESjf0T9wsLfTunh+9PGQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(366004)(39860400002)(451199021)(31686004)(66556008)(4326008)(66476007)(478600001)(66946007)(6916009)(316002)(31696002)(36756003)(86362001)(26005)(83380400001)(53546011)(6506007)(6512007)(186003)(6486002)(2616005)(41300700001)(8676002)(44832011)(5660300002)(2906002)(6666004)(8936002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3lOZHZXS09sZDFHZ3l2WjY5OHNUZmpPblBsRi9kQTB5aHZVZ08ySWRYem5L?=
 =?utf-8?B?Q1dEVUp1RktUSjkyS3M0T0NtSm5DUHhuUzlEOEVPVGRKc21JZmJlMjJzK1NB?=
 =?utf-8?B?dk9HeHZ3SjFQS0RXVXV4bzFRQ3hiU3d6VUVDaVdXOXZzWkFtaXY2MmZTYTd2?=
 =?utf-8?B?WVZtQ1FDbnlIS21BRU5iZWNwMnJxK1h1UTdMa0Q4S3hNMkp6TEhWM3dobDdZ?=
 =?utf-8?B?TVo3VWNJZ3UydnFZYzhQUlNtWkpsdHdsMFNzQmFEN1hCVHRBdU82eE5VZUNS?=
 =?utf-8?B?Q1R0UUQwZ2s5MEwrMnhGZjM5ZCtuKzEzMng2OGFzdWVvU2FaM1h2eXU4UVZY?=
 =?utf-8?B?WlBYOXhrTjI5b2JxaWhVbmxDUGlpWVplcjZtQXVzSGQxd2dYZkRvRVRndkUy?=
 =?utf-8?B?MEEwckNycEE2Njd1bzV2RTg5WXIwSXlMS1J4dmtXcUpJVCtVVzRienNmbGtl?=
 =?utf-8?B?YlIyb1hMdWNPVlF2bG90QVdzM1FZREU5WW5yNUpDOHFLaTVhRmpDRWFDbENt?=
 =?utf-8?B?SnBMMDR6WkVNV3JwTUhZOG0vSXNaZUZOMUZ3VEJQZjY5OExMTWxCcVBCblpl?=
 =?utf-8?B?WWNLVWljUUQxcDllOTJ2ZGd6WnVMREEzRGpYYUFROG1RSEovOFVuTnhhYXRh?=
 =?utf-8?B?bGRQSTlTQTBOaUVpTWsyMkFOc2hHRnhTOVBnQlFwbHFwYVV2SEtlZnM3amNr?=
 =?utf-8?B?MDJVRWdCVWVEbzhsRWgvelRLWXZuK3JFbVZQMFZ1eXVaZzk0eFZQZVpKMkZV?=
 =?utf-8?B?bnFGRlVBdStHSDJyMUNvNjZOSFI0VVc4bWhmY2NkclBxZzZXeGhHcHA3REpa?=
 =?utf-8?B?UUM4N0E4NW1OQWZFelZJUHZDcUNrZ3B2dG1lTzg4eEx1bW1xVlUyd0xjekVU?=
 =?utf-8?B?MDQ5Qms3bzRMQ1JodW01ZmNQenZRcmZOZXF1QjJiSkhkK2IyMWQ1dkUxdmxn?=
 =?utf-8?B?eU1VWkRFMStTWFRNQTV2amN3enJZVUhYeHdwdThpQkhXc09nWTRrZkl2RXd3?=
 =?utf-8?B?RGtkMStXL1QrSWpqdEY4OXZkdFFqdUhkK2hSUHBCNkRLTlVvRFFhYUVaRUQ4?=
 =?utf-8?B?dHFpQ2l2Q05vUUtLOFMvZ01TbGkxOFYvSk9UMFRjeU15dldUaHhyZU15VXVH?=
 =?utf-8?B?ZENDdnA1YUJiSmpOSlF1cVVSM0pycjE2cmN3eUJXR2lWbkJtRC9GbCtCMkRY?=
 =?utf-8?B?VU1vL3JBbTQ3VTR3SDROSHJkMStJZ1RzOWJmMzJBbldDMEdIN1pvNXlNRFZQ?=
 =?utf-8?B?eU81N1hTc1ZYcTFLQUNsUzBDM3g2UDBKdzdFNUdJalFLS0FxbXppV3RZbjdP?=
 =?utf-8?B?NS9FRzBQbmxaaDdXRzN0T1IrWGQyUmpCdFhqbmRWVHhtdG5kQXpQYk5mdFJr?=
 =?utf-8?B?VStUR1c2NmZmSlJodDlBbExmRmRqbEtBZUlkdWlmaHdrb2xLUk9aMk1FWmkw?=
 =?utf-8?B?NmNjWXpoZ1JTb1NJcmx4LzRDbi9zNEtLZFg1cEtkZENQWmdVcU1SbkF0L3dM?=
 =?utf-8?B?aHh6YXdrUEE5YW5Qd25OYndOckxGWTVGMU9ydHNIbFBTVGdmYmNYRnM5UkV0?=
 =?utf-8?B?R3lOcVNhVzhseGlFa1FkM1ZiOTF4dll2WXEvS01jUVFzamY0cGdaN2p1d3F3?=
 =?utf-8?B?ZVg4K2krOEREODhXN3BVZXNvazB5eE52cE1sWWFTTVBMWk5tY0pVOEhpQzFB?=
 =?utf-8?B?T21kbm1zZysrZDdacU95OVZhNmpTYmZveUpEQzEwMWhzZU1JQkxSbUlDM3NU?=
 =?utf-8?B?alU4eURRN2UrU1RHU3F4dUZJd01NR2RQaWM2eXpqOEZhNTV2OEVpSStwVnEz?=
 =?utf-8?B?SHhlNnBqUTM0ZGUza2ZiN0g5OXBsY0hFQVl4SWQ0cTV4eCtwYzFmOC9qVVQv?=
 =?utf-8?B?RElOYjdlZkpVU0kyakY3TVVwL2dVOW8yUGJ3azRVeVBjNVh6SzNWUnYwakNm?=
 =?utf-8?B?cFowaE52dFZYcUYrVUxIMzhSNFBRVDYrb09MaDBkWDd3d3JRSmJoRzRhS0li?=
 =?utf-8?B?eS9hZTFVQWE0MWxDZHJvQUwvU3IwU0NONml3WTd4WGpRaUlEOHNOUFE1Zkdr?=
 =?utf-8?B?UVlVVUM3MHhkTUtyVFYyTm9JMjVGdkVSTDV1QnNJbkpDRVowWFVkdkY5RHh4?=
 =?utf-8?Q?LNHx7uxsDDzTcbD+taREqqoU6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8157b64-7179-43d4-301e-08db562bffb6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 16:38:37.8381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Csb0+KIawhE4o53X9oJpbxuI9tXm7ggJ6cw3zjsXN4A3f6zGTCBCH8H5e7bAyPr/ByK7jPV8aQmxn3ejQ5+uwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8186
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/15/23 11:12 PM, Michael S. Tsirkin wrote:
> On Mon, May 15, 2023 at 07:55:14PM -0700, Shannon Nelson wrote:
>> The pds_core_logical_qtype enum and IFNAMSIZ are not needed
>> in the common PDS header, only needed when working with the
>> adminq, so move them to the adminq header.
>>
>> Note: This patch might conflict with pds_vfio patches that are
>>        in review, depending on which patchset gets pulled first.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> Acked-by: Jason Wang <jasowang@redhat.com>
> 
> It's a bit weird to add code in one patch then move it
> in another. Why not start with it in the final location?

Yes, and I usually try to catch those things before they go out :-).  In 
this case the chunk we're moving was added in the pds_core patchset a 
few weeks ago, and since then we have realized it would be better to be 
localized to the adminq header.  Perhaps this would have been clearer if 
this patch came first?

> 
> More importantly, the use of adminq terminology here
> is a going to be somewhat confusing with the unrelated
> admin virtqueue just having landed in the virtio spec.
> Is this terminology coming from some hardware spec?

This firmware adminq through the PCI interface is similar to how several 
other network drivers have an adminq for more complex conversations with 
the FW.  Yes, I can see how having both this device adminq and the 
virtio admin VQ in one place could be confusing, and we'll need to be 
sure to be clear in the difference.  This is part of why we put most of 
the adminq cmd code in its own cmd.c file, away from the virtio/vdpa 
handling in vdpa_dev.c.

Thanks,
sln

> 
>> ---
>>   include/linux/pds/pds_adminq.h | 21 +++++++++++++++++++++
>>   include/linux/pds/pds_common.h | 21 ---------------------
>>   2 files changed, 21 insertions(+), 21 deletions(-)
>>
>> diff --git a/include/linux/pds/pds_adminq.h b/include/linux/pds/pds_adminq.h
>> index 98a60ce87b92..61b0a8634e1a 100644
>> --- a/include/linux/pds/pds_adminq.h
>> +++ b/include/linux/pds/pds_adminq.h
>> @@ -222,6 +222,27 @@ enum pds_core_lif_type {
>>        PDS_CORE_LIF_TYPE_DEFAULT = 0,
>>   };
>>
>> +#define PDS_CORE_IFNAMSIZ            16
>> +
>> +/**
>> + * enum pds_core_logical_qtype - Logical Queue Types
>> + * @PDS_CORE_QTYPE_ADMINQ:    Administrative Queue
>> + * @PDS_CORE_QTYPE_NOTIFYQ:   Notify Queue
>> + * @PDS_CORE_QTYPE_RXQ:       Receive Queue
>> + * @PDS_CORE_QTYPE_TXQ:       Transmit Queue
>> + * @PDS_CORE_QTYPE_EQ:        Event Queue
>> + * @PDS_CORE_QTYPE_MAX:       Max queue type supported
>> + */
>> +enum pds_core_logical_qtype {
>> +     PDS_CORE_QTYPE_ADMINQ  = 0,
>> +     PDS_CORE_QTYPE_NOTIFYQ = 1,
>> +     PDS_CORE_QTYPE_RXQ     = 2,
>> +     PDS_CORE_QTYPE_TXQ     = 3,
>> +     PDS_CORE_QTYPE_EQ      = 4,
>> +
>> +     PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
>> +};
>> +
>>   /**
>>    * union pds_core_lif_config - LIF configuration
>>    * @state:       LIF state (enum pds_core_lif_state)
>> diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
>> index 2a0d1669cfd0..435c8e8161c2 100644
>> --- a/include/linux/pds/pds_common.h
>> +++ b/include/linux/pds/pds_common.h
>> @@ -41,27 +41,6 @@ enum pds_core_vif_types {
>>
>>   #define PDS_VDPA_DEV_NAME    PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_VDPA_STR
>>
>> -#define PDS_CORE_IFNAMSIZ            16
>> -
>> -/**
>> - * enum pds_core_logical_qtype - Logical Queue Types
>> - * @PDS_CORE_QTYPE_ADMINQ:    Administrative Queue
>> - * @PDS_CORE_QTYPE_NOTIFYQ:   Notify Queue
>> - * @PDS_CORE_QTYPE_RXQ:       Receive Queue
>> - * @PDS_CORE_QTYPE_TXQ:       Transmit Queue
>> - * @PDS_CORE_QTYPE_EQ:        Event Queue
>> - * @PDS_CORE_QTYPE_MAX:       Max queue type supported
>> - */
>> -enum pds_core_logical_qtype {
>> -     PDS_CORE_QTYPE_ADMINQ  = 0,
>> -     PDS_CORE_QTYPE_NOTIFYQ = 1,
>> -     PDS_CORE_QTYPE_RXQ     = 2,
>> -     PDS_CORE_QTYPE_TXQ     = 3,
>> -     PDS_CORE_QTYPE_EQ      = 4,
>> -
>> -     PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
>> -};
>> -
>>   int pdsc_register_notify(struct notifier_block *nb);
>>   void pdsc_unregister_notify(struct notifier_block *nb);
>>   void *pdsc_get_pf_struct(struct pci_dev *vf_pdev);
>> --
>> 2.17.1
> 

