Return-Path: <netdev+bounces-8948-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40D31726623
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:40:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DAD41C20EE7
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3250D16402;
	Wed,  7 Jun 2023 16:40:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F817C8F1
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:40:15 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640611FCD;
	Wed,  7 Jun 2023 09:40:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFB+Zu9gnXlQnlQSRWzTDqUnTWVtcjFt9N09nNBBfaB8jmAAWY26V1Jkvp6Ddm1eBqmgviJUWDgIj1L29Xn8/Truc6aszyN27Fp+VAZFXOr1uFxr5jTSjQCTu6WfPcZAhAHPjqdyUarUqFMBGHLxi34WqDk4KuS5g3BlC9eKPFCMzjIG0eWasBPsEYBtfQIYTsAIkfzN3r2keyv8F30twuLaY0pnf1n8D7xbexXs5y/DjML+Hl9tXBizKRv6dlGdIf5RvnsLJ6aCFQdDdb05oxUyeC8wW1izV6e7abahps4DPAZeezsvpABwxOqevvh8AtCZ+KqPTnjqIHqWn+ngVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7cegJvmY9qlI8qXBlqjNtrWjN7sCMrOqCiKGEXJLhHI=;
 b=Ys1XyoziNg5fSX82hVqvHs22GIUSp/dcHmh5SRYWho8DGbJW/DyalJmtxYb/xtuWO9NQpphs/GPU7rZs37YGLlc+H4h5NLgfpNKxvHR/ULVWjFbm8zVtr/jOnjkUPTHSkixb4+jMfXnVop4OtqIzDZoJBt0riLNjJciTUMMCSH6c2N+anUuc2Yy3TBCsu0nvFWQnFQ/Sodd8ENpMJ5sRnJKLXcnuHiJIHwhuKKzdYno1tjiW0REy0M7C/lktOjUl4AZ8dR4wwM/6uqcXVrw9MhQ1mcM2PbYyZG6RBxxiD3Wz8ltemwy5nFMjTdnHDaeiarQnwd9vgT+yxiIRGA1yXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cegJvmY9qlI8qXBlqjNtrWjN7sCMrOqCiKGEXJLhHI=;
 b=D4D+zm6gh5YExkn8dv34tAk8OqE+3BwuvP/nQJ/8xIVmyTfKOxUC1dV4+JN5y2SWGHPb3IY3Exd4PmwM2ajZEiXIfRFQIiiBw5CERM2PpoUTzo8vQShIJJUFbhQATujrVo+gHg4Vd/nwJPeeuy842EZQCebyRr4hUFHCUzCvLLrDLApHPAIYM5Z4qklw8RBgYqmefWgl13/OkOThcV+Lfjr1894DjKfMO3wsnz8363GKqj/r+Qtfgw+3xy++CNLNgMBrie9jhescqJbBiZ0uwsJLwb57szT8wJbFxsRxskhwJii0yEtWWu3R5tMr4cejutpBWM0EE9TchrS/6D/OLQ==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by BN9PR12MB5291.namprd12.prod.outlook.com (2603:10b6:408:104::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 16:40:09 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::66f:79:81a0:9765]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::66f:79:81a0:9765%4]) with mapi id 15.20.6477.016; Wed, 7 Jun 2023
 16:40:08 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "aleksander.lobakin@intel.com" <aleksander.lobakin@intel.com>,
	"saeed@kernel.org" <saeed@kernel.org>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, Tariq Toukan
	<tariqt@nvidia.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Leon
 Romanovsky <leonro@nvidia.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"edumazet@google.com" <edumazet@google.com>, Saeed Mahameed
	<saeedm@nvidia.com>, "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [net-next 09/15] net/mlx5e: RX, Log error when page_pool size is
 too large
Thread-Topic: [net-next 09/15] net/mlx5e: RX, Log error when page_pool size is
 too large
Thread-Index: AQHZmEZKdI6lzLiEjkOXZJcekXnqg69/iJCAgAAEUoA=
Date: Wed, 7 Jun 2023 16:40:08 +0000
Message-ID: <a2211eeaa8f25d9b2d1d2495e2e2d9de2f81178f.camel@nvidia.com>
References: <20230606071219.483255-1-saeed@kernel.org>
	 <20230606071219.483255-10-saeed@kernel.org>
	 <e7b3ebac-21ab-ad3b-7906-6eb4b81ec985@intel.com>
