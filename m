Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A1045C4EB
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 14:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352421AbhKXNxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 08:53:05 -0500
Received: from mail-bn1nam07on2105.outbound.protection.outlook.com ([40.107.212.105]:59662
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354521AbhKXNvA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 08:51:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bC8deT0vPlb1PCZ5MHr4hemlb0VteL6xSeYCNUnPc6w2Ft5jEwjBGlUX53AxOY3HJ6vslaVdnDv0FdMujt7m+JGslQVkvCa3Kmx8Nqk+ZmsFIJFsSyJIm8WBtf7oc70cp85iq6giKv5jDbPKjg0QNCEGiHQFgJlG1/RmOqKkLj05u5Cve7qryPAB9viQUbmYkkgilYK2LhRvsgHHmtnERt9I2/JLqitWbf1kNlFqF82mVvE1PioRuG/Pre0lWDFP5bQ1nvi7vAQEKl8Fc/toczfensckZEa/gR4bVuERJ6m/UIXZ8crP8tHvKv1g0eGiQOth7VZdYY2AGxld9H93ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ogChHkVE5Ke/f03wlJ6XuMpy1MaGDoZfl5cZ4QVcGTI=;
 b=TFspnbHcn7Y7cRRA4OKTmydn1wOlGpSCMDfgyZSaOo6CXyY/+L2VUaWn+1eHcqqngjla3Yu+lizvSIKJCLQXVz0Wx/1LFvTX3CFThvyfCDdEcuoakUyWAYNbQUkm67ps+QGhj4F/V96Uy2WMC642HvB0AYlPS5qzq3HqkkCatWWJhQ868lMJgKl9rqJpqhYP6rQwtUxgiSkOA4Ij5VaTaFQyZvXD4oOKWNsX/awyV/PkyFagEPXStkTn1cLoiAoYyfDURzVkzwJcM4AwyTkc5pIxscY/jWSnEyRqy4/eOdtVKcLgxJAhR0gBCREgErs+3sNxi7DFoR7VRUiu4aateQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ogChHkVE5Ke/f03wlJ6XuMpy1MaGDoZfl5cZ4QVcGTI=;
 b=WjkkbXn875Zr1ZlVkiWlzmqdsgGQW4j0rnsClD7WTbmOHbTjPfrvVxfyTMxdJw1sf3iv17sk9MZzSZ4dEtY40q2cC3Gf40J5RiwpklnT4yvQcLzwd+VQNBYcy0IuaR4HvH5PB1GDpxdyGSNYHHBNLbtM+MSMR5262HIuIMuY+ik=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM5PR13MB1628.namprd13.prod.outlook.com (2603:10b6:3:120::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.6; Wed, 24 Nov
 2021 13:47:48 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15%4]) with mapi id 15.20.4734.022; Wed, 24 Nov 2021
 13:47:47 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH v4 04/10] flow_offload: allow user to offload tc action to
 net device
Thread-Topic: [PATCH v4 04/10] flow_offload: allow user to offload tc action
 to net device
Thread-Index: AQHX3H1ga5WIPFCaM0W10xbzQpwKhKwPftuAgAFJvqCAALgaAIAAbhwwgAAU+6CAAJMrgIAAISRA
Date:   Wed, 24 Nov 2021 13:47:47 +0000
Message-ID: <DM5PR1301MB2172F332AED4A4940C2ECAF8E7619@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
 <20211118130805.23897-5-simon.horman@corigine.com>
 <cf194dc4-a7c9-5221-628b-ab26ceca9583@mojatatu.com>
 <DM5PR1301MB2172EFE3AC44E84D89D3D081E7609@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <404a4871-0e12-3cdc-e8c7-b0c85e068c53@mojatatu.com>
 <DM5PR1301MB21725BE79994CD548CEA0CC4E7619@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <DM5PR1301MB2172ED85399FCC4B89F70792E7619@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <a899b3b5-c30b-2b91-be6a-24ec596bc786@mojatatu.com>
