Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C8E6261A7
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 19:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbiKKSuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 13:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbiKKSt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 13:49:59 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D4F2E687;
        Fri, 11 Nov 2022 10:49:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QgaXPya6+bA2+X8Zx19zxXOGmI6ar/NaTCoI3rrxMYY4BtZ/0UHt7Z34qw52RK4Ha52oTLpN4ZkhoBo2M8sKnUr5CjROSxi7LeDU6lFS4+vRxa6q8dMzc5R6rqmPPUFoM1zSY1gUfy48huQH0lziMKU1ducmkVtYe1IRPs+lXMsULciCs7dd563sH59KVd4xxSirg6jb7JqKzS10pt/fFY6yLWwbV/OvTeJM789opOjEB8nvX1RuK7Qc5HGZv+XAp0Gv19bdq25hM9SNo49iVQaXIenBpnzcZZOcXwdVdOsgSYyBXZHfFqwmb8zIrES+osM4kKjZI/XmfqSG2EeepA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wu2dbqpHLlNamu6i5Ca+IS/EjWfOyzsd6P/dMpGT7wQ=;
 b=ZnZttmg6q1tjaz2kVQZKkNmjWhr1FF27bhL240noew0n1TwDVY0Oilqjlu3Xd1vuBr6IFMbEvu/bJKDKuny5rrfIkNKLtzOhVmyACZTx9Mrsy6jQ/PZoExRygcsxsvXlreO1+3uGnef4dC4yNVBs99vrjOMaJwvgRSgVKt1Ib1aJi44UtNq5GIXiJziyzxYwyFkzey0MqTSw+CV4bDrmic3MWwkrJu4kFxeFluVSulFJ/JfYtKm1j6yApuzXLc883uowLPCPa5/+7kc/aet4T/GUqxtIBqI5DvSbLm4ou7xO+fsdDuGXKA5n+KBHbSSYViUiwnSXzjQGL7TYffQ6tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wu2dbqpHLlNamu6i5Ca+IS/EjWfOyzsd6P/dMpGT7wQ=;
 b=ivJF3OpBS/NZwTBnKIv2stV9jXZcd4hAAi/pbXabtNPhx84C4iAr4jecTUJcKAGNZ3n2W0jq9YwJBj/e6nIu1GgnT8BQITZRtYysvtVy/Qt7lmfmmhH2+BOTy58X1b5khY+MnJY1DFJ68AO8Cxz86GZEAF1YgO2U8zYTRTzqOmw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CO6PR12MB5460.namprd12.prod.outlook.com (2603:10b6:5:357::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 18:49:54 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 18:49:54 +0000
Message-ID: <177144ce-aa63-58f9-d3ea-dec9cde482a5@amd.com>
Date:   Fri, 11 Nov 2022 12:49:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 05/12] x86/hyperv: Change vTOM handling to use standard
 coco mechanisms
Content-Language: en-US
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
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
 <1668147701-4583-6-git-send-email-mikelley@microsoft.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <1668147701-4583-6-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0089.namprd13.prod.outlook.com
 (2603:10b6:806:23::34) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CO6PR12MB5460:EE_
