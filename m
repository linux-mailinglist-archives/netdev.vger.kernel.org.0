Return-Path: <netdev+bounces-598-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91E556F860A
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 17:42:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EED7128108C
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18126C2E8;
	Fri,  5 May 2023 15:42:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D0E5383
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 15:42:49 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E672156B8;
	Fri,  5 May 2023 08:42:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cqyxw918tJscn1fEnksBX6Q48fhVsp4zRBAqaU1AnJ2L3rYjZibdduCAj9old7Ip/8e2NMivJa74yX0yvVL+gpu/p1SHe0vPSg3USyaVUvpDKArNxF1C53Wcsdb2PTtlAtOHlsTUTBSfSJhgy5CS2vhMGjoLML9lv9Dx5ZdRZPO3zDUfJYiAX1gzB27fDkoO0h+GzNJbr443iqmgTGmrMAZMCHRE1PjqB4RK6KS2vSezzrTJ9NEwBRpTSpZvRHih8pQOK+AxlQRjKV3hrriUfjrO0sq9CqWEQ29HR+dduhCsEnitLvM5IBMmTus8hgFb9wWvnYLwE28pUaS17M/rag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5gu7VvpG3MxwaonVUNHEZ9iLNBA/aP9kl6WEbVQK6NU=;
 b=S96PRenWKdclQg1IdT6nM+HsrOoGx6bGKfvM+duZOxYhefXeR597T3zq/iXhdcfyQI9VfdTZtAX0Wam9J8O2U/bUCTzmCBWxDucGHM3PErvSIXYej/MbHPceQml4DINb/DlJazPSUDS6dxiYctJa0JlYmM5hveb+mISWZb3jLsAqpO/mCtGMOsWtHXVxBvSEjWAvZ56Q4INfHR5VbunQfJPy6xoetcwNTgaEWKtUmvWB7cT48CZx2nmmmVqLYanavS8zDtSOSlzFNJ99GSOhu+VAwaj7zO5dl3LwMdZu78LaV8zS51VlXhY6Ig23o2rb/3vTXksODq+OAR+eIDTiIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5gu7VvpG3MxwaonVUNHEZ9iLNBA/aP9kl6WEbVQK6NU=;
 b=gW6C5sy4YjhkL9ORSgwfjwqj4nhqCDUSRbSWAXAfPBgT7iPGAU9ef+wv9CBbQy7FIxCnPoEnwTUAJG87VQYUrPMMgM1rqGxiR9j+YglB6p3QtRMYX2SSeVWBGljvrgR1+st9wm1PW5nFt+o/8wRBOXdLK8cc21u4K4XBo4N7Re4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by SA3PR12MB7782.namprd12.prod.outlook.com (2603:10b6:806:31c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.27; Fri, 5 May
 2023 15:42:46 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f%5]) with mapi id 15.20.6363.026; Fri, 5 May 2023
 15:42:46 +0000
Message-ID: <07abb13c-b60e-f35c-8e26-13857a97866f@amd.com>
Date: Fri, 5 May 2023 08:42:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v9 vfio 4/7] vfio/pds: Add VFIO live migration support
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Brett Creeley <brett.creeley@amd.com>
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, alex.williamson@redhat.com,
 yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
References: <20230422010642.60720-1-brett.creeley@amd.com>
 <20230422010642.60720-5-brett.creeley@amd.com> <ZFPwaa40glVrms02@nvidia.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <ZFPwaa40glVrms02@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0101.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::16) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|SA3PR12MB7782:EE_
