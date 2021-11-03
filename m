Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFF04443D6
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 15:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhKCOvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 10:51:21 -0400
Received: from mail-dm6nam08on2105.outbound.protection.outlook.com ([40.107.102.105]:48609
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230213AbhKCOvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 10:51:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSygBrIf6CPw9Aui9EFpISU1T+r0GSWdMjTJyQ5SU8Gxz1j3ut8+4mFXsMvQnLYP8khPrFL6sfR97R4OptkhaqOHsEpI8140dbqIAoSzuu/Wk8lM3cPMhiScoH3J01sd7Lce64amT7sr6bOavVe9qjg9dKS40YJCyCLPB/h16wGN7mp+V25iJfXkdLfl98AhR0SwWotNXKX1EZgEGiUi0t9mIXUMbCdLYCw4NJ+3+uFXLl3Iy+6v1VHZdiIxgdKgjIUZfRfBqpwaCF7CgpqNguRC8k1ee/8+qfRvohVWh8CCciWUbOhZyw/Z1aycpjAagu5c2nxecwNwqR43R/Pefw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UPziovV0dmPCWNUsaEIVrMsMu7otYV5iYQ1X2SQ3rGc=;
 b=c67kjm7qpkPS+TFF0am5HvYuMfM9bnGJ1MvYBBE5+SJGKDE3t8SVKYoncyuWceeJDKvLZZjtXST8y5/v/Myz74TlHr3D8iWMlvHD9ud/ydp6U+1xK+JqXJU8AfRG7SCd241fzxgm5KaA0Pn5LBw4jU9M8tK3Epindzv188415MWx6L0Yw9F65V6FkUy44Qr6BPdMI8bG0G8YV75llmsSgudkwwEFtV+mLtZLMp+h9H2Qmm57UMpfYU/c9858MHtGAHgzzLQVN+XXM49Lz96WSAhrMeUeKsRHJmkB2H1/l5NL0PSH1dx49iWUdZhdvhjoM3SP9+tX8fJHWJR+SzC1Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPziovV0dmPCWNUsaEIVrMsMu7otYV5iYQ1X2SQ3rGc=;
 b=kmy2QIhBFEA4+ndTXQBcmRyMeQy31aOzebt+WznBwoIEBq2ZFEd5x2y5AMNhgmmliL8kWe093KXV/U2weu9MtOlePOlMKLefqVPv2psN8oKrIlJWQJ9kQbLu2/eYTwV8wAq2Oz2k1+wQPO/PsIAvjA9P2/Vrq1uthVMAV5/DwOc=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DS7PR13MB4703.namprd13.prod.outlook.com (2603:10b6:5:3a0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.4; Wed, 3 Nov
 2021 14:48:40 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e%5]) with mapi id 15.20.4669.010; Wed, 3 Nov 2021
 14:48:40 +0000
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
Thread-Index: AQHXy+v7vBQ2XbePHEaO7o5JqSPS/avqRgqAgAEbH4CAAECyAIAAv3npgAC92QCAAOYhwIAAScwAgAHmiwCAAUGbwIAAJ94AgAASrMCAABR9gIAAEMIAgAAE2XCAAAbvAIAABdDQ
Date:   Wed, 3 Nov 2021 14:48:40 +0000
Message-ID: <DM5PR1301MB2172BBAA594802D4F8F88670E78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
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
 <DM5PR1301MB2172AD191B6A370C39641E3FE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <66f350c5-1fd7-6132-3791-390454c97256@mojatatu.com>
 <10dae364-b649-92f8-11b0-f3628a6f550a@mojatatu.com>
 <DM5PR1301MB2172BFF79D57D28F34DC6A0AE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <cd624f2b-a693-84eb-d3f4-81d869caad93@mojatatu.com>
