Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA1F1484B6
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 12:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731819AbgAXLwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 06:52:30 -0500
Received: from mail-am6eur05on2126.outbound.protection.outlook.com ([40.107.22.126]:12096
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731122AbgAXLw3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 06:52:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nn6/kUXWy6ex7lpNa5RfzFiNSxEZgab8vUA5KZPFYIj2UC5aa3j6j6/AF25R4YnX1Teo2T62G9fbG0HfLUa+K/JYR9MVk6jUd2ufrROGLiWzssWhWhtLx6NIrP04pIEK+XJpRky5/O4O469qNMZMzU+VY9Nu+GwngC5wz1wrnwcflKeQ70fqi3oUhdqyxTcnsUCo2ZP8zWf32Uq7hEdbHdsQzJhSgd7Qi/W91Tt1GPlusi742nafFVVeQJSOBgnA/2x+p5wBYma+zXy0OFwvQ5cp3vSKrko+tdPTztrg6aeh2zSyAF1KqZsf1HsSarNDGV1EP7wtsYNPz/6qCMDzBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Am+3Yj+hvx6w95KCLmuQPkZOHPPOexFk1i0m7KY8ErA=;
 b=FliVgJFdQygOhr/qLXJ1mcKSMGo4r2aECRXqnKrM1OtlAHCHLzR7dx471PBLUyFsATWj62Nc3p/qHumm/lObqPB/tLLqcpXeWkofV5u67sTw04eSq3A8lCHRGx7HpWb5FZEEph2MWZNtqwSzrNi162mTKWZih3TX4m7VlG3uZUQsIxrMJTHWbbVa9ok90L7feMgQa4KM6dub5Sh7I39xDC0+lvzsLCkLxb0gcMAP2488fQuP8JcLegce0lWXfDREnAqPHrjXDpATYCborttQdG6FrBVPr6R7hkLLPHh+3dhlTqIWGoTUjTcfJrWq9Bev4Dep0nO1cTvGL38Y4ffeFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Am+3Yj+hvx6w95KCLmuQPkZOHPPOexFk1i0m7KY8ErA=;
 b=WAu0E0lpKkSm2yq0OYIaL7BgAaLne0tbniS1Nna/K2JBuehi+/m9QZ5F5cZkjKSF+0/mHlXjVqO6+hareA2Bmkpk+0xIWyaXt1BXn0aJNVOJtL3zG/IG1EQTLgOP3WWsAuXzqSEB51kTxw402zm+wf16Y4pPsJqwKt6qqPjAFLI=
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com (20.178.20.19) by
 AM0PR05MB5282.eurprd05.prod.outlook.com (20.178.18.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Fri, 24 Jan 2020 11:52:24 +0000
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7]) by AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7%6]) with mapi id 15.20.2644.028; Fri, 24 Jan 2020
 11:52:24 +0000
Received: from SvensMacbookPro.hq.voleatech.com (37.24.174.42) by ZR0P278CA0053.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Fri, 24 Jan 2020 11:52:23 +0000
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "matteo.croce@redhat.com" <matteo.croce@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: Re: [PATCH v4] mvneta driver disallow XDP program on hardware buffer
 management
Thread-Topic: [PATCH v4] mvneta driver disallow XDP program on hardware buffer
 management
Thread-Index: AQHV0oebTsKeFqWhwESpvZKN+FWHo6f5assAgABJnAA=
Date:   Fri, 24 Jan 2020 11:52:23 +0000
Message-ID: <20200124115220.mhk3gwf6ab5dmzur@SvensMacbookPro.hq.voleatech.com>
References: <20200124072628.75245-1-sven.auhagen@voleatech.de>
 <20200124.082852.34776010407342804.davem@davemloft.net>
In-Reply-To: <20200124.082852.34776010407342804.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZR0P278CA0053.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::22) To AM0PR05MB5156.eurprd05.prod.outlook.com
 (2603:10a6:208:f7::19)
x-originating-ip: [37.24.174.42]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sven.auhagen@voleatech.de; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51cae112-2bff-4ab8-1d35-08d7a0c3e033
x-ms-traffictypediagnostic: AM0PR05MB5282:|AM0PR05MB5282:
x-microsoft-antispam-prvs: <AM0PR05MB528218B61C671C80A02203D5EF0E0@AM0PR05MB5282.eurprd05.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(199004)(189003)(16526019)(1076003)(66446008)(71200400001)(66476007)(64756008)(66556008)(508600001)(4326008)(2906002)(66946007)(4744005)(8936002)(956004)(6506007)(6862004)(52116002)(7696005)(81156014)(26005)(81166006)(55016002)(9686003)(86362001)(8676002)(107886003)(5660300002)(54906003)(186003)(44832011);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR05MB5282;H:AM0PR05MB5156.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: voleatech.de does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2RxrIV+u+QTIQ0dlhpZ2bTxiAYisCvwNIHkgx2iGMMVOfRp1+DSXp2YyjZchms++TzxmIB8i9jUfbNCnV/FAaOc2I2Ro/9CTs8oF3XzOpgVhEZlGFBhBLXTCv8bkWdox6pLD7u6l+lFxEp0MSHYC+byqQbzUCVcRujr1wKq5GIKsMus055U8yOdwQzConk9C4VsmXlsAP3fr/IEW3OORigr9VaerBQRrm0OfRmKP5MNPbwRRaWd5NPz1mVtONGtg0wHl6Bjee7FXaojKjYbPuJe3r53Q/7KKdI2cfFazAvY4EBS8y65iazTPSLk2DEU/RuhXvnRCpBSkoxXj/sfu7UfiHlvjpRFqeRyIs462vHrXifnqU3x1rq0KPvlwtL2LvWd22ZH+Z89v32g02wCgCcZoyXrUEzgIb2xtwajpi/n5R8ujyvA9SpbdeOYoFP0j
Content-Type: text/plain; charset="us-ascii"
Content-ID: <93F43C37EE569B49A2AB95D3A7316B3C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 51cae112-2bff-4ab8-1d35-08d7a0c3e033
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 11:52:23.8536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FlrhPhYudIk04cH4SqQFzHaZdWZwhh72/ia1x03sHp4cuaofKWmKsAC6pO4jVowNNyMMQsp7s63WhYKoyMoV3WovO5IbhLSMvvM7LAoZh3I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5282
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 08:28:52AM +0100, David Miller wrote:
> From: Sven Auhagen <sven.auhagen@voleatech.de>
> Date: Fri, 24 Jan 2020 07:26:34 +0000
>=20
> > Recently XDP Support was added to the mvneta driver
> > for software buffer management only.
> > It is still possible to attach an XDP program if
> > hardware buffer management is used.
> > It is not doing anything at that point.
> >=20
> > The patch disallows attaching XDP programs to mvneta
> > if hardware buffer management is used.
> >=20
> > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
>=20
> Can you at least say what is changing in each version of the patch
> you are posting?
>=20
> Thank you.

I am sorry about that. It is my first submission and I am having
some troubles with the format of my emails.

v3 -> v4:
- Please ignore v3 I accidentally submitted
  my other patch with git-send-mail and v4 is correct

v2 -> v3:
- My mailserver corrupted the patch
  resubmission with git-send-email

v1 -> v2:
- Fixing the patches indentation

