Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC9431804A0
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgCJRSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:18:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48760 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726283AbgCJRSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:18:49 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AH1MJb013481;
        Tue, 10 Mar 2020 10:18:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/TCGgFrGY32uS5Slae0Dl0gxIaZCpjbyWpvn7vU2oQI=;
 b=hBUODJJKx++VzFE9uQ736ZSkstLGsO047mpGDyqUetKMW3ToPi9bWnio1Ree09np/Ihb
 n4gauOAoOBuf4ghXBbYbuBnEsp0u5hAg9JcFpuKFzrDXJRjrGFE+p+v/irM25kaJ0mAI
 Rzol+DE/0+hGgy77PRIYOGuOhj7B6+6StaE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yp8rdt1j7-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Mar 2020 10:18:18 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 10 Mar 2020 10:18:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kdDBS+qAMS95tBvfbZ9cFP8X0HeMtTbEXssuP3UrqMtWq5LTcACrA1Tp0nuh25O68CVXBatJLuuQhQCFily72cLe+vPvtXMukuV2FbyEO9H52ljwvBIzsKhYvpRvoR+QEAuxZJtUdi4J2jMAlQDLNTh5vOM4ohA03tMdo40rcBOV4YBHt/zmeTlAl9ga5sXOq0m3ZNiQb0fIkWAEaAdDIEnDo/uRu7PyrmsR7eSLcnLAZBwUtVf0gRDNceJ+WLh0YXaWwuTzjk4Iq/dmkOgE13mHuw6EDh30/T3ojr+kzxmXVcbXWlGhWXswDYdxG+wUvPo6LiZ1nNEEd79biiPLSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TCGgFrGY32uS5Slae0Dl0gxIaZCpjbyWpvn7vU2oQI=;
 b=A//lEwcfT0Jr3rK7qIP9mwHHa9EcjFHrZYU0w7lynYgDbwZ1VBheJu3wcHMi5tqCxppUHDJj1Ja43y0Qm6kqEjfWMqVlp/XJmVK1XCHDC3ze9EILIbZIXBzQbMiQrdDcqunBG/IDS8feb2p/dampP555Aw6vTKfhCF4mY1plpoGcfTcFDxLkhrVhg7n3lTx6RxIMgJZGAG145ZX+SD3Ta9FL1dCXCElqGckeADLV7LsjoojCeOnJzjc/jHnhHIkjJMd2cD+850VYnsXBowoSu5NwaB6Nx9fEfY24DeBtH4G6klc+f9pAkQJZYupMnGA9UfHNktzXKVXIWNpxRKvNZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TCGgFrGY32uS5Slae0Dl0gxIaZCpjbyWpvn7vU2oQI=;
 b=d8vlt8GrpqILgxCUtSf7F7i//Pxt6mN8C+t7GjeWcT+SB0vaMJkm0BEwUOsfJwJWF+GHJ1Qx/qo/Ogg0Q22HhvfT2qgfmhXs5zduZec6TU3xfxPa8x3sXYmS9NYQ+cNNZ1Kk42jWfN6euL4au/KZujiceyuW/GLzqZnTzZVBqrI=
