Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB7948DDF2
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 19:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbiAMS7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 13:59:30 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12316 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237683AbiAMS73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 13:59:29 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20DHIFW0000802;
        Thu, 13 Jan 2022 10:59:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=X2LI8ZFVjeNjlCT7qe0DiJPU7TG7xCItp+oD05rRN5M=;
 b=RR6tRJAgxgcKD8Vomh4YDCbBvR8aX+7+vvTsfPVAfGZ1opXyYkoKCc1v6DDNX+5tZj2Q
 uIDXiXAGw4/wnVaxVCBxhGtrIlogtivFkmCyXC/NNPB/Sbi5m/T2IfsIL/9TPQ9cXRmK
 bvNAAKTeon+LGtJHOGDmQJZdmK0oL8osCzM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3djaprvqwc-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 13 Jan 2022 10:59:28 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 10:59:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BF6z+fsTO7+cI82xjoHUa+IiuBRR8SoqvLyarxnw+chtRdXz+RGfQZ1Ei232keZu9yEhnn1KWS70/TAmMxbIwPgnab76WAZAKAF6Aj8sIf9hrCFqgwh1frd9nsDx0ysXiI+s9xtNc5OEhKwrfJ9SFPkOVX14YrqEVhgss+sxx12RTbIj3Migbt2AH2lL9GLQxb0+5oGYL1Sa5VuCdZrJk14eCNScv9dCxiVEbX0UYXAeoiCPloLPfsYvRYsQVNhScviFb4DhMELaC8c5ybCYzi5aevZTcRq7OaG6sYgnXyVPbM/vYKuZRpIYXBs8WIwZLp0gq4ZiVtGOtP4KsiQ1iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X2LI8ZFVjeNjlCT7qe0DiJPU7TG7xCItp+oD05rRN5M=;
 b=cJqJHD26dA3CLP0qXL+GpRqhH2qMlPA18Aw8xtOdJOqx3AEKZXJhuSqSHaKN5AJOOmvChoQWC+4XXZo0DvWtHsgMKT6/bHe9/juGuMQwsox48EdWWtiYYQpdkKwvUfmqv3ML+5Jrt/NdPDep1XTAdtJwFqwD76nNFlwx+FCflC7hZ+t7FxXw6FLQphx3SrKnq80wbCx71oGiPT9ws0OFb86WRth+yD0hQa04V9LUtdXZlmguQm4nB5PUOysSXuIZ4/XelkHHcskOh2pR3DZN+8OrQy0aJW6YLyx8k8rbGBXmNwBz05kmFNeVp/CVF8j4qh4EdBAva8bfmTFVUZXj0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB2411.namprd15.prod.outlook.com (2603:10b6:5:88::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Thu, 13 Jan
 2022 18:59:24 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e%7]) with mapi id 15.20.4867.012; Thu, 13 Jan 2022
 18:59:24 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] samples/bpf: xdpsock: Use swap() instead of open coding
 it
Thread-Topic: [PATCH] samples/bpf: xdpsock: Use swap() instead of open coding
 it
