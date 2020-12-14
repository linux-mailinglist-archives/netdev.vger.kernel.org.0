Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D532D9198
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 02:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437710AbgLNBez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 20:34:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2220 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731222AbgLNBei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 20:34:38 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BE1VYGf004845;
        Sun, 13 Dec 2020 17:33:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=3VvTFhAANBLDCKkKdBlH+9gY7exTC+vfAlHUu/FumJU=;
 b=EJDcum7ic6uzPECQpK8XjIHpZi1WNN81HyWmJU+roADsMTvUKM7doxDXtoom064gXVSJ
 +VoaeytgrMKCxD0soXHm2EDvR6F7zEvDmI3XJqGLS+Y2ocPDbOZ4CRMF6uRGMC7lvvoO
 L+yk5boIUXIhJyRPTb5zaxyKUYOfTbLzit8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35df0e29mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 13 Dec 2020 17:33:54 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 13 Dec 2020 17:33:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBJNUxMybFSFxViKExGaEfho0r2zWvTm8gUrk5smt/XuRnagN2NKPRHdmlcGjeFCfmMlCjo5bwhS2UV/gJZyWaaRPnYVyozbOt6uJeprdBBZ6EmvY0bPvNq8iplLLm1at8ZKOADkCycAVdZMwSOKUImxXsOgZ7rQxVOXMUrbJZfaUwCoh00faHibgDqFbXXId9fese1QZtVN18QYWqpio6vrZ91+yqJPcQSPlIbAAGu9L5M1W20Jofg7sgs9HbIPeP90vITf8iH8cpUPy0vbBHt2/QTcAIbyIVcF8oUQG9TgX35NfQz89fcYX6q6sLFYMkcmcbcutjGqxSvEGFzA0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VvTFhAANBLDCKkKdBlH+9gY7exTC+vfAlHUu/FumJU=;
 b=iKMRUCqhfrowz+xCvpHbmW6eHG1BkU28q7bwAVQ5V4sO6v9rMLsO3lqAYzEeqGzQMo9GfjMMMyUUodM3FHz1yjYcZIw9A27sKs7bcNROSOduQRJxVADxtd/nrFHnyumI+YpvjGjYhjzlDHwD++Gn3tL9Poz7HR0bUknSY4qn6PZrXgi8+AQ49GYHZalzsLMQDo7/ZxjnzbyQIkXtQt//HOChMP6KiFUgrgllzuzuREI4sEwGlvrPRhC+VpHgRHvQWLOgImFJ7S/Q0Ghr2yuIoW2c7iv+widxp0vLioMchPVzsWdbn/+hi0uWv7NZhqOMhrPLppLKIfscN340Ec/ayg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VvTFhAANBLDCKkKdBlH+9gY7exTC+vfAlHUu/FumJU=;
 b=iciHE74dxpjiyVMlEfbjeVURjURR1ol7dkSLEZw2oNKWdehA8V9Mz/dl5VOhp+/jeelO1MmsCIfgq4gkbn01ck/Iy0yggW+SYNNUpHcbeX57bYOVJR8NlO2od332C9iyLOJSZm2uW4e0vD4fcy1h4Ie90EatgxiuEG3+4/QSTQM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by SJ0PR15MB4236.namprd15.prod.outlook.com (2603:10b6:a03:2cb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.24; Mon, 14 Dec
 2020 01:33:52 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::258a:fe57:2331:d1ee]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::258a:fe57:2331:d1ee%7]) with mapi id 15.20.3654.025; Mon, 14 Dec 2020
 01:33:52 +0000
Date:   Sun, 13 Dec 2020 17:33:50 -0800
From:   Andrey Ignatov <rdna@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>
Subject: Re: [Patch bpf-next 0/3] bpf: introduce timeout map
Message-ID: <X9bA/pSYxW079eYm@rdna-mbp.dhcp.thefacebook.com>
References: <20201211000649.236635-1-xiyou.wangcong@gmail.com>
 <CAEf4BzY_497=xXkfok4WFsMRRrC94Q6WwdUWZA_HezXaTtb5GQ@mail.gmail.com>
 <CAM_iQpV2ZoODE+Thr77oYCOYrsuDji28=3g8LrP29VKun3+B-A@mail.gmail.com>
 <CAM_iQpWA_F5XkaYvp6wekr691Vd-3MUkV-aWx4KWP4Y1qo4W_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAM_iQpWA_F5XkaYvp6wekr691Vd-3MUkV-aWx4KWP4Y1qo4W_Q@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:225d]
