Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 669AC448DB
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732651AbfFMRLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:11:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45742 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729103AbfFLWQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 18:16:20 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CMEvRp025138;
        Wed, 12 Jun 2019 15:15:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=fnqRWFwaGi1fN8h8gW1jKZV5k1YnKpGpIHbtaCKo8yo=;
 b=HzJ0vwcRpvsGwCSrkh943NekIVxDvcDdtBb51hFpOwDTRYkbztu7qoeSctgMutjimhh7
 xtnZqIrgTUAL5SLJotphICENJZcuwbbwY1MGnI3ByS3Gl6XDcHUN7/e/2ATXNQ3CL1Bd
 Utb9cj+IqASeOZHcLLQBnk1wVyqnU0dJoN0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t39sng1jt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Jun 2019 15:15:54 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 12 Jun 2019 15:15:53 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 12 Jun 2019 15:15:53 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 12 Jun 2019 15:15:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnqRWFwaGi1fN8h8gW1jKZV5k1YnKpGpIHbtaCKo8yo=;
 b=O2Qal5eHvqBoPr6sAfGwM5sKMNkdB1J7t2VeCL5s7mVDzmot9AMZajM0mo3gNwTClqkpRn0FBLUmN9YuMtvc/aN1M2xAOe0xE/8sR1dLElW5P74bPxmq32siA2gnUWBstQi2+hDLz2eqqQEzKcJcrxhqDgMf0+4RNac+UwyXR1Q=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1951.namprd15.prod.outlook.com (10.175.9.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.17; Wed, 12 Jun 2019 22:15:52 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 22:15:52 +0000
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
Thread-Index: AQHVIVHaRrrhQKOS0kuUzzPvAtDO2KaYb/6AgAAZjwCAAATNgIAAAZOAgAAGNoA=
Date:   Wed, 12 Jun 2019 22:15:52 +0000
Message-ID: <20190612221549.7rmv56yjg7a64zad@kafai-mbp.dhcp.thefacebook.com>
References: <20190612190536.2340077-1-kafai@fb.com>
 <20190612190539.2340343-1-kafai@fb.com> <20190612195917.GB9056@mini-arch>
 <20190612213046.e7tkduk5nfuv5s6a@kafai-mbp.dhcp.thefacebook.com>
 <20190612214757.GC9056@mini-arch>
 <3045141f-298c-59ae-41a7-d8bc79048786@fb.com>
In-Reply-To: <3045141f-298c-59ae-41a7-d8bc79048786@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0204.namprd04.prod.outlook.com
 (2603:10b6:104:5::34) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:564c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f6eb298-aa3a-4b78-ba78-08d6ef838814
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1951;
x-ms-traffictypediagnostic: MWHPR15MB1951:
x-microsoft-antispam-prvs: <MWHPR15MB1951B3CFC2D2D4F4C799BEDCD5EC0@MWHPR15MB1951.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(366004)(376002)(39860400002)(189003)(199004)(66446008)(8936002)(66946007)(73956011)(71190400001)(66476007)(66556008)(8676002)(6862004)(71200400001)(64756008)(486006)(81156014)(2906002)(46003)(7736002)(476003)(6246003)(99286004)(9686003)(25786009)(11346002)(5660300002)(446003)(1076003)(81166006)(4326008)(229853002)(6116002)(53546011)(478600001)(186003)(386003)(6506007)(6486002)(305945005)(316002)(68736007)(76176011)(6512007)(102836004)(86362001)(256004)(53936002)(14454004)(6436002)(52116002)(54906003)(6636002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1951;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vI+0SvZNEb6c5B2BgQvwrsAX0RY2onB3aLAZmfykvW5Pk7KTGQ8HVuQrbs/68RoD3JFegRkW4KgTPGTpErWKOghmDslCmqfxk6mp0mDTzngWG8w+rnkX836LDts39np2uvksHQjfl/JeUeHMzpjn8myKaNMtD6iiPeLvjQO3Gozn9YKn8wMPkORUNUxxOk7Fa7ptMXL8oU73GGzzVuxagW4EW3ex/dXSvW/NwtddYQJyO9ziNGEMd6qQCnUQAoAlclesAlFCgxk/2GAM0rz2ouQcq2cwGhb8brbxFh49xAbQOMmZbV1svUmpqVLTy6iz7dIX7RFdJ1/Y8isiljeCDm5jo2GqhC9Z/wB7kj1Y6dZWyxgweVZH+kBidM3G2HFHog/PkKKSpsfol2XVLWK0yuEuC2b90ogRVw5ua34GqNc=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DBD3991265DEE74B995827C197EF0D4C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f6eb298-aa3a-4b78-ba78-08d6ef838814
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 22:15:52.5430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1951
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=496 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 02:53:35PM -0700, Alexei Starovoitov wrote:
> On 6/12/19 2:47 PM, Stanislav Fomichev wrote:
> >>>> CFLAGS +=3D -Wall -O2 -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR) -I$(GENDIR=
) $(GENFLAGS) -I../../../include \
> >>>> +	  -I../../../../usr/include/  \
> >>> Why not copy inlude/uapi/asm-generic/socket.h into tools/include
> >>> instead? Will that work?
> >> Sure. I am ok with copy.  I don't think we need to sync very often.
> >> Do you know how to do that considering multiple arch's socket.h
> >> have been changed in Patch 1?
> > No, I don't know how to handle arch specific stuff. I suggest to copy
> > asm-generic and have ifdefs in the tests if someone complains:-)
It is not very nice but I am ok with that also.  It is the only
arch I can test ;)

> >=20
> >> Is copy better?
> > Doesn't ../../../../usr/include provide the same headers we have in
> > tools/include/uapi? If you add -I../../../../usr/include, then is there
> > a point of having copies under tools/include/uapi? I don't really
> > know why we keep the copies under tools/include/uapi rather than includ=
ing
> > ../../../usr/include directly.
>=20
> for out-of-src builds ../../../../usr/include/ directory doesn't exist.
Is out-of-src build mostly for libbpf?
or selftests/bpf also requires out-of-src build?
