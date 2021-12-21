Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8DC047B8EF
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 04:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbhLUDSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 22:18:49 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17424 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232143AbhLUDSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 22:18:48 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BL0miCq016091;
        Mon, 20 Dec 2021 19:18:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/oI5epePzs92lIk85lF2GDIU+q0VoxKdHg+Z2VeIeLw=;
 b=Rv9E8fNB/ucmQVJBgbiqFxrKZyNRAyNtsKRCKJ2ZqPv5yhxfGewIK5/vMyeK2jjc6nOE
 wmmr5EmlnVk0kVBluwJUspOYkNOpwgg50GerOK5RvGyFh+jKnqdxgjp65mXEMiUqU2Ee
 hHomlkB44+rqymNG6Uzxi2a5jS5ilPGL3vs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d2shknhfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 20 Dec 2021 19:18:46 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 19:18:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fb9zA9DmtrazkSmbhddMc56eGvPVy/pAkkvCzjbe8yomF6OIVeYRFI+wEkKi2XH6+ejwW3lcGzTGbB7bUA4hq8QgJbD+ER5GmeRfrkcKcb/pJFOpM0KOrYMTeGjLJ7i4D+Yvq0uwvoyuigjpoXEoT9E7fyMXpDOhX4uz1F2HoEF+Pk5v1Bp/fAv32mPr21eoL2ho7O7yU4hINPyTfZ1Mj+ICZAPsfmkzlVMDBPVzHJNsYGY2jJQuwv5wRJWEg/gqfoeRkt0lhpSNquKVAN58msoQj6NUa9kPd1rCA28P45Kd9cPq9N8bbDTp61EsKEIG/PS+roAgsRhREwQPo2pDBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/oI5epePzs92lIk85lF2GDIU+q0VoxKdHg+Z2VeIeLw=;
 b=Ehkjlia4iNa9ga14lL0ad8bTdTv+M11DHgBQAXiS+q74vweXNsqDlkwTS0hERIm4yhkLLsSnKoVKqXYw6EYPoGSqgGL7WEUtJont/EhTqp4qbr1d339wIhggfB4Ll7Ck+aJ104MOpn6aU8XhFZO9V2FJnSlRHQagRKcuaZtpcH9kCPJ179ykVpzfIMx5HJt7tQdm5j0y1F84VbMxaT9B3bqu5OjFUSzPBTQNakYDpESTzJ2Bw39eC3Kesl0plznE+GI9eFAHWmBOdFJwukoVOwc+vwFidFwQgqQeghMA0jTzwLsu0WoJd3X5yX1CzvF3KQQEFzyP3SSIPh9aea+ppw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB2061.namprd15.prod.outlook.com (2603:10b6:805:e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 03:18:44 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::b4ef:3f1:c561:fc26]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::b4ef:3f1:c561:fc26%5]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 03:18:44 +0000
