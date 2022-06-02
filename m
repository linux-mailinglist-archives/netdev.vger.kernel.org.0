Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF8653BD0E
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 19:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237392AbiFBRPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 13:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiFBRPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 13:15:17 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7531CC5CA;
        Thu,  2 Jun 2022 10:15:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3FIDp71+ZeORWAZowO3+AW8kHo3uL6O9ogerbcAx/ZIRnBgv6lQQ7JMfTOfFlFUsO+PQXeEIabPxdHQCVWfWlo0Zhozh7g0I9SmQggmSfC69wVlChxcOGN/YxrMp8K1tdl1Mi2J4yjnubBDSUEzmPB2Pfwwi7G1+GbxjDZjJQVHNhyuCj87uFgnznvwKFFYvfn8iUPdjPYYGNF3R/It2zCufcNCK9TSxvc98c4Lbm0qsgRbdJenGi/vwyuNZiR8KnAP9ogz2C6g9eGI4SjpDMA6wHflIPskZDsg8v056wP4OkOpg6hJ3vmKsgZzPUpcHrlzuC5B6IQ/Gja2Z9M5+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D8OycNrX0CknwgtT6IXxnU5bZlafhqCxIBnqrKUVx5E=;
 b=dflxIeG9H9uRPOGg4QDAS4sbMUyOQP+uA0BiAbfOE95M0bhPjJcbLrBsJdeGkTRosvlvyebf3GxUpNpxvqn8ojNowFMgdkGo+DwLABxRF9lWIHcDdzgqB4fmT/UN80YA/M39FDBV7X4q0QCIbJtNh4upmKB/Gdtyeef3kIj3AG/rPGCcpXz9PO+LmZQQZIMSWym2Aqab/mUqFURNs5nUJvq/TyuQH/XibmZwsjLgK3XLJbyOWQbPDJYDNQQQEcOijOUF8f9OZk1eDnUV1kWUbsIOZQ57roqn9uTSbDfbvQFCAQEgU762A6BRZo91BpDjyEEi8pQi6fRx7Eiy3UuRLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D8OycNrX0CknwgtT6IXxnU5bZlafhqCxIBnqrKUVx5E=;
 b=Hl/AriEUsVS4qu2aLrp1XpihLW00u8/xjW1V3bHYYhub4Z/BkHtEZcoB+SARvFGVm2ubNKixoM5dvVSgEECmEK+mtdOZWm1ptqiOLPJJmoQT0SL7g/Nq0n+cwkx1bsYedtNldl4MHQ05Xymf4sAYgcyuoyrnFbKbGhPcQPvq5HU=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by MN2PR10MB4125.namprd10.prod.outlook.com (2603:10b6:208:1df::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Thu, 2 Jun
 2022 17:15:13 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::84d6:8aea:981:91e5]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::84d6:8aea:981:91e5%5]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 17:15:13 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net-sysfs: allow changing sysfs carrier when interface is
 down
Thread-Topic: [PATCH] net-sysfs: allow changing sysfs carrier when interface
 is down
Thread-Index: AQHYdhitF3sF8MdKyEyE/FAADx5cL607THmAgACL6YCAAG4kgIAACD8AgAAI2QCAAATTAA==
Date:   Thu, 2 Jun 2022 17:15:13 +0000
Message-ID: <f22f16c43411aafc0aaddd208e688dec1616e6bb.camel@infinera.com>
References: <20220602003523.19530-1-joakim.tjernlund@infinera.com>
         <20220601180147.40a6e8ea@kernel.org>
         <4b700cbc93bc087115c1e400449bdff48c37298d.camel@infinera.com>
         <20220602085645.5ecff73f@hermes.local>
         <b4b1b8519ef9bfef0d09aeea7ab8f89e531130c8.camel@infinera.com>
         <20220602095756.764471e8@kernel.org>
