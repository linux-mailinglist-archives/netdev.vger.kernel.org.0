Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF15141E122
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 20:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351937AbhI3S3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 14:29:12 -0400
Received: from mail-dm3nam07on2064.outbound.protection.outlook.com ([40.107.95.64]:21856
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348666AbhI3S3K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 14:29:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTAxhD6vP94zgUWaHOUdHmtyVoj+D33RdOxSCrrk0/p1tVchozPdhCLykoiKXQW3dbbLy/AoP0FHXxBxDDKeJnyuP4SMdiklxsTkpANaTppwmqvMGd9HcZsZJ4IKwZ5ItJRCU3e5XwTW/v82JRjVxrjDC0ijEWbkCbL6JMWkohp4DNpWIYJhO8Hp6n6MZPKUPRPql+YgkaBEPunsja6obOseNx2k+0GRmv96VdRH9A8zgpi8n+3SGWSQy8ujByHdB7ymxAbr6OWcY5+DUSRgejlXvD6yNeqW5HwGWxsg8/NLBGpKtsbfxSlU4/EJDofSeBqbzgseUKkjJPMTD1DeyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=mGpMci9yuS8MlLlFkTUsNZ0KeVBjeXGEnshLqGB6mHA=;
 b=Oywg5qPWENm46luNvaNWA6XbjnOoOfNeRztq4IT7fy3bdbZZa5UyoVrt12ljr5J1r1v1E8X7C4pDm6uM04P74kBr6BDoTMWEu0DEcoiFjvg+ODSrmtDgohVNYofxl8lM9qq9btRc37XbhKi1hrfmUgAWujiZHpCKbPw26jrCma75jA/AbW862CoV6wOIRj1mQ5Xed8Hm7ekWFNgd+Hodug1qs8SjCR6hNwknOTjqiqM7Pzoau/FzHrEhMZSBOWwhzhWn/mD5aAYqyWGrjuUUdRnFDq1sE5EItAVHX8HNa5/TzjxxAbK7xzV/3nG0p66EYlqxWieLiWbJ1FnIUBh1kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGpMci9yuS8MlLlFkTUsNZ0KeVBjeXGEnshLqGB6mHA=;
 b=1TEjbW5YKXYet0PGnepGClupf8SGc97CzcBk79VK6hRveDA6/c/H/xtE3syj7wO0BRxygNtAaE0/S8Biy29nDgNMZ4ErxxVNBdo+/0oGfm4IWJvZSFYZBtvZJNdDs+rtW+a0SN493jcq1SrbMU3isc06f8zA3FRguqGgAbk6658=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5104.namprd12.prod.outlook.com (2603:10b6:5:393::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Thu, 30 Sep
 2021 18:27:24 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418%7]) with mapi id 15.20.4544.022; Thu, 30 Sep 2021
 18:27:24 +0000
Subject: Re: [PATCH V6 5/8] x86/hyperv: Add Write/Read MSR registers via ghcb
 page
To:     Tianyu Lan <ltykernel@gmail.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        akpm@linux-foundation.org, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, rientjes@google.com, tj@kernel.org,
        michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
References: <20210930130545.1210298-1-ltykernel@gmail.com>
 <20210930130545.1210298-6-ltykernel@gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <0f33ca85-f1c6-bab3-5bdb-233c09f86621@amd.com>
