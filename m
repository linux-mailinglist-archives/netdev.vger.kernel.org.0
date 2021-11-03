Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE55044409E
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 12:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbhKCLd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 07:33:29 -0400
Received: from mail-mw2nam10on2136.outbound.protection.outlook.com ([40.107.94.136]:10593
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231127AbhKCLd2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 07:33:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NIbsK0p8gu2WxeGq4z7KohAZq0bTtc2unw0gRrsLPQvldVXvY6gEW682nQPpvij+HZnhzx9FdzScyJ0bcG6e41Hx9kcJLLXl3I7MXIOz2UvwC8gz/ZMNvOBqouS6wRSzyBnzFZ61pPh1jzQ91ISAGVvDyptp6O4p6ZhwXkT46zGriWcCNX/bmMWlLdTEwoxfsnY7D6PJLqkt+cow79HIUqz8QXWT2pitH7O0HZWHmfpyT/E6glqLdKpadcQnaWhZ1PxyxUdIuHU2iXt93RGvhdX2TY+H3M5dToeUOgQRmd7HFNyRqzAjhCNFjxbfmjmgZDVhEmlW08H8kzjgUvBktg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K6rn93OWGs3/n4YphMso8RgFMYtNIERiBVzrZLFhn1Y=;
 b=BRUuOS9Kyf4KC2PLrMF2EsOGBQZg8EBQDXy3536kKBjunDoXzWrOyR1aT1R898JKGkvHfYz0lOfQQUY0fAEErGCZ5Im9wXuGHr79wQTo/L8rHzVrIuXLaJ0bMhQ3VeUvZltLdV2p586G8Nde76jYyRWIJE0aWB2Es2788eSNiukExsc6kGe3PNnscCYg+19WL6utwFv0/AM6tGE253fv3h/VqIxxIr/7EFIqpN0ORSMhKLYvyIqsysA1gxl7lc1rQASjdIzTGGCbvzXObzWCqdBM3C+BapCglNUF+11RsECXxLz/wW1VPPW9OGZsMRPdWvz/k7LpeSfmRNVLAObeTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K6rn93OWGs3/n4YphMso8RgFMYtNIERiBVzrZLFhn1Y=;
 b=Q9+ATP9e34BGxPY/k1CgDVmqCy8QTkwtDyDHcM/j+KsTtALqLpaxaOTuSM+4WsJq67to4TOXqCvLuw9O9SgGctDNK9TtMBSkQDdXaPaPio06aEf7962YZLEBnDQNx5VMUC75t/v3ClBwy5w6zeBoKwF4H6s4KjnSJGp5iNhYM34=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM6PR13MB3162.namprd13.prod.outlook.com (2603:10b6:5:197::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.8; Wed, 3 Nov
 2021 11:30:50 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e%5]) with mapi id 15.20.4669.010; Wed, 3 Nov 2021
 11:30:50 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>,
        Oz Shlomo <ozsh@nvidia.com>
Subject: RE: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Thread-Topic: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Thread-Index: AQHXy+v7vBQ2XbePHEaO7o5JqSPS/avqRgqAgAEbH4CAAECyAIAAv3npgAC92QCAAOYhwIAAScwAgAHmiwCAAUGbwIAAJ94AgAASrMA=
Date:   Wed, 3 Nov 2021 11:30:50 +0000
Message-ID: <DM5PR1301MB2172AD191B6A370C39641E3FE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-9-simon.horman@corigine.com>
 <ygnhilxfaexq.fsf@nvidia.com>
 <7147daf1-2546-a6b5-a1ba-78dfb4af408a@mojatatu.com>
 <ygnhfssia7vd.fsf@nvidia.com>
 <DM5PR1301MB21722A85B19EE97EFE27A5BBE7899@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <d16042e3-bc1e-0a2b-043d-bbb62b1e68d7@mojatatu.com>
 <DM5PR1301MB21728931E03CFE4FA45C5DD3E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <ygnhcznk9vgl.fsf@nvidia.com> <20211102123957.GA7266@corigine.com>
 <DM5PR1301MB2172F4949E810BDE380AF800E78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <428057ce-ccbc-3878-71aa-d5926f11248c@mojatatu.com>
