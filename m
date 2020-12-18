Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78892DE801
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 18:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731672AbgLRRY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 12:24:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44830 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731339AbgLRRY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 12:24:29 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BIHJKUE031133;
        Fri, 18 Dec 2020 09:23:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=S8XRe0zLCCtncgy20gW681AFW9CPO8//bSmOFQqX2uU=;
 b=W0I/l7F9/9sK+CMYD6wK9fdEgu1YiaFb2jR7OtH4ISOTNyd8J03UaQA0tLFZweF+CXiX
 dt82w5Ed5kGujzR4yRTrUfq6RfJysgDfwV3FvTaue1vO7ksCHcfd1R0k0GZiw7suBdMw
 Rh3OrtFDCvXKLSrMu0VuXjSt7J3WiNKDHxs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35gbrjwn8h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 18 Dec 2020 09:23:32 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 18 Dec 2020 09:23:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktwUWeDN5dnh6TFk4fGrMbAER4dIymOSuJ1GVLckGB3SfIQ+cKVhfI6yEL4qRRBsGkzci2cKNzK/CKI/cpn+XPxL5aX9VC8j7nVWkRQtrsd+GOoNleohcy0x89osROYvezWnv6L+Ta+2rH5On4FKXaig4dDL1j1rEMnK4wIEkNCKmqFhhwbI4kWHkOZLe1LRTAHhb5bSjuXK+uGDX3Hc+ucWzDcpUDvrF7bcUI/5IYpg39DzRJWEirUP+5g7KcMVa+oC8cq7xr2IjFXhLy2y9s1KZaaC6cktnb35ylzNgXtRVGcOJRgOrXeUjCzO7TPv76TbtulAJqlYFftnGFgyOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8XRe0zLCCtncgy20gW681AFW9CPO8//bSmOFQqX2uU=;
 b=mldVgoarn1lZZtkmNdlnq+S0SGSgaVNMC8h9rx7NUeTWe2j66idUR62+4+EwIS+7tP7sfdkIlpGLbXf0rvfO1u1C2CfYqEBpnxz6EnvUXhZFWU5ETBWd77TUb3FrStz3O5QA0kFGcHMM7gHdr3SYfPjE9BpvGVDkkiKXv10Rj0s+I8ScBR0N1XOyjDAJSAOwF253798t7NsNzXXbN1BHTLOm56Jf0/EVbj4ofFamj1lyNRTNTOv4aPPTQDxrSjTxYPUQBPlakmaM4GuS0m1bv07Asp1taAftfYk0DtPoz6r7vKjV3Dvoy8eC4TCHdAjcOwtSZhqKv+iqbxGTW25i6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8XRe0zLCCtncgy20gW681AFW9CPO8//bSmOFQqX2uU=;
 b=gyvdgPmk8GQCVJpTxZkaiAelLQRqR0k7KsJfDXa/l2CjQncLdB1FqBwyvPN7aFQrP20N7syoHOG+2npSp7Q64VdKBCnZMxIyPIFEkvoJXYDb1HU0jNxyMf82KogJVhsYYpF398wrWvBdNrL4BucUE9YqYXJMUOIsQtDR3Dzw7f0=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3620.namprd15.prod.outlook.com (2603:10b6:a03:1f8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.24; Fri, 18 Dec
 2020 17:23:25 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3654.026; Fri, 18 Dec 2020
 17:23:25 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Topic: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Index: AQHW0zs42cd9AcJBNEyi77fZmX7Jx6n7qAwAgAAzywCAAEpiAIAAIRcAgAAOLwCAALyEgIAADIEA
Date:   Fri, 18 Dec 2020 17:23:25 +0000
Message-ID: <09DA43B9-0F6F-45C1-A60D-12E61493C71F@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-2-songliubraving@fb.com>
 <20201217190308.insbsxpf6ujapbs3@ast-mbp>
 <C4D9D25A-C3DD-4081-9EAD-B7A5B6B74F45@fb.com>
 <20201218023444.i6hmdi3bp5vgxou2@ast-mbp>
 <D964C66B-2C25-4C3D-AFDE-E600364A721C@fb.com>
 <CAADnVQJyTVgnsDx6bJ1t-Diib9r+fiph9Ax-d97qSMvU3iKcRw@mail.gmail.com>
 <231d0521-62a7-427b-5351-359092e73dde@fb.com>
In-Reply-To: <231d0521-62a7-427b-5351-359092e73dde@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:eed7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ff6a11e-47a3-465e-d6c6-08d8a379a07d
x-ms-traffictypediagnostic: BY5PR15MB3620:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB36205E5D06D63961FC57C4A0B3C30@BY5PR15MB3620.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VbRQ2aV80ShhOihAvak+ou2sXohYLoCdll5jOXO+WIATrNHd+1CXSWRFn2cyjQhPlyp5jyHOdD58nPbks49UFYkXwmZAAYQzTDRGvSwlbFzMi6iafVrzTQpog4/mmXE5iqYiJBIZgScMmQ1FeUdovKQMGwziNQkgoF5B2AOXgipvZfpW+vYppJHxCwOSRa3B2MOHmPz06TaE6dKXBhvbJWR0yP7DY7+1c5v13yUHUW7ZSw2WzNJ3DCUBdxzy+dl4KlLEdIwu8UE0mS+CHO35Cd7gf5TLgRa2qM1KphFTFqrkwiQCUQ4BQxyN9da1Tjv3Y+UR9ZEiaciyi6kdrLFEB4L8CvvngzSwGr6EH9LNgFzABFeVY1LQSrysIwD/HJ5g
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(39860400002)(396003)(346002)(83380400001)(66476007)(64756008)(76116006)(37006003)(66556008)(86362001)(66946007)(33656002)(71200400001)(6486002)(6506007)(54906003)(53546011)(6636002)(66446008)(478600001)(36756003)(4326008)(316002)(8676002)(6512007)(2906002)(8936002)(2616005)(5660300002)(186003)(91956017)(6862004)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?bkzbPgn9BO/WQ72jkiZ1tML2dMtd/KDQt65zgeUKmYfaH4HhzjGTC8WZdRCe?=
 =?us-ascii?Q?dfnXTcnyO/BPBXwbG/PUj6c8jRvUeBemkT5Ylm8i8ljs8CwAeytHM35lp+S4?=
 =?us-ascii?Q?G1cUBxyQGN6IhsTqVD32t2S1dnv/2JfcXXwnkU0/r44mEp029bfVIT4jF7OE?=
 =?us-ascii?Q?VWSodH6mkGxgbUZzTVNsAoo+Qh9QYHUhl37xBXfYWeWSgMPNN9bh5QdtI7By?=
 =?us-ascii?Q?RqGesN2USiB+J183upGgpLedB8YnYR0CHc8WVqxSb+UiUeU5soPJu4cKhEqV?=
 =?us-ascii?Q?D9WVdCha4YeIyMKGoqxELYlH+5tYLa6jk0nUmAQg1tn0a8d6haH+eRJOvb2O?=
 =?us-ascii?Q?S4sNQoEI07GN6yxpJ9PSsRwvEVHHTpUSVKUSK4C9hZ7cab/cPY34VrxBJyt/?=
 =?us-ascii?Q?u2P4RlXwOrZnLCVk3IFnjLaH7cG3Olf8DJ1jIuD1exH5BK0h7rbEd/56sqYe?=
 =?us-ascii?Q?0ZgyzmJNqKUtMXvOd4q9S06FVOOuOasRCTmExxGJxgkQj2owzs09NRPz4lKF?=
 =?us-ascii?Q?nI1jwQPu8UB9lkjk4Et9//HiwhQU+CYH96QxNHKWWI5Y6SrpYvrtdHbWinYQ?=
 =?us-ascii?Q?SUDa2tt3yYcLaqKgx9VUkbY+I/WswLbQ9KFIb1C69m8q/RW2n8ZpZ51+kkiG?=
 =?us-ascii?Q?gtzTubUSQ/Vpx1zO5uHiZ7hQmmNV0j1SCRJheMy3l/oT6ZmFpunLSle7SY8E?=
 =?us-ascii?Q?dMchqUerwzyWlCN4H1V44QWJ3tlQmav5nNypuTohLZDILdjXlcAPb5itDAUz?=
 =?us-ascii?Q?+aqa4dUwe34p+uz9oJgj7VGMSEjNKI1nEx+HjORu5unZz86FM5JMUwRDG53Y?=
 =?us-ascii?Q?4wPsz23400buRJWY6+grGkRqLJGapS3fKxt+bjPwpOeK+7hNy7ODe/DvFTgp?=
 =?us-ascii?Q?tqF9hc9eiLuelW+OwM0UoSqdJ2/7Hg0gIAuXvN7CjpJMB3Iy17F+n+xqUlUw?=
 =?us-ascii?Q?wVnXKuYX8W+AjvStM7+bpygqqlZfADWtQH5sFAdn02bRg/7I5d/lF93dc4yE?=
 =?us-ascii?Q?GKq9z7Ija33FcAuc8K0biZVTetv/39NAjb/1iyZUE0tyJb4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D1629BE0C569D84496E72520BCDF873B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff6a11e-47a3-465e-d6c6-08d8a379a07d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2020 17:23:25.0867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IarO3wnqkRytfuN7nRwSCYEZpraIU4CTFQloTvF0oJ+GlP3Q1kXJydKRXfyUF56tLW90vR/rXPzdBcpbk4jmNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3620
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_10:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=977
 suspectscore=0 bulkscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 mlxscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180118
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 18, 2020, at 8:38 AM, Yonghong Song <yhs@fb.com> wrote:
>=20
>=20
>=20
> On 12/17/20 9:23 PM, Alexei Starovoitov wrote:
>> On Thu, Dec 17, 2020 at 8:33 PM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>> ahh. I missed that. Makes sense.
>>>> vm_file needs to be accurate, but vm_area_struct should be accessed as=
 ptr_to_btf_id.
>>>=20
>>> Passing pointer of vm_area_struct into BPF will be tricky. For example,=
 shall we
>>> allow the user to access vma->vm_file? IIUC, with ptr_to_btf_id the ver=
ifier will
>>> allow access of vma->vm_file as a valid pointer to struct file. However=
, since the
>>> vma might be freed, vma->vm_file could point to random data.
>> I don't think so. The proposed patch will do get_file() on it.
>> There is actually no need to assign it into a different variable.
>> Accessing it via vma->vm_file is safe and cleaner.
>=20
> I did not check the code but do you have scenarios where vma is freed but=
 old vma->vm_file is not freed due to reference counting, but
> freed vma area is reused so vma->vm_file could be garbage?

AFAIK, once we unlock mmap_sem, the vma could be freed and reused. I guess =
ptr_to_btf_id
or probe_read would not help with this?

Thanks,
Song

>=20
>>>>> [1] ff9f47f6f00c ("mm: proc: smaps_rollup: do not stall write attempt=
s on mmap_lock")
>>>>=20
>>>> Thanks for this link. With "if (mmap_lock_is_contended())" check it sh=
ould work indeed.
>>>=20
>>> To make sure we are on the same page: I am using slightly different mec=
hanism in
>>> task_vma_iter, which doesn't require checking mmap_lock_is_contended().=
 In the
>>> smaps_rollup case, the code only unlock mmap_sem when the lock is conte=
nded. In
>>> task_iter, we always unlock mmap_sem between two iterations. This is be=
cause we
>>> don't want to hold mmap_sem while calling the BPF program, which may sl=
eep (calling
>>> bpf_d_path).
>> That part is clear. I had to look into mmap_read_lock_killable() impleme=
ntation
>> to realize that it's checking for lock_is_contended after acquiring
>> and releasing
>> if there is a contention. So it's the same behavior at the end.

