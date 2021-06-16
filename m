Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8064E3A9E5C
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 16:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbhFPPAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 11:00:46 -0400
Received: from mail-eopbgr60047.outbound.protection.outlook.com ([40.107.6.47]:37860
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234079AbhFPPAp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 11:00:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/uA6jH15tGFUNMKjY57UO6OLGJl8NFbda/kbmkk/9rsXKC+RLEIApv54A6hx+9jfB4oHnEST9ipVUnq+py/xXkRDX5XPOVBglGmp7kJxqlirJZ5nbnxrpgkG2OlnYKLsmG9+SGRjVTCrU8g2LFe/qPtQv86GbUdWVernc8QGgYNKgls5KDbubIVEy0/uHDNCXfLjEwJjwWNdxdaJsy63hsZyp93QTSyITHlyhFphjgcDrVOmeNHp2fMFAnYUUs7IFT7wA5mxhQfXxO+jy9Y4aehxR7jco8J819SRKhYcAfp+85lbsiFBoy+38qJYhR2fswUaOk+YL9iK+f8mBQRJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wj0NGAO3xRvo0vVYFSdJt/smETFBf56KpMJcokcpYDA=;
 b=XqbjfVnGvYrElnyurtOPyTzuElPL10uMiB6W6nn5f9xLf0Bb3Gz3B62sVjWbP3P7Ed/InFkALpBBeg7QvQ95aw7jUbHxCLltvinwQKipBRCqlhAbgfpfOCpDY23EMZVv28aI8+0eEA6x7yYo61iIxCFLFXe8/gkGzapnTXP6CKjwOntXlxUrd0U6VmZAtcqfJK+/q4IJaaWbPl/svgS/TGb9AhY+iec4NzvBxufNHp5MRyaccXjznDPb51vTDLECvUwrd2BYSHTvg0BsYaa46L67AupPvFCAQtvOkOTsHuhLvU9EwxT9U46nwxQrv40bqVjMImbJ917ROYM5kbyCVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wj0NGAO3xRvo0vVYFSdJt/smETFBf56KpMJcokcpYDA=;
 b=PmTEp+WpjoGUwaqwXqRR4yfiI+uI0YSl06Muy7tEa7gRk1eimVmFL2YpLlj5GIJALUUjKOgiG+HPELkdEk58/G8SH8yVksq70G8CfWO0hMf6L1IffhIXs6xkSvl1ZK1vnPE2IM1vQyov42oqni/x12fPlfLCXQKulrOl5av7Adg=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB4494.eurprd04.prod.outlook.com (2603:10a6:803:74::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Wed, 16 Jun
 2021 14:58:36 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::310a:ea1f:ec9a:80b]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::310a:ea1f:ec9a:80b%7]) with mapi id 15.20.4219.025; Wed, 16 Jun 2021
 14:58:36 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: RE: [PATCH bpf-next v2 07/16] freescale: remove rcu_read_lock()
 around XDP program invocation
Thread-Topic: [PATCH bpf-next v2 07/16] freescale: remove rcu_read_lock()
 around XDP program invocation
Thread-Index: AQHXYfZ8Cu6AZBfsI0afiWeSFVClV6sWul7A
Date:   Wed, 16 Jun 2021 14:58:36 +0000
Message-ID: <VI1PR04MB58071321C50704530260BF30F20F9@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20210615145455.564037-1-toke@redhat.com>
 <20210615145455.564037-8-toke@redhat.com>
