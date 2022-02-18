Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9075E4BAF36
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 02:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbiBRBqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 20:46:38 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiBRBqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 20:46:37 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2098.outbound.protection.outlook.com [40.107.223.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356D2B0D16;
        Thu, 17 Feb 2022 17:46:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oRCX4NYVQWKUnYd/App3+gc5WsPvruH7D4xNKTWqWGdYxl2w0dyRsq0N6N4dgMDf6m46ZT7i5pUknMVxq83AQhKUTlQ5ooR+eJraqCvKAnOEpWEE6WxuHcMgBLYheoqDx5oAiES//ww2sqJlxXXT5zYdq6DuG21spv/8sAmxIvceLu6BCu+FlHk3aHNb/DWcIlXzvu7dDE9nNu2YRzTAhUoaNHvSgLD63dXm6FT0kx8YNQcoQr8WSKJcDnKRRj3GFwZozXV9nJv+0Lssdo5KMWLLI93lPieGgKjarbouCeT130rfLiTOsMZwROXnilxKEF2a/YbTZjWWE1mhd5Tr5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FD3gmtp9wZDfcX9oE8NXTS1ZcZhnODvL6jrYlTU9yUQ=;
 b=dbs5uIf/8O8IEph5iUrvJAvQh00xN+6dgqFj2y9v4dRRVQXdq/Ku/TZQXnuMvMdO9zb7JPpNHsvTSI/WcxfqBvgfnGv4mh5fe5u0y/0Ckl+UuPuMvisgHdsRUXXlfPo7x+mP1nNucYCPeRZPM5WKGaj/KC2+TuAXOIkEx6ygwpkKU2DdPJ/g08pC78Znjb7Za5QnPJIL0lTgsqyeHKPFk2MAEyvoblQsrv14eXmzNN6qT30NN6zd4PqRxIi8seHYSvIHYWq3wst/EXTXeTFXGg912vzTUYI1Q1yvoCmUNUGc3AYbhPAZAtsecMKf3Yf1iUiN0FEUymqLIM1sv0T2/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FD3gmtp9wZDfcX9oE8NXTS1ZcZhnODvL6jrYlTU9yUQ=;
 b=YYzGuYMeOYqH+slou3MN3aeme3bySmjo1muOaivMiE2SpGggDBCJn7eA+aYQKXC7j/ZAF7A12ftiJNrA+211slCMtIVwxtUxyoF4HKFbIO8FGqsG96dPUjUpC4ULwuhfvNIhQtOBtp8mJlvlbwM5LV2x5vMGByZXlA1Jg/tE+94=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM6PR13MB3434.namprd13.prod.outlook.com (2603:10b6:5:1cc::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.10; Fri, 18 Feb
 2022 01:46:19 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::1d6a:3497:58f3:d6bb]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::1d6a:3497:58f3:d6bb%6]) with mapi id 15.20.5017.007; Fri, 18 Feb 2022
 01:46:19 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Roi Dayan <roid@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>,
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
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH net-next v2 1/2] net: flow_offload: add tc police action
 parameters
Thread-Topic: [PATCH net-next v2 1/2] net: flow_offload: add tc police action
 parameters
Thread-Index: AQHYI9hqK9EJjBWfFE+i0lRwqXfdUayXgH4ggAAmfICAANvE8A==
Date:   Fri, 18 Feb 2022 01:46:19 +0000
Message-ID: <DM5PR1301MB21721A9F0AE0615C8B83A079E7379@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20220217082803.3881-1-jianbol@nvidia.com>
 <20220217082803.3881-2-jianbol@nvidia.com>
 <DM5PR1301MB2172C0F6E86850B5646DAB84E7369@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <a196d40f-d96f-3fb2-2189-a3906b340d95@nvidia.com>
