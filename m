Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB8EE6F4C
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 10:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388042AbfJ1Jpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 05:45:40 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29246 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730486AbfJ1Jpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 05:45:40 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9S9iqHh021301;
        Mon, 28 Oct 2019 02:45:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=Q02JBhrcCJ5JG+KEWmQ7oXS5QM8VuZmxTLvPhpaDHm4=;
 b=WRwkUHYoH3+osIaBcPlTRjdU/72LyGgbyCY71wvfywD4n2j7z2kz068kqwsAPMhO7opF
 iWj1DODyHRzO5IX3n1lOuaTLi1PgEpM0cncUV37b0yBwPYYBX0IDWX5H6y8l1rJOVtYi
 RI5gDmeJFxKFnrmEqVRQq0MrcuGL5VVihC6Y0GbqIBidredBR2TP6MdW1/B+++NRZoy+
 S4C23gf9FdPQbAhXRhX+CUJh1DUfLoHfv3vbm32LqBZ9S3W2sYQbmx1/VvyQ9vChu+z0
 MpVTdh9pooeU67VKzDVbbPxbx8vvjN4HA2hwLt51qVXj/IlLPd+90qfshwmX3QqViN8b IQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2vvnnnvxh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 28 Oct 2019 02:45:35 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 28 Oct
 2019 02:45:33 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (104.47.40.58) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 28 Oct 2019 02:45:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DduU7jm0JA6F12+IBzzIU/pnHos2OoGfriPq8xN57UY5jmOdrL9lbxQLzwoCLGsayTonRVMM4U8Eg0JwdQxtX0nkdK3JzokfeHEnjoV8fi78qU4uV1kuNBo5Wg3NZq9L8cMqc2XSjehheNWMtcjZfgYkQtA1Oqpn9k0CvSTBnvcdpr1eB51YsLbjj07LIY/n3i7Jt3asFid2O6rb90T7+7h2Hf2FZE8UwPup1CMnAIYCu+8EZCkbbqvoDpGCpyvcHsEdTwK6fG623CGcu4rb9FZYxIoemDi0fUJB+Acsy7Y1UBhpcCO1q9066jLteRQq/lPsKto9QgegbNmMtW+L0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q02JBhrcCJ5JG+KEWmQ7oXS5QM8VuZmxTLvPhpaDHm4=;
 b=CnwM3GkIJM2d08/YOum9288ARzf2KfnXeg6OPWKPdI7wziqOkeMWNr8lfDF4Gx7Owwp8qnI2RnTN7UsXYzA9WlFxw9aQ5bMPJnma6m8gSqV3uT5a1j/g6Nq6t+2pftbQ2XF6zgOJf+UaDz5jxC+PR/nASeDkL+6kdHXRG9+VVm0dwbv/Zb9pZ0X+E09OKaobprJ9Mpx5UDs1s1I5RTFG1kShUeJdoHozPIR7J/QlI1B8HEnWD2TwZ5g3nfspiWNlB+9JRYUf6spBobzHhlSeE+kV5Ny3ONNuHiNVTuJpIW/GfzWObr6JhQP22jD8whBKpDYyeH7Zg1vkYVHfTkWhVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q02JBhrcCJ5JG+KEWmQ7oXS5QM8VuZmxTLvPhpaDHm4=;
 b=VXTpbrZzeQO0IcojjVwba8e1YkKon8h2OvzqwG7kfTZFinvw3fnd0YzoudbMTGmVDD2NTBydEAXsYvl79ovT1mQ1vaEmcWDm2VqEQq4iB7DcnbaiDTJnqciZ+wV0wuxQDN0BFAmIJA439uEXESBWah6MX+udPpo7NTmbtdtOJO4=
Received: from BL0PR18MB2275.namprd18.prod.outlook.com (52.132.30.141) by
 BL0PR18MB2130.namprd18.prod.outlook.com (52.132.8.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 09:45:32 +0000
Received: from BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981]) by BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981%3]) with mapi id 15.20.2387.025; Mon, 28 Oct 2019
 09:45:32 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     Colin King <colin.king@canonical.com>,
        Egor Pomozov <epomozov@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] [PATCH][next] net: aquantia: fix unintention integer
 overflow on left shift
Thread-Topic: [EXT] [PATCH][next] net: aquantia: fix unintention integer
 overflow on left shift
