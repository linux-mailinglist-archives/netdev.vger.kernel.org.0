Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047754127E0
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 23:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhITVWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 17:22:35 -0400
Received: from mail-mw2nam10on2046.outbound.protection.outlook.com ([40.107.94.46]:19137
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232569AbhITVUe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 17:20:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SO/WK+1z2zYq8m1TjAc/+TW6M10IFsWfyAsRZQpK5G8auhRVV9UOQ8jgjZZwc+kp+3hv6InqaqL+ydmmboNRpaR6w9ZR0bgikBHjnBa3jOcew0FSVeVmz+iXObj4d7kuE6z8Rbon2VxRA9C7fNBpiNfJOMAQ+FDMvMMpNEA4k4RBzWfg6RzI+cUFjeCZ491AnqlYhB2Yy5RTQQ7u5tXp67qPfbCJLxzKS4cgD8RGWzmyftExYFttGdextwkszGnI6jixfIi0uahiDvvMpy9kMxQ4kviGXrCeWaEioepkI/CuFErR1eXWoBUht6cQp4lH3tCf+CO2+YXOb1fzIflrNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=1ks9t6HOjzZ3IRNnLnbwHCylxrHynQJg7I6i6WNCV5w=;
 b=H0Hg2wYegW1atZKL1dnTXGSO943oH8sU0nWWnuihQ2OufeZOaJrMzfnb5ieMZUoSggUYMUu3wJJy3j3j9K7mdLaUkq45HmGFsnqzIcQBVjwr9Kjz/pwBn2sXy1r3+kh+r0VmpTsP8djJkEkBUWKxWxOTr08A+swrxh524HmBb1VY3DQB/wlfJgEI5LDw4ONtEaKHQUbMcBJmu3Id1Ls8ay1rGNCAvJJXHgWp13x+X0LizKWHKs1YnE5PtPkGOo0qGDO2ZJU7vMQXf0bbvVQPm4tlOVsZwIj4oJhGSpm/VaQMX4J860yYweLUF2Ss/t56/BeAEGZD1DLUfTPlsNyCGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ks9t6HOjzZ3IRNnLnbwHCylxrHynQJg7I6i6WNCV5w=;
 b=SLNPjGs7OyQ6g2vE9vMgjHljfJCu9/Z72DIEPPVa3pJV4fmvCR53xEpRIOWdx89k6vw+MzwdHz3PEbLo/rZ9LVedoiZSzkmDmh2Ml6uBRvXmp07oUxEG45HmAMl9WhBpevzGcfRuWsEBXXsbzsrcY2UpAv15vW4WQQAJRfy0TySd3+1ZYb/QiH7cmVqv73n3XixoRv3xdcJE+9LpfAB9eSftiUTnveMxjh66F4c5cJD0l1auTIGYMcX2OZUmEOR5BCD58zhUSmkrvj713L/q9gJv8PYXVUBlZu2qNT+mzuy9C3NBVCOKNxoyBWMxSCk42pZi+qktv/1tCHoXFqzYOQ==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3591.namprd12.prod.outlook.com (2603:10b6:a03:dd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Mon, 20 Sep
 2021 21:19:05 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b5ca:e39d:6e8:3bf8]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b5ca:e39d:6e8:3bf8%6]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 21:19:05 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "len.baker@gmx.com" <len.baker@gmx.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Erez Shitrit <erezsh@nvidia.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Vesker <valex@nvidia.com>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: Re: [PATCH] net/mlx5: DR, Prefer kcalloc over open coded arithmetic
Thread-Topic: [PATCH] net/mlx5: DR, Prefer kcalloc over open coded arithmetic
Thread-Index: AQHXoiqmZBMlkoofKEWjGQlrNc717quthfEA
Date:   Mon, 20 Sep 2021 21:19:05 +0000
Message-ID: <24604c4ac90323a1f39e3f7bffb7c79fc56cd874.camel@nvidia.com>
References: <20210905074936.15723-1-len.baker@gmx.com>
In-Reply-To: <20210905074936.15723-1-len.baker@gmx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: gmx.com; dkim=none (message not signed)
 header.d=none;gmx.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 157a8af2-0f56-4af8-3f9f-08d97c7c46d2
