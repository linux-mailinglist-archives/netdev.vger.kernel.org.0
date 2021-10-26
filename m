Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CB043B8E1
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 20:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236668AbhJZSEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 14:04:08 -0400
Received: from mail-bn1nam07on2064.outbound.protection.outlook.com ([40.107.212.64]:20747
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231671AbhJZSEH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 14:04:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UK3UvzBYIgbAhrAAo7lvGAvKPIlWVppOYD7xyFrUJ5DDLChoTK9nuXj1DKE3ZpZgAyzXswhWTZtTpXy1L0kzKYjZssUONuvQqgDbZFQIPuxncGTcf9IsjAUXwG0EYl8JsQSoCOJaTxHOvRvOX6AoJf+Fl8VzxsqgtZu31D9wcFdHaP2O5ujqxkdfRxAyHgzTW2YZno6BqjV4vv1lahr1NA+MQLHEzVKjIYaiVVsVQb6vP14VU7q08+qt2P5rlCAclZ7l8wQsN136s9oCwN/QyySSJZGhSiWxjpYhQjEmwq8ov6whV38dWSvni61sDMZ3SSajYn0y4NpzHbLqjs52Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LA8ScnTPPc1dLaZ0KKOS77aUpXdI0Gw/xcJ2ngUlFx4=;
 b=oP0H62CmGlzrAFRcIkeEEnxLWH/srj25PVidK5BSI5T0rH/LJX4Il/wC6C37S8+OTczH/dn8TQCYnVbTzGxxoEWAao9+ot1YlLdS0ExP/9TbEW1KNWJXlyuPK81GkMVUz6EhNKyljeyAAREuEUlFC4PDG9zAJYQxblp3wQYdQuhKSIK+vTuLioiCYKfv46F9mSbIarp/uWaG3tzoXwHbzlVmtmA4CiNaV9sPxFV3uTBiovS1qqDepcu5YvCCnNA1JiXLcWrFPhOqqWZHKj+igqNXlXSDlm9fAows3m42uCDUOqdj3AbIRM/VLAZwygxcfrB1DUJBR22Bv73KLG8ozA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LA8ScnTPPc1dLaZ0KKOS77aUpXdI0Gw/xcJ2ngUlFx4=;
 b=Dn7YJ+tCy+NnX0S3t6Era83IHbCs8JdNfZM4999MIC2J1Ih+7UmBRF/0VLq5GDZKw7WPzesBiVrKPay2/K0MzkUwNoi4WCxAiub+YLNvV5nOV7osUntKyXw8Qr/OuNbnnXGHZRXSHLyFIz/khTL9hjA46tWeGnyJA5oLHskoPXGCutTNCF+SrTzjF3oNYJJPe+WGkRYxp6m3tn7YGcBylVSdQCs6FJXi1n+fEODnJapraDUv3XsoarBKii5GZd0OjMXrIEAu3+7GTLEU1qd+Q6g65J93Uh1kmyBj07+ppLMbwMXJoS8v3e23f+osPap8RIWyJMu190F6Z2Xaouu+Kw==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4051.namprd12.prod.outlook.com (2603:10b6:a03:20c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 18:01:39 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%6]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 18:01:39 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>, Shay Drory <shayd@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 10/14] net/mlx5: Let user configure io_eq_size param
Thread-Topic: [net-next 10/14] net/mlx5: Let user configure io_eq_size param
Thread-Index: AQHXyeKHFUDDWlwOwkOu3+SfyDMHKKvlYhWAgAANqQCAABbxgIAADJcA
Date:   Tue, 26 Oct 2021 18:01:39 +0000
Message-ID: <d29e330c2265bde648b3a7e2f5e24a275ac4f306.camel@nvidia.com>
References: <20211025205431.365080-1-saeed@kernel.org>
         <20211025205431.365080-11-saeed@kernel.org>
         <20211026080535.1793e18c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <91f1f7126508db9687e4a0754b5a6d1696d6994c.camel@nvidia.com>
         <20211026101635.7fc1097d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211026101635.7fc1097d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f12ad29-4a90-4b89-0d52-08d998aaa8ef
