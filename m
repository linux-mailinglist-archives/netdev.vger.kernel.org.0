Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC2843DC57
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 09:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhJ1Huq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 03:50:46 -0400
Received: from mail-dm6nam10on2072.outbound.protection.outlook.com ([40.107.93.72]:44512
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229626AbhJ1Hup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 03:50:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPp8XoQwqgx0+vcNYK3TVwyq7XsrjfG3xa7mHPCh00FHbsMU3zt1SeR+LQly1x18kuzRp8wQ3FHSJ95lmgmbzOq5TkpGrWHTwafNDdT/2+W7AyGXv7tCYjAaF4+3Tk8Q+LPdmbjZkUGKYuNVMDjE+g1vo1NDN7UixSxl6JZ0IGukgZKI59GdOKzf/NdWRG5vdbAkaoBWZb4SBw9TPzJT9/0M32xr/CzqbjMEZNwfzZMooK18Awwsn8hmKljVbobCDwPWwfAUabHpTR5zvegDDqJwRwOvYGApveGIV/b+U+pSC2woKoiToTxTbHRyjxyMB6yvh5074p9wtPf3uM2UlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y4nDwsRlv/EqLlWxDKPAKdU77TdVL/E4X+obdJ8ckJc=;
 b=hus/8egK+S7rnZUYsetaniLbmxiHjV2SjVEZgpHijKOdlo+dG3wxCZxIVmcmOReYrv+tuEgKWVRjA5VADhQ49vL3WZC2CJDqqOyfqL0VepLefO+BNz6wzXz9RHgHXPJPdlfi/j7uWIYSF98pGueYW/aX4pAnT6R5QjrIzosC36I8tYYz69+vtResI3gb4ysLB07OaxE2NpQ3KKUyIWw1hOuO9ChOg3c6IMQG2EnHVXs+4bTW8alUQEvM3UwsZx9FCYzB5Jf4Ypg/+LAYlh4JfjEN/3y9rokDjcuPt3o9i6b8K/YcFVYgTRkawFUPC2huh1Vll4UsZMCQcV1mibM3QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y4nDwsRlv/EqLlWxDKPAKdU77TdVL/E4X+obdJ8ckJc=;
 b=OAe34YrohPERS2dw+fgNg0avYHuOYWMtHnrw48ySsIDK7d7YSHw0fNN2yXA2qSp/Nyzt1dgC+yDSQf2DocKhtwTiPcdtvVqVxw1lvB4z/zM99ciWKRGEMqW4856KZRs+8Tf+EHOOXKavMeEw1wFvly1vdba55GQxAG+/dYVmibRRhDJk4BTpKhxZiejoBtMt+vXh+nu9lD4Ak673I0i+XzYBHvoc4uWJN/iyalGtJKDCqhnn2dBiMM89Vdg3FiZIssQwrREDhnpCiix4fB0DkIO2q4VelmeNCMjGVGftAaVHzAyXGYjPigDZQnXbPule5j1eUb60WssTW/vWrIBzlg==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3525.namprd12.prod.outlook.com (2603:10b6:a03:13b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Thu, 28 Oct
 2021 07:48:17 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%6]) with mapi id 15.20.4649.015; Thu, 28 Oct 2021
 07:48:16 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>
CC:     Ben Ben Ishay <benishay@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: linux-next: manual merge of the net-next tree with the rdma tree
Thread-Topic: linux-next: manual merge of the net-next tree with the rdma tree
Thread-Index: AQHXy5audcCoEmxRNEOFWkvsdzNr1qvoCScA
Date:   Thu, 28 Oct 2021 07:48:16 +0000
Message-ID: <bc7ba7b44e704b6316085949693e250ef0866a65.camel@nvidia.com>
References: <20211028115637.1ed0ba86@canb.auug.org.au>
In-Reply-To: <20211028115637.1ed0ba86@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none
 header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d82d92c5-4812-46f7-3ffa-08d999e74dab
