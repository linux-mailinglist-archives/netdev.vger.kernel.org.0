Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6850B36E59E
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 09:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238495AbhD2HKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 03:10:38 -0400
Received: from mail-db8eur05on2061.outbound.protection.outlook.com ([40.107.20.61]:33632
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237427AbhD2HKg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 03:10:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQ8w2+0FlNoT8ciR+uB9XPOBA6uP7Y4SQLG4GG9EyqxqR1FYmI5cWk6YEbC/V6gs7FhoXrH7NHgPD+0E6uYNOn+HEtnOpBFgj8AGVOEBCzUyfiX0Yq78oEp7Rmy78M4zVrIq3rD4XRnHfFSC/NqIpLXM8JtWW4smA1IH4PdNIo5ldUuVtu5FkpoDIOE4hJjQBpmnb5GYao+XvEz2Is8t+uTw41Qf6L45/mnIvcewc2JvpfGzuSuBXrfCiSZvsO5eadfec0QppMFqu9doXwu8M/GUJe8doBRkWQab6wYMHV0TLsVXqRrJLOnSCXIOWUE24AkBMY1rAtZvFoRbSTLWQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/fldKeQ1GTOaWcVrIsNGe7feJoZxGaANJRbn8VDdCfc=;
 b=EmR44F0aLZM/r7xPyVQ54n5EEONTYHm1tSF3Ui22zwE2loaMc+1dPI0GhV3dNnv6tg074cgORzgK2R6FE3f4Q1/Pq9sfziGgFvFItAEv1avTNvYmn5M/p8pOzSj/54O2B0cOzNWWOh8XZ90U1htQxfa5lrw2pvpAUaLJc0/OzVXKavRrkwY/EQjsAlI+DbKKESTmHrssBdm+DYbB0ww03PoXPOqTKYHSHS4z8osUzsPfLyEf3vIZtVxtHoBw0zsvdbAnJpX+PNFmSssmTy3lm7nk0LCCWJpI9itluK/aL/PnuSaEDpbFDLpehGCMBltpkXMSKOZ8FITMcjm9JL6aIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/fldKeQ1GTOaWcVrIsNGe7feJoZxGaANJRbn8VDdCfc=;
 b=rCDDRdmGfoLSY/gnEXV68naGy8oH4pwi1slYe/iXKomB/zvUTRnhl02A5OarGqwlo7eTv7REQZGl1VXgruzdpR9FSwxiKbiSTfL+3WvR9prCkZ/fRUG3gbsulze5aTR3mMFzJ8eBvBNoxSb42tarLJL8EIC0NeDrzbVcrkmBfSI=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7432.eurprd04.prod.outlook.com (2603:10a6:10:1a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Thu, 29 Apr
 2021 07:09:49 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%7]) with mapi id 15.20.4065.027; Thu, 29 Apr 2021
 07:09:48 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "Jisheng.Zhang@synaptics.com" <Jisheng.Zhang@synaptics.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V3 net] net: stmmac: fix MAC WoL unwork if PHY doesn't
 support WoL
Thread-Topic: [PATCH V3 net] net: stmmac: fix MAC WoL unwork if PHY doesn't
 support WoL
Thread-Index: AQHXPAG4PBCaV54acUeCcTVpU+pS8KrJ22sAgAEujFA=
Date:   Thu, 29 Apr 2021 07:09:47 +0000
Message-ID: <DB8PR04MB6795286E3C03699616C8C5C4E65F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210428074107.2378-1-qiangqing.zhang@nxp.com>
 <YIlUdprPfqa5d2ez@lunn.ch>