Date:   Thu, 30 Sep 2021 13:27:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210930130545.1210298-6-ltykernel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0103.namprd05.prod.outlook.com
 (2603:10b6:803:42::20) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by SN4PR0501CA0103.namprd05.prod.outlook.com (2603:10b6:803:42::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.9 via Frontend Transport; Thu, 30 Sep 2021 18:27:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5c057e4-aecc-427f-a335-08d9843ff288
X-MS-TrafficTypeDiagnostic: DM4PR12MB5104:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB51045B51F3469577570E3656ECAA9@DM4PR12MB5104.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VI73LsV92htIWJJqgYvgpe+0ax/qZga4qm7VxJQ14WH1t0EO2BfYSd+e63oXInwRQUXuG9+gqaz/WgdENTsN35+4W9S56gATELrwzFYtdFDg5/9hMLC7VhHi0tG5NBIu4/pxR+I34YYFj/m0/L9zbM8TvVPmjdOERjV+fO6mkd4M86M5IFRha0ZCxqWwrqtNEqFSB5utkTp64xzxHFp5tn+hcDafujS+6/+k0bfiuiyjLi8QZiE3ZtRy44A/juxP1i77LeFCb6fcnidyQzWKj8EkW2MDn4QpnaL1oqpOe1K7zw3s7VzLWLTS0PAEc0XyqnCzznXGJCZjYXuIz1nMdoYd33nO9e9dIQi4whFgNnP3Uc14peqMf6H9TEIs5A6LoROCJVbUhHkjkR1zdae28mDDXA/VEgA1hCbVqj1ckp6kZZEhafkT5R5AvdAFBtbQ4IcFxb3u2XwesFYdssZHU3GVhVpAV5MM0zMbFlVWoDY5T7Y0NZD8ptpAorfgloftwPDg1dlnltxYyuYJEIaEMNRSe/cPO/+1S5cGSX4xAV3Vphnr35WApqkI1VKeKlx2nNE1ekVd/RfyXKpWvMtUO/7jj5JlcBLwM178N2nKMNrRRyrcdMQ++AH4lYMLLYEKBcM3VC4cn4/4cBPOaC5liIQzYdvPVE2scPh/zR76/d+T7WtwOZUjyQ3wLBbEqrvNGBcAoKnxaXUIX9XevfDIUKYZgSlGX2k9mXV7IbMvdt0jbSrCVWso7U8JkgkXeygmHEHs/rbinbB1OEsoctdkMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(38100700002)(921005)(36756003)(31696002)(4326008)(508600001)(53546011)(26005)(186003)(45080400002)(6486002)(956004)(8936002)(7406005)(86362001)(2616005)(8676002)(31686004)(66476007)(66946007)(7416002)(16576012)(66556008)(2906002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEh1T0hDTTZua0ZNN1VGRU5BdDl2YXpKY25ZbFIxTldIc0xCWUtMOHIwZC9t?=
 =?utf-8?B?WkpIdGpzUEpnSG5XdkNqOUJKbnNLaWRtQ0toYXRpR2RhcDdCNy9TZjlBTHB1?=
 =?utf-8?B?b3ptQWpFeWpia2JpWmxwaHJ5QWxoTEpyeS9qUVZqS2xhUU5uQ2N3dWlSZEhq?=
 =?utf-8?B?Y1dLNlU2ZHJXcmpFWTRvalVQb2ZaYXFaZDd1UnZRRUtMUzNpdHhlMjdFQ0M5?=
 =?utf-8?B?a1FiTG9GMnprSHJXVnpVeEpVVGhDRlhhNFVZeVF4UmdsVjZ2U3FFcmJmdk1U?=
 =?utf-8?B?V2RoWEwyWEV2aDBUWjk3d3pWNkEvazFqclpGS3BkL3JPMmc3MG9BOWZPMXU3?=
 =?utf-8?B?bklpMUExbTVaZm5Eek9OR3FZRmhGOWk2cE1SdytrdDBabWJJYU5TeUM0NHE5?=
 =?utf-8?B?MkFEb1lQckUxUFU5Qm9LRkw0TkJ0SHVDRU1heVR4b2p4dCsvM3FjRnZ2UFRN?=
 =?utf-8?B?cWRWN0dGaWV2OUk4TGhMUnpLRkVUK1BQeVdxYzlxSkl4dnJvV2FLY082TkFx?=
 =?utf-8?B?c0NHUUxLZzlUVEFCRlNkOWhDVXBGQnhUSS8zbEIyOWx2WDZrTjlmaFhVeCtm?=
 =?utf-8?B?WEpESHNBWS9tQkd0N2xrSVBoVk9EZldpV2tveEcxWTAxMGVBOHMwS2xMZk5n?=
 =?utf-8?B?UHArQkw1S0I3Nm5YSTZ2bzNiQytqdHpOeDR2Vm9FZVBZV2NCWkI0TU9kYThv?=
 =?utf-8?B?eUt5a3RsWEI5RVc1bHNUZTZXVi80WXY0STR2V1g4VVFSZEJqbTF3UlpteDZx?=
 =?utf-8?B?Z3dVaWNVZkl0NTRybFZUYTI1MkRVbVg4YkNyMGc5ZHdrVkdiR0RwajFZL0ZO?=
 =?utf-8?B?eTlRQ3V4KzYvVlYrVVlYUUhKdiswNmhGOTlndkNidkZFUE50dDFWVEE5bEtu?=
 =?utf-8?B?dEZobjMvdHFtMFFQSzBjSDlyZ3JMaFY3QkZldWVDd3RaOWpqbVBzdXdyODRs?=
 =?utf-8?B?c2YrM1RTR3VQN3Rhb0Z5Y2NvZ1pCZ1Y4T2w1MmtGVzkrQXUxOVV0b0luMUFi?=
 =?utf-8?B?MDhxb2Q1SUszVC9zSEx0dWprVE1qTlVoU3ZpcmZyWHF5R2lGWDZKaG82UXVQ?=
 =?utf-8?B?cjJ6VC9PMkIrRDNwS3MyWkl1Um1uaFI5ZXBhNDByVG9WbDhCSWVkcldHak4w?=
 =?utf-8?B?ZUZXME5FQ0dMSzJkZWdzWEU0bDNvOWIyQndYZVFlU2hiQ1V1Y0dTRm5jWlVo?=
 =?utf-8?B?RVZ5bFFWS1k4d1gzdkI5cURpT1g0ak9QV3g1bzNMbW5OaHA5RXlSMWRpeGoy?=
 =?utf-8?B?U1pvcWZkNnpDRWYrb1ZMMCtGTzV6RklCcUdEU25JK0VRZW41UFhKQi82a0Mw?=
 =?utf-8?B?T0dldHh5dHBxcFNsWkdseE9NWkMvM2YxVEY4NmlQM2swU1dnSWlZY25HakxZ?=
 =?utf-8?B?SUlTRXhhS2ZzSGR2ZVFmb3pSUVh2UXJRbERZWWlxYVh0ZS9COXVYQmJqdUJT?=
 =?utf-8?B?VEw0SFdmUEQ0cW45eHVEcllUbjdyRFVrdXc1d2lQNDlVSm9EM091SkZyTnhr?=
 =?utf-8?B?aG51U0hUU0M5aXM5eTh2eUF3YWVBbWZvSUFuMWphOFdqQkZMQjc3aGhHUUU3?=
 =?utf-8?B?VVl2ZDlNYkVaek02K0dSVzVNR0ZxWXY0UkpVUnBKNW5xK2w1UndLVGpGWUZq?=
 =?utf-8?B?ZUIvV2FQWDYxQ0tmRUI0MlVEVVcwL0Z4SGxjM2pnZ1R6Y2ltMmgxWXhMRXFi?=
 =?utf-8?B?ZVdEeVMxQktjczBxc1Qzc010RjROeS9LRlp5MHkxa3FFbk9PdkJTRjVLdzVX?=
 =?utf-8?Q?WCdjN5ae0n7681WhG+f1qdN9ZecmkIDOC1wQhOn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5c057e4-aecc-427f-a335-08d9843ff288
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 18:27:24.0296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +xoHsz+4rnjDZcSz77W+BHlbyHiXC+cBF4bu/y0+3Zj9m6Ozw0S0DHS4GmXRngpZF1aeZy9Bkh0daOvJJq+RmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/21 8:05 AM, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 

...

> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 9f90f460a28c..dd7f37de640b 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -94,10 +94,9 @@ static void vc_finish_insn(struct es_em_ctxt *ctxt)
>   	ctxt->regs->ip += ctxt->insn.length;
>   }
>   
> -static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> -					  struct es_em_ctxt *ctxt,
> -					  u64 exit_code, u64 exit_info_1,
> -					  u64 exit_info_2)
> +enum es_result sev_es_ghcb_hv_call_simple(struct ghcb *ghcb,
> +				   u64 exit_code, u64 exit_info_1,
> +				   u64 exit_info_2)
>   {
>   	enum es_result ret;
>   
> @@ -109,29 +108,45 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>   	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
>   	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
>   
> -	sev_es_wr_ghcb_msr(__pa(ghcb));
>   	VMGEXIT();
>   
> -	if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1) {
> -		u64 info = ghcb->save.sw_exit_info_2;
> -		unsigned long v;
> -
> -		info = ghcb->save.sw_exit_info_2;
> -		v = info & SVM_EVTINJ_VEC_MASK;
> -
> -		/* Check if exception information from hypervisor is sane. */
> -		if ((info & SVM_EVTINJ_VALID) &&
> -		    ((v == X86_TRAP_GP) || (v == X86_TRAP_UD)) &&
> -		    ((info & SVM_EVTINJ_TYPE_MASK) == SVM_EVTINJ_TYPE_EXEPT)) {
> -			ctxt->fi.vector = v;
> -			if (info & SVM_EVTINJ_VALID_ERR)
> -				ctxt->fi.error_code = info >> 32;
> -			ret = ES_EXCEPTION;
> -		} else {
> -			ret = ES_VMM_ERROR;
> -		}
> -	} else {
> +	if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1)

