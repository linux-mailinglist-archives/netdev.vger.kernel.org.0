Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55793A9A9F
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 08:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731519AbfIEGZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 02:25:20 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:3644 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731109AbfIEGZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 02:25:19 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x856OBTG000730;
        Thu, 5 Sep 2019 02:25:14 -0400
Received: from nam03-by2-obe.outbound.protection.outlook.com (mail-by2nam03lp2051.outbound.protection.outlook.com [104.47.42.51])
        by mx0a-00128a01.pphosted.com with ESMTP id 2uqjrah6n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Sep 2019 02:25:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VpcRoXjJktZw4JvU7GI5vAaHB2TzOtS9h9hzDc5j6a/eRzAXkLUCRAYt/Jk+ILxjzxaZp51D4rasFnvfn+kjFsDZ8ZYdGPah8QTyQ083it5FpBpr1l8e7Rn/75vL3ZYFduYYXtxNMvzCpAcI3S+dysvlIUxqoM6nc5syG7QOYx6Sn/I5FQBQnuA/vyeYJ773xxMMA9mZQqg8N1PM7KX6KcrIZyapj/xqP7kmInd6gWDQpQVg0J+Uu/fqHoiguJYkaYFn21Fd8rnDvqtJcRPxUUvrpkK6l4sS3Pq9ZyzX6XCiB4eH+UcIunPd4S7AyCsCXw7Fa82jUPRglzHlXJfdLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dqKhGqqafYfESryIr+oRIuk3wUzuRMfm+WeXiXJ8Txs=;
 b=T9zRqPoRDrTurCREOS6LYIHSmXtiBc93TbaN8liizDg6I5l6L7POP+LAnZ1Dyi/6gXPIk4+PSl6pYFN1f5XcWnq9noUanNjY8GU1PV6lnntjIdnKD9iwBxhx603VED8xhYcO2+hRm3C8pAq392hQ93Wz4fCVJz1r6Bg+IIQg4v+YvAWS1hhK4QwVSmtxF/UhhXDx5Co5NfV9KMP//iMzjwnURP5/DX9I4vO2Ze0EYp4+Qo/2f9ErPqLBoAnREvB0eDiMaz5TYu60aroE6v8cYq99eILCyj6Xvf+SOCk0wSO4khFQXz8s8iN116yJMPhsVctvA2ow2Sm0jWCmts1jWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dqKhGqqafYfESryIr+oRIuk3wUzuRMfm+WeXiXJ8Txs=;
 b=geC6ARY6pK7SvM6GNDxmzf5EiSjZajO++w3zdz9gIXB7OJ3nQXJ0CcmQps+WXdx6TYodLwj9eT1w0RwRDTbvrsdajNgbR1RuuvXFslri7MaMwGhSHBZ2d2ynDk6CbKFn58qE6yogVGyMma4cJ/fVZCK34qx7C7JLC2u3DbWQLMc=
Received: from CH2PR03MB5192.namprd03.prod.outlook.com (20.180.12.152) by
 CH2PR03MB5157.namprd03.prod.outlook.com (20.180.15.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Thu, 5 Sep 2019 06:25:13 +0000
Received: from CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::ad16:8446:873b:4042]) by CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::ad16:8446:873b:4042%3]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 06:25:13 +0000
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
Subject: Re: [PATCH v2 1/2] ethtool: implement Energy Detect Powerdown support
 via phy-tunable
Thread-Topic: [PATCH v2 1/2] ethtool: implement Energy Detect Powerdown
 support via phy-tunable
Thread-Index: AQHVYyQB6qcesgWQmU23B3bQFKorp6cb7rGAgADipwA=
Date:   Thu, 5 Sep 2019 06:25:13 +0000
Message-ID: <361eb94a4da73d1fa21893e8e294639f0fc0bcd2.camel@analog.com>
References: <20190904162322.17542-1-alexandru.ardelean@analog.com>
         <20190904162322.17542-2-alexandru.ardelean@analog.com>
         <20190904195357.GA21264@lunn.ch>