Message-ID: <41e6f9da-a375-3e72-aed3-f3b76b134d9b@fb.com>
Date:   Mon, 20 Dec 2021 19:18:42 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH] Bpf Helper Function BPF_FUNC_skb_change_dsfield
Content-Language: en-US
To:     Tyler Wear <quic_twear@quicinc.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20211220204034.24443-1-quic_twear@quicinc.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211220204034.24443-1-quic_twear@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0031.namprd16.prod.outlook.com (2603:10b6:907::44)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6460dc70-42cb-4190-f747-08d9c4309865
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2061:EE_
X-Microsoft-Antispam-PRVS: <SN6PR1501MB206162B995F74E88B8310A03D37C9@SN6PR1501MB2061.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wKqpKVy4yHCCJxWSERRRM6z0Q/xL6OvJ7+DALU+m2Umjkgi3oZdjWWyzpZWMkCEdtLWxtIjyaSdrfaGjMhInNoPrm8VBckAg/0IuC89QKOHLmOcbDhwj8UgyLYptA4A8s/SGVY6ly42H1SoZlaHucpGHwCdeZ6UOjrxgzGzfZ+F46vEQrKvcBZIptGo7/jqz21axDz1fjmwrb7xEvShC0n1qrw/3EMCyy7up84d+ixRD+jUUstH3IqadvCnnsUwVBCRVKyqAr/Dn11MjYjVec8pH/mNB3UvPlW3Wv52TgQeF08uoo3KeVi1SaXWtnkv7nskC8cDP44TirdsyVLv5zTptgTOJXheEZd1IXsCxCuFVJkqoJ3YY0+YEbbpsRW20Sc8jdatQZSJ/rgAK8iFNnR8K4fB6zBGLtZd5yqgUhx2V742Uza6gt6TRxdT616EaefxwVcwEKlofzZJYW8UyVfJJqA2ahjrgflW2LlHpaMBp8kUvp5OKXpBNe040RgDNsk1ej0G0GzyV8D5x6IhXjbI+7dqXNMyXs0bPO8SQQ/Dtqr55ZDotY4Y9aHesOY0mW/EwZrw/YvWOLUFR13OaI9YCNR5eoTwRhwA+RoCFBtmiGowQE90TH1gBMO9KBJFfTebnVTpKe9OLpRKbVI2ReKvdevZyiyiAS7GY4tH5akEad+G9VTbQVKngpEwdbdbmgSoukYKgk/R63SemNwQmzHHAjfoj6J65P39skv96wMg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(83380400001)(2616005)(6512007)(2906002)(38100700002)(316002)(31696002)(8936002)(66476007)(6506007)(66556008)(31686004)(86362001)(5660300002)(6486002)(66946007)(36756003)(53546011)(52116002)(186003)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWRRbWFEUFBqSkYxc2kveGpYOEhyTkQvQ0NjQldva2VkeXpyM1hpY2dGQkRJ?=
 =?utf-8?B?aW9WZDJKM1MveVRvNytlNDdKb2FSQkIvVWVkaU4yTGNKOThiOVAzaWJIa2Jl?=
 =?utf-8?B?V3UxbCs5M3FudFM5dEIzeDR4WDNPNUJrRVlPOUlNM3Yrd0xUM0dPeW9COTF5?=
 =?utf-8?B?MzBCRFlic3ZsVVJXRVd3Mk9SWE9IODV1WGNCa01zandaUERKS09QZkNvSDNL?=
 =?utf-8?B?VGRHaEhZcUNFT2xRbitZeHQrMlRDbW5pd08rK3VSVTl5MzJrbSs0WmtyV0x0?=
 =?utf-8?B?NHFBR0FjTHlZVElPVjVXVHhPOXR4Y29MNWwzaU0xeHBadGdZTnhDU21ISE5I?=
 =?utf-8?B?T09LRyt3eDgwRkpTYjhjWS9ZTXVxM1BzYkpwT3BndndoRWhOSVA2SUFtYy9K?=
 =?utf-8?B?Z0tzRHF1OFd5YnZVM2tWQmVlZWIvdUtPcEZqMkN3QjZzb3J6S0s3blA5djJO?=
 =?utf-8?B?S1FIL3U5SjJyVWhGS2dxRllUTmVaQXA0dGRiL0tOcTYwTVJmWkdHbGVTV2R1?=
 =?utf-8?B?NFZkWUZFNE5mMFpHM3Y1dHVkMTNYMkFISWtoV29GbEdncEMzWW8yU3RoSDBi?=
 =?utf-8?B?VFdqSWROK0JQQzZzZjdSZTZGMnYvWTNmYU9PUVRXMTlUdVVPdzFyQThnR000?=
 =?utf-8?B?ZWFGVDBBTjFObWtDelR5Z3hPS1RucFdieWpWcWZ1Ui9IaGc0YnB5Q1BCYVlT?=
 =?utf-8?B?WjBQcHpuYno0U0U4U2pIRnhXUUI1WWYwOTU2TU1ZaTgwQzBBSFNmWnJjM3pw?=
 =?utf-8?B?aVJxbmVKbWY2NXhMVE04eHZ6djFnZXMxcWg0dDllTWd0SDJIRVRnMTVVcUFj?=
 =?utf-8?B?WmdOTGRTaXFTZnFhMTlnbW8yY011Q1RiUHNKY0M0ZFVHOUF5UkNYbWw4eGJB?=
 =?utf-8?B?YmpKMms0MzNBQ1FNU2M2ZWNsZkFTVVEvMmpFL1oxVDJiQVFUby9YcFY0MG9E?=
 =?utf-8?B?QW1sOFFVTDJncWdnU2VHdWlqbncwQnRNaXIrTjZUMWFZUmk0WjFJcUtVVkhi?=
 =?utf-8?B?ampjdUVnNXpPRC9mQUdha29lbzIyMGoxSHAwMGkzMy9XUytXWVdGWHNFNGho?=
 =?utf-8?B?K1l0c2dPM2k4ak0rOWI4aFM3Q05DeUhEakUwR0RrTzlMSmJkekxKVjJHb2Jx?=
 =?utf-8?B?dXE2WjBYZjFIMURvakdYamhzZHg4dTF0UkZZNndpaXlQaEZFWEpkVDFUbUgv?=
 =?utf-8?B?L0JDMkU2RFd3UjllMDFpTEdNMVZLcnVyeUJ0SHhzUFJuTkRsOTlNVUZxa1pS?=
 =?utf-8?B?Qk1XMWpHMzBJTHVJNkZxb2xPM242bkduUWNUZUs3TU8rckQ0TC8zN1BzUXNl?=
 =?utf-8?B?NkRhOXdLZ2ZBYTM4TnlCVndaZmRaSWpwQmlUMFZFWUJqOWNPb0VlaDhhSmxI?=
 =?utf-8?B?c3V4RlAzbTllRTFjdXFpTVRsTkx1K0M1cTNiSVRZV0ZkeVNwTlpGcmk3N09N?=
 =?utf-8?B?SkxHTXgwZmQxWFV6bXgwQ2pybmdsYmRjTzBmVzZtTDJhZDlsM044RzFjdDJD?=
 =?utf-8?B?VHVSRlNTT2dKRFZkejRwNGV3NUtudVczU0NrNFRSdU5qQWF2S0oxclZhNlJ1?=
 =?utf-8?B?OTlXczMxT2lsZDF3SmdDdWhZdG9DalZkbWdzakx6N3JwRjhnd1hhVHZvbmtC?=
 =?utf-8?B?Z09adWVXZDZodVp5WXFJOVRuc3F6eDJwQVh6bFUzbmF5ZHFOQ2d6a0ZzakFD?=
 =?utf-8?B?M0lFU1NDQmhSd1BVSGtoL3h0SlNIaDlWVzBLT0laRW9qZDNLeWtka0l6M1Jm?=
 =?utf-8?B?WW1BdTdHUW8vV052TTFsN09iRy9MWkdyZG05Q3VMRDV6TVZDQ1ZYQUZsWXl3?=
 =?utf-8?B?RU16ME0wLzNNTWVnbm5zZ1R5UEJSKzRCN2toQmI4czZ5c1NRUzZSMEUvYXdF?=
 =?utf-8?B?WFZmYVFCQWVsRHA4THB5WTF1bUNJY1YxRHA0Z0NOazE5VzdzRWVkbU5XeFV4?=
 =?utf-8?B?TGYraC9YVzZOUnBOQkc2b3B6Zkg0TktKM2N1eGdRZUc3dmJrVWJQMkFwdmlE?=
 =?utf-8?B?SFhON0dXQmM1cjFweDllUTd5TDBMVEJXQkVMeU43a1FwbkNHTG1NSDRDSC9q?=
 =?utf-8?B?V1ZhaFhLbnlUaFJpcXRET0NWWHgrckkyc0l3TGpFcURSWjFHd3BINzVzbWR5?=
 =?utf-8?Q?lbbcOsAopKNyM7xZbTc4MjRd8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6460dc70-42cb-4190-f747-08d9c4309865
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 03:18:44.5179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9zLDIJWndCMQ+EapaGMoH5uec62g5BLI1TM54id2ulwK2fd5dH0n/3IyMMjMhLTZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2061
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: LuNWKg5TfbqPM9kdL6hFin-JcEsr_Xxv
X-Proofpoint-GUID: LuNWKg5TfbqPM9kdL6hFin-JcEsr_Xxv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-21_01,2021-12-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 spamscore=0 phishscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 clxscore=1011 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112210012
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/20/21 12:40 PM, Tyler Wear wrote:
> New bpf helper function BPF_FUNC_skb_change_dsfield
> "int bpf_skb_change_dsfield(struct sk_buff *skb, u8 mask, u8 value)".
> BPF_PROG_TYPE_CGROUP_SKB typed bpf_prog which currently can
> be attached to the ingress and egress path. The helper is needed
> because this type of bpf_prog cannot modify the skb directly.
> 
> Used by a bpf_prog to specify DS field values on egress or
> ingress.

