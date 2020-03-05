Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 358E8179CC7
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 01:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388518AbgCEAYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 19:24:11 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6228 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388407AbgCEAYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 19:24:10 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0250KK4U004218;
        Wed, 4 Mar 2020 16:22:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=JSj1r+OjxqNJNP+bxemy/qzHF2QlUUvlPwJzI/wSNic=;
 b=TJ4fz7g7G8QbI8D0DyvdxHhB/fAlQy2Xo3ecvVu8syEUcr320gvY+B185iZryRoBV5NT
 PgGkJQmilU1jIGb0ZlhuX6vhdtR+AsMHzzQguZ5aB4hj2QpfoSj4QmgB6Nx0O+RkIB9i
 yiu0osZjpxjnfmj2TbInKqI+bgB6KjauxlA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yj2gj5u2e-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 04 Mar 2020 16:22:54 -0800
Received: from snc-exhub101.TheFacebook.com (2620:10d:c085:11d::5) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 4 Mar 2020 16:22:49 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 4 Mar 2020 16:22:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3T8VH39cywZN935a9+MAU+lJL8RSVyZqVOlVkZK7dmM3noT3+bJOL+th0v+mAjnhNqNkvFtlKtoLqwMYtb1fY28eIH2R4Rlwc0qpd9ZN9q0R+HOh6IxvEDVeiD5F1bcIQ/VadQjXUPk9lCxdSJ1+kDADO23qWBceslEiT7cndxmLcNrWrEy3mTaSeodOsfQtISIi0z03vdp845lizlvNkkJh5+yzDgbE2AM1NBFovopSQ9zI4gzRiYRMerXJzdSrNiacx171BfQLrX2bHqLRzZfmDLoBb1RHk5U0CqISVSZkb5TK+yNzEtVKAEaI9XUEKT/ksjLisVdeh7HrwfG2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSj1r+OjxqNJNP+bxemy/qzHF2QlUUvlPwJzI/wSNic=;
 b=Dhtq0ySH6mGdfGiaLZpEVBAiRwMCcMCDmvPJfHteUKqbW9BDJNdZt2cI5GHFilPQE4texuVfkOTO8mURxqAzzT+qPloeNVN93uekq7SeN8U2rBDvI95rj5nFvz/+QnD7RNTgoF4QgPhgv5f+/nhixWYn17C8UdMdjutozDh57sdObON3i8EdIGrOTVUzH9yEkGOodo+aRCT7oEr1CmmL1scNUEtvUOwx12/8+laxAzlDEMDLks9+tomqt36zp7040Iay2c94L9DIAaFukFHGiEb/BT90ptNcLmldcdz4QEbBK5afIOjupwLvhSIskTrQs/hSzrNt6REup9IjbBZsZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSj1r+OjxqNJNP+bxemy/qzHF2QlUUvlPwJzI/wSNic=;
 b=VffvBTvZHcPu5GhZr2SaQgRJ+8dbNdtNY0XSwW4x2kzSgekayqhuBRixrl/gN1G3X6B4vviH6kbOjTqlwQsULtXsbfR4iOOK75K2VtRFFZrFC90d0qVmY5NU696szFJcOAi0hxnzRqEPRhw6y9R/JXxfZaCB80WP9QXr4H8b08k=
