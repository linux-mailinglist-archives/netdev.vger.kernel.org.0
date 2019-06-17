Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E5B48FF8
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbfFQTqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:46:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31890 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725878AbfFQTqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:46:33 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5HJijsC002141;
        Mon, 17 Jun 2019 12:46:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Gi8KD0pLx31FYAgt3sVhyyS+oNer1oRo2C7DV//0/ps=;
 b=J5GfossVDjFsLqsS6XqZLibPN4ZbOGaxGYT3DuGRcykJfiBePObILLb+u0B2wekYlIj6
 F2DPgQreygYCTFyreuCj6bzLD5Oz6epb8fEdrbOqKzr3y6jWHBH4ybSLVujzB5tLdkpO
 PNbPVUNmoCskTbOIN2o9zezQ+C3KGviN1xo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2t6cvx11xe-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 17 Jun 2019 12:46:14 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 17 Jun 2019 12:46:06 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 17 Jun 2019 12:46:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gi8KD0pLx31FYAgt3sVhyyS+oNer1oRo2C7DV//0/ps=;
 b=S7UZYddQs8S3qjrpMF8poCBNe0hM0Pd6v9SB4yHN28fxADnEjNWjsYxMSFrgE96CJrkLnJDSS/RfmSlnw/6mG2ba2MjhDiptPch2lm9/mbVapxhfsULvZ5Tt+/Fyw8RJ5ht9EPH56Z3H/r/atucIe/pVP34Sw9eFy7MVWkTUzQw=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1119.namprd15.prod.outlook.com (10.175.8.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Mon, 17 Jun 2019 19:46:05 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 19:46:05 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 03/11] libbpf: streamline ELF parsing
 error-handling
Thread-Topic: [PATCH v2 bpf-next 03/11] libbpf: streamline ELF parsing
 error-handling
Thread-Index: AQHVJUK44HxTPQlBSkG+LkdawbJgC6agQBMA
Date:   Mon, 17 Jun 2019 19:46:05 +0000
Message-ID: <1970E78D-78EB-407E-878D-0A75FF40DD47@fb.com>
References: <20190617192700.2313445-1-andriin@fb.com>
 <20190617192700.2313445-4-andriin@fb.com>
In-Reply-To: <20190617192700.2313445-4-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:da81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c82f1f5-b2c1-4a03-ce60-08d6f35c6f77
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1119;
x-ms-traffictypediagnostic: MWHPR15MB1119:
x-microsoft-antispam-prvs: <MWHPR15MB1119E42F932182DFD0315BD3B3EB0@MWHPR15MB1119.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(39860400002)(396003)(346002)(136003)(199004)(189003)(50226002)(486006)(6862004)(36756003)(478600001)(6512007)(33656002)(37006003)(25786009)(7736002)(14454004)(68736007)(446003)(476003)(71190400001)(71200400001)(6636002)(316002)(54906003)(53936002)(6246003)(11346002)(2906002)(57306001)(2616005)(4744005)(99286004)(76116006)(6506007)(66946007)(46003)(229853002)(73956011)(5660300002)(66476007)(66446008)(64756008)(66556008)(186003)(6436002)(6116002)(305945005)(8936002)(53546011)(102836004)(4326008)(76176011)(8676002)(86362001)(6486002)(81166006)(256004)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1119;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sAOXY8WCOf2N58sQns2DZC6qV8+Ws4cwuONV96pswJvxoKsS7D5PaYgfC4sMzBS9+zHnE/ZzjhYlL2is2ZB9J9W2gKacSAaBgo9xoubw3gf4jWF1KXDZ/A0nV1sxQHFS1kYQcvkO7nnzwrO7Xwfv1DvSsWumSNmimxL0CzaBTW44o23QoMllPAwOvXZdcMGBiLmEyzyKWT13u14mDvhlcogHbAW7TNCW8xmnXkAPIfNVQ138y2xmtWb3Iq2d0B1N8I0roOCUqSVfVo1JhAmpJBUmp6mbo9LHWmu4ElOS+K7y8q33nOpaI3Pl91nkKIZjALXHYlXfwXtf+Jo2ipfxzLFKloL+4j+x5xJ8IjY2lENq/ORBvgRkXT/NPST4X3iL6ilvz4v5LhdAEPy6C1aXIuuU9zD5Ltced1oZEoPZekE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D3C3AFAB8A2EEA4788C3D72C3340C218@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c82f1f5-b2c1-4a03-ce60-08d6f35c6f77
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 19:46:05.0275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1119
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170172
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 17, 2019, at 12:26 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Simplify ELF parsing logic by exiting early, as there is no common clean
> up path to execute. That makes it unnecessary to track when err was set
> and when it was cleared. It also reduces nesting in some places.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

<snip>
