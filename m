Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04E613D095
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 00:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbgAOXMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 18:12:43 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22684 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729922AbgAOXMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 18:12:43 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00FN4vSa019218;
        Wed, 15 Jan 2020 15:12:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=WHn58j9UPnPJq+c4rsCMhlicbH0ucsdNGv4ryzy3yQ8=;
 b=bggaf45c95yJnuQ7wYmMGeVka0Rydt6bNI5Q1IdvLD8bZ+CTljMqSGK0MISRLNO0hVAe
 CMfpjw94YLBxuvXYQmigDAfLNDR3u4V8p5VMDdUdPb1/Ht5+YhQMzA3aU7ysBa2WtTDS
 x7VFoa1M5oobFNLDg4rwV6B+iDZcivtERMY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xhgwufet1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Jan 2020 15:12:26 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 15 Jan 2020 15:12:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGQJ+KWfuJjqRIRpJJMJUmzuaRoMYBY4tUpQV6EdFMFof70y8hQYY2h3tOs9RUMkwYZ2VoralCJEjxMM22FoKPyzMSAaMYEb82L3nOGLGj+v3/S7d6psHCntERkg4QgfJOINTR0cjdsUEu/QuTNyIDcBWyBC7kmzx6Ru1pkobtFyMLPSw4SKfkCiA0sewlC/uwYjatFq8pzK5W4YLL8KE3FAfUHK6FEi0niZ+hwGX0r5yp40Fy6TnWIFY/BrGbc2m4wTpBctgnIx0X4gLZ2UDlls4+R/33EOIrYhrSwSi3aY75KU7opAIC4CfQzR1WsmHhHygE19/vQDAuGvSh+IBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHn58j9UPnPJq+c4rsCMhlicbH0ucsdNGv4ryzy3yQ8=;
 b=bT82aqolfjvVIEwkmpxSAj7f7ddJaMyaknsbvR7Bmf2BbIg+gO8NAsY0hgXWN4+G57ZvtADQg76nMxFcVFoFqYzQouogIi3+dl5rizTFDPaVk94da2848mIaf81WFFTDp/vieupShx9BPHHlQm3y4rGIrRO2YJeC93iP2o5CBxBpI3ZG7qTqDRR8xbX+rNd0jh9zQGOSBE1/g/3Nby8z+cl6xaPsVOdrWea9/4jcqQZl9cMWrL5PtZdgEBrMfqFkiEj3kU/hgNvzrVvgKTTJE6wM3fsHpPu/DgK7mMr9vaI6k2n66EpXgYBhpk+37HASA7v+eCyKj/KiirL67gGK4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHn58j9UPnPJq+c4rsCMhlicbH0ucsdNGv4ryzy3yQ8=;
 b=Jtou7zvKwCrcv0cOLTjkBUUdriCk0FplG/ahE4YfqUzsKmIjGN9bvh0yjCt7XZq9dpaH2xZq7NQ49JJBa1EffkY3vcXjUSZsCXwlR2JMxvf1Ztm4iryh6HEjh9R+K4YpfI9dJNTHgizhnyU22FtndlIVyWUcHc7feIWhF1dHawA=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2909.namprd15.prod.outlook.com (20.178.253.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 23:12:22 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.017; Wed, 15 Jan 2020
 23:12:22 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::3:951d) by MW2PR16CA0009.namprd16.prod.outlook.com (2603:10b6:907::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 23:12:21 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 5/5] bpftool: Support dumping a map with
 btf_vmlinux_value_type_id
Thread-Topic: [PATCH v2 bpf-next 5/5] bpftool: Support dumping a map with
 btf_vmlinux_value_type_id
