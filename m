Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C432443324B
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 11:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235055AbhJSJfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 05:35:48 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:14086 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234914AbhJSJfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 05:35:41 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19J821bG026898;
        Tue, 19 Oct 2021 09:33:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=V70kHdMaKbFoL9SL40FRW98noSN68wWHCYnTjYmC6gk=;
 b=N/FDkxEca1wWvxetbsTypi2oWfRsIgrBaUjX97Nt/LMITwXskpGBQrTG6af4n86opW0w
 V9dxplFHt7aLOqrxER2RNQGKxDyaiwfnkHzXU403fTyiGWCoMXrHhN845U/SaP7gJT2j
 Yr/yNzjxT9Ib+3vKMS5RzzE1EL1P8JHSbISXR2ppDWeujRFAFuFnJXR4aWAI9KIzfJNC
 L+s8DjoQHziQSPvqrJWshjI4YvTzouc2/6qPR6xfsTFLxaO4cxJTnhtIq5kvUDuSEvFE
 o6xOsfUebCjzthDGeElyc6nDmWNqngWy4y5cjyEfOUAeerYt3Oq89uXa2q/yAdF+hR68 sg== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bs6hhgx88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 09:33:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPdhptZJx0pUUg1tfVsg3FJcHlMqz3esnRyL/WJXXsWoRuL2+w2xnJxNgLDgEBFXvcMPDyKIYJclx1SI+IBy3bsJRoWd6haSm0WqxwR+IDN/s7o1ezWi0sMnlIb0pEuROyGdHZVlDhHpiCQaTJSXD0eQ6lDYRra207jL085/5aKcf8Ebe3ph4xU8rqxNoUSS7YB3kM38l6zI8xV8pTGmFMBQyYGU9biLBY3edsuhfx8zT2rl6BQZ7/J+htFiOJ+8eAlauEuG6jI5eu2oD3jCG9AdAMzU4KFEdzTlHONp2X0WTBBkaSaNGVz+RV990O3p/rdskT8NbARV8i4kvJiHXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V70kHdMaKbFoL9SL40FRW98noSN68wWHCYnTjYmC6gk=;
 b=LtvBCLcDIWnLymvmdqxxhWlrWWfIjx+wDsp4I5n1aClQoi1KW9YtPIsrP9RgwsOa3t9XmOYzsV617/18JJhWiUmT0IczY78PGsogTKEbzfwGxiEEQOqhR1fXMxVwpdCZ872gLhQ4o/1VYMMpVPYZyPYOWYknDKJc/pZ9VDE4SpE9uKwtnRb12wJnsxBZjiyu4h0pEtOo83qwxXE13C/EIWb0nDOHiISvWQP06L+tBl4owlVz6AF448e7O9MSyHvB0fuOjpju0LjGM8S577nc4IaSrkexMBE0FGLaYPB/LohT3bYErlA0ERKMMT6yEsnTneEFH5beKJsznEfD4KappQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24)
 by PH0PR11MB4837.namprd11.prod.outlook.com (2603:10b6:510:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 09:33:06 +0000
Received: from PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::c11a:b99e:67ce:4a14]) by PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::c11a:b99e:67ce:4a14%8]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 09:33:06 +0000
From:   "Li, Meng" <Meng.Li@windriver.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "ramesh.shanmugasundaram@bp.renesas.com" 
        <ramesh.shanmugasundaram@bp.renesas.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] driver: net: can: disable clock when it is in enable
 status
Thread-Topic: [PATCH] driver: net: can: disable clock when it is in enable
 status
Thread-Index: AQHXxMnLa7t/w2ky1kKaKS/hPb8GyKvaDFUAgAACufA=
Date:   Tue, 19 Oct 2021 09:33:05 +0000
Message-ID: <PH0PR11MB51910E4A6C3B4879EB6F524FF1BD9@PH0PR11MB5191.namprd11.prod.outlook.com>
References: <20211019091416.16923-1-Meng.Li@windriver.com>
 <20211019092320.wrs2o7cmn4pmnirt@pengutronix.de>
