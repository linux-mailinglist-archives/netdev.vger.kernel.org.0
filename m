Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908A13931A8
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 17:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbhE0PF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 11:05:26 -0400
Received: from mail-bn8nam12on2055.outbound.protection.outlook.com ([40.107.237.55]:45124
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231419AbhE0PFZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 11:05:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=loVC7bcPT2EvEpZ2MosdwxrwvdsKsn0MaLZuqQ0d5MGCzeaVNIeYgHoJBoYY3YfxOqhcjyKsKQl/tmp07FNy19xLh+L36lcoWDRZciTsk3BoGg8DNnRNaKsi1tiRvDIW7sDIjgGZH8k6h3ivHgvr0VMaWWRS1Lc54Cc5NbAj1JD+jrddMNnQpGlEfNWbKnWcZq4ZmluFMtOW5JlnojVT/VbYclm4Wo1DyqAkT028tUBd6J1K3juPvt8SerZeNEkY/ZWxpuhp1Ry8Lg9BgoY2Eqqu7EF0mCvBD+JSZs8O1rZOSA8ZhO0qJO0ZAA7OMQzuad4JnqIBN0+m9fuuNdItuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRmXdj7/L8PWnKR/3gF5ZOIV6tIaUmJwEQlmsF8/rF0=;
 b=NsCYDMosvPqn0NoYtDfPJPImM0SaipsY9NlRj4S0UpN327d/SMWdYoTA09GKaYw+6Ph/1WynsI880r8CIPM7bIKz7uFSzwfF5c9gIqGqTQVb+YlmyDyVS3RmrX2AP7hNsR6KLQFq7E5WNNMhtooA/6lqw+q9K0hlFKM09VY6Luyd147ljMw3b/v7EfIf0p2rmHSY2bA5+di5fSUlyOq5Qb1Y65Zqtw4WnGehNKoSXEgc5MLRIQgiE0nmpU39kUxTWyIn50fMebeQFB/JZ3JOTZuBW0IHuixzd/ytXL7b/s4TalCprO3IB0o7jvp1JoXTUbFpMmsCGf9LL1mKKr5kcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRmXdj7/L8PWnKR/3gF5ZOIV6tIaUmJwEQlmsF8/rF0=;
 b=IUzhK9mr/Icd0pNMR8DzZB0yXnXErljauozDdngEHsM6pu7u1kMX3dn9afq20MyWkxTzbI9OKve31JebrEuK3ZALAiMBOukrqXhbJSHPxxxtSCtMqIK2iTqVKIGTfFt7n0hgQn+SecqWdcY3t6cfB+Uuz9fq1uUBYm60oDyHnTI=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by PH0PR10MB4598.namprd10.prod.outlook.com (2603:10b6:510:34::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Thu, 27 May
 2021 15:03:50 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::5021:f762:e76f:d567]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::5021:f762:e76f:d567%7]) with mapi id 15.20.4173.021; Thu, 27 May 2021
 15:03:50 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Lenovo I219-V e1000e device has severe RX checksum errors