Really, any non-zero value indicates an error, so this should be:

	if (ghcb->save.sw_exit_info_1 & 0xffffffff)

> +		ret = ES_VMM_ERROR;
> +	else
>   		ret = ES_OK;
> +
> +	return ret;
> +}
> +
> +static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +				   struct es_em_ctxt *ctxt,
> +				   u64 exit_code, u64 exit_info_1,
> +				   u64 exit_info_2)
> +{
> +	unsigned long v;
> +	enum es_result ret;
> +	u64 info;
> +
> +	sev_es_wr_ghcb_msr(__pa(ghcb));
> +
> +	ret = sev_es_ghcb_hv_call_simple(ghcb, exit_code, exit_info_1,
> +					 exit_info_2);
> +	if (ret == ES_OK)
> +		return ret;
> +

And then here, the explicit check for 1 should be performed and if not 1, 
then return ES_VMM_ERROR. If it is 1, then check the event injection values.

Thanks,
Tom

> +	info = ghcb->save.sw_exit_info_2;
> +	v = info & SVM_EVTINJ_VEC_MASK;
> +
> +	/* Check if exception information from hypervisor is sane. */
> +	if ((info & SVM_EVTINJ_VALID) &&
> +	    ((v == X86_TRAP_GP) || (v == X86_TRAP_UD)) &&
> +	    ((info & SVM_EVTINJ_TYPE_MASK) == SVM_EVTINJ_TYPE_EXEPT)) {
> +		ctxt->fi.vector = v;
> +		if (info & SVM_EVTINJ_VALID_ERR)
> +			ctxt->fi.error_code = info >> 32;
> +		ret = ES_EXCEPTION;
> +	} else {
> +		ret = ES_VMM_ERROR;
>   	}
>   
>   	return ret;
