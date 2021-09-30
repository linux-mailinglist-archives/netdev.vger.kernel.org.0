Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D8141E1F9
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 21:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346457AbhI3THy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 15:07:54 -0400
Received: from mail-bn8nam08on2077.outbound.protection.outlook.com ([40.107.100.77]:14177
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345849AbhI3THx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 15:07:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zcq/hDSFA90t+Wv4gvqYPK4LIZt3F0KgX2mFjO4ntWEjNpL4OiTukOb25q4XGxbRUCm9yKR4ISEkMmvalXqUnqsYszX12+zMMk/hAXalTqRXhkSZI4NOg+HU0DJcAWzvFimWBA+6l2xQYHognPWkhHxw3+AOFaHmDSNc3Se4P1TyrkkHFcpd/a0s2T5FyDGBcscCnICknDRb8VA9jroedIiNB+NPnL+aQSL4Aayhv0ktQgQvGUnmtWr8VZ/jbO6XqNpdtzOv+okveFPeIDLtm68layJoAafsqDK6OaBXzLvw3FUA5R8LE2181iIIhu6LICbIdB0cK250XTSjAF7VTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=R5zWX1StTiTooZXKioFPjYlilLCf5mJzg/77PYaUB3M=;
 b=B1EDH7rGesqMW8l0gFNAh3IU4mZpTP7x9fOED1mFcT9GzktxWR2VZ/gdWIDCycdn2xnko1fzdpjVe8H5ZqJQbYcAzVbT2H2yXpozGilf+YzKYpeBThYiWvVBO/Uf2lSP/gMey2AOi52OfVC/suZme25BmKskMYu7gwxZm3t3bnWzIR4OltZzb+4hWfzLhCD90v2o8GHwntxXJwelTSO7X60Un+nwWs+bAh5JpN4R9YIRRUqxqydOBwxr95ApPm0SJjivB9fhWbpI99kPmtgjym4lTvTGU2Sv/mIiKLEAMTZw8dLL4zhgH12AF5vAO9Kmdo6kUUKv0IUYqSHXWp60+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5zWX1StTiTooZXKioFPjYlilLCf5mJzg/77PYaUB3M=;
 b=cFcqc0R+Mj6+rg/6Meia758asoJMKhIkAPPlTSxPvymGc4Pnu4ofBOag9GHOBKsP5GWLVLpLdo0d1dTVFgYPsDdNdySPPChehSNL76VLMFYjW7rZf2KzefVeiB12eqQ6LC+TRaVIORXXE37gJuUtAR1M34Y/OYAViRAcIc/W273BGvjUtdGbccQ1iKhUBSVUSwt8MmOsq6x5uR5F+hFAUkLj3NBFAcodYCrvKHGnWic8u/BKbpVhlh/CKIkgiKysoCL4OpvD3A98XMSy1ywvGLF5f9nsnRMr6Fz3DuO24d268iQHziijoiB4ByFNyTShYaX2M0fTA41RdjtAAgA0zg==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB2661.namprd12.prod.outlook.com (2603:10b6:a03:67::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Thu, 30 Sep
 2021 19:06:08 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%6]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 19:06:08 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][net-next] net/mlx5e: Use array_size() helper
