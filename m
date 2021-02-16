Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676D031CDDF
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 17:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhBPQU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 11:20:28 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:64508 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230017AbhBPQUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 11:20:25 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11GGC2UA020894;
        Tue, 16 Feb 2021 11:19:34 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2057.outbound.protection.outlook.com [104.47.60.57])
        by mx0c-0054df01.pphosted.com with ESMTP id 36pas3hjs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 11:19:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQqq3+ZqJrK1DXzIAiiXXPJFjfLWuaF+AqEkMpE+BvtC1I6iLMxgRLTNP7kafa/lQ5fgz7cTDQbfDXNlcklCDxzxZ/dRxwqyiw4UvLP9r60HQci1FVNBlTPTq6j/pYCh2zUMl6Hcya9C+2JDIySjlmoAvFmYBnwlayCfhlE+ANzI9QW7x3/n33L9TFWUqqQH/5nc4YxhKsvbOSZxJPNuuAJYRERWCEfmt4XeIwEjNyuKJ+KzqPrPDrWQN8QMEynu4N4Xqk8jMzjzVyXNEhfvCRMbHWjMo82w5uTfCRYYVH0JE7TTSTq3yGZXVUTj1X1hjIBP8RrC/0eG2Y+UmE26Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+eFbLpQr6z7tZJkwczTQt7JmdUAL3+JIj2wjChQOmxM=;
 b=OZfiXEAxP0ci8twhXoU4+Il1+phZV9HbYJIpt+MB6W3mSgzw4H/hBISB6H+BHailZ7pLWMZ1X10LR3d/veuTomOhFfq3ock/PBMVYf9A0g7tGs3eFZKWHypdei7Xw7EP5IBjmrDzcdnki9mzcOKsdbgJS2mAX/e4Ntlm0Ykd53mG97wTewzI8MyantK14Y3/8/hGza+NlWT+VKwrD2mAqnV+/LmM+1ytFBXGj/GDgrghZRiGQba1IEJkmfNIOpVI5x8tn4aiy4HM1+xV9o550TZlvElWTS8zIcnQM1iDv0HtLzrDOqLxYqKplCgKhTDgadAEClubfqVaZd+i/rQHfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+eFbLpQr6z7tZJkwczTQt7JmdUAL3+JIj2wjChQOmxM=;
 b=hLMO8K5fXZMd1wjwQ8JEk9FtEJg6iyWubDWgr93LFAQTmpbdHXr/gMh3QNj3GPqi/tYL13mEAd4ieNaz5T2QXYNMZmN0UPg28RmKfIhsDCsfxm3/Fj7LeehHmTVK1ZnZow6I0mRtqlO9h6XLGeXkvKkl2Dm7V8vd7nr00L14gHI=
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTOPR0101MB1465.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:23::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38; Tue, 16 Feb
 2021 16:19:32 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96%7]) with mapi id 15.20.3846.038; Tue, 16 Feb 2021
 16:19:32 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: axienet: Support dynamic switching
 between 1000BaseX and SGMII
Thread-Topic: [PATCH net-next 3/3] net: axienet: Support dynamic switching
 between 1000BaseX and SGMII
Thread-Index: AQHXAZ6T9fkpYZdtNke0QYMbkgTchqpWS3eAgASwToA=
Date:   Tue, 16 Feb 2021 16:19:32 +0000
Message-ID: <97044b25fdae5cddc2fb012e3ade100190b45298.camel@calian.com>
References: <20210213002356.2557207-1-robert.hancock@calian.com>
         <20210213002356.2557207-4-robert.hancock@calian.com>
         <YCgBrycpH+TNqhBy@lunn.ch>
