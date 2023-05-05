Return-Path: <netdev+bounces-594-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 200A56F85F5
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 17:37:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C76AD2810A1
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D0FC2E2;
	Fri,  5 May 2023 15:37:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C446FAE
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 15:37:29 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46E81492A;
	Fri,  5 May 2023 08:37:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1MIrEAZeOqqTsxFNOAAcpAQs2KiysTWlIiHUQ7ykj0oA7x/sJk11hB6jS39S++OXEGQZj/Ii8zmG0/ONSY96r2gTIa/VI/3U8ifljbhoBdUTbHe6ojPFq+5o5z5S9d6oviFIU37C6GygWt57Pv4jlFkFdFCXWc+3NwzMjFQTZfoQ7gkAfeTeaHWLIrXj4XzYvm/ZYHOPLpgOY2HSBVG7E7bV5mfotMPNZh3zFrPEl/3u+4GPTJgQi+utGyBV6qBkdTTJhJZd4Gx1udwOO0lNAhDVmX+6o8201ji0IjuZBkkDorFB48hZxs9VN6QWvg/VMDAtmMsGfj7W/Mo/h1zyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ggxwi4Jv07IY+drldP2bV5sZgu4fSHCcnoAjy8Io/vo=;
 b=mcj3m+B618rvaNdLoLtEmBnqxnDwZum6aHTY8nZphSSCjrD+958C6F7+7thHYx20oDSboTV//798WHfI11N811IK6gSrISDNQsxBLrmv/yRxP5uHgIQ9MX9YLyqw61hRTLdju4tTE1EAWGFZCvPN1S5wpg58Ee8dxgYB9JPDReWPvp+CP7Avx64L3E2eNCUaKmdzNfUCpxTQlEB6682dXCzKhwEGM27sC0Xyj3Yj2cTQEBF0SGaG7O4tZS7AToWbmPAe3cle0c0UbFtCkaiL2Oy1pa6jtYs6OInsJ6sOZYX26A9bdw7XUeSmYhINaDKaMPHOOMz5QxwwkdWDMBqr2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ggxwi4Jv07IY+drldP2bV5sZgu4fSHCcnoAjy8Io/vo=;
 b=bGZwrVkEu31XXi6pjYyf40//UEGg6Dn6aEG72FwCFOQKk8/zwc/pvwsqeq4UfVHPlnZiHWGsbGfqlH0knGg2dxzyS0r7wYBc+S1nzfzrEFe1qKf9YqZNs4QKrAkB1/TP+JIpWVy/qkesUVCFxpwRx3H5AKZIDHyT1NmieHytTU0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by SA0PR12MB4542.namprd12.prod.outlook.com (2603:10b6:806:73::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Fri, 5 May
 2023 15:37:25 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f%5]) with mapi id 15.20.6363.026; Fri, 5 May 2023
 15:37:25 +0000
Message-ID: <d245e6aa-8422-0c88-fbe2-42d9af6c1bf4@amd.com>
Date: Fri, 5 May 2023 08:37:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v9 vfio 4/7] vfio/pds: Add VFIO live migration support
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Brett Creeley <brett.creeley@amd.com>
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, alex.williamson@redhat.com,
 yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
References: <20230422010642.60720-1-brett.creeley@amd.com>
 <20230422010642.60720-5-brett.creeley@amd.com> <ZFPspJbvPbo1a2/D@nvidia.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <ZFPspJbvPbo1a2/D@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0109.namprd05.prod.outlook.com
 (2603:10b6:a03:334::24) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|SA0PR12MB4542:EE_
