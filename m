Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26DB3549E1
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 03:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242710AbhDFBIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 21:08:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12888 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235769AbhDFBIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 21:08:21 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1360nNbA014629;
        Mon, 5 Apr 2021 18:07:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=pNUYB25wfxxDwogZBWWiS0l0Zb0t/9mj01sWxlUe/iI=;
 b=odoZ8i2ONm1VNB8sBxXmqQaoRcraRz/QPh5PblqsPrY673LMJC7JUTUoUySFzwz4k1UN
 R+V4Uk7weUPPPRatb+iLMM4yp0UifVKSJM4YTBiqO53Tf0xm3NtO9JEATth3zgPCgP4g
 deCf3hc5inQrKoL4ZtAXEHBZrBtH9ubNWAs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37r2vn35yh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 05 Apr 2021 18:07:59 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Apr 2021 18:07:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPrAV5XjPnBF3UPlxnrncYT/8JWqxEB4d0yzYESgDrlJix6lG7pqy7YCIIOzck+ioyXvsziIYkKPlyMspk+dMmI1xb90t9Gp5qM+htzara8p33MUjAtie/omIkHNp5XeIfXXobsVDG2qxQgWD9AxyEemMxNUit0HKvlqZbpc9rCLSCp3gDwYZvazw+ttNFrGOSG3rsiN9VIvxXLTB/djzeW7lRPXMOddH18ztqvsEihPeBqqbBApAu8yvWFoTi0bgkDtQhqDO0A/IujAMOaB7BWzXRLXSvVeARVl3yu9EFovwOOCs9wbo4u+ztOEvkPW96jSl1UMmsW47PTCiDdHRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNUYB25wfxxDwogZBWWiS0l0Zb0t/9mj01sWxlUe/iI=;
 b=XiugGUIG63kO1yGdQ128y6BAA/zpiRpGJdDcQf22bdQgp0LrNgJcnjWVTfumSmRWYrn1FwvkG/hli9bN4ga+O72BMRhtipRV43Xz3og0kxFDhgE7OZuGcnFECe3cDnpUGG3MSQj17ajKiYh/AMDVqdttTf9IrFksf3utik91MLViWA1Gu1bfrHq6lz7W6WMIHVPH0LUgcnK1JkYXFw6566rSUXUttjFRt74IeEKexnptwNZgSDT9hfxhPXAlTXO8eSyGLBDnSLBTB3QZtKh5YBxeDIAwIFQkKi412+vdSV/kfQVY75FOqB/NRcJA7CJ8jpzEZTv9Ayra2+QZVurLDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4233.namprd15.prod.outlook.com (2603:10b6:a03:2ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Tue, 6 Apr
 2021 01:07:57 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Tue, 6 Apr 2021
 01:07:57 +0000
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
Thread-Index: AQHXJq9GCj74A7YdlUumCh5fgR8tjaqfNeUAgAC1hACAAC9hgIABZM4AgAAGWACAABPLgIAACd2AgAAUn4CAACsBAIAEvAoAgAAV7QA=
Date:   Tue, 6 Apr 2021 01:07:57 +0000
Message-ID: <DCAF6E05-7690-4B1D-B2AD-633B58E8985F@fb.com>
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <B42B247A-4D0B-4DE9-B4D3-0C452472532D@fb.com>
 <CAM_iQpW-cuiYsPsu4mYZxZ1Oixffu2pV1TFg1c+eg9XT3wWwPQ@mail.gmail.com>
 <E0D5B076-A726-4845-8F12-640BAA853525@fb.com>
 <CAM_iQpWdO7efdcA2ovDsOF9XLhWJGgd6Be5qq0=xLphVBRE_Gw@mail.gmail.com>
 <93BBD473-7E1C-4A6E-8BB7-12E63D4799E8@fb.com>
 <CAM_iQpXEuxwQvT9FNqDa7y5kNpknA4xMNo_973ncy3iYaF-NTA@mail.gmail.com>
 <390A7E97-6A9A-48E4-A0B0-D1B9F5EB3308@fb.com>
 <CAM_iQpVZdju0KhTV1_jQYjad4p++hNAfikH5FsaOCZrcGFFDYA@mail.gmail.com>
 <93C90E13-4439-4467-811C-C6E410B1816D@fb.com>
 <CAM_iQpXrnXU85J=fa5+QjRqgo_evGfkfLU9_-aVdoyM_DJU2nA@mail.gmail.com>
In-Reply-To: <CAM_iQpXrnXU85J=fa5+QjRqgo_evGfkfLU9_-aVdoyM_DJU2nA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:57e2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 887e65e4-705a-42dc-207e-08d8f8986a60
x-ms-traffictypediagnostic: SJ0PR15MB4233:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR15MB4233A8BE60216FDF0FD6479AB3769@SJ0PR15MB4233.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8//pLHHWnQ2E3a+jNr/4SmxI8Dn9Bbxb9D6bpTGqAbdj+7tB9+SUgks0SVgWWPEAEaUBQ8dHrh4Pv1Jh+8HmVNNZwnK80G+8EaZzDocrrESXnIX/0rc0ebT6dpWPwmDJD7j5q3mXWzaL+9euY0INGrMQG/aJbffH61AW+TOrpjL8RarkXhS8EfOFpbiz3j38AYtYRrvXBVNUoIDSxaC+Z01VhX2uOcHlNpdTKKKqLqc4Ttai3Igdw3x2cPB+gbP/XAYV68+2FC8V5be+m7wC7j+GKs6xSfcuZSSqDEwF6MCkhF+Qh7yMdgd5l/zvbMz2a5R0gjH7ZIF1pAJCiP0K99ReqNo+1/FGQU4HOhqINDFLWuqpEyyLocQkzGUQT8wmd5PkScxeF7+O56+FppS2x57pyEOuJbi9mQrKgITkoTv1EZKpzmS6ul9e3KTV96UXefeeijzfvZgtCfTuH+qE3s+gC40tCZUsA/TuG8KZx6rg5lOMwwDFUm6U3sk45i36X2w51BrlRqITotqCM3XPRDyEcY4hc1hx/3Da4VjYVuyAI+/BBJFO/Oz0Qui0HASvusxcC7/kzOKJPv0SNcC+LGWSvLwCrwomh1CyzxsDUOp+ZDv4I+gHQWwnHM4wHW8N+cxWzGaW+QjzwjWzgqM0z9hiVG/AkitAa+ElrKTi4Ad9YP733mCpab8RhoIi2njW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(136003)(39860400002)(6506007)(6916009)(53546011)(2906002)(7416002)(8936002)(4744005)(4326008)(6512007)(83380400001)(478600001)(54906003)(36756003)(71200400001)(66556008)(76116006)(66476007)(66446008)(64756008)(66946007)(91956017)(2616005)(6486002)(8676002)(316002)(5660300002)(186003)(86362001)(33656002)(38100700001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rta8Tma4u7j0oXBmCtTrznS1FnUk3s3wCBy2IyRvgt7wtXX3HyPC794OOT1k?=
 =?us-ascii?Q?VqruYhtnGfx39WhQunltMywwLwmsx46/zE646xKXMTaDD/W0AZprvALSKYl+?=
 =?us-ascii?Q?PWzJ1ewsWkm4Y2DzzGpT28lEg70GoJZvfOxYB6FQkAoGruVOvRKzTrqmPxgx?=
 =?us-ascii?Q?hztMzOVBgAoBfHwdlvQXqc0NUAw18HF/slCckomFciGjNylwsutRkmKb6tCl?=
 =?us-ascii?Q?gQ2fCq4nOoaBSfQdXtW29iIEOJWD1MnmoADpHvdQ/IgtlcWK9zJ08jCA2DHW?=
 =?us-ascii?Q?qwluBNhtsru1qVAwZwe2paeOXHnPOnweucuRrtJ5P1wJfsQ/LzWEAlmiPhmo?=
 =?us-ascii?Q?WbiKNZ8Z1VasxrMoU6/GhaFaiY7Ud6tQR93zWZPbXVPt9Q6Fvrp0PVqouoxX?=
 =?us-ascii?Q?xdLM0UuBm1VKJ1V54OVuWV81kMAonvssPnjjwlZGRqD3PZw3HV3l6lMToo2d?=
 =?us-ascii?Q?0N5GUEh+8ckMWB9y5VRtuYF4zsQHjU6ct27WavfD8KLECELj7Xn+WdLGocA3?=
 =?us-ascii?Q?NMxXtAPmL8BxCjaAZAX6/zXwQzMxWTdaYsHQ1GCfzwL6KA46u7xkhKT2Vm6p?=
 =?us-ascii?Q?L1O+uxkBhfiMAnTVKYc4P30VfaTHfe8sqbuKIoLD/SssY6y3aFjgcqKCmMRW?=
 =?us-ascii?Q?/YjedK/bcyhnRNRZMVNoXwGOpth7RUE1+JbGOU4xLJkpVUAGN0S4ic08RBRt?=
 =?us-ascii?Q?x3a4sxV38hUgtihxwXp3E8q3yv78xkl+2HiRsL5mfomrAOe54CjnvqizfmVG?=
 =?us-ascii?Q?gIV8gc4ACistxfIq6O+9Q4MDmwpKZ3MA9NVoDEyl9TQrCoyv5iko0hqiX7Ry?=
 =?us-ascii?Q?DUD8/x91OovaYXAaYCWFNnBgtRaneinGbW4b3k8jBu88Nnc/rptK1CzzSGRx?=
 =?us-ascii?Q?px93GYmkLPHVA6GLx4HFHL7GnG7khX8TfVh5zHHnA1mYQ7WRmXMc6HCeDocG?=
 =?us-ascii?Q?nkIBsqJV8OhQgpVTWXULFHRoVUwvcnVik3aChIW54IqxhfY0O7d9fNeJbebY?=
 =?us-ascii?Q?2vz8UBUMfQ7bMb0hJXRvEbPtAv6guFz7dU+HmTL1JDWy0ejqQLnbKk0c1Epl?=
 =?us-ascii?Q?R+9mbRA9neC4eABarbOAD3xv5uUvWvMi6pmD6dYPySGPSGDbzmsXHM91G+bX?=
 =?us-ascii?Q?zZlDSphkAooZ9LQXf5spPM5xmt+YPQrK4p9ALtzoaA8KMvyU0Kf1HRdZ4kBT?=
 =?us-ascii?Q?jf4GUt2YBur8FkiOgJBzkQCT+XmeOTPpZQa+GUR8Hmy1NzpVABGNj6j1pX+f?=
 =?us-ascii?Q?8I0swfDEG0IHkfEW8Qzv4XCvz0jHZseQf2yD4h3KmQWbO+vPLN3qpGaPRr2U?=
 =?us-ascii?Q?onM9ogVMa++guDtmv5pw/bs/bfo9pJCR8JbDAl1OXk2dIoo8iCaqC0SZ8lsR?=
 =?us-ascii?Q?zIteQIw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8507AE79D4364C48B8BDE24A702AA698@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 887e65e4-705a-42dc-207e-08d8f8986a60
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2021 01:07:57.4308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BI6ztFRnrIALb/dXI4bQ6pZvkiHz98quFwyNsKi2/uJB4thyHOhf02KhvjWpyYs/xYazkwqmhyNvmiNMvvLXVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4233
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: HgvRFp7ocZrSE9YY8fo_KlnDCEVQJIpI
X-Proofpoint-GUID: HgvRFp7ocZrSE9YY8fo_KlnDCEVQJIpI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-05_21:2021-04-01,2021-04-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104030000 definitions=main-2104060002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 5, 2021, at 4:49 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>=20
> On Fri, Apr 2, 2021 at 4:31 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Apr 2, 2021, at 1:57 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>>=20
>>> Ideally I even prefer to create timers in kernel-space too, but as I al=
ready
>>> explained, this seems impossible to me.
>>=20
>> Would hrtimer (include/linux/hrtimer.h) work?
>=20
> By impossible, I meant it is impossible (to me) to take a refcnt to the c=
allback
> prog if we create the timer in kernel-space. So, hrtimer is the same in t=
his
> perspective.
>=20
> Thanks.

I guess I am not following 100%. Here is what I would propose:

We only introduce a new program type BPF_PROG_TYPE_TIMER. No new map type.=
=20
The new program will trigger based on a timer, and the program can somehow=
=20
control the period of the timer (for example, via return value).

With this approach, the user simply can create multiple timer programs and=
=20
hold the fd for them. And these programs trigger up to timer expiration.=20

Does this make sense?

Thanks,
Song=
