Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923C74089FB
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 13:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239475AbhIMLTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 07:19:53 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26122 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238424AbhIMLTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 07:19:52 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DBCQdr027683;
        Mon, 13 Sep 2021 04:18:35 -0700
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by mx0a-0016f401.pphosted.com with ESMTP id 3b25je80jq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 04:18:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9U9EW1PvEvENnZGbY85vUV9zcUlZeCMH63ZZy0UZJEb+9JW/qvz0SqBXhmRsmdA5pWjGJu0IKxgcB7LHhDF1xKcvde10LjP1MsTFBEnS1J/i1iDe+46m5sAGPVO1YVmr/WMV/HI1MUwtUEkkYxMwmheXwH9D0fkBBW3lH+IsFrjtYw97VjE0GN0iT90XklmQQcBCIdT30ZLbfh374LK/Z+AgfJXrwQlddeVe81vUwiiIV4EVI3PMynn/SNpqRVbrHjkfycjytFZ/HAE0XFKUfXtJrcrOztyPLK0Sq00Jy8VVFadtBw0qA0M9fjKJ90aHNrkBSsBoAPdvqcTsMS3Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ZDmqUPkTG4mQuFkf9i4XgyN5iX1zy6YzLEKu1IKChnE=;
 b=NSj6zmuq0kfMAlbFWn4kLiiaips9yva73YDni6Ap5zuTk4uglSzXIAzu3WpFnNtwPqPXk2tbq/Vz8iPGHnpbRmeiYrklTAKD+D2JjtJDvGaJLa7cCbJqgMkpyo/TX/Jj6CjMLm9YJ7TNJ13RGlPZmOPyBNDfq8H1OJhD2k60EqHJn+3dDnrQ7bSciQ0is6lgVLtaadoFf/VThUE33vHdyhcCXTV7zEBccoXFQFF12+7e9XBTwuqUynQ5bj9ioc55jd5iVRXGMAEw6hI9eba+lhy9G4A0RRbbtSrOliFbfDCqKZIYaJiaXuyJGC14oh0NM6d779SlkwHMEYz37Dhxfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZDmqUPkTG4mQuFkf9i4XgyN5iX1zy6YzLEKu1IKChnE=;
 b=aIdmJyEfajMcMiGi4brHKKkpaf/39bQJ6GZwA9UpvOgdIChUk2E+VinsvSafr6hHWd8AUDJoXuDw44GSKPXAdUQ6i4vXb01NryIqfhqZmNnOLOHx+oVXMZvtpAopy79IWkTQkG1zvwv8/pBRkYNG4jLwNw49bamLgO6HHSuoNUo=
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13)
 by SJ0PR18MB3817.namprd18.prod.outlook.com (2603:10b6:a03:2cb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 11:18:33 +0000
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::c38:a710:6617:82a5]) by SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::c38:a710:6617:82a5%4]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 11:18:33 +0000
From:   Shai Malin <smalin@marvell.com>
To:     Adrian Bunk <bunk@kernel.org>
CC:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] bnx2x: Fix enabling network interfaces without VFs
Thread-Topic: [PATCH] bnx2x: Fix enabling network interfaces without VFs
Thread-Index: AdeokQdWaCl+umkYRFqKciB9qHGJfw==
Date:   Mon, 13 Sep 2021 11:18:33 +0000
Message-ID: <SJ0PR18MB3882AD2C9F93E24C35A2E6FECCD99@SJ0PR18MB3882.namprd18.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a7b6e9f-7fd1-4acb-4414-08d976a83922
x-ms-traffictypediagnostic: SJ0PR18MB3817:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR18MB381787E9141AAC30873A22D8CCD99@SJ0PR18MB3817.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cr7UvD8JntoQUWDKruFOzFNNYQjAk/nyMJ6rjQ1h2VIk/3I+PZ7r7dEC6qiabbTzvnCXKRtcxd9BH6flG8s0dR4vZfOBt+yP3zEfkLyngh71ZETNZlOkPcwSU9PcGRXFKbnGsY4b42Fcjha6nPvx7J7vP8+j4l+UZYe8UKYkVpBZi8CZqALkXv+erBxN9fP2yVbH+DG86cOVMQVa3OroJLM+SVdxJuGqmUKX1/m0YB65XBW2uusnIUL2VxuPgoARYEYmuLK016R81bTk3rAw5Z9u+XNdMaa92XMo/Nb6TlyGZzv+ILo8TippDk4VjK4UZjnbZGO07CCTSYSJUaERsbUG4Vk73+UQ2EG4PQapMVnsg0pw06qQPfKi0aKtf0mfr3yH2klN1YncCtcBdKfEMjVRrdYpj4Qoc+DOs446XkR+jZQGQa6B0+rc1SXhLNWgW8l04kvOngZ7qQ2ePgT0dLFDYI+c0xt0lW5xA340OkhhCbhUK10/atd9m4F1AK5qCPH9LYUbJzAZL6/q5s049OeGXY0BQMAkNphLWK19Zx2A5nrC697u2xp1dOgKCksmw/l5Uxus/ymk7C0AJwJYXfSuEbk8s15TH4wZPrN7w/VMuu/fc7SothqUtteiRHA9MaJ/pUA9ZE8ieYaHI0DdZ6YMmCPibo/Bb2E6rZS4KDJSx6br0n98FbJrDimrywT6XCHZWncFBTztmUk6F1Khhw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3882.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(52536014)(26005)(186003)(9686003)(55016002)(6506007)(33656002)(7696005)(38070700005)(5660300002)(6916009)(71200400001)(54906003)(2906002)(122000001)(66446008)(38100700002)(86362001)(316002)(83380400001)(8936002)(508600001)(64756008)(66556008)(66476007)(8676002)(76116006)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dENqZVRkZVdJZHpnVlE5c1BpQ2ZVSFpmSWRFTnU3ZnJTUWNDUS9CMlJCQk5u?=
 =?utf-8?B?cEZNNzBDWDdLTkgzMXdlbmFacnRNWTRsWnJ1R056ZGFOYkh1M0lTWm9iMUZS?=
 =?utf-8?B?WjZtdUlsS3N2NS93cGxsQ0prMFFnT25jalZlWDJhZXlPVlNnSmJIYWZGNW9z?=
 =?utf-8?B?SjVmcUVOT0tySWRDWTNDQnVBL01EMHJwRUoxYXdEc1Rjbnp4RW9tRysrc1Zn?=
 =?utf-8?B?ZWo1OXloaHV0VWw2ams3T0JFcHQvazBXZVg1Z21EeFIzeVlqeXllMnh6NXV4?=
 =?utf-8?B?Z1RhZ3Y2cExQM3kwYVU4a08vTjZFVjdtcmd0K2Jmd2p3cDhhRjNSWEgzNmhJ?=
 =?utf-8?B?MDRZZjRlYnloTERkSHE4QS9pRmlPT2hvRDdIWXgzZUxZTFJBbERZMDZIMXBv?=
 =?utf-8?B?ck54SHFGUGZCNGwvVEU4VHZxREMyYUZZcjRkVzRhY3J2SzhQQ0h5eUc2SEw0?=
 =?utf-8?B?Sy81MHpHZHJLMmpRSmxzRU85MkUvWFJNWTlSL2kyTU5vYjdSeVAyT04yaDVT?=
 =?utf-8?B?b3pWanM3VXBPYWhBeXZUQ0ZRanFweXRyWG9sUFJBVWF3UnpwSTRBZmQyTVM5?=
 =?utf-8?B?aUZFZGl2amVKbnN6a2RGQzg1WGl1YVRPazZnSDU0WmpET3BBd1Z0aitCVmQ2?=
 =?utf-8?B?YXAwRDFud2hNZDV2NGVET1hjaUJubm5Wd1VaSUlhbGtHK2pHQ1lWU3pxenZK?=
 =?utf-8?B?QzFGNWU5L3R5Vkl4anNkZU0xdmVZU2RxaWk0c2pmcjRQbjBubE00UkF2RUty?=
 =?utf-8?B?WnhDb3N2MHoyMHJYUG5GSFNiZnYzeFl1SnVVS1BRRHRrUTVXM1JpWmh5MmJM?=
 =?utf-8?B?OWJJVHVUNEgzcDF3ZGdVLzNLTFBwWXZDOXJDd3BxVTBwUHB4RWdWUko5SHVk?=
 =?utf-8?B?cVRJRzlVQzNIalRLbVYrVFREMVRzOVdJNDM2L3dvWTc1ak1VZ1E1ZEV4b1Np?=
 =?utf-8?B?cFBLeWxTYWp3NnNuMFZVdXBTY2FFWWRtWktWM0FyWXpHQmdLYVVRMlNOV3pH?=
 =?utf-8?B?cE11MWRUblBJZmpDVFJoRXhIaTJuckpLUGFISWNLaUphRTFBWTh6MC93N2pL?=
 =?utf-8?B?YmpnYkt3QVA0RkVheXFReVEwc0NKSlR4aDZNSmVpbXBoZmFFTnVSdEsrNThR?=
 =?utf-8?B?UXpxN3dldUpDZ2hkRTRtblBPRVc3MGJNSEx2YU1IckxkVEhXamJZeWkxeGF5?=
 =?utf-8?B?VUhidkNaYVlhV2luZWI0ZGNPc0FSMUZkVmVQd25TeHNQcmM4NjdPem95cEtX?=
 =?utf-8?B?VmkvYVN4UzB1K01vaUlPVHBOOU94cFFUZkJuWkpzSlJuOTdUSGttV2JMdVlq?=
 =?utf-8?B?a2JsMEdKQXZ3dWhpckRJK1hIbWU0YmZyMDJ6NllzWVJ2U1FpZHIzYzcxUHNK?=
 =?utf-8?B?MVh6UU1RMlZPc2dvMU91TzNNNXBaN3VnS3lhMFROY2tNWmVodERBTnFjNzl4?=
 =?utf-8?B?SVhWTG5ZNTI0QnduYWRrOUZ1TWpZaXluYlRPeTIrWkFxRmNDcStaTWdXNFRv?=
 =?utf-8?B?cWhMeHhhbGtRdi9nWG5IdERhc2FhbGFQZDBqWkgrV25EaG9vSWZpSU52VjJp?=
 =?utf-8?B?OVo3NERvY1dMOXQ1aEVMaWhKWm8rTkIzemxSd2h6UDRLWitEcWNSVHF2aFBS?=
 =?utf-8?B?Mm9rVjJGOFV1QzloYkVoemp1dHN1Vzk1RVNIdlh3aytObndvUGZWUlpYaXBG?=
 =?utf-8?B?VXhma3BoQ2p4VDBwNVJYM25iYUlBOXJsd0dlS0hUL3V4aGlJak9pUFpSM0Yy?=
 =?utf-8?Q?B1yH9X0MiC/r4wATHPV1ZeJ3OrAzFuLnrDDAOFV?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3882.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a7b6e9f-7fd1-4acb-4414-08d976a83922
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2021 11:18:33.3332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kbXOXmj9JaYKrctjAh1Hon6PZlXzfuw5FnMQufbm9y3oOmTZqKuW9hleDelpuUlLrQ6PrIVG3se3jcVAkM2n2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB3817
X-Proofpoint-GUID: _9-WiABln7h_jUrLCirIQCl2Mhshs_MN
X-Proofpoint-ORIG-GUID: _9-WiABln7h_jUrLCirIQCl2Mhshs_MN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_04,2021-09-09_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA5LzEyLzIwMjEgYXQgMTo0MlBNLCBBZHJpYW4gQnVuayBXcm90ZToNCj4gT24gTW9uLCBT
ZXAgMTMsIDIwMjEgYXQgMDg6MTQ6MzNBTSArMDAwMCwgU2hhaSBNYWxpbiB3cm90ZToNCj4gPiBP
biA5LzEyLzIwMjEgYXQgMTA6MDhQTSwgQWRyaWFuIEJ1bmsgV3JvdGU6DQo+ID4gPiBUaGlzIGZ1
bmN0aW9uIGlzIGNhbGxlZCB0byBlbmFibGUgU1ItSU9WIHdoZW4gYXZhaWxhYmxlLA0KPiA+ID4g
bm90IGVuYWJsaW5nIGludGVyZmFjZXMgd2l0aG91dCBWRnMgd2FzIGEgcmVncmVzc2lvbi4NCj4g
PiA+DQo+ID4gPiBGaXhlczogNjUxNjFjMzU1NTRmICgiYm54Mng6IEZpeCBtaXNzaW5nIGVycm9y
IGNvZGUgaW4gYm54MnhfaW92X2luaXRfb25lKCkiKQ0KPiA+ID4gU2lnbmVkLW9mZi1ieTogQWRy
aWFuIEJ1bmsgPGJ1bmtAa2VybmVsLm9yZz4NCj4gPiA+IFJlcG9ydGVkLWJ5OiBZdW5RaWFuZyBT
dSA8d3pzc3lxYUBnbWFpbC5jb20+DQo+ID4gPiBUZXN0ZWQtYnk6IFl1blFpYW5nIFN1IDx3enNz
eXFhQGdtYWlsLmNvbT4NCj4gPiA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+ID4gPiAt
LS0NCj4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9ibngyeC9ibngyeF9zcmlv
di5jIHwgMiArLQ0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxl
dGlvbigtKQ0KPiA+ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9i
cm9hZGNvbS9ibngyeC9ibngyeF9zcmlvdi5jDQo+ID4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2Jyb2FkY29tL2JueDJ4L2JueDJ4X3NyaW92LmMNCj4gPiA+IGluZGV4IGYyNTVmZDBiMTZkYi4u
NmZiZjczNWZjYTMxIDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJv
YWRjb20vYm54MngvYm54Mnhfc3Jpb3YuYw0KPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvYnJvYWRjb20vYm54MngvYm54Mnhfc3Jpb3YuYw0KPiA+ID4gQEAgLTEyMjQsNyArMTIyNCw3
IEBAIGludCBibngyeF9pb3ZfaW5pdF9vbmUoc3RydWN0IGJueDJ4ICpicCwgaW50DQo+ID4gPiBp
bnRfbW9kZV9wYXJhbSwNCj4gPiA+DQo+ID4gPiAgCS8qIFNSLUlPViBjYXBhYmlsaXR5IHdhcyBl
bmFibGVkIGJ1dCB0aGVyZSBhcmUgbm8gVkZzKi8NCj4gPiA+ICAJaWYgKGlvdi0+dG90YWwgPT0g
MCkgew0KPiA+ID4gLQkJZXJyID0gLUVJTlZBTDsNCj4gPiA+ICsJCWVyciA9IDA7DQo+ID4gPiAg
CQlnb3RvIGZhaWxlZDsNCj4gPiA+ICAJfQ0KPiA+DQo+ID4gVGhhbmtzIGZvciByZXBvcnRpbmcg
dGhpcyBpc3N1ZSENCj4gPiBCdXQgdGhlIGNvbXBsZXRlIGZpeCBzaG91bGQgYWxzbyBub3QgdXNl
ICJnb3RvIGZhaWxlZCIuDQo+ID4gSW5zdGVhZCwgcGxlYXNlIGNyZWF0ZSBhIG5ldyAiZ290byBz
a2lwX3ZmcyIgc28gaXQgd2lsbCBza2lwDQo+ID4gdGhlIGxvZyBvZiAiRmFpbGVkIGVycj0iLg0K
PiANCj4gSXMgdGhpcyByZWFsbHkgZGVzaXJhYmxlPw0KPiBJdCBpcyBhIGRlYnVnIHByaW50IG5v
dCBlbmFibGVkIGJ5IGRlZmF1bHQsDQo+IGFuZCB0cnlpbmcgdG8gZW5hYmxlIFNSLUlPViBkaWQg
ZmFpbC4NCg0KSSBhZ3JlZS4NCg0KQWNrZWQtYnk6IFNoYWkgTWFsaW4gPHNtYWxpbkBtYXJ2ZWxs
LmNvbT4NCg0KPiANCj4gY3UNCj4gQWRyaWFuDQo=
