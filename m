Return-Path: <netdev+bounces-11554-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 649AA7338B2
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 21:01:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CAC61C21022
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 911E81DCCB;
	Fri, 16 Jun 2023 19:01:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4C41B914
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 19:01:56 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E4A3AB3;
	Fri, 16 Jun 2023 12:01:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q60pMEPKLfl3rQIZird27FZO8j8J+vJpgJWAIQa0gvVsyyHPE7ESeNYyT7myRgWPwNMVqcCpoUmzELwX5LOSxR+JsD5tbAmlnS6EbGnvvODQHzx4QHX4lKxzbyBct3U8R6KSmTv7DI5WR/RY8iv/preb4hJR+/bnpTOaQBYH1B2UX28Dbv1tnZd+yqCt3XG72rqDI/5oNwzDed159/uCFHDeWjnDk9i2NO+dd/MMHYeOA6E7rVFVene8dAko6iJw36A1jTh8r+JRxOCpnPVD2SaDgQTJVJcmk6l1zbFROH0j9HgOJCmAsuxYIE/3zWZg0h77TYsqv64UMXleUFKLeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+mK2wiim7UVSUrXOd8kH8GHEKcdeGhf9/OmGIw8XRBk=;
 b=DRrxGAbIQJbzADGXuAK+iovM4YxeHJgjhsb1MBv8ESjFeO6nvhPFbDvei0qv/FWgsnu4O3ydKHPn26zjuwj2dzBorOLLVJlsa68hGB2CSvu2MPwTNaZyu21NHmVS4+3KHlqM4yITuf2N349WqvYOx2JvkCxyluWj5jPDLboLyBVdZxJfKDUo6e97kRDOm+9tFxikpZsgg4ffDV9w8KLJJR9xdGtNCm1GwdvmsBOmKsjZ0our5oIbHpXODVC1+oD/MYd0d2Hzodr2Nm3BbqSUso7l6znooTcXCfGm3XbaPBiR07sumwtyc9/zsOk7yliHTO78Bb6H9PRgiDbsHNF7pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+mK2wiim7UVSUrXOd8kH8GHEKcdeGhf9/OmGIw8XRBk=;
 b=TycvA7pyhWQxEK5sBUnoohFD0gzPIpH4kRcC/EjZ3sPCs6yTtVTa1fHHzvHuYOjCxj7TWAgOc245cqTVrBBCmTHcOTIfN1sV9p6Muvu0teo+GaGsG6CsBToPJWkfwrwwmA8PhHOCBaKfEzhjmguOZBQimhEiVrZwh569pmTmcyU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by PH7PR12MB8121.namprd12.prod.outlook.com (2603:10b6:510:2b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Fri, 16 Jun
 2023 19:01:53 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e%3]) with mapi id 15.20.6477.037; Fri, 16 Jun 2023
 19:01:52 +0000
Message-ID: <080c4b23-f285-0f31-5815-e4da3f157009@amd.com>
Date: Fri, 16 Jun 2023 12:01:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v10 vfio 3/7] vfio/pds: register with the pds_core PF
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
 <20230602220318.15323-4-brett.creeley@amd.com>
 <BN9PR11MB5276B5AABEEEB9353BCF38308C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <BN9PR11MB5276B5AABEEEB9353BCF38308C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0176.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::31) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|PH7PR12MB8121:EE_
