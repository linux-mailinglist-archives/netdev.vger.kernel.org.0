Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79AFA4D8B11
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 18:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243341AbiCNRur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 13:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbiCNRum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 13:50:42 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2075.outbound.protection.outlook.com [40.107.220.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC2E13F0A;
        Mon, 14 Mar 2022 10:49:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GK9WBOhTujCacXtql5JYUBFjmsJMcRfUKNHWUWZ/kC/7Nvi0uTdL8R2CSoXJC35NVtuRT17Mt4NYkbwIOeq+FwNBBSLFHK5dUWiOqCwtSq6klctBLJB0bMTt+Lkgf9fNtFtxoxz7znotQX8ZCQi+fK0LZBipi3FZu0LdRSkznZosfaDWSr2ZjBkRN1OTObG6O67MNILhcOFaTvB8YLTMTSArgErQsJA5yG4ezepKMzL1NpN5uM7A20qYGGeTB3B0y12VfnYHZVDdN1udWi1n8tJTnsWBMy6bEw4lsOlfSubsL8vtKblVlsSjRhiToqvvakSyqUlB26Kr4Fg4Xrtjrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FkPooetszJNFjZDXkCKg83zIJbm/NhNL0w0NrzRPzZk=;
 b=dwE7gATBSrUDrLih/guJjjJIyputcDKuJ9UJ9wjd/H4CNO4nmBxLN1hET0WXgfzpKJH5Dy3JXDdC3j0SmWOI5R3C1hbli+OEC9bte+Al9th04tUJWzmXGSF2rd+xAZzeySZkfDFJwLD0Y1xeQXM1t41sYemd0LcUA4h2nAXpoCiwt+khkS/PNzkk3zpmkyjduk2RlmwSvghRSmfv9PeSpbfD1zvphgV280mDIsKzLv48l4t44f76O3DY+RKGWMG0jwyT85wAUqn5ZVK7vEsF3s18WZv3xnqg7zEAAakTCOJdpQBhCUPXtlYncMDsiGUL6zqheTmtsd+BPfaHNeFUSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FkPooetszJNFjZDXkCKg83zIJbm/NhNL0w0NrzRPzZk=;
 b=SZVj+ggFo8raYwXnA+Yu81QICVpX1NxZRDm8ZHGIs2Rn7h3MDrbjCsdihn1v9NiQCeMyHpRUDBREPYV2gWVoeBvFL8owYHaibWHJtcle2QtonzS7HsP5NVfLOKEdjIOtuL5fteiQxowmW2LkcKSeNT2kuIv77vgcqdLUrDWPVRkvdsUSzo2Xbt0qrW7N6p0pucxUFjykw865Mt4vVITtqdV8EGoHfTwF33VP/qorFpzB0hIAKuSUnPAfvaFKey2rbVhmS4zp+kV83CBAPWGwDjAo03NbH7bcuZbMNnQRTk7cWUhe/ss5l+09nkMIvMK4u6ygRJP5E5NGRkWkXawDsg==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BN8PR12MB3187.namprd12.prod.outlook.com (2603:10b6:408:69::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Mon, 14 Mar
 2022 17:49:30 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::698a:be42:9ca2:bb4f]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::698a:be42:9ca2:bb4f%6]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 17:49:30 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: RE: [PATCH bpf v3] bpf: Support dual-stack sockets in
 bpf_tcp_check_syncookie
Thread-Topic: [PATCH bpf v3] bpf: Support dual-stack sockets in
 bpf_tcp_check_syncookie
Thread-Index: AQHYJ9pCDnVWuEd8LkySywqQH+5pgKy6esCggAARcACABEWykA==
Date:   Mon, 14 Mar 2022 17:49:30 +0000
Message-ID: <DM4PR12MB51501E2FEDF409170BEA3AF3DC0F9@DM4PR12MB5150.namprd12.prod.outlook.com>
References: <20220222105156.231344-1-maximmi@nvidia.com>
 <DM4PR12MB51508BFFCFACA26C79D4AEB9DC0C9@DM4PR12MB5150.namprd12.prod.outlook.com>
 <CAADnVQKwqw8s7U_bac-Fs+7jKDYo9A6TpZpw2BN-61UWiv+yHw@mail.gmail.com>
