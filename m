Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63D5E6F6A
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 10:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732724AbfJ1Jxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 05:53:47 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63816 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728915AbfJ1Jxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 05:53:47 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9S9nmso006361;
        Mon, 28 Oct 2019 02:53:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=A6xCUgGM3klAz+ymtBtTo+G6Mbn/xHa/ZXX02C+fbm0=;
 b=AjprizKQ/5CjtdVOm+svYzQFuxV2oLemS030VRAnro+0DGpH2amT46iSyB8ZyfGA/Ba6
 Xt9NDxhCeIdwdkD2GQckpGN0exczDm/4wWh5sV5yubL58YueWrU6lNUO9LC5mPd4fADo
 W/R4weEhIs8bPfno4PqWMytfh+awCyf2lAmujXxZfi2RCsMCJT9MYoRdYxdcjLVW0dNd
 zLS4gV74NRiAQuy8tImpTPI3YdFKUkiJIQnJKDw0hkY+6Wf/Nk6Vf2PMWxgBhc0ip9yr
 G6RoDNiW/ddn5CGEUYM+OT+4i2wixxQQOLw22FfCoBV8JKajAoXSVjoXuac8IFw8Wr8H DA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2vvkgq5fdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 28 Oct 2019 02:53:34 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 28 Oct
 2019 02:53:33 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.53) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 28 Oct 2019 02:53:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gv9jJ3vQZkN0qaYpgcQ0YS2DqwA7in1cXtBJmI3tyeaieCvOMt0RDQYF8AePcZ4HmywzO33vkh5hNtN8WlHRJYWkz5JDKePHPhc2zfRkVWlL2rRGWGnTiKUfYIw05RKxVRHz/MCEiHxH36ei4c+94x2EdS60PkQN1O8KWL1gAajDtQ36p1Lqa/waJBMSF4beHspYob/+jlmt2xrk7S+ASit1Che8YPRvlYMK8OffxJ36nuvHbtjbzbLB30ZjkeGorEfXzUkYDkY70f6lRp06Zl6XLicebPmKKwU/o8hTQky919fkGlIPZJoHzoJvYyPGZ45FnKnsNr+CGQPPYdeqTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A6xCUgGM3klAz+ymtBtTo+G6Mbn/xHa/ZXX02C+fbm0=;
 b=CUXJaagfUzmhj8fpmx8uGJH+DmKxEzCReEuwL1+NyAndohsf85fm6+XSWiIxxNHxr2Kh+Yrzu8pO1CVArIeE7SDsWoLBPrPLin/DtvW/ewqo/8zgWkqA6CIfS8lF6/izwqp/a/6Wq65xJPZNvH1+i2pBtClKmUbfj+HPRo4wmdB64OUxC45BKHECbVsSSuDwMvaV87JTes7vUyX4sgWofra05U06em+iyw/ydeKW4QT9okBjZSgGBf+sBx5eyVzOfbe4sxxtc3p2ERfLs88C9hnXzRUiruiSy3oCAyM/ZwdwcDLMFTxpTrrp0AySlvHxLBtwc6nYOfXosz4NYojjKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A6xCUgGM3klAz+ymtBtTo+G6Mbn/xHa/ZXX02C+fbm0=;
 b=v8irVZaoSX7e1nzZ5eBla/u+vA2AnVqhQgxFJ/AVNhOZMxj0BwYLjtBxrG28nMM0rj4ySff9E1pL+sDOkfaFZQb+71TQoTGPyxyXqGKZDaBm1MlqGelT1ThLtlrn1q+j1jfVlP26DqdG78z1aQmx7wq9eAnV83Tsg3evXL9ZFdY=
Received: from BL0PR18MB2275.namprd18.prod.outlook.com (52.132.30.141) by
 BL0PR18MB2339.namprd18.prod.outlook.com (52.132.10.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Mon, 28 Oct 2019 09:53:32 +0000
Received: from BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981]) by BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981%3]) with mapi id 15.20.2387.025; Mon, 28 Oct 2019
 09:53:32 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Egor Pomozov <epomozov@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] [PATCH net-next] net: aquantia: fix error handling in
 aq_ptp_poll
Thread-Topic: [EXT] [PATCH net-next] net: aquantia: fix error handling in
 aq_ptp_poll
