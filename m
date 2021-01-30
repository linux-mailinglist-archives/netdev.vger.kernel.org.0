Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6064630939C
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhA3Jnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:43:51 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49872 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231886AbhA3Jnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 04:43:41 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10U9Ulbe009215;
        Sat, 30 Jan 2021 01:42:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=z9RA7C1O3sPq/cPVtu4bxmI5Wzq9JBAvHrxfhQTOL7c=;
 b=fuutvMEwn3ilfueh3rSuMerewB/Gu1q8xg3SkxMFulWTQqggddq0wFTLCGJB6ofmYp18
 +mX07QvM80xk2lTwCDXui6l1BkMvBxcV7SXuoIooX3y7yDIJBb07kCGz45LfbYgk2qK+
 OL8YEbLY4LLONFYXqfPaNXo3mP/rEsRnPHCk0F9547djiaaIZhNns+yeaAuGswUPeMZS
 JnXUv7jsK9cTuTQUDz/6DQDTZBpXdiei2KQZFju5VgDD+hZwN1TZIUvc9mtAwwWgUThw
 k1qQ+LXXCkgc/1b9H3EKBj7odcSN1mm9gskIVfji/4Qqdc24kkV+mn86ZCyUQPmvThOY qw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36d0kd8bgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 30 Jan 2021 01:42:56 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 30 Jan
 2021 01:42:54 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 30 Jan 2021 01:42:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zph2aSWjPjoN/M3eQ+HcvU7Zm+hfbtQdSi3uRA8ZSSZyo3JXIIsX18DRzG9s3lmsNMUmTdEJg3x/5pF/ZuTDMQqCzu+kS/ExxmOGoG24/xxiVht3ISbse0mZTzJTlOHzT4TVkoiaKlSeo23AOUzxkImS3ZtYMLwfqc3KWHYteOHPY6kgHLqnWeOehE0oL5RgVoSTHe5XqyC+62xZ02dEFIX3GZmLTp+HsgJdkd1JmEN6ZYMXX0dwaaap79oQ/l7Z3++ZumHGnYhMacoLt8kNRiV7wxaINUWWs5+dYJWqAENoYdpfK42PgmGQ6dDE0uRAgin2vSdHdia2r0bZRWZl6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9RA7C1O3sPq/cPVtu4bxmI5Wzq9JBAvHrxfhQTOL7c=;
 b=lxCs5Ta0u9dariAsp7nuLZEwztHamcdLMr8P3+tVoVdjlvFUtWVJGyM9hukESdBfwUbFZmuOyXvm+RK9ZBe7MNzubRUij+8ye0Q5hRMz33oiDPss7/Ok4h8/4IigkciwOng9CLHWrwXu7gbKPvQrpr8Z+JNYE930dxPLmj4ZPOnQJlSdf6f1eb7K3/MFpAYsyW2++7WkCYTUBcMU5SWz+NPh6fRw23wV0v9EO9QJmcxCAWp1jTyvnCwFLDWDVywKNs78l1i73jIcZSVwMTTd9LcsPasYsYyIsQ8zOy64SXR2X+4p8/m6vjh+ruXwkHMltqjNrMPMR2zGBPpL/OU91w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9RA7C1O3sPq/cPVtu4bxmI5Wzq9JBAvHrxfhQTOL7c=;
 b=ZQJooqQFJ59a2zSDvJC6cubK097SrRdRnDu3WW53f2dgP5dMQZxn3+jFDW7gGFl7y1C3j4f03aCBYAbEWsL3DKCnsuXhqjwZNjW7Sh6sc2091nPpnc+HuSQedPe/h5FzeLU/5amwbyXY1ADDvezqp5QjC8OZREKd/IcH3o8Sw48=
Received: from MWHPR18MB1421.namprd18.prod.outlook.com (2603:10b6:320:2a::23)
 by MW3PR18MB3481.namprd18.prod.outlook.com (2603:10b6:303:2d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Sat, 30 Jan
 2021 09:42:52 +0000
Received: from MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d]) by MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d%4]) with mapi id 15.20.3805.022; Sat, 30 Jan 2021
 09:42:52 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Christina Jacob <cjacob@marvell.com>
