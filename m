Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E34073B925
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404125AbfFJQO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:14:58 -0400
Received: from mail-eopbgr770050.outbound.protection.outlook.com ([40.107.77.50]:43074
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725320AbfFJQO5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 12:14:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gO0nx2SmB2MRMZhDGxDIp4JMMlmjnEm4TPPDI2uaJI=;
 b=gcyuFbikmiqlNzxbm6nHBvfdDbP83lyNZP0JbtE7/C2jnmXkN/v8A4odpTEjhk3gUBGTe9bDyWZkcLBxbf+U+MafTMO1tc3pchR+obDRJP2Bwuh7i8//uhRuRPtJcEQUPWyCAVrfDBtNZnhBrRJqgOJ95czpXe5aUiKpQpGdixo=
Received: from BYAPR05MB4743.namprd05.prod.outlook.com (52.135.233.97) by
 BYAPR05MB4757.namprd05.prod.outlook.com (52.135.233.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Mon, 10 Jun 2019 16:14:38 +0000
Received: from BYAPR05MB4743.namprd05.prod.outlook.com
 ([fe80::b83d:21d:3288:182a]) by BYAPR05MB4743.namprd05.prod.outlook.com
 ([fe80::b83d:21d:3288:182a%6]) with mapi id 15.20.1987.004; Mon, 10 Jun 2019
 16:14:38 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5231.namprd05.prod.outlook.com (20.177.248.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.4; Mon, 10 Jun 2019 16:14:00 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::a902:576c:72d6:b358]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::a902:576c:72d6:b358%5]) with mapi id 15.20.1987.004; Mon, 10 Jun 2019
 16:14:00 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
CC:     Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] qtnfmac: Use struct_size() in kzalloc()
Thread-Topic: [PATCH][next] qtnfmac: Use struct_size() in kzalloc()
Thread-Index: AQHVHWjZ1AedDHs530eADQaD4eZD6aaVFC0A
Date:   Mon, 10 Jun 2019 16:14:00 +0000
Message-ID: <20190610161352.xymnc4lg2jad4lah@bars>
References: <20190607191745.GA19120@embeddedor>
In-Reply-To: <20190607191745.GA19120@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0023.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::36) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b04299bb-5e97-43e3-b0dc-08d6edbea5eb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:SN6PR05MB5231;
x-ms-traffictypediagnostic: SN6PR05MB5231:|BYAPR05MB4757:
x-moderation-data: 6/10/2019 4:14:36 PM
x-microsoft-antispam-prvs: <BYAPR05MB4757573F6D1C3D53B10B83B9A3130@BYAPR05MB4757.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(376002)(39840400004)(136003)(366004)(346002)(396003)(51914003)(189003)(199004)(26005)(446003)(11346002)(4744005)(102836004)(476003)(33716001)(76176011)(66946007)(2906002)(6436002)(486006)(4326008)(3846002)(186003)(52116002)(66556008)(6116002)(66446008)(86362001)(25786009)(5660300002)(66476007)(6506007)(386003)(64756008)(1076003)(99286004)(229853002)(68736007)(478600001)(316002)(6486002)(6246003)(54906003)(73956011)(66066001)(9686003)(6512007)(436003)(6916009)(53936002)(256004)(8676002)(305945005)(7736002)(14454004)(71200400001)(71190400001)(81156014)(81166006)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4757;H:BYAPR05MB4743.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Nbb3Ss4rYdCQWes7YwwXjaJMstTeTS7/5Q23akKPz4vBWC96OO8kmCAaCgyiJCzFadE1/tZGMdSv98ZYrR+LfZCyTH5WgdipVwjHYrVz+OD0fsbQnMtsKj+Hqd3ruCYa81Zar+Q3k3DS7fma125IUyCoe80Q2eufStkF1LfN6ivpm+i0AV/okLox5BbmgAGVCskH0k34mKavocOvED2TjeAiRucHoUbdqqD68CT19C9MgTULIMn+IlWdOy2jMBXRRCGzQ/bIWRferfxhp9FuhdbMWCgCdOC7YeUIen3OH7n7861Rw+L6Layjhd+Cin0+YVZ0/1kM7Fpj4UfDYhhRA4YTKg4WEsRe7fp44bdtwLE4M+ayFJMRsIVXCN3Cyq/brlM8hb9cmje/Hd4Phc0nzKq1T78kZ/YCzCtbKxH9+2g=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DED1CC9DFD99EA448ADB8F0B5D29DDDB@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b04299bb-5e97-43e3-b0dc-08d6edbea5eb
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SPO_Arbitration_d2f137f7-57a3-41a6-974a-9a603eeb68f6@quantenna.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 16:14:38.4379
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4757
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
>=20
> struct ieee80211_regdomain {
>         ...
>         struct ieee80211_reg_rule reg_rules[];
> };
>=20
> instance =3D kzalloc(sizeof(*mac->rd) +
>                           sizeof(struct ieee80211_reg_rule) *
>                           count, GFP_KERNEL);
>=20
> Instead of leaving these open-coded and prone to type mistakes, we can
> now use the new struct_size() helper:
>=20
> instance =3D kzalloc(struct_size(instance, reg_rules, count), GFP_KERNEL)=
;
>=20
> This code was detected with the help of Coccinelle.
>=20
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
=20
Hi Gustavo,
Thanks for the patch !

Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Regards,
Sergey
