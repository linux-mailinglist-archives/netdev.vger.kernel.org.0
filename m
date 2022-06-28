Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAFE55D02B
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244492AbiF1GNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 02:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245548AbiF1GMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 02:12:36 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03622610A;
        Mon, 27 Jun 2022 23:12:35 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RJ1RHl004976;
        Mon, 27 Jun 2022 23:12:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=9FLlWCroOJLCiBuUFLOKEZapYDLZK7Fs0eCw0G1GhzQ=;
 b=qsLBGWBpWfJPg64cMbSUQGazFcmdP39ZwRB+9vqR4B9h8slosCevYRElQ/7EMCXyYLEm
 8QWfK+9e2GAcmmvltFNrb1j/hraROfAK3e0mnzTDu3In0WtwFL6BbqTF98n8dhgMuo9M
 YL3IO5tMJlBdjXUwKO6nmjbX0jCLL/jbeT8= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gx03yymey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 23:12:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TgSzHesTYEbD/ArBlX8VKcoE/SW/U8UmULnFDa7SxT92Lgy+ytvO0yFoASoNMHtZxgiaeddhRwH4W0CNenFMNofv6ytfvE1ns9E8c51yaCbP/my/R16mvDJ3gjLsRph8mWnOE9RBjShQoBVnzMzNE1fOAQtAoAoi0oAagrBtTajN2WaT1TUu6W+x2D3kguRjStK7PJLfOEwKAkvKcYHzkNL8GQr1oP4+MSiwNi09fvy/jms4aggJZ5FTdUY8c2TfsViVKv6P/rQ5Vc4wUiBGJDmmRdiF+mUcx4vgC3ch1NbkBwQdsTuBaZDXa24nRRAFYShhiHs3fiwg5UsFLlqb6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9FLlWCroOJLCiBuUFLOKEZapYDLZK7Fs0eCw0G1GhzQ=;
 b=XhtefBYlMB1kz1hbnn/667+oHKMNsD4zW9iHaVmXi+srZPjj3AoFNtfQ9nLzrR6dBz4j2ROxa6+EJ2nyHI3FPSipiPd7nc2Y9the2xWwjNlCr2IE0bdzMAdiqu7MuzhT3NitY1uFTMEj1asAMmZTv21hQdQrh/34tJZSPTE/4RrjNvl2bKj56s7SXuFSLDk+lVo9UzTz4MzUNePl11laoZkFa+wYNcm8wRQfNGlawgxp0PqiTVgYA8gzUBup/YvsSebJO15mz6+4kBp7WnMSVfE15XgoceTOP4y1HyI1969IQ+e6DfbbQGWn/pV11LMygJWb0VEkZGr0qnbk0HJm1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BYAPR15MB2534.namprd15.prod.outlook.com (2603:10b6:a03:152::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 06:12:15 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 06:12:15 +0000
Message-ID: <1c1fb651-cc69-4b5c-1b68-8f29908794bc@fb.com>
Date:   Mon, 27 Jun 2022 23:12:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH bpf-next v2 6/8] cgroup: bpf: enable bpf programs to
 integrate with rstat
