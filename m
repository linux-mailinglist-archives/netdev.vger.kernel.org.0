Return-Path: <netdev+bounces-11542-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BDA0733845
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:42:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7495F281853
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7856D19521;
	Fri, 16 Jun 2023 18:42:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2B0171DE
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 18:42:20 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C5530FB;
	Fri, 16 Jun 2023 11:42:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l97BMWpY81oLZlOpxhWkadk20gk47tTXQobGKcTzxS3rcViyu8MIcgUoMzW+M8yXdakmRLNdOb3wsbtpjiUHtkYrzKgrlfYR3lbmZTD4lax0TzjfQ5YPaXdZdc/6lDtxmSlb2o+ZmYuzrsMoODlnIxbvb4uI2bkaXVkm3HBDElc95gaI1srCOiEoAMdqWjA28fjXQ5c0n05l2i2HkfvaRqiyqoc3kO5cmbA/2vpZXQW4AIUjYqmfgScPicgkQiSnKyTZt9UtNjQKPQwZiTiG0jKHMR6dYjcilipIGaCDJ/xk+zbDg3CVWKOqhs/5I3a/HmlgHC4zpXpfIdFAHIEM1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0EBTYl1TWaQPOxktw6uCghcmmExaj0gwOCRGJueeOcI=;
 b=MG5tztUCkiVFpIzSBIqcrMwxTmuGgdvvM6JkvRFdpLyq8PiLJ9sfQ8t4JaqkAxhNwQiqygOEyMxG4sYNVw1TqDYdP8GbUvqyUlX60uImIr4cy1qoutH/pJextDWo1UC5XxtE6X30B1uHg5kCIECjP3Asu6NUnuiOzRG9MCAqylO4FqPIw+3Iwcg3vp/4F0FbeKARczGqM1+fWG9xItPGF2BXXIH/V/Tt9F63JFaJJwtn4c46wW4RquyXqcq9AYKa/lNLDMe3wtUZ1aTH+PCrO1Wnsvx+aVPodewu+qa7b6zA0PnRHeGhudveLqgqGKhJfapeTIkW2iXkN7aKrRxNVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EBTYl1TWaQPOxktw6uCghcmmExaj0gwOCRGJueeOcI=;
 b=sN5ivGxKRv6J4ZIp4SM6lsmNhEMhOV3wM8qiXbpjNbkvhDYXSFW8aoKXDt6cObOGo2QkvJUMz56rshprvq+j9BO9lOpFKOwsFN37MQsfg3n34RBAYZXITTiCtiieiSrX9ZlOfCKAqxALIW0X3KyQafcJrjDBTb6DYuL/m3uLQvI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by PH7PR12MB5854.namprd12.prod.outlook.com (2603:10b6:510:1d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Fri, 16 Jun
 2023 18:42:16 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e%3]) with mapi id 15.20.6477.037; Fri, 16 Jun 2023
 18:42:16 +0000
Message-ID: <50961ef4-aea1-1866-2ddc-5a3fd1c1a5ea@amd.com>
Date: Fri, 16 Jun 2023 11:42:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v10 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO
 driver
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>,
 Brett Creeley <brett.creeley@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "jgg@nvidia.com" <jgg@nvidia.com>, "yishaih@nvidia.com"
 <yishaih@nvidia.com>,
 "shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>
Cc: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-3-brett.creeley@amd.com>
 <BN9PR11MB5276B2C8E96E080CC828B32D8C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <BN9PR11MB5276B2C8E96E080CC828B32D8C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:217::22) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|PH7PR12MB5854:EE_
