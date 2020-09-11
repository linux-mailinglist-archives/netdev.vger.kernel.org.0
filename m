Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1CB26664F
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgIKRZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:25:33 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11756 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgIKRZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:25:08 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5bb2c70000>; Fri, 11 Sep 2020 10:24:23 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 11 Sep 2020 10:25:08 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 11 Sep 2020 10:25:08 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 11 Sep
 2020 17:25:07 +0000
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.53) by
 HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 11 Sep 2020 17:25:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+RRi4bXZdHVhiIpkLHhwdn5x6MZD2odHImR+sYb2Y5FblH2dIq5u9aCSJAaKJpAjcEVaP7olyNMu+TuARzPNCdESVou3ZV/tAmE9Xx0Jq/0J446YXYinZQYdvD6vGwd7DOXlLfKwWGoerX+HhZeoQEQ9HSCaY0yeXBrbqpLpD1gPNHE434pyPafYiiGppbb7XnlkciLPEoXOuWUNFo3Pugd4VmFOhnufvJuK4epyjmXVkWeAKvydyLwKtJx00wre9oxotHblQle45Eic0GTsqYdBfYezl7TC0KNMfOmBy+PaqVeIvBO+wKTnQIcKUXysQsLJsypTxKwul2yHaaAVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oEKYi0wcxWiVcWdQHQ4TXbxhc3Szp1YLa+a1ikCEl0c=;
 b=Qu9Xugkn7TVQT38PjKX8E4LhEM05eQHgxWshL7XzBPKHtvYZMmnhRt6N9WNKz8d5u2xNeAfShT5AVNpGsyjBjkAftlVvRnnQ/2MENZpMM7ch4lP9TZrA1OzxTjFetnA15iDdogJK3OBfpGPeubcBzK0gTcpfN9DvTJuuJNvLdB/E6rk9maqBZoMNXRBJSxTjTdvVa95kS0CvWs7IMyc/ldyoJvVVNbZTmpAA5HE0tteWB3+zWIOxskrbOW2piIOI+XfionAYczaNEgXrPm8VBS67W4I92qFhqI97uPjc2PDdZrokKI51796YYrnTQhmK218wjJPfDi8g0hmV76rSBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB3700.namprd12.prod.outlook.com (2603:10b6:a03:1a5::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 17:25:06 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::90a0:8549:2aeb:566]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::90a0:8549:2aeb:566%6]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 17:25:06 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tariqt@mellanox.com" <tariqt@mellanox.com>,
        "maximmi@mellanox.com" <maximmi@mellanox.com>
Subject: Re: [net-next V2 03/12] net/mlx5e: Move mlx5e_tx_wqe_inline_mode to
 en_tx.c
Thread-Topic: [net-next V2 03/12] net/mlx5e: Move mlx5e_tx_wqe_inline_mode to
 en_tx.c
Thread-Index: AQHWhkiHT53wZY7V80yfY7kzzX2/h6lfpgkAgAAALICAAQo2gIAAJQyAgALe8AA=
Date:   Fri, 11 Sep 2020 17:25:06 +0000
Message-ID: <c8af3b1ef5915253ad1c2b720b0e54f942d4d1c9.camel@nvidia.com>
References: <20200908.202836.574556740303703917.davem@davemloft.net>
         <20200908.202913.497073980249985510.davem@davemloft.net>
         <f99402b166904107f1ea8051fd0a9ab4b6143e79.camel@nvidia.com>
         <20200909.143437.2197212350854154737.davem@davemloft.net>
