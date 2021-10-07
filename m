Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252EE4255E1
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 16:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242237AbhJGO7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 10:59:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33886 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233392AbhJGO7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 10:59:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1977TQjp011985;
        Thu, 7 Oct 2021 07:57:13 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bhvj2srs2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 07:57:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDrhTbI/SgZuHzQYfc6u/kZrjD3KcwtU/qzCkf7xnk7FSI14JpXvndLmbT1XpWQ0lJnlwiJA3jg8bkXtbWa/PD36llr7sob0JLnWGzpF72/nU8EW2H/SWk3e4ICx9aCF7Go8NrlNrdfHmo8OBh2+sjb28NVaGDIuFZ1XI+zSEPj7XCHYBHm64AAN7lECL8o3It5nE0/UFiwwRcbSctypjO2kj+MmLTLGzPBGooq8h+yCocekhajdSeUf76bi0KVeYx3SDp3VmL+carCCIVB0M/2QjHa5lybcc0xVZFMFMZOwgirm8WlozYKjqOKsHNwZHJf/DY2YyP0ytsH6ArLzXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f62Z8hR4kqk4gm+PnJdUCUGopZlOQFJwFMxlDDOfWTU=;
 b=ew7283iHI/4gTALGem5o9WOno3t0MiDmZiF3NkXtk67c3TBrLrG/rEdxbEG2w7Em74BjL5OfokBu1HfaKGpTLE68wzmS0H1sj5d4QASWCdBeoS7/PW8kYbZR3JUiuLtBFXnU5paIx7eftWQZuMc7Iu/4T553aww+dnAllXX+WvALzJxYX9gY/kJKKFNLmECACht0+xTD7IS1ixV22PEnOspbRhuT4JDYf8c0HLABs30T6tFH566QMHHi5ScpXDW10olH/yUasBaZCnRoE6EWOXlxBjIxhFH0sE+bLgtSZQWMmtZRKQAOXbZ65KvRiMwvHeHjt54awZEVV6ycGd+nBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f62Z8hR4kqk4gm+PnJdUCUGopZlOQFJwFMxlDDOfWTU=;
 b=fkFk4AdToMKoIJCmGNDVIuCJOl/VfmvVZblGDGL1PHIHoPbkJjzgJEQ6QbeMoKEU5lAO5K8eeHldcpoTbLQUlkT1VRCqvayAAfI20ENEFajbY7Mbi9L765dLoWV3EsXKQVmxA8s6P+GEywgoMJzWgTT5FqeAtvB6pihwvoHKJd4=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by BYAPR18MB2725.namprd18.prod.outlook.com (2603:10b6:a03:111::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Thu, 7 Oct
 2021 14:57:11 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502%9]) with mapi id 15.20.4587.020; Thu, 7 Oct 2021
 14:57:10 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] flow_offload: add l4 port range match
