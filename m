Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645E852DDBF
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 21:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244459AbiESTXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 15:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241726AbiESTXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 15:23:06 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DA354F99;
        Thu, 19 May 2022 12:23:05 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24JFGAMU007916;
        Thu, 19 May 2022 12:22:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=OCuP9AJFWibYyS4g5LXxl9JwFI24fVP4FXZew0h1idk=;
 b=i78oqq9BbfxCc52syQ8EsMOL0p+EIXXqPKLkk7jrFdIW88iBS7lrL24yroHKTbsgXew2
 39Iyh6kfH922LTnCSA63O7bqvWlRC1VhPhJtVh4F7SvBbxrczqwfplwblMg0F/PRwPwX
 pA6djil6+Iahb76yNDOA93pjhAFY/HQWAhY= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2046.outbound.protection.outlook.com [104.47.74.46])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g5pj4tsg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 12:22:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vw9Fsz93dbnDd5sQamBh90XjYzmWuk0XVhL1jEKtmaZnmR7oixQTv8LPRSf0c3pgzRjA4ybTQAjyNoCIG9njLgzXlxoyt2tGk8R7vajTcrD1z2IRn+XPO0ZD2mHDTfPeQBogoc3ynVI8uqXecQ20xrJL7HMN6y68IgaIvnQfOdPbn1ZkN3wlEm12LtaQTLdYKVegAPeNCF3kQ3usLj5oINDmKEzICoQX1sGvbD8Ysw5g/N0XNOc5if5SNhwVbxVn72YwG/Vm1sMjP1fUyY7nFaZLSLXYsoDTtxhwx1u46fWhWmFZEe1pWFQv7iYK1BhhARW7ZSYXkovRYy16pHEaLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OCuP9AJFWibYyS4g5LXxl9JwFI24fVP4FXZew0h1idk=;
 b=Jf8AAVFPqD0A65Y2RkRPHXY2P1V30nOA6Z8bZQjaORvbeGkBN6ectgVF33RlLnxZFcsnHSxaNmwKuv1tUBmcqmen7CGCpf6ilVwsiWfJyScAy80Xp65YRA5hLCGvJ4zpe2wI+y+rpfCYCSLznbqz4XiEMP76Mq3ekVKftcSNk0g7icLKkInS7TFGchCFNDY6UGEzIbQKGMrgUV1Op1oMyi1KZXGypGB+jqCtUzSRVbUTkrJ/AOQiz9tZiLXPOSYo0yyTrjmtMYlY+NCcc4y3F0wV01oUErSwwKscrLf8rwfQ++gIJ6i6aG949a4UxILWMuWoDJeez2qjm0GogSCmEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BL1PR15MB5338.namprd15.prod.outlook.com (2603:10b6:208:385::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Thu, 19 May
 2022 19:22:45 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.015; Thu, 19 May 2022
 19:22:45 +0000
Message-ID: <333c515e-8b52-0e50-c5d2-529f5fcf0553@fb.com>
Date:   Thu, 19 May 2022 12:22:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf v4 1/3] bpf_trace: check size for overflow in
 bpf_kprobe_multi_link_attach
Content-Language: en-US
To:     Eugene Syromiatnikov <esyr@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
References: <cover.1652982525.git.esyr@redhat.com>
 <399e634781822329e856103cddba975f58f0498c.1652982525.git.esyr@redhat.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <399e634781822329e856103cddba975f58f0498c.1652982525.git.esyr@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR03CA0091.namprd03.prod.outlook.com
 (2603:10b6:a03:333::6) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bf9b879-2448-4bd1-05f7-08da39ccf3d4
