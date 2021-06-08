Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7919B39FB5A
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbhFHP7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:59:12 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56376 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232948AbhFHP7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:59:09 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 158FpNc3030630;
        Tue, 8 Jun 2021 08:56:50 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 39266ghgqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 08:56:49 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 158FqoKN032222;
        Tue, 8 Jun 2021 08:56:49 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by mx0a-0016f401.pphosted.com with ESMTP id 39266ghgqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 08:56:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yoe3kJSfQwLRvqwxqJt0Eh3yyVOF+o/xtuBiRg/rYmsxqiGJbNLY9L3e2DP2bnlCFIjfzzq3Mpvg3p2SRJkyuJfZ18txc+LivpK1NlXx6RAFyIt4jpFfQ6sMae0VCNlmVAXAYF5fSQnmrAm8JrtZLKn7jgY9DRGjHXblal/pJKRaWAkp1bJMR9IaGOfyv+jdPCjkKwKL50k7s2eb1G+FEWLu2aQlOevb1Z7LQT5HA/9Mqw4/OZ3TXi1L29cQn5pGT1YZkMQ+pFUhjZAPoRwez5Lv19QniHygWD1yRxHrDgGM/DIxPbLgbMa5ael91Y3PGvQTL69XGECkdC7puyyDcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfhsk3QT9Whc4gX+NCMZ/vUhqpChGArosXA+Oip5U8s=;
 b=KrfWggbhAk7OB1ucTYLfF5Z1JYoMPjYGzmftuYHb2zIn+9CrV/PdQokr8BIJYGcpVrQZYLqfOcwUtjCLEH25OxnJvhZHskZPEVvO7KX5NrlaHDOPQvgCiUDAW4ovXJmLhQtZZJNioDx/aM7akLFl2tLetxt61I4R9NPzjypTwDvAiwC9vF8QSJsu0roZc0IVCTFxmBgYvdr6BMvLSr+m90kmyRRlo/TufnDwgSGvPA8qnJr6wlYN3haQrkchKAyA/+/GywWkJTqDkuNgHpvPN8My0QcmuLZHS3TEeHtGHgSb4buAERCAVO03k8g0+inTALBelye5/A/B5q+r5MLSGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfhsk3QT9Whc4gX+NCMZ/vUhqpChGArosXA+Oip5U8s=;
 b=BHQIsqrA6F7b7ZL18pOAwGQFA7vpqPT2RmUJekex4eWwDPxW2D+/FdYf0jcH7YS2ibBCoxWGzXR7PAQPQ5suyoAJdHMelwIe8SFx8cFiL7ndhK9BvdiPy2FTNwbddeXHJ3mQ0LL8zXtwxd/Krf7G0dt1VxlJPQsRnh56jFVFQGI=
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13)
 by BYAPR18MB2584.namprd18.prod.outlook.com (2603:10b6:a03:134::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Tue, 8 Jun
 2021 15:56:46 +0000
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::419a:6920:f49:3ece]) by SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::419a:6920:f49:3ece%8]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 15:56:46 +0000
From:   Shai Malin <smalin@marvell.com>
To:     Christoph Hellwig <hch@lst.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        Dean Balandin <dbalandin@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Petr Mladek <pmladek@suse.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: please drop the nvme code from net-next
Thread-Topic: please drop the nvme code from net-next
Thread-Index: AddcfaunhQky7z/HT0yvxudPd4D82A==
Date:   Tue, 8 Jun 2021 15:56:45 +0000
Message-ID: <SJ0PR18MB38822C7D07B54625B26C39A6CC379@SJ0PR18MB3882.namprd18.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2a10:800c:351:0:9192:42fa:977b:7677]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f64a7490-dde4-4ae3-711f-08d92a9604ad
x-ms-traffictypediagnostic: BYAPR18MB2584:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2584AC9DD9D1EC6F852F2262CC379@BYAPR18MB2584.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y/91B3m+/wvtVmhpW/gZU1Q8mW+/w7Oz181EaDvGHmBhlLIxxqaeAsC9fMMeeEn4hJVx9UfMr8zJQgRmKPnzmUReuxQ7FrIWXvRB436HlvnFwYIk4L7+8nL0zwBKSixtAKhY/WNq0QFtFg94qCQ30mXkOS9Wtq5M31C/D7A1jWw0wHp4sWfgDWARz+mu1vEPBInFcmbr95okj51xE4IoXO+KoNHvbBkXf5KdOobCTjhpo4eVZuhwcayk/tv8u6pqnbMwM7hBxSePDz6t7bPFkXzUSl0iwFBshhKrbnED2RZ0C9jPeKNFVTqO5JYygVut981Siwaqe6pTFug4801jRIv36e8nVApoBpnFQdPV/BMRdRXIRJUatQ698xi5AQ3TdKwFUNXqTuKQ8y9cGzWJbZFa6akZvfbSIJrjEJZECiTIUASFLagJB3FG5xlduE7IgM/D6PggIT8luqf/SyAlQGVSeQ6NX1Bdb9N7hYccRhhZ5Hfa9euviqD5Yp9gpzdbHdqb9AZwhlkr5XCNcEgf0XWoQvLlrEprWoY/YeopJ5YX5YtMTsXH6irYIVE6xrFaQv3ELvNXFYQN6kJ5Gv46DiwtllUod93ew1OyUVg+n5IVCqH4buDYd9QIDSXqQXOYbTC68yJNOMWWx7NGDUDEL+kGBElq3833I13tAxKx7iCYXH2hP5JGojlc5fHYCX3Pnbze/KxlPrB2IaBs7WfAkTu9rESSvS48sPawZIyi8j+tAMYsr6R8P5qC3DP3CoxT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3882.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39850400004)(66446008)(66556008)(66476007)(64756008)(7696005)(76116006)(66946007)(2906002)(86362001)(122000001)(54906003)(110136005)(6506007)(52536014)(33656002)(53546011)(4326008)(38100700002)(9686003)(5660300002)(7416002)(71200400001)(966005)(478600001)(316002)(8936002)(8676002)(186003)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KcpnV/xvBjfOi9TtQHvrgqDj1tQpZVzercYGxQrVQ2l90nm7xVUot3fXsA7E?=
 =?us-ascii?Q?BXjMzv4twawD9VQD2w+3HISuU88rsw7DIAioZKTtMz3kCgt3sRG+5BGZ5U6Y?=
 =?us-ascii?Q?ZxUe8A9jOXG2qfheg+Y53eGJnL1EkZu9LQlTKnlTGx9BLjvH0bXLIi4xSosG?=
 =?us-ascii?Q?MchciMA70V041NoVsu5T45LSuhMwrv3Szo6+w+nfAgap2R305AMR94FwYsDV?=
 =?us-ascii?Q?o+jWtqAOOJZz1du8p2R9WbBiQLIe/pECLHZSHMs2DD99ZkMDoV4gGhDCVq/t?=
 =?us-ascii?Q?ShvtfCJ7e7mn0CKOsNR8qJFmhBTKpaR8/xw7K6Y0uT0Ew5rF77wdy51lYu4g?=
 =?us-ascii?Q?W+umEL6D7BSFOz/IIlf12QWP7PIU0h0VtqOk6JUEnPSTAqyyAheV/s0tO9kz?=
 =?us-ascii?Q?zO//dr2R2OdMB6n6EEcty7r8qMgPrq6kkEsg+uPsrRZyUyOW//bg3aOCb4K+?=
 =?us-ascii?Q?+WzLsGtRRPOod2F9woIcKj7ubr++RLfUJWpFB06lN0ztfYuVf73fsy6Q+uyE?=
 =?us-ascii?Q?hqbMtGrsiELECB2JSiUJjrwrqBpzOYkzhZeH2m1pqDWmSC0C2gau1S9lfowK?=
 =?us-ascii?Q?/Czwk3gwadg5kLyF7FD9DTOzKmlMmIwmTx/wn/EbwbwtMd+L9b1lqMRAFV4r?=
 =?us-ascii?Q?wq7//eB3ssMYD1g48aQeK6Czj23tvbdyeqz2iXBJjfcjVsfyC30QfqfgUy6T?=
 =?us-ascii?Q?nM54e/aYDW3Aonh8MzG3mMOYfYmcJzB8J8hkTXgvhpfRURSVo1ganOQyskGz?=
 =?us-ascii?Q?h9CUKJDpuSoP4eQZx426K2xHG1wBt7FEMq9SXF/xE+BSC3O/DTGFZ81nyRrC?=
 =?us-ascii?Q?DNtlmIqXn1SWa5Nqa9ezzVG4R3m8vGBVTX7arJCuCkKqrU8KcMNrPx47ZQK7?=
 =?us-ascii?Q?Um6fxmDD2CcvDncIV8NntXKPCa2sp4t0MiYqlwUJsYeKFfhm1S/vFUIBvva+?=
 =?us-ascii?Q?lV+V60dr3yf0eEEuSsnlVNnbivxGpwpFOTtJDxC188JEz2TrV9GdwhEls27N?=
 =?us-ascii?Q?13ktDi9M4Gvc3ArnVkQrb0XwW67UptngPS0q7S1sjL65ebJ1FqY5p5T0PpeN?=
 =?us-ascii?Q?7S8SERENdOWzK32mOjGxFRetASxHWXCuyoftao5oqL6jGPKuypFyEwdf47dp?=
 =?us-ascii?Q?zqmfXbHLO4ioAe/kbpaNzAH8Z6LIsLhN4KtphX+obHj58OCdFRjU7vh74vPF?=
 =?us-ascii?Q?6Ewxb8BNzHWOldELzSRkHKcQT4RyS1BVq21muSBv7esJrRw2vbLx9TC1jMsi?=
 =?us-ascii?Q?CCiY3aXyHLif0xqtJ+TkgGbdki9DvyQwb3oTZYz+Bwj3Ywchf49VfKCkLp1w?=
 =?us-ascii?Q?aDkTNbECoJ/ulwxTnavAxChxxFXPkq1btD1NbzBVca+KpkIIwxMxVVUR8lsG?=
 =?us-ascii?Q?ZbE5aGA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3882.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f64a7490-dde4-4ae3-711f-08d92a9604ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 15:56:45.8844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IoE3A+7MWvq/2P4zbqsd7nuNe0zjJ2+ETFHI4X9Ezp40k3bXKFasm7inKzuyFwnnh4v+gu9x9lQJQH2jMt2hnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2584
