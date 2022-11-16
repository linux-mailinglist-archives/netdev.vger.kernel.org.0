Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F2062CC68
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 22:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbiKPVQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 16:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiKPVQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 16:16:04 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3353A4C251;
        Wed, 16 Nov 2022 13:16:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqkiWCjGdjAXeDxWLCMZqAQRE9w3Rp5nWAZdEC3y/zwpEPkl0MhgqlQefyxoWB4/IOtgnkb3XUOenWtFfn476dco2K9aw0xZgcRVFJDrqLbdt98VUnM8A9r/NkNu4xnCk1tk4/pvRYgozyyDx1xDPW0NVvidyvLT/zkH/5IMHxXnaGWfXcKI2QknzXCwQGzRBndNqi64+3R2NbET3qR0f/7PXkXy5OO3Vyt+j1rDZg4yHZ9+YDB9r1u3aJfJ5UZOMAuV1FEU5Gju4D8ng0wxxthvzPVwwIKf7jplaT6UWcNm2jVPv6eCu1U5lpSbovH+HCUHOXKQ0i7NBJDRoSgwhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p5UgEfJaUqXPj+Xir96GNLcm77xEvfF5zNoRf6IbGok=;
 b=nkOq0+g4kF6Zpe95ozvJvlP0WnQHL1UEYO2QH+ql4rRx7dnMRKb8hEkZmRBonSUAHRV4PMbOqcLhXxw+ZUHOb6q1WAjugZexg3xAfdH7Xk0+Blii2L4/gOl2n1gM6J+pCvqLiK0T2/opbpL4lrGcvDCFioGDyl7ZA+UIeuxfgn1Shk+31dCPk/0tbuuT94+yr3Rjo00WZ9akhhfW6cuEVM2UK1GhSLXKvpgpWZQXFylJfHVu7dcX5shR5FDvmEuK8WMytr/SoBBq0v9VkYY0al7sGRw7N2GDsfu4ITp2ko0BuA1nEqcKVn9RCTl++yYzceq1op+p3JwBAT7HaHcYnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5UgEfJaUqXPj+Xir96GNLcm77xEvfF5zNoRf6IbGok=;
 b=gPVs4fZXTkouZXcuD/YnAOsmAyREZsvPLna7p2pqbGmO4yjl8aUlQpR7CY9e3X6rlbNrQA+YStW0owm/pG8SDdljzMO6oBD8n6nWlpX2ippyl3FQsKudKgXmt/Tv0t0flKEFActuyuEG7lAV/PWwTlR5UOb3U/lpNX3gwqz6HiE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by PH7PR12MB6635.namprd12.prod.outlook.com (2603:10b6:510:210::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 21:15:59 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 21:15:59 +0000
Message-ID: <8c9554a7-7569-ec5b-8da4-6f169d3fefda@amd.com>
Date:   Wed, 16 Nov 2022 15:15:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [Patch v3 05/14] x86/mm: Handle decryption/re-encryption of
 bss_decrypted consistently
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Michael Kelley <mikelley@microsoft.com>, hpa@zytor.com,
        kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lpieralisi@kernel.org, robh@kernel.org,
        kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        brijesh.singh@amd.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-6-git-send-email-mikelley@microsoft.com>
 <4d27540e-691e-bd86-0f70-1faff39f7187@amd.com>
In-Reply-To: <4d27540e-691e-bd86-0f70-1faff39f7187@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0P221CA0038.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::24) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|PH7PR12MB6635:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ae2ec63-3627-432d-6880-08dac817c247
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J6jQJnRrF5hGUqQy/rIQPyCGU6RhrKta953ArQ55cruTFnrO2VegKXmT7fthq1oPxBiSKe9XMYIrfLCVMnbnhbvG27j0NfPupdHr/eYqyYiddv4S1IlEh5ZhfCVHI0sBdlKmgKJhCzSqmO6ripKwdMkKI3hpU4KvCm6pKrO++uykX2qY0+O/NdreFbBCdAa+p3Nm7s5T9OfPJl5cy6y71wPbmwqbywmdGXppU56CEIQBDd5lfx7MzT1Al+DHIMIT2xmQ0/Mm6m4zvd/R9ZbjjGPTf4lHH/7ktSRytFbg8Cu/aTM7Kd1vaaOHahLvfgSvOIVhK8E28kUfrwwEk8E1W5RxvER0pQ5kL3IxQAXSggPk3YBWpFio+xRbSs9qSweYDa2+5h3B3JIZ2e7lFVARSs6RArwdfFLbWxgsCuhLSCrs9vvAp5D6d9wcHY7CTUdGm2s6Novn/vqYtg49wELxytioejiKBKp3Lz5jnShcU1xzP3h6I36+X/etPIa8cKU19ahH68GnoS8c5kqThH07TpRMNKDxVRDDjBALFcktwiMdUCYAN2hxXncM6f4oPOElZ81Upj+ydFP4JcMDBtlBQALrOZoKwbDG0BZJrlH450F6WFhNGJzSwGmfA4SuTv68Hdf9M8HeXvLH71D+gExPUGMeNYifZ3SJCNSXJsPmgeXvWr1fukMTqXvZWmobi0/VO4nQQIHwq1+p8qoBtCHdvh4aWaQL8ge2sJgUu9PuJlaju7bpwAazM4HJ3uh73AoF6qHXN4wcj1jyLZ3qpigKLQ7nptHhBTkB8Kh68yoVwFgiCAm2DnP7nR3uKxsQtwbv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(451199015)(6506007)(6666004)(6512007)(26005)(2616005)(186003)(86362001)(66556008)(66476007)(8676002)(66946007)(53546011)(36756003)(31696002)(41300700001)(478600001)(6486002)(316002)(45080400002)(83380400001)(38100700002)(2906002)(921005)(5660300002)(31686004)(7406005)(7416002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEVjMmpDRGc2Q0htQVpRTkQ4dGJEYXp1RkdXUlhubjFwOGxMSFlEbkFJTW0w?=
 =?utf-8?B?di9MYk1RbHl6b2xzQkJlY3lqd3Z5RFoyZVpkamV1OVFtTGdJMUR1dzJ6dWR1?=
 =?utf-8?B?OWg5eTFGaFlYOGRucUtjUkxIR2hsaUQ4eFR2Q2ZPazcwREE5RitTVDUyQmtp?=
 =?utf-8?B?bU5DeE81WXNpelVyNENCQndZeGNKYlNDOEEvTmp6bkIyMURSeHBicXkvdEtz?=
 =?utf-8?B?Uy9QbTB2SERNUHg4ZVRaUlhCQktQK1cyOUtKM2hoKzFwMDBhMGJxL2hVc0ky?=
 =?utf-8?B?dThBYjRJTUJxSWF0dUZNZmlvV0Q5cjNVYkphZWZzeTlrWmtoaEJpNlcycitt?=
 =?utf-8?B?emxDMGRqdis5VVBNc2Vxb2dqV3RkaWtCTmFmMHRtN0RYOTNOMnY0ZWZ5WWJy?=
 =?utf-8?B?Nk50a3hqNnFFL1daaHhNeTRyQW45U3FiYXFSbzMvd0R2RzJqbDZmMER5eUVh?=
 =?utf-8?B?MXZyMThwUnNhQjg2WFRZdGRnSXRZL0ZGUkc3RlllSGk5N0JzT2RUemYzVnpz?=
 =?utf-8?B?eEZ4Z0pFd2dOZEcwRWxYdVlOeHdJT24zRXFwSkN2UUJPakkwcUpPTFcwTGxG?=
 =?utf-8?B?R3BQYkxJUVk0aE41U0tNbkJrZk9DYmVENk0xUlVwRzN2WDRmdDhvbEFKazJV?=
 =?utf-8?B?aURTUlJFRU5ueHZ1RHoxeStTVXJjTDhPaFlEc25Ha1U0aGVjOW5qUms0azJ1?=
 =?utf-8?B?ZFFlQm5RT3pOekFmalM1NVFCQ2Fnb2ZBN3pPZE5RdktiZGxTWFM0RENyUXpJ?=
 =?utf-8?B?NVU5Z1BtV3MzM1NWZVVsUXRra1ZEU0hFM3E3WXp2R1lFSHFYWk9UQUVINHRp?=
 =?utf-8?B?WlphSEZURWZqNVZIdjVNdGVVTldWUTVMcnc4K0RPaCtvd0t6aHJrVGV2bmo5?=
 =?utf-8?B?aTYySHkxMzZJQWtKZ1Jzb3AwUXJQWjk5c0IxRFVKc2ZqZ2dxRG9XczVEOStP?=
 =?utf-8?B?QkI0K1NSRlVPcnBhNEU3QXpiZUpJSE5YYXNTZytZYkJvZnVHb3BuMjJiRU43?=
 =?utf-8?B?RkpacWcxNUtCcVpmenU4Wk84M1VaYVR1M1E3SXE5NlpkNnQwVlFNRXp6UDh4?=
 =?utf-8?B?MXFGTFhXWlA0V3dJdGlCUlQ0TFd4QXMwWTVxakVOTlk1ZXNQc0NNdkpOelB1?=
 =?utf-8?B?a1FnM2xhQ0RialQrcGcwZllCeTBweklwcHNMaFNkS1ZHc3VDaUZLRVc2VEtU?=
 =?utf-8?B?YVpkTW5MYXpYZWpCdHpjWEIxRFJ3c0lEZWdEd2VmL05uNmJrWlpvVHppdE9s?=
 =?utf-8?B?ZEZSTTMxQ0FmUUpxTHFDWE5NTXJHTTlTeVpsdnY2d3VBelpQZHhIWFovRUND?=
 =?utf-8?B?UEJ3YlJpUUZFWE5JeFp4NW9OLy9LNVpvaExXYXpYc0paMjN4SVQxU2p1K2RB?=
 =?utf-8?B?TU55QklyMEJqaldNaitzeGV4b2IzUE5IV21pTGtXc1FaemF5ZzlCbkJEQ3Y0?=
 =?utf-8?B?OEZML2xrVTNveTdsdFd6N2ppekZnN1lEc2ZiY01CVXBJL1BpV1VZWEpPelgx?=
 =?utf-8?B?dkVtejZVZ2Y3ZGxldG9IVkRmNXVSUEZ3c1hMYUY4L3FRS256UnQ4d08rd1I3?=
 =?utf-8?B?TjlTVnZSb01BcS9jL04wWVdSV1ZNR29lbzVNUEF5T3RlZC8vWVVqZW5pTldQ?=
 =?utf-8?B?Vmd1UnorVWJHaWZTM2gwZldGa2d2NFRLN3NsRTN2QmhwR21IOUZwZGRrQzVk?=
 =?utf-8?B?dUZRQW8vNzRUd3pZdEIzekFtdFV5K1dMYll6U01CZ0ZsaW55Sks2STQ2cU1L?=
 =?utf-8?B?UkZpZmxSN1RBTGdHL0xUbWllbloraEdDSm8zdVhWWWVnWkt1dzdmNUprQ3R2?=
 =?utf-8?B?SmlqNU1wZ3NhZDlvNU13b0FRRmNTUDdjUnN0RUNzVG1pRUg5WHREUHZpc0VE?=
 =?utf-8?B?QTVMNUpxZmQvZ1VoeG1kTDdWWkNPbzlSNXhwVUd0R0o3emZUQkhzQ1p5bGZv?=
 =?utf-8?B?aXV4S1RrdjA1VnhVbzRWdjlGMCtSNFVKa2RlYkpqQkZCTjJHNnpWc1YwNElZ?=
 =?utf-8?B?ZjdTVFkzQ3FkSXNVNUVlQmlINVQ2ZHgzRGRqbEp3MGVpdVhlb0dCM1ZaVklL?=
 =?utf-8?B?aHdpdlFWWHBzVnFwTVFwODR4Z0MzOWgzaXBuUDR6ZE11YkVLWlF1ZU1BZWlP?=
 =?utf-8?Q?e4D9ukoCHR7nQ2fOf+/xSkFfs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ae2ec63-3627-432d-6880-08dac817c247
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 21:15:59.7484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4c0W5Iej42ZnjiU6/+xBX6yhJjVeKDYhx5vsNGhYW6fIGc4YjlL34zPvY4n984NYvRSPfge/oOGR8bc6z9E5BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6635
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/22 14:35, Tom Lendacky wrote:
> On 11/16/22 12:41, Michael Kelley wrote:
>> Current code in sme_postprocess_startup() decrypts the bss_decrypted
>> section when sme_me_mask is non-zero.  But code in
>> mem_encrypt_free_decrytped_mem() re-encrypts the unused portion based
>> on CC_ATTR_MEM_ENCRYPT.  In a Hyper-V guest VM using vTOM, these
>> conditions are not equivalent as sme_me_mask is always zero when
>> using vTOM.  Consequently, mem_encrypt_free_decrypted_mem() attempts
>> to re-encrypt memory that was never decrypted.
>>
>> Fix this in mem_encrypt_free_decrypted_mem() by conditioning the
>> re-encryption on the same test for non-zero sme_me_mask.  Hyper-V
>> guests using vTOM don't need the bss_decrypted section to be
>> decrypted, so skipping the decryption/re-encryption doesn't cause
>> a problem.
>>
>> Signed-off-by: Michael Kelley <mikelley@microsoft.com>

Meant to add this in the previous reply...

With the change to use sme_me_mask directly

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

>> ---
>>   arch/x86/mm/mem_encrypt_amd.c | 10 +++++++---
>>   1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
>> index 9c4d8db..5a51343 100644
>> --- a/arch/x86/mm/mem_encrypt_amd.c
>> +++ b/arch/x86/mm/mem_encrypt_amd.c
>> @@ -513,10 +513,14 @@ void __init mem_encrypt_free_decrypted_mem(void)
>>       npages = (vaddr_end - vaddr) >> PAGE_SHIFT;
>>       /*
>> -     * The unused memory range was mapped decrypted, change the encryption
>> -     * attribute from decrypted to encrypted before freeing it.
>> +     * If the unused memory range was mapped decrypted, change the 
>> encryption
>> +     * attribute from decrypted to encrypted before freeing it. Base the
>> +     * re-encryption on the same condition used for the decryption in
>> +     * sme_postprocess_startup(). Higher level abstractions, such as
>> +     * CC_ATTR_MEM_ENCRYPT, aren't necessarily equivalent in a Hyper-V VM
>> +     * using vTOM, where sme_me_mask is always zero.
>>        */
>> -    if (cc_platform_has(CC_ATTR_MEM_ENCRYPT)) {
>> +    if (sme_get_me_mask()) {
> 
> To be consistent within this file, you should use sme_me_mask directly.
> 
> Thanks,
> Tom
> 
>>           r = set_memory_encrypted(vaddr, npages);
>>           if (r) {
>>               pr_warn("failed to free unused decrypted pages\n");
