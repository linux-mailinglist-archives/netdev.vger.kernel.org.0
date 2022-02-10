Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8DB4B18ED
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 23:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345139AbiBJW7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 17:59:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344698AbiBJW7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 17:59:34 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B5B115D;
        Thu, 10 Feb 2022 14:59:31 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21AMfn5I017649;
        Thu, 10 Feb 2022 14:59:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=XBr87L8uBCRElp5tScZPJQtXiemHfAz7xuoLSnnzB2w=;
 b=qY/hAIYVhjHUMsAmrHaYebmby00T/S/12EAXooKK7FDmIuNrWznxCn2Ha6Y9Dy73DO79
 BRfbZEnu6EZCH79jWu0XHl/6VFaupiDnGPL50GL2BBGG9IeRn0+3ghFQkoeBIa/+MZoc
 pHbAf1Oe8r6aQ/QPk/WLsypSVxMUO33vibM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e58mhsg03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Feb 2022 14:59:09 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 14:59:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iEuybdCgQxu5xJ2Qp5ZOQDpS7movjiyJ/PaDjC1mDmNN9NhYtkQ+zS6sEAnxk4inRmDAKbxDClCa6+UPnbiBpMfti6z5kNGMiiQCzAs/f2e4SNORX8BdWjs0WONZCdBQbtNDbZ0Kf05VeFOhQoq4avyjaQTJrR/kOvqYPcCo+qCj6JzIArwEWPcb0VgvbzDbcN0uqqqLbpzmu1BlXtLvOY1ITY1LeJZhEr0ppZTE7PPGRf4p5ue7cUpwqG1PMlevIHXp5ZCiHDle9bBXdKDAWtpoi/2lYZ7WETfme/WnPP1w0yd+P5bAZrD3SLTiG/tl7rRINOmAKHKOt8L1QkizCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XBr87L8uBCRElp5tScZPJQtXiemHfAz7xuoLSnnzB2w=;
 b=inhAoUH2vk2Y5KbPmIvX1DO3fYkc1+L3AaONx70yhwYP2W8pD5fKgdyN8Dfe516i3twuAB4ynLILEK5yd2V3I8QhL38jDud9hopn0AImGY6r4pA7DAD7FmtZn6f1PEluiFz82P2AfI8a/2+aTG6BJkC/ITocK0ZE66Wp/X1lodnC8JVvgfU2XpR+lEEYlZWiB3eoK+Sk7BSMkDlbuFVzCyG9yi2NyNvLPKuyrAFeeTR6Em2umXKCorc+TPAoyANcmbJkjXPude8vH7QXPzI0CHWc5k/jz6ka4llEr6anlQU8ICf8Isb6XYLSxj1Gyvi+C2ijPrEcg+PbDz1jsULDJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by PH0PR15MB4231.namprd15.prod.outlook.com (2603:10b6:510:23::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Thu, 10 Feb
 2022 22:59:07 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f54e:cd09:acc2:1092]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f54e:cd09:acc2:1092%4]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 22:59:07 +0000
Message-ID: <992ae1d2-0b26-3417-9c6b-132c8fcca0ad@fb.com>
Date:   Thu, 10 Feb 2022 14:59:03 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: BTF compatibility issue across builds
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Connor O'Brien <connoro@google.com>
CC:     =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
References: <YfK18x/XrYL4Vw8o@syu-laptop>
 <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
 <20220210100153.GA90679@kunlun.suse.cz>
 <bb445e64-de50-e287-1acc-abfec4568775@fb.com>
 <CAADnVQJ+OVPnBz8z3vNu8gKXX42jCUqfuvhWAyCQDu8N_yqqwQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAADnVQJ+OVPnBz8z3vNu8gKXX42jCUqfuvhWAyCQDu8N_yqqwQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-ClientProxiedBy: MW4P223CA0006.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::11) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18e03279-de51-4bfc-5a0b-08d9ece8f0fe
