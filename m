Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 887BA13DCD6
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 15:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgAPOAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 09:00:51 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:3222 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726574AbgAPOAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 09:00:50 -0500
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00GDxqJZ030899;
        Thu, 16 Jan 2020 09:00:46 -0500
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by mx0a-00128a01.pphosted.com with ESMTP id 2xf93b5vqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jan 2020 09:00:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgKBMhFOAhBknAViPL9NKgSbYaxranu0fxLHY/5VmPfPnS6DMkxl8p0vmtEzzZy5CllsLtqLypMcmQ4mFfXGELSyJzcjRidEO9hueKMKsbyFrTyBjUeLLXIsz2yRX6DNtzqBZKUk2RsFsHdTaKKZRN5SyhBrgPj9kVWveO2asfXI1eYwQCbuStPiNO1iEskZTZnwmIYMEAeN4er+zcClwv1b/ItGV4bwSt6k8jg9Oqjd67Vv/o54JIqTBHFigVvCD37wg9Xyb6iSAM/fxdukvIpeXhDIj7imlTOCDUuT1vjnYs01gzxbxNqIrJ6dpIOLBm0bBcHyf0ABdULGz/qHCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CmhWtzmE7Vo65fp5kgKTSxrsVg4zfg93VkPl0X3IPOk=;
 b=EN8Wqi+giB95B9UTp3Jf+T5yGLbvXacrGWh08O93sQN8PN1R8taZq/Bq5fuWP/wVJniaIo+pTBAHakRSDKXUlGD3b0VjT2tBPItAg+ushVw7Sim3pSkfFCvzp63PpndSPQQEjjKddhPB21Hgg9HjcZDbspNMvE0D9QbmNyp1JA221bz3WIIrl1+iVgLbZndnQxy3NFVpefb4U2YLS2DSGsxSPJYj5svraTEmyQ5EFuYx2f46um1pbU8pOMJK6nY+D71rd6htu3TmVJ7qM5+BF8/ix7uVyd0OxT15gF6JmRieV4yJrCNkSQsi3rJnAgOLw1NdGtAzVEEUXDuElnU9pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CmhWtzmE7Vo65fp5kgKTSxrsVg4zfg93VkPl0X3IPOk=;
 b=Xu8xWtzz5s8H8ZFP0dz3CQTnNO9MtbT+eXk+MvIlRurAeFacPeGgo4KQ54p7GaXqIsgwi0xp08IdAsMiNzT/8atxm7HqlHp19WJXEmDxVRfQN/4cucQahwhwb7HW9w8Ocs1DHJq4/R49JFojWLmgQEOcJMDSeD8kkSSQHauuo0c=
Received: from CH2PR03MB5192.namprd03.prod.outlook.com (20.180.12.152) by
 CH2PR03MB5189.namprd03.prod.outlook.com (20.180.4.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Thu, 16 Jan 2020 14:00:44 +0000
Received: from CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::dce7:7fec:f33f:ad39]) by CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::dce7:7fec:f33f:ad39%7]) with mapi id 15.20.2644.021; Thu, 16 Jan 2020
 14:00:44 +0000
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 4/4] dt-bindings: net: adin: document 1588 TX/RX SOP
 bindings
Thread-Topic: [PATCH 4/4] dt-bindings: net: adin: document 1588 TX/RX SOP
 bindings
Thread-Index: AQHVzE0nyLrkRqiQ/UiQrvvi96odraftTUUAgAAFaoA=
Date:   Thu, 16 Jan 2020 14:00:44 +0000
Message-ID: <4401c98c70ded3ac0e611d547b149ad3c79b0d1f.camel@analog.com>
References: <20200116091454.16032-1-alexandru.ardelean@analog.com>
         <20200116091454.16032-5-alexandru.ardelean@analog.com>
         <20200116134330.GD19046@lunn.ch>