Thread-Index: AQHVjXWOWenE2YYHN0K3xjp7931YMQ==
Date:   Mon, 28 Oct 2019 09:53:32 +0000
Message-ID: <8c961978-3fb2-730c-fe54-3b7cc2ec9b53@marvell.com>
References: <20191028070447.GA3659@embeddedor>
In-Reply-To: <20191028070447.GA3659@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0202.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::22) To BL0PR18MB2275.namprd18.prod.outlook.com
 (2603:10b6:207:44::13)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80f988f5-5cc7-41c1-faba-08d75b8cb12f
x-ms-traffictypediagnostic: BL0PR18MB2339:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR18MB2339CDFA57861E2C541616F6B7660@BL0PR18MB2339.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:341;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(366004)(396003)(39850400004)(199004)(189003)(316002)(54906003)(2616005)(110136005)(229853002)(36756003)(486006)(305945005)(6436002)(6486002)(64756008)(76176011)(66556008)(66446008)(6506007)(476003)(256004)(102836004)(186003)(99286004)(31686004)(7736002)(6116002)(6246003)(3846002)(446003)(386003)(11346002)(52116002)(66476007)(25786009)(66946007)(478600001)(2906002)(81166006)(4744005)(8936002)(81156014)(4326008)(66066001)(26005)(8676002)(86362001)(31696002)(5660300002)(14454004)(71200400001)(6512007)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR18MB2339;H:BL0PR18MB2275.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bBxDG/FX3L9yr7wcLZdqzCGI8qq3V338eMfEEdWRdutOKmTzOsRcas/uwJna3IgF7h1Me6MiVCVPZjYEOG3NMMc3xjs2rheHT2XgJUnULG2wTvP/AB2w/FCOWL35/Mkg3wE/mJsOJ53j8c7aSBsvCZEaYlvWaZ0zPOWEMqHnHsl4CpYxQ2/o9j6BYnwza7ho+ytesex/p6iUB9DJkl7cdxwU9dre5cwc48eDAq5Z78rzgNUin1NwoyyT4XoE6X7G3mpsCxmHIsnqMQRMj7MzIbKQRgnC1x3CgnpmQ+VoEL0RE6McumKOnw3MLxuCchKG2at7oQ8qkPFemTMb9zo2zbdZ4jACcg326myi76aXqiyVc4Wv/W/+B+FSXj3gUw0cLgxJRmJH2vNx9h8Zd+aivZSNfWw14askgB4jSl4HDq92DOx/a3t8/9PdoQpjYYyy
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D7449E242010041BC04C7901BCD6F9C@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f988f5-5cc7-41c1-faba-08d75b8cb12f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 09:53:32.4014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n0b9BXGdewJ2EFsrkx/sQrbd7Xo0B/8zeuFeMP+rngl+9O4DrRO2P7q/4ES3tJD9/O+lCcIFynVOZwFNn8iJMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2339
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-28_04:2019-10-25,2019-10-28 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZpeCBjdXJyZW50eSBpZ25vcmVkIHJldHVybmVkIGVycm9yIGJ5IHByb3Blcmx5IGNoZWNr
aW5nICplcnIqIGFmdGVyDQo+IGNhbGxpbmcgYXFfbmljLT5hcV9od19vcHMtPmh3X3JpbmdfaHd0
c19yeF9maWxsKCkuDQo+IA0KPiBBZGRyZXNzZXMtQ292ZXJpdHktSUQ6IDE0ODczNTcgKCJVbnVz
ZWQgdmFsdWUiKQ0KPiBGaXhlczogMDRhMTgzOTk1MGQ5ICgibmV0OiBhcXVhbnRpYTogaW1wbGVt
ZW50IGRhdGEgUFRQIGRhdGFwYXRoIikNCj4gU2lnbmVkLW9mZi1ieTogR3VzdGF2byBBLiBSLiBT
aWx2YSA8Z3VzdGF2b0BlbWJlZGRlZG9yLmNvbT4NCg0KVGhhbmtzLCBHdXN0YXZvIQ0KDQpSZXZp
ZXdlZC1ieTogSWdvciBSdXNza2lraCA8aXJ1c3NraWtoQG1hcnZlbGwuY29tPg0KDQpSZWdhcmRz
LA0KICBJZ29yDQo=