Thread-Topic: [PATCH][net-next] net/mlx5e: Use array_size() helper
Thread-Index: AQHXtLLPnG0eYG+A20Ob+qGPLWAAYqu88wyA
Date:   Thu, 30 Sep 2021 19:06:08 +0000
Message-ID: <1b274dc4be858a2af4928b5802e943bc1c915bdd.camel@nvidia.com>
References: <20210928215410.GA275646@embeddedor>
In-Reply-To: <20210928215410.GA275646@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ecc1d9fc-f6d9-4df1-0d6d-08d984455c44
x-ms-traffictypediagnostic: BYAPR12MB2661:
x-microsoft-antispam-prvs: <BYAPR12MB2661964EE5316F49233B6765B3AA9@BYAPR12MB2661.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pRVorU/4+N049aVlYH6ils7DTpeyEqpqY4FdGZKiLaZgNg8mgZku8Va0nGV9tIlAXHVuvfP7/GPrH31lSZmja6UrcZ1PN/COFZChjnmAKHbwmXgOS+eKWsMdkvXftddp7f+Btvye+dbAD/GpqQet0k+v2FkD27Bw0+eEF9ybu2GiQ/KkT4Fg1WCS5Bs+3FDF9NjCaPvJtr4tmrVwiJxaIILsRVjau/GRDjGnK0hJvEdk4q5/Fxgn5r4O/kAleylrtDK/SZSsFOwoFB/K261476TRIYbz+SwBfnjMuv49FmBUrbTB9tES7EHw3lPIHlpubc5+2ynAFTCjX/jxhuWvdU9OrvS5GlfxAKvXhJ3TGKR98E4A5z8UGdaE62BYI5ImPBGueCihuEJzbgZ56P3eG+PLo1VuqM4XJDEoGnIpNXOEGA+EFG9OkIHhq953HF76R5bCZSpQvoPA570ATohLX44lAmvIHYgPUF0GHfB3Ub1NpYjhignHEnwgZrdxnRvYwDoFPdOLVrV7QTWGZUW3OezE/TLW98GjOzVQ/2KSKVWgn863oQlLb9JqOlL0xGr0Fcihv6g/j1gMDNFF+vMmjxnfxFJA7Rl/mSZyqRl7jhf6FSyxENhfhQ8TmSZMbET9VYcOc5FlLYr5rQzrL7OQKlY64mHEHb3pbP+DpLEXwoB2Eg1hkNNLBi0sENuuQWeifkn+sCauJHE+hFOCF6WGdN6v2VnAus9GXlRCNweD5Tm2yQihdAwQmcYwkh4QqyzOMb2+iW17L/vh4PNiZRxLEBNmc0+6P/Qv2NgF0xI0jt4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(122000001)(66446008)(66556008)(64756008)(66476007)(66946007)(6512007)(4326008)(6506007)(186003)(71200400001)(508600001)(966005)(38100700002)(26005)(38070700005)(316002)(558084003)(54906003)(110136005)(36756003)(86362001)(5660300002)(6486002)(8676002)(2616005)(2906002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWU3a1FseTZNcEJVK2p1bUpNMFl6NktYZGgvZlU1UVl3Q0wwVTErQzJuK0ds?=
 =?utf-8?B?VWpMcXpXdjVnaWdJYWk5bHU4d3BSMTV4UExKMWhxNjlJVnU4SGZCUkVWZzl4?=
 =?utf-8?B?STJ1ZEgvc01pdU1FMTZ2bTlOUzlVZEI4cGNUa0NwRjZzN3NGTHRJQThFbUkx?=
 =?utf-8?B?M3hhRTRzcXBQcEZOTlZIdnorRlJFS0hqR0pPRnQ0bmx4L0ZwV2owU3Nud2lk?=
 =?utf-8?B?YWVKRjBJWlMybTl3d20zVmNldVd0N0p3eGFQcU9NR3NRejQvT3haYXlvM1Nu?=
 =?utf-8?B?a0paSWJ3YkNCZHZzRG5nNm1nQnNmQ1ppZitzQU4wMjEwVHFTVjFFeklUSmN1?=
 =?utf-8?B?QVBrZmZER2U1bHRiMHFmYnJXd1l0YkFXOXJsRlNMK1ozaGl1bjVFOEVhZGd2?=
 =?utf-8?B?VmRBS1FFbHNEUEdiZzdPaGxvOGh5WUp5dFFWOUo5bktNRDVWdDlwYUl6cSti?=
 =?utf-8?B?SkNocVpVdEd4OHliUWhXY1hKOFRwak9uQ0VqS2NMN3lXS1pvRm5La2F3cVp6?=
 =?utf-8?B?L0VJSVIxRmN3QVdEM1hhWU1uT3IyTnBxOFd5Z1ZJS0dKWEZ6ZXhqbHpwK0dq?=
 =?utf-8?B?RWZaUkNUdmZCeDlpZnEyYWZTU2lXZ2JXbUNWWlZzQys4UmJ3VEtuRWc5UTh3?=
 =?utf-8?B?UHQwa3pjUmE4WDVla2FVK0xnOEFRMWFKVysvYmRMWGNQZWV4ZkxiMTM0dExW?=
 =?utf-8?B?NUpDZmdHbUkreVJURHNjNnRKVndycDlaSHpvRUFwNmRKdGFINkdrNFlIMWx6?=
 =?utf-8?B?clk1ajgvV1hpRE5PZ1R6OTA3Nk81WVRvU04wc3FZZ2VGY3E2YnRjK0ljT25D?=
 =?utf-8?B?bkdPU0hmQzJaUVF1cjRjNDM2Y3o2amlia1pEY0J3TWdNRVBTay80VjVDZ3ow?=
 =?utf-8?B?aHgvU0s0akRYemZpbW1mTi9QdXl1TTBXN1JxdWFFbHBPUU95ejJ1cmY4c1lS?=
 =?utf-8?B?a3Z2cUhyY0JnM2dITHNLMTJFNEw5cWJRa2RtWVZnWnNzUGw3T1ZTTW5DSnpJ?=
 =?utf-8?B?YjhOOGl1R093eHg1M1U2Y0xQSWM5dWF6UUF3cnNJWkFPZ1lET2duVHlFVG5i?=
 =?utf-8?B?RytreFhkOUZMVUlPOHM4cGF5VnBURWM3cmpPbVpoVUM0OWljUzhVb1U0NWp5?=
 =?utf-8?B?eDhrVmNENUdKZFk3bjkwM0pRVGl4V2pEcEJtZjNaTGNMc2crbnZpeFhZcTZW?=
 =?utf-8?B?Zk11cjZ5R2xGVE1TWjVwL1lEQ3pLbzUwZGszd09ZZ3drZGdta0tvRTgrNmRS?=
 =?utf-8?B?WUJEd3JBZ3lZeGQxOEdwQlNOYlYzcnI5cFV5N3pFVHRBNGdUd3c4UWc2d3d4?=
 =?utf-8?B?TGhzNldXbEpCbXkxUnFobzJ1UkZRbVpMaEEzOWRtZXRZamc5ZDNHTCtqcWhM?=
 =?utf-8?B?WXQ2NzdwbHQwcWF2WWhWVE84d1dqWFJNblZ3RnE5ZmZ2RW5TeWpSV2F4SkdG?=
 =?utf-8?B?TUJnVkR6QzZUVHcxRXJwREZiKzRUT1VXL2tTa0ZGQWs2UDI5bGtRRnRwMFJi?=
 =?utf-8?B?THhTbURUNHZTbjRjOHgxei9NM1hzdm9zYjdySHJUT3ZzMDlLTFhZVzdDU1Nn?=
 =?utf-8?B?U2dMN3RHTDQ1T3lVVmhZeWtzS3JyYk45WGxzeXNBNlNZeGl0U0tKWkp0M1Bt?=
 =?utf-8?B?VXlnK3VoZlJRMHJqeTdHeDhHQ1pjVG92dU1WNEtla2RuZ0NOM1dpSlRlM1hh?=
 =?utf-8?B?VHhhMjFJOUlFZSswR3NPQVN4NXJuVFU0STZhcnczK3hTWFh5cTdpRUlZVmJC?=
 =?utf-8?B?RjFJa1hrOTRtM2x1Sk0xcG1ndUtrcmJLNFlCUEhiODA5d2NZb2NsY3NRYWcw?=
 =?utf-8?B?WkhlMXFzNkZ1VVlNamNoUT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB38D1CED1A2CF40A8D0B2C2F0D25429@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecc1d9fc-f6d9-4df1-0d6d-08d984455c44
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 19:06:08.4403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TGkMTDUdfZ9GPtviZ7O3B9k8V2/TkpIpHKrW4S03DiwviCOVgz/cGZchAKdurm98msOnQOYEAJJUzQrOHet9eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2661
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTA5LTI4IGF0IDE2OjU0IC0wNTAwLCBHdXN0YXZvIEEuIFIuIFNpbHZhIHdy
b3RlOg0KPiBVc2UgYXJyYXlfc2l6ZSgpIGhlbHBlciB0byBhaWQgaW4gMi1mYWN0b3IgYWxsb2Nh
dGlvbiBpbnN0YW5jZXMuDQo+IA0KPiBMaW5rOiBodHRwczovL2dpdGh1Yi5jb20vS1NQUC9saW51
eC9pc3N1ZXMvMTYwDQo+IFNpZ25lZC1vZmYtYnk6IEd1c3Rhdm8gQS4gUi4gU2lsdmEgPGd1c3Rh
dm9hcnNAa2VybmVsLm9yZz4NCj4gDQoNCmFwcGxpZWQgdG8gbmV0LW5leHQtbWx4NQ0KDQo=
