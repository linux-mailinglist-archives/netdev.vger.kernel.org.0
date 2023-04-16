Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD37A6E37ED
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 14:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjDPMSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 08:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDPMSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 08:18:09 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFB544B6
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 05:18:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaWHql1r52QQE/SLIan4jlpcIhJKfaQaMhTQIIVgSDS6qrBnWH5S23a54RLCD7boFbM+WdWZ2fAEelLYy25UkbkGpz89Wpo0oF8ZStxXRIwcSC3mrtNTvpZGLu0bLdlwomWY57AAaYthpOr8FOezJ+dM0ymJf7T5klUMhnk/HnhnEVDkl7gFRPvY33F8/FvnKHdcu8CQNqBSNF77ZFTyJd7F6qwl9X6aAlB91wDfX5vL597zAH3zRd+IrzdA/4cM0SoPx5t+l+UMrgKLcGI3lrBgdk85X70h9Og5BZkHUuA8OWyum8KUXrzXuzdtMamyF6pHwAaC2oHgp3DWs3QNBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K7n9Bog4bNB5e1MQRol7E5KIyUdigXSvGgsZqDs3Okc=;
 b=Rhz2UfT8WmR/DBbW45KLRZ8lMZWRG/HzS38F5KnSinKojxkiMx7ypw5AhPJM5dGTy33+qs8zrM+5x42G6AiwzmLE8zPTwFDsWgKpvBGgO/0XXoLCjtlp5d06LK1HzUPFyyoHa2mnGD/cyiIGSPMmMRVpTMy7xtuZCNT+ffhxSOR32qCfE6ppowEErDIYW+nBrEBobJlP2qfbp74jHAMw3STz1rPHqJe5tkJ48HdWZZm34D35uVX471nbPNT8TZi8uX6J3mDQpsJcidzFP7eql9x2HSlzoWYpm4oGtsUaAEGO8QcQVr6cA4d86XO2/ZxQ7bPQgFauo8mMVJt0k6G9nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7n9Bog4bNB5e1MQRol7E5KIyUdigXSvGgsZqDs3Okc=;
 b=frshgo0njGJuCk2iWklgrkRi7gmkXbW292WS2/2p8/xSVIYFKo4SkUig66ACmHIDIx98TeGa8ws8Yo7US83aFNh0pyOdh32JlTF0HeFs7/kBK5KFj3AUbyrwBWeMft4jUTx4wM+1eY7gWVsbzEh0OSKM/KA3+eP4kFHFVTjotobERYFG0y1gXjdF2aIXJ5yrFOFd++5iC+iiRRKBCbq9WHHoHtLChkyvzuwAn/Dk1DhEDijMLYWAqRKtgijTh1RJnsWX2nzPMXifWRvoEXiYhNjt0HkkKJIMuu0Nu2ZE3fmEhRUX59SSz8gZNDjkjA0l0GZXp6Ez9lVw4Y0V6DZd4Q==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by DS0PR12MB7876.namprd12.prod.outlook.com (2603:10b6:8:148::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sun, 16 Apr
 2023 12:18:05 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5%6]) with mapi id 15.20.6277.049; Sun, 16 Apr 2023
 12:18:05 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: RE: [PATCH net-next v5 5/5] macsec: Don't rely solely on the dst MAC
 address to identify destination MACsec device
Thread-Topic: [PATCH net-next v5 5/5] macsec: Don't rely solely on the dst MAC
 address to identify destination MACsec device
Thread-Index: AQHZbfas1af6DPo1R0GdH5VM8khTN68q5+GAgAL2PCA=
Date:   Sun, 16 Apr 2023 12:18:05 +0000
Message-ID: <IA1PR12MB63533E6FD3BE343E78ED60B9AB9F9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230413105622.32697-1-ehakim@nvidia.com>
        <20230413105622.32697-6-ehakim@nvidia.com>
 <20230414080051.004e2a67@kernel.org>
