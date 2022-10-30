Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52573612A72
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 12:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiJ3Lyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 07:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3Lyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 07:54:32 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2052.outbound.protection.outlook.com [40.107.95.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF38BF63
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 04:54:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bu7B1Qyt4nWB5ZGQgLPAiutgVZ2cwCLib1WxCd/XIItkvlYXDc4sDVodGrZH3MlLVOO4u7bo5pRiSPpwXIKPB246JATdBojQ83wFFULZOoABJuNcAnwXXdMrQ3kXIVQX+9ZKqIs1d3vqSve+t3fIWbGmLogARkuBt8eLyOmejrkgfBINXRxjodT4rzt/MW7EN7wOXtFluBngsinjzloRpHyFh9dgoO+jVcOVo+nOwO0akC/A/Mfd8wbgogLGrvC4SdDtEH61I84m3v1D29TiJS9knyJWatIpRJyTzJ0QZ3ETUs16FSw35QmAt9v4uNCcsuFqtSoR/1LMdh8ak/0Opg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hgFPLRXU9M70J1AE1qeTBda+8Zj0rRkaLSos2PFO0QI=;
 b=OKEfOcMqFu5dwHBL8PYollqhC4qnwWwsM4aM2V8Klo1P0XLngqKl9h3wv8AEQMEy/XNe/5Jr5366bHa1NhBEsTWbIdFOssQ1DRSn1esZHQVbJ0vGBaCJcgrRBrj/l+4Lff3bTudAJo693yzNOxIcu2h13O9GGNrbxGmk+xPt0GuDfZEVlI6Hht1xSuGwUy0BYDA7j6yaaKP/pPmvqmBTgw0uPNa4Iy1aKNyQLcFkm1vjIeQTgSWd8XcaGeLwzpTnA+bAcZ3T5yMdEREwm+jTzUqsYqwlD4VKM9jGtOxMlY175VFvduAXqOJHm8vB/nI1RB79bY8XQsOkbYegXQMaIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hgFPLRXU9M70J1AE1qeTBda+8Zj0rRkaLSos2PFO0QI=;
 b=nUyUxoMgIAJNLTczbwHIVh7Idm0yddWjrYHpW/lFuVLpwznByd6CiDiQGOwEfjak0YanXsYge3ye8kz44/quD19hmyO+aUI1lC/ymQfXsXu/cesUkIzliAcAa6Co9dfBDxt8ZoKPsSxTZCCxIQZRR7tX7WHtgMCNh/HPF0Kl3+64hJrJU/EBA/OMwMLyIoUD6d5AF5voQHauuhoinxgnPKv1UrqVfQVyNhjW1dvDYGw4Pp/NJ8TKhHj1AEJ0pD59Ith4tfpRo1LcWnjcKHjF6N0wNXJb2CRq69Z0Zxs5EF761j7TKcbaiKIdX30N+wdmW2HH6fLKqNp2iPQrHRciEA==
Received: from DM4PR12MB5357.namprd12.prod.outlook.com (2603:10b6:5:39b::24)
 by MN2PR12MB4342.namprd12.prod.outlook.com (2603:10b6:208:264::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Sun, 30 Oct
 2022 11:54:29 +0000
Received: from DM4PR12MB5357.namprd12.prod.outlook.com
 ([fe80::62:69e2:aa46:bd27]) by DM4PR12MB5357.namprd12.prod.outlook.com
 ([fe80::62:69e2:aa46:bd27%6]) with mapi id 15.20.5769.018; Sun, 30 Oct 2022
 11:54:29 +0000
From:   Raed Salem <raeds@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: RE: [PATCH net v2 1/5] Revert "net: macsec: report real_dev features
 when HW offloading is enabled"
Thread-Topic: [PATCH net v2 1/5] Revert "net: macsec: report real_dev features
 when HW offloading is enabled"
Thread-Index: AQHY6YXtLFHhb+jWK0G17LhWcxI2yq4mm9GAgAA8bKA=
Date:   Sun, 30 Oct 2022 11:54:29 +0000
Message-ID: <DM4PR12MB53577F725385E1E025E46545C9349@DM4PR12MB5357.namprd12.prod.outlook.com>
References: <cover.1666793468.git.sd@queasysnail.net>
 <38fa0a328351ba9283ecda2ba126d1147379416c.1666793468.git.sd@queasysnail.net>
 <Y14yD7i53usq1ge8@unreal>
In-Reply-To: <Y14yD7i53usq1ge8@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR12MB5357:EE_|MN2PR12MB4342:EE_
x-ms-office365-filtering-correlation-id: ce5d3f66-e21a-4dc8-59b6-08daba6d8039
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W44O3Y6yjrNE8g+sAhaVooxqKxlWzuv5CkzpqWMZzjYUKzUbvnKnsRLu4xpfqXY/sDp/oPFJUH51ajZKNy3SevGNhPjAIQTRQPv1/lXJzTl4UoprdeolKBinVT/RcwfuLmPVA6QprLoU3h3lmRo0vU8lSl8h6bQvOC9BKTCDnbhrsuAJX/LBiASWWmCn6lNqWp4ZFvKdQIEPLngzleDjXvcu6SfmK2bpzAL+z9r1Eq3P5D4QbEJEoK5hJWCkeqkPmbGljRf3mryGyQ7fhn1/1P4Q1Z9ig0lG4jh6ieR0HNjGKFBqPBZIcQA6yGKK5+tQjI3iBK36A2DvJTra92krNF+Yw9kTo6RsU/nN5eNKb2KUt1Tv0E7TT2w2/JiQ+jyozB8JT7Nu/60wrcg7EpTNUvbk+oVkh+L2v7qzszq9WF2RzCNVsRFvmGidkJnkE8KdDwt6baBrZXaSldLo5+CMSFn3CYvvGgRYQoD5udMnHvKU+CWnnjvS3BQi6KDEFdbq+6tp55mc58D8BZT3JJCye/sOI6rLtgSpQWsN4otoKUPPM2MUXLEoifGY0odNG26kR2AmLg877aihN84dxa9LmTCzpOFu9NPdrWpyFm2VvJo2ymD8nbEYh9bWEreutlVcRlRhmQFSHzT2abI7WfdepyuF60TbdOptzOd4CgZ9S2D5yn7gfCv1YETSzpU1BccJCWm67bgnJEd0Whi3pFrXMJ68nSS+RSzThyyfDQ4gcLAUy0b54YFm+2xhAx0S/EjmKeDDF2va4vn0m3w/0MbSYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5357.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(76116006)(38100700002)(66476007)(71200400001)(66556008)(8676002)(66946007)(41300700001)(8936002)(122000001)(66446008)(33656002)(186003)(38070700005)(316002)(4326008)(86362001)(64756008)(2906002)(5660300002)(54906003)(52536014)(83380400001)(110136005)(55016003)(478600001)(9686003)(26005)(6506007)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Sncya3dKbmNLdnRVODVrUWF0QmZ6NUM4VE40emNZY0s5UTc2UHkyZUl1QlRw?=
 =?utf-8?B?ait6SkV2NWZXdDBOMWpQSWxQY3M1MjEyWG03dEpMbFV0azJxVjE2dzFNU2FT?=
 =?utf-8?B?VlNydlVRcEt5TmtFUiswNmQ3YXJlbndOS2tkR3JZSFNhTTRPRGRGRmFyemxw?=
 =?utf-8?B?Rjc5b08yWjRiY0FPbE44RXFaakRaUzRGQng5NkhhbVpEcklpZGZyVTREeVkw?=
 =?utf-8?B?VmFXSW5aQ3A2b0NwZnNRMy9Qa1pvbnI5TEhGWCtvVDBxZFQySTlySE5VMnNJ?=
 =?utf-8?B?aXl5NHpETk5TOUNlZ0xJb3hxdTRBdG9NRXVlMUNNdG5acHJFaXBGMllNNUtx?=
 =?utf-8?B?K1VJSGg0QXI0bEMyT0FJaXk4SFNLN1NrRml2S2I2eFk5L2hzY1FNSlJnTEM5?=
 =?utf-8?B?bXNVSzFTMld5VFZHd0ZKaDNYOEdqR0JPazNkbWY0OWpBNVdVWXQrVDdGRFJt?=
 =?utf-8?B?QU5KZ1UyTTRmV2FkVXFqM0ZubkFsb21GVUtJanVmUGdUSGQ2Yk8vRkRtM1lC?=
 =?utf-8?B?OVhmb2pRSVZTVkkxWGU4akk2c29lWklaa3M2SWp3MkpRa3JMQ2RBUC9Tbmcr?=
 =?utf-8?B?Y3ptd0dpSm1ZMnlud0ZwcklrbUxUc1NFcmRWcFhib1VVUnNxODJXeG11cTg5?=
 =?utf-8?B?eUw2emNGZld0Uis0ZWVWMkJXUWNYaW1rS24wK0l3SDgxa0JyY3paTE5yeFR2?=
 =?utf-8?B?MHI1RE1CUUV1Z0VUTk9hcGZjZ1A0Q21pWmlmL2hDaGYxd2IyT2hvU3pFM1NM?=
 =?utf-8?B?Q3ZuVFdwTGtoYlFGSzI1Y3VGUUQwQjVQU0Rjb3VESm4yeWxpZHJ0cnVnYjRm?=
 =?utf-8?B?d2lPc2NrRncxV1JsTkE2VzNOU3JxYkRIMjdtckU2ZUREbDBIZENteE0zTXNk?=
 =?utf-8?B?QmpPaFFIMmg0d3hYSUNzVjl4MncxeWx2UUhaS29KenluQk5oRGhBTVFkck52?=
 =?utf-8?B?VE90c1E3MkRudGJYamlQcFBoODB6UzNoTDkyM29uMjM2NmJKeXVHZG1CSldF?=
 =?utf-8?B?UUN4RmFvZDl3TU0wTTJWREpUTXBFZ0NRYTdrK1hrOHlPNzdldG51MlRNdEdx?=
 =?utf-8?B?VnBrVXh4V2IySGVmN1YzUVdNb0R6UkhGT3ZPU1hxQnlQMHBaZWl3aG8vV2Vo?=
 =?utf-8?B?SjJSOWc1VWJCZ3dQRXdvRE5QSDhaU3hMVmkrZjkzTmpqdFNKV1VEL3MvVDJL?=
 =?utf-8?B?V04zQ09Ub0g3NUJZYm92WEc2TVRQZHJLWGxzWmJjU29YSE41dmxYbDdieDNu?=
 =?utf-8?B?T2FmTXZnNUhqeEc5cTF1Um9sczU0MWNZdXdKNVFGWEtQb0IzOEhiRXBHZ1RT?=
 =?utf-8?B?SG8xSENxUVM3bk1yOGM0SUxpQzdXSUtWS0l0aTdpaWcxSjR2b3VJUVpTNHNB?=
 =?utf-8?B?L1NzMWxnaEFneDdhdjFTQ096UEVacmEzUHlwbC9oWllpQ1RYK09WU2QvTUhm?=
 =?utf-8?B?NmQ3ei9Hd3VwMkN0b25RdHIxUjN0QVFpSlM5anRDcUNucUgwaWZBWHIraWxV?=
 =?utf-8?B?NG4rOGVxMHVIbEpsZlBwTHNiclQweE5VL051dGpTUndRbTNZMUdjRmpib1pH?=
 =?utf-8?B?ZFVRUW9jd0V5S2pQaWNpTU9taTRXMlU1ZS9QMkNZZXJ1K3QwMjEzYkxVNy8r?=
 =?utf-8?B?SXBwOG9LNWl4SzFOVVNJZnplM2U5ZFoxQzBSZWJQRDdjZkVCYUFJWGZvT0J0?=
 =?utf-8?B?VTZ3aTVwZ1NJMDRKSG1NRUM1R0RqSVRPQ2EzTm04RWk1Snc0ZDhGREphYlhQ?=
 =?utf-8?B?cTlwSHFYZUY2NXUzTStYME5QcHBjaUI5NTgwZEpYMTZ3ZFhBa2MxNEVGRC9Z?=
 =?utf-8?B?cTN3a0t5dStrSHNrZTN6ZEZwQ0c1T0NsY01COE5KMEtFZExxOExxYUgxTEY5?=
 =?utf-8?B?U1pzOUUwRWlDeWMyQWhldWN5S3VyKzRrWW42ZjlqanlJcmlGT3BLY0tLRml0?=
 =?utf-8?B?N2swRkExWjc0TXMzbkJuR21qdE0vS1V5ZmtWUGhRUDVxU0c4Y25DMHlLb3V4?=
 =?utf-8?B?QlNVWVNteE9UVHNPNlQyQ1hHK1R2V3R1Uys5ekpxUzRhZWt4bVJRTEdRbVhL?=
 =?utf-8?B?Z1NhOE4zUk5MYVpOMEJrNW0zaWpIRk9wUFhnTDVieUhqdkxEVndVRk1rUE95?=
 =?utf-8?Q?PP1s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5357.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce5d3f66-e21a-4dc8-59b6-08daba6d8039
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2022 11:54:29.1477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LqpmNMglMAamT8DO4aP6VEhUNOib57HXhJxGNkmx72KQ11v/Yn43w2f0ZGh18Hs8BcEq33Hfpos/+AzjDi+39Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4342
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pk9uIFdlZCwgT2N0IDI2LCAyMDIyIGF0IDExOjU2OjIzUE0gKzAyMDAsIFNhYnJpbmEgRHVicm9j
YSB3cm90ZToNCj4+IFRoaXMgcmV2ZXJ0cyBjb21taXQgYzg1MDI0MGI2YzQxMzI1NzRhMDBmMmRh
NDM5Mjc3YWI5NDI2NWI2Ni4NCj4+DQo+PiBUaGF0IGNvbW1pdCB0cmllZCB0byBpbXByb3ZlIHRo
ZSBwZXJmb3JtYW5jZSBvZiBtYWNzZWMgb2ZmbG9hZCBieQ0KPj4gdGFraW5nIGFkdmFudGFnZSBv
ZiBzb21lIG9mIHRoZSBOSUMncyBmZWF0dXJlcywgYnV0IGluIGRvaW5nIHNvLCBicm9rZQ0KPj4g
bWFjc2VjIG9mZmxvYWQgd2hlbiB0aGUgbG93ZXIgZGV2aWNlIHN1cHBvcnRzIGJvdGggbWFjc2Vj
IGFuZCBpcHNlYw0KPj4gb2ZmbG9hZCwgYXMgdGhlIGlwc2VjIG9mZmxvYWQgZmVhdHVyZSBmbGFn
cyAobWFpbmx5IE5FVElGX0ZfSFdfRVNQKQ0KPj4gd2VyZSBjb3BpZWQgZnJvbSB0aGUgcmVhbCBk
ZXZpY2UuIFNpbmNlIHRoZSBtYWNzZWMgZGV2aWNlIGRvZXNuJ3QNCj4+IHByb3ZpZGUgeGRvXyog
b3BzLCB0aGUgWEZSTSBjb3JlIHJlamVjdHMgdGhlIHJlZ2lzdHJhdGlvbiBvZiB0aGUgbmV3DQo+
PiBtYWNzZWMgZGV2aWNlIGluIHhmcm1fYXBpX2NoZWNrLg0KPj4NCj4+IEV4YW1wbGUgcGVyZiB0
cmFjZSB3aGVuIHJ1bm5pbmcNCj4+ICAgaXAgbGluayBhZGQgbGluayBlbmkxbnAxIHR5cGUgbWFj
c2VjIHBvcnQgNCBvZmZsb2FkIG1hYw0KPj4NCj4+ICAgICBpcCAgIDczNyBbMDAzXSAgIDc5NS40
Nzc2NzY6IHByb2JlOnhmcm1fZGV2X2V2ZW50X19SRUdJU1RFUg0KPm5hbWU9Im1hY3NlYzAiIGZl
YXR1cmVzPTB4MWMwMDAwODAwMTQ4NjkNCj4+ICAgICAgICAgICAgICAgeGZybV9kZXZfZXZlbnQr
MHgzYQ0KPj4gICAgICAgICAgICAgICBub3RpZmllcl9jYWxsX2NoYWluKzB4NDcNCj4+ICAgICAg
ICAgICAgICAgcmVnaXN0ZXJfbmV0ZGV2aWNlKzB4ODQ2DQo+PiAgICAgICAgICAgICAgIG1hY3Nl
Y19uZXdsaW5rKzB4MjVhDQo+Pg0KPj4gICAgIGlwICAgNzM3IFswMDNdICAgNzk1LjQ3NzY4Nzog
ICBwcm9iZTp4ZnJtX2Rldl9ldmVudF9fcmV0dXJuICAgICAgcmV0PTB4ODAwMg0KPihOT1RJRllf
QkFEKQ0KPj4gICAgICAgICAgICAgIG5vdGlmaWVyX2NhbGxfY2hhaW4rMHg0Nw0KPj4gICAgICAg
ICAgICAgIHJlZ2lzdGVyX25ldGRldmljZSsweDg0Ng0KPj4gICAgICAgICAgICAgIG1hY3NlY19u
ZXdsaW5rKzB4MjVhDQo+Pg0KPj4gZGV2LT5mZWF0dXJlcyBpbmNsdWRlcyBORVRJRl9GX0hXX0VT
UCAoMHgwNDAwMDAwMDAwMDAwMCksIHNvDQo+PiB4ZnJtX2FwaV9jaGVjayByZXR1cm5zIE5PVElG
WV9CQUQgYmVjYXVzZSB3ZSBkb24ndCBoYXZlDQo+PiBkZXYtPnhmcm1kZXZfb3BzIG9uIHRoZSBt
YWNzZWMgZGV2aWNlLg0KPj4NCj4+IFdlIGNvdWxkIHByb2JhYmx5IHByb3BhZ2F0ZSBHU08gYW5k
IGEgZmV3IG90aGVyIGZlYXR1cmVzIGZyb20gdGhlDQo+PiBsb3dlciBkZXZpY2UsIHNpbWlsYXIg
dG8gbWFjdmxhbi4gVGhpcyB3aWxsIGJlIGRvbmUgaW4gYSBmdXR1cmUgcGF0Y2guDQo+Pg0KPj4g
U2lnbmVkLW9mZi1ieTogU2FicmluYSBEdWJyb2NhIDxzZEBxdWVhc3lzbmFpbC5uZXQ+DQo+PiAt
LS0NCj4+ICBkcml2ZXJzL25ldC9tYWNzZWMuYyB8IDI3ICsrKystLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQ0KPj4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDIzIGRlbGV0aW9ucygt
KQ0KPj4NCj4NCj5JdCBpcyBzdGlsbCBteXN0ZXJ5IGZvciBtZSB3aHkgbWx4NSB3b3Jrcy4NCkkg
dGhpbmsgaXQgd29ya3Mgd2hlbiB0aGUgb2ZmbG9hZCBlbmFibGVtZW50IG9uIHRoZSBtYWNzZWMg
ZGV2aWNlIGlzIGRvbmUgYWZ0ZXIgdGhlIG1hY3NlYyBuZXRkZXYgY3JlYXRpb24gc3RhZ2UgaS5l
LjoNCklwIGxpbmsgYWRkIGxpbmsgZW5pMW5wMSB0eXBlIG1hY3NlYyBwb3J0IDQNClRoZW4gDQpp
cCBtYWNzZWMgb2ZmbG9hZCAkTUFDU0VDX0lGIG1hYw0KSSB0aGluayB0aGlzIHBhdGggc2tpcHMg
eGZybSBjb3JlIHJlamVjdGlvbg0KPg0KPlRoYW5rcywNCj5SZXZpZXdlZC1ieTogTGVvbiBSb21h
bm92c2t5IDxsZW9ucm9AbnZpZGlhLmNvbT4NCg==
