Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D2758F996
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 10:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbiHKIy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 04:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbiHKIyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 04:54:25 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80059.outbound.protection.outlook.com [40.107.8.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449E891D08
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 01:54:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfJkxReecEXg1Ez9GJ0WVPwztozYAHvO+XjlL5xlyGMp4oIWLz+LF8QMePahX0sohquvqEGT0HEKIEOvwuLPDPAM2e5HB4VkD8wR6KKfSnGbm8URk9CXYV3Z1LdspOK0PaZ2jJ+suO1OMxcjRxt5yRM6GUSF4imw+bR/pyooVUX5HIhP5HPoj35fgh2b0Iog34cVKMaswNpT+7TzS7MU/svjFNxa+T6qPtmxBVNyHOmv+CmtMgP/W503LHLgT02mao8MXV+FO4W7ZtRXXPmdyaLFSPN7Vkf3bozYD9or3XTeU/SdCi4OScYm2LeYQgwfSQTCCIT03NnfUPpUvE+c6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8RjhPKRlkb434Al9yHTUyqtUURpHyk/q1TNXrlw5Q4E=;
 b=WmcEGHCMybC1bmZPOdQAr7oer7J0DTs3KVTWQH7CnX40j6FsGy05BwlwG8E7b7o0+FTWWzAiQiSI8jvr2drtLYf3RH/DSse3gTfxnAidamOkjdAlHsIQ273zwv0Kfh+BO/tkJVq7GxW2vP6e8zP6K2Af237q57j6snVgi5UKfQQHjfrxEx436LJiwgFd7nseWspRm+7JVVUp4P2xaJENvWJIpujisWJTOHQ9209frVKDPeGcM1Va8aKDhNZzWYpHtpGqa+wQPMrsWDA1p2TnOjgKstHCEx6emNs21YH8159AgPa5/hBcYvGm8Npzhjxn/HqEjbCbkz88xyJ+1er/xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RjhPKRlkb434Al9yHTUyqtUURpHyk/q1TNXrlw5Q4E=;
 b=IWu8KKGN0JCGO1YjGTvpqhvHWwyMSbfWR+XUYr2mSMsXv0KQqm3/BlHi3mjaZLvks4Y0V5b1vjmERwU/Y2mheZV/aVC1Q4KbnEMYtI78Q5ZasXmMtUSod2KuOX5lb9K0vf6CsahOpp3caY2MtDgHgIzJDIZNgum7H6ARDigJA2E=
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com (2603:10a6:803:29::11)
 by AM8PR07MB7363.eurprd07.prod.outlook.com (2603:10a6:20b:248::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.7; Thu, 11 Aug
 2022 08:54:20 +0000
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::dd4a:cda1:59f2:a19a]) by VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::dd4a:cda1:59f2:a19a%5]) with mapi id 15.20.5525.010; Thu, 11 Aug 2022
 08:54:20 +0000
From:   Ferenc Fejes <ferenc.fejes@ericsson.com>
To:     "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "marton12050@gmail.com" <marton12050@gmail.com>,
        "peti.antal99@gmail.com" <peti.antal99@gmail.com>
Subject: Re: igc: missing HW timestamps at TX
Thread-Topic: igc: missing HW timestamps at TX
Thread-Index: AQHYmepVJYOkQdQn8k+cRlOb7lKNfK2Cowk2gAGTfACAARs4gIAkOlGA
Date:   Thu, 11 Aug 2022 08:54:20 +0000
Message-ID: <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
References: <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
         <VI1PR07MB4080DC45051E112EEC6D7734E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
         <87tu7emqb9.fsf@intel.com>
         <695ec13e018d1111cf3e16a309069a72d55ea70e.camel@ericsson.com>
