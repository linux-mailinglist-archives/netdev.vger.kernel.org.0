Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8060B20D7C6
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733226AbgF2Tco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:32:44 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:52985 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733186AbgF2Tc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:32:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593459147; x=1624995147;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=Qs69Z30JUOWLzXq7gWzy7d4CyTdtgAJq6V2MjQlqXgQ=;
  b=UBIplL3jSaH7PJlX3rv+u4qys0dhwm/3PeTVWl2hKJDIf6EqXNr+Nw3x
   6/T6UUdoisaCh2Fv2syc/sHNPNS5GD4svYiIi9ymmJzMtwWXu3usRfB8f
   7Sf+LNoLf6WR7D3HA7rgY+fcSZAZkCcSmWRDf3/eUKAp8KbecvfZENMmo
   bga11fFAn31Mu7WGdJDzERmcxcawWLHZupIySapqjKqZBMCj8Mv1R9N4h
   THhB7SjJ9UpcHprHxqPXEerW2s0pTC0XcfFh0UnzsqkAB8FjzkC0Dv6c8
   RUWCwm69yz1TBR2jvOvKyRIReZeFfsZRnyFVqt2c5gq9fp5gwY7ENtDCe
   Q==;
IronPort-SDR: 2kzJjTw4Yw69CkgRfkC8sG6tkeIPaGCqRWDUYVFU97n7zYSMmId13PfVnF4AHjuhhejc6DRSu/
 Cg3LSaTyqMrcx0kxAMCa4VqMPOSS4Wa2ClhHaKqADnE8zLANAaDSvZjRkof3clI3/r7blBstBz
 AS3nxs2Ba0kZWBIVmpi/JBtjpIQQEdIqeUq9/O782Or2GOpiwr0dbAMjUX+Snt5xKtbeCDVDXS
 XPj9DxD/BRA3/0xrxhqP4sYnJeC68Vki+80uo4AB4ij0hd7wEk2ry8prQz4zx/gOCecIU6ZNiv
 Qz8=
X-IronPort-AV: E=Sophos;i="5.75,294,1589266800"; 
   d="scan'208";a="78141735"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jun 2020 06:11:49 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 06:11:49 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 29 Jun 2020 06:11:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IoYv9qaK/c4QN+q8B74SUviLNcN7KJbdW31q6WbaMfQ4gbuSc5qlNz+iMuXcSLuUhhV0DYY2JEP7we89yVUtZH0NPyH5nLwl4v09fBPdsvGtf0BjALZcMnCRgxa+Mt+PoJ79EQScQnwr6TvlzkmY3yAUtoVbJDGjB0j8X6ZdTEpzJZwwB/V2GQSBaZApWWDODcW5gz068DEPfNjCShmRwxz79yN5AEneEnBKXXpyU1fOpwf62B6w2rTQwVWkykqB3ANMoYsSrFe1LlrYi651pEoln7LnEcmRrpwLUtbqZhGVho1yTW6Sdb+gk9gEza+EcLrpbCLyS59a9O6quQAEFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qs69Z30JUOWLzXq7gWzy7d4CyTdtgAJq6V2MjQlqXgQ=;
 b=cKP1x63jYj9SpJ5iqWgsISVDodpsY/EeAZQoFwaydSAcAzGJOthqKVp2Vfdy6OP+0/LEAtw8iDSRHbpZAEC1mhMwoR3V4cz5NN8IBaKZ8OIAajaJCxijOLbgl9ynGryPWGdOBA3OJ0+kvT5WMpwpx5CdnVK4N/21g/WzPJRFmbW7g3OLIKfttHlgs5r0lVOUR/gnk3OMHbE0GBoE3SS/HXQiiiltkFRt0gA6S7EpBlNBRZpTWk09l3H4H73ebePh61R+8YI+ZVIqgse5Tz0qCCRKUlcWJOeAhiQVR9LhU1TxchDSzFXPt7kUaUPdDMiT6XPcImmzNhQY3DbKGScBhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qs69Z30JUOWLzXq7gWzy7d4CyTdtgAJq6V2MjQlqXgQ=;
 b=Pu7S1DV6BUa0tEvO44PxLbqve0hTpyaqKF03PU+nHkvASfru2OU1V7WOFgkPSFW9QZMb4bIsDno/c9aBC6Wuq/xSDtu/DMqDOnqyVDkzq7Gl4Ty0ADDgwL+glnaDhWJOkg2VfZuxdbnJNedADKyQNFqNrV0IiY7xMkfiQZ4niUI=