In-Reply-To: <a196d40f-d96f-3fb2-2189-a3906b340d95@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bef3718c-270d-4816-5ff7-08d9f28075cc
x-ms-traffictypediagnostic: DM6PR13MB3434:EE_
x-microsoft-antispam-prvs: <DM6PR13MB343476955FCF261CFFE2157DE7379@DM6PR13MB3434.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YZwL0EwHim4SblLxNS82MamnEzsQU4oxFbnNBsgyyPVjCIXw6N/beGmJXBZfxBk8OdtD5G0vxdUsyf7scLqPrQLBtbbxvhFzAv1FFRNoPh/1sTp02A6OP1RSTo7NBFqsbPeXWSGSz5eKQQq6w2XrAG9wFcVyLkKP9cN8zQ7I/AlXlhnDPQH+R66zieq+piof3favW02O/jyhhTu/MgpbzY0z5+qlp2bTumATafMtX6DT/k2VQ7uXM5H8LzLsUN9ccZLnWc5hB5aSQ2HbJ8d6bBoeNb9sc96ILsd8KUEx641Mf92h7eXVz8z3CRIhejqpkQhwqBK2aNaOk2qRa4g5N+4ZTD+RFNfBIbrjfHMxiZul9E7NfI7vN6u9Txdp2NMWdKM6j9CErVxiyXhNQt22uXhzX7hEiPqI5T0NPkC7YQj6mP6IrTqRZMAJC0K94DTOOQnxzEcXdAc2GRELfzZwPkAcFxTBy7hwGWjP7iSgCuc6Fci6NghMnfrH3U4GEGPyaPDDyuBIm4xWLak5xkca/bZ4zWUd72uzTuZ/ZGld3JT/UPJmZ3uw+7Havvtyh4xGXZo71R9I3iZKjXw3MuT3VL0HvJhoolRf29bQBIA6snjyVKXZltAUC1pPqfmB4KosWMP7S5q/KVl28ur62hxRgUQTvgreF1/MOdWDZK8cHhFD9E6StFUMaBprhaz258EEHUolrgUGF9f2HgpH9C5KZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39840400004)(366004)(396003)(136003)(376002)(346002)(71200400001)(508600001)(7416002)(2906002)(107886003)(316002)(110136005)(5660300002)(52536014)(76116006)(66946007)(26005)(8936002)(186003)(33656002)(44832011)(4326008)(66476007)(66556008)(86362001)(66446008)(64756008)(8676002)(122000001)(38100700002)(83380400001)(6506007)(9686003)(7696005)(54906003)(38070700005)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TGZDYWFMTkNQaHdsR0k3TENxbG9WaWNXbXhWd2t2bDNyOFRyYlA4c3EvSWcw?=
 =?utf-8?B?TllqMDEvNldlNzc2TFFzcWU0TitBWUlYN2NGMXFuTllPSWp0SWZ0YkhIR2N4?=
 =?utf-8?B?ZURGZ2RtdzFZTUVLYVlGaTFnZVFtUTFtVWdYRzF1Z2JJQ2Q3amoxTlp3TnNo?=
 =?utf-8?B?YmtBVHFSa3A0WDBCeEtFU1BvYUJPSWt6bCtFaGtOUm5HODdVcU9TMG51c0hL?=
 =?utf-8?B?alNEYjZ5ek9mQzl2eEhMN2F6cjk4Nm1acWkyZHc2aGdpMnB6enc4UzZRK1BH?=
 =?utf-8?B?RmpCWlU4a3RUaE9BbTMwT1l1ZDVrODR3TmIwMnBaa0t6Z0FYM2hlOTJyczdJ?=
 =?utf-8?B?a2p4YVUzTXcwM0NabUJneDRoVGpGbEh3NUZZVDZuRzFHRm1NTm1PME1mK1o5?=
 =?utf-8?B?Q0RTWlE1VmFmbHV5NWZjYzlWejBsZjRhL1B3RTBlNjBodm1lQWpmRmRucURG?=
 =?utf-8?B?cjV4MmEwRGIwc3JQejZ5ZUpKR08yK2d5ZU9PQ1hLcGFoVGFkOUQ4aHNQYXRL?=
 =?utf-8?B?RGl6eGw0RWx6dGY2VjlGUnJWY2tEQjF6NEtCUTNSVG5KQ05peVlaSVhod3R2?=
 =?utf-8?B?QnVWNUlOOXdwUUFzSzQ2NlZzR1kyMGlHTXR4OXFTaXY4ZWFSanVWTlU2M3Ju?=
 =?utf-8?B?YXloajRpL2RLdkZMMFVoL2JheWVnNjlOVGdzdHhtdzNMY2E4OW1PWGUvd3Ri?=
 =?utf-8?B?MTBVUEN0VjEyb2R5YU8vZkxaQTlndEZGMXI1dHp1dDdLQ0VWVFJwQUVkRWE1?=
 =?utf-8?B?Qnp0WlhKVUwrUGp6VHEyRzNlM0RyT25ObzY0MG1wa2tsTm5BVlQ5S29lekxB?=
 =?utf-8?B?TlN5MU1mQkt2QXUwY2J5N2dwaVE4Nno1RjFnSVBCZkpBb0VtNHZsYWgwV1hq?=
 =?utf-8?B?RllJZ1VXTUlJZUkvUTIxNk43bm40Zjl3eTE0L3Z1TnY3M0xHMUtXdlNrNzJs?=
 =?utf-8?B?NnN2cms3MnA5d2lDQW0vdXJraUUzNFBkTmtHcUNFdFRJVUhNak82OFpQVHdQ?=
 =?utf-8?B?VDB2RU5YT3JnTWFDMkpmUm1YTGtSbWdpcFFuTmdWZDY4eVN5M2hkbXFZZDhW?=
 =?utf-8?B?eDI4Yit6V2F1K2pvSXRSdmlwZS9wcWJJemszemd2QXdsMVlKbkJtYmFkaE9K?=
 =?utf-8?B?ZURaSDhWTHZGOE02eTgvNjV2aE45UStnUnA0Mm1sNmJ6UzhVMERQanVOa0la?=
 =?utf-8?B?YTJWRFVMQmJJSDFEa3dERGVwWW9jdFVUT0FCVUVId3BrOExBMDVzS0hrckFZ?=
 =?utf-8?B?QjRFZ2dZcnpDN3hKcG91eldNcGZEQjhtWVQ4NDZ4aUtrQVBGZGgxa0NvSGxV?=
 =?utf-8?B?WlhPWWhEckFwaVNZb2E5dWtiMTQwaXpYVW1qM1EvOE9JSlpOZitKQzc2c1Nv?=
 =?utf-8?B?ZHJQUTdDU2FOOXUzbUR3Yko1T3g3L2FqUzRxc3Y5YjE5MUNYSU1CUHJxNEVl?=
 =?utf-8?B?dVl2UmxjUEhWM2xZSDJ3bWk5OTFzOGNST2Fvc2xLcURqTHNtYWVmdTFFUExp?=
 =?utf-8?B?Y3hUd2FOSThuL0grUmdBM2dOZUVVSnJVUU5venNzMThyd0luR0ltbWIwYWpv?=
 =?utf-8?B?RU4zN3MyYVFWTzBCalA0TTkxcTcrck95d1I5RUc3T2RXbEVKOE1OYjI5U1dh?=
 =?utf-8?B?azJLdUo5MmlzaXc5b2pFTUtETEN0VkFIbTJYWGdsWTN0UW4zV01yK1NOczdT?=
 =?utf-8?B?ekc3QmZZcnNvbnNtNksrK3cyZ2VTWU5oSGU3Q3ZxWEVZcnBUbEMxQzlCcGov?=
 =?utf-8?B?dEFLNVdyUXRMQXByNzZ3cG5iaGxsYlJWbUhHcm9neEE1dkRtYVF1QW1xajNH?=
 =?utf-8?B?ODZRTGkxL2VZV2ovTWIwMG9palRHMzdrTm9XMTdXN3RpUC9ZdnRoZitQSEVo?=
 =?utf-8?B?enpuNUk2OHRybTRIZE1UbnlGOGJCQ0VvTG96dWFYOE8ramFlNGlRRmtiVEpR?=
 =?utf-8?B?bGRQci9iQTlWaVRLZnRjM0tsQW9MRnV0V00xTVpRZWZTTmwraDRvTWdOMTRs?=
 =?utf-8?B?RjNLVzkyNlh2L284MEZqTHpDM2tJRWdhZENycjhLZ01rRmZZbFJSaWZmM05T?=
 =?utf-8?B?SFhUV25aSHk1Mi83MEdobmRZL1ByQkQ5cm82WG85N25ZTnlRanlEN3NCUjFz?=
 =?utf-8?B?TTNXTi9BZmNuSkhjUWsyTDhRQkU0SXVILzh6NkdFRnV1ZFV3SVh6d0RKR09w?=
 =?utf-8?B?NHRNSkY5SCs2ZGVRUGVSdDhNZHYxSFZFK3lIZUJCQ0xZZUVvUWNudEYzTGIz?=
 =?utf-8?B?N0VXQUF1b1h5c3d0OFVidVVpcGJ3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bef3718c-270d-4816-5ff7-08d9f28075cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2022 01:46:19.4137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Y+SOvEIsVx2R3povoiKcvruJ/9Q82GWQgzUkDoJN2ertZHCRyPTZUmkI3JIo/iHLqr4KGDWzLL+DY12IQIp40urtiBrRDsGh2McucA5Kys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3434
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24sIEZlYnJ1YXJ5IDE3LCAyMDIyIDg6MTAgUE0sIFJvaSB3cm90ZToNCj5PbiAyMDIyLTAyLTE3
IDEyOjI1IFBNLCBCYW93ZW4gWmhlbmcgd3JvdGU6DQo+PiBPbiBGZWJydWFyeSAxNywgMjAyMiA0
OjI4IFBNLCBKaWFuYm8gd3JvdGU6DQo+Pj4gVGhlIGN1cnJlbnQgcG9saWNlIG9mZmxvYWQgYWN0
aW9uIGVudHJ5IGlzIG1pc3NpbmcgZXhjZWVkL25vdGV4Y2VlZA0KPj4+IGFjdGlvbnMgYW5kIHBh
cmFtZXRlcnMgdGhhdCBjYW4gYmUgY29uZmlndXJlZCBieSB0YyBwb2xpY2UgYWN0aW9uLg0KPj4+
IEFkZCB0aGUgbWlzc2luZyBwYXJhbWV0ZXJzIGFzIGEgcHJlLXN0ZXAgZm9yIG9mZmxvYWRpbmcg
cG9saWNlDQo+Pj4gYWN0aW9ucyB0byBoYXJkd2FyZS4NCj4+Pg0KPj4+IFNpZ25lZC1vZmYtYnk6
IEppYW5ibyBMaXUgPGppYW5ib2xAbnZpZGlhLmNvbT4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBSb2kg
RGF5YW4gPHJvaWRAbnZpZGlhLmNvbT4NCj4+PiBSZXZpZXdlZC1ieTogSWRvIFNjaGltbWVsIDxp
ZG9zY2hAbnZpZGlhLmNvbT4NCj4+PiAtLS0NCj4+PiBpbmNsdWRlL25ldC9mbG93X29mZmxvYWQu
aCAgICAgfCAxMyArKysrKysrKysrDQo+Pj4gaW5jbHVkZS9uZXQvdGNfYWN0L3RjX3BvbGljZS5o
IHwgMzAgKysrKysrKysrKysrKysrKysrKysrKw0KPj4+IG5ldC9zY2hlZC9hY3RfcG9saWNlLmMg
ICAgICAgICB8IDQ2DQo+KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPj4+IDMg
ZmlsZXMgY2hhbmdlZCwgODkgaW5zZXJ0aW9ucygrKQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvbmV0L2Zsb3dfb2ZmbG9hZC5oIGIvaW5jbHVkZS9uZXQvZmxvd19vZmZsb2FkLmgNCj4+
PiBpbmRleA0KPj4+IDViOGM1NGViN2E2Yi4uOTRjZGU2YmJjOGE1IDEwMDY0NA0KPj4+IC0tLSBh
L2luY2x1ZGUvbmV0L2Zsb3dfb2ZmbG9hZC5oDQo+Pj4gKysrIGIvaW5jbHVkZS9uZXQvZmxvd19v
ZmZsb2FkLmgNCj4+PiBAQCAtMTQ4LDYgKzE0OCw4IEBAIGVudW0gZmxvd19hY3Rpb25faWQgew0K
Pj4+IAlGTE9XX0FDVElPTl9NUExTX01BTkdMRSwNCj4+PiAJRkxPV19BQ1RJT05fR0FURSwNCj4+
PiAJRkxPV19BQ1RJT05fUFBQT0VfUFVTSCwNCj4+PiArCUZMT1dfQUNUSU9OX0pVTVAsDQo+Pj4g
KwlGTE9XX0FDVElPTl9QSVBFLA0KPj4+IAlOVU1fRkxPV19BQ1RJT05TLA0KPj4+IH07DQo+Pj4N
Cj4+PiBAQCAtMjM1LDkgKzIzNywyMCBAQCBzdHJ1Y3QgZmxvd19hY3Rpb25fZW50cnkgew0KPj4+
IAkJc3RydWN0IHsJCQkJLyogRkxPV19BQ1RJT05fUE9MSUNFICovDQo+Pj4gCQkJdTMyCQkJYnVy
c3Q7DQo+Pj4gCQkJdTY0CQkJcmF0ZV9ieXRlc19wczsNCj4+PiArCQkJdTY0CQkJcGVha3JhdGVf
Ynl0ZXNfcHM7DQo+Pj4gKwkJCXUzMgkJCWF2cmF0ZTsNCj4+PiArCQkJdTE2CQkJb3ZlcmhlYWQ7
DQo+Pj4gCQkJdTY0CQkJYnVyc3RfcGt0Ow0KPj4+IAkJCXU2NAkJCXJhdGVfcGt0X3BzOw0KPj4+
IAkJCXUzMgkJCW10dTsNCj4+PiArCQkJc3RydWN0IHsNCj4+PiArCQkJCWVudW0gZmxvd19hY3Rp
b25faWQgICAgIGFjdF9pZDsNCj4+PiArCQkJCXUzMiAgICAgICAgICAgICAgICAgICAgIGluZGV4
Ow0KPj4+ICsJCQl9IGV4Y2VlZDsNCj4+PiArCQkJc3RydWN0IHsNCj4+PiArCQkJCWVudW0gZmxv
d19hY3Rpb25faWQgICAgIGFjdF9pZDsNCj4+PiArCQkJCXUzMiAgICAgICAgICAgICAgICAgICAg
IGluZGV4Ow0KPj4+ICsJCQl9IG5vdGV4Y2VlZDsNCj4+IEl0IHNlZW1zIGV4Y2VlZCBhbmQgbm90
ZXhjZWVkIHVzZSB0aGUgc2FtZSBmb3JtYXQgc3RydWN0LCB3aWxsIGl0IGJlIG1vcmUNCj5zaW1w
bGVyIHRvIGRlZmluZSBhczoNCj4+IAkJCXN0cnVjdCB7DQo+PiAJCQkJZW51bSBmbG93X2FjdGlv
bl9pZCAgICAgYWN0X2lkOw0KPj4gCQkJCXUzMiAgICAgICAgICAgICAgICAgICAgIGluZGV4Ow0K
Pj4gCQkJfSBleGNlZWQsIG5vdGV4Y2VlZDsNCj4NCj5yaWdodC4gaXQgY2FuIGJlLg0KPg0KPj4N
Cj4+PiAJCX0gcG9saWNlOw0KPj4+IAkJc3RydWN0IHsJCQkJLyogRkxPV19BQ1RJT05fQ1QgKi8N
Cj4+PiAJCQlpbnQgYWN0aW9uOw0KPj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC90Y19hY3Qv
dGNfcG9saWNlLmgNCj4+PiBiL2luY2x1ZGUvbmV0L3RjX2FjdC90Y19wb2xpY2UuaCBpbmRleCA3
MjY0OTUxMmRjZGQuLjI4M2JkZTcxMWE0Mg0KPj4+IDEwMDY0NA0KPj4+IC0tLSBhL2luY2x1ZGUv
bmV0L3RjX2FjdC90Y19wb2xpY2UuaA0KPj4+ICsrKyBiL2luY2x1ZGUvbmV0L3RjX2FjdC90Y19w
b2xpY2UuaA0KPj4+IEBAIC0xNTksNCArMTU5LDM0IEBAIHN0YXRpYyBpbmxpbmUgdTMyIHRjZl9w
b2xpY2VfdGNmcF9tdHUoY29uc3QNCj4+PiBzdHJ1Y3QgdGNfYWN0aW9uICphY3QpDQo+Pj4gCXJl
dHVybiBwYXJhbXMtPnRjZnBfbXR1Ow0KPj4+IH0NCj4+Pg0KPj4+ICtzdGF0aWMgaW5saW5lIHU2
NCB0Y2ZfcG9saWNlX3BlYWtyYXRlX2J5dGVzX3BzKGNvbnN0IHN0cnVjdA0KPj4+ICt0Y19hY3Rp
b24NCj4+PiArKmFjdCkgew0KPj4+ICsJc3RydWN0IHRjZl9wb2xpY2UgKnBvbGljZSA9IHRvX3Bv
bGljZShhY3QpOw0KPj4+ICsJc3RydWN0IHRjZl9wb2xpY2VfcGFyYW1zICpwYXJhbXM7DQo+Pj4g
Kw0KPj4+ICsJcGFyYW1zID0gcmN1X2RlcmVmZXJlbmNlX3Byb3RlY3RlZChwb2xpY2UtPnBhcmFt
cywNCj4+PiArCQkJCQkgICBsb2NrZGVwX2lzX2hlbGQoJnBvbGljZS0+dGNmX2xvY2spKTsNCj4+
PiArCXJldHVybiBwYXJhbXMtPnBlYWsucmF0ZV9ieXRlc19wczsNCj4+PiArfQ0KPj4+ICsNCj4+
PiArc3RhdGljIGlubGluZSB1MzIgdGNmX3BvbGljZV90Y2ZwX2V3bWFfcmF0ZShjb25zdCBzdHJ1
Y3QgdGNfYWN0aW9uDQo+Pj4gKyphY3QpIHsNCj4+PiArCXN0cnVjdCB0Y2ZfcG9saWNlICpwb2xp
Y2UgPSB0b19wb2xpY2UoYWN0KTsNCj4+PiArCXN0cnVjdCB0Y2ZfcG9saWNlX3BhcmFtcyAqcGFy
YW1zOw0KPj4+ICsNCj4+PiArCXBhcmFtcyA9IHJjdV9kZXJlZmVyZW5jZV9wcm90ZWN0ZWQocG9s
aWNlLT5wYXJhbXMsDQo+Pj4gKwkJCQkJICAgbG9ja2RlcF9pc19oZWxkKCZwb2xpY2UtPnRjZl9s
b2NrKSk7DQo+Pj4gKwlyZXR1cm4gcGFyYW1zLT50Y2ZwX2V3bWFfcmF0ZTsNCj4+PiArfQ0KPj4+
ICsNCj4+PiArc3RhdGljIGlubGluZSB1MTYgdGNmX3BvbGljZV9yYXRlX292ZXJoZWFkKGNvbnN0
IHN0cnVjdCB0Y19hY3Rpb24NCj4+PiArKmFjdCkgew0KPj4+ICsJc3RydWN0IHRjZl9wb2xpY2Ug
KnBvbGljZSA9IHRvX3BvbGljZShhY3QpOw0KPj4+ICsJc3RydWN0IHRjZl9wb2xpY2VfcGFyYW1z
ICpwYXJhbXM7DQo+Pj4gKw0KPj4+ICsJcGFyYW1zID0gcmN1X2RlcmVmZXJlbmNlX3Byb3RlY3Rl
ZChwb2xpY2UtPnBhcmFtcywNCj4+PiArCQkJCQkgICBsb2NrZGVwX2lzX2hlbGQoJnBvbGljZS0+
dGNmX2xvY2spKTsNCj4+PiArCXJldHVybiBwYXJhbXMtPnJhdGUub3ZlcmhlYWQ7DQo+Pj4gK30N
Cj4+PiArDQo+Pj4gI2VuZGlmIC8qIF9fTkVUX1RDX1BPTElDRV9IICovDQo+Pj4gZGlmZiAtLWdp
dCBhL25ldC9zY2hlZC9hY3RfcG9saWNlLmMgYi9uZXQvc2NoZWQvYWN0X3BvbGljZS5jIGluZGV4
DQo+Pj4gMDkyM2FhMmI4ZjhhLi4wNDU3YjZjOWM0ZTcgMTAwNjQ0DQo+Pj4gLS0tIGEvbmV0L3Nj
aGVkL2FjdF9wb2xpY2UuYw0KPj4+ICsrKyBiL25ldC9zY2hlZC9hY3RfcG9saWNlLmMNCj4+PiBA
QCAtNDA1LDIwICs0MDUsNjYgQEAgc3RhdGljIGludCB0Y2ZfcG9saWNlX3NlYXJjaChzdHJ1Y3Qg
bmV0ICpuZXQsDQo+Pj4gc3RydWN0IHRjX2FjdGlvbiAqKmEsIHUzMiBpbmRleCkNCj4+PiAJcmV0
dXJuIHRjZl9pZHJfc2VhcmNoKHRuLCBhLCBpbmRleCk7IH0NCj4+Pg0KPj4+ICtzdGF0aWMgaW50
IHRjZl9wb2xpY2VfYWN0X3RvX2Zsb3dfYWN0KGludCB0Y19hY3QsIGludCAqaW5kZXgpIHsNCj4+
PiArCWludCBhY3RfaWQgPSAtRU9QTk9UU1VQUDsNCj4+PiArDQo+Pj4gKwlpZiAoIVRDX0FDVF9F
WFRfT1BDT0RFKHRjX2FjdCkpIHsNCj4+PiArCQlpZiAodGNfYWN0ID09IFRDX0FDVF9PSykNCj4+
PiArCQkJYWN0X2lkID0gRkxPV19BQ1RJT05fQUNDRVBUOw0KPj4+ICsJCWVsc2UgaWYgKHRjX2Fj
dCA9PSAgVENfQUNUX1NIT1QpDQo+Pj4gKwkJCWFjdF9pZCA9IEZMT1dfQUNUSU9OX0RST1A7DQo+
Pj4gKwkJZWxzZSBpZiAodGNfYWN0ID09IFRDX0FDVF9QSVBFKQ0KPj4+ICsJCQlhY3RfaWQgPSBG
TE9XX0FDVElPTl9QSVBFOw0KPj4+ICsJfSBlbHNlIGlmIChUQ19BQ1RfRVhUX0NNUCh0Y19hY3Qs
IFRDX0FDVF9HT1RPX0NIQUlOKSkgew0KPj4+ICsJCWFjdF9pZCA9IEZMT1dfQUNUSU9OX0dPVE87
DQo+Pj4gKwkJKmluZGV4ID0gdGNfYWN0ICYgVENfQUNUX0VYVF9WQUxfTUFTSzsNCj4+IEZvciB0
aGUgVENfQUNUX0dPVE9fQ0hBSU4gIGFjdGlvbiwgdGhlIGdvdG9fY2hhaW4gaW5mb3JtYXRpb24g
aXMgbWlzc2luZw0KPmZyb20gc29mdHdhcmUgdG8gaGFyZHdhcmUsIGlzIGl0IHVzZWZ1bCBmb3Ig
aGFyZHdhcmUgdG8gY2hlY2s/DQo+Pg0KPg0KPndoYXQgaW5mb3JtYXRpb24gZG8geW91IG1lYW4/
DQpTb3JyeSwgSSBkbyBub3QgcmVhbGl6ZSB0aGUgY2hhaW4gaW5kZXggaXMgaW4gdGhlIHJldHVy
biB2YWx1ZSBvZiBpbmRleCwgc28gcGxlYXNlIGp1c3QgaWdub3JlLg0KSXQgc2VlbXMgdGhlIGRl
ZmluaXRpb24gb2YgaW5kZXggaXMgYSBsaXR0bGUgY29uZnVzZWQgc2luY2UgaW4gVENfQUNUX0dP
VE9fQ0hBSU4gY2FzZSwgaXQgbWVhbnMgY2hhaW4gaW5kZXggYW5kIGluIFRDX0FDVF9KVU1QIGNh
c2UsIGl0IG1lYW5zIGp1bXAgY291bnQuIA0KSnVzdCBhIHN1Z2dlc3Rpb24sIGNhbiB3ZSBjaGFu
Z2UgdGhlIGluZGV4IGRlZmluaXRpb24gYXMgYSB1bmlvbiBhczoNCgl1bmlvbiB7DQoJCQl1MzIg
Y2hhaW5faW5kZXg7DQoJCQl1MzIgam1wX2NudDsNCgkJew0KV0RZVD8NCj4NCj4+PiArCX0gZWxz
ZSBpZiAoVENfQUNUX0VYVF9DTVAodGNfYWN0LCBUQ19BQ1RfSlVNUCkpIHsNCj4+PiArCQlhY3Rf
aWQgPSBGTE9XX0FDVElPTl9KVU1QOw0KPj4+ICsJCSppbmRleCA9IHRjX2FjdCAmIFRDX0FDVF9F
WFRfVkFMX01BU0s7DQo+Pj4gKwl9DQo+Pj4gKw0KPj4+ICsJcmV0dXJuIGFjdF9pZDsNCj4+PiAr
fQ0KPj4+ICsNCj4+PiBzdGF0aWMgaW50IHRjZl9wb2xpY2Vfb2ZmbG9hZF9hY3Rfc2V0dXAoc3Ry
dWN0IHRjX2FjdGlvbiAqYWN0LCB2b2lkDQo+KmVudHJ5X2RhdGEsDQo+Pj4gCQkJCQl1MzIgKmlu
ZGV4X2luYywgYm9vbCBiaW5kKQ0KPj4+IHsNCj4+PiAJaWYgKGJpbmQpIHsNCj4+PiAJCXN0cnVj
dCBmbG93X2FjdGlvbl9lbnRyeSAqZW50cnkgPSBlbnRyeV9kYXRhOw0KPj4+ICsJCXN0cnVjdCB0
Y2ZfcG9saWNlICpwb2xpY2UgPSB0b19wb2xpY2UoYWN0KTsNCj4+PiArCQlzdHJ1Y3QgdGNmX3Bv
bGljZV9wYXJhbXMgKnA7DQo+Pj4gKwkJaW50IGFjdF9pZDsNCj4+PiArDQo+Pj4gKwkJcCA9IHJj
dV9kZXJlZmVyZW5jZV9wcm90ZWN0ZWQocG9saWNlLT5wYXJhbXMsDQo+Pj4gKwkJCQkJICAgICAg
bG9ja2RlcF9pc19oZWxkKCZwb2xpY2UtDQo+PnRjZl9sb2NrKSk7DQo+Pj4NCj4+PiAJCWVudHJ5
LT5pZCA9IEZMT1dfQUNUSU9OX1BPTElDRTsNCj4+PiAJCWVudHJ5LT5wb2xpY2UuYnVyc3QgPSB0
Y2ZfcG9saWNlX2J1cnN0KGFjdCk7DQo+Pj4gCQllbnRyeS0+cG9saWNlLnJhdGVfYnl0ZXNfcHMg
PQ0KPj4+IAkJCXRjZl9wb2xpY2VfcmF0ZV9ieXRlc19wcyhhY3QpOw0KPj4+ICsJCWVudHJ5LT5w
b2xpY2UucGVha3JhdGVfYnl0ZXNfcHMgPQ0KPj4+IHRjZl9wb2xpY2VfcGVha3JhdGVfYnl0ZXNf
cHMoYWN0KTsNCj4+PiArCQllbnRyeS0+cG9saWNlLmF2cmF0ZSA9IHRjZl9wb2xpY2VfdGNmcF9l
d21hX3JhdGUoYWN0KTsNCj4+PiArCQllbnRyeS0+cG9saWNlLm92ZXJoZWFkID0gdGNmX3BvbGlj
ZV9yYXRlX292ZXJoZWFkKGFjdCk7DQo+Pj4gCQllbnRyeS0+cG9saWNlLmJ1cnN0X3BrdCA9IHRj
Zl9wb2xpY2VfYnVyc3RfcGt0KGFjdCk7DQo+Pj4gCQllbnRyeS0+cG9saWNlLnJhdGVfcGt0X3Bz
ID0NCj4+PiAJCQl0Y2ZfcG9saWNlX3JhdGVfcGt0X3BzKGFjdCk7DQo+Pj4gCQllbnRyeS0+cG9s
aWNlLm10dSA9IHRjZl9wb2xpY2VfdGNmcF9tdHUoYWN0KTsNCj4+PiArDQo+Pj4gKwkJYWN0X2lk
ID0gdGNmX3BvbGljZV9hY3RfdG9fZmxvd19hY3QocG9saWNlLT50Y2ZfYWN0aW9uLA0KPj4+ICsJ
CQkJCQkgICAgJmVudHJ5LQ0KPj4+PiBwb2xpY2UuZXhjZWVkLmluZGV4KTsNCj4+PiArCQlpZiAo
YWN0X2lkIDwgMCkNCj4+PiArCQkJcmV0dXJuIGFjdF9pZDsNCj4+PiArDQo+Pj4gKwkJZW50cnkt
PnBvbGljZS5leGNlZWQuYWN0X2lkID0gYWN0X2lkOw0KPj4+ICsNCj4+PiArCQlhY3RfaWQgPSB0
Y2ZfcG9saWNlX2FjdF90b19mbG93X2FjdChwLT50Y2ZwX3Jlc3VsdCwNCj4+PiArCQkJCQkJICAg
ICZlbnRyeS0NCj4+Pj4gcG9saWNlLm5vdGV4Y2VlZC5pbmRleCk7DQo+Pj4gKwkJaWYgKGFjdF9p
ZCA8IDApDQo+Pj4gKwkJCXJldHVybiBhY3RfaWQ7DQo+Pj4gKw0KPj4+ICsJCWVudHJ5LT5wb2xp
Y2Uubm90ZXhjZWVkLmFjdF9pZCA9IGFjdF9pZDsNCj4+PiArDQo+Pj4gCQkqaW5kZXhfaW5jID0g
MTsNCj4+PiAJfSBlbHNlIHsNCj4+PiAJCXN0cnVjdCBmbG93X29mZmxvYWRfYWN0aW9uICpmbF9h
Y3Rpb24gPSBlbnRyeV9kYXRhOw0KPj4+IC0tDQo+Pj4gMi4yNi4yDQo+Pg0K
