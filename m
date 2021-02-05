Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFE0310F70
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 19:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbhBEQWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 11:22:53 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:10849 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233688AbhBEQUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 11:20:24 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601d881e0002>; Fri, 05 Feb 2021 10:02:06 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 5 Feb
 2021 18:02:05 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 5 Feb
 2021 17:53:08 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 5 Feb 2021 17:53:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JcVqNpU9bC9/t6wse1zRN/p4yS7delaGXijGAhErunQsEPQGtGbaMhQrKKP1gXCleAdVO77mi58MDMHTNZNDBHdI3THiWpUN64gDGfDf0xty80reR3L3HmVZ/FA4ctM6so9MdfznYxDhXii1FRYzTkGYqpXcAzzgkFb3LEWWSnBIn56wlklj2oQtjtHnhozmBBdaYGSBy6hTqVCMAHLILdsY2PGoayXvQiF2P4vHOh5Ua8V3GhbzZkkx1af2hUalVcbNrNNk3kkAXXzZLAVehrqjmUQXBhTIC7GFTGQ3tgZ0UQ7gZ//MjvmwdHjSBFbSdNFW7x++Ryi7AldqrZeEMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvtgmHIO2Ktpt4+9AbktTde3khU0qliuRjSr+CSWAMQ=;
 b=KnDJpVQQVlYT9PUMXiU7jR/g3nWD5B99WzR+T7TfBIIagMSUHrJ/4fdMGoVghMIwGdSh2h71O7zhjEsG9thixE4AddYMpnA4T5xkmVH3WimyYWocYds8hOZ6PkPGkPw+eSGfQcARtfDaGSv/ThA7dWc8152csvBkb8BnMOUX1Hpkj8L4EMk4MfIh4Li33cMfQySNa9dxLHUwL5K0jWAAbox7+a9khp5Mz24QtVcZDQunvwc+Sto71V6eLv8+DHEU2w87yoMor70aVcJtlKLNJF6uDWJSYmw4hQQPm/vW51kMeQ3r2O1PgzBsgwoXvcKkj2vFNVYv98IZdBr1Up6rqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (52.135.54.148) by
 BYAPR12MB2997.namprd12.prod.outlook.com (20.178.54.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.20; Fri, 5 Feb 2021 17:53:05 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%3]) with mapi id 15.20.3805.033; Fri, 5 Feb 2021
 17:53:05 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>,
        Adrian Moreno <amorenoz@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "mst@redhat.com" <mst@redhat.com>
Subject: RE: [PATCH iproute2-next v3 0/5] Add vdpa device management tool
Thread-Topic: [PATCH iproute2-next v3 0/5] Add vdpa device management tool
Thread-Index: AQHW+U8khpC7NyhaVESImHjo2LWXHapHVaaAgACF2gCAARM1AIAA7PQg
Date:   Fri, 5 Feb 2021 17:53:05 +0000
Message-ID: <BY5PR12MB4322BB72FCC893EB8D4D1B30DCB29@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210122112654.9593-3-parav@nvidia.com>
 <20210202103518.3858-1-parav@nvidia.com>
 <99106d07-1730-6ed8-c847-0400be0dcd57@redhat.com>
 <1d1ff638-d498-6675-ead5-6e09213af3a8@redhat.com>
 <0017c3d7-9b04-d26c-94e2-485e4da6a778@redhat.com>