In-Reply-To: <20200116134330.GD19046@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.71.226.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 84bc312b-4de5-4fee-c8af-08d79a8c7ad6
x-ms-traffictypediagnostic: CH2PR03MB5189:
x-microsoft-antispam-prvs: <CH2PR03MB51894786108DC97F54A6B5F3F9360@CH2PR03MB5189.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(346002)(366004)(376002)(136003)(396003)(189003)(199004)(8676002)(81156014)(2616005)(6916009)(4326008)(81166006)(36756003)(6486002)(478600001)(71200400001)(5660300002)(76116006)(54906003)(186003)(66476007)(66946007)(26005)(316002)(66446008)(64756008)(66556008)(6512007)(6506007)(8936002)(86362001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR03MB5189;H:CH2PR03MB5192.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: analog.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IH1luBcb4MxO7Tyofu8A2hUuiBEu4Z4aBfgUkhNo0XG/FaNo3yNGrpB42q5PgBRyOU1Q5oAMpyDnNwSPgdtIXbyzsIibq1aIlaIZOgLF8e5GC/5HMzNgiPSKoemFw53aVReBEmOWmE3ci8oaSRIa6dVrDxv7TtbSeTEkcg0J7/X2RH97UasHagb04lTs4Y48I6/N678ugzdkdGE50wjfpQ2QJYs6HdhbiZXWmWfQJjPSXSU/IHvLhs3euYC/Yp5dBpaqC+6Lv+qc2cMnZDp3L94hnV0DGXuJysR7/KaRFN1m44buojT4HOEJAJN/AsCCU19+nIT+/2vM9T86KaAD2I4oQNMIj7dwHXC9SV/uc8psrQhQHrvGQCylpi1G/5lLzC8DQE6TogVFMvj0WU5DRWvJKa9++8jUsW9psDuBoiCC1a+uHVvYyHzG2SPWuG1P
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6261AA03C2836F4B982D4DBBA530A316@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84bc312b-4de5-4fee-c8af-08d79a8c7ad6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 14:00:44.1487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Q/Obq0jTzxhgRFvfgH2vEUEtQCZAmovV6teQbnRYzd2ZoVy0Wy6pUqqUQb1JO4XU7ZdD1LKuVKrfIWuHrJlCEtJepXnVJ/hqmZGpa/EghE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR03MB5189
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_04:2020-01-16,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 adultscore=0 mlxlogscore=617 bulkscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 phishscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001160118
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTAxLTE2IGF0IDE0OjQzICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gPiArICBhZGksMTU4OC1yeC1zb3AtZGVsYXlzLWN5Y2xlczoNCj4g
PiArICAgIGFsbE9mOg0KPiA+ICsgICAgICAtICRyZWY6IC9zY2hlbWFzL3R5cGVzLnlhbWwjZGVm
aW5pdGlvbnMvdWludDgtYXJyYXkNCj4gPiArICAgICAgLSBpdGVtczoNCj4gPiArICAgICAgICAg
IC0gbWluSXRlbXM6IDMNCj4gPiArICAgICAgICAgICAgbWF4SXRlbXM6IDMNCj4gPiArICAgIGRl
c2NyaXB0aW9uOiB8DQo+ID4gKyAgICAgIEVuYWJsZXMgU3RhcnQgUGFja2V0IGRldGVjdGlvbiAo
U09QKSBmb3IgcmVjZWl2ZWQgSUVFRSAxNTg4IHRpbWUNCj4gPiBzdGFtcA0KPiA+ICsgICAgICBj
b250cm9scywgYW5kIGNvbmZpZ3VyZXMgdGhlIG51bWJlciBvZiBjeWNsZXMgKG9mIHRoZSBNSUkg
UlhfQ0xLDQo+ID4gY2xvY2spDQo+ID4gKyAgICAgIHRvIGRlbGF5IHRoZSBpbmRpY2F0aW9uIG9m
IFJYIFNPUCBmcmFtZXMgZm9yIDEwLzEwMC8xMDAwIEJBU0UtVA0KPiA+IGxpbmtzLg0KPiA+ICsg
ICAgICBUaGUgZmlyc3QgZWxlbWVudCAoaW4gdGhlIGFycmF5KSBjb25maWd1cmVzIHRoZSBkZWxh
eSBmb3INCj4gPiAxMEJBU0UtVCwNCj4gPiArICAgICAgdGhlIHNlY29uZCBmb3IgMTAwQkFTRS1U
LCBhbmQgdGhlIHRoaXJkIGZvciAxMDAwQkFTRS1ULg0KPiANCj4gRG8geW91IGtub3cgdGhlIGNs
b2NrIGZyZXF1ZW5jeT8gSXQgd291bGQgYmUgbXVjaCBiZXR0ZXIgdG8gZXhwcmVzcw0KPiB0aGlz
IGluIG5zLCBhcyB3aXRoIGFkaSwxNTg4LXR4LXNvcC1kZWxheXMtbnMuDQoNClllcC4NCldlIGtu
b3cgdGhlIGNsb2NrIGZyZXF1ZW5jeSBoZXJlLg0KSSdsbCB0YWtlIGEgbG9vayBhYm91dCBjb252
ZXJ0aW5nIHRoaXMuDQoNCj4gDQo+ID4gQEAgLTYyLDUgKzExNiwxMSBAQCBleGFtcGxlczoNCj4g
PiAgICAgICAgICAgICAgcmVnID0gPDE+Ow0KPiA+ICANCj4gPiAgICAgICAgICAgICAgYWRpLGZp
Zm8tZGVwdGgtYml0cyA9IDwxNj47DQo+ID4gKw0KPiA+ICsgICAgICAgICAgICBhZGksMTU4OC1y
eC1zb3AtZGVsYXlzLWN5Y2xlcyA9IFsgMDAgMDAgMDAgXTsNCj4gPiArICAgICAgICAgICAgYWRp
LDE1ODgtcngtc29wLXBpbi1uYW1lID0gImludF9uIjsNCj4gPiArDQo+ID4gKyAgICAgICAgICAg
IGFkaSwxNTg4LXR4LXNvcC1kZWxheXMtbnMgPSBbIDAwIDA4IDEwIF07DQo+IA0KPiAxMCBpcyBu
b3QgYSBtdWx0aXBsZSBvZiA4IQ0KDQpNeSBiYWQgaGVyZS4NCkkgc2hvdWxkIHBvaW50LW91dCBz
b21ld2hlcmUgdGhhdCB0aGVzZSBhcmUgaGV4LXZhbHVlcy4NCkl0J3Mga2luZCBvZiBpbXBsaWVk
IHZpYSB0aGUgRFQgdWludDggYXJyYXkgdHlwZS4NCg0KPiANCj4gICAgQW5kcmV3DQo=