In-Reply-To: <YCgBrycpH+TNqhBy@lunn.ch>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-16.el8) 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56d4ca08-9395-4acf-9fe3-08d8d296a4bd
x-ms-traffictypediagnostic: YTOPR0101MB1465:
x-microsoft-antispam-prvs: <YTOPR0101MB1465B1D2E86DA1AD48F54B9EEC879@YTOPR0101MB1465.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fDHE3Y7AbX8iSyNsOyvHn5/KDAcfxyjbXEsHSFJIxlRWkHwcagi6bxkDKxce6q6RhUzi69bET8s6vicn15LonlggKGNPatmJeDxmliLr8DH4TtUGmwmi3wIGQAhcaUshcwRCYk85gWCQYNK+lamDZar3fJ+A32Gn0w4ip3uQRc39bmVfnT7BU9W0d8KIjqd4o0zj7Z1xxKSpt8Nxl3i/yRkc025nAvzmSOKiaGIpIa/v/GdAh1hHAG/1uBSLybgshBsm/XhyV7GUcyp/Biuh/70IZGq8EHXF8FP3cSA3+yk+bQC7adnRlUiT1WpBt2HV8MPmb+5U8bvIEnxcyv5aZlNhVlGTEJFoReHBFYLEWUcScdQiLN7T43BejE/hk51XzOGVIKyINXSlIjmrqlei4OC7f5Z4iCvtpdKaarbv8uH3DviVQ0luBy3ehDI3oQUybzNafvT08kWx6PDrBJKVH8mUXfoXn1DYdWwZJdwoxrpDkwEfTWQCnpQVKYBrOYLyGu8G2hDIIy9e0ZI75XdEA73k3Oh9p0bZU69I1NHwTQnI3paD7RFRV5saucPxU5uq90QN/2dNj1gEOApCA1jl1mEutWMwGH9eHIUEeoNMOz3YY2phkaLEA3YxiVxYB45/DSbPHT3SAF2eyN4UFQirP580M4Fd6KU+leJXIb8g1ipNehvZkMoH8u5NuXj5FYax
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(366004)(136003)(39850400004)(15974865002)(36756003)(64756008)(71200400001)(316002)(2906002)(5660300002)(86362001)(66446008)(2616005)(478600001)(66556008)(54906003)(6486002)(6506007)(8936002)(44832011)(26005)(186003)(66946007)(76116006)(6512007)(4326008)(91956017)(8676002)(83380400001)(6916009)(66476007)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bTBDRDNOTmg5ck8rTWhEckszaWo3UkZGY1RQdjkzMjY3TExXNkZ5MEtPMlNu?=
 =?utf-8?B?elNuaVdFNTQ1UUhZT0hNR2RGYi9qWG4xQnVJQ2g0blpkbGp0N0IvRVo2d3pp?=
 =?utf-8?B?R2wwYmtrTDFXRDJ0U1BiaEFUbGlBTm8wY0Vsd2xDTnpFVTgzUlhKUHZleEZz?=
 =?utf-8?B?ZlBaaWV3S0FJSEVsU0FXU0NvS0ZRcUg1WFFtL2RDVnhtcFRndW1IN3MvajNK?=
 =?utf-8?B?a1ZWS2d3Mk1qQ09SN04vbEdDQUhNY0Z5MzRnbjVWUW1nL1B3bjBOcFNnK21u?=
 =?utf-8?B?bzYzT1FBcU5seHVPTlJPQzczTUFzY3NqaVo1MWpCcFZVWVZGWWRZdzh6bDYr?=
 =?utf-8?B?WWFORi9QZHZVZXBKM2tndG9WbTlLQjY0ZmJPeXo4QUZhbWY4ZUFib3REaEh4?=
 =?utf-8?B?SDhOSFdvQWpaV1BSQWhaUXhzRm5hYllZZWQyTnF5VXptSFB1c3hkcWFGR3dB?=
 =?utf-8?B?SnlFYm5UYkpIRkUwdDRSYlNtV3RsdjF2ZUVmcEZHUkVFZGE3eDB2Q1J3SGFD?=
 =?utf-8?B?MW9hTkJWcVBFQ2gycUNpS05aTTQxaTZUMndZOTl2RWRMcUg2M0hGRDJCWmJ4?=
 =?utf-8?B?aFpEeVo4ZkUzK2dtSWswVlR4TWtLQitpYjZiOFNHbDNEMGtFMm9Bc3lBV1ln?=
 =?utf-8?B?SmFmbURwV3llRDIzM0QxajhaREJkUG5Ra0lSSXJvb1FiK0dFcGdrSGx4QTBR?=
 =?utf-8?B?Vmw5RU1TN3ZvanlRUTljNU4zZmNyZWp6Mk82TktQbjVONG5DazByVEZQZHVP?=
 =?utf-8?B?NDNjSW16alRMQVJwLzN5RHk3YVlwWDBlaG1JL2oxQm8yM0I4UlFhei90KzJC?=
 =?utf-8?B?Y3RvOEo5R1dOVWI3SExOcVZWVVJVMW5DRVdyUmZJYXJOejVub3lHSzFGamU1?=
 =?utf-8?B?MnVIdUxpMmxodzhpbjZuUkYwcnErZ25hY0NjVzl4ZW5mRkdCMk10VkVoRTN5?=
 =?utf-8?B?SEZHUlBqc2NFNG0ySnRlOU9mWHhiNTJOc0Z0VFdVeVNiaitKRm9mU25LaHIr?=
 =?utf-8?B?Q002Ri8veUptc2dkN0hMN1lRZzN5cWpHNVRaTTVocEMwQ2RYeUNFSUExU0Nk?=
 =?utf-8?B?WFlHM29kZnZMREpEeVg2M3l6bmdaOWtETlNzMmtJNFd6eWE1Z293ck14Q0tE?=
 =?utf-8?B?KzZQYldsbTVCVUt5cXVBMVVnalNZdlBxRGluaENsOFZ5QyswQ2EvNTRjMTFz?=
 =?utf-8?B?WVUrQnoxenF6NERzOFFIQitZTWtUNXNoWC9STFRvd3FCV1ZPVzdsU1dJV3Vr?=
 =?utf-8?B?MFZmemxyZUVBR2tiRm9neEZmWG5OZ25mM1JWZzcvNGdqNCtrRnl3cGw1WEo5?=
 =?utf-8?B?TWZWaXR1TzUreE1HakgrdUJhSC83SEVqV0VtUCtJN01EUVlhK2lGbUpSVnNv?=
 =?utf-8?B?VFFkd3lLcmR5TXViTkpQcHRtWnNKZkVYdTAzckRyek5DUGZTb3NBMFFUOXVt?=
 =?utf-8?B?WGhTdmRiV2x0NlVFNXRVdExwQVZ1TlgyYUdSOEs4UDNMdW1JNjAvK0t0UUwx?=
 =?utf-8?B?UkJoSXRQL0RvbXNSMlExQ3JBeDgwNTh5MTF4ZVNKcWpaNWJyRTFvRTZ6eDJE?=
 =?utf-8?B?KzdqZzRINUJkdDlQWlppR2lBR2gzZ3dFOVc2bkRrNFlhT3lhRXlvT20wOEdJ?=
 =?utf-8?B?TmNhQnFLK0VOQXMvVktLVVJWWEI1MVNHeVQrYVRjRms0bSsxcVBmRmRWOG82?=
 =?utf-8?B?TElxS2V1dTE1SEpqY0VVMUZtK3dmNlhqTlZQL2YvWG1xNmZwVEVSWTlOb3Mz?=
 =?utf-8?Q?zKTDFezpbMfwBzq3yowZESv0mdG0XfMFymwcXWR?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF32824472FF1049A474E5B2CF3A9380@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 56d4ca08-9395-4acf-9fe3-08d8d296a4bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2021 16:19:32.2164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HDW0SurEyQ28gftZxEq26tWHOEW8T7qZ3cPOXvytEKiK8HxIz5+xIyOblByg8lDXQvPww6S9DDYU95sx0S06YBvSTjH2KmvYr17COROc1fg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTOPR0101MB1465
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-16_07:2021-02-16,2021-02-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIxLTAyLTEzIGF0IDE3OjQzICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
T24gRnJpLCBGZWIgMTIsIDIwMjEgYXQgMDY6MjM6NTZQTSAtMDYwMCwgUm9iZXJ0IEhhbmNvY2sg
d3JvdGU6DQo+ID4gTmV3ZXIgdmVyc2lvbnMgb2YgdGhlIFhpbGlueCBBWEkgRXRoZXJuZXQgY29y
ZSAoc3BlY2lmaWNhbGx5IHZlcnNpb24gNy4yIG9yDQo+ID4gbGF0ZXIpIGFsbG93IHRoZSBjb3Jl
IHRvIGJlIGNvbmZpZ3VyZWQgd2l0aCBhIFBIWSBpbnRlcmZhY2UgbW9kZSBvZiAiQm90aCIsDQo+
IA0KPiBIaSBSb2JlcnQNCj4gDQo+IElzIGl0IHBvc3NpYmxlIHRvIHJlYWQgdGhlIHZlcnNpb24g
b2YgdGhlIGNvcmUgZnJvbSBhIHJlZ2lzdGVyPyBJcyBpdA0KPiBwb3NzaWJsZSB0byBzeW50aGVz
aXplciBhIHZlcnNpb24gNy4yIG9yID4gd2l0aG91dCB0aGlzIGZlYXR1cmU/IEknbQ0KPiBqdXN0
IHdvbmRlcmluZyBpZiB0aGUgRFQgcHJvcGVydHkgaXMgYWN0dWFsbHkgbmVlZGVkPw0KDQpUaGUg
Y29yZSBjYW4gc3RpbGwgYmUgc3ludGhlc2l6ZWQgd2l0aCBhIGZpeGVkIDEwMDBCYXNlLVggb3Ig
U0dNSUkgaW50ZXJmYWNlDQptb2RlIGluIGFkZGl0aW9uIHRvIHRoZSAiQm90aCIgb3B0aW9uLCBh
bmQgSSdtIG5vdCBhd2FyZSBvZiBhIHdheSB0byBkZXRlcm1pbmUNCndoYXQgbW9kZSBoYXMgYmVl
biB1c2VkIGJhc2VkIG9uIHJlZ2lzdGVycywgc28gSSBkb24ndCB0aGluayB0aGVyZSdzIHJlYWxs
eQ0KYW5vdGhlciBvcHRpb24uDQoNCj4gDQo+ID4gIC8qKg0KPiA+ICAgKiBzdHJ1Y3QgYXhpZG1h
X2JkIC0gQXhpIERtYSBidWZmZXIgZGVzY3JpcHRvciBsYXlvdXQNCj4gPiAgICogQG5leHQ6ICAg
ICAgICAgTU0yUy9TMk1NIE5leHQgRGVzY3JpcHRvciBQb2ludGVyDQo+ID4gQEAgLTM3NywyMiAr
MzgxLDI5IEBAIHN0cnVjdCBheGlkbWFfYmQgew0KPiA+ICAgKiBAbmRldjoJUG9pbnRlciBmb3Ig
bmV0X2RldmljZSB0byB3aGljaCBpdCB3aWxsIGJlIGF0dGFjaGVkLg0KPiA+ICAgKiBAZGV2OglQ
b2ludGVyIHRvIGRldmljZSBzdHJ1Y3R1cmUNCj4gPiAgICogQHBoeV9ub2RlOglQb2ludGVyIHRv
IGRldmljZSBub2RlIHN0cnVjdHVyZQ0KPiA+ICsgKiBAcGh5bGluazoJUG9pbnRlciB0byBwaHls
aW5rIGluc3RhbmNlDQo+ID4gKyAqIEBwaHlsaW5rX2NvbmZpZzogcGh5bGluayBjb25maWd1cmF0
aW9uIHNldHRpbmdzDQo+ID4gKyAqIEBwY3NfcGh5OglSZWZlcmVuY2UgdG8gUENTL1BNQSBQSFkg
aWYgdXNlZA0KPiA+ICsgKiBAc3dpdGNoX3hfc2dtaWk6IFdoZXRoZXIgc3dpdGNoYWJsZSAxMDAw
QmFzZVgvU0dNSUkgbW9kZSBpcyBlbmFibGVkIGluDQo+ID4gdGhlIGNvcmUNCj4gPiArICogQGNs
azoJQ2xvY2sgZm9yIEFYSSBidXMNCj4gPiAgICogQG1paV9idXM6CVBvaW50ZXIgdG8gTUlJIGJ1
cyBzdHJ1Y3R1cmUNCj4gPiAgICogQG1paV9jbGtfZGl2OiBNSUkgYnVzIGNsb2NrIGRpdmlkZXIg
dmFsdWUNCj4gPiAgICogQHJlZ3Nfc3RhcnQ6IFJlc291cmNlIHN0YXJ0IGZvciBheGllbmV0IGRl
dmljZSBhZGRyZXNzZXMNCj4gPiAgICogQHJlZ3M6CUJhc2UgYWRkcmVzcyBmb3IgdGhlIGF4aWVu
ZXRfbG9jYWwgZGV2aWNlIGFkZHJlc3Mgc3BhY2UNCj4gPiAgICogQGRtYV9yZWdzOglCYXNlIGFk
ZHJlc3MgZm9yIHRoZSBheGlkbWEgZGV2aWNlIGFkZHJlc3Mgc3BhY2UNCj4gPiAtICogQGRtYV9l
cnJfdGFza2xldDogVGFza2xldCBzdHJ1Y3R1cmUgdG8gcHJvY2VzcyBBeGkgRE1BIGVycm9ycw0K
PiA+ICsgKiBAZG1hX2Vycl90YXNrOiBXb3JrIHN0cnVjdHVyZSB0byBwcm9jZXNzIEF4aSBETUEg
ZXJyb3JzDQo+ID4gICAqIEB0eF9pcnE6CUF4aWRtYSBUWCBJUlEgbnVtYmVyDQo+ID4gICAqIEBy
eF9pcnE6CUF4aWRtYSBSWCBJUlEgbnVtYmVyDQo+ID4gKyAqIEBldGhfaXJxOglFdGhlcm5ldCBj
b3JlIElSUSBudW1iZXINCj4gPiAgICogQHBoeV9tb2RlOglQaHkgdHlwZSB0byBpZGVudGlmeSBi
ZXR3ZWVuIE1JSS9HTUlJL1JHTUlJL1NHTUlJLzEwMDANCj4gPiBCYXNlLVgNCj4gPiAgICogQG9w
dGlvbnM6CUF4aUV0aGVybmV0IG9wdGlvbiB3b3JkDQo+ID4gLSAqIEBsYXN0X2xpbms6CVBoeSBs
aW5rIHN0YXRlIGluIHdoaWNoIHRoZSBQSFkgd2FzIG5lZ290aWF0ZWQgZWFybGllcg0KPiA+ICAg
KiBAZmVhdHVyZXM6CVN0b3JlcyB0aGUgZXh0ZW5kZWQgZmVhdHVyZXMgc3VwcG9ydGVkIGJ5IHRo
ZSBheGllbmV0DQo+ID4gaHcNCj4gPiAgICogQHR4X2JkX3Y6CVZpcnR1YWwgYWRkcmVzcyBvZiB0
aGUgVFggYnVmZmVyIGRlc2NyaXB0b3IgcmluZw0KPiA+ICAgKiBAdHhfYmRfcDoJUGh5c2ljYWwg
YWRkcmVzcyhzdGFydCBhZGRyZXNzKSBvZiB0aGUgVFggYnVmZmVyIGRlc2NyLg0KPiA+IHJpbmcN
Cj4gPiArICogQHR4X2JkX251bToJU2l6ZSBvZiBUWCBidWZmZXIgZGVzY3JpcHRvciByaW5nDQo+
ID4gICAqIEByeF9iZF92OglWaXJ0dWFsIGFkZHJlc3Mgb2YgdGhlIFJYIGJ1ZmZlciBkZXNjcmlw
dG9yIHJpbmcNCj4gPiAgICogQHJ4X2JkX3A6CVBoeXNpY2FsIGFkZHJlc3Moc3RhcnQgYWRkcmVz
cykgb2YgdGhlIFJYIGJ1ZmZlciBkZXNjci4NCj4gPiByaW5nDQo+ID4gKyAqIEByeF9iZF9udW06
CVNpemUgb2YgUlggYnVmZmVyIGRlc2NyaXB0b3IgcmluZw0KPiA+ICAgKiBAdHhfYmRfY2k6CVN0
b3JlcyB0aGUgaW5kZXggb2YgdGhlIFR4IGJ1ZmZlciBkZXNjcmlwdG9yIGluIHRoZQ0KPiA+IHJp
bmcgYmVpbmcNCj4gPiAgICoJCWFjY2Vzc2VkIGN1cnJlbnRseS4gVXNlZCB3aGlsZSBhbGxvYy4g
QkRzIGJlZm9yZSBhIFRYIHN0YXJ0cw0KPiA+ICAgKiBAdHhfYmRfdGFpbDoJU3RvcmVzIHRoZSBp
bmRleCBvZiB0aGUgVHggYnVmZmVyIGRlc2NyaXB0b3IgaW4gdGhlDQo+ID4gcmluZyBiZWluZw0K
PiA+IEBAIC00MTQsMjMgKzQyNSwyMCBAQCBzdHJ1Y3QgYXhpZW5ldF9sb2NhbCB7DQo+ID4gIAlz
dHJ1Y3QgbmV0X2RldmljZSAqbmRldjsNCj4gPiAgCXN0cnVjdCBkZXZpY2UgKmRldjsNCj4gPiAg
DQo+ID4gLQkvKiBDb25uZWN0aW9uIHRvIFBIWSBkZXZpY2UgKi8NCj4gPiAgCXN0cnVjdCBkZXZp
Y2Vfbm9kZSAqcGh5X25vZGU7DQo+ID4gIA0KPiA+ICAJc3RydWN0IHBoeWxpbmsgKnBoeWxpbms7
DQo+ID4gIAlzdHJ1Y3QgcGh5bGlua19jb25maWcgcGh5bGlua19jb25maWc7DQo+ID4gIA0KPiA+
IC0JLyogUmVmZXJlbmNlIHRvIFBDUy9QTUEgUEhZIGlmIHVzZWQgKi8NCj4gPiAgCXN0cnVjdCBt
ZGlvX2RldmljZSAqcGNzX3BoeTsNCj4gDQo+IFRoaXMgcmVhbGx5IHNob3VsZCBvZiBiZWVuIHR3
byBwYXRjaGVzLiBPbmUgbW92aW5nIHRoZSBjb21tZW50cw0KPiBhcm91bmQsIGFuZCBhIHNlY29u
ZCBvbmUgYWRkaW5nIHRoZSBuZXcgZmllbGRzLg0KPiANCj4gPiArc3RhdGljIGludCBheGllbmV0
X21hY19wcmVwYXJlKHN0cnVjdCBwaHlsaW5rX2NvbmZpZyAqY29uZmlnLCB1bnNpZ25lZCBpbnQN
Cj4gPiBtb2RlLA0KPiA+ICsJCQkgICAgICAgcGh5X2ludGVyZmFjZV90IGlmYWNlKQ0KPiA+ICt7
DQo+ID4gKwlzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiA9IHRvX25ldF9kZXYoY29uZmlnLT5kZXYp
Ow0KPiA+ICsJc3RydWN0IGF4aWVuZXRfbG9jYWwgKmxwID0gbmV0ZGV2X3ByaXYobmRldik7DQo+
ID4gKwlpbnQgcmV0Ow0KPiA+ICsNCj4gPiArCXN3aXRjaCAoaWZhY2UpIHsNCj4gPiArCWNhc2Ug
UEhZX0lOVEVSRkFDRV9NT0RFX1NHTUlJOg0KPiA+ICsJY2FzZSBQSFlfSU5URVJGQUNFX01PREVf
MTAwMEJBU0VYOg0KPiA+ICsJCWlmICghbHAtPnN3aXRjaF94X3NnbWlpKQ0KPiA+ICsJCQlyZXR1
cm4gMDsNCj4gDQo+IE1heWJlIC1FT1BOT1RTVVBQIHdvdWxkIGJlIGJldHRlcj8NCg0KRnJvbSBt
eSByZWFkaW5nIG9mIHRoZSBjb2RlIGl0IGFwcGVhcnMgdGhhdCB0aGlzIGZ1bmN0aW9uIGlzIGNh
bGxlZCBvbiBzdGFydHVwDQppbml0aWFsbHkgZXZlbiBpZiBkeW5hbWljIHN3aXRjaGluZyBpcyBu
b3Qgc3VwcG9ydGVkLCBzbyB3ZSB3b3VsZCBuZWVkIHRvDQpyZXR1cm4gMCBoZXJlIGZvciB0aGF0
IGNhc2UuIFRoZSB2YWxpZGF0ZSBjYWxsYmFjayBzaG91bGQgdHJhcCBjYXNlcyB3aGVyZSB3ZQ0K
YXR0ZW1wdCB0byBzd2l0Y2ggbW9kZXMgYW5kIHRoYXQgaXNuJ3Qgc3VwcG9ydGVkLg0KDQo+IA0K
PiAgICAgICBBbmRyZXcNCi0tIA0KUm9iZXJ0IEhhbmNvY2sNClNlbmlvciBIYXJkd2FyZSBEZXNp
Z25lciwgQ2FsaWFuIEFkdmFuY2VkIFRlY2hub2xvZ2llcw0Kd3d3LmNhbGlhbi5jb20NCg==
