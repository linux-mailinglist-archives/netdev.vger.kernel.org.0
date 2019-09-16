Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA7DB34CD
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 08:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbfIPGoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 02:44:46 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:26672 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726074AbfIPGoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 02:44:46 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8G6gpeu029258;
        Mon, 16 Sep 2019 02:44:25 -0400
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2050.outbound.protection.outlook.com [104.47.33.50])
        by mx0b-00128a01.pphosted.com with ESMTP id 2v0sy93dwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Sep 2019 02:44:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CRhYDDk8jJxLPRfkxuyLCdTwn4o6TxhvqPSp0vZBdKoIX93Tzd+brqoumHVszTdRWcK9+7m78+9gvstUEsvFN9Sn5Ea2lYPhB3rK5Z5Rg4bAkMTpzXzGEsAmMhBEL0fJxo1OkBBiRFbPiOcLoK7qVbwNbj+TCcARzKBWZCjuzJYVpmkHVdCj8oMxtfk4S6sAXAm1uOVY/e1aG2J32ekyi01ta9rk31FUKslgVrFYl5v0iOfAthvRS1Yb9qMfc59g41Qoi9LWpN000onuAXQTT9ywjBvSOaRhEbg9rgRFxJ1OQGRKozc4gDqIzaeDbr4/WB661aWGhXAQqJyqwlh3Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScVUnc7O04KIzRyP0eanAMoflGtZoTm1QQDeNDlcQUI=;
 b=W5gYdYPiTwt2PWZ50N4j7zWZDDLIkuSztI5bRlqVykkANTi7tvN8pEpEd0A3gxDcoycaB/ErAzbG3jipkwvTbzNGcudEGJKzbB+5op1yU1XsOsZJ8JUjxtyQBGon53GS6iIV1AAi1af5Drmijd87EjLO2OqTyLQewlWEj3oyuMXXSmg7QdQMX5LINFJUsUmvNTaeFPNzh9b6ZumJKUXxZDh16tjMLfb+rGhm/8RtuN8sLaomQoARdV0JvVOJbjqU9vpg7BoOPdEwXSPaiFSXdgP1jyDkr16hFHaS5bG03/6BxdhacRIxIfvC0QJyNW8+HgTzXrCpZ55ePISRP4c+9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScVUnc7O04KIzRyP0eanAMoflGtZoTm1QQDeNDlcQUI=;
 b=zcYWu6+HaBPoznOTgVgvcbXy3wpNVH6X5VXUjrFuN+I0ICFo3m6eW60TmoWSHl/DCXWcinyedniArNrM4/7Q3XggqAdzZQHNBdQB9mlNEfAJwwlBi8xJciEB7z4DWmlXC88HgUSD748duU6zhkI0I16pwZSUVbPs08Y5QfVHpqM=
Received: from CH2PR03MB5192.namprd03.prod.outlook.com (20.180.12.152) by
 CH2PR03MB5366.namprd03.prod.outlook.com (20.180.14.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.24; Mon, 16 Sep 2019 06:44:23 +0000
Received: from CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::344d:7f50:49a3:db1b]) by CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::344d:7f50:49a3:db1b%3]) with mapi id 15.20.2263.023; Mon, 16 Sep 2019
 06:44:23 +0000
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [PATCH v4 2/2] net: phy: adin: implement Energy Detect Powerdown
 mode via phy-tunable
Thread-Topic: [PATCH v4 2/2] net: phy: adin: implement Energy Detect Powerdown
 mode via phy-tunable
Thread-Index: AQHVaW31z8y5cX9S1UqR8JRwRDVNC6crT4yAgAGNXQCAATbdAA==
Date:   Mon, 16 Sep 2019 06:44:23 +0000
Message-ID: <d19897f450cc22a629e0c408b72fbc702ca8fe8c.camel@analog.com>
References: <20190912162812.402-1-alexandru.ardelean@analog.com>
         <20190912162812.402-3-alexandru.ardelean@analog.com>
         <20190914152931.GK27922@lunn.ch>
         <53816513-436e-b33b-99cf-18fa98e468b1@gmail.com>