In-Reply-To: <428057ce-ccbc-3878-71aa-d5926f11248c@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63c16df9-290e-4870-4d58-08d99ebd6395
x-ms-traffictypediagnostic: DM6PR13MB3162:
x-microsoft-antispam-prvs: <DM6PR13MB316256EEF3BF433A6A750244E78C9@DM6PR13MB3162.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JVgmUN2PucPtEtcP6q3x/1soIBMzbvnqAh+SCMcxF3ZLuDTtcRfwWCgiAWM9z6noRBqDTgqLHuHXiQ8bg03nG739sgIdkqLCnJjB7pYfw8hMH7OLOAMeVTfnP97+BX3cXnyFt++D4hGuc3l7mPqpUCyR5YL5dH99l3Py1/JlVPgz2Inm6vxV6/wpzLltKt3qClA0Bp8GlpWPnK9LPXKU7yTlFiYAHgSO+QkeEfHgCLZxDfj8VjFCsGrCcRx9Rjxx9olJEHzpYlv+0bcQ9xj0PpI36pqWdll1Y5k7L5K8A9b7vEt2jgIIUGrJ9IGnOVmuLJzaopF94nDXnjAG6+9GfQQgmMnKki28uEyJ3+WOdAZDh82Q8dbiMzlWlijpqpNBJ+dbH3mwGjKU5RerGsQJZhPhjPygdgDEDd76h8yixXTbl71t+wZWBbG2LF7ZMto9NMGJp9jPiRfFM1oDTMa61BQkrr/3aPLmw5tL2YNpinRi2+N3jTwE6sKerkEGAsR6nOGyW7GrRg5o/l+FfWuTrwraJUl4P5tQO+Prj0/gqVFel11e1a2DmqYY/1Hj8nYdv0cmLjROVMV9rln5YIkEB0hTlI8iwhqFvZQIv4BKrWfG5y08/Wqy0M3xOEpWaLwUDXa58+/etn1azqtou5zbyC9AUKQRpQGXgWRRZH57jIKmv95W+agMmV9BnnhC6NJkEt9e1ygRhFrzHfCTRXlAMA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39840400004)(346002)(376002)(136003)(55016002)(8676002)(33656002)(508600001)(71200400001)(7696005)(2906002)(76116006)(38100700002)(6506007)(66446008)(66476007)(66556008)(64756008)(316002)(186003)(52536014)(66946007)(26005)(122000001)(8936002)(9686003)(5660300002)(44832011)(110136005)(54906003)(4326008)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?KzUwVG5QR04vZ2tHT29vK3IvM0hxVGNzVWZDaUExdGlkSEdPU0hWZ3NxNnYx?=
 =?utf-8?B?Nmd6UUxrNUJ4dTZHaGduZjJtZFhnZk5Sdnl0OTEzc0lqd2ZkeWJvRldxZm9L?=
 =?utf-8?B?ckpqNis1VWZjNjNNYzFWWkIrdTN4d1VzS0dBelZ0RUlaNjBlblgrcFpQbEpS?=
 =?utf-8?B?Z0QzTXR0UUUySXpMYmUzMnlMTGxXRmdyYm1LZXA2UlA1Unp6RU1KeS8rUnYw?=
 =?utf-8?B?N3Z4cDhoemNkZUJXM0I3YXMwTmltT1V1UFJka2VQZVpPMTFjTnN5RG94RFRF?=
 =?utf-8?B?UXpYam5FcFRTcUd5TVVEZkl3eE1YTDI3VU4xaXhheW4yRHB3ZTVBeVppbU96?=
 =?utf-8?B?YUZjL0FMdXh3UTZ6YWp1Tm1YWDlyWVFkWlJrd2tsT0VuZTNHbk9ieWR4Ymoz?=
 =?utf-8?B?NHU1RUprdktQcVNiQVp0RmtnZU85Qm9IM2lLdjhFTmRkM1hqSzVQMG5BTHFU?=
 =?utf-8?B?VGtSM3dLOU5jdVRzTzd5VzdpNjdjVVJwL2VCNEFYYUpqei9sV0dyMTZ6eHZM?=
 =?utf-8?B?OU5LMVo2SFdOdURkSHhvUUZjaUdid0Y0a2RNdHVkWnd6MmUxMjNscjk4OXNU?=
 =?utf-8?B?cDhXSjhOZWhndU9BTUIvMExNb0xUZ1IxZ1hHTm1za29BaXhmKzhIOXlEamRO?=
 =?utf-8?B?L293djMvWVhWRDg2elhtNC93aGNFNGwxSWpRR3NibnhhWm8zV1NjU2pzT1Zv?=
 =?utf-8?B?bWRRSVlYUzQ0cGdyZHVCUTc2WFZUVmJ5TStyaUIybUZOb2x2TFZEQVRaRW5W?=
 =?utf-8?B?N2xWUDFtck9TTzdaaElvV2lyaXYvQlVWL1BlWG5NRGwzT0NTdVVneEkvdURD?=
 =?utf-8?B?ZzJCRDRTZmNuVmw3UE9Hb2xjS096ODJFTDVFYWMyOG1Td2taRmh3dHRxYlBo?=
 =?utf-8?B?RzIrWnVwNkZycWZZRFB6emI2Z2hvSXNTOHdMS2VRUGhqVk9ZclIyZEwxellH?=
 =?utf-8?B?b2NTajQxb2xpREE0SGNzajFGejVLd0JaclBRSjQwVkgyR1JpWDBDaUtqdVpN?=
 =?utf-8?B?QlJPTVpLVUJRUFlZVHJOZmlzZ1Q3a2hsU1FSY0NjbkVCU2dNTVlnMmJaYzBi?=
 =?utf-8?B?ZW5EWnpBSm1FOHlSR3JOS0swdWgybnMwUzE4VkZSdC85UUF0ckxFM0N3Mzd5?=
 =?utf-8?B?RFk5SEVDbUt1NVBVeW93TUJ3ZUY5ZW42bTBoZGNMU3RQakgrWFhYZnJ0K2ZH?=
 =?utf-8?B?bjhpMWR5UGl2RHorTVB6T29VUlBnQThLc25oSXltTlJCQk9kMUxuUE9zNkVj?=
 =?utf-8?B?SnlRU0hIMjV2K1lOUzJGV1BGQlEyQThIK3l2M2hXOXBFQXdQcThrUC9JRHF6?=
 =?utf-8?B?SzE4UFBJYWQ4RUFTR2gxS1pXcUZCc0xzeVQrMkcvc2FWUFhZdDAzYmQ4RXFE?=
 =?utf-8?B?RTk0RDJKWHpLVkRxR3RDMFlXZlAvb2tEWTdtK3hqaEpYMUZLTm1RZzRBcUFo?=
 =?utf-8?B?bHJqd1ZLU2dJbXlWdnZIUE9lREFpZHNXaS80cU4wQVJPK3c5dG5Mai9tNUtM?=
 =?utf-8?B?aStOVHJMeXVUcjhDVlpXb0kva251dE9jVmI1SEpocEh4ZFBGYXBEZkFNZW1h?=
 =?utf-8?B?UFpaK0FTU3Boa21nMXRzMWYwUERWSllkNWdhekRPYStyNEhKZmJuZVNCR0l5?=
 =?utf-8?B?QUg2a1FDL1gzOGY5ZVNCdm83NEJsZ21LeXlpaTlPdlN5S1RsVDdiZWRwUXRS?=
 =?utf-8?B?bWFDek5mbVVtNDFLVmxrbXVQVTR6bmJCQndRZHRPclRCYmhIUU4rNHJ0N296?=
 =?utf-8?B?cnZpdzVZclNqdUZCUHVIVjcyN3BzQlRGVDdKY2VOU3BUUnBaVDlrbW9tQjJ4?=
 =?utf-8?B?Z21PZUs5VTVaNjNxMmwvQUZOY3NJOUo3Q2pvVklGcnhOUndRb1dJamovZy9B?=
 =?utf-8?B?Y2pZYnpIRmI3YzZ6WTVjLzJGTWV1S05IckovNmo5SE81TzdtVytTSUZ6VXNp?=
 =?utf-8?B?a3FjK29ZMUtKenAyNitBOWRJT0VITzhnYitNZWZvNXYyUEM2dTR1d29ubVFH?=
 =?utf-8?B?ZnZvdERWRi9Ha3lCWXovcVdFcWIwbFFzTW5jS3ZqVDJyMlJMK011dkJ3MmRN?=
 =?utf-8?B?aUgxcGxZRnZiY2pQZ1I4U3VHSldoRXhlZ1dlVFdNbTZOMmhmRzJ2UG9wUlZC?=
 =?utf-8?B?Nm1yWTlNOHI3VitRS0E0Q0poaEdXc1Z6Z1hsZzltQzdLN00yUThxeDZRNGpj?=
 =?utf-8?B?cGF3Z2pXWHFlL2NPT1FoeUowVnFxcUtlemQ0djhHckkzamV5amJNbzF5cTQx?=
 =?utf-8?B?c1dBa0hLQmkrOUZiSXlrS1VXbStRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63c16df9-290e-4870-4d58-08d99ebd6395
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 11:30:50.5832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gUS9aFYtS1sxhoDX0vZisy745t/holPTzuVVkaKlk5jOHsSpiyrMqWvbRRd2lnn479RTdSWjjG73DR7+TZWAmXjqeS9QNfnK+UgPHEhcrT8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3162
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTm92ZW1iZXIgMywgMjAyMSA2OjE0IFBNLCBKYW1hbCBIYWRpIFNhbGltIHdyb3RlOg0KPk9u
IDIwMjEtMTEtMDMgMDM6NTcsIEJhb3dlbiBaaGVuZyB3cm90ZToNCj4+IE9uIE5vdmVtYmVyIDIs
IDIwMjEgODo0MCBQTSwgU2ltb24gSG9ybWFuIHdyb3RlOg0KPj4+IE9uIE1vbiwgTm92IDAxLCAy
MDIxIGF0IDA5OjM4OjM0QU0gKzAyMDAsIFZsYWQgQnVzbG92IHdyb3RlOg0KPj4+PiBPbiBNb24g
MDEgTm92IDIwMjEgYXQgMDU6MjksIEJhb3dlbiBaaGVuZw0KPg0KPlsuLl0NCj4+Pj4NCj4+Pj4g
TXkgc3VnZ2VzdGlvbiB3YXMgdG8gZm9yZ28gdGhlIHNraXBfc3cgZmxhZyBmb3Igc2hhcmVkIGFj
dGlvbg0KPj4+PiBvZmZsb2FkIGFuZCwgY29uc2VjdXRpdmVseSwgcmVtb3ZlIHRoZSB2YWxpZGF0
aW9uIGNvZGUsIG5vdCB0byBhZGQNCj4+Pj4gZXZlbiBtb3JlIGNoZWNrcy4gSSBzdGlsbCBkb24n
dCBzZWUgYSBwcmFjdGljYWwgY2FzZSB3aGVyZSBza2lwX3N3DQo+Pj4+IHNoYXJlZCBhY3Rpb24g
aXMgdXNlZnVsLiBCdXQgSSBkb24ndCBoYXZlIGFueSBzdHJvbmcgZmVlbGluZ3MgYWJvdXQNCj4+
Pj4gdGhpcyBmbGFnLCBzbyBpZiBKYW1hbCB0aGlua3MgaXQgaXMgbmVjZXNzYXJ5LCB0aGVuIGZp
bmUgYnkgbWUuDQo+Pj4NCj4+PiBGV0lJVywgbXkgZmVlbGluZ3MgYXJlIHRoZSBzYW1lIGFzIFZs
YWQncy4NCj4+Pg0KPj4+IEkgdGhpbmsgdGhlc2UgZmxhZ3MgYWRkIGNvbXBsZXhpdHkgdGhhdCB3
b3VsZCBiZSBuaWNlIHRvIGF2b2lkLg0KPj4+IEJ1dCBpZiBKYW1hbCB0aGlua3MgaXRzIG5lY2Vz
c2FyeSwgdGhlbiBpbmNsdWRpbmcgdGhlIGZsYWdzDQo+Pj4gaW1wbGVtZW50YXRpb24gaXMgZmlu
ZSBieSBtZS4NCj4+IFRoYW5rcyBTaW1vbi4gSmFtYWwsIGRvIHlvdSB0aGluayBpdCBpcyBuZWNl
c3NhcnkgdG8ga2VlcCB0aGUgc2tpcF9zdw0KPj4gZmxhZyBmb3IgdXNlciB0byBzcGVjaWZ5IHRo
ZSBhY3Rpb24gc2hvdWxkIG5vdCBydW4gaW4gc29mdHdhcmU/DQo+Pg0KPg0KPkp1c3QgY2F0Y2hp
bmcgdXAgd2l0aCBkaXNjdXNzaW9uLi4uDQo+SU1PLCB3ZSBuZWVkIHRoZSBmbGFnLiBPeiBpbmRp
Y2F0ZWQgd2l0aCByZXF1aXJlbWVudCB0byBiZSBhYmxlIHRvIGlkZW50aWZ5DQo+dGhlIGFjdGlv
biB3aXRoIGFuIGluZGV4LiBTbyBpZiBhIHNwZWNpZmljIGFjdGlvbiBpcyBhZGRlZCBmb3Igc2tp
cF9zdyAoYXMNCj5zdGFuZGFsb25lIG9yIGFsb25nc2lkZSBhIGZpbHRlcikgdGhlbiBpdCBjYW50
IGJlIHVzZWQgZm9yIHNraXBfaHcuIFRvIGlsbHVzdHJhdGUNCj51c2luZyBleHRlbmRlZCBleGFt
cGxlOg0KPg0KPiNmaWx0ZXIgMSwgc2tpcF9zdw0KPnRjIGZpbHRlciBhZGQgZGV2ICRERVYxIHBy
b3RvIGlwIHBhcmVudCBmZmZmOiBmbG93ZXIgXA0KPiAgICAgc2tpcF9zdyBpcF9wcm90byB0Y3Ag
YWN0aW9uIHBvbGljZSBibGFoIGluZGV4IDEwDQo+DQo+I2ZpbHRlciAyLCBza2lwX2h3DQo+dGMg
ZmlsdGVyIGFkZCBkZXYgJERFVjEgcHJvdG8gaXAgcGFyZW50IGZmZmY6IGZsb3dlciBcDQo+ICAg
ICBza2lwX2h3IGlwX3Byb3RvIHVkcCBhY3Rpb24gcG9saWNlIGluZGV4IDEwDQo+DQo+RmlsdGVy
MiBzaG91bGQgYmUgaWxsZWdhbC4NCj5BbmQgd2hlbiBpIGR1bXAgdGhlIGFjdGlvbnMgYXMgc286
DQo+dGMgYWN0aW9ucyBscyBhY3Rpb24gcG9saWNlDQo+DQo+Rm9yIGRlYnVnYWJpbGl0eSwgSSBz
aG91bGQgc2VlIGluZGV4IDEwIGNsZWFybHkgbWFya2VkIHdpdGggdGhlIGZsYWcgYXMgc2tpcF9z
dw0KPg0KPlRoZSBvdGhlciBleGFtcGxlIGkgZ2F2ZSBlYXJsaWVyIHdoaWNoIHNob3dlZCB0aGUg
c2hhcmluZyBvZiBhY3Rpb25zOg0KPg0KPiNhZGQgYSBwb2xpY2VyIGFjdGlvbiBhbmQgb2ZmbG9h
ZCBpdA0KPnRjIGFjdGlvbnMgYWRkIGFjdGlvbiBwb2xpY2Ugc2tpcF9zdyByYXRlIC4uLiBpbmRl
eCAyMCAjbm93IGFkZCBmaWx0ZXIxIHdoaWNoIGlzDQo+b2ZmbG9hZGVkIHVzaW5nIG9mZmxvYWRl
ZCBwb2xpY2VyIHRjIGZpbHRlciBhZGQgZGV2ICRERVYxIHByb3RvIGlwIHBhcmVudCBmZmZmOg0K
PmZsb3dlciBcDQo+ICAgICBza2lwX3N3IGlwX3Byb3RvIHRjcCBhY3Rpb24gcG9saWNlIGluZGV4
IDIwICNhZGQgZmlsdGVyMiBsaWtld2lzZSBvZmZsb2FkZWQNCj50YyBmaWx0ZXIgYWRkIGRldiAk
REVWMSBwcm90byBpcCBwYXJlbnQgZmZmZjogZmxvd2VyIFwNCj4gICAgIHNraXBfc3cgaXBfcHJv
dG8gdWRwIGFjdGlvbiBwb2xpY2UgaW5kZXggMjANCj4NCj5BbGwgZ29vZCBhbmQgZmlsdGVyIDEg
YW5kIDIgYXJlIHNoYXJpbmcgcG9saWNlciBpbnN0YW5jZSB3aXRoIGluZGV4IDIwLg0KPg0KPiNO
b3cgYWRkIGEgZmlsdGVyMyB3aGljaCBpcyBzL3cgb25seQ0KPnRjIGZpbHRlciBhZGQgZGV2ICRE
RVYxIHByb3RvIGlwIHBhcmVudCBmZmZmOiBmbG93ZXIgXA0KPiAgICAgc2tpcF9odyBpcF9wcm90
byBpY21wIGFjdGlvbiBwb2xpY2UgaW5kZXggMjANCj4NCj5maWx0ZXIzIHNob3VsZCBub3QgYmUg
YWxsb3dlZC4NCkkgdGhpbmsgdGhlIHVzZSBjYXNlcyB5b3UgbWVudGlvbmVkIGFib3ZlIGFyZSBj
bGVhciBmb3IgdXMuIEZvciB0aGUgY2FzZTogDQoNCiNhZGQgYSBwb2xpY2VyIGFjdGlvbiBhbmQg
b2ZmbG9hZCBpdA0KdGMgYWN0aW9ucyBhZGQgYWN0aW9uIHBvbGljZSBza2lwX3N3IHJhdGUgLi4u
IGluZGV4IDIwDQojTm93IGFkZCBhIGZpbHRlcjQgd2hpY2ggaGFzIG5vIGZsYWcNCnRjIGZpbHRl
ciBhZGQgZGV2ICRERVYxIHByb3RvIGlwIHBhcmVudCBmZmZmOiBmbG93ZXIgXA0KICAgICBpcF9w
cm90byBpY21wIGFjdGlvbiBwb2xpY2UgaW5kZXggMjANCg0KSXMgZmlsdGVyNCBsZWdhbD8gYmFz
aWNhbGx5LCBpdCBzaG91bGQgYmUgbGVnYWwsIGJ1dCBzaW5jZSBmaWx0ZXI0IG1heSBiZSBvZmZs
b2FkZWQgZmFpbGVkIHNvIA0KaXQgd2lsbCBydW4gaW4gc29mdHdhcmUsIHlvdSBrbm93IHRoZSBh
Y3Rpb24gcG9saWNlIHNob3VsZCBub3QgcnVuIGluIHNvZnR3YXJlIHdpdGggc2tpcF9zdywNCnNv
IEkgdGhpbmsgZmlsdGVyNCBzaG91bGQgYmUgaWxsZWdhbCBhbmQgd2Ugc2hvdWxkIG5vdCBhbGxv
dyB0aGlzIGNhc2UuIA0KVGhhdCBpcyBpZiB0aGUgYWN0aW9uIGlzIHNraXBfc3csIHRoZW4gdGhl
IGZpbHRlciByZWZlcnMgdG8gdGhpcyBhY3Rpb24gc2hvdWxkIGFsc28gc2tpcF9zdy4gDQpXRFlU
Pw0K
