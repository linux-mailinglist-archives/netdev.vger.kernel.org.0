Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5204646C757
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 23:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237834AbhLGWWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 17:22:54 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19678 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237879AbhLGWVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 17:21:54 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7J4cdf021574;
        Tue, 7 Dec 2021 14:16:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=2tKsq/qL/r+NhwepSb+uxf1+QugrAKFwO0FY1iRlKmE=;
 b=XWRecB0LHq59slRGxV2y7kcy4c87QP1TEDscRMPN2zUARQK+HX7UPub6+MnV3zEfzRm3
 IdxqoSmbizZrpLXSleGNzsEIjeRdCejYH5bbUm1Z1kOA9E3adnRpH4hgh+6tI7X7eo9L
 +FBTRFWiMdh2vyAunxAa9mz5ToFRjlLXQTY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3ct4p850sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 07 Dec 2021 14:16:50 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 14:16:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YF8b/DFu1FKl/lPrrjbQFdoGneHpN35XiIZ7hbBzWQ7mWLHqv6M2MeMBU+/SBNqJhe68bFioGZzmA69yZ7ba9BYkruBg6sORfmh3pgK87lxKZbEU22uAufNXYgvN8ivqRV9iBjPa2EMEPLUzePzdKnrzLJRZdmt3QhTcrtIG1HOZ+qQ2O4Ky0Zv6KgyRwYD59KujE8MDhruqJcsspcy9aRhsm2BalKrgvn0d0j8pxME5CcDDbsEDJDunK+ECMiY8oCmiwEfzyW7bRbma0oQ000OCp/tDv1H0FxDz1Dhbh4KwY7qLQdCVach8YSE25jI2GA/rgXcY1BGgrvYbnvXWCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2tKsq/qL/r+NhwepSb+uxf1+QugrAKFwO0FY1iRlKmE=;
 b=k1RuoOg9Yap0wZPVsNqjJW/5927XHqw7Lhn94nV5MhdGUq1IxsUr0874YzQ+2X64Bey9Bt0q+KbCdnoOpbaVY/IRnV+oVUZxzFE6iu2IzhT2x2N94XW/bO7IxJSrfrMYCE8DHN3T2MVDnxwD71eeOkbzeHO9x7tm0g1u7UM6kXyTJlmJhyy0TNQ0Rmvb6H8vn4yiufqzQjUfBO5QIsqQzfwuJaAuMvqYDS25Ogl6aPAGsbkJwE5a9oerMsOYXO6YLOERDNau/QHc5Ej0o95KuVFZnTNTrIsoWNOZUfcLo15lMhiUwOXXFrbjeYfM6SJpRkl8xES9R7+iaxGz4jyFdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4465.namprd15.prod.outlook.com (2603:10b6:806:194::23)
 by SA1PR15MB4355.namprd15.prod.outlook.com (2603:10b6:806:1ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 22:16:49 +0000
Received: from SA1PR15MB4465.namprd15.prod.outlook.com
 ([fe80::853:8eb0:5412:13b]) by SA1PR15MB4465.namprd15.prod.outlook.com
 ([fe80::853:8eb0:5412:13b%8]) with mapi id 15.20.4755.021; Tue, 7 Dec 2021
 22:16:49 +0000
Message-ID: <2f0757f8-797f-644b-50ee-0c1aef8fe865@fb.com>
Date:   Tue, 7 Dec 2021 14:16:43 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH net-next] net: Enable some sysctls for the userns root
 with privilege
Content-Language: en-US
To:     CGEL <cgel.zte@gmail.com>, Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <alex.aring@gmail.com>,
        <stefan@datenfreihafen.org>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <horms@verge.net.au>, <ja@ssi.bg>,
        <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <daniel@iogearbox.net>, <roopa@nvidia.com>, <yajun.deng@linux.dev>,
        <chinagar@codeaurora.org>, <xu.xin16@zte.com.cn>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-wpan@vger.kernel.org>, <lvs-devel@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        Eric Biederman <ebiederm@xmission.com>
References: <20211203032815.339186-1-xu.xin16@zte.com.cn>
 <20211206164520.51f8a2d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <61af0ac4.1c69fb81.6badc.a755@mx.google.com>