In-Reply-To: <CAADnVQKwqw8s7U_bac-Fs+7jKDYo9A6TpZpw2BN-61UWiv+yHw@mail.gmail.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44c3085d-dc8b-4bb7-f895-08da05e2fe01
x-ms-traffictypediagnostic: BN8PR12MB3187:EE_
x-microsoft-antispam-prvs: <BN8PR12MB3187DF75DFE2004E0E2B5233DC0F9@BN8PR12MB3187.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kjv3+flWaSs30y/EwXXfhamRx9QLtnrA4gMrQIHaUfApwcVObalcq7Rx+HeH1US54bHOVbN+6n8B2zTB6vi2/IxmFKhxm3KTxm14ACwS7YfPJCQfNyq8dH82jlFxVG8OhOz+HtnKIb4cuZC5SbHOTCMIOCcioz6zre3M+AoDY0MNyoRfMtxWxE7Sv8IshYAJKYiwQ1jGkLtxvrdM2Dmo94coz4T3jNdy2G47o90GdxIHXSVHaF+0ofmvw8qWfHIF2M8uqhMd27yEEex54pkZUveurbYRFwmV3QTISlppWEKcwJtehnkX9qTsC4fjtD09sC2HzKLqUtVehxLcE0APZdU2ZwjherPaxj9xyI6nX+8jNu5MgHQRJB3LRXVQ++yvxgOJht9tD+bFh/bUYdpcMqsNMv/5PWn2RoS+ufMiR6ldAAPXd4k9Yh9zZAGr+nAkTWZzlBvcv1QgtFr9lsPG+Ig+/VKU97W/3xWX9hny9U1t7tclk4vU2RMz2t91mQHxIr+Glf4yXFdY2/AbTSaB44rv0aFNZxq5gwG1OEpN8XE9rhre84BH6meKOVbHYgzdhYL32zg8pOlKv9M9JuolXxzkOFHkZDQNGDFHZMG87bogsnqLVdet2ozInA1Ggkx6H9ye0tFUyYTS4KuiEbmERoB41qsco7aWPsiDQAuC2XVDRVv+evquxc95oJyyomoMCVG/E2wFbtqWArYvza/Yhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(316002)(2906002)(55016003)(86362001)(38070700005)(4326008)(8676002)(52536014)(64756008)(66446008)(66476007)(66556008)(66946007)(4744005)(7696005)(6506007)(53546011)(508600001)(38100700002)(8936002)(71200400001)(9686003)(6916009)(54906003)(122000001)(26005)(33656002)(5660300002)(186003)(7416002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MkZGd3BLVHFPekxZRE9tRVVrN1lKV25YbHRidHVSbkg0T2UyTll0VG03eXZI?=
 =?utf-8?B?Rm9FZW5yQmIyOWhtWURQV1k4dTBXTUxId3dkM0dBWEI4UGJBRVl1RHR6M2Zo?=
 =?utf-8?B?Ym80RjFXMlJoaUtJREczOUNNQkdrN292VWdoelI4bVlJT1hucmlLUnJSczlT?=
 =?utf-8?B?U2JnQ2U4SmVpYkRxbFZSa2dJTlZLZ0RHQjFGUVQ4Z1h4SHkwdDlkejl0QTYx?=
 =?utf-8?B?VUhEK1QxT1BQUHlkamlzMzB2V2RRaUV6aGtORk9naWxicmt4ckwyMmt1cUpt?=
 =?utf-8?B?bWVhZHVwaWV3dWV3ckQxejU2YmJxbzRTN2FwN2c2RGQxdHJnNkhJOGlOL0I4?=
 =?utf-8?B?TnZPeXRxUnV4Um9ZOUVwcUREd3lCSE9UYm5YNmJnN3JCemV5MHVvSWlVTzZv?=
 =?utf-8?B?d0VrbS9zMGg4ZS9xWnJ4SXVoVE9RUHBGSTNTQjhPTWx4Tkd0NjRManRyWGQ4?=
 =?utf-8?B?TUtQRElZemlPMzl4REFoNVdZVzg3ZEVaM0E0RmZwYUkxZ1dOQ2R5SXdyMHg5?=
 =?utf-8?B?bU5TNU01QnE1L3EvVWM1VWxZVWVxTE5Hd0NjOURvUEdkNFhJWWM5b2xZaktP?=
 =?utf-8?B?Vmthb09XOW5CZXdNTW9kMGNveHVCdXExUjVZVWRVa3pYdUdqRkxWYng1SFpx?=
 =?utf-8?B?aURiWTlBZDRBVVhxbHJPeGU3aGJqYnFQc2JTUmlFOFBTYlkvU05PeDVJVjg2?=
 =?utf-8?B?ZWZNZlE2TzBkL2VTbFAzM0lRVHAxREtiOFYwTHJtR0VFaFVNVXVEVTdmbDgr?=
 =?utf-8?B?MnpTZ0RMcDE1Q1hNRVpBZEVGb3Vrc0RZVlFZbzIzV0k1bE1BYmpCUXR3Wit0?=
 =?utf-8?B?bXJuWFpLb2RnSm9hZFpXa2NvdElwb2hjM0VOWmF1YzBjVTNVMTNlckpsLzNm?=
 =?utf-8?B?aXJzeUp1UEpBZ2ljdm9URnNaWHdaT0tiZzZtU2hYTWliMTN1WmhMeHNBd1R5?=
 =?utf-8?B?S0ovbkJuVzlLZ0I1SnllR3l6aXorc0ZhakRNeWIyRlpvdHhwUjZwcElEN0tu?=
 =?utf-8?B?eGFXd1BzNXlvbXp0cy8rNWMyRUgybXZET2hVYTAxOWRMMUpMZFk2a3hnWU5w?=
 =?utf-8?B?UTNsN2tkZVJtSDNuMGVUb3Q1OURqajRpU3hLeDJUbUZFSUtrRFVPUUw4T3Js?=
 =?utf-8?B?WkJBMy9ZUi9DbDhpREJsTjRtanU1SjNkVUtydlQycGlkeUxTWFNiRGNqYTh5?=
 =?utf-8?B?WGxwTURNUXAwWTFEenoycGJ1NUpoUDUvVTExVURlOFpYUXVFZVNLd0dIbkFX?=
 =?utf-8?B?b3pFSXd3Z1JJWjNsMkNGSFNrUkJJR205NlA2MURFSTUvNk1QcytoSWkrTlhy?=
 =?utf-8?B?RjArZ0FrandqMzFqTW1aaFlqd0JFbHg1WGdCaWhlM1hOcTVvQWg1Nkg5YzhH?=
 =?utf-8?B?WW1DSm1GVWIzbm1zRExPdDdyYTQ5cHhseTY0NndUNXQ5Q2U3ejF4OWlxakl4?=
 =?utf-8?B?YVZMdHl0WDNDcnQ5UzhwbDNFSlM1b05sVzl6RktXcTJyclBnT1dxL093R0tI?=
 =?utf-8?B?SDFDaDdZdlZhVzJYVzVrY2xqZWVYcW1pS0E2UzVxQjFTOVpEMjNLVkE1eW9X?=
 =?utf-8?B?Zk9DOUJ6OWl6VXJZcGZ1b1hlbTM3TFZGTmlQZDNpK1h4NjZDMjdDYUpEK3hj?=
 =?utf-8?B?TGV1d1RaUWlWZVBoTmF0Smg1VDdMYkZTN2hlYU1waDV3K1BlR2ZRYktpbjhp?=
 =?utf-8?B?WGxtcnRkOXRDdUROOXVENXJROEh3bVAvVk5PZDFKbGxaTkpiNGJxdk1IS1VD?=
 =?utf-8?B?QUZlc1hjZXdjbGYvUkFPNldYMlFWQytOcDVNUG4wcjVXa3NRaGtjT2ovOVlu?=
 =?utf-8?B?MXpiZ2lIMTBjMTBWM3JjUXozZXRBaTRUWHhHNGpYd3I5aUpHOXV0aWdOaW04?=
 =?utf-8?B?YjI0cVQ4Z1pEb3Zuams3ZXBhMU55T1UydjN1NGdnN3ZNQUNYOWwyTG95dVhI?=
 =?utf-8?Q?olAuV5fHkZTq03qvVtJkzYgBsZbJUFGT?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44c3085d-dc8b-4bb7-f895-08da05e2fe01
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2022 17:49:30.7698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LQLWjF3Krff5dPDOr4GBnl+Yluy6iuat70CpnmViVwJchiE0P6JNOQrV72gngHm0DiXhkbWUJI/5Y4q+jYukbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3187
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbGV4ZWkgU3Rhcm92b2l0b3Yg
PGFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb20+DQo+IA0KPiBPbiBGcmksIE1hciAxMSwgMjAy
MiBhdCA4OjM2IEFNIE1heGltIE1pa2l0eWFuc2tpeSA8bWF4aW1taUBudmlkaWEuY29tPg0KPiB3
cm90ZToNCj4gPg0KPiA+IFRoaXMgcGF0Y2ggd2FzIHN1Ym1pdHRlZCBtb3JlIHRoYW4gdHdvIHdl
ZWtzIGFnbywgYW5kIHRoZXJlIHdlcmUgbm8gbmV3DQo+ID4gY29tbWVudHMuIENhbiBpdCBiZSBh
Y2NlcHRlZD8NCj4gDQo+IFRoZSBwYXRjaCB3YXNuJ3QgYWNrZWQgYnkgYW55b25lLg0KPiBQbGVh
c2Ugc29saWNpdCByZXZpZXdzIGZvciB5b3VyIGNoYW5nZXMgaW4gdGltZS4NCg0KQ291bGQgeW91
IGVsYWJvcmF0ZT8gSSBzZW50IHRoZSBwYXRjaCB0byB0aGUgbWFpbGluZyBsaXN0IGFuZCBDQ2Vk
IHRoZQ0KcmVsZXZhbnQgcGVvcGxlLiBUaGF0IHdvcmtlZCBmb3IgdjEgYW5kIHYyLCBJIHJlY2Vp
dmVkIGNvbW1lbnRzLA0KYWRkcmVzc2VkIHRoZW0gYW5kIHNlbnQgYSB2My4gV2hhdCBleHRyYSBz
dGVwcyBzaG91bGQgSSBoYXZlIGRvbmUgdG8NCiJzb2xpY2l0IHJldmlld3MiPyBXaGF0IHNoYWxs
IEkgZG8gbm93Pw0K
