Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBB735C0F6
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 11:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239839AbhDLJSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 05:18:32 -0400
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:60417
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241331AbhDLJPf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 05:15:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BeQQZt1LHpvQ5yEhCmc9B7ToquBqSW54exPchhSg3p2KsxfwAmvQeusbCQ19LYeH2fLKOEu1RVr2WOwQ6JCwkFYacRdYBfXf+d5lOgwqVWew1bbA6U9w8P5wy1pq39D6h1z49Sf/vJ4IBOvy7H+W6z+3JDvGlwbCQWw/orDuktWnTwNU/vRefGQKcU9QsGYzvzwNckufnFisbC5vEMJ85MeZxFgzOF9eaLwmHg7R/vjZmAYzAWtJCvFWSLY3OxSfszX7j0uxUTZWTpovyt/5wAgHoxudzPT5tncZ41a31XQO5cX3jCOzLTLPX+FHPfI33OFe50kzMWs7frTLmSiMpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOMLdRZPFmTjW81OQ/hJIL2NPMwUIk98bbC81WeC43M=;
 b=GwwutJEbgE62pjFXOw49cYcyWVJ2ixDGkfR0Gz0vQI9qcLlJPjxjniSnyq655Wy02KalHx5yKHkV1XnqKlZ/yWQtEnb8V6kOJfbBqhmsuicM3BV5dfycIEOvT/35oAm37gW+mWZSJ/U769qFTjsIeQNZdr/AgHGNcaKF6+3SoTm+13Hx0Y91sYj1cEI+f+fn2IqAizKgQ08gKFHGwLRksjxwbCoMTlohmWxzVg4+Pi2IzlyihPHVS31LDRuPpTTH8Q0YHzEAmGJE0fwNW7pFdEB3QTML4dAOwB/P8u8nEL69VOvBsnlxrGJJrH5pO2mHTKDHlm2fxWfCKI1ZbyATBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOMLdRZPFmTjW81OQ/hJIL2NPMwUIk98bbC81WeC43M=;
 b=JIEQ/qmqLXIuiYhRX9huCH0gBzo0cJ0INxle+xo858h8FAaVgA4h4/dw2jzpO/Zz3bza7SuDJKQkOA898cW9Sc8TS9NwNasaUpxVRUPHsTfNWvbUl9WfUoR4Esph40uYIY7/jxHrnXUqwP8a0EQiXRLE9zRBGrP/B42WSy+R0c4=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM6PR0402MB3944.eurprd04.prod.outlook.com (2603:10a6:209:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 09:15:14 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777%3]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 09:15:14 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@gmail.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: RE: [net-next, v2, 2/2] enetc: support PTP Sync packet one-step
 timestamping
Thread-Topic: [net-next, v2, 2/2] enetc: support PTP Sync packet one-step
 timestamping
Thread-Index: AQHXLGdYYc5/r8Ce2kysjXIc9bpBvKqqyHEAgAABMwCAAPNJgIAAn8CAgAA4xICAAAMuAIAEA+2A
Date:   Mon, 12 Apr 2021 09:15:14 +0000
Message-ID: <AM7PR04MB6885C05634FCE45B0CE0DEBBF8709@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20210408111350.3817-1-yangbo.lu@nxp.com>
        <20210408111350.3817-3-yangbo.lu@nxp.com>
        <20210408090250.21dee5c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210408090708.7dc9960f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AM0PR04MB6754A7B847379CC8DC3D855196739@AM0PR04MB6754.eurprd04.prod.outlook.com>
        <20210409090939.0a2c0325@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a9a755f3-9a44-83d5-4426-1238c96c8e15@gmail.com>
 <20210409124412.3728a224@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210409124412.3728a224@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 756f0076-766a-40c6-60b7-08d8fd937b65
