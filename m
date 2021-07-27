Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D87B3D7DD3
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 20:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhG0Sjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 14:39:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36748 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229716AbhG0Sjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 14:39:31 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16RIc9mA011735;
        Tue, 27 Jul 2021 11:39:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=00sprvqQAQ52VYwvjjYCFU2kMBZkUFzcwsmvBozz3UI=;
 b=Yf5K+jwVvGYhgrayry2x/5+gc+f8+bYNCxhCYFkKOsnl9tLbbNOiqrilHlse7t59Ngwf
 ixuIjflO6Lc3j0QCEbaf5vA3JtIwjvZQ7npAtYAQ0BoKonS4D/d+nQjriP/+pNxQJa3G
 L4iWzHM1+/YOvPVD9Tj/GYv0NDP+KAo02ZE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a2350y571-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 27 Jul 2021 11:39:16 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 27 Jul 2021 11:39:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=diNpnxAiXYaOlETsgq9iBWxElyJfS4xJOeB4T8gw1S67q2YL6C8fU7GKPtRChqcaUUMabGeuywSIyZ1oKVCkLZARjgLR46ItDXmrZba/0XBWsoGdW4UipLUZQS4E878+JCj/Q27mrGO/wBios4H3e3Hnz5omfjOiYXLVeAa8u1nsn1qZRXtjfwHYN/TX6kqLtEruBeMnEFqj6b0z7dKt/j19HFh5fGB7C9lICvJjqanuOomENr+XLsCoLQsarEsbqVC08b2Iv1UJV4NthbNA1TxVV4CbJOQ5dDajE+miqhf0ihIKsIIGF/9Fj+CHoqJbeqMtn2jy586hmkVOxqY7TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00sprvqQAQ52VYwvjjYCFU2kMBZkUFzcwsmvBozz3UI=;
 b=hl71Eabm2694t1rDI0UF1tyMXge06+vtP+6WuiJC3UMN4x14KyrDwga9A7U8eCIPUglN+IGkCW6W9Yel6EmR6cXFklB4W+NTVkWbkvhSqJbMK7FNNrn+cNi+lwnokmpQTTq7tW/kisDMmtFTAGXqEP7mFfftcN13yK0B1XNaNkc1QRrUbjKar8ayLcm3VX3+4C5M4SNtnL07YquvMsdFHwZu6O/VZKDJtgHJSDr0fzqAIQTXt9PjDZPdvkUGcgz2PVomxvf6RRIKXmE+uWF3VHFeOzisjZscLfUU8FHs9/btWj/NliWRNzPeR4YOj/lSPpYrl8a3nMOC1ux3hrNlRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2208.namprd15.prod.outlook.com (2603:10b6:805:1b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Tue, 27 Jul
 2021 18:39:14 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 18:39:14 +0000
Subject: Re: [PATCH bpf-next 04/17] selftests: xsk: set rlimit per thread
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <maciej.fijalkowski@intel.com>
CC:     <jonathan.lemon@gmail.com>, <ciara.loftus@intel.com>,
        <joamaki@gmail.com>, <bpf@vger.kernel.org>, <andrii@kernel.org>
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
 <20210727131753.10924-5-magnus.karlsson@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <8d3d2bdb-3750-80dd-3874-def189e0e51f@fb.com>
Date:   Tue, 27 Jul 2021 11:39:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210727131753.10924-5-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0064.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::9) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:4698) by SJ0PR13CA0064.namprd13.prod.outlook.com (2603:10b6:a03:2c4::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.12 via Frontend Transport; Tue, 27 Jul 2021 18:39:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c01f1e5c-0cb9-4e2c-b92c-08d9512dd534
X-MS-TrafficTypeDiagnostic: SN6PR15MB2208:
X-Microsoft-Antispam-PRVS: <SN6PR15MB22086D8CCB59E21AF0D1C0B5D3E99@SN6PR15MB2208.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w9xmIE9x4CQ1XNjlXMWB5qMxnnulFUGprX5evLVxGybrY5ieMbl7cJexM7icPW/FB6UwMKk/mrpj3n7XXrVqya5/wE2mZZpmD1BD0G8P5ldhAjqYb5HZ9tma+OImWb2QW7MIpTvkiGfvjYk4PgONFLRIhdsaR2dQOKYNdnI/N0UC1FFZYB5ChmaB5I7llVbbI60lwBPrDgTbk14lfXm+HkDsx7TSFyWw05WWKQVBVf8PVr6xOLaYQfgkQ5l1Zb1IQXz+6nKu7mpY33S+3NYwr478efckZv1kkOYbq97Mct56CrYgM6MZpT89kAbAdpRY10vWLDid7xd/NdpeMKlYFrqSRq6f7RQGtVvKwca0E2d+4T+/gdZ1OzzX27VVD31EoSnZ/WKDubnXvIXUl1E74AlQSUnn/VsIxMmjlXT2WqamWeIl9KndWOpg6cgvV2Tmv0tZSZKmKgjqs0l1AgaecigsAYixe5D+R033ZnofNHefHsWuaKqsQ863j1KCUXSffCO48W285CXs8IEZ0rz2XKY5lXfK1xkguAgTSjOt0IwNe2CwIDMP8vkPPY4CwfaFmmI9og8zAr1RIVF/eCWWMy8919PynifQTYzvlltoolCLHruwxlkKrxFdLIicZxImOKlmXKJ3vcT9/nHY6/GmfI/+ccR2aIWXWUywyraJ/Il1yv01m/HhwRtz0hmqDSlM7Z4GupWm4sgafcYvWqaBUynUCqsqg56S2BmqWqa3zaQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(316002)(7416002)(8936002)(4326008)(66946007)(6486002)(66556008)(66476007)(53546011)(31696002)(186003)(86362001)(2616005)(31686004)(36756003)(5660300002)(38100700002)(83380400001)(8676002)(52116002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODlKOWJURVhVdVNwWHdFenZWOEhMU0dja2ZyM0thZ2Z3czRiSCtCMWY1L245?=
 =?utf-8?B?RitZTTZLVitGZ2VUYlhYeUlCbGhTSHF0SFBoVDQ5OEV3U21rb1YyQWhWbUEv?=
 =?utf-8?B?TTFpVkltR2RDNEc3ZWRlMGFCS21EWWVySXM4dlFoVXpLb3Y0Uk0vRThONGpZ?=
 =?utf-8?B?NndjckpBWjBoeWlnV0JvVHYvNTE4ZDNRVDNTNVlJVTBJV2ZSWFlUTHBQdEl0?=
 =?utf-8?B?RDY0ODdiVEk5bUhuWE05Mm5ieWpjcERpMWhSMHV1MTVGYmprc1U1aU1PK2J0?=
 =?utf-8?B?YlFwWFFWMEsyU1Z0d0ExK3Q1UGlGNzI4UStLcDhwOVlKNUJ3QlREaG55RzA2?=
 =?utf-8?B?b3BkMnpzUkZRRE1PbkpjbWFRWjVqUUk1NFkrSlpMSEhNV3JoOGVHY2lMOWhN?=
 =?utf-8?B?VVhsdEYxQ21HcGJzMHJRdjBQTnZmNFROVnFLSk1KTi80NmgrRnI1b2N0OWsr?=
 =?utf-8?B?Q2RieWVQZTk3U0F4NzcyMWh3cUlOeFcwMEMvSDFjelBJY29EL2FUZkdhbzI3?=
 =?utf-8?B?Y0NpYWloSlFsWU01ZmVxRG15bFpRNzdKaUxOSkpqQTFWNW1LU0dZQWxRTjh6?=
 =?utf-8?B?b0ZrSEIxZkpmVnZWb2EwV3RQRXZIQm5jUDNsakluOWNvM3BGWkdkYnA4Ymkw?=
 =?utf-8?B?d0hKSjYwdU5RRVRxdENkeCtWMWRqRmFoNXhWRnNKOGQxb281dFk2UXF4RFph?=
 =?utf-8?B?UjdvNDZaSkRNbHluWUdkYllSK3Y4S1M2bnJrL3ZuZmFDRGttbVFYODdDUlVG?=
 =?utf-8?B?d1pQWUxhZTBHWTBZUGE2U1pEMzh2UmRLbEJCengyQ1phRmlSTENyVTdzcDdO?=
 =?utf-8?B?S0g4bDUxZHZkZEp6N0tpWnRtY0JQMW9CMWxaTy9Cem1ZTUd2RTJGamU1OWFz?=
 =?utf-8?B?aWtxeHRiQ2dWek9OV2xPMEJPOHZib3RydkM1amZqZFpGRHNUMWFEejkzbmhV?=
 =?utf-8?B?Z2lLZ2xENFgxQ3gwempiRTA2NFJ1NC9DZkxvb2hnanVObzY3dnBFTlh3aTE3?=
 =?utf-8?B?L2tHVlJ1OC9JU0svVGRaVi8zTU9sVXlHbVcva2FYOWIzbzVldlhNSWFxTWhI?=
 =?utf-8?B?QmN2dDhlWnFuOFFMaTZFVDRvYmxEV1dTR05ramU5QkJZSDJEa3lwUzRUUlc3?=
 =?utf-8?B?eDNIY2VwR0xvUkgveG5aWXRwQ3NRNHpNRnBGYm9OSTRTZTlJbHF1YXRPMUY4?=
 =?utf-8?B?bUFhVVV5V2paREJYNkcrc2FpMnl1RysxZ0dPSHF5TERyZm9mOUE1aXlWWEZL?=
 =?utf-8?B?K3dBLy92VHYwL0oyQkdCK2JiczU4bjRCTjNnYU5SSjJCSkY0Zm5tVlhQMEtL?=
 =?utf-8?B?M3VrYXdwS0hpT21Vb0VBanIxbGVFK2hrcEZZbjF2ZmVrZ2xHdElKQlBEeUJh?=
 =?utf-8?B?cHpBdTJQV0lZV3hUQS9ZWHkrNER2R1E3MUxzNDZ2MExRUkxsZmVtR24wQW9z?=
 =?utf-8?B?Ylc0UVo4MWE4REU3ZkFadzZkcjcvS3dnQ0UwWmUyWmJRQUpHL1RRa2FCN2Zr?=
 =?utf-8?B?a1Jhamd2TE5sWUJHSFJWL3ZLNmNFU0NOOGRGbnpUVkVIbVEySlFvM0NoY3ha?=
 =?utf-8?B?dnpScEhYZW5YS3dCb1I2YnZ4UEpQQzNXa0NEWW9uZktMeTBlTVgwS1JDTDc3?=
 =?utf-8?B?NUVQMEZRMkx3S2hjdVY1MEV1eGxtMkV5RjZjVXByQXdSVFR2LzhRKzZENkg1?=
 =?utf-8?B?c0d0VUhHN09ubEFjZlB3U1Q5VDcxZkN2dzlseVBZVStJZjBBUVM5bk5WWVE1?=
 =?utf-8?B?NFB5N0pLQktaMjREeHRWSTZkcTQ2a2NOU3NhcEFsMHNPV21hTG95dXFiejRG?=
 =?utf-8?B?Uk9FOFJpUUJYR1QrbTB0dz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c01f1e5c-0cb9-4e2c-b92c-08d9512dd534
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 18:39:14.3835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mhzfeF7lXbD8SZWFNpUVzKGYkKh1ypkeCi3Ap7utf6dSvv5oLLPNqpIN+1z+xaxU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2208
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: urXS-PKxL5Swrc1jowaglL9Gb-4eSvIm
X-Proofpoint-GUID: urXS-PKxL5Swrc1jowaglL9Gb-4eSvIm
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_13:2021-07-27,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2107270110
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/21 6:17 AM, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Set rlimit per thread instead of on the main thread. The main thread
> does not register any umem area so do not need this.

I think setrlimit() is per process. Did I miss anything?

> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>   tools/testing/selftests/bpf/xdpxceiver.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index 4d8ee636fc24..2100ab4e58b7 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -252,6 +252,7 @@ static void gen_eth_frame(struct xsk_umem_info *umem, u64 addr)
>   
>   static void xsk_configure_umem(struct ifobject *data, void *buffer, int idx)
>   {
> +	const struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
>   	struct xsk_umem_config cfg = {
>   		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
>   		.comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS,
> @@ -263,6 +264,10 @@ static void xsk_configure_umem(struct ifobject *data, void *buffer, int idx)
>   	struct xsk_umem_info *umem;
>   	int ret;
>   
> +	ret = XSK_UMEM__DEFAULT_FRAME_SIZE;
> +	if (setrlimit(RLIMIT_MEMLOCK, &_rlim))
> +		exit_with_error(errno);
> +
>   	umem = calloc(1, sizeof(struct xsk_umem_info));
>   	if (!umem)
>   		exit_with_error(errno);
> @@ -1088,13 +1093,9 @@ static void run_pkt_test(int mode, int type)
>   
>   int main(int argc, char **argv)
>   {
> -	struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
>   	bool failure = false;
>   	int i, j;
>   
> -	if (setrlimit(RLIMIT_MEMLOCK, &_rlim))
> -		exit_with_error(errno);
> -
>   	for (int i = 0; i < MAX_INTERFACES; i++) {
>   		ifdict[i] = malloc(sizeof(struct ifobject));
>   		if (!ifdict[i])
> 
