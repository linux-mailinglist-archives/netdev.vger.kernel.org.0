Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED534298D58
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 13:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773481AbgJZM6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 08:58:20 -0400
Received: from mail-bn8nam12on2050.outbound.protection.outlook.com ([40.107.237.50]:48097
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1773456AbgJZM6T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 08:58:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUOaTBiyKk4MxIG2xqObYmMURqthpGGyYtsjY2VxP4K8dyO7D41BS83EePMDwYc67+rA8cu64A6JjeS1OOa2Fc8lOj2UemT24ZESzX17eTkBM7fbqWhJggJRt8jAA4u/IEFmsFVytBgmvPO+9SOw1K0ko+KpRyVuMKT/mJ6Nf5ilwFGR+m2RRw9cfRZ/9bq0raeG3rJ3UWuq1qegwSKtdW/umfVKzbnDTa88tMRNEfB1X2uBw6a1F/ywNUrfLZmgxnZOWBBR+vKjlhWwDEPxx4BUSSRk4Sa+hogY7YJRtwhTAayfk3u6jTc7bOo/kxzhtiqjrY+5o1ObwGaQanjvlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+Axbw2QezwYHKa7/wc3NfwNdTH0wMgozLGcjnKbhRQ=;
 b=lyTxlY+QcJor4Oq85DNXIIPTPtsbj3fVuwXq2XGwBSF/QR64L9szLf7jtAIHFe1g1BZgHd6hLgzqDMC0wydLdaYf8qowqZZAGvOnYpQS+mf1tljk5oc8/EKFhtcVgHfbAvgALVTP+Aq9cxyOB/U7AJ+CMP7xXqXDrq47jElSrTs7kc/wCGVOTYO4ITsnWb+qAjY0AMx5sjnr6TB/PQTauV1WtK1L4zDK4a1UsgM6AK3PPeTF1ELygp6RWV2uTbB/hZBwOrrBEEgJahwjUzmJpV1zDTU2MySv6Y8CYI8Uws3nHUiFYkUj48r+f2UG6E3U+c7/zlTTgA9L6Oig9TZV8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+Axbw2QezwYHKa7/wc3NfwNdTH0wMgozLGcjnKbhRQ=;
 b=DyUI3+kmDDdP1QQIVSzGurQmbycSAOYU+YECxvWb04OfzWsdP4y9LowxsGlu579zBEO8LXgXCOjNCUHBaJwktJwiSGNf33DzAVpg1j7SMc+/vg9fUDhKXHchEOkUZw6LsZCXYbJAt2FkLR3/Gli4pNqCsvUsBiqarT+D/Uoy3zQ=
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 (2603:10b6:910:45::21) by CY4PR1001MB2165.namprd10.prod.outlook.com
 (2603:10b6:910:42::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Mon, 26 Oct
 2020 12:58:16 +0000
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::bd9d:bfc6:31c2:f5d8]) by CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::bd9d:bfc6:31c2:f5d8%6]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 12:58:16 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: arping stuck with ENOBUFS in 4.19.150
Thread-Topic: arping stuck with ENOBUFS in 4.19.150
Thread-Index: AQHWqIbAhm/w52lyHEuPPxU5ZaHMxKmp3kiA
Date:   Mon, 26 Oct 2020 12:58:16 +0000
Message-ID: <e09b367a58a0499f3bb0394596a9f87cc20eb5de.camel@infinera.com>
References: <9bede0ef7e66729034988f2d01681ca88a5c52d6.camel@infinera.com>
In-Reply-To: <9bede0ef7e66729034988f2d01681ca88a5c52d6.camel@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.1 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed723f51-716b-4d8b-85b9-08d879aece81
x-ms-traffictypediagnostic: CY4PR1001MB2165:
x-microsoft-antispam-prvs: <CY4PR1001MB216505D732135466619B5DB7F4190@CY4PR1001MB2165.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:949;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f7LsPR/Tra8E2qG+EKx8u3BSTqYkgp7Amu3l0LlGTt/KeWWMe4yfSZxQsY7BqPYVphCNO3b6Y8xn8YR3EWnPX3/NoNaTUtc2IGKbzPJcEBd6aCyQ4kklv6xHUTycc45ZEgfD3OALSaxujsoqaW0FoTZ6EGSqT02o4hbsjKHhs37HUuvqjvpgFcqLmoGEzQ87DZUNFdSwP6lYY3xXJN3NK/HaYKDOXDX5FEAcIWh7QRlMd49R0c4FTcYRcIboQBH7huyODhbxnH7x8k/olg1BUoWtwBftTTTDMc0Nb2CYPsmjey6h0VjLaE8bdqwUH3fpsaYVuUAA7QPgWdDxBSCliw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2389.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(39860400002)(136003)(346002)(6506007)(91956017)(4001150100001)(6916009)(66446008)(76116006)(66946007)(66556008)(64756008)(66476007)(86362001)(478600001)(5660300002)(8936002)(4744005)(6512007)(6486002)(36756003)(316002)(2616005)(26005)(186003)(71200400001)(8676002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: mLQM+eST02CZkSutIHZx5s7/OV3DK+icsbGiwTK+jy4y3wHlc18l8QNEM2VSkn/V3QpPPVv7XHP/JDPFPSoz0kybVbpAA4AYc0bkVFcnVh1XK40+l1alymtEXKdwsmeUYKwgG8yZX+jItAT2alIxKBsGABH6BQ9V/ExMiLArvsFYCOg9eEswYp3fvYpe5UIgao4aQvoXJaajzYFg2z98B7CEQbndB72I+kQl5z87pTle43p+D1qAC3KM8US5AsytQl/L3WK4cj+3D9TyCKXeu1W67VSAVUcnfXbsjcXlES9LHyLEM4uj7qcsOxv1SQAf5kZwZqt7U5x19VzJMgNoqdJ14UUstkfSDsJI8dH18NnAFU9IuaREEbSLsBNtZtomYGbyq5UZORDdXiXEj9D1X30xNu7LpS2SWc6rLndpTzJGYK7/0XvYM3l2LfhCPfxLMGksPvwvfupXu2iv88YQqJxeyTMPMSHmX7fL1yuQTPbEtO2kAEaVmQCuDlyqZpuryq903P4vQaR5k7Othf0s6XTV0keAcXjEY1QonXpmYaosYqgWuC+zHLlzgiWBKshzKLj7SPoqFLmUT3cXWb5noRif4pjcKEM1rQIv0Jcav4Xqfv24bZV2jZ1TZ/YqgTjTkrWDJ/DGFB7DbC7QBmr7Ig==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <62CE1460C4661743BF4B2908CB66B3AD@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2389.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed723f51-716b-4d8b-85b9-08d879aece81
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2020 12:58:16.7661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uxhh0wMCdnhpXaBuuYaJHA8ZjjoeLf7qwdvPKC3/niwwcITMYgqpe/uWn1LmkxgqN7mZ8QO7c++/a76hslzwRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2165
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UGluZyAgKG1heWJlIGl0IHNob3VsZCByZWFkICJhcnBpbmciIGluc3RlYWQgOikNCg0KIEpvY2tl
DQoNCk9uIFRodSwgMjAyMC0xMC0yMiBhdCAxNzoxOSArMDIwMCwgSm9ha2ltIFRqZXJubHVuZCB3
cm90ZToNCj4gc3RyYWNlIGFycGluZyAtcSAtYyAxIC1iIC1VICAtSSBldGgxIDAuMC4wLjANCj4g
Li4uDQo+IHNlbmR0bygzLCAiXDBcMVwxMFwwXDZcNFwwXDFcMFw2XDIzNFx2XDYgXHZcdlx2XHZc
Mzc3XDM3N1wzNzdcMzc3XDM3N1wzNzdcMFwwXDBcMCIsIDI4LCAwLCB7c2FfZmFtaWx5PUFGX1BB
Q0tFVCwgcHJvdG89MHg4MDYsIGlmNCwgcGt0dHlwZT1QQUNLRVRfSE9TVCwgYWRkcig2KT17MSwg
ZmZmZmZmZmZmZmZmfSwNCj4gMjApID0gLTEgRU5PQlVGUyAoTm8gYnVmZmVyIHNwYWNlIGF2YWls
YWJsZSkNCj4gLi4uLg0KPiBhbmQgdGhlbiBhcnBpbmcgbG9vcHMuDQo+IA0KPiBpbiA0LjE5LjEy
NyBpdCB3YXM6DQo+IHNlbmR0bygzLCAiXDBcMVwxMFwwXDZcNFwwXDFcMFw2XDIzNFw1XDI3MVwz
NjJcblwzMjJcMjEyRVwzNzdcMzc3XDM3N1wzNzdcMzc3XDM3N1wwXDBcMFwwIiwgMjgsIDAsIHvi
gItzYV9mYW1pbHk9QUZfUEFDS0VULCBwcm90bz0weDgwNiwgaWY0LCBwa3R0eXBlPVBBQ0tFVF9I
T1NULCBhZGRyKDYpPXvigIsxLA0KPiBmZmZmZmZmZmZmZmZ94oCLLCAyMCkgPSAyOA0KPiANCj4g
U2VlbXMgbGlrZSBzb21ldGhpbmcgaGFzIGNoYW5nZWQgdGhlIElQIGJlaGF2aW91ciBiZXR3ZWVu
IG5vdyBhbmQgdGhlbiA/DQo+IGV0aDEgaXMgVVAgYnV0IG5vdCBSVU5OSU5HIGFuZCBoYXMgYW4g
SVAgYWRkcmVzcy4NCj4gDQo+IMKgSm9ja2UNCg0K
