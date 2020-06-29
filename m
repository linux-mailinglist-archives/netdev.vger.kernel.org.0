Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E93220D61A
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgF2TRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:17:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3202 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731371AbgF2TRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:17:40 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05TIBqqV006401;
        Mon, 29 Jun 2020 11:23:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Gwm0WsNbzDA9ujCP5w9KgN7hvV3V1qylikXyd3mxQSM=;
 b=a8bEgFhG8Nf1iAz0nhjLQUJ7PVubgJCjiVuxOnBM0bRxmTmuBOL2vQlkWRQi7Fk68SKJ
 6a6Jz1y+DPy7RYLtQMaytjvXuAOM0/Ytkhr4b4Qxg5kvYW5XZZ7vNNj49Da8/uqduVFz
 p3+d3z7/yy3gh/rjN5uaF0hnNTbUYNmKoWQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31xntbnwbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Jun 2020 11:23:07 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 11:23:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+LXj+H+zVz/32QJJoLgRro/Ms3j0jZnmMRPWQjV3Xcjmy4YI/tzGg5za0C6t7K5A+yJ22QQMfCY/YDBf7DgZN331QQlBCdCFzIPS7lqI1XkbZ+Uv4HbnoJtz5EbRf+umaxNPE02is2BWRkQhJHmPOW89GehHIRC9NTYqYnMBOmWaKEOlvZFTfalbNFrH+BRT8VvJoXULKR+zP8l3HBdUCoDl+toSM68XIDJgHcJyeuRxLtm/9V7ruiPEl2kWUZaOKGv8HBz3kpewdqnmlarD+mFaJTQr/Goiq39y9FxstM/ncWRSyaoMquYkB4/c+mEKSGNVmFo7qbugHQKYE/fKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gwm0WsNbzDA9ujCP5w9KgN7hvV3V1qylikXyd3mxQSM=;
 b=aFhX9hSrB0cczM68r+bpibQDk/tTkOkz6mjjH7vUI9cJu109IZF4MpChXPCR4Z6p5Rr710H1h2yxXbW3eToP2jVkTcAcs3oOCFbyHl8MhvJxAj67Qxb46xkaFjwEAwJr0++XEnsPF8nS1+d5V3WA3QFmbsAISk/u5NTQyQE30hf5RffbxHynbRvZPvA0/btjDwKc6cz6MfP52zQjy4haQjOSIGZK2LavpUyz3mvFFBpz8Ibt7Hh+a4xoOBn8lrzWglKd6lwdbfYsU2FpvToQKNKae1ikiOxjh1rh8eiRBWND+7+y+uBtQ2azVFu27BhV0A9Eyjnf7zjOFoz3u4z1uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gwm0WsNbzDA9ujCP5w9KgN7hvV3V1qylikXyd3mxQSM=;
 b=QDwI/mG6dfLrucQTr90sUIL5sWBMIkE+3kzMj360//ob/Hg/01kgBAqypn4A4g6hLs2rlXa3ORXtjvZ1JBNHxQModQopzRFQSdJJSQ5O3YImxiSPO6aN8YyKrYxXyaSylZVLSCZSsBzgXalMOfax6QAyXQYqnK/mQ7hFDvIyiEs=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2376.namprd15.prod.outlook.com (2603:10b6:a02:8c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.26; Mon, 29 Jun
 2020 18:23:03 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 18:23:03 +0000
Subject: Re: [PATCH v4 bpf-next 4/4] selftests/bpf: add bpf_iter test with
 bpf_get_task_stack()
To:     Song Liu <songliubraving@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
References: <20200629055530.3244342-1-songliubraving@fb.com>
 <20200629055530.3244342-5-songliubraving@fb.com>
 <bd62a752-df45-8e65-9f74-e340ef708764@fb.com>
 <D3BAF0B3-122D-409C-B0DD-600E1EE606C0@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <30cafbac-723b-c5a2-84aa-b9899d3c8997@fb.com>
