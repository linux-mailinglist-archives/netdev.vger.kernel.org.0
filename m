Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 711C4448B2
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404635AbfFMRKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:10:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54382 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729337AbfFLWjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 18:39:51 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CMcbpT009842;
        Wed, 12 Jun 2019 15:39:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=klXxn1R7gKpZRMYz+C+HRdyXN3M6Um6kXRZ5bhbFn98=;
 b=dE4lc4+xWxceIVuNuxfndCaICYtkN1oG2SWnCP4O4Jkpjt+0oMq9hEYmt38OBx/1abCo
 OaYaY0xv4LsLjwEMvdUxUosFF9NuDUCecfcW1NTS22bR244uA4VHQtqWWlZ2++n/Zwq4
 x9XxJ4n5XN97PCfA6vVTTEU0r3rMU+SfOR0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t3338hp84-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Jun 2019 15:39:31 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 12 Jun 2019 15:39:09 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 12 Jun 2019 15:39:09 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 12 Jun 2019 15:39:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=klXxn1R7gKpZRMYz+C+HRdyXN3M6Um6kXRZ5bhbFn98=;
 b=ov1W27iW+FVZu3iu/iiiSWynjfEdWLB3RKOXeunFr0PAfH1yhf/zBwzflvh9vmofQi6ApRpnS2BKm+TAahqtwoSD5PWhkzvLvtNXVPNCQHNew5+GGJurbKyhze8PH5QT6VRDT9q3mS8lt7l4H9xCiXrqiKZ/ncyRuet2LbmnXy4=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1918.namprd15.prod.outlook.com (10.174.101.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Wed, 12 Jun 2019 22:39:07 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 22:39:07 +0000
From:   Martin Lau <kafai@fb.com>
To:     Alexei Starovoitov <ast@fb.com>
CC:     Stanislav Fomichev <sdf@fomichev.me>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/2] bpf: Add test for SO_REUSEPORT_DETACH_BPF
Thread-Topic: [PATCH bpf-next 2/2] bpf: Add test for SO_REUSEPORT_DETACH_BPF
Thread-Index: AQHVIVHaRrrhQKOS0kuUzzPvAtDO2KaYb/6AgAAZjwCAAATNgIAAAZOAgAAGNoCAAALJgIAAA7YA
Date:   Wed, 12 Jun 2019 22:39:07 +0000
Message-ID: <20190612223904.wxabk2ldc6e6c4qf@kafai-mbp.dhcp.thefacebook.com>
References: <20190612190536.2340077-1-kafai@fb.com>
 <20190612190539.2340343-1-kafai@fb.com> <20190612195917.GB9056@mini-arch>
 <20190612213046.e7tkduk5nfuv5s6a@kafai-mbp.dhcp.thefacebook.com>
 <20190612214757.GC9056@mini-arch>
 <3045141f-298c-59ae-41a7-d8bc79048786@fb.com>
 <20190612221549.7rmv56yjg7a64zad@kafai-mbp.dhcp.thefacebook.com>
 <64cf5b03-bb3e-ee4d-932e-46433bd0ecdb@fb.com>
In-Reply-To: <64cf5b03-bb3e-ee4d-932e-46433bd0ecdb@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2001CA0017.namprd20.prod.outlook.com
 (2603:10b6:301:15::27) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:564c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c1a9ea4-5cd8-45cc-dbf3-08d6ef86c77e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1918;
x-ms-traffictypediagnostic: MWHPR15MB1918:
x-microsoft-antispam-prvs: <MWHPR15MB1918F330FE6BB2E05072A136D5EC0@MWHPR15MB1918.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(376002)(366004)(346002)(396003)(199004)(189003)(186003)(6116002)(4326008)(64756008)(8676002)(66446008)(66556008)(73956011)(66476007)(66946007)(54906003)(102836004)(316002)(46003)(14454004)(6862004)(476003)(68736007)(486006)(53936002)(11346002)(446003)(7736002)(6246003)(99286004)(8936002)(86362001)(81156014)(6506007)(229853002)(305945005)(52116002)(5660300002)(256004)(14444005)(6636002)(76176011)(71190400001)(386003)(2906002)(6436002)(6512007)(71200400001)(25786009)(9686003)(53546011)(81166006)(6486002)(1076003)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1918;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ygHoG2+p86Snykhlz43dlrwf4/OVwrinzXaRvNOgI+ItibpQJ8rSoXLGIRO2WeihJ+kgU/uG9jtFoi8vCREi44YkFWsi11MJ+6yvM4yKFQ74PNf+GBmNPNJg8sg1XMfo+y5MH5vZOMNcsrM4ksctuaGLXItM18dNc6iIx1rZ/qRB4zSMscjv8b1HZYiEt5rYg97AtXyhyTuuHLoaUIKsGbvyfmkxOp/S+AI117WMbSG/kdkN990HoWMyKKieIYKPPPXfVNT1BNJ0VukBRDY6hI3aAS+VnbjS6d+3mTjBuxm7KgDXRevCPepxcKMmblklUsUFwFHgai6sgl9nUXo9WOI/aTbiohj+ygHB/En4cfcyO78bobKHUAyJpyKJT4XyOykaWZeZYeFg2W4okbny+ZCVwtIUUPdZjy2YAB0Vk7g=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3D0678DC08483F40B54427DD7238693A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c1a9ea4-5cd8-45cc-dbf3-08d6ef86c77e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 22:39:07.6354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1918
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=592 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120159
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 03:25:47PM -0700, Alexei Starovoitov wrote:
> On 6/12/19 3:15 PM, Martin Lau wrote:
> > On Wed, Jun 12, 2019 at 02:53:35PM -0700, Alexei Starovoitov wrote:
> >> On 6/12/19 2:47 PM, Stanislav Fomichev wrote:
> >>>>>> CFLAGS +=3D -Wall -O2 -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR) -I$(GEND=
IR) $(GENFLAGS) -I../../../include \
> >>>>>> +	  -I../../../../usr/include/  \
> >>>>> Why not copy inlude/uapi/asm-generic/socket.h into tools/include
> >>>>> instead? Will that work?
> >>>> Sure. I am ok with copy.  I don't think we need to sync very often.
> >>>> Do you know how to do that considering multiple arch's socket.h
> >>>> have been changed in Patch 1?
> >>> No, I don't know how to handle arch specific stuff. I suggest to copy
> >>> asm-generic and have ifdefs in the tests if someone complains:-)
> > It is not very nice but I am ok with that also.  It is the only
> > arch I can test ;)
> >=20
> >>>
> >>>> Is copy better?
> >>> Doesn't ../../../../usr/include provide the same headers we have in
> >>> tools/include/uapi? If you add -I../../../../usr/include, then is the=
re
> >>> a point of having copies under tools/include/uapi? I don't really
> >>> know why we keep the copies under tools/include/uapi rather than incl=
uding
> >>> ../../../usr/include directly.
> >>
> >> for out-of-src builds ../../../../usr/include/ directory doesn't exist=
.
> > Is out-of-src build mostly for libbpf?
> > or selftests/bpf also requires out-of-src build?
>=20
> out-of-src for kernel.
> In my setup:
> $ pwd -P
> ..../bpf-next/tools/testing/selftests/bpf
> $ ls ../../../../usr/include/
> ls: cannot access ../../../../usr/include/: No such file or directory
> $ ls ../../../../bld_x64/usr/include/
> asm  asm-generic  drm  linux  misc  mtd  rdma  scsi  sound  video  xen
Got it.  Agreed.
I will copy asm-generic/socket.h and do the ifdef.