x-ms-traffictypediagnostic: BYAPR12MB3525:
x-microsoft-antispam-prvs: <BYAPR12MB3525FE3A3B4E4B6B826ADA39B3869@BYAPR12MB3525.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wle3hrhR/DeOVCYvLgUGYmBFPVHnQVHYcYG2L+irtwOdyXfp/T4myynMURlj8pR+Rfh1ipuJwkCfKGqP/tytCvvkKPD+ze1IFJm2XvjOwN6lsGQL3asZj/FHkp7zoGZs9fbduAUpb1YfhvPeNvZhiychViyKb+NSAtvm/mphvrPDQ2P3Q6BVeexA0ZQSTApoZAUuOT0Q7GvbH5puPPgS6JHGf5Sg9isbhUY0gZ7JHzAwKIUzrS0Z+bJTvr40thnOIkrFoTEV89qPWG1OQkikhep7UG9pk8RJZS06QFwSogTXbiKQKfmQein5mOgHsw3zK770hVcz/W9lhKV2G8dAUx4tnrBG7zjF7WeeqW0p4zlKHAgh1DmeAm6e89yb+Cyu3QIw/kua8Ud+KWJLddXzNt2dmbssycIe0iN9CdcLVtx5EVKMcOcX3QtdRNw3EK8C0aCOjYTM4CdMgFwGH18VImGa3xFRXpcV3fETQc4UlmRLxIfdOUxYoE0rGXK7tJ7StyY3ixBzDKgy37glEITJIArNuGCiNCYdxygdL96pDu0vfTsMabdAA15FgqxAjxxmPGStOpjMPoN4nyJ0ACjJP1bmVNJcIbXWlpPFb+27xhUTonTzm5Qu57LspNuNwBwtccmjf4c0KVqJ7bIrzhNW2lYZ9NgOMd39rUGKU+D/5Kw/xMeCMdb9NY7OW2tIJ2zbAE8/4xeB5MQEY33wi1penAZZ/y5L68ZncEnVxzmk3OZF3AXfubjPi/baYd9uMPC+H1kDWZ+n3dEGUfiNKCItPDAF8AglyeFqbXfT+IZi1ZA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(86362001)(5660300002)(4744005)(8676002)(6486002)(4326008)(316002)(4001150100001)(2906002)(36756003)(66476007)(76116006)(38100700002)(54906003)(6506007)(38070700005)(66946007)(64756008)(110136005)(186003)(66556008)(122000001)(66446008)(8936002)(71200400001)(2616005)(6512007)(966005)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGNQS1k5SmlCMzdVSm5WNTV3dmY5bmNEVTJzTkZqeFQzRm1PMHlQQ3ZvY29G?=
 =?utf-8?B?Q2lKMm5NZWhJKzl6c3BIdlZEU00xYmU3cDJpOVdvUDFYMnJtUmJpY3pmQ1pD?=
 =?utf-8?B?WndudlJxSE0wVDlzOTgvMlZvSjVuT0VoKzV6bWpFb0pIcU82ak5PVmNIL2J6?=
 =?utf-8?B?dVJ4eHBVM3MvOFRqU29tM0xMbU1Vb0F6dXdzOGNMMkx3a203MFFGWnRobGx2?=
 =?utf-8?B?Z3BvOG9kdFQ3ZE1Bcm5CQjl5ME11b0Nza2J1MEtUN1ZvQUVONDN0bUxBU0Zn?=
 =?utf-8?B?ekdSRkM1TXZDSzhabnNsbDdTNFNvdjRxbmU4and0amZSdWZiYytqaEdlNmd0?=
 =?utf-8?B?Z2ZRbXh2OFp3algyeXpPUEVrOUd6WVFsSThYSU1Wa2RmUGdnMkpZT05JdTFq?=
 =?utf-8?B?em1SLzk1VnUxMktPWVFiUmZxZk1Oc2F4L1dwaG9nek5yTHFWRXBpdjNmaDRU?=
 =?utf-8?B?ZGxTQldoNUk4TDVxN2ExYTU2MFd6bGV4eUQ5bWtoVmp1V1Z3aGVyZ0ZOWml3?=
 =?utf-8?B?WGNKbUVCU0IzajNTUzBleUFWYlJmM2JCSElNT2N2TWpScnZMZjJDTDYrb3Bx?=
 =?utf-8?B?TzNHL3hSOHh4cHplaWZDSS9Uc3ZQVFNxcFhwM0prMTc2KzdvTjZkMmJ5N0tP?=
 =?utf-8?B?U3RpTktQS292NCsvV2kxbEdaNlRLT1hkc3pwZmFYQkFhcnQvajRudUFWT1NP?=
 =?utf-8?B?eC9VV2JmOXpOditMbXBidGttZHdiMmR1U2lxcmJCV3ZpajRzTVJweVZCbHN0?=
 =?utf-8?B?V0tyaEk0VzVUaDcyemgyUWRJTzhEdXhZeGtsRllpdlJtZlFBZS9xTXFMaWdI?=
 =?utf-8?B?Wk9RVFAwcmtVMkdPVlFFM1BnekxKNjJnNDU4cTJrU3dJaU1VUG9PVUZtN1RZ?=
 =?utf-8?B?a3V6V0pFNy90NGFVaW43c3hEOW01V2hhT0ZkSG51VXhNRGwwbXZsSW56V0tP?=
 =?utf-8?B?WWNQRm1IdmtJNzJYckp2emdSa2FmMlFyZC9UbGM5TnFYQ2hmN2x1SDhzU3pF?=
 =?utf-8?B?ZmNTU0tsTjFPazRYVWd2REFaZkpGdmZnUzgwN25zTXh1dGtrYkc4NEVybjk3?=
 =?utf-8?B?YjdXTnVRWC9kcWtzNzErT2N0Yy9PR3R3QVNaZ1N3a2dxM0hjeDl5alcvSis0?=
 =?utf-8?B?cGlPZGhmWmIyU28rR1JuN1dJQjdMeVFZT2FxMTJ3K2EwWHZKYXNuMmNtM3hB?=
 =?utf-8?B?blNBUnFubnNLYThkRHJjTnphWE1UenZHdmNoeHhaNUZ3MEVBM1dsVlJJL0E1?=
 =?utf-8?B?SzVZZ2Y0SjVEcFR6RkdDb1U0NDVxSGo2eTQvWk5kTkZ2WnNTOTBzK2V5dXhP?=
 =?utf-8?B?a3RSM2c2c2xyQ3pSQnpXRmUxWGlPM0ZYa2FES0lqYUp5NGdqVWpyRmgrYnhS?=
 =?utf-8?B?dVVHVmVGL3FuV1lEOTlNaVdxN1YvL3d2SHJWQXZwZ25wbmhrM1Yvb3dqbmZE?=
 =?utf-8?B?YXl0MWcyTXF2UGNKUnJMd0JOaGVLNDV1M0h3T2pOTlJWWDJxM0xNb2RjZVY2?=
 =?utf-8?B?ckZBNUdYQ2UyZnBwR1JnYnNDTHZmeXhlY3VqK1JTd3hBcmQ1TWtrSmx2NnV1?=
 =?utf-8?B?czMzRXFhd0dLNnhZRldwa0hQUEg3a1hpQlV3OGhpeFM3Uld2UmlOZzQ1WmJi?=
 =?utf-8?B?bW1CeWVOL3NQTnJQUFhlUVQ5T3JqQ3NVb3puS3ZkVEZNYVFQdGVvdzRyQmhl?=
 =?utf-8?B?ajJPcHRXcUlnelIzK2pnRXBJTnVXWmJoU0hjbEt3dFd6ZGx1Qk0ySmsxSms1?=
 =?utf-8?B?VUNTOFhxeTRuVS9MZUUwUUZLK3RJSHBYQ0trVlN2SjJoWHM2eC93c28wcnk0?=
 =?utf-8?B?QzBRYUhSMUNmQ0tSOStEZkNyQXV5bmV6eVlqV3FwMnFicm1ESEF1S1JtUFdD?=
 =?utf-8?B?ZFFmcXJRQXgxRURwRkI1a2dOWkkwRnZFdnRDV0xmTzFQTjRvU2d4bXBodGVx?=
 =?utf-8?B?RUo3eVBGMzlRMkZGbkNXcDZBMGd6QUxYdG9sdTh2NVNRNnA4UUt0QmZLY28r?=
 =?utf-8?B?UXpteWdZZ3hLZnhrU2JzMVN5NnkyQzhpVHlvTlR4dWNpbjA5N1Z0bjBTamI2?=
 =?utf-8?B?Z0lYVGVva1pucngwZW12OS9EMDFZMEhWUWNwdWZGMHVtUzRTZXM5NjhtVVJV?=
 =?utf-8?B?S0NGaStLQ1Qxb3VHeXFnWHFzVEc2N0xRYjJmcEJ1Q0dvS2E1SEJ5TlpTVThQ?=
 =?utf-8?Q?LYRwamN+NjnGWrzMw5U5UFc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <02D42D3DA8CF2948B1E07FA0744E1686@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d82d92c5-4812-46f7-3ffa-08d999e74dab
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2021 07:48:16.8263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IXeHV0eqNa26EfDnkoJLP2CfbhSdZ1hjOJ6KdiL6Lneqr4gRSBX4nJteLvjO3qLyDUE8PwQTSejT8bipxWwM0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3525
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTEwLTI4IGF0IDExOjU2ICsxMTAwLCBTdGVwaGVuIFJvdGh3ZWxsIHdyb3Rl
Og0KPiBIaSBhbGwsDQo+IA0KPiBUb2RheSdzIGxpbnV4LW5leHQgbWVyZ2Ugb2YgdGhlIG5ldC1u
ZXh0IHRyZWUgZ290IGEgY29uZmxpY3QgaW46DQo+IA0KPiDCoCBkcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQo+IA0KPiBiZXR3ZWVuIGNvbW1pdDoNCj4g
DQo+IMKgIDgzZmVjM2YxMmE1OSAoIlJETUEvbWx4NTogUmVwbGFjZSBzdHJ1Y3QgbWx4NV9jb3Jl
X21rZXkgYnkgdTMyIGtleSIpDQo+IA0KPiBmcm9tIHRoZSByZG1hIHRyZWUgYW5kIGNvbW1pdDoN
Cj4gDQo+IMKgIGU1Y2E4ZmIwOGFiMiAoIm5ldC9tbHg1ZTogQWRkIGNvbnRyb2wgcGF0aCBmb3Ig
U0hBTVBPIGZlYXR1cmUiKQ0KPiANCj4gZnJvbSB0aGUgbmV0LW5leHQgdHJlZS4NCj4gDQo+IEkg
Zml4ZWQgaXQgdXAgKHNlZSBiZWxvdykgYW5kIGNhbiBjYXJyeSB0aGUgZml4IGFzIG5lY2Vzc2Fy
eS4gVGhpcw0KPiBpcyBub3cgZml4ZWQgYXMgZmFyIGFzIGxpbnV4LW5leHQgaXMgY29uY2VybmVk
LCBidXQgYW55IG5vbiB0cml2aWFsDQo+IGNvbmZsaWN0cyBzaG91bGQgYmUgbWVudGlvbmVkIHRv
IHlvdXIgdXBzdHJlYW0gbWFpbnRhaW5lciB3aGVuIHlvdXINCj4gdHJlZQ0KPiBpcyBzdWJtaXR0
ZWQgZm9yIG1lcmdpbmcuwqAgWW91IG1heSBhbHNvIHdhbnQgdG8gY29uc2lkZXIgY29vcGVyYXRp
bmcNCj4gd2l0aCB0aGUgbWFpbnRhaW5lciBvZiB0aGUgY29uZmxpY3RpbmcgdHJlZSB0byBtaW5p
bWlzZSBhbnkNCj4gcGFydGljdWxhcmx5DQo+IGNvbXBsZXggY29uZmxpY3RzLg0KPiANCg0KDQpB
IG1lcmdlIGNvbmZsaWN0IHJlc29sdXRpb24gcHIgd2FzIGFscmVhZHkgc2VudCB0byBuZXQtbmV4
dCwNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8yMDIxMTAyODA1MjEwNC4xMDcxNjcw
LTEtc2FlZWRAa2VybmVsLm9yZy9ULyN1DQoNCg==
