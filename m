Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A5E4A7E84
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 04:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243149AbiBCD7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 22:59:53 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23940 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231361AbiBCD7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 22:59:52 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2131MiYB032033;
        Wed, 2 Feb 2022 19:59:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=zRJWigo+8yaBV6K69/4K7DQRmXOtR02S55DeJhllmww=;
 b=IcywoV9wNlE+OyAcwqk+MayG2qIi8dk6G4WCIPBq0NuTZaYjPG8j/FbRth64+4pylepi
 XiKx7xPsERqNwpmrk/dvidPaIWRtrgVTqKNTI0uK7PIoS0IF4FzbihdzDPE88YjnXBs8
 /ucqOJCrIlW+7j5vuFJftUp1f/hi2A1GVPo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e01kn21mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 02 Feb 2022 19:59:27 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Feb 2022 19:59:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/P78YlzodCw6Zb9MHAqZQfZQSoJYs2pNrtGKobsb6LfejGJ9SDEetyZc+w5nvE6yM0YMTDwVZzJySPpR0vax6YdYdeNeyIoTbIa+gXrB4hlOzpQHQKuQ5sugHec3vbQtOcq6CjYTRytRM0eNRICVy5AJj8MOaLDVVs9neNv9JcaW0CTV4GH6jGZ3Z3S3rUe+G0jwLXb5Ig6jgI8tApjgekb0pwbCxEQne9beMToRe1n2LDao3Ah8JkCsPcAJT3BkH+J/bYiOJd/N2bLzWb0mDF38e4J/qFbD9BPs3m8NPS2Tu+qdhimpKMll7sduMa6wuuGl0YizRJLA0abrKLFEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zemQs/jX4QaX73mB/34lQTKZNVeaNHtuYM/3dTJTIKk=;
 b=kgtJwDg/QofBEMTJKVbtYgtdXYeRBYHclvbnlELuQ1C9xQnZDX7sW+/Kk2+TuOnGJI6AF4P8CnPN4aSBT8gdF7yU+TiR2irRmqLs7OyeKpKQtDb7hj6yQUuhxwv9eWKv4Nm9bJCiMUXtpTxwLkz1nfKWQPhwOMttb6Lb6cq0aKUZvYRL+jZbjo8q3jQC/4G1sRmGcKQriLHSrGSfOuquna6wxqiRi3Yg2zVxdRbCIX491SHDe+qyno7eXeDiTJvtSFs/zLZCxF0JQsxqtGD45BNnlWboB5U/sZdE3LVlPlE3SdwwCcIUne4GmhueYA3mHR7Ani8C28ngQ0ZtwE/UnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM5PR1501MB2008.namprd15.prod.outlook.com (2603:10b6:4:a6::34) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.21; Thu, 3 Feb
 2022 03:59:17 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0%6]) with mapi id 15.20.4951.012; Thu, 3 Feb 2022
 03:59:17 +0000
Message-ID: <8968ee4f-988a-16cd-9bb0-e79096b4f809@fb.com>
Date:   Wed, 2 Feb 2022 19:59:13 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [syzbot] general protection fault in btf_decl_tag_resolve
Content-Language: en-US
To:     syzbot <syzbot+53619be9444215e785ed@syzkaller.appspotmail.com>,
        <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <kpsingh@kernel.org>, <linux-kernel@vger.kernel.org>,
        <llvm@lists.linux.dev>, <nathan@kernel.org>,
        <ndesaulniers@google.com>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>, <syzkaller-bugs@googlegroups.com>
References: <00000000000079a24b05d714d69f@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <00000000000079a24b05d714d69f@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-ClientProxiedBy: MW4PR03CA0171.namprd03.prod.outlook.com
 (2603:10b6:303:8d::26) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d58fceca-59ca-4c56-b9e1-08d9e6c98c7c
