Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8303D4970A9
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 10:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236025AbiAWJIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 04:08:46 -0500
Received: from mail-sn1anam02on2084.outbound.protection.outlook.com ([40.107.96.84]:43470
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230401AbiAWJIp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jan 2022 04:08:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FyHpLSvsi7CMNp8jLX8j06/Guu45ABbGMldM760zoO0PGM1iRu3TvpTeyyW1cJuhgWpdwoX9j3DBuFSxeFyXBv2cAlg4HXBzyVRJHG1ZgHbb1FroqLs1bH383/Bj6HI/eYP2w7Qms5H5Oh6Ty4LAvmGqrawcvCnelbM6PjdqkSthDc8NzZmHQKEAAa/eA/+EfHcjAfH2msiTseYPi0ykUe9ITuxGnlJq5IgBumg8coIK9/mcN2qOhcYzx8115kmVcPy2o0EfUDfl+9sohABZhHoVSmCYf7RhDZI6hWjeKGfTJeREgQeRbG2Z+92dOGj/O3jdt4YGVI31S8JX3vpArw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+tkSMbnx5sn6aDVfriyds4TT9Ync4AGJ8GneRO7TNMY=;
 b=aOEl+axDIByG8ODjb0Gyz/EgIwu3Xj/Owrq8wKnhm3MhbMGaCnJgrh8rBE5I9Fcyhs0XjWlbrKztg/PYcOHAOZzl2d5hB3rHbXLtWJrezGov/GpVYyxsYs2xsp7g9eSx24Xsoo3Rf5fcdQVC7HF05Rk0gxujmgImIdsIhsQ+qoXZLqj+F+Z8whbD/iGkE/jho3z9nnv3gezRf9mb03SQhBETjqKflDHKnQb71oP6216jpM9p3vKwcaBA7HpLta7oCdO8BPdGgdVGltpHTSV6q15hdu1EYuoLZVzGUg8iYZ50xOoanYTuC230OMrt9uAgMXphOOsrCEy+1muyd3A1Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tkSMbnx5sn6aDVfriyds4TT9Ync4AGJ8GneRO7TNMY=;
 b=ZbAQKUK3s2UT9lVaWVQHCY99xjvqrXt2QPkK0BwviGba7VWSNS+hAu3E4MeY7mxhLnFQq7IHYQUP7qvPQf3LnYPs7xHeSGaAhMOMeIvcDuccwQb2bZ92c9roZ605YT6RtNeZjI2wOoIPQSAkO9D0bIDADAmACaoK4a6ucX3/q6a8C8ED5YC7p4TKF7Y/FgUZVSXc10jILYWkjbSD9Szvo44HNFjIoPg4VmBe13FSYrm6KSw5psSnBKDZ4zatXTCYGOr+aZX5HJ+aRFhQ/5UMPJyFen4oXxZ1ti3kvn52roD5to8iTaQ0EZ5+88C46TTwtrPdNUYnfMNzooSuB1zOEA==
Received: from PH0PR12MB5452.namprd12.prod.outlook.com (2603:10b6:510:d7::16)
 by BYAPR12MB3077.namprd12.prod.outlook.com (2603:10b6:a03:db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Sun, 23 Jan
 2022 09:08:41 +0000
Received: from PH0PR12MB5452.namprd12.prod.outlook.com
 ([fe80::c071:3b53:4a01:8b91]) by PH0PR12MB5452.namprd12.prod.outlook.com
 ([fe80::c071:3b53:4a01:8b91%4]) with mapi id 15.20.4909.017; Sun, 23 Jan 2022
 09:08:41 +0000
From:   Moshe Tal <moshet@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Amit Cohen <amcohen@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net] ethtool: Fix link extended state for big endian
Thread-Topic: [PATCH net] ethtool: Fix link extended state for big endian
Thread-Index: AQHYDeP6DXJXPfpZqEWMZDeLohMMBKxr/FMAgARZhAA=
Date:   Sun, 23 Jan 2022 09:08:41 +0000
Message-ID: <172d43f5-c223-6d6f-c625-dbf1b40c4d15@nvidia.com>
References: <20220120095550.5056-1-moshet@nvidia.com>
 <Yel1AuSIcab+VUsO@lunn.ch>
In-Reply-To: <Yel1AuSIcab+VUsO@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49289885-088b-4f67-5519-08d9de4ff363
x-ms-traffictypediagnostic: BYAPR12MB3077:EE_
x-microsoft-antispam-prvs: <BYAPR12MB307780C41D8A585DAE3F88CAA05D9@BYAPR12MB3077.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wb72J+A+hhdUw5sC7CII1bNOHSthFc/43CzaVIx59uoroBqdeKTZhlIXPkVfRsO/PD1ZZISC2grwh2D57RxHKjtQv4XheSlBsJwgye6+KQZjijBjHLu9XGzcYHz/R7wvEjf+zGufcLFuIoc34C/5GQTFu1vdGdBblnKsjusLB+2sDjKB/s6uYn3U07fUmfY4I4qU5HYWRQtTqsAX2jtW356tT8QHPakGVOHNHQAYiabLcyD9M2fITnRt3YyZJXxpWzYrYsYw6QEfcQLilovK+RPDkoeNxzDOGLvNltq1MumonN00D8ajxyz5IwkJCNYrauiwBEZAyjKivP1GlIFTS7yMuaAThc/tPj1SsCXzfX5ge5/OoLH2HGjLKZiGYNqZafiHJAbmqEpAFQLhARSHeFD0kPaf9gp3WvN4g4uCqqf14dePMejR03D3NkC7S+Jt0h8Nfxgg7Ni1Vabyw3H50lq3c1EVSp0sY5xlh7p+2i+0/2MjwD9anxcFSZm8/vDdWr/EHcYcUtVhAUZXwVsvvVRa6ZG9yRzyudjAFBxvENj379KrJGpBOiX4wwS4g3N0TC9lvVi0dlVwrEgXVFHkig+c6bpnAZAsSoEYuYWzmiSOGWsCmun7wz5JpfM9Q+DNNf+VyY/qM2nZf0JoQVza3rvn7hP0IBXvoYrb8akdDkwrBqoquVu08VXSwsUZ/TKPFxHNatOv74T4qo/z/OTGzNyAPNvSAhpKlTfG3O/39oFEHKrzMjDmdc7t/ITl1NPZ6YQi9lUZA812r7q5k/xIZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5452.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(31696002)(66946007)(36756003)(64756008)(66556008)(107886003)(91956017)(5660300002)(53546011)(66446008)(76116006)(66476007)(38100700002)(6506007)(4326008)(508600001)(122000001)(186003)(83380400001)(2616005)(8676002)(6486002)(6916009)(38070700005)(6512007)(316002)(31686004)(2906002)(8936002)(71200400001)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dlpTWm1qNUVoaDl5ejNYaGhmRVA2SkpTdmJDUnhUREtUNXZ4ZG5Sa1liZ2xs?=
 =?utf-8?B?WUdJVTR2MzkrS2M0WmhEMXoxWmk1aytQbEdGY1hNR2FvUFRXZkFOcmZsNW5V?=
 =?utf-8?B?VW5zZ2U5dzBlMm9YZkk2dmZnRDkwYldZOWRjTXhtOXpmKy8zTUY5NnZDaklz?=
 =?utf-8?B?bDJYNVpvNi9SWVpGOEVSZUN0bWFFS2RXOVZvcklwYTJHbXo2NmEyNjArODc1?=
 =?utf-8?B?T1hYVHdHWDRKZ1Y5ZzlXc09taEJwRDhNcTdhYXhOcDBnQkJqcjczNFdwa3lK?=
 =?utf-8?B?S0Z6Y3VGT0ZVck5vRFdacWY3dXdFT3QzUE1yaDgwVnlobVFBbm5lWkpGWTIw?=
 =?utf-8?B?NlljbzBzTEQwVUxIYlYvS2p2ZXJubU14MWo2RjdnNUUvaEtjd2hJNUFxSS90?=
 =?utf-8?B?S1V4d3Nrd1M2Sm96ZU9ZaHI4cWVyN1Z0K0c1UnozRld1UEdpdDUrR1V3dW5x?=
 =?utf-8?B?cE13T1g2OVg4NlBGaEltcGk1Sk1kb1djUmZBQWlHMGc3OXBhakNURkhDYUc5?=
 =?utf-8?B?RlNnV3BLSS9QS3A3LzFDbldLWGtIQ28wM1cwY3d2NmtYYTc4aDA0RjlFMVRB?=
 =?utf-8?B?SHRWZUdBQlE3S21oNmFPWEgwNXZ4M2lWUjRmVWVwUjRpMHZTdlF6OHQ0dGR4?=
 =?utf-8?B?c0tjTU1PSTJYZ0NVclVBSTRuUWhzTTRzY1VnZGF1ck83VDRXbERxMlAwOEx0?=
 =?utf-8?B?bmV1a0RqY2Q0VC8xdDBYSnRSTkd5YjJCNGRZY2RCTTVWY29iNVZTTE9HTE1k?=
 =?utf-8?B?d1Q0YzF5eEVmNlNZSDBhRmZZR1Q1YnBGeDc4cGY5dzNRVGZUMndvaGp5S3do?=
 =?utf-8?B?UGF2TTVmczUvTkwrUDFORUJNQ01QRkhnMDd3UGxtZmdqZmJxMm5jaS9KTkF6?=
 =?utf-8?B?dERIWjNVaEdkT2Y4YklVRytteDhjZ09oOUI0TGpzdmRrU3Y5WTFpMlU5TlJY?=
 =?utf-8?B?N1dRcUtVYThqd0ViSFAycHhPTFczdXVKcUI4NGpvUC9HUWtadmkrd2ZLSDd6?=
 =?utf-8?B?WUtzWUNMbFM1dVJIeCs2NzhGMXAvMmVSTy9vRnFBL3Buc0hjdmhQcy9CY1Ez?=
 =?utf-8?B?cmlsZVByMC9vS3FIbUhyUm1YY2J6RnN1Q2QzWkJBbUtld0V1VmhOVm5Pd2Mz?=
 =?utf-8?B?a2pxUXB3a0FycllFcVlzWjRPUExuY0tibnlGeStza1BRbWdiMk1tVWlvT21N?=
 =?utf-8?B?aHRJOS9ZS0h1a0Z5MThZM0xYUHBnRnBJblhyRFdiNURWZkQ0dk5qWnJyZGg2?=
 =?utf-8?B?RHBJVTk5TXpBNU5MTk4rYzJ2cFJ1VFBlVTZRcTlTMkhtRVFvMlVKcEpjZUxs?=
 =?utf-8?B?YmZ6UFMrcUt1L0NZUk53aGNTMHlyWlFqTmloUkVPT3pHOEhVci82WXAzSlVY?=
 =?utf-8?B?d2I1MlNJbC9IZTd6UGN6RVdCZ2VtWWhpUXoyMGg0NHBKWVVodSsxcEhscDdM?=
 =?utf-8?B?QUI1THNsUlhXRWNzbVpZQ3FSUktDaDBPY0kvVEpLdkg3MU9ZWHJ4UjI4UDBL?=
 =?utf-8?B?SURIRk4vakdaaEtJRUx0OG05ODE3bEkvQlFqazdaRW8waWNzU21GS0NKcWZY?=
 =?utf-8?B?OFgrU05tVmNmRjRCamJmQjVaNzk1cEFiQzVwMkVvcjUzNjRsQjgwNU5DUllZ?=
 =?utf-8?B?U29DdmJyRFV5YlQ3bmR5WTlISThZM0F5UnVrTlVaYW0rNGVMRFpyQ2NzU2dH?=
 =?utf-8?B?MnNzZnNUUWFvaW1iQzFxUUZkbkdla2FCVXdYN2Q5K2p2bWlkdHRnbFFSM01t?=
 =?utf-8?B?YzYybEphbnp2WFhsSlVQKzU1WC9JQkViN1VxOElhRzRaQWozcFNrN3YvTmkx?=
 =?utf-8?B?NkZnbWNQN0ZjSnlLcTRyUTdhZ0FrWW04U0M1K2g3UDRtLzcvZ0RLWjJMb2Ix?=
 =?utf-8?B?akNoK2VOU2ozRGlKY2dtZW1BMTFNUkZFNllnTGR4N1ZDbjhTZEJhM3NZSEhZ?=
 =?utf-8?B?QWNTaEdLdnMrRkZjemZuTk8rYStSTHNLelRjYStJTE9abFp1bEdvclB2QS9J?=
 =?utf-8?B?Z25jZFR6KysvcnVqRFhBaStvc1dJY0dZZEwvSUZ3U2JlYU1mVy9mYWlpTUNQ?=
 =?utf-8?B?WUIwb0RidVVyNVZXRjc3OGZqQjVXbFo1TWI3YVRjNnVmQnZzTy9MTXh4b0tj?=
 =?utf-8?B?NzN5RnFRVHgyaDhKNWN2bGVtRHYya3p2QWdiMlo2L1dzUDlVa3ZGNHByT3Vm?=
 =?utf-8?B?bnpYaXFMSlh6eGUrWHNFeDR5Qkc2dUdvTUZTT1YzbkZEK3F5VlNZenJoQjF5?=
 =?utf-8?Q?VTkL0+Z0PQyxEh/YuPP2tOjbqKodjMLtuXweB0BHxQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <49FD6A943B71AC458077FE502F36C8D7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5452.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49289885-088b-4f67-5519-08d9de4ff363
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2022 09:08:41.4917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mhzNEzBKtFztEBK155UST+H0bR3ptsrIQ3i5HVb8ozyumRTAki1PDOzAtw25nsS4G37Xmc1nexesWwDLSdg60A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3077
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAvMDEvMjAyMiAxNjo0MywgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IEV4dGVybmFsIGVtYWls
OiBVc2UgY2F1dGlvbiBvcGVuaW5nIGxpbmtzIG9yIGF0dGFjaG1lbnRzDQo+IA0KPiANCj4gT24g
VGh1LCBKYW4gMjAsIDIwMjIgYXQgMTE6NTU6NTBBTSArMDIwMCwgTW9zaGUgVGFsIHdyb3RlOg0K
Pj4gVGhlIGxpbmsgZXh0ZW5kZWQgc3ViLXN0YXRlcyBhcmUgYXNzaWduZWQgYXMgZW51bSB0aGF0
IGlzIGFuIGludGVnZXINCj4+IHNpemUgYnV0IHJlYWQgZnJvbSBhIHVuaW9uIGFzIHU4LCB0aGlz
IGlzIHdvcmtpbmcgZm9yIHNtYWxsIHZhbHVlcyBvbg0KPj4gbGl0dGxlIGVuZGlhbiBzeXN0ZW1z
IGJ1dCBmb3IgYmlnIGVuZGlhbiB0aGlzIGFsd2F5cyBnaXZlIDAuIEZpeCB0aGUNCj4+IHZhcmlh
YmxlIGluIHRoZSB1bmlvbiB0byBtYXRjaCB0aGUgZW51bSBzaXplLg0KPj4NCj4+IEZpeGVzOiBl
Y2MzMWM2MDI0MGIgKCJldGh0b29sOiBBZGQgbGluayBleHRlbmRlZCBzdGF0ZSIpDQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBNb3NoZSBUYWwgPG1vc2hldEBudmlkaWEuY29tPg0KPj4gUmV2aWV3ZWQtYnk6
IElkbyBTY2hpbW1lbCA8aWRvc2NoQG52aWRpYS5jb20+DQo+PiBUZXN0ZWQtYnk6IElkbyBTY2hp
bW1lbCA8aWRvc2NoQG52aWRpYS5jb20+DQo+PiBSZXZpZXdlZC1ieTogR2FsIFByZXNzbWFuIDxn
YWxAbnZpZGlhLmNvbT4NCj4+IFJldmlld2VkLWJ5OiBBbWl0IENvaGVuIDxhbWNvaGVuQG52aWRp
YS5jb20+DQo+PiAtLS0NCj4+ICAgaW5jbHVkZS9saW51eC9ldGh0b29sLmggfCAyICstDQo+PiAg
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+IGRp
ZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2V0aHRvb2wuaCBiL2luY2x1ZGUvbGludXgvZXRodG9v
bC5oDQo+PiBpbmRleCBhMjZmMzdhMjcxNjcuLjExZWZjNDVkZTY2YSAxMDA2NDQNCj4+IC0tLSBh
L2luY2x1ZGUvbGludXgvZXRodG9vbC5oDQo+PiArKysgYi9pbmNsdWRlL2xpbnV4L2V0aHRvb2wu
aA0KPj4gQEAgLTExMSw3ICsxMTEsNyBAQCBzdHJ1Y3QgZXRodG9vbF9saW5rX2V4dF9zdGF0ZV9p
bmZvIHsNCj4+ICAgICAgICAgICAgICAgIGVudW0gZXRodG9vbF9saW5rX2V4dF9zdWJzdGF0ZV9i
YWRfc2lnbmFsX2ludGVncml0eSBiYWRfc2lnbmFsX2ludGVncml0eTsNCj4+ICAgICAgICAgICAg
ICAgIGVudW0gZXRodG9vbF9saW5rX2V4dF9zdWJzdGF0ZV9jYWJsZV9pc3N1ZSBjYWJsZV9pc3N1
ZTsNCj4+ICAgICAgICAgICAgICAgIGVudW0gZXRodG9vbF9saW5rX2V4dF9zdWJzdGF0ZV9tb2R1
bGUgbW9kdWxlOw0KPj4gLSAgICAgICAgICAgICB1OCBfX2xpbmtfZXh0X3N1YnN0YXRlOw0KPj4g
KyAgICAgICAgICAgICB1MzIgX19saW5rX2V4dF9zdWJzdGF0ZTsNCj4gDQo+IE5vdCBteSBhcmVh
IG9mIGV4cGVydGlzZSwgYnV0Og0KPiANCj4gc3RhdGljIGludCBsaW5rc3RhdGVfcmVwbHlfc2l6
ZShjb25zdCBzdHJ1Y3QgZXRobmxfcmVxX2luZm8gKnJlcV9iYXNlLA0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBjb25zdCBzdHJ1Y3QgZXRobmxfcmVwbHlfZGF0YSAqcmVwbHlf
YmFzZSkNCj4gew0KPiAgICAgICAgICBzdHJ1Y3QgbGlua3N0YXRlX3JlcGx5X2RhdGEgKmRhdGEg
PSBMSU5LU1RBVEVfUkVQREFUQShyZXBseV9iYXNlKTsNCj4gICAgICAgICAgaW50IGxlbjsNCj4g
DQo+ICAgICAgICAgaWYgKGRhdGEtPmV0aHRvb2xfbGlua19leHRfc3RhdGVfaW5mby5fX2xpbmtf
ZXh0X3N1YnN0YXRlKQ0KPiAgICAgICAgICAgICAgICAgIGxlbiArPSBubGFfdG90YWxfc2l6ZShz
aXplb2YodTgpKTsgLyogTElOS1NUQVRFX0VYVF9TVUJTVEFURSAqLw0KPiANCj4gYW5kDQo+IA0K
PiBzdGF0aWMgaW50IGxpbmtzdGF0ZV9maWxsX3JlcGx5KHN0cnVjdCBza19idWZmICpza2IsDQo+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IHN0cnVjdCBldGhubF9yZXFf
aW5mbyAqcmVxX2Jhc2UsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0
IHN0cnVjdCBldGhubF9yZXBseV9kYXRhICpyZXBseV9iYXNlKQ0KPiB7DQo+IA0KPiAgICAgICAg
ICAgICAgICAgIGlmIChkYXRhLT5ldGh0b29sX2xpbmtfZXh0X3N0YXRlX2luZm8uX19saW5rX2V4
dF9zdWJzdGF0ZSAmJg0KPiAgICAgICAgICAgICAgICAgICAgICBubGFfcHV0X3U4KHNrYiwgRVRI
VE9PTF9BX0xJTktTVEFURV9FWFRfU1VCU1RBVEUsDQo+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgZGF0YS0+ZXRodG9vbF9saW5rX2V4dF9zdGF0ZV9pbmZvLl9fbGlua19leHRfc3Vi
c3RhdGUpKQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FTVNHU0laRTsNCj4g
DQo+IFRoaXMgc2VlbXMgdG8gc3VnZ2VzdCBpdCBpcyBhIHU4LCBub3QgYSB1MzIuDQo+IA0KPiBJ
IGd1ZXNzIGkgZG9uJ3QgdW5kZXJzdGFuZCBzb21ldGhpbmcgaGVyZS4uLg0KPiANCj4gICAgQW5k
cmV3DQoNClRoZSBOZXRsaW5rIG1lc3NhZ2Ugd2FzIGRlZmluZWQgdG8gb25seSBwYXNzIHU4IGFu
ZCB3ZSBjYW4ndCBjaGFuZ2UgdGhlIA0KbWVzc2FnZSBmb3JtYXQgd2l0aG91dCBjYXVzaW5nIGlu
Y29tcGF0aWJpbGl0eSBpc3N1ZXMuDQpTbywgd2UgYXJlIGFzc3VtaW5nIHRoYXQgdmFsdWVzIHdp
bGwgYmUgdW5kZXIgMjU1Lg0KDQpTdGlsbCwgdGhlIGNvbXBpbGVyIGlzIHN0b3JpbmcgZW51bSBh
cyBpbnQsIHRoaXMgaXNuJ3QgbWF0dGVyIHdoYXQgdGhlIA0Kc2l6ZSBvZiB0aGUgb3RoZXIgbWVt
YmVycyBvZiB0aGUgdW5pb24uDQpJZiBpdCB3aWxsIGJlIHJlYWQgaW50byB1OCAtIG9uIEJFIHN5
c3RlbXMgdGhlIE1TQiB3aWxsIGJlIHJlYWQgYW5kIHNvIA0KaXQgd2lsbCBhbHdheXMgcGFzcyBh
IHplcm8uDQpTbyB0aGlzIHdhcyBzb2x2ZWQgYnkgcmVhZGluZyBpdCBhcyB1MzIuIExhdGVyLCB3
aGVuIHRoZSBjb21waWxlciB3aWxsIA0KcGFzcyBpdCB0byB0aGUgZnVuY3Rpb24gYXMgdTggcGFy
YW1ldGVyLCBpdCB3aWxsIHRha2UgdGhlIHJpZ2h0IHBhcnQgLSANCnRoZSBMU0Igb24gZWl0aGVy
IHN5c3RlbS4NCg0KUmVhZGluZyBlbnVtIGJ5IHU4IGZyb20gYSB1bmlvbjoNCj09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT0NCnwgICAgICAgICAgICAgZW51bSAgICAgICAgICAgICAg
IHwNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCnwgIHU4ICAgfA0KPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KfCAgTVNCICB8ICAgICAgICB8ICAgICAgIHwg
IExTQiAgfCBPbiBCRSBzeXN0ZW1zDQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
DQp8ICBMU0IgIHwgICAgICAgIHwgICAgICAgfCAgTVNCICB8IE9uIExFIHN5c3RlbXMNCj09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCg0KQ29udmVydGluZyB1MzIgdG8gdTg6DQog
ID09PT09PT09PSAgICAgICA9PT09PT09DQp8IHUzMiBMU0IgfCAgPT4gfCAgIHU4ICB8ICBPbiBh
bGwgdGhlIHN5c3RlbXMNCiAgPT09PT09PT09ICAgICAgID09PT09PT0NCg0KDQo=
