Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E68157928C
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 07:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236527AbiGSFkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 01:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbiGSFkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 01:40:22 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2087.outbound.protection.outlook.com [40.107.102.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCB16586;
        Mon, 18 Jul 2022 22:40:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQZq0+pfAzkyTu7gcD43225g90d6fJkJ+GpOF/Om81R87ivqTR53lgbAvB59qW8yfw1BG5d3dmttwoxRRix513bbd0yfTyu2uwvxPAyFE3gV7MQKhHEl/8u7u+SUJehSsh//NcZrNmfuEeLpBdsu4jizv5EYxBqpUujAW2XP524rSAmEwVDDdUJyNBb27nmTljfuTGtYVC7uy6fL4b0HYq2ogCEKgt1RjYDPnd6zxOyckF9L9TlX1vChbmEtIcnjaKYLA6k0vkKQ2GUGg1zYgpXpV2tFNJMaN9xuD1jR3BgNDsJ7fo+itiDbr1lm7iYpktPNiuR6OgibShqgtwmCsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=siSbUl5fnja9Y1cIoXe+5rvwQUWGjGiKKfSjGcj2P+U=;
 b=ArPIqxiirmh7BC3SMEJeeYrfPRylfRZKRHNjEMJzDIxprJg0gLH5p02Y2VJG+cG+Eah41+DJW7kLPV6DTTmbowLhQVDu6Xot6CelQdePJIIZ6XuGqgO0deVV+WDetWXSLu3bU1q6LcW9cGMQ9HeyBvqfRIrMbzLS8w69SSpnceaPK6pbzmp7tSNR+XFkNIUNkFnUh0i/1YGRHzC0uRkzNJtetJdLaVUg+pYEzYOKAGwH7cUmatwVJ8FSAPsvSV0rE6ZNINdTd+GOH6JzV6+beNTWANAP3KvqQFZH2M3aVOG/iCEr3LWoSo1DzhmXupRuZyOpzho+cHmYSj6d3Holbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=siSbUl5fnja9Y1cIoXe+5rvwQUWGjGiKKfSjGcj2P+U=;
 b=CWqjwzetUz931/wCvfCz4nwx/LXxu7Kpt27nJG3rE/ewLy+JhShQATzajsNIyXco9xDIXkV+word/ap+Q5B1cJ1M1y1h+ij87zcupUg0TyPrXjKTdKdrTY5tqXXX0Ts3a8AHWL48ak+PXChJK156sQ14Xqhe2vuqkYt3ZSl+oj/+IN+/0CDjy/Q22u9LN6G24ih2tEArDDsQc1ay/nlCrXlmiXRkPj7fjXgV+Hnf52DgvOXZcpi0kWEk8RHgmPw16V8ut4gsuQFI7epOiIbtUgy4JnYHRJtoA40eUk35IM3l6TZFZer2EqbUz2dn9Ytch5jhOBg6DsmnSCbc+P+Lwg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by MW2PR12MB2506.namprd12.prod.outlook.com (2603:10b6:907:7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Tue, 19 Jul
 2022 05:40:18 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::e16c:261d:891d:676c]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::e16c:261d:891d:676c%4]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 05:40:18 +0000
Message-ID: <692a0d74-9ef4-06b7-c9d6-3d88820f5160@nvidia.com>
Date:   Tue, 19 Jul 2022 11:10:04 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>, Neo Jia <cjia@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Shounak Deshpande <shdeshpande@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-4-yishaih@nvidia.com>
 <20220718162957.45ac2a0b.alex.williamson@redhat.com>
 <BN9PR11MB5276B6658EE0BCE9F2EA52F68C8F9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <BN9PR11MB5276B6658EE0BCE9F2EA52F68C8F9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXP287CA0017.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::35) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 030d5e1c-1903-4722-dcf6-08da6949298b
