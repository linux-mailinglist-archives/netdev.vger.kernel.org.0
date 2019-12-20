Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84DE81280F0
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 17:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbfLTQwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 11:52:21 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18000 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727181AbfLTQwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 11:52:20 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBKGpFmV022765;
        Fri, 20 Dec 2019 08:52:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=YPUdzpI5m1ym7yw8NakyrxPEsIVEWOiJMOft+RQ4RXo=;
 b=gT8JwNMNJiJ6GLqMv837CP//TAJriyAh0NU16+GsRLkvkzL21oOMoTluhlkbbpxOYYqN
 HZ+Yz4L+pbZmU8UsQb+PGioc4sVIe69HJT9qngIzuzMwoBZlVCmdrS6KFD63QjynHGnp
 ahiqggvJLiZqdnUfFJ21h3i/jNGAsEu5RtM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2x0fafcxwu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Dec 2019 08:52:06 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 20 Dec 2019 08:52:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HKoAjZv7eS3jmYiOyt6kBJ5hhw2BXzhhopkmSry2NB49J5xXN6Wt4dFTZrX9FKuwvxuKHOIGcFawI22AnijTlV9ftdx+dQZLnXiltOavYThwKzhceMY6jaTxhczgh6cN1X2hsHGvNI+nv9aYig2xoO81gt7/SzXiYbZHV7yie1wLw45/vhZxoBPKvMk5m1e+Fy4T1YKCMq5xYE3+zJZI0JtUBSIXT/0+v33YjJp/AZhrHWVr6AkhMYXtYBy/S1pizjqz3neOqzqUh2Ydr7rg9+Oc0DS6BF1JmwZAXXi+AAhly4MRSbarJs4ZFcr5SfEJL//AGSFa9AfuIOVXAwcd9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPUdzpI5m1ym7yw8NakyrxPEsIVEWOiJMOft+RQ4RXo=;
 b=XUG5dSVZ0QUA57smg1lfbOeDxgrWexbi4w7AAKKVDWIqwnHexQcT9TC+ykl0b4y3SmHtUP5eUfVJDHwbKc93yKpSj+1jOR5DMhl+SdPRFnNSibfDGOSSx7YYKUBH5AzajdADewikvCjahAfIQwsKrUBi4J5dnO1MMqSr29GX2pbqMU5zUc6IaPVxmF2FsfWBIaEZDheJVOgaSFRqwVbyQX2rBgGElJ3Qd091NPZ3isVfUoMc1Ic4jZk3l+beXeXupr8ac8MBNQ+GUNdXrVhsRPgBpsIoHfeNnfo93mzrPHG+QZr+g3vGQlC01sp5nScGsSkkj7d0pCIl3npNLT4sJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPUdzpI5m1ym7yw8NakyrxPEsIVEWOiJMOft+RQ4RXo=;
 b=ZkfbMorsXhkpuVRvacvkkYfjHxJvJCDXaEY4sib1dGwtBsGFqkggFWinmFZQ8Vitzk08F5xdTl10oDDGN1Q4/OB5Hd9asNVrwJUYchzr6LjE8QvHM/qrpmWwDOuh1kTsUfb71da+RD8sXhLTnHQwvtrQ4o5n7n97K1Nlrtgwe4o=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3406.namprd15.prod.outlook.com (20.179.22.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Fri, 20 Dec 2019 16:52:03 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2559.016; Fri, 20 Dec 2019
 16:52:03 +0000
Received: from kafai-mbp (2620:10d:c090:180::f326) by CO2PR04CA0056.namprd04.prod.outlook.com (2603:10b6:102:1::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.14 via Frontend Transport; Fri, 20 Dec 2019 16:52:02 +0000
From:   Martin Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 06/13] bpf: Introduce  BPF_MAP_TYPE_STRUCT_OPS
Thread-Topic: [PATCH bpf-next 06/13] bpf: Introduce  BPF_MAP_TYPE_STRUCT_OPS
Thread-Index: AQHVtwY1LJ1bT9dZQEGGVICfqJBmq6fDPYkA
Date:   Fri, 20 Dec 2019 16:52:03 +0000
Message-ID: <20191220165158.bc6mp7w5ooof262h@kafai-mbp>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004751.1652774-1-kafai@fb.com>
 <6ca4e58d-4bb3-bb4b-0fe2-e10a29a53d1f@fb.com>
 <20191220072150.flfxsix4s6jndswn@kafai-mbp>
In-Reply-To: <20191220072150.flfxsix4s6jndswn@kafai-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0056.namprd04.prod.outlook.com
 (2603:10b6:102:1::24) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::f326]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7acaee31-2e0e-4e73-9296-08d7856cf056