From:   Joanne Koong <joannekoong@fb.com>
In-Reply-To: <61af0ac4.1c69fb81.6badc.a755@mx.google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-ClientProxiedBy: CO2PR05CA0073.namprd05.prod.outlook.com
 (2603:10b6:102:2::41) To SA1PR15MB4465.namprd15.prod.outlook.com
 (2603:10b6:806:194::23)
Received: from [IPV6:2620:10d:c083:1409:25:469d:91d7:d5f8] (2620:10d:c090:500::1:6b8a) by CO2PR05CA0073.namprd05.prod.outlook.com (2603:10b6:102:2::41) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 7 Dec 2021 22:16:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2de9cc7a-e98e-4735-3039-08d9b9cf4343
X-MS-TrafficTypeDiagnostic: SA1PR15MB4355:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB4355D861EE5E17A5E342D620D26E9@SA1PR15MB4355.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uKKF3Tmi/vDopFDqguKxt+d64WkMbdQzs+RXIM0bHyw+GGiWewo7G4xuoCJywL8b1RL977GiKRPsuHUvxPH3aej1K4+XWSzmnB/k2WYoHgxl2AoRg2evxWh0Pl0BTy7tfibM8L6nTqxaZh4t89CiHNHvJEAuRpM2h+htSClAQqGs5P+Ukpp9B5sBJi45tav4CfcekJmG/klIXue00vKqXfI5DMN0+KaIxkVdinyJum6HkacJdAdMPgY1ZyPA26/a3Zbbr+fWgSjUhBzB8f9KSTdWcANd/kUL8KpoGG1vkiBfM0MGLBoS/6runAmUzWPtWO3Uzy7XXBXVVXKgPmq90QosUKg6j53XfNmIOz4uNmBSVpRmyA//etdRkRPqhCbgTOkWyxswXLRLoRGpQ5mstavWsTt/BXrSC+Ii/YzNuRT3Trvl7i2nZkibyi9FFA5Dvwh1xm1KDYuCrPeiLjFP49OSVPVo12Xj5khyUTuNAq455yrYavjNt+ANKM4NJaos93sNuLeWIHVkaYjzeJ3sISeaeudmKsmE5WyWpVs/aQ3AgUznp2/Xeq4ZyKqtgPnzeIr8ZY1A0QKIQD0FAYX2W1eVG/3leZ6uySZyCU7YFS1QWhQrBto+Qp9Aiy8bnOzbQTfSbS1WdhX8Twn7Z/Ti8vfZa/j2bKJnQkEMVfN0QBNyJc6/YzMHVsqtNiEU6PExaClAe7wDTL62aUfiIvrGaSRGTcow4g2rfbUWk+KugQUicX7E5i3+HBVHlRRAZa1yRg8s/pX5KjzXHfe4RRaJRgrvwPs5ScAbtbOCY2oZO1222AVC41z9T7J9fKLzqNmBj5an7PytssLoQd58VdRqDc1YU+Kwbf4fj/bOtITlb0g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4465.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(186003)(7416002)(66946007)(66556008)(66476007)(5660300002)(31686004)(2906002)(8676002)(53546011)(6486002)(8936002)(86362001)(2616005)(110136005)(83380400001)(31696002)(36756003)(316002)(966005)(508600001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUJxU3poeGpwSTVGdUo1SUh3YldaeEN6RXZwaDMxamc5WWg4RjczVVBCQUhF?=
 =?utf-8?B?NFYrSmdxMzJIWVk4N2w3ZjllT2ZSNy9YZnV5alhNeDBHRWNwcEpDTWpMaElh?=
 =?utf-8?B?UTlXMFU4RVJDYmlPaWJnNVJUVDJvb2JPTzcvSW5abWkvM0R5dXNZQTlVS0pH?=
 =?utf-8?B?NThiTGNLVzgzdWpEeG1kRTFDa0RkdmRqMWFtQkVOZ3dHbVRjUnJCTmVzQ0p4?=
 =?utf-8?B?QVgrVXRNUmZFR3k3amdRcUphTVpqMlJMZTBKOVVROHJkeTk4ZlMvcS9SQ0o4?=
 =?utf-8?B?elV1RHNHbFBsbFd1TGZmejM5YUFhMW1DS1BZL3NiMHR2ekEvZ1hLS1BDa1Rw?=
 =?utf-8?B?VEs4V2lzZ3FSY3UyRzdyT0RmZ1NNSW1NaDFJNDA3U0tSN2RKb1d4UExiZ3Zk?=
 =?utf-8?B?WEVaL3AwYjlQQXcvb3U5V2pWdi95T1ZycVNkWUx5L1A1dlBMcGoxM3FWVzZq?=
 =?utf-8?B?dnAreDZQUzI0Z1Fvb09CZFNBYmxic2czWTRaRWJ4dytBbldKdUxndjQ3TUNu?=
 =?utf-8?B?SWU5MURnMVIxUTJla1pCampXNSsyMkRkTEg5VXYvMS9LRm51YUtZWUwyUGd1?=
 =?utf-8?B?TkpoZXlLdlVnVkk1SmcvTHUxOVhNMkRTK3RvaDBRNVl1OWVNcWNyOElDTlU2?=
 =?utf-8?B?TU9yVStxZTNIVHRWQ21GTS9nbENUYzVlb2JpQnlMenRFalRPMnZpYXphdkZn?=
 =?utf-8?B?THk2VjQzM0hwbmdqcjVOQWtzZlhFaGwwYU1JOGw1bmJjRHdaaVNQREdEM0dJ?=
 =?utf-8?B?NFNFTGQrWnF4MTA1aXFqV0NlbUdPMTM0eFNmS3UwVTliT2tRZ2ZoUFZFczFo?=
 =?utf-8?B?NFhMT3VlbldQbDdjb0ZUSEFpd0ZEa2dLV0FPRkdUMWxGZU4zSnFGY09UbVpN?=
 =?utf-8?B?eEtxakdqWThmRHdpbVZUNVY2ZktCOXBOYWY4UFhzR3ZieU9NWXZTYnZPOEEy?=
 =?utf-8?B?bitTeERYVUdSRzYwZDh2dnYyT1JtS2tqU1dHZTl6ajVWTExwMlhGS3R1TkFF?=
 =?utf-8?B?QW15eUtONk9uRHNpamVzUlVJWmRiMGZRRFRFa3l2SDJlSGdsRVZLL0l0dVM5?=
 =?utf-8?B?VzRpZzVFck1nSkVDZVV1TkV3eGlOTkRSRUJqejNiR2NGTFUyNFMzZ29WV0du?=
 =?utf-8?B?bUMyeWMyMXhaWXE3RXhuMngySXAwOVVxbGFQblc1RmYyUlllaGEzWTJ1VVJX?=
 =?utf-8?B?b3Ruc3A5SHpTWlZwL3BTbXh5SS9LTHZOY3llYXFUM0pIc0tmeDJTb1hCSVAv?=
 =?utf-8?B?V1hPTUoxM0czMEljaXlDYS9tejlydDBMamxRejUzVmxnYkhWR0ttYjhBeS9P?=
 =?utf-8?B?WllraWR2VHFoS2NWbUdibFpRNE1Qb2tSNG5Ic05zeTV6blpyMFVXODZUNnNm?=
 =?utf-8?B?YTROMm52RnRZSDlRTkJhaXIvY21DRWt3d1pSTkEzaS9PNEp4WjF2cWlpeU8r?=
 =?utf-8?B?ODBLcGY5Zm8rSng1Y3lRSE9INDNsTDlLS0RocER2MS9jNmNYZDZRL0dBMHVW?=
 =?utf-8?B?TjlhVG5rcGdaVzlDbktPTGVSWHhkdEI3dGFKT1NFcEx3M2E5b2tOcFZweWln?=
 =?utf-8?B?SnE0RnBkV3FkRmF0RGhhZ0NZeHcyQXRIMUgzMTNPdWZNSkV5dnlkS01ldGtm?=
 =?utf-8?B?dERlbk9BdEpVUWJ6MkVHcGVXRjRKWVVrSlB0NktkOVBqWVR5ZUZONE9mejNZ?=
 =?utf-8?B?c1RGcmZvU2VKYXE3TXJOZTZPSHlRWHdGdzY4cjVpRFIxWlZCYWRMTERNK01X?=
 =?utf-8?B?UkxMbU5QWFIxckdwYTJlWlpVNU5OamtGdjBBajdUZ202NzJwRmx5S1E1MFpW?=
 =?utf-8?B?cURRNTNWaEJaMzNuNEdmUjhqMmREUmFNeFU3ZFBkUlJIUHF3cnZISXRiT3lB?=
 =?utf-8?B?ZDlCUzhtVnQ1OXl1WFpEcGEzSU9jaWlIU00zRjdHTUY2ZzVXYkhMekFjRVBj?=
 =?utf-8?B?MTlsWkNVNzNLa2Y3V2pla0k1aWNIbUVIK00vMTRQQTN4MklRZTdlVUlGblhL?=
 =?utf-8?B?MXlmb0JuUlNkaE5wR21vanRteStCNjU4TW10L2VIQWxNSGN3QktpUFpvRlh0?=
 =?utf-8?B?YzJIMGkwSkxwOXYyb3ZjVjN5dTdwT2R3UVh3Mm8zRUI4eDQ1ZktReUFQQ29N?=
 =?utf-8?B?KzJKckNwZFpkZXBuRy9rdzhrRUdLQkltbDgwemNwcHludGpJTUFzdjBZckRs?=
 =?utf-8?Q?yiDcwAW5wBxDabPFQxFDfwY9HuUmDIViT3mj5DYwwPTN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2de9cc7a-e98e-4735-3039-08d9b9cf4343
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4465.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 22:16:48.9721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 75FrTpRMrUrq9GVLVM2OykJenEdBdnyqburOspzV8LjpQXAt27mP1sF9fG9A5NjtHI7ZEdI3LcoORjXR7qodqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4355
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: dNF53CkqYYl8M7vmsFChFgrHs-qRk8QJ
X-Proofpoint-GUID: dNF53CkqYYl8M7vmsFChFgrHs-qRk8QJ
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_09,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 mlxlogscore=820 priorityscore=1501 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070135
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/21 11:18 PM, CGEL wrote:

