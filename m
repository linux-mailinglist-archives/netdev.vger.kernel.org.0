Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E201B4BAFA6
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 03:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbiBRCW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 21:22:26 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiBRCWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 21:22:25 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6875A58E;
        Thu, 17 Feb 2022 18:22:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WrTSSLmbtD3naAMn8izM8jdvkOmgCN8FJd0uUCUPYNWHUU8GakxyXkIoeazcvIJJf+5F77iOjIMqdq1BonOxzTjcE4eK9T9ZfyVf+mDyVoqZeCBi3CqlMhKlMXVe9DdoGzBwr0IB+FDogOCeGsWWowivoa3GZq1Y6Kz+wF/yynJC+sxHjwwWfh1BdpmKVxvMHLES3zCsBoKqThzsBv2X4ohkMBBZ4ixpHhIrchAbkbL2oY90+uKpfY24gNbhZ/oH/h8ErCVUEAMKq+TliATTCI4cYRl9aE9Eeu5j/Gx3Km87Mi74xVUFPyZ58bVGEsEkVir0NVvNRDOFzYPPgd5Gdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t19UOCEo44yiy9fCeub5saDWZIOpX0t4FxaJiM8hi7I=;
 b=nXejj3ZOHoFH121kbZTQD+YN8YDiEcvp2oMhlfPJiMbg+6DARB25153CoGN058oUWNullWDc6Cyz/EE9L/U4HuSd6mZ6VQUFMCHqzI2PDfckfb3HVRAgA4YQMZO51eMHTkdu0SqLxbDSWiDEKqMhCguTv9eW7I7dSVMNccHBsJTl93bGEw4/EzZHJmibQuwe+1r9szWmd23AVXAUPSbjPPg6Y85sO1p+y9lpjCkNwH2BR7xqdWRHofVp/uIDQbHhfZERisZgF64omFH4rtTOu0d9xiBBBk26wpuES6KyJR81YNBm0jbeDjSNtMNOeXN6NGKL0yRzpfWFGJYl+lbyCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t19UOCEo44yiy9fCeub5saDWZIOpX0t4FxaJiM8hi7I=;
 b=h7A+vAOJZTbwjeGDMIHMbLd9zNGHzkoeft6zKitW7ZX2KnGrmqLinGOLzZIJvjm3uiOs3MZXpHw4UnqyXQa8NONhN9Mf4gk26qYmPrp7l3gTytxYIlB6AX2oul6mjTTSqKF/v1RGPGg+3Gpgt5M3XdOfvvs7H+F0A/rm5WF6cmNXH1/0avcvJEBldNcK1QZBCvxZCAO6tVwuRbzO9g89KxUbEQdzxddfuHbRo/N4bmdh7yy/BIFw1h3XEK9V23Ww6yyocg6zAfvIzs59bw2Ps1N12a6umGqU64dJqLUYELNqO9r8qu1KkZvqvIkphndhLxeY0/BcEqMUpP+PArpYOw==
Received: from BN9PR12MB5196.namprd12.prod.outlook.com (2603:10b6:408:11d::17)
 by SN1PR12MB2445.namprd12.prod.outlook.com (2603:10b6:802:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Fri, 18 Feb
 2022 02:22:07 +0000
Received: from BN9PR12MB5196.namprd12.prod.outlook.com
 ([fe80::f1f2:c7b8:5521:e887]) by BN9PR12MB5196.namprd12.prod.outlook.com
 ([fe80::f1f2:c7b8:5521:e887%8]) with mapi id 15.20.4995.015; Fri, 18 Feb 2022
 02:22:07 +0000
From:   Jianbo Liu <jianbol@nvidia.com>
To:     Roi Dayan <roid@nvidia.com>,
        "baowen.zheng@corigine.com" <baowen.zheng@corigine.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>,
        Petr Machata <petrm@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkelam@marvell.com" <hkelam@marvell.com>,
        "louis.peens@netronome.com" <louis.peens@netronome.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "rajur@chelsio.com" <rajur@chelsio.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "sbhatta@marvell.com" <sbhatta@marvell.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "sgoutham@marvell.com" <sgoutham@marvell.com>,
        "gakula@marvell.com" <gakula@marvell.com>,
        "peng.zhang@corigine.com" <peng.zhang@corigine.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v2 1/2] net: flow_offload: add tc police action
 parameters
