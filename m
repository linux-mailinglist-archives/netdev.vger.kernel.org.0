Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96188352082
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 22:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235522AbhDAUSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 16:18:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34156 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234783AbhDAUSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 16:18:09 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 131KHtBS001896;
        Thu, 1 Apr 2021 13:17:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=1HxTgflJ3Hfge1EPfEuDGUuBJqswvdXgSk6HrP+6JaQ=;
 b=BisSNQc8f2TscSbQmHdECrak7dCv3tBlHF9BeZxPuwBxagDPm6IxGlCFkww3C3mjchj+
 nFbvzHcChS0H2tXF8XioI3xLm9mGUG3n+NzTHZk0F3XW1/rHsTH4qgYdRvC/Z8evTump
 8y63njP1l5cxDaGydO3fYx8D+bYzkFIY10w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37n2a669yw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 01 Apr 2021 13:17:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Apr 2021 13:17:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrbWtN7WgWXL7Via598G2of8LssoIcwjWRiK9jAm0N33m5CGxseU6XcD2V2t3CjwIoZ2qqGsWUheeIou2XSMK0glGQePO6mhsfUzGEjlspB+ud4VNbcnsyku4pTzAAWmzDEuYJCDeRLQOcdwO5phOh8Qf22cDGAVRlMp4CjIFGy/bF9lpd90F/+1UTI4R58+F398Jd1ULH5QkUX0wGb9lLhL+vjNytGKNSAgzVQfSeRinolql7ndsGjUtYxogQ9A4yzJKSThbhbuOv0gpXyxwNeTYbVnxXh8c0KC4cfSwRKDrmLquQEe8ERce9UBaQ2yUIa/0WE/Amc8kkm4YN3+Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1HxTgflJ3Hfge1EPfEuDGUuBJqswvdXgSk6HrP+6JaQ=;
 b=oQHe3I8HQZAI4k1wDJc9KAZZr0T2UW7kMzLGWQowlZXlbvTdCsrBnHnk8m78uh86ElAT+Nt8I4lr06SAYAdPfmUJq9Ca1Ig5gtGcG8AdOXKasffGsYe/eyZqNr0Mzj4M7qVJrkpum3GYXTaTxv08+oe+9EC004MrqkNpgN6vs5xRX6eb6r6ydD21+zpmnQGbMZO0CPb4HusNuISiS+98EkWuJwxnOOBkJVB29cEtoKpSEaDxEC/V1ysOKA2pRN8h/k2+AIPneIdtpkandDnv7g9/MS94G1foZBt2Pv8mJZ8Qj0fTqCJnwPwqWumfTFGoG5fASaC+79ABy7vj2dgWxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2197.namprd15.prod.outlook.com (2603:10b6:a02:8e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Thu, 1 Apr
 2021 20:17:48 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Thu, 1 Apr 2021
 20:17:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>,
        "duanxiongchun@bytedance.com" <duanxiongchun@bytedance.com>,
        "wangdongdong.6@bytedance.com" <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        "Cong Wang" <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin Lau" <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
Thread-Topic: [RFC Patch bpf-next] bpf: introduce bpf timer
Thread-Index: AQHXJq9GCj74A7YdlUumCh5fgR8tjaqfNeUAgAC1hACAAC9hgA==
Date:   Thu, 1 Apr 2021 20:17:47 +0000
Message-ID: <E0D5B076-A726-4845-8F12-640BAA853525@fb.com>
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <B42B247A-4D0B-4DE9-B4D3-0C452472532D@fb.com>
 <CAM_iQpW-cuiYsPsu4mYZxZ1Oixffu2pV1TFg1c+eg9XT3wWwPQ@mail.gmail.com>
In-Reply-To: <CAM_iQpW-cuiYsPsu4mYZxZ1Oixffu2pV1TFg1c+eg9XT3wWwPQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c1d1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d708814-6dbf-46c7-922b-08d8f54b37c2
x-ms-traffictypediagnostic: BYAPR15MB2197:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB21971B5ADD9F09806F5CD49EB37B9@BYAPR15MB2197.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XirkMNjKQixkWEaHv41yvVz7TE1ij4nWq4QWnDLY1LHT8fnefvGDvYBdLoHbeJVNL19eLUvO0KSeHzf1FI5ux4MDwUWy/WYy4xvdV8Pcd+RtHpConCHSxvVgncFMk8nZ0PazESp3TqGw1a1nensu/do+jOa7jNu0+W0XsyPKz8yAG4GE9BKScjIJ7gR4q5bmImKOaZMD5eZglpU1sJY2BKwdmJ+M8FTxe2YTngroeX2bfRhDKj244vgnwb4jWTdyQnzYzPKQDdmV2B/Yw/Sg1e+HQQdmlRDLUrn3+HX+2OgkFfU4LOpDnqVVHGo09bWfQn+ppbzYlx3j/VH307+AX9QC+o63m2JJJpRXHSLW4GwecAmiUH9F1u9n0U2yInX8J1gkGFH2Bu5gd2z78RKiOicLcd/GQDFr7loV5rmLrc98aWWzRAIqrtRsrpPCXUa8/wuXmtH0Y8hNelZNAEKf8FGGPbfBpX/riy/In9p/dfAYJH4Z9XEqxsSMqAz6vwGaZ4W+FO5uev9dxB6kkoyMqMCgj6q2Q/qau5GIIfMQNJfIXca4pGav6d+mHnkkTUhxnFQLfCu/XexrI/T6fA08W00/iBB86A3ktRHIlz+lbCWT6vG05ruxd3/i1G5Gvovv9MJOvCZDCi06uHMWW4blhJU5i6483jkGaEIVu/BwdhVjb9lwXqmNpBc08Q4CGpfR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(366004)(39860400002)(66446008)(5660300002)(4326008)(478600001)(66556008)(6512007)(64756008)(8936002)(86362001)(6486002)(7416002)(6506007)(6916009)(76116006)(53546011)(33656002)(66476007)(36756003)(316002)(71200400001)(91956017)(8676002)(38100700001)(2906002)(66946007)(54906003)(186003)(2616005)(83380400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?nUG8YlWHxTXV0zgWmTbdoUsLZ5Sxo+o5bSMDbNCLhKERSOyN6KSqyjjG+JdZ?=
 =?us-ascii?Q?cx92/t5kuzXN82RKT+aHblDsx1LpqmVIhs7eeyqDtxD81qLzIQ7PEgXJChPt?=
 =?us-ascii?Q?5G4UDms4R3QpZO8r9mdfKsrM2Q9ZtfAhCqMcsGNaizGsevovqmG8NKxzeiCh?=
 =?us-ascii?Q?qwbc5WJCNtN9BG8vYMszNFuiC4YPKuRwkcNTp9JI6F7vhzwzCEjEoKT7yQSS?=
 =?us-ascii?Q?1PoLoT5fIYtSlXWNX/99IXuom3wt/ekU2afKe4ST1xT1VliTZ+yIdUlUYiR+?=
 =?us-ascii?Q?Z8abs5e+axHi07+XYmy5SxuvE48FxwfF/S6XTWlz+02i23Jkuekuh40FlCe9?=
 =?us-ascii?Q?G+Cz6MLlDVAW3ZKx20cVyOv5jfPaGzJosdVl6lvn8TGr3jgOwW/v/DmH58D2?=
 =?us-ascii?Q?YNAaDjAsbm0FvPM88HvND0bW8LDS/06VN41t36eb/BUlRCDUrp1aPjsuYQTF?=
 =?us-ascii?Q?+kDjcBFZbFO281ey3fXMap87Wrye73UGDWCL6KKKBXpIVj9uX5FrVA/p6/Ww?=
 =?us-ascii?Q?/1d2s1DEPEMtI42lxl7LHEiUNvl2y9czjYxLZwJQF3vfR+S1vAoUIOWdsgGC?=
 =?us-ascii?Q?5F5ZQCGRYsxJSzvFvImOTwguN1Hl0F7xzbzyQWSDCSqRFcGDYy1+5gaY2RD8?=
 =?us-ascii?Q?AzPzmfoUZLc77AXFRu6LaBZiloeFinihYFyVZKHKvneHHw8tgPLzF2gjW9OY?=
 =?us-ascii?Q?lk574NLJUgYEtOfbyAEj5I/V8IghV33GZouAkgtCMB3YvgWlta0kjmjvFMIb?=
 =?us-ascii?Q?B1muR2xDy7Ob3OoEjOtfOsEwvDmrJpLWFwsEbsVCtHjL1BWj3mX5hUb3b3s4?=
 =?us-ascii?Q?NC+0yqc6nazyZdHDFkHV7Lkd/hX+X4etXAjZpqIf9uEjLnnAvNQRqPKBWiw9?=
 =?us-ascii?Q?h9tXVsM9uyTcm7xESWWshgjJjTgkOTefrMjXJFo41cHBzrSrja6Cbcb4Shrv?=
 =?us-ascii?Q?dDScJeLjoNU1sTN0eM76X/yG8EYQwJgLUR54CfFVnTBrmj6ppNm+pyNacdu0?=
 =?us-ascii?Q?5A5h6QtvIckIfbuyrE+dIIsmkzl7vhoN6B9A/3z8iWENPTwkn93uikuLBVUx?=
 =?us-ascii?Q?621QuEPP2OMHgqQZnXde39RFnvxRsGsgRYpnqu46G2EX2JWxgc/uzx0x7i5E?=
 =?us-ascii?Q?YUVYQ8eRWq3eZmftUd2rrXfxP927nzR44atgQzt00ocK4rxOJpdtVoaeZ3iQ?=
 =?us-ascii?Q?xUVDmihgBzOp54dVf8UIy9oGwi8JCUI+cwdTHIBUMVtiuLMvsfq/tN5pZiNq?=
 =?us-ascii?Q?49iWEJGygf97y6RxcQhQ6aixt/CCeymnqTFS6WoT3VLbv4DyoW3PxZCdBghL?=
 =?us-ascii?Q?NCCIm8BfRMhk8Ep0p7e4PwMtckCjhXSzzBLSG7SFwk5vHYBsJKHij7fDtuLv?=
 =?us-ascii?Q?UWAYtyg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BD88F824825A0D43B385578DDD1B299F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d708814-6dbf-46c7-922b-08d8f54b37c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2021 20:17:47.6857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pAwcic/5UV+fRJvcxSwzP8ZEzeXiPHBH5z/oSTRV+tipngqZwCTkfFWhhApzwxIN320YRw8Dl8S2X9MDQFWZdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2197
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: wz0sCmYydJMSnTRrTWbBhDe3WfpAhwTg
X-Proofpoint-ORIG-GUID: wz0sCmYydJMSnTRrTWbBhDe3WfpAhwTg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-01_10:2021-04-01,2021-04-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=0 impostorscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 bulkscore=0 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2103310000 definitions=main-2104010131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 1, 2021, at 10:28 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>=20
> On Wed, Mar 31, 2021 at 11:38 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Mar 31, 2021, at 9:26 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote=
:
>>>=20
>>> From: Cong Wang <cong.wang@bytedance.com>
>>>=20
>>> (This patch is still in early stage and obviously incomplete. I am send=
ing
>>> it out to get some high-level feedbacks. Please kindly ignore any codin=
g
>>> details for now and focus on the design.)
>>=20
>> Could you please explain the use case of the timer? Is it the same as
>> earlier proposal of BPF_MAP_TYPE_TIMEOUT_HASH?
>>=20
>> Assuming that is the case, I guess the use case is to assign an expire
>> time for each element in a hash map; and periodically remove expired
>> element from the map.
>>=20
>> If this is still correct, my next question is: how does this compare
>> against a user space timer? Will the user space timer be too slow?
>=20
> Yes, as I explained in timeout hashmap patchset, doing it in user-space
> would require a lot of syscalls (without batching) or copying (with batch=
ing).
> I will add the explanation here, in case people miss why we need a timer.

How about we use a user space timer to trigger a BPF program (e.g. use=20
BPF_PROG_TEST_RUN on a raw_tp program); then, in the BPF program, we can=20
use bpf_for_each_map_elem and bpf_map_delete_elem to scan and update the=20
map? With this approach, we only need one syscall per period.=20

Thanks,
Song

