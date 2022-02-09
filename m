Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC1C4AECE0
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243042AbiBIIle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:41:34 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243035AbiBIIlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:41:31 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8240C03C197;
        Wed,  9 Feb 2022 00:41:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZbZcid06uH019u2nISt1CxwnZBLqS6zW5FpXMH+fsxm/Sq7Un+QVE6krHmT2x61GNJ1xAuXGRmTVmE3nvRsnHLN5kH332SeGMiiQvzkyO2/dyB4vQN0xskvuV7Z9+tayXGXCUSSVAkr5hAXl1WIZPG9IhkFQTjTYn/Q8wglFPzuN7cjm2+p4EWDDG5INMSbkBUIkNEVUs4htB6RO+YmE7Uji35y9Je1oc9aknaiY2s1dBoXgWejFILM1MD8saXWdNhuxdixqYvox6438Xn1CYs6kL9m+Fxyw7F3yuumoQsGRAYx9gNv3aEiy/JQGGw6RgEWgN4K64Hg1IbdQ7Fhaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sEXCxW7AXQfQzNc7TcgjCQeRJ++ibEh6gr1RwVXB6lw=;
 b=c9IP/CGhLzUgjXyIH9ew3Sf5fQLUPM3hTjnlcC/e7RlvJnn6XlaUA5BgkRef52ONs/kqPD36lsLkJGrlYiUGBUx4SEQEWhx+E5tyWddMHlz6pwY4XrsrotjMfH85bSt3DgpbE9IPXxhafaVaV8VHyJrMZ++k9cmlHutZcB768SRyHOSc+/VqOGyvwgQQ/OQf49GzfFWkb2uONW5+16zpGaiRq2zxtYnEKH/2KDKMEXyUshbiGOuZ9EgTpeX+zwQyWo/Gnk9WS7aZCnvJsX4+GmHzqjFQXfJ7FdUpn4KR14aEY12Mhc2mpxLx0JWZU0CnwOOxIaVcCpPPz4fYIMHVKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEXCxW7AXQfQzNc7TcgjCQeRJ++ibEh6gr1RwVXB6lw=;
 b=TyZ1P/LnwzgKnKeUHuAj+cJ7GrMTwIvE4SWWd+SnaVsH4R/POfEUGxTZvazMSUM8c30DFYEFQMzw70Rkf2AHAKavQFfMnmaWTR0blY7LmHUpVb5Y9FFAOyPk8Xgsv0kd6kyhvc5ztfqnmVTbWD39eyO0CCI2afP2DLnYHvB73hc=