In-Reply-To: <0017c3d7-9b04-d26c-94e2-485e4da6a778@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a2278db-7ad7-4963-0389-08d8c9fee420
x-ms-traffictypediagnostic: BYAPR12MB2997:
x-microsoft-antispam-prvs: <BYAPR12MB2997A3B2B55AB26324946C01DCB29@BYAPR12MB2997.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ngo1zd/4IuXUKKbJjYJ7vUqm1EjAM89cPVmw9/6Au2lBXjAZyEbjBr+fRPehC7GEYubY4SkmvoBk0r4hIDsY6h3Gvadmrpkp2K39pfrSqlxXqIrMB5Q7eF45mCfTX0f7kJ5nYqnvhbjryOWi688Z+YJc1ITPdfsdFrZBmKFtDFDP2TK4lvUMHQdeMMVPvA+D0BJ1Xv3vBGnpM/6YP2C7c86ZXbPbWl0P+OQldOVN0ZLBKOezg2dPqw7oouX0Cf2tm+m8o8fj7Yye7KGOZXC7inkGx0NHsc2p7xyhzPFMDwWe9ygHdikoR09P30wFUEpydjS6KI9FwoKjqKnzCP3CHSsoWWd+bw4+jVaqiwlSYqhVM3CYyjivg80FEo00/nkRAjlGR8BsUwYb72dL2iri2t7R1dQb2begVNnvq7Q6kDpy6ZxUaWw0Odc0ZVfFoQ4slWWT+leMnOwTptuYpVzKU9qlBk6N6t5ZhmiMc93hhirhIgdsg5n8XFmYxdrpXhPqbjUdAzXf2PijZtI+gtWC9f9QH8YRkX/9IliVHzUbmoLgGUHUDkJCBo2OP543P/QXrVIlv8qEZyf9jkpf0nmxTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(66446008)(83380400001)(316002)(53546011)(64756008)(9686003)(33656002)(66556008)(478600001)(76116006)(66476007)(8676002)(26005)(6506007)(2906002)(966005)(66946007)(8936002)(5660300002)(71200400001)(7696005)(86362001)(186003)(55016002)(110136005)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MVZTTGJVUFU4ZXNhMHdxTFQ5OFRac1RyckF1Z05qczlxaVBFMUFaNENmT3k4?=
 =?utf-8?B?QlVnMFg3U3E4ODBRaFpxTnN2Z29BSVR0WldlSWpKbDBaUU9YOTNvcVQ3dzFX?=
 =?utf-8?B?R01UWXNUcUtpcHlFVngxeVhWRnJiL1hTT0xkVXcvaFBkbTBEa0JLWVdYRVdK?=
 =?utf-8?B?QWxvS3pGS0Vxb0VOMUE1MVFDWnJUQm9wT1dFTzJDQ0NxYTNtK0dZamc5Q2d2?=
 =?utf-8?B?SVhSY2UyeklOUGtHNzJOWXZCMm9tQWgydjI2eXF1d3Jxbld2VTZUN2JLR0pm?=
 =?utf-8?B?VlFsak9KRnMzYUxpelZhTEdIcnRPbkRWRmE4ZE41cHE2d2RDbzhxOTREN3ZX?=
 =?utf-8?B?ZnFOcFhHMTZVdGtuNllTWW1HODZ5RUZYZzBBMzlrV1U1R1dNUnBDWWlmSmxj?=
 =?utf-8?B?a3Rud2dUQ2ZibUFadE5UeWR6Ukd4aFQvQUMvbEkwQ1RGVFlsTHlnNXh4L1lQ?=
 =?utf-8?B?cW1Ua0JIbnArWTFXa0hDQlBMNWh2UHQyWllyQ1hlTDdoYUNxNFFveVVqQUND?=
 =?utf-8?B?S1hkMThEMVBMWWpRNUtGYUgwZ0NOSFNGL3RoK0hCQ1Foc2oxZEtpSm14Mk92?=
 =?utf-8?B?QnhLcGMwNUd2MkN6SmFRb0g1N3BteVRjWTZ6cnlaWWxXc1FmK092TWxTdER0?=
 =?utf-8?B?S1NpWWgrS3hRNnNwWXE1N0xxUjFZdGt4WVlxSmlSam5PeERNMzV2VkpHV0k3?=
 =?utf-8?B?Qndjc1dnaXQyVitQbVdjaUVCQWRJY1A2WnBTZDVRWU5VUi9zazQxMS9uaTls?=
 =?utf-8?B?T3RYdkRNL3hlZ0JGSUJRN0VNcFJwMjNGSWxPMFl1R3hiV1BoOElJSTlOQVFH?=
 =?utf-8?B?WG0vR3ZyR0cwb2J1NnA1UWRnVklRK1pFZ2hGcDNzSW5jOVRCSWZpcVdyQys0?=
 =?utf-8?B?R05oQ2JtbmJzZmRtSjh3clluM2pnL0NjejRuL1FCb1I0dnpPNVltYzF1ZExJ?=
 =?utf-8?B?TmRDSkJ0OWFxRVBTdHVYSnQzaG5nSG5WaVNOMjZoUmlLTjhzSEdxTjl4UU9T?=
 =?utf-8?B?c2ZSdFkyaXROa0hpL3ZTVlpBNWJoRE9vd0dPRkNDNlU4MStxWitXcDJlMi8y?=
 =?utf-8?B?K0pNNC9XekhPWmNoTFNHaUkyOTVEYmVJQktNaEdENTZTQ2psMlJpWllJSW1o?=
 =?utf-8?B?SmlhVXlocWFYOHNKclJXZXZpYWs0RC9sU0N6L2NTOVJjOVZYTGJLd1pJemRI?=
 =?utf-8?B?b3BxWStWeTU4cnk4WlNRRW9Ubk9qdmJXK2FHdHB2cVE3bHlJZnpEUzNDS2FU?=
 =?utf-8?B?OWViZWVtMmFiZFlDaW1WTllkSXByMXdiZmFLTDh4Mk5rYW02dVFoUHV0OUNB?=
 =?utf-8?B?R1B4TXQ1enVIcXhSTmF6a1B6Nmx1OHlxejRwbzlTeUlITE1PTzJTeGtzb3pt?=
 =?utf-8?B?NVZYNmNLZmJoOE11Zk9PcjJKejRSMlp1KzJQYktDUms1eG9EOHRwQ3JRL253?=
 =?utf-8?B?eXM2K0FNN0J0eGxSZ0YrQ1haSVN2aDJqT0JOR1ZpSlM4NDltdlVrNU5OVERB?=
 =?utf-8?B?RlRRMnY3eG9kd0Z5TEFSUDhSa2tGWDE4U2dGRVFmVDlJcUZYSWZVd05XM3dn?=
 =?utf-8?B?MFVIbVhYTUp5UGFQRGJUK3hveWpqN1ZnOWExRkxnZVpYOWhQeUhqS1R4b3Z2?=
 =?utf-8?B?aXRHV0hJbVd5RmorRE01eEQzN3NVVW90WUJUSWQ3dy9PcDcrWm1HVStjQ09O?=
 =?utf-8?B?NGdvWW03N2VUOFZqQlh3OW1Xaks2ZHpLMUF4S0N3UWc1Y1dMaUt3bUdjcmlT?=
 =?utf-8?Q?rtgWVksYSCrgqozywHh8TZzivClQd0axnr6o+EP?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a2278db-7ad7-4963-0389-08d8c9fee420
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2021 17:53:05.7073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bcZe9mj+QUAOSGZd/pCZR2iD3Lm3GZtH6WOBLs7RqvxloG7aKNhsBL1kbbEa7IOqpbq1Xs1BCV5ZdOD7dHWVlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2997
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612548126; bh=nvtgmHIO2Ktpt4+9AbktTde3khU0qliuRjSr+CSWAMQ=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:x-header:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         x-ms-exchange-transport-forked:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=ZIllTSZtqIsqJTKowLImWKk6ARR/+5/0jLbQh4Bqip8JN8GM8XWFx/Ek2PMFowdiv
         8E30sg0E4Sk+uPGM0v9xYdJ+PdW6Vk9z6P5Ao4R2o+7p5zo/0i+tc1Znu3X1Za6yB5
         +H9a6/bLpQWY94Ek9YriZXGPnZGZJGFZNjFyykuCEeHRGgndheacQj7Pz4MPzLW4+q
         /TuvZJyYVI4ZDrKhJT82PB64cHKwRDAAiIhJ1OUBCKFzC4i5xtAw+vrhi7euUfZwvt
         3KdEYs2v8OsH8vatmTXAcHW22DHTmffNJqDOm6Nrd2zJD7IOTgtEQ6Mh4jh6lPz5BN
         m2Tw4qboNlOdg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gU2VudDogRnJp
