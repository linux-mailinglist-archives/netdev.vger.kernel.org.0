Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476074B9CFF
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 11:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239154AbiBQK0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 05:26:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233037AbiBQK0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 05:26:15 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2120.outbound.protection.outlook.com [40.107.236.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858E4279085;
        Thu, 17 Feb 2022 02:26:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kXxvt9vCcukE+iiFty68tnhPGO0OoweZRLm3mxIGGupHgBMUFKNJrvR2gqmZR274WeEqlowSIm2MoBae0uhyO9BBXxYubHHuDX6ogfoC/DHdvBq+t8K5tkT9Z9gS5uw0swNWDVmSQcZ1IAqw3sKqLZT27Lz2rfZ/B2C0OqjwJTrLoZPZYptoI5dl2yVuHXKRW52W0WZ7CbSYuVUq8oQM/XXijTqmtZeG1AiDC4L5GTwQZm6Uw8vVUyCRc93J1L8rQS9flVuM0tddFF8Hpg4/ZPUDl9pWTzlzNUnqRjJydEeB0JD25Hr3TTs1kYO0gS/jcI1h5C0JZ2eFtHOlSbeLew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8wds2HwjXzffokBYS9lgyWZm7AUiG5j1i9eRBoantKY=;
 b=eFhAlpw8teFp/W/8axFm+k19a5FC09KXIe1IYvITAgfY2rwqtod+bt+S/VVDhhwNLIQbPI70eB3zyDjKv/HEa9wveQ3+JnAszhf1A0ANrpelA84WDnB4F7YryjzmO7/AXyoH+41CFuJlYfhVmEgpu5K1rkW+Okb6r0PT9QVnhyictaJyodTSiIGjgx069F8T5LRAjMXlCrANUYLtMO7Ue2K/Rc/qoUgg3xsTDHrJFMx2R9qfH6euGD8A/ibMzPuaZgplPRIi4NR5r+MYPjh51jysAArwtm2S70VCrcUZW//RdTmRD5ZM2Y/kp7skMKSZA98OF1fTZfd58KmHPvkyiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8wds2HwjXzffokBYS9lgyWZm7AUiG5j1i9eRBoantKY=;
 b=dKwjmu25l5HIdt1Jxz2fnnXDKdseXu9eM8u40ThhsaVjf9rGwKDtWP3wjCnpf4mu0x9m4pZUUsd7mUjuP0Z7QchChGk+XZa9dsz3TWTDO+Z0dv0oczbD+cW6Tt+T9xZ8hhSCNsUEsIUVkmTtSbOi9w+Eg7m9KpCsuLuakgaZdGc=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by CH0PR13MB4588.namprd13.prod.outlook.com (2603:10b6:610:db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.7; Thu, 17 Feb
 2022 10:25:58 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::1d6a:3497:58f3:d6bb]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::1d6a:3497:58f3:d6bb%6]) with mapi id 15.20.5017.007; Thu, 17 Feb 2022
 10:25:58 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jianbo Liu <jianbol@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     "olteanv@gmail.com" <olteanv@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "rajur@chelsio.com" <rajur@chelsio.com>,
        "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "sgoutham@marvell.com" <sgoutham@marvell.com>,
        "gakula@marvell.com" <gakula@marvell.com>,
        "sbhatta@marvell.com" <sbhatta@marvell.com>,
        "hkelam@marvell.com" <hkelam@marvell.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Simon Horman <simon.horman@corigine.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "louis.peens@netronome.com" <louis.peens@netronome.com>,
        Nole Zhang <peng.zhang@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>,
        "roid@nvidia.com" <roid@nvidia.com>
Subject: RE: [PATCH net-next v2 1/2] net: flow_offload: add tc police action
 parameters
Thread-Topic: [PATCH net-next v2 1/2] net: flow_offload: add tc police action
 parameters
Thread-Index: AQHYI9hqK9EJjBWfFE+i0lRwqXfdUayXgH4g
Date:   Thu, 17 Feb 2022 10:25:57 +0000
Message-ID: <DM5PR1301MB2172C0F6E86850B5646DAB84E7369@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20220217082803.3881-1-jianbol@nvidia.com>
 <20220217082803.3881-2-jianbol@nvidia.com>
