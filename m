Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C39D6E7499
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 10:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjDSIEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 04:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjDSIEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 04:04:00 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2321B19BF
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 01:03:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBbCtv3BwS6Ey6FhDKsxiFZU2rjQaL6/L8S7kzndRD8Bk8BwQthHFPhxye6SbwnaErgKXVPRRqk8/xqVO7CtNtez3rTfMsvHULTZMFkoT5PezN4Y4zIO3yvvH+QIWfadIBekUEG0voK38lIfOwqMCHLzwgXvwBWnAdBIEFN+GuVX++zGJPzYPuTCZcOuagY+RkLTRvbmYoltHa7iWu20Loi3VMD8iNL31aLll2m1Qci2EpS4x1dMgon3rsvm+xYlp2IEauSu0B755tnBp/VW4JrUUticYrLHdYLSC67kcFxE0Gr25BY9osP9j7oz9vtF2mIkXiBL8Mv7ID02wcVvIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5WK6osbt0/PKrLF1sXNGppM4AeQsH0TDdsdjdMEhP94=;
 b=hjdhlNMP+DIEKdDFAR3WJWkybTK5ubO6elhUOCSqNAKV5oltH5DKZhm/t/Yp9vSEb47iGrCoEWqzPD/1+xWlgrfukza4Q9Dm4CAf6atq/D6LIzXqzqEJ4ur4tZZVs5ta5hoWNKHPA9HPNFEoPreoNn3H6IfSYInMNoyyFQC0CGEJoJRQjxXmVZd1EwvlAr2edcH/0HisA4FcUtqj73vAnVxOGcxzUz3m3SV17YG+TqRFR6eP8qOXnutMqNkv1ZJWAmE0z/1FvFNql/vUx4+DTrhdfffNi5QEAWFtW87vmf0HqN8/PtqaelDgMXrdbt1nVxQ+sLXkRNkSYBpc9rxfxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WK6osbt0/PKrLF1sXNGppM4AeQsH0TDdsdjdMEhP94=;
 b=l49gv5eCxBNKzq0mjEgs5OTU6MY3nvNKS9pKSzGN0Z7Uf8O1t1Y+pC0Fm4QQEJk6E+7R4T4zHaZw/SaRb/bPOLZa7gQDwCoMgnwE51tNezHbFcvOD9aZViTQvRph318c+sUh1Z1bgSo+ZJ+nGK16/nYX+/s8tnyylYl9/HzZqy+35SxUCoGDh7PaKZDSmWKgRtxer2NfSEu0Crw3Vn/wUl8gUcZmAXytftMEvM2uBgTg+dRTavbcWt9PfbxXfXCHuxpDl5pCU0TD6j/tdE9f6Jpt8NjjUSfJ6Be4ggSVEx+clafG+pYmYnWipc2u+n4jsHWpm8GqtHWs4jhJtlkC0g==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by SJ2PR12MB7896.namprd12.prod.outlook.com (2603:10b6:a03:4c6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 08:03:56 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::cabb:aea2:67d6:52cf]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::cabb:aea2:67d6:52cf%6]) with mapi id 15.20.6298.045; Wed, 19 Apr 2023
 08:03:56 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: RE: [PATCH net-next v6 3/5] net/mlx5: Support MACsec over VLAN
Thread-Topic: [PATCH net-next v6 3/5] net/mlx5: Support MACsec over VLAN
Thread-Index: AQHZcdAsWGuUMJNyBUOXkjmzTxi6ca8xyjaAgABziuA=
Date:   Wed, 19 Apr 2023 08:03:56 +0000
Message-ID: <IA1PR12MB6353EA08099A70A5CEE2E235AB629@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230418083102.14326-1-ehakim@nvidia.com>
        <20230418083102.14326-4-ehakim@nvidia.com>
 <20230418173603.5b41e2e0@kernel.org>
