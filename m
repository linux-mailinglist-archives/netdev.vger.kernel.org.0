Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6855749E4F6
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242636AbiA0Oq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:46:28 -0500
Received: from mail-mw2nam08on2079.outbound.protection.outlook.com ([40.107.101.79]:51521
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242624AbiA0Oq2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 09:46:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K876mGsNSjn1/CBIXY3EnLDWGiGr62UgQpnZI6eLpWR/2nBGOfUnDgIzal9p/AGOoPqMgKXunOOD6KlIy22A+F0H0VNmXN2C0yE2cO8pElqKCiFPFxq/qvmS/+ReQDXnMSHT6yYKrtInowpRyv2AKyOCXyK4lsQsjpIAWB4FjCQ5hs3PYjdWxQWZXm3QNhfek7GeJ1wveqp/hfywi5ZmBdcIAi2tJx1XBp6cAkn+/tKuOQn3qdTrSltK3PEsoVtZwHCq82nBsduIC2F0hipaTHFu6h/CrNXBjoDSfh600lGcmH+8CAzeAsYwyiavS20ZFUulXnoecdziNtTFTHiUHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IUeIeOU2gN42gTMISjo20qVWEAzxfPQcO2UAP4IvzsE=;
 b=DHRhGFp5GerbVlAgRRCZjNTPKqLnPux2oYg/soJbEB2v4Dryp5B/fAbQFZopoDns7OPAyQ56bGTl7df2ItrhhIT0uwQdyBUowspTJZUliBb/+hIyuPGgpiFDw3f57kJZwzJ/qcJaiMZ2LtiKIpxot3nrSLqZxAkElb21i6JASlXn2D/uD5w5KRqSTVYc2bt32YMx2f2hxGH5mCIn2RrxIGbT08SWau6AChs3vwE8LnqJcC5aLleMryojeNhBITvJadrt8wPx9Tf4BtOu1EhHGTTpgpa2VRE6pfxUk5sN22JwmXtKG78Voo2XDJNSIVdT2H2cg6VfkE/TkSZ+mFeh3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUeIeOU2gN42gTMISjo20qVWEAzxfPQcO2UAP4IvzsE=;
 b=Rm2lqkxpIZukc9rEZwHP13KS8LI+3jmdbmqm1f+Tpk7//tLB5knClrxQR+9btwNtniCQT9PeqDzA8kXZ/Z5d/kcqMIqDswXkP4k8CV+M1oPIyK7Dh0HvdkL/1s51gyIHJRdPaY9o5N3NRT+CaojULye+hclH/KM61SRL1gz8y1Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM5PR12MB1385.namprd12.prod.outlook.com (2603:10b6:3:6e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Thu, 27 Jan
 2022 14:46:26 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ccd7:e520:c726:d0b]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ccd7:e520:c726:d0b%8]) with mapi id 15.20.4930.018; Thu, 27 Jan 2022
 14:46:26 +0000
Message-ID: <d5d2ab29-60c7-6092-18a6-ce953c4362c2@amd.com>
Date:   Thu, 27 Jan 2022 08:46:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Raju Rangoju <Raju.Rangoju@amd.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Shyam-sundar.S-k@amd.com,
        Sudheesh.Mavila@amd.com
References: <20220127060222.453371-1-Raju.Rangoju@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH net] net:amd-xgbe: ensure to reset the tx_timer_active
 flag
