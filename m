Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C236CF319
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 21:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjC2TYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 15:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjC2TYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 15:24:13 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CCF100;
        Wed, 29 Mar 2023 12:24:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfNMF/iwrbzkYngatcAqxLeCunmjaTVsHI+jxvy3fxOQTV0NVe+gncmTSAaV3ufOnNkFP+5+BnOyo+6000cryS+RnFXwsLSgZfmot6dMnIvp1rqncVM00VnJ27wO+qVkajt0L6oYmKdXZIsHH/Wz7ZaXBRKhozFS8ZOuYCUzqPAt6oYIFIKU+8iPZpBbQCZf5721Pu4UhXu/y2ARD8DV/7DI/i3r4e7PBuKXHepDARtYoYUMOLnWXud6EcfRD5vS0XE+lDfkUBkMv7N668WStEELr8+sH+He/VOb81lil//dqjjN6id/meOUeW2c7lPFTYm2USGzhURljYE92lMWcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AgJ/RYuDixKJGHBLj/ZqvlpP6A4uFjqFB2MEivG6JHI=;
 b=npU6qibeFzMHZlSAyifBa4hbVltJSomqi6w9H344YRMpno4eBplYXatrgRGVcuxm0+LtGFf9JAyloMKoPk+s5/Xj3bYDrAA5beP/oS9ehjnP0DEggRriYbITp8nz/wczm6WmxjTTdjMSM+5VdMdcYLw73wXAMp8vxz5yvhNqVQPorUh70sjf8ZuhwJbYFaoykLRxik7zAtNUuNX5Kzs2M4IVFvyVgp2KGtQv39nCbwoJQ0vRFsrukV2RU1jGlMq597rbJ/EuWDkuHaTDY0W4KKSSMyfDN5abCql3Ibrz1Aga6Z5vi+Ic5KeJbWEjkelqK2m+W54H85p7lBYLER4YJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgJ/RYuDixKJGHBLj/ZqvlpP6A4uFjqFB2MEivG6JHI=;
 b=JHkZRVvty+jMNC61y58faLWMvw5nW0F6/l47BRBZ3PDrvUaFsMdEaEwzOaSEpgr4K5ZQNLiQNs+BlNwOqjndRrkS8zUIZbC5J944YwGsia9Wlr3iOmpGbaTsYABb7MdlNnvD/Jab6m2xPHyKn2P8ekbJqUhU3TzKhEyTda0FLbo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DM4PR12MB5264.namprd12.prod.outlook.com (2603:10b6:5:39c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 19:24:10 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e2de:8a6f:b232:9b31]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e2de:8a6f:b232:9b31%5]) with mapi id 15.20.6222.033; Wed, 29 Mar 2023
 19:24:09 +0000
Message-ID: <0ecf52b8-af4e-172b-bac7-1461d021357c@amd.com>
Date:   Wed, 29 Mar 2023 12:24:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 vfio 1/7] vfio: Commonize combine_ranges for use in
 other VFIO drivers
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io
References: <20230327200553.13951-1-brett.creeley@amd.com>
 <20230327200553.13951-2-brett.creeley@amd.com>
 <ZCQrOeX8WtQplYdZ@corigine.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <ZCQrOeX8WtQplYdZ@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0052.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::27) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DM4PR12MB5264:EE_