In-Reply-To: <20220217082803.3881-2-jianbol@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e06a1e6e-1d22-4f91-b787-08d9f1ffe348
x-ms-traffictypediagnostic: CH0PR13MB4588:EE_
x-microsoft-antispam-prvs: <CH0PR13MB4588B769A93B4CE8BD75BD2CE7369@CH0PR13MB4588.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0jj02SQx68BEk/Y2CbuPPTf5INNJY2j9zqRsQxWLIyfR9Fwn0er/gtkQywVKyWfzA8B7IUpssu/Ks1JL6+DXr5t+DiH7noefegemtN4oYerNY6xsqApKj1Wjm3WLdD21JLZLpgJMJa2yLzAVFmHdcVDd3RFi8y0k071xpIaO5X+bMis8Spyz5zd9UThFHodasfaeG2gjae9ECijRGjpowgVUEkvdmpT2uPLw/y/nRL1NWq+Q+gHP46zi+CCnA1uplq/+N4U3EiIs6gT9jXf29qDLG6roHHv6uz+aWa98KCjDjDPIUgZw16bi3EjCh2VwCER0ayRBDnAfKkVfomIuAaSvw9mDYz0LEju3OE/JqzjCMOBj6Qerr8F8FPmz7ZFtWjXrA/maztxY8Y0McLAdRNODrUeUYQsCR869j89WiJhpmYurU8CFKjRZrfl3ZVEiZs9jP2oVjY/wmhwJh54wVCebP8Awdmau/XqbkO9g0F/qxAXJ3VhONhv4YVXUKuDpPuuZxeUDXqWzi+huJV8LMziHqS1CIJIIHCCAAPlGJCzYLrhf7FAJGK3syDfsF6mb7QY4/OOm9kyKgIG+wy3EjW5IPE6qrcdl3jTFVoxEAv7FZyugVKzIAbYZkVXFziz1PBtXTIvw1S/ya4FXP/pPA6mEqooAH3aslcZVY8YpyZcG6GmM9uozkRcNCkleObguhpgW6WDlWkLOZp5/JMoiRtydhKF263xNRREtWVDIhAqFA1xtYUcqijF+p/6OwNOi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(136003)(376002)(396003)(39840400004)(366004)(33656002)(8936002)(508600001)(9686003)(7696005)(6506007)(83380400001)(122000001)(7416002)(66476007)(5660300002)(52536014)(2906002)(76116006)(8676002)(54906003)(316002)(110136005)(66946007)(64756008)(66556008)(66446008)(38100700002)(4326008)(38070700005)(44832011)(55016003)(26005)(186003)(86362001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFhndTU2YXRuWDUrejNUd3RzZDdHMzcvV3F4cGIrWTZWZTNIUkd1Szg5VFFS?=
 =?utf-8?B?ZDlYbXNHbnN5RG96UlFJV2FyMFZabHBWRGx4NSt4NkFrYlhibERZTWZHMVBP?=
 =?utf-8?B?U2FnblZ1L0xRSmpDMFZZMDRCcGFjMkhSaTNSZjkxMWtaN1d3ZnoyVXVzQlRP?=
 =?utf-8?B?QW5zVFVTcHNIRXRJWnRtaTJlbC90eU9jQktLYUJHYmt3YitRbFlEdHJmaThN?=
 =?utf-8?B?c1VvL2k4UUVZN090VGdXbG8rNyszblVlb2pDWGtnMVErZkVnUnQvU1lXZlB5?=
 =?utf-8?B?NTdETDVNQzIrVk0vc2hXSEVhSlc3b0xxWWt2L2dqck0wSGtUWDJUbkNRMUN0?=
 =?utf-8?B?cDYvUGdHdDhneGhYekhSVlhkOU5MYkVwOTFBK3V2STAvNDJSOFVDaE5qTFB3?=
 =?utf-8?B?RDFzOGxzMi9vamNtQXM0NEZ2WTgyVzduald0K3hFbFJTVlRWRW1FUzltTGZo?=
 =?utf-8?B?YnNLZ3ZrdU1sSXBNa3IyTHRId2FOZk9qSlVZUndOQWZqU0RuOG9McnNpbkxU?=
 =?utf-8?B?M09HMStPanZUU21jSHd1M0FJdEZUUlA5Y1hiVFlDVnBYTWdkYVhWM3V4Qi9E?=
 =?utf-8?B?QXpGZzNUSU5SVnN2QmJRYmxodmFRNTZwVi9Gc0N4WDg0U2FvYS9wR3puUEJQ?=
 =?utf-8?B?eXVaMllZb2JmZmRDczFNWXVBVWR3ZFI1TnNJRC9uUi9vODJWUkNkRGtxSVdq?=
 =?utf-8?B?ZXZ1bGRYSkdWN1lSV1RJeHVpTkdNSXZGQmxCdWI4Y3pyYmVzVHg1Y1BBWDFv?=
 =?utf-8?B?YjJaNUY2UWszTXdGVWYrTGRnTDV4VE5CYTh2MnhJMk4rZlVkaDNzRWZHYVln?=
 =?utf-8?B?dnVEUHN4MFhOWUphQ0FBdFM4U3cvNnZnVUtPWVI3R0ZJcjNSMVN6UkNLNXVP?=
 =?utf-8?B?L1N2dk8vcnpaUC96R3REeUhxMHkyY2JkcExaRml5MENKalFCZ3BJejVDc1Nt?=
 =?utf-8?B?THlOczNXcUJkd0phV2trckxEc0NpYzczNU9XYTNHK2tWWktIaHdyOFVBbkRi?=
 =?utf-8?B?Vjl0MnRUZjNRQTE2QjAwTW1nM1A3c291WklldVNjZHUxMnk4ZGN1bTllU2pO?=
 =?utf-8?B?dndDSjJHQklLNzc5cUw5a0pySUI0NDhjUHhsQVgxbmtENit2M0hzT1RCNHlW?=
 =?utf-8?B?dFE2K0tBMmpRQVo2RExjZ0dJMzBaOVB0dzlGamJCZXY3dzJmZUtkWklCaWlr?=
 =?utf-8?B?VkRmMVVsS1p0TEdvMWUvZlJxd2NOc2kxMUQvUzdQZEo2V3prNk4wSkZqc2w2?=
 =?utf-8?B?ZUhaeFRDeWlpU2hQQ3F3RFZhSE9lejFJK0srZ0JuRnY3QkQ3S0F0emV6K21T?=
 =?utf-8?B?ZHVJTk9MbU5CT0F2UU0vY3hLL2hSdjhRM0RjR2d0V2VWclBPZDlUZnIzdXFT?=
 =?utf-8?B?WGhCNk1kOGs0R1llL0w0RnVLKy9iRVlaZ2d4M0RxclRiSmhGSHZvVEdaQURQ?=
 =?utf-8?B?ajQrNE9manp0OXBkeDczRWR5Zm0yOTF0SmgrKzZROGNydkRDeFNPc2dnSElG?=
 =?utf-8?B?WG1ZMjhXY3JQQy94VzFzaExxbWhIZkNQazlwUUpSNUhQcFdSN0VzU2Y5ejZ0?=
 =?utf-8?B?d2thaVl0Q2o4NWxUTk5PT3g3ZmFxZUk2QXNUSjBjbzBKWXlPOXJHb08rYk5a?=
 =?utf-8?B?em9iZ21takJQeVNRUEFlOTlscEhVVXhTbm85Y2NOTVhxRUd4U0ppZC9YdHVu?=
 =?utf-8?B?Uko4S3drcWQyMm1OUGU3aWMvOG1Dcy95S000bVRWZjgwM1NaRlVLaDZDc01z?=
 =?utf-8?B?enBuSzByM2dnQWxSSytwNzFKVDdVMmZjeTJyb0Z3R1lldXlHdGUzNE5paGV4?=
 =?utf-8?B?eWZ1TEc2MUVSSDNqSm41cG9QUUFnMzBFTnVnQU5LcWlWZHFLbEttQ01TUXdI?=
 =?utf-8?B?M1h0RHVuVkd2bzFrcnZySld2V2Z5SG54Ujk0b1dzZ1FqZzBleFJuRDc4MXBu?=
 =?utf-8?B?aDhjQjZvMjdVU2pqK1hISUNta3FSUTg5Ynd0Q0JXaWVGZ0VveFcvTVl4VDhr?=
 =?utf-8?B?ZHcvRmJSL2tSdjcva3JVaWlrdmRSYVhDRDJ5UWp5YytXTytSSWNyRDdBTTVu?=
 =?utf-8?B?UHBsTU1UaEw1V2xsMURGMEtRSFVvNy9iOVVTdjYyM0dRaGpEUCtBQVFUMUhD?=
 =?utf-8?B?K296TlRDa0d6cEtXSGNrZG1EakxVaUs2Mnd1Q2ZzcTBiTW9lNnB1anBSTXpr?=
 =?utf-8?B?LzFXLzFrRlBJeEtCaFFjdHZUTEhWK1h0WlBzQzZYelJGMWxlZmY5MjZzUm5X?=
 =?utf-8?B?ekx5Yms5OG04ditSMFJoSmJBc2tnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e06a1e6e-1d22-4f91-b787-08d9f1ffe348
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2022 10:25:57.9909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LD29PtgmYUjS5RTTzEwmfzvc6K79OxaTW8NcwSYsbIMHJoTJ6WIbQKSdksdKz25bLdkuKcSrHjHxzu2ScmpiVIqH6f7JHI0N13V+eR6NJuQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4588
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRmVicnVhcnkgMTcsIDIwMjIgNDoyOCBQTSwgSmlhbmJvIHdyb3RlOg0KPlRoZSBjdXJyZW50
IHBvbGljZSBvZmZsb2FkIGFjdGlvbiBlbnRyeSBpcyBtaXNzaW5nIGV4Y2VlZC9ub3RleGNlZWQg
YWN0aW9ucw0KPmFuZCBwYXJhbWV0ZXJzIHRoYXQgY2FuIGJlIGNvbmZpZ3VyZWQgYnkgdGMgcG9s
aWNlIGFjdGlvbi4NCj5BZGQgdGhlIG1pc3NpbmcgcGFyYW1ldGVycyBhcyBhIHByZS1zdGVwIGZv
ciBvZmZsb2FkaW5nIHBvbGljZSBhY3Rpb25zIHRvDQo+aGFyZHdhcmUuDQo+DQo+U2lnbmVkLW9m
Zi1ieTogSmlhbmJvIExpdSA8amlhbmJvbEBudmlkaWEuY29tPg0KPlNpZ25lZC1vZmYtYnk6IFJv
aSBEYXlhbiA8cm9pZEBudmlkaWEuY29tPg0KPlJldmlld2VkLWJ5OiBJZG8gU2NoaW1tZWwgPGlk
b3NjaEBudmlkaWEuY29tPg0KPi0tLQ0KPiBpbmNsdWRlL25ldC9mbG93X29mZmxvYWQuaCAgICAg
fCAxMyArKysrKysrKysrDQo+IGluY2x1ZGUvbmV0L3RjX2FjdC90Y19wb2xpY2UuaCB8IDMwICsr
KysrKysrKysrKysrKysrKysrKysNCj4gbmV0L3NjaGVkL2FjdF9wb2xpY2UuYyAgICAgICAgIHwg
NDYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAzIGZpbGVzIGNoYW5nZWQs
IDg5IGluc2VydGlvbnMoKykNCj4NCj5kaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvZmxvd19vZmZs
b2FkLmggYi9pbmNsdWRlL25ldC9mbG93X29mZmxvYWQuaCBpbmRleA0KPjViOGM1NGViN2E2Yi4u
OTRjZGU2YmJjOGE1IDEwMDY0NA0KPi0tLSBhL2luY2x1ZGUvbmV0L2Zsb3dfb2ZmbG9hZC5oDQo+
KysrIGIvaW5jbHVkZS9uZXQvZmxvd19vZmZsb2FkLmgNCj5AQCAtMTQ4LDYgKzE0OCw4IEBAIGVu
dW0gZmxvd19hY3Rpb25faWQgew0KPiAJRkxPV19BQ1RJT05fTVBMU19NQU5HTEUsDQo+IAlGTE9X
X0FDVElPTl9HQVRFLA0KPiAJRkxPV19BQ1RJT05fUFBQT0VfUFVTSCwNCj4rCUZMT1dfQUNUSU9O
X0pVTVAsDQo+KwlGTE9XX0FDVElPTl9QSVBFLA0KPiAJTlVNX0ZMT1dfQUNUSU9OUywNCj4gfTsN
Cj4NCj5AQCAtMjM1LDkgKzIzNywyMCBAQCBzdHJ1Y3QgZmxvd19hY3Rpb25fZW50cnkgew0KPiAJ
CXN0cnVjdCB7CQkJCS8qIEZMT1dfQUNUSU9OX1BPTElDRSAqLw0KPiAJCQl1MzIJCQlidXJzdDsN
Cj4gCQkJdTY0CQkJcmF0ZV9ieXRlc19wczsNCj4rCQkJdTY0CQkJcGVha3JhdGVfYnl0ZXNfcHM7
DQo+KwkJCXUzMgkJCWF2cmF0ZTsNCj4rCQkJdTE2CQkJb3ZlcmhlYWQ7DQo+IAkJCXU2NAkJCWJ1
cnN0X3BrdDsNCj4gCQkJdTY0CQkJcmF0ZV9wa3RfcHM7DQo+IAkJCXUzMgkJCW10dTsNCj4rCQkJ
c3RydWN0IHsNCj4rCQkJCWVudW0gZmxvd19hY3Rpb25faWQgICAgIGFjdF9pZDsNCj4rCQkJCXUz
MiAgICAgICAgICAgICAgICAgICAgIGluZGV4Ow0KPisJCQl9IGV4Y2VlZDsNCj4rCQkJc3RydWN0
IHsNCj4rCQkJCWVudW0gZmxvd19hY3Rpb25faWQgICAgIGFjdF9pZDsNCj4rCQkJCXUzMiAgICAg
ICAgICAgICAgICAgICAgIGluZGV4Ow0KPisJCQl9IG5vdGV4Y2VlZDsNCkl0IHNlZW1zIGV4Y2Vl
ZCBhbmQgbm90ZXhjZWVkIHVzZSB0aGUgc2FtZSBmb3JtYXQgc3RydWN0LCB3aWxsIGl0IGJlIG1v
cmUgc2ltcGxlciB0byBkZWZpbmUgYXM6DQoJCQlzdHJ1Y3Qgew0KCQkJCWVudW0gZmxvd19hY3Rp
b25faWQgICAgIGFjdF9pZDsNCgkJCQl1MzIgICAgICAgICAgICAgICAgICAgICBpbmRleDsNCgkJ
CX0gZXhjZWVkLCBub3RleGNlZWQ7DQoNCj4gCQl9IHBvbGljZTsNCj4gCQlzdHJ1Y3QgewkJCQkv
KiBGTE9XX0FDVElPTl9DVCAqLw0KPiAJCQlpbnQgYWN0aW9uOw0KPmRpZmYgLS1naXQgYS9pbmNs
dWRlL25ldC90Y19hY3QvdGNfcG9saWNlLmggYi9pbmNsdWRlL25ldC90Y19hY3QvdGNfcG9saWNl
LmgNCj5pbmRleCA3MjY0OTUxMmRjZGQuLjI4M2JkZTcxMWE0MiAxMDA2NDQNCj4tLS0gYS9pbmNs
dWRlL25ldC90Y19hY3QvdGNfcG9saWNlLmgNCj4rKysgYi9pbmNsdWRlL25ldC90Y19hY3QvdGNf
cG9saWNlLmgNCj5AQCAtMTU5LDQgKzE1OSwzNCBAQCBzdGF0aWMgaW5saW5lIHUzMiB0Y2ZfcG9s
aWNlX3RjZnBfbXR1KGNvbnN0IHN0cnVjdA0KPnRjX2FjdGlvbiAqYWN0KQ0KPiAJcmV0dXJuIHBh
cmFtcy0+dGNmcF9tdHU7DQo+IH0NCj4NCj4rc3RhdGljIGlubGluZSB1NjQgdGNmX3BvbGljZV9w
ZWFrcmF0ZV9ieXRlc19wcyhjb25zdCBzdHJ1Y3QgdGNfYWN0aW9uDQo+KyphY3QpIHsNCj4rCXN0
cnVjdCB0Y2ZfcG9saWNlICpwb2xpY2UgPSB0b19wb2xpY2UoYWN0KTsNCj4rCXN0cnVjdCB0Y2Zf
cG9saWNlX3BhcmFtcyAqcGFyYW1zOw0KPisNCj4rCXBhcmFtcyA9IHJjdV9kZXJlZmVyZW5jZV9w
cm90ZWN0ZWQocG9saWNlLT5wYXJhbXMsDQo+KwkJCQkJICAgbG9ja2RlcF9pc19oZWxkKCZwb2xp
Y2UtPnRjZl9sb2NrKSk7DQo+KwlyZXR1cm4gcGFyYW1zLT5wZWFrLnJhdGVfYnl0ZXNfcHM7DQo+
K30NCj4rDQo+K3N0YXRpYyBpbmxpbmUgdTMyIHRjZl9wb2xpY2VfdGNmcF9ld21hX3JhdGUoY29u
c3Qgc3RydWN0IHRjX2FjdGlvbg0KPisqYWN0KSB7DQo+KwlzdHJ1Y3QgdGNmX3BvbGljZSAqcG9s
aWNlID0gdG9fcG9saWNlKGFjdCk7DQo+KwlzdHJ1Y3QgdGNmX3BvbGljZV9wYXJhbXMgKnBhcmFt
czsNCj4rDQo+KwlwYXJhbXMgPSByY3VfZGVyZWZlcmVuY2VfcHJvdGVjdGVkKHBvbGljZS0+cGFy
YW1zLA0KPisJCQkJCSAgIGxvY2tkZXBfaXNfaGVsZCgmcG9saWNlLT50Y2ZfbG9jaykpOw0KPisJ
cmV0dXJuIHBhcmFtcy0+dGNmcF9ld21hX3JhdGU7DQo+K30NCj4rDQo+K3N0YXRpYyBpbmxpbmUg
dTE2IHRjZl9wb2xpY2VfcmF0ZV9vdmVyaGVhZChjb25zdCBzdHJ1Y3QgdGNfYWN0aW9uICphY3Qp
DQo+K3sNCj4rCXN0cnVjdCB0Y2ZfcG9saWNlICpwb2xpY2UgPSB0b19wb2xpY2UoYWN0KTsNCj4r
CXN0cnVjdCB0Y2ZfcG9saWNlX3BhcmFtcyAqcGFyYW1zOw0KPisNCj4rCXBhcmFtcyA9IHJjdV9k
ZXJlZmVyZW5jZV9wcm90ZWN0ZWQocG9saWNlLT5wYXJhbXMsDQo+KwkJCQkJICAgbG9ja2RlcF9p
c19oZWxkKCZwb2xpY2UtPnRjZl9sb2NrKSk7DQo+KwlyZXR1cm4gcGFyYW1zLT5yYXRlLm92ZXJo
ZWFkOw0KPit9DQo+Kw0KPiAjZW5kaWYgLyogX19ORVRfVENfUE9MSUNFX0ggKi8NCj5kaWZmIC0t
Z2l0IGEvbmV0L3NjaGVkL2FjdF9wb2xpY2UuYyBiL25ldC9zY2hlZC9hY3RfcG9saWNlLmMgaW5k
ZXgNCj4wOTIzYWEyYjhmOGEuLjA0NTdiNmM5YzRlNyAxMDA2NDQNCj4tLS0gYS9uZXQvc2NoZWQv
YWN0X3BvbGljZS5jDQo+KysrIGIvbmV0L3NjaGVkL2FjdF9wb2xpY2UuYw0KPkBAIC00MDUsMjAg
KzQwNSw2NiBAQCBzdGF0aWMgaW50IHRjZl9wb2xpY2Vfc2VhcmNoKHN0cnVjdCBuZXQgKm5ldCwg
c3RydWN0DQo+dGNfYWN0aW9uICoqYSwgdTMyIGluZGV4KQ0KPiAJcmV0dXJuIHRjZl9pZHJfc2Vh
cmNoKHRuLCBhLCBpbmRleCk7DQo+IH0NCj4NCj4rc3RhdGljIGludCB0Y2ZfcG9saWNlX2FjdF90
b19mbG93X2FjdChpbnQgdGNfYWN0LCBpbnQgKmluZGV4KSB7DQo+KwlpbnQgYWN0X2lkID0gLUVP
UE5PVFNVUFA7DQo+Kw0KPisJaWYgKCFUQ19BQ1RfRVhUX09QQ09ERSh0Y19hY3QpKSB7DQo+KwkJ
aWYgKHRjX2FjdCA9PSBUQ19BQ1RfT0spDQo+KwkJCWFjdF9pZCA9IEZMT1dfQUNUSU9OX0FDQ0VQ
VDsNCj4rCQllbHNlIGlmICh0Y19hY3QgPT0gIFRDX0FDVF9TSE9UKQ0KPisJCQlhY3RfaWQgPSBG
TE9XX0FDVElPTl9EUk9QOw0KPisJCWVsc2UgaWYgKHRjX2FjdCA9PSBUQ19BQ1RfUElQRSkNCj4r
CQkJYWN0X2lkID0gRkxPV19BQ1RJT05fUElQRTsNCj4rCX0gZWxzZSBpZiAoVENfQUNUX0VYVF9D
TVAodGNfYWN0LCBUQ19BQ1RfR09UT19DSEFJTikpIHsNCj4rCQlhY3RfaWQgPSBGTE9XX0FDVElP
Tl9HT1RPOw0KPisJCSppbmRleCA9IHRjX2FjdCAmIFRDX0FDVF9FWFRfVkFMX01BU0s7DQpGb3Ig
dGhlIFRDX0FDVF9HT1RPX0NIQUlOICBhY3Rpb24sIHRoZSBnb3RvX2NoYWluIGluZm9ybWF0aW9u
IGlzIG1pc3NpbmcgZnJvbSBzb2Z0d2FyZSB0byBoYXJkd2FyZSwgaXMgaXQgdXNlZnVsIGZvciBo
YXJkd2FyZSB0byBjaGVjaz8NCg0KPisJfSBlbHNlIGlmIChUQ19BQ1RfRVhUX0NNUCh0Y19hY3Qs
IFRDX0FDVF9KVU1QKSkgew0KPisJCWFjdF9pZCA9IEZMT1dfQUNUSU9OX0pVTVA7DQo+KwkJKmlu
ZGV4ID0gdGNfYWN0ICYgVENfQUNUX0VYVF9WQUxfTUFTSzsNCj4rCX0NCj4rDQo+KwlyZXR1cm4g
YWN0X2lkOw0KPit9DQo+Kw0KPiBzdGF0aWMgaW50IHRjZl9wb2xpY2Vfb2ZmbG9hZF9hY3Rfc2V0
dXAoc3RydWN0IHRjX2FjdGlvbiAqYWN0LCB2b2lkICplbnRyeV9kYXRhLA0KPiAJCQkJCXUzMiAq
aW5kZXhfaW5jLCBib29sIGJpbmQpDQo+IHsNCj4gCWlmIChiaW5kKSB7DQo+IAkJc3RydWN0IGZs
b3dfYWN0aW9uX2VudHJ5ICplbnRyeSA9IGVudHJ5X2RhdGE7DQo+KwkJc3RydWN0IHRjZl9wb2xp
Y2UgKnBvbGljZSA9IHRvX3BvbGljZShhY3QpOw0KPisJCXN0cnVjdCB0Y2ZfcG9saWNlX3BhcmFt
cyAqcDsNCj4rCQlpbnQgYWN0X2lkOw0KPisNCj4rCQlwID0gcmN1X2RlcmVmZXJlbmNlX3Byb3Rl
Y3RlZChwb2xpY2UtPnBhcmFtcywNCj4rCQkJCQkgICAgICBsb2NrZGVwX2lzX2hlbGQoJnBvbGlj
ZS0+dGNmX2xvY2spKTsNCj4NCj4gCQllbnRyeS0+aWQgPSBGTE9XX0FDVElPTl9QT0xJQ0U7DQo+
IAkJZW50cnktPnBvbGljZS5idXJzdCA9IHRjZl9wb2xpY2VfYnVyc3QoYWN0KTsNCj4gCQllbnRy
eS0+cG9saWNlLnJhdGVfYnl0ZXNfcHMgPQ0KPiAJCQl0Y2ZfcG9saWNlX3JhdGVfYnl0ZXNfcHMo
YWN0KTsNCj4rCQllbnRyeS0+cG9saWNlLnBlYWtyYXRlX2J5dGVzX3BzID0NCj50Y2ZfcG9saWNl
X3BlYWtyYXRlX2J5dGVzX3BzKGFjdCk7DQo+KwkJZW50cnktPnBvbGljZS5hdnJhdGUgPSB0Y2Zf
cG9saWNlX3RjZnBfZXdtYV9yYXRlKGFjdCk7DQo+KwkJZW50cnktPnBvbGljZS5vdmVyaGVhZCA9
IHRjZl9wb2xpY2VfcmF0ZV9vdmVyaGVhZChhY3QpOw0KPiAJCWVudHJ5LT5wb2xpY2UuYnVyc3Rf
cGt0ID0gdGNmX3BvbGljZV9idXJzdF9wa3QoYWN0KTsNCj4gCQllbnRyeS0+cG9saWNlLnJhdGVf
cGt0X3BzID0NCj4gCQkJdGNmX3BvbGljZV9yYXRlX3BrdF9wcyhhY3QpOw0KPiAJCWVudHJ5LT5w
b2xpY2UubXR1ID0gdGNmX3BvbGljZV90Y2ZwX210dShhY3QpOw0KPisNCj4rCQlhY3RfaWQgPSB0
Y2ZfcG9saWNlX2FjdF90b19mbG93X2FjdChwb2xpY2UtPnRjZl9hY3Rpb24sDQo+KwkJCQkJCSAg
ICAmZW50cnktDQo+PnBvbGljZS5leGNlZWQuaW5kZXgpOw0KPisJCWlmIChhY3RfaWQgPCAwKQ0K
PisJCQlyZXR1cm4gYWN0X2lkOw0KPisNCj4rCQllbnRyeS0+cG9saWNlLmV4Y2VlZC5hY3RfaWQg
PSBhY3RfaWQ7DQo+Kw0KPisJCWFjdF9pZCA9IHRjZl9wb2xpY2VfYWN0X3RvX2Zsb3dfYWN0KHAt
PnRjZnBfcmVzdWx0LA0KPisJCQkJCQkgICAgJmVudHJ5LQ0KPj5wb2xpY2Uubm90ZXhjZWVkLmlu
ZGV4KTsNCj4rCQlpZiAoYWN0X2lkIDwgMCkNCj4rCQkJcmV0dXJuIGFjdF9pZDsNCj4rDQo+KwkJ
ZW50cnktPnBvbGljZS5ub3RleGNlZWQuYWN0X2lkID0gYWN0X2lkOw0KPisNCj4gCQkqaW5kZXhf
aW5jID0gMTsNCj4gCX0gZWxzZSB7DQo+IAkJc3RydWN0IGZsb3dfb2ZmbG9hZF9hY3Rpb24gKmZs
X2FjdGlvbiA9IGVudHJ5X2RhdGE7DQo+LS0NCj4yLjI2LjINCg0K
