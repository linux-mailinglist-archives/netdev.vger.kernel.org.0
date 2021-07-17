Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EAF3CC3DE
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 16:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbhGQOqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 10:46:30 -0400
Received: from mail-dm6nam12on2094.outbound.protection.outlook.com ([40.107.243.94]:19041
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234234AbhGQOq2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Jul 2021 10:46:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VgHPyn/FIEh2PdLm8+/AgZxsXn3HlQudbBL8PiuzvOQ919gvKdWE+A8zRMqiA23lR2aPYjFinG9tZQjsl4ovZ4PMbHxYx6qEisU7sWGuY4N2IWy3rOcoY1Puyc1Ldltwc0GSFi+vXhibn6NjMP1c+TOuwBYGCK3Cth5vEA36U/IdfNcpM+kwtoOVsfD23TmGzlimLJLYr9HwOp1oegaBOfz7vtMChaaBkd0RQKQCC5GTaj2AMN+srV4URVulHQdny31K2IAZ1mh7o4yoDpP1/taG2a+fMiEC8rLqzuw0Mb5zmAeScCxIUytDCnR3RSerXq2a+TTwiULfecWRIvskbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fT/AFhhuouFBhUfuId6iq8uWY9zSu78SXfVJFfcbKSE=;
 b=oNfyWO8NaZdhmkKSgTTx6sJzNMlIifPkotqQtZcY20uoKifBH9oNeIhCj1mfE+adRvVrBJLoxXA/1R63lQ7FnVzpdKYGCz2fLWVu11h/kGI6ScuxWSKYWQZ1t5T+5avrZp40R3YvvzI84TZQFykmiggo1UemrOPYUDmVvZEZTPEGK7DAWY/qhym9IOIBU0pc1e/mEwdlQUK+OZeSjiCRoJHnRltQfkqG+PJNUcr7zCxnI7HXCiM9fXYsguA800iYu/4/imzPVff+LhMBXLU1RoZsV1IYRRCu48RamKYnNXNg/T6RNycVzwAuW7IMwpjSLy98bnCPEbg3wTtLMzM+0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fT/AFhhuouFBhUfuId6iq8uWY9zSu78SXfVJFfcbKSE=;
 b=S5apJlE3W9HWxxGKbQXUlioQVJe3/0PZ2Ia0c7m/CbsfkrYo6+8+zu2+4Sn/6XetXa8iIxZFBMSVZ4gPBHcoiQizxAxi6P/qMlq1U5yfuGBXDa6fwzfcUJqYwO6tqS45rwQzyk5Q2xWZZNrOxnu22VHuh57+0eOfNtgMonoqVGM=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by CH0PR13MB4585.namprd13.prod.outlook.com (2603:10b6:610:cb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.8; Sat, 17 Jul
 2021 14:43:26 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::f427:dd84:789e:6c57]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::f427:dd84:789e:6c57%4]) with mapi id 15.20.4352.017; Sat, 17 Jul 2021
 14:43:26 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "tanxin.ctf@gmail.com" <tanxin.ctf@gmail.com>,
        "xiyuyang19@fudan.edu.cn" <xiyuyang19@fudan.edu.cn>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kolga@netapp.com" <kolga@netapp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
CC:     "yuanxzhang@fudan.edu.cn" <yuanxzhang@fudan.edu.cn>
Subject: Re: [PATCH] SUNRPC: Convert from atomic_t to refcount_t on
 rpc_clnt->cl_count
Thread-Topic: [PATCH] SUNRPC: Convert from atomic_t to refcount_t on
 rpc_clnt->cl_count