In-Reply-To: <20210615145455.564037-8-toke@redhat.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.137.32.89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d37fc6a0-351b-492a-d588-08d930d737dc
x-ms-traffictypediagnostic: VI1PR04MB4494:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4494BFD7544649DA00BA9DB6F20F9@VI1PR04MB4494.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iI3wSFo0mALj291ihOoyqzkE6dYf+IK06zQ+3dAirmywxco5/uk8bIiriQtFqHU91mGzi1tUh3BToQGWQmXEA+6MX7NiAl6LqVCHqhccrPCtAmfRKV8luZXYj4aWgp2vBoOvw8sF/kYFkXsC2y7byx3jBnP2F4/IsI4ua6u7pGhsriGccOIaQ5v3hTOq7i7qFX7qKwNlZlXleECc8NDoLc1Y57HGabi+G0RX3HCp5JL35GwSpcUW2pwKKWf3yCaVLzBzXYeH0sdndIGlGumAVH1XbrPhjeDiYAKdaL+SpKnyd3U0d0G+aiqb7TvHpo8obUQ0SMDkhb9Ektb9Qv42+jyBMtKJb+B9Wbd0M+1CJBPd95pjnpyEtJRnWxKn8yqX7R7l/S7r5u3yiCAU0fb6kRojBpCANJ+W3YgrN1tCdNhvDAegMs1ieppGjvNOQYuhOY+h8x0e8FTtLpvPE9xIKgxl7mc6gdEr937zFFoY9QKmpX6LWCD1chc1OPbhv82jy0lobJON1K9PiNU3JD8C+oT72SVyHcWRiFJxmTKF3p/kbih6urU1L3GSmat7Yncec2Jjc7f97TxL7hjFZQx/ZHVnJtcIyvbgEFTdLYdyPYw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39850400004)(396003)(376002)(346002)(83380400001)(122000001)(8936002)(54906003)(110136005)(33656002)(66574015)(2906002)(5660300002)(52536014)(8676002)(7696005)(26005)(316002)(76116006)(53546011)(64756008)(6506007)(9686003)(478600001)(71200400001)(186003)(55016002)(86362001)(66446008)(66556008)(66946007)(38100700002)(4326008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bFFMK3VnN3NhQU1DRFJmbHIrZHA1dFRjQXFzRjMvV2p5d1NjOEJQc01QV3Bv?=
 =?utf-8?B?eFZDc0hTUWlURTg1aWYwOFdpMnFvWlNFUlVnVkRSMlBoY1hQRU4wN3ZWQmUv?=
 =?utf-8?B?ZURqY1NVdTV3K1dQQk1abGRaSDQ4YlRqZi93QTlzS281UTFCeWUzMDBuZWk1?=
 =?utf-8?B?UGNTTU1rK0xUc3VKYTVXT05ZcnNlYlhsMlhsRm9MMWMxSXBocjNveUt0VWRF?=
 =?utf-8?B?ZDd1K2tXWmhjeDRrYnVPRExhK2QzWVBCaUV6d2pDMnY1Y1MxR0Rzd2lVR1Ba?=
 =?utf-8?B?NHhzTDZ6akkzdktSV0YxL3Y2QmRsUnI0a2RoRW9IcTRjOGI2dFk5eHNIOTA5?=
 =?utf-8?B?L1BieTFTalNiT3oxYzBKTGYwbkZNSU82S25LcUVSSVBUNjdGM2IvVE5YcHh0?=
 =?utf-8?B?NXYxNnBKd0hUNHc5aXRrMmh1cmVpWmVzajBXZUxnbkl3b1NqU3ZyUEZQTFY2?=
 =?utf-8?B?WFdYcUNJQjFLTjdMU2pyMXFtdndMMlFodUZFZ1B0MHJkREh6aFNmL3NlQllk?=
 =?utf-8?B?Y3B0SGZUL1FjdExBOXh5ejZubVRaNS9rSW0wWDczYnpuS3grS0o1UU9LVGZv?=
 =?utf-8?B?U1FIK081amFQeTh6U0p1cDJ1MTBoVm5ad1psTyswb204RGV5bUlmWmJmNktY?=
 =?utf-8?B?eXdRWWlTaCtWZ0p4Q3IzWURGNWV1TzhLckZCYXFRbE9WMkt4NE5MRTNpd3RB?=
 =?utf-8?B?VWVwbWhHTXU1OWZXUWRuT0JIbHNnb1A4aHlCa01uS0VxZmQ2bXdHOTd6c2Fk?=
 =?utf-8?B?Y2dpN2JDS3ZwejdUend2Q3hwbGVIMjcxejJNNy9oQTZaakJWUkJzeEhFWFRr?=
 =?utf-8?B?RFpBRTUvYk1Yc1lFY3FqT2Izb1oraHI4U3FHSnRJc05Id1cycGw0WWxBc1dM?=
 =?utf-8?B?dm4yUldSVnEyWVNUMU9TTDlEWS9SM2JKOHVPQzRTbGErQXJnd3QvRGZYTzRC?=
 =?utf-8?B?WEJNaXV4VllhVUtoSklCenBjS3VOZmNQdmc0em9FYTIzRFVXR2JUcEs4VzRw?=
 =?utf-8?B?UGt5Vkp2OFo4cEpjNDE0SmJYZU5ZMS85L2NzZnFjNEVwelYzSFNuMkcxOE5S?=
 =?utf-8?B?aHNUZkM4QkpSRk13R1pFSGJuQnRJNnVsMDVLZEQwZGZUZWQ0MjNrcldCWklu?=
 =?utf-8?B?UnhhVXhZeDlweTZ3Y0NWNndDWmpjbUVwTEQvWHpQcjJBSmxNRGljU0Fxdy9N?=
 =?utf-8?B?SEsxbXl5Rkx2TW9lSmFKMzJEbW15YUVnUDV2cDh5USsrc2xlOWZiL3Y1d21O?=
 =?utf-8?B?SXU2V0prc01Fa0FWV3h2T0swSnpiWmZZR1R6Qk03TUFuQ0hGNGV1b0FvVjYy?=
 =?utf-8?B?bWFTM3JlODdzYkFHeVU1OW92TEw5QXJaTkY5cUp2cHhaQUpzbnBvNlMwcXVv?=
 =?utf-8?B?YjgzMWZEVWZUSjhnbjBFVTNqVFpOTnpJb3pweWFZVjZHSHpUVEQ3VzVQMHBE?=
 =?utf-8?B?S3dTeUh6UDJLNnVYclJXUTJGRERjL21QQi81Q05PWDVQQit6L2x5ZlZXckJC?=
 =?utf-8?B?Q2lQY21YeU1ldEZQYzlVQ3hjbXdBbVRnRUlEK05Vam9hcHZDMzZQbE5kZmFh?=
 =?utf-8?B?ZmJTc1o1a0lrT1hZMjZ5MnhYaUpRWmQ3eXFYL3l6NEpPT1ZYWUxvbFE0NnVO?=
 =?utf-8?B?L2UrY0FrU2NrTjlCMFdxWUlLZzhPWldPd2swc0xKK1kvZWdCeG5GaW5tbFJD?=
 =?utf-8?B?QzF1YUowMk52NkFUOGNuSmsrbUtBcms1R3ZQUGpmZHAraVRsMGJxblNNYnlN?=
 =?utf-8?Q?36VEUYJ2+ZrVS4fqY0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d37fc6a0-351b-492a-d588-08d930d737dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2021 14:58:36.1268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A6x4rr7j1VqennlTiFgBCkeSD5odh8TnfIIuwi4AjI5D2qFZahgAJH9xvo5t6jDaU3Qr7UXrX8Vt2Skyy8FdaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4494
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBUb2tlIEjDuGlsYW5kLUrDuHJn
ZW5zZW4gPHRva2VAcmVkaGF0LmNvbT4NCj4gU2VudDogVHVlc2RheSwgSnVuZSAxNSwgMjAyMSAx
Nzo1NQ0KPiBUbzogYnBmQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0K
PiBDYzogTWFydGluIEthRmFpIExhdSA8a2FmYWlAZmIuY29tPjsgSGFuZ2JpbiBMaXUgPGxpdWhh
bmdiaW5AZ21haWwuY29tPjsNCj4gSmVzcGVyIERhbmdhYXJkIEJyb3VlciA8YnJvdWVyQHJlZGhh
dC5jb20+OyBNYWdudXMgS2FybHNzb24NCj4gPG1hZ251cy5rYXJsc3NvbkBnbWFpbC5jb20+OyBQ
YXVsIEUgLiBNY0tlbm5leSA8cGF1bG1ja0BrZXJuZWwub3JnPjsNCj4gSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz47IFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbg0KPiA8dG9rZUByZWRo
YXQuY29tPjsgTWFkYWxpbiBCdWN1ciA8bWFkYWxpbi5idWN1ckBueHAuY29tPjsgSW9hbmENCj4g
Q2lvcm5laSA8aW9hbmEuY2lvcm5laUBueHAuY29tPjsgSW9hbmEgQ2lvY29pIFJhZHVsZXNjdQ0K
PiA8cnV4YW5kcmEucmFkdWxlc2N1QG54cC5jb20+DQo+IFN1YmplY3Q6IFtQQVRDSCBicGYtbmV4
dCB2MiAwNy8xNl0gZnJlZXNjYWxlOiByZW1vdmUgcmN1X3JlYWRfbG9jaygpDQo+IGFyb3VuZCBY
RFAgcHJvZ3JhbSBpbnZvY2F0aW9uDQo+IA0KPiBUaGUgZHBhYSBhbmQgZHBhYTIgZHJpdmVycyBo
YXZlIHJjdV9yZWFkX2xvY2soKS9yY3VfcmVhZF91bmxvY2soKSBwYWlycw0KPiBhcm91bmQgWERQ
IHByb2dyYW0gaW52b2NhdGlvbnMuIEhvd2V2ZXIsIHRoZSBhY3R1YWwgbGlmZXRpbWUgb2YgdGhl
IG9iamVjdHMNCj4gcmVmZXJyZWQgYnkgdGhlIFhEUCBwcm9ncmFtIGludm9jYXRpb24gaXMgbG9u
Z2VyLCBhbGwgdGhlIHdheSB0aHJvdWdoIHRvDQo+IHRoZSBjYWxsIHRvIHhkcF9kb19mbHVzaCgp
LCBtYWtpbmcgdGhlIHNjb3BlIG9mIHRoZSByY3VfcmVhZF9sb2NrKCkgdG9vDQo+IHNtYWxsLiBU
aGlzIHR1cm5zIG91dCB0byBiZSBoYXJtbGVzcyBiZWNhdXNlIGl0IGFsbCBoYXBwZW5zIGluIGEg
c2luZ2xlDQo+IE5BUEkgcG9sbCBjeWNsZSAoYW5kIHRodXMgdW5kZXIgbG9jYWxfYmhfZGlzYWJs
ZSgpKSwgYnV0IGl0IG1ha2VzIHRoZQ0KPiByY3VfcmVhZF9sb2NrKCkgbWlzbGVhZGluZy4NCj4g
DQo+IFJhdGhlciB0aGFuIGV4dGVuZCB0aGUgc2NvcGUgb2YgdGhlIHJjdV9yZWFkX2xvY2soKSwg
anVzdCBnZXQgcmlkIG9mIGl0DQo+IGVudGlyZWx5LiBXaXRoIHRoZSBhZGRpdGlvbiBvZiBSQ1Ug
YW5ub3RhdGlvbnMgdG8gdGhlIFhEUF9SRURJUkVDVCBtYXANCj4gdHlwZXMgdGhhdCB0YWtlIGJo
IGV4ZWN1dGlvbiBpbnRvIGFjY291bnQsIGxvY2tkZXAgZXZlbiB1bmRlcnN0YW5kcyB0aGlzIHRv
DQo+IGJlIHNhZmUsIHNvIHRoZXJlJ3MgcmVhbGx5IG5vIHJlYXNvbiB0byBrZWVwIGl0IGFyb3Vu
ZC4NCj4gDQo+IENjOiBNYWRhbGluIEJ1Y3VyIDxtYWRhbGluLmJ1Y3VyQG54cC5jb20+DQo+IENj
OiBJb2FuYSBDaW9ybmVpIDxpb2FuYS5jaW9ybmVpQG54cC5jb20+DQo+IENjOiBJb2FuYSBSYWR1
bGVzY3UgPHJ1eGFuZHJhLnJhZHVsZXNjdUBueHAuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBUb2tl
IEjDuGlsYW5kLUrDuHJnZW5zZW4gPHRva2VAcmVkaGF0LmNvbT4NCj4gLS0tDQoNClJldmlld2Vk
LWJ5OiBDYW1lbGlhIEdyb3phIDxjYW1lbGlhLmdyb3phQG54cC5jb20+DQoNClRoYW5rcyENCg0K
PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEvZHBhYV9ldGguYyAgIHwgMTEg
KysrKy0tLS0tLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFhMi9kcGFh
Mi1ldGguYyB8ICA2ICsrKy0tLQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyks
IDEwIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ZyZWVzY2FsZS9kcGFhL2RwYWFfZXRoLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVl
c2NhbGUvZHBhYS9kcGFhX2V0aC5jDQo+IGluZGV4IDE3N2MwMjBiZjM0YS4uOThmZGNiZGU2ODdh
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYS9kcGFh
X2V0aC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFhL2RwYWFf
ZXRoLmMNCj4gQEAgLTI1NTgsMTMgKzI1NTgsOSBAQCBzdGF0aWMgdTMyIGRwYWFfcnVuX3hkcChz
dHJ1Y3QgZHBhYV9wcml2ICpwcml2LA0KPiBzdHJ1Y3QgcW1fZmQgKmZkLCB2b2lkICp2YWRkciwN
Cj4gIAl1MzIgeGRwX2FjdDsNCj4gIAlpbnQgZXJyOw0KPiANCj4gLQlyY3VfcmVhZF9sb2NrKCk7
DQo+IC0NCj4gIAl4ZHBfcHJvZyA9IFJFQURfT05DRShwcml2LT54ZHBfcHJvZyk7DQo+IC0JaWYg
KCF4ZHBfcHJvZykgew0KPiAtCQlyY3VfcmVhZF91bmxvY2soKTsNCj4gKwlpZiAoIXhkcF9wcm9n
KQ0KPiAgCQlyZXR1cm4gWERQX1BBU1M7DQo+IC0JfQ0KPiANCj4gIAl4ZHBfaW5pdF9idWZmKCZ4
ZHAsIERQQUFfQlBfUkFXX1NJWkUgLQ0KPiBEUEFBX1RYX1BSSVZfREFUQV9TSVpFLA0KPiAgCQkg
ICAgICAmZHBhYV9mcS0+eGRwX3J4cSk7DQo+IEBAIC0yNTg1LDYgKzI1ODEsOSBAQCBzdGF0aWMg
dTMyIGRwYWFfcnVuX3hkcChzdHJ1Y3QgZHBhYV9wcml2ICpwcml2LA0KPiBzdHJ1Y3QgcW1fZmQg
KmZkLCB2b2lkICp2YWRkciwNCj4gIAl9DQo+ICAjZW5kaWYNCj4gDQo+ICsJLyogVGhpcyBjb2Rl
IGlzIGludm9rZWQgd2l0aGluIGEgc2luZ2xlIE5BUEkgcG9sbCBjeWNsZSBhbmQgdGh1cyB1bmRl
cg0KPiArCSAqIGxvY2FsX2JoX2Rpc2FibGUoKSwgd2hpY2ggcHJvdmlkZXMgdGhlIG5lZWRlZCBS
Q1UgcHJvdGVjdGlvbi4NCj4gKwkgKi8NCj4gIAl4ZHBfYWN0ID0gYnBmX3Byb2dfcnVuX3hkcCh4
ZHBfcHJvZywgJnhkcCk7DQo+IA0KPiAgCS8qIFVwZGF0ZSB0aGUgbGVuZ3RoIGFuZCB0aGUgb2Zm
c2V0IG9mIHRoZSBGRCAqLw0KPiBAQCAtMjYzOCw4ICsyNjM3LDYgQEAgc3RhdGljIHUzMiBkcGFh
X3J1bl94ZHAoc3RydWN0IGRwYWFfcHJpdiAqcHJpdiwNCj4gc3RydWN0IHFtX2ZkICpmZCwgdm9p
ZCAqdmFkZHIsDQo+ICAJCWJyZWFrOw0KPiAgCX0NCj4gDQo+IC0JcmN1X3JlYWRfdW5sb2NrKCk7
DQo+IC0NCj4gIAlyZXR1cm4geGRwX2FjdDsNCj4gIH0NCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYTIvZHBhYTItZXRoLmMNCj4gYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYTIvZHBhYTItZXRoLmMNCj4gaW5kZXggODQzM2Fh
NzMwYzQyLi45NjRkODVjOWUzN2QgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ZyZWVzY2FsZS9kcGFhMi9kcGFhMi1ldGguYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9mcmVlc2NhbGUvZHBhYTIvZHBhYTItZXRoLmMNCj4gQEAgLTM1Miw4ICszNTIsNiBAQCBzdGF0
aWMgdTMyIGRwYWEyX2V0aF9ydW5feGRwKHN0cnVjdCBkcGFhMl9ldGhfcHJpdg0KPiAqcHJpdiwN
Cj4gIAl1MzIgeGRwX2FjdCA9IFhEUF9QQVNTOw0KPiAgCWludCBlcnIsIG9mZnNldDsNCj4gDQo+
IC0JcmN1X3JlYWRfbG9jaygpOw0KPiAtDQo+ICAJeGRwX3Byb2cgPSBSRUFEX09OQ0UoY2gtPnhk
cC5wcm9nKTsNCj4gIAlpZiAoIXhkcF9wcm9nKQ0KPiAgCQlnb3RvIG91dDsNCj4gQEAgLTM2Myw2
ICszNjEsOSBAQCBzdGF0aWMgdTMyIGRwYWEyX2V0aF9ydW5feGRwKHN0cnVjdCBkcGFhMl9ldGhf
cHJpdg0KPiAqcHJpdiwNCj4gIAl4ZHBfcHJlcGFyZV9idWZmKCZ4ZHAsIHZhZGRyICsgb2Zmc2V0
LCBYRFBfUEFDS0VUX0hFQURST09NLA0KPiAgCQkJIGRwYWEyX2ZkX2dldF9sZW4oZmQpLCBmYWxz
ZSk7DQo+IA0KPiArCS8qIFRoaXMgY29kZSBpcyBpbnZva2VkIHdpdGhpbiBhIHNpbmdsZSBOQVBJ
IHBvbGwgY3ljbGUgYW5kIHRodXMgdW5kZXINCj4gKwkgKiBsb2NhbF9iaF9kaXNhYmxlKCksIHdo
aWNoIHByb3ZpZGVzIHRoZSBuZWVkZWQgUkNVIHByb3RlY3Rpb24uDQo+ICsJICovDQo+ICAJeGRw
X2FjdCA9IGJwZl9wcm9nX3J1bl94ZHAoeGRwX3Byb2csICZ4ZHApOw0KPiANCj4gIAkvKiB4ZHAu
ZGF0YSBwb2ludGVyIG1heSBoYXZlIGNoYW5nZWQgKi8NCj4gQEAgLTQxNCw3ICs0MTUsNiBAQCBz
dGF0aWMgdTMyIGRwYWEyX2V0aF9ydW5feGRwKHN0cnVjdCBkcGFhMl9ldGhfcHJpdg0KPiAqcHJp
diwNCj4gDQo+ICAJY2gtPnhkcC5yZXMgfD0geGRwX2FjdDsNCj4gIG91dDoNCj4gLQlyY3VfcmVh
ZF91bmxvY2soKTsNCj4gIAlyZXR1cm4geGRwX2FjdDsNCj4gIH0NCj4gDQo+IC0tDQo+IDIuMzEu
MQ0KDQo=