In-Reply-To: <20211019092320.wrs2o7cmn4pmnirt@pengutronix.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none
 header.from=windriver.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59f9f522-02a2-410c-28db-08d992e3748b
x-ms-traffictypediagnostic: PH0PR11MB4837:
x-microsoft-antispam-prvs: <PH0PR11MB4837D4A18205BD81D09DF6F0F1BD9@PH0PR11MB4837.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:949;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wMMUKSJGKpKBuu/cNPvA1OSat2IDum9xJlJsGMl8XpHMFHpiL5PVOt9frIICKsHJkrcTC09YXZZqaE/Huz0z7mugGFsiq0E+8arHOpFVFVuP6VU0st10oRUpxxAwWIIsZcHWa+MUuMvPgKjtbHY4LtA4BRKRTaiN9qxdy4DWZ2mgJVHcVDjopfjzACf0ghR8pUxN9xoyoo0Rpku9e5zRM9/yF8pNdGyemxPQZLWZtjmZnH4G3KQn8aQjsO5XzG9xCpv+k0X2WnMlVqI4R2s3RBuGDfIXLfTWxaFWsyuuB81qCPrkBjprVV1OkRGx6m08Xu5Ipy00NJOhE+JHsW301hYAjBygAAWXWOWIWBKQ7lEkFKWL16Qs5U9eUFvYd23dBZuWrU+6wfsWQQjwh0Uryq3EsgLNMna7OCS8X3WxPRYdnsjGwgqoslybIQp+/tcJ96g7W3nyWfpWbBf1D0eHJ2eKjxFZTHxIVKBbJzhOB8Nr8A5nUXZF+IR2lZATr20HrtglOss9OcgpTE13hpJXhC7SOH0sl9cy1EeJdECyLKx0xihYC6180NdXvNKp0B4J2vD0cnQv1K47DTk9HV0huhp0033S3l9zgS5xkS3/yA0k1ykUfa83uBNq/lQThNiUb8Szq594jqVs1LSvGr+0nvNHegalrS3sTO42MxRibAMxiG6WntFjBhBK7dTQje9QqmZ46XxBroCYyM4lwugDzyELCHyZDIAd7Xdg/8astYc/zeoSzBHVWr0idqFWlUoj1wLAWUUYaQcz0Pu3cBTqeXae/ql929E0bbO0I/SC8z0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5191.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(508600001)(4326008)(38070700005)(316002)(76116006)(64756008)(8936002)(7696005)(33656002)(53546011)(83380400001)(66946007)(966005)(38100700002)(66476007)(6506007)(86362001)(2906002)(66556008)(8676002)(55016002)(186003)(71200400001)(54906003)(9686003)(66446008)(7416002)(122000001)(6916009)(5660300002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2tZSk4xK0xDN1c1N0NMSlQzU0hvR1V4Umx3QlZza1RCNFJ1T3RyWVcyUHla?=
 =?utf-8?B?bzBnUk9laklrN2xwdEtGY3F2Vm5mcjk5WUxjYjBhVTRoRHNka0VqMjUxM1F2?=
 =?utf-8?B?bWx1VExteDJuN1NZYVZLUG1NRFdVdnQzRTNrRmJ1dU96enM5RC8yaS9sVHNJ?=
 =?utf-8?B?Zk54VEZVSTNVZGZGUC9PdnY4aE1wMUhMaGM1MDgwSE5YY1cyZU5HVnArVXJG?=
 =?utf-8?B?TTF2MTA0Ymhodm5rTmZoYkxJNHZFZHEwNE1EMjl0TG5HZDRoc25lZklFSTJY?=
 =?utf-8?B?ODl4VHdwcmhzd1M4cm9zRGtGaEVMRXRPQnVvOTJQVHdnZFdCd3dkc0Y2aCsy?=
 =?utf-8?B?NmtFYXp0czdHZU5rT1U1YStUWExBSUVpY1FXMU4zSFIxak9xNkZObXozQTFF?=
 =?utf-8?B?MldUYXFRMlJNTlhQV1JSWTM1Y2FYMG4wdFcvdlBreWF5Uit3Z25qLzNrbWFF?=
 =?utf-8?B?eGhNUkQzdmhNL3RRNjY1S21TeWgvaHZmRkpKUE81OEZZVUdiRTV5a096RWJD?=
 =?utf-8?B?SFJuNDJXUXl0WkwzbHF0bmlFSlJGS0trOWN0dnFlYXJ2QVRCVHZNQlhJYW9V?=
 =?utf-8?B?MitBemJ5UWhEZEI5NTZPOGU2RE1aeitobjU5TTZ0NG1OZW9qQkNYL0dPL1BS?=
 =?utf-8?B?dDZjSHJ1dW5DMlFSck1Ec2taY3BQZStpU1Rxb1UwcUljeEdKazRvSXpWS2Yx?=
 =?utf-8?B?UUE1OFR1ZkFyc1RJSFZucHBEZWZob2JSekE5RzBYbHlTMmhCajY0Vk45eFZt?=
 =?utf-8?B?c1pzankwdlNSNUxqd1Npbjl6MGhXRlp5YzFhb2FFQkZVbzhXZXJ4R0VkZCtB?=
 =?utf-8?B?am9IekVzMnozR0RPZXdnV3M5blBLZmx5SDNOQWw2LzRUQVQyUWpHS1M4bERn?=
 =?utf-8?B?S2daN0FmeGdROVk2dEF4ZlZSekZVRUVEZWRpTEJVcmhEdm16cVVydzhmZjZu?=
 =?utf-8?B?MlhKbDA3MmdtcVBERjU5MVNxTS9vNEdaN1kzYSs2WDVDNHNpM21LRURSaHFP?=
 =?utf-8?B?d2VNR244akNKQW5yNkQrcllEeDhpaFZpUmJJUnh0S25VZTdPc2QrMFUvYTFE?=
 =?utf-8?B?dlFDZkQ2WXQ0Y0FTL3g5c0d1MHdoOVY5UENvL1VBM2tVcmlZanBKZlUrakNU?=
 =?utf-8?B?TTFNeWxmNVFxMWoySjFGYnlIS3lYbVlaSWszUG1OU1QvRjhsUE82ckdXenI3?=
 =?utf-8?B?NldVYkFmVnhCalJXaitSMXFVVUJDSmVhajB3Q0s1TVRGYWFJaVJtaUoyY3dU?=
 =?utf-8?B?dE5OL3FBVk94RmdSczN2eHJJWXlZUy9HUEhjbjB2SjhMREgrRHNCbXg5MDlV?=
 =?utf-8?B?bUQ3VENHblhiQ0NEdVZrd0plck9kVTBkbGp2NmpuYXN5cEZrVGp1SWkreGd5?=
 =?utf-8?B?K2JFMHdaQ0ZvY2syREZVckxYdGRGeXQrM1hqUmZaa1hpSnYzQk5TYVlxclJh?=
 =?utf-8?B?elRkQWE1SXNGY2hZL2ZsVGZpRTRaMUpEaDlEY05kY1NHRTJwc1NWMGFuSGZo?=
 =?utf-8?B?eTNGcFlzVjVnZlVUOHliRmhQYUp5U2VZK2lZN0NaVWdkUzIwVTN4SUZwUXJS?=
 =?utf-8?B?VU9hNVBIc3lQb0lES3VwU2l2M0xJT1VIR09zUDRrY0RhNWpOOFZmMTVSNVlS?=
 =?utf-8?B?TE1OckltTmU1RUd1UUlZdUZXRnovZGo4KytGU0wxZUJtVklrZ3I1Q2x6bW1y?=
 =?utf-8?B?Tzhnc042em1LQlpaT3NRZU5vcEl1YmhwS24rWEhEZ1dhZ3JUMExlZGZpNm85?=
 =?utf-8?Q?M33NfxyJ3BDKEoCvcUshO6U6qZiOq2Dr2D0Ya2I?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5191.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f9f522-02a2-410c-28db-08d992e3748b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2021 09:33:05.9009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5NIpytg9xUzYNS8u4Q+bUjUVsRVglzkZpEuirUaUF5JG2LPD3OtFrFpXiGIzWzZLe+npIIXfcViiZneKpTbI7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4837
X-Proofpoint-ORIG-GUID: ToiJHXhOAO5e0XQXB4Z2cZWFu-lxLtBV
X-Proofpoint-GUID: ToiJHXhOAO5e0XQXB4Z2cZWFu-lxLtBV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_10,2021-10-18_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=809 adultscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWFyYyBLbGVpbmUtQnVk
ZGUgPG1rbEBwZW5ndXRyb25peC5kZT4NCj4gU2VudDogVHVlc2RheSwgT2N0b2JlciAxOSwgMjAy
MSA1OjIzIFBNDQo+IFRvOiBMaSwgTWVuZyA8TWVuZy5MaUB3aW5kcml2ZXIuY29tPg0KPiBDYzog
d2dAZ3JhbmRlZ2dlci5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsN
Cj4gbWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI7IHNvY2tldGNhbkBoYXJ0a29wcC5uZXQ7DQo+
IHJhbWVzaC5zaGFubXVnYXN1bmRhcmFtQGJwLnJlbmVzYXMuY29tOyBsaW51eC1jYW5Admdlci5r
ZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIGRyaXZlcjogbmV0OiBjYW46IGRpc2Fi
bGUgY2xvY2sgd2hlbiBpdCBpcyBpbiBlbmFibGUgc3RhdHVzDQo+IA0KPiBPbiAxOS4xMC4yMDIx
IDE3OjE0OjE2LCBNZW5nIExpIHdyb3RlOg0KPiA+IElmIGRpc2FibGUgYSBjbG9jayB3aGVuIGl0
IGlzIGFscmVhZHkgaW4gZGlzYWJsZSBzdGF0dXMsIHRoZXJlIHdpbGwgYmUNCj4gPiBhIHdhcm5p
bmcgdHJhY2UgZ2VuZXJhdGVkLiBTbywgaXQgaXMgbmVlZCB0byBjb25maXJtIHdoZXRoZXIgd2hh
dA0KPiA+IHN0YXR1cyB0aGUgY2xvY2sgaXMgaW4gYmVmb3JlIGRpc2FibGUgaXQuDQo+ID4NCj4g
PiBGaXhlczogYTIzYjk3ZTYyNTViICgiY2FuOiByY2FyX2NhbjogTW92ZSBSZW5lc2FzIENBTiBk
cml2ZXIgdG8gcmNhcg0KPiA+IGRpciIpDQo+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcN
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBNZW5nIExpIDxNZW5nLkxpQHdpbmRyaXZlci5jb20+DQo+IA0K
PiBUaGFua3MgZm9yIHlvdXIgcGF0Y2guIFRoaXMgcHJvYmxlbSBzaG91bGQgaGF2ZSBiZWVuIHJl
c29sdmVkIHdpdGg6DQo+IA0KPiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC9uZXRkZXYvbmV0LmdpdC9jb21taXQvP2lkDQo+ID1mN2MwNWMzOTg3ZGNmZGU5
YTRlOGMyZDUzM2RiMDEzZmFiZWJjYTBkDQo+IA0KDQpPayENClRoYW5rcyBmb3IgcmVtaW5kaW5n
IG1lLg0KDQpSZWdhcmRzLA0KTGltZW5nDQoNCj4gcmVnYXJkcw0KPiBNYXJjDQo+IA0KPiAtLQ0K
PiBQZW5ndXRyb25peCBlLksuICAgICAgICAgICAgICAgICB8IE1hcmMgS2xlaW5lLUJ1ZGRlICAg
ICAgICAgICB8DQo+IEVtYmVkZGVkIExpbnV4ICAgICAgICAgICAgICAgICAgIHwgaHR0cHM6Ly93
d3cucGVuZ3V0cm9uaXguZGUgIHwNCj4gVmVydHJldHVuZyBXZXN0L0RvcnRtdW5kICAgICAgICAg
fCBQaG9uZTogKzQ5LTIzMS0yODI2LTkyNCAgICAgfA0KPiBBbXRzZ2VyaWNodCBIaWxkZXNoZWlt
LCBIUkEgMjY4NiB8IEZheDogICArNDktNTEyMS0yMDY5MTctNTU1NSB8DQo=
