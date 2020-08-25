Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0402513E2
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 10:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgHYIMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 04:12:52 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:10822 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHYIMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 04:12:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1598343169; x=1629879169;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2gSk4MA+LyuzuuDUpypaDmm+wsJBhI2/hxQhDHjIhUE=;
  b=zUT2BP+dduknzh+PLajL+TDDRk+wtza68dO8IKaqSTsCLZ5/Jtddais9
   0jNxPn4lUE1Ktfre21l7OnzUMlpErFSfcnHUEz+etdLwJzk8kpxs1WkZy
   EFuJMvLZDsSy6jAA4nJzVVOns4QcXZdbI9Kk5oRo4dD9tuc1PG9nUzWrh
   ekG8bG0or6Ecugb1CXURWYGDC44ezK8QzTot76UXxoQV8BeiF5GVysoaT
   mnP95kOP/t22Xi9g+14egg1fIPdMa5DZ5VWTUiOxt18ikEe4YiaLfR9ip
   13AD/jrDMprOy+gZrC/rrBnnrqY7VJ3C3S0b/p/INMbH8bSp/mfHHBfrq
   g==;
IronPort-SDR: fnZRLkfw+R4AF7h+/9Q9pVAq5DEYcdHS2ktSWvWAa2LAUkMnksYCBb4/28l6Pr/CerMf8/wYD1
 6FbrmWmJR6hzLVkYW27WLMhnwX9kIGcw621o+3f8elwAXockVMo3QrXlM/pYYipoDvdHTK1x4E
 In81EffJGizUvgYxO8PJTXuaG1gHtsx7ANp0EaI18snv+veGd/DKN7N9WTJzxpaoXJ7MXves+A
 GYhaZUfyiTftxtk5cGBNYIJnnVvS2Vh6tnLAykIizPvbeZq1yBXbn09VNM99+CtAptJAIMFn/q
 7Po=
X-IronPort-AV: E=Sophos;i="5.76,351,1592895600"; 
   d="scan'208";a="86802150"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Aug 2020 01:12:48 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 25 Aug 2020 01:12:07 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Tue, 25 Aug 2020 01:12:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+H09xsnRouilqNiSYItLRxkDSLERrFxoVRcY3oGYZzaAaQVaZsxy8o9ggPYtoy9SgeGLxYtHR3dfd1CgzwE1ZSRZ6wBBEO6v1DdvBbBcUd7JTpHbzpPKKHpoxBc4gw6PrnQrI4uxCs2MuVXVG3WYBHvSYAVyVBxqclwU2+swJd/fiJMpxTvJqIBE7gFlKItCA9PCEDd0pzxCHLIBxIQcBgqsRAe2Rao4EtFAOS75VvbW6+13WaV4xZjZBq0UBHKLOBAPQ/x5jA9HkE/EyQHjpV4oL5cTYb44KpKeBSEXlDnhG4WqujiDc1nIdRwahGmkfZNTljSVYiG1r3MdyMuLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gSk4MA+LyuzuuDUpypaDmm+wsJBhI2/hxQhDHjIhUE=;
 b=BDLaZS8dUnzBbqRz2zmOWYIGfGySoi+hgwp7NfShc57PFqO0mB7bKKLC54Uc7eXzOuqvE28whKa1YcDOL4c85UKepYTx1Dc0j4TAZqf9qMPEgUkdCOoTBHAcDmFFyJ1ISfLcYXwGl60ElcaNhqZ0QJAOpMuMEQzRAN3L//CjTLXKLQP6G6VCi0/fByExnlRaG4BD0tqg2ZO76Pvlb1+XUQetP9wCvM7v0N1kzH2mdSjNZ+L500j+JWEtE5nxvGp1Lgg4331pzWklkW7XvTOib9RPCwqAJEoFizQcBk4KVFZaTZwCLcw6OwPgijyy8ERph2o4eNVOCq7nk5kwDU9kcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gSk4MA+LyuzuuDUpypaDmm+wsJBhI2/hxQhDHjIhUE=;
 b=DQKYBnD4ifTKJwwsOiR4OxmuUnQDanftWIx/r72oaub1ue6Usmv2m+jB5MJcfM/IItRLsXwYxjnRhnfyz6KdCtLkigtZhv3iML1KEI09EYiDrmxSZUaCsYKAQ7tOSsgc3ir7wI60raXP51U6+ihuMxaaquDNEEK3ewyg3eDIeRo=