> On Mon, Dec 06, 2021 at 04:45:20PM -0800, Jakub Kicinski wrote:
>> On Fri,  3 Dec 2021 03:28:15 +0000 cgel.zte@gmail.com wrote:
>>> From: xu xin <xu.xin16@zte.com.cn>
>>>
>>> Enabled sysctls include the followings:
>>> 1. net/ipv4/neigh/<if>/*
>>> 2. net/ipv6/neigh/<if>/*
>>> 3. net/ieee802154/6lowpan/*
>>> 4. net/ipv6/route/*
>>> 5. net/ipv4/vs/*
>>> 6. net/unix/*
>>> 7. net/core/xfrm_*
>>>
>>> In practical work, some userns with root privilege have needs to adjust
>>> these sysctls in their own netns, but limited just because they are not
>>> init user_ns, even if they are given root privilege by docker -privilege.
>> You need to justify why removing these checks is safe. It sounds like
>> you're only describing why having the permissions is problematic, which
>> is fair but not sufficient to just remove them.
>>
> Hi, Jakub
> My patch is a little radical. I just saw Eric's previous reply to
> Alexander(https://lore.kernel.org/all/87pmsqyuqy.fsf@disp2133/).
> These were disabled because out of an abundance of caution.
>
> My original intention is to enable part of syscyls about neighbor which
> I think was safe, but I will try to figure out which of these sysctls
> are safe to be enabled.
>

A team at my company has a use case for needing to set the unix sysctls,
so I submitted a patch for enabling the unix sysctl here
https://lore.kernel.org/netdev/20211207202101.2457994-1-joannekoong@fb.com/T/#u

[...]
>>> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
>>> ---
>>>   net/core/neighbour.c                | 4 ----
>>>   net/ieee802154/6lowpan/reassembly.c | 4 ----
>>>   net/ipv6/route.c                    | 4 ----
>>>   net/netfilter/ipvs/ip_vs_ctl.c      | 4 ----
>>>   net/netfilter/ipvs/ip_vs_lblc.c     | 4 ----
>>>   net/netfilter/ipvs/ip_vs_lblcr.c    | 3 ---
>>>   net/unix/sysctl_net_unix.c          | 4 ----
>>>   net/xfrm/xfrm_sysctl.c              | 4 ----
>>>   8 files changed, 31 deletions(-)
>