X-MS-TrafficTypeDiagnostic: MW2PR12MB2506:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ozuZOd+qo1aDG724tkx44NtNy7rg2rU4xisCEFLmQO7CNkzQIGmKyaxRkWfs3Hm+G+ne3gnwcq6cJkbZMbi6NtsdlhhE/DyrKJ5KuRKTEkJ5A48k44KmuyJw9TzS+9iB77o86yXjG0NgzfCr8nZ493f+rIl/OQG/ldcE0dHbU+7IgemaYX4cZeBoUj3OGoYeQNelKUvcdozJAeNEOI8R6UxYe9kfwqpGTS5mpi0+lkIhFBCt6nUCT5WNRXGMY+kOGG6OKcyWRDveDadQR0Q4FrqOvm3aAJcfaBRD64s8x+P12ffw7ef6GLEy5tlqobjYmjOIEpFq9AP1hGtOorzucd5kWbujKHDVzw+QXOSaS0dTvxCLEwv0DOE3UO2UqEyQKsnvET7pojYgdx9ADAOrG5vUxT8BTrmmZ8SpdJawibaRsHvsX+Szj/o8aCN38lS/OB7EsQQahmWHtUAbz70xC3yCdRQ5e14Asei4B5Bepgana2PQ4DE5AIREAZEffHZZMZunrs8ta8eb69gvSwvCZ8Lce8baJBBMa85eGBhgrpSvl0yBWogeClmo4J3pYBrZRIPdmyQbrNw8mMI5VTHh/N3x9XHEby8ddp55bDmtFhBUYzp1nJgX6orSCp+ufwQYSmSNkjMwZQbSjenlQ23H1xsgJdh82PfGpNMVjzR5S+P9CR0IvCE9QuWfaLa7QmZGbNE2AS777uW/jJgOlDhOytW4+4K9jd75QRZ5+UM7DNUlb9LXfxpF0Jd2BEtTph/TWZnR1YH1QzjP7dAOUBETz5aPyfp5eS/8QLODhWYF4XTV+XJm7w8k31oaIcxbDtbvmgyMcf9Bunr6JIPGJ166w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(31696002)(26005)(2906002)(5660300002)(8936002)(55236004)(86362001)(6512007)(6506007)(53546011)(38100700002)(6666004)(41300700001)(110136005)(2616005)(478600001)(107886003)(6486002)(186003)(66946007)(54906003)(66556008)(316002)(31686004)(8676002)(6636002)(4326008)(36756003)(66476007)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RkwrUTZ2bzFrS0hEZU5FQjI4Qjk4QlJlY3JlSGVaenVoZlFXWlpuSllOMlc5?=
 =?utf-8?B?MnVrdUxoK3NaU1NibkprNW9BYndPUC8wazMrc1I1UkcvdUovU0tCUlYyM2gr?=
 =?utf-8?B?b0lEdWljNEVYbGowUFZ4eUR6Y0xmNHJxVnZ5VEc3bk03dDZQWmRENXJQV2Vp?=
 =?utf-8?B?WWJtbmpUaGFPbW9WOEF6cFVJcDlnV1RJbmQ5elJrbzNRaFZISDBTUHlhSHlu?=
 =?utf-8?B?d2UxZ01ObFVwTmtDQ1RIWEg5Y2l0Q1JTOVFmM3Z3R0F3Y09Zci9yNE1VdlJG?=
 =?utf-8?B?MEdrY2I3WmsyYnlXYXNHZVBmV2FXQnVJcDA1S1RxNThQa3paYVJ0c3N4azhP?=
 =?utf-8?B?NENoWEhhb0xtT01IMW5PL0lHSVR6emlRSGt2MUJlOUNrLzZ1M0RKL2RVZTlX?=
 =?utf-8?B?NVpkekdoclhJOUFoQTdWdDh4c25tNTlReFk2d0I2TXBVRmxMRitxc25NUXNZ?=
 =?utf-8?B?TnJnOHB0b3dsL2ZFRVNvcGJESGh4QUVaWGNaSnJLSFE1MjJMTTY5WS94UWlT?=
 =?utf-8?B?cmFENGNvNm4zUk1VRHROUkNZRllTQ05qdlArTE1nd09OYzlCQ05Kb0hQcGtl?=
 =?utf-8?B?REhjWDlyRm9FWldud3V0Mm1UQjdabVg1L3RYZEdoSFZEQVVUWlowVG9vZ0lR?=
 =?utf-8?B?N2xDZno3MW02Qk5nbDBhZEhwSWVlS1hpUkZTa2ZjaDZ6OFlaVzM4ZmdJbFNv?=
 =?utf-8?B?a3NUcy9uc1Vkc0ZTSUNpbXhuRXBSUnRDMHZ5R0p6c3poS282akVGcGpaaXVH?=
 =?utf-8?B?RDlSY2swTXB4SUJsaDZ1VGFjc1VIdjdYRmNlRnFMVWk0dEpEOWZMTXFPVHAy?=
 =?utf-8?B?YTNNUVBuRlN3UVpaWkVZRkxPS0lpeXB6UldkVlIvVnYwbDgxZVVId0srNi9H?=
 =?utf-8?B?WU1CMStMTjR4ZzVzYjJCcmVWdTE3YUNuREhJSzlpWVlJMTdOWmM1aXNmS3h3?=
 =?utf-8?B?K1NnNnJIZC9sdEhqamJjaHUvRjRFdDczWmNvUENibUdMTDJyN2ZlL1dTL2lj?=
 =?utf-8?B?TWtHRXl3L1FCKzNZRHdXazNsdUE3T1pLaXNzMDJPcEs3cEpHekdZQzYvbGJE?=
 =?utf-8?B?VHJkUitHNU9jS01GYXcraTVJOUlHeEZQYWxiRG43WVpVQXIxdDNXZ1RpMk5D?=
 =?utf-8?B?SHk5TWhmbFpKVHN1Sjk0cGdmZzg3bVc5a013dnRxM1ZJUzdvYjQ2YmErR2c0?=
 =?utf-8?B?RUhCclNvWUFETkV0VEtzS21EN0NNZzlMY0lQMFV4WkR0RUNRU25IdXJBTW1Y?=
 =?utf-8?B?d3VSQUJGYWhFeEFwVk5DZkVOOW5TbUl3Y2FnaDBJR1EwbjV4c3F2bWQxYkFO?=
 =?utf-8?B?WlpiLy8waEtkSnRqWjJkWDg1WGhFQVBSZm4yU0NNclZzTGF4TDh5ODFBQWVq?=
 =?utf-8?B?TzBNaWoyNkhiNmgzdzB6aFd3V0lpTkxWTFlwdmFPU1RFSEo1eUlGaytVMmhh?=
 =?utf-8?B?L01FR0pyL3ZBZlllSzdUNGpPNktmTFZQQmM1dndDRjBoTWgwQ0pFTEZwb1dl?=
 =?utf-8?B?YWQxanZsdk5JUDVNS2w0WXF0UUFoN0tkOHhxWDZvd1RpemQ3L3d1eWd5SWQx?=
 =?utf-8?B?OUdGYWxYMU1lbk5wMzdFOWovdVI5Ujk0QzMyc2xEZEVRQ2hPQjRyUS9lWkR6?=
 =?utf-8?B?NU0wNElYSjc4VGVuSU5aK25ranRSSElvUFBWOXN5bUZMbFcvdExoNHhkRXB1?=
 =?utf-8?B?Wkx5anZTNkRwL25YM3NRcVYwalJCRjdYVUF1b1FQUzAxaUJSa1BzaG5JWUJ0?=
 =?utf-8?B?R1U0N1JZQVladmpsdmE2T3pBMVZBZGFMOVl2MFJvSGFwVE14UW1BcFVLbGR5?=
 =?utf-8?B?RGpKVGU2My9LSlZkeG13ZE9WeU9pTENncEZ5OEFTUk82MW5HMEExRU1pK2R1?=
 =?utf-8?B?VTRSeEpKazVncHFGQzJoMGdRL0xLT1dkUUttNUJLVDlFSDBmLzc0SXVkNTU0?=
 =?utf-8?B?cmZRYUNsTEdDM01wUk5GNThMdGhJbkU0bjdTeGhtMkZWMzAwa3N5OVdaVGRR?=
 =?utf-8?B?OHhCUmlLYUFlOGtZaE5zNDlzSm9xRnUwem9Pb3QvbjErZGpHUlVCbzRBT2dz?=
 =?utf-8?B?V2FzVTVQSENBWXNWTlVadzdMbWk0bnRWaVp1eU0reVIyTTc0MnJUZDBnVnVW?=
 =?utf-8?Q?fcM5oxsqZtXa3WmJAdzO7Uvl4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 030d5e1c-1903-4722-dcf6-08da6949298b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 05:40:18.0813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0HNCow+wTfbdpKwCLJ5idYMD/ZxX+wNS0SO//RnPw+LnzSar5dVEeFG0fGrWou1a5LBamIrZ8Y4FiEFiS4yerQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2506
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/19/2022 7:09 AM, Tian, Kevin wrote:
>> From: Alex Williamson <alex.williamson@redhat.com>
>> Sent: Tuesday, July 19, 2022 6:30 AM
>>
>> On Thu, 14 Jul 2022 11:12:43 +0300
>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>
>>> DMA logging allows a device to internally record what DMAs the device is
>>> initiating and report them back to userspace. It is part of the VFIO
>>> migration infrastructure that allows implementing dirty page tracking
>>> during the pre copy phase of live migration. Only DMA WRITEs are logged,
>>> and this API is not connected to
>> VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
>>>
>>> This patch introduces the DMA logging involved uAPIs.
>>>
>>> It uses the FEATURE ioctl with its GET/SET/PROBE options as of below.
>>>
>>> It exposes a PROBE option to detect if the device supports DMA logging.
>>> It exposes a SET option to start device DMA logging in given IOVAs
>>> ranges.
>>> It exposes a SET option to stop device DMA logging that was previously
>>> started.
>>> It exposes a GET option to read back and clear the device DMA log.
>>>
>>> Extra details exist as part of vfio.h per a specific option.
>>
>>
>> Kevin, Kirti, others, any comments on this uAPI proposal?  Are there
>> potentially other devices that might make use of this or is everyone
>> else waiting for IOMMU based dirty tracking?
>>
> 

I had briefly screened through it, I'm taking a closer look of it.

NVIDIA vGPU might use this API.

Thanks,
Kirti
