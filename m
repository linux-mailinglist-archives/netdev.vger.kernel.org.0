Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51949434CCF
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 15:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhJTN6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 09:58:50 -0400
Received: from mail-bn8nam11on2082.outbound.protection.outlook.com ([40.107.236.82]:32730
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230299AbhJTN6q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 09:58:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mg/h2X60nw4lWBEla1xqGCRlfmVnxVqLd1SBqClYkRwNgLPKe2Lv3tpf51cUXA4DSxTL//YxthAKNHN2dmsC8yP4gyKeB00ReG6GRhIlJcY5ctjEFxORMGLUdFOhsJz/caocJWy6pPRMmER+zGdkKMgYvO41UbpdddY4TYI7IBwyAHaIDDHNjWr1qca5majpbiDpvhRYkJ3AhoAAwlZuIKEYgKx02lk6zXx9hYpoZOQe8KvrkQP7806J766E94iy7174HXd9rW/MM/coDQDMj2TXC2rX9R5GcUtKkG3XZmSm60mlbu2ypyYBBI7MkeEMXlgwvC8VnWd147/rNNn7Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U8m6TZunXY5aWIMc34WFoUBMpnz40/o1YX2fbVe9hUo=;
 b=kdQ77L+YCwQF2P8k41cvrr7wIN4o8tIu3AjukHz48WrukXDAIO3AFgFNuBWN82syuBKHqHKaw9AW/36aTCsPMABviA7fbKtBxKLMA152DeKiUk7Vuzqx2/LabAyE6CD6CAuyieVv2juJzf1xx6H85r6OcKH+mkFYLSpVhGlfTFq5uprf1DBL3+Wuoe/UzoNqbOMHJudPEO4NdPz9RQXtkWy/8uu54xxTiN7mfcXqITbptWAWJM6ryxYbvFgG4hsffTjQxDnSad/kwAPGyCHF229/z9m9C3PltC4aKTNcNrBImKtIOfj8l9KPgJgM3vnB1GMMjSHs979Ycovj+rn7PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U8m6TZunXY5aWIMc34WFoUBMpnz40/o1YX2fbVe9hUo=;
 b=BK8pbIq9+M3kszyFKnUbfRcydqNrEyWbvDwDv362gxCwzPdTKxEb/3MLilWsF1VsNtN0/7Y++4ACuICPUnkV+Bub8DMPiWxZIUmISnH2PayPsybL8MAvMSZc2ybQrzfjpISQm4eEKGK88lnYlhvObPXnxWwqsAryoaRaGuQ/DLw=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB5536.namprd12.prod.outlook.com (2603:10b6:5:1ba::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 20 Oct
 2021 13:56:28 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%7]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 13:56:28 +0000
Subject: Re: [PATCH] x86/sev-es: Expose __sev_es_ghcb_hv_call() to call ghcb
 hv call out of sev code
To:     Borislav Petkov <bp@alien8.de>, Tianyu Lan <ltykernel@gmail.com>
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        kuba@kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de,
        jroedel@suse.de, brijesh.singh@amd.com, pgonda@google.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, tj@kernel.org, aneesh.kumar@linux.ibm.com,
        saravanand@fb.com, hannes@cmpxchg.org, rientjes@google.com,
        michael.h.kelley@microsoft.com, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        konrad.wilk@oracle.com, hch@lst.de, robin.murphy@arm.com,
        joro@8bytes.org, parri.andrea@gmail.com, dave.hansen@intel.com
References: <2772390d-09c1-80c1-082f-225f32eae4aa@gmail.com>
 <20211020062321.3581158-1-ltykernel@gmail.com> <YW/oaZ2GN15hQdyd@zn.tnic>
 <c5b55d93-14c4-81cf-e999-71ad5d6a1b41@gmail.com> <YXAcGtxe08XiHBFH@zn.tnic>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <62ffaeb4-1940-4934-2c39-b8283d402924@amd.com>
Date:   Wed, 20 Oct 2021 08:56:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YXAcGtxe08XiHBFH@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:208:2d::34) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by BL0PR03CA0021.namprd03.prod.outlook.com (2603:10b6:208:2d::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend Transport; Wed, 20 Oct 2021 13:56:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a1765a2-4975-4785-3186-08d993d16951
X-MS-TrafficTypeDiagnostic: DM6PR12MB5536:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB55366BB4DAB8EA04B4507A33ECBE9@DM6PR12MB5536.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dDmoLnQpjfAH7ECB28crP8woAWvICL/32uYYk1tBEzCuL/MBywiKEorVN6Evhcxcp5KEMpPD22vEqb1CVoIISjc8W2Nb9XnzgOx8NQNK/0Xsbg9S4qyJJDmxT55wFVgmYytfCCyUgHedTAl2MWtC7jTwONLRapb4CrTD8bvT9zmwg0pF6GhQGmoKTDRjP5RnNKIIlXLYgdIMEWQ+mx+hhIXHWJuDqwP4eOGoOKDKsA+ixoBBiW1e9FZOSjTSbM76T7N+5AhmDd011RzrO5Y9Yc7FjCiQJ/Rjy6aDYvUjQ1bIsDU20wQk3c0Yl5NAc+69FsFRGUbmFtRGSfB2uVxCk9kVK3s1RAI9Hf7qGr9iepUN2YQbEVsNxjoIFh655jvlD8SUzxZjF/sGtD5jj+tXlBsnOqcXiA3v/L+M1vXsiYh4u0dBomxycTxCVajd7/GK3X9yXZZ/jSOhwXSgf8ouwXeXoRFW6/Qq56yUKFrGJQeQ/mA60aw+NdnaIZYhy2YeHGLFhrhSlfekFS+u1oBcZxCPJZKSR9yiSlwMka1N0fOrbhReiXpbFDSZ5mscY4boFCvRn6hkRDhYHcegHkpzQBmvRT8ug3yHPSsIORK/A/sJBfWI8GQ2FYSw9f1i1377VSbeg9sNxkTvoyeULxIBe7sEEIV/UQ0ZiGDtKf6tlkYFeOghW3The+hvAbX4IouMJGNKZxNqOwg+Yi76knO/SszdjQpA2YA9oCC5LAfM+OvXSHjT6Kq9iAG7uUu+Qd+K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(16576012)(26005)(86362001)(186003)(31696002)(53546011)(508600001)(110136005)(7416002)(83380400001)(31686004)(36756003)(7406005)(956004)(8936002)(66946007)(2906002)(66556008)(8676002)(4326008)(2616005)(66476007)(316002)(38100700002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YktHRFp1dVBxOFd1K3NxR1orQ3lIRlBkS1ZZdCtQOGMxVnhQWEZiWk5sY1Vi?=
 =?utf-8?B?U0JaU01zUTJJRXpsRHFLWnAweHY2QStKSmhqQW91bkpyVHZMblEvY0krNHY0?=
 =?utf-8?B?TkNzTEx0K1hZazFIUC8vaGlkTXZVZ0p5VXhqa1hnems3Z0VoZjJkK0JqZG1l?=
 =?utf-8?B?aVJ3eFkyeld6Q0pFZUdjYmNWeVl3ZExTN2czd2k3anowR3ppak9GVnFNR1pG?=
 =?utf-8?B?VURlNm1VY3diRzBpMjlNZGtnMEo2cUFXK3ZpZ1pONVpxWmsvbFVpODZMdUZH?=
 =?utf-8?B?SHJPcVFod3dLZDFqblhMTlBPcWJsdndsUXVvcG42YTl1Sm0vT2p0b3F5ZW4w?=
 =?utf-8?B?azNXdC85d21DN04xamtyVTlGWWFEMzJCY0hOVlQ4S1Z4Nnk1WU04YnJadkox?=
 =?utf-8?B?L1VwN3dyRWZOTU1ZelVEQjUxUTlXZi9rMnU1WFBlL3NYeE13cUV4YTdSMXNJ?=
 =?utf-8?B?ZU5uQmlrRjF1RXQ4UGpNbzFHSkZDRW9CMGZzanNZQ252YVY0MVJLMnc2VXpV?=
 =?utf-8?B?MU14OGNoMWJCTVZ3VlNqQndEKzg4T3NiNXJLOFFYRndGMUgvQjZwVWJKWFRt?=
 =?utf-8?B?b3ljdTdScmlRb3g0N2ZwNHpXRCtjYXBVSUppNXVYYVN5V0dGdk45NUxYSjZ2?=
 =?utf-8?B?TFJVeFBNTm9IN2VBRFpETHNFaEsyUW1qQTVDdkpJWE03Z2FnQm14bnNRQmdh?=
 =?utf-8?B?YUJvenlwSHc1STBCT3o4bTB1UXNMRzhGLzQvdEpyNW0wYU9jdkxmWFN2WXZQ?=
 =?utf-8?B?Q2F6WElQSWl4UGJYMWhKbythTFpLWWsrWng0Q0tONURrdkhMdENVZVFFQU15?=
 =?utf-8?B?YWF6aWFzVHdPbHVDMExuSDRwSkpwUktiSTNjWjVRRGNNTVVxWUYxV0t2elpU?=
 =?utf-8?B?TnRmbWJGcFpSZ2RuN3FaUFNmbmkyQkcybFozOXBDMEV4NTVyRFBxR3h5N3hF?=
 =?utf-8?B?ZTdyeGhBTFZYTXJ0S1ZNRkphQkRTR0pyakdMUmpPTENnOFk4L29RekwwWXdL?=
 =?utf-8?B?K2FNVE5keDNzTmp4SUE4MWh3YUw0QmtWTGR1enFVTWN3N0ZheEtSQW93UzZ4?=
 =?utf-8?B?bkUvNEFrZVZNQlZNMkkrTWRMQWI4dkRIK1NEb0srYlFPaURad2NlVWRsU1NP?=
 =?utf-8?B?bEFSSmNINUpIU2xpNERZS3FBSVdwNEVmT1g1UnZMdmJ4YkhaUjQzVVQ5M25H?=
 =?utf-8?B?bmwvZG5JZlY3K1Q1cGlYSEhsS3dhYmFPTzVnSWdRWlp3ZWxkaXpESmhQeGJH?=
 =?utf-8?B?bUFuYXoyaGhLUWlRTUlTV25LeitsL2pWVVBpaXptL0xWMFRKSDBSaXpWdk5M?=
 =?utf-8?B?QVZSMnZwdjFyVTVmcmh6eHdXSGUyYkZBa3JSS0hpc2doSmhKTS92ZlJ1MVdu?=
 =?utf-8?B?eDFhZUxhN1hKeWNnUjNaUUVWTjFkelZ2Q01UR3ozaGRuOENPeHVCcHViL2xn?=
 =?utf-8?B?MEprMFJYcjBQZ0xKbVRMUWVmSUZFc0Q0Rk1UVXpYTFlhcUdlNnR4VFFvam1p?=
 =?utf-8?B?NUtqQXhENnRXelFaWDdhZFZhRXlwS1FhSXplckpOQ1BxR3VMWTNpWFU1emM4?=
 =?utf-8?B?TDhkbDUrT3dBNDNUUTRybXZOUW9VQWFzVmhNZ2JOQTJBRklaSWxzeWxITGpl?=
 =?utf-8?B?anFHRWVTK2RuYmR1eWwzM1J4Q0tXYnVFUC91WEtqVDQwZ2Q4Q1ZQOTJjOUZT?=
 =?utf-8?B?OUJ1UmdrMmorUFRnRDhqNEFFYUhUZm1FOUdtMUVxdnU3MVduWGV4YjVta0pZ?=
 =?utf-8?Q?Pb4zX3/7wB3SIoIuinY04hjkCTD4+mA4seucxJy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a1765a2-4975-4785-3186-08d993d16951
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 13:56:27.8174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +509fiCbU/q/PYIB7+CnvMOkdTWuZXUlKqJRKaANoXQht8bm49bdr7xMcZg6ILgZlyy6GphjAz+/DDnYdZF5tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5536
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/21 8:39 AM, Borislav Petkov wrote:
> On Wed, Oct 20, 2021 at 08:39:59PM +0800, Tianyu Lan wrote:
>> Hyper-V runs paravisor in guest VMPL0 which emulates some functions
>> (e.g, timer, tsc, serial console and so on) via handling VC exception.
>> GHCB pages are allocated and set up by the paravisor and report to Linux
>> guest via MSR register.Hyper-V SEV implementation is unenlightened guest
>> case which doesn't Linux doesn't handle VC and paravisor in the VMPL0
>> handle it.
> 
> Aha, unenlightened.
> 
> So why don't you export the original function by doing this (only
> partial diff to show intent only):
> 
> ---
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index f1d513897baf..bfe82f58508f 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -125,7 +125,7 @@ static enum es_result verify_exception_info(struct ghcb *ghcb, struct es_em_ctxt
>   	return ES_VMM_ERROR;
>   }
>   
> -static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb, bool set_ghcb_msr,
>   					  struct es_em_ctxt *ctxt,
>   					  u64 exit_code, u64 exit_info_1,
>   					  u64 exit_info_2)
> @@ -138,7 +138,14 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>   	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
>   	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
>   
> -	sev_es_wr_ghcb_msr(__pa(ghcb));
> +	/*
> +	 * Hyper-V unenlightened guests use a paravisor for communicating and
> +	 * GHCB pages are being allocated by that paravisor which uses a
> +	 * different MSR and protocol.

Just to clarify the comment, the paravisor uses the same GHCB MSR and GHCB 
protocol, it just can't use __pa() to get the address of the GHCB. So I 
expect that the Hyper-V support sets the address properly before calling 
this function.

Thanks,
Tom

> +	 */
> +	if (set_ghcb_msr)
> +		sev_es_wr_ghcb_msr(__pa(ghcb));
> +
>   	VMGEXIT();
>   
>   	return verify_exception_info(ghcb, ctxt);
> 
> 
