Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B312B9F96
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgKTBGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:06:01 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42760 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726321AbgKTBGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 20:06:00 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK14qA5021464;
        Thu, 19 Nov 2020 17:05:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=lLE9SxUQzGenpqUdnDwOe6mY2TPpMuiH3eAx2erkOUk=;
 b=cqS+rMKRP5zFDgTTedMtCEEvHlpYIL0jVhVfRwEs4M5UMRCkaLeq3FCbzbdARTs1Wi/I
 t+3AiS5f8OQFNOd8Hh3vTh5PANYU7ezcpTKiVRnw7b/yGMLkitFmo8zV61QpvWYhpopU
 mT+zlE1Sxv41u0n0KYKHO+vQlMYQKx0LItM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34wbeptxbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Nov 2020 17:05:43 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 17:05:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKJPZwd0QCfVt1gTYN+TPj3EqJqevST78WBaTXG6RQFX527QlyOAQR7TlrnYktTXzz/VXCpKadmggqIoDRzluBYzGGx50IxgftPMeSxm7/Oo6wUC+BlBazDg8NHhDVaPImV6kCk3Rc6PhNzcKs2iGNJ6rWuSU7rI2Iyal/8S613FlyQzp3pmdGnsaejru5kHFhepXeDwEOLLQwpe/OtOkyW65+fB74QTk3uwaZdwVDFirK4cukoe2kqq8lGIViO444ZV2NRhDsikyb67eu4DXc7rAHd7NlYRl341pvtt4oEe4ywZmuHF7E9fulPO7MuOP7L2bbD8+JTmNi6W9aFeBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLE9SxUQzGenpqUdnDwOe6mY2TPpMuiH3eAx2erkOUk=;
 b=DDEWqE1eR6U6ED4tMVd5bp+7J9taHDLeLb42zPZk/x9T/5FShbDA7UidTBRYNTHH1JwO2ObDXOs74PTFjzHEZIgH6huLRMMEoKe8JTjrLZNwaMEzUdxZcrjSQKn8vsWTSwrQBmZ7NBb6KNcWSVZx+82Hq1wlIMTVv7u0sVZ2i6YfFr93bKlnDfz8Vh7trF27qdqNhH3fFHd1HWcUjeXfTLbnpZoy3+DYxlzdc1CzdkocdIpWySY4CSyGtEhZTTZQyepgLOLQOxwaTEwzMLEx5srhaYL5+v0IZKXThxJG38PnelUtkVvfWY6kI4UWJfM/edRf5S3jZ+5+dv85/k6UUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLE9SxUQzGenpqUdnDwOe6mY2TPpMuiH3eAx2erkOUk=;
 b=Sip9tQDeaJhei1rxODBSthsL9swolbI0GkOXHgBD4i6cHEU7Bjo/IHKHwAnLoAr+ZvxXWScwjUdl5kbBacM1sVXhSOkvXHATk7ChR5jHDv/1xRk7nXzyIZeWaUZ7nipapI1GyxR1+J78NRKK2m5YQtW7FmubcWcKUuiimu+Rpr4=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2647.namprd15.prod.outlook.com (2603:10b6:a03:153::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Fri, 20 Nov
 2020 01:05:41 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 01:05:40 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Roman Gushchin <guro@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v7 06/34] bpf: prepare for memcg-based memory
 accounting for bpf maps
Thread-Topic: [PATCH bpf-next v7 06/34] bpf: prepare for memcg-based memory
 accounting for bpf maps
Thread-Index: AQHWvpq6YLSkgLftzE20TA3OGTR2XanQNU+A
Date:   Fri, 20 Nov 2020 01:05:40 +0000
Message-ID: <FC95D421-CD1F-4344-A3C8-CFDCE79B3BB2@fb.com>
References: <20201119173754.4125257-1-guro@fb.com>
 <20201119173754.4125257-7-guro@fb.com>
