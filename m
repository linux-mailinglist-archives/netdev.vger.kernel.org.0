Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9E243E903
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 21:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhJ1TfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 15:35:22 -0400
Received: from mail-mw2nam10on2041.outbound.protection.outlook.com ([40.107.94.41]:51233
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230442AbhJ1TfU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 15:35:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ExaJW2cBUwYy1hLm2tKa3fv3OLLPucOpPKedJJ9KIcihV81Ek4q7kpZ4NS3RMJBaip8hx/afB50mCK+0s58CZ5m0Pl3TTvXVKKSw5irXkYvJex3majs/zuPX7IpyEJxxT3yN0Vx3eBzTsIxCN6Pn9dUKex60oBpSAC0HOjO61Or98PgjHWFsmEeloH4PZUnbNwzv22ykruwsbbxxSJ9H65R8tUIHmSkhUbq+CoYPZX9JNwJ1aHBBZGc6ziQh/8A9f97/XeAKNf/2QaP5qnZyLMx8mrKaC86F/qdlOGBNaUB2UoPh5ilmPIvIUl9uSsit5yTs0mOY8z6PS7qhuMilKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQ0TsE8Ct/qllq4LKFhKF/oG5fF0UhZ2uKjm2RvEJ/s=;
 b=Q7EgCo+45bN+F5k7eJHDIQUT6rESklh6OOUTQUKbOSSDZKSBDUfNiJtkcSfeeAVIpN34cNv+Ee2Jph1TkZcL3ZSYeTYUSiYr+2R1HN3BY1/Q/JH231n92q6kKjWDYINhB+WGxeGNP0WhQsw+7MsReFwWgPnm/aQE2EgTIESbA5qyVEBZlvCOQi0nHfIxuAuowMuHBk6GmgnDRWgKpToN+AszEqf1pA0ckGyZLnl5QkLJkJj+WNwDAyi0Jq07oFDmjivz1vnU9q2aI7E3YqJw/P16QbyaDruCZeN25szlz61gLomjXG2wM5V3TiojK+fcY6AAbNbMB3V7fpI3owbgNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQ0TsE8Ct/qllq4LKFhKF/oG5fF0UhZ2uKjm2RvEJ/s=;
 b=s7qG+SZ7stfrCv81pn/89aCQBr3c2oiWQ2KC1IOjCwhM4aj6RNgCuFrHps3SZIXDLqZgM/FBTMKsurLVCvpimvs83pNR/RdVjfY0yy5KK9uAOvFHIk8qnablfaueGg3f6i75840CsqJgsCogDiMs3C5SGHI2C41EYBR8dev6pVDzhD0eyYPD+5+XjaAxLt0dqRe3Puo/CpCvpN6Uh7vQlETNWpQ9hXbO8xco3UtNd5gyZfDJqVwJos3kF4TjjRhGmlR0zJoMbCk22CvedOW24t2mvxwPrl8Nk0z7iH9X3eJ0bB5ofDRg7uwEJiWuCebkJeA3wCEGi09UqfFc43cLog==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB2709.namprd12.prod.outlook.com (2603:10b6:a03:6d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Thu, 28 Oct
 2021 19:32:51 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%6]) with mapi id 15.20.4649.015; Thu, 28 Oct 2021
 19:32:51 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull-request][net-next] Merge mlx5-next into net-next
Thread-Topic: [pull-request][net-next] Merge mlx5-next into net-next
Thread-Index: AQHXy7uiCrVRFQ5hrky3bRgce/9qoKvoh6oAgABGDgA=
Date:   Thu, 28 Oct 2021 19:32:51 +0000
Message-ID: <fc2a38d0a5bcecf0032edd50e67334b3e229d825.camel@nvidia.com>
References: <20211028052104.1071670-1-saeed@kernel.org>
         <20211028082206.3690e760@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211028082206.3690e760@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19dab567-fcb3-40e9-dcff-08d99a49bb26