In-Reply-To: <20220127060222.453371-1-Raju.Rangoju@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:805:de::33) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b679b72-ea7d-4c0e-d52a-08d9e1a3cb90
X-MS-TrafficTypeDiagnostic: DM5PR12MB1385:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1385104C988C740C0BBBCB32EC219@DM5PR12MB1385.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QJ/rGKceIrk0ZJbsNYvLtGgXptkKU0zKk1U/2GPk4w3AUq3g0Yju9Ln4BuS7Iy9A0u8+nwKFZpDV+Ww7PwkUbXipPDVrHME2ST406+99i0/swm83Kf6c1RYHAc4lu+vkTI+Z2408Fy4PzrHdnVVFgtYt6sm/K8oUM6FUwidBLVHeAJ/1gBjxYDQQ0t7Wwc9Xexuz9l8TuoPsoJ91yEuXBGUiZNvuIYMly4tBryDxSeakiE04X1s1sASQQTC6qF3m6fQTNaS4Q99hLXJbrNanFFBhjUpNCuA+SH3tvh3PDK/lvwpwCtBXamA+c44hLdr4CBenwkbAp1AiWVPU8KxV1D0VRPEtlV+pv8rdUBUx3AO7nypj8qV9Uc90bl402zawzTwlyOqhVncSINHgWdJ8yIEXmmc1CXiE4LLi0cnwBMuhFyRUCKL2Am2V2Y0lytKPAs/KpJ7lZ3rh431faCIjX92G1f9e01b3Ii87fvb06gK0iaL/GmPTLO1jnYa6mvJuqSsN/NCaEFbFdiU94+np2v8jxwfGYOu31W+TCRyHqr+k+XOOWeO93924iYhRSijaNPtlyq7tX6IRj232OjKBKiWMb4uexLGh4c/JCTm5An+4TBP8DFCAX3C2uS8y7TyzhSek7SFsHgU16BWgsp8SZhOXpVfqAFh2Lmom5lbvKYgCEO/t57s1bz/iaewUyOBeSCbGuyczJq9C+pb40sqjAKLRCbod3LJTNFkTjwqGQi8gbiTg3O5y2K1ZmsA0G0hC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(66946007)(8676002)(508600001)(53546011)(2906002)(6506007)(316002)(4326008)(86362001)(6486002)(66476007)(31696002)(26005)(38100700002)(6512007)(5660300002)(8936002)(66556008)(83380400001)(186003)(31686004)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGNpQjVlNjF0U0dzRXRwSk45OHBkbTRNODFtdlg3R1pNMXBYcTNka0tjMmZQ?=
 =?utf-8?B?bUtQZWJjWnFwWmV0NVBBV0xwODl2SlZEc1g5bUp6bDFiUUdMdmlDV09LUE9P?=
 =?utf-8?B?QzFtSVFDeUhEd0VtQ3hybG1UWllncWpRR3RER2dXMW5LdGVrZEZTaEZuSENk?=
 =?utf-8?B?b2NLbGZMZEtETFZlbStXV05xdmx5UjB1UXZSQU1jOS81bTZQVVNlUk1Pa0ZG?=
 =?utf-8?B?c2pBM3ZUejQza0lKSEk5RG1zUmdwWGFxOVZOM0pEOGx1ZkpTZFlnTWZlczR6?=
 =?utf-8?B?dkR0Z2pNSUhwQ1VBeGZSN1JNMWFISFNIVjJjUndwNFkyTWg1bmdWbk5Ia0Jh?=
 =?utf-8?B?ekhCKyt3MjNJcDMwQUN2Z0hlMWFmenhwTjJQVE1lWDc4MkVKOUYwUWhTeUJv?=
 =?utf-8?B?TkNMTXJueXRyY0JsKzcxMXR4a0JYQ21LM0dYUHRIRXNrSXhMYkZuUWFwVUtL?=
 =?utf-8?B?dnEvOEZ2Y3dvaDdSK21ERjg4Rm5aaUd5VnJkWHd6ekNULzJGZUNyeURCdkdQ?=
 =?utf-8?B?YjN1WWV1b01RZS9aYU1SY2FzNWFDdWNjVTd1OS91VUdleGZySTZuZFpvcTg3?=
 =?utf-8?B?eDJFWW1BWHU2UmpPb0E4eE4zM0xHejZWZGtLTUZNdC9ya1p1WWd0cWRhc3pZ?=
 =?utf-8?B?VUFLSUFOT0UrSm8xamZUc1lpWWdsQW9mMHlVVHhPQkVTRVFDb3dDRk1MZlB0?=
 =?utf-8?B?dENxc2hNV2dlTEVLSDdvQmJ2NjBZc0JkN2JYSHFDc1B4bVczV3p2MTA1TTdI?=
 =?utf-8?B?N21TM2QwQld2VFhuaHlDSXlzQXFjY1BWeVRhRkZWVDZNa0x0aXIrT0ljcmo4?=
 =?utf-8?B?WDc0WldocC9VZ1NlRWMvelpiell6bGpmckErRFNOeG8zR3JSMGpXTEZDSVNi?=
 =?utf-8?B?MWR3ejA0bWE3UXFZUnBXVDdSSkpuSnV2OE4vMGJrUmEzMjQzc09mb1dua2w3?=
 =?utf-8?B?UGV5QVpvT2FpL3UyblRZbGdjVUNnaXJoRUNhODBMUlJ2RW5oL2VSSFQyMzV3?=
 =?utf-8?B?RGFEbytxRWZrbklrdUZWUzcxbkYvQzExYVZCSkJSekdsUmRCYU5GeVpkOXlZ?=
 =?utf-8?B?NjBsZlBVZnBQNy9yUUtPaDZUcHhPUG83R3E2bW9VQjVibmNueHA0T085MVlT?=
 =?utf-8?B?VXB1Mi9WTit2R3NUdmdBeExuSDhvMUUzQlVqdXNvWHd6aUxXaW1NK1RDTmVu?=
 =?utf-8?B?bWNLcVNDZFdGOXpuVWYza2ROQmJlSW1Fd1kvSlB3TGhXVm8xYTVOZG11d3hm?=
 =?utf-8?B?M204S1FnVHphNktIMFdKS3BQdHI4OVNvZWhqU2kyZ2ZjZnJlR1VHYytlYlhP?=
 =?utf-8?B?eWp1dFpzT2NsblhEZXM3QVZ4OWdIYmpEeDNoSGJHdDI5VS80ZlZoV3ZTWjM5?=
 =?utf-8?B?M3pwYnJCNFZGaWNnU3dNb2MxUTQ1Nm9RZGNYSFF4enFHOGxBTDhLMDRwd09C?=
 =?utf-8?B?Sm54OXlJU0tQZnkwd3hrUTdyRU5RY2VwNWQxRXd6aHhsZ21iMXp3dFIwaXc1?=
 =?utf-8?B?Tk5URkFTVVJWRklQdjlPRk9NbkxTZjk1a0pnZ3ZhSi80VnE0RGxqeVNMVUFY?=
 =?utf-8?B?MkJnR0ZGcUI4Y3hadTl0cFdwQ2xXdXByOWNMT0dZUVlIc3RMVy9oSWJiUVJI?=
 =?utf-8?B?Q28wNHBGVmxKUUhnNUwyOTdoVk9vRDRReFYzNVQzWUYzSmhjaWovZnFOZk9x?=
 =?utf-8?B?Z0FZMzI3RkdzSFJMQlBSeFNxZW1yNFgzWmZzY3ZCWkVDS1htTHhPdE9UeGxZ?=
 =?utf-8?B?V1BwNXFjWUVpbTd1U0ZmUHhGRjRQa3VLa09VaGxaS2FNb1BLMzNhZUlMdkZX?=
 =?utf-8?B?TFp6ZVZHLzlSZkdkTEx2TzVwdnk4bkxxUTFKMzFXSTVPN0hwcFEzWkxCUGpz?=
 =?utf-8?B?N2svbFNOMjJFRklPZVpFR2NnR1RwWUl3OVEzc3VyMzlEYjZkb0J6d0ptMVQz?=
 =?utf-8?B?SXo1UjdacHFTZVZBUkpGRGoxZUVDZUNuR2RMOXFsWXdpMlI1MzJvWWFPWlR4?=
 =?utf-8?B?ZFAvdzZsYlNlVnpEUllmMWpucG5ZSlluMHFIemIxZmVwWWFRMjkvMHl2SmEr?=
 =?utf-8?B?Q3hSSVhsNUpTUVhKMndJRDJldTI1VXB0NFpwYzZlTDBjRzlKNlhMaVZOYXox?=
 =?utf-8?B?UzhzUllpYXpuT2FVUlhHZy92a29HSlBUemxvb2ZkcmxWa0dzaDRvQU1ubFFm?=
 =?utf-8?Q?O9Z4fY7hBFTBd0OReM9vpVk=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b679b72-ea7d-4c0e-d52a-08d9e1a3cb90
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 14:46:26.3497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z8mVJTt894v8xXvu4imTltBMl8BWzde0RvQnuUbs6KOkatxL5u9EUzEjTKgswsC63TX5oNDlnCs6WkgXqmfmMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1385
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/22 00:02, Raju Rangoju wrote:
> Ensure to reset the tx_timer_active flag in xgbe_stop(),
> otherwise a port restart may result in tx timeout due to
> uncleared flag.
> 
> Fixes: c635eaacbf77 ("amd-xgbe: Remove Tx coalescing")
> Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> index 492ac383f16d..4949ba69c097 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> @@ -721,7 +721,9 @@ static void xgbe_stop_timers(struct xgbe_prv_data *pdata)
>   		if (!channel->tx_ring)
>   			break;
>   
> +		/* Deactivate the Tx timer */
>   		del_timer_sync(&channel->tx_timer);
> +		channel->tx_timer_active = 0;
>   	}
>   }
>   