Subject: Re: [Patch v2 net-next 1/7] octeontx2-af: forward error correction
 configuration
Thread-Topic: [Patch v2 net-next 1/7] octeontx2-af: forward error correction
 configuration
Thread-Index: Adb27Arlo7Q8sqIFQnWYAldRpK+MAw==
Date:   Sat, 30 Jan 2021 09:42:52 +0000
Message-ID: <MWHPR18MB14217664A28BDBF32A31233BDEB89@MWHPR18MB1421.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [117.201.216.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 205bf909-ba39-4418-3f6f-08d8c50369f0
x-ms-traffictypediagnostic: MW3PR18MB3481:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB3481B908569C7F0158F99095DEB89@MW3PR18MB3481.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:121;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: prWNy2UeoFxHdQSqpga3n5ltOI/vV3XS9O1CNXXRVh4xoHRNHRLnNZDV/aH8Pb4OSIjVWIPm95avkM7+KDnocg67MlFYRjJDV+ZkWjKWp7fKE5ne8ah47gsK5CAhBGZZWfauLJ4o/rjpJrw9g7FHSvWLUc4qP0VxzpnXCC4TwHt55ApTCayJsADv7j3fC8i0dGQdX6FYYAZr8A5ngwGHH8rAqRCHx5Gaxr6vIFVncz6/Al7sRAzbmP2NPPJUEWYCoeu8nUu6We4iQbLvqZbCr4jeqnP+L1Kt/P8H79NcDy+S9Odj+1WTwMhahnedpXN72aMil4VoPrnNLGB4xA77C2drydy8RTflBMKh+D56YPuc+hNwY7rbsSK8t+W/eh/8MoxmSJr6+sPqzS58JOjGFQ0mgkJHP5607EXifm5p6hHqFJMTxoQywviT+gh/dtTTmmQTj4JxiqZ51LQyBzXefytgcPwhMEHuwxZ1GW0Ooq+bcCblN8Lpt7JqFiOpqWdHY8hV2fHqE5HovRGKSjke4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1421.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(33656002)(52536014)(26005)(71200400001)(8936002)(86362001)(478600001)(6916009)(53546011)(6506007)(5660300002)(66476007)(66556008)(4326008)(55016002)(9686003)(66446008)(64756008)(54906003)(76116006)(66946007)(2906002)(316002)(186003)(83380400001)(55236004)(8676002)(107886003)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?c044eSs3dEtSeEQ0SFZhdlZHT01MVm9DUGRITnVXK1JQbTZEZ3hPdWJMek1k?=
 =?utf-8?B?dEtRdWZWY2orMjhkODgwbnkwdmtHdGtnZW15Z2VGdVd3d3IvcmlPblFQVWdM?=
 =?utf-8?B?NTJkSVpjV2tFT3JRN0E3ME42NVFBZWJEZjhQNExLTGd1cjgySUFGMUJEMlph?=
 =?utf-8?B?L0F1U3hUdFBMMUFsWmp4M255UkJ0S2YzSU5WZTRKMjBLdVo4ZlQrUHhRWlVn?=
 =?utf-8?B?MTJrREFJVVoxTE9LNGpxTUR4TmZhZkdta3lCY0xJd1czM0x1U2tTTW1ONlRD?=
 =?utf-8?B?YXE5L3YwNlcvdkdVdWE3S3J6ZElhN3hHRi9XRWlEZEJpelczS1FYUzBDV0JG?=
 =?utf-8?B?dXRuSkR0blVGTEQ1ajczd2RBT0hraWxVRTZVUXZVYjN5R1pPV2ZYM05xTXZF?=
 =?utf-8?B?eVZyV0NUSTluK0VuYTBCZm5XeDRDVGNUMGYvRlFjSnp5VDlmcUc3T0NqNGlV?=
 =?utf-8?B?Vk56WHloRzZkaTl5eHNwSVZlM2dNS1l0WllkYTRJeTZHZkY2NFhRajhLQk9s?=
 =?utf-8?B?UXZmZCs2a2NaM2g0aHhESlgyNVIzclN4WldwU0x5N1RnMlRIS3hJNFFrNHRa?=
 =?utf-8?B?Q01SV2RlaVpWRExEbHJEMTUxRENtdVNscnJ4SVpqbFowRUZNQ0UwTFFOQ00z?=
 =?utf-8?B?amt3NmNJZVdTTkk0KzJhVlpEdW5xY2VCb25qZkRMREJOQmFnN0tUS0t2bmZa?=
 =?utf-8?B?bk10aEZGUHJ0dkFueXRCcFhKWWpsRzlEWlg4MDlwZVkydWJBU3ZaL3RmOHY4?=
 =?utf-8?B?c1VmVWdNQU5jZ0NTYXRDYlpFOEJ3SGt6bjNQSjVRbkJFa0dOOWNZQzB6UWNy?=
 =?utf-8?B?eHlQVGVQeDJER0tUZm5aQVU2SWU4Q2NqZlZIcnByVTdDNzl0cHR6N1FWU2ZG?=
 =?utf-8?B?Z3NyTzdHYmVVWml0bzZFaW1zRjdweHhtUlQ5cWZLRmJXcWZieCtIUWxxNXMr?=
 =?utf-8?B?endUMTlzaFgyTGxPNE5RL2VWaVlBVm85SHNFbGVFSUtxcXJHOGFMZmxnSEpz?=
 =?utf-8?B?bzEvYU1TUlltWFJVVjFFN0FSenJaajRJZ0ozOVQyK24zdXd4c3lCSDZ4bytP?=
 =?utf-8?B?S2V0TTVOWFk0b1lNUmx3STBCWWlOWmN6azAwL000WVRrYklNakRzU1dOYVJX?=
 =?utf-8?B?R2RnTnk2UHNNelJpWS9IZlduQzQ4S2VQbkIvQkYxMFFIaEQyTmVDejVyMTho?=
 =?utf-8?B?RDJCd2ZodFRRYjY5b0ZkL0ZHMlBLTjNTWVRMK1ZZcCs3YkFxY2hSSkNZbWhk?=
 =?utf-8?B?cDA5UUMzQXFIY09WMXVPSGFQSVU0dm15U3U3THJRdnc0aDN5S1Q1SW9OS1NV?=
 =?utf-8?B?amhtYlh3Q0U1cjhVdWtmZWcrenFTNzZ5M0F0Vk9kS2hnaGNQM0NEWkQ2eGpG?=
 =?utf-8?B?a0dvdzYxKytyTUExQVY3cktHdHNyZ2JBUEFOUmRiV1lBWXZYMjM1blZRdHh1?=
 =?utf-8?Q?Cv2JAIhm?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1421.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 205bf909-ba39-4418-3f6f-08d8c50369f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2021 09:42:52.4312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SA5u7v8U+cvjm05FlqkOSVc1tyJVCzJwx6pLIIUCxIKKb+k571aX9G6qJQnUOPkIvJQ15jYiII1ths5875E7XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3481
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-30_06:2021-01-29,2021-01-30 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgV2lsbGVtLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFdpbGxl
bSBkZSBCcnVpam4gPHdpbGxlbWRlYnJ1aWpuLmtlcm5lbEBnbWFpbC5jb20+DQo+IFNlbnQ6IFRo
dXJzZGF5LCBKYW51YXJ5IDI4LCAyMDIxIDE6NDUgQU0NCj4gVG86IEhhcmlwcmFzYWQgS2VsYW0g
PGhrZWxhbUBtYXJ2ZWxsLmNvbT4NCj4gQ2M6IE5ldHdvcmsgRGV2ZWxvcG1lbnQgPG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc+OyBMS01MIDxsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZz47
IERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViDQo+IEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+OyBTdW5pbCBLb3Z2dXJpIEdvdXRoYW0NCj4gPHNnb3V0aGFtQG1hcnZl
bGwuY29tPjsgTGludSBDaGVyaWFuIDxsY2hlcmlhbkBtYXJ2ZWxsLmNvbT47DQo+IEdlZXRoYXNv
d2phbnlhIEFrdWxhIDxnYWt1bGFAbWFydmVsbC5jb20+OyBKZXJpbiBKYWNvYiBLb2xsYW51a2th
cmFuDQo+IDxqZXJpbmpAbWFydmVsbC5jb20+OyBTdWJiYXJheWEgU3VuZGVlcCBCaGF0dGEgPHNi
aGF0dGFAbWFydmVsbC5jb20+Ow0KPiBDaHJpc3RpbmEgSmFjb2IgPGNqYWNvYkBtYXJ2ZWxsLmNv
bT4NCj4gU3ViamVjdDogW0VYVF0gUmU6IFtQYXRjaCB2MiBuZXQtbmV4dCAxLzddIG9jdGVvbnR4
Mi1hZjogZm9yd2FyZCBlcnJvcg0KPiBjb3JyZWN0aW9uIGNvbmZpZ3VyYXRpb24NCj4gDQo+IEV4
dGVybmFsIEVtYWlsDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IE9uIFdlZCwgSmFuIDI3LCAyMDIx
IGF0IDQ6MDUgQU0gSGFyaXByYXNhZCBLZWxhbSA8aGtlbGFtQG1hcnZlbGwuY29tPg0KPiB3cm90
ZToNCj4gPg0KPiA+IEZyb206IENocmlzdGluYSBKYWNvYiA8Y2phY29iQG1hcnZlbGwuY29tPg0K
PiA+DQo+ID4gQ0dYIGJsb2NrIHN1cHBvcnRzIGZvcndhcmQgZXJyb3IgY29ycmVjdGlvbiBtb2Rl
cyBiYXNlUiBhbmQgUlMuIFRoaXMNCj4gPiBwYXRjaCBhZGRzIHN1cHBvcnQgdG8gc2V0IGVuY29k
aW5nIG1vZGUgYW5kIHRvIHJlYWQNCj4gPiBjb3JyZWN0ZWQvdW5jb3JyZWN0ZWQgYmxvY2sgY291
bnRlcnMNCj4gPg0KPiA+IEFkZHMgbmV3IG1haWxib3ggaGFuZGxlcnMgc2V0X2ZlYyB0byBjb25m
aWd1cmUgZW5jb2RpbmcgbW9kZXMgYW5kDQo+ID4gZmVjX3N0YXRzIHRvIHJlYWQgY291bnRlcnMg
YW5kIGFsc28gaW5jcmVhc2UgbWJveCB0aW1lb3V0IHRvIGFjY29tZGF0ZQ0KPiA+IGZpcm13YXJl
IGNvbW1hbmQgcmVzcG9uc2UgdGltZW91dC4NCj4gPg0KPiA+IEFsb25nIHdpdGggbmV3IENHWF9D
TURfU0VUX0ZFQyBjb21tYW5kIGFkZCBvdGhlciBjb21tYW5kcyB0bw0KPiBzeW5jIHdpdGgNCj4g
PiBrZXJuZWwgZW51bSBsaXN0IHdpdGggZmlybXdhcmUuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBDaHJpc3RpbmEgSmFjb2IgPGNqYWNvYkBtYXJ2ZWxsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBTdW5pbCBHb3V0aGFtIDxzZ291dGhhbUBtYXJ2ZWxsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBIYXJpcHJhc2FkIEtlbGFtIDxoa2VsYW1AbWFydmVsbC5jb20+DQo+ID4gLS0tDQo+ID4gIGRy
aXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvb2N0ZW9udHgyL2FmL2NneC5jICAgIHwgNzQNCj4g
KysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxs
L29jdGVvbnR4Mi9hZi9jZ3guaCAgICB8ICA3ICsrDQo+ID4gIC4uLi9uZXQvZXRoZXJuZXQvbWFy
dmVsbC9vY3Rlb250eDIvYWYvY2d4X2Z3X2lmLmggIHwgMTcgKysrKy0NCj4gPiAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250eDIvYWYvbWJveC5oICAgfCAyMiArKysrKystDQo+
ID4gIC4uLi9uZXQvZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250eDIvYWYvcnZ1X2NneC5jICAgIHwg
MzMgKysrKysrKysrKw0KPiA+ICA1IGZpbGVzIGNoYW5nZWQsIDE1MSBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21hcnZlbGwvb2N0ZW9udHgyL2FmL2NneC5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
YXJ2ZWxsL29jdGVvbnR4Mi9hZi9jZ3guYw0KPiA+IGluZGV4IDg0YTkxMjMuLjU0ODlkYWIgMTAw
NjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250eDIvYWYv
Y2d4LmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9h
Zi9jZ3guYw0KPiA+IEBAIC0zNDAsNiArMzQwLDU4IEBAIGludCBjZ3hfZ2V0X3R4X3N0YXRzKHZv
aWQgKmNneGQsIGludCBsbWFjX2lkLCBpbnQNCj4gaWR4LCB1NjQgKnR4X3N0YXQpDQo+ID4gICAg
ICAgICByZXR1cm4gMDsNCj4gPiAgfQ0KPiA+DQo+ID4gK3N0YXRpYyBpbnQgY2d4X3NldF9mZWNf
c3RhdHNfY291bnQoc3RydWN0IGNneF9saW5rX3VzZXJfaW5mbyAqbGluZm8pDQo+ID4gK3sNCj4g
PiArICAgICAgIGlmIChsaW5mby0+ZmVjKSB7DQo+ID4gKyAgICAgICAgICAgICAgIHN3aXRjaCAo
bGluZm8tPmxtYWNfdHlwZV9pZCkgew0KPiA+ICsgICAgICAgICAgICAgICBjYXNlIExNQUNfTU9E
RV9TR01JSToNCj4gPiArICAgICAgICAgICAgICAgY2FzZSBMTUFDX01PREVfWEFVSToNCj4gPiAr
ICAgICAgICAgICAgICAgY2FzZSBMTUFDX01PREVfUlhBVUk6DQo+ID4gKyAgICAgICAgICAgICAg
IGNhc2UgTE1BQ19NT0RFX1FTR01JSToNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICByZXR1
cm4gMDsNCj4gPiArICAgICAgICAgICAgICAgY2FzZSBMTUFDX01PREVfMTBHX1I6DQo+ID4gKyAg
ICAgICAgICAgICAgIGNhc2UgTE1BQ19NT0RFXzI1R19SOg0KPiA+ICsgICAgICAgICAgICAgICBj
YXNlIExNQUNfTU9ERV8xMDBHX1I6DQo+ID4gKyAgICAgICAgICAgICAgIGNhc2UgTE1BQ19NT0RF
X1VTWEdNSUk6DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIDE7DQo+ID4gKyAg
ICAgICAgICAgICAgIGNhc2UgTE1BQ19NT0RFXzQwR19SOg0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgIHJldHVybiA0Ow0KPiA+ICsgICAgICAgICAgICAgICBjYXNlIExNQUNfTU9ERV81MEdf
UjoNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBpZiAobGluZm8tPmZlYyA9PSBPVFgyX0ZF
Q19CQVNFUikNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAyOw0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgIGVsc2UNCj4gPiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHJldHVybiAxOw0KPiA+ICsgICAgICAgICAgICAgICB9DQo+ID4gKyAgICAg
ICB9DQo+ID4gKyAgICAgICByZXR1cm4gMDsNCj4gDQo+IG1heSBjb25zaWRlciBpbnZlcnRpbmcg
dGhlIGNvbmRpdGlvbiwgdG8gcmVtb3ZlIG9uZSBsZXZlbCBvZiBpbmRlbnRhdGlvbi4NCj4gDQpB
Z3JlZWQuIFdpbGwgZml4IGluIG5leHQgdmVyc2lvbi4NCg0KPiA+ICtpbnQgY2d4X3NldF9mZWMo
dTY0IGZlYywgaW50IGNneF9pZCwgaW50IGxtYWNfaWQpIHsNCj4gPiArICAgICAgIHU2NCByZXEg
PSAwLCByZXNwOw0KPiA+ICsgICAgICAgc3RydWN0IGNneCAqY2d4Ow0KPiA+ICsgICAgICAgaW50
IGVyciA9IDA7DQo+ID4gKw0KPiA+ICsgICAgICAgY2d4ID0gY2d4X2dldF9wZGF0YShjZ3hfaWQp
Ow0KPiA+ICsgICAgICAgaWYgKCFjZ3gpDQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiAtRU5Y
SU87DQo+ID4gKw0KPiA+ICsgICAgICAgcmVxID0gRklFTERfU0VUKENNRFJFR19JRCwgQ0dYX0NN
RF9TRVRfRkVDLCByZXEpOw0KPiA+ICsgICAgICAgcmVxID0gRklFTERfU0VUKENNRFNFVEZFQywg
ZmVjLCByZXEpOw0KPiA+ICsgICAgICAgZXJyID0gY2d4X2Z3aV9jbWRfZ2VuZXJpYyhyZXEsICZy
ZXNwLCBjZ3gsIGxtYWNfaWQpOw0KPiA+ICsgICAgICAgaWYgKCFlcnIpIHsNCj4gPiArICAgICAg
ICAgICAgICAgY2d4LT5sbWFjX2lkbWFwW2xtYWNfaWRdLT5saW5rX2luZm8uZmVjID0NCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICBGSUVMRF9HRVQoUkVTUF9MSU5LU1RBVF9GRUMsIHJlc3Ap
Ow0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gY2d4LT5sbWFjX2lkbWFwW2xtYWNfaWRdLT5s
aW5rX2luZm8uZmVjOw0KPiA+ICsgICAgICAgfQ0KPiA+ICsgICAgICAgcmV0dXJuIGVycjsNCj4g
DQo+IFByZWZlciBrZWVwaW5nIHRoZSBzdWNjZXNzIHBhdGggbGluZWFyIGFuZCByZXR1cm4gZWFy
bHkgaWYgKGVycikgaW4gZXhwbGljaXQNCj4gYnJhbmNoLiBUaGlzIGFsc28gYWlkcyBicmFuY2gg
cHJlZGljdGlvbi4NCj4NCkFncmVlZC4gV2lsbCBmaXggdGhpcyBpbiBuZXh0IHZlcnNpb24uDQog
DQo+ID4gK2ludCBydnVfbWJveF9oYW5kbGVyX2NneF9mZWNfc3RhdHMoc3RydWN0IHJ2dSAqcnZ1
LA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IG1zZ19yZXEg
KnJlcSwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBjZ3hf
ZmVjX3N0YXRzX3JzcCAqcnNwKSB7DQo+ID4gKyAgICAgICBpbnQgcGYgPSBydnVfZ2V0X3BmKHJl
cS0+aGRyLnBjaWZ1bmMpOw0KPiA+ICsgICAgICAgdTggY2d4X2lkeCwgbG1hYzsNCj4gPiArICAg
ICAgIGludCBlcnIgPSAwOw0KPiA+ICsgICAgICAgdm9pZCAqY2d4ZDsNCj4gPiArDQo+ID4gKyAg
ICAgICBpZiAoIWlzX2NneF9jb25maWdfcGVybWl0dGVkKHJ2dSwgcmVxLT5oZHIucGNpZnVuYykp
DQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiAtRVBFUk07DQo+ID4gKyAgICAgICBydnVfZ2V0
X2NneF9sbWFjX2lkKHJ2dS0+cGYyY2d4bG1hY19tYXBbcGZdLCAmY2d4X2lkeCwgJmxtYWMpOw0K
PiA+ICsNCj4gPiArICAgICAgIGNneGQgPSBydnVfY2d4X3BkYXRhKGNneF9pZHgsIHJ2dSk7DQo+
ID4gKyAgICAgICBlcnIgPSBjZ3hfZ2V0X2ZlY19zdGF0cyhjZ3hkLCBsbWFjLCByc3ApOw0KPiA+
ICsgICAgICAgcmV0dXJuIGVycjsNCj4gDQo+IG5vIG5lZWQgZm9yIHZhcmlhYmxlIGVycg0KQWdy
ZWVkIHdpbGwgZml4IHRoaXMgaW4gbmV4dCB2ZXJzaW9uLg0KDQpUaGFua3MsDQpIYXJpcHJhc2Fk
IGsNCg==
