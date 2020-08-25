Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A2C250DC7
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 02:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgHYAom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 20:44:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21628 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726090AbgHYAok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 20:44:40 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07P0f2L7017666;
        Mon, 24 Aug 2020 17:43:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=X33VrTA8ZEyzUgtNbdx9RHevLeQ3yTwlT2mVN4Ui8+M=;
 b=Q0s/A+as7lA8CsZcvg0CuD2SOZVdcojTxXn7edZShFPzkPyLNc5lXWCxwfePqR7k/9MK
 ZeCE6AhbJOKVFOcFG0899g/xPw/oLmZN7ikc77+ES+dD5A05Dx1ACcUbeMLWaQnPD/Xt
 UEwz3KYYDQ+31yZ0c+zdhSzrPkBPy6z4hXY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 333jv9r2ar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 24 Aug 2020 17:43:52 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 24 Aug 2020 17:43:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAfaKR2BfOTVJ0sH2/gygNHiJ+oGw8EJrtG/TO70Wmf8uA6OzojhbY8ra4CqbvK/N6mQEH2Jyoob2TR2VOgGsXgHwudSrzku6kvihR1vjF09yycQhGbI6d2AoqrTTeKnR9kOXDN+OTHxCmw5VXW3ILCB4TKTJyKrjEC6z1qAERObzMxgqkBrdmy290FsIUQQ3MrOuf1O4hbZ0RJ0jNWly3kPSYwXoIKIV4ZD8lA7iwIkm3QwD1NKllMFdTnR+ihkqv4zygIDEvRMCP21THsjubXo6CALi6hd+A0D3osn10m07xEJKblrXyW1nx5i2WFJDLsKW/IQp0eZjN4Au2tPgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X33VrTA8ZEyzUgtNbdx9RHevLeQ3yTwlT2mVN4Ui8+M=;
 b=RSqP5nEYSUWawRjSnlWbUFWIPBlMIGa5ZeMumxWscMpv+95OsYk7Gfd7s2O6BVQUE42h8Cj3soFWHh0nZs6Voi1rDxXfLXDDIje56Nb8bM5TnoN6dEPILR/lX7NsjEOF5frJMokkigAgq6WVJ3uYKbGxa/KmgRtFdL342kxKlbPUza/sBjBtaPzWvmQxbJX7vx9wQxaCbHa70ZJbKkI7esIVlJGQrCUdimFSSu32rIGv8FIawp+RGiKUa9znk5j0S25r/erdLfJ4heCF6TMLV33hx6zGsBqwZBAF8mUvJox4xFQP3fe6BINthMsDg4nO/ocHT+ZRXP+hk1WvRWnPfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X33VrTA8ZEyzUgtNbdx9RHevLeQ3yTwlT2mVN4Ui8+M=;
 b=LJjAVQ3zRGwyAHcgX6ts1TxuB9cg5cFE7ounUpgUK3+CgLUAWcyh+8beJ/3NTIN7gfwaBS2X3Ll5MRL0qc77pKYZYotDcEjaoFv5a37bREYhIG9jsDBZJ3UD01pkzsWyzNFx7TO5xuV9cK94IZpoX9fUJ9H4Mc9rFuapuLeySQo=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3713.namprd15.prod.outlook.com (2603:10b6:a03:1f8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Tue, 25 Aug
 2020 00:43:49 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 00:43:49 +0000
Subject: Re: [PATCH bpf-next v1 1/8] bpf: Introduce pseudo_btf_id
To:     Hao Luo <haoluo@google.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
References: <20200819224030.1615203-1-haoluo@google.com>
 <20200819224030.1615203-2-haoluo@google.com>
 <35519fec-754c-0a17-4f01-9d6e39a8a7e8@fb.com>
 <CA+khW7iGs=tN2FT=rEiPZMQ_Z9=sqhRe4dY7dKbVoViwX666BQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <84cf7c65-bc39-f7ee-0eff-022699e9d776@fb.com>
Date:   Mon, 24 Aug 2020 17:43:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <CA+khW7iGs=tN2FT=rEiPZMQ_Z9=sqhRe4dY7dKbVoViwX666BQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR15CA0017.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::30) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR15CA0017.namprd15.prod.outlook.com (2603:10b6:208:1b4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Tue, 25 Aug 2020 00:43:45 +0000
X-Originating-IP: [2620:10d:c091:480::1:75df]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 324ce935-baf7-4878-5e85-08d8488fee21
X-MS-TrafficTypeDiagnostic: BY5PR15MB3713:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB37130B3FD0459993D5E0C987D3570@BY5PR15MB3713.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FuVu+zH3bfRcZQNIq32WYzGd9/QhUD/qNhhb5NdMijGB+y2c1wWplUh9Vq2XTLomGjF97SQL3CM+NeeiKKDqP6oIUpvaQ7+2XqxVSzMBd0AVllJtLZ6NGKOlXmoENUnMnxXIPtO0YsE7TYkbH5csXRA8fnyjISo1vLLpJiH07OdDiI9Tzq2GVF9fcYjCw9KwFZAVvdGQzDBsTe/4KF8ky5dQlyTrXfDdjNQLnnzd2dJOyFNbtybFq/xYJKNWJxS/qUSvhq259l+BCRStpwlW7jXZIIa1L8vgfYKfQVK//LvROoycPskUY2R6IZ7bBdltOERRqmd0UJ8hMRa07my5h/wyB2/bh5EFn1XlNeCUF3DSMAOwG/xo2u0xSawMHc3C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(376002)(396003)(346002)(5660300002)(66476007)(956004)(54906003)(4326008)(66556008)(52116002)(7416002)(6486002)(31686004)(478600001)(31696002)(86362001)(66946007)(8936002)(16576012)(186003)(8676002)(2616005)(83380400001)(6916009)(2906002)(53546011)(36756003)(316002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: KpdzDUais/geCuYZqMrqE6hy1nAJkdfq33DeFf4KSs79DDi+F1ZBXGAKjsLIwnt19S1NfgUmDIo8fWoZfHDrlGIdyUfkKzIOd+Z+xTPVhGhqV0InX7S8xt+yYaygYXA0A07QliDRxybWQJnx2eX5IpyqEnSsZBnr700oQ3rLsZ5Tbq97zGs3zqNnCZWoeQhsImNPfAJgA+Zb4LzzPbagvMM23ZcBnR+m6hqZ7jv2CIjdHrdMdycjhnGwKiRxJT4U19zxqnfHUPdoLnlYfvE6DlEMcN6gj8KVHs5dtQRF9Uu1o2EZbm4ksEMkEryCMWOW1XhOoi6c6VR8XqnrUdrQbQV2ufBU34X4zNa8Gvz2FOCWtQcIWxzdctzlIqZwdUHI0r6F5fDa7q33oHZqTaloVF2x8dJQ6lpTSVtow/05qaWqWB77bQoLDE0U+PMbBpFq9GJXtWz3sL/wJyS6GUvC5YhLsGgOWkR8AbiTjrJYOPSWXILbGwDNsdx6RgGCg/zwN9EV5PAHPnKVLsjByIuN/z31ALRbSBzPJw+lw9nswT/rCLOeDp41RC2tecZAPNFqCbyIa1MoQFulRJTybjd9j6iy0nGfdcYsFcqOGDbg0FQ4unrNuUw+HojUiEj1SAlab8Tq6X+Flb62/TqnP5f7y4Bqs6kcbkwjMdL7I0lh+K2z+pQZG63lYyFdn1DoSAxT
X-MS-Exchange-CrossTenant-Network-Message-Id: 324ce935-baf7-4878-5e85-08d8488fee21
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 00:43:48.8860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Td7L242/WJk2130d+3ibjzGFRAXHOhPQJwJ3OB1tGa76UtMZafmbSU4lIPo70fTO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3713
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-24_12:2020-08-24,2020-08-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 mlxscore=0
 spamscore=0 adultscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/24/20 5:05 PM, Hao Luo wrote:
> Yonghong,
> 
> An update on this thread. I successfully reproduced this issue on a
> 8.2.0 gcc compiler, It looks like gcc 4.9 did not have this issue. I
> was also using clang which did not show this bug.
> 
> It seems having a DW_AT_specification that refers to another
> DW_TAG_variable isn't handled in pahole. I have a (maybe hacky) pahole
> patch as fix and let me clean it up and post for review soon.

Sounds good. Thanks for fixing it in pahole! People may use gcc 4.9 up 
to gcc 10, or llvm compiler (let us say llvm10 which is the version 
which has CO-RE support and is recommended for compiling bpf
programs.) Once you have fix for gcc 8.2, it might be worthwhile to
check a few other gcc/llvm version (at least gcc8/9/10 and llvm10)
to ensure it still works.

Currently, by default kernel is using DWARF2, pahole has a good
support for dwarf2. I am not sure whether it supports dwarf4 well
or not. But I think additional dwarf4 support, if needed, can
be done a little bit later as dwarf4 is not widely used yet for kernel,
I think.


> 
> Hao
> 
