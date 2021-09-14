Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E404F40BA7D
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 23:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbhINVmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 17:42:25 -0400
Received: from mx0a-0038a201.pphosted.com ([148.163.133.79]:39106 "EHLO
        mx0a-0038a201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232891AbhINVmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 17:42:24 -0400
Received: from pps.filterd (m0171340.ppops.net [127.0.0.1])
        by mx0a-0038a201.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18EJRgZ5027707;
        Tue, 14 Sep 2021 21:41:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0038a201.pphosted.com with ESMTP id 3b2rjvj5h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 21:41:04 +0000
Received: from m0171340.ppops.net (m0171340.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18ELe8XG019021;
        Tue, 14 Sep 2021 21:41:03 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by mx0a-0038a201.pphosted.com with ESMTP id 3b2rjvj5h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 21:41:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S38j5TCx0Q5Oda1ADyoTw4FMgiA+CHotIBlX3VRZ/ZRq88SN2uii9bHeweykUtYgrXVjjnh+2+8ni/0/MMGho/6x024eofeLLxki/agSC7jrpiAdoWpMODcYf8ivO2W7NLei3KpKH1oRpTdJ0gifFd7h766bPsuj/x1CJRpoLWE5ySBTrwtpu4DaP+7j+dP5Q42wD2HNh2Eos3sqLvD7juQW46MqYaxt3rjRlVLXv45x6lqq4BcJAL8jdILEuheC6b2eV2RW65Dcv/7k2B3psXL7FtcBp/NcDPZT5aVStCOLHtAvCO6WtNF87nOgBNU7F9FHKSoWExvBtEccHhKHvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/io3r1SIn4B3QSddz6loiXRgV+NtecBn8nHA7tAOASg=;
 b=S028BKguThalSjCZb1yUJoU95H4JyLKH/+vcGZpdjXbE9rSVnAaqHlSn5hcYAp3koxbKTXcSQBAXEwcWgwDC2k5LXlmwO+mnb5BUqxih43QzAGDkdtPT8yj0S8yvFSywOW5B+sgMSnswMMw3KET7SnxQwqPIdFpxf5OIPlEEDS31RPOJqDwyFpZLXeq8XbfHiku2F3L27+X8zvd+GwrIq0Xo2OgkPwTrv85LZCfN4+ag1uijkwuWH01xuaC+S2vVGc4zXqCgBIiIOGHp98Ch8V/IbKXbXSRTMYNaV6TQkEoyTJz/t51i7QsiOeWi+FN+AhfgJrGddhYzdR1NnTTQkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jumptrading.com; dmarc=pass action=none
 header.from=jumptrading.com; dkim=pass header.d=jumptrading.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jumptrading.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/io3r1SIn4B3QSddz6loiXRgV+NtecBn8nHA7tAOASg=;
 b=Akjwxf1ROq6DhhFGaI8xYNDW/wfAEU8QZh555iN0o5PCsJzeAxXbFuXQup17aPP0cLjLVA6lVeS2j3tFkBAcx73VQjjvhsscgvV5bzPiqtvQktp7HsQ1/IF0aLr7xeMzy0oyof1AjnXaBzJtovZ7a5L5Vku1XG5bOxuZxtCnbX0=
Received: from MW4PR14MB4796.namprd14.prod.outlook.com (2603:10b6:303:109::19)
 by MWHPR14MB1631.namprd14.prod.outlook.com (2603:10b6:300:133::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Tue, 14 Sep
 2021 21:40:54 +0000
Received: from MW4PR14MB4796.namprd14.prod.outlook.com
 ([fe80::2c0d:7614:3aed:f97e]) by MW4PR14MB4796.namprd14.prod.outlook.com
 ([fe80::2c0d:7614:3aed:f97e%9]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 21:40:54 +0000
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
Thread-Index: AQHXmsh2FN3baon3J0C4ms4cTGoQHauMjGGAgAGT9oCAFFbJcIAAD3CAgADHjICAANwswA==
Date:   Tue, 14 Sep 2021 21:40:53 +0000
Message-ID: <MW4PR14MB47960CC778789EEE8E8A54EDA1DA9@MW4PR14MB4796.namprd14.prod.outlook.com>
References: <20210826221916.127243-1-pwaskiewicz@jumptrading.com>
         <50c21a769633c8efa07f49fc8b20fdfb544cf3c5.camel@intel.com>
         <20210831205831.GA115243@chidv-pwl1.w2k.jumptrading.com>
         <MW4PR14MB4796AE05A868B47FE4F6E12AA1D99@MW4PR14MB4796.namprd14.prod.outlook.com>
 <bebb58f34ed68025e95f8bc060af58a24333374b.camel@intel.com>
 <DM6PR11MB3371A3D1F314F3B8541FAF03E6DA9@DM6PR11MB3371.namprd11.prod.outlook.com>
In-Reply-To: <DM6PR11MB3371A3D1F314F3B8541FAF03E6DA9@DM6PR11MB3371.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=jumptrading.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f8e0876-56b0-43ad-6543-08d977c8544d
x-ms-traffictypediagnostic: MWHPR14MB1631:
x-microsoft-antispam-prvs: <MWHPR14MB1631B934FD7FA51CDFFBD647A1DA9@MWHPR14MB1631.namprd14.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MwOLV4K0ltcqq38ZXIugUGNyQzZ0d4f+EF2f6WfpztiZlCJzsBwgR5m7Z1in3Rw6/1gatywvBR8j8jduOHHBaWVbuy2pdvDcr6syRMdBf7fPMFy870QXXjaclNEbguzA57Yx1yS3ga37hjYWRdMj69tIQYrpHzWbFSuERHw4+afTAnDo0XfqBJtp5xYgsU2C/XJlN7vaOLIy/fm1IXW5LeijAgp5DNh9ZQBMIqrV7YqrX86PWQqTHf0qSUYGnJCql/cRIvslJ3DS0an+T0vgjI8lfxfu7hCyy7IUrEsilLrLXM46l8xm1DcDeaEDRAP1Q9rSzQYeGi2JT0gADPvQKgu+O48C19HoEIEJ5LOrnxL+DFkGOIxGxYpAPbi5bmlKRN/K0Zg4xafponjtDbx9iqgxdxQvYaPmRJb2EHTveFlkDNL2CIv08PoceKyp9iwWWVrzVJChKOGavoW/Cju6DZ6KIICXE+nWI1bBNtm6IZ5GyiqX0Fr8Q3vvFJqbltDn6CtlIC+nyRnxavw+GRhTxsojF2XzywoRL7YDP7Y4yFXrDCM2V2the5exLaxip31kgBOrw8rsTgTD/KrcKmdqx0AC5WUpVQ33TptXMjITwdmsvbr5EqXlypd1QmNT8Hb0wMSyXjKXQfTiv1S5HsqPx4HDHRiY2UlVzoEeIQvWiF5O9ovkdLkEAqwlDgKQ52pJ2zduIbt4CD/TjtdrSpChTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR14MB4796.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(136003)(346002)(376002)(6506007)(478600001)(110136005)(53546011)(5660300002)(7696005)(186003)(33656002)(55016002)(26005)(4326008)(71200400001)(2906002)(8936002)(316002)(38100700002)(66476007)(76116006)(52536014)(38070700005)(8676002)(83380400001)(66556008)(66446008)(86362001)(66946007)(64756008)(122000001)(7416002)(54906003)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0RTdFlqSjcyd3ZsR1FKT1hac0JkUjVOT0dHMkhCbGQ5ZGFaRFJXTkVrS3Fj?=
 =?utf-8?B?dFVVcC85S0syOVhETDRuOUlHNEVZalVKdWpxd0U4T0RQZktEVGY1SytaTmhl?=
 =?utf-8?B?SWN4cXc2RDhrK0Y1dmVzUXM4TSs0N0NoQVA3SUxMMHNKQmVId0UxTUQxRW9n?=
 =?utf-8?B?NTNWODBEVUFtR01La04vTTBObjRXZDkzbW5kOVVYcXZ2U3hyWTBPKzJvc0Iv?=
 =?utf-8?B?Z1U0ck9CN1M4RmJpeDdqNEM4QURTZm9Ja2pERGZmU3ZlbnBEY09JRzZPQUJZ?=
 =?utf-8?B?Tk9QdmtSYW9ZSkhsQ2hQOFZXdlZEQWVURkpHTjRackhpNWdyR3E1ZGdvVDBo?=
 =?utf-8?B?OU5XbUpUYXAwZzJ1UC9sSHFYNEdUZk1FSjJDeVpqN2s2VkhjYUJ0KzByT1dL?=
 =?utf-8?B?aWFDTHJ4YzlSUk5YcTVLcXJyd1NRZUFpUmRnQzNURG1SSmpnUHkwaVhJUytJ?=
 =?utf-8?B?Smh1aXlxbTd3dFpOcWg3RTBjYWRkKzc1UEFZcytGV1d4aEFWUDh5bFFBc1Fn?=
 =?utf-8?B?NktLYjdzZkEyYlJJUW55RW9aVVJzOVF3RDZpNlVmQ3NxTE1XU045QUY5bjJw?=
 =?utf-8?B?aERWOUhvNERBZUxFVlhWQ1R1L0dBbEd0TTdwNmZPbGw1MUlLMXozeEg3TjhE?=
 =?utf-8?B?TWtUQytHN2YwU1VYMk44UHJZWVo2L0JUQlY5VXZQVUs2eC8vUEFwRTY1UmRI?=
 =?utf-8?B?MjYwckpwVUFobkNITWg1c1FnMU5KT3BqK3padkkrWFNNY3dHOGk0KzNqbWtZ?=
 =?utf-8?B?VUorTEZjR3FPK1BNOCtFeTFYUzI3WG5FR0t2bFUwSnd1Vi9jWDVyV3ZKQzRt?=
 =?utf-8?B?S1dGNVVUVURVZnA2ckE4cS9EUHBaMEgwQkZFTVROcGhiZmpjMGFKZm9vWE9r?=
 =?utf-8?B?cU1BTk1yVDhHRWk1VmdOV214NTVCOFpzaVloMDkwajM5R0p5QTYwNHgxWGlO?=
 =?utf-8?B?YmxlajJEenE0UlVrc2VpODFkOUIrTVIwR3pGTTBXZlNEcndLTFFxR1BvZ3ZX?=
 =?utf-8?B?cjVVcElzSG9kWUtQc2ZQSDV6NEZmY3ZzaXRXUnlZNWFxdWxsN212SysyQnhv?=
 =?utf-8?B?dGtFOW55a3pGMDdsQmZNUXRYOVpWUVpWYkZzbHBTckpaam5SWVhOSVk5NDlK?=
 =?utf-8?B?V1NIWUgwZ1Z4Z0paVDd4czNKOXV0cFhsNkNNNWFyQjhGT2FYYytTNnFsYUov?=
 =?utf-8?B?THV6ME90K21WRXpicjJGYTdLSnlhM0dpMGFJTXVzZk5HbUVIUmVTc0RqUTVs?=
 =?utf-8?B?SnlEdDVJQTZCU0xMbnU1bHQ4eTFpWFNIU3lWQlRLWGE5ditHc1NLeUdWcFJn?=
 =?utf-8?B?RStSUFpqbEJHQ0ErcktycEpieHM5OG5hWjlzRi9pbDBzeWxLajk0OWZaYWJT?=
 =?utf-8?B?WkVNNUhMRUhGQzduNDVpUFg0em96OWxHWFVEeWE1WU90VFNBTVlpenFsN3N2?=
 =?utf-8?B?dTJjUUd2NnRHemcvRUdkUWdpTmF1bk5ZODNhWkNsVXVjZU4wV0JyS2hNUXhh?=
 =?utf-8?B?Y28zWllKbkVNUXhqMFBWUWxOQUp3QUFyV2dtZXd0ajkxbnFmTE9ac3c5YlNG?=
 =?utf-8?B?ci9PMzVJbWcxb2ZSUThjNGF3UXJLYWlYSlJEaVBIS05pSjkvTXdIT1JiUVM2?=
 =?utf-8?B?RlFZZGhLS3ZKS2lmTGQweXdNK1Nra21relJNZnZpTmJORkJJWFRFM2xocno1?=
 =?utf-8?B?WVhmRGROMDNETjAyUm93T3FqaDFhSzF2M3Z1aTRHbUNiVkVVQXdNa283aXN1?=
 =?utf-8?Q?UXAOnf4DGqdsMIdR8DKp09lig+dVfp6gNfencN6?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: jumptrading.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR14MB4796.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f8e0876-56b0-43ad-6543-08d977c8544d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 21:40:53.9754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 11f2af73-8873-4240-85a3-063ce66fc61c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HrvXI23w+UgJ67a3TukEJZOPSAPkR1CvXlivE8KkWnAgsbFAVADvuYmO4hbA40Fu6zdr8+/c+GIsl7X1eMz3JOlH0+PPXGaHIQWj9oxotLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR14MB1631
X-Proofpoint-GUID: cn1nzDrQkGcod6iB7N8mlXkFktahAke0
X-Proofpoint-ORIG-GUID: L8BVpBOKB-dG7mvVI2soM2nRfabzRSeT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-14_08,2021-09-14_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 phishscore=0 spamscore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3lsd2VzdGVyLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IER6
aWVkeml1Y2gsIFN5bHdlc3RlclggPHN5bHdlc3RlcnguZHppZWR6aXVjaEBpbnRlbC5jb20+DQo+
IFNlbnQ6IFR1ZXNkYXksIFNlcHRlbWJlciAxNCwgMjAyMSAxOjI0IEFNDQo+IFRvOiBOZ3V5ZW4s
IEFudGhvbnkgTCA8YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+OyBQSiBXYXNraWV3aWN6DQo+
IDxwd2Fza2lld2ljekBqdW1wdHJhZGluZy5jb20+DQo+IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0
OyBwandhc2tpZXdpY3pAZ21haWwuY29tOyBGaWphbGtvd3NraSwgTWFjaWVqDQo+IDxtYWNpZWou
ZmlqYWxrb3dza2lAaW50ZWwuY29tPjsgTG9rdGlvbm92LCBBbGVrc2FuZHINCj4gPGFsZWtzYW5k
ci5sb2t0aW9ub3ZAaW50ZWwuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgQnJhbmRlYnVy
ZywNCj4gSmVzc2UgPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsgaW50ZWwtd2lyZWQtbGFu
QGxpc3RzLm9zdW9zbC5vcmcNCj4gU3ViamVjdDogUkU6IFtQQVRDSCAxLzFdIGk0MGU6IEF2b2lk
IGRvdWJsZSBJUlEgZnJlZSBvbiBlcnJvciBwYXRoIGluIHByb2JlKCkNCj4NCg0KW3NuaXBdDQoN
Cj4gPiA+IEl0J3MgYmVlbiAyIHdlZWtzIHNpbmNlIEkgcmVwbGllZC4gIEFueSB1cGRhdGUgb24g
dGhpcz8gIE1hY2llaiBoYWQNCj4gPiA+IGFscmVhZHkgcmV2aWV3ZWQgdGhlIHBhdGNoLCBzbyBo
b3Bpbmcgd2UgY2FuIGp1c3QgbW92ZSBhbG9uZyB3aXRoDQo+ID4gPiBpdCwgb3IgZ2V0IHNvbWV0
aGluZyBlbHNlIG91dCBzb29uPw0KPiA+ID4NCj4gPiA+IEknZCByZWFsbHkgbGlrZSB0aGlzIHRv
IG5vdCBqdXN0IGZhbGwgaW50byBhIHZvaWQgd2FpdGluZyBmb3IgYQ0KPiA+ID4gZGlmZmVyZW50
IHBhdGNoIHdoZW4gdGhpcyBmaXhlcyB0aGUgaXNzdWUuDQo+ID4NCj4gPiBIaSBQSiwNCj4gPg0K
PiA+IEkgaGF2ZW4ndCBzZWVuIGEgcmVjZW50IHVwZGF0ZSBvbiB0aGlzLiBJJ20gYXNraW5nIGZv
ciBhbiB1cGRhdGUuDQo+ID4gT3RoZXJ3aXNlLCBBbGV4IGFuZCBTeWx3ZXN0ZXIgYXJlIG9uIHRo
aXMgdGhyZWFkOyBwZXJoYXBzIHRoZXkgaGF2ZQ0KPiA+IHNvbWUgaW5mby4NCj4gPg0KPiA+IFRo
YW5rcywNCj4gPiBUb255DQo+ID4NCj4NCj4gSGVsbG8sDQo+DQo+IFRoZSBkcml2ZXIgZG9lcyBu
b3QgYmxpbmRseSB0cnkgdG8gZnJlZSBNU0ktWCB2ZWN0b3IgdHdpY2UgaGVyZS4gVGhpcyBpcw0K
PiBndWFyZGVkIGJ5IEk0MEVfRkxBR19NU0lYX0VOQUJMRUQgYW5kIEk0MEVfRkxBR19NU0lfRU5B
QkxFRCBmbGFncy4NCj4gT25seSBpZiB0aG9zZSBmbGFncyBhcmUgc2V0IHdlIHdpbGwgdHJ5IHRv
IGZyZWUgTVNJL01TSS1YIHZlY3RvcnMgaW4NCj4gaTQwZV9yZXNldF9pbnRlcnJ1cHRfY2FwYWJp
bGl0eSgpLiBBZGRpdGlvbmFsbHkNCj4gaTQwZV9yZXNldF9pbnRlcnJ1cHRfY2FwYWJpbGl0eSgp
IGNsZWFycyB0aG9zZSBmbGFncyBldmVyeSB0aW1lIGl0IGlzIGNhbGxlZCBzbw0KPiBldmVuIGlm
IHdlIGNhbGwgaXQgdHdpY2UgaW4gYSByb3cgdGhlIGRyaXZlciB3aWxsIG5vdCBmcmVlIHRoZSB2
ZWN0b3JzIHR3aWNlLiBJDQo+IHJlYWxseSBjYW4ndCBzZWUgaG93IHRoaXMgcGF0Y2ggaXMgZml4
aW5nIGFueXRoaW5nIGFzIHRoZSBpc3N1ZSBoZXJlIGlzIG5vdCB3aXRoDQo+IE1TSSB2ZWN0b3Jz
IGJ1dCB3aXRoIG1pc2MgSVJRIHZlY3RvcnMuIFdlIGhhdmUgYSBwcm9wZXIgcGF0Y2ggZm9yIHRo
aXMgcmVhZHkNCj4gaW4gT09UIGFuZCB3ZSB3aWxsIHVwc3RyZWFtIGl0IHNvb24uIFRoZSBwcm9i
bGVtIGhlcmUgaXMgdGhhdCBpbg0KPiBpNDBlX2NsZWFyX2ludGVycnVwdF9zY2hlbWUoKSBkcml2
ZXIgY2FsbHMgaTQwZV9mcmVlX21pc2NfdmVjdG9yKCkgYnV0IGluDQo+IGNhc2UgVlNJIHNldHVw
IGZhaWxzIG1pc2MgdmVjdG9yIGlzIG5vdCBhbGxvY2F0ZWQgeWV0IGFuZCB3ZSBnZXQgYSBjYWxs
IHRyYWNlIGluDQo+IGZyZWVfaXJxIHRoYXQgd2UgYXJlIHRyeWluZyB0byBmcmVlIElSUSB0aGF0
IGhhcyBub3QgYmVlbiBhbGxvY2F0ZWQgeWV0Lg0KDQpUaGF0J3MgZmluZS4gIEkgZG8gc2VlIHRo
ZSBndWFyZHMgZm9yIHRoZSBxdWV1ZSB2ZWN0b3JzLiAgSSBzYXcgdGhlbSBiZWZvcmUuICBUaGUg
cG9pbnQgaXMgaTQwZV9jbGVhcl9pbnRlcnJ1cHRfc2NoZW1lKCkgdHJpZXMgdG8gZnJlZSB0aGUg
TUlTQyB2ZWN0b3Igd2l0aG91dCBndWFyZCwgb3Igd2l0aG91dCBhbnkgY2hlY2sgaWYgaXQgd2Fz
IGFsbG9jYXRlZCBiZWZvcmUuICBJbiB0aGUgZXJyb3IgcGF0aCwgaXQgdHJpZXMgdG8gZnJlZSBp
dC4gIFdlIGdldCBhbiBvb3BzIGZvciBhIGRvdWJsZS1mcmVlIG9mIGFuIElSUSAoYWxzbyByZWFk
OiBmcmVlIGFuIHVuYWxsb2NhdGVkIGludGVycnVwdCkuDQoNCkkga25vdyBob3cgdGhpcyBjb2Rl
IHdvcmtzLiAgSSB3cm90ZSB0aGUgb3JpZ2luYWwgcmVzZXQvY2xlYXIgaW50ZXJydXB0IHNjaGVt
ZSBmdW5jdGlvbnMgaW4gaXhnYmUsIGFuZCBwb3J0ZWQgdGhlbSB0byBpNDBlIHdoZW4gSSB3cm90
ZSB0aGUgaW5pdGlhbCBkcml2ZXIuICBXZSBoaXQgYSBwcm9ibGVtIGluIHByb2R1Y3Rpb24sIGFu
ZCBJJ20gdHJ5aW5nIHRvIHBhdGNoIGl0IHdoZXJlIHdlIGRvbid0IG5lZWQgdG8gY2FsbCBjbGVh
cl9pbnRlcnJ1cHRfc2NoZW1lKCkgaWYgd2UgZmFpbCB0byBicmluZyB0aGUgbWFpbiBWU0kgb25s
aW5lIGR1cmluZyBwcm9iZS4gIEkgZG9uJ3Qgc2VlIHdoeSB0aGlzIG5lZWRzIHRvIGJlIGEgc2Vt
YW50aWMgZGlzY3Vzc2lvbiBvdmVyIGhvdyB0aGUgdmVjdG9ycyBhcmUgZnJlZWQuICBXZSBoYXZl
IGEgdmFsaWQgb29wcywgc3RpbGwgaGF2ZSBpdCB1cHN0cmVhbS4NCg0KSSd2ZSBhbHNvIGNoZWNr
ZWQgdGhlIE9PVCBkcml2ZXIgb24gU291cmNlRm9yZ2UgcmVsZWFzZWQgaW4gSnVseS4gIEl0IGhh
cyB0aGUgc2FtZSBwcm9ibGVtOg0KDQpzdGF0aWMgdm9pZCBpNDBlX2NsZWFyX2ludGVycnVwdF9z
Y2hlbWUoc3RydWN0IGk0MGVfcGYgKnBmKQ0Kew0KICAgICAgICBpbnQgaTsNCg0KICAgICAgICBp
NDBlX2ZyZWVfbWlzY192ZWN0b3IocGYpOw0KDQogICAgICAgIGk0MGVfcHV0X2x1bXAocGYtPmly
cV9waWxlLCBwZi0+aXdhcnBfYmFzZV92ZWN0b3IsDQogICAgICAgICAgICAgICAgICAgICAgSTQw
RV9JV0FSUF9JUlFfUElMRV9JRCk7DQpbLi4uXQ0KDQpJJ3ZlIGFsc28gYmVlbiB0b2xkIGJ5IHNv
bWUgZnJpZW5kcyB0aGF0IG5vIGZpeCBleGlzdHMgaW4gaW50ZXJuYWwgZ2l0IGVpdGhlci4gIFNv
IHBsZWFzZSwgZWl0aGVyIHByb3Bvc2UgYSBmaXgsIGFzayBtZSB0byBjaGFuZ2UgdGhlIHBhdGNo
LCBvciBtZXJnZSBpdC4gIEknZCByZWFsbHkgbGlrZSB0byBoYXZlIG91ciBPUyB2ZW5kb3IgYmUg
YWJsZSB0byBwaWNrIHVwIHRoaXMgZml4IGFzYXAgb25jZSBpdCBoaXRzIGFuIHVwc3RyZWFtIHRy
ZWUuDQoNCkNoZWVycywNCi1QSiBXYXNraWV3aWN6DQoNCj4gUmVnYXJkcw0KPiBTeWx3ZXN0ZXIg
RHppZWR6aXVjaA0KPg0KPiA+ID4gLVBKDQo+ID4gPg0KPiA+ID4gX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18NCj4gPiA+DQo+ID4gPiBOb3RlOiBUaGlzIGVtYWlsIGlzIGZvciB0aGUg
Y29uZmlkZW50aWFsIHVzZSBvZiB0aGUgbmFtZWQNCj4gPiA+IGFkZHJlc3NlZShzKSBvbmx5IGFu
ZCBtYXkgY29udGFpbiBwcm9wcmlldGFyeSwgY29uZmlkZW50aWFsLCBvcg0KPiA+ID4gcHJpdmls
ZWdlZCBpbmZvcm1hdGlvbiBhbmQvb3IgcGVyc29uYWwgZGF0YS4gSWYgeW91IGFyZSBub3QgdGhl
DQo+ID4gPiBpbnRlbmRlZCByZWNpcGllbnQsIHlvdSBhcmUgaGVyZWJ5IG5vdGlmaWVkIHRoYXQg
YW55IHJldmlldywNCj4gPiA+IGRpc3NlbWluYXRpb24sIG9yIGNvcHlpbmcgb2YgdGhpcyBlbWFp
bCBpcyBzdHJpY3RseSBwcm9oaWJpdGVkLCBhbmQNCj4gPiA+IHJlcXVlc3RlZCB0byBub3RpZnkg
dGhlIHNlbmRlciBpbW1lZGlhdGVseSBhbmQgZGVzdHJveSB0aGlzIGVtYWlsDQo+ID4gPiBhbmQg
YW55IGF0dGFjaG1lbnRzLiBFbWFpbCB0cmFuc21pc3Npb24gY2Fubm90IGJlIGd1YXJhbnRlZWQg
dG8gYmUNCj4gPiA+IHNlY3VyZSBvciBlcnJvci1mcmVlLiBUaGUgQ29tcGFueSwgdGhlcmVmb3Jl
LCBkb2VzIG5vdCBtYWtlIGFueQ0KPiA+ID4gZ3VhcmFudGVlcyBhcyB0byB0aGUgY29tcGxldGVu
ZXNzIG9yIGFjY3VyYWN5IG9mIHRoaXMgZW1haWwgb3IgYW55DQo+IGF0dGFjaG1lbnRzLg0KPiA+
ID4gVGhpcyBlbWFpbCBpcyBmb3IgaW5mb3JtYXRpb25hbCBwdXJwb3NlcyBvbmx5IGFuZCBkb2Vz
IG5vdA0KPiA+ID4gY29uc3RpdHV0ZSBhIHJlY29tbWVuZGF0aW9uLCBvZmZlciwgcmVxdWVzdCwg
b3Igc29saWNpdGF0aW9uIG9mIGFueQ0KPiA+ID4ga2luZCB0byBidXksIHNlbGwsIHN1YnNjcmli
ZSwgcmVkZWVtLCBvciBwZXJmb3JtIGFueSB0eXBlIG9mDQo+ID4gPiB0cmFuc2FjdGlvbiBvZiBh
IGZpbmFuY2lhbCBwcm9kdWN0LiBQZXJzb25hbCBkYXRhLCBhcyBkZWZpbmVkIGJ5DQo+ID4gPiBh
cHBsaWNhYmxlIGRhdGEgcHJvdGVjdGlvbiBhbmQgcHJpdmFjeSBsYXdzLCBjb250YWluZWQgaW4g
dGhpcyBlbWFpbA0KPiA+ID4gbWF5IGJlIHByb2Nlc3NlZCBieSB0aGUgQ29tcGFueSwgYW5kIGFu
eSBvZiBpdHMgYWZmaWxpYXRlZCBvcg0KPiA+ID4gcmVsYXRlZCBjb21wYW5pZXMsIGZvciBsZWdh
bCwgY29tcGxpYW5jZSwgYW5kL29yIGJ1c2luZXNzLXJlbGF0ZWQNCj4gPiA+IHB1cnBvc2VzLiBZ
b3UgbWF5IGhhdmUgcmlnaHRzIHJlZ2FyZGluZyB5b3VyIHBlcnNvbmFsIGRhdGE7IGZvcg0KPiA+
ID4gaW5mb3JtYXRpb24gb24gZXhlcmNpc2luZyB0aGVzZSByaWdodHMgb3IgdGhlIENvbXBhbnni
gJlzIHRyZWF0bWVudCBvZg0KPiA+ID4gcGVyc29uYWwgZGF0YSwgcGxlYXNlIGVtYWlsIGRhdGFy
ZXF1ZXN0c0BqdW1wdHJhZGluZy5jb20uDQoNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fDQoNCk5vdGU6IFRoaXMgZW1haWwgaXMgZm9yIHRoZSBjb25maWRlbnRpYWwgdXNlIG9mIHRo
ZSBuYW1lZCBhZGRyZXNzZWUocykgb25seSBhbmQgbWF5IGNvbnRhaW4gcHJvcHJpZXRhcnksIGNv
bmZpZGVudGlhbCwgb3IgcHJpdmlsZWdlZCBpbmZvcm1hdGlvbiBhbmQvb3IgcGVyc29uYWwgZGF0
YS4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCwgeW91IGFyZSBoZXJlYnkg
bm90aWZpZWQgdGhhdCBhbnkgcmV2aWV3LCBkaXNzZW1pbmF0aW9uLCBvciBjb3B5aW5nIG9mIHRo
aXMgZW1haWwgaXMgc3RyaWN0bHkgcHJvaGliaXRlZCwgYW5kIHJlcXVlc3RlZCB0byBub3RpZnkg
dGhlIHNlbmRlciBpbW1lZGlhdGVseSBhbmQgZGVzdHJveSB0aGlzIGVtYWlsIGFuZCBhbnkgYXR0
YWNobWVudHMuIEVtYWlsIHRyYW5zbWlzc2lvbiBjYW5ub3QgYmUgZ3VhcmFudGVlZCB0byBiZSBz
ZWN1cmUgb3IgZXJyb3ItZnJlZS4gVGhlIENvbXBhbnksIHRoZXJlZm9yZSwgZG9lcyBub3QgbWFr
ZSBhbnkgZ3VhcmFudGVlcyBhcyB0byB0aGUgY29tcGxldGVuZXNzIG9yIGFjY3VyYWN5IG9mIHRo
aXMgZW1haWwgb3IgYW55IGF0dGFjaG1lbnRzLiBUaGlzIGVtYWlsIGlzIGZvciBpbmZvcm1hdGlv
bmFsIHB1cnBvc2VzIG9ubHkgYW5kIGRvZXMgbm90IGNvbnN0aXR1dGUgYSByZWNvbW1lbmRhdGlv
biwgb2ZmZXIsIHJlcXVlc3QsIG9yIHNvbGljaXRhdGlvbiBvZiBhbnkga2luZCB0byBidXksIHNl
bGwsIHN1YnNjcmliZSwgcmVkZWVtLCBvciBwZXJmb3JtIGFueSB0eXBlIG9mIHRyYW5zYWN0aW9u
IG9mIGEgZmluYW5jaWFsIHByb2R1Y3QuIFBlcnNvbmFsIGRhdGEsIGFzIGRlZmluZWQgYnkgYXBw
bGljYWJsZSBkYXRhIHByb3RlY3Rpb24gYW5kIHByaXZhY3kgbGF3cywgY29udGFpbmVkIGluIHRo
aXMgZW1haWwgbWF5IGJlIHByb2Nlc3NlZCBieSB0aGUgQ29tcGFueSwgYW5kIGFueSBvZiBpdHMg
YWZmaWxpYXRlZCBvciByZWxhdGVkIGNvbXBhbmllcywgZm9yIGxlZ2FsLCBjb21wbGlhbmNlLCBh
bmQvb3IgYnVzaW5lc3MtcmVsYXRlZCBwdXJwb3Nlcy4gWW91IG1heSBoYXZlIHJpZ2h0cyByZWdh
cmRpbmcgeW91ciBwZXJzb25hbCBkYXRhOyBmb3IgaW5mb3JtYXRpb24gb24gZXhlcmNpc2luZyB0
aGVzZSByaWdodHMgb3IgdGhlIENvbXBhbnnigJlzIHRyZWF0bWVudCBvZiBwZXJzb25hbCBkYXRh
LCBwbGVhc2UgZW1haWwgZGF0YXJlcXVlc3RzQGp1bXB0cmFkaW5nLmNvbS4NCg==