X-MS-Office365-Filtering-Correlation-Id: ee1446d3-9f2f-4f6d-187c-08dac41585bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X/iphSnXttxaSd5iN//iHdkJ8Mgk5K7eKSzP2E5juOGMYNUUmkNxhMbNlGTTfuVZxBDYgBh7ZrPq2KjMffMhtk8AA0DkajzWPZ+uYmma0kE3HxUHmiiBmSay/vmmm+fa6Zf3zDEfmCafF8blD9yVNNRAc4uZLxGdkOF5IPthezvD7gjRL+klWFeXOylPtUvZh5HMRcuA7SJzbpvdkYQMUTUnh2H/65gfAf/AtTu6y4yrlCrz8qlTx2yRh0ClBqU9d/uzdPXM12La94KR65cms0qikxWzDG62zyA0beSKviZjGP1dJtqWkZEsJTV8i/s4kUHsoNtblf81Yj0BDR0LohPWJ9mRbgUp12+Y3yBonaKMc6LV1K87bNgnUA19gSi6gvnASGXx9L8Dwl97f6qOJgU961nkl+b0udiTVS3MQ0Q0sfUl1pykHalE5j4O+xs2gfoveg0LoqMKcJ+a8dA6+1ns1JkK474GcBUh+Pr4yVJxyoDzZl/PxwCBk7lIUvzPhgPA1iMGJcQ0tSAWgJZ5PmZQNaWMi4KquIb4OpcvGvG7Ch6peck8VUvQbcltiCGaA23EK3HVAExgQn76IMWv9IO+RwAer0v9gQxvdenHv0152GOtPwJIxGww4YledOBdbKbbqjJSwIytqs7pznP3ab/Tkv9d44AgnyF2O/osbVKHbPXyNWhlNzXTTaXBqsKFfPiLUjL3J0iXyo7gFtyVRWRB/0hiTChOodo40pSVtNaU9OcOXOs0H72LqvKlnMneGAbmJf1NMvvQViUyiXZ5VRi6gCjByfTP0UrFBSszPwCMdSx77Q2zydq6zVrpDnjnM5i4XrML0IhaMw7s+OrBdwG7vq5k0dnynHaH+O1Zbm1dww1HdYtfmAl+1LGSjXswxW7Bb7RcsDaqjUHcbdzTTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(451199015)(83380400001)(26005)(2616005)(38100700002)(186003)(6512007)(66556008)(6506007)(5660300002)(53546011)(7416002)(2906002)(7406005)(6486002)(8936002)(41300700001)(966005)(6666004)(478600001)(66476007)(316002)(66946007)(8676002)(31686004)(45080400002)(921005)(86362001)(31696002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTFoR3pGVFZZREFzTng3MHJ2TnVqSFJtalA1cndPRTBab1lnQ0NyZlcvNmNV?=
 =?utf-8?B?czBpTDJaeklKL3AvemFJbEgrOUlzTzg2Vy9pcHFqbnFRejNMSlI1TkU5ZVI4?=
 =?utf-8?B?RlFUYzF2alhDdGxhVzl2Vmxvc2JyZm5JTVBNWENDREZ1b0RsY2t0YWNlL09F?=
 =?utf-8?B?UnFPV0VTWWc4K1pMZDZZZjJjV3FxR201TmV2Q1lMR3p3c2RnR0hzSTlZNDBx?=
 =?utf-8?B?blNTMHBTMVVNS1BZcVhPWFR1OWN3QmdRcUdUSHJFeld2QjdRenpYM2JaaE5J?=
 =?utf-8?B?Q2FRT2MzNFY1OUxBT0RlR0psazF4dXdtUW1OWUZDeGZnemxDakliMmpzZFY2?=
 =?utf-8?B?eHdLOEZPV25JYitxVHQ3YU1UMGtNNzN4a1RveDhZRGJ1N0dlNFJOeSs5Rkc5?=
 =?utf-8?B?ekRkUk5ScGtKeVQvSGwxRUU5UGZLQ1dQcFBsN2JoSTFESEhDMXh6Uk9TaEtm?=
 =?utf-8?B?Sy9IZUZtMWhHWUZmRmNsbXpDN3ZxTUlxWHRYcDNRUG9MNVR3TXlTdkthTWlB?=
 =?utf-8?B?cXJaNlZIYzM2MTkvNm9ac0h1cUJSei9KYzU3ejdFSTlZM1JSZ01NVmVSdHIy?=
 =?utf-8?B?NzhMR015T1llMFZkYkM1MlBqZk9VL04xbHdDejBpZ1FwNHNYWFBIQTltazRj?=
 =?utf-8?B?VUVCa29zUTNsSHNoMS94OHRuN2pFMW1ybmVrS09QM3dWQmc1bjBLMkZYdFFR?=
 =?utf-8?B?TEJWRGhBNjVaWjVvOUlnYUsxUzg4RzJmbEw0QWlVSnFYaThRQlhucWNWSlBk?=
 =?utf-8?B?TUluRnJ3S1h2cGdyMUgzblFNeTFQZkZZUWRGK0ZVZS9KUEkrMDZlNmVXcVVp?=
 =?utf-8?B?NXBTS1M2TWpZMS8wSlg1eDV4dmt0RnE5QzNTNGw4eHRycDUvZHpEMHpTOFQ5?=
 =?utf-8?B?VDMvY2RZYktyaUlpTmtCT2lYN20yWUJUSWcxVFZrMzdvU08zU3kvWTdIVktT?=
 =?utf-8?B?Uy8zd040S1kvY1pIY3ZoWWNzV2crK2swMjdtOXNjN3Z0RkduWnZGOFdJUTR4?=
 =?utf-8?B?OS9XWWRZMDEveEszclJxYlVQR3JzNXBrWG8vUlpsTXZCczVkcyt4TUJyUXhB?=
 =?utf-8?B?V2ExbFNJY05Ka2REKzFWdGs5MDhBWGNHS2luQWp4K2Y4d2ZuMVZXMG1MZjlo?=
 =?utf-8?B?bmlNWHdneTlpL0lyMkw0V1UvVlc5ejZKMU5INGM1eTFLbktYT1ZkVHk1OUg0?=
 =?utf-8?B?cHNWUEwyN1VacGhQQnNRdTR2QmFHS0UvbEd1MHRUMjd2MndsVExhcjU4Z044?=
 =?utf-8?B?NmVRUElXTFRIUzR5Uk8zT003YjVuei84ckwzOHM3YUZoMWFWZi9CNWU1SDV5?=
 =?utf-8?B?UFoxNVhHSTNERlFZYUpQSFdvS1JEZXo2L20rNkIzeElFTUxTQ0pVb0F3TDc3?=
 =?utf-8?B?cEp3NDB6NkkwL3ZNTEJMUzgraXJBVWpUa0VJYUdrOTJZUmFrcTlLMVhLSm9I?=
 =?utf-8?B?UXErbDJsR1kwZFJTMlJ2djR6Wnk2ZGNCbTdhM2xnY1JOTjhJZWRaZldvdVpw?=
 =?utf-8?B?SS9hYzBLcE5hdnRCZ0JEV3U1K0JKbDNQYVh4d2VJVW1XMU9rU1NrYTdSR2dQ?=
 =?utf-8?B?U2RlNlBpVDZFNmZwdlMycUhOVlNrM1F6YWRvM3ZURlN3WFlGeW4zc1hoeURy?=
 =?utf-8?B?NHRqUWpzNFVNWFA4Rzk5MURiSjd0bXJQMXRHTUpCbzRDeW93Ty8zNTdtdzFB?=
 =?utf-8?B?SlpDaWExRTBFTDNtRnVoT3crZDBBc3BabjFQSnFRS2I4c3hiQitsY1pWZHR0?=
 =?utf-8?B?ZXYxKzVKZGY3M0pqZmZ0MjN6MXM3MHd1RlFZM3ZvV3d1NUxxcUNCbnU4VDVK?=
 =?utf-8?B?YkU3UUsyRFpKYmc5Qy9MSXVIcnhITGdCN2hib1hMVE5PZU5sc2RrSlFuNTYy?=
 =?utf-8?B?ZFNDRmhrZUlOa1F4RDZyai9xQk1IVXY3aDc2Z2p6dTR6L1Y4amZaYTZaa1Zj?=
 =?utf-8?B?UmN6V25TZzNjMS8vU2lxMEFILzFVSHBzcWdWYWx2VXdpYVk3Rzg3QmJ6TUc0?=
 =?utf-8?B?RWZnb0EzUzRnQUxmcnhCRnovd04wZWtnbXExSUFlRW54aFdqQllBTWo3dnVX?=
 =?utf-8?B?UDRxS2dwSmxPRW5IVGRJR1NKbkZ1a2JNcmxmL1pCVVF0RWt2VGRzSWdhYzNm?=
 =?utf-8?Q?6ZHUZTNZzAMq939bGIbNidE48?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee1446d3-9f2f-4f6d-187c-08dac41585bf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 18:49:54.5315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XCNmf/ckM7EPQAajVQtXxjXd+hberMaiOV36cn5T3Ij1KsamoB1knPATbTT/Rxgfoo0fTYG1+BiqpO3G/+6HKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5460
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/22 00:21, Michael Kelley wrote:
> Hyper-V guests on AMD SEV-SNP hardware have the option of using the
> "virtual Top Of Memory" (vTOM) feature specified by the SEV-SNP
> architecture. With vTOM, shared vs. private memory accesses are
> controlled by splitting the guest physical address space into two
> halves.  vTOM is the dividing line where the uppermost bit of the
> physical address space is set; e.g., with 47 bits of guest physical
> address space, vTOM is 0x40000000000 (bit 46 is set).  Guest phyiscal
> memory is accessible at two parallel physical addresses -- one below
> vTOM and one above vTOM.  Accesses below vTOM are private (encrypted)
> while accesses above vTOM are shared (decrypted). In this sense, vTOM
> is like the GPA.SHARED bit in Intel TDX.
> 
> Support for Hyper-V guests using vTOM was added to the Linux kernel in
> two patch sets[1][2]. This support treats the vTOM bit as part of
> the physical address. For accessing shared (decrypted) memory, these
> patch sets create a second kernel virtual mapping that maps to physical
> addresses above vTOM.
> 
> A better approach is to treat the vTOM bit as a protection flag, not
> as part of the physical address. This new approach is like the approach
> for the GPA.SHARED bit in Intel TDX. Rather than creating a second kernel
> virtual mapping, the existing mapping is updated using recently added
> coco mechanisms.  When memory is changed between private and shared using
> set_memory_decrypted() and set_memory_encrypted(), the PTEs for the
> existing kernel mapping are changed to add or remove the vTOM bit
> in the guest physical address, just as with TDX. The hypercalls to
> change the memory status on the host side are made using the existing
> callback mechanism. Everything just works, with a minor tweak to map
> the I/O APIC to use private accesses.
> 
> To accomplish the switch in approach, the following must be done in
> in this single patch:
> 
> * Update Hyper-V initialization to set the cc _mask based on vTOM
>    and do other coco initialization.
> 
> * Update physical_mask so the vTOM bit is no longer treated as part
>    of the physical address
> 
> * Update cc_mkenc() and cc_mkdec() to be active for Hyper-V guests.
>    This makes the vTOM bit part of the protection flags.
> 
> * Code already exists to make hypercalls to inform Hyper-V about pages
>    changing between shared and private.  Update this code to run as a
>    callback from __set_memory_enc_pgtable().
> 
> * Remove the Hyper-V special case from __set_memory_enc_dec(), and
>    make the normal case active for Hyper-V VMs, which have
>    CC_ATTR_GUEST_MEM_ENCRYPT, but not CC_ATTR_MEM_ENCRYPT.
> 
> [1] https://lore.kernel.org/all/20211025122116.264793-1-ltykernel@gmail.com/
> [2] https://lore.kernel.org/all/20211213071407.314309-1-ltykernel@gmail.com/
> 
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>   arch/x86/coco/core.c            | 10 ++++++++-
>   arch/x86/hyperv/ivm.c           | 45 +++++++++++++++++++++++++++++++----------
>   arch/x86/include/asm/mshyperv.h |  8 ++------
>   arch/x86/kernel/cpu/mshyperv.c  | 15 +++++++-------
>   arch/x86/mm/pat/set_memory.c    |  6 ++----
>   5 files changed, 54 insertions(+), 30 deletions(-)
> 


> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 06eb8910..024fbf4 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -2126,10 +2126,8 @@ static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)
>   
>   static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>   {
> -	if (hv_is_isolation_supported())
> -		return hv_set_mem_host_visibility(addr, numpages, !enc);
> -
> -	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
> +	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT) ||
> +	    cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))

This seems kind of strange since CC_ATTR_MEM_ENCRYPT is supposed to mean 
either HOST or GUEST memory encryption, but then you check for GUEST 
memory encryption directly. Can your cc_platform_has() support be setup to 
handle the CC_ATTR_MEM_ENCRYPT attribute in some way?

Thanks,
Tom

>   		return __set_memory_enc_pgtable(addr, numpages, enc);
>   
>   	return 0;