In-Reply-To: <e7b3ebac-21ab-ad3b-7906-6eb4b81ec985@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|BN9PR12MB5291:EE_
x-ms-office365-filtering-correlation-id: c8045f78-2433-4e27-a4ea-08db6775daee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 UTTBSqHYjrvlLfNFtxjbIDIn8+p6DKtfkinJ96Z5DbzLBpXasbYTOD6BgmJD9TNRVLsIx7gTJo87zQpPH2gaTzrKzeCfVN2t4ntwA49sb0s8XJ7giNIbuNlh9AL51gwPJUDJiB7rLcgUZTeGHr+FtOzS/NFN2I3+aAUA77HPD2wYlF9dQnIhwcZt6gDiGKihAb8bfVgOIGSo69WdCi8GElRhVp8EtJ8hDHM5KM8t+0kwaRgc19QerqmYapHyx7R2Aoq6SnNGhyiWehvZE1HV/v/krE96DEeWkw5LLgxgh+muoxOYoszCuqzIAZghryPIhr0Rp1Z+GDm30VPLiJnqmyYSFAtzk53O8G0Bwy4Gq43Egs4YvoWpZmng+4IKZsb6Ofoz0L+fzE5k/sNV4K6uexTNKZ/0/oF/lTK9rYlYchU1879dzaemzOXZGH2+92MInoqqrE8PS2nPn629GL+Ug60Jc9QTSTdJecxO/CkDVWgfdJQriMLy7vTCcTYHcpm/xnUhB/3ly2HTON4qMrjEx7VUOt4lM3OZdq3TCc5DsDGVQpSbA0AUQ/CNj7aTeE5fjNNkBTPNEBYh6fhkKUx8lTJmEkKDGhTQ5R6hJZIlldFRHH+PGT6j86My53U1sCDc
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(451199021)(86362001)(122000001)(83380400001)(54906003)(110136005)(4326008)(64756008)(91956017)(66476007)(38100700002)(66946007)(66556008)(76116006)(66446008)(6486002)(71200400001)(478600001)(2906002)(36756003)(186003)(4744005)(38070700005)(2616005)(5660300002)(8936002)(41300700001)(8676002)(316002)(6512007)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?L094bU4wYnN5VHkreHdLVXo4YW1zc3RsVVVIcHVicnkrMkF6OG9ub2I4QlZw?=
 =?utf-8?B?ZzhlQSt0bmtsZXVCZkt5NUcxZ05VRlcrZjRLYVV4eEc2d0NFdXVDNE85dlB1?=
 =?utf-8?B?dkVvQTF5WC8rdndOM0lqbFlWTUtLVW1SWVBKbzVrTmNLK1lQVS81L2UvdWdJ?=
 =?utf-8?B?Z0VCZjVhMEhLMjBJdFJvd3JmSkxncXJKTTdjYno4NkRPRldRc095UGpvOG94?=
 =?utf-8?B?MThnK2JScjNZTkdLd0RiZVlIZkwrOWhPaXE3T1pFZVZQZUhoL3lRTnVjRkl3?=
 =?utf-8?B?cGlmUkFqYTdFZXhsaHZoRzd0ZnhUc2YxbitWVDFpQXFTYWZQOHM3MmMzWEFr?=
 =?utf-8?B?ZG9jYUhjZFdFak1QWHBTTGNHTXQvT24vd2xEdkhzTW03V2c5bzlxam03NmZP?=
 =?utf-8?B?a2toUlpXUmpoZGdiak5idG5rcVJpM0RVSUdWc1RRck9zbldkTDhobUVNWnZZ?=
 =?utf-8?B?VmkwZ2RtcmcxZVI5TUJyOEhVSExFTUR0VzU1ZnF0eGMzcjRnMFlSeHZmVXVm?=
 =?utf-8?B?QWZQWk14Wkh2TGlmL1Zwem83RVVvTFJGR1JIT2RnQSs4QkkyNFp0dnRoaVhw?=
 =?utf-8?B?T0xEb0VUcS9YT0R6b24zUy9ROC9UOWttaHBxY3RvRmlwYjhrTGkyYzQxWnlB?=
 =?utf-8?B?QjZZR2xldlRidFFCZC9mWU92VWNrS3lHYjdWYS9yMmZSVkhVRTBDQVZXMDlh?=
 =?utf-8?B?YkFSdEMyVlMrN1ZtVnZRQTJmS25jWkpxTitsayt0YmQxay9PYUFsbzVySmpx?=
 =?utf-8?B?ZzZWOTYzWWpVZXZuMStZam4zcTloRXZ4ZkREaVNxNUVWZGdMTVZteVd3V3pT?=
 =?utf-8?B?eXN4QmZnVXlqam84SWxNaVhZVGNrckNWTW16Zm4zZXFCNE0vZCs1TU1YQk9O?=
 =?utf-8?B?dXdxNmhDSTdrS3RmVHFZL3gzbitmUEtTb0E2SkNKc1kvQlRmZXFucjYvay9z?=
 =?utf-8?B?akFqQklROWNsamJ0Ympxd1NhS3VyRUxaWUd4VHBwZEpTVkIzb3lLcFZMUDlN?=
 =?utf-8?B?ZFFHWFJwQ2pjcjMxcXNZN3FySEtpWDBzVVNlWjFFSjNDdnZ4N3JqczZEdkoy?=
 =?utf-8?B?V3VkandFdnpkZ3g4ZkRjWEVxeE1Bc2tqYkJYL3FFMVN2K2tndmV6YjRQM3Nh?=
 =?utf-8?B?WnNmd3RLeldkUnk4MGFWeHVjSG1hTGVEcXEySlpvU3FtdDZld0MrNHVLOHM5?=
 =?utf-8?B?TnJkN2JJZE13V1BBeGlHL01zNEs3MmF1RkNTM1dFN050dHZzZk5iRGFxMVhn?=
 =?utf-8?B?S01NZjJVZUNESkVaWk9wbHp6b1N3SlVKYzRqVTlNU0J3RGI1VXB0S3dhRmN4?=
 =?utf-8?B?d3RGN0s5UURMYlpWYWZYQW9PVEtzY1ZFdHkxbWpmYUdhbWNmRW9XeVhJZDIz?=
 =?utf-8?B?dUxJU1lZbWhBc2MyWmxRSEpsL0c3Vzh2ODBLTUhHUWdaR3lXNWlYaERWN2tI?=
 =?utf-8?B?bU40VUdIZnhWSUwvM1Rneng0d1ZsZkpEd2JvaGZxY2N0Z2VZSU5XTDZjVWpX?=
 =?utf-8?B?MmMrN3I2dFprMm9NMG9USys4alV5WnF5RGJsazErUjE5akE5RU5iblZkVjJV?=
 =?utf-8?B?Ri9oOXZaMmlDcjRWcEFRd3RodWVPemNSTFdweGFFRXNGTWN0SlduS1BFcHVY?=
 =?utf-8?B?LzRnUkF5aDRGZmVTMmdlS1BWY2NuL2Vack0zS2ZlN1JIejdhMWk1aXVoN0Jy?=
 =?utf-8?B?NUVZdm1ZK0NISDVTb0g0RWhocDhpc1FuMHFDWXIvWGJZYjU5YnFCNnp5WGpY?=
 =?utf-8?B?RXloMkZYcXVPZVNpNGFxdUMzM0Z6R2s1MUd0UC94OFR1NFltZGlORTZ0Sy9S?=
 =?utf-8?B?UlBlRWF0YmRTTy9KL0dUWWVpd1BLb1BSM1IrSHJxQlM4MzZKMC9PUEUxd0x3?=
 =?utf-8?B?YklMMVZpaHZiMVl1dFRla0FHazVaKzN3WXpQWkNQQ0xyZ1l6SHhUMzFIMmRE?=
 =?utf-8?B?U2JLVmRwbXA2NlFZaHVNMW9Ud0ZBV0l5cm9nQXpPRTIwN2xKSEVNeUx2OXIr?=
 =?utf-8?B?YjJ3T24xdFBRRHJXb1hmOFE1R21mSFpLeXBjLzNrNi9QUFN6RnQ4Q25MaGls?=
 =?utf-8?B?cnl6NkVzdEI3d2xEaTlTa0YvWW5IenFUaHc3MWRjemtSQWtWOVFqeTdOZnhH?=
 =?utf-8?B?Um5KWGk5bDYyaVM5ZHUxMEY4WkVvK2lMUFc0L0xia2FQa1FiS1o2RzJ1c1pk?=
 =?utf-8?Q?y59neqxh7kXf6nCHN4o34tn+u+km3fRrI6ELZjpDnQrf?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7CA195BE804DC542BF4BC3055EEFA7AC@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5565.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8045f78-2433-4e27-a4ea-08db6775daee
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 16:40:08.4726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3QPLt3vptNi2uJdI2B/RkCcFQfTtVCjr8UJkfwV2zRIOl1LYEYnHLgb3iUWkFbsfZWGL4Zvbld1CAGd5LK3/wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5291
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gV2VkLCAyMDIzLTA2LTA3IGF0IDE4OjI0ICswMjAwLCBBbGV4YW5kZXIgTG9iYWtpbiB3cm90
ZToNCj4gRnJvbTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkQGtlcm5lbC5vcmc+DQo+IERhdGU6IFR1
ZSzCoCA2IEp1biAyMDIzIDAwOjEyOjEzIC0wNzAwDQo+IA0KPiA+IEZyb206IERyYWdvcyBUYXR1
bGVhIDxkdGF0dWxlYUBudmlkaWEuY29tPg0KPiA+IA0KPiA+IFRoZSBwYWdlX3Bvb2wgZXJyb3Ig
bWVzc2FnZSBpcyBhIGJpdCBjcnlwdGljIHdoZW4gdGhlDQo+ID4gcmVxdWVzdGVkIHNpemUgaXMg
dG9vIGxhcmdlLiBBZGQgYSBtZXNzYWdlIG9uIHRoZSBkcml2ZXINCj4gPiBzaWRlIHRvIGRpc3Bs
YXkgaG93IG1hbnkgcGFnZXMgd2VyZSBhY3R1YWxseSByZXF1ZXN0ZWQuDQo+IA0KPiBXaHkgbm90
IHJhdGhlciBleHBhbmQgUGFnZSBQb29sJ3MgImdhdmUgdXAgd2l0aCBlcnJvciIgaW50byBkZXRh
aWxlZA0KPiBlcnJvciBtZXNzYWdlcz8gSSB0aG91Z2h0IHdlIHVzdWFsbHkgZ28gdGhlIG90aGVy
IHdheSBhcm91bmQgaW4gdGhlDQo+IHVwc3RyZWFtIGFuZCBtYWtlIHN0dWZmIGFzIGdlbmVyaWMg
YXMgcG9zc2libGUgOkQNCj4gV2l0aCB0aGlzIHBhdGNoLCB5b3UnbGwgaGF2ZSAyIGVycm9yIG1l
c3NhZ2VzIGF0IHRoZSBzYW1lIHRpbWU6IFBhZ2UNCj4gUG9vbCdzIG9uZSBhbmQgdGhlbiB5b3Vy
cy4NCj4gDQpUaGF0IG1ha2VzIHNlbnNlLiBUaGVuIHlvdSBjYW4gYWxzbyBwcmludCBvdXQgdGhl
IHZhbHVlczogcmVxdWVzdGVkIHZzIHRoZQ0KY29uc3RhbnQgbWF4IHdoaWNoIGlzIG5vdCAoeWV0
KSBleHBvc2VkLiBJIGNhbiBwcmVwYXJlIGEgbmV3IHZlcnNpb24gb2YgdGhlDQpwYXRjaC4NCg0K
PiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IERyYWdvcyBUYXR1bGVhIDxkdGF0dWxlYUBudmlkaWEu
Y29tPg0KPiA+IFJldmlld2VkLWJ5OiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBudmlkaWEuY29tPg0K
PiA+IFNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbnZpZGlhLmNvbT4NCj4g
Wy4uLl0NCj4gDQo+IFRoYW5rcywNCj4gT2xlaw0KDQpUaGFua3MsDQpEcmFnb3MNCg==