Received: from DM6PR02MB5386.namprd02.prod.outlook.com (2603:10b6:5:75::25) by
 DM5PR0201MB3480.namprd02.prod.outlook.com (2603:10b6:4:7b::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.11; Wed, 9 Feb 2022 08:40:47 +0000
Received: from DM6PR02MB5386.namprd02.prod.outlook.com
 ([fe80::edcb:5b1a:1a4a:f93e]) by DM6PR02MB5386.namprd02.prod.outlook.com
 ([fe80::edcb:5b1a:1a4a:f93e%6]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 08:40:48 +0000
From:   Srinivas Neeli <sneeli@xilinx.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Appana Durga Kedareswara Rao <appanad@xilinx.com>,
        Srinivas Goud <sgoud@xilinx.com>, git <git@xilinx.com>
Subject: RE: [PATCH] can: xilinx_can: Add check for NAPI Poll function
Thread-Topic: [PATCH] can: xilinx_can: Add check for NAPI Poll function
Thread-Index: AQHYHQfhCbkJD7wJyUaac0q2SvLXYKyK2RMAgAAKW4CAAAF/gIAAAjnQ
Date:   Wed, 9 Feb 2022 08:40:48 +0000
Message-ID: <DM6PR02MB53867DD5740FAA93CB5BC3B4AF2E9@DM6PR02MB5386.namprd02.prod.outlook.com>
References: <20220208162053.39896-1-srinivas.neeli@xilinx.com>
 <20220209074930.azbn26glrxukg4sr@pengutronix.de>
 <DM6PR02MB53861A46A48B4689F668BEE9AF2E9@DM6PR02MB5386.namprd02.prod.outlook.com>
 <20220209083155.xma5m7tayy2atyoo@pengutronix.de>
In-Reply-To: <20220209083155.xma5m7tayy2atyoo@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc58fd1e-0502-486a-28b1-08d9eba7deff
x-ms-traffictypediagnostic: DM5PR0201MB3480:EE_
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-microsoft-antispam-prvs: <DM5PR0201MB34806CCFE85C91C95F70591CAF2E9@DM5PR0201MB3480.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cH94kob1lq600Z7YJ23ItSZl4OJL/CINm33s4fb+HNncxJF3RBdCslGZGroSrKUXQEYl0zJzWQlNuHf2rYwVkIC4wZdS6qvIkH4JLUTXiK/G5j3iFB34CHLgQb+y4o7Roc17zRK2Z/hSv3q8rfXIisX5zLluji6EaCjF9z3FXF5w+0gmx170V7LbIuAy3yNloLJKAqDniGCGY7bp+pkQ0tjivN8RAO7JjvwQhwpVGpU5pzLEaJkFUTu42YyHogfi8q1wo8ktYBP0vi1q+nePTfMhKyHQbrYV45derrhpr7atRpNICXhrfSLcRvfy+EpgAVKmEYMERUQN7CNrEylJgWLqBBZ1FGm+nH+HOQ6AdQmWopy38zOPA/K8ROzrdOnnxe7uyLWvo1xc0yUgOP4HTiaoqCkZxHjViaxnkFBq98Lt0RSxU78C3LdJaIHfSEFxnvHY+fZ8aulz8Te54OwfIn9D0ptweLoFXxVQeeEjUo4fSv5J0MlCtPQXG4UKozNIkECZmfDKzUHZonYwqKg3BnAD0MsEwaWpbp9xubj8ncQ40QV0ivRAt95sz6FKwNVxfXlyrWZP6Dh/P6Xu1vWVpuOaJwB3QNyv9eO7fx4SLH5EfCTuY5WUh0AEmYFjJisjPVPQEbCBDB1h9+Emp9GsETY3ruXQHlT6NiFNV9NDoSCOjtDp4aW0kMJ9/bTppwmuzhhxrgugifdwnnjcAPpW6rZyJ54sWrnAPNi1aS72+RUwDv9gfZ1V7c2/C9YCPDSCaa3jF5BSqm/dFwNrfAFI6hxysAHxHnvcBW9xXKHt8yg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR02MB5386.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(186003)(26005)(966005)(107886003)(9686003)(53546011)(7696005)(6506007)(71200400001)(86362001)(83380400001)(52536014)(38070700005)(38100700002)(122000001)(33656002)(4326008)(76116006)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(316002)(6916009)(54906003)(2906002)(55016003)(8936002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmhZZFhSQjRyZUlSb2k0c2Jwc2luTUtBU3FBTFJIZHZjR2ZoK2FXcTYxeHph?=
 =?utf-8?B?djYyWm02eTh0MEE1QXlWV3krZHhtelFRTmQ2U3NTQWE1UFVDRmFRVWNQSVJY?=
 =?utf-8?B?RllHMEZZRVZqMHdwVXVjNi9hbVhlZnF4cWtEeU5CVjQrQmYvSUh6NklHTnBy?=
 =?utf-8?B?NTJ0a3VZSTJlQm1CdmMrVmUvdVZCUDcrbVNITUo5YUtURnA2dGwxeGo5MEVT?=
 =?utf-8?B?NFpOUHNvdEhIZlowNThrcUtxbUJNcUc2cE9zVEU2TE9HbzNCUTUxemNKTGwx?=
 =?utf-8?B?NnV3YlowOGtIOE16b2pmWm9WRkhnc3JqYm1rYkhLaS9zUmt3QXZqSXJZUjdo?=
 =?utf-8?B?ZkxuQjhJb1R1eG81alZyZkxoVE5DQmJIR3ViOGU2TWxmUjRuVlJneUFMbHBS?=
 =?utf-8?B?MFgvVUp2aGhWeUhidk9XNUR5blMxR0p3YnRrNWpFcHV5K2txbDB4L3VrV25P?=
 =?utf-8?B?TktnMlBXM2JCaG11eG1ndlhJTFNMNmR5N1JybmVOMEljSE14M2NRMWZvVWZJ?=
 =?utf-8?B?RThpd3FuQnl0cGNCOEZEV0Joc3JVVTZDV0ZRemFycUV5aWlIRzB5dllWVVdr?=
 =?utf-8?B?VmpDVWdULzlZNzlzMFpIeVpHTlhxNkN1ZXk1azVtRnhNcDJvUWZqV205VTRE?=
 =?utf-8?B?ZFhId0ZsQUEza3hPSmsyTG5LRFB1aXM5Z25PVHBpVzdGbFZtU01DeDdjM00v?=
 =?utf-8?B?MS9DbFZBZVZDS0VramJCK0kra3Q0S2tyTCszb0lsV01QQ1AyV2Zkc1J1c3Zs?=
 =?utf-8?B?VTlGTFp6ZjQ2YWIrNVZiZE5DYzdMN2JUcXF6OUhNZWN1QmU1WFlHRGZRTW5C?=
 =?utf-8?B?em5DMXF1QWI3WmtjV1FpVkczZ0dhdUF4dnN4UWpFbytWd3RmUEVvL3JXNHJS?=
 =?utf-8?B?ZHBEZGVsZFhiSWZFMk1peXg5d2R4eTllR1NsUyt1YWk1QVJ4M2NiRnZEa3VE?=
 =?utf-8?B?aUlSSnV6eEpXb3dmZGJSeDFROHZUdWxDeU9mTm5QWU94THF0OSthMGhyRTFB?=
 =?utf-8?B?T3hiZUp6YWgwMnQ1Q2NxTDJFdXhUWUpQK0FmZWVCYVdTR2RhYWJza1F2eStw?=
 =?utf-8?B?QW5XN1JWUEQzT1dMTks0SU1BS0xyM0ZWSDFXcnYxWHc2YnNnVDFyVkdKYzQ3?=
 =?utf-8?B?b1AvNHVaVDV0cUtFNEFrR3ZaM3dCK3RQNE1uaGZyTzlJcmQxWlRlRFJCVmRy?=
 =?utf-8?B?QlpGSlhWSkdjV1BRQlJTQ3g0OGhzZFljUjlNR25zMlk4VVJnRk5EU0pqVjFY?=
 =?utf-8?B?RnB6eGhUYThDbTFEbUZUNHdWL1pJMThtTUtWN1dFdFRLZmVLYjVnWkVaQnp3?=
 =?utf-8?B?WVkyQzFudEgwYVlJZEN1WmpqcERMc01hdFNLMjlPaEM1MkF6c1Y1NHVDSHJi?=
 =?utf-8?B?ZzNzZjlZU29zU0pQZWFMTjlsQjYzR2NIakNvWTNrQ05Ka0pYTWZWYjQzYzZt?=
 =?utf-8?B?ZHlmQXpSMFI5ZEpUWVN3cEpGRzlMMEdveGhabERabjdKSHZGbld2OGZFaG5Y?=
 =?utf-8?B?U3RBYklNNkp0M05UaUZCU0t6T2pyMzFsdEZrN1JXdnVIZDc0bjZ2eFIrdkJs?=
 =?utf-8?B?ZHdhYys1L2c4OUNNT3lyRzZBRWEwNVkvZHgwUFJUalhOU0pjdXJ3SjVMODE4?=
 =?utf-8?B?V25mQytzUHJ0emNkQkNvU2pKTk9KTlpmdC9QODB3cDhPMys2SVN2cDFVNnNI?=
 =?utf-8?B?aHlIUHJ5Q2x4UXl5K0R5akU4MFNza2RBWmdXNWhIeEFQcjBUcEdxVUhEbkRB?=
 =?utf-8?B?Y004LzNKajhaOGI4ZEo3VlFVcjRydXo0bDdhUWxmOWdWNDd1S2NMVUJ3MlA5?=
 =?utf-8?B?WEJzT1NhNS9ELzRXa1p1NzdVNFlHWjk1MXdUL25Pa0YzMHR0a3BkNU1QeWNP?=
 =?utf-8?B?UXl5ZWZRWWZEVzl6QUNDTjBTNG01K3NxL2JXbTRzNVQyNDIxa3NsSi9kRUNZ?=
 =?utf-8?B?eXljb2R0WHNsMDdkNFlBV1hKcGJoR2pvbjM3bC9Mb3g4WjE3WEJiNFJTZ2lk?=
 =?utf-8?B?V1dpSm54L0plOUhGKzE3Rjh4MUE5Wm9nZ2RlWi82cjRRaUpuMUZLSVVJK21H?=
 =?utf-8?B?R3Y1b1JsVTQ1ZnVIVTBCYXg4RWdpL1hLSHRMdlcyWFBPaDQ1eUpRUW5EUGh0?=
 =?utf-8?B?c24wS1NzSzNreGpWeWs1THVKNVJUUzN2MnN5cXBtb0U1L2lzSFFvdkpWald1?=
 =?utf-8?Q?gL9a4VDYqXRr9qI6V4cxQpc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR02MB5386.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc58fd1e-0502-486a-28b1-08d9eba7deff
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 08:40:48.1559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I9unqkWI/WemvY+7V5rMKAbcclfwlUVQ0oqwIBkzjwyvEhB0qrFroEJXPDstba7+AXJXKGBrkTekDBXaYljhtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0201MB3480
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXJjIEts
ZWluZS1CdWRkZSA8bWtsQHBlbmd1dHJvbml4LmRlPg0KPiBTZW50OiBXZWRuZXNkYXksIEZlYnJ1
YXJ5IDksIDIwMjIgMjowMiBQTQ0KPiBUbzogU3Jpbml2YXMgTmVlbGkgPHNuZWVsaUB4aWxpbngu
Y29tPg0KPiBDYzogd2dAZ3JhbmRlZ2dlci5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFA
a2VybmVsLm9yZzsgTWljaGFsDQo+IFNpbWVrIDxtaWNoYWxzQHhpbGlueC5jb20+OyBsaW51eC1j
YW5Admdlci5rZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1hcm0t
a2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwu
b3JnOyBBcHBhbmEgRHVyZ2EgS2VkYXJlc3dhcmEgUmFvDQo+IDxhcHBhbmFkQHhpbGlueC5jb20+
OyBTcmluaXZhcyBHb3VkIDxzZ291ZEB4aWxpbnguY29tPjsgZ2l0DQo+IDxnaXRAeGlsaW54LmNv
bT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gY2FuOiB4aWxpbnhfY2FuOiBBZGQgY2hlY2sgZm9y
IE5BUEkgUG9sbCBmdW5jdGlvbg0KPiANCj4gT24gMDkuMDIuMjAyMiAwODoyOTo1NSwgU3Jpbml2
YXMgTmVlbGkgd3JvdGU6DQo+ID4gPiBPbiAwOC4wMi4yMDIyIDIxOjUwOjUzLCBTcmluaXZhcyBO
ZWVsaSB3cm90ZToNCj4gPiA+ID4gQWRkIGNoZWNrIGZvciBOQVBJIHBvbGwgZnVuY3Rpb24gdG8g
YXZvaWQgZW5hYmxpbmcgaW50ZXJydXB0cyB3aXRoDQo+ID4gPiA+IG91dCBjb21wbGV0aW5nIHRo
ZSBOQVBJIGNhbGwuDQo+ID4gPg0KPiA+ID4gVGhhbmtzIGZvciB0aGUgcGF0Y2guIERvZXMgdGhp
cyBmaXggYSBidWc/IElmIHNvLCBwbGVhc2UgYWRkIGEgRml4ZXM6DQo+ID4gPiB0YWcgdGhhdCBs
aXN0cyB0aGUgcGF0Y2ggdGhhdCBpbnRyb2R1Y2VkIHRoYXQgYnVnLg0KPiA+DQo+ID4gSXQgaXMg
bm90IGEgYnVnLiBJIGFtIGFkZGluZyBhZGRpdGlvbmFsIHNhZmV0eSBjaGVjayggVmFsaWRhdGlu
ZyB0aGUNCj4gPiByZXR1cm4gdmFsdWUgb2YgIm5hcGlfY29tcGxldGVfZG9uZSIgY2FsbCkuDQo+
IA0KPiBUaGFua3MgZm9yIHlvdXIgZmVlZGJhY2suIFNob3VsZCB0aGlzIGdvIGludG8gY2FuIG9y
IGNhbi1uZXh0Pw0KDQpJZiBwb3NzaWJsZSBwbGVhc2UgYXBwbHkgb24gYm90aCBicmFuY2hlcy4N
Cg0KPiANCj4gcmVnYXJkcywNCj4gTWFyYw0KPiANCj4gLS0NCj4gUGVuZ3V0cm9uaXggZS5LLiAg
ICAgICAgICAgICAgICAgfCBNYXJjIEtsZWluZS1CdWRkZSAgICAgICAgICAgfA0KPiBFbWJlZGRl
ZCBMaW51eCAgICAgICAgICAgICAgICAgICB8IGh0dHBzOi8vd3d3LnBlbmd1dHJvbml4LmRlICB8
DQo+IFZlcnRyZXR1bmcgV2VzdC9Eb3J0bXVuZCAgICAgICAgIHwgUGhvbmU6ICs0OS0yMzEtMjgy
Ni05MjQgICAgIHwNCj4gQW10c2dlcmljaHQgSGlsZGVzaGVpbSwgSFJBIDI2ODYgfCBGYXg6ICAg
KzQ5LTUxMjEtMjA2OTE3LTU1NTUgfA0K
