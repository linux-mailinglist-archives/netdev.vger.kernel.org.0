Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AA94BED78
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 23:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbiBUWyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 17:54:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235855AbiBUWyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 17:54:45 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BD02459E;
        Mon, 21 Feb 2022 14:54:21 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21LHoggw019030;
        Mon, 21 Feb 2022 22:53:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=c3m7/O1DWyAj3x2EemrgBpl1E3qm8xPONKNe94L+2mA=;
 b=vjog858hqmz9/h2S0Kvydg6GFkyal/naoaBhuf+8+qR7wlZQHtL3+bMs7Jh1ZBylucB2
 yHyuedNKFGpmAJKkeka8gUA0tKtNfNClisvs3tgYJrIXvup9NFskpae30Z+yzzSlFN+u
 ubKSGqIHOLCBKhgGr50Ny7QzXv4usAIc+KmRf/iRBlslmy+GqJUYlMObwRjFCoUusC2H
 cn9CfqQpa/O2KYgz8qKQANhXehP6JdZvNRLwkz3adJzo4dGRS0+xWyUeaQzrhkPsa5r8
 h+On+FjzzCuY19CO7MrjlkfQ/3p9Q6X4zSOG/UCP6PaK7CVWh6YRpKeDjuWGAYHercLr lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eas3v53ks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 22:53:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21LMoQgc169944;
        Mon, 21 Feb 2022 22:53:21 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by aserp3020.oracle.com with ESMTP id 3eb4804arp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 22:53:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyJ+mmetSAwNTP1huTk+f+QW6C8oprpW5RTiVXvAVAYJlW0nQY3pfj0Q4szTBR2doW/WRB7P1ToW8UOoc5PmylvNUAA5mFps7Y9/DdhB1//xOiAItTxTuH6RFy4kErY/PXhgy9beCEfpc/V0kFOI6OO0SBGsgx5fCFoA8EGL1FOcaO76KJHuBIX8yU+XenvfvF1qemXu3vUkgm0uk/Z+5UG6lUj1iD27y7WDiH1Vig4W16T/J3X9+CNC33guXmIvppspx5x9+cCWQXEzINCg5ttcbKXHTWxysyjqOisSXTI8DwZaJB20uoYYBkw2GEe7wQ0i9neQQ7zOlseqk9SPeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c3m7/O1DWyAj3x2EemrgBpl1E3qm8xPONKNe94L+2mA=;
 b=J18YkScPc7ALhfvBFe5ZXJLVsFURVNqZ+SWjpFI0G2NcO1rZ1+V8j73b55aeZSFb9l8abkFubSoYk827WzFNEyXK+e6gydFsIHmphwaJbz2yzM/JhPN3ItSqJ+BtftLoyTVmn5fkdYJ9C52AS04Op0fjiUh5QFidG74M9fp4ZXZx23rt87UwrXSRUqlwdnTjLEDs7HWIzyPMwkLNhF1jjH0sLlJ2GrkkQVgkhTMNq0pB5TgVTC/PFUwBKFEK14Tf1g7bznKDwRG1iyeMQQfo/3AUz9WO14ghrDV7VHTkH0V5PBWYUuy2/enWRH0pEzmAah67ihcmRsulvI021iU6sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3m7/O1DWyAj3x2EemrgBpl1E3qm8xPONKNe94L+2mA=;
 b=AjaO/8lKIh8js/SOo4adIa6nwhPodwsolR3fp1fEk5mUeNCToVj0r6GMWGlQy8YUvNK0o7jscO5ZdPJwiKV5rm1MamG+GhUsZQ7zIOZL6+RZ0qktTQLMpbJjHpNzRSJt5L7yOnN6KX+PKFkLvW/QIwbqfMB6lNQrIRHzh6V1fK4=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SN6PR10MB2816.namprd10.prod.outlook.com (2603:10b6:805:d5::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.22; Mon, 21 Feb
 2022 22:53:19 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 22:53:19 +0000
Subject: Re: [PATCH net-next v3 0/3] tun/tap: use kfree_skb_reason() to trace
 dropped skb
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
References: <20220221053440.7320-1-dongli.zhang@oracle.com>
Message-ID: <213e06fa-13be-f9c1-f9dc-613e0cb6a39d@oracle.com>
Date:   Mon, 21 Feb 2022 14:53:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20220221053440.7320-1-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0048.prod.exchangelabs.com (2603:10b6:a03:94::25)
 To BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b616325-98dd-4f60-7204-08d9f58cf468
X-MS-TrafficTypeDiagnostic: SN6PR10MB2816:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB28163D4E0F67B50F19CD420EF03A9@SN6PR10MB2816.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KzHofCh/DYGrMBldoQxVZBbRtJ5nV6STQmLPJtEyFgjBtr/3u2O5isLlEeRqzikxK85OBFqdxhaffru1oPu+QaR/epKeSKB+ywT4kIaQGb7PL8WNh9PG2j74k5uUgMqnLazBdpkYj+vWOfL3pkMCv4vQ5KLdSaTNJYgzZwqge2PzVU9dCj79QG+5H6Hpi/+CIswq2xkuFy0BZYZC2gf7Ig1Iax2bUd8YbTq8iP57Os6lkSG0YmUjAqJODTy42yzq62vcmWDVeA6xvsvTPOLtmf2Nn9vWobw1GTKzY4U60szOOF80C536vjxEPuZ81Cwxxw5OnFt50GP81VALHolUHovSagjui3KkX6UXi7ek+drqXsS5t/MsiV/YoUJpUjgzJs26p1K/DAwtTfk3VikIHMCk1T1C9ZovxPOUbl58mcfWi/DqnVTT/7yZY5tPS2YFPFLlCgxT1wGMRKGYLan/6SfrDYHeVUIHe7u9n4ZqqOoTpjAeOgHdkQzQOSMCsqP+lYo7PJz9iCPzwAfR/+r4Y37Ob4FLx5lUOTA5hDA5mGApMhaZ7CeWI81/OnsS9vwI9vgRRCviU4CMwIzht42/4d6DWppu3o+VgtJj6QclFjxRtxdKfRueFGeaDR+VF+Rp0HAQJMn3+ybuU9wuU1NMe0cvRbPHpt1czFcOAYuThuMhv/8Fkur8fO3W4QeE2Q8bxrkNeOGsf9c+0WRovn+qhzPxyJBNb3M8XB0Jka+HXjU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66946007)(4326008)(8676002)(66476007)(38100700002)(8936002)(2616005)(2906002)(316002)(186003)(36756003)(5660300002)(31686004)(44832011)(7416002)(86362001)(6506007)(83380400001)(6486002)(6512007)(6666004)(508600001)(31696002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTIwVUdybklBeGNIREtUWjJHMzN2ejQxaTJvZzNVUTVtSlV0cCtlcDNHZ1d3?=
 =?utf-8?B?OS9zbkVhbXJNT1gxM0hXQ3hzcloxbW9pUmtOZ24vNFRkUzJLcmViaVd3MTdC?=
 =?utf-8?B?VmN3eVlmNlNDNzJhNkJtb25qODNKOXZrVDd4TW1jellwQTNLSzhuajFHVHM5?=
 =?utf-8?B?U0thNGt5djVjOWw2NC9Udy9GV0M5Uml5N1BRWkQ2ZTRTZmJiZDFzY3UvMGlK?=
 =?utf-8?B?U2NkSi8vSHFyUklxL1l4bXFFbFRZSWliaUlWNGdhZ2tiYWFFcWVabVU1czU1?=
 =?utf-8?B?MWZHaGZqcGpQODhrZEhScmpIdS9RNThobElqcC9NMEkrR1lLdmxydWYrM3FQ?=
 =?utf-8?B?T25pMVVMeHdhalIzUmRlQVFhUytvWlYwQVhZT0kvQmpIZGYwUjdCdUp5aHIx?=
 =?utf-8?B?RmtZUGRRdTZtb0NLaTVsRVRrMkxpbUlSQkg0d2FObDdIRlMzckJBV01hcW1q?=
 =?utf-8?B?MWlDT2ZYMGwveFRpV0lpWTdkb1JRSjJCbWRIeGhZbi80WE1VZ05ob0IrY29q?=
 =?utf-8?B?M3RtT2did1dzeFlmdjdSSm1NeUJJcTUvdk9Id2tiNnN2RnFuRGFlMWVxeVVu?=
 =?utf-8?B?ODRFeERKT243VUFWclgvdjhoWVBwb2lkdGlNQ1RiSjhrUTFpZEZ4OFR0T2ZP?=
 =?utf-8?B?cDRnZ1VyQ2VLM0ptWjF4cU5ib1NmVk9uTDJQZ1R0Q1E2aW9RaENCY0NIYjBh?=
 =?utf-8?B?Mjc3OXJDQjRJaHhQY1hsQzNyNGhOSW9GWGRIcWJvUUNWNCtJUjdDTVE2ZVpt?=
 =?utf-8?B?SStlZUpTUkhmVlM4bFNIWkNzaTRHZ2FVRi84UERoZGJOd3RZb0MzajNKbFpY?=
 =?utf-8?B?Ry9Hc3N5TXZMMWZWZXNXeEt3UWZpZ1ljUFRwVERna0E3M1lZNU50bm14ZnBE?=
 =?utf-8?B?Ny9aUGllcURhTFAwc05pY1JtOURiSFd4VkkxZnV6L2d5WjhPZFljMlRxenNq?=
 =?utf-8?B?cXVSa3RNQUxDV1VOWTJRTUk0OWp2bUVOcHJXbDMxdEpsOFJyR2x6TEZKWkxm?=
 =?utf-8?B?MnFaRk1ia2YxMXZ5WkJIWnE5R0VaeGpjM01rd0hWek5SV0dhL0JnRlowSXhR?=
 =?utf-8?B?K0tUUloyTTlvaUFYUHFIMWx5dHk5dUs4UFhka3poNzRLNW1Cemw4WkJMazBv?=
 =?utf-8?B?NnR0bUFucXVscG9IMXJpWUw5WGczb1M5c2NQN2Vpdm9XNE5tMzZTZmZuOFJo?=
 =?utf-8?B?Y0tQUE1GZ1lXTG9sbEoxUXVwdUJpRnpuUm1IWlFRTFBOREtTR3dsc2lMdEpE?=
 =?utf-8?B?VFpwaTF6V0NreVhhd2xmdnlPS2d4K2RwUFhYaGRpMmtMWE5QWEF2RmVXSXZ3?=
 =?utf-8?B?bldySUJ4QnRlYlpNTTVOOHAyRmluOHA5TkN0TnE0dkNwZVVqL1Z5Y0pqb3Zn?=
 =?utf-8?B?RlJjeWVHMFFqWnBuTFAxbm44RVUzNVRQa002NTkxMkNxbkxISzVPN1d4dHQ4?=
 =?utf-8?B?WVo4K2dkM0E4eUFDMXhWWE1jdy9TM3lVSTN3S1NIcjZJOEZHQlF6MXlJUDJE?=
 =?utf-8?B?Wm1wZlJkZjFRaVhHSzEvanUrT0JEMmRtc3lhYnd6TmRsZzFGUkRhQWFCVkxF?=
 =?utf-8?B?YU1DNURqRStxVkYyeVA3ZUtYeTBYZFRDWm1JR2RZbFMzTlR2WStEY0tnekxW?=
 =?utf-8?B?OHNzVWNJaVpvR1lZNFR5WVhIZkx3bFZQc2JqRzVHelhwZTI0dEUybVNDNmto?=
 =?utf-8?B?U1UrNlFxQ0phRUh4b2V4MUtQaXc0Z085Z3h1dVdRTmFBRjhwTERBTHo3Smxn?=
 =?utf-8?B?a2tza2dTblQ4dHBKbFFCRDZ2akdkOCtIb2NQOUdyZVdIK3p0aDlTL3huYmZU?=
 =?utf-8?B?Qit0WHlFYlNmZmovYnZHNUVndWNTVWRCUmYxaWVDaXlZUHp6dlJhM2hKaEZu?=
 =?utf-8?B?Tnl4N29NRTVMdmdsQXNGVkxjQUhZb3NjWG1FVUgzL2FwckszMmNyN0lxeXBF?=
 =?utf-8?B?RE1ZV3ZiS1B1bHhEeFVqU28rRDlmZFFuRm5KNkxlTEppK1FTMlVrc3FjTDhG?=
 =?utf-8?B?NjB2eFNGK3VWSFBpM1Uwc1FzbUhZQzlMYjNUL3l4RVk2WXVGd1lkVi9aZk9p?=
 =?utf-8?B?MEJ4eTR2Z2RmdUc3Z3lHdkNCM1RhcWMxbWlWcWdHMm4vazB2R3hNY2ZBYmtH?=
 =?utf-8?B?QWNQN3JabFBkczhnUFJBdXZ1cFg4cnZJaW80VWg4dmtqSzdadXRWc0hLVUg2?=
 =?utf-8?Q?rQyD5b4So5FwPRdf0Ttg8KWBvygqvjWgVE34Tz6SStun?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b616325-98dd-4f60-7204-08d9f58cf468
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 22:53:19.7316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QJT+9oCty4XRfGakkIlNC11DHEFGAsrTIbbqThJ0+MmkhAbtSTUG46efekbxHCcPNeLxqPkB9twAfrrwL9SPWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2816
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10265 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210136
X-Proofpoint-GUID: 43BR7JH7yVRpz11f1d5XHYLt-u7P_6HY
X-Proofpoint-ORIG-GUID: 43BR7JH7yVRpz11f1d5XHYLt-u7P_6HY
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The subject should be [PATCH net-next v3 0/4] but not [PATCH net-next v3 0/3].

Sorry for the mistake.

Dongli Zhang

On 2/20/22 9:34 PM, Dongli Zhang wrote:
> The commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()") has
> introduced the kfree_skb_reason() to help track the reason.
> 
> The tun and tap are commonly used as virtio-net/vhost-net backend. This is to
> use kfree_skb_reason() to trace the dropped skb for those two drivers. 
> 
> Changed since v1:
> - I have renamed many of the reasons since v1. I make them as generic as
>   possible so that they can be re-used by core networking and drivers.
> 
> Changed since v2:
> - declare drop_reason as type "enum skb_drop_reason"
> - handle the drop in skb_list_walk_safe() case for tap driver, and
>   kfree_skb_list_reason() is introduced
> 
> 
> The following reasons are introduced.
> 
> - SKB_DROP_REASON_SKB_CSUM
> 
> This is used whenever there is checksum error with sk_buff.
> 
> - SKB_DROP_REASON_SKB_COPY_DATA
> 
> The kernel may (zero) copy the data to or from sk_buff, e.g.,
> zerocopy_sg_from_iter(), skb_copy_datagram_from_iter() and
> skb_orphan_frags_rx(). This reason is for the copy related error.
> 
> - SKB_DROP_REASON_SKB_GSO_SEG
> 
> Any error reported when GSO processing the sk_buff. It is frequent to process
> sk_buff gso data and we introduce a new reason to handle that.
> 	
> - SKB_DROP_REASON_SKB_PULL
> - SKB_DROP_REASON_SKB_TRIM
> 
> It is frequent to pull to sk_buff data or trim the sk_buff data.
> 
> - SKB_DROP_REASON_DEV_HDR
> 
> Any driver may report error if there is any error in the metadata on the DMA
> ring buffer.
> 
> - SKB_DROP_REASON_DEV_READY
> 
> The device is not ready/online or initialized to receive data.
> 
> - SKB_DROP_REASON_DEV_FILTER
> 
> David Ahern suggested SKB_DROP_REASON_TAP_FILTER. I changed from 'TAP' to 'DEV'
> to make it more generic.
> 
> - SKB_DROP_REASON_FULL_RING
> 
> Suggested by Eric Dumazet.
> 
> - SKB_DROP_REASON_BPF_FILTER
> 
> Dropped by ebpf filter
> 
> 
> This is the output for TUN device.
> 
> # cat /sys/kernel/debug/tracing/trace_pipe
>           <idle>-0       [018] ..s1.  1478.130490: kfree_skb: skbaddr=00000000c4f21b8d protocol=0 location=00000000aff342c7 reason: NOT_SPECIFIED
>       vhost-9003-9020    [012] b..1.  1478.196264: kfree_skb: skbaddr=00000000b174fb9b protocol=2054 location=000000001cf38db0 reason: FULL_RING
>           arping-9639    [018] b..1.  1479.082993: kfree_skb: skbaddr=00000000c4f21b8d protocol=2054 location=000000001cf38db0 reason: FULL_RING
>           <idle>-0       [012] b.s3.  1479.110472: kfree_skb: skbaddr=00000000e0c3681f protocol=4 location=000000001cf38db0 reason: FULL_RING
>           arping-9639    [018] b..1.  1480.083086: kfree_skb: skbaddr=00000000c4f21b8d protocol=2054 location=000000001cf38db0 reason: FULL_RING
> 
> 
> This is the output for TAP device.
> 
> # cat /sys/kernel/debug/tracing/trace_pipe
>           <idle>-0       [014] ..s1.  1096.418621: kfree_skb: skbaddr=00000000f8f41946 protocol=0 location=00000000aff342c7 reason: NOT_SPECIFIED
>           arping-7006    [001] ..s1.  1096.843961: kfree_skb: skbaddr=000000002ec803a8 protocol=2054 location=000000009a57b32f reason: FULL_RING
>           arping-7006    [001] ..s1.  1097.844035: kfree_skb: skbaddr=000000002ec803a8 protocol=2054 location=000000009a57b32f reason: FULL_RING
>           arping-7006    [001] ..s1.  1098.844102: kfree_skb: skbaddr=00000000295eb0da protocol=2054 location=000000009a57b32f reason: FULL_RING
>           arping-7006    [001] ..s1.  1099.844160: kfree_skb: skbaddr=00000000295eb0da protocol=2054 location=000000009a57b32f reason: FULL_RING
>           arping-7006    [001] ..s1.  1100.844214: kfree_skb: skbaddr=00000000295eb0da protocol=2054 location=000000009a57b32f reason: FULL_RING
>           arping-7006    [001] ..s1.  1101.844230: kfree_skb: skbaddr=00000000295eb0da protocol=2054 location=000000009a57b32f reason: FULL_RING
> 
> 
>  drivers/net/tap.c          | 35 +++++++++++++++++++++++++----------
>  drivers/net/tun.c          | 38 ++++++++++++++++++++++++++++++--------
>  include/linux/skbuff.h     | 18 ++++++++++++++++++
>  include/trace/events/skb.h | 10 ++++++++++
>  net/core/skbuff.c          | 11 +++++++++--
>  5 files changed, 92 insertions(+), 20 deletions(-)
> 
> Please let me know if there is any suggestion on the definition of reasons.
> 
> Thank you very much!
> 
> Dongli Zhang
> 
> 