Content-Language: en-US
To:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>
Cc:     Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-7-yosryahmed@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220610194435.2268290-7-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0183.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::8) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d5fd4b0-01dd-45eb-4276-08da58cd25f0
X-MS-TrafficTypeDiagnostic: BYAPR15MB2534:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 62afsHaf02LyqhK4abY2fJ6uAkrysVToSpGyNnNbs5hZf/UIl7IsftxIgUGG4+0yMEpaYmwitam9gCIjdDChBQY0yCI5SftlQSWWk7xxalPVgjiuPr0R7btfkR4pzPiawMAgPWT58WCGidMc4mL5lPO8zdeSs7854t3LgrQGYAqo5LYrPtT4Bz88bvsV4YbeNxDxmQbx4QJ96Cj+S6K2O28+gf5ZWwB1qDuZwsmSQF9iPa309t/awS3O39SQDV0N6ZsGLgcvyzez8wNhnk+HhS9VEqpPBgqGhl7Al9iW0NGGMZa2+H1KbmoKwJFh6xiqJq9Z5PSBplDcL0Q28OKS5KL/Avh119ZWNDmExwzeJ3FmV4MRe6eXpA4APQq1qAKsnJctivHx8uCSZDIe1aVmrdyT9nRi56tPfFheppO+4DiNnppmN4c8RpvPf3Zgn31f0iFabwYU5wTuSYkUgnCP4/LOeK0IPdlqAL2i9AqfJVP4fYuRLcKtQ0hJfVGGgQVSMdrOYQDCe8C3e+ItRuyMoFtIwzsba3TterCviKk/vLB+ItRk33uru7bXrYLoYMkLO7PtPN+UQ1/adMSZkLxM7uva0EVegagN+OxcaFIwMbrwlLE0TqeVAoDZQf+uK6j5LLpKW1nkr42gUkDICrpclfjrtA5L1Pd12o8X+ekm2A69F586kZpgxYKc4xOFehHlxFgEiB1+De5j0GMDj7ckxgr7g7QvA5RTRPsThL4c07YT2TyOIoEq6KFZRStb9xoKdexhA5rCqusiUfsR37uIwFcJgvwze71AeitdF/GWWGDcCkNszcSi0vQKmD4DtRgJU9f6zUAme6m0lEOk/s0+lmy2r71u2952hLmmH+SUtQ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(2906002)(478600001)(83380400001)(2616005)(7416002)(5660300002)(41300700001)(4744005)(6512007)(53546011)(31696002)(86362001)(921005)(6506007)(36756003)(38100700002)(6486002)(110136005)(6666004)(66476007)(31686004)(54906003)(186003)(8936002)(8676002)(316002)(4326008)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmNaYW1Rbm1uYWJhTjBpMzJCUUtSNG1jZ0h5SmMrbVZvNS9xYnBiMExjeFls?=
 =?utf-8?B?QXNnUUxvbnM1VWRmTDUxZzZER1k0YTFIb2lMWHBOS2NpZDBsUGRCbG1Vb1pH?=
 =?utf-8?B?VlVLVTRDenA2cjlzc0QyQ2Z0VVpwM3ZBa1pVSjJQMU5FcVcweWNBNUR3T1hL?=
 =?utf-8?B?ZlpyRmdmcXVBSG9qL25aMGNCNEw5SlZNV3BOT01IdllNTTgvRFI1bVVGb2tw?=
 =?utf-8?B?eE1JRXVLT2IzZlY3MWZjM3IzdzdFZ3VCMDV0Z25uVGJ2SHBZWkE4YVZKSmx2?=
 =?utf-8?B?OHdONHhBNUlLWkVQVm9SR0ZmbDJiWE1TSzNsdU9Oc3hjc3RwYjNXU21RZEtW?=
 =?utf-8?B?UmFid0ZBdVBheDAya0kyY3NnMDdSTXhTQnIzNEZaRU1qd1pScjA3dkRIQUhp?=
 =?utf-8?B?eVpucGpNaHU2ajl5N0VhWWVIZmI5ZHU5aWZLRG9oMkpnalNrdVYrdW1rOGxY?=
 =?utf-8?B?d2FNMktCK1N0dVo2YjdqMU1wTXRxVTNxMGNLci9ZcVdHWEQyMVFXaEJDd3Y2?=
 =?utf-8?B?cnY0ZGdnOCs1Yzd4a1R2UytKcUZKMjlwYWVyVjk2K3JNYWlGZFFFbVBob25M?=
 =?utf-8?B?cnp1VFpiaG9DaVl0VTRkTzZPR0dXdkV5cUhjYUxvMEZ1LzVneHFvbVdFRVpO?=
 =?utf-8?B?eVhuWTdDdlYyVlFObUhWRC9JMFMyc1hPdm1LaGIzL2NVaDlXQ0JXMzQyamRw?=
 =?utf-8?B?U21PNDhLQjJ2MnlPTlowRzB0UERzZGpFd1pwQkM0WU1WNkN3aktZZXFMczY4?=
 =?utf-8?B?T093blFBSncyVS9hUEVraWNYNEdlL3dtU3FGOFJ5SFJZY25tK1NWYlV0TUVB?=
 =?utf-8?B?NVB2eFl4Q0NrcHF6Mm5FWUx0OHI4UGN6SWkrTXE5S1dkdFczblJxQ3pGRzAr?=
 =?utf-8?B?QW5qOHJzTk1Camt3SDdKL282Qi91MS9ZVU5qQ00zWnpHcDhpVlJzMXpUdFk5?=
 =?utf-8?B?OW96cG9RL0UyUmt6UzBCRVczWkt3SGFLaFd3bEVTY0NGU2F3eGJRUmdSVmJq?=
 =?utf-8?B?NjFSN2hBNjBSYUFHWTlsRFdxU0pFU2xydFBWUXZ2Y3VJbEM2UjJYMDBWOVN6?=
 =?utf-8?B?bXg4R1JqdmFoalo5V0NVcVcvUmhyUGQ1bzNuRnppeEgvS0I5YVIzaWozMkls?=
 =?utf-8?B?cXJKRmpkaWtBNlo4bUpaUlpBVXFpb0JydmF5cStqZ1dYTmRRSkI1U01aZGF2?=
 =?utf-8?B?VUJEaXkrN2RTSVRxQ1U0Mk05dmEvL09VTHRzTTFxa1U2UGJVRTdzTEt6bW9o?=
 =?utf-8?B?QmR2QlV1cjZ4ZUk4cHAxLzh4N0ludE00ZHZTaUh0RmNQaXhVckVFd3J5SVUx?=
 =?utf-8?B?L1djOUphR2lmQ0pFaDhUaHhJQ2ZKRDliVU44aWMxend3bU9NTlpTcStkRUti?=
 =?utf-8?B?VFVQUFIvSHNLTmxsbERHS0FucEdwNzZaNHZPejA5ZzluNFhHcTIrZ2Npc1Er?=
 =?utf-8?B?ampiV2dlczdtNit2dHk0Zk1lZVIzOWFKOUNYWGVtY1c3Sm1mK1lUVjVpOGh0?=
 =?utf-8?B?c1h5ZVVmYUN6dDJhUmJVbkVRM0VsQjRrOUZSSnBsTWFNcTM4ejhpTFB5b0pZ?=
 =?utf-8?B?OTBod0tmMEcyQ2MwRW5sbytaZHZZOURlTVQybS9oVE4va0htOFd0aFc3dkpj?=
 =?utf-8?B?Zm9sWkwyT05XbHhIUGRXTStERUthNDJ6Uy9JcVVZWDFXRFNmQXFPWkFKVFln?=
 =?utf-8?B?MzkxTTczbmp2YXNiWjh5OVRpNnAydUFUNU5LaExqQyt0V3FFOEh1ZHNqdVBS?=
 =?utf-8?B?THRENFRsL28wTUdMckptOENkNHd0ZitPOXhrL1R1WjZ0blYrL2NzQi9lNDRu?=
 =?utf-8?B?UVlhNTN6VUlraWFiVjBpSVBoYjAyZlc4QnhSbUUyMEs3VG1jaEpmbUZTT0dk?=
 =?utf-8?B?Wjduc3JWNGlWTW5nK25JU2VzOFg0Rnk4bkxDQ05pcGcySkVOODU3YytpSXlF?=
 =?utf-8?B?VHNzOXhlczR0bjVtNnNsckNwUC9PNW9zK0ZaMU5YSXpWTi8xczRqZnpyTVp3?=
 =?utf-8?B?TGpGa3RJWVJLWDExcksvaGFqRXJHWkVXSC9PL1Y1QmR2aC9DU011US9tMk96?=
 =?utf-8?B?ZHNMQkhnbzg3S0Yyd2RPK2pwb1k1b1doK3pyTmFSQXlxb2NZWnN5T1Jjd1dH?=
 =?utf-8?B?Mk51S3pFMFBxQnJUV3R0RktNbGpOWVhPUzJQckkzRTF4VVRqUnJwY2hDSmJC?=
 =?utf-8?B?ZVE9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d5fd4b0-01dd-45eb-4276-08da58cd25f0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 06:12:15.6107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wVGRAZ0JSgIqJALOONSSUwCG4trp6zTSf7ajbjMWP5qWlsCQTyoAZar3YHaN1JRy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2534
X-Proofpoint-GUID: q_IkH8N3qWMaWPMsjRXR2HJ1Xnu-vm-V
X-Proofpoint-ORIG-GUID: q_IkH8N3qWMaWPMsjRXR2HJ1Xnu-vm-V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_09,2022-06-24_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/10/22 12:44 PM, Yosry Ahmed wrote:
> Enable bpf programs to make use of rstat to collect cgroup hierarchical
> stats efficiently:
> - Add cgroup_rstat_updated() kfunc, for bpf progs that collect stats.
> - Add cgroup_rstat_flush() kfunc, for bpf progs that read stats.
> - Add an empty bpf_rstat_flush() hook that is called during rstat
>    flushing, for bpf progs that flush stats to attach to. Attaching a bpf
>    prog to this hook effectively registers it as a flush callback.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Yonghong Song <yhs@fb.com>