X-MS-Office365-Filtering-Correlation-Id: 0433ae48-4548-457a-37b4-08db6e9c257a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dqRxaasxC2VuYJqb10/1343C1gsa9pGN5Nquju9pHN9Iswp9Jd7q/CBMqEth/XimcFmR8bpPmhZTKEVsqtCTWyM8IB4qg7XONn24okljh9Hzhw9pe8e0zSXReLskMTDsznXtrOK0z/4nssBAErT0uODXfphcuc0eAJJhGZRKbTvpvIhfPRLd6dhN4c+MH1/PhI3pi9Qz/asFJDql5I4fdhhmdFr4JoJ5UoXDjjwp1+sBXY8Gcp42IJXgcfHi59iG4zWbfuTUHqxQhdrGQJ6lp/av9bKg5aDqlhncWTz6OitYgJS8z+QTzczVRt3MG5DYeUTOwZ1mkf1WnRZNqArjZnslxuKMIvwXH6t2kF721mRZm98RP+Ieo2D7pRFTNZm1MW+Fk4tVMt2okozQh61Uw0D2W1tLsGX8tQ+DIXhJext7MXiNqblRUL8b/cVL5NQ341MezNIvn+Zei6XOrcIZVW6O3PD/4iICpVMP1KLHD43A5cysnWIi1eCtZ9i+48BGxbs19+V7v7DIRnSXdXQ6uzBAhYHetQCgNsUFPyAHW14fwVUewnyhhtAZ618Ixw8BDyIoB0UmlI8ZAq3hxTAzb016W2WMhxjgsTi3UHiCO+0b/6oHFKxJKNBkLvR+rIJJTurKhgPUEvFqxc50HoQJjQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199021)(4326008)(6506007)(66946007)(66476007)(66556008)(316002)(36756003)(110136005)(31696002)(53546011)(6512007)(26005)(186003)(478600001)(6486002)(2616005)(38100700002)(83380400001)(5660300002)(31686004)(2906002)(8676002)(8936002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S2hkdVNsY2ZRQ01KTVU4eGFVZXBIdmVzS0lGT2laR0RyekYvdUIyZFJyZlEx?=
 =?utf-8?B?R004ZVlNclhqVGxaenBsMDRCVVcrM3dPeWJTQUhFa1kydkpMM0VMZnVValVD?=
 =?utf-8?B?SE1QNDc5ZlVVSjlUdU9QeCtFcjR0WFpiUlFJYzRPbU90MUpzQzI5QjAwRW91?=
 =?utf-8?B?SHd6a0wrRUJsRDdBVm1KekVLR201MzJPZDQ3MXN1ZXFlSllQaDRZSFEzcTBm?=
 =?utf-8?B?ckQzL2w3cm1Pb1M1WHBNVzVvTmlqVFdZT0NVc2JYQVFFKzFwK2tXa1hDcjhv?=
 =?utf-8?B?TW9TalJCNHB5VE5tcEwwN0d1RzZFb0JrQkt4UVRWYkd6aUVSZmNMTWxsZWI2?=
 =?utf-8?B?NEx5K2dZb0tqaXdNaGtFazl3eWpMMFRzeHJyUWtJK1NqTEhpd1lBVEREbXZN?=
 =?utf-8?B?bGhybXlkRjBlbE1XazR3L0xJNWNBc2dyRVR2WnpNc3NFNGVQbFhrK3ROSjlS?=
 =?utf-8?B?YjFkaUNtZDBCN0QyYjR3ZUY4NGVSNHU4L1huR0VBbGVYRnNGWElXanljaVhI?=
 =?utf-8?B?aVJuVFI4WC9SMndkM3NTVExoUWNFMWgzWTEyay9ZcnVpRkR5RUpSeVVuM2ZX?=
 =?utf-8?B?dERxZnk5N1lYNUVXUnB2a09zMVhFQ01SWEVzVElVTlFVeXVlZzhHUktzZlNu?=
 =?utf-8?B?SWhiQ1FwWUE3Wkc1Z3ZBanpTRUpudGtSTGMrM1ZEb3dETE8rYnpVZUE0aUVj?=
 =?utf-8?B?ZnBUTVRzbjBFMWVPOTlqRkVZZ1B4ay9KVkJBSVliN1pDQXhXeHpXaldhK1Q5?=
 =?utf-8?B?aytnaXdvL0VvTFZBVVVTTEgxTGtRNjR2aDNUZnM0VlE0UmVUcEs5VFlsSEJl?=
 =?utf-8?B?b2hnRFJnTGI0ZmtLNXlmTDdubmpzYi81L0xwVG9vNG9nNjBWRnhlOUJzblFC?=
 =?utf-8?B?WFFrT1d4WVpsODZ2VS9MTFA5UFVmemNXYklFR0VoZWpwZng4MUE5OEZkVlE3?=
 =?utf-8?B?VHI5ay9NWVJOWGo2WStJUC9GT2FhaTQvRzVxbUQ2TzNjVDlUNXA3RUtCdkNw?=
 =?utf-8?B?K3VMM05PdG5aSmVtTzZnd1E2SW4xMlFCY0ZtVjZkOFNNd3dyaGhjdkwvOFNs?=
 =?utf-8?B?ekRIaWtOU01ZYlhuR3J5WGVpUmJDN3NxdEcyYzc1NHhVWkJOSWFYNlVhMUQz?=
 =?utf-8?B?MnhVTXdMY0JOV0ZzMnNSRG9FTFFMOG1iZHZ0VnVTYW43QTlwTy9QWENkNCtu?=
 =?utf-8?B?blJXcVNNcjZlV2loNjdFdGJRRk5FRXh2OUVTc0tiZlNVVVprb1lqZlQxYkds?=
 =?utf-8?B?SWdHQ1RRV2cyNHBtT1JIMCswcG5ucE1LK1owWmhEL2FGUkVCZExnR1NRNHJR?=
 =?utf-8?B?dkNSY0FUVDJlY3U5YkMwLzBCZlFaaVhzeUN6MGw0Ulc0Y00vTHBneWR1TXNw?=
 =?utf-8?B?Z3FBbjd2RnVEYTRHWVhiTHZ0REhzS2dIRDF5VHJIUnk4R2diV1EzdkNaelhi?=
 =?utf-8?B?alhHMzM0cnNrem56YXZqcGUxbFk3ejhxOUF0eHMveWRmNEFxVzdqaTRKOW5m?=
 =?utf-8?B?SjdHeVIvbno0dDZSVWVOWGs1K0xpOENrazd1dFduVUF4ZnRIaEt3czNQY3hk?=
 =?utf-8?B?M2hkT1loVnhPYnNQUjAyckJMM3FRaWIxMWk4MUpZaGp5Wnh0MTI5U3NkODBY?=
 =?utf-8?B?c25kY0NVaEY4VXlJZGQ2ZTI5OUc4R2FUZ05yc0xNeDRvUUJHRjlNMVo2NS9j?=
 =?utf-8?B?NE9oKzZWZEJrR3FxVmZsZy9zY2lPb29BSm1nZldHdVoxUW1NdUROeHF6SS9O?=
 =?utf-8?B?TnlzN2Q5MUNXOVVxRHVlOXZaZS9TeFhPc1NTVUJ4ZDc5SURlRXpsWkpTU0hy?=
 =?utf-8?B?bFZxS1pyWVB0Z3VSRXdqeDdPWW4vSUJ3UWRjN2s1S2hWeGdGNzFQejhHQ2NK?=
 =?utf-8?B?OW56NkNyaVZzdXo0U0NTMllCT1hkUm15NXN3dUNrSHhBQ1hidi8rOFFsdmRu?=
 =?utf-8?B?Mzc3Szd6bWZhZmZRcHY2OWJDd1JFdzV4RjFRWjJwc1RxYXE3WVR4S2xNV2VR?=
 =?utf-8?B?blFOc1gzdVpGRlp0U2VwOTMvUXR2UG45NzVLeXNNYjk0WGprUkFrM0dmZDM4?=
 =?utf-8?B?UG9vQm50RmpyQTBsYU1iUGVWU1R6eHN5RExleVFGQUlrMzM5dzArZ3hBRUZS?=
 =?utf-8?Q?d1aDcLYbU/diwy3/HI2XuOGoU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0433ae48-4548-457a-37b4-08db6e9c257a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 19:01:52.6768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tlclLKSq21a5zQFXZ3CzXWccjko521G+WM7XI6WunDBS5A9TX3NfHbld6dW0Wu0J8LkhYHSUA6RRk81Ocu2btw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8121
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/16/2023 12:04 AM, Tian, Kevin wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> From: Brett Creeley <brett.creeley@amd.com>
>> Sent: Saturday, June 3, 2023 6:03 AM
>>
>> +
>> +int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
>> +{
>> +     struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
>> +     char devname[PDS_DEVNAME_LEN];
>> +     int ci;
>> +
>> +     snprintf(devname, sizeof(devname), "%s.%d-%u",
>> PDS_LM_DEV_NAME,
>> +              pci_domain_nr(pdev->bus), pds_vfio->pci_id);
>> +
>> +     ci = pds_client_register(pci_physfn(pdev), devname);
>> +     if (ci <= 0)
>> +             return ci;
> 
> 'ci' cannot be 0 since pds_client_register() already converts 0 into
> -EIO.

Yeah, Shameer already mentioned this and I have already fixed this issue 
for the next revision. Thanks.

> 
> btw the description of pds_client_register() is wrong. It said return
> 0 on success. should be positive client_id on success.

Yeah, this was also mentioned by Shameer. I will submit a follow on 
patch that updates the documentation in pds_client_register(). Thanks.

> 
>>
>> +struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio)
>> +{
>> +     return pds_vfio->vfio_coredev.pdev;
>> +}
> 
> Does this wrapper actually save the length?o

It wasn't so much about length but encapsulating the multiple 
de-references and multiple uses into a function call.

> 
>>
>> +     dev_dbg(&pdev->dev,
>> +             "%s: PF %#04x VF %#04x (%d) vf_id %d domain %d
>> pds_vfio %p\n",
>> +             __func__, pci_dev_id(pdev->physfn), pds_vfio->pci_id,
>> +             pds_vfio->pci_id, pds_vfio->vf_id, pci_domain_nr(pdev->bus),
>> +             pds_vfio);
> 
> why printing pds_vfio->pci_id twice?

Will fix. Thanks.

> 
>>
>> +#define PDS_LM_DEV_NAME              PDS_CORE_DRV_NAME "."
>> PDS_DEV_TYPE_LM_STR
>> +
> 
> should this name include a 'vfio' string?

This aligns with what our DSC/firmware expects, so no it's not needed.