In-Reply-To: <53816513-436e-b33b-99cf-18fa98e468b1@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.71.226.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e91c201-f560-4559-3f34-08d73a714fa2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CH2PR03MB5366;
x-ms-traffictypediagnostic: CH2PR03MB5366:
x-microsoft-antispam-prvs: <CH2PR03MB5366AF0AD5980F9FA6EB8570F98C0@CH2PR03MB5366.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0162ACCC24
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(396003)(39860400002)(366004)(376002)(189003)(199004)(25786009)(476003)(6512007)(53936002)(118296001)(66556008)(81156014)(36756003)(11346002)(446003)(2616005)(54906003)(81166006)(64756008)(66446008)(66476007)(5660300002)(6246003)(4326008)(8936002)(6436002)(7416002)(99286004)(6486002)(186003)(7736002)(305945005)(26005)(86362001)(229853002)(478600001)(76176011)(110136005)(6506007)(53546011)(76116006)(91956017)(102836004)(14454004)(316002)(3846002)(71190400001)(71200400001)(6116002)(486006)(66946007)(2501003)(2906002)(66066001)(8676002)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR03MB5366;H:CH2PR03MB5192.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: analog.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kfniJMQabqge+sBx0X/075cR/8LYY6z//ViQTlddnubDfSuRKHw/LSukZhaSSCgNfKNveG9Rho/Q/Yhh8lZizLvrBnvJwqHzb34d0lXrtH93hiHkpvYR8QYis2xLmhyGTXU5OiXmgADxSH9dUYdPFvDS/eg+6T0Ip1CI+MEJ3m+nSe/5eQ1I8MNIbeqKXA1LfquCAMU0LCuI1J5QytgYrFru5eT5JZmFvVMk/6Q6YVkizGpn/qEcD9yG5vd1IpKiVDf5flNQjaz7xure7DxqUQ4g7Ye12bOr820ascuP1jtuNco8pSKof1euUEdlb00AfbjeXXaBFHsq44TgQ424SYTTaKWUgS303nuaCbz2TRZJVZpPGOTHaXXl6MJujraPvPKnfsRa4U6VuJ2aAXOXmwMLF5e0JkiUk+E6gfrlAGs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F3CA00B51D26304BA3FD7223515506E0@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e91c201-f560-4559-3f34-08d73a714fa2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2019 06:44:23.6511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vUbObz8G6CRAEZSsKp30otLdx7DAbssA9E3vICDTb2qkrbL3cZLQPkJq8mMc0NXodJ+iOWdF62fTY5bNTVP4sOfR0ZHcolmrsS2L+NsUJPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR03MB5366
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-16_03:2019-09-11,2019-09-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909160072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDE5LTA5LTE1IGF0IDA4OjExIC0wNzAwLCBGbG9yaWFuIEZhaW5lbGxpIHdyb3Rl
Og0KPiBbRXh0ZXJuYWxdDQo+IA0KPiANCj4gDQo+IE9uIDkvMTQvMjAxOSA4OjI5IEFNLCBBbmRy
ZXcgTHVubiB3cm90ZToNCj4gPiBPbiBUaHUsIFNlcCAxMiwgMjAxOSBhdCAwNzoyODoxMlBNICsw
MzAwLCBBbGV4YW5kcnUgQXJkZWxlYW4gd3JvdGU6DQo+ID4gDQo+ID4gPiArc3RhdGljIGludCBh
ZGluX3NldF9lZHBkKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYsIHUxNiB0eF9pbnRlcnZhbCkN
Cj4gPiA+ICt7DQo+ID4gPiArCXUxNiB2YWw7DQo+ID4gPiArDQo+ID4gPiArCWlmICh0eF9pbnRl
cnZhbCA9PSBFVEhUT09MX1BIWV9FRFBEX0RJU0FCTEUpDQo+ID4gPiArCQlyZXR1cm4gcGh5X2Ns
ZWFyX2JpdHMocGh5ZGV2LCBBRElOMTMwMF9QSFlfQ1RSTF9TVEFUVVMyLA0KPiA+ID4gKwkJCQko
QURJTjEzMDBfTlJHX1BEX0VOIHwgQURJTjEzMDBfTlJHX1BEX1RYX0VOKSk7DQo+ID4gPiArDQo+
ID4gPiArCXZhbCA9IEFESU4xMzAwX05SR19QRF9FTjsNCj4gPiA+ICsNCj4gPiA+ICsJc3dpdGNo
ICh0eF9pbnRlcnZhbCkgew0KPiA+ID4gKwljYXNlIDEwMDA6IC8qIDEgc2Vjb25kICovDQo+ID4g
PiArCQkvKiBmYWxsdGhyb3VnaCAqLw0KPiA+ID4gKwljYXNlIEVUSFRPT0xfUEhZX0VEUERfREZM
VF9UWF9NU0VDUzoNCj4gPiA+ICsJCXZhbCB8PSBBRElOMTMwMF9OUkdfUERfVFhfRU47DQo+ID4g
PiArCQkvKiBmYWxsdGhyb3VnaCAqLw0KPiA+ID4gKwljYXNlIEVUSFRPT0xfUEhZX0VEUERfTk9f
VFg6DQo+ID4gPiArCQlicmVhazsNCj4gPiA+ICsJZGVmYXVsdDoNCj4gPiA+ICsJCXJldHVybiAt
RUlOVkFMOw0KPiA+ID4gKwl9DQo+ID4gPiArDQo+ID4gPiArCXJldHVybiBwaHlfbW9kaWZ5KHBo
eWRldiwgQURJTjEzMDBfUEhZX0NUUkxfU1RBVFVTMiwNCj4gPiA+ICsJCQkgIChBRElOMTMwMF9O
UkdfUERfRU4gfCBBRElOMTMwMF9OUkdfUERfVFhfRU4pLA0KPiA+ID4gKwkJCSAgdmFsKTsNCj4g
PiA+ICt9DQo+ID4gPiArDQo+ID4gPiAgDQo+ID4gPiArCXJjID0gYWRpbl9zZXRfZWRwZChwaHlk
ZXYsIDEpOw0KPiA+ID4gKwlpZiAocmMgPCAwKQ0KPiA+ID4gKwkJcmV0dXJuIHJjOw0KPiA+IA0K
PiA+IEhpIEFsZXhhbmRydQ0KPiA+IA0KPiA+IFNob3VsZG4ndCB0aGlzIGJlIGFkaW5fc2V0X2Vk
cGQocGh5ZGV2LCAxMDAwKTsNCj4gDQo+IFRoYXQgZG9lcyBzb3VuZCBsaWtlIHRoZSBpbnRlbmRl
ZCB1c2UsIG9yIHVzZQ0KPiBFVEhUT09MX1BIWV9FRFBEX0RGTFRfVFhfTVNFQ1MsIHdpdGggdGhh
dCBmaXhlZDoNCg0KQWNrLg0KDQpNYW55IHRoYW5rcyBmb3IgY2F0Y2hpbmcgdGhpcy4NCkkgbWlz
c2VkIGl0IHdoZW4gcmUtc3Bpbm5pbmcuDQoNCj4gDQo+IFJldmlld2VkLWJ5OiBGbG9yaWFuIEZh
aW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT4NCg==