X-MS-TrafficTypeDiagnostic: BL1PR15MB5338:EE_
X-Microsoft-Antispam-PRVS: <BL1PR15MB533860BF579EF400B10A8ACBD3D09@BL1PR15MB5338.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +uFQ/ZutKvljpDV7f2V1C0Bv4/J9qg4GIaIdFelW9nIKwGZcOMOnHW6bMAOzN9dLi1sZRi/kq+O7byrIoHn5MSkUZWarWP+uUPFlJXfs232AZxeEBoFtwTWKrWztMzduUF4y4apjxu0aQCdTgnWM6CQQppRdiSS+W9tc4F15T79IH2c6YWiBU0/RlyNbZCGFUKjMMXoen/XVV853ItmgSqKkFKF5Uz7UNbyvd84lfCFbCdUoO1rOdBconJPME0VJ6CzjQHYocsKbJp0s0IFHrh84uJnYm84YsZ85Mkh+i4MP4EQkbZUftCKckOYE3CdRGowF2Y08A71fZ4G6MLN0lk6+GEX5866adzZf5LbBucomxlX+USYR16yYB78qhTkFUXIFUGUdPTNCoq/baAuDM3/lyj4JmsTXD/3f8OsJm2Vc4RepEkNkDGQcx541/5ezzJ1pi9VZ//7IeXBPeU7yP8iVcb+PVyZt8wdjGSHJeDiekvkL7PB6bTWo8+1OXkXHwrQUUPaov24MxRrlcgCJt+SNpyZfJL0DNdiYE1HFBQLffbORjzfL8gQ9mJW5iMFxEAUfO9WMVcK6+XY7g2yCOR0a5cFVTPtMUjyBhfHpWw/QeSUX99/rhJC97C4/jm6cGZv+raHTcAi856kmYDuAlc21FDwtK15jimuvTThageJOxcAKPdvtUL6mmyrCxLgHMeNlKpae5VRWtsWqOHYR9sh4gwjU1ukRPlymYs+mKxICdTVQdRrbBE7V7Y69WSrsQfvSTZlbl2Zc8gJvnCOQPTpXtvS+v8vT3Y962kCkeqz9NuXoJmp1pkRTYkGPalnw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(2906002)(38100700002)(31696002)(86362001)(966005)(6486002)(54906003)(110136005)(5660300002)(4744005)(7416002)(316002)(8936002)(83380400001)(6512007)(36756003)(66476007)(66556008)(31686004)(6506007)(8676002)(2616005)(53546011)(52116002)(186003)(6666004)(4326008)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bko4QUZzVVlOb3Bpb2hVRUlCalJncnlrR1dBUFF5RHVOT1BNSHY5STlxL2lq?=
 =?utf-8?B?dUJzeHJKRWNxUGtkZURnTDJLVUZDTm1oWkZsV2g3d3Y2UXNVWk9UZ0pzbFNt?=
 =?utf-8?B?WmMvb29TcDl3dGVkZnRieTlFeCs3bUE2WnphNFNpVnZyY01BTWJueUtPUjBp?=
 =?utf-8?B?WHF4SEZNRWNwK1FIblBGWDBGUnNRL1ZoUkIzdVpmQ2dNRXk1VmUwU2cxZ1hv?=
 =?utf-8?B?TjBQZU9Fc3lndjhhMVIydk1QYnp1SHZ6VGY2NXB6M3FSRVU2b2lXb3dJcW4y?=
 =?utf-8?B?bXA1T1NzMUsvNW4xd3NKeitFdEIyLzZPaENLWUN0SlovenZYUVN3aVZZbTV5?=
 =?utf-8?B?cEdUSU02LzdJL2w0UkxDMnZONmVQcTVSMmhVM2lyRVpBZnh1eVd4bUxlajBz?=
 =?utf-8?B?c3haSUY0bXl5Y3hReSs5eDBXZzVGK01tNXZzTlA2Vkl0dnJTcTZRTHF5VXVn?=
 =?utf-8?B?VWhnV3psTlhJRlFFalNwWUpaUDRxeXphY0VuS1lsQStyT2ducTQ3VEVFeHVC?=
 =?utf-8?B?SXpWYUhRT0lTRzJhaml1UTBwWWYybUpHY3F1ZVd4V1hwM3NUSEEyT0JrYis1?=
 =?utf-8?B?Y2JBUzFobFFHQ0xJeHg2bTY5Qzc1eFZPWldaU0lwYnNtNmtlVEt2aGhZNEZS?=
 =?utf-8?B?dEV5Ym5VSS9tc1YxZG1Vc2x3ZVRNbitkZHIvTmFnTU93ZzV3NmJ6YzA3N3lL?=
 =?utf-8?B?aTMyYmo4ZTBLUFpjcWJhZkpsZmd1ZWNKTTBUTSs2OXdHRktuS2I5dHJZd2Fx?=
 =?utf-8?B?ckNpdDUwaGY2K0lMOXNQMDBtaXdDTkZsRDhLNHRuUVJxeGdwYW9jSXQralhL?=
 =?utf-8?B?RERkeW84S203Sm1hb2t4WTlOSU5EdXJhVy9xVUpmMERwNUpWRWZreUJGS2VI?=
 =?utf-8?B?WVdiWVYwQjB0V1ViYVJDN3BOU29YZzZEQXJMUzZDbG00NkZnWGQwRTJLVzBR?=
 =?utf-8?B?Zm4yWjZxbmI5TVJLUGw3bXRSc1JUUTJsWWpLR0NMclRuNXBpeWNXOHA0YTZa?=
 =?utf-8?B?dGNncTRCNmN4THBZRXNOc2srZVNmTW9CL3ByNmpTMmFyL0paaFVkZHl3dlYx?=
 =?utf-8?B?VkdqbUYxQlF2QTkrZzBQMy9mQm1hc1FmZ2ZBMGVDMmFmTUVlaERDb1RYMEkx?=
 =?utf-8?B?MEJzSU1WeWpMWmpmbFJlalRxK1dOUlRlb05aVHFta2ZQOHgxKzVwRGdiWFV6?=
 =?utf-8?B?K0o1cXp4YTlpNHM2V2tpY1hkSWhTb2t0SnUvZzlObnZXdll4TmdFcThHZit6?=
 =?utf-8?B?M2JuOTBpR2hid0U0V0JKOXBSOGZPM2UrUGlCWU9ZM1RoWGRqTDAxVzhtMEFu?=
 =?utf-8?B?aEt4d0V5d1dGenZtNjJ1L2F4WHBaRFBFZGFySVYvOUREV1FvTHNOVzg3eXhp?=
 =?utf-8?B?Y0FHUDlYUWVyUTVPWXkrWmpMelpiRWlHYVpNdk5OUWdqWVA1Yjd3SDRBZEc3?=
 =?utf-8?B?aC9sODNyV21IUEdvTzhBYUxNZVN0NVZ2SGNEL0NaemUrdUJvRGdYTUZqQkR2?=
 =?utf-8?B?RG5uT1kyOVBya0Z3N1VLWlNHZnBjNEFyb0hzUEtqV1dZOTlBN1FrZGRXWG1j?=
 =?utf-8?B?bHR3M0QzdHhDSkNGaU83VDRqd05XZ0VURXdKcGk3T20rUTNJT3JiUG5vVEhY?=
 =?utf-8?B?aWhQZk9zL0lEb2J6SXNUTFNJMVVldW15VTBFbVFWRFJjR1NaL1JVT3Bmb0tJ?=
 =?utf-8?B?cVZwMWZKZzN0TzQ0ZjRRN3IvWktuSTlMUW9aOXpJenpSZmFObllZcFpXS2lJ?=
 =?utf-8?B?VGFzamZ4ODdIay9GMXE2QjdaelNpUUtDeHZENHJzd2dsYjcxa2FtVTN4R2NQ?=
 =?utf-8?B?WW92ek5YUzY2T0YzR1RCeWErQWN1eXU1Ym1RYjgvWnZieGJtKzM0R3hmMGRo?=
 =?utf-8?B?Mm1NVmZIS0ZNYy96QTZTdGVrNEc2dkxicEtERHNPMkNGTzQ0bnlPWHlPQ1lO?=
 =?utf-8?B?LzdTb1V3dmJ6Yk9NMmUyUTV4LzdSKzR0U0lzdlRUT1BlMkR1dFZJV3VWS0c0?=
 =?utf-8?B?ek81UnpnMWtmemtPYXlJbWN5NmNBc0ZOdzVUeGZOeEdlL015OGh6eHNPeFBH?=
 =?utf-8?B?eDRBbXRPNVJnVFFISjBGNTdPV0VMZitDSGFFU1lrY0Vmc0RNbHN4aHlCalpQ?=
 =?utf-8?B?d3phTDhIUGo5cjRia2dJYUdSVXBVS3E5ZW1MQzdUd2RWSTRFVWhLMWZrV2Uz?=
 =?utf-8?B?ajQwQUNHZysveDFzWHg2dDZQc3p3Y3FHK0N1M2l6RkxjaFRucXlrRWZOK20w?=
 =?utf-8?B?ckE5Q2tFTUd6NDJLVXczby9Lb2ptcFNTditsRkxFNzlOemVBYWF1U282ZzRG?=
 =?utf-8?B?U2dZV2xrbnZZdHp4UnBicHhvNmxYdU9veXBvM3d3b0hhMUpKMFRwV1hZYXRw?=
 =?utf-8?Q?y6uKRZuzdNYLiI/0=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bf9b879-2448-4bd1-05f7-08da39ccf3d4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 19:22:45.4935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hRHCABzrC8SruhGtj9aybYf58S0Gc13gkGRf7Z54cesJLrEIC6JwEFRpiCh6OMUJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR15MB5338
X-Proofpoint-GUID: q4FCuXNh0vHxMHVF7w7BN5704gQguKjc
X-Proofpoint-ORIG-GUID: q4FCuXNh0vHxMHVF7w7BN5704gQguKjc
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-19_06,2022-05-19_03,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/22 11:14 AM, Eugene Syromiatnikov wrote:
> Check that size would not overflow before calculation (and return
> -EOVERFLOW if it will), to prevent potential out-of-bounds write
> with the following copy_from_user.  Add the same check
> to kprobe_multi_resolve_syms in case it will be called from elsewhere
> in the future.  The INT_MAX checks are performed in order to avoid
> triggering kvmalloc_node warning [1].
> 
> [1] https://lore.kernel.org/lkml/cfe6abea-8d00-8f8c-f84c-e6f27753b5d1@fb.com/
> 
> Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>

Acked-by: Yonghong Song <yhs@fb.com>