In-Reply-To: <YIlUdprPfqa5d2ez@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c92494c-2417-4675-1c35-08d90addc667
x-ms-traffictypediagnostic: DBAPR04MB7432:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB7432322DD32B127A81947423E65F9@DBAPR04MB7432.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6zfilxk9Js5wj1F0UVzIrNkzpSQLGJQJa3pNUvs5Z70IcDRfbuLd8F3lLJj/sVUEl2wvQTuUSgSyjldjLC6OJJQOGiUuXAquxUTh6O5fSLYOHtlNXrOmw8Cxczbmya/MMhxq9cI9sA++WYfHA9IJMC2M19kMie4JS7BsXmYS1lvYrRg0VP8SH+WN5Lt9rGiUr3G3fI9GjMxIRc4VCh8gBzvgP2WScuLagam+E9060eWyozIkuXe+Z865+4yUMDkz07wIpFRaVK11s62gFST1qwUnLoB16IBeRLtili2Jaul/iLmqfiLO5tOk98Yz17D/eDFHdI6o4VMxThefXQsBJ2I6RWAsPih/5Ikbr4OmSkwUjH2fM32lMxU6f0vU4tBBM2mQU4ubs+oWGNifN1Uuq5J14PJywS6Oh4tEXaTO+h3Nz1xxKfGWsvdJbsBegTlrV0EnQkaOMujGPPBnfDeLumIvVZDebRkH0Y441Kvwb2HobYZKXvC1KPplyXKft1RW7qDUKYfq/RpX0VyBc1cwaBkC/lbPW+oFgRJb57XU9/4/U6Wemi55mmG653Q0pUdVMJ9GvmrnQF4L3g+Z3lBPcnqFt5ztspxF0r7iEfxEsTE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(52536014)(38100700002)(71200400001)(478600001)(122000001)(64756008)(76116006)(66556008)(66446008)(8936002)(9686003)(66946007)(66476007)(55016002)(2906002)(316002)(6506007)(33656002)(86362001)(53546011)(83380400001)(8676002)(54906003)(6916009)(4326008)(186003)(5660300002)(26005)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?cm8zNEFQRkJaNVZPdzBFV1d6SlJhRWk4UkI4SjRYdFE0OVRkemVOelZtRTlv?=
 =?gb2312?B?WUtuT1hTcnRxa21QbktLcHlyYzZMaXBXL3ZRdERkMlduWmNvVnJpMklzR3hH?=
 =?gb2312?B?LzNablFMbnhDNlVZcmo4d1FBY0ZzOVFWZ01ZNmJySUUzSC9RNHEreDBueTlM?=
 =?gb2312?B?bmhTdVBPS2MxRTErc0FQb1E0NDZvek9maDlyU2VXYjFlU0NXZDViUTRlQ1gx?=
 =?gb2312?B?eWpiUGl2azAweUpFM0w3ZGJVVC84N3FBV2J6dXhyY3o3bDBNdEpqTnpxM2du?=
 =?gb2312?B?bjdDRlJvWk1pOHQyMWxwaEw0SmRnUzltZjBYbS9YMmhmdXBsaWRhTzlUV3Iv?=
 =?gb2312?B?NWFKR3hEMThWdCtRNE82eStMd1lzc2NRUFFGK2VkbEVSaHdDOEY0eWVmdzd4?=
 =?gb2312?B?cC9ybDYvNTZONzQ5VEtTUVNacUNnU3JHRDU4U0JEcDl4QlNQMHhwMDFqUzN5?=
 =?gb2312?B?NmZpMzBCT2lnVzFNUllPUkNsZUVDTHlMRndsTENaRW5oNjRoL1M3TVpBYm5B?=
 =?gb2312?B?OXRia2UvTWhGNWtUMnY0eHNid3huWGNFd1FmUVRBRHdhT3lvaHdFWTh2bm1E?=
 =?gb2312?B?RWxTaGY0UXRvWC81c3puL3ljc0lFT3BSZEIvUlh3aDJCcEtvU1kxR3RSYmpa?=
 =?gb2312?B?Y0dkTUN6WVloUnVYRjkwVW9XaURrMld3ODFocVRicktKaEluWnVIcjBqb1lF?=
 =?gb2312?B?NzBFTmUraFZpVURxYUlNV0xPYzVTZUptOXNJOHJHMUZsOWhQKzArU1BtSytw?=
 =?gb2312?B?LzFWbEQrRlJxZ1hMc1NFc0FWNTh0cktBRnh5L0d6MjA4RG1VQThiY3FpZzhj?=
 =?gb2312?B?RzZzbmR6VmFlL3Z4bzRSVnJuQ0wzL2w1TCs4bUF2RjNKdlovM3p6cVR4YXJK?=
 =?gb2312?B?cUVQeE4rTXVkYzFPT094WFNKVTFENkFCK0Fma0lwV3UxMFEyL25qRVlWSEta?=
 =?gb2312?B?VGZzNzNxZFZNK21XVThYVUxKMU5CeEZEQm1yQ0J1NVkvc0lJcmFyNnQ5NmU5?=
 =?gb2312?B?WFArd282Y29KalczdHpsRk9yekRzNGZ2T2RSNnMzY0d2aHFnZjRWdUMxOTVO?=
 =?gb2312?B?TXBhbnJERkw0S2ovQ2tQNDFodnBEaFZXVFVFKzJFVWI1WEFWYmNUeHpmc1pu?=
 =?gb2312?B?eHVzNlJtME1Jdjc2K3E2NXpmZ3RJVGE0V3c0SVlQcVFxWnhGdjd1dmhJNVRD?=
 =?gb2312?B?TlRhUkM2TVNvYWMrcDJjNnljbkxncVFXcm00MVMvbTNGUmprKzF1SWdQNTkr?=
 =?gb2312?B?RGFrSXRuUy84ek9jSGRtL0JpUnRNbjZ6MjQrR0xpbjBPMmw2WXA2Rk45d0JD?=
 =?gb2312?B?ZzlHdEpPM3I4OFVrQy9oN01jVUZydlQ5dktMdW5ZeVJHUGF0ZFRVdEJVQndD?=
 =?gb2312?B?OEo0b0dZMFFwUFdYTWc5ZStBQWdNTDJ5ZlRxcDNGcjZOUzhJMUJCYjdZN3hW?=
 =?gb2312?B?WUtJVkp6OUZTZ0tnUHNMWDk1b2RuMnhIMG04SngvYjB5TG9oOWg0MkhDZFRO?=
 =?gb2312?B?eWtaNk9JcjJjL3JOV1BvOHBKdXljS09ZdlFIUzZGaEFtM1BJdmk5bGd0OE5X?=
 =?gb2312?B?QlJPN1ROc1MzZHQ4NldXZHpKOU1HVWNnUHpSdHFxVGszd1hnWUlJMzRHOWFV?=
 =?gb2312?B?SEVQWUdGSFQ3SUgzY3pIbkNqZGR1OUdsQUgxaHF1YW5hTnhyRnBRbkVBVEg2?=
 =?gb2312?B?RkdRNkRoN1pwSThMa25sTXlFVGZaYUZjajdZQ1N6VDJ4ZVhRQUNKc2NQeE10?=
 =?gb2312?Q?grX82PrbZasKKcvdja2IoXHiKs6GeJGtOIfU3K4?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c92494c-2417-4675-1c35-08d90addc667
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2021 07:09:48.0370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DC1NSQTpYYwcPQ+r5dCyQVY4K9WDHomAZo/t10PpVMXU1VfOmnXLGgBcVM+tDVNC0B3HSAHwmYlD5px1W6g8pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7432
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFuZHJldyBMdW5uIDxhbmRy
ZXdAbHVubi5jaD4NCj4gU2VudDogMjAyMcTqNNTCMjjI1SAyMDoyNw0KPiBUbzogSm9ha2ltIFpo
YW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IHBlcHBlLmNhdmFsbGFyb0BzdC5j
b207IGFsZXhhbmRyZS50b3JndWVAc3QuY29tOw0KPiBqb2FicmV1QHN5bm9wc3lzLmNvbTsgZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOw0KPiBmLmZhaW5lbGxpQGdtYWlsLmNv
bTsgSmlzaGVuZy5aaGFuZ0BzeW5hcHRpY3MuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0K
PiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IFYzIG5ldF0gbmV0OiBzdG1tYWM6IGZpeCBNQUMgV29MIHVud29yayBpZiBQSFkgZG9lc24ndA0K
PiBzdXBwb3J0IFdvTA0KPiANCj4gPiAgc3RhdGljIGludCBzdG1tYWNfc2V0X3dvbChzdHJ1Y3Qg
bmV0X2RldmljZSAqZGV2LCBzdHJ1Y3QNCj4gPiBldGh0b29sX3dvbGluZm8gKndvbCkgIHsNCj4g
PiAgCXN0cnVjdCBzdG1tYWNfcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7DQo+ID4gLQl1
MzIgc3VwcG9ydCA9IFdBS0VfTUFHSUMgfCBXQUtFX1VDQVNUOw0KPiA+ICsJc3RydWN0IGV0aHRv
b2xfd29saW5mbyB3b2xfcGh5ID0geyAuY21kID0gRVRIVE9PTF9HV09MIH07DQo+ID4gKwl1MzIg
c3VwcG9ydCA9IFdBS0VfTUFHSUMgfCBXQUtFX1VDQVNUIHwgV0FLRV9NQUdJQ1NFQ1VSRSB8DQo+
ID4gK1dBS0VfQkNBU1Q7DQo+IA0KPiBSZXZlcnNlIGNocmlzdG1hc3MgdHJlZSBwbGVhc2UuDQpP
aw0KDQo+ID4NCj4gPiAtCWlmICghZGV2aWNlX2Nhbl93YWtldXAocHJpdi0+ZGV2aWNlKSkNCj4g
PiAtCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+ID4gKwlpZiAod29sLT53b2xvcHRzICYgfnN1cHBv
cnQpDQo+ID4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+IA0KPiBNYXliZSAtRU9QTk9UU1VQUCB3b3Vs
ZCBiZSBiZXR0ZXIuDQpPaw0KDQo+ID4NCj4gPiAtCWlmICghcHJpdi0+cGxhdC0+cG10KSB7DQo+
ID4gKwkvKiBGaXJzdCBjaGVjayBpZiBjYW4gV29MIGZyb20gUEhZICovDQo+ID4gKwlwaHlsaW5r
X2V0aHRvb2xfZ2V0X3dvbChwcml2LT5waHlsaW5rLCAmd29sX3BoeSk7DQo+IA0KPiBUaGlzIGNv
dWxkIHJldHVybiBhbiBlcnJvci4gSW4gd2hpY2ggY2FzZSwgeW91IHByb2JhYmx5IHNob3VsZCBu
b3QgdHJ1c3QNCj4gd29sX3BoeS4NCnBoeWxpbmtfZXRodG9vbF9nZXRfd29sKCkgaXMgYSB2b2lk
IGZ1bmN0aW9uLCB0aGVyZSBpcyBubyByZXR1cm4gdmFsdWUuIEkgdGhpbmsgd2UgY2FuIHRydXN0
IHdvbF9waHksIGlmIFBIWSBkcml2ZXIgZG9lcyBub3QgaW1wbGVtZW50DQpnZXRfd29sKCksIHdv
bF9waHkuc3VwcG9ydGVkIGlzIDA7IGlmIFBIWSBkcml2ZXIgaW1wbGVtZW50IGl0LCB0aGVuIGl0
IHdpbGwgZmlsbCB0aGUgd29sX3BoeS5zdXBwb3J0ZWQgZmllbGQuIFBsZWFzZSBwb2ludCBtZSBp
ZiBJIGFtIG1pc3VuZGVyc3RhbmRpbmcuDQoNCj4gPiArCWlmICh3b2wtPndvbG9wdHMgJiB3b2xf
cGh5LnN1cHBvcnRlZCkgew0KPiANCj4gVGhpcyByZXR1cm5zIHRydWUgaWYgdGhlIFBIWSBzdXBw
b3J0cyBvbmUgb3IgbW9yZSBvZiB0aGUgcmVxdWVzdGVkIFdvTA0KPiBzb3VyY2VzLg0KPg0KPiA+
ICAJCWludCByZXQgPSBwaHlsaW5rX2V0aHRvb2xfc2V0X3dvbChwcml2LT5waHlsaW5rLCB3b2wp
Ow0KPiANCj4gYW5kIGhlcmUgeW91IHJlcXVlc3QgdGhlIFBIWSB0byBlbmFibGUgYWxsIHRoZSBy
ZXF1ZXN0ZWQgV29MIHNvdXJjZXMuIElmIGl0DQo+IG9ubHkgc3VwcG9ydHMgYSBzdWJzZXQsIGl0
IGlzIGxpa2VseSB0byByZXR1cm4gLUVPUE5PVFNVUFAsIG9yIC1FSU5WQUwsIGFuZCBkbw0KPiBu
b3RoaW5nLiBTbyBoZXJlIHlvdSBvbmx5IHdhbnQgdG8gZW5hYmxlIHRob3NlIHNvdXJjZXMgdGhl
IFBIWSBhY3R1YWxseQ0KPiBzdXBwb3J0cy4gQW5kIGxldCB0aGUgTUFDIGltcGxlbWVudCB0aGUg
cmVzdC4NClllcywgeW91IGFyZSByaWdodCEgSXQgc2hvdWxkIGJlOg0KCXdvbC0+d29sb3B0cyAm
PSB3b2xfcGh5LnN1cHBvcnRlZDsNCglyZXQgPSBwaHlsaW5rX2V0aHRvb2xfc2V0X3dvbChwcml2
LT5waHlsaW5rLCB3b2wpOw0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gCSAgQW5k
cmV3DQo=