x-ms-traffictypediagnostic: BYAPR12MB2709:
x-microsoft-antispam-prvs: <BYAPR12MB270994F6305DF425EEE2F0A2B3869@BYAPR12MB2709.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:334;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mb8N91GLqJi4gGprBVfVFOC8urRdRrmPVyFeaJ/crZo1T8klYnbbwmLUx9mqm/7w5LS6Y2Jdd8gDqzY0t7UcQhPbFQcGh6sW6+n5NueJUvu0XFc80UkU6H+h5W7fPlc7FDf2+rul08TVjNMpg2wREAi/B6qEWhLFWmdMO0sCqKyvkARD3aLj7djzsPlvL3/WkKFgjH9B2PYbvRojZd1p1jeYE48EjAoA8LDIrDNzdmWdJm+9uMDvSdfVQBJ/t2/rH4Ck5Zgb8l4ZuGGSF6CRN7cf4Np8RmkuM/MFACB8BC9zxNFoJNGRe69moeQn0pnugARY2WqUGhS3tZmvzBt0vatW/ZHexfQaM791pulzN4oCX1JfP6bwCAQuqbrbR+tgzCmHR8Ady4cTChHxpq8QVc0DmSIztUaKKy5GmlGy/7izeqeJ6U7NNGnfPdiRZpQF6CBD0o0V950Zk5p8wSjR1tKc+G4IMZXoxLom7tpE4ciUPXXTgzqfhPNQaVTC1x58NlTXc7eSKi9t1l6YUeHk82qd0663w7b6XbGLRGFG5+MwATHZHegl1pV5iblBEXIEk1qTBp+3/5cTv/4KPKd8YEcofS9GYSD1u5wBR/DBs21o5Me43RUZ0lPkMTsW2n61bVEEhL+AjRXPRQcBt3Wrt7k+7I7k7qnqBbB9kkEF4Y6E/8335SE98+1j5WPLbqYM3cLgWEfI7zTyDHy7XW2FxRZ5+OaveHCqlupaFDCdSYHoCLLnmOu9kBggm3XQ8tI/oYPFn1x3qCA2O29MHjaDXHvvX0WIon+2f/X+vEBU79o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(8936002)(2616005)(76116006)(966005)(8676002)(36756003)(66556008)(66946007)(122000001)(4744005)(4326008)(86362001)(71200400001)(186003)(66476007)(5660300002)(38100700002)(54906003)(6486002)(66446008)(4001150100001)(6512007)(508600001)(64756008)(6506007)(26005)(38070700005)(316002)(83380400001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z3BmL3BCL3JhUGk3TG9zVEZQVXh0bk5mdjkxUGYwY201UFErMlNrcEJzYVFj?=
 =?utf-8?B?eGFjQ280QW1GZkVmNzE4aVVGVVJGUEl1blJpSUl2dEkwYzB5ZDZvWm9obk1y?=
 =?utf-8?B?YS9tTy94eXUyQUVoTDd6YzBLZlhWWFV3elZFVHg5NDduV3Jrc0c3Tm1RMG9n?=
 =?utf-8?B?MXduYU8zcEw3RThjYWpCZkFTRUpxNk5xNm1oejNVS1E5Zlp1NWlzUVBEYWlZ?=
 =?utf-8?B?b1JoSDlxWVZQVDRzYnE5L2tTZ005VnhraGlkcEVIZ2t4M05SWHlwQ2ZCZXZS?=
 =?utf-8?B?QmJyZUN4R3c3S05aWmpnSFMvVHJ4S3pESDE3R3NZRE43VU5EVC8zRlRlb3l6?=
 =?utf-8?B?eGFVWno1V1FsQ0RtbEV6V2RQRkIwNTJoWU1JeFZvNTRMTlR6UWViTk50OGta?=
 =?utf-8?B?NXBoM3p6V2hpWXRBM1ltdGZldW1mZkx6WkVHVGppWXExYnlnZWVVM25YaGV4?=
 =?utf-8?B?Rk80NzN4Rm5hYlI0T3pjeldTNTR2cGgvT1N2OUxZa1FXYy9HRHd2ZzdmTGt3?=
 =?utf-8?B?azZLSngwVDlCb1VYNnJjblBkVThQVkdLTVBieWIxWDI1d3ByWE94ZnZTQURp?=
 =?utf-8?B?UWZoSE1aMFlBZERLaCt1ZHRJUy9aRyt5TVlxY0hvRDl6a2dJaEZFQVNCOGli?=
 =?utf-8?B?WWdUaXF6SDR3THdVczlvQWlDaEdramp4elQ1d09yV1FHSjlQRzEreWtiaW5H?=
 =?utf-8?B?MjQzRWNLam1yTWt3NW5iWEhmTUc3MzU4SWhRZzd3TVI0b0FqTVBrWWNQdm5r?=
 =?utf-8?B?ZXFUWC9KalZheEQyUTEya2t5S1NvT1RpYlRhYURoZUtRV3c1K3pyVng4c2Ir?=
 =?utf-8?B?NVVlRjlIN3JOZVlydEYrMzlBdTUyMGNlTWY1a0M4ZHhienpuQlVwb0NuM0Nk?=
 =?utf-8?B?T2ovUUR5dC9ZQlhVWXVpTU1PNmhvL093MjluaGhBcVhzdEMzbm1LbGt6QmZw?=
 =?utf-8?B?RkZyOXhWRnFyNWhEL3l2NVZNbklBWkloT2NsWDBiRExOandwWGlXSHR4SjNn?=
 =?utf-8?B?YWZ0SjZGVUs1cWR6RitEbnlaMGV1T2ppN3NHV0c5bUVSVThrK2JWNzRSdUtL?=
 =?utf-8?B?MEZiVnFnR04vbmdiN0g4WW45VzRpeHFtVXloa01EdEliRTRXOHpBbVo2R1VY?=
 =?utf-8?B?VThvYWMvQUVnc1VGWDlnd1ZhNWR3Q0dGTVV5VWdXYWg3bnlKMldabzVEK1FR?=
 =?utf-8?B?QURITUVadWpaV1NTNFNZaUdsamE5Q3NiWEVkb3RXMmx5ZjhRRFMxN1JxMnRC?=
 =?utf-8?B?Z0wzTzlWMk9Pb0Y2VVR6TWdWbkJuSjNXQUVseVhIczRZY2duTmE4d2Jhc1Mr?=
 =?utf-8?B?NDdFYzYyWmdDTXlnbUk3K2lhdTBCSFJudlYxZTEvMzNqd0VITENiY2RHajNr?=
 =?utf-8?B?ODk0MENlTHIybkt6SGFpK1hJNC9rclFldEpsQnpYb3dvejZndnREL3hsSGVO?=
 =?utf-8?B?V0NiZlFYWVBubmwxK1pYNlVYY08vS3phREZ5bUJyYTN1eGZyVExLeXlUVEVK?=
 =?utf-8?B?NkI5YWVseFFnZ0UwVDUzWHNUWURGaUsyTHhSVEs3TUs2RWlTSEJIRGZ4ZHBk?=
 =?utf-8?B?UFdLS1M4MmVMeFRNS0hEVDZHdlpPTWJrbW5kVnFLcExoRDBJcTFMVXR1U0FX?=
 =?utf-8?B?YmhKQkpkOEtoMllsNVN6QlVwam9Bb1BESDNTeU0rWHkvTGdvdVpHYTcya0J6?=
 =?utf-8?B?aEdtUjhEeitXOTNNTER3SUMxU3dvbGppUlRpWnpOWTdmc0dBS3hJb2dsR3J4?=
 =?utf-8?B?WUNPUSs2MUhrenZSdHpKdUxnNktHaW0rRHJ5ZzRmSFJnS1RCRllpMkVDYlJT?=
 =?utf-8?B?OGcxZDBDa0Y3bG8xaEJCRVRSRFhQWk83Z3YvbDhCUlBVNFplYmgxZFEra2hE?=
 =?utf-8?B?eW9TdEVzS3JyS3pqNTFjZTRKU080Uys4UWFUUUhuaU1Vd0J5RmRpT2Zsb04y?=
 =?utf-8?B?QnpxNTVZbFh0d21xNHR6MkUrZUx1cktuZTZDWC9xK3h5U2ptbzd1YWVkYUla?=
 =?utf-8?B?amdwcnZRbEtwMHNIM0UweENaR0ludnp1TkJ1N2VCUDdER0dnVDdtWFBKRzA0?=
 =?utf-8?B?ODY5bTFIMEhyL1A0SWovNktnUTJtNzZzVzlrZkVzZ2c3RlZISHE3dG10bTds?=
 =?utf-8?B?c2RXclR4YkZtdjJvWU45OVZKaUxDK2EvUGFjaDdVdXFBT2VpUkhVaDZycFN4?=
 =?utf-8?Q?aSQeDqVx48cX/v5EbxZhjTQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3FE53808D0E01549AD6A2309A549A9A8@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19dab567-fcb3-40e9-dcff-08d99a49bb26
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2021 19:32:51.1657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xOa6lOSy4LloOwJNsX+Aq9MSNWy/7dkBEi0Zl/aDTWkKaZikmeZIlgG5moXv6E3NLsU6kE2wjKPrB3tzSLgPTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTEwLTI4IGF0IDA4OjIyIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAyNyBPY3QgMjAyMSAyMjoyMTowNCAtMDcwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBGcm9tOiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG52aWRpYS5jb20+DQo+ID4gDQo+
ID4gSGkgRGF2ZSwgSmFrdWIsDQo+ID4gDQo+ID4gVGhpcyBwdWxsIHJlcXVlc3QgcHJvdmlkZXMg
YSBzaW5nbGUgbWVyZ2UgY29tbWl0IG9mIG1seDUtbmV4dCBpbnRvDQo+ID4gbmV0LW5leHQNCj4g
PiB3aGljaCBoYW5kbGVzIGEgbm9uLXRyaXZpYWwgY29uZmxpY3QuDQo+ID4gDQo+ID4gVGhlIGNv
bW1pdHMgZnJvbSBtbHg1LW5leHQgcHJvdmlkZSBNUiAoTWVtb3J5IFJlZ2lvbikgTWVtb3J5IEtl
eQ0KPiA+IG1hbmFnZW1lbnQgY2xlYW51cCBpbiBtbHg1IElCIGRyaXZlciBhbmQgbWx4NSBjb3Jl
IGRyaXZlciBbMV0uDQo+ID4gDQo+ID4gUGxlYXNlIHB1bGwgYW5kIGxldCBtZSBrbm93IGlmIHRo
ZXJlJ3MgYW55IHByb2JsZW0uDQo+ID4gDQo+ID4gWzFdDQo+ID4gaHR0cHM6Ly9wYXRjaHdvcmsu
a2VybmVsLm9yZy9wcm9qZWN0L25ldGRldmJwZi9jb3Zlci9jb3Zlci4xNjM0MDMzOTU2LmdpdC5s
ZW9ucm9AbnZpZGlhLmNvbS8NCj4gPiANCj4gPiBUaGFua3MsDQo+ID4gU2FlZWQuDQo+ID4gDQo+
ID4gLS0gDQo+IA0KPiBGV0lXIHRoZSBQUiBpcyBmdW1ibGVkIGEgbGl0dGxlIGJpdCBhbmQgdGhl
IGFjdHVhbCBjb250ZW50cyBhcmUgaW4NCj4gdGhlDQo+IGZvb3Rlci4gQnV0IERhdmUgaGFzIHB1
bGxlZCBzbyBhbGwgZ29vZC4gSnVzdCBub3RpbmcgdGhpcyBmb3IgdGhlDQo+IGZ1dHVyZSBjYXVz
ZSBJIHRoaW5rIHRoYXQncyB3aHkgd2UgbWlzc2VkIHRoZSBwdyBib3QncyBhdXRvLXJlc3BvbnNl
Lg0KDQpHb3QgaXQsIFRoYW5rcyENCg==
