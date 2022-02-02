Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15104A6DEB
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 10:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245503AbiBBJhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 04:37:25 -0500
Received: from mail-mw2nam12on2093.outbound.protection.outlook.com ([40.107.244.93]:45601
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232002AbiBBJhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 04:37:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T6mz0ioCA4qEonTLPiHUReRAyM9QmFsgC1LsACoa0+gkeRtLgMM8q+cCzoUt6yj5kjuLOJBWUNoV3hf6V0pPChm/6Mnyfa0/+nQHE2WC9BXz5lIPRcPeTTFmMj/BuIBKUK7gR9kP+5UYMpSTPbIAYByBFXfozk2VdGqfOwvRAWusJ7FSaMBHLmTrrdsNZ4uVMplRvHRBiLL20qYOZT3EtxRh2Aaj3g/xwzPW1gzf+Mw/HPzDWdAEfONMGKWXFY807fz4fwUxyBPbuIUEoy+dPdrdhX4frFm5is+VTA9kub8yeG9WXgaF/TFv+V1u8OAGrChCqHP+ylKRUH16dYcLlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UOdvdkKh1an/Ft4V9enw0mOd0PGW47+AA6RM91P7Dj4=;
 b=biXnzuPk9l4qvp0UvP1DMSSAAltnHJzTy8UcDwNlcyRiWLVp1xBWEHlwW98PfjcqxF5tHQ9lj3ERz4ZsMS6TsLcnX1BKXIuN2FhADkT6dCy62A703uU88lSkrV2aWxvrCBd+7xkUGS0JbhPdQCPULm/BZglJt2x+qftPBJDs5YHtHZW3iNKk4AyP7YZh9ObRvkMn7+NPtSpl/xaQHeQppDzf9ufuq4yebzB4WbTDtl9CG4Z/a9dNZjJ3Z1FHKX2+wLp3h9aWddAI4ji9PG0rSiK1Rx7ggyZG4omQPcECFRh7t5f567LP7SLnD+eWzYnArCYVYJREdAvLOhEH/f1aQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOdvdkKh1an/Ft4V9enw0mOd0PGW47+AA6RM91P7Dj4=;
 b=Vcl2ZeHfcArsx/KSzxD/+sRPRxUn2F3I/VhSJm+aYVBptW2DDfzf46Xqp1ds7k6w+VLNADag+P/vCpa/Xx5gKB5D1NF++10VIi1GuV/m5IBVWPEyLX6G1GtyziYK+4VjQyCFv9LvKvoXQ2N+ZJm9Oc649NsdDfccg3LIJo0Z87I=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by BY5PR13MB2981.namprd13.prod.outlook.com (2603:10b6:a03:18e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 2 Feb
 2022 09:37:21 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::29e9:10e2:c954:f2b7]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::29e9:10e2:c954:f2b7%4]) with mapi id 15.20.4951.011; Wed, 2 Feb 2022
 09:37:21 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Roi Dayan <roid@nvidia.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Victor Nogueira <victor@mojatatu.com>
CC:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: RE: [PATCH iproute2-next v2] tc: add skip_hw and skip_sw to control
 action offload
Thread-Topic: [PATCH iproute2-next v2] tc: add skip_hw and skip_sw to control
 action offload
Thread-Index: AQHYEoG1Et1s4gxqYUSe1W65rALAhKx1T7gAgAhAIoCAAmveAIAAAheAgAAHpsA=
Date:   Wed, 2 Feb 2022 09:37:21 +0000
Message-ID: <DM5PR1301MB21726E820BC91768462B8C70E7279@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <1643180079-17097-1-git-send-email-baowen.zheng@corigine.com>
 <CA+NMeC_RKJXwbpjejTXKViUzUjDi0N-ZKoSa9fun=ySfThV5gA@mail.gmail.com>
 <b24054ae-7267-b5ca-363b-9c219fb05a98@mojatatu.com>
 <1861edc9-7185-42f6-70dc-bfbfdd348462@nvidia.com>
 <caeac129-25f4-6be5-76ce-9e0b20b68e7c@nvidia.com>