X-ClientProxiedBy: BYAPR05CA0070.namprd05.prod.outlook.com
 (2603:10b6:a03:74::47) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:225d) by BYAPR05CA0070.namprd05.prod.outlook.com (2603:10b6:a03:74::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.9 via Frontend Transport; Mon, 14 Dec 2020 01:33:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd7a69af-40e8-4b4c-3581-08d89fd0509f
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4236:
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4236C47AB3DBC732B6035543A8C70@SJ0PR15MB4236.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LKClzg+8k5xL9Quid2HjDkE1iOMA2yGdAaWLjR+jOkG3eLzT0jcK9yuw6bJhD+Sj8snvta7ZsCX8/Npmn4JezgIdyz95oZiSp/WGbOdHOoYfATNZyvPIsZphfJYXL+SDo7+6WzDgu8NDUC7d98oWTQHAM2IjS7pu+hi6Ini2zjIaXFEwi1Dpz0y9QCxkavYx9sZOVLW33tvclex1VDDjtLiqFNFwxVpSpM99jiQCsy93NOkks6B1XOKuyvaPs/kjrsFuAeKzpMeUtwa1h1GIu/v9FeyswNzMF7DrbjAunso0ik0l+r6T9uq9BA7Q4xevkIh4fFP9M7GVY5nqOvcbpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(136003)(6916009)(9686003)(16526019)(6486002)(66946007)(54906003)(4001150100001)(186003)(66476007)(66556008)(5660300002)(53546011)(6496006)(83380400001)(4326008)(86362001)(8676002)(2906002)(8936002)(52116002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aHFCU1dGclpobi83YWMwMmhDWk5DM0RJZ3RPMFB6U1FxdlprOXNQUUlqa21h?=
 =?utf-8?B?RmdFbDV6U21XeUo3TlpLeC9UNlliT3FVQ2lxYStvMkN5UU42eC9LSlZBc3Np?=
 =?utf-8?B?eVJIbHZ5R0IrUHBJdUpTWm1JSzBCY2Z1b3l6QTUyU3FRbUI4REU0YVRJRUd5?=
 =?utf-8?B?Y2c4VFNOcGIyYnNUaGU1WEVWRnN4UzhNR3psd3BpVndaU1hnOElueTNGYTJk?=
 =?utf-8?B?eVI3RVhya05BRmw0QllyL0wyRFJLR1QzM2V1UjFycUIwMjd0LzhtbWh6VkIv?=
 =?utf-8?B?RGpDVGtoQ2xyNGJudkJtaWd4SFhkM0U5Y04zUmhxVlpBWVIyNW14WUpqS3ZK?=
 =?utf-8?B?SWY4UXN2OHlRaStnZ3NrUUp3amJWTURmSEttdDlGS0x1MkNRTWQ5MkFnVjd3?=
 =?utf-8?B?OG9UbWxuck5WdUtMc1JDakJqSGRuMzJseEo5cUpMYTA5S0pOcWx6RUxLTmR5?=
 =?utf-8?B?ZTlJeXJ0U0tuR0NmM1IrM0RFTjQ2Z3lZV3JBL2NEdVorRk1tSEd2Z1JxSlNV?=
 =?utf-8?B?eFlJdEtydzM5OGg4ajZmdXFJOURtYU10Wk8rRk54NzVqcjkycVNnOXJpbEl1?=
 =?utf-8?B?OElmYmFDNjAvUjBiQVdvL3hDQUdIUmh3eGYyU0dzMDgvK2E3b3hGREhoZHlE?=
 =?utf-8?B?Y0FCR0pFSXR5ODBmUE44YU5iRm9LN2FRMGdUaDVGeFp2bW1VcjhMS1JJRUY1?=
 =?utf-8?B?anlUNFkxQmJyb1hCYlpreGZNVTZjZDJzcmxaMGNTUVY5ZTZZcmZpcGpiYjBz?=
 =?utf-8?B?T3p4Zmo2YWQ1WGFtNk00eUYwWHdnbDFQTXBRV2pPbXdoZWxlajFPcjhyb2gr?=
 =?utf-8?B?ejBvTmh6ZWFaT1ZoZUdFKzF2cWN6SExEMURVRTZ1RGlxaXFaaklCR05MTC9I?=
 =?utf-8?B?NHlwZzZtYWUwOURxSkIrVFl0QlEwaCtjbnlvWmkvWU0xeFp2RjdJTHlhbWor?=
 =?utf-8?B?KzJJNE9JLytYc1Y0MW1nUTFZTlZSeVhmK3ZiSzE1TWNUbUU4Uk1RZU9FeW13?=
 =?utf-8?B?cVBURUpNN242S05Mdmt0ckFaWXQ4QUxBVExGVGR1czJIbUcxellUQnA2eHMw?=
 =?utf-8?B?S1Q0UHFpYm45TU1JV0JUTTVpbzJ4NWZZbnJNS3ovelk4WUVBSVNWOTl5S0RL?=
 =?utf-8?B?ZVA1TStzc0VYcjdscDc3K0xoSEhJYWR6UGd0dkp1TVFVWFgvRWpidG5La2Rn?=
 =?utf-8?B?TXgrTTlpSHYzWTdBblBnWFErMG9MazlwZW5TTHltSWtOU3pKdVhrREYzUHZS?=
 =?utf-8?B?ZnBRK2V4WFk5bXpwRWZCZUdISy9vUjZoRThrbzdlUE9YR2tIdTJyYU56clpv?=
 =?utf-8?B?MlZTS0FGUklBY0xHb2ZqTTlMa1owd0pMNFc5ZzF1MmtZZ0g0MzgrVkIvMXpi?=
 =?utf-8?B?bmlkR2UrQ3pxcGc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4119.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 01:33:52.6041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: dd7a69af-40e8-4b4c-3581-08d89fd0509f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: odgfBfWh90U9NP1nLbYEtB3pbip/EAFkdSop4xohUbyugRJYsFxFqI3+v3nmOM+/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4236
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-13_08:2020-12-11,2020-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1011 spamscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140010
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> [Sat, 2020-12-12 15:18 -0800]:
> On Sat, Dec 12, 2020 at 2:25 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Fri, Dec 11, 2020 at 11:55 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Fri, Dec 11, 2020 at 2:28 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > From: Cong Wang <cong.wang@bytedance.com>
> > > >
> > > > This patchset introduces a new bpf hash map which has timeout.
> > > > Patch 1 is a preparation, patch 2 is the implementation of timeout
> > > > map, patch 3 contains a test case for timeout map. Please check each
> > > > patch description for more details.
> > > >
> > > > ---
> > >
> > > This patch set seems to be breaking existing selftests. Please take a
> > > look ([0]).
> >
> > Interesting, looks unrelated to my patches but let me double check.
> 
> Cc'ing Andrey...
> 
> Looks like the failure is due to the addition of a new member to struct
> htab_elem. Any reason why it is hard-coded as 64 in check_hash()?
> And what's the point of verifying its size? htab_elem should be only
> visible to the kernel itself.
> 
> I can certainly change 64 to whatever its new size is, but I do wonder
> why the test is there.

Cong, the test is there to make sure that access to map pointers from
BPF program works.

Please see (41c48f3a9823 "bpf: Support access to bpf map fields") for
more details on what "access to map pointer" means, but it's basically a
way to access any field (e.g. max_entries) of common `struct bpf_map` or
any type-specific struct like `struct bpf_htab` from BPF program, i.e.
these structs are visible to not only kernel but also to BPF programs.

The point of the test is to access a few fields from every map struct
and make sure it works. Changing `struct htab_elem` indeed breaks the
`VERIFY(hash->elem_size == 64);` check. But it can be easily updated
(from 64 to whatever new size is) or replaced by some other field check.
`htab->elem_size` was chosen semi-randomly since any bpf_htab-specific
field would work for the test's purposes.

Hope it clarifies.

Also since you add a new map type it would be great to cover it in
tools/testing/selftests/bpf/progs/map_ptr_kern.c as well.

-- 
Andrey Ignatov
