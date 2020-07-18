Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D212248E7
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 07:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgGRFLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 01:11:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8806 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725887AbgGRFLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 01:11:19 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06I54E4D031034;
        Fri, 17 Jul 2020 22:11:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=KDucF0EnmPmNjVKnUkg3Kkazg02B8T13X0nFF/oVKMQ=;
 b=LXVFxlMR0qf4YmzMvDURhQA8zRgRnrmIo8AhCvl5fLKYt9eF9imKdfwl/ip1t2PLdG08
 /zrntoB69C54D3BmUElJjSLPpqLWmj/yzIbcsL5/Tz4sMvL2c65TT3KPtu/pEJyanYRF
 J0URNEUtJbIyCnonkf/O7Bn5QcqhrhsigfA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 32ares0hh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 17 Jul 2020 22:11:01 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 17 Jul 2020 22:11:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6wWDaOltsAUNwMy3dR5817U0egkDpfcqNMH33hOcV4OF6v0dnegqej0/29ueY9F2a0kfZbTWUy5rSfjEpV0JkPUQH6Un/XeJdD+w/0rH7IdWI12sd8WV5Xt7SG0gPYhJ9VyUwmx7Cb1U90WlGSJ9nAXzVg1BHvRUi7FmQfpJyLWVEcdB3Ujyrogxp8fhlXhJpUSzFzWkLsaUK/KfrjibaaAc6Sto8b98Y+yYRiZ/dFR3W2QB0fDBMmlC5nsbbtTgqeH0yWbkU5d+oLbn5ihdGCgjQ/LRxy9R4wFolvFxWrogR4bPipz8zVkz9oERB0KvEqPOU8w88tpOgTLP27XsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KDucF0EnmPmNjVKnUkg3Kkazg02B8T13X0nFF/oVKMQ=;
 b=bMatCDAtN24NhiBJifFfUzsHMnoil/gUltdvac+WUtXwRa3EEXcvZ4Zt2b3fJI3a/BTLIhmxzD1y05uMqMxXdNt9zjly6b+rrdW4I3dPzFqZCWzLPk08aJKnxs2l5J8LoGrFtoqfXnJaAnG16de2VQh+M1pZLLROEWj7GQrl9RNYUOA+vlUU2BPPvR7Ab3nSFpZn/h5P78bGlGUBXdVuCXtKZI5NbcR8ntWq8WYKlo063bJZxJSprrBoaNd+26bWpaqFQV4enYRXrvLCkMGhXxjo7xvXD8Qh1Z4q8lf6lmX4bcRLrKq+nKFYXkskGgu6IsW1yv4I8kU+nTWQUldn4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KDucF0EnmPmNjVKnUkg3Kkazg02B8T13X0nFF/oVKMQ=;
 b=Fgkkt9+nokB6dDuj6wS3UXfWWr4qlmRMqZKu4EHFFcawQ2P8nkibfID26xxoVN9Jg0JvB9N8H8Ygao+tkobpWpBfYw/LEvsDWMCskNftcA1w502yYbrHBKDwVQydRK2+gIgnstoh1oJVqVcj4Z3SDm9Pyv159K8bt5GJvFzEbwI=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3190.namprd15.prod.outlook.com (2603:10b6:a03:111::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Sat, 18 Jul
 2020 05:10:57 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3174.026; Sat, 18 Jul 2020
 05:10:57 +0000
Subject: Re: [PATCH bpf-next 1/2] bpf: change var type of BTF_ID_LIST to
 static
To:     kernel test robot <lkp@intel.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <kbuild-all@lists.01.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, <kernel-team@fb.com>
References: <20200717184706.3477154-1-yhs@fb.com>
 <202007180734.M4279SC8%lkp@intel.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b4c188bf-27f2-878d-88bf-7650f9b5904e@fb.com>
Date:   Fri, 17 Jul 2020 22:10:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <202007180734.M4279SC8%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:217::22) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1160] (2620:10d:c090:400::5:6f2d) by BY3PR04CA0017.namprd04.prod.outlook.com (2603:10b6:a03:217::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Sat, 18 Jul 2020 05:10:56 +0000
X-Originating-IP: [2620:10d:c090:400::5:6f2d]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d52f68d-98d4-487e-82df-08d82ad8f41e
X-MS-TrafficTypeDiagnostic: BYAPR15MB3190:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3190646A25BD29064B742CA7D37D0@BYAPR15MB3190.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9FWKbJYNYPK+fR1/8IVtM6hXhGlSE2aYP58F8EhFB2XwvE4ukcXQOqB1kTJkUoR3SWN//aoFEZh2V8cz+qlyu634FWgnRmWzA5i8V4ZweZNRoL7IBMuV+FENyFfyGQOYvDOr47lgWz+QDI1PabbMHexEUGjEEGyjxXhwzNS2GWIjTezrgtYOuhnBcGGokwxEeSrYj8PxHqlOSvY19wYHQGUttmxoJgMTSusUQwDB9in0F5+CArVPd6TrFxfMj9TUjzrV1YN0ER5dvsTLd7qvWsWkVNlYsHs1r+Xu9tGOmuhNFp+tPt9M5E1KriN+XxP4sQnVxGhRs0CsXQl3QoHQETkIaVDa5Ib6qAbiD2fShUsgPhJJnh8SfrtIvt/9dbvKmV6imyRwGNhkpsCOO5/VD1/1+hTOhSqCv4d76v7MQPFvfnlcUHq+JPX4VFulMCw05zT4yjZITIGM3YnhTlRYcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(346002)(136003)(376002)(39860400002)(66476007)(66556008)(2906002)(66946007)(186003)(86362001)(2616005)(53546011)(31686004)(16526019)(5660300002)(6486002)(4326008)(478600001)(52116002)(8676002)(8936002)(36756003)(83380400001)(316002)(54906003)(31696002)(966005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: GADkq4ZI4cATjXxwikP9PXEg7yrvgZao75DK06PmXxfxYKB6niOpee+OCdjQGOrQL7TJhWrD1qDloECi/+CS07/vZn9aFCSZb9Gx4DOmjQ1uIewATf8u4Pfc6sCyBJ1VximOMpYzDGEwTxmCURqI9f6po0LObdVxAEvGPJj/dKbbEYCvmt2nDHDQ8IIoIVYi207HA78nt8lNfHcQDCJOBiC0TJ8AlYraH1AUkRgVL5umaTHup9NLeGOFepDlNhref22WHVAJs6VAMed88bDlHn4mednfYsRJykbl/uNzHdR/C71wjtjf/s1agqkQRmxnK6/v/Rkk8gHSC3fuz4TfdYFo4Hcu6X/WR3jdV0U4RZm8NfT2nWglQkJC03OXTZr/WcTmzSSkd6/+Pe6RCd1Ck2X8qwJoWqYtL+Yzc+BsODct64t1QJcxtvt47QfzanjJP9wQMkWh/zh2K0V1sZiTBTDwizBksOzzcIWVv4xg5VRDrCLVQj6pG3C8rHqIPC4S/7JLT00SfsPmGsEGuv1qlg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d52f68d-98d4-487e-82df-08d82ad8f41e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2020 05:10:57.3835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ubj4w2DMRglIc37BmWNC08a3ENGPRXD0pZ8NcSnpz6RvF0+eJ6OwE4Z456vESKkF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3190
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-18_01:2020-07-17,2020-07-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007180035
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/20 4:12 PM, kernel test robot wrote:
> Hi Yonghong,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on bpf-next/master]
> 
> url:    https://github.com/0day-ci/linux/commits/Yonghong-Song/compute-bpf_skc_to_-helper-socket-btf-ids-at-build-time/20200718-025117
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> config: x86_64-rhel-7.6-kselftests (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-14) 9.3.0
> reproduce (this is a W=1 build):
>          # save the attached .config to linux build tree
>          make W=1 ARCH=x86_64
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All error/warnings (new ones prefixed by >>):
> 
>     In file included from kernel/bpf/btf.c:21:
>>> kernel/bpf/btf.c:3625:13: warning: array 'bpf_ctx_convert_btf_id' assumed to have one element
>      3625 | BTF_ID_LIST(bpf_ctx_convert_btf_id)
>           |             ^~~~~~~~~~~~~~~~~~~~~~
>     include/linux/btf_ids.h:69:12: note: in definition of macro 'BTF_ID_LIST'
>        69 | static u32 name[];
>           |            ^~~~
>     /tmp/ccYr5IvF.s: Assembler messages:
>     /tmp/ccYr5IvF.s:23808: Error: symbol `bpf_ctx_convert_btf_id' is already defined

gcc8 is fine and gcc9 enforced the rules as `name` is defined both in 
assembly code and in C code. I guess `static u32 name[]` won't work.
I will restore to original `extern u32 name[]`.

Thanks.


> --
>     In file included from kernel/bpf/stackmap.c:12:
>>> kernel/bpf/stackmap.c:580:13: warning: array 'bpf_get_task_stack_btf_ids' assumed to have one element
>       580 | BTF_ID_LIST(bpf_get_task_stack_btf_ids)
>           |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
>     include/linux/btf_ids.h:69:12: note: in definition of macro 'BTF_ID_LIST'
>        69 | static u32 name[];
>           |            ^~~~
>     /tmp/ccjqxVG0.s: Assembler messages:
[...]
