Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8919753BDC3
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 20:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237846AbiFBSJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 14:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234321AbiFBSJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 14:09:23 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9708328725;
        Thu,  2 Jun 2022 11:09:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SfoF7V+rlY6X8DN5hGzYjvNk/SSXxNpwjjT3oBzG36bUqQjYlu42bOHJRD6bGPCh93ULtE85n0qdKR6NhWgwRRsFVp33U7ovX/YpQqK27E7BzoJ/dMuArfMxUtyzra7uggg92nTRLWPsOotf0WQThl5/OAM+0eyOLm9KxxEvcZXGSfsJByK1cPd7X1mGGIjqfzQy5PeJ/cxnIIoTa51XRnlM4NwBbau3cBA/EDh6xQQiUsCv811InFOE28tB76EQdzCc18cxOYNKqlmI7Ju/ia7CgTLp4sQ7kIL57/BD588QiUjCFV9Sbep8yuMOB6OtqW6FDLg83TGPHl51h6mjzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wpGEQVPjN5FQ+ri/yeHUBtNAdfYKynxlebWdnRcIijU=;
 b=Dv2xM/bj6z1XknlcWKbB4fZ40xDvB2JzGDZux9XWstlGkeVqR3Pz3ff0F3mKpD50qSYn+GlnrlSokPTjfDN6+I1Ema2CRsFXxUB9Ip6K6um1hzkqCK3Dj4NvFLEDQdWW1cAjt43AK1Wr5+d1krTBC9BI8fptfED7Q+QyMY1ptdSg/v9IQJ4P/DVkE8Gz8f80U+OPm38JFcVT3nvBvx+K5aODqp+OdAx0aq8B7A0QuvLUBy+8aAoHNFDRa+I0meoEqx9zo9279f0woEUztBJDDGgC22EnPIgAoQLTJ5syg+NxOw5Np8y8ll+kx+O25OaBJhQAYMHWVKfKTIPi9NUcRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpGEQVPjN5FQ+ri/yeHUBtNAdfYKynxlebWdnRcIijU=;
 b=S0nwzgxVGbKNZK8J6ALl3OZuj9uR5ColTOoEsftcMjE7WNsmCYGSfu7t1vkJlgHsIp6EYCzT2pyWTtLAyUVnScAX6pODlWnnhQsy8qtJsBLFsGwXsZ2CcpM3MW4wuA0A9cPD6/n8OvBuwglElVGVJEJHDPb3WViRwnXazOqm7wE=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by CO1PR10MB4451.namprd10.prod.outlook.com (2603:10b6:303:96::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Thu, 2 Jun
 2022 18:09:20 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::84d6:8aea:981:91e5]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::84d6:8aea:981:91e5%5]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 18:09:20 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "stephen@networkplumber.org" <stephen@networkplumber.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net-sysfs: allow changing sysfs carrier when interface is
 down
Thread-Topic: [PATCH] net-sysfs: allow changing sysfs carrier when interface
 is down
Thread-Index: AQHYdhitF3sF8MdKyEyE/FAADx5cL607THmAgACL6YCAAG4kgIAACD8AgAAI2QCAAATTAIAAC6cAgAADeIA=
Date:   Thu, 2 Jun 2022 18:09:20 +0000
Message-ID: <2390a40206f0f822569e6f55b8b7ae636eef7d05.camel@infinera.com>
References: <20220602003523.19530-1-joakim.tjernlund@infinera.com>
         <20220601180147.40a6e8ea@kernel.org>
         <4b700cbc93bc087115c1e400449bdff48c37298d.camel@infinera.com>
         <20220602085645.5ecff73f@hermes.local>
         <b4b1b8519ef9bfef0d09aeea7ab8f89e531130c8.camel@infinera.com>
         <20220602095756.764471e8@kernel.org>
         <f22f16c43411aafc0aaddd208e688dec1616e6bb.camel@infinera.com>
         <20220602105654.58faf4bd@hermes.local>
