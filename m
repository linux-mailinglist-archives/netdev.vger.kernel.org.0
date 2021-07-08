Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB573BF403
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 04:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhGHCg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 22:36:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2658 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230195AbhGHCg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 22:36:58 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1682VZqq014219;
        Wed, 7 Jul 2021 19:34:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=sj3MJy1ZhmoMsk1bUTqPjl5EZ8PMxaEDSU90/F7aNGQ=;
 b=clkI7YYZI5cadTgc/S+R22275xmAjUupUTlb6NPPeE1/D+1aZK+dlsbootkuIhj6U61N
 jgPJalqWDC+BJAtfgteQ12ys7CqSSY0SCOZ9vfESsLUy5kp4hXuCwgDHrFjw7jtHTRyb
 /81kcukLF8BFbbr9LcvLJokVAFv7Sxr4MPA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39mmbemhan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 07 Jul 2021 19:34:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 7 Jul 2021 19:34:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eEeBwVzxBsU53M9FUM0US/nwBs5Xi3xWqpWUe/q/rXeeChwWd6wZZQhYDr0MJqR8ZB6C0KvcnkOXnvwCovbEYo3RvyjY4ZyNL41klboXi2PnT7BGaUx3Fbn8sW0D4Fgo4fSYfrEf0AmQMTrd/VG/WhFTsmSS4nwQXxQOlS6JMVhbEZXv8N2xsIKiTA6mYJezlQUu0y7SGi2qFucFuUwyHu8BHh0JeVBouQFtiFGPpzpzH3sz3y3rPq7xIP0gRJ0Bl5NtCeLKQ+pCnYuSLghUBMygLdaLp8ePAQagNbmmebOe+nHhO2Q/hAS2iiO2KIbA6nZxOn5A+v0s7e9Qbd0OdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sj3MJy1ZhmoMsk1bUTqPjl5EZ8PMxaEDSU90/F7aNGQ=;
 b=FRdFR73j75nlNqxklnTREKJ1f6mWxBLui0QLf8m0SABcZghgktYj/RVrMAtlbi2MQHbn6HcAE8DdqmyS3/k0eDXNDTAZB68chB1TEChLQfPATwibwa7RCbpNJGViMqWYA3fFPa6Lh2AqTGzU8I5WF/e2qkKdFWs+LyCxFKVDMYLcpndYyoVE5rhw7H2Y7kdXuue2shzn/+Tyq3PXhaxQtykP5eBif/YFXnsVd/YJXyyt9Fp6fy6zaHJAMViRAgCTp/Rbsj6uoLcA2kHJL0MkNYRBiMEIt219tIRW3qQrJ1uGDWBKtm564dpAD9FpTZ5sTkiWcfNRnAaQ/wlpGPlxUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: riotgames.com; dkim=none (message not signed)
 header.d=none;riotgames.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4870.namprd15.prod.outlook.com (2603:10b6:806:1d1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.32; Thu, 8 Jul
 2021 02:33:58 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4308.021; Thu, 8 Jul 2021
 02:33:58 +0000
Subject: Re: [PATCH bpf-next v8 3/4] bpf: support specifying ingress via
 xdp_md context in BPF_PROG_TEST_RUN
To:     Zvi Effron <zeffron@riotgames.com>, <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Cody Haas <chaas@riotgames.com>,
        Lisa Watanabe <lwatanabe@riotgames.com>
References: <20210707221657.3985075-1-zeffron@riotgames.com>
 <20210707221657.3985075-4-zeffron@riotgames.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <fb6374ff-a649-c80a-a67b-ded0f3542011@fb.com>
Date:   Wed, 7 Jul 2021 19:33:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210707221657.3985075-4-zeffron@riotgames.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0235.namprd04.prod.outlook.com
 (2603:10b6:303:87::30) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::19cc] (2620:10d:c090:400::5:c77f) by MW4PR04CA0235.namprd04.prod.outlook.com (2603:10b6:303:87::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Thu, 8 Jul 2021 02:33:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c91524c-a926-49cd-e44b-08d941b8d6e4
X-MS-TrafficTypeDiagnostic: SA1PR15MB4870:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4870536DCFA00B8B5A14AC48D3199@SA1PR15MB4870.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CmZXtgKe+mT6M26L5cz1WhDjtVWPWdi1PioVgVQv2Xjna7bsfUgrFp34K0AWRX5fduaFZNYl7YrLMTx5TDiwrfdBCFYHuOy/m0H1k5RdmcbV/3yXmM/bLj5wGNBofj8MvJNtOkZNIJJiI1T4+BvcKHLrenRJUNofTnJO1ALwXIdlHKl1iFoXP6D9xoTCZIxOlpAxWZQUUgObR+Z3O2El013g+NygNy/TeRMxKFy99WcgtM7VarbFHBIH2l4yTh+o+yG1HlwsGz631BNv7Oi44h2b55INRCzYDn1dXu/JpBCIbAPopBn/Qy7HP0rcq9J/uzyDUPBNkx8kr/XpIEDI4Kz3XvYnL/AE4qt+yUllukugCrhCUPHRnQ0li/gWMZOTqjuZF4fS8zb1LyAj4PEsLLjtOAdl1Tpdl6Z/3Y25LXF6QM7DYdx8EhEloIf1nBvWr9xKB3rO9Hk61XV5gLPMigz1j2WxGb/RoNYxTk9w95PhIvWOhQBbq9/knb+9iK5QqC+fut1hYz8tYjrMZMQ3zrdfY3D2JW7yw3KtpsrDeztPQZfnVCjJLF5SohsUklm/N3c/5bpgSQmZ19ULUs3qJBteAjZ8KmXculJksynPrMJpsxcs5x0/ufbhCGlwTSqvj7j+zixGotQOMRXU+6etR10AXoHikRrD9JVlmrtKty0ctqiG/UtchqdYab2+/qo+7bkKT3dti9yFVTbjjtHpSwqZc4VM8OLIxKSWg061KrE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(376002)(39860400002)(346002)(6666004)(66556008)(66476007)(66946007)(8936002)(53546011)(5660300002)(86362001)(52116002)(2906002)(36756003)(38100700002)(31686004)(54906003)(4326008)(31696002)(316002)(186003)(4744005)(7416002)(6486002)(2616005)(8676002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2ltOWhpSGNEZ01YdlozdldzSnNucGc5NkVrRnQ4THpNM2hHWHEyQ3NBME5m?=
 =?utf-8?B?VnBMdjdRVTd5Y3QvME94dnZjcFhUSkpIckVMdlRhaXRwSkNyRThJUDhzaXJm?=
 =?utf-8?B?SnFFY2lqcFJDckRoNFFMMGpVUHp0dDZNb0ppZ082OVpybmFxUEVZakhkSzBt?=
 =?utf-8?B?N2Z6MWhub3I1aE54RGV3TVFGNTVSY3kxQm5QYy84K21TWTJ5cXk2RG5ndkxx?=
 =?utf-8?B?M24za3lteldXMmx0ZEhzY1ZITjJOdTlxME1VdEMvWmxaZXNtRU9yUTl3M0Rp?=
 =?utf-8?B?dzFkQVI1MzBzTTJqVENyeWRMcUhTT2dsOGwxU2FTQ1Nwc0ZDMHZHay9XSVFx?=
 =?utf-8?B?RW81KytOR2IyUzRIelI5VkUyN2VyK3poRVNVa0d4SytxMnFLS2wrTjNrak5P?=
 =?utf-8?B?Mm9CWVlyd2dub09Oa2pPbFpNU09aTjNxWExZclVjV2pxRTRVYkUxR3hOekxh?=
 =?utf-8?B?dndMc2Y3VldFTTRsR011Tm9GWVFQK05XblppTDUvTlpEQTROMzBtWUdFZW5z?=
 =?utf-8?B?VFExTzU2ZXM3NlNySUZMbVRhWkIyN2orRkxTczdFUjNvSnJiZC8xN3FObkNm?=
 =?utf-8?B?YUMrUW1rVFQwTy9lR2luU1YveDBvTFZ1dURvbTZpaHh5YTZmcEdKcURnd09o?=
 =?utf-8?B?dGFLY3pWeHovWnUrODdTYnJkZDNDN3Z4bk9VOHVoSUNCUUlrWFRRdkIzVWFj?=
 =?utf-8?B?Z3pWdkIyaVdmM0VlS0VkQnJiSjNUWm9wb0FDL09LR3pncE9YL3ozTlN2cXFi?=
 =?utf-8?B?dFk2eUd2VU1BV2hQWmNERW5odTg3UjV3UmowcXlnSTY0WHB3QVR4Mi9wVWtw?=
 =?utf-8?B?S1VIQ1hkeW5hZEU4TWpydFp6NzdKeDZtekowT2k5RWxxNENKdHRkRDhXNjVv?=
 =?utf-8?B?elJpL240MnhwZ2txd1lmY3l2cW1vamc4L3JibFBvLzNoY0hHMlp6YjlJQmFZ?=
 =?utf-8?B?VXZ4MXpPbk12cG9DUTRYWi9YZmM3dVI1UzlBT2ZOa0FsQ0x6NkhWRUxyOXBG?=
 =?utf-8?B?emIwbFBTOUxxMk0zZzUwY05tUHpIL3VZOXd2WXYrMTRqbFBOUnF0WGU4S2pP?=
 =?utf-8?B?NDE5MTlnWkNESXhwRVZxQ25BWjh0eVZGODRYK2laR2ZDZUVERE9WMWh6Tnll?=
 =?utf-8?B?VXJiOEZWNUwya3ZEMTRDN1J6L2htblpyWlh3Z1JzcXZQZ1FnVG84SW9IcjlO?=
 =?utf-8?B?eVJFNTJaRWRkQWJqb3hGeFZTQUd6b1RIT2ZaWXdzbWRJbHRnVzRYZllqQ2Vp?=
 =?utf-8?B?NUNuUExKZnN3c0I3V1IyVE4zeERINDdLMlh0VmExTHBidHB0OWtyMUlMTFBa?=
 =?utf-8?B?U0dqZ0xjQkdKZDJtanRXWkxzSHR6WGRQTFdCRS9nL3NtTURyOVlhUk9scWNW?=
 =?utf-8?B?ZjcyL09rU1QrbktwYm1RZk85b0FJc3dORU40bUIxZFp1WGdSbE5VVGh1dlli?=
 =?utf-8?B?Z1dzOFZOYnRFYk1YOUlOMUVnUmJYOE4zamcxTldGK0huY21GQmUzY09qWmtv?=
 =?utf-8?B?LzZJMXd2eC9ROHMzRERTM0k3YittTkIwNXIrT1YvQjVzVk1wTXJWVjhyQ1Fn?=
 =?utf-8?B?OEVIVEViYlN4d01ZRHRyaE9uaWREMnN2MzcwWElsVVVlYWdZTTAvWjFLR3pX?=
 =?utf-8?B?ckhsZTZUV1ZqcnRYYmFHa01RMzhpYVlEd0wxL1lCUTJycXA4eGhkMGsxRFlt?=
 =?utf-8?B?YVBqaWJEdXNRZjhhZnd4WE1rUVYvOG9KcEhRaytGbHdVVlp6Wlh3SEE0Ymcw?=
 =?utf-8?B?YkRWYWRRZEZaQm5UT0NLNS9aWXlVc2svMGd4TG9yd2FMODNzQ1JJSmdPdUsy?=
 =?utf-8?B?QXM3c3JGS2hKTWVObmVTUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c91524c-a926-49cd-e44b-08d941b8d6e4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2021 02:33:58.6537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p/3uF16NfzY5Wc+iNj1cjlhd89K86YOC1h1th5kEtl1M28TEL45apN51MuMfyiO2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4870
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: _S23O_GsX7CyRK6DfDVP7lHcRW5rKUUQ
X-Proofpoint-ORIG-GUID: _S23O_GsX7CyRK6DfDVP7lHcRW5rKUUQ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-08_01:2021-07-06,2021-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107080011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/21 3:16 PM, Zvi Effron wrote:
> Support specifying the ingress_ifindex and rx_queue_index of xdp_md
> contexts for BPF_PROG_TEST_RUN.
> 
> The intended use case is to allow testing XDP programs that make decisions
> based on the ingress interface or RX queue.
> 
> If ingress_ifindex is specified, look up the device by the provided index
> in the current namespace and use its xdp_rxq for the xdp_buff. If the
> rx_queue_index is out of range, or is non-zero when the ingress_ifindex is
> 0, return -EINVAL.
> 
> Co-developed-by: Cody Haas <chaas@riotgames.com>
> Signed-off-by: Cody Haas <chaas@riotgames.com>
> Co-developed-by: Lisa Watanabe <lwatanabe@riotgames.com>
> Signed-off-by: Lisa Watanabe <lwatanabe@riotgames.com>
> Signed-off-by: Zvi Effron <zeffron@riotgames.com>

I double checked reference counting for `device` and it seems correct
to me, so
Acked-by: Yonghong Song <yhs@fb.com>