Received: from MW2PR1501MB2059.namprd15.prod.outlook.com (2603:10b6:302:e::24)
 by MW2PR1501MB2188.namprd15.prod.outlook.com (2603:10b6:302:d::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Tue, 10 Mar
 2020 17:18:14 +0000
Received: from MW2PR1501MB2059.namprd15.prod.outlook.com
 ([fe80::25db:776d:5e82:7962]) by MW2PR1501MB2059.namprd15.prod.outlook.com
 ([fe80::25db:776d:5e82:7962%3]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 17:18:14 +0000
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
        "md@linux.it" <md@linux.it>, Cestmir Kalina <ckalina@redhat.com>
References: <20190828071237.GA31023@krava> <20190930111305.GE602@krava>
 <040A8497-C388-4B65-9562-6DB95D72BE0F@fb.com> <20191008073958.GA10009@krava>
 <AAB8D5C3-807A-4EE3-B57C-C7D53F7E057D@fb.com> <20191016100145.GA15580@krava>
 <824912a1-048e-9e95-f6be-fd2b481a8cfc@fb.com> <20191220135811.GF17348@krava>
 <c1b6a5b1-bbc8-2186-edcf-4c4780c6f836@fb.com> <20200305141812.GH168640@krava>
 <20200310145717.GB167617@krava>
From:   Julia Kartseva <hex@fb.com>
Message-ID: <8552eef5-5bb8-5298-d0ab-f3c05c73c448@fb.com>
Date:   Tue, 10 Mar 2020 10:18:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <20200310145717.GB167617@krava>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR15CA0041.namprd15.prod.outlook.com
 (2603:10b6:300:ad::27) To MW2PR1501MB2059.namprd15.prod.outlook.com
 (2603:10b6:302:e::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c082:1055:817:11ed:82a6:c24a] (2620:10d:c090:500::5:3a0f) by MWHPR15CA0041.namprd15.prod.outlook.com (2603:10b6:300:ad::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Tue, 10 Mar 2020 17:18:13 +0000
X-Originating-IP: [2620:10d:c090:500::5:3a0f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9e4ec4e-7942-4735-0290-08d7c517044b
X-MS-TrafficTypeDiagnostic: MW2PR1501MB2188:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW2PR1501MB2188AECB2F3EF17A18E5522CC4FF0@MW2PR1501MB2188.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10001)(10019020)(136003)(39860400002)(376002)(366004)(346002)(396003)(199004)(189003)(7416002)(8936002)(86362001)(31696002)(2906002)(7116003)(36756003)(53546011)(54906003)(5660300002)(966005)(6486002)(4744005)(2616005)(81156014)(66476007)(81166006)(66556008)(4326008)(31686004)(6916009)(52116002)(316002)(66946007)(3480700007)(8676002)(16526019)(478600001)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2188;H:MW2PR1501MB2059.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PRV3+KTON5JFibIrNUXsB9elxE10e7wyJdoh/YA5Bf4PngEimcdxGrNkKqGZ6PJaq2s7siM4hF33OVoCx4azT/S01avROwmY2dtniUxcW0eJ3uIrNAa5ERTEwzBRco3jaTIIjaJ2pxYJljX9TPztgbn4avmVX88WwZpso52W+SLZ7vmOVvPZcB2rkfoojjCa9uPJ2Z3kqJcf+Jn8XIN9Hdc3wXAdtYaDyylkuozFHyHm3ipViuAXjBQmNsbsK9sYSOjQopkjB53bEQObVHqbf2mvemgkjYNtgYyhYgXPiLBBPHzoUOSDLvpywW665XsY5n0Bkc97uS2OLs2/vbzJS295XxW/zr4MgkaGM4qxPqVddYOIH8WLpCCk/9QIKsta50+yNgukG0lYUl5BbBK6RWSUwCjqvBdh2HJg9zqTlTH247dJkqtuJRtYah1Q/lE8MsYyD59C1PySZT/NBMKWjVtBSffv2x+/dcRoOyB591lKdc1eAOaXYnkjsa/2jy4wGFcGXZFGDAKLHfGJJrm1GeuaBQm20olDCGGfjjaQW01QrjMFIyjywoUE0fsatBir7ExuQ157jzD/oT60Be/5nQ==
X-MS-Exchange-AntiSpam-MessageData: pJGEjejx1HMwlp2Kh7dY7e4W3Ml8y0gjEhbWl4FsfHAGzU9b7iGAmG+M3QBg5TKPRZPoybhPhpdxRK9ACVT32AbXi6bfdpYIW4m4aozi4jNvHcKaxi88o9JZmfuOEdeF7uR05Rj8rZrNbNsm5947g/gS9ZCGmnUjtkGIrB+KjssrS9zf1Ghc4X7gYV8V9Gc0
X-MS-Exchange-CrossTenant-Network-Message-Id: c9e4ec4e-7942-4735-0290-08d7c517044b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 17:18:14.6656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +AraNFv3DtXZZ54wi/2iGNkmzuIQIUe/nQ4L3gz7cA4MJNrPDfGFgSptBi5J/4Up
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2188
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_12:2020-03-10,2020-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 bulkscore=0 suspectscore=0
 clxscore=1011 malwarescore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=869
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003100104
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/20 7:57 AM, Jiri Olsa wrote:
> On Thu, Mar 05, 2020 at 03:18:12PM +0100, Jiri Olsa wrote:
> 
> so I did some more checking and libbpf is automatically pulled into
> centos 8, it's just at the moment there's some bug preventing that.. 
> it is going to be fixed shortly ;-)
> 
> as for centos 7, what is the target user there? which version of libbpf
> would you need in there?
> 
> jirka
>
Hi, that's great news!
Nothing prevents us from having the latest v0.0.7 [1] in CentOS 7 :)
Can updates for CentOS 7 and 8 be synced so the have the same libbpf version?

[1] https://github.com/libbpf/libbpf/releases/tag/v0.0.7