Maybe you can expand a little bit here for your use case?
I know DS field might help but a description of your actual
use case will make adding this helper more compelling.

> 
> Signed-off-by: Tyler Wear <quic_twear@quicinc.com>
> ---
>   include/uapi/linux/bpf.h |  9 ++++++++
>   net/core/filter.c        | 46 ++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 55 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 556216dc9703..742cea7dcf8c 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3742,6 +3742,14 @@ union bpf_attr {
>    * 	Return
>    * 		The helper returns **TC_ACT_REDIRECT** on success or
>    * 		**TC_ACT_SHOT** on error.
> + *
> + * long bpf_skb_change_dsfield(struct sk_buff *skb, u8 mask, u8 value)
> + *	Description
> + *		Set DS field of IP header to the specified *value*. The *value*
> + *		is masked with the provided *mask* when ds field is updated.

This description probably not precise. If I understand correctly, the 
*mask* is used to mask the current skb iph->tos value which is then 
'or'ed with *value*.

I am also debating the helper name, bpf_skb_change_dsfield vs.
bpf_skb_update_dsfield vs. bpf_skb_update_ds. Here, we are actually
doing an update instead of completely overwrite the original value.
Maybe "update" is better than "change". Maybe we can just do
"bpf_skb_update_ds"? We have an existing helper bpf_skb_ecn_set_ce
to update ecn. We don't have any helper with suffix "field".

> + *		Works with IPv6 and IPv4.
> + *	Return
> + *		1 if the DS field is set, 0 if it is not set.
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
>   	FN(unspec),			\
> @@ -3900,6 +3908,7 @@ union bpf_attr {
>   	FN(per_cpu_ptr),		\
>   	FN(this_cpu_ptr),		\
>   	FN(redirect_peer),		\
> +	FN(skb_change_dsfield),		\
>   	/* */
>   
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 035d66227ae2..71ea943c8059 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6402,6 +6402,50 @@ BPF_CALL_1(bpf_skb_ecn_set_ce, struct sk_buff *, skb)
>   	return INET_ECN_set_ce(skb);
>   }
>   
> +BPF_CALL_3(bpf_skb_change_dsfield, struct sk_buff *, skb, u8, mask, u8, value)
> +{
> +	unsigned int iphdr_len;
> +
> +	switch (skb_protocol(skb, true)) {
> +	case cpu_to_be16(ETH_P_IP):
> +		iphdr_len = sizeof(struct iphdr);
> +		break;
> +	case cpu_to_be16(ETH_P_IPV6):
> +		iphdr_len = sizeof(struct ipv6hdr);
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	if (skb_headlen(skb) < iphdr_len)
> +		return 0;
> +
> +	if (skb_cloned(skb) && !skb_clone_writable(skb, iphdr_len))
> +		return 0;
> +
> +	switch (skb_protocol(skb, true)) {
> +	case cpu_to_be16(ETH_P_IP):
> +		ipv4_change_dsfield(ipip_hdr(skb), mask, value);
> +		break;
> +	case cpu_to_be16(ETH_P_IPV6):
> +		ipv6_change_dsfield(ipv6_hdr(skb), mask, value);
> +		break;
> +	default:
> +		return 0;
> +	}

There are some repetition here. For example, in the above, 'default' is 
not possible at all. Is it possible to remove the second 'switch' 
statement with simple
	if (...)
		ipv4_change_dsfield(ipip_hdr(skb), mask, value);
	else
		ipv6_change_dsfield(ipv6_hdr(skb), mask, value);
?

> +
> +	return 1;
> +}
> +
> +static const struct bpf_func_proto bpf_skb_change_dsfield_proto = {
> +	.func           = bpf_skb_change_dsfield,
> +	.gpl_only       = false,
> +	.ret_type       = RET_INTEGER,
> +	.arg1_type      = ARG_PTR_TO_CTX,
> +	.arg2_type      = ARG_ANYTHING,
> +	.arg3_type      = ARG_ANYTHING,
> +};
> +
>   bool bpf_xdp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
>   				  struct bpf_insn_access_aux *info)
>   {
> @@ -7057,6 +7101,8 @@ cg_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   		return &bpf_get_listener_sock_proto;
>   	case BPF_FUNC_skb_ecn_set_ce:
>   		return &bpf_skb_ecn_set_ce_proto;
> +	case BPF_FUNC_skb_change_dsfield:
> +		return &bpf_skb_change_dsfield_proto;

We do need a self test to exercise this helper.

>   #endif
>   	default:
>   		return sk_filter_func_proto(func_id, prog);