In-Reply-To: <20220602095756.764471e8@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=infinera.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1cd70255-af41-4e37-519f-08da44bb74b1
x-ms-traffictypediagnostic: MN2PR10MB4125:EE_
x-microsoft-antispam-prvs: <MN2PR10MB4125138690D2CEB988A1D839F4DE9@MN2PR10MB4125.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CViH9ohONoJ4n5gu3kcvLEouBdXtmGVX1o3LGlV6Lf6nQkcFft8PqajTA4uWK8b8moJQV9yTfwUCLaSnXib+nKcXN1zvSr6OPtTlg//oWo0qG+qBMD6O/SCd12LAT5luHYNG4XmgIMyU+7S2IrEf4199ETySThY/VqJ3WTSAgEKvckqn0teNnjH0SrskFz8KjYQ8a6lJZ8IWR593ruHo48uo6we6If6K2eaiQUjAJQ2akPkUb5aeo3q1RFhhDnkK0PsDhGZPblrgywWgXBnVD5QRuxhe3/FCZaWyWHVYPryDPteJgOHXQxFjreR2D0I191BwUrcGU4uDfm/esknwiuWBX3mL4f44zrieZnWV68N2iGt/hLvt6KZaG7JXKr5F9/TPYujvwUD5RBv2c94dJg1zRJxxIo24fvf6Zd9rb4OuL/YaqmRo6EepxNx6Cv0CUqwJ4dRRtW0Q0htZrHKUTOi4yJHAoZKWPzUgV8Acqw+gG3XDcxCjhB5c3QuEbF9wA8UKBl+1dRx3TpE5Hnxu0cJ44d6ZgNg41deXJPkoJQdOfTIY99X14icHBhJPMt0tny+6MwldznNsyzJhjXAr/ZbgXksZVN1EuHX3HwKYZFljkj63lYs4uvyjmb3r4yLUafa6+tJx9/2d5tST7rqpp74Xmz4VkFaJwnqJBvaTI/zEObFdS8+hUOFvI3SXtu3ZsCWKeFgE/RkfS9J0TM5WDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(316002)(38070700005)(8676002)(64756008)(66476007)(66946007)(83380400001)(66556008)(76116006)(66446008)(4326008)(186003)(71200400001)(91956017)(6486002)(508600001)(6916009)(54906003)(26005)(6512007)(86362001)(8936002)(38100700002)(36756003)(5660300002)(2906002)(6506007)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3NMblRBUXp6YURKVHVKOEZxd3ZMRGlWUmIvUHVjUTRJRHRSV2RKbXlyTjRB?=
 =?utf-8?B?L0JObWRESyt6VjhKVms4bG9iSnZINTZhMXgrNlRPd3R5bDRqd0o3cHFPMFA4?=
 =?utf-8?B?Snp1VEJ3aVJxRUF4N1VLSXgxZUlZcjJwRTNuTThZaFFPdHNwVHpEU3pqN2pk?=
 =?utf-8?B?QVdpNEV5K1pleVFtOEJNb3BXdlBCWEhBb2JXdFc1dVJQNERnamdHenBydTlJ?=
 =?utf-8?B?Y2w5V2t3SVpOdjlIcktXdG1mNE9acE93T1E3WWcvYzdBSWhKRUZWQ29za3RK?=
 =?utf-8?B?SjIycFFxTHpid3pIUzNkUUVNYlA0alJtRU1Pajh5eGxaVTA0UjBKOFI0OE5l?=
 =?utf-8?B?U2NXWUpXM0tYeTBEeU5xaFFkWmFsZFJzTzRjcCtxejlpZDlXanhNVEhoR3Vk?=
 =?utf-8?B?Q054b1g0VXBqUElVSzJBYTdabU5ZQTBhOVowMzJESDg3ajg4M3dUWk5keFQw?=
 =?utf-8?B?NGsvUTl5aTBQV0ZOYmFTdjZJWnN2L1VlVWdKRDlESGlmV0FnZi80dXFEeGh4?=
 =?utf-8?B?UlQrMUJvQ2ZzVHdJOTlXb2VCRmVwVG9STXl4bFpPekQxSUtxNlV0NzVTeDVN?=
 =?utf-8?B?NnRnYnd5K1JvenJnY3pPUFVOeUoyZ1kzV0xwcW1wRlE2TzdISjVrVmU2R2FI?=
 =?utf-8?B?NFFMYTRYd1ZQUHRDbndsb05MM1NTNzNGa3BtcVNoVC9FUHoyamdLc09WMGd1?=
 =?utf-8?B?RVMxODJmaStVaE1yTTFmc0NnZDVRYVpvdEJmLzNuREoydmJ1SzA1U2hyQTBk?=
 =?utf-8?B?b2JFcjI2TVhvQ0V0UXNqZGxBRWRPNnhOWStPT2xJOWhKQzhqTDBvbmhrMFk0?=
 =?utf-8?B?TDBVMGl0bnhQMUlGWktaYm1EM0plcy81WnFUVGIzajhkb0xKSzFDM0gzOTkx?=
 =?utf-8?B?dzNwK1JxNUc3a05tTm5BTndJcitDMXZqbC90OFA0aG1lS1cxemoxK2gwUDJB?=
 =?utf-8?B?RkxrNHZ1cTRzNmNVckYyd2ZOUWlFUmNCQmp0bUpMQVhiU1ZqaHAwNldyRTU3?=
 =?utf-8?B?aDR2Z2g1STBQUndvVk0ySmFTZVFCd2dvMXRQa3JTMUhRemR3VkhpcWpMblc0?=
 =?utf-8?B?ZHcxeXBUcVFlcGV2M3RWZEVSNGxKdjdpRWNqNVZnMVlOWU5zNUVYWjkzUHBM?=
 =?utf-8?B?YjdOelNjNzJiMnc0bzV0R0o0U3k5c3FKbWhsczNwelFVUCtXQlNrUjFtREhn?=
 =?utf-8?B?WUthc3lsWDBuKy9xck9Rc3d2dElhMUgwdTBjQXlsQ0JFWnd5TTNMY1lvUmd0?=
 =?utf-8?B?cWFPZk42YlkyU1pKS2w0NUZnMVE1cEEzcDBSSVkxQ1JPZ2p1R0Z5RG1ZSUtu?=
 =?utf-8?B?TWpUVm95bHVYNFFlSENkaWRzeVU1anpKLytaeXpBbnN3RFlaVzQvMWU0UmNK?=
 =?utf-8?B?UkFiYUhlM1FaSWVwQTMwcHU0NWtQbmJvMlFSVmRXbG1jUWZWdDBCUDJ1SCtV?=
 =?utf-8?B?RDNad28rOGc2YjQ1VUZCR2ZDMHdMQ1llSnc2cDB4ZHRqNE00dVdqZmcreHNq?=
 =?utf-8?B?eFNONHd2Y3ZOaW9jd1N3UW0reDI0MFFoN01pczNLNWEvUmVDT2o5N083Q21u?=
 =?utf-8?B?bEhuQS9jVUNWTUdQbUREb0d3UXE1SmhYbXpxL2VvZXBNL2VWZHg4UHVXVWV0?=
 =?utf-8?B?c0xBSWkrZHc5N2RoeHNqbzMvc0FrblBlcTRRS01ncFlLOWpPR215aXBaa2F4?=
 =?utf-8?B?ZFhlTm1yOEFQOXk5RW95aThYZ25zbzkvRzJ5VW81TDV1cGN1ODlJekFLZVhp?=
 =?utf-8?B?NHg4T3lVR2g1TnZOT0kydlRGWWN5VWErK3FDNndSYk1GYjhleHFSR3loSU50?=
 =?utf-8?B?L3Nrcmk0blN6VGp2MXVuOVJCMGhCZEZXVEhOVVZldTE4dFU4T1VCbGVrQVM3?=
 =?utf-8?B?YXRjMWF0SFg0OXF2OVNhT0N5SVNiVm8zWlNOZDZTUERtQXpsNVgvUVIzbmtz?=
 =?utf-8?B?aTVNSFNqNi93K01wRGJwTGFLcE94OGc2RVBxanU4dzEwSFUwQlplSmlJVGd5?=
 =?utf-8?B?Tk9Xang4bGl0ZTZoYUFjQ2lZSUVmbHV1TVAxeENEcWJtTlZpakY1V2RWT0Rk?=
 =?utf-8?B?QW1sazYzekNHVFpsYVlFaXhZV0tiK2pRQ1FoaXdqb3JOZFdFWTRmYVhmTzli?=
 =?utf-8?B?THRQTEVpZjJEa0MvT21vdkNCNHE3VmNRcHBzNWN0YndiR21mdmt3VkdzbmNj?=
 =?utf-8?B?VUdCUUVvUlN6RmpCWnpmdlJJQXRzZHpzMDl3ZHJQWERxZWF2bWt5WVVCaEVh?=
 =?utf-8?B?OHA3WXd2ajJlb2lteFlBdm1XbW9MR2l6ZHpHV2FZSzZCbGZwRHJyZ09xRDlH?=
 =?utf-8?B?d0k5RnczSHRxcllMZzlheGtqU1diQkk4NXRpMXIydWFadFZWYXJaNnlFU2t5?=
 =?utf-8?Q?9v8YlxzTyaaQRndE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0C77E10FD76DB4DACAA8332C28A9D27@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cd70255-af41-4e37-519f-08da44bb74b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2022 17:15:13.3385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MQphtocbW6hThrVgnp/FIRfjtb4wmmto+ofKeC3ZNzeJ4jyYwe9keC99sJ9PGNIhs8vVVb0AM5qxaABOcLzP5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4125
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA2LTAyIGF0IDA5OjU3IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAyIEp1biAyMDIyIDE2OjI2OjE4ICswMDAwIEpvYWtpbSBUamVybmx1bmQgd3Jv
dGU6DQo+ID4gT24gVGh1LCAyMDIyLTA2LTAyIGF0IDA4OjU2IC0wNzAwLCBTdGVwaGVuIEhlbW1p
bmdlciB3cm90ZToNCj4gPiA+ID4gU3VyZSwgb3VyIEhXIGhhcyBjb25maWcvc3RhdGUgY2hhbmdl
cyB0aGF0IG1ha2VzIGl0IGltcG9zc2libGUgZm9yIG5ldCBkcml2ZXINCj4gPiA+ID4gdG8gdG91
Y2ggYW5kIHJlZ2lzdGVycyBvciBUWCBwa2dzKGNhbiByZXN1bHQgaW4gU3lzdGVtIEVycm9yIGV4
Y2VwdGlvbiBpbiB3b3JzdCBjYXNlLg0KPiANCj4gV2hhdCBpcyAib3VyIEhXIiwgd2hhdCBrZXJu
ZWwgZHJpdmVyIGRvZXMgaXQgdXNlIGFuZCB3aHkgY2FuJ3QgdGhlDQo+IGtlcm5lbCBkcml2ZXIg
dGFrZSBjYXJlIG9mIG1ha2luZyBzdXJlIHRoZSBkZXZpY2UgaXMgbm90IGFjY2Vzc2VkDQo+IHdo
ZW4gaXQnZCBjcmFzaCB0aGUgc3lzdGVtPw0KDQpJdCBpcyBhIGN1c3RvbSBhc2ljIHdpdGggc29t
ZSBob21lZ3Jvd24gY29udHJvbGxlci4gVGhlIGZ1bGwgY29uZmlnIHBhdGggaXMgdG9vIGNvbXBs
ZXggZm9yIGtlcm5lbCB0b28NCmtub3cgYW5kIGRlcGVuZHMgb24gdXNlciBpbnB1dC4gVGhlIGNh
c2hpbmcvVFggVE1PIHBhcnQgd2FzIG5vdCBwYXJ0IG9mIHRoZSBkZXNpZ24gcGxhbnMgYW5kDQpJ
IGhhdmUgYmVlbiBkb3duIHRoaXMgcm91dGUgd2l0aCB0aGUgSFcgZGVzaWduZXJzIHdpdGhvdXQg
c3VjY2Vzcy4NCg0KPiANCj4gPiBNYXliZSBzbyBidXQgaXQgc2VlbXMgdG8gbWUgdGhhdCB0aGlz
IGxpbWl0YXRpb24gd2FzIHB1dCBpbiBwbGFjZSB3aXRob3V0IG11Y2ggdGhvdWdodC4NCj4gDQo+
IERvbid0IG1ha2UgdW5uZWNlc3NhcnkgZGlzcGFyYWdpbmcgc3RhdGVtZW50cyBhYm91dCBzb21l
b25lIGVsc2UncyB3b3JrLg0KPiBXaG9ldmVyIHRoYXQgcGVyc29uIHdhcy4NCg0KVGhhdCB3YXMg
bm90IG1lYW50IHRoZSB3YXkgeW91IHJlYWQgaXQsIHNvcnJ5IGZvciBiZWluZyB1bmNsZWFyLg0K
VGhlIGNvbW1pdCBmcm9tIDIwMTIgc2ltcGx5IHNheXM6DQpuZXQ6IGFsbG93IHRvIGNoYW5nZSBj
YXJyaWVyIHZpYSBzeXNmcw0KICAgIA0KICAgIE1ha2UgY2FycmllciB3cml0YWJsZQ0KDQo=