ZGF5LCBGZWJydWFyeSA1LCAyMDIxIDk6MTEgQU0NCj4gDQo+IA0KPiBPbiAyMDIxLzIvNCDkuIvl
jYg3OjE1LCBBZHJpYW4gTW9yZW5vIHdyb3RlOg0KPiA+IFNvcnJ5IEkgaGF2ZSBub3QgZm9sbG93
ZWQgdGhpcyB3b3JrIGFzIGNsb3NlIGFzIEkgd291bGQgaGF2ZSB3YW50ZWQuDQo+ID4gU29tZSBx
dWVzdGlvbnMgYmVsb3cuDQo+ID4NCj4gPiBPbiAyLzQvMjEgNDoxNiBBTSwgSmFzb24gV2FuZyB3
cm90ZToNCj4gPj4gT24gMjAyMS8yLzIg5LiL5Y2INjozNSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0K
PiA+Pj4gTGludXggdmRwYSBpbnRlcmZhY2UgYWxsb3dzIHZkcGEgZGV2aWNlIG1hbmFnZW1lbnQg
ZnVuY3Rpb25hbGl0eS4NCj4gPj4+IFRoaXMgaW5jbHVkZXMgYWRkaW5nLCByZW1vdmluZywgcXVl
cnlpbmcgdmRwYSBkZXZpY2VzLg0KPiA+Pj4NCj4gPj4+IHZkcGEgaW50ZXJmYWNlIGFsc28gaW5j
bHVkZXMgc2hvd2luZyBzdXBwb3J0ZWQgbWFuYWdlbWVudCBkZXZpY2VzDQo+ID4+PiB3aGljaCBz
dXBwb3J0IHN1Y2ggb3BlcmF0aW9ucy4NCj4gPj4+DQo+ID4+PiBUaGlzIHBhdGNoc2V0IGluY2x1
ZGVzIGtlcm5lbCB1YXBpIGhlYWRlcnMgYW5kIGEgdmRwYSB0b29sLg0KPiA+Pj4NCj4gPj4+IGV4
YW1wbGVzOg0KPiA+Pj4NCj4gPj4+ICQgdmRwYSBtZ210ZGV2IHNob3cNCj4gPj4+IHZkcGFzaW06
DQo+ID4+PiAgwqDCoCBzdXBwb3J0ZWRfY2xhc3NlcyBuZXQNCj4gPj4+DQo+ID4+PiAkIHZkcGEg
bWdtdGRldiBzaG93IC1qcA0KPiA+Pj4gew0KPiA+Pj4gIMKgwqDCoMKgICJzaG93Ijogew0KPiA+
Pj4gIMKgwqDCoMKgwqDCoMKgwqAgInZkcGFzaW0iOiB7DQo+ID4+PiAgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgICJzdXBwb3J0ZWRfY2xhc3NlcyI6IFsgIm5ldCIgXQ0KPiA+Pj4gIMKgwqDCoMKg
wqDCoMKgwqAgfQ0KPiA+Pj4gIMKgwqDCoMKgIH0NCj4gPj4+IH0NCj4gPj4+DQo+ID4gSG93IGNh
biBhIHVzZXIgZXN0YWJsaXNoIHRoZSByZWxhdGlvbnNoaXAgYmV0d2VlbiBhIG1nbXRkZXYgYW5k
IGl0J3MNCj4gPiBwYXJlbnQgZGV2aWNlIChwY2kgdmYsIHNmLCBldGMpPw0KPiANCj4gDQo+IFBh
cmF2IHNob3VsZCBrbm93IG1vcmUgYnV0IEkgdHJ5IHRvIGFuc3dlci4NCj4gDQo+IEkgdGhpbmsg
dGhlcmUgc2hvdWxkIGJlIEJERiBpbmZvcm1hdGlvbiBpbiB0aGUgbWdtdGRldiBzaG93IGNvbW1h
bmQgaWYNCj4gdGhlIHBhcmVudCBpcyBhIFBDSSBkZXZpY2UsIG9yIHdlIGNhbiBzaW1wbHkgc2hv
dyB0aGUgcGFyZW50IGhlcmU/DQo+DQpZZXMsIGl0IGlzIHByZXNlbnQgaW4gdGhlIG1nbXRkZXYg
c2hvdyBjb21tYW5kLg0KSSBzaG91bGQgaGF2ZSBhZGRlZCB0aGUgZXhhbXBsZSBmcm9tIHRoZSBr
ZXJuZWwgY292ZXIgbGV0dGVyIGhlcmUuDQpMaW5rIHRvIHRoZSBrZXJuZWwgY292ZXIgbGV0dGVy
IGlzIGF0IA0KDQpBbiBleGFtcGxlIGZvciByZWFsIFBDSSBQRixWRixTRiBkZXZpY2UgbG9va3Mg
bGlrZSBiZWxvdy4NCkkgd2lsbCBjb3ZlciBiZWxvdyBleGFtcGxlIHRvIHRoZSB2NCBjb3ZlciBs
ZXR0ZXIgd2hpbGUgYWRkcmVzc2luZyBEYXZpZCdzIGNvbW1lbnQgZm9yIGhlYWRlciBmaWxlIHJl
bG9jYXRpb24uDQoNCiQgdmRwYSBtZ210ZGV2IGxpc3QNCnBjaS8wMDAwOjAzLjAwOjANCiAgc3Vw
cG9ydGVkX2NsYXNzZXMNCiAgICBuZXQNCnBjaS8wMDAwOjAzLjAwOjQNCiAgc3VwcG9ydGVkX2Ns
YXNzZXMNCiAgICBuZXQNCmF1eGlsaWFyeS9tbHg1X2NvcmUuc2YuOA0KICBzdXBwb3J0ZWRfY2xh
c3Nlcw0KICAgIG5ldA0KDQpbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2LzIwMjEw
MTA1MTAzMjAzLjgyNTA4LTEtcGFyYXZAbnZpZGlhLmNvbS8NCg==