Thread-Index: AQHVy/Wi/rEobTqQmEOESUirDOtKAafsVEqAgAAC0ICAAANygA==
Date:   Wed, 15 Jan 2020 23:12:22 +0000
Message-ID: <20200115231219.ajxqzbg2khtgmql4@kafai-mbp.dhcp.thefacebook.com>
References: <20200115222241.945672-1-kafai@fb.com>
 <20200115222312.948025-1-kafai@fb.com>
 <CAEf4BzbBTqp7jDsTFdT60DSFSw7hX2wr3PB4a8p2pOaqs18tVA@mail.gmail.com>
 <20200115224955.45evt277ino4j5zi@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZDnaYswB07s2HSMQ4D96LuqLwVa4rp3gwi8a6chV2Zog@mail.gmail.com>
In-Reply-To: <CAEf4BzZDnaYswB07s2HSMQ4D96LuqLwVa4rp3gwi8a6chV2Zog@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR16CA0009.namprd16.prod.outlook.com (2603:10b6:907::22)
 To MN2PR15MB3213.namprd15.prod.outlook.com (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:951d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e074de0-620c-469f-d41b-08d79a10605c
x-ms-traffictypediagnostic: MN2PR15MB2909:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2909EEF500E48B160AC3EE6DD5370@MN2PR15MB2909.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(39860400002)(136003)(376002)(346002)(189003)(199004)(478600001)(4326008)(9686003)(2906002)(5660300002)(71200400001)(64756008)(66446008)(86362001)(66946007)(66556008)(66476007)(7696005)(1076003)(55016002)(16526019)(81156014)(54906003)(8676002)(6506007)(53546011)(81166006)(186003)(6916009)(316002)(52116002)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2909;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ptvnpjPyS0cFLPUeQ8uaR8QDOQKMBqvJCUH6qyvNswuvRC2ZkADia+yoVubDF6a0fHDQk3tflQMA1PM+CUHQb2FXi+TJSCdkCBFksAAAA6Tqwpf+qzsdfZLc29RPr+kU0GUCbiS6He7BN8LUaFYe+9AijFxcXd8jCxBiIhT8m/B72y6yWa54xmPZPbjACYLJdseBOiG2POHGAqaDJ3vHmJzbqZdCSxSUdeGukOfcApkkPWHwXtb/MV1/V+N8rYa/I9G8bN/2G/2zDdJIhIBMjd8xvEt4cTDBowTNlN1cA8iS9dbAr7anef7jqW25hAt7n1LOK3oLBAUSUar7i3jEKRnLLBWbBZbQy3R60ztqEhMKAS3x6wcNAn37mbV4h4qf05QL/IHggbcEe3aM3DVWqw+3HQwEKBN5pp83+R3MyIq9lffWgFZqMR0oxZ8GUD/b
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A4E58BDE15D66B4CBB8EED805FE9733D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e074de0-620c-469f-d41b-08d79a10605c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 23:12:22.5363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wFBcOAvSZVdWGj297pmMRf30YkBv0cdsj5WoL6QFLVVoiZ0SqDUr7z2ZV9vQsE2P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2909
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-15_03:2020-01-15,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=580
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001150174
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 02:59:59PM -0800, Andrii Nakryiko wrote:
> On Wed, Jan 15, 2020 at 2:50 PM Martin Lau <kafai@fb.com> wrote:
> >
> > On Wed, Jan 15, 2020 at 02:46:10PM -0800, Andrii Nakryiko wrote:
> > > On Wed, Jan 15, 2020 at 2:28 PM Martin KaFai Lau <kafai@fb.com> wrote=
:
> > > >
> > > > This patch makes bpftool support dumping a map's value properly
> > > > when the map's value type is a type of the running kernel's btf.
> > > > (i.e. map_info.btf_vmlinux_value_type_id is set instead of
> > > > map_info.btf_value_type_id).  The first usecase is for the
> > > > BPF_MAP_TYPE_STRUCT_OPS.
> > > >
> > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > ---
> > >
> > > LGTM.
> > >
> > > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > Thanks for the review!
> >
> > I just noticied I forgot to remove the #include "libbpf_internal.h".
> > I will respin one more.
>=20
> didn't notice that. Please also update a subject on patch exposing
> libbpf_find_kernel_btf (it still mentions old name).
oops. already went out. :p
The commit message mentioned the renaming from old to new name.