Received: from MW2PR1501MB2059.namprd15.prod.outlook.com (2603:10b6:302:e::24)
 by MW2PR1501MB2140.namprd15.prod.outlook.com (2603:10b6:302:3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Thu, 5 Mar
 2020 00:22:37 +0000
Received: from MW2PR1501MB2059.namprd15.prod.outlook.com
 ([fe80::25db:776d:5e82:7962]) by MW2PR1501MB2059.namprd15.prod.outlook.com
 ([fe80::25db:776d:5e82:7962%3]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 00:22:37 +0000
Subject: Re: libbpf distro packaging
To:     Jiri Olsa <jolsa@redhat.com>
CC:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "md@linux.it" <md@linux.it>
References: <a00bab9b-dae8-23d8-8de0-3751a1d1b023@fb.com>
 <20190826064235.GA17554@krava> <A2E805DD-8237-4703-BE6F-CC96A4D4D909@fb.com>
 <20190828071237.GA31023@krava> <20190930111305.GE602@krava>
 <040A8497-C388-4B65-9562-6DB95D72BE0F@fb.com> <20191008073958.GA10009@krava>
 <AAB8D5C3-807A-4EE3-B57C-C7D53F7E057D@fb.com> <20191016100145.GA15580@krava>
 <824912a1-048e-9e95-f6be-fd2b481a8cfc@fb.com> <20191220135811.GF17348@krava>
From:   Julia Kartseva <hex@fb.com>
Message-ID: <c1b6a5b1-bbc8-2186-edcf-4c4780c6f836@fb.com>
Date:   Wed, 4 Mar 2020 16:22:35 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <20191220135811.GF17348@krava>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR12CA0047.namprd12.prod.outlook.com
 (2603:10b6:301:2::33) To MW2PR1501MB2059.namprd15.prod.outlook.com
 (2603:10b6:302:e::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c082:1055:817:11ed:82a6:c24a] (2620:10d:c090:500::6:2507) by MWHPR12CA0047.namprd12.prod.outlook.com (2603:10b6:301:2::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18 via Frontend Transport; Thu, 5 Mar 2020 00:22:36 +0000
X-Originating-IP: [2620:10d:c090:500::6:2507]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fad7300b-cf10-48df-ea18-08d7c09b4f0f
X-MS-TrafficTypeDiagnostic: MW2PR1501MB2140:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW2PR1501MB2140BDC84EEFE8D27A8F8FD2C4E20@MW2PR1501MB2140.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03333C607F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(136003)(396003)(346002)(366004)(199004)(189003)(53546011)(54906003)(31696002)(86362001)(4326008)(316002)(8676002)(8936002)(81156014)(6916009)(36756003)(81166006)(7116003)(52116002)(66946007)(16526019)(6486002)(5660300002)(66476007)(66556008)(3480700007)(478600001)(31686004)(2906002)(4744005)(2616005)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2140;H:MW2PR1501MB2059.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zleC5EIEsgYWYL4kcGkSKzQR2pXFPd30VC3omsEfZPmvnqGntDCsaFtxKZ2a0UROM7LamyEgEtNnexFeSEUTA0ixLQCmJBHlUrEvWbFVqZN6d0/pkQPzjr5b+gcuQir6xiuOda6x3QeA/Yibsp4ddQuZDZfuSohox/s7dRU+5a8L0VU/f8LmF5rfHOlAVjDh7VkHYeslqGfF7ZlAUadamvYIIxyCp+Lqs45ZQPjTjg7lhJpBL1lfiCVaLbC44RlKH03Z1fZvCbbaxgCk/ZPu0/3CVJrXgNCSx27i+DvAw9FIIZz8Z2hSuqnxAPn6BGCe32fsu0I/1I2TjDn8vHONj7gZKs42I+7ZBsBRZJMKBmgi7aNLaPmruvf+Fl87f+JbEOdKl/gRfnfwM6p2SyVvMH1y9CUvqpE/ckACkih2gNM0rIxh0h1pavlHEUomq2ee
X-MS-Exchange-AntiSpam-MessageData: AJOKaEMW/rzrGlCNNffxGixdqH7a4w1VYuupUEdDn+lzeW/Pd0KxLwY+dIt5BmMIFfGqx5C3ukcna5BB4yBXjWvTfQXDtoibMzFT3XlF1BzjfCeDdUCJvMyujcpoq1NrGT8IG69u+V8LNK2YAbPaOt7KYQbpz3VmaxIYTUS+Iet82+oyjgIMxpzGSr1nQVKL
X-MS-Exchange-CrossTenant-Network-Message-Id: fad7300b-cf10-48df-ea18-08d7c09b4f0f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2020 00:22:37.8129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sCs+CP20JWMLUnRAQ85fVeNEXot4jxNox/FTwP1ykklsqYtBM4nPMHohHIV5AAJI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2140
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-04_10:2020-03-04,2020-03-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0
 adultscore=0 bulkscore=0 phishscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=866 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003050000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/20/19 5:58 AM, Jiri Olsa wrote:
> On Thu, Dec 19, 2019 at 09:37:23PM +0000, Julia Kartseva wrote:
>> Hi Jiri,
>>
>> 1. v. 0.0.6 is out [1], could you please package it?
>> 2. we might need a small spec update due to zlib is made an explicit
>> dependency in [2]. zlib should be listed in BuildRequires: section of the
>> spec so it's consistent with libbpf.pc
> 
> sure, it's ok for rawhide, in fedora 31/30 we still don't have
> latest headers packaged
> 
>> 3. Do you plan to address the bug report [3] for CentOS? Namely rebuilding
>> Fedora's RPM and publishing to EPEL repo?
> 
> I did not get any answers on who would do that internally,
> so I'm afreaid I'll have to do it, but let me ask again first ;-)
>

Bump :)
Jiri, any volunteers for Fedora EPEL 7|8 packaging?
systemd folks would appreciate it.
Thanks!

> jirka
> 
