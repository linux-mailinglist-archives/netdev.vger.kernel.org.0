Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97FF2E01B8
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 21:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgLUUzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 15:55:51 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51276 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725791AbgLUUzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 15:55:50 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0BLKqNax029189;
        Mon, 21 Dec 2020 12:54:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=oz166JjDH9Nk0LvN+WT/TypLuFkZexY0LbrSUi+OmqQ=;
 b=Z7eajCUwsbJ3mY4QeMZBjlNYtc7MOh+BY9mnuRQv6uMYUWa1J3eB8Moq7XjjI4rf9nuL
 sev7dcurC89W5XVF/jEPfSBFiMRTEhzvTy5+1U4LoLB6QlCKAyYXdfVtv0aZOm/G8QqF
 NwpKNCweQUPFL3TVZk8PATAP/1IFXqZd6I0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 35k0d790fx-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 21 Dec 2020 12:54:51 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 21 Dec 2020 12:54:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYOhWiOda6sHc5vMgpF4WzeaOtNnPZH6Wk75/k/KFsX427DBKPVkgDExvQ3mHnX/pU9j69Xl97W+wf20T0IjHQX/yahbhNZEsHrbbeI4q5FiZJmNCcnzcMDiBmz6wq5BCiCoHUEbOVGh70lhnF+mj1sTOPI3d+Rthoo/7DDaw/xEKbAR9c+F57QBUMj9H+SlbV/PElekd/4ngs49Ij3hxhZc5tUVrYbkl9+kHwj7buLG7YsKthJ8CO/1U4dmnvT42UuZXYgC8Pmu7iUI4WD8eIPz/r4Ko+Teb0Uwq16mwjWbDNc5kIMUrPWSYewBibBSjIBl0Fz9mNEFypqbH2EFyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oz166JjDH9Nk0LvN+WT/TypLuFkZexY0LbrSUi+OmqQ=;
 b=O/TnJ3RTJ+uIKD+D5wE+cgqgvPLMp2ErG9h4UXjdz2BwCy2BpjkfUicTGyKVHCWY2edUZO5KDwYFQUwzrdTLraY7x9uWIviGjuhU0oGwYalmB2z2Bz0XhrIzLSzaj/z58+/iS6RJTaAiCp/u0+NUpjY4SL/zejo36jT/QZWIFAqn4hgr5vPhHOL34Hw9RwvoFZ8+TjBW10E5oE8HOjPJ0WDyRqe1o42mTWyRvFvo2yjM9aK/6KDlYntceEke+KDErxsENJ/5ZuGk70N/4mzDBi/rR8O6TbNIuCm1VcFrmJZy6EfNKJKnTfaSda06tI4gCbZnOLeWwVYhTcZ5UuHaWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oz166JjDH9Nk0LvN+WT/TypLuFkZexY0LbrSUi+OmqQ=;
 b=iXG+uKlZ8Kts5dehiSS+P9HSD3EbglFZNwY1M1TmksB2KEZ+OgRAIvi20xVE5qNJdzbTMi/SIzp2Dz2GzkIdpDou1dwnq2yHOML+7Cx47PrTl9pSXwa++A7WmBr8q96Mbcsb1pnP1JFPfJe/1QBMk7EvmUzdtN2xXMmRGMZ5aOk=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3191.namprd15.prod.outlook.com (2603:10b6:a03:107::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.33; Mon, 21 Dec
 2020 20:54:48 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3676.030; Mon, 21 Dec 2020
 20:54:48 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, bpf <bpf@vger.kernel.org>,
        John Sperbeck <jsperbeck@google.com>
Subject: Re: [PATCH bpf] bpf: add schedule point in htab_init_buckets()
Thread-Topic: [PATCH bpf] bpf: add schedule point in htab_init_buckets()
Thread-Index: AQHW188F3F/xoJdag0OsN1a6i8AOP6oCB2qA
Date:   Mon, 21 Dec 2020 20:54:48 +0000
Message-ID: <86F51957-F67D-411A-A790-B4255C617F85@fb.com>
References: <20201221192506.707584-1-eric.dumazet@gmail.com>
In-Reply-To: <20201221192506.707584-1-eric.dumazet@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:7b59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7620687-e19e-4a34-08fa-08d8a5f2a76a
x-ms-traffictypediagnostic: BYAPR15MB3191:
x-microsoft-antispam-prvs: <BYAPR15MB319127B1F69AA807C27C40A4B3C00@BYAPR15MB3191.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zlSgpEC8zt16kLheP7AEiwGRTqZIJNwYtJFjhP+4kGJUbROcmbGnQmIDLO4XjxOZUK0j4r4VULHNbBK8KIuijzS974bJC8E323y4myo6FfCgtwmce17NfITU2isnRt7x0asXfBAKrhdb8PX5Yi7qPwZyVuIiRFj3BzYW5DcCHHtU9CJMYmoyHaTC5Z6er0yZ9LmqZ6RWP+6CSzEzo0mtD+H7hu1YUBHBNm4eObhCVgd9qyKEZT4DjKCgbXqIS8ff0u4FcgJbw3uQnZZL4aRaZW2ksPwyRGqmxisutH+avXqe3V4Cxp6qpxQYeoWAVy1yHXBS8sScxJLFw+kBsLOBtsynCm2UPu+Mg2VTXjz4HHjQqq9lqvXYSIVkTTCpoae4qMXNAGgXuKnrTM05zhNmfdGF3aE2qsH6Rov/8btqAf986UcyMZJWaEnAaGL/t1+G
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(366004)(396003)(376002)(2906002)(5660300002)(76116006)(478600001)(83380400001)(66556008)(4326008)(36756003)(86362001)(6512007)(71200400001)(6486002)(4744005)(316002)(186003)(2616005)(33656002)(8676002)(54906003)(6506007)(64756008)(66446008)(66476007)(6916009)(91956017)(53546011)(66946007)(8936002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?HmdwCU6+Tve1wgRPn1BtYxKtgL0WaJ+c2gbC7XlS6uVGtBLkVaoK33E3NF8N?=
 =?us-ascii?Q?9uTKQMYHcCw2YFZgefHcHfh0JqpOWS9nNS+zvAw+LF53le41oAaweB3k1sZR?=
 =?us-ascii?Q?QpdQO3XDfDJZZpXH+RuwdXON3rlNXyCbxgcptV0Ssm0ZQnmEX0nvWzZ+Qhtb?=
 =?us-ascii?Q?+hA0KK7bU5/RNEHlr/f3saiGM63nLAejCl5u4mX8JXeKS+kdbe0VjYvGEQJx?=
 =?us-ascii?Q?lUl+93QZuv7qgkQ97uaK2BiNRjmQBqoB1TT3pw+qH1DmsLuO6vjTQKGXco3B?=
 =?us-ascii?Q?bdQzzo/8lCm+EunEO/+nCoA8laPWG0dVaDDex8MF5c4ziZmvFZzGmuas94IZ?=
 =?us-ascii?Q?87KTJXsxgDhl2sCZ8C2+FD8mtjMnf3C/2UpEnQ9ObR8DOoimz57CEns3R/7K?=
 =?us-ascii?Q?iPYA/GjJUmjSWCHsV2xTP4IXz9gz2JDdBwALi4PXROzqt8wQJc195Lco/N8d?=
 =?us-ascii?Q?qwS+gcOtUrWU1rG4/3m4sa9VxyTtBh7hvImMvzxyVoM9SY2AIvA9kXBe6VD9?=
 =?us-ascii?Q?EZNFnX4zhldwRvAzp7fBXxnxpeWRt+md4mSN1nu1EPY6YRpyt2OWDLjp4oV2?=
 =?us-ascii?Q?FZjEERlI+wtFXQh9qYfejyAaIDAYoji7M39w5JZUGg05SMJSNfKc9SVX8GsI?=
 =?us-ascii?Q?NOS0GyxUsXppiDdILQ5BMrhvv0Ac4krAalRgRsy98gbChCa7MUHm0p4iXkR3?=
 =?us-ascii?Q?g2oyInR8QTZHplLu+fspjT2gTtEXPT/qQqakxDysVCPjKezzCCsOb6sJkkuM?=
 =?us-ascii?Q?2xeA1VpRBtyRcEtOQ98GiRpBGATw/WGKOnbBJ4B65PIZsN2ZIWCM885yI8lh?=
 =?us-ascii?Q?//wr+bndO7gbnrADpKpZWwai/To50xGYTjjcMg8oDZFMspkZ/SxbCTALZClS?=
 =?us-ascii?Q?IWini3rUDn+RbMg+b0avGOOcsM2GWpbPrNz58N3Re4vi7piCtICw31W3gxWm?=
 =?us-ascii?Q?TF8EmXgGxTu/o4YRazXGtnFMdFhPPw3zFptGToGRflz9UjpGQ2LkVpBc/KL/?=
 =?us-ascii?Q?D2/JJfM4t6i8wcciY+mb0SQ/S8DR4Fd9qg005wsQIS1ke8s=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F081A0D4FBA2EB4195639D65D123CD08@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7620687-e19e-4a34-08fa-08d8a5f2a76a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2020 20:54:48.1428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fB8x3iHCGIzrtsaqtDLnXDe654gqdVoaQ0KeJaEobj49qIUpryyYqqbazvZVnB8+vgIj+OzgYkPk1bArLz9VOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3191
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-21_11:2020-12-21,2020-12-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 spamscore=0 mlxscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210142
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 21, 2020, at 11:25 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote=
:
>=20
> From: Eric Dumazet <edumazet@google.com>
>=20
> We noticed that with a LOCKDEP enabled kernel,
> allocating a hash table with 65536 buckets would
> use more than 60ms.
>=20
> htab_init_buckets() runs from process context,
> it is safe to schedule to avoid latency spikes.
>=20
> Fixes: c50eb518e262 ("bpf: Use separate lockdep class for each hashtab")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-By: John Sperbeck <jsperbeck@google.com>
> Cc: Song Liu <songliubraving@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

Thanks for the fix!

> ---
> kernel/bpf/hashtab.c | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 7e848200cd268a0f9ed063f0b641d3c355787013..c1ac7f964bc997925fd427f51=
92168829d812e5d 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -152,6 +152,7 @@ static void htab_init_buckets(struct bpf_htab *htab)
> 			lockdep_set_class(&htab->buckets[i].lock,
> 					  &htab->lockdep_key);
> 		}
> +		cond_resched();
> 	}
> }
>=20
> --=20
> 2.29.2.729.g45daf8777d-goog
>=20

