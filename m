Return-Path: <netdev+bounces-5925-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38C5D713595
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 18:08:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE857281629
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 16:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD0C9134BF;
	Sat, 27 May 2023 16:08:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F801078A
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 16:08:06 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08076C3
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 09:08:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXnaiUkaJKguEcEPCDG8jihAK4cAkpMeHjeK03tluC/oPmVabhaVBje1GC9uOIdJMPnuueGaj/1krPdUAs+xqpsyhNETh66OO1TCv2p4wF2vL7p9LVfn6ghCk3zeJFFLWDq+qz6SDHIJdFEnO0o+UIWXjKbrr5VPxfA5uPnCvKsNhoERvXMi3tCgDihx5xwuEpoBZOYlcr+sJs94xQAUlXEP5Y4zQgw2PhmtbqabMJOkwjcjRslD3cgXbOYp9cTmLQD3KYdMQq8YtWv7T0BtGZ2DYn+wH9CsT5/zj6EVMzMk4UEkXYRIcQpDUnY/qHz6LGN981XjhqLE0cQCrRwFYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L7nJIR9eNQSsbafMDqRsRZah9ZH4o1tusuKyA/Yx0CE=;
 b=kCmigjplqaxghp/+Rszgf7NDtZj0x2aoByEXp6pwP9mulBKA3DeUVYiPw51N8uL/6RWwi9BBbicmqcH5DvrqTLBvEkIhPu7A+6e/DWZuLNRtR+nPU0QlFdXsHQrOGKnaDwGj4dCzOp/BgHGcICVzs2+5lEjQQFAIGv/Gsp6NlFtzuPNx9CaLlOgxVPcrJ+8KHALrtdgnXw7BAgrH+r4EbjR71cV4nH7ZDaVhsXnRq8jTx58TxjxN4buE7fCfI1AqsPp0bPZPX7Pvcpd3YcM16No9pUxXf9XuToZfILH3V1fT0XEOb2eWBM76RRlW28OXFd949u2BkwSbHNgIFfndoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ooma.com; dmarc=pass action=none header.from=ooma.com;
 dkim=pass header.d=ooma.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ooma.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7nJIR9eNQSsbafMDqRsRZah9ZH4o1tusuKyA/Yx0CE=;
 b=QNClZ1JMIQDfPN46DMDPcIjn6EN6asUHj+7SwHUwSKGZH4oq56mKY9uSCqd+38/AhDnluzsXS+MNk5dSnkKqk8qnlfXiF8T+n7/ewuANJmGb6i5whWVgtFd0iN8tfhlHzilCPzpxaokQicftH/k3IGRvVusr+OiUy1tC19qI0zI=
Received: from BYAPR14MB2918.namprd14.prod.outlook.com (2603:10b6:a03:153::10)
 by SN7PR14MB5939.namprd14.prod.outlook.com (2603:10b6:806:2a2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.21; Sat, 27 May
 2023 16:08:01 +0000
Received: from BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::3d7d:27a2:4327:e6fa]) by BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::3d7d:27a2:4327:e6fa%4]) with mapi id 15.20.6433.018; Sat, 27 May 2023
 16:08:01 +0000
From: Michal Smulski <michal.smulski@ooma.com>
To: Simon Horman <simon.horman@corigine.com>
CC: "andrew@lunn.ch" <andrew@lunn.ch>, "f.fainelli@gmail.com"
	<f.fainelli@gmail.com>, "olteanv@gmail.com" <olteanv@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] net: dsa: mv88e6xxx: implement USXGMII mode for
 mv88e6393x
Thread-Topic: [PATCH net-next] net: dsa: mv88e6xxx: implement USXGMII mode for
 mv88e6393x
Thread-Index: AQHZkDFKB6qL5Cp6ZEaCtRFBWvQnHa9uHeGAgAAsQvA=
Date: Sat, 27 May 2023 16:08:01 +0000
Message-ID:
 <BYAPR14MB29187B85C91334F4FB3122EAE3449@BYAPR14MB2918.namprd14.prod.outlook.com>
References: <20230527002144.8109-1-michal.smulski@ooma.com>
 <ZHIFgcxgh2quGxZj@corigine.com>