x-ms-traffictypediagnostic: BYAPR12MB3591:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB35914430CBF01CDCBB35568BB3A09@BYAPR12MB3591.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fm11kd7xqIR6gthGYeHN0OG7BcxKbUHWts6uxJLcE9tLXBgogIsuvu0hshymbkTG8K70qCq4Lc8BsC5EEqHZFiYe4pPaRAbh6b+hQQyQzGQGCg/h9EJKDz+RbsrzdIFYjDTtNj+L5pUEnpDndbLel7gZfSH5CH0o/T9Uxn9MUGPxL9784QaqjLscsBrz/t93KDAThRwhvCvl/qPGWcPRZjX+uCWqxuH+mIhKhv7eJehGm5hfJ0PU1duTqiw5udUxNaU32vCrfmUVa4C8xssISfRzQQrJ9EnNuesfSkdqGVtQgQn12yY3EFcZ6d/vzpvOweSC7Hnd45jeDBeeZDsmMZmqKFx0qnQfjhWwCk/KU9qX2rjLr2fgINbL3mgUOf9iKxhHKcDQqGrLvwsPAtjuu1xJ8lkO3xXSwVaJkYO+UA+g4deR6fadvP//KeyaSeYgy64pjzIIQfyOBZZiY8hjKW9xXwlHIAgrKDBQua9Vs4sSas1zKKxFFDR25w9Ndy2jMxGQXmxlPaGmrQUl+ieYOJkhxJ5Un6MVKOgczORwaly6qSNknAQNFoj6v3xwnRt1BNe62qu7+c8s5s9h9cAJmHNP1qz7Hbgw174XYIK/vrjFl+PmXtskfmpmztq9X6R0+e7GFzjrVG2ruNY7MhG5kuVBipovZRVMBHm5yzX1F4iE7ziYllM7mDnUt+0FvbRgn6ertaiHEJdaXDWHovpn9Ch6lnWb7BctSkHVjLtIqgtdjw3xv17EEkOM0x9sKTvTD4u8UQFNUdXb1uIOOXJGYasHVX8xvGSNfcdNxt8vilQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(396003)(39860400002)(966005)(66556008)(6506007)(66476007)(66446008)(316002)(64756008)(6512007)(86362001)(66946007)(38070700005)(36756003)(71200400001)(54906003)(2616005)(478600001)(110136005)(4326008)(8676002)(38100700002)(5660300002)(76116006)(6486002)(107886003)(83380400001)(26005)(186003)(122000001)(2906002)(8936002)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bFc4N3A1b2grWXRraDNNWUZrVGRzU3hQZSt5b0ErSktZSHZUVkZ6V3Fvd0Zx?=
 =?utf-8?B?R2pCWGFUSURnKzg3OWhoRDM0UzZybEVxWEROSWJnN3dESytjNVB4NFdXWnhX?=
 =?utf-8?B?TmlmVHBHY2VxMHgrQzV4N1lFSFNNWDJSU0swTUFPMjZJZ1pncjB5M1F1My90?=
 =?utf-8?B?ejVJMzJiUVZIVzdvY2FuM1JwZTZ3K3ZjZ2pxYlJHWWlGNzFlaXIwejRBbS96?=
 =?utf-8?B?OHlOYXJzUHFGMzFLV3I3UXZjcW1VK2YxbjhsK2g4aVZ3VXJBSG5IR1hDL0x6?=
 =?utf-8?B?N3NSdE5LS01zRFNZSEVHY1VxWDdlTStrUi8vMVNFNTV6Sy9TNnd2c245NEJs?=
 =?utf-8?B?Yk5oSzFUb24rTTd6K3F6Rjd4NCtBWTZSUXdMaXJDa1pzbjBtU01UMXRscmVQ?=
 =?utf-8?B?NDgzWlVaV1cvSGlCVVh1aU9hYzhVcmI0NUlNOUVueC9Ydm9DZVoxYUtNVlcw?=
 =?utf-8?B?cEFTQUlYRy9Ta291YnBTRGNvUXZtNWVZclhXNE9mazBUdkdPdnVXbUpjd29R?=
 =?utf-8?B?bVNSSmpvRWtuNC9RRURaekRCaGQ3VUl6bXZ2eDJVOTI0YXNlU3pvMXlUbGtS?=
 =?utf-8?B?b0twdEV2c0Vxak4va1RpalVCOTBaTXhQNmlIZnljczZKazdRYzFCUVc0MGpt?=
 =?utf-8?B?UW1mS2c3MFJqVStDMlNhUkgvY0krbDJlbWh3ZjVrWThPNzM2SjI5Mm1RMnJx?=
 =?utf-8?B?VGNpMmRIcmFORS9nVU5UNElISHpPMktCUGJ0MlZQa0JIeFJtd0NMamlIRHNK?=
 =?utf-8?B?cHdkVDZNNHpaZUpDWVVnYnNWa0NybnBvZzE1TzhaQ3paNDNoVzUrN1oyRWRy?=
 =?utf-8?B?dXJXcU1sbitVd3Z0ZVVKekVCTmI1ZmpqYjByQncrVEhOa0hlZjdUYkQ3bm5Q?=
 =?utf-8?B?ejFiNytPYU1KN2xNY3hPMHhvRmdqVlk5QjZ6dE0xU2tHYklhVEgvaU9qdGsz?=
 =?utf-8?B?YjZzajFTSWpGckZyRVhWc2REYnNGMkRvU0tYUWhnam85b0Yxa29yenFvUFht?=
 =?utf-8?B?blRqcHMrUkZybmVjRi9lTHMvUDZhRmZaNlJPMUx4SmExTDFKSkc2UnNNZTFQ?=
 =?utf-8?B?Y0M1cmpUTGhua3N6cnRTTE0ydnFyeWRib0RWUWRoKzk4ZzRKVm9KMktUd3d0?=
 =?utf-8?B?ZGh5RnlXOWZGRkxZU3NiSEtxR2d4Sk1FZERnODBueis4YUwxVWRjd01UNHdL?=
 =?utf-8?B?cCtXMzRHd0RmelA4RXhLMGJ0elBTZmVhTEgvTDY3YXNsZERHOThFZzl5UENV?=
 =?utf-8?B?WDNLZ3d6b1V2b1U4MkRPdElBY3dDM1lDbEV2OWFxL1ZNQW5WMkdReXJadU4z?=
 =?utf-8?B?MDNPdU1DdjR1SW9VM2FyR25HU3JIeStkQXg2WnNOY0pTdEhrRHd1bXNhbHpt?=
 =?utf-8?B?endXemVtS2t0NUV6d3Q5T2wwVlRyWlFPTGdVSGFVNlp2eTB2MUh1amR1ZzdN?=
 =?utf-8?B?MTExU3doSUQrZWFib3A4dUZ1aXNYY252Qm9pa2tGMDZEYkRaS0NwaUdqQlFJ?=
 =?utf-8?B?M3ZmaDZJWjF5VlY2NEg3K2JET01jYldEdHBVdEdVKy9WRC9VbVJlYkxEL29O?=
 =?utf-8?B?RWppVnpKWno2VGxmeXBPZ2Z1ODYyWEw2MUJ5aFFvd2V3RDNXZUgwTmVNMmE0?=
 =?utf-8?B?UXd4ZnpTTHgzQ2ZRZk0zbzNObFlFNjFUZHVBOG5uMHQ1RmJwY1RyT3B3STdm?=
 =?utf-8?B?d1R1YTBMSXdwZ3NMZGhyUndJNExOeTFUY0pxOXcrMHVaeU9yc2JONzQ4YURM?=
 =?utf-8?B?Qko2bUd5SEFkMXNQNHFrcVJGUmNhcVhvUk9BRklBUUIrYXJqMWoyMTNaUEVJ?=
 =?utf-8?B?NzlUb3pNNUlCeTVZOEdwZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B7A476B3275D44499D3D08C1A4807EF3@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 157a8af2-0f56-4af8-3f9f-08d97c7c46d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2021 21:19:05.4921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GYo3kPlq/6/k9oq0puZuO2+JAzQPq4dEA02Z5OSRZkN6AgnQ/lPJ7x8EV+yArtiV2+SsWz4sSo+tQw/elg9/3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3591
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIxLTA5LTA1IGF0IDA5OjQ5ICswMjAwLCBMZW4gQmFrZXIgd3JvdGU6DQo+IEFz
IG5vdGVkIGluIHRoZSAiRGVwcmVjYXRlZCBJbnRlcmZhY2VzLCBMYW5ndWFnZSBGZWF0dXJlcywN
Cj4gQXR0cmlidXRlcywNCj4gYW5kIENvbnZlbnRpb25zIiBkb2N1bWVudGF0aW9uIFsxXSwgc2l6
ZSBjYWxjdWxhdGlvbnMgKGVzcGVjaWFsbHkNCj4gbXVsdGlwbGljYXRpb24pIHNob3VsZCBub3Qg
YmUgcGVyZm9ybWVkIGluIG1lbW9yeSBhbGxvY2F0b3IgKG9yDQo+IHNpbWlsYXIpDQo+IGZ1bmN0
aW9uIGFyZ3VtZW50cyBkdWUgdG8gdGhlIHJpc2sgb2YgdGhlbSBvdmVyZmxvd2luZy4gVGhpcyBj
b3VsZA0KPiBsZWFkDQo+IHRvIHZhbHVlcyB3cmFwcGluZyBhcm91bmQgYW5kIGEgc21hbGxlciBh
bGxvY2F0aW9uIGJlaW5nIG1hZGUgdGhhbg0KPiB0aGUNCj4gY2FsbGVyIHdhcyBleHBlY3Rpbmcu
IFVzaW5nIHRob3NlIGFsbG9jYXRpb25zIGNvdWxkIGxlYWQgdG8gbGluZWFyDQo+IG92ZXJmbG93
cyBvZiBoZWFwIG1lbW9yeSBhbmQgb3RoZXIgbWlzYmVoYXZpb3JzLg0KPiANCj4gU28sIHJlZmFj
dG9yIHRoZSBjb2RlIGEgYml0IHRvIHVzZSB0aGUgcHVycG9zZSBzcGVjaWZpYyBrY2FsbG9jKCkN
Cj4gZnVuY3Rpb24gaW5zdGVhZCBvZiB0aGUgYXJndW1lbnQgc2l6ZSAqIGNvdW50IGluIHRoZSBr
emFsbG9jKCkNCj4gZnVuY3Rpb24uDQo+IA0KPiBbMV0NCj4gaHR0cHM6Ly93d3cua2VybmVsLm9y
Zy9kb2MvaHRtbC92NS4xNC9wcm9jZXNzL2RlcHJlY2F0ZWQuaHRtbCNvcGVuLWNvZGVkLWFyaXRo
bWV0aWMtaW4tYWxsb2NhdG9yLWFyZ3VtZW50cw0KPiANCj4gU2lnbmVkLW9mZi1ieTogTGVuIEJh
a2VyIDxsZW4uYmFrZXJAZ214LmNvbT4NCg0KYXBwbGllZCB0byBuZXQtbmV4dC1tbHg1LA0KDQpU
aGFua3MuDQo=