X-MS-Office365-Filtering-Correlation-Id: 39793590-2800-47f1-4e21-08db4d7f5f85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4WFX+alg8a7IGzKyq9zSq7BFpTEkAx3Jjhnf36UhVncv+rz95wCXcA42F5YokBJFVum6uEDK7ehAK+AKjx1oD0i5yLm8SFHWxqhItoxwM/m2H7GVFhW3xXRrrCDetu2/A7xOMQveHBkP8GNxLi5EvmTC56kyO8E5/TMeGDxC/+EVUrQ4EmDYtX7f1pKp2miHPMRBFJaRKv8uwp4wF4gNxSX49yNF5UfTNdmPHY+y5LR05CVgosQuvIDSEP9bN+auPGKvirXVTuo5H7Z/ZhpTYvy9CJqY8Unlaab2LDdlnMwqC3q97Xlku29Kd5/Mytm6t/dia8BeZnoX6Pzfhr2JOhUzjYk/3eXZYC64rjlWAW74dQd/50InBd+l0mFRo3gxjkZbUETipI68Mldja6TFcpvY9huzWltlffg6uxZFcoEtM2WUEX5F8QhJWmmptpTDrhGzk8GiZs+yJZKRm+FcJMWe5kKfUk9/o5o6eVPYHWW1W0jPrhVm1SMEF0MQeLObwLAadT7c1WlL4hlXjrPeZ/GADIXK15VXTyC4XH1xTostZwOciU00gdxnITq8DTxr8rLZQ3YnCl54sDfYAqa9hm/8qZq1Yuuru/026lhmn4NDJBl1Q8TSgUI1IBJV4CWSkcMMN+3eP4rdUdlw8k/9Ow==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199021)(6636002)(4326008)(41300700001)(66556008)(66476007)(66946007)(8936002)(5660300002)(8676002)(110136005)(6506007)(26005)(53546011)(6512007)(31686004)(316002)(478600001)(6486002)(2906002)(83380400001)(186003)(2616005)(36756003)(31696002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RjFPNmZrUXlzMk5hS05YWndZcC94bnZhT3YvWXBMWnF1WEt3dWhEVzdPeGEz?=
 =?utf-8?B?SGZGc3E5c0RKQzhkMml0eWJwQWZ4b3NkUWV3T0g2NTJWdWpDOWJoRTByZUxs?=
 =?utf-8?B?ZElEcnFQWHhzU2ZmVGZzbnNVcnZQL1hWbEd4djdpT3VTVUx1ZURvdmNhZHU0?=
 =?utf-8?B?MU94YWtIamx4V1ErcWZZTi9hMVFqTHhPMG1ZK29CeG9La1psUnJCT05JT09L?=
 =?utf-8?B?MWd3dzhMbUtJT3k4N3ZkeFVtdDhySE1jNGR5MzlDd0J1QTg2WFpDVTBIZ3NO?=
 =?utf-8?B?MFNpV2lRT2ZUZ3lFcVRSV0phYUszVWJza3NESlhDTjdNZnBVM2pudy9ucElF?=
 =?utf-8?B?RnNFV1JxODVvOS9ITndkVlNiR1JvclVXc243bGtkSEZGS3Vxd0JyZ0YzVDVR?=
 =?utf-8?B?NUhqblF1cEI4b010cFZycmgxV3gwdWx5YjJKNFNrdXhOdXYvQXFTbzJsTDI2?=
 =?utf-8?B?VTdtQkl6VTVHcHFRRi9aaDk4OTNDblhESW8yN2NJSUhLMGRJYkFLVEd1R3Fq?=
 =?utf-8?B?ZS9OYmdPWk1XdHd6eE51eG54TENNeW5OUEpZeHVOL0swREhBY0pZa0ZXWWFx?=
 =?utf-8?B?YWk4SnJWRHYrUkd6TTNTd1p1eGhDVzJSek43blEyZkpWZ3d6VFpIQUJ2NnVV?=
 =?utf-8?B?dGNxM2RmTjRZUFg1ZVBMa04wYjFhZ2hRVTRFdHJQU3VlNWpvYWFtNElFdnJJ?=
 =?utf-8?B?cW9sREwwTXhDU2hFVjhUcXRDMFNaQ3h6cWd6SklVVGN3VWwyWW04MUFkUU9J?=
 =?utf-8?B?UzFrM2hhV1hKSHRoT0xXNXQrd3dvQk9WNUpLV081c0E5RFB0bGhZM3I5OVBZ?=
 =?utf-8?B?WU44cmdpU09rTTVHaW9DTDd4VXJEd0FKODIrYnZwQUxTU3hmNHJoT0NwZEo0?=
 =?utf-8?B?QXRmaTgrZFJEdkRkUW5Md3lVeGIrWnlrZk9tMHpPdmtURGVadHlOZ0pZcjRh?=
 =?utf-8?B?L3VzMWhPSDc1Z1pyTVIzKzd4cHhsejN1V0kyVzZUQVExRnJRTm1BY2RKUGVi?=
 =?utf-8?B?WVZDMlVvSm1HalJZVkQ0OVFjMUh5SDRZT2EyRFh5VkQ0KzBjWkhoNHkwWUI2?=
 =?utf-8?B?MGljMWdJdmd0dGYxcDZjM3BCUHdhdVgwM2hYTTlJcEZPZ3dyckNqcnNSbFpG?=
 =?utf-8?B?U09aTEhPb2J0d2NOV0FXK0ZSRDNxM3hubkJTM29WM1JReGtjNjdUeERjYVZh?=
 =?utf-8?B?S202enU3ZXRodFczb3RIZjQzbGh1c0hYT254d09OaTA1d1NqUTFHb2h5eDNZ?=
 =?utf-8?B?UGs2eHJSNFZONGZQT0lwODh1M1pzR096VHhaUkRyRWFrQ1BkK00xbzllSWlY?=
 =?utf-8?B?V3RCS1NzdDg3ajhaSFlmWTVRTkFieHNVMVpYWW9VVktxcGNyMkN6VU0rek5M?=
 =?utf-8?B?RWhnVndYSU9ra2I4SU9FVnFNN0F3bDdXZkg0ZmpvQ0V4bG1kejR5Yzc3Rnl5?=
 =?utf-8?B?QXQwbm5DajNtejZ0THRYdkk0U29nR2pIbUF6eW1JYkI2M3R1UThxWlRpNmdN?=
 =?utf-8?B?NGFjYkFqeFd4ZUlUdEpTc1BXNURMTGdtNm93NEF2ajI2eVpPYlZucnZPWERM?=
 =?utf-8?B?N0J2SGJxajNBZ3lkVXlFVVVWZjFkY0x0S1kxeDNVQjhrSGVOYk1oRGhKdm9V?=
 =?utf-8?B?TEZoL1dPQy9DWjcyV2xsMW5mZDF2TkFkZmRHTGFvZXo3U0FCblFrNElzYzNR?=
 =?utf-8?B?bzBuaURiR2VNV05sWlhTL0E4UVM0VFlUandXUkhhSTk5S3llQU5lQVNwU1U1?=
 =?utf-8?B?dWcxaTUrdzlvTUl6VzFYWUNJWXBLUkx1YWlnZ1d6VFEyY3M1cmdQaEFZbGJL?=
 =?utf-8?B?OHZNb1VESmo1VFpWb0phYWwzV3VqaTJBWGtVU0tIK3lWdW1pa2dTMXNpaG80?=
 =?utf-8?B?czc1cUlYUDNwQTh5ekE2Q2lpVXoycS9pQ1ludytCMnVRZzNYSWNqSEZuNVpo?=
 =?utf-8?B?cGFzVnN4dXRwbVRJQ3Y3OVh1a1lyM0hIcHA1VVcxZ21NbmlreEJZR1hnZ3h1?=
 =?utf-8?B?Y2oxYnM0Ujg5L2FpRnI3d0JlNGlXVVdVM1Jmbmx4eW4wakdtWnR3NWdEVklU?=
 =?utf-8?B?Z0hTNitYcEZnRTNEN0puVGtGY2xrdnlMck5GYnNOcVlUenRITittN0MxWkov?=
 =?utf-8?Q?a1aLQslQhN7PhllMEhJ31pjNt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39793590-2800-47f1-4e21-08db4d7f5f85
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 15:42:46.2724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N05Lcxee1FcFdxSeoHDT0iTJuNf89og9LEM37NDjuhpvQDb7RPImuoMcvO0kYd67kwvjBCt2X23Ph6q7swKK/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7782
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/4/2023 10:50 AM, Jason Gunthorpe wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Fri, Apr 21, 2023 at 06:06:39PM -0700, Brett Creeley wrote:
> 
>> +static int
>> +pds_vfio_dma_map_lm_file(struct device *dev, enum dma_data_direction dir,
>> +                      struct pds_vfio_lm_file *lm_file)
>> +{
>> +     struct pds_lm_sg_elem *sgl, *sge;
>> +     struct scatterlist *sg;
>> +     dma_addr_t sgl_addr;
>> +     size_t sgl_size;
>> +     int err;
>> +     int i;
>> +
>> +     if (!lm_file)
>> +             return -EINVAL;
>> +
>> +     /* dma map file pages */
>> +     err = dma_map_sgtable(dev, &lm_file->sg_table, dir, 0);
>> +     if (err)
>> +             return err;
>> +
>> +     lm_file->num_sge = lm_file->sg_table.nents;
>> +
>> +     /* alloc sgl */
>> +     sgl_size = lm_file->num_sge * sizeof(struct pds_lm_sg_elem);
>> +     sgl = kzalloc(sgl_size, GFP_KERNEL);
>> +     if (!sgl) {
>> +             err = -ENOMEM;
>> +             goto err_alloc_sgl;
>> +     }
>> +
>> +     sgl_addr = dma_map_single(dev, sgl, sgl_size, DMA_TO_DEVICE);
>> +     if (dma_mapping_error(dev, sgl_addr)) {
>> +             err = -EIO;
>> +             goto err_map_sgl;
>> +     }
>> +
>> +     lm_file->sgl = sgl;
>> +     lm_file->sgl_addr = sgl_addr;
>> +
>> +     /* fill sgl */
>> +     sge = sgl;
>> +     for_each_sgtable_dma_sg(&lm_file->sg_table, sg, i) {
>> +             sge->addr = cpu_to_le64(sg_dma_address(sg));
>> +             sge->len  = cpu_to_le32(sg_dma_len(sg));
>> +             dev_dbg(dev, "addr = %llx, len = %u\n", sge->addr, sge->len);
>> +             sge++;
>> +     }
> 
> This sequence is in the wrong order, the dma_map_single() has to be
> after the data is written to the memory as it synchronizes the caches
> on some arches

This is an easy enough fix and I'll keep this in mind moving forward. 
Thanks for pointing it out.

> 
>> +
>> +     return 0;
>> +
>> +err_map_sgl:
>> +     kfree(sgl);
>> +err_alloc_sgl:
>> +     dma_unmap_sgtable(dev, &lm_file->sg_table, dir, 0);
>> +     return err;
> 
> And why is the goto error unwind in a messed up order? Error unwinds
> should always be strictly in the opposite order of the success
> path. Check them all when you are fixing the "come from" notation
> 
> Jason

Yeah, this wasn't on purpose. Thanks again for pointing things like this 
out. As you noted I will go through the entire series to make sure the 
goto labels are named by what they are freeing/clearing and also that 
they are in the correct opposite order.

Thanks again for the review.

Brett