X-MS-TrafficTypeDiagnostic: DM5PR1501MB2008:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1501MB200835E8DA0C55AF6CD227D8D3289@DM5PR1501MB2008.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +0auaD8srYgXUepGTUEqMvqbQBzb05yvPfJlRuARK4y0GijCMwRIbtEWY0qnsTglovwaBZWcs73XJM3jIFzkfWaPUlkIqz9F5MHACoIijNYBmKMqhOhXX/Oq0oXLoHZPYfeWAEtZ7tkkPkscXmvqpH+fTRSXG210nsOvicvMIc3sP8lYaAzC3vSW9fmldPsn21pyIjQewQrzDu8cOsJyTqyimfPs7YcKXJ5fPFS6qXLqz0r5RSVW/i624IHd+R5UqRgAESU5GbAV492vB3MU/1JZ1ZO89+9ib2AT8ZswrU2lqVmZE4Uhre9OmqmHjUCEmgzADl2WkyOsgT56hoxIlIHTDR+yIYGeofGGyA0LkZf/Nv295diPFZyIuhPk/f3BLQroG5kOT9fYPv+gYI8VI32pQf7Zg5MK+N0jb+BluT/JXw34S28GSvoGcVDuFBFmvGXSm7BJGaUAeEbHSnUuN49j40R7ew0PDw5Kzw5CtYJMkwVBViz/Htinkt5jO5xbB7Irx3wgMXY0hASIeIrSg+YLOYkx061WmaRGANjyRVpKZCKpZ+bD2lglNkj2e0Bhg4qtebLy0Tql0nb7pvhTnq5uO3fxOz53XTNK27Tg6aecjO3yR9nV0ryTkOY7tSeegu/8piU5KRC1flfBEQSnA2ZK5khuP7B+BK6/peVFqxEfgvhaQcO8RcsZ/DLbMVxQVH3u+eXwAfVRTky8Ni2KrDi5pL7bIuPQtfx7TQQMvjJVV9NhYhXfVZyM6f05YgzKUTNmqJZyjO8jqGSz6RJPu3tgWZhntoSUrQB/K1w9SNxNso4TJUq0RfE9LMsll+e1G2/VuuQMaI6xNGaV5J27DycSGRoA0ILt08KTuD3fP5AsFXp6c5fcfS0/jZZPQ6P05B/0OLUuVKyMMgml7VwSig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(2906002)(2616005)(6666004)(31686004)(52116002)(53546011)(6486002)(966005)(6512007)(508600001)(45080400002)(5660300002)(6506007)(36756003)(186003)(86362001)(31696002)(66946007)(66556008)(38100700002)(66476007)(8676002)(8936002)(316002)(921005)(99710200001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHlrQ21RSXY5TmJhaW5DQ2JGb01CRmJPUnB0NmFkZEdBMk5uVDEzRnNMTmVB?=
 =?utf-8?B?VTdlSk5KbDMzeExGakVUVjFPb3RqbUxWU1d4SFRqVUhtV2hXSStod1MrK2xV?=
 =?utf-8?B?clBraWVsaHdmT0xER1k3V2V2WmIyNUpERm1YUksrTDRjNVREckR3YmFoWFdN?=
 =?utf-8?B?NVhKVzJRSVpWa0FaSkxpVXowU0dLcjdsL2NqelV0Nkx5WGVXRGppcDU2c0k4?=
 =?utf-8?B?TUtadlZQRW51RUNHQ1RPWXVaR2hTWGZKcCtDQWh6V2J6YXVXWlZVM2NGc2ZO?=
 =?utf-8?B?eGxTOHY5azNpRFVTU214SC9uK09aTGxVbWJmVi9idUYwREI5cVlTb0tYb1h6?=
 =?utf-8?B?a3JWZGlMWncvd1diK1NPbHEwUEgxYjQyQlhXOW1Rb1orQVMyY2RjUndFQVBI?=
 =?utf-8?B?QzZtRk1sbWhMRjhUeUhLVjkvQU1XVWNhVU1rSWJNOWhKUDZuYXpxQlVoKzlo?=
 =?utf-8?B?Ui9nMll3emVVYUtxMkJrMVFvRzhIcE9NdC9jdHlacUU5cXBxQy80eTIydGhk?=
 =?utf-8?B?d2NZUWdseThLYnE0MDVjUGZIVGpXT1pxTGtTUk5MSC9reVRQdjBvTHdpakFt?=
 =?utf-8?B?RkFqYzJVVUEyVG1Telo3aUplbStJRzJsOTRKRVJxUGlzeWY2aVdFdDR4ZXdW?=
 =?utf-8?B?R1J3c2puYkRrRDhScEhPWUVackpCdlhsc2RhZ2U0SHJTbTF0QzR2dEorYWJY?=
 =?utf-8?B?MVEwTytReE9pd1FuZ1FyR250bEl0c3hMZjBWZnlMT091RTNqaHg5ZmthS3JR?=
 =?utf-8?B?YVZ3dnZXV0V4b081RTVGeU9kbG9QKzEzb3lCSGJsTmN1ZFlrRStsN2YrK2FL?=
 =?utf-8?B?STh1ai9sSUlsSDZCSXBINm1TMjRkMmpqUktGbUIxSXVUYzB4YVQxRDBSK2Iz?=
 =?utf-8?B?cDNRc0ZzenBVTHd5K1Z3WGoraUVhNVF3eTBkN0ZrVVU1Qnc2VHNVd3RxNk9U?=
 =?utf-8?B?NGpubkgwdXFBUUxnamtHT1dHaUVOZVM5emVDaitFNjVLb1dDZzNoM2k3SGM0?=
 =?utf-8?B?dUFsU2s2K1V5QWxHeUQ1WElUcjhqMUdXQU9LdnVLWG1teEhtdDBRcUxrOXlY?=
 =?utf-8?B?N3o1OW1iSm8waXNKV2FoZ0l0amo1TjBHNU81elY3dm11VzdLZGhhSjNHL3Qy?=
 =?utf-8?B?d3l6VUd1QzhyZ2xwOFVlN0doY2VlbEZSbmRxanNqenFlV2NXOEVVRG9KMlUz?=
 =?utf-8?B?R2tKNnJ3WkpNdXUyVUpobmZhaU8yazVDM2s5VnE5WDA1OWdtc1o4QXh1S2lG?=
 =?utf-8?B?NXhhVE1KU3VNcXN2SmZaMWZ4VVdLVXY2Nkc4dDRMaGY2dXdBMnA3L3c3eldq?=
 =?utf-8?B?K0xSbFdneWI2Uit4RlRjOTVrZzhJM01OVU1TdVZROHdLNWhtTkhKRTBqRFBW?=
 =?utf-8?B?UWVZczB3OVJnbEJaYXp5UEJndkkreFZXekRwM01kSWo1TGZvQ2dVNlhGMEVF?=
 =?utf-8?B?UEVTMHIvWXJBSnFUeEZiMmE5MXFlK3pyK2xSbmxBNlovMzhVUnkzby92MGdS?=
 =?utf-8?B?aW9VQmVPVmVCV2hRRTllUk8vZXM2UDd2U0luY1Z1UzI1TlBvU2hQS0lqajdx?=
 =?utf-8?B?bUIrUXY1RklKL1RoamlvZlBkSWh6R2FPQ0dEdzZPRDB0QkkrZGE3TFpTSzFv?=
 =?utf-8?B?SUhIUjF5a25xUWdBWUIyblptaXNGR200RmJNSTB4OGVnN1k0akRzeTk0K1FY?=
 =?utf-8?B?YjlLYTIybEx4dGtwSGw4Y0F3WVJ1WTdETzhybFdGUEhQeWluU2ZSbkR1U3JS?=
 =?utf-8?B?WDZmUWwzeXVQZ2crUmdFRTVUM0hNbFUzWmpic2dWcnhFWEsrNDBlREVwMVY3?=
 =?utf-8?B?ejAzZXJBemZpeXcwWjZpMVcweDRGTEJSbFViS2hWWVdDaXoxcDB3N3MwMTNZ?=
 =?utf-8?B?NEY5aXJuN2N1NndYVE8vTjlwK285S2dhank5QzUvclhBdlVieUVlZURLTVQ4?=
 =?utf-8?B?Sm52bktUYUxaalJCV2FFa0p0ZkVxdXRsS0cvaFpaTzluMjVWd0YzMkxqWmZC?=
 =?utf-8?B?ck1TSWRiVFRHWW1CVnFOSHovaEJzdXJOWTNLVGgzajEyS0svbGFpSTBsMFZM?=
 =?utf-8?B?b3dtbFVOem1xdmJPc3pIbVd3MTV0K0dkdElPYzJIQlIrY2Z4Uk9EQTR1cnhU?=
 =?utf-8?Q?DcW/NUjUuudeuCtSeYa7NaavX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d58fceca-59ca-4c56-b9e1-08d9e6c98c7c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 03:59:17.0372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZmZKaQBFpbOd6Dwi2JjE6DFYxFc6n9pa/9S0xzbiqXQWlrJNxLj9jvpLvn2h2XGx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1501MB2008
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: d_DlHuj7RKhAeRL2Nq0amvGFLXXy3m2V
X-Proofpoint-ORIG-GUID: d_DlHuj7RKhAeRL2Nq0amvGFLXXy3m2V
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 8 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-02_11,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 spamscore=0 mlxlogscore=990 adultscore=0 clxscore=1011 impostorscore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030021
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/2/22 7:36 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b7892f7d5cb2 tools: Ignore errors from `which' when search..
> git tree:       bpf
> console output: https://syzkaller.appspot.com/x/log.txt?x=13181634700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5044676c290190f2
> dashboard link: https://syzkaller.appspot.com/bug?extid=53619be9444215e785ed
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16454914700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ceb884700000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+53619be9444215e785ed@syzkaller.appspotmail.com
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 PID: 3592 Comm: syz-executor914 Not tainted 5.16.0-syzkaller-11424-gb7892f7d5cb2 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:btf_type_vlen include/linux/btf.h:231 [inline]
> RIP: 0010:btf_decl_tag_resolve+0x83e/0xaa0 kernel/bpf/btf.c:3910
> Code: c1 ea 03 80 3c 02 00 0f 85 90 01 00 00 48 8b 1b e8 b7 c9 e6 ff 48 8d 7b 04 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 2b
> RSP: 0018:ffffc90001b1fa00 EFLAGS: 00010247
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff81918c09 RDI: 0000000000000004
> RBP: ffff888015c32000 R08: 0000000000000008 R09: 0000000000000008
> R10: ffffffff81918bb1 R11: 0000000000000001 R12: 0000000000000004
> R13: 0000000000000008 R14: 0000000000000000 R15: 0000000000000005
> FS:  00005555556fd300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f98c38b8220 CR3: 0000000019537000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <TASK>
>   btf_resolve+0x251/0x1020 kernel/bpf/btf.c:4198
>   btf_check_all_types kernel/bpf/btf.c:4239 [inline]
>   btf_parse_type_sec kernel/bpf/btf.c:4280 [inline]
>   btf_parse kernel/bpf/btf.c:4513 [inline]
>   btf_new_fd+0x19fe/0x2370 kernel/bpf/btf.c:6047
>   bpf_btf_load kernel/bpf/syscall.c:4039 [inline]
>   __sys_bpf+0x1cbb/0x5970 kernel/bpf/syscall.c:4679
>   __do_sys_bpf kernel/bpf/syscall.c:4738 [inline]
>   __se_sys_bpf kernel/bpf/syscall.c:4736 [inline]
>   __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4736
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fd57f202099
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe9e5eb898 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd57f202099
> RDX: 0000000000000020 RSI: 0000000020000000 RDI: 0000000000000012
> RBP: 00007fd57f1c6080 R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000ffffffff R11: 0000000000000246 R12: 00007fd57f1c6110
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>   </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:btf_type_vlen include/linux/btf.h:231 [inline]
> RIP: 0010:btf_decl_tag_resolve+0x83e/0xaa0 kernel/bpf/btf.c:3910
> Code: c1 ea 03 80 3c 02 00 0f 85 90 01 00 00 48 8b 1b e8 b7 c9 e6 ff 48 8d 7b 04 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 2b
> RSP: 0018:ffffc90001b1fa00 EFLAGS: 00010247
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff81918c09 RDI: 0000000000000004
> RBP: ffff888015c32000 R08: 0000000000000008 R09: 0000000000000008
> R10: ffffffff81918bb1 R11: 0000000000000001 R12: 0000000000000004
> R13: 0000000000000008 R14: 0000000000000000 R15: 0000000000000005
> FS:  00005555556fd300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000000 CR3: 0000000019537000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess):
>     0:	c1 ea 03             	shr    $0x3,%edx
>     3:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
>     7:	0f 85 90 01 00 00    	jne    0x19d
>     d:	48 8b 1b             	mov    (%rbx),%rbx
>    10:	e8 b7 c9 e6 ff       	callq  0xffe6c9cc
>    15:	48 8d 7b 04          	lea    0x4(%rbx),%rdi
>    19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
>    20:	fc ff df
>    23:	48 89 fa             	mov    %rdi,%rdx
>    26:	48 c1 ea 03          	shr    $0x3,%rdx
> * 2a:	0f b6 14 02          	movzbl (%rdx,%rax,1),%edx <-- trapping instruction
>    2e:	48 89 f8             	mov    %rdi,%rax
>    31:	83 e0 07             	and    $0x7,%eax
>    34:	83 c0 03             	add    $0x3,%eax
>    37:	38 d0                	cmp    %dl,%al
>    39:	7c 08                	jl     0x43
>    3b:	84 d2                	test   %dl,%dl
>    3d:	0f                   	.byte 0xf
>    3e:	85 2b                	test   %ebp,(%rbx)
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ  for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status  for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

Thanks for reporting. I am looking at this now.
