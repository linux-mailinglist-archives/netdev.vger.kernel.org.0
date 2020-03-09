Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7093C17EC59
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 23:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgCIWyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 18:54:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21312 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726698AbgCIWyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 18:54:31 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 029Mq81u019851;
        Mon, 9 Mar 2020 15:54:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=B1K+IwyJLhzm5kCVjGHKqT0NkUwj0MYpZL4qLTTgysk=;
 b=EnFEriXuB5fMqOg8baZiSea6IsLh4nEYQEfipKhvUk/C1iWdyTQWdJtbUc2KEZvJ93oe
 nz9HX82kk2hV3JwMXe7q2fZXJpkAkHsFX+jDAqN+pp/s/7IKrW2TqptSYs45GkDmEjPG
 CAk/WeQ7ReXTW8DrGefWvfb3Pdhkvuer5jA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ymv6jq9g0-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 09 Mar 2020 15:54:18 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 9 Mar 2020 15:54:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mkV6h96ZCp/u/qR/dwHD9lB4Xt3Un9OcbV5oprOXTq+0TPm2tKMYwY/6on3ojOCqdNF3G69j8GL6jq3BM3bT0DTWgD4Urr9TQTxpkeFMrOvN3EuTPT1+36sSc3EepGMloOeMa21oHS+OyW6UXwSs+i67HsHHjVURNb6m2P+J+O9VD4M+4oZy9J3Yaw7aFqARvrLlDLqBPlb2xEtUdKObgNFeCM23zhCzBDYJAMSNWpBpwpjbuUITuOWBm67Q8e7ojTPWOHax4drAgFJILBWW0D4p0PT6gKXMKA56qGxpTvpXemxWsHg/WzfTTJFeTnsRLlcd1Z6TIh3/JZo0afLVDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1K+IwyJLhzm5kCVjGHKqT0NkUwj0MYpZL4qLTTgysk=;
 b=MIILNYlhN9AeKSTdinLfPLmrMU31+v5DZfe5ieA5fzF1suX17Uk+9pmrL4iqrKZsyODOvXknAjqoZLF90rViFLJZLhuVPNEEhqccwvl+/4DHpwBaK386SrWhmQoEYmG0HTUf68FUGw4YWcsK4EN1aNRUmZSVW5RR69kROjqYX8xC7JT+RK8w9c+b0Exx8tVhES5dftwR3C5PNoLAsxRHHjxB5yKmdrvlxyBzNUmAKhvgvG+c8emFVBMv6HzAk6zxFm4qPF7rLl6RwNVkT+quy2JmGWChWq7Av+CE08Pl2dhK55swuIq9dz0t79nkD4xHzyXduQby02Kteg24FqEfOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1K+IwyJLhzm5kCVjGHKqT0NkUwj0MYpZL4qLTTgysk=;
 b=JgEUIexkGsVPiqGXVyAEiJXP2tKWIJchUY1LnSM+jsPnhhiJDAg0MirLMxDzMQ9w88KrIzJSx0CoEmjhLF4zdrZP498y65DhiSDy0gRFwv5z9Ol06Er/8Ttk4e/WnDWSXz0O8TOEDdAGzX9xPFLTMypjxwriYEMUdI9DUl2jUQM=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (2603:10b6:5:13c::16)
 by DM6PR15MB2777.namprd15.prod.outlook.com (2603:10b6:5:1a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Mon, 9 Mar
 2020 22:54:00 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2793.013; Mon, 9 Mar 2020
 22:54:00 +0000
Subject: Re: [PATCH v6 bpf-next 1/4] bpftool: introduce "prog profile" command
To:     Song Liu <songliubraving@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <quentin@isovalent.com>, <kernel-team@fb.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <arnaldo.melo@gmail.com>,
        <jolsa@kernel.org>
References: <20200309173218.2739965-1-songliubraving@fb.com>
 <20200309173218.2739965-2-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <9d3f763c-af59-472e-a57e-57fe61da2799@fb.com>
Date:   Mon, 9 Mar 2020 15:53:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <20200309173218.2739965-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR06CA0061.namprd06.prod.outlook.com
 (2603:10b6:104:3::19) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:576a) by CO2PR06CA0061.namprd06.prod.outlook.com (2603:10b6:104:3::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Mon, 9 Mar 2020 22:53:58 +0000
X-Originating-IP: [2620:10d:c090:400::5:576a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b28200d-fc25-42ef-357b-08d7c47cc182
X-MS-TrafficTypeDiagnostic: DM6PR15MB2777:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB27774DE24EB95E0BEAD6E333D3FE0@DM6PR15MB2777.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-Forefront-PRVS: 0337AFFE9A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(136003)(366004)(39860400002)(396003)(376002)(199004)(189003)(5660300002)(66476007)(8676002)(81156014)(81166006)(66556008)(4326008)(66946007)(36756003)(31696002)(86362001)(8936002)(2906002)(6512007)(31686004)(6666004)(6506007)(16526019)(6486002)(186003)(53546011)(478600001)(2616005)(52116002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2777;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w652ga0d0gD5ZyjZCAxy/RCs/FGvLh6xoMKKN13+XDOi7QlaQwvJW6W7hV654T3RVPaUFVDTCKLuuFg3a0ar9R0wb6N3XuN/vAtWrAvQViXNRrsYtefq8N3lFlSmgQ5utnHQtBkAMr9EdikGwyW9At0sShcI/IhYgO4o/dEYCXuC/QTjsqQWzw0kpBte0S6mCWpNFJB/nNb6hvt3Whj5DLzyMt3eF2bHLBQyR6DBTnzO/AgrO0aICeLMfUH24DhgNCglTn2HQL8zi78EDlAdyo3RDAUY6VAGhnETA0AgUj3hLnemGGpbS6qcbile4LsZWnm2RSDos5XDYj4z3Iinq+LgNPs6mcldtjbxu2G1faZnxRSUlyE1rkTJDvVm+S6tDnbCC/0NWiN2IaLLpYrjxH1GwLMbOLoWm5UP3T7Mq2RXKLDpDZUkl6wHeGPfP4Bx
X-MS-Exchange-AntiSpam-MessageData: TDaMpTujCigi+qa365qEPYaTolz5EquocvU773FP3DpPAc8DjrAMhvCoFvAAxA4VK336wFY4MqxrKr4P0k/KopR0ase8ZfeLWqCNdjl7CDFK6KSmHal9vK8ADgvD9oz2++9SAp+3jFuLQuymbKm179OpCh6j3vSpeFxbvmq7s2sDCFWVpUSu1JNoxtSWqTOP
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b28200d-fc25-42ef-357b-08d7c47cc182
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2020 22:53:59.9818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kckm50S/3g7+o8b5+0Bi7IqVXvvq73J6cBvnpOgdhh+lhk23ECJ3yGqlIhA4mq7I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2777
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_12:2020-03-09,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 impostorscore=0 spamscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2003090138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/9/20 10:32 AM, Song Liu wrote:
> With fentry/fexit programs, it is possible to profile BPF program with
> hardware counters. Introduce bpftool "prog profile", which measures key
> metrics of a BPF program.
> 
> bpftool prog profile command creates per-cpu perf events. Then it attaches
> fentry/fexit programs to the target BPF program. The fentry program saves
> perf event value to a map. The fexit program reads the perf event again,
> and calculates the difference, which is the instructions/cycles used by
> the target program.
> 
> Example input and output:
> 
>    ./bpftool prog profile id 337 duration 3 cycles instructions llc_misses
> 
>          4228 run_cnt
>       3403698 cycles                                              (84.08%)
>       3525294 instructions   #  1.04 insn per cycle               (84.05%)
>            13 llc_misses     #  3.69 LLC misses per million isns  (83.50%)
> 
> This command measures cycles and instructions for BPF program with id
> 337 for 3 seconds. The program has triggered 4228 times. The rest of the
> output is similar to perf-stat. In this example, the counters were only
> counting ~84% of the time because of time multiplexing of perf counters.
> 
> Note that, this approach measures cycles and instructions in very small
> increments. So the fentry/fexit programs introduce noticeable errors to
> the measurement results.
> 
> The fentry/fexit programs are generated with BPF skeletons. Therefore, we
> build bpftool twice. The first time _bpftool is built without skeletons.
> Then, _bpftool is used to generate the skeletons. The second time, bpftool
> is built with skeletons.
> 
> Reviewed-by: Quentin Monnet <quentin@isovalent.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
