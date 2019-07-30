Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACB4E7B4E6
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 23:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387649AbfG3VUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 17:20:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43724 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387480AbfG3VUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 17:20:11 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6ULDBIS003709;
        Tue, 30 Jul 2019 14:19:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=KkwqQavWjQXvA5jZAQ1Q5agZoFkcYMInai0ewBLmqOc=;
 b=UH2X60yAleYCCoJFo8uruxZf9O1zn/VSNHTuBBFS1YziPDpznWiokK5CDQLh/xrBG+xS
 q0zHjYWM4zy7wboQXv5IxYcLGff5BjbXN6WIdp60ZCE7kaXXP+LUMhr4rGBFlNKP+l6n
 NPPdKn69VYZ9IwaVGPym2SiJO2ynAHgkuSA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2we0g2b5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Jul 2019 14:19:51 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 14:19:16 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 30 Jul 2019 14:19:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKqV7zBQSx5e1EnNgOfwl+UqVv9pZVf2AJiMIuIfUTjL2p4j+YHxVjg4MYTAbp69NcT6vqzvqs/T3e2Q/Th3yetdnRN51Ftcz0sOHghUlVQ+O1kl2IuBlT1N+CnCZmCIMbhu9kIpQSjogKiQk2Ebw3+DSGFMGZXHLgn7iO6phEwAWAaMUsIlmMXzl5ucaiXU12CtWb+vQAB+ZyTeIJLcCbD3bYKgo+2zzAtpDbUn/+l+qTOex9/vJOIV3Oc02omMwYhboOgZiRVrj0GPZn68nIfX2GCLE/B058FCIjhMn4NPhIw4S9Ka4Dx4ioIqNbSoeaxJqhxSdEaNLS57wX1xWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KkwqQavWjQXvA5jZAQ1Q5agZoFkcYMInai0ewBLmqOc=;
 b=f+6382LiyuDBvAS8p/r8Ipf8I2NWaO6zp52RckRcGygULR6UxA1YAJaFTiBuMdZcAOd9C92e16LcUKpoaYqPd2Gk4sfDIG+IBH3gLI13kU1l9wWsnlWBKXlB1KB6xnKay9MLfWxgjfvbT3pUfAijvzkTf6dP8j30JURzWNg5+p9zELpQWWOYVpVnac4LE/B6VIT++Mba6tjeuI9GmBG8mm33tDkpQXBbAS3zDPHx6hUTJnShM7yTEkaXmKmAWIUP9A1W2vxRNHungPxs0lmPaU5tlbPNIuUqwlKr2o6aQnVZVX1uUvVZBD+IAxUKVZOl/wEN0Vzrz1t5GXW1r9dw7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KkwqQavWjQXvA5jZAQ1Q5agZoFkcYMInai0ewBLmqOc=;
 b=Zqrb8MP/AOtLY3jtIH4cLABX+fM6gvj2HTNwPN9oXa2b+peUoGHACSBH0H9it89J20R5oDXEsy+YZzZQoxclD11m+6zfXsHeXBFeNNppn0Y3zPjhofyT9PjGl6mRtulFkqlQZVZryI+QWQjA/hrHloyJV8/BQk/FP8w2DBJqzGQ=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1888.namprd15.prod.outlook.com (10.174.100.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 21:19:15 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 21:19:15 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Yonghong Song" <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 01/12] libbpf: add .BTF.ext offset relocation
 section loading
Thread-Topic: [PATCH v2 bpf-next 01/12] libbpf: add .BTF.ext offset relocation
 section loading
Thread-Index: AQHVRxCcUGQ3ezGxT0qmeix6sgnjYabjqr4A
Date:   Tue, 30 Jul 2019 21:19:14 +0000
Message-ID: <36AEDC97-3055-47ED-B1CD-628BC6E21148@fb.com>
References: <20190730195408.670063-1-andriin@fb.com>
 <20190730195408.670063-2-andriin@fb.com>
In-Reply-To: <20190730195408.670063-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:5cb8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 230e9b88-6a65-4f5f-8614-08d715339309
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR15MB1888;
x-ms-traffictypediagnostic: MWHPR15MB1888:
x-microsoft-antispam-prvs: <MWHPR15MB1888663F99E3750C57E9030FB3DC0@MWHPR15MB1888.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:425;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(376002)(366004)(39860400002)(199004)(189003)(71190400001)(25786009)(54906003)(102836004)(91956017)(76116006)(6116002)(229853002)(66446008)(68736007)(305945005)(256004)(37006003)(66476007)(99286004)(316002)(66556008)(66946007)(64756008)(6486002)(86362001)(4744005)(14454004)(446003)(4326008)(46003)(6436002)(486006)(6512007)(36756003)(11346002)(2906002)(478600001)(5660300002)(33656002)(6506007)(81156014)(53936002)(6246003)(7736002)(186003)(8936002)(6636002)(8676002)(57306001)(6862004)(53546011)(2616005)(81166006)(71200400001)(76176011)(476003)(50226002)(142923001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1888;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +nxm+kaX2XHycYnqjdB7YtgrmFdzNEBocoSmmHj205KWW4lTyq+Jwbn0P5rgQonRiT/IHLwLj3ymjWfDGjiVTztK5I1+K91drsiGDJ3xAihoYfTF6ThtJ+Ivah2BLiy4WSpGNIjRC+RxOQpPutEEN+lvuUsDCImRoXSWnEsNVDTZnwsQE1NWQEt7E2AuCMG+wy1fSyUOKfwvxzb2WXGKe2w84fSFOBByuuJI8bhnlywHjHw0Nw35AIdz3dPdFlNXcydwDYKEkzOPZ7xZV54xCYE7/n8o7FzppOpyb2iGibCwn252bZwTV19r4LnpjC53WFpQxb0TFN6RJdH18KzZKhBvoX9AOgYSrO+IO3lKa5KRVnmEHHDdLudNv8t5fpLqImtB0QwRVi6LGrJn2gaZMsYvLaBi6X54ln/lEdOIzeg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1791E42D2800B84A852C52E064257172@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 230e9b88-6a65-4f5f-8614-08d715339309
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 21:19:14.7071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1888
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=779 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300212
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 30, 2019, at 12:53 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Add support for BPF CO-RE offset relocations. Add section/record
> iteration macros for .BTF.ext. These macro are useful for iterating over
> each .BTF.ext record, either for dumping out contents or later for BPF
> CO-RE relocation handling.
>=20
> To enable other parts of libbpf to work with .BTF.ext contents, moved
> a bunch of type definitions into libbpf_internal.h.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