X-Proofpoint-ORIG-GUID: wehbLlINebCCHOhUOzjXkqBFoBxKjvau
X-Proofpoint-GUID: Waf0eNEH0Hf5lPzMuZc01WRqkOHtKptB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-08_11:2021-06-04,2021-06-08 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, Jun 8, 2021 at 4:38 PM Christoph Hellwig <hch@lst.de> wrote:
> Hi Dave,
>=20
> please drop the nvme-offload code from net-next.  Code for drivers/nvme/
> needs ACKs from us nvme maintainers and for something this significant
> also needs to go through the NVMe tree.  And this code is not ready yet.

Hi all,

Sorry for any confusion we may have caused. Our plan was for the qed series=
=20
to be considered for net-next, and for the nvme-tcp-offload series to be=20
considered for nvme mailing list.
We attempted to communicate this in the cover letter and the addresses=20
in to: vs. those in cc:, but perhaps this was not clear enough.

The plan was detailed in the cover latter under the "upstream plan" section=
=20
https://lore.kernel.org/netdev/20210531225222.16992-1-smalin@marvell.com/
The series is structured in a modular way so that part 1 (nvme-tcp-offload)=
=20
and part 2 (qed) are independent and part 3 (qedn) depends on both parts 1+=
2.

We have sent the first 2 parts which are independent:

- QED NVMeTCP Offload - https://git.kernel.org/pub/scm/linux/kernel/git/net=
dev/net-next.git/commit/?id=3Deda1bc65b0dc1b03006e427430ba23746ec44714
  This part includes the qed infrastructure which was discussed over the RF=
C.
  Our intent for this part was for it to be accepted to net-next, which it =
was.
  Dave, from our perspective this piece can stay in net-next.

- NVMeTCP Offload ULP - https://git.kernel.org/pub/scm/linux/kernel/git/net=
dev/net-next.git/commit/?id=3D5ff5622ea1f16d535f1be4e478e712ef48fe183b
  This is the nvme-tcp-offload ULP which we intended the NVMe tree,
  and it shouldn't be merged to net-next.
  Dave, please revert this from net-next until nvme maintainers are complet=
ely=20
  satisfied with it.

Christoph, we would be more than happy to incorporate any feedback you may=
=20
provide for any part of the series.
