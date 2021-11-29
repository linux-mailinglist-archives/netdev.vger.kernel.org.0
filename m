Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916F1461B11
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 16:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344576AbhK2PjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 10:39:00 -0500
Received: from mail-mw2nam12on2081.outbound.protection.outlook.com ([40.107.244.81]:51425
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245133AbhK2PhA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 10:37:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQp71ZTQz3HYlkd7LmZwVvh7qnfW2SkMJaN9Y1jyy3DoZ9VZHt0GsjDbNcN6/pOHHvbTO+gm/EBM2zk75LVP64Lqt8aItw79aTrzOyDfGU5iDjFNzN/zOuJHtfs8MrBeB1TGpCEOxNLTvkzluqbIkMwltxLbDzJWKTf4XZ/o+WlhohVp4eOHl7Zg3PjGy+GTB09mxHGQq/7LoSpgtqaSHRcKgqLMqGA35ff2+TODPktak80Kwu7OILSNWgO26QMhImIdfH8fVePDDW5B+nvlyo1UBFwYqROKOyvbaVGSIIYG1euUzIBM9McJUbj7ldXAYowEdovwPwyIx++WwxrFVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qAlpiloShDQ5m98inIdvEHcovbY2rgI3zbDvI0JJwz4=;
 b=mfZa6Df1E/g94I6e3xHbT4H2gKQDGEVwn/QdD+elOkg6YysfKPsCRa0uj0w0bhJ5R10jTVJ7zIfKQ3r5Wcv9iPcZXSWzBF9qwhl55ebYKaxaXRPu7IHXzBOUevUrL6MogC9hXfK9bGIjU28qh4S2JuSZQlKSQtzIQRSPHOouWsGO8wZmVotW4vsR1sW5PXX9ybcwFs5ncNA0q4Jtb5ibxRMnwDzF8nEb0w2o60S+ZkTrfuiTsrzVDsvVgfOwKiBDwMbK4Cbn+MzRzucQfQFXedF4XTTfD72ldxzoS985CDj7szJvT0X/Gp7AeglrXziHZ7JO9u4lGc7Xhry9J89qrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qAlpiloShDQ5m98inIdvEHcovbY2rgI3zbDvI0JJwz4=;
 b=hLCgulR58fL/jW6eouFBTEbXLSKkUCKHgVhQZchl1DmR9x3eR+T39OmDVSF/2/Xb1jLX30QyJgRFyqTM/qOTdurRDiXL1D0eMFq+4qfUnPhEK5FvaazDNO6KZGQr+Rg29cgbbPHFgLEvasATa4dEdt22UZ4jeC8sxtHE0Q3lF5SI7S29sJEnsJTho3iZt1s+zH8m+os7mYRtQYxpRKBF1OpX8A7f9naTDWNu10GWtM3YKjJSVClrFWQOLld6zgSX04VcEB8tMplPg10Zi03dSbVdLITXZhTqqnzkqU2e3/UCohGEaUhMFDIeBuzxpxJed92KErs2nSbohIagG8/0iA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5039.namprd12.prod.outlook.com (2603:10b6:5:38a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 15:33:40 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::2c70:1b15:8a37:20df]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::2c70:1b15:8a37:20df%3]) with mapi id 15.20.4734.023; Mon, 29 Nov 2021
 15:33:40 +0000
