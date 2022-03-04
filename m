Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5264CD6CD
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 15:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239976AbiCDOyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 09:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239972AbiCDOyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 09:54:15 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497F5119F0C;
        Fri,  4 Mar 2022 06:53:26 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 224EFSgO019110;
        Fri, 4 Mar 2022 14:52:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=HohMhKiSlunQOdKjFZsZP9L2vHnDxLkyWmOoVQNndCE=;
 b=i4fJrOa8FKWX8QPi31jqAxUzeaQqnRat21xWGx2xv7I18s2Ejsi4OVsoe6jfDrZ3aVSU
 RSFS1EdaYzNLgcip7aYuRwjDrNH17mfnrUSk1HUKouD53I/LPg2l+t+P5/ydsLryGT74
 D/mMDqkQPorUMKeU8LVAYZFtPf7Gy04YN2UX7DaCJl7arF2SO7k4HHYVF/ZfrPBCq65y
 eH/TRZrzv8ZOdWox/RR0pH7wHLNDisG4Msg4koim560G6f2GBDOFDnYlmPPKPJa8He9P
 46Vo7m1Cp50i/28nlpYQhNl4ixLLA6R7cL9yDQFgPthiBKnUeFIJvaUDyarU4w/WWKaE yA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hv9xgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 14:52:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 224EZOmd069058;
        Fri, 4 Mar 2022 14:52:12 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3030.oracle.com with ESMTP id 3ek4jgvkn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 14:52:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDffRyuGcvsYeAmywz4uI6NqmsRoEvMBxuh1DDw168ADMwzUene/CiXqYz02nlkxkiwWt27lswA8ZRuwRiNwDJk+i29TvAcvjdk2vHwc285wDT7P10TtoDKZBuVigsGrN3wSjWHT9kt1y/2U9Rkr2GHk24eDp/deM3LGevPMLVCFrw7WB7mSqiPImO9c6XE06MTNZjW+NLspxw/46u3fEoU83UdZxvOi7o6lv+uRFqeWHMMxA0Dw9skRprvUTTy+1dnCzuq81gkeiIseegaauOwWjYBdJI00RBpwPHHNzZnO2Lerwe9z1trpKgEO0oNACFPzPd0vANJTSMiYAa7/VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HohMhKiSlunQOdKjFZsZP9L2vHnDxLkyWmOoVQNndCE=;
 b=dwxw3hjRNwg6m2tl9fLl9p0e4Zr/TRYjE/gWhFCtTG+ZiRraaRcaPjst0s7ZlQYuc5Gox+fqRYJ53NXQ8i9yI6DMiE4CCK5AyFQrM5O8k+iidZvfBjoX8zeB4uciSyWG30P2kfjjQjxsKwR8GmgYn16t9s+uUAVCdprOnedjp+emsla4AMuuhgUcXyGU41jMuso0nWjrxJcwH0KiOGCs4ekcVIIAUewgdyE6OdqyAi49UQ8OgbKybflE92IV6ZXKvJaPhViHrr7NRt75t6tMmvb5g69QPvDmnC2DSxx1H+INQ/TA4dHKw6VAl3/gIiXHvtUW6LMfOJHkJUhdQAgrEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HohMhKiSlunQOdKjFZsZP9L2vHnDxLkyWmOoVQNndCE=;
 b=fAYeyQvd7fsjiAhYlpQJQtpIrIJQB1rmW+EyAAaRVV/WiTOI3IP8yV7igzb3FNy63xlH/k23cnvyp7BZW2gkvlMmRp1XA10en2x6fbm3tTlgcfi+zhzK2dUiwumoeirz7dKciLAW4CaYHEoWn352swv8eyCoS6xWW1BVe5a/U1o=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SJ0PR10MB5672.namprd10.prod.outlook.com (2603:10b6:a03:3ef::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Fri, 4 Mar
 2022 14:52:11 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 14:52:11 +0000
Subject: Re: [PATCH net-next v5 0/4] tun/tap: use kfree_skb_reason() to trace
 dropped skb
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
References: <20220304063307.1388-1-dongli.zhang@oracle.com>
 <20220304.122547.1342402483120688005.davem@davemloft.net>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <578fc0bd-56bd-e644-6cf8-1c6b203f0f8b@oracle.com>
Date:   Fri, 4 Mar 2022 06:52:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20220304.122547.1342402483120688005.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0094.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::35) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e2ecf44-f1f2-4149-033b-08d9fdee8fe1
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5672:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB56721E9A4E98D81B818F6795F0059@SJ0PR10MB5672.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jNiEdC5fwsS9qhf+p32MVelRPYvm8hdfZAgWrS3O4dzniCkM4oNzW7tTWC59LY+8hOqOgYCSzPABMtYF4DLgEdeB1i4X0sN8ey/J8ChAtZQFE/8zynEtr6zLG3Ei95BbUHevyBTtMTl+/9BcEjCERWUQmld+1pwm32f3GFA7nxhGIK3Wvbp9lB28uiUkyck/5D1tes11yEdU4y9rAJHhbifZDOeUqplDlQbFckVzYK/cXO5omX4AXKqx/cNUTR8Rw8HHqBaIgep/6Le82Sp7a/WDlUadtPbsj295idkggXPnQSn6xBvawozlTm4zCfQSzT2DjkLhIDwhDYnY38o+6629XUxJnSmQ3J2it0fxD7QmWbBa8PnZlis9TMJ6fJA2GEnBJWeCNTHOwWModzgWWWx3MBvipEqr5anyhwmE+K76dVQgZnI1kqs826ULXQYIj0x1u6ec79zpRnmeuK+YnBY8kesQOvN8FAawxO1uKBvDj9IZFSvThDAH5UxSJpCEZlXJxIOutJ3tO+Sy+73tIi7AFwaXPdUCzBrGHfEAjmMZGPYvIsxHQfnNGhQ2549ZMiLTfQwl508AXb8to7emm7fk/6jeeLzSMBwC/CG0QV9EhC33uBbUsFyKLGWFyslTHJm6NQKBR/akQ8umRITaF9z833jSc1XLbTPASjmb7919BybXyyxaiujJZo3JkcfuFY2cFxHj9v8rjE7YZSv9sqK0uuQ6Jj5YmTmh+uxGf10YJjE+x0CcOTw+PUp0lbV/QorsQk2PUKb+juou/LU4Ma51db0bAXvBNRG5W6JNWb48JoizLIz9PC6AQCf9+YR1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(6666004)(2616005)(966005)(6486002)(508600001)(86362001)(31696002)(6916009)(316002)(2906002)(4326008)(8676002)(44832011)(31686004)(8936002)(6512007)(38100700002)(4744005)(66476007)(5660300002)(66946007)(36756003)(7416002)(66556008)(6506007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?azhlQ3l1V2JCdmttRzluWFBhQ1JXc0IvZitWNzRTMnF2eDdhZ09xN2NMVmc4?=
 =?utf-8?B?ZlBJUERKbWFnL0gwL2RHazg5V1Q3Tm1aOFFkVkVtT3dRdGxjdjhQR0hwSE9X?=
 =?utf-8?B?anFoUEZ3VUxvNGFTaEtmK3lROFg1dHhEcUFjalRPL1FEN0NIbi85VXlia0xS?=
 =?utf-8?B?WHlvVGxWN3NnaDNacDFBcVpvTkxPamVpbTA0cHFlSEtuMVdTQSs0cHZLRE8w?=
 =?utf-8?B?MlFIMkZqY21QYzBPZHRMRXZjVU01dXVKeHgvU3BCcWhQT0g4MENIMm0xZlgw?=
 =?utf-8?B?djdUV05pTVJ0dFU1TVVYbmp0Tk9wU2JpZHp6NzJWVFdyTTZGN0N3SGZ3YVFm?=
 =?utf-8?B?RnUwRHgrb2E0dE1rZkoxVWpkRWJkaHVrK1FRQXE1a1NPaDZGNXJ4eXVVYmtN?=
 =?utf-8?B?N1VjNXJoV0MwVEdRWmV0V0JibWJNYTBwc3N6a20xQytLcFd6MWw3VWZaUjMw?=
 =?utf-8?B?Q3NtbzI0aVd6WXNuUUhVenhtb3FvbzhyT0ZPb2Jia0UzMUdLMUFiNWZ5Wkdw?=
 =?utf-8?B?NWFQSi9USjF6ZEZxdGNuWEdCMjkzNFJYc1hDNmx1YStLN2xaeWxDa3hMVEhZ?=
 =?utf-8?B?aEdFTmFvbDdwckJwWDR2eTdPT3JkQTJuQm1hakVRNEZ0Zm1lYzkrN251QUlI?=
 =?utf-8?B?Mno3NGp5RklQWEdNZHBVNEY2NW9rbEt0RVFnejJWSkxJNHFHZ25lQmxSeTVv?=
 =?utf-8?B?MXJkRVdXOFZLQWpoZG1BTDVnbWl0SzhOYzhsMC9NalVBMHVwSm52ZkQ5akxG?=
 =?utf-8?B?WExmQUdYenhHUjlYbTJibVlsMXB0YjJjSStMcHRZajNTZy9UQUtlL0JPN05X?=
 =?utf-8?B?S0d0djZDQVZnaytsVGNzaFkrdW1WT2xpZDBwN2lBWFJoeFlHaGRrN2xOcTlN?=
 =?utf-8?B?VkNGMlZaR2haOTZsTTB3a2dBUUNlRGNKN0xBc2hDaEhZNUZENkovUE9HdTh4?=
 =?utf-8?B?OUJScEJkM3ZzSS9YcmVwbkJraEZLem1JeHF3eUhDWVdsUkltRys4bEN0ZG13?=
 =?utf-8?B?S3VyQXdMY0gwekowQ0I4UkZxN3I3SkJVSVlJdjBXajZ3REx6d1oyTndDNWhG?=
 =?utf-8?B?c09mc2dmZjN6VCtFYWxVazVjUWpjM0VDMzV3UlNTckdvQzRrWUh1Z0JERzlj?=
 =?utf-8?B?d3J5ZGlZVE5SYWpBSkMzOG94YW1kM1pvT2xnOUJ3QkYrcE1XK0xsbytKRlFo?=
 =?utf-8?B?UDBzWTF0VkhYSS9rQk5UdVU3amxjSWRWd2dVL3puSUZkVStJSHYvV2wzQmZU?=
 =?utf-8?B?Sm9ZNnp2bDhzMWljU2RhZnZRb0JqcG5kT3JJR3Nzaldzb2REY3RQeFBGbTFt?=
 =?utf-8?B?T3RROVVpNGRLWFRmS2RxTmEzcHVzODZDQTJoWDd3Rm4xUFdVbHlURTRsTko5?=
 =?utf-8?B?aXFDMzEwZU5aQzlsaXFpSzBIWW9SRTRtTlh6VmhWTit5QXA5cnFKUDNmb013?=
 =?utf-8?B?b1ZHbzg4MElOV2QwUVRBM2RUazRYbTdVUUtHaU1SVTRHZ044czBhSEJENTdS?=
 =?utf-8?B?UDZTdWRSN1N4bzhVSVhoYXRIY2hldGJ3M0hBWFRiNHlENkREQ2dUbmE2d0o3?=
 =?utf-8?B?UWVDWVhDd3hUL1BQSWJuUFQ2ZWVIQ01XZklBK2xmejgwZmhNckcyeU5md0o2?=
 =?utf-8?B?VmFDdzNGUHY0VXJnNnQvbEF5bTRYZk9HbytMaEFPMWttTytRVkhsbHpseGdL?=
 =?utf-8?B?bkhCSDFGVFV4bnZZU05rd3V5ZmQvS0dLMVZoNENXU2NhZjZMalcyWHJIVGpX?=
 =?utf-8?B?cE9GamlYUEhMTFpQeTZISmxhUnpMT2s1QTZJUDRiZlIxemtJOFZhUGhNRHZy?=
 =?utf-8?B?cy9TZ2JqSGZTWFNZbHF0K013aDBZWkh1aHJRWUpUZFVGTGJVS2drQ0cybUEv?=
 =?utf-8?B?TVZ2R1Z0cXFIcnRTU09yNjBjSFF2ZnQyNFlpQSt4bG9pcCtKQ2syWnZITnhj?=
 =?utf-8?B?cndObzZhOGxweUFTYjJDY1F6bVhLeWJGWk1aRlpwdTJFNlg4a3Zya0ZNNFpo?=
 =?utf-8?B?YkhjeTVOTHM3eHBwZ2U0WGMwMSt4UGVsMkw5K1NodWhuNEVzQkhBb0JDMkFa?=
 =?utf-8?B?Q0NDQmFWbTRhUUgwNjRiUnpKcWhwL2pBRkhOeHpTREYxNmJTZXd6dThCMFRD?=
 =?utf-8?B?ZnEzRXU4Yk1TeHNuQWx0aDF5azdHYWxLUy91L2V2eVFPc1RLaVh1RWVFeEYw?=
 =?utf-8?Q?T84y6ZD+NJIki+AynNWsZGIipxvK5itzNR3LUAoo15Q/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e2ecf44-f1f2-4149-033b-08d9fdee8fe1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 14:52:10.9599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yjo8ovXKpxhULeFKJ1pS7M0DcuZaKHt++ZAwNYqgHZjbR1Y63l8uRTwDj5tfmRT4AXTamqoJcufDoebk/LQDIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5672
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10276 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040080
X-Proofpoint-GUID: OiMWQF-DllDrPBluVetTMJxMRx26wyQz
X-Proofpoint-ORIG-GUID: OiMWQF-DllDrPBluVetTMJxMRx26wyQz
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On 3/4/22 4:25 AM, David Miller wrote:
> From: Dongli Zhang <dongli.zhang@oracle.com>
> Date: Thu,  3 Mar 2022 22:33:03 -0800
> 
>> The commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()") has
>> introduced the kfree_skb_reason() to help track the reason.
>>
>> The tun and tap are commonly used as virtio-net/vhost-net backend. This is to
>> use kfree_skb_reason() to trace the dropped skb for those two drivers. 
> 
> This patch series does not apply cleanly against net-next, plewase respin.
> 

Sorry for that. I will rebase to the most recent net-next.

Unfortunately, one patch just merged to net-next has already been in my patchset ...

https://lore.kernel.org/netdev/40f63798-2b85-c31c-9722-ee24d55093a8@oracle.com/

...  so that I will need to remove my PATCH 1/4 and rebase.

Thank you very much!

Dongli Zhang
