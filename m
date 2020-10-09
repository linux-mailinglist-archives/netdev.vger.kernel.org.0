Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0A1288C54
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389191AbgJIPOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:14:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26266 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388914AbgJIPOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 11:14:34 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 099F5B4o020344;
        Fri, 9 Oct 2020 08:14:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=k9abOT2H2zIaT8Ztb5Vf+S8k2wZeru1R6a7GMUrMR3o=;
 b=PkMBmPYhuBcj6O5OisANQ7MhR8CophmnjZw9J2IVBAUBk6eRHeUVN2jNuXgPTR1iOmAN
 xZKkApa4FTWeDEsDvbXQ+cU1uLbvj3uIqvhHT/h5EQ2OzcnByhf38bwWk6iKcnvKoW93
 V6kbo3Ymfj2Gc7Bwek/Noci5uh/AfQNvZyg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3429gpc6c3-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 09 Oct 2020 08:14:20 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 9 Oct 2020 08:14:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EjWw8jUXkXn+5VPt1enLQjDq/pAuol+Ne5RyNB2mKklcs0LUtQcC4yesgZteEIYKC1uuBDd9ekJ8/VcVPx4+MnLy6rZjQqIbMfqckYodOLBK/49FbAW6ELdNVOWxnBcnpgJeOFUcWG78uYJohMS0ScuIyWaw7AC3CQ4g0i/HnHasx7zwXFmRIvFIDIxHQ7xdHnO3eWMakscA2jqUZKCSqFNvLZG2WOvZBERLzrvfqE/MDSRUKVSXdlcaRuhTceB1OP89xMUNCSR/ZdV7G8maAG0JTw+8ZR4ijvEyEPCiSCA2MlXVIt1sfnjYUYba5mruj5L9O4VlVmK5ACtCuU4kTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+aV38NmhcYSAlpwCUkCNAZ/uFC+4mfTm7zhrTMTHcU=;
 b=Wi6EtxBRS2pNF9Ww7IgqNu3dq0sDDxFLBMzWraAiWsU0CGnB0I36K/QQevTbEtAVqjigGnteuc66FviYDcmu3tKXaOGO71xhs8yIAhJ9Z0SQrbZjDhrCpvQ7UX88S92V4AO8xxhVPjXrkpqLf5muWk16I5W0vi/ZxrotG1IZGRCGJDQJX4HDEjg7ys9k0uJPoMCjmLsL7rM5gWuJuFyjtOArGngTqZ6aRrSm0QRxph1bA7ShjJIcB1PAAvLZvMrZMPdJk0iGY1KhhxUAgMjdpf+BkY9eIDGkTr7VS/NSzzF59ZmfuJVljIx6DH0hnjEJBW17phJTOEh/vQ3+xl2w/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+aV38NmhcYSAlpwCUkCNAZ/uFC+4mfTm7zhrTMTHcU=;
 b=jbx9er5wqF5jIEmEogqWKgo1gglHjTl18IfbedVSx2BVAe9Okn4gTfE8NYMQIDQapBVvwVvVVnqPkuaK0gPb5EJic2038vV3rpotXZvEQuUb7BilutO7NBlZtPLZqOUcoZKRmfLvGaPr+CAzB/D6b7EDeP8ZlwA3XPXHRrSbuiI=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2197.namprd15.prod.outlook.com (2603:10b6:a02:8e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Fri, 9 Oct
 2020 15:14:01 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3455.024; Fri, 9 Oct 2020
 15:14:01 +0000
Subject: Re: [PATCH v2 bpf-next 3/4] selftests/bpf: Add profiler test
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
References: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
 <20201009011240.48506-4-alexei.starovoitov@gmail.com>
 <5c129fe9-85ad-b914-67d3-435ca7eb2d47@fb.com>
 <CAADnVQ+MCPWoCOB7_ZWsiT7Xs3ek-s-ti+Gx7uYOjpDtAO1oYA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6218b1e7-99ef-0b74-a549-dc0145cbd401@fb.com>
Date:   Fri, 9 Oct 2020 08:13:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <CAADnVQ+MCPWoCOB7_ZWsiT7Xs3ek-s-ti+Gx7uYOjpDtAO1oYA@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:544b]
X-ClientProxiedBy: CO1PR15CA0109.namprd15.prod.outlook.com
 (2603:10b6:101:21::29) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1844] (2620:10d:c090:400::5:544b) by CO1PR15CA0109.namprd15.prod.outlook.com (2603:10b6:101:21::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23 via Frontend Transport; Fri, 9 Oct 2020 15:14:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3edf2b0a-8c89-4ea0-d721-08d86c65f3c9
X-MS-TrafficTypeDiagnostic: BYAPR15MB2197:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2197747E87987CB624F54B81D3080@BYAPR15MB2197.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:416;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FIqjd2+oYjqGpcWZa/kavghyej0Ce5r/X/E3tKawrsuLED9JZsK3VQJ12HeJCMSQLvq8IsMRvo9jAEu+UXVxTSjWfumUbBUnc7FnEMhSwrcUloyy3ySehMlFDLDJTajEd/8kSrwY2zQxhwCVAR5A8Fth+ZH3uD104YTfIoldEu9xhGebOizmaDDkDHMlkuSpx+R/3NLOW9Vfd/T4ZT7OooA+o9eAaUOwgbOaIwJC58f2t8iR3d2iF4gii6vjci+iusbn9BYWFFh2FnUcm+ShCvt+/EboI33C+gwJNElNgNfKZ8fOKgL2yb52EZQP2tG461HZHVT7CaYjbnE7GHXP1b8h/R0jnKQKfhvKn/KNW8a6vDTypVF447sRPE/No6y9V9usm6ezxsmL5/kk32reFowm+a78DAUMIQjhGN/49zxupF0AzHHyIvIkNBS2Ajsg0XWWv4cyANbAPka5RogC8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(39860400002)(396003)(136003)(2616005)(31686004)(6486002)(186003)(6916009)(66556008)(8936002)(16526019)(66476007)(83080400001)(66946007)(4326008)(36756003)(316002)(54906003)(31696002)(478600001)(52116002)(4744005)(966005)(8676002)(86362001)(5660300002)(53546011)(2906002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: bEaCE8bSkMz7SGe0U7Hj1c3PMZeYnIqEMSahcJFJU6x3ntvVuIuip07aQP8BqIHnZL+G8iGd0f3bNLIK3ayvVnxGcGn81nFJfRAisW/Ceq4VxnU4umhwS6KulsFPU6pMh1QUFnqMx/Kejk9a/VE9u/uZyoCSnAOC41p9lw+S1uanWCaPZFdcj+2TZPQiUCrOGnWuNkHyUNRlvaPPftArCvdpv6TZ4cjbLmcSCEMqSqhSvEw6Jm5MNnk2NpC42SMb0tYO3goQevSG7b+XeGocBXAPJkZiTnjT8OOenUgNC7AIx4oJHYQQUphdX+WXHjNRhiAjfDFgW/CNip8FE6UfGsxz4c2jo48SvFPuKvJVaNaLNh0g0B2U7tvq6r3qd9h500sPLbjYZaRyBeEdXfdIBig+TfHQZA4XULM0hFEUmq2++Hn5Lq9XBP/2b4zJeTuVg+PjaEs3+YpeOkewLvUeXlpZjTGolHi6ctUBiEJGDTry6XWSTvltTsviGTg4FVorHFvb5n22fgRO+r/8rB1z8yDVp8BUQReAY2AdGhicDGxp7rqvyA0yXYg7i+K44hHtfehqAYrRCcC1xdbTLs4FX0kRD3Sk9i6MPxm8rxf4kSALzz1DhtVBRGbV8TkXvdYyiuhtmk6ZT0BjiAfapmbbHwYHdxWL/Vn8IFZKnrQ2ZVQ=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3edf2b0a-8c89-4ea0-d721-08d86c65f3c9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 15:14:01.2951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uozFv2yKjUjxioYQb7BaAvydKnnWBHiMTUIM+RhwzQ9wF2UokJofiSYieVnDwTLk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2197
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 2 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_06:2020-10-09,2020-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 bulkscore=0 mlxscore=0 adultscore=0
 mlxlogscore=648 suspectscore=0 impostorscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010090112
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/9/20 8:08 AM, Alexei Starovoitov wrote:
> On Thu, Oct 8, 2020 at 11:49 PM Yonghong Song <yhs@fb.com> wrote:
>>>
>>> profiler[23].c may fail on older llvm that don't have:
>>> https://reviews.llvm.org/D85570
>>
>> Not sure but the below equivalent URL may be more intuitive:
>>     https://reviews.llvm.org/D85570
> 
> It's the same URL :)
> See it unmangled here:
> https://patchwork.kernel.org/patch/11824813/#23675319

WoW, I never pay attention to this. Thanks for pointing it out.
