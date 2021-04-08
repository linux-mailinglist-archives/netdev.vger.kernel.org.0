Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74DFD3581A2
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 13:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhDHLXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 07:23:19 -0400
Received: from mail-vi1eur05on2069.outbound.protection.outlook.com ([40.107.21.69]:36916
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229721AbhDHLXS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 07:23:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKrg3CzEGuBdaucmleqfdXpQAfe4veRk6cr4P28tYCM8lB3uiZ0Cb7LHWAEnKL9+N0+OBT/IFCoia3AOP5Ny2x03Vhi0B8OfXM/jTNDpVikCa1tsNjqopZyGnRmecmQ3AQQ2Sai8/8fXZD/JEvdVpIhDnbkLwszMMeB3AepvZXTjy1XqBjbUWTPzsym1/ph6aQAhKFS3fN4jPTVZKSRxNmriQ0nyojl7B5qPhI56DpbHoxQpFDoBofVqUbdRbdKEkoXs1NEOU6lJ4mWjLgLeG7mJ2/YJPRgXwLpSZe+0GjSh04KtvEM356tEVMfIKXXAzbD+n5q0LKxq+GROTJoeAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/uE5ewre38LdxcJ1EVHCyk4a+OVNy5Uai9M+7W63N3U=;
 b=baT3MdVyNQyERhcyMioOMQvsrudpKKjVkzUas3HKtEsGT4PHD6jStW9azojiKfIQmRAe3keDku5PLo9WCiFidM5GXFd2zgsupP/56SJCFoq+2UYqBZv64V/XamKk7OStkj6zDUnL7TBINPEbgwg7feG0Sw1eGXsQhlwdZutTW5rQktNbqDm3LXh6JSQlaQKoQHM1dij95c1uKjzVmOHatylt1fhJ0xIw732wkliS4uZQWnYgGIFFwqfybFMUmfjxb4ThyrZfBopoAoNFY7TCIMUJO7Ba5mY0Z/rNQyUmFyCI2N4Fejika73rVkQGMWf5UTy1vaI5mNHPqlI74T5YLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/uE5ewre38LdxcJ1EVHCyk4a+OVNy5Uai9M+7W63N3U=;
 b=PDP9GWP0iA89pH5bHnj3NS1IEZFfVuDOdmxWyl66qYHAwUbnXkYQcxU9m041w9fmgyYijAfozSrUyQPOOP9y8ybH1Vt3XNk3SDQ/x+UvuYxOWDRWc7ZlOc9fVhtoBjsdAWpLpK/SuA7hByDecwfh29Dc2zjYgfD3kbXRekBK8tI=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM6PR04MB4840.eurprd04.prod.outlook.com (2603:10a6:20b:11::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Thu, 8 Apr
 2021 11:23:05 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777%3]) with mapi id 15.20.3999.032; Thu, 8 Apr 2021
 11:23:05 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH 2/2] enetc: support PTP Sync packet one-step timestamping
Thread-Topic: [PATCH 2/2] enetc: support PTP Sync packet one-step timestamping
Thread-Index: AQHXIh91MovEoZw7WkSYkDMugKaweKqZCjeAgBGCemA=
Date:   Thu, 8 Apr 2021 11:23:05 +0000
Message-ID: <AM7PR04MB6885F7552685585FCB21EDE8F8749@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20210326083554.28985-1-yangbo.lu@nxp.com>
 <20210326083554.28985-3-yangbo.lu@nxp.com>
 <8fa3394e-847f-a3fa-438a-1b357b5726fa@gmail.com>