X-MS-Office365-Filtering-Correlation-Id: 837c8f5e-a881-4544-be30-08db6e996850
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UkGcSDqTtd3TnwTHIGRe8wKrREL3FVepzpUeTV+ujmvdzvrT6zGLEqJ4GVXIvjNdV8QAAao47iNgwo9Jn32VX2uKlzQVrcEKOSfj6Z0zfmcQ0tFZqO+CdvFUEdqV3ofNlp1lWpWoF3GC5SJaQAjaGvGxIn4ZvkgeLcZJH/wQTnofb4BMtuVqLECj95x3FF+y/70YpFRyTjn9dj35q10GVl4fG0CMWy2GE1pWljNknYdGJoFJf0mVuJHJWSTrmre1r5qpw1nrOTkoligh+3yXW6By6GyMTh3MpdSX6wHTB/k2RALr3oxn15odV6OiYHBTj84jT3IxVUm5nyBR6gMVK4cQJe5sLt8GXEOudo5Kw9c2R+EGsxNDG+/YMRdyNSMHshm3blNN72+qnKqUD32zJZJPCtcC0iwO7Up69zEo8zF4DIpQKEzDd0D9aJsK7yVgyWRiQyXsDDqnofNtL7pV6ei88UugUMDUJNsLNvHKfSiV9eqpLdXpAPYxtNsAb8H8/L1qDZB2nCi9pPvSEpQ4sxXtSNXtV7zUrU0o03Q2LYbqSVdJvhThm/wDJ2CT9YFjeqe+fHzAqu985DbUQf/ODl/RFXt3nBhjqQizlmX0FgA3UVujK2VCNy65n51GkIR1DQ7X9MFG2BI2dzCO0MYW5g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199021)(110136005)(31686004)(31696002)(41300700001)(8676002)(66946007)(66476007)(66556008)(8936002)(6486002)(6666004)(316002)(4326008)(36756003)(478600001)(6512007)(5660300002)(26005)(83380400001)(2906002)(6506007)(53546011)(186003)(38100700002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mmo2MXpJcG5uVSs1TVp4MDZkTFhoS0U5aWxSNVhhTXEzN3AvQ0NlT0xleldQ?=
 =?utf-8?B?SFdyVHZCVE9qTGgzSCtwU0hyME52MjRrcGlBS1gvNk9IOGNra0ZhN2wzR3NT?=
 =?utf-8?B?TUZ5L1BsVjIyOWRxWjVUS3J2SG84dzd2UUc2V3k1alo1MXpMVm5kUkdKWW5t?=
 =?utf-8?B?QXNhN0JlWGdtM1p0Q2ptRmFaZVY3UXRxSmgzRCtoSDA1azF0TkxweXFONUNG?=
 =?utf-8?B?OGV6M1FLdTU3SUVnY21wR2p1VEJtRTBUMXdlYS9wZWJpLzlkM1R5bnVMUWha?=
 =?utf-8?B?S0hjYjdRRko4cTBxZ2tHZ28vUzNFNytrdm1Zam5SK3Q4Rm4wd0VQRnZvYjFv?=
 =?utf-8?B?YmRNNUlQa1JEMXBkQUpVRWNTL2JTTEZFSURHbkRmdjhSTkRLQXJLMHhHbDJT?=
 =?utf-8?B?WVRZQlJOd1RYQ3lxcnJLMEtqU0x4aDlPM25QZXR4Q1ErTExza3JaRUFuRnlZ?=
 =?utf-8?B?amRnODd5cjhONGRTcnltcE8rdnFSVEpBNUFTRjhDckhvZDdvOXdicVR5MERO?=
 =?utf-8?B?WkpTRGZaZXAzakZXZm91dXEzSSt4cE5mSWVWeGtsQWVQOXpmd3M2L2twUEll?=
 =?utf-8?B?cHloMUlmNUxsb3Q3QTFGR3BXdytHUU1iWjZ3OWR3U2JzS0dZNUt4V0dHSW53?=
 =?utf-8?B?V0FKTU1meEJVYUpLVld3MlFWZjBIYzFaOWkxQm5OQ1E2ZEU5RjJPRnRpeE9B?=
 =?utf-8?B?RXp6bHA1dCtqV1JNcTdkWWtHMHJXZDBjSzZ0aFQvNjFiSmNiOWoxdnArbzRP?=
 =?utf-8?B?M3R6NE1nMlNIMGhNZWRsQ0EzNDJjWHhOWEVFSk1YcUNBSGhVL0ltMTNmOXRs?=
 =?utf-8?B?WUZUWVJjTDc3VHM0RStrNVVQSGRGQzIwbmk2b1paVGVYbEJac3NJT2pSMHYv?=
 =?utf-8?B?YU0zcWZEc0k1TkRvQ2N0SzRYQXJjR05sU21UcUoyL090Mm5tQW5xSEd1Q3Nr?=
 =?utf-8?B?Zk5rcXpock4rSlV3QmVWemh1S3g1L2FrbE9LWjVYUmZ6dlluQWwyamVPM2N6?=
 =?utf-8?B?QmFCeW9PVDRRMWJ0OFlSUHdDMGxUcGVwWE53NURob2dDVTRzdkptMVlMZSs0?=
 =?utf-8?B?bVRadzJWRFk5VytndDFKMm1qVDVOK1lsRkRENmZOUEpRT3ZyM3RGMURhQ0Q2?=
 =?utf-8?B?eFNWRkkvTzZWeWgyREQvR1ZZSktxaXhjRktORDZaR1VudksrOXFWeFQweXlU?=
 =?utf-8?B?cGdCLzgweUlIOUk1Ym52a0VJNE1YakdGc2FVMGpmRENrTjdaTkVsbGtvbnRq?=
 =?utf-8?B?MEN6R0FSUjVxVWdKdGJtZHFzUVJHRzBDb1ZFRUU5QzNyZmN5YlZrdEVrVGt1?=
 =?utf-8?B?YUJvemtxak4wbzdOT2hWbWc2QlU5UG1aUGNjMU1jZEVRb1BWUTI5MTYrc001?=
 =?utf-8?B?RmtMQUJWelVZRmlPQjJYVlh3SjFkRFkxN2FOWHpKbWVVb2JNaVd1UjFKTGp3?=
 =?utf-8?B?UjZQbEUyci9KbmtpbXMzQ2pqUVJxVktNakdvRzBYeDIzOUI4Ymoxd0ppODQ1?=
 =?utf-8?B?Y3BDZFV1a1R1UlJwMzJwc20rcTNITS9JQTBhNFNpRXNsSStzc0tzRzh3QVJC?=
 =?utf-8?B?NjBOT09pajEvbllrRGhQeDhKTGViZjFrZ3V1L2tDVmJYTXRLa3h0bTdSQkdH?=
 =?utf-8?B?SXNnTEY5RUZCdzhCM3Z0NnlkWkEzVVlPUE5DaHZyVkw1N2plTlA2UTZMWE41?=
 =?utf-8?B?ZGJSQW9tREIzUC9JdjUxVkNkanh5dmsxT2hBMnJ0c1BlM1JiSDlCMjBta1Jp?=
 =?utf-8?B?dHJOaEJ1VUUyOVRJNVJPR0lQSmM3TWZZdTJ3dVp3K0FDb0x1VWltUFMrQi9p?=
 =?utf-8?B?dFdxVmVqYnlFU3pBOWZlQzNhU1NKK3dwdFNVZXh2cHU1d3Z1bmFNRTg4ZVJo?=
 =?utf-8?B?a2xYalBmTXgxVHpSTkxjS3drYnhQY0o4bUVPV2tWYjZGQUt2eVhaUWlkMzBj?=
 =?utf-8?B?MmFvcjV5N2U3OU1zY2JtVi9NZDJaMlBhVjIweTVBdVM1ZGduN2ZwcTBnZzdG?=
 =?utf-8?B?WW5oL210MFBMd2h4Tk9QUWFDNGIwSWZxeGdlN1hZeDZ1UmFiTkVlZ0wwaGRV?=
 =?utf-8?B?RnZEWWtmT1ZTbHlGK21NbzE5SEpjaE91U3orb014TmlNUFpPZDZCTjhDUWpH?=
 =?utf-8?Q?rA7Q6k1jqIT9UgSe+JwmYQM4B?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 837c8f5e-a881-4544-be30-08db6e996850
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 18:42:16.3311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aKYEnpMzM5iGgLF8x4+cECDmWHjzkIaWesc4/KAj2yxpUjMSasXPnr7SjwuTOb0aDjDkBrham/uuylrgVhNurw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5854
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/15/2023 11:56 PM, Tian, Kevin wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> From: Brett Creeley <brett.creeley@amd.com>
>> Sent: Saturday, June 3, 2023 6:03 AM
>>
>> This is the initial framework for the new pds_vfio device driver. This
>> does the very basics of registering the PDS PCI device and configuring
>> it as a VFIO PCI device.
>>
>> With this change, the VF device can be bound to the pds_vfio driver on
>> the host and presented to the VM as the VF's device type.
> 
> while this should be generic to multiple PDS device types this patch only
> supports the ethernet VF. worth a clarification here.
> 
>> +static const struct pci_device_id
>> +pds_vfio_pci_table[] = {
> 
> no need to break line.

Must have missed this one. Thanks.

> 
>> +
>> +MODULE_DESCRIPTION(PDS_VFIO_DRV_DESCRIPTION);
>> +MODULE_AUTHOR("Advanced Micro Devices, Inc.");
> 
> author usually describes the personal name plus mail address.

Will fix. Thanks.

> 
>> +
>> +     err = vfio_pci_core_init_dev(vdev);
>> +     if (err)
>> +             return err;
>> +
>> +     pds_vfio->vf_id = pci_iov_vf_id(pdev);
> 
> pci_iov_vf_id() could fail.

Good catch. I will for failure on the next revision. Thanks.

> 