X-MS-TrafficTypeDiagnostic: PH0PR15MB4231:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB4231FEFE55830392D266106BD32F9@PH0PR15MB4231.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2cAZBgOGh7aBOXTJJH/EftDrrfcwJDL9brlQFTjLtZkWi+Xh9tJMmSfnRwynp5DKgAe7lcbwvV1cj/TzeeEUNYGOCPwZdNtU+TVndDq1Wap4vv61qr9lXW+0ziFUDO8Oj4UkhLqv6VtPPYISfkDnX300L9kW1zuh/DAkxANLdMiYQin0fHMv/5vMsSQbah7Dzg2d78wa4ZRni4wgLRs0yErX1S7D9183kWx4THEWUetVCWeJJ9HcqoXo3zDyzPlGmF9w1dzWZvEto6uoeT5pvh0xFjJsM37MHPytgizymae0g42GchCdxBu51NdKnDVKnmK7TidBCEGSQMqe2itkoP1IYP61tjAo6adtK13nZm0uuiO2yTBzGJF+Anshd7z74qQ8+idOapAyhASqZhjMLlyejiYaJ3t37UhrkuSz+sfGmOxEkHfS/aluDYJvpm4+WlcJmHBT7VEVsP4hzMSijiHwZ4r//3l7Ya8nYWUH59A6/fyMSe3xoKgkrUF8iyB+phDiE/s+s9fgEOgpSeb0i45pr0AR5/zeF6PloQF8Z7nHWm1/cJAFTdIT86TjAG66HgvkpTmD00yBx3nHjup3Ca8VVMuXcCZw5RKqop5Mb+jMQU0lMM7NXiP2/55EhBIrKQ0J+lHcr8FIBqd3r1NdZJIFE3gcDWINX4bLV+rEPQMjydOAJkVPy/huj/hjczZRFn9gIVtk1aVR8ppBjxkj3EBsIwbGdAVx1+n3Qsg/UBQg+V80ryKwFHjwylSZE7d9AZ2lq+1U+YTgu1R0z+AN/9V6Gxh6MsX4RV77Kvq6zhiPvNznzezYRfDu2M71iMIEFEBFrLLA7pH8fBFzBY1IEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(66946007)(31686004)(508600001)(6506007)(6666004)(6512007)(53546011)(186003)(66574015)(2906002)(2616005)(31696002)(86362001)(66476007)(36756003)(4326008)(54906003)(8936002)(38100700002)(8676002)(6486002)(5660300002)(966005)(66556008)(110136005)(83380400001)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDNIbXN3d3J6K1Rwd2pHaFVQWWJpZXJ0aWZsc0JtT0VUbVBKaFRHREEyOGFM?=
 =?utf-8?B?Y1MvOTREZE1NS3U1VWtoVGd4c2o5TGo3ZENWOGNuU3Y1dmpiNjJTaTErcStV?=
 =?utf-8?B?bEtyV0ZiMk9KUUxyemxGMnExZXpkdFVNbVZ2LzR2N3REZW9ocGFyOWZZeWRy?=
 =?utf-8?B?ODBSVGNYN1JCNXJTRndqa1NFclF3VCsraFdXbWtNYXp3Zmhoai90U3pXU3Jh?=
 =?utf-8?B?M20wNE1CTVB3VmwrT3dRUWd2RmdmWkRDSlh6YWk4Qk5ZMnQ2YTdoVDNvMHdx?=
 =?utf-8?B?djZ4dXdvUWVWVzhoelhQdW1pODZhcERSM3JpWDBMSzN0SEN3c1VIWDVQbEd3?=
 =?utf-8?B?ejNzSGhoM2w5dnJqVVdDSU9BS3NNZWdGWGNFRDErVVVLYTJ4NGpSZUFvV1hI?=
 =?utf-8?B?VW4xZFNHM3ZVRjEyNnNNMjlVV0R4MHdwVHptUzN5ZnhLMnExbVZqY2kvckZQ?=
 =?utf-8?B?WHVlSDk0U3N4dlk3Sll0V0x5VTZ2YkhZOUVjeU41NWtUdkVGaXE5TVErOFRV?=
 =?utf-8?B?aVNqZWVzcEY2MXJtMC9qMEZGN05sQzdXTGx6VDVaeGdER2xhcVlIdzNtaHdO?=
 =?utf-8?B?UGl4UVFBVHdoUENsdDluZ1JtWVE2Q21uTGRPNGUvdC9ZTGRrallJSjhZTVVY?=
 =?utf-8?B?S1RxL1lESCtuMGtTSUU2QmgvajJwMXRVaklxNnRFL0ZmeFQzcHczNmFZWFNQ?=
 =?utf-8?B?bzhjcUhEeWdidGRKcTZjVnhjd2k3L3Z6aEluZ3NLRFNOQzlkcndLU0krWUYw?=
 =?utf-8?B?bmhRS1NGVlJ1NG15NGtlK2lyY2djSWpGakFQUThNeWl3TjI1MUhKT1BiWGc4?=
 =?utf-8?B?WndZLzAxTU9RQytvU3Vsd0YvcHVoOUgrUXMzdHlGb0dQVmVGQTNaTEl6bS9H?=
 =?utf-8?B?eko2a1dxYlUzYlpzUUtSbXpUQXFPd1VYcDdRMmdPa25XVVZENWZ2a0ZiL2Zz?=
 =?utf-8?B?bURRWFdyaXh5ODRUY1ZyOFdRZSsvZHJ1a0YzTmI2TC9mKytUK1ZvT05sTndw?=
 =?utf-8?B?R0FyV3J0ZitTdlhTQVRWOUl5eFZ4U1pUNU5ZdjFCZDRyaGhlbWxMV3N1czE0?=
 =?utf-8?B?dWpnS2YwSENtL3pEdkRVTll5djl6WjhiZG9BZXk5amNjMGs0cG5jMmNtZjlN?=
 =?utf-8?B?ekxrUHlKWE8rMWE0aUIyMFI3RS82bnEwbE9OeXh6M21UQ3lEREc2RUlCSy9w?=
 =?utf-8?B?cnd3cUx0WHRneU9ycWc3eDF0TVo3N2VtUmtqUVJLN2RHYkp6L1daM0FxRjBH?=
 =?utf-8?B?dUNNQzIybDM5S0RlREpWbzZicStZa01kN0t1aEJSL0hhM1lHSUplZmtWYStY?=
 =?utf-8?B?MkZPblVmUlgxZkNWK21OVXZWZUJCWGlUOFo3WlVqSHpXblZuL1cwQmlhckNu?=
 =?utf-8?B?Q2FtaVVJcUo0d2pIcE02TkdYVHZNWld0bnFhL1ZGOXVyVDNud1lsTzJUaHFC?=
 =?utf-8?B?THN3S2U0cFZUdlVkdThLQjN5NFBHYVVjL1crRkpHdUs2Z2pPYnMwNmYwQUE4?=
 =?utf-8?B?aTB1SGw1RExQQ1UxalNzcjJJbEx4UHlqTnhTWHNkUXB6ZU9WaWlvc2wrTllu?=
 =?utf-8?B?UThXUEErbTRwcFRBaTQ4dGEwbVp3VkoxQ2U0am15MUFzT0VUOXMzSThyNkJF?=
 =?utf-8?B?YXJnRjF4c1F4MHdRU28xOGpMQkQ1MC9RWkNkUUcrd0MzYW1GOElhMm5NS1pz?=
 =?utf-8?B?V2ZYNUhaTElXTzZIcnlnWnFndUJMeVFUNHN1V1lYU1o1bXFjc3Nvd0RpV0xO?=
 =?utf-8?B?eGVWd0k5eG1qc3QrQUl0ZTh6YjYvdVNNVmU3OTZGNnRhM0k1bGVrbTZiU2Vm?=
 =?utf-8?B?SUI5YW4raXFIR3pnSDdoNDBUenVlbmg5b1Yrd2g1QndBb2lDSFdRVzd3cUJt?=
 =?utf-8?B?d0VhZFF2RFJCdmYzWU13dlZSOXlIVWZqTk5xYTlEYWdZQ2Fnb2pJb2pxMUl6?=
 =?utf-8?B?SW1JV2pCMGsvNlBkN3k5cGZTSXU0SURPbWp3b0lSTG5SVUxGYVJ1b0FmbWdY?=
 =?utf-8?B?R1liOEpXOGp0M05YUTVOUGpwMGpBYzZxRjBsK1dhVzhxZGJjekpoa3drd3Bw?=
 =?utf-8?B?NEtIRURVeUZYaEZjZzFGa05wTmdWbE9sR2E1a3VzQlgzNUtTNytZWUZTcE1E?=
 =?utf-8?B?R3owSlNqR0FjV1d5aXo2amZ0RC9QUXhnNDFOV2tQa3RqRVlsQ0djN3NwUGJF?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e03279-de51-4bfc-5a0b-08d9ece8f0fe
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 22:59:07.0498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vR0veIRgxqRBVnj1owWcFWHu9EDeZKj22HfIxW9UFAiGQP1P+LEf+qztN5+VPzs+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4231
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Iooq6kZYbUufrmpBwb4BlYctUHI9-9s1
X-Proofpoint-ORIG-GUID: Iooq6kZYbUufrmpBwb4BlYctUHI9-9s1
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_11,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0 mlxscore=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 priorityscore=1501 phishscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202100117
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/10/22 2:34 PM, Alexei Starovoitov wrote:
> On Thu, Feb 10, 2022 at 10:17 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 2/10/22 2:01 AM, Michal Suchánek wrote:
>>> Hello,
>>>
>>> On Mon, Jan 31, 2022 at 09:36:44AM -0800, Yonghong Song wrote:
>>>>
>>>>
>>>> On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
>>>>> Hi,
>>>>>
>>>>> We recently run into module load failure related to split BTF on openSUSE
>>>>> Tumbleweed[1], which I believe is something that may also happen on other
>>>>> rolling distros.
>>>>>
>>>>> The error looks like the follow (though failure is not limited to ipheth)
>>>>>
>>>>>        BPF:[103111] STRUCT BPF:size=152 vlen=2 BPF: BPF:Invalid name BPF:
>>>>>
>>>>>        failed to validate module [ipheth] BTF: -22
>>>>>
>>>>> The error comes down to trying to load BTF of *kernel modules from a
>>>>> different build* than the runtime kernel (but the source is the same), where
>>>>> the base BTF of the two build is different.
>>>>>
>>>>> While it may be too far stretched to call this a bug, solving this might
>>>>> make BTF adoption easier. I'd natively think that we could further split
>>>>> base BTF into two part to avoid this issue, where .BTF only contain exported
>>>>> types, and the other (still residing in vmlinux) holds the unexported types.
>>>>
>>>> What is the exported types? The types used by export symbols?
>>>> This for sure will increase btf handling complexity.
>>>
>>> And it will not actually help.
>>>
>>> We have modversion ABI which checks the checksum of the symbols that the
>>> module imports and fails the load if the checksum for these symbols does
>>> not match. It's not concerned with symbols not exported, it's not
>>> concerned with symbols not used by the module. This is something that is
>>> sustainable across kernel rebuilds with minor fixes/features and what
>>> distributions watch for.
>>>
>>> Now with BTF the situation is vastly different. There are at least three
>>> bugs:
>>>
>>>    - The BTF check is global for all symbols, not for the symbols the
>>>      module uses. This is not sustainable. Given the BTF is supposed to
>>>      allow linking BPF programs that were built in completely different
>>>      environment with the kernel it is completely within the scope of BTF
>>>      to solve this problem, it's just neglected.
>>>    - It is possible to load modules with no BTF but not modules with
>>>      non-matching BTF. Surely the non-matching BTF could be discarded.
>>>    - BTF is part of vermagic. This is completely pointless since modules
>>>      without BTF can be loaded on BTF kernel. Surely it would not be too
>>>      difficult to do the reverse as well. Given BTF must pass extra check
>>>      to be used having it in vermagic is just useless moise.
>>>
>>>>> Does that sound like something reasonable to work on?
>>>>>
>>>>>
>>>>> ## Root case (in case anyone is interested in a verbose version)
>>>>>
>>>>> On openSUSE Tumbleweed there can be several builds of the same source. Since
>>>>> the source is the same, the binaries are simply replaced when a package with
>>>>> a larger build number is installed during upgrade.
>>>>>
>>>>> In our case, a rebuild is triggered[2], and resulted in changes in base BTF.
>>>>> More precisely, the BTF_KIND_FUNC{,_PROTO} of i2c_smbus_check_pec(u8 cpec,
>>>>> struct i2c_msg *msg) and inet_lhash2_bucket_sk(struct inet_hashinfo *h,
>>>>> struct sock *sk) was added to the base BTF of 5.15.12-1.3. Those functions
>>>>> are previously missing in base BTF of 5.15.12-1.1.
>>>>
>>>> As stated in [2] below, I think we should understand why rebuild is
>>>> triggered. If the rebuild for vmlinux is triggered, why the modules cannot
>>>> be rebuild at the same time?
>>>
>>> They do get rebuilt. However, if you are running the kernel and install
>>> the update you get the new modules with the old kernel. If the install
>>> script fails to copy the kernel to your EFI partition based on the fact
>>> a kernel with the same filename is alreasy there you get the same.
>>>
>>> If you have 'stable' distribution adding new symbols is normal and it
>>> does not break module loading without BTF but it breaks BTF.
>>
>> Okay, I see. One possible solution is that if kernel module btf
>> does not match vmlinux btf, the kernel module btf will be ignored
>> with a dmesg warning but kernel module load will proceed as normal.
>> I think this might be also useful for bpf lskel kernel modules as
>> well which tries to be portable (with CO-RE) for different kernels.
> 
> That sounds like #2 that Michal is proposing:
> "It is possible to load modules with no BTF but not modules with
>   non-matching BTF. Surely the non-matching BTF could be discarded."
> 
> That's probably the simplest way forward.
> 
> The patch
> https://patchwork.kernel.org/project/netdevbpf/patch/20220209052141.140063-1-connoro@google.com/
> shouldn't be necessary too.

Right the patch tried to address this issue and if we allow
non-matching BTF is ignored and then treaking DEBUG_INFO_BTF_MODULES
is not necessary.