In-Reply-To: <caeac129-25f4-6be5-76ce-9e0b20b68e7c@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3c5840f-e78c-4aa3-6259-08d9e62f9c74
x-ms-traffictypediagnostic: BY5PR13MB2981:EE_
x-microsoft-antispam-prvs: <BY5PR13MB2981824475A42E26D47FE7A9E7279@BY5PR13MB2981.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q7lGxq+d9U75LvvCt72NeZnZER35wbGQ1mqDvdrX7P0ZG+5NVsSKiKG/YPo1fGkW1MoNbD/dVosH53ROoikWMOs+m5orRt/ZvCFyGNGK1gR+erda2To+fHJzSC0i+jp3r7UET7MXv7RjyprKP0B/6HSeFLbnaHzCMJxovUKG/HazETB/XgimCgKxnX6eRYpnq2VBSIb4ohO1WJTgnmx4VMZ4FfRvDtgJU4SgvGWm1jQ5p+VqbSir9TAqqRepe0GEu8vnT/L8hVVVDKVNtnyQbHxYoIZAmH93LsAOBzRXMJS18YbUVHA4oEV6AfJlj2KJ1Ttsujlgw8P4nVtYtxradTRF6ev8Ug20JCY7zNo7j4pCbyflsKmUKTMK2LsYw2Xjgzdh26d30q4Q01swtheczZegNiuHUflOKSFyXgRYCl5TLEbfbOwR6YBqucUswKoOvu9h+HlDXJqG3IMsrjKqYep1aAyo76XI2Kl7avEyc1a/UAsa3E+P8wnTrOWeF3xnEl/Ol9mSDhWYOT+E0UX9IBKQmArp0aNHxqe1o1v1hNFZg6hmIO1kD77FyPDuj0aQLfY/6GKY5VKTX1cqrz0pLQuk5GHcqmFHebUxO5ywHOZC7Vjj0fGOp9ql00D7lX/UbCGwUjBMhJBXiLYdEuEmpVzdf0WkFC+kV4wLJy5PzrWJG3OTfwMsmCXs9ss6Z4ADF95oTzdbL/iiVseGKbZOCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(39830400003)(396003)(136003)(376002)(346002)(76116006)(122000001)(66556008)(66946007)(8676002)(38100700002)(64756008)(8936002)(66446008)(66476007)(86362001)(54906003)(52536014)(44832011)(5660300002)(71200400001)(110136005)(107886003)(4326008)(316002)(53546011)(186003)(2906002)(33656002)(38070700005)(6506007)(7696005)(83380400001)(26005)(9686003)(508600001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YmNQbXZ0RWtRRmdxYmFOUDg5WG5OWkhEVW5ZSkhVOGswdjVjaEd2RW1Manpw?=
 =?utf-8?B?Vi9LRkRwdTFlR2ZIQTYvczZVRkVQaFFDaFd1TlBMS1JqOTNhVlc4QXhSSmY3?=
 =?utf-8?B?UEJJUG5ZSHFRd1dqeGFLU0RlRmVjUTl2NzhFM0NoN2l5WUZOa2ZuSlViWXZv?=
 =?utf-8?B?YmZFZWt1NGRWd3RrNkhIcS9lYjVjWXdYMU90MENQaXlUYlBFOVg2QXIwWGE0?=
 =?utf-8?B?NzA2V2tyaUFGb0RIcWpPMERqRUV3RnB2ZnFsbE1ERnRBNEF5WUw5VFM1cWZ0?=
 =?utf-8?B?cXgyTkdFQzJyU2pjNE5nWDJ3QlNnS045SGxPcGN0a3YzNWk2T0NHbGNLbW54?=
 =?utf-8?B?ZXZuc2dYZ3BxMyt3bHpYbGh5dE02RmNFUUpHL3JDRWN5bWZ1M1hsNU5nZjVD?=
 =?utf-8?B?RlRkMk0wMDRvQnJ6NnRScm9rUnh0SjRmUVRHeVpsMVVjSFZnZ2dvL0JLMjhj?=
 =?utf-8?B?YUQySmhOT2N1eWJkUWxzT1NDRTZQQmRkSmZOejFaYldkSTJFRWpxUXZSalFB?=
 =?utf-8?B?NkhIZ0VONC9ST2I1RGkxWG1TaFppZmxNc21VVTdtc25UZlhQOGU3ZDlQT1Fx?=
 =?utf-8?B?TkFJbkFIN0N2bW9tQ29lY0s1d2xOOTBQK3Bzb0V5N1czc2VrSW9xZ3lCc01m?=
 =?utf-8?B?RU80cEF3UU4xNWJ2MHRvMzFnWGhlN1h5aG5uWUZhS3E3cFVCb3ZsQU51Tzls?=
 =?utf-8?B?RFNhUzgrNE1SNERYMk1Fb3ZLZ01hb0o3U1c3REk2Y28xbmVvNWIzSEYzd2lU?=
 =?utf-8?B?a252RlQwMTM3eTU3cFNkMzRPZDZXdjBra0pBOWZCakpiK0EvNlFranBFZnRu?=
 =?utf-8?B?NVgwZWtoV1ltTU53M1owYStMNXh2dzYrODRVZGlOTklXSk8yQUc1VWVpa3gy?=
 =?utf-8?B?MHd1a3R6WFRnR3FoZS9kdVF1UEU1WnEzd1M4b3lrdTFXWTNmUkhaVXNvL0lX?=
 =?utf-8?B?VXJSWXdKTUlOaHNCdWR5S3I3d0swQnZEU1ZrdkVmWG5RMlY5c0ozd0dPWE1i?=
 =?utf-8?B?NW42TzZuK1BTZW5vcm1RUFFwWk5BWU54MFlvdTR4Y0t5SU1GS2VYMTJ5Y0pk?=
 =?utf-8?B?cW0wUVlFcmFsUjJRYmZWSUJhV05sQldWeTlYOTJsUE9ZV0hCOGQ3ZXBCVHJa?=
 =?utf-8?B?WmJlc3V6VEIzZ3UvSDFLanNkUEJuOVNTTFRZNmpvVGdTbVoyNXVtVEgzTFFE?=
 =?utf-8?B?S3kwOEZsM2c3S0ZjaU5Fclk3RUF2Y0s2UTdYWHpydVBUYjZHdHR4Wm14VTVj?=
 =?utf-8?B?WmFNMTlPQjI0L2RyMlJjdEZVMnpWRld6RG4rSEFiK1hXN3BvdXpQMC9lcmNQ?=
 =?utf-8?B?RFgzc2lmMlgrbEhQNHg1RkVPdjR4ZWRyanFicHg3TmFrNTJuRnlNRXI0eksz?=
 =?utf-8?B?UWxpR1BDZERNSml4a0F4NFZ5eHpNVllsc3VJWkI4U1Fid0M5azZHd3lpVFdK?=
 =?utf-8?B?TjRMcHNBUlVsekJpRjIzV2tHdkN3N3djaXlqY3hPY2d0WFVhbnRzYm56MzI1?=
 =?utf-8?B?YUVocTZ5YVJCUm1LbldUT3NGVU5OYU8xUXJOUHIzd2FsWDJORWkrendsbWFl?=
 =?utf-8?B?SnZDZ2E0bUlGM3pGWEVhNzFCdW5Bbk9NeU9WTzk2TUU5bGRIbzVWeWl4ZDZ3?=
 =?utf-8?B?SzFja213KzdLWXdXNHVhLzZpYW02ZlhNL3YweFVlbmNMa0pZejFDUXY0WTRi?=
 =?utf-8?B?RE1ZSEE3RTFnT0hIQis0L2hWcDZQSmMyb2NtbGVaU0lYV21UYlFudmxvbmlM?=
 =?utf-8?B?T2x4NmNqU0FtWFhEVTQwZittZm9nWTlCYXNTaVIzZ2I0MWQrdC9yVGFzeHJj?=
 =?utf-8?B?ejNnejlkcWdzMnlBUjJZODErRTF2L003UVlTZUt2YlM4RzNWZGFnL1ViRFgr?=
 =?utf-8?B?MllXdTRqa0hYTU91SUlpVWNDODE1MG9hS0pDdXRiSFlUR3doUFVmMEx5OWxO?=
 =?utf-8?B?ZmFmMHZNL0RrOGhJZTlyU29zYW00NUFQclFDeEx5L25DVG9OV0dJSDE1V25u?=
 =?utf-8?B?Q0UvekFhV2ZndU5UeTJSNVpKOCtkWmVrblpxRjc2MjNZQXRuZTRoL25tWkJl?=
 =?utf-8?B?RFU5Z3N0SFNZMlErcHZDeVkrRlozaEdubXJqK0ZZbHhmWE9jbko4TERVWUNE?=
 =?utf-8?B?UWFsdFhud1dXRlkyQlBBU2tDTlF4NnQ0SERjckp5N1lBMldJZWdaOFBKWXJy?=
 =?utf-8?B?aHFESHVDK201TCtscE9DYXg4OXF0VDdiQlJlc3N4Qnl5VXVucnFLUTZUVHZt?=
 =?utf-8?B?NnJ1N3RpQ01ndzhwZCsvSEltQzh3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3c5840f-e78c-4aa3-6259-08d9e62f9c74
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2022 09:37:21.1422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BcxPkQb1eU4aIA63CvQrAE7swTLobbmbeVICBf6ZQ4GDkrcCo0KKz7MfPT8CPXqsYulOGsAgkCpRo5gmENE0GOC7ngRrrZxqWHIy7Y0s/+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB2981
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUm9pOg0KVGhhbmtzIGZvciBicmluZyB0aGlzIHRvIHVzLCBwbGVhc2Ugc2VlIHRoZSBpbmxp
bmUgY29tbWVudHMuDQoNCj5PbiAyMDIyLTAyLTAyIDEwOjM5IEFNLCBSb2kgRGF5YW4gd3JvdGU6
DQo+Pg0KPj4NCj4+IE9uIDIwMjItMDEtMzEgOTo0MCBQTSwgSmFtYWwgSGFkaSBTYWxpbSB3cm90
ZToNCj4+PiBPbiAyMDIyLTAxLTI2IDA4OjQxLCBWaWN0b3IgTm9ndWVpcmEgd3JvdGU6DQo+Pj4+
IE9uIFdlZCwgSmFuIDI2LCAyMDIyIGF0IDM6NTUgQU0gQmFvd2VuIFpoZW5nDQo+Pj4+IDxiYW93
ZW4uemhlbmdAY29yaWdpbmUuY29tPiB3cm90ZToNCj4+Pj4+DQo+Pj4+PiBBZGQgc2tpcF9odyBh
bmQgc2tpcF9zdyBmbGFncyBmb3IgdXNlciB0byBjb250cm9sIHdoZXRoZXIgb2ZmbG9hZA0KPj4+
Pj4gYWN0aW9uIHRvIGhhcmR3YXJlLg0KPj4+Pj4NCj4+Pj4+IEFsc28gd2UgYWRkIGh3X2NvdW50
IHRvIHNob3cgaG93IG1hbnkgaGFyZHdhcmVzIGFjY2VwdCB0byBvZmZsb2FkDQo+Pj4+PiB0aGUg
YWN0aW9uLg0KPj4+Pj4NCj4+Pj4+IENoYW5nZSBtYW4gcGFnZSB0byBkZXNjcmliZSB0aGUgdXNh
Z2Ugb2Ygc2tpcF9zdyBhbmQgc2tpcF9odyBmbGFnLg0KPj4+Pj4NCj4+Pj4+IEFuIGV4YW1wbGUg
dG8gYWRkIGFuZCBxdWVyeSBhY3Rpb24gYXMgYmVsb3cuDQo+Pj4+Pg0KPj4+Pj4gJCB0YyBhY3Rp
b25zIGFkZCBhY3Rpb24gcG9saWNlIHJhdGUgMW1iaXQgYnVyc3QgMTAwayBpbmRleCAxMDANCj4+
Pj4+IHNraXBfc3cNCj4+Pj4+DQo+Pj4+PiAkIHRjIC1zIC1kIGFjdGlvbnMgbGlzdCBhY3Rpb24g
cG9saWNlIHRvdGFsIGFjdHMgMQ0KPj4+Pj4gwqDCoMKgwqAgYWN0aW9uIG9yZGVyIDA6wqAgcG9s
aWNlIDB4NjQgcmF0ZSAxTWJpdCBidXJzdCAxMDBLYiBtdHUgMktiDQo+Pj4+PiBhY3Rpb24gcmVj
bGFzc2lmeSBvdmVyaGVhZCAwYiBsaW5rbGF5ZXIgZXRoZXJuZXQNCj4+Pj4+IMKgwqDCoMKgIHJl
ZiAxIGJpbmQgMMKgIGluc3RhbGxlZCAyIHNlYyB1c2VkIDIgc2VjDQo+Pj4+PiDCoMKgwqDCoCBB
Y3Rpb24gc3RhdGlzdGljczoNCj4+Pj4+IMKgwqDCoMKgIFNlbnQgMCBieXRlcyAwIHBrdCAoZHJv
cHBlZCAwLCBvdmVybGltaXRzIDAgcmVxdWV1ZXMgMCkNCj4+Pj4+IMKgwqDCoMKgIGJhY2tsb2cg
MGIgMHAgcmVxdWV1ZXMgMA0KPj4+Pj4gwqDCoMKgwqAgc2tpcF9zdyBpbl9odyBpbl9od19jb3Vu
dCAxDQo+Pj4+PiDCoMKgwqDCoCB1c2VkX2h3X3N0YXRzIGRlbGF5ZWQNCj4+Pj4+DQo+Pj4+PiBT
aWduZWQtb2ZmLWJ5OiBiYW93ZW4gemhlbmcgPGJhb3dlbi56aGVuZ0Bjb3JpZ2luZS5jb20+DQo+
Pj4+PiBTaWduZWQtb2ZmLWJ5OiBTaW1vbiBIb3JtYW4gPHNpbW9uLmhvcm1hbkBjb3JpZ2luZS5j
b20+DQo+Pj4+DQo+Pj4+IEkgYXBwbGllZCB0aGlzIHZlcnNpb24sIHRlc3RlZCBpdCBhbmQgY2Fu
IGNvbmZpcm0gdGhlIGJyZWFrYWdlIGluDQo+Pj4+IHRkYyBpcyBnb25lLg0KPj4+PiBUZXN0ZWQt
Ynk6IFZpY3RvciBOb2d1ZWlyYSA8dmljdG9yQG1vamF0YXR1LmNvbT4NCj4+Pg0KPj4+IEFja2Vk
LWJ5OiBKYW1hbCBIYWRpIFNhbGltIDxqaHNAbW9qYXRhdHUuY29tPg0KPj4+DQo+Pj4gY2hlZXJz
LA0KPj4+IGphbWFsDQo+Pg0KPj4NCj4+IEhpIFNvcnJ5IGZvciBub3QgY2F0Y2hpbmcgdGhpcyBl
YXJseSBlbm91Z2ggYnV0IEkgc2VlIGFuIGlzc3VlIG5vdw0KPj4gd2l0aCB0aGlzIHBhdGNoLiBh
ZGRpbmcgYW4gb2ZmbG9hZCB0YyBydWxlIGFuZCBkdW1waW5nIGl0IHNob3dzDQo+PiBhY3Rpb25z
IG5vdF9pbl9ody4NCj4+DQo+PiBleGFtcGxlIHJ1bGUgaW5faHcgYW5kIGFjdGlvbiBtYXJrZWQg
YXMgbm90X2luX2h3DQo+Pg0KPj4gZmlsdGVyIHBhcmVudCBmZmZmOiBwcm90b2NvbCBhcnAgcHJl
ZiA4IGZsb3dlciBjaGFpbiAwIGhhbmRsZSAweDENCj4+IGRzdF9tYWMgZTQ6MTE6MjI6MTE6NGE6
NTEgc3JjX21hYyBlNDoxMToyMjoxMTo0YTo1MA0KPj4gIMKgIGV0aF90eXBlIGFycA0KPj4gIMKg
IGluX2h3IGluX2h3X2NvdW50IDENCj4+ICDCoMKgwqDCoMKgwqDCoCBhY3Rpb24gb3JkZXIgMTog
Z2FjdCBhY3Rpb24gZHJvcA0KPj4gIMKgwqDCoMKgwqDCoMKgwqAgcmFuZG9tIHR5cGUgbm9uZSBw
YXNzIHZhbCAwDQo+PiAgwqDCoMKgwqDCoMKgwqDCoCBpbmRleCAyIHJlZiAxIGJpbmQgMQ0KPj4g
IMKgwqDCoMKgwqDCoMKgIG5vdF9pbl9odw0KPj4gIMKgwqDCoMKgwqDCoMKgIHVzZWRfaHdfc3Rh
dHMgZGVsYXllZA0KPj4NCj4+DQo+PiBzbyB0aGUgYWN0aW9uIHdhcyBub3QgY3JlYXRlZC9vZmZs
b2FkZWQgb3V0c2lkZSB0aGUgZmlsdGVyIGJ1dCBpdCBpcw0KPj4gYWN0aW5nIGFzIG9mZmxvYWRl
ZC4NCkhpIFJvaSwgdGhlIGZsYWcgaW5faHcgYW5kIG5vdF9pbl9odyBpbiBhY3Rpb24gc2VjdGlv
biBkZXNjcmliZXMgaWYgdGhlIGFjdGlvbiBpcyBvZmZsb2FkZWQgYXMgYW4gYWN0aW9uIGluZGVw
ZW5kZW50IG9mIGFueSBmaWx0ZXIuIFNvIHRoZSBhY3Rpb25zIGNyZWF0ZWQgYWxvbmcgd2l0aCB0
aGUgZmlsdGVyIHdpbGwgYmUgbWFya2VkIHdpdGggbm90X2luX2h3LiANClRoaXMgaXMgdG8gYmUg
Y29tcGF0aWJsZSB3aXRoIHdoYXQgd2UgZG8gaW4gTGludXggdXBzdHJlYW0gOGNiZmU5MyAoImZs
b3dfb2ZmbG9hZDogYWxsb3cgdXNlciB0byBvZmZsb2FkIHRjIGFjdGlvbiB0byBuZXQgZGV2aWNl
IikuIA0KDQo+Pg0KPj4gYWxzbyBzaG91bGRuJ3QgdGhlIGluZGVudCBiZSBtb3JlIDEgc3BhY2Ug
aW4gbGlrZSByYW5kb20vaW5kZXggdG8gbm90ZQ0KPj4gaXQncyBwYXJ0IG9mIHRoZSBhY3Rpb24g
b3JkZXIgMS4NCkZyb20gbXkgZW52aXJvbm1lbnQsIEkgZGlkIG5vdCBmaW5kIHRoaXMgaW5kZW50
IGlzc3VlLCBJIHdpbGwgbWFrZSBtb3JlIGNoZWNrIHRvIHZlcmlmeS4NCj4+DQo+PiBUaGFua3Ms
DQo+PiBSb2kNCj4+DQo+DQo+YWxzbywgbm90IHRlc3RlZC4gd2hhdCBpcyBwcmludGVkIGlmIG1h
dGNoIGlzIG5vdCBzdXBwb3J0ZWQgYnV0IHVzZXMgb2ZmbG9hZGVkDQo+YWN0aW9uPw0KSWYgbWF0
Y2ggaXMgbm90IHN1cHBvcnRlZCBidXQgdXNlcyBvZmZsb2FkZWQgYWN0aW9uLCB0aGUgbWF0Y2gg
d2lsbCBiZSBtYXJrZWQgYXMgbm90X2luX2h3IGFuZCB0aGUgYWN0aW9uIHdpbGwgYmUgbWFya2Vk
IGFzIGluX2h3IHNpbmNlIHRoZSBhY3Rpb24gaXMgb2ZmbG9hZGVkIGluZGVwZW5kZW50IGZyb20g
ZmlsdGVyIHJ1bGUuDQo+DQo+aXQgY291bGQgcHJpbnQgZmlsdGVyIG5vdF9pbl9odyBidXQgYWN0
aW9uIGluX2h3Pw0K