In-Reply-To: <ZHIFgcxgh2quGxZj@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ooma.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR14MB2918:EE_|SN7PR14MB5939:EE_
x-ms-office365-filtering-correlation-id: ef4012fa-4fda-40dd-0afb-08db5ecc8bb6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 9nDF/lbOTJASs99Vs8e4T6ocqFL5Crnk24PsNUIjw6iEe0vPlPCl8QilCSA5GVwl3YAyZO5OHWaxCoz9osK4+VoFGc/gwxlmLv2DZZ4SgOdZaTahl/JLt0/dWBHQbwB9tV11BZpGIn7LURaR/uh6GXmtoF2NBoLZCU0Od/GxuMxIJZb0GnmKV0t8gWjkQ2ZxWaWMbzQtExhdh3wBL79L2L37B+fNftXP0f3exEF9v3IQfvfd3lKWGehxJo6y74ds1fDtHJ5O2cNtz/QMoVpLZm+DNtKZAHM6E9Wh1smcpBoL9cGY7zL2Y6VAnKiDwbGaKaQ/ZkundSiEn9RYv0eYWpVGHexzQjv9HkXEeGudcEVuWmMYsLdjBLFiKhg78KRlzJL9Bu2XicygYdtYg9AKHR/amC1YlFmSIHoSZMj5Fy1ZPWEHP2L7PqqHNiTb4X9/pXzAjphb5pC03/Juv+gmVpHUSK8a1OBE4dbu8cCyuFeKXwE8Ko3WKyPfmTF17gah7DmOo60VblCXV77s0CQWrvXwc6RNE/WcXaXN9RRcvvduY4xKGYoj695OWQKNqaqzKD8KnmDAL0HH5PVleHusnHfpZO7IkWrMlH3ZVOpsal4oTSUbx/DlJYFe7Ib8q1QDnQCDwzxRDZFgYpd/sl5Fsw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR14MB2918.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(376002)(346002)(136003)(366004)(396003)(451199021)(44832011)(4326008)(55016003)(66556008)(66946007)(66476007)(186003)(76116006)(83380400001)(6916009)(66574015)(64756008)(66446008)(53546011)(478600001)(71200400001)(2906002)(54906003)(7696005)(9686003)(6506007)(122000001)(33656002)(38100700002)(52536014)(8676002)(8936002)(26005)(38070700005)(5660300002)(86362001)(316002)(41300700001)(138113003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YWgwY3o4K29xRitzR21IVjRUZFRtQ3pCU0VQMS9sSnpabGZ2dXl4czJaWm81?=
 =?utf-8?B?Y3R6Sm8vaHZqSFBCeTI2aXQ5SU1WaVBZclp4WlJQdVhnMFlIK1ZtUm5URE1F?=
 =?utf-8?B?NHJVV2RCMVB6NnBGeS9FcXYxRWxneExIQWgwanFBYkV1cDhiYXkyQ1JoQmFU?=
 =?utf-8?B?cmFyVWx2Y1Z0V05HVzhnNmowVDdzcXRjUHdveFNGV2JRelprS21MKzlrQ0xN?=
 =?utf-8?B?Zk56d0ViQ0R6V1ZBSWtsRXJxM0FuTnhqdU5wZlBvUG1CVVpReUV3ek83UGh6?=
 =?utf-8?B?OEVKMHVkK1pwdjBJOFdMMGdtYm5KTVNENFVFQndjOWFnb04vVGlzYXBobFdJ?=
 =?utf-8?B?aWpvYXFhcTN1d3hTQ2szbTlsT1dFUWlCbkF5MXBkbGMxejRuampIQ0QrdTJv?=
 =?utf-8?B?Qm1OVFhQS1JPOW9UQTFzeUF3UHduNlBYL1FnMVA5SlpMNEZXK0x1WE1CNXdD?=
 =?utf-8?B?elJnVTdhd3drK1FyZ0NrYytpTVYzeStYdXUzUUhhRWFJajdJdVE5cjgwUngr?=
 =?utf-8?B?Z1VJaTV0UDlUWDN5Y1RjVWRFRkZTZ1U3SklKT3hBVm5xM1lpSWZwZDB0VHNH?=
 =?utf-8?B?Y09uQ1REcUpjWUpEQXFpRFU2U0pRZSsxT1B2V0lFSmdyNG5LMHRBR0ZLLzJv?=
 =?utf-8?B?MnVuZXlmSG85NWFYZTRRUTRCRm1yTG5OM3ZtWWppanRTU2xraUZPd1J0S3NW?=
 =?utf-8?B?QVdwMDBzbnRteXdoWXdzL3NzRUZZODZtU1R2M2JnYlpaTzF0VlJuMDJweDNH?=
 =?utf-8?B?QzZ1UjdiaFZmNEF2TDRCcUtuWFZZM0U3NldkWHZrYVg4ZjRVUXljL000WFFi?=
 =?utf-8?B?TVY0NU5EM3A0TGlrZmhIS0tuUzdlKzg2Rnh0bjdyaTNqSVZhWmdMY0FSbzYv?=
 =?utf-8?B?T2tWY2pjZVVWb1p3cEZpV1pxOG53Tkt0V01teG9HWkRYR1RLWUwxcXhIa0R5?=
 =?utf-8?B?aUdrRlg5b3VPZE5mUGM2L0dvbGZvL3lORmJaS3Rkb1lqRzhYanI3TUovckVz?=
 =?utf-8?B?Y2xJbUk2bDRoSjFFVXN0VW8xdVExOGlrdFk5TWptL01XY1lUTWZ3MWMzMk1m?=
 =?utf-8?B?Wm1pckdoUGJJTWVyZ0hBZEhGTitELzJSUFVlSExDSjhURWtLY2hIWE95T2t6?=
 =?utf-8?B?WFBzaERXb1N1Y0wxZjV1aUFMKzJaUkdvM2pBank2blBPZEZCUDQ4QSswYVph?=
 =?utf-8?B?SmdEdllZSDJTQXRhNERNUS9vbXNTaFptV0NSRVFDWXVQbHliT2drTWRCMTlY?=
 =?utf-8?B?MnlrYVh2YXRyTHFuUUtjZUhnQkNDVkJrci9OVkVnOElGUithRDhIYW5OQmlk?=
 =?utf-8?B?OFFGcnA0ZHlwMFBLbDgzVDk2MDU2Y1ZZNENZMmQ1ZGRPbzRHYmM0cGZyakFl?=
 =?utf-8?B?OTlXQlVXcU5aNTdzVFVvQjRYUzdlTlN6VTJ4QldpcGFXN3BlMjZvNzBYMmt2?=
 =?utf-8?B?cHpkNy9LK0U0Z2NSSjFhanIvNUlKQXlDMTlXOXBickJvY2Fubmh3N1F5SDlr?=
 =?utf-8?B?R3RGamE0ejE1Qmw3VDQ2b3hBQVV4NXJHM2RVWDdWbG5TOGdweEFlMHZHc2J5?=
 =?utf-8?B?WXRocGRjVXpucjZDeVJ0Z0FtbnhWTlRLYWd0SHZ0KzV5N3lTZDZrbnRhSEkv?=
 =?utf-8?B?aFBrYVBJbm9iNVNGQmdtZVhDMDVRL1N0ekJZVnVQWmdJTHh3K3l4dENRVWxQ?=
 =?utf-8?B?eFJKUzkxd1gyVERiNDlZRDZSdUhSNFo1NTZHZmpJZTkzYlhTeHBDd2VRMXE2?=
 =?utf-8?B?TEdlUDJDTGNPQnhySWJhQU9BczNuUDlxNS9NQmM5ak13dk9VSEMwWXhoTFQz?=
 =?utf-8?B?d1g3Rnc5NUZlemxYd0t6cVAyRWg0b0NsNmJhYzJ4ZjlhazBsUHpsM01kbnVL?=
 =?utf-8?B?dnV1OGRjek9WVmJITjYwQnVlREE5TmlUbDE0UUtieFNXM1l0T3R4ZGhhQ1VG?=
 =?utf-8?B?SHdrdzBSRzlwQ1lFQ2tTeFVnTzd2YlJFWDJjWUFvOUU3bExCNytHUGhwWVpm?=
 =?utf-8?B?b1pqVElXVUxHUjIzM0puMTdHdi9yQURpYVJvUHFoNnVVWGpBOENWbEpVRUZv?=
 =?utf-8?B?OWIycS9ERXlGVzRiUTBybFBYNUdTYkMzUzVtbGxMVzFWblpteUpFMHRvdzZX?=
 =?utf-8?Q?J8VSn165NqhW5dhOEv3obHsDZ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ooma.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR14MB2918.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef4012fa-4fda-40dd-0afb-08db5ecc8bb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2023 16:08:01.3223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2d44ad66-e31e-435e-aaf4-fc407c81e93b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fFO1i3OhsyWi2l9v1pHOg4lWMnB4X+Lr4vLavOx63FNX63dMODMdueaGUDfQhE/Xbc+fhluS+bbaczoipJjusg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR14MB5939
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

VGhpcyBpcyBhIGdvb2QgY2F0Y2guIEkgd2lsbCBmaXggdGhpcyBhbmQgcmVzdWJtaXQgdGhlIHBh
dGNoLg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogU2ltb24gSG9ybWFuIDxz
aW1vbi5ob3JtYW5AY29yaWdpbmUuY29tPiANClNlbnQ6IFNhdHVyZGF5LCBNYXkgMjcsIDIwMjMg
NjoyOSBBTQ0KVG86IE1pY2hhbCBTbXVsc2tpIDxtc211bHNraTJAZ21haWwuY29tPg0KQ2M6IGFu
ZHJld0BsdW5uLmNoOyBmLmZhaW5lbGxpQGdtYWlsLmNvbTsgb2x0ZWFudkBnbWFpbC5jb207IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IE1pY2hhbCBTbXVsc2tpIDxtaWNoYWwuc211bHNraUBvb21h
LmNvbT4NClN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHRdIG5ldDogZHNhOiBtdjg4ZTZ4eHg6
IGltcGxlbWVudCBVU1hHTUlJIG1vZGUgZm9yIG12ODhlNjM5M3gNCg0KQ0FVVElPTjogVGhpcyBl
bWFpbCBpcyBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBEbyBu
b3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IHJlY29nbml6ZSB0
aGUgc2VuZGVyIGFuZCBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUuDQoNCg0KT24gRnJpLCBNYXkg
MjYsIDIwMjMgYXQgMDU6MjE6NDRQTSAtMDcwMCwgTWljaGFsIFNtdWxza2kgd3JvdGU6DQo+IEVu
YWJsZSBVU1hHTUlJIG1vZGUgZm9yIG12ODhlNjM5M3ggY2hpcHMuIFRlc3RlZCBvbiBNYXJ2ZWxs
IDg4RTYxOTFYLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWwgU211bHNraSA8bWljaGFsLnNt
dWxza2lAb29tYS5jb20+DQoNCi4uLg0KDQo+IEBAIC0xNDc3LDcgKzE0ODEsOCBAQCBzdGF0aWMg
aW50IG12ODhlNjM5M3hfc2VyZGVzX2VycmF0dW1fNV8yKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAq
Y2hpcCwgaW50IGxhbmUsDQo+ICAgICAgICAqIHRvIFNFUkRFUyBvcGVyYXRpbmcgaW4gMTBHIG1v
ZGUuIFRoZXNlIHJlZ2lzdGVycyBvbmx5IGFwcGx5IHRvIDEwRw0KPiAgICAgICAgKiBvcGVyYXRp
b24gYW5kIGhhdmUgbm8gZWZmZWN0IG9uIG90aGVyIHNwZWVkcy4NCj4gICAgICAgICovDQo+IC0g
ICAgIGlmIChjbW9kZSAhPSBNVjg4RTYzOTNYX1BPUlRfU1RTX0NNT0RFXzEwR0JBU0VSKQ0KPiAr
ICAgICBpZiAoY21vZGUgIT0gTVY4OEU2MzkzWF9QT1JUX1NUU19DTU9ERV8xMEdCQVNFUiB8fA0K
PiArICAgICAgICAgY21vZGUgIT0gTVY4OEU2MzkzWF9QT1JUX1NUU19DTU9ERV9VU1hHTUlJKQ0K
DQpQZXJoYXBzIG5hw692ZWx5LCB0aGlzIHNlZW1zIGxpa2UgaXQgd2lsbCBhbHdheXMgYmUgdHJ1
ZS4NClNob3VsZCBpdCBiZToNCg0KICAgICAgICBpZiAoY21vZGUgIT0gTVY4OEU2MzkzWF9QT1JU
X1NUU19DTU9ERV8xMEdCQVNFUiAmJg0KICAgICAgICAgICAgY21vZGUgIT0gTVY4OEU2MzkzWF9Q
T1JUX1NUU19DTU9ERV9VU1hHTUlJKQ0K