X-MS-Office365-Filtering-Correlation-Id: 08600349-fd57-4906-5140-08db308b2b9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vcrty+aryairkbfN56b6bczyved24rNbBFBk1XBeQdqtX6ZWqObAdSk2CNxXwBSDKxsnvPwEVavsJSymEOK3D5VtP67iLX3k7mbU/w9tX/9GAz7o3hxSVKjKJp0h/iciPNPIdIY/CsI13UX3AhFUk6K0bnjVlvpUwEwzkYNdCxCkztqsZj9cNQw6YVdZv3K8QeZ/2T48nhbqtuz/5YsUcJ8kYxDZ6b8tMTwhh1kWmCGxjCVH8/PaUFKZF9GMgg9jwsDM6BkAjMchst9tK9uN90Mmm8kG3HErI+Oilcl9MPKEwE9KolYaDDfwXddZI3Kqm7UY7nvJgPQDkmtzn8wMHjA5ywo5Dqx24nafaFrySr2mg1zHHGZ2Luy1ycpuZHdqd3yvzb1cEOVilhs9YJHt9tanxlGAgeuYKFGaQ6a/lLeAxUe6SBibGByPc1ZisvdJD8bCoVZ4dAtLf1Ng44Ryo+pYdTzJNhJ7e3TXq4Aka9EM8A00yjZmklr6y2W8e65Az7Z9+KippiZOzBfIa8DzyXjHZmRVLuLOan+585IHJ16WCXWF7fhTe83UOns22wMRDJkaAN0LbHWnsVGrFIUobFf+gK4vQzhMrMp+m9o3R85iymDWy1Xmm46BH7NK97z6BK+HdtvgkxV/nhLpEgRQLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199021)(2906002)(8936002)(83380400001)(31696002)(38100700002)(36756003)(6486002)(5660300002)(66476007)(66556008)(8676002)(4326008)(186003)(41300700001)(66946007)(316002)(110136005)(31686004)(6636002)(26005)(6512007)(53546011)(6666004)(6506007)(478600001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXI0Wlp1dkhUTFdFUE45Qk1uY3p2RW95cGROTWpBUnJIOHZaVW0rVG54OVdG?=
 =?utf-8?B?YUVtS2d5M3VPaTF4Uy9TVWFpSXRRR2FmMVVXQW1wTkxJWmpGcklBMml4SkNP?=
 =?utf-8?B?MG1HSkN1L0ZNeGg1R0lhRDJkMThHeHp0d0pLYnUrdE9QL0VKVWlMeVhsMlR4?=
 =?utf-8?B?OVdXaE9CeVRwa2ZXV1lVdDlqVzFYdE54WkhzNUpRNmFhR3lvUW5Fb0FCNWcx?=
 =?utf-8?B?Z2dZNjB0U2xrb3JqSWtQMVM5QVNYVEZ6WXhNUjlqL29EQjVoam5ZVnF6am1O?=
 =?utf-8?B?RWV6U3pmeXBwUjEvQkNzbk10Vm1vYmd0N3FEZFFOd1ZmQ0ZDd3NITjhDbWN4?=
 =?utf-8?B?UUhhbWNwRFRHd2lKb2ovL2VDRi9KeUpBUlc3MkdSWW5aeC9BT3NoaHBBdmlt?=
 =?utf-8?B?SE90UU9sbjFnK0JMNnBBVnc5dnJyWllhb2t1OTQwc292NllHNEY4dEI3dkhl?=
 =?utf-8?B?S3Q1SHZhYS9YUDBVdG5hUTBCUU16YlZkUWlzeU4zcjYxWjZrOERjb2NJdmpx?=
 =?utf-8?B?VWphTFNiT1V4aW5ZMlloSlNqOE1WMVVNcjBwQWd1ZmtEOUp6c1pzTzhCdWFu?=
 =?utf-8?B?d2tFQlV0MCtBUjFmYm5JY1BxcFdLY1JNYmMyZENJdVVPLytWcUhNMHlHWEFG?=
 =?utf-8?B?Rmp4bnIxUmhhN1doNHkxSisyc1NaWW9RN01kTHpRNHd0aTlQcEdZdEJVYUpx?=
 =?utf-8?B?UlVFVkMwbXBzczRZeGFid0h4cHRYMzJTNFh3UVZvWkRNMmpBeWVLWlFock9S?=
 =?utf-8?B?VElKWVZjOHUzYWEvRzV5TXp1U0Q2R3R1RmYycms3RTk5aHVwdHdpUG9FaXRE?=
 =?utf-8?B?Wmw3Q0pnemVzWGtYNUVLKzg1ajhhdi9lb05OQ0xKdmo3ZFBqeDM1c2x5Qjhn?=
 =?utf-8?B?QzVnMnZhRENmeGZucHBHOE1WMG9TbGFYSnRmWjRYeXlwL2YrQlI4Z29FblBU?=
 =?utf-8?B?UzRUNjhwRnhrdkJqM2ROcVVTWVY5SGR3ZEVpVXZrcSsvWW93SEhiUkFjUW9i?=
 =?utf-8?B?T1Y2c3N4QTBmaTdLcTAxbTM1ZGJUbHgraHgrNExmb2tPcmFyczgzdmRzdlps?=
 =?utf-8?B?bi81Q0xtaTJjWUsyelNHTVROMWZsVG1GSE5tcnEzTlFBSTZYTWZWTkozcVpR?=
 =?utf-8?B?VFYyMjdaZkxQVHY4ZTBtK05icyt0a0hSRXEyM1RNbjFTampXb0p2VVlzYytM?=
 =?utf-8?B?NUpOK0I0N0JoczlKR2Jwc2FrRHNMWmZObE5yckFNQnY4eFJUdE13Y3gvbXlW?=
 =?utf-8?B?bi94QTB0a2lKUlhLNWYxTzJjaWZpNktiS1FDRDhhU3pHRVUxZGJsdXR0ZzU5?=
 =?utf-8?B?WGJBMDEyMFZxL25WM3R5NTJaNklNTTJlcEpqbEYvekNnQzhxN2xHcE52ZlZX?=
 =?utf-8?B?TmtrdEgvTkQ0Q3I4RytHSzVIY0FBMWtUcDdFN0lIc3lCZEhrK2dBRm9URjhq?=
 =?utf-8?B?ejhYRnlWYmlqT0JYVmtRVXAvOUh1MFJWYWpJQm1KWTdLQ2RlVGRFVnEzMHJZ?=
 =?utf-8?B?eHVuOThVaFBKVlRoNVloT285QmlmaC9DS0pmMnhueTY3ZWRWREJmMHloNEsy?=
 =?utf-8?B?Ukw2VE1CaHJ0dXlLTlFHK1BZc1BZSTIzYUNudGkySHUzNUlsSEFhYVgxSVND?=
 =?utf-8?B?RnBjanNQakVHNVl0NThuQzVkallSb0N2WjNoTlAzanhBQ1l5dzc3VWFyd0Zk?=
 =?utf-8?B?aDgrMDFkMWlDZVN5cElBZTFIQXFzTS96SVcvSjFWQVVxT1MrNlIxUHJrUWJW?=
 =?utf-8?B?NjN6Mk5CcGlHRy91S0RKcWNUVktuNWZSNDlJelo4OUN2cytyTWk1dVdJUXRv?=
 =?utf-8?B?UVpFRlNyeEpVNG82aU5MK2dCM3VuRjhPMERjTmhhV2Q2d0RJQzNQL2FybDZt?=
 =?utf-8?B?MlByRkFhUzdDNGg5RWNIcUNZekVuVzM5MjdFdkRZOHBRNkkwWlJwazE4bWVz?=
 =?utf-8?B?emk4anF2OEVaSWNZVVRkNVNlL0Z1alU5bERqL2dDRkxiNmd5ckxURU5GUUpP?=
 =?utf-8?B?S0MrMlI2QmE3Sm5hZ2dwY2haSHVPUGNia2QvdG4rNUxXMXl0eHJnVzhoNzV4?=
 =?utf-8?B?Z1BQODNBSWlXRWpxTkkxN1lIQ0hMbnppbnZkVzcvTEtBTXRSWC9Md2I2dmxH?=
 =?utf-8?Q?qPxmS2z/d4F8f5TqdqBoLn94i?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08600349-fd57-4906-5140-08db308b2b9d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 19:24:09.4907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lOmcAPomjLWBxs/fndz3c1J/2+OYn5AkDq/XNiVh304wh9WqEWiXYU3c210f713n/mmDlY2amWDdIiDgyfbYBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5264
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/29/2023 5:12 AM, Simon Horman wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Mon, Mar 27, 2023 at 01:05:47PM -0700, Brett Creeley wrote:
>> Currently only Mellanox uses the combine_ranges function. The
>> new pds_vfio driver also needs this function. So, move it to
>> a common location for other vendor drivers to use.
>>
>> Cc: Yishai Hadas <yishaih@nvidia.com>
>> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Hey Simon,

We really appreciate the reviews and I do have another small change that 
I need to incorporate into one of the patches, so I will include all of 
your feedback in v7.

I won't reply to each individual comment, but I looked through all of 
them and they all make sense to me.

Thanks again for the review,

Brett

> 
>> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
>> index 43bd6b76e2b6..49f37c1b4932 100644
>> --- a/drivers/vfio/vfio_main.c
>> +++ b/drivers/vfio/vfio_main.c
>> @@ -864,6 +864,54 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
>>        return 0;
>>   }
>>
>> +void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
>> +                           u32 req_nodes)
>> +{
>> +     struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
>> +     unsigned long min_gap;
>> +     unsigned long curr_gap;
> 
> I appreciate that this is just moving code from one place to another.
> But if you end up respining this series for another reason
> you may want to consider rearranging the above two lines so they are in
> reverse xmas tree order - longest to shortest.
> 
> ...
