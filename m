Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610A03678E9
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhDVExp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:53:45 -0400
Received: from mail-eopbgr40061.outbound.protection.outlook.com ([40.107.4.61]:17287
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229533AbhDVExo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 00:53:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPj1jKV+0Wu2IJuT409/KYBbpUGHg5/lBLufE1K2hWY7Z5oiV+SfcDPHCTZDXM+PQtqHfl2fMT0Q6dLGF7LYtx8HsLOpNoVpyXrWsgKgyyz1FltVc/vRRYBKS69Sz0HrMxazPuhmE2zmbqv3BVoj1VMaeyYdb5WKdlXuSWvUWgFIS4VlpxKZJ4aGbIYFiLidYmKQtnwtLcG7Raei/5YJz7XYuqKLSIBUMfG10VKMupdc9I2iIc2quI+63AFSR1iwkBLrRNRf5IdJJVdNY1yvSAwy+CkNRMFbBNsUuakdR826G3QTTfClR4MTef85r+8AG8OEhWuUGc7pnaKmrxOxBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntglTDUf4S3Di3xd29XV2UqSqIFs5pNZaETBlzHOHk0=;
 b=j0TqTs9yIZHE0YdXD9gWfcw9XzsLzMkAAbOtTU12ld9boOaq1RbDv5+Hb8+4M6luSHO6YQph7s+r74dagUxaN70p1VKzn3NFwfBCZLX9PZ/e/BcLz+RR2lAxXGhVy0hADYAZYeCGPYdG0TNHhdyhRG8TOgyEpkC7iQuEhm4npe1L/zx7H2br+Dz8JTCj/GXoMW9emKChZV3juAHrRwh3VAP71XbrrDb2nhWhzlbf6B9E8ooo/bekSc2HHlWtwqmf0dMPHS57Dp7GLa9q5KCFFkjKkP6l3Gy2dnsW1HyMGxnWVmDUpbo28CBzcAonYzMBo1hE7MsMwnc9tNzkpen6fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntglTDUf4S3Di3xd29XV2UqSqIFs5pNZaETBlzHOHk0=;
 b=TwqRE10jkfORYfj2eaMSviWDytLrfZpUkyCM6soSIFpP57CpsoJEpsAEBepGZFfXkhr37z6IJcahNXXC+DAGpwPdkviH3jhhyZiBgcCYJslFCvleXquowcVIw0GIXlv0ZSJRDbORIpIZQqkWXhnRtEiUzdcG++HQTpBYyjZ5vLs=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6971.eurprd04.prod.outlook.com (2603:10a6:10:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Thu, 22 Apr
 2021 04:53:09 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%7]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 04:53:09 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
Thread-Topic: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
Thread-Index: AQHXNRN2zsKOwhYLU0OtzigMEkddiqq78qqAgACuHyCAAMibgIACfU4w
Date:   Thu, 22 Apr 2021 04:53:08 +0000
Message-ID: <DB8PR04MB67953A499438FF3FF6BE531BE6469@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
 <f00e1790-5ba6-c9f0-f34f-d8a39c355cd7@nvidia.com>
 <DB8PR04MB67954D37A59B2D91C69BF6A9E6489@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <cec17489-2ef9-7862-94c8-202d31507a0c@nvidia.com>
In-Reply-To: <cec17489-2ef9-7862-94c8-202d31507a0c@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92b6b0a7-8e5f-41ac-b0a8-08d9054a8666
x-ms-traffictypediagnostic: DB8PR04MB6971:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB69710C716F454E5EC6C59613E6469@DB8PR04MB6971.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EjaHXmDAocapJUPnQqnSHwFVJ3U5b+Y/8z5qJ+bLBHKOh/W+Se5wAC1TJUgHs6uJ/7Vry3iY8py45vK9O3Fb1SJw3rqahQAJupYxg8lZTYfiVla3kyZybHZspaoEwq1xxJUlUMFsqcXyxve1BRo+X7OqrJxggjbqBeEwFFqEeuiB5i38vDyAYoas8OHUvUWr6FAtVSe7btHqctaXF1Z/9sCtsjJw7+ZavU6S4qjiOq6e6RqWq6a7/FtqeLPrkkZu7ZrdBq5sW0iNUvbaxiwaSXlopaQnbWuYb6/xKUP029SzUTU59Alrmru9KK15LUa/GhwqZ4gGCzkehMjScbalOJUGRllYkmtEp9iP5sPNmUc36J+nnRVvxnqyA+I+pcIAPhcZO47+oCr58l03q9+S58oFnHfHFhtvQRlPQaQPHPXuSClPMfa1YQPbGF+kfA8Uz5zuYzvoxTelkYrbalX/kK2531E+NsSKxX1i0sGIxpUyXo4CpfN9mHmU6JZ9CzHHXlXRfUfp63qOeinaNseM5sgmLqKAMKNoURtFX825PXsxQM+vMWbHOKrEP++L7caCuV1azNmtcev6jHN6erj4OUaCI24gRdwQmdhBCZa7IkM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(39850400004)(366004)(376002)(316002)(54906003)(110136005)(83380400001)(86362001)(26005)(52536014)(8936002)(7416002)(4326008)(66446008)(66946007)(64756008)(66556008)(33656002)(76116006)(9686003)(186003)(53546011)(71200400001)(5660300002)(7696005)(2906002)(38100700002)(478600001)(55016002)(122000001)(8676002)(6506007)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?aXZMVVFYZktaaGdGQStidVdaZDg5cmFOc2R4dnNmbWZscHBXNkRxWmVyc3dS?=
 =?utf-8?B?SHlMZk15UGY0eGc4Mnd0N1hyUytJaWV6THhSY0FYOHdHQy9YTElrUE1FQ3pF?=
 =?utf-8?B?UW1zeS9paU9LMCtDT0NxZXJ0eWtHa1BxMmtoZ24vdFhVSjhGMFlrSTc0OUtK?=
 =?utf-8?B?enFqUGVtQlVOOTU4eWtta0Rya1E2TmFZRTd1Umo3ZXVBbXJ1amlsUWV5bzhu?=
 =?utf-8?B?TlpqN2tIaHoxeC9WN2UvRm1yTzBSUDVCZm1NdU1WYTBlNDBjM3pXR2VkSXZY?=
 =?utf-8?B?MEFHQ3B3ZTROZmYyS0NmTWFsalFKVTc2eEkvSm9VcG4vRFpkT0VQbkcrcE5T?=
 =?utf-8?B?ZEM0Umk4YzVyenRDRFNWUWpJZTFNSGVUOUxPWDlxWjJQN3pFU21PNnRxL1ZP?=
 =?utf-8?B?TVlUMXlLTkV2QzVNN3Z0MVNENHN4TWY3bi95bWY1dFVVWTRYNmJPK0xFd2t1?=
 =?utf-8?B?UlJvd2NveW5MNzdUNmEvS25yb29tdlQrQlkzMy9pUDhzaGVnVldnVy8rOGpJ?=
 =?utf-8?B?OHU2ZmczV1gxdG5nZkU0QVVUK084NG9uY1hqaU1wWGYzRllER3Z0NFFMZ3hu?=
 =?utf-8?B?VDhCNUJlYy9xY2UwV2w3b3RMYzZpV1dFWDB2TU9WYTZwT0NZZmkwU3lWM0Ft?=
 =?utf-8?B?UTQxOTVZUzJKRm9FeGpUclNQZlpWcVdQa0hHNTV5Tjg5dTduY2liR20rWWZE?=
 =?utf-8?B?THRSVmNkWEY5aG9wYkdId3VobXdjV25JZi9ySTdYa1RFTWgrSkwrc041bytI?=
 =?utf-8?B?Z3B0Yk8xc3duVW0ySDhxaDhZeGNNRkowRExuZHFxUVVZcENiN1ZIUktLWlp6?=
 =?utf-8?B?N1VtNkZHdEpsVHFESDVpZVlSVWQ0NlJCVmt5aFk0Y0t0OVdKQ2JqZUhVR2lO?=
 =?utf-8?B?OXIvTmJNNjgwV1lzMEJGVTU2NnlEWE9McFpBRE1WbXdpVFYvUnlUSHBaUmZk?=
 =?utf-8?B?ZXBCWDlHSDdteEs5bVppalJYbWJXLzYvbEZXeTBEeUlvQnFvVEFkODhma0JS?=
 =?utf-8?B?UWVFVFF0enI4OTNmeTBtU2NUMXJEbTdNSG5Fa2RUbUN2ckFXdjlVbmI2T29Q?=
 =?utf-8?B?L1FqNnhkc2ZXRUZKUFRoV0lsV3lOcWlFSjAzV3lDSlU2OENzRWdPRHNPa2w3?=
 =?utf-8?B?alUzTmJlRzAyNzFYaFc2UDI0R1VyS3htSTJhRHczc1BzRVBsVzdXTVljd2Ja?=
 =?utf-8?B?SnJjN1QvRWxrUEFTeWpYQkVKU1NJaFJoNkczWnFMcVdGK3RpVTNzR29SaFV4?=
 =?utf-8?B?TUVLTDNEd3psWU9YOE1jYkx0N0xvZ3hFWi9kM0paaTF4a3M1dUhnQk9tRTdS?=
 =?utf-8?B?YTFzdkZGdWQveUpXS3JjVXg1Y3dPQ0RjVE5kNWI5TFhHODMzbHNYc290d1ZQ?=
 =?utf-8?B?Z09BbmhBYThaRjhsWUNoL1NqMFFmVTJMUUFIQmFZS1dvRmE4YUxCUVdLR2hu?=
 =?utf-8?B?QWtZbStOc3gxYUUzeDJsN1RDUGMvR1hKaFIzeVFpWTdoaU9FakJmOXNxd0FC?=
 =?utf-8?B?cWdVaHhxRDUzK09SV2srcFA2dml5MHNtWUN2eldlNGwrSnBydGs0QUljZThR?=
 =?utf-8?B?K1B2a1FTaEdNVVVYcVdPMkdUSE5zQkk3QUFnUldyKzFaZlVzVmJMcjFncDA0?=
 =?utf-8?B?ZlNMSHl0VmlaeElSVEpXZVQ4eVc3N3Y4eU1UbjBIbSs3NDUwQUViRFI4bUR0?=
 =?utf-8?B?bm1vTTdVSzFTdDlpN01WeDF0MHNYeW80YmNMa0Y3MlVGRHZkVVJKcTZ0dE9t?=
 =?utf-8?Q?FUWwWOGKdTcAsrYAXMvPrYFwWtkDT/+naYFVLB6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92b6b0a7-8e5f-41ac-b0a8-08d9054a8666
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 04:53:08.9235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K3VNihoYqZNUN4PPHT0hX2MM5vECm7QYfCJsOjuNjRHVvFu+sKC/NuPm7p2WM9xD+XhHvDrzlZ+eEyM+BbDzDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvbiBIdW50ZXIgPGpvbmF0
aGFuaEBudmlkaWEuY29tPg0KPiBTZW50OiAyMDIx5bm0NOaciDIw5pelIDIxOjM0DQo+IFRvOiBK
b2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgcGVwcGUuY2F2YWxsYXJvQHN0
LmNvbTsNCj4gYWxleGFuZHJlLnRvcmd1ZUBmb3NzLnN0LmNvbTsgam9hYnJldUBzeW5vcHN5cy5j
b207DQo+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgbWNvcXVlbGluLnN0
bTMyQGdtYWlsLmNvbTsNCj4gYW5kcmV3QGx1bm4uY2g7IGYuZmFpbmVsbGlAZ21haWwuY29tDQo+
IENjOiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgdHJlZGluZ0BudmlkaWEuY29t
Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUkZDIG5ldC1uZXh0
XSBuZXQ6IHN0bW1hYzogc2hvdWxkIG5vdCBtb2RpZnkgUlggZGVzY3JpcHRvciB3aGVuDQo+IFNU
TU1BQyByZXN1bWUNCj4gDQo+IA0KPiANCj4gT24gMjAvMDQvMjAyMSAwMjo0OSwgSm9ha2ltIFpo
YW5nIHdyb3RlOg0KPiANCj4gLi4uDQo+IA0KPiA+PiBJIGhhdmUgdGVzdGVkIHRoaXMgcGF0Y2gs
IGJ1dCB1bmZvcnR1bmF0ZWx5IHRoZSBib2FyZCBzdGlsbCBmYWlscyB0bw0KPiA+PiByZXN1bWUg
Y29ycmVjdGx5LiBTbyBpdCBhcHBlYXJzIHRvIHN1ZmZlciB3aXRoIHRoZSBzYW1lIGlzc3VlIHdl
IHNhdw0KPiA+PiBvbiB0aGUgcHJldmlvdXMgaW1wbGVtZW50YXRpb24uDQo+ID4NCj4gPiBDb3Vs
ZCBJIGRvdWJsZSBjaGVjayB3aXRoIHlvdT8gSGF2ZSB5b3UgcmV2ZXJ0ZWQgQ29tbWl0IDljNjNm
YWFhOTMxZQ0KPiAoIm5ldDogc3RtbWFjOiByZS1pbml0IHJ4IGJ1ZmZlcnMgd2hlbiBtYWMgcmVz
dW1lIGJhY2siKSBhbmQgdGhlbiBhcHBseSBhYm92ZQ0KPiBwYXRjaCB0byBkbyB0aGUgdGVzdD8N
Cj4gPg0KPiA+IElmIHllcywgeW91IHN0aWxsIHNhdyB0aGUgc2FtZSBpc3N1ZSB3aXRoIENvbW1p
dCA5YzYzZmFhYTkzMWU/IExldCdzIHJlY2FsbA0KPiB0aGUgcHJvYmxlbSwgc3lzdGVtIHN1c3Bl
bmRlZCwgYnV0IHN5c3RlbSBoYW5nIHdoZW4gU1RNTUFDIHJlc3VtZSBiYWNrLA0KPiByaWdodD8N
Cj4NCj4gDQo+IEkgdGVzdGVkIHlvdXIgcGF0Y2ggb24gdG9wIG9mIG5leHQtMjAyMTA0MTkgd2hp
Y2ggaGFzIFRoaWVycnkncyByZXZlcnQgb2YNCj4gOWM2M2ZhYWE5MzFlLiBTbyB5ZXMgdGhpcyBp
cyByZXZlcnRlZC4gVW5mb3J0dW5hdGVseSwgd2l0aCB0aGlzIGNoYW5nZQ0KPiByZXN1bWluZyBm
cm9tIHN1c3BlbmQgc3RpbGwgZG9lcyBub3Qgd29yay4NCg0KDQpIaSBKYWt1YiwgQW5kcmV3LA0K
DQpDb3VsZCB5b3UgcGxlYXNlIGhlbHAgcmV2aWV3IHRoaXMgcGF0Y2g/IEl0J3MgcmVhbGx5IGJl
eW9uZCBteSBjb21wcmVoZW5zaW9uLCB3aHkgdGhpcyBwYXRjaCB3b3VsZCBhZmZlY3QgVGVncmEx
ODYgSmV0c29uIFRYMiBib2FyZD8NClRoYW5rcyBhIGxvdCENCg0KQmVzdCBSZWdhcmRzLA0KSm9h
a2ltIFpoYW5nDQo+IEpvbg0KPiANCj4gLS0NCj4gbnZwdWJsaWMNCg==