x-ms-traffictypediagnostic: BY5PR12MB4051:
x-microsoft-antispam-prvs: <BY5PR12MB405183166A63752D70A939D7B3849@BY5PR12MB4051.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VgIUojaryXbVrp32HEBAPq+JRItEVS5MbYDUl7EHaIlij8sN6HvotYit+4topfxgP0kiYnQaIg+TlkwbeZ+daUD3w0sNxQTC3iO2sd+NLAjba0kdMrUDy8+stKNN7mY/LzmYXy2WkekvGXz+LyMhHZkSGoJE1QMtoErrjYJIO+YuwMqko6mFB4ND358BlN0JOOIecE5VezW9bihgJ7TbEV61YbK7Lxe3jYAFTdeG0Y4ySUrYyVh6cpf7u4qVwAHTgP4esa2XTsPnI4qE4CCc6N9QTNdJpnZM1B4yMNKkqmLRbCRgwBego4PvUOUYgCjvqMZ0gaJwwabbLs+epHmTteTi9oLJAbtVmBFSzzLeUDlm99OPJSl6Q/XXAQu7wHy+MPYhVRR/a9P+VKmZ/fUswDr6+zZ+Yf3WZo6r/nBsTHB4IC7bH/hGtZoKz9odGIhG436nOgvfJzLASiJu2ESTSN8pDiDklkoHiKv2krC7zQoQi6b3jxseru0MBq42cwD8O9xm644K/H4PuqXhowlqJK+vI2L8w990bNbJUTKtUNemUJa/67N4JIsAYuPXr+RcrWQ0n9fuDhC3GeMw4wiLQxm7DIxbyMj59wYSlS+2mustHU7UMRo+1OG88cDvy5HO0xeVILlryh6+ZqvXGxriRqA3f+mbYKlhJSGXXZr47QUCv/vZP46k+phKRGC3M4aksP1Iy+g77L270jz/stvxNw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(64756008)(66556008)(66446008)(316002)(6486002)(66946007)(6512007)(86362001)(4326008)(2906002)(54906003)(38100700002)(38070700005)(76116006)(6506007)(122000001)(508600001)(5660300002)(36756003)(8676002)(6916009)(71200400001)(2616005)(186003)(45080400002)(26005)(4001150100001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S21kakkrRWlNM1pYaHFKWXZTTHRQUUlxS1RuMWFibGtiaEdTd3NacjlpQ1Vt?=
 =?utf-8?B?bTA4Mlk5c0FUcTFWTHFublJQQnNHbFJUT0s4cnRFWmYvKzV3cVIvRmFxRzRE?=
 =?utf-8?B?OTJHK0dYbm1IVlgvcDlSSk1sbFUwckd1a0ZXMWlFaGQwN3Fjc1ZtdnRUZncx?=
 =?utf-8?B?M1JDY1lOLzNabURXYUs2cGExSjRDcUFoUXc3d0hMZ3cwRXNzaFFjTmM0M0JZ?=
 =?utf-8?B?NGxaQitRbkVTL0hDWVNJVzVMb2lvdnMxeEJJNEwyZUt0QVZ2YzBRS1VUOW9F?=
 =?utf-8?B?RWJjamhXZEtQUC9YSE5BZWxlczEwdERkZHplMmJtS01obXF5MFZzcjkxekJ6?=
 =?utf-8?B?V1B2L3NKdW4rWjJYejJSOXR1QnppSzBjZGtpbFYyWlJYcVRwbGVDZytsQXcz?=
 =?utf-8?B?Qm8rdnVuOFo4bG1GWGJ5dEs3SDBNYWZpTStNUHlHMFRuS1NvdjVPUUpWS1d2?=
 =?utf-8?B?RlB2WFBNSHhsWWpwOWdPU000MmU5cHJvT09Cc0xIYm9QbVNvOENuK0xUMHoz?=
 =?utf-8?B?OVg4NEhhVFZzL1hlS2lraFo2eTFRWkFSYXVNUzZESTFmMUM4QjJCenNEVGQ2?=
 =?utf-8?B?cHoyc3FKUXgvRHRCTGRXR0JpYkRFMzgrU0JxL3U5cXpFLzhmaHFYejFlUkVr?=
 =?utf-8?B?T0NWRnY1ZksyaThEV0NiT3pjK0NpNi9kNHd5RGEvNFNyaTdYTk9HVitJTmJO?=
 =?utf-8?B?TXI3M0Y0b3RTUlFJdkorU0poQzJ5cU1ySTBSSEx4a2hFaWlQbW9HaUx0bkR5?=
 =?utf-8?B?Q2gzVXJMQkJlTjBxU1h3bjc3TlNINHlHRENMUCtneGFwTXEyUnFkWjlWblBZ?=
 =?utf-8?B?dlAyVFpmVzdWMTNLNUZ0Nk9LcjVYZ1A0M2xQbHg5UzVDSHJiNVVrMVN3TDFN?=
 =?utf-8?B?WXJyUm1NQ09LYUxCWVU1RmpUd1QvWlVJUVc3ZFFtZnlLVkRoNlVnY2JnUmZi?=
 =?utf-8?B?Y2t4ejgzNmhDM1NNYjgybzNReEowMWh5dlZLRGkzWGlRZ2NFVDdDODErNFVT?=
 =?utf-8?B?R2d5SkNLOU5GRWY1L0pYSnd0T3FuM3gramg3Q3JMU0ZNUU5rV0tkaG52a1Zl?=
 =?utf-8?B?STVUK3BPYjZOcjJxL1J1TXo4cGQwaEZ1V29rMkFPdVRMRFR6eXFMVHFvemNV?=
 =?utf-8?B?bWlZTXd1dFc3YUVoRWc1dXlCQnhqWDh3M1BKMnFnblRsbVNXQzllUDcrNnRV?=
 =?utf-8?B?cnZUdWZNWW5OdG1GR0lrNGkxaHE3czF5UEJpallzdlZobnc0aU14OFZESmxl?=
 =?utf-8?B?ZlF6KzEvTGJPNERIUW5Za24zOEZ5Q1drM1p5MEFxRjQ0VGloY1lzakZ1cUVI?=
 =?utf-8?B?dDFqdk9ZSGtvTFV3ZFpDNEM1Z1ptMUxNWWkxcVcyaVBtT2FnZStVckpoU0hi?=
 =?utf-8?B?eVNobTNtQnM3Ny90c05NcVVYWjBpU09RbGd5RnN3SFNKYUJPbkxjMlkyQXFr?=
 =?utf-8?B?cnBMdEhRTGtEMHFRN2luTHB2ZzBrS2VkTWhtTEMvVG4yVWxpM0lPdFVLTllM?=
 =?utf-8?B?RTNXUDBrdVljZHFya1lsZVRSNlFPMnBPUG9KcW5IQkRhOFIwcXVRdDFYWmFR?=
 =?utf-8?B?TFl2SlhrVU5VZ0pJZ3F2M3hnU204OGh4UnRyM2RWNkdYQm00WTMvTTN6ckVE?=
 =?utf-8?B?YWZmaEg0a0RyWUdYc2Nua0lkZGpZRm8zeDZjcTNuUWQ0ald6R2VpTDFsTlIz?=
 =?utf-8?B?UzFOL1dzcVZhRjNGNGd1MGZGWE9yd21yVXFZczNTYzh2QTlFdjB5SHoreTBC?=
 =?utf-8?B?VVFFWS94dnZ3bnJ5dU8zV3Zpd1FSZXdWLzBsNE9sdmRTaSs4SWg1eXRSb1RJ?=
 =?utf-8?B?c1FkZDVkWVZUWDFNSytFaHErRnlvK1F1aGYvUnNaRDl0MmQ3STVBdDlLU2Jj?=
 =?utf-8?B?WkxITGl6Mkw4Nm9EMldSRjFSUEtkOEtmZmo1M3lreElsZXZJNlBEalVpUmhy?=
 =?utf-8?B?cnBEenIwYmwwUHVPQ0kxRkQ1RE1GUjJ4VFdCM0hkY2VZa1U2RHJZUzF6OWN0?=
 =?utf-8?B?QS9veUE1b0diQ05uUi9ZV0NleVp3QlhIL2lHNVQ1VUtJdVpxR0tjZG83eGc2?=
 =?utf-8?B?R0psOEdETVI5OHJnaEhsRzRwS1NzMUVreUw2T0FreE1QUE5SNXlNUkZhSCtx?=
 =?utf-8?B?K3NwWWtWcHUzTXRiQWhIbHlkTHk4clE2WGVma25zcUF5THI4MVdEMmdEYkgz?=
 =?utf-8?Q?wsqy8331UiHoGV5gxSrBav88koTU5G8YwGMraaRXbnab?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7818CD2A64440644AA99C1E0CC5AB6AB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f12ad29-4a90-4b89-0d52-08d998aaa8ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 18:01:39.4173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: knsRBg4ruLaKiLgLmkGCf639kYY6ITK+ScKhUXc8XwU0000sNeNW88zJu4e+3PZL1b2c2OTeX1wmLwtxJmzbKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4051
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTEwLTI2IGF0IDEwOjE2IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAyNiBPY3QgMjAyMSAxNTo1NDoyOCArMDAwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBPbiBUdWUsIDIwMjEtMTAtMjYgYXQgMDg6MDUgLTA3MDAsIEpha3ViIEtpY2luc2tp
IHdyb3RlOg0KPiA+ID4gT24gTW9uLCAyNSBPY3QgMjAyMSAxMzo1NDoyNyAtMDcwMCBTYWVlZCBN
YWhhbWVlZCB3cm90ZTrCoCANCj4gPiA+ID4gRnJvbTogU2hheSBEcm9yeSA8c2hheWRAbnZpZGlh
LmNvbT4NCj4gPiA+ID4gDQo+ID4gPiA+IEN1cnJlbnRseSwgZWFjaCBJL08gRVEgaXMgdGFraW5n
IDEyOEtCIG9mIG1lbW9yeS4gVGhpcyBzaXplDQo+ID4gPiA+IGlzIG5vdCBuZWVkZWQgaW4gYWxs
IHVzZSBjYXNlcywgYW5kIGlzIGNyaXRpY2FsIHdpdGggbGFyZ2UNCj4gPiA+ID4gc2NhbGUuDQo+
ID4gPiA+IEhlbmNlLCBhbGxvdyB1c2VyIHRvIGNvbmZpZ3VyZSB0aGUgc2l6ZSBvZiBJL08gRVFz
Lg0KPiA+ID4gPiANCj4gPiA+ID4gRm9yIGV4YW1wbGUsIHRvIHJlZHVjZSBJL08gRVEgc2l6ZSB0
byA2NCwgZXhlY3V0ZToNCj4gPiA+ID4gJCBkZXZsaW5rIHJlc291cmNlIHNldCBwY2kvMDAwMDow
MDowYi4wIHBhdGggL2lvX2VxX3NpemUvIHNpemUNCj4gPiA+ID4gNjQNCj4gPiA+ID4gJCBkZXZs
aW5rIGRldiByZWxvYWQgcGNpLzAwMDA6MDA6MGIuMMKgIA0KPiA+ID4gDQo+ID4gPiBUaGlzIHNv
cnQgb2YgY29uZmlnIGlzIG5lZWRlZCBieSBtb3JlIGRyaXZlcnMsDQo+ID4gPiB3ZSBuZWVkIGEg
c3RhbmRhcmQgd2F5IG9mIGNvbmZpZ3VyaW5nIHRoaXMuDQo+ID4gDQo+ID4gV2UgaGFkIGEgZGVi
YXRlIGludGVybmFsbHkgYWJvdXQgdGhlIHNhbWUgdGhpbmcsIEppcmkgYW5kIEkgdGhvdWdodA0K
PiA+IHRoYXQgRVEgbWlnaHQgYmUgYSBDb25uZWN0WCBvbmx5IHRoaW5nIChtYXliZSBzb21lIG90
aGVyIHZlbmRvcnMNCj4gPiBoYXZlDQo+ID4gaXQpIGJ1dCBpdCBpcyBub3QgcmVhbGx5IHBvcHVs
YXINCj4gDQo+IEkgdGhvdWdodCBpdCdzIGEgUkRNQSB0aGluZy4gQXQgbGVhc3QgYWNjb3JkaW5n
IHRvIGdyZXAgdGhlcmUncyANCj4gYSBoYW5kZnVsIG9mIG5vbi1NTFggZHJpdmVycyB3aGljaCBo
YXZlIGVxcy4gQXJlIHRoZXNlIG5vdCBhY3R1YWwNCj4gZXZlbnQgcXVldWVzPyAoaHVhd2VpL2hp
bmljLCBpYm0vZWhlYSwgbWljcm9zb2Z0L21hbmEsIHFsb2dpYy9xZWQpDQo+IA0KPiA+IHdlIHRo
b3VnaHQsIHVudGlsIG90aGVyIHZlbmRvcnMgc3RhcnQgY29udHJpYnV0aW5nIG9yIGFza2luZyBm
b3IgDQo+ID4gdGhlIHNhbWUgdGhpbmcsIG1heWJlIHRoZW4gd2UgY2FuIHN0YW5kYXJkaXplLg0K
PiANCj4gWWVhaCwgbGlrZSB0aGUgc3RhbmRhcmRpemF0aW9uIHBhcnQgZXZlciBoYXBwZW5zIDov
IA0KPiANCj4gTG9vayBhdCB0aGUgRVFFL0NRRSBpbnRlcnJ1cHQgZ2VuZXJhdGlvbiB0aGluZy4g
TmV3IHZlbmRvciBjb21lcyBpbg0KPiBhbmQNCj4gY29waWVzIGJlc3Qga25vd24gcHJhY3RpY2Ug
KHdoaWNoIGlzIHNvbWUgZHJpdmVyLXNwZWNpZmljIGdhcmJhZ2UsDQo+IGV0aHRvb2wgcHJpdi1m
bGFncyBpbiB0aGF0IGNhc2UpLiBUaGUgbWFpbnRhaW5lciAobWUpIGhhcyB0byBiZSB0aGUNCj4g
cG9saWNlbWFuIHJlbWVtYmVyIGFsbCB0aG9zZSBrbm9icyB3aXRoIHByaW9yIGFydCBhbmQgcHVz
aCBiYWNrLiBNb3N0DQoNCldlbGwsIGkgY2FuJ3QgZXZlbiBjb3VudCB0aGUgcGF0Y2hlcyBzaG90
IGRvd24gaW50ZXJuYWxseSBiZWNhdXNlIG9mDQpub24gc3RhbmRhcmQgQVBJcy4gVGhlIGRyaXZl
ciBtYWludGFpbmVyIChtZSkgaGFzIHRvIGFsc28gYmUgYQ0KcG9saWNlbWFuLiBBcyBsb25nIGFz
IHdlIGFyZSBpbiBzeW5jIEkgdGhpbmsgdGhpcyBjYW4gc2NhbGUsIEkgYW0gc3VyZQ0Kb3RoZXIg
dmVuZG9ycyBtYWludGFpbmVycyBhcmUgZmlsdGVyaW5nIGFzIG1hbnkgcGF0Y2hlcyBhcyBJIGRv
Lg0KDQo+IG9mIHRoZSB0aW1lIHRoZSB2ZW5kb3IgZGVjaWRlcyB0byBqdXN0IGtlZXAgdGhlIGtu
b2Igb3V0IG9mIHRyZWUgYXQNCj4gdGhpcyBwb2ludCwga3Vkb3MgdG8gSGF1d2VpIGZvciBub3Qg
Z2l2aW5nIHVwLiBOZXcgdmVuZG9yIGltcGxlbWVudHMNCj4gdGhlIEFQSSwgbm9uZSBvZiB0aGUg
ZXhpc3RpbmcgdmVuZG9ycyBwcm92aWRlIHJldmlld3Mgb3IgZmVlZGJhY2suDQo+IFRoZW4gbm9u
ZSBvZiB0aGUgZXhpc3RpbmcgdmVuZG9ycyBpbXBsZW1lbnRzIHRoZSBub3ctc3RhbmRhcmQgQVBJ
Lg0KPiBTb21lb25lIHdvcmtpbmcgZm9yIGEgbGFyZ2UgY3VzdG9tZXIgKG1lLCBhZ2FpbikgaGFz
IHRvIGdvIGFuZCBhc2sgDQo+IGZvciB0aGUgQVBJIHRvIGJlIGltcGxlbWVudGVkLiBXaGljaCB0
YWtlcyBtb250aHMgZXZlbiB0aG8gdGhlDQo+IHBhdGNoZXMNCj4gc2hvdWxkIGJlIHRyaXZpYWwu
DQo+IA0KPiBJZiB0aGUgaW5pdGlhbCBwYXRjaGVzIGFkZGluZyB0aGUgY3FlL2VxZSBpbnRlcnJ1
cHQgbW9kZXMgdG8gcHJpdi0NCj4gZmxhZ3MNCj4gd2VyZSBuYWNrZWQgYW5kIHRoZSBzdGFuZGFy
ZCBBUEkgY3JlYXRlZCB3ZSdkIGFsbCBoYXZlIHNhdmVkIG11Y2gNCj4gdGltZS4NCj4gDQoNClNv
bWV0aW1lcyBpdCBpcyBoYXJkIHRvIGRlY2lkZSB3aGF0IGlzIHRoZSBiZXN0IGZvciB0aGUgdXNl
ciB0aGF0IGZpdHMNCmFsbCB2ZW5kb3JzLCB3aGVuIHlvdSBhcmUgdGhlIGZpcnN0IHRvIGNvbWUg
dXAgd2l0aCBhIG5ldyBjb25jZXB0LA0KRVFFL0NRRSB0aGluZyBpcyBhIHJlbGF0aXZlbHkgbmV3
IG1lY2hhbmlzbSwgdG9vayBvdGhlciB2ZW5kb3JzIGEgd2hpbGUNCnRvIGNhdGNoIHVwLCB3aG8g
d291bGQndmUga25vd24gc3VjaCBtZWNoYW5pc20gd291bGQgYmVjb21lIHBvcHVsYXIgPw0KDQpi
dXQgSSBkbyBhZ3JlZSB3aXRoIHlvdSAgbWFueSBhcGlzIGNhbiBiZSBzdGFuZGFyZGl6ZSBvciBh
dCBsZWFzdA0KcmVmaW5lZCB3aXRoIGJldHRlciBwb2xpY2luZywgc29ycnksIGJ1dCB0aGUgb25s
eSB3YXkgdG8gZG8gdGhpcyBpcyB0bw0KaGF2ZSBhcyBtYW55IHZlbmRvcnMgYXMgcG9zc2libGUg
bG9va2luZyBhdCBlYWNoIHBvc3NpYmxlIEFQSSBwYXRjaC4NCg0KTWFueSB0aW1lcyB3ZSBhcmUg
cGlvbmVlcmluZyBpbiBsYXRlc3QgZmVhdHVyZXMsIGVzcGVjaWFsbHkgZm9yDQpzbWFydG5pY3Mg
c2NhbGFiaWxpdHksIHRoYXQgaW52b2x2ZXMgcmVzb3VyY2UgZmluZSB0dW5pbmcgYW5kIGZpbmUt
DQpncmFpbmVkIHVzZXIgY29udHJvbHMuIGx1Y2tpbHkgZm9yIHRoZSBFUSB0aGluZyB3ZSBjYW4g
Z2VuZXJhbGl6ZS4NCg0KPiA+ID4gU29ycnksIEkgZGlkbid0IGhhdmUgdGhlIHRpbWUgdG8gbG9v
ayB0aHJ1IHlvdXIgcGF0Y2hlcw0KPiA+ID4geWVzdGVyZGF5LCBJJ20gc2VuZGluZyBhIHJldmVy
dCBmb3IgYWxsIHlvdXIgbmV3IGRldmxpbmsNCj4gPiA+IHBhcmFtcy7CoCANCj4gPiANCj4gPiBT
dXJlLCB3ZSB3aWxsIHN1Ym1pdCBhIFJGQyB0byBnaXZlIG90aGVyIHZlbmRvcnMgYSBjaGFuY2Ug
dG8NCj4gPiBjb21tZW50LA0KPiA+IGl0IHdpbGwgYmUgYmFzaWNhbGx5IHRoZSBzYW1lIHBhdGNo
IChkZXZsaW5rIHJlc291cmNlKSB3aGlsZSBtYWtpbmcNCj4gPiB0aGUNCj4gPiBwYXJhbWV0ZXJz
IHZlbmRvciBnZW5lcmljLg0KPiANCj4gSURLIGlmIHJlc291cmNlIGlzIGEgcmlnaHQgZml0IChh
cyBtZW50aW9uZWQgdG8gUGFyYXYgaW4gdGhlDQo+IGRpc2N1c3Npb24NCj4gb24gdGhlIHJldmVy
dCkuDQoNCndpbGwgc3dpdGNoIHRoZSBkaXNjdXNzaW9uIHRvIHRoYXQgdGhyZWFkLg0KDQo=