Thread-Topic: Lenovo I219-V e1000e device has severe RX checksum errors
Thread-Index: AQHXUwmAWyLoQ9nmJEmSg1nL2Isn6g==
Date:   Thu, 27 May 2021 15:03:50 +0000
Message-ID: <a2011d9c626e57cffa0b0cee35d31cb481599244.camel@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.0 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c01e12e4-ce6d-47df-dcd8-08d92120a2fb
x-ms-traffictypediagnostic: PH0PR10MB4598:
x-microsoft-antispam-prvs: <PH0PR10MB45986E26DBE534B43AFA8747F4239@PH0PR10MB4598.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: niN7yHX/1SrLvYGB86BcM5LZjCEkE3DDJAPTMgwtwlr15LSGLTbe6BfiVmSLaGi9l8W+CC3ydAKIrT/p1mcdRpAi4XBUvaaNmNrHTkkniEU55ivFl2Jb0wMVB4ntxFnOJD2QyBsmiSD8O4CyPGdfLK6uei0eO867YQwZtZjCp9qErqsaDoTnnNZQRC/iIt+Aqhmmmn0oZ3HcfzJhcOkb1BdymS4iEPCtYZIdziY0+lQN655WGCVUXOCcZ5vJe7Xixn2Yi5V1IbZMCe7pC1d0Wi8K6nZFS4YOluFa2/OWTrHpVZzBjC83HedxPUKb3CNeaAW9dl/7oMJtEeT1MMf8GUyMRiSjAvr1/t/YPn0LnraCs+9XIHZhGwib+BLlh4TtNgSeD9uQ2J4YuiG50jljTlLvS4+TxA7AmHqgxPzrbv6XqrsSLXOb/o0ebh7378JYzzYSv5IsGe9CgZCi3E1g8MKqFrINuvlqUrCdNhEdAP+ZBcGET/nOainI0FgpA7tkZEYYwbP+slCcALW9ZhzWGCuiwyZ13pfM8CHxeLf8w/dX68BfaYFgt6DZwemi+LI+MiDF1tAkBCdGYzEkpYVJyVGb16mD50ZzW462jfrPgH8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(6512007)(26005)(2906002)(186003)(86362001)(122000001)(8936002)(38100700002)(8676002)(6506007)(6486002)(71200400001)(64756008)(66556008)(66476007)(76116006)(66946007)(316002)(91956017)(4744005)(2616005)(5660300002)(6916009)(66446008)(36756003)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?N3NPTzZWTnIrcE5scjFOakF2SmNKRnJUbGJGNFN0cG41YlhzOUNFYTVOaWpQ?=
 =?utf-8?B?ZlpHTWRtNi9USGpiM3V0cVpKVmhPUFVzaTloUTZRa25iL01yYThLUjMycFpm?=
 =?utf-8?B?Y0lxTnJpUWxLTmpRU0Zvbm1LKyt3RitMR2F3TTlBK1RyYjdMRE1GRzNhZmlQ?=
 =?utf-8?B?eXVjVTMzSTgzazUrNlNLbEVMVVJ1TlRXbGdxM3IvK1VxSms3cVRCM0wwdFVI?=
 =?utf-8?B?TkkvV3NtdmREUUlwRkJ3dVUwYkg2MjRIRHdDSzZvcnZIMHlVeWY1SnBzbVdS?=
 =?utf-8?B?VTY2ZW84YW11SUdmNVlEZVVWV3YyeFZpK25PbVhZRlJUemwrb0prVisvYm1l?=
 =?utf-8?B?TkkwNGhtcFpnRldUTGdBUmdvQ0V6KzVIaDR1MjE3bTUvelNRR2l6dlc0WmhX?=
 =?utf-8?B?OFNPeExjaUh2MTR2UXhYbVZHaWIxQ0R0VE5qZjRHcUpSNzcyWjJQTyt0bmtI?=
 =?utf-8?B?ckIzakxTdVpFR3FFZXdZUUZwMEI1SGJiYXNLNFBLbG5FQnBzTTdRVXhPeFZK?=
 =?utf-8?B?dE4rQWUycUJqOGR6SDVYNjVWNXhjRTNkLys3a24rek4yMmlFY3RTeDFTTFlI?=
 =?utf-8?B?eWVvM1lwQTRMYXRodDV5cE4weXRrMjVnaFVUSFkzZC9Mb1FaZzZpM1B6VzBX?=
 =?utf-8?B?QjFyemgzNVU3aTh2NmxSeG9uY1l3b1lQcHh6RVMzeWUwOW1rM1FXWXFaSE9k?=
 =?utf-8?B?dnlzVUlVbWNqdHhUOUdnZzhkbFlTTDBkcGhBanFVVWQvUFMxZENJNUZWL1V0?=
 =?utf-8?B?SWY5dkJUa01vRDRKT1FQWXRmRHVHc2ZmNzl0ZE1kOXhLVzY5bmV3WEdXMEdH?=
 =?utf-8?B?ZkFuNGdseGZJM1JHK1dVRXd0VGNaMzFUNWl6eXFGRGIwWis3cjNXcEtuaCtS?=
 =?utf-8?B?dXJERFlDNHI0NlV6dUN1RXFUeTBmUHJlRXM5RFhjRU1Tam5rbmVhRXlwaXBL?=
 =?utf-8?B?bFdZT0xJdmdlU01Cd282RGNpenZHZFREV2tiYzNJcU0wVS9VZ254MnF0MEll?=
 =?utf-8?B?eWpVQktDSW1ZSXBVSEFva1hBRWJHaitNVm5xakJab21tR01yMEhZcTlFRG1u?=
 =?utf-8?B?bFY2aTNQTVBLdERuTjk0WUs3M3lGWGYvdWNwTjMzNjFaZzU0bmMwZlF3NkZZ?=
 =?utf-8?B?cXV1MGt0emNRbEZySWpMRGxPME9KaEpLalFyNkVuUzk0eHBvMHlxYXkwTGZu?=
 =?utf-8?B?bndFbWNtZVd2Q1JYcW02VHlzM29taWQ1bWRBMGE4U3NhOXNrN2NyVzRWODFa?=
 =?utf-8?B?MVk2NXhCWjN4dGw5Rytqd1Nxb1ZDUy9wVy8xS3JlRzdCQnJyM1V1MCtjRVR3?=
 =?utf-8?B?RkdOSmxodHNUNEtHM2pZUXZWbDVQdGJXanUwQ2hwQU1ZQVdpSDhROEhOb2lp?=
 =?utf-8?B?ZkR2Sy9FT2h2d3Zpcy8zSThNWnJKSFNBQTV4VlFSam15MmFXUHFJTHpVQW1I?=
 =?utf-8?B?OVFPN1NFdmZiNW1rQXN2S1drN1BFVFlnTVFFV3BBbDdQcVN3UFdERm0zcEVD?=
 =?utf-8?B?b04yelNLV1ViaHZvRDVRSzJweXB2SkxUU3NvdlUwZVp4MDJMaFhEK3BsTnJE?=
 =?utf-8?B?bEk4KzRYNzNTVGovTnNIS0UrR1l2aTd6WkFES3hOY2RVTzFvcFIwM1dyc2RO?=
 =?utf-8?B?VEZzV1Znb2lMbmxEbkd1eDJlY1dlMCtyVldNc3BybWx3WlRCNVZsWk5WRG1q?=
 =?utf-8?B?NHNpenhxU3JlNm1icExXeFp5NVRldGRQMHZKaUxvWXVGaEx0ODdTSk1PeXZ4?=
 =?utf-8?Q?dO/b7BTJq81lVl63nrIfJGlDhW+z+aXIL58azzH?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <ABD40D910B886B4FAEECD8E766D6CA11@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c01e12e4-ce6d-47df-dcd8-08d92120a2fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2021 15:03:50.3425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xndkqt6/t0f4CbKee5I+LFKO5uE64YTs/rT1FSOJO+egoLWa1ZIAbd+UUCht8UUOy0JgqQv79cviz3Hm4+33Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4598
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MDA6MWYuNiBFdGhlcm5ldCBjb250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiBFdGhlcm5ldCBD
b25uZWN0aW9uICgxMykgSTIxOS1WIChyZXYgMjApDQoJU3Vic3lzdGVtOiBMZW5vdm8gRXRoZXJu
ZXQgQ29ubmVjdGlvbiAoMTMpIEkyMTktVg0KDQpUaGlzIGRldmljZSBpcyBpbiBuZXdlciBMZW5v
dm8gbGFwdG9wcyBsaWtlIFQxNCBnZW4yDQpVbmRlciBMaW51eChXaW5kb3dzIHNlZW1zIE9LKSB0
aGlzIGRldmljZSBzZXZlciBuZXR3b3JrIHByb2JsZW1zIGFuZCBpcyBhbG1vc3QgdW51c2FibGUN
Cg0KVHVybmluZyBvZmYgSFcgb3B0aW1pemF0aW9uczoNCmV0aHRvb2wgLUsgZXRoMCByeC1jaGVj
a3N1bW1pbmcgb2ZmIHR4LWNoZWNrc3VtbWluZyBvZmYNCmV0aHRvb2wgLUsgZXRoMCBzY2F0dGVy
LWdhdGhlciBvZmYNCmV0aHRvb2wgLUsgZXRoMCByZWNlaXZlLWhhc2hpbmcgb2ZmDQpldGh0b29s
IC1LIGV0aDAgcngtdmxhbi1vZmZsb2FkIG9mZiB0eC12bGFuLW9mZmxvYWQgb2ZmDQoNCk1ha2Vz
IHRoZSBSWCBjaGVja3N1bXMgZ28gYXdheSBidXQgbmV0d29ya2luZyBzdGlsbCBzdWZmZXJzDQpQ
aW5nIHRpbWVzIG9uIGEgbG9jYWwgbmV0d29yayB2YXJpZXMgd2lsZGx5LCA+IDEwMCBtcyBpbiBz
b21lIGNhc2VzDQpHb29nbGluZyBhcm91bmQgdGhpcyBzZWVtIGxpa2UgYSBjb21tb24gcHJvYmxl
bSBmb3IgTGVub3ZvIFQxNCBnZW4gMg0KDQogSm9ja2UNCg==