Received: from DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) by
 DM5PR11MB2010.namprd11.prod.outlook.com (2603:10b6:3:12::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.26; Tue, 25 Aug 2020 08:12:46 +0000
Received: from DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::cc1b:9fb4:c35f:554]) by DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::cc1b:9fb4:c35f:554%4]) with mapi id 15.20.3305.031; Tue, 25 Aug 2020
 08:12:46 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <dinghao.liu@zju.edu.cn>, <kjlu@umn.edu>
CC:     <Ajay.Kathat@microchip.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <gregkh@linuxfoundation.org>, <adham.abozaeid@microchip.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [v2] wilc1000: Fix memleak in wilc_bus_probe
Thread-Topic: [PATCH] [v2] wilc1000: Fix memleak in wilc_bus_probe
Thread-Index: AQHWereDSWO7u/7biEGHRUz+xtuXIg==
Date:   Tue, 25 Aug 2020 08:12:45 +0000
Message-ID: <6499b77a-c18a-ae37-d6cf-65caf20959f4@microchip.com>
References: <20200820055256.24333-1-dinghao.liu@zju.edu.cn>
In-Reply-To: <20200820055256.24333-1-dinghao.liu@zju.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: zju.edu.cn; dkim=none (message not signed)
 header.d=none;zju.edu.cn; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [82.137.16.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae0b6530-ff8e-4ba7-d616-08d848cea619
x-ms-traffictypediagnostic: DM5PR11MB2010:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB2010105E64BF5239E5AA19C387570@DM5PR11MB2010.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ut5T4Wu4ue4H5ccAIQm/Ld9PhCsx82EaO27fPwEV0Vio+a3WQOIgk+feS1TfSXIloGIp1JMChmMVnULHs/5ydm7dIF+Lp4ArcEEzCv3E4t/c7Vq3/Xx8qYBwzR7ZgdV4sy0lrzk8SHqBmZ78n4TNAQ8f/jHEReY1NYKLtIr9J2jIVeFYZaBCPw6kKfm5qOA8wQ7D1sBje3kMwRDocgCRisGMGL92j66sVheMjHw0w4UC+jjfMFkpmqrZClaB7Qi4ybI+w0lGv83q6dkF6WiD6V6Oy66nkq6lA+w9DPYpn1Y+niRIrUt79xEEkm78hFPS5LJKQDt5jaBivP7OePfkow+2G5mmAOdaERg0pO1p3MbazGoMjXMND5fSL9F7qLyb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(396003)(136003)(6506007)(186003)(31686004)(54906003)(66946007)(66556008)(64756008)(66446008)(83380400001)(53546011)(71200400001)(66476007)(91956017)(6486002)(76116006)(5660300002)(6512007)(316002)(2616005)(110136005)(478600001)(86362001)(2906002)(8936002)(8676002)(26005)(31696002)(4326008)(36756003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: mEvJeatyZvomqVrJEJaMShcDmSnnbd2hFsWj6biD8omU3KjgmQFw+Tc1e6aTpZCUocxefqAe2n+3j1E1DJ6ZIoQboDdiSB8BrQ901QyB/Ks8lKVfev1MltkxlfGHO0wPrFUMm+mOY3jHel5T+5A1GMaN4IBjm67eGpEWCUpwtG468VWXLhyUiZvs0Pg43npH3/cayvm1R4tInaapM2phLpmqOXWzUoT/LXaU9xqiunZoILzkpab6JjRfDP3kbsebPMByJCFJs8n6E+ywW6Re4QROcO6G9Xuch9Ov6nWq540SS5XDgPWOO+4Y7pxs6NYRJKGM2PsxL7VPqFt8GJAKMawi+NXXu+jyH/0kQ/25W5KOsm9vFarpJTp/5TLNstfUmJyXWc/gLZ9q3bwIJD2sfzQ1N7zOogXwAbOKrDHwm+6tjIeyc4loGxrMS0EtAen0KKNkjFimZNf9dZOh53v49Z9uMVY5tJNSXi/CzpMN5QCCw9bPJaMprjVzXOWU7GV7kZA51XDfQQ2Pn/NK4sqlOzOphKrWyPi7mHr3XrqTZj47+rnlgrlEy0cyY8TDr3aXmmVojeZjBYf19l8TOTAZPeQGIejGljV4Aylrhf8xm9lh3rPq+QtMg4g6FqcHZ+bTEiGILTOUhszgruzGLfo/BA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <46C53874D826FF4E8FC9F46A1C2D56F5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae0b6530-ff8e-4ba7-d616-08d848cea619
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2020 08:12:45.8519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H3Nnmia0QL3A095LSQulPsvVzoJphb5AKQVfqt8j6KvlDCAMUnp2hYy3JbpIGybgeSB+AKIjoaGm/5X9M0H2z18LaCbB1CV/Uvv56GekKBA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB2010
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGluZ2hhbywNCg0KT24gMjAuMDguMjAyMCAwODo1MiwgRGluZ2hhbyBMaXUgd3JvdGU6DQo+
IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1
bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gV2hlbiBkZXZtX2Nsa19n
ZXQoKSByZXR1cm5zIC1FUFJPQkVfREVGRVIsIHNwaV9wcml2DQo+IHNob3VsZCBiZSBmcmVlZCBq
dXN0IGxpa2Ugd2hlbiB3aWxjX2NmZzgwMjExX2luaXQoKQ0KPiBmYWlscy4NCj4gDQo+IEZpeGVz
OiA4NTRkNjZkZjc0YWVkICgic3RhZ2luZzogd2lsYzEwMDA6IGxvb2sgZm9yIHJ0Y19jbGsgY2xv
Y2sgaW4gc3BpIG1vZGUiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBEaW5naGFvIExpdSA8ZGluZ2hhby5s
aXVAemp1LmVkdS5jbj4NCj4gLS0tDQo+IA0KPiBDaGFuZ2Vsb2c6DQo+IA0KPiB2MjogLSBSZW1v
dmUgJ3N0YWdpbmcnIHByZWZpeCBpbiBzdWJqZWN0Lg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L3dp
cmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC9zcGkuYyB8IDUgKysrLS0NCj4gIDEgZmlsZSBjaGFu
Z2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3NwaS5jIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3NwaS5jDQo+IGluZGV4IDNmMTllM2YzOGEz
OS4uYTE4ZGFjMGFhNmI2IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9taWNy
b2NoaXAvd2lsYzEwMDAvc3BpLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9j
aGlwL3dpbGMxMDAwL3NwaS5jDQo+IEBAIC0xMTIsOSArMTEyLDEwIEBAIHN0YXRpYyBpbnQgd2ls
Y19idXNfcHJvYmUoc3RydWN0IHNwaV9kZXZpY2UgKnNwaSkNCj4gICAgICAgICB3aWxjLT5kZXZf
aXJxX251bSA9IHNwaS0+aXJxOw0KPiANCj4gICAgICAgICB3aWxjLT5ydGNfY2xrID0gZGV2bV9j
bGtfZ2V0KCZzcGktPmRldiwgInJ0Y19jbGsiKTsNCj4gLSAgICAgICBpZiAoUFRSX0VSUl9PUl9a
RVJPKHdpbGMtPnJ0Y19jbGspID09IC1FUFJPQkVfREVGRVIpDQo+ICsgICAgICAgaWYgKFBUUl9F
UlJfT1JfWkVSTyh3aWxjLT5ydGNfY2xrKSA9PSAtRVBST0JFX0RFRkVSKSB7DQo+ICsgICAgICAg
ICAgICAgICBrZnJlZShzcGlfcHJpdik7DQoNClNhbWUgaGVyZSBhcyBpbiB0aGUgcmVwbHkgdG8g
cGF0Y2ggIndpbGMxMDAwOiBGaXggbWVtbGVhayBpbiB3aWxjX3NkaW9fcHJvYmUiLg0KDQo+ICAg
ICAgICAgICAgICAgICByZXR1cm4gLUVQUk9CRV9ERUZFUjsNCj4gLSAgICAgICBlbHNlIGlmICgh
SVNfRVJSKHdpbGMtPnJ0Y19jbGspKQ0KPiArICAgICAgIH0gZWxzZSBpZiAoIUlTX0VSUih3aWxj
LT5ydGNfY2xrKSkNCj4gICAgICAgICAgICAgICAgIGNsa19wcmVwYXJlX2VuYWJsZSh3aWxjLT5y
dGNfY2xrKTsNCj4gDQo+ICAgICAgICAgcmV0dXJuIDA7DQo+IC0tDQo+IDIuMTcuMQ0KPiA=
