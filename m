Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A1755DA60
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245428AbiF1GLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 02:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245403AbiF1GLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 02:11:41 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E991AF38;
        Mon, 27 Jun 2022 23:11:41 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RKtdCt031559;
        Mon, 27 Jun 2022 23:11:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=C9yRgUCUTP0ZkKNKC5p1wjiKYW6UECYUdIOfJIE464s=;
 b=ni9Sc4t5uUsaZgPAK16lfeCzia9VWURl92DYzl4pDmcAUzLvKJaaDXrIHcokBjPB2njR
 lvrHpAThdLrzywu+JQ79LXBdMibB7ak1XcbWP2XsP8/fSpuD+u8juzWBRMBuVbid1bTa
 tjfJQUIj9vcn6VdQu8Zi/0P37scwfrhiDWY= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gym12ab13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 23:11:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jYyiZcuGu6mNHHu1MgfYST36q4P35rNQ9tQxxbPB1p7QXmCtfYiudWG4xTeVlexJATm+np2EhkBQNCkzYpICfzexYKtfiEZ7u6wqGO1De79R6Ve1/gqgjdpzo9TWy+SZmj+yLq2bIcfB+GV9Hvl1tEpJVaXr/aKHa0xJ5RoTplcQtito/zJLn5IshjgeWB48dNxbuI+gTM2sivWG/bwnWdRCrcMnid/XYLPHrI175Kk6sPwhJ91onrB2uglHbUN3jW6+1WsVZ0Thv+xAWhxFRdoaZ3XqLpCGyQZQ1s2uD7XIFXcd665heY4bF12a9fdKO08rkNnEZV1aV/raNJPImA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9yRgUCUTP0ZkKNKC5p1wjiKYW6UECYUdIOfJIE464s=;
 b=LGnOvH6PfKDLOUfnbiYEad2clVEDDyU60aqe+yXh/XMORG0lnmVmI0q5gOqTqILziXJARjLPl0Xi3qklPHBuzqo8Vc6kXZoxaqgnf8bTXktCib+RTboxHU22n5b5xhnFYG9XSUPwv2UABBehlm/AOqxUr2zhPU/fbJ+GVNnAjNP+IixDj7KI5iaraaQs6jbVuPjkWfbCUxCZIp3BwoFI5bOKINYnz2xQo/ppXYnB1Z5VBZIHbNoFY+eAZmfGHmzKvm3q59EKsitgF+alO4uKWa9ReNqOYwwXRl184ThnLn3KQoaFPNoNwH9llqt/cGcoYbrPGhXx9WIHnSJMcrUykQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BYAPR15MB2534.namprd15.prod.outlook.com (2603:10b6:a03:152::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 06:11:17 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 06:11:17 +0000
Message-ID: <60365571-bcf0-d096-d023-c9a8bc9a40a7@fb.com>
Date:   Mon, 27 Jun 2022 23:11:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH bpf-next v2 5/8] selftests/bpf: Test cgroup_iter.
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
 <20220610194435.2268290-6-yosryahmed@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220610194435.2268290-6-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0184.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::9) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a309d7d-c553-4569-d7c3-08da58cd02f5
