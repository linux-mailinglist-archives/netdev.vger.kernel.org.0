Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78FD534F65
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 14:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346642AbiEZMkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 08:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346286AbiEZMjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 08:39:52 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FEC2F03F;
        Thu, 26 May 2022 05:39:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvhPoF+BuxIDwfHJvhqJ1I856Ba8s7DG2J3wc0vzUY228HIlDdCqzPma7dZrWpNaGAZSrpkjXYqUSYlIEOjsO6kYmdT9p+AjEjMksaDYfmghKcMt1WlWgBeE9EGGLFEOe7Lu/Mx9CdlMYgBBVbPd3xGK7+EZ/OCh+C5C34XNMg9XOfECzhhPBI5hDCiJDuu4WZc2S5HVMJ6F+0fP2U/YljR9Yj5mPLxjieiqtfsIEe9UKaZIWONhlIDYZ6Xex5JY0u7SwI5G1m95SmX2PpmoOSIO2O/Djc+pEv6yVlIUZb5+4JRyoryVHIc3i3w09GQk0DQD+cSnAASiRyI0ykCk6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OTJIGl25/msHuQCC2EFXN0flV8IJUiPz9cCJAxtz4J4=;
 b=LlNnFMzCAMkrbzMxTqudsA0xL/ATMxLm51SFH5RE1GLfZB4SnWtHVvvkMMOUpI77fpSZB7pAnYMvMFw1Ww4Z3PssnM8T2a3FUfMk4Cwb6d68zM+7gw1N0XBWy41vQ0p9dZYYJEbj4/nt76/iBdRBNtQ2/ZuxVY6NkjR60PW4MKaKdu+JJX6Sjac8Kqfowsu5SxVyDcDpb9CU0kmuGTI600jKB5v+OdXfgpJ/zCmwDuAHQP5VdSGCzi9mwN6Juej7LvanOr4oSkC8GDAdbQco8EjY6BuWfEbeOSSYmGc7IkELhl34rB0aDpN9cNTI9j8ZfHhm+OBlekSWoU0/9l4F6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTJIGl25/msHuQCC2EFXN0flV8IJUiPz9cCJAxtz4J4=;
 b=XdyhUma0dfcd/xZAkzXh0xK6C9kll/x179xDWBRcUxDtbmkTxFb8I0aA1ZkjtpFx2ixmKeC66cDolGlI0ywfcefU/4CcOw9VjnU93+mink+Uqg0SJ3ifZ8582AdWjawhheZuAiHnrAzbwLzv1rRNr6go1eoct0T0zEz9BPj7PGJORbsOdiYgILKJvFWWMjiXYFn9qPidNhJDd+cnepSapneNmdLYdc8lNJuvnaWCIkVARjZfLXOp7TrwYNtMzqXEEvMOXQ8E0TplTqYwRkb6f2MQJJZaxA0BbbP+1xGFT5RWQtp0ixyWppRQC4Lhw+zNVAdqATh1sLbh86Hk+nzgmQ==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by MN2PR12MB3102.namprd12.prod.outlook.com (2603:10b6:208:c6::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Thu, 26 May
 2022 12:39:49 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::489d:7d33:3194:b854]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::489d:7d33:3194:b854%3]) with mapi id 15.20.5293.013; Thu, 26 May 2022
 12:39:49 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        Jianglei Nie <niejianglei2021@163.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Vu Pham <vuhuong@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net/mlx5: Fix memory leak in mlx5_sf_dev_add()
Thread-Topic: [PATCH] net/mlx5: Fix memory leak in mlx5_sf_dev_add()
Thread-Index: AQHYcNzfgM6UB9evF0y2uRowA5oHFK0xAcQAgAAXDXA=
Date:   Thu, 26 May 2022 12:39:49 +0000
Message-ID: <PH0PR12MB548184F122D980C9AFD72C68DCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220526084411.480472-1-niejianglei2021@163.com>
 <5a7cb5c7c0bf2f9f9540616a2a0e70d36a166a9f.camel@redhat.com>