In-Reply-To: <20201119173754.4125257-7-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:f2e3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34a6d6ee-5816-41bf-48f1-08d88cf06642
x-ms-traffictypediagnostic: BYAPR15MB2647:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB26474910C8A82D5FA0C887CAB3FF0@BYAPR15MB2647.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xSAGsJSJE3Bc0ZvjTEV/4q6jB3AssDsVd6UqlAAnuAOZhgSzb4RmxeLTN5YI5/CPp8c6wgCSeDWg3DO/MvAfLIIkTv3qLvp7Wrh+CTlQancpMG4yzO1yUfxoJWahgVaRjhlui0yPSbfhEWXwJGnYhQjMIanDg95inVI/f4F6jpRx54S5eeY3rfQPqlZfe5XeGaBT9ochgQGQmSqGRsfdz3vnn2TFYmXp8pV2/hfUAPNECiP0l1WV/oOfVf1KmoaFZV6TGj10RECbHQzAwd+ak+Shh0p280rBTEmPbcoVMyUW3iccE43L3m+DJUivHmoxrW8zwP4xvMzVO3z56eIayg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(366004)(396003)(346002)(83380400001)(2616005)(316002)(66476007)(36756003)(8676002)(66446008)(76116006)(186003)(478600001)(66556008)(91956017)(66946007)(53546011)(64756008)(6506007)(6486002)(54906003)(86362001)(37006003)(33656002)(15650500001)(8936002)(6512007)(6636002)(4326008)(5660300002)(71200400001)(2906002)(6862004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: XWDFbJls+7N6Wh5AQ7oLoQyGN13y2X1Mz/6SLCrWYva241iVUJkgtOXJvmFpItPI4xk4PZysuvYHobd8TwUvwX/NqoNwPMeIXPIivFPyMcZUZxvPS0bGSu2qkYRJnIFuAd0IWp0LecufBEyrsqf31DkPNGX24mE+9nj2tOhtu9HCY6E1IaiEneRSqWdLoP+CIDUNNNxRKd27MzdvxTXgLuafn6v4AS/Dcf4KzaXmhc31DPQx23iiaSpq1gmE2xI3dJ4naQbpX5sIgs4xaUfBQif/YbFnLvOS2ZNuPNlb6xzFOEu7ytp/L/3qmr5D9qty+QKZevgQny+hE4VrHeR7j4IluY7Ar6R0GrURNQuF7BjFNoKGYeHwdJyNwEeW6j3wXb4w4UMB/FxOgdmYkbSPyP9TKryxldUXmrMf+0QZUKF1YMYJqNQfm6c0uZpqOY/PUb3I/21KbNfmvfML6dyyhVtXF6kKko7oQefKz3dxLdNJFlcDqDzw5yRHGz1mxP84O8A1ChvueJHrwtxnPGLjYRMLgl6OKWsKXfG60H4358Y6+VETwWUvMH2iFSCpQczBPeYph0UhrGNyuniomXOiTd9qxKRhpTOlvznfxWt5UHNlrhljQrDzgwiPQEO/hUJhGhMQDXD0dhDJ3GkSs/JG0pU1rybXPiN8xPcz4TrWHi8oGrteXNJNDNKjO5pesOyJBhu9VRkTpY3ikzTkubrlvMTtXwCly3LzLN7PJbXGpZKtVUjk3+VGS6eioYFAvd2WD2o5dRrjca5o/Hd9th6azOFUUTwSlw6lBh1oxo+KowmgoajDMKxJjZEKWHAc5hY+C1iwr81u1Q0JIOaDnGLimMgMVgI4doi4hTxQ+akNEaOTi+yT+bMJPLFxk0ZyNxo4XCwMWEjHhZwwUeh8I5TMCNfMdaZofic7rza/DcdM42s=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D420ED52B7E78849A2843DBF0808203E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a6d6ee-5816-41bf-48f1-08d88cf06642
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2020 01:05:40.7945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OxpjEN6iytC35IoO+S3XTHqj59kQCxLDqAU1Ka6X2ZQeAYDdbwrDO9AecfkvRyrmW1XJI9RmVSi+EeVMF2Ylcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2647
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 adultscore=0 phishscore=0 bulkscore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011200007
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 19, 2020, at 9:37 AM, Roman Gushchin <guro@fb.com> wrote:
>=20
> In the absolute majority of cases if a process is making a kernel
> allocation, it's memory cgroup is getting charged.
>=20
> Bpf maps can be updated from an interrupt context and in such
> case there is no process which can be charged. It makes the memory
> accounting of bpf maps non-trivial.
>=20
> Fortunately, after commit 4127c6504f25 ("mm: kmem: enable kernel
> memcg accounting from interrupt contexts") and b87d8cefe43c
> ("mm, memcg: rework remote charging API to support nesting")
> it's finally possible.
>=20
> To do it, a pointer to the memory cgroup of the process, which created
> the map, is saved, and this cgroup can be charged for all allocations
> made from an interrupt context. This commit introduces 2 helpers:
> bpf_map_kmalloc_node() and bpf_map_alloc_percpu(). They can be used in
> the bpf code for accounted memory allocations, both in the process and
> interrupt contexts. In the interrupt context they're using the saved
> memory cgroup, otherwise the current cgroup is getting charged.
>=20
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

[...]