In-Reply-To: <20230414080051.004e2a67@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|DS0PR12MB7876:EE_
x-ms-office365-filtering-correlation-id: 04f472bc-b02c-4132-65b4-08db3e74a1cd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i+zSx76spDz/FOROkh+eN+c2wrBy0FHOZY+OiEm8zcfKhCHhtMjuc4GkrBD6vm45HrUmirxn60K1+PalWeMEZdbqj6t7QumqVAet5LqqjuhZFKPSFntV17ZkYCkzEUzrTlQvugbs2MOMsFyNzvLXRxlCrLSVf08OB7rDQpDhK44nHh2pf6Jvh3j7/SajP8xtkZyA2pnQC6mFpj5tWhjN3pwQJYQCod/rSsY5uBGFWuBeuolGORZzIvpqvWZ1E3SxmpdC+/NBr5KjOes64ny1npdPx6NwILivtHp8GTVi9Fk9VgZ1KIeqmrqsPh1q+Y37r6ZDOaQuLvWZrptgoBFVLb8GlTUxYUYwFGw19cJruza45hHxcJcCtKJfo+3cUoUqcQh7++N1aW2jczAoOCYo4Gi+q2VX/SltzXh3QxNJvpAdsWpD3X+ig72eZMpYQ6YLINhd7QVwFaSQ8JMhyUqPU5hQP43rcN9sDA6f2ku58DuNp/1uEQ9QWmDWYTsw4HyzOIXBVhn53ZghXQCeEbPIn2neK9oqmA2UQ7ItxnhNrP01wvrSDFNkZZuGD12Z7df2vyoHqllAosJxInMtLv3spCavMuA5C/js3syJSAig8YqykA0wjhzwsUxtDCj5H+in
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199021)(5660300002)(71200400001)(7696005)(6916009)(66476007)(66556008)(2906002)(66946007)(4326008)(76116006)(64756008)(66446008)(86362001)(38070700005)(122000001)(38100700002)(41300700001)(33656002)(478600001)(8936002)(52536014)(8676002)(316002)(55016003)(54906003)(9686003)(53546011)(6506007)(26005)(186003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z29sbTlESThkVkMyL2xiTUtTMktWekhDVXphVEsyRjZaaXBaVWlTb1hzb2xh?=
 =?utf-8?B?YjF2bkJMVTlYV3Yvd2EvU3pDNHBjYmtTWGdFQ2RwekJLdnVoSnBGNFRvU21K?=
 =?utf-8?B?MFM5S2tKVk9vdmV1bUlvL1U2dUhCZHg5VnBjdVo0L1ErLy9XVmpHL3lFWTk1?=
 =?utf-8?B?RkNtcFpMRDRTK0M4bE5hUlJDUzBLbWpDaVVCRGY0S2FObW5HU0FSKzEyOUVQ?=
 =?utf-8?B?Snh3a2MrYi9nQmdFL2pmQi8vSWYveHo3WmE4WlNmZi9HZDdsSEhDVzJMVU8r?=
 =?utf-8?B?TmJTUFM4bmNDMjZ1cDNycHRObWhGc2pHMGFUNlE3MkdsaUlhbjJJWjY3WmpM?=
 =?utf-8?B?MExoRVVRZC92dkQxT1dZSCtkN1BoTkpCcThZbHFwa01hSkpiQmMvenVTcTBs?=
 =?utf-8?B?QjBNUFJRNWNiOC9PTWF6K1loN3NkWGhPWjJwUjRVR01yOVVzVU56TnFsZS9j?=
 =?utf-8?B?V1B3Q3VmdWRpc09zQU5aN2FsNkNmRkdYUzBDdXZ3UlAwVWxiUkVYd05wZGhx?=
 =?utf-8?B?eVFvNklScnV6ZXdyMk1vaFFSVVdlcElCSmVEZ3VHY2tFbkRUb0d0UEZDVDJv?=
 =?utf-8?B?RnEvQ2RYRzVXS3VGNFRIZ3hoWHFkdWxtWlozYWRLTXRmZzJqZHVsMW9iVUp2?=
 =?utf-8?B?WWZ3dWZ6cGlqc0xEL2hUc1dHVTNST1k3NEVSZnVaeVlaUXBjaUNUVVEyWnJ3?=
 =?utf-8?B?WWQydkJod3hTMzlFS05tWWV1cTdJaGszeEkwVGdxKzZCcThsdjNvSXg4UHUr?=
 =?utf-8?B?NFRid3ZqRWNLRkNIQkdCWFRJdlB0Y0pkd1BzcXRUTVh0VDd1MVQvZC9lWmFE?=
 =?utf-8?B?U1R2cGVGUjdHUnNLMXg3OVdJanh5Z0RMTml6UTh5ZEtjRVVyV3g0OGFxY0Jj?=
 =?utf-8?B?NnlSenR4d0ROc2Z5dzdPdDNBemErWjBjYWRlQUdMU0lLU0hZTVdjaWc5T0J5?=
 =?utf-8?B?RW1SanVIR05qUzBRYWtET0MzVXRrdWtjbzVxVm50Y2pab3MzSWxsaXZKSWk1?=
 =?utf-8?B?QlF1UDVadzZtTUg1NEkvc09iMGdEeFFUa1VkMTZrRzczRVlEdmw4Z1IvOWE2?=
 =?utf-8?B?QXJJMlNoWURWTHp3NDV1a2svajVya1VXenRJaGkyKzY1dGN0YWhLQnIrZDAw?=
 =?utf-8?B?S1R3NjlyR1duV0dydmNCTmFhbjN3SW5tVEhWMmJBT0tWbmE3VUgrU3l3L0NN?=
 =?utf-8?B?bStHYUgvcmZXc2VsMTdKTmw2WHY1aU10YXMwYjhaNUJwWnVIazZObDFMaGVT?=
 =?utf-8?B?Wi9vcE9ONnNIVkt5MUl6OVVxWEFhZjRMY2hTOW8rcXBVRFRlQ2VvcWVSZGF6?=
 =?utf-8?B?eDArL3NYQzVndndhSHcyQXFnU0RtWHFnd2lBaWhoak9kd0pjbjdaQ0RUWElE?=
 =?utf-8?B?Zitma1JXYWR3UGFKdFMrMy91U0wyelB3QUdzY0J2UjFlbng0d0c5amduRFU4?=
 =?utf-8?B?WjBReGNRWHY5WTFmQy8rQi9Jc2IxMmdKSUJtRDA1OFc2czE4bDFxNnJpb05x?=
 =?utf-8?B?WkVZQUNvRUVDa2pnOEx1Nkt2cTBpUW9RU0hSK1RkamJ5R2YzT09wU091QkZ2?=
 =?utf-8?B?NXZoVXZ5WGZ0OFZZZTZmejFsODdjdngvM1o0cUs1ODNiR0J6ZFVrWU12R2pz?=
 =?utf-8?B?R2RRczNTd3E5aEpsY3lzbEkrTllsblRIOVl1UTY0QnVDanVWRzBuMi9Ob2Q4?=
 =?utf-8?B?eHlTY3pldnhXWDB1TnRSSjhCYXR6K3R1YytJYzVUanl3NFdDOFFwcEUyY2VJ?=
 =?utf-8?B?dTI4c094cnptOTExakloOWxvSWhtdWdPWVFqcUVGUG5nb0h2bHF5T0pxaXAx?=
 =?utf-8?B?WnMwMFVvWUlaNUVNTi9CclNaTGdrSUZ3YTlkQ0dGWUhYSC9BcTdwNUV1NSts?=
 =?utf-8?B?V1dQU3d0RnNIWWQwa21vTWJqRHJBcW14Kzl2Nm5sRVllTGwvV0FZZTQxRDJa?=
 =?utf-8?B?ZjRqNXhmR2JwbjA1MmFWb24wQ1g0K2dDYmd3SkJidFVJWDFuR29yOWtaV3dY?=
 =?utf-8?B?a0ZmSHBwaCtGSUhmWVZpQk9aOTVxcmxjZTlwSEFjdTJWeGp1dDdwN1J1bjN4?=
 =?utf-8?B?K0hVaVBjOHUxSG9ZR21KdXNVMkxyUE1nNitXRk53YlJaSjlOWUJwd3cvUm4y?=
 =?utf-8?Q?2AfE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04f472bc-b02c-4132-65b4-08db3e74a1cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2023 12:18:05.4310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jfUpZKJxLJdADP1CirK1iY25wzZuBbZ+epB8rP+QHK+Jt8mI7oBPgsrMBcVWKEpjG5xoR+1UWHc43SjQ0GthpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7876
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogRnJpZGF5LCAxNCBBcHJpbCAyMDIzIDE4OjAxDQo+
IFRvOiBFbWVlbCBIYWtpbSA8ZWhha2ltQG52aWRpYS5jb20+DQo+IENjOiBkYXZlbUBkYXZlbWxv
ZnQubmV0OyBwYWJlbmlAcmVkaGF0LmNvbTsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsNCj4gc2RAcXVl
YXN5c25haWwubmV0OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsZW9uQGtlcm5lbC5vcmcNCj4g
U3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2NSA1LzVdIG1hY3NlYzogRG9uJ3QgcmVseSBz
b2xlbHkgb24gdGhlIGRzdCBNQUMNCj4gYWRkcmVzcyB0byBpZGVudGlmeSBkZXN0aW5hdGlvbiBN
QUNzZWMgZGV2aWNlDQo+IA0KPiBFeHRlcm5hbCBlbWFpbDogVXNlIGNhdXRpb24gb3BlbmluZyBs
aW5rcyBvciBhdHRhY2htZW50cw0KPiANCj4gDQo+IE9uIFRodSwgMTMgQXByIDIwMjMgMTM6NTY6
MjIgKzAzMDAgRW1lZWwgSGFraW0gd3JvdGU6DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIHN0
cnVjdCBtYWNzZWNfcnhfc2MgKnJ4X3NjID0gKG1kX2RzdCAmJiBtZF9kc3QtPnR5cGUgPT0NCj4g
TUVUQURBVEFfTUFDU0VDKSA/DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgZmluZF9yeF9zYygmbWFjc2VjLT5zZWN5LA0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbWRf
ZHN0LT51Lm1hY3NlY19pbmZvLnNjaSkgOiBOVUxMOw0KPiANCj4gSnVzdCBhIGNvZGluZyBuaXQs
IGluIGFkZGl0aW9uIHRvIFN1YmJhcmF5YSdzIHF1ZXN0aW9uOg0KPiB3aHkgdXNlIGEgdGVybmFy
eSBvcGVyYXRvciBpZiB0aGUgZW50aXJlIGV4cHJlc3Npb24gZW5kcyB1cCBiZWluZw0KPiAzIGxp
bmVzIG9mIGNvZGU/IDp8IEFuZCB3ZWxsIGFib3ZlIDgwIGNoYXIuDQoNCnJpZ2h0LCBtYXliZSB0
aGlzIGlzIGEgYmV0dGVyIGFwcHJvYWNoPw0KDQogc3RydWN0IG1hY3NlY19yeF9zYyAqcnhfc2Mg
PSBOVUxMOw0KDQppZiAobWRfZHN0ICYmIG1kX2RzdC0+dHlwZSA9PSBNRVRBREFUQV9NQUNTRUMp
IA0KICAgICAgICByeF9zYyAgPSBmaW5kX3J4X3NjKCZtYWNzZWMtPnNlY3ksIG1kX2RzdC0+dS5t
YWNzZWNfaW5mby5zY2kpOw0KDQp3aGF0IGRvIHlvdSB0aGluaz8NCg==