In-Reply-To: <20190904195357.GA21264@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.71.226.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a73a648-6ec9-4a30-dda1-08d731c9cf4a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:CH2PR03MB5157;
x-ms-traffictypediagnostic: CH2PR03MB5157:
x-microsoft-antispam-prvs: <CH2PR03MB515790C55E157D66726FAC54F9BB0@CH2PR03MB5157.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(136003)(376002)(39860400002)(346002)(199004)(189003)(71190400001)(25786009)(71200400001)(6436002)(1730700003)(4326008)(91956017)(66476007)(2501003)(478600001)(66556008)(64756008)(66446008)(66946007)(256004)(486006)(316002)(446003)(76116006)(14454004)(6512007)(36756003)(2906002)(26005)(99286004)(53936002)(186003)(476003)(2616005)(6116002)(2351001)(5660300002)(305945005)(6246003)(66066001)(86362001)(5640700003)(6486002)(76176011)(118296001)(229853002)(8936002)(8676002)(6916009)(6506007)(7736002)(81166006)(54906003)(11346002)(102836004)(3846002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR03MB5157;H:CH2PR03MB5192.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: analog.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eWJHKChnDZbWTARInB5h+3/dp67dSMKmNyc/yWRcNmsc/ErTOcmWsgiub2U0m3jlVPbz/VC8NT6SDpILE4KKLbzWTbavtSG/SUKdYHV3N5eKJuVw9ZLo9UJ6i4dyi2eA5zyDYEMryekhref3cT8Md3CQATxUS918O20BVdZWLItCIv3N+Bs8vYa/3o7cXFlyE0M3Fwm3H2n5aA+tlBbuTEQpapjfYoPeRgJbX9F2bXy6UR48x1zzqgJGp8Ul6rNNomB+CVmNodJgfX8YBsPT0adTjAPs3GIuKgQVcehYguc/V4br6DyAICMJ3YYajdHloz1MIdNzUhlhc/DBz4REKeixNHO8teRQJ4JqhdA1NEYcl8k6gGhVk5jN0/e1fQl3Ruo82pam+CLm2+D4DWrMWgzR0yan+Dgs+g9VwTMAipU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1BA918C9BD23494ABC7477F27478EBE3@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a73a648-6ec9-4a30-dda1-08d731c9cf4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 06:25:13.1521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c8hJPblyvDD5cHoasY4tRibc6N9Ou4Jrqo5nFu3BoTuX0VTmpOnKnTSsGE8Sw5PBXhtsR15n+o0u92d0y3bUpAnsgtjcd+CfGnpckBXXa6s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR03MB5157
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-05_02:2019-09-04,2019-09-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=949 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909050065
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA5LTA0IGF0IDIxOjUzICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gV2VkLCBTZXAgMDQsIDIwMTkgYXQgMDc6MjM6MjFQTSArMDMw
MCwgQWxleGFuZHJ1IEFyZGVsZWFuIHdyb3RlOg0KPiANCj4gSGkgQWxleGFuZHJ1DQo+IA0KPiBT
b21ld2hlcmUgd2UgbmVlZCBhIGNvbW1lbnQgc3RhdGluZyB3aGF0IEVEUEQgbWVhbnMuIEhlcmUg
d291bGQgYmUgYQ0KPiBnb29kIHBsYWNlLg0KDQphY2sNCg0KPiANCj4gPiArI2RlZmluZSBFVEhU
T09MX1BIWV9FRFBEX0RGTFRfVFhfSU5URVJWQUwJMHg3ZmZmDQo+ID4gKyNkZWZpbmUgRVRIVE9P
TF9QSFlfRURQRF9OT19UWAkJCTB4ODAwMA0KPiA+ICsjZGVmaW5lIEVUSFRPT0xfUEhZX0VEUERf
RElTQUJMRQkJMA0KPiANCj4gSSB0aGluayB5b3UgYXJlIHBhc3NpbmcgYSB1MTYuIFNvIHdoeSBu
b3QgMHhmZmZlIGFuZCAweGZmZmY/ICBXZSBhbHNvDQo+IG5lZWQgdG8gbWFrZSBpdCBjbGVhciB3
aGF0IHRoZSB1bml0cyBhcmUgZm9yIGludGVydmFsLiBUaGlzIGZpbGUNCg0KSSBpbml0aWFsbHkg
dGhvdWdodCBhYm91dCBrZWVwaW5nIHRoaXMgdTggYW5kIGdvaW5nIHdpdGggMHhmZiAmIDB4ZmUu
DQpCdXQgMjU0IG9yIDI1MyBjb3VsZCBiZSB0b28gc21hbGwgdG8gc3BlY2lmeSB0aGUgdmFsdWUg
b2YgYW4gaW50ZXJ2YWwuDQoNCkFsc28gKG1heWJlIGR1ZSB0aSBhbGwgdGhlIGNvZGluZy1wYXR0
ZXJucyB0aGF0IEkgc2F3IG92ZXIgdGhlIGNvdXJzZSBvZiBzb21lIHRpbWUpLCBtYWtlIG1lIGZl
ZWwgdGhhdCBJIHNob3VsZCBhZGQgYQ0KZmxhZyBzb21ld2hlcmUuDQoNCkJvdHRvbSBsaW5lIGlz
OiAweGZmZmUgYW5kIDB4ZmZmZiBhbHNvIHdvcmsgZnJvbSBteSBzaWRlLCBpZiBpdCBpcyBhY2Nl
cHRhYmxlIChieSB0aGUgY29tbXVuaXR5KS4NCg0KQW5vdGhlciBhcHByb2FjaCBJIGNvbnNpZGVy
ZWQsIHdhcyB0byBtYXliZSBoYXZlIHRoaXMgRURQRCBqdXN0IGRvIGVuYWJsZSAmIGRpc2FibGUg
KHdoaWNoIGlzIHN1ZmZpY2llbnQgZm9yIHRoZSBgYWRpbmANClBIWSAmIGBtaWNyZWxgIGFzIHdl
bGwpLg0KVGhhdCB3b3VsZCBtZWFuIHRoYXQgaWYgd2Ugd291bGQgZXZlciB3YW50IHRvIGNvbmZp
Z3VyZSB0aGUgVFggaW50ZXJ2YWwgKGluIHRoZSBmdXR1cmUpLCB3ZSB3b3VsZCBuZWVkIGFuIGV4
dHJhIFBIWS0NCnR1bmFibGUgcGFyYW1ldGVyIGp1c3QgZm9yIHRoYXQ7IGJlY2F1c2UgY2hhbmdp
bmcgdGhlIGVuYWJsZS9kaXNhYmxlIGJlaGF2aW9yIHdvdWxkIGJlIGRhbmdlcm91cy4NCkFuZCBh
bHNvLCBkZWZlcnJpbmcgdGhlIFRYLWludGVydmFsIGNvbmZpZ3VyYXRpb24sIGRvZXMgbm90IHNv
dW5kIGxpa2UgZ29vZCBkZXNpZ24vcGF0dGVybiwgc2luY2UgaXQgY2FuIGFsbG93IGZvciB0b25z
DQpvZiBQSFktdHVuYWJsZSBwYXJhbWV0ZXJzIGZvciBldmVyeSBsaXR0bGUga25vYi4NCg0KPiBz
cGVjaWZpZXMgdGhlIGNvbnRyYWN0IGJldHdlZW4gdGhlIGtlcm5lbCBhbmQgdXNlciBzcGFjZS4g
U28gd2UgbmVlZA0KPiB0byBjbGVhcmx5IGRlZmluZSB3aGF0IHdlIG1lYW4gaGVyZS4gTG90cyBv
ZiBjb21tZW50cyBhcmUgYmV0dGVyIHRoYW4NCj4gbm8gY29tbWVudHMuDQoNCldpbGwgY29tZSBi
YWNrIHdpdGggbW9yZSBjb21tZW50cy4NCg0KPiANCj4gICAgQW5kcmV3DQo=
