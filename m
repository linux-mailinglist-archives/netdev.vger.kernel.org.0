Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070CBA2B07
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfH2Xjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:39:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42372 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725826AbfH2Xjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 19:39:36 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7TNYpra027011;
        Thu, 29 Aug 2019 16:39:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=qxxsEe5TOWex0wc8IDqW2B8LhAw7Ez15cHSZ+uvJprs=;
 b=qmyDOROVsmYZ5QyovCfOop5ExNJ1NliQIXgz97tusMptMn1xrpt+Z7NAhQJ4s6tHy3pa
 wYdsX9xKCm5xLqkgEY4cJ0QOjKTWDLJan0TzwwXkm7RsFHrdDnH/4s8kG71dK/JhudFF
 fFXiNRvIMqbKKdlrsXH5dnL5aqDzDG7qf20= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2upnhx0t7f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Aug 2019 16:39:14 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 29 Aug 2019 16:39:13 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 29 Aug 2019 16:39:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+0NaxgW2qb3U/WrhHmTiXHopsn1XBdJ9Jotrp2ofSKFRXPbiiuTbXKOXi1RiiKD7ciV2fK6DIhk8SgsyqrYkulT25L+Bp2LIUhxq4CLd6fmsz+idWVFS/sOWGRZjZ/u9dL7l5hXuDwY+Ri/mk6wxJGqhyJY4f5QI/bhfJ0AtgEg2Y/QGYEuE1zUrDrhhGEX+A/CJwNQwX+ompnegc1OiXmqvSXzlBeezU5hoSZ+V1fp3JbIStY1i6HA5GXCWWSINMdm6OJbOjnH4noqb+Rf62SaEe2m2+Df9VLpKmhYHbbaNabHh0x/lb9KdnpnRogbiGhwE0a2p9Jez3tWmCx1+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxxsEe5TOWex0wc8IDqW2B8LhAw7Ez15cHSZ+uvJprs=;
 b=YGVvsocQ4JGz8xf8+mpKeO1lPQrKxn2g1/dbCf/uy7rLEkEIzbymy4X0tIS40V8pSPAzmWEpxQFYwffCw7lUxg3MxBpFXvy6KFA5/pZRbFJpqaefZ/sPSmbqJ3sqSxo82/7Cu8xO/YNuw2y1KkeGQvYtIYvrNro8UMnof5CPjoit5DdQpJNPZgtQqIlC2rBm0ScQOLP6MgCZ3Tf84Kvsk7eho6YV6VQWfdJrA9g3OP9rTQ5qki4DrlVoxMjDSM6KE85D1vdACxLdkbf6w2pUTJSp0mZknysVd2yzNbrJqlTzxFsiUB/MrSGnVAlK5g9DlGHHMBGen2k4bw4MruUqUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxxsEe5TOWex0wc8IDqW2B8LhAw7Ez15cHSZ+uvJprs=;
 b=V5TNwFr7VRcToZDIoUgpUCRiekl3DIoH/6e8SYG2eVlVJTfZhtNKWJd66Zx6k49YRwVrJuKLwN7LT7dBT7n15IgZ1Jg9OOq6kyPn1hQdnER4ToBJyMFg+wzSgxVjNHquiqlHE8/YBgSJZS7g7KxN1/kz2um6nKzzOjeMaPZDv08=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1213.namprd15.prod.outlook.com (10.175.7.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Thu, 29 Aug 2019 23:39:12 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 23:39:12 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 03/13] bpf: refactor map_delete_elem()
Thread-Topic: [PATCH bpf-next 03/13] bpf: refactor map_delete_elem()
Thread-Index: AQHVXjVUxTgTUzauiES0hXUSZfUdyacSyYCA
Date:   Thu, 29 Aug 2019 23:39:12 +0000
Message-ID: <029954C3-D673-4D47-A59E-1D5AD9729814@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
 <20190829064505.2750541-1-yhs@fb.com>
In-Reply-To: <20190829064505.2750541-1-yhs@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:3161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45ed632d-ead8-4f70-3e63-08d72cda1893
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1213;
x-ms-traffictypediagnostic: MWHPR15MB1213:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1213710D088100A87092AC2FB3A20@MWHPR15MB1213.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(346002)(376002)(366004)(136003)(199004)(189003)(81166006)(99286004)(14454004)(7736002)(54906003)(486006)(305945005)(33656002)(14444005)(8676002)(558084003)(8936002)(37006003)(316002)(50226002)(6116002)(81156014)(478600001)(36756003)(229853002)(46003)(76176011)(71190400001)(71200400001)(4326008)(66476007)(66946007)(66446008)(64756008)(66556008)(76116006)(256004)(6246003)(2906002)(86362001)(6862004)(476003)(6512007)(6506007)(53936002)(446003)(6436002)(2616005)(6486002)(11346002)(5660300002)(57306001)(102836004)(53546011)(25786009)(6636002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1213;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hyvb6YWRb96HHNLeOn3QnYzzRi2rG/GYSGtDIm0xmnrNgdNOP+KH+6eCeLbsl5LS2zW8hp4cfPhUEhPRywyDykrfonauHjsFTsI5VCoLwobdg3T/IJTLDeQcwo49F77kIqxaZbiyWnnHq2IkTloPHykQaliL6RQwFcw5BHSzSeeiOQdJqQH0PlvcrAh7yzIAzgew9fVWAZzSb3LKVzUsdvJkRk7D8zIvjwCqiWK7G1rJNPahtNJdBZCNqSRMYFqucQmF6UgZtNDAWo6kKv71zgH2ImuGR17hr7zAQ/vLoo6T+lgewHRxYnTKPBBpTHFn4T8laVJNFztRT9/q39am7fUuqwXTzrY1a3CNnTqrZgIlFxszOg1alSgN45U06r633CTSdDI3fmtKw+b6ShWlMcJMu9AkCERJxlVRU+SI39w=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5D2B8E4FD3C97F40B1DFA584B6FF3C14@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 45ed632d-ead8-4f70-3e63-08d72cda1893
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 23:39:12.1750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pkH0nSIOBo/K73o3EFTRu9yGpcLTQA5XnU7Opfn9za6bPK1WH62gP1Q3br7j6C/V9BCJpDnc35SdxPPE64uV0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1213
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_09:2019-08-29,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=522 bulkscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908290236
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 28, 2019, at 11:45 PM, Yonghong Song <yhs@fb.com> wrote:
>=20
> Refactor function map_delete_elem() with a new helper
> bpf_map_delete_elem(), which will be used later
> for batched lookup_and_delete and delete operations.
>=20
> Signed-off-by: Yonghong Song <yhs@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

