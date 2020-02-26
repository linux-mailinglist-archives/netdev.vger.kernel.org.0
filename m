Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2846E16F954
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 09:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbgBZIMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 03:12:43 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53796 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727247AbgBZIMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 03:12:43 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01Q8AGAZ006814;
        Wed, 26 Feb 2020 00:12:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=F6WaUDCaYka/b3TDB39yYD6+my1XajZ8zN2JOZSG62k=;
 b=Qc4Ks7XJZZpJLTXpisQwXSolRt1ioDO7RA5Iphq8zdSHMH9Sf3FWaePdSRcBqU8wNPsM
 cE7/83SD3PFFclJcAevoXFmBKDqxokC5svLWy8btv0x2lJJBnpD8WYu1TZUaKFV/iC/h
 J/V2YqE8NuoXJQjBfVkfTjeXkZAWW2OxwtUcms0mXmBnSEHg919tipS4ChQWpd5FM/6W
 ig6Q/8+Ki9Oi53K1vsA4XxNiIZhwfJtKx1Pgvom70mPflpyIV0SlczqVD0kCbrMxdT1p
 mxlZkIwAs6Zo/BjFDDrDtQaZIRWQb82QzAu67cFQNQagQPzigo9LGIZM1Yhr/HEa5P3J LA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ydcht9utp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Feb 2020 00:12:37 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 00:12:34 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 26 Feb 2020 00:12:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+4hFIS7PV8LiwHmxN/LkBjV9hue7t0YibQbviyDz6TUVbSskjcysJGoOiZg0nW5RjsxNRWHwteK2jKMb8gDk7crT/mpkyHsH2k0aJxFXBaCBObG6Qmii9qBED3lpG2Tqc+WWtZYgwUVTpIWJ0e00ey/drBTXHnxRXbL8WlFzFXAbcxp0PTlWRutSAtNfoMgwPAH1ZSQDCgitEYb6w3a6crNOLEaSeYQk/dFesoX3OOtIHuRjrTxn3UW845ZYsmHpv7jVJ2LJqzdh25n79uKPrbInx0EaaTV6nglnxyRf0oidx2SQw1jKN3cWNxlmUZWkwjLQumwHsdF3BF1LOiApg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F6WaUDCaYka/b3TDB39yYD6+my1XajZ8zN2JOZSG62k=;
 b=arvUap/6RLUpwjcRPYRl90rxt457QcCF2Ge3Gorc5A/yj8lY3p1eX7ey+wPd9R35lxAHP13rJuJc4XqtmYGnIEJN2XcrFKEcdQ41hRzII8O8oZekiof9Bu9+yBjbJX27e/gjAzQyq6B1FbKgmonKQYRju8GwMf6IvPR/q+fq9MUxS8KijBrCvocCy/2vuCTY/Lq6Q2o/+ON/wBHsmlkkEwy6JC6fw6mlGm10JQHjJsCmhBc5PWkbmUawRFZH667/7KOYy5LNJqrycFfESNNHuSw3tVy/GLHLDMf0BQzCGLa+v8MZF1vv9ABak/3DN+FZseU/+crNl4K1Sk0ESHgw6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F6WaUDCaYka/b3TDB39yYD6+my1XajZ8zN2JOZSG62k=;
 b=Kpia2VzWagFvpqH6hoR0OFAAYZHIZ2fewdHxgcQ6YBM6D895yk41EjwwE1RlfGJoUmif2W6c+lXfUd5CB2y5NQevECu6/An9wjWjIPSXqSXCr795vBBJ5me/zldjj9cZAyI76H78S0hNnu0E82GXHgFdtjKRLWOnl9/FfYaWt9Y=