In-Reply-To: <5a7cb5c7c0bf2f9f9540616a2a0e70d36a166a9f.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e36e542-3560-4d23-5231-08da3f14d2bf
x-ms-traffictypediagnostic: MN2PR12MB3102:EE_
x-microsoft-antispam-prvs: <MN2PR12MB3102A2013219EA7EB2579CEADCD99@MN2PR12MB3102.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mc6lJ7c2zXXo2q2DiOtT9vnr/mrIeBSyqEaAv23FCFRs3ThlKdTj6OHYgPCU5cxpdIybbfEx8RzkgJX4q1JkTbL/JtdJAmwhOVteM5W8dI989GtynYGXmtK+N+ElBn2J98W0oHzGn+BmTS0KGXmVeaRy9Qq+KESnaXZNqSdFDXymslBJjBFyZt0U2uZNhLQXqakw/HgRqAkAo15CEiN7IOQGBfwqOzyl8fKPCIPDIGSuslZOGAkzTR4OEbMgnduKk5Qz+E6MEUmkK15WshqY+IbpQ2G1o59U6nepDUro+nfKIHs0wK2sUNRy1PzqpRBFhK8el7KIke7OllptrAYs/T/1X5WnFp+ZdG2lNoDIjmZsgfj6Cem2sY/nP+7Dy3pNEGk42cPPMnK9dQq8FvkCU+uGCnlBoVgWWhHanfQXChpRvkDmOXIayoKCae6HAxaDuS1wHGvveVywgSI3H/OHY/lvrq5/xq/k/S+A0dDcxHEvnip6hJrOyOe5VWtGl/Qe0lvYXZvMsiEmRbZJHn9YDavbpVYxH2SMRcquxf15z54d/l8abYU5ZuDekplA9tQzvgsVrbvBaELn31X3m0RDPQLx0MS+76IaYdWxBMi188xRHx/S1L7x9JeWpFOxpwiOq2aALqTvMrykEyWE80R733WIQgAmU0lGBHKX1i9n6KG6kD0k4fSvtE+cWIyMigS2EqWzvg27FSW72hvfRqK/pA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(83380400001)(122000001)(38070700005)(55016003)(38100700002)(6506007)(7696005)(66476007)(54906003)(66446008)(64756008)(4326008)(76116006)(66946007)(2906002)(71200400001)(6636002)(316002)(508600001)(8936002)(8676002)(9686003)(66556008)(5660300002)(52536014)(86362001)(33656002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cm02NDE1a2srMk1VY0dXMGRGNHBpUk00RC9wVnM0ZmR2RzFRZGljbkFZVG5X?=
 =?utf-8?B?SjlqcnNPRkJUZWFHUmlRb1Urb2U0Q2t4SVZWWXZFMzNWYlJaaCsvZ0o1elk1?=
 =?utf-8?B?S3hvQzlLMzRTYyswa25RSS9HcGFwQ3o3MkhZWG1MM1VWZUtacnRsUGFDb0FT?=
 =?utf-8?B?ZGlIOEtRTWd1ZXl1TEF3VDN2L28vcmViZ3JNZndMNkRZZkhZajJQSjFtcW5L?=
 =?utf-8?B?WmpYbmo3SERMSWZaaCtjL3Z6U2tDRm1PK3U4MUxleklqUE02YWRaa0dHRDlv?=
 =?utf-8?B?Yi84dnFBd2FCQWQyVVhqaVBMVVZNcitzcmpkc0QyYTFpZ2ZhMEdSL3JKck9B?=
 =?utf-8?B?M3VvdHdGb213RkRoYmRGQmJWbG9UdjJBSEJwR09ZWmd4ejZIbk03WGlTa3cv?=
 =?utf-8?B?T1JuUzBBdDRrUTVKb21XWnRXTjM5TDVBV0tGQ1pYeEJQVUtrR1NLU3FTdlM0?=
 =?utf-8?B?NDlPQWIzWWdDWjV4L1V2MFN5L29HQ3NPc1ZCbUw3WUdjTk96TnNOTklyWS9Z?=
 =?utf-8?B?MVZwcmxNZWhrT3Uza3R1eEV3Q0pIdW14K0tsZ040U2ZrRGpKMHVraVBjc0Yv?=
 =?utf-8?B?VE9LOEs3NmZSRzdWTWlyS2pjOThVanZhM05zM29pRUdhRThncWlQZ1VVZVQ4?=
 =?utf-8?B?alpRVmtYNTJQc2VoRDlEb0lrdllvOEdHMmUrbnpmY29ISlpaUEtVdVVLS3VN?=
 =?utf-8?B?Sys2NFN2L0xPZHd4K2RBeWVpcDJlbGV4d29YYWV6S2V1KzU2eUxwSEhQRHRu?=
 =?utf-8?B?ZzFZb0tWOU4vejN3UURFNjNoTklseFBpaDFQeHpWS0xBQUxjOHlvbWVieFpB?=
 =?utf-8?B?NzA1aU43MDYyR2kwRWxPY2NPZlVuc1lBNWNCaHBzSEFYY2M3NTBLcUY5TmE4?=
 =?utf-8?B?Qlp3YnozemxsanA4NzFBK2NJNEFRaUNZZENiWjN0SUhIdjZ3ZUFuQUxITnNV?=
 =?utf-8?B?YmlCY2F6WG43ZElDdnMvMjRZRmd1ZzNiU2I3TkJMbWFJcnh2cnk1RzFJRmQ4?=
 =?utf-8?B?T0wybklscWthcjdHWUlPL3hDekY1S2tkc1JmV1Z3djRQUW5zVVlUR1NDWndL?=
 =?utf-8?B?YzQ1NWJFd3FsVzYyODlCZU5sM1grYUFIY0ppekVIb3E2SXpBeHh4aWhiVTFW?=
 =?utf-8?B?R2pwVUFuTFF0SklRN3p2Vkh5NDdJR2RkRlpRWHVhd0lCYnRKVHRaWnRSV2NP?=
 =?utf-8?B?WWVrTWZlQW5EQTJqU05MREZzUGRTdTZpQUo3NjZabW1LK2pMR2pIM05EYUZw?=
 =?utf-8?B?cytZajU2WkdDSFk2bTM3NnhwWkF4MWt1VVE5eDlKVmNmSHpqSWx5R0lvQm9z?=
 =?utf-8?B?MzAyUk1ZejlvUVFXWXNLekVZd3ZXZTEwK0ovRm9HZWc4SmhmSE5lRk53ckVB?=
 =?utf-8?B?NFpDL3lGdlJDUnRGM0NWSzlnTzNkbkswOGdSWkwxVDA5OVdFc0ttNmQxOWFz?=
 =?utf-8?B?K3ZFbWhPM1BVVjNvc1l5ckdaM3ZhYURIOVZSY1BNdkt4MFRtUGtYWmFGRWNN?=
 =?utf-8?B?TWtwNlNnc3I0MVgvUXlVL3B0Q2RINmxqNlovaEtsaWhHc2swaUwvZ1JJdDZT?=
 =?utf-8?B?ZzY1OFNRU2VwLy9iS0o1R2lCTjRCb3BBMEtTb2tJRkJ1YUFBZUZxS3hTL3ky?=
 =?utf-8?B?SEhNYnpwQVVPMFNxcFJTaHdLaEhQOGt3U0QreVRzT01UZFFYZzFXb1UvQzNF?=
 =?utf-8?B?eDY5SWozelVsbHJwR3ZVeEU3blVGdGIxWWVNUDQ1ZXpsdmVxUUdOK0cyR0hB?=
 =?utf-8?B?aXZ1Sm5TUTVJWVFjYzBGcjlwRXpoWENVRVgxYU9UUWVDSEdBWUQybTBQVjAv?=
 =?utf-8?B?YmZJRnN5d2lMRHVRMlVpcmNvOUZvTjNLcTJoNVhGdDNNQlZ3VGhPNXBWVjlo?=
 =?utf-8?B?ZHJ4K1MrSmxiVlEvUEx2dGVjdHhObGI1WEVPVGdxYURlVnlEUm4xSzJEUlUr?=
 =?utf-8?B?L3k1R0lERmdGVW1lSjRGMHVCQldHcjNuYnFzQVFYNFNrVE5CT09PN1NzMjBy?=
 =?utf-8?B?akhZWFg0K2xBYnRqSnhtd2MvLzh5WXVGcEc4YWl4WlZ5dUlINW1wTHdyZjF2?=
 =?utf-8?B?WTcrUXhmazEvcCtQaW5LbE1HVUJVQmRJaXgvMk9CYmc2U1UzbE5VRWpERlN6?=
 =?utf-8?B?N3JqZlhCdTFIOGtDYzhPaWtMSUpTQmh3Q3Y5RklHTnRRZU14NVNNbWdxWkZu?=
 =?utf-8?B?NFpScjhUMjQ5VmttUFAvNXM4dXl1Z1hUWm1LeE04ZG96WkREUXE4cXVKS2po?=
 =?utf-8?B?Q002UGNjR3lSN0poQVJYbUxDOTgyVnJtRy84dFNVWk1RTjlBL0Y2YnVZckxC?=
 =?utf-8?B?ZjVjRXJCTXJ0RTV5U3FCYXd3UWJZVytYYStSdXNqVHBCbS83YjNIUW12ZzNx?=
 =?utf-8?Q?qsokfaebTUieWzLQcPLH+h2PDXVWBbH/CORIYSW2bK7um?=
x-ms-exchange-antispam-messagedata-1: UHdSaPKueT4GLQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e36e542-3560-4d23-5231-08da3f14d2bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2022 12:39:49.2277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aALzdLJuln4k6ag6u9ehAQcLE654H2hH/f+oMmrtIiLIcmU9/1cmKHwZ5cNGiOD117fHEi4UDuaXvVp0r5u8rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3102
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPg0KPiBTZW50OiBUaHVy
c2RheSwgTWF5IDI2LCAyMDIyIDc6MTQgQU0NCj4gDQo+IE9uIFRodSwgMjAyMi0wNS0yNiBhdCAx
Njo0NCArMDgwMCwgSmlhbmdsZWkgTmllIHdyb3RlOg0KPiA+IFRoZSB2YXJpYWJsZSBpZCBpcyBh
bGxvY2F0ZWQgYnkgbWx4NV9hZGV2X2lkeF9hbGxvYygpLiBXaGVuIHNvbWUgZXJyb3INCj4gPiBo
YXBwZW5zLCB0aGUgaWQgc2hvdWxkIGJlIGZyZWVkIGJ5IG1seDVfYWRldl9pZHhfZnJlZSgpLkJ1
dCB3aGVuDQo+ID4gYXV4aWxpYXJ5X2RldmljZV9hZGQoKSBhbmQgeGFfaW5zZXJ0KCkgZmFpbCwg
dGhlIGlkIGlzIG5vdCBmcmVlZCx3aGljaA0KPiA+IHdpbGwgbGVhZCB0byBhIHBvdGVudGlhbCBt
ZW1vcnkgbGVhay4NCj4gPg0KPiA+IFdlIGNhbiBmaXggaXQgYnkgY2FsbGluZyBtbHg1X3NmX2Rl
dl9hZGQoKSB3aGVuIGF1eGlsaWFyeV9kZXZpY2VfYWRkKCkNCj4gPiBhbmQgeGFfaW5zZXJ0KCkg
ZmFpbC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEppYW5nbGVpIE5pZSA8bmllamlhbmdsZWky
MDIxQDE2My5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9zZi9kZXYvZGV2LmMgfCA1ICsrKystDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA0
IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvc2YvZGV2L2Rldi5jDQo+ID4gYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvc2YvZGV2L2Rldi5jDQo+ID4g
aW5kZXggN2RhMDEyZmYwZDQxLi45ZjIyMjA2MWExYzAgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL3NmL2Rldi9kZXYuYw0KPiA+ICsrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9zZi9kZXYvZGV2LmMNCj4g
PiBAQCAtMTI1LDEzICsxMjUsMTYgQEAgc3RhdGljIHZvaWQgbWx4NV9zZl9kZXZfYWRkKHN0cnVj
dA0KPiBtbHg1X2NvcmVfZGV2DQo+ID4gKmRldiwgdTE2IHNmX2luZGV4LCB1MTYgZm5faWQsDQo+
ID4NCj4gPiAgCWVyciA9IGF1eGlsaWFyeV9kZXZpY2VfYWRkKCZzZl9kZXYtPmFkZXYpOw0KPiA+
ICAJaWYgKGVycikgew0KPiA+ICsJCW1seDVfYWRldl9pZHhfZnJlZShpZCk7DQo+ID4gIAkJcHV0
X2RldmljZSgmc2ZfZGV2LT5hZGV2LmRldik7DQo+IA0KPiBUaGlzIGxvb2tzIG5vdCBjb3JyZWN0
LiBwdXRfZGV2aWNlKCkgLT4gbWx4NV9zZl9kZXZfcmVsZWFzZSgpIC0+IHNob3VsZA0KPiBhbHJl
YWR5IHRha2UgY2FyZSBvZiB0aGF0Lg0KPiANClJpZ2h0LiBBcyBQYW9sbyBleHBsYWluZWQsIGN1
cnJlbnQgY29kZSBkb2VzbuKAmXQgaGF2ZSB0aGUgY2l0ZWQgYnVnLg0KDQo+ID4gIAkJZ290byBh
ZGRfZXJyOw0KPiA+ICAJfQ0KPiA+DQo+ID4gIAllcnIgPSB4YV9pbnNlcnQoJnRhYmxlLT5kZXZp
Y2VzLCBzZl9pbmRleCwgc2ZfZGV2LCBHRlBfS0VSTkVMKTsNCj4gPiAtCWlmIChlcnIpDQo+ID4g
KwlpZiAoZXJyKSB7DQo+ID4gKwkJbWx4NV9hZGV2X2lkeF9mcmVlKGlkKTsNCj4gPiAgCQlnb3Rv
IHhhX2VycjsNCj4gPiArCX0NCj4gPiAgCXJldHVybjsNCj4gPg0KPiA+ICB4YV9lcnI6DQo=