In-Reply-To: <8fa3394e-847f-a3fa-438a-1b357b5726fa@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c35b535a-5502-4a1a-1d9c-08d8fa80ade8
x-ms-traffictypediagnostic: AM6PR04MB4840:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB4840C2F26A86BE4D7E012992F8749@AM6PR04MB4840.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SNPhZuPcBRRlf2T0BBGXNaFQaL9VVM7I9z37UbBZn9KgsW7DShsumUoEqWS8fVoB0GNO1IBRRIRH+YfsOBsTb7tucln1WOnLIYEKrKLzyFe270acPK5LqrMpp7hk1wfDLvhfog95g9Lri/6crNDI1yZxuHV2yxsbd4l+9Gb5GsRCBSMdoQN2NtvndtaK0lsmpAVeTuBmZxvw0DhK1sboNNz6fnuPLA9o3D1+URfhHTccXvxDZj45yxbOD2+i2GlMJYc6mN+WocIGf54EU9q1+J8RxQGbg1juwmrnzpVudw52RYOuYSIFZJlBUvj/vC0QM6KKChA/yqKYyFyESpdU1zKcaL4m7zwW5P3t2jQ5YpP6TrbzB3Z9MoJyRc7zhKyQl+/us9kexccqGNQ7DtmBE/7aBqNnkAqz1PSTOoHthqWCcInVJoBc4H14j2Z3qktPfnENdfBL/Umr8lnkcK7lNWKZlQT8sqltCsMCdvulcKaPUXMpJWB4zMshUHaBdgV2OqW0cGnMtFkSO3AmEtOzLGxjnuJRoU9DRkQnprSMUcY701PbFxnfYmJTP4WFrrmIHey59gJvoIgZi0hC7zrnIc+cvTbYS8SrRCYm478VyHBaRW4uJnRPgbGkDV9DlvIYGYZ7M9ALwdnFhIcO+HdrwXFXP3wgFbQYnNpjkXKPUE8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(366004)(396003)(376002)(346002)(316002)(76116006)(54906003)(52536014)(66556008)(66476007)(66946007)(110136005)(5660300002)(33656002)(66446008)(2906002)(64756008)(83380400001)(55016002)(7696005)(38100700001)(71200400001)(6506007)(4326008)(186003)(8676002)(26005)(86362001)(53546011)(9686003)(8936002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TVprbHdTRVZkeXlzVitOb0R5TXB6Z29UTi9GeEFXK2lmSWpzSEIwVWNnS3Ru?=
 =?utf-8?B?RTBFRnIxTmJHQ0ZSbEFvS3dMVGg1My9iRTFFSW40UTAyZHFkUXYxR2JQMjIx?=
 =?utf-8?B?NXl5SCt0UW5LbmsxNS9SVGxJckhwMVBNZ2VFZGREd093dURsNDBwU1c3eXBE?=
 =?utf-8?B?cmhZblNuSDdCSEtpMFliMHNmSm8xK3gxV2FoRDZvSi9kRWxFdEdhL2JadmlD?=
 =?utf-8?B?OWV2d285dGJvZlQzZ0RLVGs0RFpCTnlDUnRtTWs2aXFRTHphTWl0OCtOWVpW?=
 =?utf-8?B?ZzREZE5BMndWK09OTUJ1Q0oxU0VmNnVnaXNSWElka2ZnZGZmNDJWQVZhVHZQ?=
 =?utf-8?B?c0V3MVE0SVc3TW5JNE83NldMaDN1bFFpcGdFWUcvQ25nbWZvZDh4N3BwTTVH?=
 =?utf-8?B?Wk4yZ2o5V21pSE1ROG5pS254WDg5cDdVaVo4V2ROSjR4Wjg5RnQreXpvRC9G?=
 =?utf-8?B?dVRMNFVpTHNlSUxoaFRuU3JFNkxtd0EvRTU0ZHk3WlZPenBrSVlrNStNZXlj?=
 =?utf-8?B?cXdrV3RzbURtdnlaMVZpaG5aT0hFNHpJTkx0RTQ2RTVYNE5LcDJtdjZ4OHB6?=
 =?utf-8?B?NlVURG5sejZnUHNzY1hkbXp1aDUzdGpkdnp5bFhJRHQ5U1grVkVPU05Lb3Nw?=
 =?utf-8?B?QVRPVEZvOWY0dy9aL1Z0YTVNTzl1cmZuRjZ1ZS81Y2dHemZqeEdzMlJYZjk3?=
 =?utf-8?B?anlxbzc0UUVIVVdsMGl1SDRlTWpoVzY4YVVRNytIcXh1MVdNdHF4WHU0MEZv?=
 =?utf-8?B?NTI4WWEvRjZFU1EzMmlXNWV0YW5UTmNCQzV4bUNIR0VVUndqNERCWWt1UHQx?=
 =?utf-8?B?SlVUNExaeEFVNVF3UGc2d3BaaVZDZFI1VWhudXNUYU9CemJ0S2JmTklHRWRT?=
 =?utf-8?B?Wk52UE1tL1pPK2Zzd2NHQ2l2RzNLV1REU1Z0YzZZa1B6T2YxcmhjM1h3cStO?=
 =?utf-8?B?bmdpUStpOGsvNGRtb1N6QVgrVzJKSEJsVkV0NUtadld2OXc3R0JaaWQ5YXE1?=
 =?utf-8?B?Z3A4TFIwYkV4dHRFeGt6OXJ2clh2RU1xRHNJN3Z1UDVTWFlOdmlDTm84TU5P?=
 =?utf-8?B?a3doSlNiQVFSaU15SnVEakxYSlBrS084VkhNcWZja0hidkR4b2hMS1VhSWxy?=
 =?utf-8?B?SXhmdHdlTTdPREpuV1Vrd1F6OXc1OWNWNENPOU5BZFBuRTFGVXZOZ3grdTUz?=
 =?utf-8?B?M1huN0FjVlBHWjVXRVgvV0Vxa2lRQWRHOXdCQ2R5M2N6RHJCT3Q2MERDdERB?=
 =?utf-8?B?U21adTA5T2l4dWJIWjRqamNIb3ljUmpsa2wydUFTUGI3cExldlJTV3pRQ1pt?=
 =?utf-8?B?TGlZdW8weG82TWZLZ1dpcHM4VHNLUW10TmxFZGl5elFqbXQ4Uys0VS81OGVl?=
 =?utf-8?B?ODZzMDhDTVJDZzFSZmtGWGdLTGNFYUliNlVFWTU3MlVENk84Q0JGU3JGYnFG?=
 =?utf-8?B?Z2daaHBNQUVPOEJUN0lGNVNpTC9lZ3J4QVpnUXRNMnkrR29reUdFdnBXdmU1?=
 =?utf-8?B?WUZXSSs3cU5ERGU5UWJicjg0enRMcm94T1Z3VDF3NnQyQ3gwaXhod3VmR2lj?=
 =?utf-8?B?UDJWd0JxMkprajhIajQwdTg0ZjFGYW4xNzluSiszYWZKQnpCR3ZncEhFVGRm?=
 =?utf-8?B?d25rUkJ4Qml2dU14MWgwU29sS2hqMXhwbWd2UnQrNTJEVllCQ3RJdFIyK3l4?=
 =?utf-8?B?SlplRWY2czNnN3dmUU1Jc0NZR21vZHpHVklDN1hKSGZFR2FQMjhWYmdZalpF?=
 =?utf-8?Q?TL+Xy/tISVGN/aMapm5/2AX9JInqhIyJk3NhUZy?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6885.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c35b535a-5502-4a1a-1d9c-08d8fa80ade8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2021 11:23:05.1780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fho8XD9KjYkZFffmTl45IU9/JxcNCERGVPHtbm8lTzZzUU25AVZGoljli4GPKvcKoYqDM4HC06TdyJAlM7mfWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4840
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQ2xhdWRpdSwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBDbGF1
ZGl1IE1hbm9pbCA8Y2xhdWRpdS5tYW5vaWxAZ21haWwuY29tPg0KPiBTZW50OiAyMDIx5bm0M+ac
iDI45pelIDE1OjUyDQo+IFRvOiBZLmIuIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT47IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IERhdmlkIFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5u
ZXQ+OyBSaWNoYXJkIENvY2hyYW4NCj4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT47IENsYXVk
aXUgTWFub2lsIDxjbGF1ZGl1Lm1hbm9pbEBueHAuY29tPjsNCj4gSmFrdWIgS2ljaW5za2kgPGt1
YmFAa2VybmVsLm9yZz47IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMi8yXSBlbmV0Yzogc3VwcG9ydCBQVFAgU3luYyBwYWNr
ZXQgb25lLXN0ZXANCj4gdGltZXN0YW1waW5nDQo+IA0KPiBIaSBZYW5nYm8sDQo+IFBscyBhZGQg
dGhlIFtuZXQtbmV4dF0gcHJlZml4IHRvIHRoZSBzdWJqZWN0IG9mIHRoZXNlIHBhdGNoZXMgbmV4
dCB0aW1lLCB0byBhdm9pZA0KPiB0aGUgcGF0Y2h3b3JrIHdhcm5pbmdzIGFuZCBsZXQgcmV2aWV3
ZXJzIGtub3cgd2hlcmUgdG8gYXBwbHkgdGhlbS4NCg0KVGhhbmtzLiBJIGFkZGVkIHRoYXQgZm9y
IHYyLg0KDQo+IA0KPiBPbiAyNi4wMy4yMDIxIDEwOjM1LCBZYW5nYm8gTHUgd3JvdGU6DQo+IFsu
Li5dPiArbmV0ZGV2X3R4X3QgZW5ldGNfeG1pdChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3Qg
bmV0X2RldmljZSAqbmRldikNCj4gPiArew0KPiA+ICsJc3RydWN0IGVuZXRjX25kZXZfcHJpdiAq
cHJpdiA9IG5ldGRldl9wcml2KG5kZXYpOw0KPiA+ICsJdTggdWRwLCBtc2d0eXBlLCB0d29zdGVw
Ow0KPiA+ICsJdTE2IG9mZnNldDEsIG9mZnNldDI7DQo+ID4gKw0KPiA+ICsJLyogTWFyayB0eCB0
aW1lc3RhbXAgdHlwZSBvbiBza2ItPmNiWzBdIGlmIHJlcXVpcmVzICovDQo+ID4gKwlpZiAoKHNr
Yl9zaGluZm8oc2tiKS0+dHhfZmxhZ3MgJiBTS0JUWF9IV19UU1RBTVApICYmDQo+ID4gKwkgICAg
KHByaXYtPmFjdGl2ZV9vZmZsb2FkcyAmIEVORVRDX0ZfVFhfVFNUQU1QX01BU0spKSB7DQo+ID4g
KwkJc2tiLT5jYlswXSA9IHByaXYtPmFjdGl2ZV9vZmZsb2FkcyAmIEVORVRDX0ZfVFhfVFNUQU1Q
X01BU0s7DQo+ID4gKwl9IGVsc2Ugew0KPiA+ICsJCXNrYi0+Y2JbMF0gPSAwOw0KPiA+ICsJfQ0K
PiA+ICsNCj4gPiArCWlmIChza2ItPmNiWzBdICYgRU5FVENfRl9UWF9PTkVTVEVQX1NZTkNfVFNU
QU1QKSB7DQo+ID4gKwkJLyogRm9yIG9uZS1zdGVwIFBUUCBzeW5jIHBhY2tldCwgcXVldWUgaXQg
Ki8NCj4gPiArCQlpZiAoIWVuZXRjX3B0cF9wYXJzZShza2IsICZ1ZHAsICZtc2d0eXBlLCAmdHdv
c3RlcCwNCj4gPiArCQkJCSAgICAgJm9mZnNldDEsICZvZmZzZXQyKSkgew0KPiA+ICsJCQlpZiAo
bXNndHlwZSA9PSBQVFBfTVNHVFlQRV9TWU5DICYmIHR3b3N0ZXAgPT0gMCkgew0KPiA+ICsJCQkJ
c2tiX3F1ZXVlX3RhaWwoJnByaXYtPnR4X3NrYnMsIHNrYik7DQo+ID4gKwkJCQlxdWV1ZV93b3Jr
KHByaXYtPmVuZXRjX3B0cF93cSwNCj4gPiArCQkJCQkgICAmcHJpdi0+dHhfb25lc3RlcF90c3Rh
bXApOw0KPiA+ICsJCQkJcmV0dXJuIE5FVERFVl9UWF9PSzsNCj4gPiArCQkJfQ0KPiA+ICsJCX0N
Cj4gPiArDQo+ID4gKwkJLyogRmFsbCBiYWNrIHRvIHR3by1zdGVwIHRpbWVzdGFtcCBmb3Igb3Ro
ZXIgcGFja2V0cyAqLw0KPiA+ICsJCXNrYi0+Y2JbMF0gPSBFTkVUQ19GX1RYX1RTVEFNUDsNCj4g
PiArCX0NCj4gPiArDQo+ID4gKwlyZXR1cm4gZW5ldGNfc3RhcnRfeG1pdChza2IsIG5kZXYpOw0K
PiA+ICt9DQo+ID4gKw0KPiBbLi4uXQ0KPiA+ICtzdGF0aWMgdm9pZCBlbmV0Y190eF9vbmVzdGVw
X3RzdGFtcChzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspIHsNCj4gPiArCXN0cnVjdCBlbmV0Y19u
ZGV2X3ByaXYgKnByaXY7DQo+ID4gKwlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOw0KPiA+ICsNCj4gPiAr
CXByaXYgPSBjb250YWluZXJfb2Yod29yaywgc3RydWN0IGVuZXRjX25kZXZfcHJpdiwNCj4gPiAr
dHhfb25lc3RlcF90c3RhbXApOw0KPiA+ICsNCj4gPiArCXdoaWxlICh0cnVlKSB7DQo+ID4gKwkJ
c2tiID0gc2tiX2RlcXVldWUoJnByaXYtPnR4X3NrYnMpOw0KPiA+ICsJCWlmICghc2tiKQ0KPiA+
ICsJCQlyZXR1cm47DQo+ID4gKw0KPiA+ICsJCS8qIExvY2sgYmVmb3JlIFRYIG9uZS1zdGVwIHRp
bWVzdGFtcGluZyBwYWNrZXQsIGFuZCByZWxlYXNlDQo+ID4gKwkJICogd2hlbiB0aGUgcGFja2V0
IGhhcyBiZWVuIHNlbnQgb24gaGFyZHdhcmUsIG9yIHRyYW5zbWl0DQo+ID4gKwkJICogZmFpbHVy
ZS4NCj4gPiArCQkgKi8NCj4gPiArCQltdXRleF9sb2NrKCZwcml2LT5vbmVzdGVwX3RzdGFtcF9s
b2NrKTsNCj4gPiArCQllbmV0Y19zdGFydF94bWl0KHNrYiwgcHJpdi0+bmRldik7DQo+ID4gKwl9
DQo+ID4gK30NCj4gPiArDQo+IFdoYXQgaGFwcGVucyBpZiB0aGUgd29yayBxdWV1ZSB0cmllcyB0
byBzZW5kIHRoZSBwdHAgcGFja2V0IGNvbmN1cnJlbnRseSB3aXRoDQo+IGEgcmVndWxhciBwYWNr
ZXQgYmVpbmcgc2VudCBieSB0aGUgc3RhY2ssIHZpYSAubmRvX3N0YXJ0X3htaXQ/DQo+IElmIGJv
dGggc2ticyBhcmUgdGFyZ2V0dGluZyB0aGUgc2FtZSB0eF9yaW5nIHRoZW4gd2UgaGF2ZSBhIGNv
bmN1cnJlbmN5DQo+IHByb2JsZW0sIGFzIGVuZXRjX21hcF90eF9idWZmcyh0eF9yaW5nLCBza2Ip
IGlzIG5vdCB0aHJlYWQgc2FmZSENCg0KVGhhbmtzIGEgbG90IGZvciBwb2ludGluZyBvdXQgdGhp
cyBwcm9ibGVtLg0KSSB0cmllZCB0byB1c2UgbmV0aWZfdHhfbG9jayBmb3Igb25lLXN0ZXAgdGlt
ZXN0YW1waW5nIHBhY2tldCBzZW5kaW5nIGluIHYyLCBwZXIgeW91ciBraW5kIHN1Z2dlc3Rpb24g
b2ZmbGluZS4NCg0KPiANCj4gUmVnYXJkcywNCj4gQ2xhdWRpdQ0K
