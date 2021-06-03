Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585F739A3B3
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 16:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhFCOyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 10:54:00 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:34622
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230394AbhFCOx7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 10:53:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FeqOUjVFWieWobMGV4gus3uYMDw5LcD9d8pjSmG/KiRbymow/wMfF0WR19PUHrUjN7FSxLFzY+iklNADLzgWNeh+bvvU3VmZnyXbvJB3KdwdkI/fwHTPyiW2TowI2u+qopI8lKHzIOMeV6eBfpZRosS//yCtNtRilSKdrPpXBa2431POvgxJop+wIiiiOLfKmxGjoI83T7hGHoiv7+BR8w2z71bLs5NtbN60BnoAuhQkZVuowH/4HuMiysseupFdj0cJUGZcu/gRa2GTsl/XuEfmKlVeu9SfOxww6KwSFcR4Cz3eFtjRaCldPNLhEdlulADES8E/zptQBMqMs+NWpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZnLRO0DiZH0J+qIcUv0sVmwsisnkPeimaTtTzZ1tFg=;
 b=BsTMsHvlUOFI7Ni4wn9RQOwiQRl1zjkuqeO1y7QeWvt8r3hSCCjZqmNIfbeWb0PCitDwLkjy1Y62G60+hPvKNBtMqfZDdqBL/g1zrAO7LUgwnJUx0FQ7gd9GhM7r8/DDQ7B5bykEKM+9ci0bUU2gc70nixLILCYOrkS6d4WNjsWA4qAq22hQjH+t6daQysASkp8Syjero6zGu0W+mGVldydTHg8mAGsnzK4wvZg/ZQysnvC4VEBbMw1PLO+OZjHJ/yoH0Ja5d9m9dO2Llz2mRUzAHyGuoxTe0caNzkxFkq6DdTy7RnQWDyjP8PWX14UTfelvltYG74qFpD4I+gCxog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZnLRO0DiZH0J+qIcUv0sVmwsisnkPeimaTtTzZ1tFg=;
 b=miiBugBb4p6jSpdWqEl48g3vws8mnqYdFknhGPRDvb5N8bA1Vs2MGDYCGY1xFIuch2WEVmKwRGXlg7gcFp6zKIdV+F4Bw0Uku9mzaFQ8zq0Ye7hCXePjUwqSJbQJPJhjMug10+UmL6LUkdy7FY3WDXtwolNrAHfcoCWaMXK7O0w=
