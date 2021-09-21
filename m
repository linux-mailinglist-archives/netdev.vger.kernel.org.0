Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E2E413802
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 19:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhIURI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 13:08:27 -0400
Received: from mx0b-0038a201.pphosted.com ([148.163.137.80]:61576 "EHLO
        mx0b-0038a201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229566AbhIURI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 13:08:26 -0400
Received: from pps.filterd (m0171341.ppops.net [127.0.0.1])
        by mx0b-0038a201.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18LGwLnG016336;
        Tue, 21 Sep 2021 17:06:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0038a201.pphosted.com with ESMTP id 3b7ffu11cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 17:06:51 +0000
Received: from m0171341.ppops.net (m0171341.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18LH6pXB001376;
        Tue, 21 Sep 2021 17:06:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by mx0b-0038a201.pphosted.com with ESMTP id 3b7ffu11cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 17:06:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R1qMc4B9RwRmRCd16lrwggWmsvhZZR6mva21Xry/FilKe5MMeVAXZLIzbosN1DjiCVNNHT2xvI8Y3c+ju3BTjIgYBC/CHp32jAl1sCrj/HiH1+gdsrLMVvdutQ/cBXppMv2lo1lIyFrHPGmjSGMnvuDDw1CDr9k+jlsTi3Dpq1sjC1CE7yS1WrUFlVolNqBdRp7uhAS/viRoVLgde9HU+JYEpyKpT/CM7rizVaBJpOvIrvxLIORHM43LcXV9K7rpHz6zlQpqU4MMF+YjoWYC0JM/6O6Vsm06hLumhIQG6G00DT/jg4cJ89UZBSBFv/1M/LVUD0tdv+BV0d7678osSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WTqJqCTOJMgcEM/em5mWGbmeC7TGvyqXy7zE3giA+yE=;
 b=A6ZG/p036gwiTrhLWBjwvdVVXPyvH3qIGCd8QSjdvAKfW3OPI5uKhw+uhnfWo/UvjJL0TagnHbVSNNi82EH0gO8u6BDzT09AvKOPUOvP31HjTIwmT0RZqV25FV1pkRaKiY58bhwXs5zB7N3XRlHnQlyB8e24STtGyxBi5Bzyn5iHNkcES1FRalmhrVUb7+iNO8ybxDAEBJHPfAm1IZo0aUi7vVmLucWBvwomXkS9ZAJbhVdHAnqncdBrsZ0cPHffHPi3uwBQ+7bp0PwNHrgJjq0/kO3g18oieMq+3xGQHS+odood9zbE+xF1x76aoTy2wxe0JdfmeUhKbBi4OPkQag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jumptrading.com; dmarc=pass action=none
 header.from=jumptrading.com; dkim=pass header.d=jumptrading.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jumptrading.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTqJqCTOJMgcEM/em5mWGbmeC7TGvyqXy7zE3giA+yE=;
 b=LZBlhYoH3jDGNPuaBKxSEWUBQHNe4H5NND8EiXZ1Lc6W5HsM6k7tyqqAv9neZwGMqgCOdLHi3ByJafWRCjqf4fJy5izYaAtuQd2MKkJw7RXLI8KEb6GY/as+FRh0DVawlI964ocdvnRo4e5aB/bDWOaeHW1pKaMxSnzm/LauDcw=
Received: from MW4PR14MB4796.namprd14.prod.outlook.com (2603:10b6:303:109::19)
 by MWHPR14MB1614.namprd14.prod.outlook.com (2603:10b6:300:131::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 21 Sep
 2021 17:06:49 +0000
Received: from MW4PR14MB4796.namprd14.prod.outlook.com
 ([fe80::2c0d:7614:3aed:f97e]) by MW4PR14MB4796.namprd14.prod.outlook.com
 ([fe80::2c0d:7614:3aed:f97e%9]) with mapi id 15.20.4523.018; Tue, 21 Sep 2021
 17:06:48 +0000
From:   PJ Waskiewicz <pwaskiewicz@jumptrading.com>
To:     "Dziedziuch, SylwesterX" <sylwesterx.dziedziuch@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pjwaskiewicz@gmail.com" <pjwaskiewicz@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Subject: RE: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Thread-Topic: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Thread-Index: AQHXmsh2FN3baon3J0C4ms4cTGoQHauMjGGAgAGT9oCAFFbJcIAAD3CAgADHjICAANwswIAAz1YAgAQuqaCAA4nqAIACJSpQ
Date:   Tue, 21 Sep 2021 17:06:48 +0000
Message-ID: <MW4PR14MB47967810D43031FF8C4C2265A1A19@MW4PR14MB4796.namprd14.prod.outlook.com>
References: <20210826221916.127243-1-pwaskiewicz@jumptrading.com>
         <50c21a769633c8efa07f49fc8b20fdfb544cf3c5.camel@intel.com>
         <20210831205831.GA115243@chidv-pwl1.w2k.jumptrading.com>
         <MW4PR14MB4796AE05A868B47FE4F6E12AA1D99@MW4PR14MB4796.namprd14.prod.outlook.com>
 <bebb58f34ed68025e95f8bc060af58a24333374b.camel@intel.com>
 <DM6PR11MB3371A3D1F314F3B8541FAF03E6DA9@DM6PR11MB3371.namprd11.prod.outlook.com>
 <MW4PR14MB47960CC778789EEE8E8A54EDA1DA9@MW4PR14MB4796.namprd14.prod.outlook.com>
 <DM6PR11MB3371B4431AD7C46672C7E439E6DB9@DM6PR11MB3371.namprd11.prod.outlook.com>
 <MW4PR14MB4796F279908B7E4D11622C66A1DE9@MW4PR14MB4796.namprd14.prod.outlook.com>
 <DM6PR11MB3371A285032A583A73BA62E0E6A09@DM6PR11MB3371.namprd11.prod.outlook.com>
In-Reply-To: <DM6PR11MB3371A285032A583A73BA62E0E6A09@DM6PR11MB3371.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=jumptrading.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1cb5c53-c434-4658-669e-08d97d2232f1
x-ms-traffictypediagnostic: MWHPR14MB1614:
x-microsoft-antispam-prvs: <MWHPR14MB1614CBF290180CAC8A4173EAA1A19@MWHPR14MB1614.namprd14.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F87rfCKq4t8anvz6Dys5BjvZIM8JCHHmFv9gOOCsg5R33/NDp1QZcRFREhvEw+OyseZ2pv6TiY7NAFsc29M94RlmqfeqIk8N+A+ALP7sEVqu6wcX3VNfUkvppzqOQEtNuBPbjqkzyeDdiL7SBTbmqaT9kV1k88XYnXUYdEh0gIo7O3O4UCSdU09HlFCzJGve9iUxroFe10J8lkSPZcHghXjmrl+8+JeeGqLGGvFFyxjfdgONBdLx8F2AHOJ9W+VNCTcKpsESrBGxOXl7dFXMsZ96Rw1mGTmkkAWq5rp6sdX2X8CctGjuqdMQGwPKfriqToMsbEFQwVpj/tepuxW8u20YL5JUrrQB+ByBcwH3RGNLayj6p125UvJsN2vDoCJ908Hto39KrDhVP9IoG7l3hTnsNPQknzIXyZukQ8UiDCGf1Gf3Rs9NXhgwF1XLU8mTidhz5dub4YEUHqc2hMQSwFaq086X73JEvGyPGnjvIpdOGfzlMGnWVKWPoJrhL1rSJZLW2j+9/yEeSCTyaANGPBrhXUyXkPyZYc73pO2F4QOrz5RCOeoKNcDx8mS5iVg5hUYF9huEBzFigkzBqIoj54KRCjonDqZ73GTOAfQdNEzNbIJLJgcfqbG9m3Kvf39QcIjEMnhH+KXwrglyY/FK5QkmzLDufiAsK3hH9/pLY9d3JMymb3z38FGCnGXK5/jS1hdV1dDItGIVMQI+07pY6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR14MB4796.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(4326008)(9686003)(38070700005)(8936002)(55016002)(71200400001)(76116006)(110136005)(66446008)(66556008)(33656002)(83380400001)(6506007)(38100700002)(122000001)(64756008)(66476007)(7416002)(54906003)(316002)(8676002)(186003)(5660300002)(26005)(2906002)(508600001)(7696005)(66946007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TG8razZ5QTVoWjcreGhSdWs4NXhRMFVtQ05hRm8vUEJMSFgyM2U4N3lnd1Vh?=
 =?utf-8?B?bGYvdjNiUTJrbThpcWpZWlByYmVCVGM4amJSR09vM3hlby9FNGY1NkN2bWYx?=
 =?utf-8?B?Nk5XcnR0L1BoUEhtT1ZqejUwaDh2c3dObDNFS0dXYUdKVVpWa05OdVVRcGZB?=
 =?utf-8?B?UDhHbTcrMG9qN2VGelFKYXZSMjdEVWpNNVRvWWIwd1B0OC8rYmlMWXFWeGlW?=
 =?utf-8?B?ZTNzMDhyYUpmcW1WQnlNTlFBTmxYaDhldm5QZFRpOCtmN2pSSGlObEhaaUZO?=
 =?utf-8?B?YmVHemovdml3WXRFbmROMlBNbEdCMUdHUGdYNERxelN6VjdEcFhsN0wvVmVG?=
 =?utf-8?B?OVhsajIyck51OUI2M0tVWGF5cFNtNEMxa3ZGUk9jaTlRYmNyRTljRmZNVHZB?=
 =?utf-8?B?MktNUkd0OUs3eWc4WkNuVUR4d2pPQ1RsTjBIV1ExMTJBM2ZhS2FRbEZxUjFX?=
 =?utf-8?B?Mk1vdlFra0UrNXNsOXF0RndWMTI4NHMvSE9vdzBsdTMzdW1uYlFaNldBUWNj?=
 =?utf-8?B?bUREaVVVMkhjdlFVYmJJNk1ucDZGeUpvZU93bWUrNy9SNEg1cFhyN2JrcXZx?=
 =?utf-8?B?REp4ZS9uTkptWGFpTUdMUnhEQjlKK3Z1QThkdWcyK1hHaDNnZGF3M080NytW?=
 =?utf-8?B?VGpnNDZ0N0tmVW8zVVpqZFBqalZTK3gzOTd2eDAyL2swb2lpV3prVWE4Z3hy?=
 =?utf-8?B?UGx3d0s2c0xBQ3hzMEY5OHNnV0MwL0ZubC9DWW5JVVl4SmR5L3JsSnkyMWIr?=
 =?utf-8?B?VFFMVUJYZzFYZzhjOVhQbm45aVRObWNLSk9PWWR2Nmc1eUQzT2orTEVMdWlO?=
 =?utf-8?B?ckJIRVBjMkluTmNab2UxQkxjT3RuWGVMRFZFaU0zdGpBLy9sNmlPNlU4VlZY?=
 =?utf-8?B?cW4reFBzbmZFTk5KVWwzYzRBdkxoT1hUNC9tOVRpdU5JLzF1YWZEV1FTNHdP?=
 =?utf-8?B?L3ZXblFXd0Z3SitCemU4aFlwaEgzbW9vdHFxcWN3cjZVYnYreXRLOERrTHBJ?=
 =?utf-8?B?Z1VLbTJoalpuSWZ0TSt5Y1lLQVJXdG55NGZDSGphWVllTjR3ZzJoVWxrN2kv?=
 =?utf-8?B?Rldhc3pUQTFUS2pZQ0hrZGpCY3A3S2lLWmx2YTdiNEdLVlFsNDY1d0QrTnZi?=
 =?utf-8?B?VnBTemRsMGVvYUx4ZVFiS0ZMNjJkQkZxM1g0Vi9qTEJVY1gxQy9HTWZ1ZnBM?=
 =?utf-8?B?cERvcmpMVDFCQVRUT0RFRDZRMWpGR2JDeXpMd2RQckxTV2Nsa1RXa3ZnNHRW?=
 =?utf-8?B?bzhkeGNyUFExT0pkNStPWU5hUlUwQW0yTU1TMS9VQkYvZzZzSjhlcHdkQy9V?=
 =?utf-8?B?ZWx5TTI4S29HRXF4SHduV2hXanhFaFY0a2hJOElTS1JQWCtwWHpGRjFhSXc4?=
 =?utf-8?B?c1drQm5OY1U5cGRXWWxNNXN4dEk2blR3Mlh0UGVGeUgrS09aMk1qejNHMkV2?=
 =?utf-8?B?MDJ4N2Y4ZnBjekN4Q1UydEJVTkVCWHc3OWkzUjA3dGl4T2xNZGJqOStSdFMx?=
 =?utf-8?B?cDRkZ1hZVmI4cVhrSmNZblFZd2VOdWROYkpCT1c0QzhTU2xmam5iOTdlVUNL?=
 =?utf-8?B?TzNaMHR0U0tQSE9qcERiOEQ3eWhpQWVreCtRYlZCOVV2ekRNNUVIQitGYlhY?=
 =?utf-8?B?dHplRDRweWpxZGlwT2xzU3BFb2NxaXRFdXFkNlZWVElEMk0ydm1kNllUWkNv?=
 =?utf-8?B?Q3F3U00zV0JRTnhlS0VDTFE5dldDRHdMRW1SVTVONXZzMVp6eEpMOHQ1QTAw?=
 =?utf-8?Q?I6o/jhyG0vQBGIzNRI0347G8WjxC1y8L6AnO8OF?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: jumptrading.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR14MB4796.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1cb5c53-c434-4658-669e-08d97d2232f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2021 17:06:48.4063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 11f2af73-8873-4240-85a3-063ce66fc61c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V+YQzS6v3fdvz7IOMB+OVjzd09V/6qjqhcdH80MotzFv8dQtNsT1gNC8mEsoggzMcJJ27YaPpxBPKMy1iZ+1TTAgdpHYeMuamMlm9w1Pe+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR14MB1614
X-Proofpoint-ORIG-GUID: T6tSkmiu5LFnwsHUlNdunUkgrEMKh5Ac
X-Proofpoint-GUID: D4fpy4w8YswIu8lpankiBfp1cFCeZ2oN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-21_05,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 clxscore=1015 spamscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109210101
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBIZWxsbyBQSiwNCg0KSGVsbG8sDQoNCj4NCj4gPiBzdGF0aWMgdm9pZCBpNDBlX2ZyZWVfbWlz
Y192ZWN0b3Ioc3RydWN0IGk0MGVfcGYgKnBmKSB7DQo+ID4gICAgICAgICAvKiBEaXNhYmxlIElD
UiAwICovDQo+ID4gICAgICAgICB3cjMyKCZwZi0+aHcsIEk0MEVfUEZJTlRfSUNSMF9FTkEsIDAp
Ow0KPiA+ICAgICAgICAgaTQwZV9mbHVzaCgmcGYtPmh3KTsNCj4gPg0KPiA+IFdvdWxkIHlvdSBz
dGlsbCB3YW50IHRvIGRvIHRoYXQgYmxpbmRseSBpZiB0aGUgdmVjdG9yIHdhc24ndCBhbGxvY2F0
ZWQNCj4gPiBpbiB0aGUgZmlyc3QgcGxhY2U/ICBTZWVtcyBleGNlc3NpdmUsIGJ1dCBpdCdkIGJl
IGhhcm1sZXNzLiAgU2VlbXMNCj4gPiBsaWtlIG5vdCBjYWxsaW5nIHRoaXMgZnVuY3Rpb24gYWx0
b2dldGhlciB3b3VsZCBiZSBjbGVhbmVyIGFuZA0KPiA+IGdlbmVyYXRlIGxlc3MgTU1JTyBhY3Rp
dml0eSBpZiB0aGUgTUlTQyB2ZWN0b3Igd2Fzbid0IGFsbG9jYXRlZCBhdCBhbGwgYW5kDQo+IHdl
J3JlIGZhbGxpbmcgb3V0IG9mIGFuIGVycm9yIHBhdGguLi4NCj4gPg0KPiA+IEkgYW0gcmVhbGx5
IGF0IGEgbG9zcyBoZXJlLiAgVGhpcyBpcyBjbGVhcmx5IGJyb2tlbi4gIFdlIGhhdmUgYW4gT29w
cy4NCj4gPiBXZSBnZXQgdGhlc2Ugb2NjYXNpb25hbGx5IG9uIGJvb3QsIGFuZCBpdCdzIHJlYWxs
eSBhbm5veWluZyB0byBkZWFsDQo+ID4gd2l0aCBvbiBwcm9kdWN0aW9uIG1hY2hpbmVzLiAgV2hh
dCBpcyB0aGUgZGVmaW5pdGlvbiBvZiAic29vbiIgaGVyZQ0KPiA+IGZvciB0aGlzIG5ldyBwYXRj
aCB0byBzaG93IHVwPyAgTXkgZGlzdHJvIHZlbmRvciB3b3VsZCBsb3ZlIHRvIHB1bGwNCj4gPiBz
b21lIHNvcnQgb2YgZml4IGluIHNvIHdlIGNhbiBnZXQgaXQgaW50byBvdXIgYnVpbGQgaW1hZ2Vz
LCBhbmQgc3RvcA0KPiA+IGhhdmluZyB0aGlzIHByb2JsZW0uICBNeSBwYXRjaCBmaXhlcyB0aGUg
aW1tZWRpYXRlIHByb2JsZW0uICBJZiB5b3UNCj4gPiBkb24ndCBsaWtlIHRoZSBwYXRjaCAod2hp
Y2ggaXQgYXBwZWFycyB5b3UgZG9uJ3Q7IHRoYXQncyBmaW5lKSwgdGhlbg0KPiA+IHN0YWxsaW5n
IG9yIHNheWluZyBhIGRpZmZlcmVudCBmaXggaXMgY29taW5nICJzb29uIiBpcyByZWFsbHkgbm90
IGENCj4gPiBncmVhdCBzdXBwb3J0IG1vZGVsLiAgVGhpcyB3b3VsZCBiZSBncmVhdCB0byBtZXJn
ZSwgYW5kIHRoZW4gaWYgeW91DQo+ID4gd2FudCB0byBtYWtlIGl0ICJiZXR0ZXIiIG9uIHlvdXIg
c2NoZWR1bGUsIGl0J3Mgb3BlbiBzb3VyY2UsIGFuZCB5b3UNCj4gPiBjYW4gc3VibWl0IGEgcGF0
Y2guICBPciBJJ2xsIGJlIGhhcHB5IHRvIHJlc3BpbiB0aGUgcGF0Y2gsIGJ1dCBzdGlsbA0KPiA+
IGNhbGxpbmcgZnJlZV9taXNjX3ZlY3RvcigpIGluIGFuIGVycm9yIHBhdGggd2hlbiB0aGUgTUlT
QyB2ZWN0b3Igd2FzDQo+IG5ldmVyIGFsbG9jYXRlZCBzZWVtcyBsaWtlIGEgYmFkIGRlc2lnbiBk
ZWNpc2lvbiB0byBtZS4NCj4gPg0KPiA+IC1QSg0KPg0KPiBJIHRvdGFsbHkgYWdyZWUgdGhhdCB3
ZSBzaG91bGRu4oCZdCBjYWxsIGZyZWVfbWlzY192ZWN0b3IgaWYgbWlzYyB2ZWN0b3Igd2Fzbid0
DQo+IGFsbG9jYXRlZCB5ZXQgYnV0IHRvIG1lIHRoaXMgaXMgbm90IHdoYXQgeW91ciBwYXRjaCBp
cyBkb2luZy4NCj4gZnJlZV9taXNjX3ZlY3RvcigpIGlzIGNhbGxlZCBpbiBjbGVhcl9pbnRlcnJ1
cHRfc2NoZW1lIG5vdA0KPiByZXNldF9pbnRlcnJ1cHRfY2FwYWJpbGl0eSgpLiBJbiB5b3VyIHBh
dGNoIGNsZWFyX2ludGVycnVwdF9zY2hlbWUoKSB3aWxsIHN0aWxsDQo+IGJlIGNhbGxlZCB3aGVu
IHBmIHN3aXRjaCBzZXR1cCBmYWlscyBpbiBpNDBlX3Byb2JlKCkgYW5kIGl0IHdpbGwgc3RpbGwg
Y2FsbA0KPiBmcmVlX21pc2NfdmVjdG9yIG9uIHVuYWxsb2NhdGVkIG1pc2MgSVJRLiBPdGhlciBw
cm9wZXIgd2F5IHRvIGZpeCB0aGlzDQo+IHdvdWxkIGJlIG1vdmluZyBmcmVlX21pc2NfdmVjdG9y
KCkgb3V0IG9mIGNsZWFyX2ludGVycnVwdF9zY2hlbWUoKSBhbmQNCj4gY2FsbGluZyBpdCBzZXBh
cmF0ZWx5IHdoZW4gbWlzYyB2ZWN0b3Igd2FzIHJlYWxseSBhbGxvY2F0ZWQuIEFzIGZvciB0aGUg
aHcNCj4gcmVnaXN0ZXIgYmVpbmcgd3JpdHRlbiBpbiBvdXIgcGF0Y2ggYXMgeW91IHNhaWQgaXQn
cyBoYXJtbGVzcy4gVGhlIHBhdGNoIHdlJ3ZlDQo+IHByZXBhcmVkIHNob3VsZCBiZSBvbiBpd2wg
dG9kYXkuDQo+DQoNCk9rLCBJIHNlZSB0aGUgcGF0Y2ggb24gSVdMLi4uLmxldCdzIGRpc2N1c3Mu
Li4uDQoNCkp1c3QgYWJvdmUsIEkgcG9pbnRlZCBvdXQgdGhhdCBpZiB0aGUgTUlTQyB2ZWN0b3Ig
aGFzbid0IGJlZW4gYWxsb2NhdGVkIGF0IGFsbCwgdGhlbiB3ZSBkb24ndCB3YW50IHRvIGNhbGwg
ZnJlZV9taXNjX3ZlY3RvcigpIGF0IGFsbC4gIFRoYXQgd291bGQgYWxzbyBtZWFuIHRoZSBzdWdn
ZXN0aW9uIHRvIGNoZWNrIHRoZSBhdG9taWMgc3RhdGUgYml0IHRvIGF2b2lkIHRoZSBhY3R1YWwg
ZnJlZSB3b3VsZCAqc3RpbGwqIGhhdmUgdGhlIGNvZGUgY2FsbCBmcmVlX21pc2NfdmVjdG9yKCks
IGFuZCBvbmx5IHNraXAgdGhlIGFjdHVhbCBmcmVlIChhZnRlciBkb2luZyBhbiB1bm5lY2Vzc2Fy
eSBNTUlPIHdyaXRlIGFuZCB0aGVuIHJlYWQgdG8gZmx1c2gpLiAgSSBwb2ludGVkIG91dCB0aGF0
IHdvdWxkbid0IGJlIGlkZWFsLCBhbmQgeW91LCBqdXN0IGFib3ZlLCBhZ3JlZWQuICBZZXQsIHRo
ZSBmaXggeW91IGd1eXMgc3VibWl0dGVkIHRvIElXTCBkb2VzIGV4YWN0bHkgdGhhdC4gIFNvIGFy
ZSB3ZSBqdXN0IHNheWluZyB0aGluZ3MgdG8gYnVyeSB0aGlzIHRocmVhZCBhbmQgaG9wZSBpdCBn
b2VzIGF3YXksIG9yIGp1c3Qgd2lsbGZ1bGx5IG5vdCBkb2luZyB3aGF0IHdlIGFncmVlZCBvbj8g
IEl0J3MgcHJldHR5IGRpc2hlYXJ0ZW5pbmcgdG8gY29uc2lkZXIgZmVlZGJhY2ssIGFncmVlIHRv
IGl0LCB0aGVuIGNvbXBsZXRlbHkgaWdub3JlIGl0LiAgVGhhdCdzIG5vdCBob3cgb3BlbiBzb3Vy
Y2Ugd29ya3MuLi4NCg0KQWxzbywgcmVnYXJkbGVzcyBob3cgeW91IGd1eXMgd2FudCB0aGUgY29k
ZSB0byB3b3JrLCBpdCdzIHVzdWFsbHkgZ29vZCBmb3JtIHRvIGluY2x1ZGUgYSAiUmVwb3J0ZWQt
Ynk6IiBpbiBhIHBhdGNoIGlmIHlvdSdyZSBkZWNpZGluZyBub3QgdG8gdGFrZSBhIHByb3Bvc2Vk
IHBhdGNoLiAgSXQncyBldmVuIGJldHRlciBmb3JtIHRvIGluY2x1ZGUgdGhlIE9vcHMgdGhhdCB3
YXMgcmVwb3J0ZWQgaW4gdGhlIGZpcnN0IHBhdGNoLCBzaW5jZSB0aGF0IG1ha2VzIHRoaW5ncyBs
aWtlICR7U0VBUkNIX0VOR0lORX0gd29yayBmb3IgcGVvcGxlIHJ1bm5pbmcgaW50byB0aGUgc2Ft
ZSBpc3N1ZSBoYXZlIGEgY2hhbmNlIHRvIGZpbmQgYSBzb2x1dGlvbi4gIE5vdCBkb2luZyBlaXRo
ZXIgb2YgdGhlc2Ugd2hlbiBzb21lb25lIGVsc2UgaGFzIGRvbmUgd29yayB0byBpZGVudGlmeSBh
biBpc3N1ZSwgdGVzdCBhIGZpeCwgYW5kIHByb3Bvc2UgaXQsIGlzIG5vdCBhIGdvb2Qgd2F5IHRv
IGF0dHJhY3QgbW9yZSBwZW9wbGUgdG8gd29yayBvbiB0aGlzIGRyaXZlciBpbiB0aGUgZnV0dXJl
Lg0KDQpJZiB3ZSB3YW50ZWQgdG8gZG8gc29tZXRoaW5nIHdoZXJlIGZyZWVfbWlzY192ZWN0b3Io
KSBpc24ndCBjYWxsZWQgaWYgdGhlIHN0YXRlIGZsYWcgaXNuJ3Qgc2V0LCB0aGVuIHdoeSBub3Qg
c29tZXRoaW5nIGxpa2UgdGhpcywgd2hpY2ggd291bGQga2VlcCBpbiB0aGUgc3Bpcml0IG9mIHdo
YXQgd2UgYWdyZWVkIG9uIGFib3ZlOg0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvaTQwZS9pNDBlX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0
MGUvaTQwZV9tYWluLmMNCmluZGV4IDFkMWY1Mjc1NmE5My4uYTQwMTkzYmNjN2I3IDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX21haW4uYw0KKysrIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX21haW4uYw0KQEAgLTQ4NjgsNyAr
NDg2OCw5IEBAIHN0YXRpYyB2b2lkIGk0MGVfY2xlYXJfaW50ZXJydXB0X3NjaGVtZShzdHJ1Y3Qg
aTQwZV9wZiAqcGYpDQogew0KICAgICAgICBpbnQgaTsNCg0KLSAgICAgICBpNDBlX2ZyZWVfbWlz
Y192ZWN0b3IocGYpOw0KKyAgICAgICAvKiBPbmx5IGF0dGVtcHQgdG8gZnJlZSB0aGUgbWlzYyB2
ZWN0b3IgaWYgaXQncyBhbHJlYWR5IGFsbG9jYXRlZCAqLw0KKyAgICAgICBpZiAodGVzdF9iaXQo
X19JNDBFX01JU0NfSVJRX1JFUVVFU1RFRCwgcGYtPnN0YXRlKSkNCisgICAgICAgICAgICAgICBp
NDBlX2ZyZWVfbWlzY192ZWN0b3IocGYpOw0KDQogICAgICAgIGk0MGVfcHV0X2x1bXAocGYtPmly
cV9waWxlLCBwZi0+aXdhcnBfYmFzZV92ZWN0b3IsDQogICAgICAgICAgICAgICAgICAgICAgSTQw
RV9JV0FSUF9JUlFfUElMRV9JRCk7DQoNCi1QSg0KDQpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXw0KDQpOb3RlOiBUaGlzIGVtYWlsIGlzIGZvciB0aGUgY29uZmlkZW50aWFsIHVzZSBv
ZiB0aGUgbmFtZWQgYWRkcmVzc2VlKHMpIG9ubHkgYW5kIG1heSBjb250YWluIHByb3ByaWV0YXJ5
LCBjb25maWRlbnRpYWwsIG9yIHByaXZpbGVnZWQgaW5mb3JtYXRpb24gYW5kL29yIHBlcnNvbmFs
IGRhdGEuIElmIHlvdSBhcmUgbm90IHRoZSBpbnRlbmRlZCByZWNpcGllbnQsIHlvdSBhcmUgaGVy
ZWJ5IG5vdGlmaWVkIHRoYXQgYW55IHJldmlldywgZGlzc2VtaW5hdGlvbiwgb3IgY29weWluZyBv
ZiB0aGlzIGVtYWlsIGlzIHN0cmljdGx5IHByb2hpYml0ZWQsIGFuZCByZXF1ZXN0ZWQgdG8gbm90
aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkgYW5kIGRlc3Ryb3kgdGhpcyBlbWFpbCBhbmQgYW55
IGF0dGFjaG1lbnRzLiBFbWFpbCB0cmFuc21pc3Npb24gY2Fubm90IGJlIGd1YXJhbnRlZWQgdG8g
YmUgc2VjdXJlIG9yIGVycm9yLWZyZWUuIFRoZSBDb21wYW55LCB0aGVyZWZvcmUsIGRvZXMgbm90
IG1ha2UgYW55IGd1YXJhbnRlZXMgYXMgdG8gdGhlIGNvbXBsZXRlbmVzcyBvciBhY2N1cmFjeSBv
ZiB0aGlzIGVtYWlsIG9yIGFueSBhdHRhY2htZW50cy4gVGhpcyBlbWFpbCBpcyBmb3IgaW5mb3Jt
YXRpb25hbCBwdXJwb3NlcyBvbmx5IGFuZCBkb2VzIG5vdCBjb25zdGl0dXRlIGEgcmVjb21tZW5k
YXRpb24sIG9mZmVyLCByZXF1ZXN0LCBvciBzb2xpY2l0YXRpb24gb2YgYW55IGtpbmQgdG8gYnV5
LCBzZWxsLCBzdWJzY3JpYmUsIHJlZGVlbSwgb3IgcGVyZm9ybSBhbnkgdHlwZSBvZiB0cmFuc2Fj
dGlvbiBvZiBhIGZpbmFuY2lhbCBwcm9kdWN0LiBQZXJzb25hbCBkYXRhLCBhcyBkZWZpbmVkIGJ5
IGFwcGxpY2FibGUgZGF0YSBwcm90ZWN0aW9uIGFuZCBwcml2YWN5IGxhd3MsIGNvbnRhaW5lZCBp
biB0aGlzIGVtYWlsIG1heSBiZSBwcm9jZXNzZWQgYnkgdGhlIENvbXBhbnksIGFuZCBhbnkgb2Yg
aXRzIGFmZmlsaWF0ZWQgb3IgcmVsYXRlZCBjb21wYW5pZXMsIGZvciBsZWdhbCwgY29tcGxpYW5j
ZSwgYW5kL29yIGJ1c2luZXNzLXJlbGF0ZWQgcHVycG9zZXMuIFlvdSBtYXkgaGF2ZSByaWdodHMg
cmVnYXJkaW5nIHlvdXIgcGVyc29uYWwgZGF0YTsgZm9yIGluZm9ybWF0aW9uIG9uIGV4ZXJjaXNp
bmcgdGhlc2UgcmlnaHRzIG9yIHRoZSBDb21wYW554oCZcyB0cmVhdG1lbnQgb2YgcGVyc29uYWwg
ZGF0YSwgcGxlYXNlIGVtYWlsIGRhdGFyZXF1ZXN0c0BqdW1wdHJhZGluZy5jb20uDQo=