Received: from BYAPR18MB2630.namprd18.prod.outlook.com (2603:10b6:a03:134::33)
 by BYAPR18MB2439.namprd18.prod.outlook.com (2603:10b6:a03:138::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18; Wed, 26 Feb
 2020 08:12:31 +0000
Received: from BYAPR18MB2630.namprd18.prod.outlook.com
 ([fe80::d50c:4387:4e94:1d28]) by BYAPR18MB2630.namprd18.prod.outlook.com
 ([fe80::d50c:4387:4e94:1d28%6]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 08:12:31 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        "Dmitry Bogdanov" <dbogdanov@marvell.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>
Subject: RE: [EXT] Re: [RFC 00/18] net: atlantic: MACSec support for AQC
 devices
Thread-Topic: [EXT] Re: [RFC 00/18] net: atlantic: MACSec support for AQC
 devices
Thread-Index: AQHV6MdJxy9M23eEgk2Dz8/X4mXbwagtJIiw
Date:   Wed, 26 Feb 2020 08:12:31 +0000
Message-ID: <BYAPR18MB2630CB1BE0BCD0878612F86BB7EA0@BYAPR18MB2630.namprd18.prod.outlook.com>
References: <20200214150258.390-1-irusskikh@marvell.com>
 <20200221145751.GA3530@kwain>
In-Reply-To: <20200221145751.GA3530@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78662328-ef2d-4a52-4258-08d7ba93a0a1
x-ms-traffictypediagnostic: BYAPR18MB2439:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2439A8ED5FC4BFB767D8C0E7B7EA0@BYAPR18MB2439.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0325F6C77B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(189003)(199004)(71200400001)(316002)(5660300002)(8936002)(81166006)(2906002)(81156014)(8676002)(54906003)(186003)(86362001)(26005)(9686003)(6506007)(4326008)(52536014)(66446008)(66476007)(66556008)(64756008)(33656002)(66946007)(76116006)(7696005)(478600001)(6916009)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2439;H:BYAPR18MB2630.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g+hNiF9P0RjRojSmWoxBt9jMoSZraf6JwVWGStgJpejhkjpkeMMgtWs0ISYIAUZ5Zx4P5Zbi+uhUgPAEurU8kR3T9LrRfwhiTwbWinrTAYBBhcYOC24CJFDZDxksZ6SkAovf42hoxDLwrVQUQcjO3lvG9cjD1zuPpeVZSNJL0lKak+kMyHNqTSDU4A6t8I6p1TKxHGUerYQR0xqQcnSBuzQD1JwwodoLd/4yoHt+vWffQVJDovss8Sq1FCtyon+xTr2yLZYk5UhdPaJdWb9X0upcn9nlrBInhyHpitXY1BVUca/GUkMBGI3MpUHHfxFIyzcTb8XWz5h14AhtNqpICt95joK9ROwUIjXY3s0vU48BtgK/aMWXAgo++J4GvsjWkkA6h0S1T6ltrqSTF1HT5tpL/HBqTXGfOsSOwnXkdg1s627/F3/HuqgtIra17L2s
x-ms-exchange-antispam-messagedata: OAZB0IUyYlBvlZc+4NRBa19tb8cB7SbKeMsgPAtiY4/0Op33zQTc8c+d0xtehJMdwLmOvu5EtIGNZX3Z8/XEaMMMtx65R4VowOtHndKsmfQicJ9WJuSkbGb8DEGtXJz5NDMgUKFnqvm5LnyU1mfB1Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 78662328-ef2d-4a52-4258-08d7ba93a0a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2020 08:12:31.3566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DLSqSxkAYPa7RV+pGBeW26QKuMGoTzXoeXPZk4tbJEXv05HD2/yJK4k1U/KKCi2N4DKJkzjczOqyBReh0Wa8pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2439
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_02:2020-02-25,2020-02-26 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hello Igor,
>=20
> Thanks for sending this series!
>=20
> Please Cc Sabrina Dubroca <sd@queasysnail.net> (the IEEE 802.1AE driver
> author) on such series.
>=20
> Antoine


Hi Antoine, thanks for reviewing this, your comments are all correct, will =
respin.

I'd also like to stress on the following patch:

> > 1) patch 0008:
> >   multicast/broadcast when offloading is needed to handle ARP requests,
> >   because they have broadcast destination address;
> >   With this patch we also match and encrypt/decrypt packets between
> macsec
> >   hw and realdev based on device's mac address.
> >   This potentially can be used to support multiple macsec offloaded
> interfaces
> >   on top of one realdev.
> >   On some environments however this could lead to problems, e.g. bridge
> over
> >   macsec configuration will expect packets with unknown src MAC
> >   should come through macsec.
> >   The patch is questionable, we've used it because our current hw setup
> and
> >   requirements assumes decryption is only done based on mac address
> match.
> >   This could be changed by encrypting/decripting all the traffic (excep=
t
> control).

We now basically see two different approaches on macsec traffic routing bet=
ween the devices.

If HW supports per mac decryption rules, this could be used to implement mu=
ltiple secy channels, all offloaded.
But macsec code then should use dst MAC to route decrypted packets to the c=
orrect macsec device.

Another usecase we have to support in our system is having a bridge device =
on top of macsec device. To support this
we had to encrypt/decrypt all the traffic against the single macsec dev (i.=
e. unconditionally, without mac addr filtering).
And this imposes a limitation of having only a single secy.

Internally, we now separate these usecases basically by private module para=
m (not in this patchset).

But it'd be good to hear from you and possibly other users if these are leg=
itimate configurations and
if this somehow should be supported in the offloading API.

Regards,
  Igor