Thread-Index: AQHXevVKRkvfVoso5keyqPOQsgVX3atHPkeA
Date:   Sat, 17 Jul 2021 14:43:26 +0000
Message-ID: <1f12b3569565fa8590b45cc2fbe7c176ca7c5184.camel@hammerspace.com>
References: <1626517112-42831-1-git-send-email-xiyuyang19@fudan.edu.cn>
In-Reply-To: <1626517112-42831-1-git-send-email-xiyuyang19@fudan.edu.cn>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 171a62d5-98be-495c-62a2-08d949313c4a
x-ms-traffictypediagnostic: CH0PR13MB4585:
x-microsoft-antispam-prvs: <CH0PR13MB4585AA22076EA0CEDD2E4648B8109@CH0PR13MB4585.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a7gn0y8E+jEiik5qXPvKXLzdXdHMH0zm0U6wjfQOJ8FJSNej0Vbbuykq6rWxZupuByPE7/is07RGOxJn1FlP1drViA4jCgclYJysAV3t3/hvpVPl9IQMgj8hjOuclJZpPLl5LB8pvFm4H23899Gob4kVwNOnTtpN+sh03MsuaE2t6PTTAxlkNfwE3LqEJIclW9lid+IqHvpSeuWzVCF6xDqJWNcKUx+/daTLaOjgBsaJl/el3Fz7OnDsKREeqr7NdkOFcGxzse91TW5fDnRAy/mg7i0RI0y3iKqKZR50thxDwZ1U6kXBGFzXlnwu8B1aI5Qw/8j0weHMInSxRA2CbFANe95JZacnOpJWvsSuctvwUYAW0HMrHJjyRI/9ykTFFEJ66fKrXbePn7XYtfnjop/TfCA0NEhMoizO0K2ubxAAmESe0gFBihfwEMF+aKwXh6P1WIl1xw5EoqhpHL4EKnuwF8OaCUnh8FQ23f0cJqg0zbakAWQfNpGnbR5vevY9SBiRmSPi3j70FI006z1ZAHBunmvcTIGRuao0c9ZP/saZ0Ipv52cNegw3UFkzZA1d/beT8eTrqQ9G1WG0giho2tso6t/zGSEqtgcZftKpZSHlkzmVpfvppVD9sgrfakAPsxeMAQ9tZh844gpmfvTgBM/FBxKI5zsVKIOGtG84TPr5leAbsoMcB3HQqZHaaSttzJm7SILtd5JQbi1+/A22Xa8y4mxr0RJF9vSCq86eqoI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4744005)(110136005)(921005)(4326008)(86362001)(5660300002)(7416002)(316002)(122000001)(2906002)(66946007)(66446008)(64756008)(66556008)(26005)(76116006)(66476007)(38100700002)(6486002)(8676002)(2616005)(36756003)(6512007)(8936002)(186003)(508600001)(6506007)(71200400001)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z2VFVWZuQ0pPaDBVYmFGOXVNVmhjMVFXbUJVcXQxcnhuMXJsa0xBTmgwdzJL?=
 =?utf-8?B?eXhmckxMMEo4MFZ6V2RTcFlNaGVYK0h2eTVNRTc2MDgySENMOXBZYmx0NEE4?=
 =?utf-8?B?M3VoNCsvYzh1WEdFcTZUQ3lGbW5rZzhGTTl4U2ZwNjBMTFF6SzhxekpZbWhw?=
 =?utf-8?B?ZnV1TEZ2UUpCdmlCeUUvdTRFaGhHSGJZOVk2SXNZbHV1L1Y0ZlJMQ1hhTy9K?=
 =?utf-8?B?cklpdHJQNXNhNkFmMmFZbFUyeHI2RWNHT3IxOEJmWWV1L2E0T0t6WDVRaWwy?=
 =?utf-8?B?bGkva0ovOGYrNTkyQ3lMNmJJbnVyR1NkY0lUN3M0NXprQ3kvcy9qSE9lZ3lQ?=
 =?utf-8?B?bE1HTjFRSDdCVlNDQjVIU2FCZmhZNUxCT3AwMTlPZDI1TThXUVFkcjQwRFVH?=
 =?utf-8?B?TGk3bWczQWR2cGdPcE1jQURrdzByRk1GR2ZsVUJ5dDQyQXlBUXpQRHdXTzN6?=
 =?utf-8?B?d1pzcE40cGtRUC9XM0I0NWxiZ08rN2k3L25UWjhhc05JcUZxY1czbi8zck54?=
 =?utf-8?B?SkRqUEF6NmlLZTF4R0k2UDNLZmNhajh5bTM4dUtVcDFpNzF3R2QvS0sxL01r?=
 =?utf-8?B?eU5Ja2FKQ1A2VDhDdkU1RTFyVzNvVDJvRDZGdFJJVDFLQ3FWUVlrd3VkUEVk?=
 =?utf-8?B?c2hkWmVRUFNGWHJ5VXlqNGNxb0x2S3lMUUVVTjZLR0ZjcUpZNjRieHd0clkz?=
 =?utf-8?B?aFVuNUFpeSsxTDdyZVNVVWJDYTZkclNhak9NM01kNE5pU1ZFVldSUnF2d2w2?=
 =?utf-8?B?dDZHaWpKK1Z1TjE4TVNiakI0QWJnSjRyclZMTGFaYmZnTGVIUExNRFowRFhq?=
 =?utf-8?B?Wkw1bHk5c3YyQXpuV2M2am9ZdTg1NER0Y2MvSDVjWVRwUDRtUERJaXNXSG44?=
 =?utf-8?B?SVREYWF5MmI1U1liRWVVZDMyM3dUeThVejFGOXpXaFE4Z0l3WXVTQlNUYUNt?=
 =?utf-8?B?dDdnVFpJd09BTCtPcTJ1UzdNWWhOQzRveWlIZHJWZllTb2ZpSlBPUENEV0F0?=
 =?utf-8?B?RlB2RjZKQld0Z3JMMHBvZy9kQ3FONUN6K0owNUVMTjMyRS9ZWlBFcEVjcVpB?=
 =?utf-8?B?UG1FdDE2Yyt3N29mNVU3ejJMUDhpRjFRVGdZUTZqVDJURE9xNVgyYVhPYWtG?=
 =?utf-8?B?eExpMVBVcTRrM3R4Q1YrNk1NR1BkVlRVekhqOGwzK1ozL0F0S2VtM3FEYUt4?=
 =?utf-8?B?QXd5b3FIWnNVa3p2NVlhUUdvVFNlQ0x0Q045Z0N4Uzd1UnE4aDR1dlZCTlJl?=
 =?utf-8?B?NEVKSE1zZU16eEtkcExDYkd3b2g2U2dwRE5xWkhpaWc5NTNtaGhOSlJBUDVV?=
 =?utf-8?B?eW5qNGp6RFhIRWdVUjNSM1F5b2ZkNUVLMjJuNUFvUFMxRUFIRFZNbGI5TE1C?=
 =?utf-8?B?K3laR0k1YlVQVC9mNGh3VUNCV0xLRVcvNGhrVlp2eUEvYXRqYVgvbnEzVEwy?=
 =?utf-8?B?dGw2VUFrMHI0ME5iS2pNSm5OY2toUHI3U1ZHd1lPa1BwYVBaenJmbmZYTUQv?=
 =?utf-8?B?ZTV6eGIxbndDMEUyOFd6enVyeHFVSmFWUUtRZUpMNlJNWFRNSW44Z0lPT2xt?=
 =?utf-8?B?NTJmSVBkbnFTb1hTQkZDUDFZRUphUjJtU3E0aENZSXdRYU15TWdvWG1NV3pt?=
 =?utf-8?B?RmhiRWJuSzdkRFJnUDFINFV2QWpFcW5LcTVRKy9haDMzMFdwVkxvditYT3dY?=
 =?utf-8?B?S2R6QkFFT1BEWHJZKzZtUG5uYUN1MlRzYTQrTlBXM09pMzZHcjJ4d1ZHdXJp?=
 =?utf-8?Q?x30DDen+M9DhPKgW0005RFU+9fiVYhfbDwb8OcI?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A8B624C64AB9044BAB08926162329B41@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 171a62d5-98be-495c-62a2-08d949313c4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2021 14:43:26.0869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gkW07sNvkWxmYTf1eWtjQ/U0bhEm6gXYtSlKN04bHVjr9qEmZRA//Gu10O4H3kgtATapqHSMsnAlgz6oMFp3xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4585
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIxLTA3LTE3IGF0IDE4OjE4ICswODAwLCBYaXl1IFlhbmcgd3JvdGU6DQo+IHJl
ZmNvdW50X3QgdHlwZSBhbmQgY29ycmVzcG9uZGluZyBBUEkgY2FuIHByb3RlY3QgcmVmY291bnRl
cnMgZnJvbQ0KPiBhY2NpZGVudGFsIHVuZGVyZmxvdyBhbmQgb3ZlcmZsb3cgYW5kIGZ1cnRoZXIg
dXNlLWFmdGVyLWZyZWUNCj4gc2l0dWF0aW9ucy4NCj4gDQoNCkhhdmUgeW91IHRlc3RlZCB0aGlz
IHBhdGNoPyBBcyBmYXIgYXMgSSByZW1lbWJlciwgdGhlIHJlYXNvbiB3aHkgd2UNCm5ldmVyIGNv
bnZlcnRlZCBpcyB0aGF0IHJlZmNvdW50X2luYygpIGdldHMgdXBzZXQgYW5kIFdBUk5zIHdoZW4g
eW91DQpidW1wIGEgemVybyByZWZjb3VudCwgbGlrZSB3ZSBkbyB2ZXJ5IG11Y2ggb24gcHVycG9z
ZSBpbg0KcnBjX2ZyZWVfYXV0aCgpLiBJcyB0aGF0IG5vIGxvbmdlciB0aGUgY2FzZT8NCg0KDQot
LSANClRyb25kIE15a2xlYnVzdA0KTGludXggTkZTIGNsaWVudCBtYWludGFpbmVyLCBIYW1tZXJz
cGFjZQ0KdHJvbmQubXlrbGVidXN0QGhhbW1lcnNwYWNlLmNvbQ0KDQoNCg==