In-Reply-To: <695ec13e018d1111cf3e16a309069a72d55ea70e.camel@ericsson.com>
Accept-Language: hu-HU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ericsson.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85a833c5-e46a-467a-d047-08da7b7714e5
x-ms-traffictypediagnostic: AM8PR07MB7363:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f9NYzKlA03UyAozy4sdgFvdRx8DNDR8YhsRrz+qni/iBYdENPnlD90LQQ+UaiI0cwe7pDL4zIc/SRFrYWxxBrMtp7QXJNIwSZ4z1IZddvyn9sWrim+ZzzuSTXt14E82CepDrCyVx0RvI2gpu+e+AbsdciMnK8eXMDCXMy0LisBf1MUcgqF5ESf5oxf4/gNwE8+JVjZdD0VRYYav/SIVIrfzrrX1kplIIIugqXqjKIDEtHobKpJlU8EfxoHeULNAgfv1Nx698VBRlr6q8BZM1ZA6wbL9/dlU0h1XK/tKk3BwsyWpg7asVaSoWYAWApMbP+qKvfCVyDaUbnU8AipeVfKs8vAqETv9LOeAeP5QpYRuiZY0OJR2UVSeVFAP5EJLSPgWvfDvxb4CvB/YkAKNgHGtb9fMmMCc7i6mlbkxXo/X4TQX50upGNZ3xLt72MWDmpPpuTOfdRRiLvoVBLtwtcQFiYJfjBxfxfKBOjiri0eIUAti0rPO1Ut7diMEORVqGRo97+ucwx0gk/HThEMepfAMHOQq4lWgzp8IUGgliwNtHhwOk12RcnQgz1nIPB3Qt2+2OlPJl5BtjWS8LOv/tPgmlVjM6ZsjEKzt6V/c5QodnjZD/Q0Vo+uidEH/boOXStTyu21hl3NoMc4kjLqChlSPFfLbgbogiDvZtcv0JJAO+g6RVsA/4/4qzilrUarJ0IGxkw8ZmxV+Xoe1H6uRmRuwK6ilL3O3mONgsi1zlTTpJtiC67cY8GgQ9uk4wL5FrEW+svYp4r/cD2TB5/wEEMZkjVHe6EmR3nJ5pUFZUKdmVJSsXY564p5wEbr04DTlmndwhaKcRSUCN/2EUvlkMyw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR07MB4080.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(26005)(6512007)(38070700005)(122000001)(36756003)(2906002)(5660300002)(44832011)(38100700002)(71200400001)(86362001)(6506007)(8936002)(82960400001)(66446008)(91956017)(110136005)(54906003)(316002)(83380400001)(41300700001)(478600001)(4326008)(66946007)(186003)(6486002)(8676002)(64756008)(66476007)(66556008)(76116006)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MGoyVUI3cGFwejVDbjJPR2VhdkY2eERwK2NlWW8vSlJOWExleDMvS25GQzVq?=
 =?utf-8?B?eVJsRzhwRmpIVjU5c1AxK2t6Wm9UNWlHbjk4a09OYWZydlJ1ZXROZmVKU2xV?=
 =?utf-8?B?aUtKZXBEK05HRGpsRXJ4Rm9uVEZ4WDE4NnJkeng0eFVKaG9wT2ZXWXpRYWVO?=
 =?utf-8?B?T0gwdjNBY2kyNS9sd0VmY2d6U2ErOEN5aFBNR3pJWFYrWnJYbkdrV3g2T0I5?=
 =?utf-8?B?cjZFTElFRm9rL2ZITm5CWFFBYkYycXZnTVljN0t6eU5Ya1hqWU1KSTBvVEtT?=
 =?utf-8?B?d2xSQzVacEJiRFdmQjhkeTNpUVJIYVZITlBwU3JNcEdxaklva0ZZNWl4ZDRt?=
 =?utf-8?B?Q1hVek04OWV6em5pWVo1L2dxelVieklLL1AvMjc5ZGJvYW5pRGwzWFdBdWlq?=
 =?utf-8?B?Ym5rR092eGYrNzBkZXNUbDU1dU9oOFlqR2tCSGw2WTBDNjZPS1NoUWdWR1hw?=
 =?utf-8?B?RjVBaElMU3JldittVE9nT0hHZTVMNlRteTN0dGRTUjliNlV3NWNWQVdmRzg5?=
 =?utf-8?B?RWdLWnNxdUx0S2xsZlArTjFiYldUS3l3TzFnWmFIL25QZ1VtUlJkQXJndkhW?=
 =?utf-8?B?MGlycHNJM09OWWlEdzY4djlzdGJUSWx2ZEVUT0J0WFp5bDExSk0wWHVsRUFH?=
 =?utf-8?B?Mlk4blBlcVM1ZWxEZTk3Z0lQZWJERUJ4K1JOR2V4QlUwZ1JBV3dLNS9JTGFt?=
 =?utf-8?B?bzYvY2d0MFRvQm5CZEpwQjJvbkhyQ2pHa29hR2x3UmFMWHBIVi9ub2dONWNy?=
 =?utf-8?B?L0VvVDBMT1hnb0JjWWlaa3hVTWk1c1QvOWtpMllkQ1UySTBBK0h6Rkw5N3R3?=
 =?utf-8?B?SHBJVXlKbzVheHU3T1ZSajN1MEI5d2VrYXVUa1lkTTh1VU1MVDYxTGRFNHdM?=
 =?utf-8?B?TUJmVitndTF6b3RiZ0tEQ3psczdOYlNSeWlCQml1ai9Wdm5TbUFmcVMxYmpP?=
 =?utf-8?B?OUkwV1N0SWtGL0I1TGlWa0xsZmE2Unc0Szl3cEt2U2FqZXdaSGF4RnVuTVVz?=
 =?utf-8?B?SEZqSnNqbm15VHNEMFQwZk8yeVViZXYwc0xNTWJOK3FXNDNYVWJCN29FWDlm?=
 =?utf-8?B?L3NIRENPWTVZK0NCaTJDZG5hZnVwVHVZM0QvVldZUllEUnZPYlNTdXQ4OWta?=
 =?utf-8?B?ZWNnNXJlWUN6ZFFGZDhZV0JIU2JuVm9jaVc1RTdyMzYyR0tOV0pGUUx6ZFdk?=
 =?utf-8?B?UWIvZ21CYk44SDhuNmgrL0kwL2Rhek9OTGtkdXZ4VDJuQXVKM212eno1S1p0?=
 =?utf-8?B?S0NKZGw2K1hBWnhpY3NvdTdoVTZkdndWWDJLSlF0WkswUG5XOEJNQWN4d0Zm?=
 =?utf-8?B?bGRGMXI4cDdmSEVqRWhvUndGRndXeTN2RXFlaUh1OVY4UHI0T3ZEU3FWZXZI?=
 =?utf-8?B?TkpHODJuQ09zWWo2eFRYKzFTVWt5aHRkcytQQVFmKzdsTkZ4UStac0lLMG5z?=
 =?utf-8?B?RC9wTjl5RGNWRzl5VGIzb29RRk5MdUtYbUxCVVMrR09mcm5HakNWSVJ5ckV4?=
 =?utf-8?B?czBIZExMeGpmV0I1Y0tNRU5qUWxqbFlaVURrYmNHRUc1TllZaUlkS3VtQ2FB?=
 =?utf-8?B?MDM4T1ZieHVwMTVSVWdLRWc1OHBEUTJqN0tSVm1mTnlFTXlsWk1DS1FrQ3pv?=
 =?utf-8?B?cWlVMkR6dU5pd3pLVUdBUkk1Z3hzMjVwOXRTSWIxZVlvMXlxY2VBb3Z5ZGlv?=
 =?utf-8?B?ZXo5SmNJWjUzakRNT0lidHlVTFB5UEthKzlRalZVbDAzbzJ2WmhPVHpITWM4?=
 =?utf-8?B?OEQxbVBTbFRmcUJPSzIxRlFXSkkwbm1VdVZiQTJqZlZUTythNnpHaHMrVHB2?=
 =?utf-8?B?WXErNVV2U0pDV0NjR2NUTWxmS3Yzbktnbm5uMVJmKzFtaFVNam5wbVlzVmN3?=
 =?utf-8?B?eGc2aUZMNFVKTEFhTG9EU1p4dm5UTDlaZkFiejRLazBVN0xzS1l0ejFaVndv?=
 =?utf-8?B?aVhMYzJDUTFySXI1cys2Wlc3RGhDMHd5Z2lKdUh3dytic3BYWVRnc3VZOGVD?=
 =?utf-8?B?WVNtMjJoSVdFcFdjOHR2RGhvMUUvaFhudS96OXRwcFlsdVZFcDQ1RHVNZTEy?=
 =?utf-8?B?a0RyelpENzRaR2JwNGN5Tmh6cW5hT2pRZFovbWZ5a1l3Y2U4Z2RjemdDVkts?=
 =?utf-8?B?YnpSWnNZVnpTMDQ3b1d6QWdIbG5QVG5CdGk4eTBodHBTQ3Q1MjEzenp6N1RH?=
 =?utf-8?B?emc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8DE2C52FC3464F4EB1029913F479B214@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR07MB4080.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85a833c5-e46a-467a-d047-08da7b7714e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2022 08:54:20.7964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UPWTsOZ1L1rGlNubThBKKcOz2u4U4icrygNrxVieUiiyF2+AsmorYV0JC5F7k5DfEnya4cDU0V9fdxamqlc0Aom09ql96Q0ChPkZt152h/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR07MB7363
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmluaWNpdXMhDQoNCk9uIFR1ZSwgMjAyMi0wNy0xOSBhdCAwOTo0MCArMDIwMCwgRmVqZXMg
RmVyZW5jIHdyb3RlOg0KPiBIaSBWaW5pY2l1cyENCj4gDQo+IE9uIE1vbiwgMjAyMi0wNy0xOCBh
dCAxMTo0NiAtMDMwMCwgVmluaWNpdXMgQ29zdGEgR29tZXMgd3JvdGU6DQo+ID4gSGkgRmVyZW5j
LA0KPiA+IA0KPiA+IEZlcmVuYyBGZWplcyA8ZmVyZW5jLmZlamVzQGVyaWNzc29uLmNvbT4gd3Jp
dGVzOg0KPiA+IA0KPiA+ID4gKEN0cmwrRW50ZXInZCBieSBtaXN0YWtlKQ0KPiA+ID4gDQo+ID4g
PiBNeSBxdWVzdGlvbiBoZXJlOiBpcyB0aGVyZSBhbnl0aGluZyBJIGNhbiBxdWlja2x5IHRyeSB0
byBhdm9pZA0KPiA+ID4gdGhhdA0KPiA+ID4gYmVoYXZpb3I/IEV2ZW4gd2hlbiBJIHNlbmQgb25s
eSBhIGZldyAobGlrZSAxMCkgcGFja2V0cyBidXQgb24NCj4gPiA+IGZhc3QNCj4gPiA+IHJhdGUg
KDV1cyBiZXR3ZWVuIHBhY2tldHMpIEkgZ2V0IG1pc3NpbmcgVFggSFcgdGltZXN0YW1wcy4gVGhl
DQo+ID4gPiByZWNlaXZlDQo+ID4gPiBzaWRlIGxvb2tzIG11Y2ggbW9yZSByb2JvdXN0LCBJIGNh
bm5vdCBub3RpY2VkIG1pc3NpbmcgSFcNCj4gPiA+IHRpbWVzdGFtcHMNCj4gPiA+IHRoZXJlLg0K
PiA+IA0KPiA+IFRoZXJlJ3MgYSBsaW1pdGF0aW9uIGluIHRoZSBpMjI1L2kyMjYgaW4gdGhlIG51
bWJlciBvZiAiaW4gZmxpZ2h0Ig0KPiA+IFRYDQo+ID4gdGltZXN0YW1wcyB0aGV5IGFyZSBhYmxl
IHRvIGhhbmRsZS4gVGhlIGhhcmR3YXJlIGhhcyA0IHNldHMgb2YNCj4gPiByZWdpc3RlcnMNCj4g
PiB0byBoYW5kbGUgdGltZXN0YW1wcy4NCj4gPiANCj4gPiBUaGVyZSdzIGFuIGFkaXRpb25hbCBp
c3N1ZSB0aGF0IHRoZSBkcml2ZXIgYXMgaXQgaXMgcmlnaHQgbm93LCBvbmx5DQo+ID4gdXNlcw0K
PiA+IG9uZSBzZXQgb2YgdGhvc2UgcmVnaXN0ZXJzLg0KPiA+IA0KPiA+IEkgaGF2ZSBvbmUgb25s
eSBicmllZmx5IHRlc3RlZCBzZXJpZXMgdGhhdCBlbmFibGVzIHRoZSBkcml2ZXIgdG8NCj4gPiB1
c2UNCj4gPiB0aGUNCj4gPiBmdWxsIHNldCBvZiBUWCB0aW1lc3RhbXAgcmVnaXN0ZXJzLiBBbm90
aGVyIHJlYXNvbiB0aGF0IGl0IHdhcyBub3QNCj4gPiBwcm9wb3NlZCB5ZXQgaXMgdGhhdCBJIHN0
aWxsIGhhdmUgdG8gYmVuY2htYXJrIGl0IGFuZCBzZWUgd2hhdCBpcw0KPiA+IHRoZQ0KPiA+IHBl
cmZvcm1hbmNlIGltcGFjdC4NCj4gDQo+IFRoYW5rIHlvdSBmb3IgdGhlIHF1aWNrIHJlcGx5ISBJ
J20gZ2xhZCB5b3UgYWxyZWFkeSBoYXZlIHRoaXMgc2VyaWVzDQo+IHJpZ2h0IG9mZiB0aGUgYmF0
LiBJJ2xsIGJlIGJhY2sgd2hlbiB3ZSBkb25lIHdpdGggYSBxdWljayB0ZXN0aW5nLA0KPiBob3Bl
ZnVsbHkgc29vbmVyIHRoYW4gbGF0ZXIuDQoNClNvcnJ5IGZvciB0aGUgbGF0ZSByZXBseS4gSSBo
YWQgdGltZSBmb3IgYSBmZXcgdGVzdHMsIHdpdGggdGhlIHBhdGNoLg0KRm9yIG15IHRlc3RzIGl0
IGxvb2tzIG11Y2ggYmV0dGVyLiBJIHNlbmQgYSBwYWNrZXQgaW4gZXZlcnkgNTAwdXMgd2l0aA0K
aXNvY2hyb24tc2VuZCwgVFggU1cgYW5kIEhXIHRpbWVzdGFtcGluZyBlbmFibGVkIGFuZCBmb3Ig
MTAwMDAgcGFja2V0cw0KSSBzZWUgemVybyBsb3N0IHRpbWVzdGFtcC4gRXZlbiBmb3IgMTAwMDAw
IHBhY2tldHMgb25seSBhIGZldyBkcm9wcGVkDQpIVyB0aW1lc3RhbXBzIHZpc2libGUuDQoNCldp
dGggaXBlcmYgVENQIHRlc3QgbGluZS1yYXRlIGFjaGl2ZWFibGUganVzdCBsaWtlIHdpdGhvdXQg
dGhlIHBhdGNoLg0KDQo+ID4gDQo+ID4gSWYgeW91IGFyZSBmZWVsaW5nIGFkdmVudHVyb3VzIGFu
ZCBmZWVsIGxpa2UgaGVscGluZyB0ZXN0IGl0LCBoZXJlDQo+ID4gaXMNCj4gPiB0aGUgbGluazoN
Cj4gPiANCj4gPiBodHRwcyUzQSUyRiUyRmdpdGh1Yi5jb20lMkZ2Y2dvbWVzJTJGbmV0LW5leHQl
MkZ0cmVlJTJGaWdjLQ0KPiA+IG11bHRpcGxlLXRzdGFtcC10aW1lcnMtbG9jay1uZXcNCj4gPiAN
Cg0KSXMgdGhlcmUgYW55IHRlc3QgaW4gcGFydHVjdWxhciB5b3UgaW50ZXJlc3RlZCBpbj8gTXkg
dGVzdGJlZCBpcw0KY29uZmlndXJlZCBzbyBJIGNhbiBkbyBzb21lLg0KDQo+ID4gDQo+ID4gQ2hl
ZXJzLA0KPiANCj4gQmVzdCwNCj4gRmVyZW5jDQoNCkJlc3QsDQpGZXJlbmMNCg0K