Thread-Topic: [PATCH net-next] flow_offload: add l4 port range match
Thread-Index: AQHXu4ubMEhICmG1v0qZMo14P6UTtQ==
Date:   Thu, 7 Oct 2021 14:57:10 +0000
Message-ID: <SJ0PR18MB400926F5F6A79AAFACC8C552B2B19@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <1633525615-6341-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <20211006173841.63dde6f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211006173841.63dde6f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 780818fc-1ce9-d48d-a484-a09adfe24cf6
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 256b44c4-dade-4dc2-1e53-08d989a2bda8
x-ms-traffictypediagnostic: BYAPR18MB2725:
x-microsoft-antispam-prvs: <BYAPR18MB27259E7F194E698259409851B2B19@BYAPR18MB2725.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q6IZVL5qcHsQCjo1LxpVppeq6/J3IoT8P0xwjWAJJiPdy02YLHwqxPyFaLDL2vhrvEodadblVR/OdsoKhF6rRCZ9427iX0dPr2yighRSx+KwFcjdfu/7MCwB4X5hUtuUVgKNzJJRTV8Se4XKblZDbuTgMJZUcdNzj0hetBVjI+rR8k7cCC2iOpGM1iIf4bgFe2uZpUpMHQIENCfnmac5qBA0hWAasDm6NhU1z4FpF0yWCG+a+8yTrvIC9Noh+c64fGgwIgmfmPy2yXOSkC1lM2RY3DVJG853Q0ZAf8MK0G+yuEdW3ki6m0v0z0JMaR41Lu2Xn4DPpAQ8bGXWB58U1bR35WBdTf0FprvQ3e9KkamrbY9fhAekzs7WWwEXxRSyTFJ0aGSY7NG0dboNreIClyEF7iiy7HeqLIWxKWzfC+LNzwOCYRCKhtNGyPA4UMB+ETXWnCb1jbu8ql4AJfM43Al+GUkudwp4PDXTANNZbK3dUiZTUOXp1h0svjY3OPb3PdLH8D2tCMpC/4pG1khBGbcihxnCtLaSbyxteJU03o889j0wTFGFIegzJnQzByD5VvQ4tcI1rfklJJN2tr5UC55+/5o+bwmjacltNn2daXnijyDzswmtIkd6YnxYtUljSg2o797+JI9v3oOJspU/+885aAJ5r2EFT7ncf14nhXbjvmShGiH6QqhMbFaK4CT9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(7696005)(8936002)(76116006)(38100700002)(38070700005)(86362001)(2906002)(122000001)(66946007)(33656002)(66446008)(71200400001)(66476007)(66556008)(64756008)(26005)(4326008)(186003)(8676002)(9686003)(6916009)(52536014)(508600001)(316002)(54906003)(5660300002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?EKsGJT3/hSlfikZwJ3IN4z4E/LXVE0s1dqM85U6JrHWwMiNNVpolwqLVEV?=
 =?iso-8859-1?Q?eDfMl5eGDuKxIK8wlRQS7izdepdeQTts8FAZVM/NRvKwvZT/hyej66EFQl?=
 =?iso-8859-1?Q?vpxTHrihZEU7KlxjN8qjynJSrgAs+WwxeKAGasaa4mkdVmOXRCur4Ll9NL?=
 =?iso-8859-1?Q?LaBwOxbQoX9tWFyh55Vho/gBgpK2t//big41N/J94/UW8Ut5qox382RCmq?=
 =?iso-8859-1?Q?aBr7vHRetGaIi7F/FHM8fiaXwzXEjlymUcTrFnsYyB14/A2JrN/7dAt3KF?=
 =?iso-8859-1?Q?MXWyyQXbos3VEHSb/BAOR9tvREBUgZtxLPknNJTY1iV4dKQcnTOr35uLff?=
 =?iso-8859-1?Q?8DeCwyTVZgu83JAZcy7Yjdd/Zf7CXMNWN2U0Pm407zjuoziYrmhMTS/8mM?=
 =?iso-8859-1?Q?Z1aKMCC9AI1ZY9RRyy10wXP7wKdPiGAgk4MHKeVwQT3nf3WrZ4zjsJy0cZ?=
 =?iso-8859-1?Q?oLbrZ8HAMH9bdwZavjk3bq7Se+V/sab4Xef8jvvsM7OQgHBT+PxH5HbtMm?=
 =?iso-8859-1?Q?VyDvOPLAzEnKdc11zw+heAhkR6CqPwEvpQIo2e9yM5jtmjJ8sZ2mwA1r9a?=
 =?iso-8859-1?Q?KoG81QaoQYizDFjJ56UR22jryiNCJc16H929QQtxzlNmUsrYT4eEbdFG2j?=
 =?iso-8859-1?Q?D1chHAetfh+s0z4YzJk/b0+QMtWidqjqCS2ZSU6t0qS1mQ+IJqFD2w1b2C?=
 =?iso-8859-1?Q?nfrgSIQK8WbalMWMdEHZ1QQnSVOXwg7Au2DfEoZcuWjE81/iODohGiRPHS?=
 =?iso-8859-1?Q?k9LzqCDWdc3VlRuNq5aCQdQsqgUgMG3IRsvTYTv+kiwGzJAudoxmNneb0a?=
 =?iso-8859-1?Q?qohcYatfAw0XzacT+AzDMYXN7yAkKiKQL6rfPNrV6EXKASNDs8RYe5LTRo?=
 =?iso-8859-1?Q?5gJ9iKobN2/3O6sp2bp8Odd13S9pfjQFyKzG2hOjXM4Q8o+h1Atvx82lmu?=
 =?iso-8859-1?Q?2pi6AfkhyO208OhAHxoZU+hFyB3y4N4IkETt3jb89sp48TFzorggZQrkRZ?=
 =?iso-8859-1?Q?h3PTv0Q/oYyRfMUTccTaUOpW/PNYSla0to/nRw93Xv83UySFqZsupEiaCB?=
 =?iso-8859-1?Q?94PK2Wb+jGfTqqH3yw0af8RvEEMK+XeWu6wrpS+dNKoqc5mPZ3ay7xrl6n?=
 =?iso-8859-1?Q?kRR/hCch79I0dv58wVofqjUathm2zZtEB5KAsWxt8u42vbqCdyl0KFzdgh?=
 =?iso-8859-1?Q?OiBdACmzfT0P2jfCZCbx5MGVS4HhMuRFOiLTMISNsJAFEbMbu6LclBQb34?=
 =?iso-8859-1?Q?gG8hPLT27joCEcIMEn7Po+vJaSdOsJIBVxlkxrJ5LDGc67YitjMzpHFcHb?=
 =?iso-8859-1?Q?DRuAfTFtwlhqV1+OuEvDVORlfCOz9r7KcYX4pt1kXciMGhI=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 256b44c4-dade-4dc2-1e53-08d989a2bda8
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 14:57:10.8298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ndV5q4Zy2wPsojv9rr0Zq1zS1cmzYn7MCWzAZkc13mg3hPTFcirCbvDm8hanXhynE7KLNc47TIc4w5IRusIufQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2725
X-Proofpoint-ORIG-GUID: WF-X-XdPco7m_F90re03OuAPnuLv23Rn
X-Proofpoint-GUID: WF-X-XdPco7m_F90re03OuAPnuLv23Rn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-07_02,2021-10-07_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,=0A=
=0A=
> > From: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> > =0A=
> > Current flow offload API doen't allow to offload l4 port range=0A=
> > match dissector (FLOW_DISSECTOR_KEY_PORTS_RANGE) in the driver,=0A=
> > as is no relevant data struct that will hold this information=0A=
> > and pass it to the driver.=0A=
> > =0A=
> > Thus, to make offload of l4 port range possible by other drivers=0A=
> > add dedicated dissector port range struct to get min and max=0A=
> > value provided by user.=0A=
> > =0A=
> > - add flow_dissector_key_ports_range to store=0A=
> >=A0=A0 l4 port range match.=0A=
> > - add flow_match_ports_range key/mask=0A=
> > =0A=
> > tc cmd example:=0A=
> >=A0=A0=A0=A0 tc qd add dev PORT clsact=0A=
> >=A0=A0=A0=A0 tc filter add dev PORT protocol ip ingress \=0A=
> >=A0=A0=A0=A0=A0=A0=A0=A0 flower skip_sw ip_proto udp src_port 2-37 actio=
n drop=0A=
> > =0A=
> > Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> =0A=
> A driver implementation needs to be posted in the same series.=0A=
> Otherwise it's an API with no in-tree user. Let's consider this=0A=
> posting an RFC.=0A=
>=0A=
Ok, thanks for the comment. Will post RFC with driver code usage included.=
=0A=
=0A=
Regards,=0A=
Volodymyr=