In-Reply-To: <20230418173603.5b41e2e0@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|SJ2PR12MB7896:EE_
x-ms-office365-filtering-correlation-id: 9ca81215-91fb-4bde-cf39-08db40aca00f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wGGTVVOmbrtgzlLNsQadOTogVtkWri8qS3JWY7lHMgKpBNpWMEn9L/g9GAoZ5BlH7fMV+2Lk72eZphC42EaaMW7n1Dm4+8VKBNP/iFRHf2AU1482EzZg4GqQBpKOq29C9Z5M0XcpQba+LqD8jSXMPJjjRkWbL7U4Q/FV33hk+ZD53bZGEtPO3ha/M0UEY7MAKr9Tm5MHmQuEnl7jP0fwvN1nH6S1MvRwTDI2QtXGtxWoOvBO0psRhFaLuTAaxkSQGjfPLEWGDDI/r2td6b43/8zN5IBuhD77DtDdE6qItfzucEW1ZKSOqRM4Yo0C3rLnptzmFUJcOyj+pvrAt5ka458/F7vMFBS1qHgRkxeYZIoQpIwuDpy6Lf78AN8dKunjR3B+iY5iUAcnK9Yx+rjb7CSQxDJyOd10JslplYwhF38rmD2Aae3c2XG12Ezf8mJar9nGG4llMRbcPMGzMJRHp86gpNQpiHoeN3uXJIrchS3DkWocclPXkvVgxHd+hd/ApSnQ/Zz3OckUCe9CAYa9wGIr/VdMc7W4778GsOgaizA1gIP55GvMcquLiUTKjVD+/RyvykvWFmCBku3ak4D+FsPnuMxugMqawdl/x2L8M6nSuYYarnjTy2y+E+VtX5oD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(451199021)(55016003)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(6916009)(4326008)(478600001)(316002)(54906003)(8936002)(8676002)(5660300002)(52536014)(41300700001)(122000001)(38100700002)(186003)(53546011)(83380400001)(9686003)(7696005)(71200400001)(6506007)(26005)(33656002)(86362001)(38070700005)(4744005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWpINi80UWdVTHZlcHdkUkNGYUcrejJwbVRWMFYrSkNMcUw0Z1lBbFJMUVZE?=
 =?utf-8?B?UEU0ZitWRkwwUSt2NWVYZyswZUxwM2JZK2o4Vi9IVmplR2tQa1JRYStKNDJa?=
 =?utf-8?B?bndrSzMxQkRvM1lDTWVZK2YzVWlYYU1NaVhQWlhiVWdBSnFMOEd4NXdMc1lG?=
 =?utf-8?B?T3VZYWpXb25BSzNoaEVqcVUvdWxra2pxWVhoS3FhZXF4a01ObEdQRU1jTU1k?=
 =?utf-8?B?akxqUjFsUHhRd0ppaTUxblM5MVpTb0YxRjNjdlZpclYyN2dzYnB1WU9KcEdN?=
 =?utf-8?B?MWRwZHI3emladnp1eVd6aUY0N3JhL0JJUkdXMFNsaVRNT2xJckw0OGRmeUhq?=
 =?utf-8?B?YjF4bldPVUMrR3plV05abTI3cWpXelprMlZ5VFl2Q1V3QmVqR00xMFBtK091?=
 =?utf-8?B?SGE0RG84TzdMeTNXbHN5Yml5YmROZzlqWUlHcGplM0ZPc2dLcWRzWHRDOVJU?=
 =?utf-8?B?NCszVjU0THoyaFlrbkdSZ1NSQ0pnR20yTjliQ3RFSVdER2hCL09kcGxoelZV?=
 =?utf-8?B?ZzJDSXFacGswTzBvdkdHelBnTCtSZ1JiamwzTjdPTERNajZnN3c1OGNSZWN3?=
 =?utf-8?B?NEgvSnpxd1IxN1AxQTZTeVMvVHBJcDIrYXVkNFVkdUNnWjV0c2NZM21sNjBv?=
 =?utf-8?B?N0N3TDhtMVRHVURHWXBudUNEQis4bkovZ1l6M1VJRHIxcHhkK3IzN2hQRGNs?=
 =?utf-8?B?MXJxSWtxMVJNOVAwMmpGeUFGZFFkbHc2MS9DNWFEbVBXWDE0SEhXck1hdlVw?=
 =?utf-8?B?TVViczhKMUhDak1wNlRSc2hkdW1XTFAzZ0xRdWJyK0laaXBxZTNWcHRJUVVI?=
 =?utf-8?B?OTJjYXQwcmFMQUZFNk8zQ3pDNS92ZVFiU3drVjBtZzNMdVVXZU9aMHZvMGRi?=
 =?utf-8?B?Nk0wbDBOdytDdXY5cWJWMzlvbStFSmtLWW5qUG9SZTJiOTBPMEVweGpEN3Bn?=
 =?utf-8?B?WWtRa01tUUM0WXBuV1VQUFovSnNONXpUOTU2SEJQS1pMaGZBVzBndXBCS1Vl?=
 =?utf-8?B?Wnd6WWRvanVxSk1SR2lURllSMVQ3OHNNdDhEeXVUcnQydVpyaHZDWGFMbmU0?=
 =?utf-8?B?QXlmN0lCMTRZQjJQZGhYNUlhL3hFSTFUUndXTHJ1OVN6Q3Z2M1A0SnlMYmJT?=
 =?utf-8?B?c3ZURW02S2ZpWHNYUmVVd051OUE2U2JZbVVueCtrUjFRUXpObHpqeU9QejhC?=
 =?utf-8?B?NWdES1lRY3dSZ0VVNHg4bC9hMDFTb3Z5NFI5NXlPMTFNZlQyNkV1Ylc2UDJ6?=
 =?utf-8?B?cS9TVzc3U2d3KzczcDRvbnQ2dTc4eUhSYi92TjlJRm9XbXg2RHp0LytLREpv?=
 =?utf-8?B?dFN1L0c0SXBtZS9DQTI4Z002ZlV2bEc2Q054bmpYU2p4RDRUMysrN1VCQ2d4?=
 =?utf-8?B?WUV2TG9XdzVqZS9WVjZDT0pBK3BBYVNoUGRtTm1iUXJmampEbHFJSWtqUjZK?=
 =?utf-8?B?WkUybERuYnAxNFVtUXVnV2J5SGhiZVZobDJGRzZrMjVRRkZJSU5RbnZGOUdW?=
 =?utf-8?B?NThDTUhnL1JiSXZNWGRYdms2WGI0bjJDZHM0V0JYVWROa3daSENDOEJiL1B2?=
 =?utf-8?B?RVNXNW5ZaDZDU2lOT2pMemttWDgrZUdiVUJxVlJsaWZ5M2JPTXJUL3k5N1hV?=
 =?utf-8?B?TGtDdHhrTmRhMW95cXNjdkI0VmIwQ0daS2lpMVFac0QxcURzcXpCdWtSYjVw?=
 =?utf-8?B?bTJmOU9zVU9jamFmcG5rMTJmRjdweEhCdC8yTVpVWWE3MmlvTmtoMVhudDFy?=
 =?utf-8?B?ZlkrQ1RwY2hYeStoL2VydjcvRUdWaHhBRzA0K0ozUVpzaVpKcmtzNnhsdWtP?=
 =?utf-8?B?MXYvLzNvUXIxaEhKRmI0Uk9Fd1A0a25MWEdna1BTN0ZnTzFaN1VyRzRsZ29q?=
 =?utf-8?B?TGo0NnpWSm5SUlNBeFVwV2U4VXQzYlo1Q2VRQ1RGUFR2bXFCZzNlbmgrSFd1?=
 =?utf-8?B?UTRBREpma1U3WFVaZTJEcjdKdlFHN25VaHhVd1E1QUxzTGxPZzM3RUFreGdE?=
 =?utf-8?B?dDZxM2pEMjg0MzB0dUtPV3d6U1FqSUUzeDVHTkp2WDB6TkE4MU9IWHlDY0ky?=
 =?utf-8?B?azIxbDdIejlNZlZ0UTRqbUd2a2c0ZzNlOXo5OE95STFVYzRVSGk1N2xiS3I4?=
 =?utf-8?Q?SdKc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ca81215-91fb-4bde-cf39-08db40aca00f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2023 08:03:56.6646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 17UAFNqg5vWu7Pzj6T7Ton22msTvCyDRUzfopSIcwxKzuePls2h6mneocAzAjJkFnsilSBQS2XpnRfIXZ17ydg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7896
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCAxOSBBcHJpbCAyMDIzIDM6MzYN
Cj4gVG86IEVtZWVsIEhha2ltIDxlaGFraW1AbnZpZGlhLmNvbT4NCj4gQ2M6IGRhdmVtQGRhdmVt
bG9mdC5uZXQ7IHBhYmVuaUByZWRoYXQuY29tOyBlZHVtYXpldEBnb29nbGUuY29tOw0KPiBzZEBx
dWVhc3lzbmFpbC5uZXQ7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxlb25Aa2VybmVsLm9yZw0K
PiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IHY2IDMvNV0gbmV0L21seDU6IFN1cHBvcnQg
TUFDc2VjIG92ZXIgVkxBTg0KPiANCj4gRXh0ZXJuYWwgZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5p
bmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4gDQo+IA0KPiBPbiBUdWUsIDE4IEFwciAyMDIzIDEx
OjMxOjAwICswMzAwIEVtZWVsIEhha2ltIHdyb3RlOg0KPiA+ICtzdGF0aWMgaW5saW5lIHN0cnVj
dCBtbHg1ZV9wcml2ICptYWNzZWNfbmV0ZGV2X3ByaXYoY29uc3Qgc3RydWN0DQo+ID4gK25ldF9k
ZXZpY2UgKmRldikNCj4gDQo+IERvZXMgdGhlIGNvbXBpbGVyIHJlYWxseSBub3QgaW5saW5lIHRo
aXMgd2l0aG91dCB0aGUgZXhwbGljaXQgaW5saW5lIGtleXdvcmQ/DQoNCkkgd2lsbCByZW1vdmUg
aXQgdG8gbGV0IHRoZSBjb21waWxlciBtYWtlIGl0cyBvd24gZGVjaXNpb25zLg0KDQo+ID4gK3sN
Cj4gPiArI2lmIGRlZmluZWQoQ09ORklHX1ZMQU5fODAyMVEpIHx8DQo+IGRlZmluZWQoQ09ORklH
X1ZMQU5fODAyMVFfTU9EVUxFKQ0KPiANCj4gVGhhdCdzIHdoYXQgSVNfRU5BQkxFRCgpIGlzIGZv
cg0KDQpBQ0ssIEkgY2FuIHJlcGxhY2UgaXQgd2l0aCAjaWYgSVNfRU5BQkxFRChDT05GSUdfVkxB
Tl84MDIxUSkNCg0KPiA+ICsgICAgIGlmIChpc192bGFuX2RldihkZXYpKQ0KPiA+ICsgICAgICAg
ICAgICAgcmV0dXJuIG5ldGRldl9wcml2KHZsYW5fZGV2X3ByaXYoZGV2KS0+cmVhbF9kZXYpOw0K
PiA+ICsjZW5kaWYNCj4gPiArICAgICByZXR1cm4gbmV0ZGV2X3ByaXYoZGV2KTsNCj4gPiArfQ0K
PiANCj4gLS0NCj4gcHctYm90OiBjcg0KDQo=