Thread-Index: AQHYCJnPDy4utsIJUkazfv4sYDNj26xhTiYA
Date:   Thu, 13 Jan 2022 18:59:24 +0000
Message-ID: <15D65AC9-F89D-4BA1-AEF7-DB111FE1165B@fb.com>
References: <20220113162228.5576-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20220113162228.5576-1-jiapeng.chong@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c9b7a94-b0de-43b1-ba79-08d9d6c6d09d
x-ms-traffictypediagnostic: DM6PR15MB2411:EE_
x-microsoft-antispam-prvs: <DM6PR15MB2411979BE20C4A651077565FB3539@DM6PR15MB2411.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9cbd8UWI8Z74wjUkYRrhlE7v/3aREhaAqqtXvwxZ+mHgEZg1AFbBbSYUybHz4Ofr2oQOS5dI3QRjI0HjLGOZTRnDy5yWM9TpQZl6OKIzHnEVCQe2qDtt0a7dCG7tuWbeo0HDmuySluBA3zfZtBbWWrGNlYncm2uY8SP3Y+mJXNLOjlRXXvzrczL3CtNwdxMSHy5eBSbUMDn2xuL4KZnTVxUlz/a4+dJOj8CzR0gIcCGsgSZVf40cb3CozkF64gUuP+7VtLSaqHUk2O1A+JUk2RhkH0Z2P8+hve3/5v8bWh5hsuqoy2MAkZoD6JLQQ8GCEmgb66qyfb/3ZaZhDVpwuMOHhDMxO2Alh4/TDbIRL9DvDmqzfAxbaXnBbaIRc8Ef3abuNdy9EfAlOr0yRIstxC4XoJ/h1az9YlVVICu/vVYey2yYhaW6cuEyLvSeSR6gp/2ZybEGW2Y2pxs1Ogm1t2tI2d0oDdYjIQGbp51bHvAwMrjHLKtUpl5sIs+67TsnX7DEKzhq0eMBLuvCiM8EFT7DwaSbsicMH0LYeS2XVnm/Nlhb8WPqj1OqwrtHIeNXfEzVOYQv8p+/HjlE/l1tZ0rxzrRrY/vfcEUx0s0Djq/AFWMLG8xKcn9s6F2pzZzbRQ0otzIByrgox18KofF9JvMrIa667IxX4xBqsVNZKrfge9M3KMwRZYVwwUPl5RCCzlhJY8VDbleDK7UXDnQTrOfNWhgZ+SaGgMKxFpt1oxX5W1Cg3aWBUic/gD5Sqcaf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(64756008)(508600001)(6506007)(54906003)(5660300002)(6486002)(66446008)(6916009)(66476007)(33656002)(316002)(4326008)(2616005)(71200400001)(6512007)(186003)(53546011)(8676002)(7416002)(2906002)(91956017)(558084003)(76116006)(38100700002)(83380400001)(122000001)(8936002)(86362001)(38070700005)(36756003)(66946007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vJsqHJj7J4xLHhhy1LlpYAwZhuaTfWio+zera/dedvCTUH0uTus1kj+CVf+/?=
 =?us-ascii?Q?oZZecvr1C2EGPYqjLxTbEVRcQt2dvETz1cATn//SHL7Ipqq2Dwn68nsBo5ox?=
 =?us-ascii?Q?sFx9NrTmi5pr3excy4o4O6iQ8OEN5iUc8RO9vs8ChpMb3i75UMy37ItCGmtU?=
 =?us-ascii?Q?OXtjY7coByYr48KGbVALk+uRhir60zyh7WdKhvKWYt0uCVpIYLH5EZBNRoPp?=
 =?us-ascii?Q?b99A8vFcNTAzco3hwanXdP2R5iTlEkLwuyiLERaOLgYksR+TuVl64Rau61We?=
 =?us-ascii?Q?Nnk8840GKtBWPK6dCLair4wHgp2af+CCb9/SZ5pYdz02JkxDoFOQQEv6tKuz?=
 =?us-ascii?Q?fvsoL9o5qqNQ2YRjHZB7AyRuYJiwrY+gHdhKC9YvZllEx/eID5JlFtQHz8AD?=
 =?us-ascii?Q?ZRGXSlufuV1fxketJit+szaNbDF3slfqy0q2PGBAxHd2WZ7BYJwe6MeoW4UC?=
 =?us-ascii?Q?8YqVbmvFmB+E/W81ghG9o206o33k9h6YRIb2LkCj9Mn+yuW7+OmPLq4rtz6b?=
 =?us-ascii?Q?85NxQsIaMvYrRvsYRVhhIgpmmYDQ08O6Vz4NO38bveBHI2eHCPDVjRowryKv?=
 =?us-ascii?Q?DsnJ1hhe77XY31iJrguB7UletvVUBKVCd8h1DGmaAB+naWiZ7bp6/K/Kqn97?=
 =?us-ascii?Q?B3vJNL0Y67ZzIC9/0lsI+IzZ8Tr+hEj+HaeuOO0/5CcgRXqDDJi1KFtnDBWY?=
 =?us-ascii?Q?dzDXKXXMegIBDj7Qum1aTts4Ybx0pLI00eBJEs5q4yzr0UhURHp/qa5HKDxN?=
 =?us-ascii?Q?6tyJW0yXVEnIqo9LqVB1iCC1pgT1AIEKKPjjK2poWLqVIfkfeaVt2xipGCpp?=
 =?us-ascii?Q?jM35kqE5p8CSqSSneSnAxJa1CPSgJkXlQWpNmUlNjfCP46AkZpvKjbg38CUW?=
 =?us-ascii?Q?xjDWgNH4VKM6LWZmuVR7ZB40A0uMisxGYcG6k40MMSefRRA8Zbc1Bd+c1Nqq?=
 =?us-ascii?Q?MSAq0HH+tJMpIFlk4srH1K5Z26UlZwgMAy/Lie8dvq6TLNKxXXjIcsD7wMfh?=
 =?us-ascii?Q?sj9Ak9YpOFpiXu0idB7Tv/4UjjfkmhAHMY5f5J/s0jHnHreDZITjxFGq+jtY?=
 =?us-ascii?Q?2EhU/ljwGpm2jmVyztPQbOleh8W8IXeitZ5DEhrRaf2jBUYHnHJL8wC0wiuP?=
 =?us-ascii?Q?H48R3jR0g47yHDT7XYlieNhuAU187m/0RxCkbeJ2k82m/30yviGqnp+hNFCF?=
 =?us-ascii?Q?+vygsVDytd78fI1trVff6PDBnrqlT22QaHO4m1ok6dKbA7QZ5vaiY3opMJIK?=
 =?us-ascii?Q?n2CEFxcMyk8xWPLGDtpux73QJSViJqO/5PPT+CaUk/6iLPgwmKLyfwKikqbz?=
 =?us-ascii?Q?75q8htGCJwB8b/CXuGPrRWzEGBTJdk6Wc3/y7tbqBrstX1EWApMAZL35ouql?=
 =?us-ascii?Q?98OG2o+DamWNTcx9HaosDKOsXQF6wDd59qe+xSq3J9kttzEPWFhaQpqWw14I?=
 =?us-ascii?Q?GAvnKeKMHa9fHRQANwhtKgLatygqjk0q8k9zlI+RgBF/tGQWNjQmWmkFpKpi?=
 =?us-ascii?Q?Nx+bTpbvuNJW+/OgDJaINGDEf0nIPfpKDGw5F/GqaY+kCDnwXyP4W7M9GJC+?=
 =?us-ascii?Q?VRXzwfKPXi7qKUlFFbtK3AfK9NnZ+Y+EfrSOt00lUCXHx+w1FIZLZO9fa8wU?=
 =?us-ascii?Q?p4uGvx3npGwYWBtCCyrdB9HAJIEnAAfai+5+ibHRt/RJpRAefN+Bz25/Aqoy?=
 =?us-ascii?Q?U+GQQw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3EA9C26153A0F844BBE60BE9F5DA479C@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c9b7a94-b0de-43b1-ba79-08d9d6c6d09d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 18:59:24.1189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oG8lx3dhSxI45qm95NhXgSjtPfotYr1nw8k05GWTZyNUgh9wZBJvOlEDvvmzf19V8tUyD6D2Z8/J3xcp/weCHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2411
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: J6fP54F6YnFbeKjUui8eUbry5m1kIrFv
X-Proofpoint-GUID: J6fP54F6YnFbeKjUui8eUbry5m1kIrFv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_08,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 suspectscore=0 mlxlogscore=993 spamscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 bulkscore=0 clxscore=1015
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130119
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 13, 2022, at 8:22 AM, Jiapeng Chong <jiapeng.chong@linux.alibaba.com> wrote:
> 
> Clean the following coccicheck warning:
> 
> ./samples/bpf/xdpsock_user.c:632:22-23: WARNING opportunity for swap().
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Acked-by: Song Liu <songliubraving@fb.com>

