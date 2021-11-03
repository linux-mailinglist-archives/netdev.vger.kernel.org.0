Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF6F443E9F
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 09:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbhKCIxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 04:53:18 -0400
Received: from mail-dm6nam10on2064.outbound.protection.outlook.com ([40.107.93.64]:55681
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231910AbhKCIxM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 04:53:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uj9n/ut9c0ondrlvK50SjxA070LR6aBf+qa+bQM6B69Gm8psM1JOHtIsFGysCGraf3vRNnXRB3e4pLUPfUKYxLxx3h220zAPuhDn0fB/jMLkLgUeat4UA9fUOkAQmmU01iFUDrVYF9F9eto3eAO85GOxjPnFpPllQ1y9WjzZD34mq4yBKI8iCWtuaSV780atLp9k7g9T0lizNkwUjRhsr8NJgZ/XZ6CZ3eler1lqc7OIgpIKVlg+J8Og2xXP3pTK+tgWGkMqebGe/cm5waHXGfAyFCdiHZSLyfl12Q6asLelPb39bX+CG+F37mLFdX4Z+XbtXDUb6dGmEdPlWtSXjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YaTu7bSoOXRyVL4wOCAaWejv/q5R+ldBz+vs4ZFdFe8=;
 b=hrO53FqDGsBuFN5Y7Zw3QQIOqCXb6HaHuTCB3yRmG9TLUPXrvdgdLXf/FSIXhCr1tXjSWQb4Pdth5+yb3ibesRp3/CfTbsMWX6/Y3iQQKif0ST4WcXRrhWFk9Rg6MB36MkS3tGh9zUD/Q5H6Fs7Qs8+eueTJaTY0/tceRJ0kRhUW3yvsen7Qkv02CMLAI0PeiAxrZY1fUzP8rgq5ytXYCpIyJpal309r+9UoZcFrUvXTOD4DU5LF1QrW2dnZy/jJsuhsTNasteAFyqglV8k8aSpiePgdlGBIA6CxD9m6aSfQsDWRTutbokmMBnSOlEGhwu+U3ntJN3Mia+NIE0ghpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YaTu7bSoOXRyVL4wOCAaWejv/q5R+ldBz+vs4ZFdFe8=;
 b=Tm23iQSZrDvdUNhTznviewS7k4gm0NaefHm9lvoDwFcARkEKZHDjnVXNefSxDEziYJ0eH9arEjyyxPafv7QSVRUZVqrXiZt6F76WPqWCRVqzwLij+9Upyh5gMqUq4gCYtCcHtILGZUkBhNFIbGF9FFq2Hcpu8sy4+5mf+MDWsi4=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by SN6PR02MB5405.namprd02.prod.outlook.com (2603:10b6:805:e2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Wed, 3 Nov
 2021 08:50:31 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::4513:36a7:3adf:3b0f]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::4513:36a7:3adf:3b0f%6]) with mapi id 15.20.4649.020; Wed, 3 Nov 2021
 08:50:31 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
CC:     Michal Simek <michals@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>
Subject: RE: mdio: separate gpio-reset property per child phy usecase
Thread-Topic: mdio: separate gpio-reset property per child phy usecase
Thread-Index: AdfLMkaiDAtsCpNITLKzSmdhMK2gugAJEiEAAU2SxjA=
Date:   Wed, 3 Nov 2021 08:50:30 +0000
Message-ID: <SA1PR02MB8560936DB193279B2F2C5721C78C9@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <SA1PR02MB85605C26380A9D8F4D1FB2AAC7859@SA1PR02MB8560.namprd02.prod.outlook.com>
 <64248ee1-55dd-b1bd-6c4e-0a272d230e8e@gmail.com>