Received: from BY5PR11MB3927.namprd11.prod.outlook.com (2603:10b6:a03:186::21)
 by BY5PR11MB4434.namprd11.prod.outlook.com (2603:10b6:a03:1c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Mon, 29 Jun
 2020 13:11:47 +0000
Received: from BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311]) by BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311%7]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 13:11:47 +0000
From:   <Andre.Edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next 4/8] smsc95xx: remove redundant link status checking
Thread-Topic: [PATCH net-next 4/8] smsc95xx: remove redundant link status
 checking
Thread-Index: AQHWThbXr+B0X4aF20usRiS6Eln+hw==
Date:   Mon, 29 Jun 2020 13:11:47 +0000
Message-ID: <d6c3c83b3615391b555e11671094d0276348a67a.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [93.202.178.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab5c3853-c57c-4c84-6083-08d81c2dfa63
x-ms-traffictypediagnostic: BY5PR11MB4434:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB44343C95424384510486A717EC6E0@BY5PR11MB4434.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B0+bCMrl6Ni8m9pWwv8KCFQvqc1ToZh9wzC2SADa0SnQnvfY6WDR67anK65KPk1BZVXRgpgex2gP1BqeMbkF/uux0bSZNpKGiwoBXaYL7JqoSKLgRz1/Dtn88pf4lkf6Ggg0frPm2NeF1MY4mmm+mYog/WnsS4dME16H76ddvBa0G/dDz1alTGJu9ouKFGwqf7/WY5hkzwNtAVeKUdCH/KybAtXeWfSN2J2HeoAEvUXXDweyhAP/1DGqAImiZBaDDKPVnus/m4ShWtiV8Iv9zVWlQDRftJkE5CK7YasIDOnCnu5vhTX4h3FV+xmOkUIs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3927.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(136003)(39860400002)(346002)(376002)(83380400001)(6512007)(8676002)(8936002)(5660300002)(36756003)(110136005)(4326008)(316002)(2906002)(6486002)(107886003)(66946007)(6506007)(2616005)(76116006)(91956017)(66476007)(66556008)(64756008)(66446008)(186003)(26005)(478600001)(86362001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: fzneRlh9dq0FK7/fLCBB/oDAwF1iEVFZqrtDwWDlLmYuxAdqjlhvoRDFwHhdyOohR98NV6kAglIXCYIUmsW8s8h4cwD8kN8W51aqIT6ZS2T8cg1nlYfmnbwswE/5AZiFfY7IdrlyDbziR9DX3aLcY+ZpNJyrulcpm0QFVVguykhD6PLsJxiftkcWNHmcbjPMNTM0YDy8bt3CRckYupSbawASKr7zAYyxX3XVD8YgD/B16MgTHToo1Tu5DrAxdoBw0K/hclUcAbq0V5QdLYN/77gbR8NouO1WyjpMYsRmjtCfr+f8f5KCdjLLxDPQeMDMIDZwneR2LAUelrxVRCA/pOu6IQ23YZNmNPcP/A+QJUVfK0QFvCsxzZPCrACVptYKfyN8Rw7GBGAAESYvlySt/0ifoCETBGWPvnSV3IB9fDHzSNmlGfe1QahM5eU4nmWGBxbZmd1njKqRPbG+1mlVUISxN+2Zpcp/XI9Om7bOZ6s=
Content-Type: text/plain; charset="utf-8"
Content-ID: <81E1262AD1C35C43A83B4BE298672966@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3927.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab5c3853-c57c-4c84-6083-08d81c2dfa63
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 13:11:47.1598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9oFUVv5wH8tdjs6MkWRvdNoUPopUU2Oik9Qx0EfhtfGvlaCJ6cRCu2waVVpJxO9qRwBQ5UjXSSSBm2iJbmC3xStZi+K1lgXCphjV6kS8TSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4434
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q3VycmVudCBkcml2ZXIgc3VwcG9ydHMgUEFMIHRoYXQgZG9lcyBsaW5rIHN0YXR1cyBjaGVja2lu
ZyBhbnl3YXkuDQoNClNpZ25lZC1vZmYtYnk6IEFuZHJlIEVkaWNoIDxhbmRyZS5lZGljaEBtaWNy
b2NoaXAuY29tPg0KLS0tDQogZHJpdmVycy9uZXQvdXNiL3Ntc2M5NXh4LmMgfCA1NSAtLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCA1NSBkZWxl
dGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3VzYi9zbXNjOTV4eC5jIGIvZHJp
dmVycy9uZXQvdXNiL3Ntc2M5NXh4LmMNCmluZGV4IGZiYjgwYTdhZWYzMi4uM2I4ZjdlNDM5ZjQ0
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvdXNiL3Ntc2M5NXh4LmMNCisrKyBiL2RyaXZlcnMv
bmV0L3VzYi9zbXNjOTV4eC5jDQpAQCAtNTEsOCArNTEsNiBAQA0KICNkZWZpbmUgU1VTUEVORF9B
TExNT0RFUwkJKFNVU1BFTkRfU1VTUEVORDAgfA0KU1VTUEVORF9TVVNQRU5EMSB8IFwNCiAJCQkJ
CSBTVVNQRU5EX1NVU1BFTkQyIHwNClNVU1BFTkRfU1VTUEVORDMpDQogDQotI2RlZmluZSBDQVJS
SUVSX0NIRUNLX0RFTEFZICgyICogSFopDQotDQogc3RydWN0IHNtc2M5NXh4X3ByaXYgew0KIAl1
MzIgY2hpcF9pZDsNCiAJdTMyIG1hY19jcjsNCkBAIC02NCw4ICs2Miw2IEBAIHN0cnVjdCBzbXNj
OTV4eF9wcml2IHsNCiAJdTggc3VzcGVuZF9mbGFnczsNCiAJdTggbWRpeF9jdHJsOw0KIAlib29s
IGxpbmtfb2s7DQotCXN0cnVjdCBkZWxheWVkX3dvcmsgY2Fycmllcl9jaGVjazsNCi0Jc3RydWN0
IHVzYm5ldCAqZGV2Ow0KIAlzdHJ1Y3QgbWlpX2J1cyAqbWRpb2J1czsNCiAJc3RydWN0IHBoeV9k
ZXZpY2UgKnBoeWRldjsNCiB9Ow0KQEAgLTYzNiw0NCArNjMyLDYgQEAgc3RhdGljIHZvaWQgc21z
Yzk1eHhfc3RhdHVzKHN0cnVjdCB1c2JuZXQgKmRldiwNCnN0cnVjdCB1cmIgKnVyYikNCiAJCQkg
ICAgaW50ZGF0YSk7DQogfQ0KIA0KLXN0YXRpYyB2b2lkIHNldF9jYXJyaWVyKHN0cnVjdCB1c2Ju
ZXQgKmRldiwgYm9vbCBsaW5rKQ0KLXsNCi0Jc3RydWN0IHNtc2M5NXh4X3ByaXYgKnBkYXRhID0g
KHN0cnVjdCBzbXNjOTV4eF9wcml2ICopKGRldi0NCj5kYXRhWzBdKTsNCi0NCi0JaWYgKHBkYXRh
LT5saW5rX29rID09IGxpbmspDQotCQlyZXR1cm47DQotDQotCXBkYXRhLT5saW5rX29rID0gbGlu
azsNCi0NCi0JaWYgKGxpbmspDQotCQl1c2JuZXRfbGlua19jaGFuZ2UoZGV2LCAxLCAwKTsNCi0J
ZWxzZQ0KLQkJdXNibmV0X2xpbmtfY2hhbmdlKGRldiwgMCwgMCk7DQotfQ0KLQ0KLXN0YXRpYyB2
b2lkIGNoZWNrX2NhcnJpZXIoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KLXsNCi0Jc3RydWN0
IHNtc2M5NXh4X3ByaXYgKnBkYXRhID0gY29udGFpbmVyX29mKHdvcmssIHN0cnVjdA0Kc21zYzk1
eHhfcHJpdiwNCi0JCQkJCQljYXJyaWVyX2NoZWNrLndvcmspOw0KLQlzdHJ1Y3QgdXNibmV0ICpk
ZXYgPSBwZGF0YS0+ZGV2Ow0KLQlpbnQgcmV0Ow0KLQ0KLQlpZiAocGRhdGEtPnN1c3BlbmRfZmxh
Z3MgIT0gMCkNCi0JCXJldHVybjsNCi0NCi0JcmV0ID0gc21zYzk1eHhfbWRpb19yZWFkKGRldi0+
bmV0LCBkZXYtPm1paS5waHlfaWQsIE1JSV9CTVNSKTsNCi0JaWYgKHJldCA8IDApIHsNCi0JCW5l
dGRldl93YXJuKGRldi0+bmV0LCAiRmFpbGVkIHRvIHJlYWQgTUlJX0JNU1JcbiIpOw0KLQkJcmV0
dXJuOw0KLQl9DQotCWlmIChyZXQgJiBCTVNSX0xTVEFUVVMpDQotCQlzZXRfY2FycmllcihkZXYs
IDEpOw0KLQllbHNlDQotCQlzZXRfY2FycmllcihkZXYsIDApOw0KLQ0KLQlzY2hlZHVsZV9kZWxh
eWVkX3dvcmsoJnBkYXRhLT5jYXJyaWVyX2NoZWNrLA0KQ0FSUklFUl9DSEVDS19ERUxBWSk7DQot
fQ0KLQ0KIC8qIEVuYWJsZSBvciBkaXNhYmxlIFR4ICYgUnggY2hlY2tzdW0gb2ZmbG9hZCBlbmdp
bmVzICovDQogc3RhdGljIGludCBzbXNjOTV4eF9zZXRfZmVhdHVyZXMoc3RydWN0IG5ldF9kZXZp
Y2UgKm5ldGRldiwNCiAJbmV0ZGV2X2ZlYXR1cmVzX3QgZmVhdHVyZXMpDQpAQCAtMTM2MywxMSAr
MTMyMSw2IEBAIHN0YXRpYyBpbnQgc21zYzk1eHhfYmluZChzdHJ1Y3QgdXNibmV0ICpkZXYsDQpz
dHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZikNCiAJZGV2LT5uZXQtPm1pbl9tdHUgPSBFVEhfTUlO
X01UVTsNCiAJZGV2LT5uZXQtPm1heF9tdHUgPSBFVEhfREFUQV9MRU47DQogCWRldi0+aGFyZF9t
dHUgPSBkZXYtPm5ldC0+bXR1ICsgZGV2LT5uZXQtPmhhcmRfaGVhZGVyX2xlbjsNCi0NCi0JcGRh
dGEtPmRldiA9IGRldjsNCi0JSU5JVF9ERUxBWUVEX1dPUksoJnBkYXRhLT5jYXJyaWVyX2NoZWNr
LCBjaGVja19jYXJyaWVyKTsNCi0Jc2NoZWR1bGVfZGVsYXllZF93b3JrKCZwZGF0YS0+Y2Fycmll
cl9jaGVjaywNCkNBUlJJRVJfQ0hFQ0tfREVMQVkpOw0KLQ0KIAlyZXR1cm4gMDsNCiANCiB1bnJl
Z2lzdGVyX21kaW86DQpAQCAtMTM4Niw3ICsxMzM5LDYgQEAgc3RhdGljIHZvaWQgc21zYzk1eHhf
dW5iaW5kKHN0cnVjdCB1c2JuZXQgKmRldiwNCnN0cnVjdCB1c2JfaW50ZXJmYWNlICppbnRmKQ0K
IAlzdHJ1Y3Qgc21zYzk1eHhfcHJpdiAqcGRhdGEgPSAoc3RydWN0IHNtc2M5NXh4X3ByaXYgKiko
ZGV2LQ0KPmRhdGFbMF0pOw0KIA0KIAlpZiAocGRhdGEpIHsNCi0JCWNhbmNlbF9kZWxheWVkX3dv
cmtfc3luYygmcGRhdGEtPmNhcnJpZXJfY2hlY2spOw0KIAkJbWRpb2J1c191bnJlZ2lzdGVyKHBk
YXRhLT5tZGlvYnVzKTsNCiAJCW1kaW9idXNfZnJlZShwZGF0YS0+bWRpb2J1cyk7DQogCQluZXRp
Zl9kYmcoZGV2LCBpZmRvd24sIGRldi0+bmV0LCAiZnJlZSBwZGF0YVxuIik7DQpAQCAtMTY1MSw4
ICsxNjAzLDYgQEAgc3RhdGljIGludCBzbXNjOTV4eF9zdXNwZW5kKHN0cnVjdCB1c2JfaW50ZXJm
YWNlDQoqaW50ZiwgcG1fbWVzc2FnZV90IG1lc3NhZ2UpDQogCQlyZXR1cm4gcmV0Ow0KIAl9DQog
DQotCWNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygmcGRhdGEtPmNhcnJpZXJfY2hlY2spOw0KLQ0K
IAlpZiAocGRhdGEtPnN1c3BlbmRfZmxhZ3MpIHsNCiAJCW5ldGRldl93YXJuKGRldi0+bmV0LCAi
ZXJyb3IgZHVyaW5nIGxhc3QgcmVzdW1lXG4iKTsNCiAJCXBkYXRhLT5zdXNwZW5kX2ZsYWdzID0g
MDsNCkBAIC0xODk2LDEwICsxODQ2LDYgQEAgc3RhdGljIGludCBzbXNjOTV4eF9zdXNwZW5kKHN0
cnVjdCB1c2JfaW50ZXJmYWNlDQoqaW50ZiwgcG1fbWVzc2FnZV90IG1lc3NhZ2UpDQogCWlmIChy
ZXQgJiYgUE1TR19JU19BVVRPKG1lc3NhZ2UpKQ0KIAkJdXNibmV0X3Jlc3VtZShpbnRmKTsNCiAN
Ci0JaWYgKHJldCkNCi0JCXNjaGVkdWxlX2RlbGF5ZWRfd29yaygmcGRhdGEtPmNhcnJpZXJfY2hl
Y2ssDQotCQkJCSAgICAgIENBUlJJRVJfQ0hFQ0tfREVMQVkpOw0KLQ0KIAlyZXR1cm4gcmV0Ow0K
IH0NCiANCkBAIC0xOTE5LDcgKzE4NjUsNiBAQCBzdGF0aWMgaW50IHNtc2M5NXh4X3Jlc3VtZShz
dHJ1Y3QgdXNiX2ludGVyZmFjZQ0KKmludGYpDQogDQogCS8qIGRvIHRoaXMgZmlyc3QgdG8gZW5z
dXJlIGl0J3MgY2xlYXJlZCBldmVuIGluIGVycm9yIGNhc2UgKi8NCiAJcGRhdGEtPnN1c3BlbmRf
ZmxhZ3MgPSAwOw0KLQlzY2hlZHVsZV9kZWxheWVkX3dvcmsoJnBkYXRhLT5jYXJyaWVyX2NoZWNr
LA0KQ0FSUklFUl9DSEVDS19ERUxBWSk7DQogDQogCWlmIChzdXNwZW5kX2ZsYWdzICYgU1VTUEVO
RF9BTExNT0RFUykgew0KIAkJLyogY2xlYXIgd2FrZS11cCBzb3VyY2VzICovDQo=