X-MS-TrafficTypeDiagnostic: BYAPR15MB2534:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WhpFhVSMz62C5sEA1hQqfUQW5PJm8Sg8C7/yDyOEoUsm507OyoHxEGuXSuLTAX00tHFdXHjdRoZsviK6NyKe4TOaKT1muibJI/1KwDAp1qZ01j79o+uyms+yCR9ApKBSHXoi/lcCqgddM/tOtzcirsGxYJc7WRq3iZnlQPhUGugk8T+XKi76jeXLLgElY9KxMaNfGpLOBdgWxqLlEasxpz60Wt5yLUy+TPoaDpn7MXCSt6U0Uxr4efPyXWi/mSZ2Kd+KN5GCnVMH+UMEn3zKEQSz6P5mMw9TM7oQogkljSybJOL/BA7h0YoXMwByjWnbfOyTUVQOydz7ciXpFtf6SolVBc06vBYfZZV90Kaj1wWuGFnddVtgOKtDqaR0tbwYl3TLnGXNuNVWnPAnt2xWu1TeTzH1qu3k1EkP0/VT9ELm+bCEacyJoVdwAA+M2SeZiLla7HoVNUSp2AUE34liqjHzw973FS+6pYl4j7Vw8OMwzwbSAnEUTZtQzIpQZrneWYJLpFGfQcdWZ9j6M0LwXG1Hj38tYxwFTOINkBy44ITag2U94mgg2NvM3+dV0SPwKixRhYLv/Nf9Do8SY0Q/ZEsW9PWJbu6Gi58FOGjGGoewoPL+qW2zbYH7irM8vOND5IxLBL9tzYRsKkjjZhwro3WuScnVBXnSN4Gg7UFeyMwhYQj3gaNXc6/z+py8p+64Rjn57enpJJKsR/y6u8CVfmGvYpzWWlhNbWf6jSaPwEBQfJKjHDaHmYTiCYEUwxgumh3Bq/hhg/65T7dxLFSPAbo9cN4EhHYXxdfdBtG8iGi/sczXMKMvlOLjRVT9bTuRxza1U3zi376n6Ir4DOwxtmejuJGpRlMUNR9YNvN58K0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(110136005)(66476007)(6666004)(38100700002)(36756003)(6486002)(8676002)(8936002)(66556008)(316002)(4326008)(66946007)(31686004)(186003)(54906003)(5660300002)(2616005)(7416002)(41300700001)(2906002)(83380400001)(478600001)(6506007)(921005)(6512007)(4744005)(31696002)(86362001)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tk5QTkRFRW5zakcra0E0ekZxSlp0bWZzRnJBWFBzQWNwaGZtakkwYlJvZit6?=
 =?utf-8?B?SWNKeGQ1enJXc3NaWGZuRFh1RWxlNVlSWFlEcmFsZ0k1cFdMOGRiU0taRndi?=
 =?utf-8?B?S0NJNHp6QnRIVytWZzlHaEFpZ0tqUzR0MmtFSkhMVUw1NWhKV092dmRzaUJO?=
 =?utf-8?B?dVZwVGk1KzdUby91QlI2Qk5zd0ttKytMM29GZ2hPMkpadGg2TmRYTGZFMURJ?=
 =?utf-8?B?S2hleTdxMlQvbncwcnpWQTh0Nm4rN0hTT3dzayt3b2tYZis5SWVtRUtPQ2Nv?=
 =?utf-8?B?dVVaU2dwdFFPUE1MVjJRR1Bwa3pHdWJQZmVyZHo2YVVlY2ZiVno0UlBqQis0?=
 =?utf-8?B?ZDdTL1BmRGRmejVicTQvWk9NTzVhTWlaTmlFS1ZKcWhhM0w2NjlDYUxZUGpu?=
 =?utf-8?B?Q0tyNm5SQ0EwOGh6bjVmczM0SDBjcW0rWmRkSE9zV1h0eTdyNTBIaDJCemdt?=
 =?utf-8?B?Uy9YYXVKYk9Vd0lMNU9BTkpLQ1dDclJzekFDcWpjVm5FUkx1Yzk2dHRrSlhv?=
 =?utf-8?B?VmsvU1lESjVIZU1RYUMrd0RDVVJTM1FFMWRwOWU5cEw1ZkJ0cXBtdEdqemt3?=
 =?utf-8?B?OElDM1JreDQzczNFY3FNWVBpb3gvL1lmNlZMWlMvMmNzd1V5MlVEd3g5TjlG?=
 =?utf-8?B?RkYrZ1pKdEFMYmRPZHBIdXFRV0ZvVGh5anhFUERqR05SdzFXS0l3OXNuTU5K?=
 =?utf-8?B?REZKdGxDc0dCY01lVUs1S2JUNjk5L2J0VGwrWEUzQlJaQ0ZmazlmYklYQjVF?=
 =?utf-8?B?K2RkSEVEc2lOUHBVRHorbGY2SXd3SFM4TkRVWGNDaFhKQlE0c2lVQng3elNh?=
 =?utf-8?B?bENTNXQvL1poVGZzT1J6NmpNU2JZUkxDMWFtRXkwZ1ZnZVV2VTZ6NmJQeHht?=
 =?utf-8?B?dDZ1RDhsRXdZTDJXSldGcjZCajBSd2Q5cGxXREFTMDEzQVR4SjBaRk5rbVh0?=
 =?utf-8?B?SzFTaGwvZXNJdWlSUUZ2QThoSjNvTDh6bzNlbEhvcWxreSsvanh3VmIrQzZw?=
 =?utf-8?B?MUlOSnlQZUExYkE1ME1SYW4vTmEyRFBkWXpKV2pPWVNsbGNJZUlTUFoxVDVU?=
 =?utf-8?B?aTBENG1rNXNNWGlWTXpwM3BocU5IMnh6alRNb2RLWTJBcDlmbHdUYUhGeTQ4?=
 =?utf-8?B?L0hqQS9ocHVsam8xNXVWMEhYUnpTMjQzTnZDQ2tFWVZXUTlXVmlGaFArYnY1?=
 =?utf-8?B?aTMyanNHVDUyUEdWSHg0NlRjNDR0RExZbnY0bzRQS2srdlUxcEM3blJzdzN5?=
 =?utf-8?B?QS9QMy9sVUVXRk05SkRDbVBQajkweVhtdFBYNWtydEh2S3ZHREVpYjVIMTFo?=
 =?utf-8?B?M0VXUDYyK2NSVTNUMWROZC84Rk1sMVZqY0hINWlzNHcrZ2luajhDTE11ckg5?=
 =?utf-8?B?d2F3WEUyc0RHYm52L09ZNU91MVFRM2w4RWhMWGNkZFhocUxqUVROUDdGQkNH?=
 =?utf-8?B?eXYrRmRVaWhvM3YrRGpxVUc5NEo2SjNIOFkxTFN3VXM0TlJFZ2Z1bnYwWWZQ?=
 =?utf-8?B?RHRMRk5kSmtlMmpjdkN2aXFHZThrWGY0UzFHME1mSzN3YmNGY3VsVHdoZE5V?=
 =?utf-8?B?Q3dzZFcySTM3QXdjaUhZTmZSeFFxdmQ1MFVySFNtOW5DaXNXZmN5N294UFRN?=
 =?utf-8?B?Y0lyR2V3dldFU0ZTdGlGeFFHcXF2VTVSQ2RJY2tzMnJmaUNhMVArdSsrbkdJ?=
 =?utf-8?B?TzhGdGtvQjdicWhEc2dEWlJEd1hkZ2ozQW5RMG9WSHRjQjRncUdob0toOFJR?=
 =?utf-8?B?MFpsdUZ3SFNCSk5HWWhsY2RwSEFQcVhUcS9Jdk9vdlZkVUQrYXd6U21EVnM5?=
 =?utf-8?B?UWJlSXluNmRFUGtxZlZkc0YrRkErWHp1bHdZeDZNemFZbWppbHl2THZMZFgr?=
 =?utf-8?B?ZmM5Qjk2OEkvTmdldkQrUXlRc1NndFR6TGp6dXpzY05ocjJnY09TNlNSTVdJ?=
 =?utf-8?B?aXI4RzlaaEV6THpOekFlajRxUjVPUkZoVGxrSjZGcVZjTTBsYU9DNWRSSysz?=
 =?utf-8?B?c3RtcWlIM1BwaW1TM1NuN1ZHR1IzWlZCK3dmdlpFcldFL0J5ek5zZ1k3MHM4?=
 =?utf-8?B?WXpNb1NrSWY3NExhd1dKZkxYTEs0Q2NaOUh3TXBsUWw0QWlJY0U1RElvRVVB?=
 =?utf-8?Q?Ye4bBz0zDoRkWn8fiyTUFx4GA?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a309d7d-c553-4569-d7c3-08da58cd02f5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 06:11:16.9114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F1gBjwWygf08dCGqL1iQg9oh6B9fZSfnmO2YlO9jN14imssNjTnZ+3/eKEFj7evX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2534
X-Proofpoint-ORIG-GUID: hk4_i9Trha6Jaz6GPVqN3qzzgecEAfpF
X-Proofpoint-GUID: hk4_i9Trha6Jaz6GPVqN3qzzgecEAfpF
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
> From: Hao Luo <haoluo@google.com>
> 
> Add a selftest for cgroup_iter. The selftest creates a mini cgroup tree
> of the following structure:
> 
>      ROOT (working cgroup)
>       |
>     PARENT
>    /      \
> CHILD1  CHILD2
> 
> and tests the following scenarios:
> 
>   - invalid cgroup fd.
>   - pre-order walk over descendants from PARENT.
>   - post-order walk over descendants from PARENT.
>   - walk of ancestors from PARENT.
>   - early termination.
> 
> Signed-off-by: Hao Luo <haoluo@google.com>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Yonghong Song <yhs@fb.com>