Date:   Mon, 29 Jun 2020 11:22:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <D3BAF0B3-122D-409C-B0DD-600E1EE606C0@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::42) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::17d3] (2620:10d:c090:400::5:40c) by BYAPR05CA0029.namprd05.prod.outlook.com (2603:10b6:a03:c0::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.12 via Frontend Transport; Mon, 29 Jun 2020 18:23:01 +0000
X-Originating-IP: [2620:10d:c090:400::5:40c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9971c23-f702-4c3f-fba0-08d81c5975c0
X-MS-TrafficTypeDiagnostic: BYAPR15MB2376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB23765B0BF0BAADEA4DB5612DD36E0@BYAPR15MB2376.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:510;
X-Forefront-PRVS: 044968D9E1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mHuZvrR27Door7hn97zgTWRloW+b9eLl8H6CMTTfPF2O7RfJj56Cd05hFEEveiMu9kAz0O7DiyKQfQOgRRpvX7ax96k0Jdnmy0b9yAngRh+6VEPaw3Uta1Sp+ZSrvMvYhO80JBpBzyxVf2F5u0cm4bvPwDaBVbflSa2cOGCuE8sn7sQKtREKxQwLdPdu/h1XazUd/5sRwoxL1X2+nmkifiM3JDXrEQ9wizO3I/HHlWGN+724VfLginS7NNfSGFV4ka9myvrVsz+402OpzpjCbIiQWaqeF2R6Nazm70ABsUb1v/UsvDvsqqNyyuY4feh8PGWkSz6FNXAfnedRSbobxwy+hboCKxa8/z3wQ8jdJW5kWX43W0fq91L8aZ8b4RRh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(39860400002)(136003)(376002)(366004)(396003)(316002)(83380400001)(31686004)(186003)(16526019)(36756003)(37006003)(2616005)(6486002)(54906003)(31696002)(86362001)(53546011)(6862004)(6636002)(2906002)(8936002)(4326008)(66556008)(66476007)(8676002)(478600001)(66946007)(5660300002)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: WL97Ol1JVhWA5Rl/MWw7XdCgGolqMU3ezO3FpNckGZYuOYqKZczdWnvJGlt3oCVbii58s4Y+MC4MBE0A0lmmIyDDE69WjTe7xsMXYYFER28la9rhhpgLlGP3wuSyVQspoQYv4KAlJdbbWhUmSVIeO26AkQfEHcMKJQWuZiek7iEsl+IqJQDpxwzkf+nGca0t8y8sheJK2T8Zv1lvT43ZQqCXBfQrt+0Z/75bjHXwdi8ueNcpmV5bxljpTbr8yS+Kx87LsKiKU8IM/tUa01FjlH2FRSkFFGaT7GpWBJDyt9IJSpn0gB90miE3/NrEfoEhHrw2BV722TpxX4ZUlsra12gWuKJbm329W+QesxhWvDvaWuUMHWZDxfc3G/cZww3Rm8DZbljUYjL6+CaZkeLrTL7Tfe/2ba8zRRJtxBb6c7wgPxWril3uHRg9bLdNNBmn9rlDJF2t4LbTntZosTZbpPe62cp3Us/D0w7xdOw1iZIQiPKTxlsvD4NSs+3nUAt5PGLEURdOWKWUklFglZHlkg==
X-MS-Exchange-CrossTenant-Network-Message-Id: c9971c23-f702-4c3f-fba0-08d81c5975c0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2020 18:23:02.9232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3wvT5m2UsbY9CfFhegA+m9KVGTQoUdjvC8oY1TrF/Iql60ykIUq2enYHOVfZ9BdO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2376
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-29_21:2020-06-29,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 cotscore=-2147483648 lowpriorityscore=0 mlxscore=0 clxscore=1015
 bulkscore=0 spamscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006290115
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/20 9:56 AM, Song Liu wrote:
> 
> 
>> On Jun 29, 2020, at 8:06 AM, Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 6/28/20 10:55 PM, Song Liu wrote:
>>> The new test is similar to other bpf_iter tests. It dumps all
>>> /proc/<pid>/stack to a seq_file. Here is some example output:
>>> pid:     2873 num_entries:        3
>>> [<0>] worker_thread+0xc6/0x380
>>> [<0>] kthread+0x135/0x150
>>> [<0>] ret_from_fork+0x22/0x30
>>> pid:     2874 num_entries:        9
>>> [<0>] __bpf_get_stack+0x15e/0x250
>>> [<0>] bpf_prog_22a400774977bb30_dump_task_stack+0x4a/0xb3c
>>> [<0>] bpf_iter_run_prog+0x81/0x170
>>> [<0>] __task_seq_show+0x58/0x80
>>> [<0>] bpf_seq_read+0x1c3/0x3b0
>>> [<0>] vfs_read+0x9e/0x170
>>> [<0>] ksys_read+0xa7/0xe0
>>> [<0>] do_syscall_64+0x4c/0xa0
>>> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>> Note: To print the output, it is necessary to modify the selftest.
>>
>> I do not know what this sentence means. It seems confusing
>> and probably not needed.
> 
> It means current do_dummy_read() doesn't check/print the contents of the
> seq_file:
> 
>          /* not check contents, but ensure read() ends without error */
>          while ((len = read(iter_fd, buf, sizeof(buf))) > 0)
>                  ;

I see. Thanks. It could be great if the commit message is more
explicit about what 'modify' is.

>>
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>
>> Acked-by: Yonghong Song <yhs@fb.com>
> 
> Thanks!
> 
> [...]
> 