In-Reply-To: <20200909.143437.2197212350854154737.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.6.56.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4cd9ec3-9c7e-4870-e5fe-08d85677a092
x-ms-traffictypediagnostic: BY5PR12MB3700:
x-microsoft-antispam-prvs: <BY5PR12MB37008870063B0708444FD081B3240@BY5PR12MB3700.namprd12.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6kLu2VQekNUMMoGPCQxuPcax37M+Asngf/2DUCOEsZzWL4rFGeA+K0a6yn+usjOAv/J/26Kz0MQ4Rsmbgmh+72IpGE0yrHx6CmKGrUvnjOhNqCO1d7izUcHl6ss9ahS/ddT+6ePI4znqmqYPrn4sh/RLmgSQhQZNdi8Nu8Ovn7K9mxCOXADFrijGtU/BeoULq75wTiEHMcxjy2Gg6dVmjFavE956Rq8vbL5Vi74mVKJomLTTk/E/vBMRsmHNLzZKNFrKGTWi3RU9dEZJbMC07NiVis5qO3ENh85OeYEScL/KKj8uJ6kWzgLU6rWwC4zr9kxPUDewPkd0pW/CkhmolQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(86362001)(4326008)(6916009)(8936002)(66946007)(478600001)(66476007)(26005)(2616005)(76116006)(71200400001)(186003)(6512007)(83380400001)(2906002)(66446008)(64756008)(66556008)(8676002)(107886003)(54906003)(5660300002)(316002)(36756003)(6506007)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: IDZHvbgQB6PMWSGJAD4M0ydXn2ymLaIUomjbdEfUOGo+XyrMK6qIN5gmT6n/yNOy3/o4xuyBV4qh8ylmXXIkUZVqJ6f0YKQYxEzCouQvlVKve1zB04zThCMYNjU2MtFhhiORfyn/VMITYx1zB8wQWI910LQRVQXe4KpiWzPGK08h+PGXZyPNndQxMcTcuJWNvoTHO0lCfKvLtkDi3B6e+tOVsu7NHzSgwTuvenhnDJFrmZaTcCOOEQxB2QiD7YUXzOInfna+s61qNPAHSaGfSMbkz3Y0f82vOsNCHt/LH26TrYrDZda88ElpgXaD0ZU2/0n8p+hmZ1zQkmsGBLA+0MNvVTKDLeWqz3mdYh/0+Rua5w+sIPskZu/P6X4w6u/a7JAgNlr62+VygwueO6pKGqnyornAJuadz+ClHQC/JcMPjwqnxIQtdSb/o8e/AKGFYTAGWX2hfyW8fwtvYAamzgQeSw53sKvVkv9Jr3noxDYE8xe67k9afZCq+nMw+Nh7LfSmsAXRb+mEJir/pwwOFpEYt3Jk3MU6ALK9khcF0HJlihiUa8WapxPtQ0RCCo7LQE1xDR1hWQ/a+t8aMQwRRLWgXEgwCksfwtYGk0Xt6Yk1YUjvnmtmfqRHpGP5p4AQlPWdCy2O5kH9Jo9pU0IlCQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <6A810F8D7CBF104D8F719F0EC73C173F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4cd9ec3-9c7e-4870-e5fe-08d85677a092
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2020 17:25:06.6968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5VMuK581ebErologCwuBZqXAvkz/XD1DOpzwEYLyKzMugOJcXTOPCtzPNlDyfCIr4F3C7OINKAqasCyymfegvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3700
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599845063; bh=oEKYi0wcxWiVcWdQHQ4TXbxhc3Szp1YLa+a1ikCEl0c=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
         x-ms-exchange-transport-forked:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:Content-ID:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=QAvEx5LfMsvcUq1b+E0Wsm/TkEBoUv5KbWOVOkGUSGhX/krcqaHXoe4iZmGbEirmf
         md6yZbMYyDDG0P3oVoda7KpFMiO0vQj2ZEJvZlkFDUPou8oxajaMv6qnzWCwQX+dxE
         Divb5AozTSR2wiObvjEKJUdT/X9zXqk3PMuo71fydSaoyg4sOs6OrRSxH5HTE0iFKH
         ICwcH02Qd9bApKs4tyFDcz6iB0DbkqC/4g8L13vYvyNh+OsPNaonIjHSQ6sEBYaaka
         TEMsHrX/CXkRKJv5SypZ40gB4aXamLc6iWDV3ihcEfG3zFhyBcd+v0+gOOv1BXvdvC
         QlTIOsFuCJxmQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA5LTA5IGF0IDE0OjM0IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbnZpZGlhLmNvbT4NCj4gRGF0ZTogV2VkLCA5
IFNlcCAyMDIwIDE5OjIyOjAyICswMDAwDQo+IA0KPiA+IE1heGltIHJlYWxseSB0cmllZCBoZXJl
IHRvIGF2b2lkIHRoaXMgd2l0aG91dCBodWdlIHBlcmZvcm1hbmNlDQo+ID4gZGVncmFkYXRpb24g
KH42LjQlIHJlZHVjZSBpbiBwYWNrZXQgcmF0ZSksIGR1ZSB0byB0aGUgcmVmYWN0b3JpbmcNCj4g
PiBwYXRjaGVzIGdjYyB5aWVsZHMgbm9uIG9wdGltYWwgY29kZSwgYXMgd2UgZXhwbGFpbmVkIGlu
IHRoZSBjb21taXQNCj4gPiBtZXNzYWdlcyBhbmQgY292ZXItbGV0dGVyDQo+ID4gDQo+ID4gT3Vy
IG90aGVyIG9wdGlvbiBpcyBtYWtpbmcgdGhlIGNvZGUgdmVyeSB1Z2x5IHdpdGggbm8gY29kZSBy
ZXVzZSBpbg0KPiA+IHRoZQ0KPiA+IHR4IHBhdGgsIHNvIHdlIHdvdWxkIHJlYWxseSBhcHByZWNp
YXRlIGlmIHlvdSBjb3VsZCByZWxheCB0aGUgbm8tDQo+ID4gaW5saW5lIA0KPiA+IGd1aWRlbGlu
ZSBmb3IgdGhpcyBzZXJpZXMuDQo+IA0KPiBTdWJtaXQgYSBjb21waWxlciBidWcgcmVwb3J0Lg0K
PiANCj4gSSdtIHN0YW5kaW5nIGZpcm0gb24gb3VyIHBvbGljeS4gIElmIHlvdSBkb24ndCBmb2xs
b3cgaXQsIHRoZXJlIGlzDQo+IHplcm8NCj4gaW5jZW50aXZlIHRvIGdldCB0aGUgY29tcGlsZXIg
Zml4ZWQsIHdoaWNoIGN1cmVzIHRoZSBwcm9ibGVtIGluIG9uZQ0KPiBwbGFjZSBhbmQgZm9yIGV2
ZXJ5b25lIHJhdGhlciB0aGFuIGp1c3QgeW91ciBzcGVjaWFsIGNhc2UuDQo+IA0KQWNrLCANCg0K
TWF4aW0gd2lsbCBiZSB0ZXN0aW5nIHNldmVyYWwgdmVyc2lvbnMgb2YgR0NDIHRvIGNvbXBhcmUg
YW5kIHVuZGVyc3RhbmQNCnRoZSBiZWhhdmlvciBiZXR0ZXIgYW5kIHdpbGwgcmVzdWJtaXQgYSB2
ZXJzaW9uIHdpdGggbm8gbWFudWFsIGlubGluZQ0KaGludHMgbGF0ZXIsIGZvciBub3cgaSB3b3Vs
ZCBsaWtlIHRvIHB1dCB0aGlzIG9uLWhvbGQgYW5kIHNlbmQgdGhlIG5leHQNCnB1bGwgcmVxdWVz
dC4NCg0KVGhhbmtzLA0KU2FlZWQuDQo=
