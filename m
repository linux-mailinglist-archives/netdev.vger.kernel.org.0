Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A5F58E02C
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 21:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241905AbiHIT1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 15:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241503AbiHIT1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 15:27:15 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2077.outbound.protection.outlook.com [40.107.100.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C219FCB
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 12:27:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtLnapoHWhS7ny4wUg/YM0EX0U3z7nrQJHVnTtVLh9yl88tgUabzR6KvFPk0DMRWO15wydVQHo4CsJtaYF5GqP/uUGGJ2WO4a1Q8ZLaPp7KwUI7fehgJZwjGZ7GcPVkl1UZ3VnhHt3NftNBweLKlwkWUP8vmiWfufeGJT+O3iWE50RWlL41FEpk0/VLPvkJ64PABYhjuGUbM5LV8M7KrB9wS1JfFqkqf5xlIulNIeEToBbcJ6EElwctwsuPKxAakaxDW97FrltumvZE/iSzNJksF1NTJV28d1RpxOi6o3cbQj8z3wmSh2l3NAvgjnvB9VQEdJeboOK7ARhiO5DI4eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SdwAg/BJRysKrzmDd6uen+GxIZPQC80ttmuD89X4O7g=;
 b=NUdJDsElCtEfHvE+jEyXzfZdbdG0u4pt2k08Vx8ibce/xVt8jmHmMhC7SSvCP2iCDu03I9pdnb1WrtSEceh8wL1qUrpu/xzJshO1ajWXxQ5CpK0EH2G1GIWeX7PeMU1yOj9Wpt2N4Kg16YE7dPTxDc1Da4OfI/rssAWzDVNpTVDHrGYYW4GSDfLkSoMHwyskxvkm47KK7/m4MY6IkoAA19JKa+UWwMAU4fIulkBh9w2fyQH29VZBGk1kkBhqIOAA8iTNPVxRjVtQjQLky87IeAp3f8CW7gnjI2MynoxZMZaGrvAfYoFxHvRDCZHviCiP3NPFFTdxzggkS7Ui7Bejlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdwAg/BJRysKrzmDd6uen+GxIZPQC80ttmuD89X4O7g=;
 b=OXKiqujt27JJKdkX3OJeJmhhKrfXtNW2rwZOcMnNPvWV1Wt4U1Jlrq78rDh2iq7OUY2kl1yVuqUYRKAiz9ZIE492/6Nf8O0ZZWqifJkH2UHgw8qGMhG1iiMy2FSkwlfR7ynWBZQdymh3e0BCajE4mKEUPdBczGQsCxYlL1vLg229xiQBT1XS9vG9V9AZe3o4eByVyWFdSPmZSln0MxmswmetmHJpks7iQGFgQRmSGc3PUxeI9UFDY/Pyl/gcjeX9gunjwXffC2/Fm3VGc21srTyoKnwsiaU8kqmwOWSIuPgQ1mur8hi2gZj2mzTV7LHjC5+tTH8+xSLhT7wZLKQFUA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BYAPR12MB3142.namprd12.prod.outlook.com (2603:10b6:a03:de::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 9 Aug
 2022 19:27:11 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::957c:a0c7:9353:411e]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::957c:a0c7:9353:411e%5]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 19:27:11 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V4 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Topic: [PATCH V4 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Index: AQHYncLBTkGC7Q3QJk+hIdvX3SqZ2q2KXRuQgAF0rYCAAdS1UIAC3HsAgAAA0NCAAT2VgIAVTvbw
Date:   Tue, 9 Aug 2022 19:27:11 +0000
Message-ID: <PH0PR12MB5481C539B4A2D6AA67605B8CDC629@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220722115309.82746-1-lingshan.zhu@intel.com>
 <20220722115309.82746-4-lingshan.zhu@intel.com>
 <PH0PR12MB548193156AFCA04F58B01A3CDC909@PH0PR12MB5481.namprd12.prod.outlook.com>
 <6dc2229c-f2f3-017f-16fa-4611e53c774e@intel.com>
 <PH0PR12MB5481D9BBC9C249840E4CDF7EDC929@PH0PR12MB5481.namprd12.prod.outlook.com>
 <9d9d6022-5d49-6f6e-a1ff-562d088ad03c@intel.com>
 <PH0PR12MB548133788748EF91F959C143DC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <9e27b28c-f88b-87c4-d869-d4984ece2066@intel.com>
In-Reply-To: <9e27b28c-f88b-87c4-d869-d4984ece2066@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbe5eaf0-c830-454e-cdf6-08da7a3d2859
x-ms-traffictypediagnostic: BYAPR12MB3142:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2lCEPeFXl7BtXUn7u8qRYOqINGZxjH9oa37uc7fBkeK0uSVMiwOeW4XxRWX+7tXYawwRS2p9i/HfJP8KO8QwT7V+kkRm6/eK0gm0BuP19flffKE1uAAFZzctAD1nOmfVO4lGiJwfo3P04dn2tySWOEa9L1r4uZFIDIG/jyy2HX4oSgPiZevBuuzYYER6Aa98T8qcxyDKTsKq7SiuywxLWa8WneC1HfW9xskusAepxVhpz1Fadh5wWcMAThQyHKYqQdocEWaAB3nKjRBBbCCbXvbAIdH9gMdZGm2c+aGsSEtwdY8Z74UaPv188AnVbmhS4k/gfOGhs7rc8POnT83QzpHTTbVXMaDIvc50Qm4nL/VZGJcj7/eBqLTgCBfWAOLy41JrkD/L8WnFwtHqpQurKidKhefEuusz9laBHU+OsdaQBKE9s6fmp46NFKYgCuflNsC1fkWJF8B4e/tF46jcu+YeT7S92GthUE5v7dtbKCA9MmITSqlFbM1CqeSS189q0Byo71x/UhK6+QTv/n3BUS7Md6L//H6ebHOSb+4FT8psBogwP+AfZtQBpZ+AMHum5m2WSUoc3mZjivA4yDxVft+Z85sExqzt3i8LvIn/28saQ6nYX3Oicxj7yS220LfNyfeWHBPHQB0IBhAK6hfzFtKJQFjbqeFdHkeq6NqY3oHMHlAW5mPNYRm5wTEodQimjy99jdOXew/naQyMSRBAuyHMRdxhxcRabg897zwee6aPJ+x8kCLZGHVxlNmlRI9NT8Rz1UJS3ZwN91KZbhHKLTd9GkYzgD5f/oW+7kZ1vt/E1COcLwJ7mfyeETkBDfei
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(64756008)(66446008)(110136005)(71200400001)(33656002)(41300700001)(4326008)(55016003)(7696005)(6506007)(53546011)(8676002)(83380400001)(5660300002)(66946007)(54906003)(66556008)(66476007)(2906002)(38100700002)(76116006)(316002)(122000001)(86362001)(9686003)(38070700005)(52536014)(478600001)(26005)(186003)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TmFVVmcvTkJIcVFMVTl1NkpIdlNKSS9SSjN2dGRqY1pTY1IzcG4ya24ySEJa?=
 =?utf-8?B?dFZnVFJKckF0YmovRmJCU0htR0U1QkcrZ0JNcDcwM3dYaWhXSnRwaUxBcUZV?=
 =?utf-8?B?ZFhySFBHRHV2MGl2cjlpUyt0Y29sazZEMzdqR3dQckdWZXB2OTBpRTBxN3NI?=
 =?utf-8?B?bk96R21UbG10eXE4dmM2RTYxUWRCZzJFbklmYUpLQmEyVnYvcEhXQkpFcmV0?=
 =?utf-8?B?VWJ3K2ZqT1Q5dTIwQW9SNnBaeXYvbzVoR1lyM2NnRGRxNno2N1BVSnlHeUpF?=
 =?utf-8?B?S1ROUExhcDBwbG5uaTRWVHZuYXhWYTZRaUR4MDhZeFMzWjBMT3FkZmlqVUtl?=
 =?utf-8?B?N1ozUXQwVVBCY0lOdmRHOEN5VVFoUHhPUTg2ODBhcVN5Nk1rU1V0bW9MdUw4?=
 =?utf-8?B?Nlo4ODJ1UEY1bEJlRU5NdVhiYjBqTlBOOFArSWIvSGtISE9vRzdqeTBOb3pU?=
 =?utf-8?B?dzBod01PcXlqTExkT3E5cHdudmJYZGttYitudDFORjlFRGVRdEEzSGRVelNp?=
 =?utf-8?B?YXczNU1ZMkRUUkhlaHlYUjlYR2Rnd2x5Vy9abzhSL1VjMGxndTZveTMxTVg1?=
 =?utf-8?B?OW95R1JEbzFDVnZsdFp0SnVhYjcraEZtK2hLY3piOUtyUE40d1UyTDNlc2xK?=
 =?utf-8?B?blc3NUZWem56b09ERzhjL1djemoyLytyalZTMkZranAwKzV5cXpKMVpNVXhn?=
 =?utf-8?B?WHZEUG1TT09FdWV2b1dLZlpPVklQdzZvYlBTRCt2ZkI3dXNBdTBJOW5hR29z?=
 =?utf-8?B?Q0FpSDFwUzFOWVpueE5QQmJBZmRHcTFUSng5Z0U3U1E4RXIzSzZLelVPbGZO?=
 =?utf-8?B?aWFHOGM3R2U5SUpXSnZzYldBN2ZGU1N4Ri9yR2J4S1ZDcGJTZ3M2dTVPNHZs?=
 =?utf-8?B?RHFaNGFrYlFWeG9rRjlHbXhIcytRSkpKTHV5L040ODdaNGZMUU5iaEgvclgw?=
 =?utf-8?B?T29MQ1BWMEk4cHJjZXVucHRDNnUxcSsrQTdwVUVEbktGMmJGaDN5cUlUTEtH?=
 =?utf-8?B?cHNxVDhodWl2ZHFYcnFETnFHNWhEenhWYXMvRTJMNGcrVy9JSXpsMURRSXRj?=
 =?utf-8?B?c3BBRUxQeExNcmJsT3dzV2s1TXFlZUtKOWNWMWJmc25GMTY2VER6aUNIeGZR?=
 =?utf-8?B?MG1LZ2NLL3ZDMmMwMnIvMWk5T1hiUDlMVi9zMXcrdXBpVkdYUENoRzMyZVhH?=
 =?utf-8?B?SVdCK2ZKMnlMRzFmMjBMa2lyZW55dHNNb0I5TEZwS3NkSGc0Mm8xa2JkajdI?=
 =?utf-8?B?TlUvZGlWanZYM2Q0TmNHMmFrRFg0aU90SjFSZkZ0clJKYjhyaWZ3d3dRUjZ0?=
 =?utf-8?B?U3NiTitaTWloR1pXaEZPb3J5bEhqQklOMUxreEd4dXZ4ZkdaWDB4cERhNGs0?=
 =?utf-8?B?Y2k5SW84dkQ4VFhnSzVoYk42aTVCTTMyZlN6UTc4TjZEdStzN05pWWxGbitB?=
 =?utf-8?B?ajBmTThrYm9yVnJ4M0E3clQ3NDloS2hra2dyVnozb3RFdFpWd3gzV1p3NVo2?=
 =?utf-8?B?UWIxM1pwSGlIUVVTY2FnTWNjYkRpZmJocVJrN3Y5bGpyL1NvZnFOaTJ5U0xO?=
 =?utf-8?B?Z09xVkdtT01uQ1UxdXNTWjJsa01xOXQ5K3lZOG9ZU2txNmY1SDZ2SCtYTlBV?=
 =?utf-8?B?TGZSbHBlMmp6Q2FYY05oUkdhTzBOWmZDRkJUSHE0N2N6V1dJNS9ZMFk1UUM4?=
 =?utf-8?B?amJFTTBKbllQN3BoRys1U0UwNzlLdGt2VzJLdzBwMHdtNFdPN3FiWEMxc0Z1?=
 =?utf-8?B?SjF0NmlGbDVBUmFoeW5aWFJIdzl2dmtNcUhFTm4wckxJb2NLK1lDN3F2dk5t?=
 =?utf-8?B?bUFaSW5BamtvV2d4Q0EzY2xPenFkbUVYM0NqeGZ3aC9idXFURzlkeEpqT3Mx?=
 =?utf-8?B?dHZVdGM5RksxVlRZOG5uY2JSZ090bk5MOXIwWm1VaU9WbHJDYlpiaUVFQUNh?=
 =?utf-8?B?L2l6Q3lxdE1URGo0OVBmRUI4SXNXc1REQlFPa0gyL0szckQvZklYdWQvTGJ6?=
 =?utf-8?B?OVloUTFSa3EzVGpaOHByVitqckV1Y1RNTFVUTDQ0a2tJSHJ4RVkrT2Z3bHZG?=
 =?utf-8?B?WDZsL0dCR1JVTlk3cnJPT05Ia2w4QjRRNGdsdncvaXIzMHVnSDRibVR4WHZ2?=
 =?utf-8?Q?dtO8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe5eaf0-c830-454e-cdf6-08da7a3d2859
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 19:27:11.4444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YEPv13W8vKN78Wp19S0CS8O+VuR8cs0oty6PHXkzjucvEOggW6w4cPcXmkVMPTVEZPrmmWRp6WY36RH3Jbg5yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3142
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBaaHUsIExpbmdzaGFuIDxsaW5nc2hhbi56aHVAaW50ZWwuY29tPg0KPiBTZW50OiBX
ZWRuZXNkYXksIEp1bHkgMjcsIDIwMjIgMjowMiBBTQ0KPiANCj4gDQo+IE9uIDcvMjYvMjAyMiA3
OjA2IFBNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4+IEZyb206IFpodSwgTGluZ3NoYW4gPGxp
bmdzaGFuLnpodUBpbnRlbC5jb20+DQo+ID4+IFNlbnQ6IFR1ZXNkYXksIEp1bHkgMjYsIDIwMjIg
NzowMyBBTQ0KPiA+Pg0KPiA+PiBPbiA3LzI0LzIwMjIgMTE6MjEgUE0sIFBhcmF2IFBhbmRpdCB3
cm90ZToNCj4gPj4+PiBGcm9tOiBaaHUsIExpbmdzaGFuIDxsaW5nc2hhbi56aHVAaW50ZWwuY29t
Pg0KPiA+Pj4+IFNlbnQ6IFNhdHVyZGF5LCBKdWx5IDIzLCAyMDIyIDc6MjQgQU0NCj4gPj4+Pg0K
PiA+Pj4+DQo+ID4+Pj4gT24gNy8yMi8yMDIyIDk6MTIgUE0sIFBhcmF2IFBhbmRpdCB3cm90ZToN
Cj4gPj4+Pj4+IEZyb206IFpodSBMaW5nc2hhbiA8bGluZ3NoYW4uemh1QGludGVsLmNvbT4NCj4g
Pj4+Pj4+IFNlbnQ6IEZyaWRheSwgSnVseSAyMiwgMjAyMiA3OjUzIEFNDQo+ID4+Pj4+Pg0KPiA+
Pj4+Pj4gVGhpcyBjb21taXQgYWRkcyBhIG5ldyB2RFBBIG5ldGxpbmsgYXR0cmlidXRpb24NCj4g
Pj4+Pj4+IFZEUEFfQVRUUl9WRFBBX0RFVl9TVVBQT1JURURfRkVBVFVSRVMuIFVzZXJzcGFjZSBj
YW4NCj4gPj4gcXVlcnkNCj4gPj4+PiBmZWF0dXJlcw0KPiA+Pj4+Pj4gb2YgdkRQQSBkZXZpY2Vz
IHRocm91Z2ggdGhpcyBuZXcgYXR0ci4NCj4gPj4+Pj4+DQo+ID4+Pj4+PiBTaWduZWQtb2ZmLWJ5
OiBaaHUgTGluZ3NoYW4gPGxpbmdzaGFuLnpodUBpbnRlbC5jb20+DQo+ID4+Pj4+PiAtLS0NCj4g
Pj4+Pj4+ICAgICBkcml2ZXJzL3ZkcGEvdmRwYS5jICAgICAgIHwgMTMgKysrKysrKysrLS0tLQ0K
PiA+Pj4+Pj4gICAgIGluY2x1ZGUvdWFwaS9saW51eC92ZHBhLmggfCAgMSArDQo+ID4+Pj4+PiAg
ICAgMiBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiA+
Pj4+Pj4NCj4gPj4+Pj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZkcGEvdmRwYS5jIGIvZHJpdmVy
cy92ZHBhL3ZkcGEuYyBpbmRleA0KPiA+Pj4+Pj4gZWJmMmYzNjNmYmU3Li45YjBlMzliMmYwMjIg
MTAwNjQ0DQo+ID4+Pj4+PiAtLS0gYS9kcml2ZXJzL3ZkcGEvdmRwYS5jDQo+ID4+Pj4+PiArKysg
Yi9kcml2ZXJzL3ZkcGEvdmRwYS5jDQo+ID4+Pj4+PiBAQCAtODE1LDcgKzgxNSw3IEBAIHN0YXRp
YyBpbnQNCj4gdmRwYV9kZXZfbmV0X21xX2NvbmZpZ19maWxsKHN0cnVjdA0KPiA+Pj4+Pj4gdmRw
YV9kZXZpY2UgKnZkZXYsICBzdGF0aWMgaW50IHZkcGFfZGV2X25ldF9jb25maWdfZmlsbChzdHJ1
Y3QNCj4gPj4+Pj4+IHZkcGFfZGV2aWNlICp2ZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqbXNnKSAgew0K
PiA+Pj4+Pj4gICAgIAlzdHJ1Y3QgdmlydGlvX25ldF9jb25maWcgY29uZmlnID0ge307DQo+ID4+
Pj4+PiAtCXU2NCBmZWF0dXJlczsNCj4gPj4+Pj4+ICsJdTY0IGZlYXR1cmVzX2RldmljZSwgZmVh
dHVyZXNfZHJpdmVyOw0KPiA+Pj4+Pj4gICAgIAl1MTYgdmFsX3UxNjsNCj4gPj4+Pj4+DQo+ID4+
Pj4+PiAgICAgCXZkcGFfZ2V0X2NvbmZpZ191bmxvY2tlZCh2ZGV2LCAwLCAmY29uZmlnLCBzaXpl
b2YoY29uZmlnKSk7DQo+ID4+Pj4+PiBAQA0KPiA+Pj4+Pj4gLQ0KPiA+Pj4+Pj4gODMyLDEyICs4
MzIsMTcgQEAgc3RhdGljIGludCB2ZHBhX2Rldl9uZXRfY29uZmlnX2ZpbGwoc3RydWN0DQo+ID4+
Pj4+PiB2ZHBhX2RldmljZSAqdmRldiwgc3RydWN0IHNrX2J1ZmYgKm1zDQo+ID4+Pj4+PiAgICAg
CWlmIChubGFfcHV0X3UxNihtc2csIFZEUEFfQVRUUl9ERVZfTkVUX0NGR19NVFUsDQo+IHZhbF91
MTYpKQ0KPiA+Pj4+Pj4gICAgIAkJcmV0dXJuIC1FTVNHU0laRTsNCj4gPj4+Pj4+DQo+ID4+Pj4+
PiAtCWZlYXR1cmVzID0gdmRldi0+Y29uZmlnLT5nZXRfZHJpdmVyX2ZlYXR1cmVzKHZkZXYpOw0K
PiA+Pj4+Pj4gLQlpZiAobmxhX3B1dF91NjRfNjRiaXQobXNnLA0KPiA+Pj4+Pj4gVkRQQV9BVFRS
X0RFVl9ORUdPVElBVEVEX0ZFQVRVUkVTLCBmZWF0dXJlcywNCj4gPj4+Pj4+ICsJZmVhdHVyZXNf
ZHJpdmVyID0gdmRldi0+Y29uZmlnLT5nZXRfZHJpdmVyX2ZlYXR1cmVzKHZkZXYpOw0KPiA+Pj4+
Pj4gKwlpZiAobmxhX3B1dF91NjRfNjRiaXQobXNnLA0KPiA+Pj4+Pj4gVkRQQV9BVFRSX0RFVl9O
RUdPVElBVEVEX0ZFQVRVUkVTLCBmZWF0dXJlc19kcml2ZXIsDQo+ID4+Pj4+PiArCQkJICAgICAg
VkRQQV9BVFRSX1BBRCkpDQo+ID4+Pj4+PiArCQlyZXR1cm4gLUVNU0dTSVpFOw0KPiA+Pj4+Pj4g
Kw0KPiA+Pj4+Pj4gKwlmZWF0dXJlc19kZXZpY2UgPSB2ZGV2LT5jb25maWctPmdldF9kZXZpY2Vf
ZmVhdHVyZXModmRldik7DQo+ID4+Pj4+PiArCWlmIChubGFfcHV0X3U2NF82NGJpdChtc2csDQo+
ID4+Pj4+PiBWRFBBX0FUVFJfVkRQQV9ERVZfU1VQUE9SVEVEX0ZFQVRVUkVTLA0KPiA+Pj4+Pj4g
K2ZlYXR1cmVzX2RldmljZSwNCj4gPj4+Pj4+ICAgICAJCQkgICAgICBWRFBBX0FUVFJfUEFEKSkN
Cj4gPj4+Pj4+ICAgICAJCXJldHVybiAtRU1TR1NJWkU7DQo+ID4+Pj4+Pg0KPiA+Pj4+Pj4gLQly
ZXR1cm4gdmRwYV9kZXZfbmV0X21xX2NvbmZpZ19maWxsKHZkZXYsIG1zZywgZmVhdHVyZXMsDQo+
ICZjb25maWcpOw0KPiA+Pj4+Pj4gKwlyZXR1cm4gdmRwYV9kZXZfbmV0X21xX2NvbmZpZ19maWxs
KHZkZXYsIG1zZywNCj4gZmVhdHVyZXNfZHJpdmVyLA0KPiA+Pj4+Pj4gKyZjb25maWcpOw0KPiA+
Pj4+Pj4gICAgIH0NCj4gPj4+Pj4+DQo+ID4+Pj4+PiAgICAgc3RhdGljIGludA0KPiA+Pj4+Pj4g
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC92ZHBhLmgNCj4gPj4+Pj4+IGIvaW5jbHVk
ZS91YXBpL2xpbnV4L3ZkcGEuaCBpbmRleA0KPiA+Pj4+Pj4gMjVjNTVjYWIzZDdjLi4zOWYxYzNk
N2MxMTIgMTAwNjQ0DQo+ID4+Pj4+PiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgvdmRwYS5oDQo+
ID4+Pj4+PiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvdmRwYS5oDQo+ID4+Pj4+PiBAQCAtNDcs
NiArNDcsNyBAQCBlbnVtIHZkcGFfYXR0ciB7DQo+ID4+Pj4+PiAgICAgCVZEUEFfQVRUUl9ERVZf
TkVHT1RJQVRFRF9GRUFUVVJFUywJLyogdTY0ICovDQo+ID4+Pj4+PiAgICAgCVZEUEFfQVRUUl9E
RVZfTUdNVERFVl9NQVhfVlFTLAkJLyoNCj4gdTMyICovDQo+ID4+Pj4+PiAgICAgCVZEUEFfQVRU
Ul9ERVZfU1VQUE9SVEVEX0ZFQVRVUkVTLAkvKiB1NjQgKi8NCj4gPj4+Pj4+ICsJVkRQQV9BVFRS
X1ZEUEFfREVWX1NVUFBPUlRFRF9GRUFUVVJFUywJLyoNCj4gdTY0ICovDQo+ID4+Pj4+Pg0KPiA+
Pj4+PiBJIGhhdmUgYW5zd2VyZWQgaW4gcHJldmlvdXMgZW1haWxzLg0KPiA+Pj4+PiBJIGRpc2Fn
cmVlIHdpdGggdGhlIGNoYW5nZS4NCj4gPj4+Pj4gUGxlYXNlIHJldXNlIFZEUEFfQVRUUl9ERVZf
U1VQUE9SVEVEX0ZFQVRVUkVTLg0KPiA+Pj4+IEkgYmVsaWV2ZSB3ZSBoYXZlIGFscmVhZHkgZGlz
Y3Vzc2VkIHRoaXMgYmVmb3JlIGluIHRoZSBWMyB0aHJlYWQuDQo+ID4+Pj4gSSBoYXZlIHRvbGQg
eW91IHRoYXQgcmV1c2luZyB0aGlzIGF0dHIgd2lsbCBsZWFkIHRvIGEgbmV3IHJhY2UgY29uZGl0
aW9uLg0KPiA+Pj4+DQo+ID4+PiBSZXR1cm5pbmcgYXR0cmlidXRlIGNhbm5vdCBsZWFkIHRvIGFu
eSByYWNlIGNvbmRpdGlvbi4NCj4gPj4gUGxlYXNlIHJlZmVyIHRvIG91ciBkaXNjdXNzaW9uIGlu
IHRoZSBWMyBzZXJpZXMsIEkgaGF2ZSBleHBsYWluZWQgaWYNCj4gPj4gcmUtdXNlIHRoaXMgYXR0
ciwgaXQgd2lsbCBiZSBhIG11bHRpcGxlIGNvbnN1bWVycyBhbmQgbXVsdGlwbGUNCj4gPj4gcHJv
ZHVjZXMgbW9kZWwsIGl0IGlzIGEgdHlwaWNhbCByYWNpbmcgY29uZGl0aW9uLg0KPiA+IEkgcmVh
ZCB0aGUgZW1haWxzIHdpdGggc3ViamVjdCA9ICIgUmU6IFtQQVRDSCBWMyAzLzZdIHZEUEE6IGFs
bG93IHVzZXJzcGFjZQ0KPiB0byBxdWVyeSBmZWF0dXJlcyBvZiBhIHZEUEEgZGV2aWNlIg0KPiA+
IEkgY291bGRu4oCZdCBmaW5kIG11bHRpcGxlIGNvbnN1bWVycyBtdWx0aXBsZSBwcm9kdWNlcnMg
d29ya2luZyBvbiBzYW1lIG5sYQ0KPiBtZXNzYWdlLg0KPiBJZiB0aGlzIGF0dHIgaXMgcmV1c2Vk
LCB0aGVuIHRoZXJlIGNhbiBiZSBtdWx0aXBsZSBpcHJvdXRlMiBpbnN0YW5jZXMgb3Igb3RoZXIN
Cj4gYXBwbGljYXRpb25zIHF1ZXJ5aW5nIGZlYXR1cmUgYml0cyBvZiB0aGUgbWFuYWdlbWVudCBk
ZXZpY2UgYW5kIHRoZSB2RFBBDQo+IGRldmljZSBzaW11bHRhbmVvdXNseSwgYW5kIGJvdGgga2Vy
bmVsIHNpZGUgbWFuYWdlbWVudCBmZWF0dXJlIGJpdHMgZmlsbGVyDQoNCj4gZnVuY3Rpb24gYW5k
IHZEUEEgZGV2aWNlIGZlYXR1cmUgYml0cyBmaWxsZXIgZnVuY3Rpb24gY2FuIHdyaXRlIHRoZSBO
TEENCj4gbWVzc2FnZSBhdCB0aGUgc2FtZSB0aW1lLiBUaGF0J3MgdGhlIG11bHRpcGxlIGNvbnN1
bWVycyBhbmQgcHJvZHVjZXJzLA0KPiBhbmQgbm8gbG9ja3MNCk5vLiBFYWNoIGZpbGxpbmcgdXAg
aGFwcGVucyBpbiBlYWNoIHByb2Nlc3MgY29udGV4dC4gVGhlcmUgaXMgbm8gcmFjZSBoZXJlLg0K
