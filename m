Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 408B9129E74
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 08:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbfLXHdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 02:33:01 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10330 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725993AbfLXHdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 02:33:01 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBO7VbE8023807;
        Mon, 23 Dec 2019 23:32:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Gh2riE+VIqr3NJToalcUMZn4Qbe2Q9obgyhjo/2so0c=;
 b=a+jpo1mlr+30UK/RxFGn4GSjka4NJrUHE5UAJsgQdd3VQscqHz0DoGQlMS5n0j72dzQ9
 9w1QSFmn6VO3oAwl1NW/puvm/vIL6xNFckfeuUoIegcvkf/hgGBtyeUBNtJ9xFoQrCyX
 AIAjeNLnZIUVAUYPKt+bXTgi7wmbOKLjGtY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2x2gx6dy0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 23 Dec 2019 23:32:46 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 23 Dec 2019 23:32:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PPZqMI41yWc4YMvkr4S2EOdajSjcPftMq9R5t4ii7U5a8T4AXKoyqpN8bug7ATjec7QoCY6VbNQuEwSyCe60RrmAqbmEdIaQS8oCyxgXE5EwsY5VVbwfpS4QKXn/QqHxDwi9sRu+J0CrhXPZUL2I7xtxtSgKNgpBUCAdwqKXD5sw1oXkizu2LSGw9Qen52HhNq4K5ETaWH6Rhbe886MjI1jXnyrGSSqexmFn8FKQmIbaTeoM2c3SqNgnqi9LeQAwWWZ7aujBUGnvu/HMKg1ISN724rKiamVUu2rfGcsTW2+xy6+ox3cEae3fwxVyWsWYoJwCIsiFhnp2k8BBHYfYOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gh2riE+VIqr3NJToalcUMZn4Qbe2Q9obgyhjo/2so0c=;
 b=R+EgtXAjIvNS8RVF6z/AaXzFomVJVHdtTY/q8y0mYRmAhu1qzSJIZgSfGLOdj88nhEJ1mCpDsmr8TH7ueNMhsIQv2uVy0J8XZcWusunqD6bUNS2VzGVORMIe61Z0tO4xe9QBw8upsM4xMW50aZa43sniP7PVW2MfJchYsVBN2JjJWLjiDnL5Kq6gSSZQ5xMrcHHZCYj+kn0PoJIL8gCCC/pLRubvVyR3nDdVZgHWm1rsnsxn6FruHlmmdRBicw9DQmdC20JLToCsa60ZceY5KAEYoBBw4ou+XKzCztsIstL+6qHbsPiAz2TshWUAw6r5yA0VUAz897KxVnqOCk9mTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gh2riE+VIqr3NJToalcUMZn4Qbe2Q9obgyhjo/2so0c=;
 b=SSsFJPYGDXe3qslw8ZDjw/ayNhiNqWfJaaI9OwllfYZMNoc7tklExZqp3NpNWT7qBY6UerN1G2zuDKKj3PEEWt3N8andnOiho5S2e27zdvRa+Sp5+wyQ1LBoPLMLAkzIVGqHmwkJuIAVH4ENBwmnAdzAM2pZ8YottADK5f8dorc=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3520.namprd15.prod.outlook.com (20.179.23.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Tue, 24 Dec 2019 07:32:44 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2559.017; Tue, 24 Dec 2019
 07:32:43 +0000
Received: from kafai-mbp (2620:10d:c090:180::446a) by CO2PR04CA0185.namprd04.prod.outlook.com (2603:10b6:104:5::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.14 via Frontend Transport; Tue, 24 Dec 2019 07:32:42 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 11/11] bpf: Add bpf_dctcp example
Thread-Topic: [PATCH bpf-next v2 11/11] bpf: Add bpf_dctcp example
Thread-Index: AQHVueh9eJgyi9Vd8EqEIu9FcYh4uKfIf/YAgABcRoCAAAiWgA==
Date:   Tue, 24 Dec 2019 07:32:43 +0000
Message-ID: <20191224073239.zcrdaybyj7wj4kvf@kafai-mbp>
References: <20191221062556.1182261-1-kafai@fb.com>
 <20191221062620.1184118-1-kafai@fb.com>
 <CAEf4BzZX_TNUXJktJUtqmxgMefDzie=Ta18TbBqBhG0-GSLQMg@mail.gmail.com>
 <20191224013140.ibn33unj77mtbkne@kafai-mbp>
 <CAEf4Bzb2fRZJsccx2CG_pASy+2eMMWPXk6m3d6SbN+o0MSdQPg@mail.gmail.com>
In-Reply-To: <CAEf4Bzb2fRZJsccx2CG_pASy+2eMMWPXk6m3d6SbN+o0MSdQPg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0185.namprd04.prod.outlook.com
 (2603:10b6:104:5::15) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::446a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4bd3202a-df2a-45f7-39ed-08d7884376d3
x-ms-traffictypediagnostic: MN2PR15MB3520:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB35203C838D554DD3C5BAFC0BD5290@MN2PR15MB3520.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0261CCEEDF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(39860400002)(396003)(366004)(136003)(189003)(199004)(8936002)(86362001)(55016002)(71200400001)(9686003)(4326008)(316002)(478600001)(8676002)(186003)(52116002)(6496006)(81166006)(54906003)(81156014)(16526019)(1076003)(66946007)(2906002)(66476007)(64756008)(66556008)(6916009)(5660300002)(66446008)(33716001)(4744005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3520;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +he7pQdIsULj9yIh8Tt6Y2S6J+UeLd85RYwYKkHoFlRh76jMkKf2yziNJFUrNfWgz+G2ETX4QmYXP1FrE0qnPXXK0O55+S7QKCapxFluIEqJBW2zl/dPyUhTnx3cG01bdisZfPIX5ILefUoCkNHYYJShgaFUdGu8y2eymi/hc8KQe0xOoZf3m7vjc2iB15aa5umx25is412LvenSjlS1Z1FQnqrQK1AHB5F9W5lGuV/Gyj+Zl90Bnc/vgEOk8Nmlp68CcGygCQ3ZlrpSiUj3FghHhw4K3724SvHRAGdgoIn3JoKtNoC/LJPVnXKDomL+dJ2Rvx5CBrHfKmGrT/egSCui3kuv0FKnSKRkwffAeEgav0b0lMVOZhNyQNeqEVkQenR47gcYxGwvOvL+tESgRq9r/mmu7nk9g456fJBbmcNtDF1futiqfS0oUB3O8pL0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18DF9400E014724A921DC4A15D647C56@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bd3202a-df2a-45f7-39ed-08d7884376d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2019 07:32:43.6014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cy5RHC4ZYcWTrZ4X9fkCOAOGdbxX0oOY6EQPCZEkvXdTRmvz1fgRAmxZ+9dRV5W+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3520
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-24_01:2019-12-23,2019-12-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 clxscore=1015
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=583 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912240066
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 11:01:55PM -0800, Andrii Nakryiko wrote:
> > > Can all of these types come from vmlinux.h instead of being duplicate=
d here?
> > It can but I prefer leaving it as is in bpf_tcp_helpers.h like another
> > existing test in kfree_skb.c.  Without directly using the same struct i=
n
> > vmlinux.h,  I think it is a good test for libbpf.
> > That remind me to shuffle the member ordering a little in tcp_congestio=
n_ops
> > here.
>=20
> Sure no problem. When I looked at this it was a bit discouraging on
> how much types I'd need to duplicate, but surely we don't want to make
> an impression that vmlinux.h is the only way to achieve this.
IMO, it is a very compact set of fields that work for both dctcp and cubic.
Also, duplication is not a concern here.  The deviation between
the kernel and bpf_tcp_helpers.h is not a problem with CO-RE.
