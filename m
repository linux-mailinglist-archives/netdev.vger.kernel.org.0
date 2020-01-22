Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC22145EFF
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 00:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgAVXLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 18:11:54 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27248 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725884AbgAVXLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 18:11:54 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00MMrAsQ030221;
        Wed, 22 Jan 2020 15:11:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4X6gEVMAMq2RQTZ8Bs5xRdJ9CeWGBrh7CSSpKmRuI/8=;
 b=m1xyj6NS8l46Zsy6YfU8ck74qskorsBU2qRdpHlHqlO1GRSoLXrP3ujd2R0C61GSgank
 4kOhg5f14A+ramSEnVXs8EC7A/AZelhXrqsSFko1+QYvAn8njCadBMfeJppDK9mIaoiL
 7WV3WOu9CU60G0/VSnJ/eAUeOPtcewi7eSw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2xp5vs6rbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 Jan 2020 15:11:41 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 22 Jan 2020 15:11:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEq1Ek2BW4ORzwrvPcqcav3389tatoNhgAM5wKjvns0ESVN34esSEZ0u5HwYcr+EpKqDCJT2n8+Nl3weQ8hy9YN7lvdKZ+LEUPISkdwLdPjA9wM2vWfYZkHlzk52kmBj9jMVuYGrv6tgCBMRhLqsq13eG20l+h57GFbtMtV55c1EC6kLko+422+AKcRmQFhg7u7Mxc5YMXvhu10I/mok63bTVxtChrg3q8sTmNN+KAhjQeNaTENSldEe+X3uHhBgvwWO6U3LFlm2elKI8x1m82IH5mIJ+V+9emwXjnyTaCTKUspTFceYM0SNPRPxxvbmNKTSDA7Soe8gnIiCNxC0WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4X6gEVMAMq2RQTZ8Bs5xRdJ9CeWGBrh7CSSpKmRuI/8=;
 b=JYuDGYcTEN4MOhD+wmEeSjUOGJSPzruMndAQHp360fiqdQAxuF9O15jUu9JUWN27X7rt59cuoWISgb6kqkdkb1qEb9pyTOr/lJx4/MgQgFeKuuQEemw7UxO1wabWQA5L0dcX0IV8LgcgTNAYcRSgLp5WJgi/ihLywkRuxW2pB5B8N6kY1BlzmodwRZPMj9zTfiwFk/xaDGrV6n0123zcIFsRAq88ezJIuDwyPN+PsjwEN71dRpVHhaZZdwQkcJQYUwyQg1talQlsghRK7Ry2G+YkTFD7Is40gQHoQGbdQPtINCSdSZrhy7swgskqy/lVxepGuBnfNC1WK0WD6Tf/iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4X6gEVMAMq2RQTZ8Bs5xRdJ9CeWGBrh7CSSpKmRuI/8=;
 b=hryubOsIdlVbc1ZjgdshrsRb70YNx99cfbFf2fV8c9etbPqoCHlpb/eLs9YSkQWJaa5PJvVRNycS6lKFlahzKkX96LZosGr5aGY1bbm4kaYBe8LKP9ve/+dkyr4rWiVTq0KyhaECtFPHII2prTV6f3ojx087BljZ8LWrug9Df74=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2766.namprd15.prod.outlook.com (20.179.146.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 22 Jan 2020 23:11:39 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 23:11:39 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::ccdf) by MWHPR14CA0041.namprd14.prod.outlook.com (2603:10b6:300:12b::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.19 via Frontend Transport; Wed, 22 Jan 2020 23:11:37 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v3 06/12] bpf, sockmap: Don't set up sockmap
 progs for listening sockets
Thread-Topic: [PATCH bpf-next v3 06/12] bpf, sockmap: Don't set up sockmap
 progs for listening sockets
Thread-Index: AQHV0SS0YVQ89hBmX0ab1vzU0B+9tqf3UEuA
Date:   Wed, 22 Jan 2020 23:11:39 +0000
Message-ID: <20200122231135.igubfiivymp7usra@kafai-mbp.dhcp.thefacebook.com>
References: <20200122130549.832236-1-jakub@cloudflare.com>
 <20200122130549.832236-7-jakub@cloudflare.com>
In-Reply-To: <20200122130549.832236-7-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0041.namprd14.prod.outlook.com
 (2603:10b6:300:12b::27) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::ccdf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f282a011-7b76-4fd9-20d8-08d79f906f63
x-ms-traffictypediagnostic: MN2PR15MB2766:
x-microsoft-antispam-prvs: <MN2PR15MB276654E67EC281C6A498DD8CD50C0@MN2PR15MB2766.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(346002)(396003)(376002)(366004)(199004)(189003)(316002)(6916009)(54906003)(86362001)(71200400001)(2906002)(4326008)(478600001)(8936002)(52116002)(66446008)(1076003)(7696005)(16526019)(66946007)(64756008)(8676002)(5660300002)(55016002)(66556008)(81156014)(4744005)(6506007)(9686003)(186003)(81166006)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2766;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: esUAHoLZE43k+VIgrG/8hYypVQKcRNpjdhPcrQxoy5EAqA0+9sIXEmD/B0S0y/wXGhT0cUppvFUa6M7qm89FRYmgaHei01JUHPl6r1ut02Tcu4c6x8mrXhCOxxIy/yoki+YkcEeTQ2PcUPkd2Xb/C4j1HPZqsr8snovaOt87hOxynrnP/iCMnKsppmnKCaAS4IYy+wodNS6v7gjmILLqODSklhJx+OjsLkydGEyP/cHuYPO0cYPxJVH/dmKDi1Hf+sG1ijIQJCA3SiY4m6RESOy6XW2RcUMJte/z3j/vf6qBwYJhNEr69jXo+haMDtLJYjqbimTFHiqp1Hct5r3bVQdPb/ouv5InrHkqTxHpsAmaZWvxOngR1g6rSSlVFfco2DFxYNEtkEh6IQ13DXkuCDUs4MNouzgpcDOxBFdRydtzqPeLoJhDB6H9xQp3+aMn
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A5C092F48088A64F848F6C8EE4752DCC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f282a011-7b76-4fd9-20d8-08d79f906f63
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 23:11:39.1367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UL+GZZ3LAWkhvOzs2UzViUfLgn9h9GGNgOs5tyUDxYmRIMPOqGG28VdIfVn4Zl6V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2766
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-22_08:2020-01-22,2020-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=738
 bulkscore=0 spamscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001220192
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 02:05:43PM +0100, Jakub Sitnicki wrote:
> Now that sockmap can hold listening sockets, when setting up the psock we
> will (i) grab references to verdict/parser progs, and (2) override socket
> upcalls sk_data_ready and sk_write_space.
>=20
> We cannot redirect to listening sockets so we don't need to link the sock=
et
> to the BPF progs, but more importantly we don't want the listening socket
> to have overridden upcalls because they would get inherited by child
> sockets cloned from it.
>=20
> Introduce a separate initialization path for listening sockets that does
> not change the upcalls and ignores the BPF progs.
The change makes sense to me.

Acked-by: Martin KaFai Lau <kafai@fb.com>