x-ms-traffictypediagnostic: AM6PR0402MB3944:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0402MB39449A607695FCA81B16944EF8709@AM6PR0402MB3944.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XT4tRDMDOvLlGEGD3EvP3Eh+/NyvYcRoWvztuDFnprNOxDXuZdYZ9dViBsYI9SuXhvZXjgGRHm3T7pwQJ312NOoPDWJiJN0z5v+SETQX4sneV+BSCwmD0MALPbACKuMAroVC7CKJwE0DRsaBZUxHJt8Uzpoeso4FdQznWixy3iFte8qqWOOqMKg/xuQkIO4JqvvOzA/fTteJjj7x4rZd0aneIlzo1rUAVBiMKrrepPN+z4nui/T3fMaQdJL+vEq5bZsYPiqTtNUxj/a5imuF2sBb0xVny43gF/+pTjaR4dH0Cb9D5RjGx94q2ix74/pr2/H/E0WGSXKoBfmSEdp+yt93YwyHDcddaf0qg/wBHdNYbacgLq0kZgvZvsYynbe4L2QGyrxccn7bfyvn3jauJJHasGnGUglR9HWt2CnD9E/YbktHWAaqcR9EbCVi+0sM3+vPQb5Fm1X3v/fq2OgfoUORx1uoslxSaq29N2srh0kZXAXaQRHXdztDeI6uNopfoYyvn1EBZMx0QKvs9HzrKCJq1l/vZXxdfvKQsOn/XxFk4v4niIirkJCkjonmGHymfQLkmPJotlhNt7sYVkBt8kXYLkDOG7+b+ZSkV4vree0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(6506007)(71200400001)(8936002)(54906003)(76116006)(316002)(478600001)(7696005)(110136005)(52536014)(83380400001)(53546011)(33656002)(38100700002)(9686003)(186003)(55016002)(5660300002)(64756008)(66556008)(66446008)(66476007)(4326008)(8676002)(2906002)(66946007)(26005)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?d1VUY2JnVjA3T0VLdUdnaWlCcDRMSjl4U1FhSDQwbjZ0YXIxMlg1ejlBYmtV?=
 =?gb2312?B?bTFmbUgwT2JNTnJNZHlycHRJaVFncVBvWGd4cjRlN3ZuOXo5cnRaNW5nZGZC?=
 =?gb2312?B?K1dEelhLVHVGT01Zcm5ON2dwQ3QyQTNjamNEOWFHRHVZRUk0N1VoTVBaOWNI?=
 =?gb2312?B?QmpsWSszNk1tZmtGMmFVdFd3WUtGRGdSdVlaTFh5bHZobUhaaHgvSE5TT1Uy?=
 =?gb2312?B?U0xEc1VNZ2ZUT3RoN1RlOEZ5QkRNNXlEbUozS2hVbDRrYVZjRHVhYlcxMDJS?=
 =?gb2312?B?MHBTV3cxcm5xTzNPZ3R0UStmZ1NZU2N3SStlTWZQR2EzLzZaL1ZMZTA1bVds?=
 =?gb2312?B?UEhhZEVpVWxaMTJFYVFocUphNCt6Mms3bW0rUTlRVGxUeFpKbWxEUlhQZEkz?=
 =?gb2312?B?QzNqVFBrbkJ2Ui9rejFqRUg1bFBTZksvM3k2ZFRyTXhuOHg2OFlwTEgxTkZj?=
 =?gb2312?B?Mkk0TW94bFRGeE5WUXU3YmVWdUc4aUVyT3U0cjEwRnYzb0RHTHk2RUt2Nmt6?=
 =?gb2312?B?UXZvSTdqd1NzRm1heFl5R0ZWcE9VQ0hDQ202NkhqZk96L2h5RFhONnNueGEr?=
 =?gb2312?B?R0NWMVhhaFoyM2doOXpwZEJ3K3oxaDFLd1NvbWZPYWIwb3p3RTF2Qm9rSXVk?=
 =?gb2312?B?RVB4Q2t4MjQ2aXc5d0ZTeDc5WHlBaTREamUwYStnK1JoemFmUTZ0TWVIUkVZ?=
 =?gb2312?B?OXhDZkVaQ0hjZXRBcFd1eEM2N2lhdm9YTCtSR1Mya3ZCaEpqSW9PQXBWL3Vu?=
 =?gb2312?B?b3pIRnY4a2dyZys0UFo2em82ZWNZMnorNmk0cEtZOWFENW1Dd1I4ZjVKNFlI?=
 =?gb2312?B?cDA3THRtMkZEcEFCUVQyUTdNajFKMk56NmVDdmR2VmtlWDhENjJyckhoNzRP?=
 =?gb2312?B?L2EvK2d1M3BGUnBTcFkxODRFWGVaYy9sdXJGeTRrYjBjaGM2bnloYUpERi9S?=
 =?gb2312?B?Rno4TGJtL0hqL2lpUG5NeVJLdFQ1bHV6M21uczJCcVJhQ1FmU3JyWkQzUUM1?=
 =?gb2312?B?YXE3ZkdpS1g2d3lNWTRCSFRoMUU4cnB1ckc0aXB1SDFsWmcra0RkcHBibVhr?=
 =?gb2312?B?dzd4REQ3OHN5dkk2SERUZFdldUp4Yk9qbFdMMnBCOFlUTFU4b3RWbjd2c01I?=
 =?gb2312?B?Uld2eUJyYzRnNlU5ZGRuMmFNdDAxMnovTWFodDZnK2tUL3hTL09aZ1c1dmx2?=
 =?gb2312?B?dDJIcHRzQVVXSDRFRU5uajVSY1pCZVRoZHNxbk1GOG5tNm9RTGJHeVdEUWFD?=
 =?gb2312?B?OUF5c2JNSlgza0ZKUnJlOGdWOGxvWDFUWCtQei9KZEhzdEMxSTU4Lzg3M3VU?=
 =?gb2312?B?TzRNRGFEODRkaVk4eXVUeGJLRzRNZzR4dnZBVEZWWDF0WHY3YWhzM1pvcEpU?=
 =?gb2312?B?Tjg1VXZzME5RMTY0bjhvTS9JSHpQbFNzejc5SG5PWVJjRmhiSkZhaURNUGta?=
 =?gb2312?B?NDZHd0lRUU5LUXh2bS9KT0lraVE5YWN6K0paR0hXa21jMlI0cXFWWEFaRDNK?=
 =?gb2312?B?VXBHd0Q2NU5VSFY0YmhOZW10ekJ6d0VEWFJTeDhCWXJzdUlVMmV3VVc2WFln?=
 =?gb2312?B?aUNqbjVkOExMSXgxSFlaZElHQTdvMmc5R1NFaHFCN1poaGxOaHB0a1JCWXlV?=
 =?gb2312?B?NE1wL0Q4NmoxK3plUlVVYUl1UHc2MmNUK1crNGx1TTMrL1dTVTY1S3k0WGJz?=
 =?gb2312?B?S3lkWk4yOE5mV3dKS2kvYnRTQlYrbUtma2VNd0QrcnJrQTRadFBCRVZWeGpu?=
 =?gb2312?Q?AixawkTX1h+qYFSpD1Bgl9h02o+NuUGyXec5HBH?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6885.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 756f0076-766a-40c6-60b7-08d8fd937b65
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 09:15:14.4180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: piTwwuzLzCeG6qkq/4abUSiqk464V4PMUhz3cdEwSRxrYjsI4nR3aUh0pfSarswSU7ZBYh82VvVyLHhnBsHf0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3944
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrdWIgYW5kIENsYXVkaXUsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4g
RnJvbTogSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogMjAyMcTqNNTC
MTDI1SAzOjQ0DQo+IFRvOiBDbGF1ZGl1IE1hbm9pbCA8Y2xhdWRpdS5tYW5vaWxAZ21haWwuY29t
Pg0KPiBDYzogQ2xhdWRpdSBNYW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBZLmIuIEx1
IDx5YW5nYm8ubHVAbnhwLmNvbT47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IERhdmlkIFMg
LiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBSaWNoYXJkDQo+IENvY2hyYW4gPHJpY2hh
cmRjb2NocmFuQGdtYWlsLmNvbT47IFZsYWRpbWlyIE9sdGVhbg0KPiA8dmxhZGltaXIub2x0ZWFu
QG54cC5jb20+OyBSdXNzZWxsIEtpbmcgPGxpbnV4QGFybWxpbnV4Lm9yZy51az4NCj4gU3ViamVj
dDogUmU6IFtuZXQtbmV4dCwgdjIsIDIvMl0gZW5ldGM6IHN1cHBvcnQgUFRQIFN5bmMgcGFja2V0
IG9uZS1zdGVwDQo+IHRpbWVzdGFtcGluZw0KPiANCj4gT24gRnJpLCA5IEFwciAyMDIxIDIyOjMy
OjQ5ICswMzAwIENsYXVkaXUgTWFub2lsIHdyb3RlOg0KPiA+IE9uIDA5LjA0LjIwMjEgMTk6MDks
IEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiA+ID4gT24gRnJpLCA5IEFwciAyMDIxIDA2OjM3OjUz
ICswMDAwIENsYXVkaXUgTWFub2lsIHdyb3RlOg0KPiA+ID4+IFBsZWFzZSB0cnkgdGVzdF9hbmRf
c2V0X2JpdF9sb2NrKCkvIGNsZWFyX2JpdF91bmxvY2soKSBiYXNlZCBvbg0KPiA+ID4+IEpha3Vi
J3Mgc3VnZ2VzdGlvbiwgYW5kIHNlZSBpZiBpdCB3b3JrcyBmb3IgeW91IC8gd2hldGhlciBpdCBj
YW4gcmVwbGFjZSB0aGUNCj4gbXV0ZXguDQo+ID4gPg0KPiA+ID4gSSB3YXMgdGhpbmtpbmcgdGhh
dCB3aXRoIG11bHRpcGxlIHF1ZXVlcyBqdXN0IGEgYml0IHdvbid0IGJlDQo+ID4gPiBzdWZmaWNp
ZW50DQo+ID4gPiBiZWNhdXNlOg0KPiA+ID4NCj4gPiA+IHhtaXQ6CQkJCXdvcms6DQo+ID4gPiB0
ZXN0X2JpdC4uLiAvLyBhbHJlYWR5IHNldA0KPiA+ID4gCQkJCWRlcXVldWUgLy8gZW1wdHkNCj4g
PiA+IGVucXVldWUNCj4gPiA+IAkJCQljbGVhcl9iaXQoKQ0KPiA+ID4NCj4gPiA+IFRoYXQgZnJh
bWUgd2lsbCBuZXZlciBnZXQgc2VudCwgbm8/DQo+ID4NCj4gPiBJIGRvbid0IHNlZSBhbnkgaXNz
dWUgd2l0aCBZYW5nYm8ncyBpbml0aWFsIGRlc2lnbiBhY3R1YWxseSwgSSB3YXMNCj4gPiBqdXN0
IHN1Z2dlc3RpbmcgaGltIHRvIHJlcGxhY2UgdGhlIG11dGV4IHdpdGggYSBiaXQgbG9jaywgYmFz
ZWQgb24geW91cg0KPiBjb21tZW50cy4NCj4gPiBUaGF0IG1lYW5zOg0KPiA+IHhtaXQ6CQl3b3Jr
OgkJCQljbGVhbl90eF9yaW5nOiAvL1R4IGNvbmYNCj4gPiBza2JfcXVldWVfdGFpbCgpDQo+ID4g
CQlza2JfZGVxdWV1ZSgpDQo+ID4gCQl0ZXN0X2FuZF9zZXRfYml0X2xvY2soKQ0KPiA+IAkJCQkJ
CWNsZWFyX2JpdF91bmxvY2soKQ0KPiA+DQo+ID4gVGhlIHNrYiBxdWV1ZSBpcyBvbmUgcGVyIGRl
dmljZSwgYXMgaXQgbmVlZHMgdG8gc2VyaWFsaXplIHB0cCBza2JzIGZvcg0KPiA+IHRoYXQgZGV2
aWNlIChkdWUgdG8gdGhlIHJlc3RyaWN0aW9uIHRoYXQgYSBwdHAgcGFja2V0IGNhbm5vdCBiZQ0K
PiA+IGVucXVldWVkIGZvciB0cmFuc21pc3Npb24gaWYgdGhlcmUncyBhbm90aGVyIHB0cCBwYWNr
ZXQgd2FpdGluZyBmb3INCj4gPiB0cmFuc21pc3Npb24gaW4gYSBoL3cgZGVzY3JpcHRvciByaW5n
KS4NCj4gPg0KPiA+IElmIG11bHRpcGxlIHB0cCBza2JzIGFyZSBjb21pbmcgaW4gZnJvbSBkaWZm
ZXJlbnQgeG1pdCBxdWV1ZXMgYXQgdGhlDQo+ID4gc2FtZSB0aW1lIChzYW1lIGRldmljZSksIHRo
ZXkgYXJlIGVucXVldWVkIGluIHRoZSBjb21tb24gcHJpdi0+dHhfc2ticw0KPiA+IHF1ZXVlIChz
a2JfcXVldWVfdGFpbCgpIGlzIHByb3RlY3RlZCBieSBsb2NrcyksIGFuZCB0aGUgd29ya2VyIHRo
cmVhZA0KPiA+IGlzIHN0YXJ0ZWQuDQo+ID4gVGhlIHdvcmtlciBkZXF1ZXVlcyB0aGUgZmlyc3Qg
cHRwIHNrYiwgYW5kIHBsYWNlcyB0aGUgcGFja2V0IGluIHRoZQ0KPiA+IGgvdyBkZXNjcmlwdG9y
IHJpbmcgZm9yIHRyYW5zbWlzc2lvbi4gVGhlbiBkZXF1ZXVlcyB0aGUgc2Vjb25kIHNrYiBhbmQN
Cj4gPiB3YWl0cyBhdCB0aGUgbG9jayAob3IgbXV0ZXggb3Igd2hhdGV2ZXIgbG9jayBpcyBwcmVm
ZXJyZWQpLg0KPiA+IFVwb24gdHJhbnNtaXNzaW9uIG9mIHRoZSBwdHAgcGFja2V0IHRoZSBsb2Nr
IGlzIHJlbGVhc2VkIGJ5IHRoZSBUeA0KPiA+IGNvbmZpcm1hdGlvbiBuYXBpIHRocmVhZCAoY2xl
YW5fdHhfcmluZygpKSBhbmQgdGhlIG5leHQgUFRQIHNrYiBjYW4gYmUNCj4gPiBwbGFjZWQgaW4g
dGhlIGNvcnJlc3BvbmRpbmcgZGVzY3JpcHRvciByaW5nIGZvciB0cmFuc21pc3Npb24gYnkgdGhl
DQo+ID4gd29ya2VyIHRocmVhZC4NCj4gDQo+IEkgc2VlLiBJIHRob3VnaHQgeW91IHdlcmUgY29t
bWVudGluZyBvbiBteSBzY2hlbWUuIFllcywgaWYgb25seSB0aGUgd29ya2VyIGlzDQo+IGFsbG93
ZWQgdG8gc2VuZCB0aGVyZSBpcyBubyByYWNlLCB0aGF0IHNob3VsZCB3b3JrIHdlbGwuDQo+IA0K
PiBJbiBteSBzdWdnZXN0aW9uIEkgd2FzIHRyeWluZyB0byBhbGxvdyB0aGUgZmlyc3QgZnJhbWUg
dG8gYmUgc2VudCBkaXJlY3RseQ0KPiB3aXRob3V0IGdvaW5nIHZpYSB0aGUgcXVldWUgYW5kIHJl
cXVpcmluZyB0aGUgd29ya2VyIHRvIGJlIHNjaGVkdWxlZCBpbi4NCj4gDQo+ID4gU28gdGhlIHdh
eSBJIHVuZGVyc3Rvb2QgeW91ciBjb21tZW50cyBpcyB0aGF0IHlvdSdkIHJhdGhlciB1c2UgYSBz
cGluDQo+ID4gbG9jayBpbiB0aGUgd29ya2VyIHRocmVhZCBpbnN0ZWFkIG9mIGEgbXV0ZXguDQo+
IA0KPiBOb3QgZXhhY3RseSwgbXkgbWFpbiBvYmplY3Rpb24gd2FzIHRoYXQgdGhlIG11dGV4IHdh
cyB1c2VkIGZvciB3YWtlIHVwLg0KPiBXb3JrZXIgbG9ja3MgaXQsIGNvbXBsZXRpb24gcGF0aCB1
bmxvY2tzIGl0Lg0KPiANCj4gWW91ciBzdWdnZXN0aW9uIG9mIHVzaW5nIGEgYml0IHdvcmtzIHdl
bGwuIEp1c3QgSW5zdGVhZCBvZiBhIGxvb3AgdGhlIHdvcmtlcg0KPiBuZWVkcyB0byBzZW5kIGEg
c2luZ2xlIHNrYiwgYW5kIGNvbXBsZXRpb24gbmVlZHMgdG8gc2NoZWR1bGUgaXQgYWdhaW4uDQoN
ClRoYW5rIHlvdSBzbyBtdWNoIGZvciB5b3VyIHN1Z2dlc3Rpb24gYW5kIGd1aWRlLiBTbyBJIHVz
ZWQgYml0IGxvY2ssIGFuZCBhbHNvIGZvbGxvd2VkIEpha3ViJ3Mgc3VnZ2VzdGlvbi4NClRoZSBk
aWZmZXJlbmNlIHdhcywgSSBtb3ZlZCB0aGUgZmxhZyBjbGVhbmluZyBiZWZvcmUgdHJhbnNtaXR0
aW5nIHNpbmdsZSBza2IgZnJvbSBza2IgcXVldWUuDQpPdGhlcndpc2UsIHNrYiBpbiBxdWV1ZSB3
b3VsZCBuZXZlciBiZSB0cmFuc21pdHRlZCBpbiBzdGFydF94bWl0KCkuDQpQbGVhc2UgaGVscCB0
byByZXZpZXcgdjMgSSBzZW50OikNCg0Kd29yazoNCg0KCW5ldGlmX3R4X2xvY2soKQ0KICAgIGNs
ZWFyX2JpdF91bmxvY2soKTsgLy8gcHV0IGNsZWFuaW5nIGhlcmUNCglza2IgPSBza2JfZGVxdWV1
ZSgpOw0KCWlmIChza2IpDQoJCXN0YXJ0X3htaXQoc2tiKQ0KLy8JZWxzZQ0KLy8JCXByaXYtPmZs
YWdzICY9IH5PTkVTVEVQX0JVU1k7DQoJbmV0aWZfdHhfdW5sb2NrKCkNCg0KVGhhbmtzLg0KDQo+
IA0KPiA+ID4gTm90ZSB0aGF0IHNrYl9xdWV1ZSBhbHJlYWR5IGhhcyBhIGxvY2sgc28geW91J2Qg
anVzdCBuZWVkIHRvIG1ha2UNCj4gPiA+IHRoYXQgbG9jayBwcm90ZWN0IHRoZSBmbGFnL2JpdCBh
cyB3ZWxsLCBvdmVyYWxsIHRoZSBudW1iZXIgb2YgbG9ja3MNCj4gPiA+IHJlbWFpbnMgdGhlIHNh
bWUuIFRha2UgdGhlIHF1ZXVlJ3MgbG9jaywgY2hlY2sgdGhlIGZsYWcsIHVzZQ0KPiA+ID4gX19z
a2JfcXVldWVfdGFpbCgpLCByZWxlYXNlIGV0Yy4NCj4gPg0KPiA+IFRoaXMgaXMgYSBnb29kIG9w
dGltaXphdGlvbiBpZGVhIGluZGVlZCwgdG8gdXNlIHRoZSBwcml2LT50eF9za2Igc2tiDQo+ID4g
bGlzdCdzIHNwaW4gbG9jaywgaW5zdGVhZCBvZiBhZGRpbmcgYW5vdGhlciBsb2NrLg0KDQo=