Message-ID: <8f11307c-9acf-2d83-a7f4-675c46966ede@nvidia.com>
Date:   Mon, 29 Nov 2021 17:33:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net-next] net: ipv6: use the new fib6_nh_release_dsts
 helper in fib6_nh_release
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com
References: <20211129120935.461678-1-razor@blackwall.org>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211129120935.461678-1-razor@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR10CA0076.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::17) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.42] (213.179.129.39) by AM6PR10CA0076.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 15:33:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f423688e-eef8-4570-5533-08d9b34d9e4a
X-MS-TrafficTypeDiagnostic: DM4PR12MB5039:
X-Microsoft-Antispam-PRVS: <DM4PR12MB50390FE0198325E7342DFBEBDF669@DM4PR12MB5039.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1tWaR9V5JWnVaNAMZ5p5ulrNpSkqv5y+VAXpM343o55YebtxxpmiuxQmm7HFloq82HKY1l9pN3cjDA/EV22/nsRI9xGHKAUBqZV5qN2Qh31HRSpl3VLrKpcenqxNa5xSqXAJkhITK46zyjtXJkXkBEiRFc/E+6OOjByvv8ju7fpNyvTd1HbANM+A5UwWd6pGDHw3weWL24Ui/r+CQGUt3+fO1yhPGMeU80iShtbtMOlqoChGLWkfOuUocSKihtc5AUf0fZ0QUXVff5S55/tCV893VmEAwTJ/UI3/0M1cfqVaeOKyZM0JcCD221sis7/XSu67I0WYvaqnLUX/3JnwE65gaUb8hLVWEg6Ds8TJ1dgE78hARlQ/bIdO2Tksq2N/R34730nXl21Ez1il35vFxLdut96v04DWD52d/rcVCvjFnJkDNQ7aAiruJgSNCZn6epFmD3qlqVuh459cPmuX8Pu22NlF5uPLdZuiyTRxCRIqJdurhRtMsRdxDsaMcBgg0DYYSGSxzpROqnCZ5jHQ7oGYyvmHuZOKxs0Xx5FZrHsTammwaGzw01Eoduy3JRGNaokZur0FOPFU8akoSLm/aI8Cxuc/3njLyK4HQTFMfsFMfkSltZ5rAr8CMvENpCQQxBlCuIMzBv2KRwofvwZCU7JI6nZYekgRT8VX9JSrssAalTAoTwQQjJhuF39WLJx8/OoKmbfsh391C3vwn62mvn6Rm3d2b5iJ7bFfxk4M0wE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(86362001)(186003)(31696002)(53546011)(26005)(83380400001)(508600001)(6666004)(16576012)(8936002)(31686004)(2616005)(956004)(4326008)(38100700002)(6486002)(2906002)(5660300002)(316002)(66476007)(66556008)(66946007)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2J3N24rbURIVnZPenU5MmFUQXc0amhsMk1BNmROaHhmd0tva0N2L2JVeCsw?=
 =?utf-8?B?UkJXV2drNmpWUE9YWm9sQ0s2djZjam1tMnVCb1FLS0labGNaOE43b1JFMEc4?=
 =?utf-8?B?UWJwSGlZTUtJWVZSWGpiN1RZbHBMVkptQXFYV3AzalBrdHBjYkRnZER1T1h2?=
 =?utf-8?B?Zlk4NTRheXRkbkVIVGsyTGNxVk5yYWxXK3VtNWtJRHAyVjVVdW55TFlRQzNi?=
 =?utf-8?B?OUU0RDVtaGp4WkhpTTFTVWg4QXliem50ejdkbWtzejh0WlQ2bHIrbzNvQXZM?=
 =?utf-8?B?ZXpGNXViTTFiZ1dnYlF6L3dTQmo4L2FFUWdQam5jcWJiYkNhUXNWdm5zeHcx?=
 =?utf-8?B?KzY0YzVqZ1pNUzFJQTZnaTZzdTJWa2NvQXNiRlBVVTQ5RUUraEpmTXRsclh5?=
 =?utf-8?B?T25IVTVNL3RlSEhKTmVmS0RDVUJ1RDN6QVpOc1pNRHBRc0x5TlpubXNZUmZv?=
 =?utf-8?B?TnIzWGhJd2JUMW52T0FIUjIwME44cEVVZU9iQ1BoZlA1M1F4NGdiRHdJODVq?=
 =?utf-8?B?V0xHWGNIUy9QU2pSRXVVRU94NGZCa204ZzNiTUZJNnhjZW5EOWxwV3ZBVmth?=
 =?utf-8?B?eDlEVnRRMUU3dU1PYkFDdTRTQ1d2Q3BadkR5QnJRaXZQeUlUeXo2KzI2S09V?=
 =?utf-8?B?akExUnN0Vk4rSk52WlNNSGJTQ1dDRVVRcmM1MENYTTdkTFdMdkRBaUkyR3Vq?=
 =?utf-8?B?RUg2K2lndDRvcEU5Z1NUMDVVMU5IQ21yRTVFeEZ3ZHZZQ1MrSDQrU2tKanJy?=
 =?utf-8?B?YVA0NVNBbVZrT05iSnpGTmRPL3RsSVBleXI4d2NaRDR4dU5KaEFQSHZ4SGFz?=
 =?utf-8?B?alZzSGVBK1N1a09SNlRpaU16c1BQT2NwY1hpOU5sNGQyZE5vV2dKWEt1S2FP?=
 =?utf-8?B?MzJGNWhRZU1hODViVWtIR1NNMlZ6TkxJUkpLdVNJR0Y5Mkw2VGJ3WHU0cmFB?=
 =?utf-8?B?TjM5bUxabnhZWEF2NDJ6bEtWeEJOK2J1RklhYjY4NWlhK3ArNUdmKzF4d3cr?=
 =?utf-8?B?YUxVUFNVYTgzWTNmM0JjZUpmd3pCKzZiRkZ3RG5oU0YzVWFCbnl3UEppd3Y5?=
 =?utf-8?B?RHFaTm1NM0R3eFJtOE5pNjhMRzFzZHg0YUs3YlZWRERYQUhVWnV3Nk0wUVdm?=
 =?utf-8?B?Y2ZZVXpuRExHVkRLMnJmWGFtZ2dUcHcxcFAvQVgrMEpNMjlSdk1UR2pFalJU?=
 =?utf-8?B?RCtWZytlMWVTbWlLbWhyNFRxK3FBOXc1VHFGTEllaUswanZ6K1NGOUxPbUE0?=
 =?utf-8?B?bDFYUlVOWlMrSFd0b0dHeGNZVHZzYWx4L1hab3g5MW5vMU96R1lLNkZPcDU2?=
 =?utf-8?B?Mk0rd002U0lIMDcrcGJvczNPUFV3V0NmN25NWXZ2aHdYVGdKNmJCMm8rRFY4?=
 =?utf-8?B?T1djaEUvZzdNSWM4Q3ZCS0k0ak1lekI5VVVYemQrR0NSTG16OHZMQTNkOGx5?=
 =?utf-8?B?djY5VDRmV0psMTFJK01kNS93VkI3VnFQV0RTdE1YcUR1d2NIMi9iR1FENjV5?=
 =?utf-8?B?bk9nZUtyQ0NpS0Y2anBYV0JyWlh1MCtlWm9wZlArcEJCdFphdFltT0hhNG91?=
 =?utf-8?B?OUhKNEhmcTBmMWUxUWpsYVJsaDZ3T3RiWnBDU3NOMkFMSmxseThuUkhCTWlk?=
 =?utf-8?B?Q2gzc2FZNGdwYVpRUjloZGhKaXE5YUlxc3kvOEgweHJQalRQMHp2ZTY4Z3B5?=
 =?utf-8?B?RFpSOXNHeDRKS0dkM0ZlajA4U1o1OU5OUjJHVVFBWkJHQ3VMa01aMGtGZ3A3?=
 =?utf-8?B?SE93VVk3bHNsdEFGWGxNdU5jMEtMUTJNQ29KZXhtS3Z4c1EzNWJOSTBVZ0Zn?=
 =?utf-8?B?OEtlYU9UeFBFUUtKTk94WG5TOG1uZ05BeTM1MkRGbVB2cENCR3dKdUREdVk4?=
 =?utf-8?B?ajV5eCtmQjQ0OGtQQTVyQnJ3U2JURHJLV3NjS3BuK2pyMGZ5RWdCT1NVRVFH?=
 =?utf-8?B?NnZOMCtEYlBXNytaY05KYko3RVdiMDFaTmhsVXNabWdYcUFTRWh1eHE3RG11?=
 =?utf-8?B?c0pqNGZmT21ydGJySzRFdkNrQUk5TmRWTDlmVkx3SzRhVHFRUHpmdUMzQmc5?=
 =?utf-8?B?Y1BwWEdRejR5MVlUY2xKUjVJZ3hjYWZSQ2YrR29kQ3RiY1JreHhYemVWTWUy?=
 =?utf-8?B?bXZwa1RtcVd4Q01UUzZtN1JXVEw0YzkyR0g1K1grbHYvTXVDUWwwNVpuQXFl?=
 =?utf-8?Q?eKcBeaUv4v/ZfS8pH2E4Lt8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f423688e-eef8-4570-5533-08d9b34d9e4a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 15:33:40.4666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FiSxBJsQmWXcP1JatzbG5OsWhG1IDoG5r1pQ8DQf7SnIXHNBQwliDspZoJkm33C66ZRGMjty9UoORFs43xpDjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5039
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/11/2021 14:09, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> We can remove a bit of code duplication by reusing the new
> fib6_nh_release_dsts helper in fib6_nh_release. Their only difference is
> that fib6_nh_release's version doesn't use atomic operation to swap the
> pointers because it assumes the fib6_nh is no longer visible, while
> fib6_nh_release_dsts can be used anywhere.
> 
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> ---
>  net/ipv6/route.c | 19 ++-----------------
>  1 file changed, 2 insertions(+), 17 deletions(-)
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 62f1e16eea2b..b44438b9a030 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -3656,24 +3656,9 @@ void fib6_nh_release(struct fib6_nh *fib6_nh)
>  
>  	rcu_read_unlock();
>  
> -	if (fib6_nh->rt6i_pcpu) {
> -		int cpu;
> -
> -		for_each_possible_cpu(cpu) {
> -			struct rt6_info **ppcpu_rt;
> -			struct rt6_info *pcpu_rt;
> -
> -			ppcpu_rt = per_cpu_ptr(fib6_nh->rt6i_pcpu, cpu);
> -			pcpu_rt = *ppcpu_rt;
> -			if (pcpu_rt) {
> -				dst_dev_put(&pcpu_rt->dst);
> -				dst_release(&pcpu_rt->dst);
> -				*ppcpu_rt = NULL;
> -			}
> -		}
> -
> +	fib6_nh_release_dsts(fib6_nh);
> +	if (fib6_nh->rt6i_pcpu)

Actually I can even drop the conditional here, free_percpu() is a noop
if called with NULL. Will respin in a few..