In-Reply-To: <cd624f2b-a693-84eb-d3f4-81d869caad93@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 690a3533-0f34-4d33-b375-08d99ed9067a
x-ms-traffictypediagnostic: DS7PR13MB4703:
x-microsoft-antispam-prvs: <DS7PR13MB4703D4BE3A03D4E5B2FAF808E78C9@DS7PR13MB4703.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MIYCaBeEMEXOsd9bO+3OpVUkPaaG/gb3WhKmjQiEPxvMfRfGs1gRbYgtszU2mOGs57HW45Roi3DRwP+5ubv3dnSn+A48Vo7QD2aE/iaGNqR5JWct2zbOINgWi8EHC3nj0mqZbSgwruOOFESgPP+ZmONM6QsKGEvxa92xh6q6tWHfcm2hZed2CTkHvdbTSZ4t3Zoa5Mf5s7BO9/BkXN1NIyje9vAqi1TqIl8BHrWqa5nuKCulAT0nju2mZX7DZlZbq0sZBtm58fXAWIpPS3SgtpK0Zw1FKVn8NLsjpsanZAEZQKskyvqG6B3Xhn0SdbAFcr0VkmZ22s3pWEGfiG7fKbkf07PN+yHV+831jFUwolhFJYhOb9qZboGxAi2aVpygzUgvmVAqNtp8aYQPHfCLME32XhcPgsIRy5l/2kei40uc/TW57VCQfBGWfBUk5t6lVdLmtKv9Np71oZQdOpWlLjpcQRFuf5Ejy0QGU2xSdBE4rzK4lp2JNl9/idHnL+c1OWW5rgWKoV7uHSc/p3hxw/liisZYY3LcKzcENTggO4oB27fxmTf4zhIg7yTQrWClu9tdVotyk8saNz4AzPrIAV5ZVN4eDszUudXpY4jh11Z86uXQc/vSDIX2KsRtmopWU6US90Qi1tmCgVq0rLXqMyKkMzRqYZNjgq2OlLv0ELMzDS3Yfj/sPb2jGv4O++Ud8ARA/KJnCnVkfvx1FdY34A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39840400004)(346002)(376002)(366004)(5660300002)(8676002)(38100700002)(53546011)(186003)(4326008)(6506007)(8936002)(26005)(33656002)(71200400001)(7696005)(86362001)(52536014)(54906003)(122000001)(83380400001)(110136005)(55016002)(9686003)(76116006)(66446008)(66556008)(44832011)(64756008)(2906002)(66946007)(66476007)(316002)(508600001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVkzdDJpRmFvWURGdFYvZHBGNW50WlJ4UVg2NWx4YzRJSGtnQVIvc3lieWFq?=
 =?utf-8?B?VkVzRUxyS1QxS1dzajdhL2haTWdrL25SdjJFOGRkRExjTS93aTB1LzZGSVRt?=
 =?utf-8?B?b01Zbm5XREs4US80bjh1UFhwNW1oWk96SzF1TEZZN3doMGluRjRSZnBJRXRL?=
 =?utf-8?B?YXRoUXYzclJPNXFpTUFkdVBZODZ3Um1mRm5xN1l5NnVpMVlhemdtblN1NEdY?=
 =?utf-8?B?bUdxYWxYZUg4ZllBVWFFWWo1SUZia2dRUUhXQWdFaXJua3pGZGJ3anp4bU15?=
 =?utf-8?B?eFlxWlptamVnSGpaaFhMS3U0RG5GNFpCY0Rub3FGVVJHMGJDeUVIQVJmZWFz?=
 =?utf-8?B?SXM2T1dUWWhHcFJFaWI5cTdIRWZmN2lRUVlaN1ZiZW5MWUdIbGYxSXpKSnFB?=
 =?utf-8?B?N3BFUThpMWVIZW5ZaS95NTNuL1BQcGJrVzZocGpOaEdPWXZrNDh1Q3k3NXFp?=
 =?utf-8?B?MUxWc1Nva0EyYmRJVWFZU1FKMG5INGpxSHBqZGkrMGdFS0k2VHczRHM1K1hy?=
 =?utf-8?B?alZ1UjNFWlREa1UwZVpFdms3dG1VWW9ONGxVK0sxUWlYeDQ4bmxMUTVrS0lp?=
 =?utf-8?B?WlNCODFHNmorMkJ6SDBaRllwbW9sSjFDMmwxQ01xVk14ZFVLUlZDNCsxYjM1?=
 =?utf-8?B?M1g1YlBPS0ppT3ZSK3VXRGU5SUdjeStEWmZkSUxGUHZ1WW9hUzBzU24xOWRB?=
 =?utf-8?B?ZWl5c2t2VWRwN1Y4N3JycmI3aVgzVHlueEFMZkhacnF1cW5aT3d6Z2pUeFJX?=
 =?utf-8?B?U2Z4aUN6Y2J6b0NmS2thSVRkdm1QUzhmWGU5Ymd5K1RpQ0c4QWlyTHNmSUlE?=
 =?utf-8?B?Q0pOaHJITjZRVjBBbmZnSDJlVHdxemdFeVNtMDdVS2FkaWJxSVlXZTlHMHZQ?=
 =?utf-8?B?V1BIay9SVmhrYWlSY2hjblhUSXd2WVlmaEtQdUFHdUNoc2g1RFlZNm1Rd3RX?=
 =?utf-8?B?V3Z0Q0JhVEFXQzYrOWYyZ2RFMVdiYlJZVlJndFdVY0c4THVqNUNvbVhpRE52?=
 =?utf-8?B?d0M2Sy9hdzgvc0QrV3U0TWxWd0hjRk5oZ1ZtTGxPeWZWa3IrcHczN3FpaFUr?=
 =?utf-8?B?MzhTY2dYS0hrTlZ5ay96WDdYNG4yQUdRc21xTDFRQ3lwWXBzR2V4bHUwR0FC?=
 =?utf-8?B?MUgzZFpQZGlUWWt1QVN4cUdRYVZsbFFLY2E5MWhJMVhBR045Qk1SVkNhWlFG?=
 =?utf-8?B?cHdrSkRKM1E5bGw4UndhREs4Vnl1OE1NTWZuZ3Z6eExNNVVsSVpxV1RjbXFE?=
 =?utf-8?B?ajBDeHQyWVJYOWVaSnl3VGpvQUl2WXRXM2JwOWlDaHNRZndPdUtZQkwra1hp?=
 =?utf-8?B?b0dYZVdQaFkzWTVrY1NwbmlvbkpqSHk2akpsbG14Y0x5QlZIU29BaUs0RFMz?=
 =?utf-8?B?bXp5b2IzbktwdzFNeGhLRkx0OEloUmlsVU8vWlg2KzhvSmNwRnhvUzVGNlpG?=
 =?utf-8?B?UCticmZubThGTnNxam1zbzBVUzdEOTQycEtDdU4vS0QvLzlPQUJLOTlONTli?=
 =?utf-8?B?TDRzWlVHcDNPd3Iza0hWNHIycDVHMmVMSE03U3dhRk95ZW44T1BJN0F4eHk2?=
 =?utf-8?B?L0hzS2tQcW1mQUJxNCtTU2dwVENyOEN2TjU2V04xRmhwUkFRL05xVTJ6cXc3?=
 =?utf-8?B?MGVHMjdVM2tySWJzT3VmNlZTaUtJV2lzUTg0ZVkzMThJdG9EemM3eEd0WHpp?=
 =?utf-8?B?SUk3ZHJ6c0d1UmpLRVpOSHJDZHczaVJMazljcUd2ZVRPcDRQb2dlN3FsMmVP?=
 =?utf-8?B?cCtOREg1VzR2Q3EvTi9VRXU4NzVkMjhaSytmRk53UEkwSzdKbnBzZ2VSWkhC?=
 =?utf-8?B?eHIzQVJtZGdtdTJDVHdibHZrb3kza2wzbmlNZy9IOWdZOStLdHBORkE3Wlcy?=
 =?utf-8?B?SUZvOW9uTnVOR0E0Y0ZITWN3Zy8xK2hnalIxOEFSbWFyblRBNWg0OTQ3TE1t?=
 =?utf-8?B?OW5DdWptQ001eU5kcjN1MVhYNktCZFp5MC8xSkwzc2g0Y3h1Zkl0TzQ4SkN3?=
 =?utf-8?B?ajZjSkwwUGlrWWl5NWgrbHg5N1lqTnhCdVVZM0dwamh0U3JBMy9ZK01mRU9V?=
 =?utf-8?B?ZUhQNENlcS9hbnJ3dHowYWtJYzBpN3NmYlluT1RvV1NvOXdxRFF1QXpqNU40?=
 =?utf-8?B?dGVBRGx5Z1FkUWtBd0VncWE4cys4cDZrRlphOXg0Y0hSWm9uY2lTTVN0RVM5?=
 =?utf-8?B?cEFYK092RVVKc2svUzVDK2RoekoyTjRNcTdNNk5mT1lRVjZqNzFFQkxuR3lM?=
 =?utf-8?B?SDFTcE9KZGdtdjdEMGpUbDBwVER3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 690a3533-0f34-4d33-b375-08d99ed9067a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 14:48:40.2063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mSQPRhOsTuNPVvkoAkEFt6JW/TNbQ2IHN1IsLlONceFH+cGMeL/I5HU2TyFv0MaNIIEr5VY58CwEETnxdCBaQDh2zi3j+Xrcr6WcXEXxiDg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4703
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTm92ZW1iZXIgMywgMjAyMSAxMDoxNiBQTSwgSmFtYWwgSGFkaSBTYWxpbSB3cm90ZToNCj5P
biAyMDIxLTExLTAzIDEwOjAzLCBCYW93ZW4gWmhlbmcgd3JvdGU6DQo+PiBUaGFua3MgZm9yIHlv
dXIgcmVwbHkuDQo+PiBPbiBOb3ZlbWJlciAzLCAyMDIxIDk6MzQgUE0sIEphbWFsIEhhZGkgU2Fs
aW0gd3JvdGU6DQo+Pj4gT24gMjAyMS0xMS0wMyAwODozMywgSmFtYWwgSGFkaSBTYWxpbSB3cm90
ZToNCj4+Pj4gT24gMjAyMS0xMS0wMyAwNzozMCwgQmFvd2VuIFpoZW5nIHdyb3RlOg0KPj4+Pj4g
T24gTm92ZW1iZXIgMywgMjAyMSA2OjE0IFBNLCBKYW1hbCBIYWRpIFNhbGltIHdyb3RlOg0KPg0K
Pg0KPlsuLl0NCj4NCj4+IFNvcnJ5IGZvciBtb3JlIGNsYXJpZmljYXRpb24gYWJvdXQgYW5vdGhl
ciBjYXNlIHRoYXQgVmxhZCBtZW50aW9uZWQ6DQo+PiAjYWRkIGEgcG9saWNlciBhY3Rpb24gd2l0
aCBza2lwX2h3DQo+PiB0YyBhY3Rpb25zIGFkZCBhY3Rpb24gcG9saWNlIHNraXBfaHcgcmF0ZSAu
Li4gaW5kZXggMjAgI05vdyBhZGQgYQ0KPj4gZmlsdGVyNSB3aGljaCBoYXMgbm8gZmxhZyB0YyBm
aWx0ZXIgYWRkIGRldiAkREVWMSBwcm90byBpcCBwYXJlbnQNCj4+IGZmZmY6IGZsb3dlciBcDQo+
PiAgICAgICAgIGlwX3Byb3RvIGljbXAgYWN0aW9uIHBvbGljZSBpbmRleCAyMCBJIHRoaW5rIHRo
ZSBmaWx0ZXI1IGNvdWxkDQo+PiBiZSBsZWdhbCwgc2luY2UgaXQgd2lsbCBub3QgcnVuIGluIGhh
cmR3YXJlLg0KPj4gRHJpdmVyIHdpbGwgY2hlY2sgZmFpbGVkIHdoZW4gdHJ5IHRvIG9mZmxvYWQg
dGhpcyBmaWx0ZXIuIFNvIHRoZSBmaWx0ZXI1IHdpbGwgb25seQ0KPnJ1biBpbiBzb2Z0d2FyZS4N
Cj4+IFdEWVQ/DQo+Pg0KPg0KPkkgdGhpbmsgdGhpcyBvbmUgYWxzbyBoYXMgYW1iaWd1aXR5LiBJ
ZiB0aGUgZmlsdGVyIGRvZXNudCBzcGVjaWZ5IHNraXBfc3cgb3INCj5za2lwX2h3IGl0IHdpbGwg
cnVuIGJvdGggaW4gcy93IGFuZCBoL3cuIEkgYW0gd29ycmllZCBpZiB0aGF0IGxvb2tzIHN1cHJp
c2luZyB0bw0KPnNvbWVvbmUgZGVidWdnaW5nIGFmdGVyIGJlY2F1c2UgaW4gaC93IHRoZXJlIGlz
IGZpbHRlciA1IGJ1dCBubyBwb2xpY2VyIGJ1dCBpbg0KPnMvdyB0d2luIHdlIGhhdmUgZmlsdGVy
IDUgYW5kIHBvbGljZXIgaW5kZXggMjAuDQpJbiB0aGlzIGNhc2UsIHRoZSBmaWx0ZXIgd2lsbCBu
b3QgaW4gaC93IGJlY2F1c2Ugd2hlbiB0aGUgZHJpdmVyIHRyaWVzIHRvIG9mZmxvYWQgdGhlIGZp
bHRlciwNCkl0IHdpbGwgZm91bmQgdGhlIGFjdGlvbiBpcyBub3QgaW4gaC93IGFuZCByZXR1cm4g
ZmFpbGVkLCB0aGVuIHRoZSBmaWx0ZXIgd2lsbCBub3QgaW4gaC93LCBzbyB0aGUgZmlsdGVyIHdp
bGwgb25seQ0KSW4gc29mdHdhcmUuDQo+SXQgY291bGQgYmUgZGVzaWduIGludGVudCwgYnV0IGlu
IG15IG9waW5pb24gd2UgaGF2ZSBwcmlvcml0aWVzIHRvIHJlc29sdmUgc3VjaA0KPmFtYmlndWl0
aWVzIGluIHBvbGljaWVzLg0KPg0KPklmIHdlIHVzZSB0aGUgcnVsZSB3aGljaCBzYXlzIHRoZSBm
bGFncyBoYXZlIHRvIG1hdGNoIGV4YWN0bHkgdGhlbiB3ZSBjYW4NCj5zaW1wbGlmeSByZXNvbHZp
bmcgYW55IGFtYmlndWl0eSAtIHdoaWNoIHdpbGwgbWFrZSBpdCBpbGxlZ2FsLCBubz8NCldoZW4g
eW91IG1lbnRpb25lZCAiIG1hdGNoIGV4YWN0bHkgIiwgZG8geW91IG1lYW4gdGhlIGZsYWdzIG9m
IHRoZSBmaWx0ZXIgYW5kIHRoZSBhY3Rpb25zIHNob3VsZCBiZQ0KZXhhY3RseSBzYW1lPyANClBs
ZWFzZSBjb25zaWRlciB0aGUgY2FzZSB0aGF0IGZpbHRlciBoYXMgZmxhZyBhbmQgdGhlIGFjdGlv
biBkb2VzIG5vdCBoYXZlIGFueSBmbGFnLiBJIHRoaW5rIHdlIHNob3VsZCBhbGxvdyB0aGlzIGNh
c2UuDQpCZWNhdXNlIGl0IGlzIGxlZ2FsIGJlZm9yZSBvdXIgcGF0Y2gsIHdlIGRvIG5vdCBleHBl
Y3QgdG8gYnJlYWsgdGhpcyB1c2UgY2FzZSwgeWVzPw0KU28gbWF5YmUgdGhlICJtYXRjaCBleGFj
dGx5IiBqdXN0IGxpbWl0cyBhY3Rpb24gZmxhZ3MsIHdoZW4gYWN0aW9uIGhhcyBmbGFncyhza2lw
X3N3IG9yIHNraXBfaHcpLCB0aGUgZmlsdGVyIG11c3QgaGF2ZQ0KZXhhY3RseSB0aGUgc2FtZSBm
bGFncy4gDQpXRFlUPw0K