In-Reply-To: <64248ee1-55dd-b1bd-6c4e-0a272d230e8e@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c9a47d5-b094-4a8e-8b1e-08d99ea6fe01
x-ms-traffictypediagnostic: SN6PR02MB5405:
x-microsoft-antispam-prvs: <SN6PR02MB5405BC0A86C6F8F1DFA993E4C78C9@SN6PR02MB5405.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Onw30VSqi2lFhFtck8JZhA4SdDJgCYTBoIzgO+G3Z5hjQ0CnUlbxCuovTM49GSsIfIgqoHlfo3kXlsIPuUSYPg2RwSz2h3PVUXMCkLMAn5jK7hpH9U0ikMfCbtkbajW5sSB4CiQ9UxXTMYsZEfgAzXmxviRyOUwJiI6O+VPo4MJFuTkNBh7CTFxFdCV+2kPkY9tYFkB36+iQAFuY/El9Q+/KhzvqMGQFIJOR+OUhMaaks50Bxo1OfOzvb515DLDWlCCbYtScnyohzmI3THGh8TzL1t1regHMkNQqiclgf8pt8QPbSX45kSyQZKdBP40wxAut443+wTQzqYviZjmHTTjEqvNBb2ZhIvukNvIhjYnYKLsfwvQ0ZNLWVYlx4CT27pKAy8/4o1RSBTTxb3lPp546vKECoNATxHhBd2vEa6qFb0oYWUFkZk2L3GAilp6dlT88lPY89uy0pbJw1FN29RCWnDCQXxsxHyp8HPtlCkbanolxnRusXnvmx3brR+EWMvEyd9BNmy22g9fr8flq4OFPbyHqVrOTGvCLYcvis463capLTPx1c8Uo8SOTCjq3VHmbOyEm268xpp4rDpi3XAkOnRXq0SFLwvl1qZ5eOdVgtMKw5UgPC9Sjc1pSOWT18EBSfqT+JvpgH/KM3+W3WjzxO69mkLmue3BSbw10SJIHGNBFgLRaRZPFMnSQ/qEq/9ZGSyqiND7euYwHmtJe8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(76116006)(66946007)(122000001)(66446008)(38070700005)(64756008)(316002)(2906002)(26005)(83380400001)(107886003)(186003)(6506007)(53546011)(66556008)(66476007)(71200400001)(5660300002)(8936002)(508600001)(33656002)(7696005)(8676002)(54906003)(4326008)(9686003)(86362001)(55016002)(110136005)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dXhMeGRLOS8vVmZKYWxLQUJ6bndDUm5FclFweWtHNFFtU2NPVytZdWlZWmVG?=
 =?utf-8?B?Qytkc3FQblNGclAyS1NxVFZHaFNDYXl3WEw4TE9tK1R5ZldkNzQ2YUNQK3lB?=
 =?utf-8?B?d3Badi8rY05SV0RNTURDMGlzbXB5T1U1cFlLTU5OYWJqTTRPUTZGNnB4Nlp1?=
 =?utf-8?B?dis3ZjJDVXA1b3dkbThFcU5vWit4OVltdkVwNUVHOVo2VzNtT0FoZzZ3clpa?=
 =?utf-8?B?cWt3Z0JiblRHQzNQY1pLYjJRcGdCdENYUjFwc0ZZVjJpSWUwRTIvVDJocC9t?=
 =?utf-8?B?aGpOdlB2RkJLSzZEKzlFQXNEbksxMFVaYW5FZmFHUmwvS0djM0JDVWI4VmlV?=
 =?utf-8?B?WXpKNzQyd2xjclFuV1I3N0tiR0Fac1pWQ0hsYUxmeDhXNHIxSWhCVXlpK3M2?=
 =?utf-8?B?am9tYWtFSEZkNVc3Wk5jQkV3ZnF1cmw4WmRoS29weVNEUWx0VFF3TExmeGh6?=
 =?utf-8?B?VUJFOW9vVXZaMHJ4SGJ4dlBoemExTEZDQmFPZGJibTdSby9ybklhWlVCcDVm?=
 =?utf-8?B?UCs4TnhqUDJzWnhlaVdVZWQySlFvUFBoZm91ZXFKbWdBcGZQSlFrd0RFL3Jw?=
 =?utf-8?B?NW12OWZCbjYxYkdFTnk3V1pWNXRrUGdpUVVQWERBZXhTUEh3MGFuSVQ1STU1?=
 =?utf-8?B?c2M0VkNWRVdDWDY0TGNBRHZqQ2NzcnJTT1pLc21zS1UwdXZBM1ZyNWNxdmtz?=
 =?utf-8?B?WlRCQU1oc2JLVEJDemU5MW5qVGNRT0poTmFLMHp3bUVpRlhqamdlbDc3VDNK?=
 =?utf-8?B?TjdBOGNWdG15V1hwWE1Pb0FHaGZrNjRpSDVZVDQ2OWk5RWM3UFFKWG5GazQz?=
 =?utf-8?B?OUJhcmMvcEtVSVBGRWhvNTEzZ0ZGVkREdm9pQzVNTXNhZmVpWWtSL25YcFlM?=
 =?utf-8?B?Y0xRSEt6Q0FqaVIyTWZqQlozZ2lGb3dydUtaZ3llSU50aVduN3hkOVVOdmZa?=
 =?utf-8?B?bndURXFkdFlRSksxVUtXNS9OYXZJU0FHRy9lUzdDZURsdkowcHkra3Ura1Jy?=
 =?utf-8?B?cXJEcjRNMnlzU1BNMkh0WHZuUW9mWm5TdjM4WExycy9HUVlodXFjZTQ2WlJY?=
 =?utf-8?B?L29lM2J2cGVvUUROWnphZ0tpRFc5bEdEUkJna0Jzb2ZnR2NTYm16Y2RNbm9n?=
 =?utf-8?B?aU9jcDMxUUxmQXN5ditnWDBLaTU0Q21qVjhRMVR3Si80YUI5N2h1MS83aStk?=
 =?utf-8?B?VjIzTmVtUG1ZWHQ0TFdhTldUaEx3NndTRXVBTUJ5ekg3T1ROTWtxZlQ4bW52?=
 =?utf-8?B?RUF4RS91bVVaSzBwUThjWlEvYVdkTldsTGNJWk9TSUxQL1hhNkNZN0VEK0FS?=
 =?utf-8?B?UEozSXJVSWVVR2g3MTNhKzlTMXFXUGdiYS83MWZ0MGRUUEllM0pmS08xb0pB?=
 =?utf-8?B?VnNpVHlkZUR3dzhyL3JmRnRCOE5nM0w1MFhNVWtGVDcvTEh4eVV5dCtSSDkv?=
 =?utf-8?B?VUcxWnZNcWEwb1RPRzNGanpMRjI0OURMSno4eWlXNis4L0tFdlBGSTQ4cWsw?=
 =?utf-8?B?T015bkZndHlqWm5uNExUYllTV3FaVVBiSGVNdWZINVJyMzBGUzg3LzE3WTFX?=
 =?utf-8?B?TjBQaHF4VnFHZk9lS2E0K3E1TldTaHE0dXpiY0EvYUxVQ05Iam5hSW81Rkpn?=
 =?utf-8?B?YmRkSmp4aGpxUGNFZDh6L2U3WWhSZHBUS0FwL0dOYUpON3IxejZ5YmJoTHI1?=
 =?utf-8?B?UHQwTFg1TVhnTHFUWFRZTXJyMjh4b3ZKcEFRKzIvaWlDZ3RWQjNtYTlld0Y5?=
 =?utf-8?B?a1RSQmJ6eGFXaTczWjF6RUtZaUNoc0w1QW5oTXBkanF3VExkRUdsMGlWMnlh?=
 =?utf-8?B?VEFPekFyWWtLK2RZZkVQWUxBZFo2bVJiS05sejZsV2tIZko1dEE0SUFNeGNI?=
 =?utf-8?B?UGxjZ2ZIWHlSZGJXMHVOSHcwRGp4U2RqK0FjSkRwdlRTbEM3bzZ4amdGdEZm?=
 =?utf-8?B?a0pHbzhmZ0Jqa2VObUpydjl4NUZUYjFQcXZ1MUY5V1YyOXBJZW42aDN6Nk9i?=
 =?utf-8?B?bzVncXo4bWo1NDBsTUx5c0EvbUpmMWt1Mnk4S3haMkZkSmg5VXRpNmV1dW9w?=
 =?utf-8?B?NklDaWZuVFFtS1V0ZEJ3WTVrK21iSmRJNUZ4cWJqblU4NzRmZjk5RTFSVTRZ?=
 =?utf-8?B?M3NjbGF3NHRKakZ3aFgva2JER3l3OXlDcWxKeTRNSXVNbXFGTTlnRnQ0OWlt?=
 =?utf-8?Q?P9n5eL2K0VHvux4r4uBjk84=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c9a47d5-b094-4a8e-8b1e-08d99ea6fe01
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 08:50:31.0400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FzI8dUe6V682L6Y6FnytFfqDQy/L5r8GxjwE6DbiJZ95O/R9D04/xzJ4n5Q6CQdhe1i6qM0ylkV5yjj2kom2Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB5405
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBGbG9yaWFuIEZhaW5lbGxpIDxm
LmZhaW5lbGxpQGdtYWlsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBPY3RvYmVyIDI3LCAyMDIx
IDEwOjQ4IFBNDQo+IFRvOiBSYWRoZXkgU2h5YW0gUGFuZGV5IDxyYWRoZXlzQHhpbGlueC5jb20+
OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+
OyBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPjsNCj4gUnVzc2VsbCBLaW5n
IDxsaW51eEBhcm1saW51eC5vcmcudWs+DQo+IENjOiBNaWNoYWwgU2ltZWsgPG1pY2hhbHNAeGls
aW54LmNvbT47IEhhcmluaSBLYXRha2FtIDxoYXJpbmlrQHhpbGlueC5jb20+DQo+IFN1YmplY3Q6
IFJlOiBtZGlvOiBzZXBhcmF0ZSBncGlvLXJlc2V0IHByb3BlcnR5IHBlciBjaGlsZCBwaHkgdXNl
Y2FzZQ0KPiANCj4gK1BIWSBsaWJyYXJ5IG1haW50YWluZXJzLA0KPiANCj4gT24gMTAvMjcvMjEg
NTo1OCBBTSwgUmFkaGV5IFNoeWFtIFBhbmRleSB3cm90ZToNCj4gPiBIaSBhbGwsDQo+ID4NCj4g
PiBJbiBhIHhpbGlueCBpbnRlcm5hbCBib2FyZCB3ZSBoYXZlIHNoYXJlZCBHRU0gTURJTyBjb25m
aWd1cmF0aW9uIHdpdGgNCj4gPiBUSSBEUDgzODY3IHBoeSBhbmQgZm9yIHByb3BlciBwaHkgZGV0
ZWN0aW9uIGJvdGggUEhZcyBuZWVkIHByaW9yDQo+ID4gc2VwYXJhdGUgR1BJTy1yZXNldC4NCj4g
Pg0KPiA+IERlc2NyaXB0aW9uOg0KPiA+IFRoZXJlIGFyZSB0d28gR0VNIGV0aGVybmV0IElQcyBp
bnN0YW5jZXMgR0VNMCBhbmQgR0VNMS4gR0VNMCBhbmQgR0VNMQ0KPiA+IHVzZWQgc2hhcmVkIE1E
SU8gZHJpdmVuIGJ5IEdFTTEuDQo+ID4NCj4gPiBUSSBQSFlzIG5lZWQgcHJpb3IgcmVzZXQgKFJF
U0VUX0IpIGZvciBQSFkgZGV0ZWN0aW9uIGF0IGRlZmluZWQgYWRkcmVzcy4NCj4gPiBIb3dldmVy
IHdpdGggY3VycmVudCBmcmFtZXdvcmsgbGltaXRhdGlvbiAiIG9uZSByZXNldCBsaW5lIHBlciBQ
SFkNCj4gPiBwcmVzZW50IG9uIHRoZSBNRElPIGJ1cyIgdGhlIG90aGVyIFBIWSBnZXQgZGV0ZWN0
ZWQgYXQgaW5jb3JyZWN0DQo+ID4gYWRkcmVzcyBhbmQgbGF0ZXIgaGF2aW5nIGNoaWxkIFBIWSBu
b2RlIHJlc2V0IHByb3BlcnR5IHdpbGwgYWxzbyBub3QgaGVscC4NCj4gPg0KPiA+IEluIG9yZGVy
IHRvIGZpeCB0aGlzIG9uZSBwb3NzaWJsZSBzb2x1dGlvbiBpcyB0byBhbGxvdyByZXNldC1ncGlv
cw0KPiA+IHByb3BlcnR5IHRvIGhhdmUgUEhZIHJlc2V0IEdQSU8gdHVwbGUgZm9yIGVhY2ggcGh5
LiBJZiB0aGlzIGFwcHJvYWNoDQo+ID4gbG9va3MgZmluZSB3ZSBjYW4gbWFrZSBjaGFuZ2VzIGFu
ZCBzZW5kIG91dCBhIFJGQy4NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgeW91ciBwcm9wb3NlZCBzb2x1
dGlvbiB3b3VsZCB3b3JrIGJlY2F1c2UgdGhlcmUgaXMgbm8gd2F5IHRvDQo+IGRpc2FtYmlndWF0
ZSB3aGljaCAncmVzZXQtZ3Bpb3MnIHByb3BlcnR5IGFwcGxpZXMgdG8gd2hpY2ggUEhZLCB1bmxl
c3MgeW91IHVzZQ0KPiBhICdyZXNldC1ncGlvLW5hbWVzJyBwcm9wZXJ0eSB3aGljaCBlbmNvZGVz
IHRoZSBwaHkgYWRkcmVzcyBpbiB0aGVyZS4gQnV0DQo+IGV2ZW4gZG9pbmcgc28sIGlmIHRoZSAn
cmVzZXQtZ3Bpb3MnIHByb3BlcnR5IGlzIHBsYWNlZCB3aXRoaW4gdGhlIE1ESU8gY29udHJvbGxl
cg0KPiBub2RlIHRoZW4gaXQgYXBwbGllcyB3aXRoaW4gaXRzIHNjb3BlIHdoaWNoIGlzIHRoZSBN
RElPIGNvbnRyb2xsZXIuIFRoZSBvdGhlcg0KPiByZWFzb24gd2h5IGl0IGlzIHdyb25nIGlzIGJl
Y2F1c2UgdGhlIE1ESU8gYnVzIGl0c2VsZiBtYXkgbmVlZCBtdWx0aXBsZSByZXNldHMNCj4gdG8g
YmUgdG9nZ2xlZCB0byBiZSBwdXQgaW4gYSBmdW5jdGlvbmFsIHN0YXRlLiBUaGlzIGlzIHByb2Jh
Ymx5IHVuY29tbW9uIGZvcg0KPiBNRElPLCBidXQgaXQgaXMgbm90IGZvciBvdGhlciB0eXBlcyBv
ZiBwZXJpcGhlcmFscyB3aXRoIGNvbXBsZXggYXN5bmNocm9ub3VzDQo+IHJlc2V0IGNpcmN1aXRz
ICh0aGUgdGhpbmdzIHlvdSBsb3ZlIHRvIGhhdGUpLg0KPiANCj4gVGhlIE1ESU8gYnVzIGxheWVy
IHN1cHBvcnRzIHNvbWV0aGluZyBsaWtlIHRoaXMgd2hpY2ggaXMgbXVjaCBtb3JlIGFjY3VyYXRl
DQo+IGluIGRlc2NyaWJpbmcgdGhlIHJlc2V0IEdQSU9zIHBlcnRhaW5pbmcgdG8gZWFjaCBQSFkg
ZGV2aWNlOg0KPiANCj4gCW1kaW8gew0KPiAJCS4uDQo+IAkJcGh5MDogZXRoZXJuZXQtcGh5QDAg
ew0KPiAJCQlyZWcgPSA8MD47DQo+IAkJCXJlc2V0LWdwaW9zID0gPCZzbGc3eGw0NTEwNiA1IEdQ
SU9fQUNUSVZFX0hJR0g+Ow0KPiAJCX07DQo+IAkJcGh5MTogZXRoZXJuZXQtcGh5QDggew0KPiAJ
CQlyZWcgPSA8OD47DQo+IAkJCXJlc2V0LWdwaW9zID0gPCZzbGc3eGw0NTEwNiA2IEdQSU9fQUNU
SVZFX0hJR0g+Ow0KPiAJCX07DQo+IAl9Ow0KPiANCj4gVGhlIGNvZGUgdGhhdCB3aWxsIHBhcnNl
IHRoYXQgcHJvcGVydHkgaXMgaW4gZHJpdmVycy9uZXQvcGh5L21kaW9fYnVzLmMgdW5kZXINCj4g
bWRpb2J1c19yZWdpc3Rlcl9ncGlvZCgpL21kaW9idXNfcmVnaXN0ZXJfcmVzZXQoKSBhbmQgdGhl
bg0KPiBtZGlvX2RldmljZV9yZXNldCgpIGNhbGxlZCBieSBwaHlfZGV2aWNlX3Jlc2V0KCkgd2ls
bCBwdWxzZSB0aGUgcGVyLVBIWSBkZXZpY2UNCj4gcmVzZXQgbGluZS9HUElPLg0KPiANCj4gQXJl
IHlvdSBzYXlpbmcgdGhhdCB5b3UgdHJpZWQgdGhhdCBhbmQgdGhpcyBkaWQgbm90IHdvcmsgc29t
ZWhvdz8gQ2FuIHlvdQ0KPiBkZXNjcmliZSBpbiBtb3JlIGRldGFpbHMgaG93IHRoZSB0aW1pbmcg
b2YgdGhlIHJlc2V0IHB1bHNpbmcgYWZmZWN0cyB0aGUgd2F5DQo+IGVhY2ggVEkgUEhZIGlzIGdv
aW5nIHRvIGdldHMgaXRzIE1ESU8gYWRkcmVzcyBhc3NpZ25lZD8NCg0KWWVzLCBoYXZpbmcgcmVz
ZXQtZ3Bpb3MgaW4gUEhZIG5vZGUgaXMgbm90IHdvcmtpbmcuICBKdXN0IHRvIGhpZ2hsaWdodCAt
IFdlIGFyZQ0KdXNpbmcgZXh0ZXJuYWwgc3RyYXAgY29uZmlndXJhdGlvbiBmb3IgUEhZIEFkZHJl
c3MgY29uZmlndXJhdGlvbi4gVGhlIHN0cmFwDQpwaW4gY29uZmlndXJhdGlvbiBpcyBzZXQgYnkg
c3cgc3RhY2sgYXQgYSBsYXRlciBzdGFnZS4gUEhZIGFkZHJlc3Mgb24gDQpwb3dlciBvbiBpcyBj
b25maWd1cmVkIGJhc2VkIG9uIHNhbXBsZWQgdmFsdWVzIGF0IHN0cmFwIHBpbnMgd2hpY2ggaXMg
bm90DQpQSFkgYWRkcmVzcyBtZW50aW9uZWQgaW4gRFQuIChJdCBjb3VsZCBiZSBhbnkgUEhZIEFk
ZHJlc3MgZGVwZW5kaW5nIG9uDQpzdHJhcCBwaW5zIGRlZmF1bHQgaW5wdXQpLiBGb3IgUEhZIGRl
dGVjdCB0byBoYXBwZW4gYXQgcHJvcGVyIFBIWSBBZGRyZXNzDQp3ZSBoYXZlIGNhbGwgUEhZIHJl
c2V0IChSRVNFVF9CKSBhZnRlciBzdHJhcCBwaW5zIGFyZSBjb25maWd1cmVkIG90aGVyd2lzZSAN
CnByb2JlIChvZl9tZGlvYnVzX3BoeV9kZXZpY2VfcmVnaXN0ZXIpIGZhaWxzIGFuZCB3ZSBzZWUg
YmVsb3cgZXJyb3I6DQoNCm1kaW9fYnVzIGZmMGMwMDAwLmV0aGVybmV0LWZmZmZmZmZmOiBNRElP
IGRldmljZSBhdCBhZGRyZXNzIDggaXMgbWlzc2luZy4NCg0KVGhhbmtzLA0KUmFkaGV5DQoNClJl
ZmVyZW5jZXM6DQo4LjUuNFBIWUFkZHJlc3NDb25maWd1cmF0aW9uIFtEUDgzODY3RS9JUy9DUyBk
YXRhc2hlZXRdDQogDQo+IA0KPiBUaGFua3MNCj4gLS0NCj4gRmxvcmlhbg0K