Received: from DBBPR04MB7818.eurprd04.prod.outlook.com (2603:10a6:10:1f2::23)
 by DB6PR0401MB2277.eurprd04.prod.outlook.com (2603:10a6:4:46::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Thu, 3 Jun
 2021 14:52:12 +0000
Received: from DBBPR04MB7818.eurprd04.prod.outlook.com
 ([fe80::fd56:435f:ce07:7535]) by DBBPR04MB7818.eurprd04.prod.outlook.com
 ([fe80::fd56:435f:ce07:7535%5]) with mapi id 15.20.4195.023; Thu, 3 Jun 2021
 14:52:12 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE:  Re: [PATCH net-next 2/2] net: enetc: count the tc-taprio window
 drops
Thread-Topic: Re: [PATCH net-next 2/2] net: enetc: count the tc-taprio window
 drops
Thread-Index: AddYhGoxAvs4fl/jT+CT+k560B546w==
Date:   Thu, 3 Jun 2021 14:52:12 +0000
Message-ID: <DBBPR04MB7818F4FA1546E3E71F547374923C9@DBBPR04MB7818.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 70143d0d-6652-4848-b783-08d9269f2be7
x-ms-traffictypediagnostic: DB6PR0401MB2277:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0401MB2277AEA59B16B2C37967AC91923C9@DB6PR0401MB2277.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pmgq1pJmoOc4+somQANIQQwdpoGpjqHYvtjQ4++M/TolhPS8duo9xE0/TcafGu5Xiz9t8Ve4MO9ds73KF5NSnHKn9UmynuJ6U/4cshkSrgCyi5yRHg0jUIWcaFt97+XfodSwOQ0Rk0PWJV7R++pO9WZ9IP5PlDSHt/eukTZ6YAnbA/j5voxOM+9IYOLbslRWnFN2wAxMV3As7XeJpzuK0W48xrXQH/GFEa8CEWpHL+xgwzQWlRMspvVCLpFL2toSpzK9Wra00QFQ0lop2lGPaTXFELqS/01HXMkaIlMs3i+XklMRSXMSxwbBE//fIi9VuKIBBvZRdhazwM2TqWWNTHs3wxyobUHZ2xMnFE+SL3vjEOWPPy7nr9QP1wIH+Fo83d4/C1w6C0Iq+gYvSGc7/h/6A8GN7OEg2asrT54Hts/v9rsH0PADBSZ8n92v97DA+U5GCRRIueQbqjz+XmIZA5j/VWp6n+9I22coopiVOblpkjT6oNc8A7TdfUa8PSsbTDRue4h+qQ+u/ZWkVuc/zSN2KuBJypyO/wtmP9K9Cx7JHWok3lO/A6pIRfpryowUMTtMbP39sY0H6kfrOmd6jlQznqDgOaj2f/1X26rJILY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB7818.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(39850400004)(136003)(376002)(2906002)(66556008)(66476007)(5660300002)(8676002)(71200400001)(4326008)(186003)(83380400001)(55016002)(53546011)(110136005)(76116006)(26005)(6506007)(33656002)(7696005)(38100700002)(478600001)(66946007)(316002)(86362001)(8936002)(9686003)(52536014)(122000001)(44832011)(54906003)(64756008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?OWlvWGFpWUkzbkJoK0l4bTdnaFZJRCtrUnQwVEdVdnNONGp1TGtjbmdjZlNY?=
 =?gb2312?B?d2xiZ1BpNHlIUzdxdkFiSm9kT0Zhd0loTDlxWTBKd2N0SGY5cmZDaFFkZUZp?=
 =?gb2312?B?SDBCWlJ6SEFvc0RxQW0wZXcwSjZwUmVGa2FvdlRwM044b1VXN21ZMHM4dUxo?=
 =?gb2312?B?OVN5QlMwdDZ2QytHK1VMamd0N3RWdTRGY3orTWc1VXFvR0ZhQ1haeTEwbEM4?=
 =?gb2312?B?ZUZYblA5NFFudUMrM3JkTWVkL3hBWU53SURja0lKNWZtZFNKNU5ocHpuZFpR?=
 =?gb2312?B?cURoaTYvVm9MUW16OHMralVzVlVneXRlY3hRTzZXWGxueForbHVna3lwT3k3?=
 =?gb2312?B?R21aSlFpSmRlSjFsVGdYajFpdUxwYkdoMThWbTJVQnhsR2dPNzl3ZjhJODJs?=
 =?gb2312?B?UEdvOXZoWXdnbVh4TzkzdG9IMzYzckVwbUthdHdRcW5YUnJtMUEyOVFGWFZs?=
 =?gb2312?B?Vk5DbUw2S3l1aVFTL2ZhbWxNTWFZalQzeVhScmQza21Id1JEbnlKZkxvQkw5?=
 =?gb2312?B?K1o4YUFkRFpwaWhoME1wcFhPeUxxU2d2ekh6REdFWjZPNUdHbEtiQWZCaGdS?=
 =?gb2312?B?MFhwRElQQWMxZWcyT1ZyMUFEbmErWmFsb3MwdVBCVUZFT21vU3BEUThwQ1VP?=
 =?gb2312?B?R0xrdzVRS283VXg5am50VlBqNGNTTHgvQjBBckNFV2pRbWdCc1hwZVlQZkdC?=
 =?gb2312?B?MVRONDRrbms2a3VIcHFwMk1aNENWeHFEZWt0bGtoeVZlVmNvUVZhd3dMbi9y?=
 =?gb2312?B?VDFDYlloRk1VaTVYcndiQkZQR29kV3NyVVRBSmNHR2pRVCtQQWhVcVlCbVJP?=
 =?gb2312?B?V0xmY1YrQnAvUXM5SWdDSHd0bFdvUE1zT01vSE5EL01xZDFnS01rT3c2VkRw?=
 =?gb2312?B?Mm1BdnZuYXRnS1AxWTZ2RUN2L2l1T09RTDdPWWVacnJEdWJwM2MzdFdGQUVu?=
 =?gb2312?B?UkJ2eVRlem8wdUdJa3d3QWgvSkE1cG5rN3ZaWFo4TnAyZTA2ZnpEcmRtMmww?=
 =?gb2312?B?MWRXMlZJblBYNSs1eFIxUzFhWVAwOUdRS21XYXNVamNhUHRyN1pXamRmT0Z1?=
 =?gb2312?B?d0pOOHZVQllsRUpuRmQ1V1I3Rk9TZ3p2cUJWeWVtTlVUenY4Sjhtejl1bXVn?=
 =?gb2312?B?ZTJWeHlZUFdjM2RlMFdSdDI3UFpUMnJDdDgwaVJyY3ljMzc3cGtxVDNNU3lm?=
 =?gb2312?B?Sm01S3E5SFBFY2FzN1BOVjd2bjhoSG5hWmJvQ2ZML1paSXNvcmJqRzVSR2Zz?=
 =?gb2312?B?V0U4Y05nam9wUmdlYWt4dnc0RmpsbXVwQk1oL3hSRXNYSHVKYWh4SllFaHZs?=
 =?gb2312?B?RUpyTGJoOW9xQWw2dWdFZjU4UmpGR2tWdVZLVmkvVFJ4bTFIVVVlc08zUnJL?=
 =?gb2312?B?eXNKc0J2cFhNdmxMZDBoZmZTaGMvSGJrbStGdUFiR1ZTZVBjUmZDc0lTamQw?=
 =?gb2312?B?ekJkWHo0N0VQUGY4aENEeW5kZHI3M0dWdXVRWVZZRm5OS2tZc1VrWEF3VCtz?=
 =?gb2312?B?Q1EyUnNxakNrWjN6a0hFQVRtM0pnQnEybXZ6dmllQUFwbml4TjNacGRJOWZZ?=
 =?gb2312?B?c0JUSWpidHVHdEdNTktYdkxZR0NMbytRQThpQXMwcGY1SElYRUNRajUzRXZh?=
 =?gb2312?B?TEdTS0xjL0FXMlRKQnIzR1NhZzBIdjUyUFh2Sy9JTktLNGNFc2k0VCsvN3Er?=
 =?gb2312?B?U3Y4UDd0WkdoNjQza3RkWmZWcDVFSDdOVkI4U0dEMTAzUmoyNTRvVmZjMGsz?=
 =?gb2312?Q?Py7R+czFGdb6YJ2JRVWU9disT6L24lSUpo+220y?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7818.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70143d0d-6652-4848-b783-08d9269f2be7
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 14:52:12.5896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7DYmBd4qrXLRDDm2TsvMldj89j8uHapta9Nw2wuExf/q0cEZOMHvdRFPip5WgQIf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2277
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrdWIsIFZsYWRpbWlyLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZy
b206IFZsYWRpbWlyIE9sdGVhbiA8b2x0ZWFudkBnbWFpbC5jb20+DQo+IFNlbnQ6IDIwMjHE6jbU
wjPI1SAyOjAwDQo+IFRvOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiBDYzog
RGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZzsgQ2xhdWRpdQ0KPiBNYW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBNaWNoYWVs
IFdhbGxlIDxtaWNoYWVsQHdhbGxlLmNjPjsgUG8NCj4gTGl1IDxwby5saXVAbnhwLmNvbT47IFZp
bmljaXVzIENvc3RhIEdvbWVzIDx2aW5pY2l1cy5nb21lc0BpbnRlbC5jb20+Ow0KPiBWbGFkaW1p
ciBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IG5ldC1uZXh0IDIvMl0gbmV0OiBlbmV0YzogY291bnQgdGhlIHRjLXRhcHJpbyB3aW5kb3cNCj4g
ZHJvcHMNCj4gDQo+IENhdXRpb246IEVYVCBFbWFpbA0KPiANCj4gT24gV2VkLCBKdW4gMDIsIDIw
MjEgYXQgMTA6MTk6MjBBTSAtMDcwMCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+ID4gT24gV2Vk
LCAgMiBKdW4gMjAyMSAxNToyMToxNCArMDMwMCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6DQo+ID4g
PiBGcm9tOiBQbyBMaXUgPFBvLkxpdUBueHAuY29tPg0KPiA+ID4NCj4gPiA+IFRoZSBlbmV0YyBz
Y2hlZHVsZXIgZm9yIElFRUUgODAyLjFRYnYgaGFzIDIgb3B0aW9ucyAoZGVwZW5kaW5nIG9uDQo+
ID4gPiBQVEdDUltUR19EUk9QX0RJU0FCTEVdKSB3aGVuIHdlIGF0dGVtcHQgdG8gc2VuZCBhbiBv
dmVyc2l6ZWQgcGFja2V0DQo+ID4gPiB3aGljaCB3aWxsIG5ldmVyIGZpdCBpbiBpdHMgYWxsb3R0
ZWQgdGltZSBzbG90IGZvciBpdHMgdHJhZmZpYyBjbGFzczoNCj4gPiA+IGVpdGhlciBibG9jayB0
aGUgZW50aXJlIHBvcnQgZHVlIHRvIGhlYWQtb2YtbGluZSBibG9ja2luZywgb3IgZHJvcA0KPiA+
ID4gdGhlDQo+ID4NCj4gPiB0aGUgZW50aXJlIHBvcnQgb3IgdGhlIGVudGlyZSBxdWV1ZT8NCj4g
DQo+IEkgZG9uJ3QgcmVtZW1iZXIsIEkgbmVlZCB0byByZS10ZXN0Lg0KDQpBbHRob3VnaCwgdGhp
cyBwYXRjaCBpcyBmb2N1cyBvbiB0aGUgZHJvcCBjb3VudGVycyBmb3IgbGFyZ2VyIGZyYW1lcyB0
aGFuIGFueSB0aW1lIHNsb3QgZm9yIHRoYXQgVEMuIEJ1dCBmb3IgY2FzZSBpbiB0aGUgYmxvY2tp
bmcgbW9kZSwgdGhlIGZyYW1lIHNob3VsZCBvbmx5IGJsb2NraW5nIHRoZSBUQyB3aGljaCBzZXR0
aW5nIGFsbCB0aW1lIHNsb3RzIHNob3J0ZXIgdGhhbiB0aGUgZnJhbWUgc2l6ZSBJRiB0aGUgcXVl
dWUgYW5kIFRDIGFyZSBvbmUgdG8gb25lIHBhaXJlZC4NCkkgY29weSB0aGUgVEdfRFJPUF9ESVNB
QkxFIGJpdCBkZXNjcmlwdGlvbjoNCiJUaW1lIGdhdGUgZHJvcCBkaXNhYmxlDQpUaGlzIGZpZWxk
IGRpc2FibGVzIHRoZSBUQ3MgZnJvbSBkcm9wcGluZyBmcmFtZXMgdGhhdCBhcmUgdG9vIGxhcmdl
IGZvciBhbnkgb3BlbiB3aW5kb3cgZm9yDQp0aGUgY3VycmVudCBjeWNsZS4NCjAgRW5hYmxlZA0K
MSBEaXNhYmxlZA0KIg0KDQo+IA0KPiA+ID4gcGFja2V0IGFuZCBzZXQgYSBiaXQgaW4gdGhlIHdy
aXRlYmFjayBmb3JtYXQgb2YgdGhlIHRyYW5zbWl0IGJ1ZmZlcg0KPiA+ID4gZGVzY3JpcHRvciwg
YWxsb3dpbmcgb3RoZXIgcGFja2V0cyB0byBiZSBzZW50Lg0KPiA+ID4NCj4gPiA+IFdlIG9idmlv
dXNseSBjaG9vc2UgdGhlIHNlY29uZCBvcHRpb24gaW4gdGhlIGRyaXZlciwgYnV0IHdlIGRvIG5v
dA0KPiA+ID4gZGV0ZWN0IHRoZSBkcm9wIGNvbmRpdGlvbiwgc28gZnJvbSB0aGUgcGVyc3BlY3Rp
dmUgb2YgdGhlIG5ldHdvcmsNCj4gPiA+IHN0YWNrLCB0aGUgcGFja2V0IGlzIHNlbnQgYW5kIG5v
IGVycm9yIGNvdW50ZXIgaXMgaW5jcmVtZW50ZWQuDQo+ID4gPg0KPiA+ID4gVGhpcyBjaGFuZ2Ug
Y2hlY2tzIHRoZSB3cml0ZWJhY2sgb2YgdGhlIFRYIEJEIHdoZW4gdGMtdGFwcmlvIGlzDQo+ID4g
PiBlbmFibGVkLCBhbmQgaW5jcmVtZW50cyBhIHNwZWNpZmljIGV0aHRvb2wgc3RhdGlzdGljcyBj
b3VudGVyIGFuZCBhDQo+ID4gPiBnZW5lcmljICJ0eF9kcm9wcGVkIiBjb3VudGVyIGluIG5kb19n
ZXRfc3RhdHM2NC4NCj4gPg0KPiA+IEFueSBjaGFuY2Ugd2Ugc2hvdWxkIGFsc28gcmVwb3J0IHRo
YXQgYmFjayB0byB0aGUgcWRpc2MgdG8gaGF2ZSBhDQo+ID4gc3RhbmRhcmQgd2F5IG9mIHF1ZXJ5
aW5nIGZyb20gdXNlciBzcGFjZT8gUWRpc2Mgb2ZmbG9hZCBzdXBwb3J0cyBzdGF0cw0KPiA+IGlu
IGdlbmVyYWwsIGl0IHNob3VsZG4ndCBiZSBhbiBpc3N1ZSwgYW5kIHRoZSBzdGF0IHNlZW1zIGdl
bmVyaWMNCj4gPiBlbm91Z2gsIG5vPw0KPiANCj4gWW91J3JlIHRoaW5raW5nIG9mIHNvbWV0aGlu
ZyBhbG9uZyB0aGUgbGluZXMgb2YgdGNfY29kZWxfeHN0YXRzPw0KPiBIb3cgZG8geW91IHByb3Bv
c2UgSSBwYXNzIHRoaXMgb24gdG8gdGhlIHRhcHJpbyBxZGlzYz8gSnVzdCBjYWxsIGEgZnVuY3Rp
b24gaW4NCj4gZW5ldGMgdGhhdCBpcyBleHBvcnRlZCBieSBuZXQvc2NoZWQvc2NoX3RhcHJpby5j
Pw0KPiBJZiB0aGUgc2tiIGlzIGJvdW5kIHRvIGEgc29ja2V0LCBJJ20gdGhpbmtpbmcgaXQgbWln
aHQgYmUgbW9yZSB1c2VmdWwgdG8gcmVwb3J0IGENCj4gc3RydWN0IHNvY2tfZXh0ZW5kZWRfZXJy
IHNpbWlsYXIgdG8gdGhlIFNPX0VFX1RYVElNRV9NSVNTRUQgc3R1ZmYgZm9yIHRjLWV0ZiwNCj4g
d2hhdCBkbyB5b3UgdGhpbms/DQoNClllcywgdGhlc2UgY291bnRlcnMgbGVhZCBvdXQgZm9yIGVh
Y2ggVEMsIGV0aHRvb2wgY291bGQgY2hlY2sgZWFjaCBUQyBkcm9wcGluZyBjb3VudGVyIGR1ZSB0
byB0aGUgb3V0IG9mIHNpemUgaXNzdWUuIA0KSSByZW1lbWJlciBRZGlzYyBkcm9wIGNvdW50ZXJz
IHdvdWxkIGluY2x1ZGUgYWxsIHRoZSBkcm9wIGZyYW1lcyBpbiBvbmUgbnVtYmVyIGFuZCBub3Qg
ZXhwbGFpbiBhbnkgc291cmNlLg0KDQpCciwNClBvIExpdQ0KDQo=