X-MS-Office365-Filtering-Correlation-Id: a03894cb-b543-471f-076b-08db4d7ea01f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NzviBu5GX1F7XtM5IiwHch+1yMFXSPNgr+CHosJbciJTeOQulx6sFjK+QUYD51fkMEGa6XgL6KWK4KUdhRsuxj6Sd/pSO829zvjKPptHi3bRmJ0M+EWDFw2M3Ph336u0lIk/5B+RcRZLpjZm5YCiLBcg6q5tJ58rAzlMXG3VGyu0RqxLTdrwiNEkSW7O6hVNfFr58Ld9+4ndPxKEXNCdiyvI+b+TiVc7t57tcgsPHKIcZ+Wq5t1XzIjz9NKxrEZ/pZBogo06C9Nxkhwipovyz2vTMwVvEbDPQKLeFAKSJSLGT/CnMtEHwMGvJn0e11oKIyx9d438PS0UyycefarblOvucZZJAJdy34FKmE8Qnk8MDKKFTV+QLiG1KDf0UjO2UYzn9L6T7oARI6bhh9ZbT9uoBQGMr/v7NhH4Oe1CtuPslEW4QecbeL/qPwlGogijN31lv5cRgaTJMlD5ufMTXnfmVynpJmZMd2ywcnGb9MEdmp7CGzqIIB1lpqpxsVQmtrbHyp+De1jSVReX/Z98dYRKD8fgUkBWTRatpNSiTf57/PHua0Zby2AsVJEIg9Z57et+XVecvnfFZtiUqyLdAw0RAq1df2Tvdh+EoiGxpOZd3UmJQwp18Q08QFRCB/ypastKOiYf9uk/skTE0K4HsA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199021)(31686004)(66476007)(66556008)(4326008)(6636002)(66946007)(6486002)(478600001)(110136005)(316002)(36756003)(31696002)(83380400001)(2616005)(6512007)(6506007)(26005)(53546011)(41300700001)(8936002)(8676002)(5660300002)(2906002)(186003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFdnWkNtUFplV0NOaHczdmZJNC9GSU15WCtyNXpJREc3VTNIUGdoMXRFVjVV?=
 =?utf-8?B?VEN2OFcrSitRNmkrZDZJcjAwR2h1SzVMaEJVQXMvUjBNelJyNHBnRm1LWDgv?=
 =?utf-8?B?a3JocFVuTlIyV0M5dDRWVVpMYXgzUEh5TklrelZxNXJGRUNwbXBvTHBrb1N0?=
 =?utf-8?B?NDdKM3hDRFJ1c2dxWU81ekwrMDRGVWN4WXJQMVJyRjgvZ0lzbGVPUW0vMVMv?=
 =?utf-8?B?V2JENi9PTjdCNVJjRzNHT0ZGVnR3Zlk0bGY2WDYvOGdSZ1FsR3FoWlAvRTho?=
 =?utf-8?B?SkxBMGsxVXJYRjU1VHBkU29HUXJjSFJ3VjQ5UmNpcVF3SjRveXFKMTBYc04y?=
 =?utf-8?B?b1Rnc1lLc1VpNFc2dGsrZkdGQk5rWTRzZ2ZVa3RyMVE0ZTBUOWs0djlPSXdm?=
 =?utf-8?B?Ly9vRnpNU2U5QkJmOGtjNEE0YnJqQWc5THd6VEcwbVp2OEh4b0I0MWFBSS9H?=
 =?utf-8?B?SGp5emk5YWhIYzE1aHZpL2F5ZHZQdG9IVm9jQ0JXdGFWaXpWc3lpS1lDZy9R?=
 =?utf-8?B?WWE2YlplY1B4SVNYcmkxbGNtNmY4UmFPZFFSb0FSaTQ4YWk4ZHpPY08xb2NC?=
 =?utf-8?B?YittRXd6RWUrU2J5Z1lNVlZrQVNMWjFSUFRkVVhkT0hid1ZSR0RFM1VZLzJ2?=
 =?utf-8?B?MHFpdS90MUMrQm1CMkZkUlBLT0lneGxhZHVzREViU1ptczk4T1V4MVpyVzhX?=
 =?utf-8?B?V3lRaU5DTERLc0lWM0JsMzR3Nnk3NFB5L0s1bTJETHcxYXAxdFhNa1NoTVlY?=
 =?utf-8?B?NkhoY1NSeU9SeGVIbnpnNzJVWXRTaW9yVXNVUk0vMXJONW5nU2w2NU81ZzhB?=
 =?utf-8?B?L0FlTzQwNzJ1VTNhaTRmTlpnTjdzbGxqZnI2Qmx1NUdaUTRyWU1NM256Q0Nv?=
 =?utf-8?B?ZUh0L1VIVW1uZ0FJQVhtUGFPWVplNGsyR0RlVXozZXRzSTU1ZjVVT1U0dTdP?=
 =?utf-8?B?TXRNbWdNT1NldnBKSWFRMW8yUFFmTjl0VWxwSGhSYkRISHlISHBJcDg0TVhU?=
 =?utf-8?B?ZUpZTW50eHdhSXlSeWh5STc5aFc4d2RFajVqaE8rQ3luMUdxRnBwNVE3ZW1L?=
 =?utf-8?B?Sjk1YnJOZE1lU2VuUnlsZnpnQTZpRndxSWN0QVBKbWNQUEF3ekplelVRa09B?=
 =?utf-8?B?SldPa2tkaDJQWmxydkhNM1lZakkvQVJLRDhrL2xlY2VEVkVxbTRCd1FnNCtT?=
 =?utf-8?B?OVJLcTZlSmRNV1htc0NuNW1kVmVxdXZLYWVYbFlzQk94SjlSZUlFR2h1VXBL?=
 =?utf-8?B?ZmNHV1dLKzdTSzdaOWxHbVBKQlorZEtXMktXNHFIR0MxNkdUek9EbjZsRUpH?=
 =?utf-8?B?N3BBbEptbEFhTHFxOWcrNWViOEpCRHM0a280WVVtbHAySjJnT0JTYnFYMi82?=
 =?utf-8?B?OGZMTGZPVGJncWZldWJyaFlrR2pJVHdWQWxzMXBrUGFkYXI5NEQvTlJjZ3oz?=
 =?utf-8?B?STl1Tnc1VS9VeHJNTVV1eENBYTAxNkZhcjVQM0FiN3NRRHhUWDFad2pGZXdK?=
 =?utf-8?B?ZzBxejlucmZrNWQ5WFU2aEh3TTBoTFZDc241RzBwU0ZZWDNVK2ZJNlpUZ3JP?=
 =?utf-8?B?SlNJTWVicHQ0b2plb1I2TUtQbUNVZDN1TXFHaHl3K2h3SHBkc1Q0Q1c0MVJw?=
 =?utf-8?B?Q012Nk04azFRdXIvNkszNkluTGt6TGVuamJCR3RDL0cyekhubHpWS0xvSFUv?=
 =?utf-8?B?UDFpOUNrTERML05laDlucDFCcVp1QWdMdHB4Wm1STDFoRmk3enZvUURtd1pp?=
 =?utf-8?B?L0oxN01HRUlveEVVZU1odmJpTkRhRzV1RkxRaXhoVDJuMTkvc3I0OWlsd2lZ?=
 =?utf-8?B?b2plcDd0V05xWnpqRmZtMi9McitsZTR4L0FLYUp6MlZWWHh6SnVOY3BSbjZv?=
 =?utf-8?B?RDVreWIvZElEemU4ZUxQRjlWTm9ZajVvbXVFbXhLVUFIQkhBVmlBbmFnNXJD?=
 =?utf-8?B?amduNi9YV09URDd1UXVJaE9ZQTRicXBrQVNmM0loQ1h1UFFsL0tJWkxjQVIx?=
 =?utf-8?B?L21xTHdjTGJYSXZlYU12bXgxYTI0QWhYbTZpY0lHWUlwd1h4Z2doZHh5M2U3?=
 =?utf-8?B?eHJGbmMyT1hFL01wTjdpRXI3V2xCWUt5Rml4U0NjS2VHeXBkOGdnTzV0RmlN?=
 =?utf-8?Q?aTpqCoLaXqZAW/jte+7dSTon/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a03894cb-b543-471f-076b-08db4d7ea01f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 15:37:25.1630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MHt7o+6qTPGoU5NYoijr2KvnzN8iSC7KqUEMMhN1sIiJAFUFQsL/JugDX3JVcJV3FTW3T3bWxzBViQ5WN3AagA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4542
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/4/2023 10:34 AM, Jason Gunthorpe wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Fri, Apr 21, 2023 at 06:06:39PM -0700, Brett Creeley wrote:
> 
>> +static struct pds_vfio_lm_file *
>> +pds_vfio_get_lm_file(const struct file_operations *fops, int flags, u64 size)
>> +{
>> +     struct pds_vfio_lm_file *lm_file = NULL;
>> +     unsigned long long npages;
>> +     struct page **pages;
>> +     int err = 0;
>> +
>> +     if (!size)
>> +             return NULL;
>> +
>> +     /* Alloc file structure */
>> +     lm_file = kzalloc(sizeof(*lm_file), GFP_KERNEL);
>> +     if (!lm_file)
>> +             return NULL;
>> +
>> +     /* Create file */
>> +     lm_file->filep = anon_inode_getfile("pds_vfio_lm", fops, lm_file, flags);
>> +     if (!lm_file->filep)
>> +             goto err_get_file;
>> +
>> +     stream_open(lm_file->filep->f_inode, lm_file->filep);
>> +     mutex_init(&lm_file->lock);
>> +
>> +     lm_file->size = size;
>> +
>> +     /* Allocate memory for file pages */
>> +     npages = DIV_ROUND_UP_ULL(lm_file->size, PAGE_SIZE);
>> +
>> +     pages = kcalloc(npages, sizeof(*pages), GFP_KERNEL);
>> +     if (!pages)
>> +             goto err_alloc_pages;
>> +
>> +     for (unsigned long long i = 0; i < npages; i++) {
>> +             pages[i] = alloc_page(GFP_KERNEL);
>> +             if (!pages[i])
>> +                     goto err_alloc_page;
>> +     }
>> +
>> +     lm_file->pages = pages;
>> +     lm_file->npages = npages;
>> +     lm_file->alloc_size = npages * PAGE_SIZE;
>> +
>> +     /* Create scatterlist of file pages to use for DMA mapping later */
>> +     err = sg_alloc_table_from_pages(&lm_file->sg_table, pages, npages,
>> +                                     0, size, GFP_KERNEL);
>> +     if (err)
>> +             goto err_alloc_sg_table;
>> +
>> +     /* prevent file from being released before we are done with it */
>> +     get_file(lm_file->filep);
>> +
>> +     return lm_file;
>> +
>> +err_alloc_sg_table:
>> +err_alloc_page:
> 
> What is with these double error out labels? I see it in a few places,
> that is not the kernel style.
> 
> In VFIO we have been trying to label the err outs based on what they
> free, it is not a 'call from' scheme.
> 
> Jason

Yeah this is kind of ugly. Thanks for pointing it out. I will fix it and 
any other occurrences in the next revision.

Brett