Thread-Index: AQHVjXRw9FKmSHRGRE6+XsIIk1N3lA==
Date:   Mon, 28 Oct 2019 09:45:32 +0000
Message-ID: <1fe5fdc0-ea7a-6a4a-6453-4115adf6e2ba@marvell.com>
References: <20191025115811.20433-1-colin.king@canonical.com>
In-Reply-To: <20191025115811.20433-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0136.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::28) To BL0PR18MB2275.namprd18.prod.outlook.com
 (2603:10b6:207:44::13)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cec1dfea-92cc-4327-1c07-08d75b8b9333
x-ms-traffictypediagnostic: BL0PR18MB2130:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR18MB213024FFD4F056C9CE94234EB7660@BL0PR18MB2130.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(396003)(366004)(39850400004)(189003)(199004)(81156014)(6486002)(6116002)(3846002)(6246003)(76176011)(52116002)(102836004)(71200400001)(71190400001)(86362001)(2906002)(305945005)(14454004)(386003)(31696002)(6506007)(229853002)(486006)(26005)(31686004)(99286004)(186003)(446003)(11346002)(476003)(2616005)(4326008)(5660300002)(66946007)(66476007)(36756003)(66446008)(6436002)(66556008)(64756008)(256004)(66066001)(81166006)(8676002)(8936002)(25786009)(110136005)(478600001)(316002)(54906003)(6512007)(2501003)(4744005)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR18MB2130;H:BL0PR18MB2275.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ut3aXmEEHyTj2GbkgKmhqRtFBFuvxaBASFrrEO+irU9dP/zX489dLK40tnomF77MBEyXzn2PvmUPZkaS9KQ4y+fjyUBQGL8eXlCv0Gb1DriM3FVlNpQoeY4CYOeMTJTJAsGi1sVT4+UfsS+9cO2nirsOF2akfC6ohytxQXZGrYunJICbgdC9ts1mYDQ7G1gUSQ0bRwbFmL8u4dpTyaGej2bnlrZGfcwOzDc7Xkh6zci5LWJYtEcmrdBRFKk2hCaqzH8rXC7Ln9wmJIuI7HDIIj85aBkSxVRQQCraQObAwxg/YDQ+tjSGzORRB0BHkGvcnbHXiPCKmm9ombakOXBsXyR4zsegfxwdwLW20WH5iO9nilGcibpLFRSorxvcBWgJkou+fna3AYcOIjxseSnMC2N6P5K5frMBuC5vUvkBJ0VkvqE8b6FXVX3O1wVQAt8X
Content-Type: text/plain; charset="utf-8"
Content-ID: <B9772C2C8D1F4141BD47DA5F1E2FD917@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cec1dfea-92cc-4327-1c07-08d75b8b9333
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 09:45:32.5975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8XdG3xBtf3K+OfQb5fqu2hk9hjkSIC4JgV0S0GF3R6Yn8ahsHkmidNl9cnU9aWwI3ZLIkY8AnWfGcl6EO7g50Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2130
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-28_04:2019-10-25,2019-10-28 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IA0K
PiBTaGlmdGluZyB0aGUgaW50ZWdlciB2YWx1ZSAxIGlzIGV2YWx1YXRlZCB1c2luZyAzMi1iaXQN
Cj4gYXJpdGhtZXRpYyBhbmQgdGhlbiB1c2VkIGluIGFuIGV4cHJlc3Npb24gdGhhdCBleHBlY3Rz
IGEgNjQtYml0DQo+IHZhbHVlLCBzbyB0aGVyZSBpcyBwb3RlbnRpYWxseSBhbiBpbnRlZ2VyIG92
ZXJmbG93LiBGaXggdGhpcw0KPiBieSB1c2luZyB0aGUgQklUX1VMTCBtYWNybyB0byBwZXJmb3Jt
IHRoZSBzaGlmdCBhbmQgYXZvaWQgdGhlDQo+IG92ZXJmbG93Lg0KPiANCj4gQWRkcmVzc2VzLUNv
dmVyaXR5OiAoIlVuaW50ZW50aW9uYWwgaW50ZWdlciBvdmVyZmxvdyIpDQo+IEZpeGVzOiAwNGEx
ODM5OTUwZDkgKCJuZXQ6IGFxdWFudGlhOiBpbXBsZW1lbnQgZGF0YSBQVFAgZGF0YXBhdGgiKQ0K
PiBTaWduZWQtb2ZmLWJ5OiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29t
Pg0KDQpSZXZpZXdlZC1ieTogSWdvciBSdXNza2lraCA8aXJ1c3NraWtoQG1hcnZlbGwuY29tPg0K
DQo=