Thread-Topic: [PATCH net-next v2 1/2] net: flow_offload: add tc police action
 parameters
Thread-Index: AQHYI9hjOAeRza2oWk6NVVEw4zRgM6yXic+AgAAdK4CAAOP7gIAACf0A
Date:   Fri, 18 Feb 2022 02:22:06 +0000
Message-ID: <cca0b02dcef93272c05b8b037f93977c3e6302c0.camel@nvidia.com>
References: <20220217082803.3881-1-jianbol@nvidia.com>
         <20220217082803.3881-2-jianbol@nvidia.com>
         <DM5PR1301MB2172C0F6E86850B5646DAB84E7369@DM5PR1301MB2172.namprd13.prod.outlook.com>
         <a196d40f-d96f-3fb2-2189-a3906b340d95@nvidia.com>
         <DM5PR1301MB21721A9F0AE0615C8B83A079E7379@DM5PR1301MB2172.namprd13.prod.outlook.com>
In-Reply-To: <DM5PR1301MB21721A9F0AE0615C8B83A079E7379@DM5PR1301MB2172.namprd13.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.0-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9b594f2-7eb7-4898-acfc-08d9f28575d7
x-ms-traffictypediagnostic: SN1PR12MB2445:EE_
x-microsoft-antispam-prvs: <SN1PR12MB244527E626A52E345B2DCB27C5379@SN1PR12MB2445.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oEcJKZuXDXLAinVmQVsb/gKeanBfFGa3MkHSn12ofuaQ5sGrkoMv78YvWVDOCDIyjHKmkiIjv97k3u6ONyzdeDDXg/O/Pl4+jF081eGZLA0UYU4Z4SV16kBMxg4v9P4rXNLvp3EhfKK1SX2GoSYU/UQJQHjhg5C5L5fsrdQcgDSJL66wOis36wvL0TTVc+gMuTTWsQ0VlluM4FAhoJtmY7H9C1dxdD40vYKgeuhCK8KuQZYtESaZB5WbuXX+vDuus1yWx1MlEfAf+42gNeol+fSHwLUui1sFMAaZo/lDAj+piaUCchRNYFnPI6QOPpUFHFYoqSSPQ5mudcAGvitWNI3+UuQ3ZqODgdw8/EzDKSPNphAYQaM49VIoDNagvpzlrukx/6mFseo4pFr0yHVCcyA4qoIO7/gLc7KwZBGfwnWUVjZOtwgBftsj+hnNVNmtfMA9lzgDOLfW0yLAV1r7mDDpsIlBJHJODWV+nxIz4J0Ya864BebhOdADgq1+vVMXd/jWFnLyWofUZ6wZmWkpYUkmoD1mdcKOuZXwjqCamfOdkcsq9Xl0ioPSK/U7QIhTVoFrkeRDqFc5unZTbIewWw745tDU+JbTIX0Jbq6wQJU0JD8sb66P/iauN+439Yz3BKrAI0CHZdPJL2GLM/K1aqNwYRPowjZcUaDveNl6fo7TUAL/UW5iRsgzdYHaoqjxnkUOn/yl59esVJYZWnLN7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5196.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(5660300002)(122000001)(38100700002)(6486002)(508600001)(4326008)(316002)(2906002)(86362001)(83380400001)(64756008)(66556008)(54906003)(66476007)(66946007)(66446008)(110136005)(76116006)(53546011)(7416002)(6512007)(6506007)(91956017)(8936002)(8676002)(2616005)(71200400001)(36756003)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TW5aOGt2NnJRTjBBdmczamYwWERaVzFLQkRDdWplWmw4dGU0ekYxZkY5Mjc3?=
 =?utf-8?B?MG8wRENTYVB6dktsMU41ZHprd3RtLzRLRDdaSG1qUDhHRVhrSXU3K3hLTFM1?=
 =?utf-8?B?RE9UM0Y1WERsdkx2VkJyL2ZPREdkMFowTGRIMlY4MSs5djg2ZFFpcEs3Wjc2?=
 =?utf-8?B?WTVoZzRCV1Z1VDNHNStqeGZCdC8vLzZVSzdFckxmd2UwTWJLb2grNHNLT0Nu?=
 =?utf-8?B?dlcvS2RPdGtDOVhReE85VFc2VWRaRjYvbnQ5SGFncGF6MzJaY0hFeEtad1BG?=
 =?utf-8?B?cGtaVmVxa1Bjd21mUDVnQWZVSTBnNkhZSlRiai9UZmlSa2FnL0FSUHZaRG9M?=
 =?utf-8?B?YUE0MFZoRWtpZ0lranZ3QjRpb3RCV1NwMEJFbm1ZSnhmM3l4S29BL1NpR2ZH?=
 =?utf-8?B?Q1FUQm5TTjlYYVFCYjJ3WTNkQVoxbHZ0Z0R2VXJ0SmVSdXlrYlp5YkgzcUZk?=
 =?utf-8?B?eWo2NytERVVMcFZBeTN0MlFMNEg5OEVGYVhFcXlVaHlLS01aZXBuZjNvUDJO?=
 =?utf-8?B?dDE1eWpnZ0oyeTJxd1UwaWZQZUlRZGFrNzg0bFVKSEY3Rm9JckpSekpES1M0?=
 =?utf-8?B?OUJFNS9TZlEzS05SL3BhSDlxWFVOUHZFTHhEaGoyOFd3OU9wSkhUVlFoWVZs?=
 =?utf-8?B?L1RUeTl2cTA5YXlmYU9LNFRXOTY2V2ljeFdRblYrMW50OWV0V1NTdmFiTWFP?=
 =?utf-8?B?U256Wk9NbHVBMWtLUXdTNUNmWFVNeldtSU9xZm1OKzV5ODgyVytEOFRFMDdn?=
 =?utf-8?B?NUlXTTdhZjl1SkJDNUY5WHZ6cmtNdUd4bFdxekYzZHo4OHJzZ2ZRdHpjSmJs?=
 =?utf-8?B?N0FRaVNJb2RITk1sVlFjOHhCak9ETWwwZWFEdHRiR2NPMENueDlKUXVjWXJu?=
 =?utf-8?B?S3VWTUhUWWVEUDhCeVlnUnJMWitXYWV0RzJBa3p1ZGk3eWFONmoyS3JpSU9O?=
 =?utf-8?B?THNydkRDSDNUYStmKzIySUVRQ2tzZ1YxOEh3OVRFZTlwTjVlU2kzZFFUWlZU?=
 =?utf-8?B?TXFTQlZjSElWVWYxNzArd1Q0L2hXaVZZOXE0eDhNemFUK2hPeEZ0ZnlYOWZi?=
 =?utf-8?B?dWpvdXhzYUJMbTdlYm4wQUt4V1RlWU1KVGxOWlQrNnZGRGpzVUIwUm5FcElJ?=
 =?utf-8?B?QkJPbmFOSi8yTG0vU0RITHlHZHoxVExIUzQ5Mm9EakNURkJWeitYSG44bTJj?=
 =?utf-8?B?VW14Umhsd0xwcEhlZ2xSdW1TWnhnUzRGNGNwWWM5dXU3MHVJV1g1YllucFZv?=
 =?utf-8?B?VGtLQ1pMZ0Yrc2xsdHZpNE5jVXhMTmpNejNsTGtGczVqdXJPSmVpMU4xNG1C?=
 =?utf-8?B?Y1IvTEc3T1FwVmRGc1dDcnkvbUFmWWg5V01iK1J0QWxNUVNRbVZXT0QyVXFS?=
 =?utf-8?B?cnVJcm4ycGlORk9DeWxBVWhJWUw3OGtYcXRiQlc4MC8vcDl2MEpINnZIT1V2?=
 =?utf-8?B?aFB0QTY4ZHZpYXJBWC80MGliTjFjNWxWdHdCZW9TTjhUNTBuZEo2RjlNbmdP?=
 =?utf-8?B?MzdVUUFvUFhjU2JNc25Qd1pqd25lOTg4WXRJOGt3VElDdlVhRlBVVUhUU20w?=
 =?utf-8?B?SlVrMFU3NTJsVW5zQlRmdHJTNTh5ZlQrYkJRVEYxR3FUSTJjZkpwUmtsTGJm?=
 =?utf-8?B?aVpNN3FGMERsbEMwT2Z3aXdaNGxrbjRkRDgvQkdBek1BTWtsblhjVW1wYmov?=
 =?utf-8?B?cjdCMDl1SHllY1ZtZC9aTWtrMGRma3U0WlN2SXhCVDZZMFFEcGYrWEU2ZFYz?=
 =?utf-8?B?NnhCTmJ2WHN5Z2l4WmFjSnFTUmk4R21GY0I1V0xURHdUVE1laDJjck5tYWlQ?=
 =?utf-8?B?eXRmallUeUtUY09vS3V6enJwY05IY3kreU9YVDhPejh2SjdrRktkSk5vRFRJ?=
 =?utf-8?B?K3ZPK0JnRHpRUUoxYkJzWUYxTUdUczB0NS9DSThVS29mVFAwbElYb3QzMUhB?=
 =?utf-8?B?UDNxMjRPeVFHajdSOWpEVlRSWFhiNytISW54Wmd2TTBOcE4ycW5yYXVWWWRL?=
 =?utf-8?B?NGg3S2FucEY4SjFEenRSeDRXaUVDUmFENFA0YmtFZjlybmtjWlhsNzNXd0VL?=
 =?utf-8?B?ZGFlYmtJWkFzRnBOeVVnUTZLMkJJOWl0T2lRRGpzWDJheHFPWnRRRHJoMlNo?=
 =?utf-8?B?UWM0Y2hpWUtHa29qUmdNWnRpWm1YeWFoN3I5QlVYRVJSekhjOGE1eHpSVjUz?=
 =?utf-8?B?UlBTRk55WGF1RU02bzVNMlE0THRkRGtnSnNjbUZpQ2I0Sjh5U2ZsQXAyRHpm?=
 =?utf-8?Q?PI9YwKY5PxSfoEZn83fBZbsoH1SVMENDNkj7kHd8mc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <394401BC6B46DF48967E31C028FA2AC5@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5196.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9b594f2-7eb7-4898-acfc-08d9f28575d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2022 02:22:06.9870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YbjV4J6slmlrvhrP6VP6W7AERZCCGjemEqPtrLA6Gksg+lYtLEJdfasMhfpD0SHF07F/rM1qdbUhtnQQsGV2KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2445
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTAyLTE4IGF0IDAxOjQ2ICswMDAwLCBCYW93ZW4gWmhlbmcgd3JvdGU6DQo+
IE9uLCBGZWJydWFyeSAxNywgMjAyMiA4OjEwIFBNLCBSb2kgd3JvdGU6DQo+ID4gT24gMjAyMi0w
Mi0xNyAxMjoyNSBQTSwgQmFvd2VuIFpoZW5nIHdyb3RlOg0KPiA+ID4gT24gRmVicnVhcnkgMTcs
IDIwMjIgNDoyOCBQTSwgSmlhbmJvIHdyb3RlOg0KPiA+ID4gPiBUaGUgY3VycmVudCBwb2xpY2Ug
b2ZmbG9hZCBhY3Rpb24gZW50cnkgaXMgbWlzc2luZw0KPiA+ID4gPiBleGNlZWQvbm90ZXhjZWVk
DQo+ID4gPiA+IGFjdGlvbnMgYW5kIHBhcmFtZXRlcnMgdGhhdCBjYW4gYmUgY29uZmlndXJlZCBi
eSB0YyBwb2xpY2UNCj4gPiA+ID4gYWN0aW9uLg0KPiA+ID4gPiBBZGQgdGhlIG1pc3NpbmcgcGFy
YW1ldGVycyBhcyBhIHByZS1zdGVwIGZvciBvZmZsb2FkaW5nIHBvbGljZQ0KPiA+ID4gPiBhY3Rp
b25zIHRvIGhhcmR3YXJlLg0KPiA+ID4gPiANCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogSmlhbmJv
IExpdSA8amlhbmJvbEBudmlkaWEuY29tPg0KPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBSb2kgRGF5
YW4gPHJvaWRAbnZpZGlhLmNvbT4NCj4gPiA+ID4gUmV2aWV3ZWQtYnk6IElkbyBTY2hpbW1lbCA8
aWRvc2NoQG52aWRpYS5jb20+DQo+ID4gPiA+IC0tLQ0KPiA+ID4gPiBpbmNsdWRlL25ldC9mbG93
X29mZmxvYWQuaMKgwqDCoMKgIHwgMTMgKysrKysrKysrKw0KPiA+ID4gPiBpbmNsdWRlL25ldC90
Y19hY3QvdGNfcG9saWNlLmggfCAzMCArKysrKysrKysrKysrKysrKysrKysrDQo+ID4gPiA+IG5l
dC9zY2hlZC9hY3RfcG9saWNlLmPCoMKgwqDCoMKgwqDCoMKgIHwgNDYNCj4gPiArKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gPiA+IDMgZmlsZXMgY2hhbmdlZCwgODkgaW5z
ZXJ0aW9ucygrKQ0KPiA+ID4gPiANCj4gPiA+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2Zs
b3dfb2ZmbG9hZC5oDQo+ID4gPiA+IGIvaW5jbHVkZS9uZXQvZmxvd19vZmZsb2FkLmgNCj4gPiA+
ID4gaW5kZXgNCj4gPiA+ID4gNWI4YzU0ZWI3YTZiLi45NGNkZTZiYmM4YTUgMTAwNjQ0DQo+ID4g
PiA+IC0tLSBhL2luY2x1ZGUvbmV0L2Zsb3dfb2ZmbG9hZC5oDQo+ID4gPiA+ICsrKyBiL2luY2x1
ZGUvbmV0L2Zsb3dfb2ZmbG9hZC5oDQo+ID4gPiA+IEBAIC0xNDgsNiArMTQ4LDggQEAgZW51bSBm
bG93X2FjdGlvbl9pZCB7DQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqBGTE9XX0FDVElPTl9NUExT
X01BTkdMRSwNCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoEZMT1dfQUNUSU9OX0dBVEUsDQo+ID4g
PiA+IMKgwqDCoMKgwqDCoMKgwqBGTE9XX0FDVElPTl9QUFBPRV9QVVNILA0KPiA+ID4gPiArwqDC
oMKgwqDCoMKgwqBGTE9XX0FDVElPTl9KVU1QLA0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqBGTE9X
X0FDVElPTl9QSVBFLA0KPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgTlVNX0ZMT1dfQUNUSU9OUywN
Cj4gPiA+ID4gfTsNCj4gPiA+ID4gDQo+ID4gPiA+IEBAIC0yMzUsOSArMjM3LDIwIEBAIHN0cnVj
dCBmbG93X2FjdGlvbl9lbnRyeSB7DQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgc3RydWN0IHvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgLyoNCj4gPiA+ID4gRkxPV19BQ1RJT05fUE9MSUNFICovDQo+
ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHUz
MsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJ1cnN0Ow0KPiA+ID4g
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB1NjTCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByYXRlX2J5dGVzX3BzOw0KPiA+
ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHU2NMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBlYWtyYXRlX2J5dGVzXw0K
PiA+ID4gPiBwczsNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqB1MzLCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBh
dnJhdGU7DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgdTE2wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgb3Zlcmhl
YWQ7DQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHU2NMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJ1cnN0X3Br
dDsNCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgdTY0wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmF0ZV9wa3Rf
cHM7DQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHUzMsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG10dTsNCj4g
PiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzdHJ1
Y3Qgew0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBlbnVtIGZsb3dfYWN0aW9uX2lkwqDCoMKgwqAgYWN0X2lkOw0K
PiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqB1MzLCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGluZGV4Ow0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoH0gZXhjZWVkOw0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB7DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVudW0gZmxvd19hY3Rpb25f
aWTCoMKgwqDCoCBhY3RfaWQ7DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHUzMsKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgaW5kZXg7DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfSBub3RleGNlZWQ7DQo+ID4gPiBJdCBzZWVtcyBl
eGNlZWQgYW5kIG5vdGV4Y2VlZCB1c2UgdGhlIHNhbWUgZm9ybWF0IHN0cnVjdCwgd2lsbCBpdA0K
PiA+ID4gYmUgbW9yZQ0KPiA+IHNpbXBsZXIgdG8gZGVmaW5lIGFzOg0KPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHsNCj4gPiA+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBlbnVtIGZsb3dfYWN0aW9uX2lkwqDCoMKgwqAgYWN0X2lkOw0KPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHUz
MsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW5kZXg7DQo+ID4gPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9IGV4Y2VlZCwg
bm90ZXhjZWVkOw0KPiA+IA0KPiA+IHJpZ2h0LiBpdCBjYW4gYmUuDQo+ID4gDQo+ID4gPiANCj4g
PiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9IHBvbGljZTsNCj4gPiA+ID4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qge8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKg0KPiA+ID4g
PiBGTE9XX0FDVElPTl9DVCAqLw0KPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBpbnQgYWN0aW9uOw0KPiA+ID4gPiBkaWZmIC0tZ2l0IGEvaW5j
bHVkZS9uZXQvdGNfYWN0L3RjX3BvbGljZS5oDQo+ID4gPiA+IGIvaW5jbHVkZS9uZXQvdGNfYWN0
L3RjX3BvbGljZS5oIGluZGV4DQo+ID4gPiA+IDcyNjQ5NTEyZGNkZC4uMjgzYmRlNzExYTQyDQo+
ID4gPiA+IDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9pbmNsdWRlL25ldC90Y19hY3QvdGNfcG9saWNl
LmgNCj4gPiA+ID4gKysrIGIvaW5jbHVkZS9uZXQvdGNfYWN0L3RjX3BvbGljZS5oDQo+ID4gPiA+
IEBAIC0xNTksNCArMTU5LDM0IEBAIHN0YXRpYyBpbmxpbmUgdTMyDQo+ID4gPiA+IHRjZl9wb2xp
Y2VfdGNmcF9tdHUoY29uc3QNCj4gPiA+ID4gc3RydWN0IHRjX2FjdGlvbiAqYWN0KQ0KPiA+ID4g
PiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHBhcmFtcy0+dGNmcF9tdHU7DQo+ID4gPiA+IH0NCj4g
PiA+ID4gDQo+ID4gPiA+ICtzdGF0aWMgaW5saW5lIHU2NCB0Y2ZfcG9saWNlX3BlYWtyYXRlX2J5
dGVzX3BzKGNvbnN0IHN0cnVjdA0KPiA+ID4gPiArdGNfYWN0aW9uDQo+ID4gPiA+ICsqYWN0KSB7
DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB0Y2ZfcG9saWNlICpwb2xpY2UgPSB0b19w
b2xpY2UoYWN0KTsNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHRjZl9wb2xpY2VfcGFy
YW1zICpwYXJhbXM7DQo+ID4gPiA+ICsNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgcGFyYW1zID0g
cmN1X2RlcmVmZXJlbmNlX3Byb3RlY3RlZChwb2xpY2UtPnBhcmFtcywNCj4gPiA+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqANCj4gPiA+ID4gbG9ja2RlcF9pc19oZWxkKCZwb2xpY2UtPnRj
Zl9sb2NrKSk7DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoHJldHVybiBwYXJhbXMtPnBlYWsucmF0
ZV9ieXRlc19wczsNCj4gPiA+ID4gK30NCj4gPiA+ID4gKw0KPiA+ID4gPiArc3RhdGljIGlubGlu
ZSB1MzIgdGNmX3BvbGljZV90Y2ZwX2V3bWFfcmF0ZShjb25zdCBzdHJ1Y3QNCj4gPiA+ID4gdGNf
YWN0aW9uDQo+ID4gPiA+ICsqYWN0KSB7DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB0
Y2ZfcG9saWNlICpwb2xpY2UgPSB0b19wb2xpY2UoYWN0KTsNCj4gPiA+ID4gK8KgwqDCoMKgwqDC
oMKgc3RydWN0IHRjZl9wb2xpY2VfcGFyYW1zICpwYXJhbXM7DQo+ID4gPiA+ICsNCj4gPiA+ID4g
K8KgwqDCoMKgwqDCoMKgcGFyYW1zID0gcmN1X2RlcmVmZXJlbmNlX3Byb3RlY3RlZChwb2xpY2Ut
PnBhcmFtcywNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqANCj4gPiA+ID4gbG9j
a2RlcF9pc19oZWxkKCZwb2xpY2UtPnRjZl9sb2NrKSk7DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDC
oHJldHVybiBwYXJhbXMtPnRjZnBfZXdtYV9yYXRlOw0KPiA+ID4gPiArfQ0KPiA+ID4gPiArDQo+
ID4gPiA+ICtzdGF0aWMgaW5saW5lIHUxNiB0Y2ZfcG9saWNlX3JhdGVfb3ZlcmhlYWQoY29uc3Qg
c3RydWN0DQo+ID4gPiA+IHRjX2FjdGlvbg0KPiA+ID4gPiArKmFjdCkgew0KPiA+ID4gPiArwqDC
oMKgwqDCoMKgwqBzdHJ1Y3QgdGNmX3BvbGljZSAqcG9saWNlID0gdG9fcG9saWNlKGFjdCk7DQo+
ID4gPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB0Y2ZfcG9saWNlX3BhcmFtcyAqcGFyYW1zOw0K
PiA+ID4gPiArDQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoHBhcmFtcyA9IHJjdV9kZXJlZmVyZW5j
ZV9wcm90ZWN0ZWQocG9saWNlLT5wYXJhbXMsDQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgDQo+ID4gPiA+IGxvY2tkZXBfaXNfaGVsZCgmcG9saWNlLT50Y2ZfbG9jaykpOw0KPiA+
ID4gPiArwqDCoMKgwqDCoMKgwqByZXR1cm4gcGFyYW1zLT5yYXRlLm92ZXJoZWFkOw0KPiA+ID4g
PiArfQ0KPiA+ID4gPiArDQo+ID4gPiA+ICNlbmRpZiAvKiBfX05FVF9UQ19QT0xJQ0VfSCAqLw0K
PiA+ID4gPiBkaWZmIC0tZ2l0IGEvbmV0L3NjaGVkL2FjdF9wb2xpY2UuYyBiL25ldC9zY2hlZC9h
Y3RfcG9saWNlLmMNCj4gPiA+ID4gaW5kZXgNCj4gPiA+ID4gMDkyM2FhMmI4ZjhhLi4wNDU3YjZj
OWM0ZTcgMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL25ldC9zY2hlZC9hY3RfcG9saWNlLmMNCj4gPiA+
ID4gKysrIGIvbmV0L3NjaGVkL2FjdF9wb2xpY2UuYw0KPiA+ID4gPiBAQCAtNDA1LDIwICs0MDUs
NjYgQEAgc3RhdGljIGludCB0Y2ZfcG9saWNlX3NlYXJjaChzdHJ1Y3QgbmV0DQo+ID4gPiA+ICpu
ZXQsDQo+ID4gPiA+IHN0cnVjdCB0Y19hY3Rpb24gKiphLCB1MzIgaW5kZXgpDQo+ID4gPiA+IMKg
wqDCoMKgwqDCoMKgwqByZXR1cm4gdGNmX2lkcl9zZWFyY2godG4sIGEsIGluZGV4KTsgfQ0KPiA+
ID4gPiANCj4gPiA+ID4gK3N0YXRpYyBpbnQgdGNmX3BvbGljZV9hY3RfdG9fZmxvd19hY3QoaW50
IHRjX2FjdCwgaW50ICppbmRleCkNCj4gPiA+ID4gew0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqBp
bnQgYWN0X2lkID0gLUVPUE5PVFNVUFA7DQo+ID4gPiA+ICsNCj4gPiA+ID4gK8KgwqDCoMKgwqDC
oMKgaWYgKCFUQ19BQ1RfRVhUX09QQ09ERSh0Y19hY3QpKSB7DQo+ID4gPiA+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAodGNfYWN0ID09IFRDX0FDVF9PSykNCj4gPiA+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBhY3RfaWQgPSBGTE9X
X0FDVElPTl9BQ0NFUFQ7DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBl
bHNlIGlmICh0Y19hY3QgPT3CoCBUQ19BQ1RfU0hPVCkNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBhY3RfaWQgPSBGTE9XX0FDVElPTl9EUk9Q
Ow0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZWxzZSBpZiAodGNfYWN0
ID09IFRDX0FDVF9QSVBFKQ0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGFjdF9pZCA9IEZMT1dfQUNUSU9OX1BJUEU7DQo+ID4gPiA+ICvCoMKg
wqDCoMKgwqDCoH0gZWxzZSBpZiAoVENfQUNUX0VYVF9DTVAodGNfYWN0LCBUQ19BQ1RfR09UT19D
SEFJTikpIHsNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGFjdF9pZCA9
IEZMT1dfQUNUSU9OX0dPVE87DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAqaW5kZXggPSB0Y19hY3QgJiBUQ19BQ1RfRVhUX1ZBTF9NQVNLOw0KPiA+ID4gRm9yIHRoZSBU
Q19BQ1RfR09UT19DSEFJTsKgIGFjdGlvbiwgdGhlIGdvdG9fY2hhaW4gaW5mb3JtYXRpb24gaXMN
Cj4gPiA+IG1pc3NpbmcNCj4gPiBmcm9tIHNvZnR3YXJlIHRvIGhhcmR3YXJlLCBpcyBpdCB1c2Vm
dWwgZm9yIGhhcmR3YXJlIHRvIGNoZWNrPw0KPiA+ID4gDQo+ID4gDQo+ID4gd2hhdCBpbmZvcm1h
dGlvbiBkbyB5b3UgbWVhbj8NCj4gU29ycnksIEkgZG8gbm90IHJlYWxpemUgdGhlIGNoYWluIGlu
ZGV4IGlzIGluIHRoZSByZXR1cm4gdmFsdWUgb2YNCj4gaW5kZXgsIHNvIHBsZWFzZSBqdXN0IGln
bm9yZS4NCg0KT0sNCg0KPiBJdCBzZWVtcyB0aGUgZGVmaW5pdGlvbiBvZiBpbmRleCBpcyBhIGxp
dHRsZSBjb25mdXNlZCBzaW5jZSBpbg0KPiBUQ19BQ1RfR09UT19DSEFJTiBjYXNlLCBpdCBtZWFu
cyBjaGFpbiBpbmRleCBhbmQgaW4gVENfQUNUX0pVTVAgY2FzZSwNCj4gaXQgbWVhbnMganVtcCBj
b3VudC4gDQo+IEp1c3QgYSBzdWdnZXN0aW9uLCBjYW4gd2UgY2hhbmdlIHRoZSBpbmRleCBkZWZp
bml0aW9uIGFzIGEgdW5pb24gYXM6DQo+IMKgwqDCoMKgwqDCoMKgwqB1bmlvbiB7DQo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHUzMiBjaGFpbl9pbmRl
eDsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdTMy
IGptcF9jbnQ7DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgew0KPiBXRFlUPw0K
PiANCg0KWWVzLCB3ZSB3aWxsIGNvbnNpZGVyIHRoYXQuIFRoYW5rcyENCg==
