Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C63395917
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 12:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbhEaKmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 06:42:37 -0400
Received: from mail-eopbgr60071.outbound.protection.outlook.com ([40.107.6.71]:31507
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231344AbhEaKm1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 06:42:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjsDm4iQc/diPYYt3D9XtwwxIpFtq6Zo7EKPzajHatvKV883EIByXiBWEqzdwSIOquE6yq0sQNJpvVBKbc/bOWaibTVmQqhRttEGqkdnq9N3r3zBhRMJ8GXH1QI4qRatI/AD0vJGvIql6qs8q+boPelprbi4crzXtZjhReiMc9btVVzvvnM96nwg50Rwf7i57dEm+5J3Mbe/+HuTDHlQMZJGzk2zVgJL+abSqpzm3FVCWHXOTSLJ3EF+t677GgmIoylNWTelfAk5DYo9227O2QyUQQOemhTAHzQ7bF3pxVOdSTg+rIxeA3stKQbzKVrMEmGYNKXd9a1f6/bAaUBbCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwValhbfpPoLozVErGxmQImEUdwIgPvWUFfa8m0ckQs=;
 b=dz79SEX4RcvMR1/QCPkbTh9iP0FKQjyqL1eYZVjN5YUMimFQzCJel26/aMYZiUK5ofVwNyGs4bGTxu2F+5/cJDjwIzuJM0j7NxjQwhGsJ9xkKKkI4nFweWZqmO6pzRy2A+WSaFhgBlh8uaPcIadlAtR7mrzCJdc/BMotbsSYEvFTKenM2TMmdguVghIicUPco+aQy12qLEqDKYego5+MmxFOXVuu3QG40zlrvXsScUn9sujnng34nvweOTL7vbXddwDrWPR7tYFIKk085MfyJ+Z6QWwOSkHofKdCKp1pc1w6D/7HwCsY3Sxy5EfYJbMvTewiWI8NhfG7yCaDWfEwmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwValhbfpPoLozVErGxmQImEUdwIgPvWUFfa8m0ckQs=;
 b=ka1ASMyooUfVuL9gLuCzHDCkgPGbdBl5u4C1pAEIiJcB0z/QaUQ3bcHUI/lRGZOlElhzq6GcOldKNSR6CymLm8t1bd5pfbziN4RQSx4xEczbTyn7wul6dMZr5SS5pvj2+8rzHYW74NX0u4Zgi88nFgO/VB3qosl6XlR1SFdTAmE=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DBAPR04MB7399.eurprd04.prod.outlook.com (2603:10a6:10:1a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Mon, 31 May
 2021 10:40:47 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd%7]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 10:40:47 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [net-next, v2, 2/7] ptp: support ptp physical/virtual clocks
 conversion
Thread-Topic: [net-next, v2, 2/7] ptp: support ptp physical/virtual clocks
 conversion
Thread-Index: AQHXTfl6/1N1bm7Iwk2SXkUsOeQDmKr0JvEAgAlPnHA=
Date:   Mon, 31 May 2021 10:40:46 +0000
Message-ID: <DB7PR04MB501714AD36532802298384D5F83F9@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
 <20210521043619.44694-3-yangbo.lu@nxp.com>
 <20210525122820.GA27498@hoboy.vegasvil.org>
In-Reply-To: <20210525122820.GA27498@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88e8b01b-7ae1-4b1b-d92d-08d924208cdb
x-ms-traffictypediagnostic: DBAPR04MB7399:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB7399EE2105A2F2D8C2EEF72BF83F9@DBAPR04MB7399.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yaHVt4wATBOoNLgWqSRDpukq0FMLv3DgEZnzOd20opVec/p7K4RYD7nLCQqqZAoonv/C4Pl12GlihFYg3T3dBSNNg6xM6DlK6IRHhSlwRntfMdF/ZOrDTFrHwOTkF3e0tXsiWjFrp7xmo17ooh/R256UEbRTExqKO3r+nipRMQVT+iY0GSFmeDhU2m32OowREW+QJtW5x51JA4n6glEuNVaz/TLoBNJkOXiSiwUQKk+2Au87+GP9gP62iK1lL7hu43W7EVs54Kw+P1gBbLZhORcLU7FK5hXqZ83LpMTqZb/KgHK//jqnVDLYY5e/sOHz9V4bdK3c78WwA8gXdlI6n52XjcaYZlUeN0wOVIClCr7tA9Bz6imlgArFVm6vqlxt45leCyURuLy5p62NWqokEY1ll+pWTDGypUacGJWTTaGorELvZtKkTzCuk4fbZoWikgnYC9Mk1PSVudKvqbcm8RiqxTu/WQAMi5S8CHJM5JwTBbX7dkWLdJyAs40p5nvJuQn9cSa8xZxfG3d+lEXjpI9ESK4pW/BsZaL2tnt9JRjBXbv0RTdmqWjcaPpS12ZHu7+YMwmKIHwTkOdZICZm1Lqi1cV+2QD6VFMDvHgTgds=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39850400004)(396003)(366004)(346002)(4744005)(5660300002)(83380400001)(9686003)(53546011)(8676002)(316002)(6506007)(7696005)(2906002)(478600001)(55016002)(6916009)(26005)(54906003)(8936002)(4326008)(86362001)(52536014)(66476007)(66556008)(66446008)(64756008)(33656002)(76116006)(66946007)(186003)(71200400001)(38100700002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?TUFoQWVwM2pkYVlNR3Z1YkR4Y2tvb05keGt1dE9HWmVMcUR3eDFiQzRGZ0s1?=
 =?gb2312?B?cVprWG80bnZOWUhkU0c2ajVpRUMzcm10Wkl4Znc3K25Zc1lXSnE3bkpMRTJZ?=
 =?gb2312?B?RG9CKzY1endlalh4OFZqR2FUM0c4SS9Fdm5KTWxHL21lMmRzUXpuOEN3UjFT?=
 =?gb2312?B?Ukhxa0VqZ2xGZmw3MEJjdUl2QlZWSVovVXRzSDlnV25EWm5uMXVSNUwrVVVZ?=
 =?gb2312?B?b1c4b2xySWw4TTU5ejZqMVI1WlVtYzFJQjcyNVhNVzV2U0tCTUFXQmtDWXNk?=
 =?gb2312?B?Y2oyVkJ2bkprV2QzcnNFT013cEk3T01FRkJ6b2sxMVordENaOXFsdE1vTTZZ?=
 =?gb2312?B?UTZEQnloZEN3QnFPYzNQTEUyMHBvenp5Vm1MMHpxTHJydTlMKzRwbXNjS1lz?=
 =?gb2312?B?MjhsbUJqVzQwT1NOQlBheXZkb1pJeE5RVWVKdVNtUHpsVWhsdlVlOFBsS0Nh?=
 =?gb2312?B?Unhnd1lPbVZRUkMzRGpJVHR6VlFxWnEwalptNmxqeFA1L3RkSExrTE10UnYv?=
 =?gb2312?B?ajBlc0x3eWFyZTArcFFVZ08xek9ZeG8rNHFvV2Evek9iRGVHN1FiTi9DMDIx?=
 =?gb2312?B?VVlMODE2c3JzMURzMEYxMU52SThuNTJsRlNVSlduZ3c2bDJOQmpjQXA3ZnNQ?=
 =?gb2312?B?YXlYS241ZXJUVFFCektqbk9DSnhza2Q4MWEzYm1GRVJVcitmSnpqMTRNZno5?=
 =?gb2312?B?RS9xc2VkOXAwWk9uM25TdUt1dmhrN2hoblBJbENNR0RvWDNxOE9YNGIzVEJa?=
 =?gb2312?B?dUxzaHdFT0g4a0grNmRwTG1IcUt4c0JESVJXcm9leWlNZ2Z0MG1GVmMwYVMv?=
 =?gb2312?B?S0JFaGFDenlVK3pKeko3ZjV1WUtXc29PQmNLT2pySjdPbUFmWm1kdmJoZlNS?=
 =?gb2312?B?bTlxd2ZBbnZBM1ZSWVhuRC9wUmhqK0ZqWE9YcHdRbkFXNVU5UDVRbGVuTlBU?=
 =?gb2312?B?U2h3azNkREtzMkw4ZDEvalJMazB1M2QyYm9xZHlPUGhOWEdtUThEb21YVjU3?=
 =?gb2312?B?TUZwdm04VXNxelBEd0NrbzBETWJDNU4vOUdMeEVDbXZTTlM5dU1aVXRpSUY1?=
 =?gb2312?B?VFZLZ0N1T3RSZ0U0czdCVlFaRCt3SFNlcWxINFIzT0hmM2VQbHRHRnJyRGNv?=
 =?gb2312?B?aEJBei9qcWFuUC9ZakJtUGFWMnRXK1F5emR0b0pxRUJ0ZUNzN0NIWUZlbjQ2?=
 =?gb2312?B?eitNZWo3d3llMHR0M3paUTNyTy9WU0VUZnl5VXlSYlFBQUJxRmF5Q1FSejFr?=
 =?gb2312?B?cXRBWnI3bFhpU1p5UWN3dGtGS0FPbUw2UllvY3NmUHAxZWNJNVB0QjU4Vm5p?=
 =?gb2312?B?TUNWQTBrdFEzdkdINWR6SU44U3RUYzBjb0lrSDVQL3Q5a0kyOU40OEtOU05U?=
 =?gb2312?B?T2lSYytpdys4R2k0ZzN0VCsyZXA2cTJGMG5JQ1IzNHozYWRpNWRPcmlQKzBE?=
 =?gb2312?B?M1VaUmxKc0V5UThlNkpHN0FrK2t4Q3h1ejJ0YVAycllVYVNUYTVsK1AzUVda?=
 =?gb2312?B?UHJONEdDRytmU2VPVExWVisvSTYvaDBlZ2V2M25SUWJyTzIwUkdFV21YbXZt?=
 =?gb2312?B?NXd0cDBkaHcyTHlBSGZ5MjBZdkJKZC82bnFzZmN6WFBCK1BDY3NlNXpLVWZt?=
 =?gb2312?B?SEcrUU51M1NUeHhvZGJxK0tJd3llcEdheWdCblVxaytEaWJzQ2VqK2tNdDBk?=
 =?gb2312?B?a1RuR2YwaHZXZHkzekZyTlBzc0poWEhVM2VkeHpvMXpzdnNpRVhhVlFXaWRh?=
 =?gb2312?Q?Ef5/5igGom967qiEK1xe5Aa41kyo2drNLuvij/Y?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88e8b01b-7ae1-4b1b-d92d-08d924208cdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2021 10:40:46.9847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J6Kq8Kwr/QHmuxXFRiQkQ6lwHevMy4qoerZq1g+Ji/IPVbBTAeDjielf5wh7HhQWKVQf3NYP8vHasLDS7e9l7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7399
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNoYXJkIENvY2hyYW4gPHJp
Y2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqNdTCMjXI1SAyMDoyOA0KPiBU
bzogWS5iLiBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnOyBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgQ2xhdWRpdQ0KPiBN
YW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJu
ZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW25ldC1uZXh0LCB2MiwgMi83XSBwdHA6IHN1cHBvcnQg
cHRwIHBoeXNpY2FsL3ZpcnR1YWwgY2xvY2tzDQo+IGNvbnZlcnNpb24NCj4gDQo+IE9uIEZyaSwg
TWF5IDIxLCAyMDIxIGF0IDEyOjM2OjE0UE0gKzA4MDAsIFlhbmdibyBMdSB3cm90ZToNCj4gDQo+
ID4gQEAgLTc2LDYgKzc3LDExIEBAIHN0YXRpYyBpbnQgcHRwX2Nsb2NrX3NldHRpbWUoc3RydWN0
IHBvc2l4X2Nsb2NrDQo+ID4gKnBjLCBjb25zdCBzdHJ1Y3QgdGltZXNwZWM2NCAqdHAgIHsNCj4g
PiAgCXN0cnVjdCBwdHBfY2xvY2sgKnB0cCA9IGNvbnRhaW5lcl9vZihwYywgc3RydWN0IHB0cF9j
bG9jaywgY2xvY2spOw0KPiA+DQo+ID4gKwlpZiAocHRwX2d1YXJhbnRlZV9wY2xvY2socHRwKSkg
ew0KPiANCj4gR29pbmcgdG8gbmVlZCB0byBwcm90ZWN0IGFnYWluc3QgY29uY3VycmVuY3kgV1JU
IHB0cC0+bnVtX3ZjbG9ja3MuDQoNCldpbGwgcHJvdGVjdCBuX3ZjbG9ja3MuDQpUaGFua3MuDQoN
Cj4gDQo+ID4gKwkJcHJfZXJyKCJwdHA6IHZpcnR1YWwgY2xvY2sgaW4gdXNlLCBndWFyYW50ZWUg
cGh5c2ljYWwgY2xvY2sgZnJlZQ0KPiBydW5uaW5nXG4iKTsNCj4gPiArCQlyZXR1cm4gLUVCVVNZ
Ow0KPiA+ICsJfQ0KPiA+ICsNCj4gPiAgCXJldHVybiAgcHRwLT5pbmZvLT5zZXR0aW1lNjQocHRw
LT5pbmZvLCB0cCk7ICB9DQo+IA0KPiBUaGFua3MsDQo+IFJpY2hhcmQNCg==