In-Reply-To: <a899b3b5-c30b-2b91-be6a-24ec596bc786@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b73eef0-6d73-40de-33c5-08d9af51002e
x-ms-traffictypediagnostic: DM5PR13MB1628:
x-microsoft-antispam-prvs: <DM5PR13MB1628958D95548E8D68B8D4A7E7619@DM5PR13MB1628.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NIfOd8/TLdHTroHe3uaYBWHBBcmyShghdBsrDplGYG2T6ovSeMWnlV/jb4xK8p1e5cPcEAom0LTEc22oHeNK2AJCw3DNKbZKcgid3dKOjlV/cKzesK/FPQcdK5yNh5hTlvoniZxMnnCb95iptp5/tZNz8NK9tkdTwPNzs9DRzFA0IkQm6ZpipMm+3w+Ejl+aHQjNuOfmBTnA9FgYJAWwNTElv8eQXNTknoBRPeGIRQea8WFyIswZPNbxXmQzW7H9YuKrHjwOYtQ9n/mC0CYGVP/U9SzIxuV2VngCb1B0dUAdiSmIVmd7aNpqEUkDw/oFovux3GZyfRnuo5XKHskJbL57bn/tvXzHhivvnKVTAFXss17deXDzwLvaKEaouuoxpxJYxAar1jPiANkuPWRRsdoNy9fG8DQJPPCBBIOdqufLmAhgrts2dG08xFxvq1h5vaP8zVfzci8v4eKNsmQ+vpEuCqbPMC3ndt1OZqjJ1iSdD5POrOiNnSfwHVUEHXxtNPQ1mJRMnDKEEphHQXlazPk2n6p1PWsL/kYgsl8Nf+VRXBLL8oVuCejD1N0anffctVl4pDULfsdX7yVWuf86XwU4OKSmRYc3FLv0VjGeayNxkuY6GvjhkGhiekk7YLyFSlDguLYsleD4P4cihP8DLF2yS50oVDkGpeDvJGg5GY5XXA2N/n5Aagnd67AY1SdpaJRhEkO7SPLFZ+Ik3NU5NUm2OfngTJHdgqbda99V03C35P4OHCCmg2hKxkg22zX0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(366004)(396003)(136003)(376002)(346002)(4326008)(2906002)(7696005)(508600001)(71200400001)(83380400001)(6506007)(4001150100001)(107886003)(316002)(54906003)(8676002)(66446008)(64756008)(38100700002)(76116006)(66556008)(66476007)(66946007)(8936002)(44832011)(55016003)(110136005)(9686003)(38070700005)(86362001)(26005)(186003)(122000001)(52536014)(5660300002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVp3dEdqTHM4NlhVMU50Vm9wVGRJYzNpMytLRUVLSmJXZ3ZtNHBSbmNWV3Ju?=
 =?utf-8?B?NW5wYytsbnMySlllanRlL3JhY3A3bmxmNlpWMmhCMmRMVXowM3Vod1NFdDNy?=
 =?utf-8?B?dml3UU51SUUxZjJ2TCtsVGdHUEdmanBlYjdLUEU0WVZlZlYyTVQrMTI5cmRM?=
 =?utf-8?B?Y3l1SEFkdTdEdS9NNmt4NFBNb2VUYVpwdVZnSGJCZ05VYVZPakZWcm5hQzEx?=
 =?utf-8?B?TGdFOFNjYnVzN1orMDBRNXJhSWI4T0R6dVMrUm1aZUhoRTJvQjVxYU1vc3Bw?=
 =?utf-8?B?TG9RTzJyYjF6UXoyY29JYVJlMjJncXRHV1FTdThuL1ZHNzVpUTF6MGxZZU9I?=
 =?utf-8?B?YmFCRUVMZnZUMTRNNzJlU01pMjc1OE52Q0xNN2hodGNvQnNmbExwUUZnQ25q?=
 =?utf-8?B?Q2xmeG9rZTVOdzE3aXkrU0Y2aGVOWkpqM1FROGFUd05CZEkzdmhyVHpHRXZ0?=
 =?utf-8?B?RVlnYmRwUFZYRGxMQ3V6WCtjU29aUXduMnJSSDlRNmtTMjdiemFxSXE5Vzc0?=
 =?utf-8?B?REdVemtZbnpwWWJwTnIvVTNlTEI3eTE0anJmbkVteEdLSjVDOXJXSDZITitD?=
 =?utf-8?B?V2d3cDYrd2xPS2NuNFJzVnlFa0dGNXYrNGlKUkpESVBBeUhOd3pSbWV1VWtQ?=
 =?utf-8?B?UGV0Vmx6bUx2UGJ2VEluUXM1bGkvblVKWWJUWFhXQVRVVDA1bm01QmthMDdR?=
 =?utf-8?B?TS9teFp4TjZld0V6Wm1BYVl6L0o4NDU1dWRqaFpZeVE4SC90VmdCOGNVc2pY?=
 =?utf-8?B?Mnl3VzlGSWpQSkxHUTVwcnhVbFNpRVUrcWIzVEtYNW9vODNNV01PY0p0NW1U?=
 =?utf-8?B?dEppTlV1QjFsMmNDcEFFd043NXduYk4vMzIvRlVPK21RZjZ4ZlVENU1XSFlQ?=
 =?utf-8?B?d1lxWnM3WDh5YjBISWl2dU5JdlEyZHA0SFBjTjBnY1Q3TURqZU5nQ0RtSUli?=
 =?utf-8?B?U3E0bXhhRFI3VUhBZ1BRSGIzTDNGWlVlaU9hRHBnSHZ0T25sSnIyM24xelFG?=
 =?utf-8?B?azVSWHgvYnFReEdWZUNrNlZubENVN1Q0MytUUktubEpTUmJkVzZrVFZPalpu?=
 =?utf-8?B?dEtsQk5PUWZYSTgzenk4SGNzclFrSmNJNkFTNHV0VGg4QUE3REt1UWVBck5X?=
 =?utf-8?B?akJUZUVCdTdmS01jVU1uTGVjdDE0NzdnOVhWRmRQSGM4Z05KbG45WFVjUWNv?=
 =?utf-8?B?NTAwU2JycnF2bnhaRCtRK2hZMysrQVRkM1NRak9DQnkwVUQ3cnNadUdMcTZJ?=
 =?utf-8?B?eDdNVVBsY24rTzFIUDZ1bzl2ZW5VWmFPQWt4YS8wdVVkSzZPMFZzMXpGc3Vk?=
 =?utf-8?B?Z24zM2NPUVFhenY5V1FkOUkrUG5nQ1VkQXN4d0p2cUdnVTBZNnFjS3pURldP?=
 =?utf-8?B?M0s0TjJHZzVnbEZ0UVV1RCtMcUxFMEQwYkl4cmQrY0p2aEg2THloajZQZkNG?=
 =?utf-8?B?L0ZZa1ZDRjU5S2ZqRnh6R2VqVU9VOVl5SzhMVExsVlhUdTQydVNmb3F5UHZ3?=
 =?utf-8?B?VG5FalRhSUpETkNKdVdkMVdNOG9FVGNEbUVXV1Y4YlB6VmNrNldsNVVidkhJ?=
 =?utf-8?B?RUFXK1lZMGtxdkdPM2Y5U0h5OG9TL1RrYm5lSHBIMGlybXJMY2VnZ3BJM05B?=
 =?utf-8?B?bTJ4SWw0ZVE1YWo2bzl3SmlXcmVrS3krdmplNll1TTVxM0prSjB3RUpuOGEy?=
 =?utf-8?B?WUcwY3l5OXF1MVY2TlF5TjlGQ3hZc1VHZzZFWDJNWDNsUy9hdXBEUmRBY2I0?=
 =?utf-8?B?SytOQThtdlM3ejhDamtoQWp1V21kajdETnFiWFBrY2ZOUjFJcmdtVXFJRENH?=
 =?utf-8?B?L0NxUnNlQlRQMDBKWnNLYmN6SGV3cXEvTGNoWVg1NGRpczl2dGpobkt4R25E?=
 =?utf-8?B?SG9ERnlhQnlPZWZQS2drbExwVWNKSmZmYlljMkJIeS92N0grNTh5ZXdYVnNu?=
 =?utf-8?B?MDVseEtjQndoSHBaVE5PT2xSZ01KOUwyK2grSFE0bUwveURMMFVxVU5idEU5?=
 =?utf-8?B?dWw0YTByMFVaaDJwV1R2MktkbG42VDZvcWhmM1RQeHZtbEVFSWFrRXZndC9B?=
 =?utf-8?B?UFpiTE1OaTZLeXZIR3NYc0VqMW9wMUs3bXRPS0IzQklWRWtadEdXQS9zRFBQ?=
 =?utf-8?B?VGF0Z1JoTEJSYWlxN1BRNHM2aTNkdTRjcmphUUtsZGNLYU1rWWVKTUx0WFZ2?=
 =?utf-8?B?QVdNMGR2QzArUllzRm81YzkraFppMGxOWFR5MVJqUTB6SGM2MFMxOTBObXR3?=
 =?utf-8?B?VTJ1b0pIWXMxWDVwMTcxU1FPTFdnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b73eef0-6d73-40de-33c5-08d9af51002e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 13:47:47.6177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zufux55lQUuIz9tZeUiqIgrby2kr3Is4bSeMX/zT2xPEuV7k+pxn2IWs5Nap11ZQ83ofyZJfeG6sUujrjfky7VNWjFYMq3ibtd+Tv0hT4ZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1628
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTm92ZW1iZXIgMjQsIDIwMjEgNzo0MCBQTSwgSmFtYWwgSGFkaSBTYWxpbSB3cm90ZToNCj5P
biAyMDIxLTExLTIzIDIxOjU5LCBCYW93ZW4gWmhlbmcgd3JvdGU6DQo+PiBTb3JyeSBmb3IgcmVw
bHkgdGhpcyBtZXNzYWdlIGFnYWluLg0KPj4gT24gTm92ZW1iZXIgMjQsIDIwMjEgMTA6MTEgQU0s
IEJhb3dlbiBaaGVuZyB3cm90ZToNCj4+PiBPbiBOb3ZlbWJlciAyNCwgMjAyMSAzOjA0IEFNLCBK
YW1hbCBIYWRpIFNhbGltIHdyb3RlOg0KPg0KPlsuLl0NCj4NCj4+Pj4NCj4+Pj4gQlRXOiBzaG91
bGRudCBleHRhY2sgYmUgdXNlZCBoZXJlIGluc3RlYWQgb2YgcmV0dXJuaW5nIGp1c3QgLUVJTlZB
TD8NCj4+Pj4gSSBkaWRudCBzdGFyZSBsb25nIGVub3VnaCBidXQgaXQgc2VlbXMgZXh0YWNrIGlz
IG5vdCBwYXNzZWQgd2hlbg0KPj4+PiBkZWxldGluZyBmcm9tIGhhcmR3YXJlPyBJIHNhdyBhIE5V
TEwgYmVpbmcgcGFzc2VkIGluIG9uZSBvZiB0aGUgcGF0Y2hlcy4NCj4+IE1heWJlIEkgbWlzdW5k
ZXJzdGFuZCB3aGF0IHlvdSBtZWFuIHByZXZpb3VzbHksIHdoZW4gSSBsb29rIHRocm91Z2gNCj4+
IHRoZSBpbXBsZW1lbnQgaW4gZmxvd19hY3Rpb25faW5pdCwgSSBkaWQgbm90IGZvdW5kIHdlIHVz
ZSB0aGUgZXh0YWNrIHRvDQo+bWFrZSBhIGxvZyBiZWZvcmUgcmV0dXJuIC1FSU5WQUwuDQo+PiBT
byBjb3VsZCB5b3UgcGxlYXNlIGZpZ3VyZSBpdCBvdXQ/IE1heWJlIEkgbWlzcyBzb21ldGhpbmcg
b3IgbWlzdW5kZXJzdGFuZA0KPmFnYWluLg0KPg0KPkkgbWVhbiB0aGVyZSBhcmUgbWF5YmUgMS0y
IHBsYWNlcyB3aGVyZSB5b3UgY2FsbGVkIHRoYXQgZnVuY3Rpb24NCj5mbG93X2FjdGlvbl9pbml0
KCkgd2l0aCBleHRhY2sgYmVpbmcgTlVMTCBidXQgdGhlIG90aGVycyB3aXRoIGxlZ2l0aW1hdGUg
ZXh0YWNrLg0KPkkgcG9pbnRlZCB0byBvZmZsb2FkIGRlbGV0ZSBhcyBhbiBleGFtcGxlLiBUaGlz
IG1heSBoYXZlIGV4aXN0ZWQgYmVmb3JlIHlvdXINCj5jaGFuZ2VzIChidXQgaXQgaXMgaGFyZCB0
byB0ZWxsIGZyb20ganVzdCBleWViYWxsaW5nIHBhdGNoZXMpOyByZWdhcmRsZXNzIGl0IGlzIGEN
Cj5wcm9ibGVtIGZvciBkZWJ1Z2dpbmcgaW5jYXNlIHNvbWUgZGVsZXRlIG9mZmxvYWQgZmFpbHMs
IG5vPw0KWWVzLCB5b3UgYXJlIHJpZ2h0LCBmb3IgdGhlIG1vc3Qgb2YgdGhlIGRlbGV0ZSBzY2Vu
YXJpbywgdGhlIGV4dGFjayBpcyBOVUxMIHNpbmNlDQpUaGUgb3JpZ2luYWwgaW1wbGVtZW50IHRv
IGRlbGV0ZSB0aGUgYWN0aW9uIGRvZXMgbm90IGluY2x1ZGUgYW4gZXh0YWNrLCBzbyB3ZSB3aWxs
DQpVc2UgZXh0YWNrIHdoZW4gaXQgaXMgYXZhaWxhYmxlLg0KPg0KPkJUVzoNCj5ub3cgdGhhdCBp
IGFtIGxvb2tpbmcgYXQgdGhlIHBhdGNoZXMgYWdhaW4gLSBzbWFsbCBkZXRhaWxzOg0KPnN0cnVj
dCBmbG93X29mZmxvYWRfYWN0aW9uIGlzIHNvbWV0aW1lcyBpbml0aWFsaXplZCBhbmQgc29tZXRp
bWVzIG5vdCAoYW5kDQo+c29tZXRpbWVzIGFsbG9jYXRlZCBhbmQgc29tZXRpbWVzIG9mZiB0aGUg
c3RhY2spLiBNYXliZSB0byBiZSBjb25zaXN0ZW50DQo+cGljayBvbmUgc3R5bGUgYW5kIHN0aWNr
IHdpdGggaXQuDQpGb3IgdGhpcyBpbXBsZW1lbnQsIGl0IGlzIGJlY2F1c2UgZm9yIHRoZSBhY3Rp
b24gb2ZmbG9hZCBwcm9jZXNzLCB3ZSBuZWVkIGl0ZW1zIG9mIA0KZmxvd19hY3Rpb25fZW50cnkg
aW4gdGhlIGZsb3dfb2ZmbG9hZF9hY3Rpb24sIHRoZW4gdGhlIHNpemUgb2YgZmxvd19vZmZsb2Fk
X2FjdGlvbiBpcw0KZGVwZW5kZW50IG9uIHRoZSBhY3Rpb24gdG8gYmUgb2ZmbG9hZGVkLiBCdXQg
Zm9yIGRlbGV0ZSBjYXNlLCB3ZSBqdXN0IG5lZWQgYSBwdXJlDQpmbG93X29mZmxvYWRfYWN0aW9u
LCBzbyB3ZSB0YWtlIGl0IGluIHN0YWNrLiAgWW91IGNhbiByZWZlciB0byB0aGUgaW1wbGVtZW50
IGluIGNsc19mbG93ZXIsDQppdCBpcyBzaW1pbGFyIHdpdGggb3VyIGNhc2UuDQpEbyB5b3UgdGhp
bmsgaWYgaXQgbWFrZSBzZW5zZSB0byB1cz8NCj5jaGVlcnMsDQo+amFtYWwNCg==