In-Reply-To: <20220602105654.58faf4bd@hermes.local>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=infinera.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1afef490-1917-416a-eed4-08da44c30419
x-ms-traffictypediagnostic: CO1PR10MB4451:EE_
x-microsoft-antispam-prvs: <CO1PR10MB44511E774B3F9814759D7774F4DE9@CO1PR10MB4451.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 83LuMWe8oDOJYW7BVTaw8Y+NvscjjtOKNx3V4ooaeBCagnd4gNALrzbR6jUBKWiMeqtNXwNroAvaqsltCQ0D2WAeci0Xk5ar5T9LiEGfOexJ58alSNmCVIagdAGQHn1ybSl2delKL0w6865sCTeCVgkuEo9QkdKynLapJxXIo3N3RqFhG8nzLhEF6oa8FJt3J1YjyPUPHbx5Pn9wki5A8t/KWqtB5+YQ5G83dthH6jl/61/kHGGD8+HMopAEF7i3DA8theEZjFGC0EuOdJavol/V5xoJBFsiQQNkTN07R5fD+8DupNEqRfg5kqQWvPWQms+zp6gEpo6h8bfrJ/TNkKX3AhPaj+W6RpMdOFBn2HRmDlYZvizN9QG0zXpK8enEDNgZsJn0z+ukfINArlZ5+Hv+Q5h0OPzmMJ6tq9mvXIMWhr14IhyibNLtboOhNESSzWymJElFq13sD4ZdWCR/UbV9Z7XUpX8l2JQZ7vUrkDROEVX0zTVitsWM9O/+N0N8uOsNWYggwsWZGNjiOQoBAZS4okhwA6hBQcAvhq8Wj4JCzIahjqvtzBQ4tCLHUsdhsMEjTV2y0ztxhm02yT70T2uf+Hc5zZMSItaICnRqPg9RSmfrYdohTUSQwDl7qWLo6VMX1hMxDiCRWAdUKXfmtqoh/ar7i6VMtkBC9Ti5rl8UBsydFMo6hCWYNxaYVSxKnwh7hfwp1oXc0RVTLLN9pA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(91956017)(66476007)(66556008)(64756008)(66946007)(8936002)(8676002)(76116006)(4326008)(66446008)(38100700002)(71200400001)(2616005)(6486002)(186003)(86362001)(83380400001)(2906002)(5660300002)(38070700005)(316002)(508600001)(6916009)(54906003)(26005)(6506007)(122000001)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDRrWng5YWs2RUg5RTVPRlpXRk1hNTV4K29YdEg0MkFCRGtWV2hrOU91TUpm?=
 =?utf-8?B?aFNmSno2VkVmMThFQ1BvUUhiVlV5emdYVktTdTRVcHdKaXhJU3BlOFp0TWwr?=
 =?utf-8?B?c1dTNzBGYWVIWkNTa1FqOTJKRmQzNDV5K0JNTFRENlIxRTFMVG1YTXdCLzU5?=
 =?utf-8?B?ZVYwSER5UGZSUkFydWhabHlqZm84MDlkcngxNnNCNTVHb3dleENMcU9sSzNJ?=
 =?utf-8?B?VkF2REx2R1pDYWhEUUZWYUVBbWNjSngwaXVscGVXMFlQN1RBMUg4UzFZSVJW?=
 =?utf-8?B?RjlEUTNGeXkyZkYvOWhpc25LTi9kbDVXTXkwZ1UzRHpWZEJkckovNThqd1cw?=
 =?utf-8?B?dHpNTGhkTW1LRG9Gb29RR3Bzd1ZnbWZ0dCtFQzYveFZQc0NyNGxlSUNqU2Ez?=
 =?utf-8?B?b0F2M1ZqYkJ1ZXFXKzhydk55bDRTZjBISk9sN3RaQXBuMTVISllBU295dWxa?=
 =?utf-8?B?UDlOeXNucUxGVjQrTWtnOEtSY0JZVFlJQ2ZmVkZaaGQwMjVSOWNqZDFLUkJN?=
 =?utf-8?B?MG1idGxVYVZuVjRBNncrUGFIQ2pFOVNUblZLZ2hiMVZBK0NwQm9UZk02aG5E?=
 =?utf-8?B?YXBLUURZZkpuRFgwdHE3UmU2QzV6T01LYlJWY0s2ZU1GNllGUVhRR0w1Mmxr?=
 =?utf-8?B?eUlSb0pCQk12dXZtZ1BkRndKalVLZEFaOGdjSWJLbmZacFhIUFkvd3RLbUdy?=
 =?utf-8?B?bW1jdjV2TlRvdk1YOUxlb3BTU3p3MmNyN0pRbWlPQUhja3BZdkhoMThCUDRK?=
 =?utf-8?B?TnVNY0VHSnJ6aEtlcytYcXh1aHFPQTZQQ2R5ZkNIMlVmWmFKQ0N5K2NUTjJp?=
 =?utf-8?B?dkkvdWtSMFZscVJJdTBkOWNmSE5pM0p1eDRZNnRLd2FQV1laQXBha3hjZjYx?=
 =?utf-8?B?bUhwTmk1QStKaUMwY0g1TTdCV3RuZ1VKajZwUm9obGpYbDVOTHYwdy85NFph?=
 =?utf-8?B?MGF0bjlZK3JNYW9qLzNTbVYyZEUyby9pZGRINzNSNElIMW1sUVNvOUQrNnFo?=
 =?utf-8?B?enEwTXRPVkhRSWxCY2ZsMUhBaGJjRjRNdk5rY0o3KzFlZ29udDFWMTRpODFW?=
 =?utf-8?B?a2ZuNUQ0YThGRDU1MmVTRGZROXdrYnl4VDRKT2Q5YVJaV3cvd0oxcTRWcmcv?=
 =?utf-8?B?Y1FDdzlxcEc5Ky9KMXdSZXJVQkhFWHl1TFBJR2F6QURqWDcrV0dRNlJSV0gr?=
 =?utf-8?B?RitoZWRYVWFNV2tGZkVCd0JKQzR4RkpRMWJFZ2JYK3lMZG9FQklIZks0VVpM?=
 =?utf-8?B?WjJ1REh5aE9GN05xRC9UYmRXQk16QlZUVlFxVVhDank2ZjR6V3R3eXlNYWtJ?=
 =?utf-8?B?UUd3RVVlMnBBYmhlR0RUZTJhc2c1T3kxYkJQZFpQZUlrQjREY1Z1RUpPQTdz?=
 =?utf-8?B?c2Z2NGkzVUV5SkxvUFFnY3laQmh0bHBNQWd5VFF4TFZDcHhkK0ZFQmtlTWZq?=
 =?utf-8?B?cmRCcTFualEyb3dwUXRUdWNreGxzYUw5c2ZYclljdUU0VEFDU3lYQ3cyaXBU?=
 =?utf-8?B?WTNUR0FMcS9TK2Y5RE0xdDdCb0FHU1U1eGJkUVJLUFBvRXFLdXd0MGQrRHlu?=
 =?utf-8?B?QnMvMU9oQ1JraUNvYlYrZncvMWZyMjZ1bk0zOTYvTEZQeFpvdWpjTlpBQ3Ev?=
 =?utf-8?B?YWYrcHNCN1FjVW9KTFpvRHRRanlaVUhZcjBNQ1hsTVNzUHVrcVdXdUg2ZGFP?=
 =?utf-8?B?bkpxRDEzWTM1SjJ4TEN3K2QxZCtFS0V6aTFnaDdDMjRlVXBFOGgxcFlWSklp?=
 =?utf-8?B?a05iVWw1Skxjb2dLT0JYWjBLWXg5ampxZ0V6TCtMK3o2VHZQWnlNZ00xdFlq?=
 =?utf-8?B?ZFhDSFFmRTRiZnZtZDJQUklRZEhIZTZFSmp0T0VrUUtWSjA0Snk2R05WNm10?=
 =?utf-8?B?NVhuZTIyWG10a2MrVU9QLzYzdkpxT3Z5RHh5dUdISFFWVTlwczdYTitqenVq?=
 =?utf-8?B?d1JKVHpJQW1DUy9jbkZvK0VaNlRra09BSXlFSWNwRjNlMm9kZWYzSFhKV3Av?=
 =?utf-8?B?eFh6NU5QOGVsNEYzZnpqZjAvSGZpMUN6M1dEL1JNWnFadkE3dHpvUTRJdnoz?=
 =?utf-8?B?cEFseFVDRFpQdDhmd0V3VGU3N1FQZWpvMzJzYTlBUFdUWkRqQk9RUE1teTNU?=
 =?utf-8?B?MVNlTTZrUHB4Nks3bG04UXlIVVBRVHZMYXVUN3lLT2pkOGcyRUVxNmZiYU1x?=
 =?utf-8?B?Mzc2OVhvZ1V1TzVkbE5BcDA4bFRzbWx1UWpNYXlBYU1zRzBSeFAzNGhrYjNl?=
 =?utf-8?B?ZGZYcEp5eWo3REhOY2trdXFwaHJGUWVvOUtMNGVmb2lFSkdHWjZpbC9hVWRt?=
 =?utf-8?B?clNCbm5PV1BmeC9YMGM2NFRIcEhiRHN1WXZScmZGZUtnU3JsdXZhaHVzeHht?=
 =?utf-8?Q?e1Mfi7H0N0Ll72cA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED043D85F5ED00409EE95B9744BCB21B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1afef490-1917-416a-eed4-08da44c30419
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2022 18:09:20.3841
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Ja0O/OMsaRWwsuGXALD+iuO1ZpzrrX8zWhDFxE9rW89tIEONvbyBNTeu7e2WWl5OsKQaSzJyhODjDjvGu2i+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4451
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA2LTAyIGF0IDEwOjU2IC0wNzAwLCBTdGVwaGVuIEhlbW1pbmdlciB3cm90
ZToNCj4gT24gVGh1LCAyIEp1biAyMDIyIDE3OjE1OjEzICswMDAwDQo+IEpvYWtpbSBUamVybmx1
bmQgPEpvYWtpbS5UamVybmx1bmRAaW5maW5lcmEuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gVGh1
LCAyMDIyLTA2LTAyIGF0IDA5OjU3IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gPiA+
IE9uIFRodSwgMiBKdW4gMjAyMiAxNjoyNjoxOCArMDAwMCBKb2FraW0gVGplcm5sdW5kIHdyb3Rl
OiAgDQo+ID4gPiA+IE9uIFRodSwgMjAyMi0wNi0wMiBhdCAwODo1NiAtMDcwMCwgU3RlcGhlbiBI
ZW1taW5nZXIgd3JvdGU6ICANCj4gPiA+ID4gPiA+IFN1cmUsIG91ciBIVyBoYXMgY29uZmlnL3N0
YXRlIGNoYW5nZXMgdGhhdCBtYWtlcyBpdCBpbXBvc3NpYmxlIGZvciBuZXQgZHJpdmVyDQo+ID4g
PiA+ID4gPiB0byB0b3VjaCBhbmQgcmVnaXN0ZXJzIG9yIFRYIHBrZ3MoY2FuIHJlc3VsdCBpbiBT
eXN0ZW0gRXJyb3IgZXhjZXB0aW9uIGluIHdvcnN0IGNhc2UuICANCj4gPiA+IA0KPiA+ID4gV2hh
dCBpcyAib3VyIEhXIiwgd2hhdCBrZXJuZWwgZHJpdmVyIGRvZXMgaXQgdXNlIGFuZCB3aHkgY2Fu
J3QgdGhlDQo+ID4gPiBrZXJuZWwgZHJpdmVyIHRha2UgY2FyZSBvZiBtYWtpbmcgc3VyZSB0aGUg
ZGV2aWNlIGlzIG5vdCBhY2Nlc3NlZA0KPiA+ID4gd2hlbiBpdCdkIGNyYXNoIHRoZSBzeXN0ZW0/
ICANCj4gPiANCj4gPiBJdCBpcyBhIGN1c3RvbSBhc2ljIHdpdGggc29tZSBob21lZ3Jvd24gY29u
dHJvbGxlci4gVGhlIGZ1bGwgY29uZmlnIHBhdGggaXMgdG9vIGNvbXBsZXggZm9yIGtlcm5lbCB0
b28NCj4gPiBrbm93IGFuZCBkZXBlbmRzIG9uIHVzZXIgaW5wdXQuIFRoZSBjYXNoaW5nL1RYIFRN
TyBwYXJ0IHdhcyBub3QgcGFydCBvZiB0aGUgZGVzaWduIHBsYW5zIGFuZA0KPiA+IEkgaGF2ZSBi
ZWVuIGRvd24gdGhpcyByb3V0ZSB3aXRoIHRoZSBIVyBkZXNpZ25lcnMgd2l0aG91dCBzdWNjZXNz
Lg0KPiANCj4gQ2hhbmdpbmcgdXBzdHJlYW0gY29kZSB0byBzdXBwb3J0IG91dCBvZiB0cmVlIGNv
ZGU/DQo+IFRoZSByaXNrIG9mIGJyZWFraW5nIGN1cnJlbnQgdXNlcnMgZm9yIHNvbWV0aGluZyB0
aGF0IG5vIG9uZSBlbHNlIHVzZXMNCj4gaXMgYSBiYWQgaWRlYS4NCg0KVGhlcmUgYXJlIGluIHRy
ZWUgdXNlcnMgdG9vLCBzZWUgZml4ZWRfcGh5X2NoYW5nZV9jYXJyaWVyKCksIEkgYW0gbm90IGFz
a2luZyBmb3IgYWRkaW5nDQphIG5ldyBmZWF0dXJlLCBqdXN0IG1ha2luZyBhbiBleGlzdGluZyBv
bmUgbW9yZSB1c2FibGUuDQoNCj4gDQo+ID4gPiAgIA0KPiA+ID4gPiBNYXliZSBzbyBidXQgaXQg
c2VlbXMgdG8gbWUgdGhhdCB0aGlzIGxpbWl0YXRpb24gd2FzIHB1dCBpbiBwbGFjZSB3aXRob3V0
IG11Y2ggdGhvdWdodC4gIA0KPiA+ID4gDQo+ID4gPiBEb24ndCBtYWtlIHVubmVjZXNzYXJ5IGRp
c3BhcmFnaW5nIHN0YXRlbWVudHMgYWJvdXQgc29tZW9uZSBlbHNlJ3Mgd29yay4NCj4gPiA+IFdo
b2V2ZXIgdGhhdCBwZXJzb24gd2FzLiAgDQo+ID4gDQo+ID4gVGhhdCB3YXMgbm90IG1lYW50IHRo
ZSB3YXkgeW91IHJlYWQgaXQsIHNvcnJ5IGZvciBiZWluZyB1bmNsZWFyLg0KPiA+IFRoZSBjb21t
aXQgZnJvbSAyMDEyIHNpbXBseSBzYXlzOg0KPiA+IG5ldDogYWxsb3cgdG8gY2hhbmdlIGNhcnJp
ZXIgdmlhIHN5c2ZzDQo+ID4gICAgIA0KPiA+ICAgICBNYWtlIGNhcnJpZXIgd3JpdGFibGUNCj4g
PiANCj4gDQo+IFNldHRpbmcgY2FycmllciBmcm9tIHVzZXJzcGFjZSB3YXMgYWRkZWQgdG8gc3Vw
cG9ydCBWUE4ncyBldGM7DQo+IGluIGdlbmVyYWwgaXQgd2FzIG5vdCBtZWFudCBhcyBoYXJkd2Fy
ZSB3b3JrYXJvdW5kLg0KPiANCj4gT2Z0ZW4gdXNpbmcgb3BlcnN0YXRlIGlzIGJldHRlciB3aXRo
IGNvbXBsZXggaGFyZHdhcmUgZGlkIHlvdSBsb29rIGF0IHRoYXQ/DQoNCllvdSBtZWFuPw0KbHMg
LWwgL3N5cy9jbGFzcy9uZXQvc2dtaWkvb3BlcnN0YXRlICANCi1yLS1yLS1yLS0gICAgMSByb290
ICAgICByb290ICAgICAgICAgIDQwOTYgTWFyICA5IDEyOjQ2IC9zeXMvY2xhc3MvbmV0L3NnbWlp
L29wZXJzdGF0ZQ0KDQpJIGRpZCwgYnV0IG9wZXJzdGF0ZSBoZXJlIGlzIG5vdCB3cml0ZWFibGUu
DQpEaWQgeW91IHBlcmhhcHMgbWVhbiBzb21lIG90aGVyIG9wZXJzdGF0ZSA/DQoNCiBKb2NrZQ0K
DQo=