x-ms-traffictypediagnostic: MN2PR15MB3406:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB34064CAB33BFB8FC62C42CCBD52D0@MN2PR15MB3406.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 025796F161
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(39860400002)(136003)(396003)(51914003)(189003)(199004)(52116002)(71200400001)(5660300002)(8676002)(81166006)(81156014)(16526019)(66556008)(64756008)(66446008)(186003)(66476007)(66946007)(1076003)(33716001)(8936002)(86362001)(9686003)(6496006)(55016002)(2906002)(478600001)(54906003)(6862004)(4326008)(6636002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3406;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mVbC4V7H0Si2cfuEQTQCFsX8IHP3c9N5H05Li5TEoAGlBS5ctt5XtBSKeSfAtTQpD+xRwLTYhosVX+YFoFf53JXEekEmUL6A3qfoC88+uAZdes+NFZsmRV8joyHqiLiE3tdWg2/CWwuJm3VrADTTGCFZ15tEL97M9ra7YcmD5+S7OliXO4JxnagS9jYf40vgK+I8HtJTdT8XqmWeK7gniN1R+dN9S2fssp4KJ2j3QTJZPyXL6nlFZHTXINm5f56MFawmNuq7NDOo600OSASOkp0RkvVtaoo7vtvRpOWpCUn59vuP58DDjj0zHZM0HVRqqi7YlV8NXyH7YN3JxKHCiC6FFezr+pm5t9ocokkiSifmUqt3YSPn/SY3GLGenMo1AC+YjLfBltp9pDvoS4K/sTJAPOF2aRUp2JxniSOGSJsajHNM3/vGPDiJeRxLiIragGRI/tr6jhfBk6BCuOPFAPR2zMY6jlmy3AA9j+5ntuhbZVUw5Av98ssvdvUtr5Iy
Content-Type: text/plain; charset="us-ascii"
Content-ID: <39B734EA806E8C4C8E24101B28C2DEC2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7acaee31-2e0e-4e73-9296-08d7856cf056
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2019 16:52:03.4470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iHx8w2Jmq+FdpkanrIazbUoUskVeOzAAFJ9eQBUpCM8pBFnzuCq8V6bSv29FbLYE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3406
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-20_04:2019-12-17,2019-12-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=497
 phishscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912200127
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 11:22:17PM -0800, Martin Lau wrote:

> [ ... ]
>=20
> > > +/* __bpf_##_name (e.g. __bpf_tcp_congestion_ops) is the map's value
> > > + * exposed to the userspace and its btf-type-id is stored
> > > + * at the map->btf_vmlinux_value_type_id.
> > > + *
> > > + * The *_name##_dummy is to ensure the BTF type is emitted.
> > > + */
> > > +
> > >   #define BPF_STRUCT_OPS_TYPE(_name)				\
> > > -extern struct bpf_struct_ops bpf_##_name;
> > > +extern struct bpf_struct_ops bpf_##_name;			\
> > > +								\
> > > +static struct __bpf_##_name {					\
> > > +	BPF_STRUCT_OPS_COMMON_VALUE;				\
> > > +	struct _name data ____cacheline_aligned_in_smp;		\
> > > +} *_name##_dummy;
> >=20
> > There are other ways to retain types in debug info without
> > creating new variables. For example, you can use it in a cast
> > like
> >      (void *)(struct __bpf_##_name *)v
> hmm... What is v?
Got it.  "v" could be any dummy pointer in a function.
I will use (void) instead of (void *) to avoid compiler warning.

>=20
> > Not sure whether we could easily find a place for such casting or not.
This can be done in bpf_struct_ops_init().

Thanks for the tips!
