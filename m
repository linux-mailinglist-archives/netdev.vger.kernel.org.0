Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD65B3E4E00
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 22:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbhHIUje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 16:39:34 -0400
Received: from mail-bn8nam11on2073.outbound.protection.outlook.com ([40.107.236.73]:40417
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233500AbhHIUjd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 16:39:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKGmN65sL3jlZ1XxYFaQR85e3crmcAZAT+6F2Rjqa8uHMNZPsuRvC88ytlxmqdFWsk3rG83Qj/qYTXtVCDkyssqWKq/P+hDHRO0S/DzYj6aW1ELIEr9X/UW4JUaSJNlappk+W/FyYW1KYXhYdNUY+iC7sVWzbn55S87QD4w8quzZNp9vVqrr9lIszdRqHgNrEh7TE/8BWvIWnfRykeHoZySbkLM7mqW5xdiia/Le6zkzqT49q6gXHvrp4EOPIOz6nId128mqClSZUukQRL+4g9OpoKiN4sA6qXROqA5sCuJUXWJQItnjLo8RKDli4QO8VCnIz20xJwIDuk1AB6Vfpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgoqA1E7mJ4byZdr8buRJRrroDR2bCGwN1SmY56yoww=;
 b=bsM38LbtGS/vpdiaYDjhSOQ/AcqJrhVsjFJOGanIuU9x3Cgs5FWeUyfjFUYZJ5d9cG90w9Gmx4YM7LWpSKazMV05QTjYfri5pIq/3BwSIaVJ4Blcq1IZb3+H7Ll5IDHHPjI9Eksf2p7hOvabWVcS1F01zNyWl8EQvLlQcZhQOUjAwNMsWKk2FAUX4tPCx8MphobhKAV6xpgR1QfchGSKEEyisWU3Vp/xIfVyJMnH4z8/N+Q+NcSO0BZNE8qJXibFvocfMdxaLrIUElxuwnoCFWp3UbswSP8pJxAKN6rTv6bjEYrxY0te87uzn0FMzEfbncXS6iLOSRpZngUHQAtxcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgoqA1E7mJ4byZdr8buRJRrroDR2bCGwN1SmY56yoww=;
 b=DOaG2bmFb+jNtzrMqD33LYtdJaw9wXBVG7n7g1Mj69HAFmMHaPl6ONMGvaXKVf/C7nAXarC7LhUDjUTOtWTeSbggO1+p7XLWHhAaheHbPw3SVtvTrdJ0K4M0lvpqBCZvv1BBsQHrj4EMy4mwU17cc1ct5IOgmiN7V0KD35R74LRdwivAt0K2w0zx/HsurjGGpqHvMjzJaU1uMHNyAOFmIkdFDgkX2E8XxbSb0oLEuRzXMtEjjgXjavF6hpmG+yYWuuWymQ0L01xCGG284bNrGewRLGroexL/N0LIQ4NaG9Kmvgd0jnkwsEmNo7uebVw9ZogZiVd3f3EqCk4yTPwkgg==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Mon, 9 Aug
 2021 20:39:10 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e000:8099:a5da:d74]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e000:8099:a5da:d74%5]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 20:39:10 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "caihuoqing@baidu.com" <caihuoqing@baidu.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH v2] net/mlx5e: Make use of mlx5_core_warn()
Thread-Topic: [PATCH v2] net/mlx5e: Make use of mlx5_core_warn()
Thread-Index: AQHXjRjVMMy1IuWST0e7zJunGwt/mqtrowOA
Date:   Mon, 9 Aug 2021 20:39:10 +0000
Message-ID: <7b7dba6e8d62e39343fd6e4dcbd0503aadfb9e40.camel@nvidia.com>
References: <20210809121931.2519-1-caihuoqing@baidu.com>
In-Reply-To: <20210809121931.2519-1-caihuoqing@baidu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.3 (3.40.3-1.fc34) 
authentication-results: baidu.com; dkim=none (message not signed)
 header.d=none;baidu.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0eb15aa2-b372-41b4-3540-08d95b75bdc9
x-ms-traffictypediagnostic: BYAPR12MB4791:
x-microsoft-antispam-prvs: <BYAPR12MB479121D9CF7A1C230B32AE19B3F69@BYAPR12MB4791.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nO9uEtN4Pm1wXUGETRyY0CZhIc+7/Udh01q668ExoIh2eYLVo+HQb2pXpOHLfkzmpLJYIINWbVyDSgfZCJvCdvidGKlLKOtZAjHzYDWR5lkXwvDUbo+6ltNGa6TR0UE/16pNXCZKw7LJJaJ+D84bksgLpGg4LTCnI9smkIlMvrI6xRPlfhjZeFujCwKB8+diaG9i6jnouPEywHpuK7OTavx5OitKRlLgJvZ/Y9Rq9Ny5bY0MSKTL5BN9WCCBc8ylE3R3NjGTwz+OipUZ5Ze7KZS1T2k3hgdyzqvK9SzjelaBfXY5AyYlZls3OBx1pLXhvH52nKQQMafLaWkov+RXPV++BVFNgGWvCU4Ga2aHTLBUaKhDNkArUNvwSpMLcCiicuAkroAW+aYcCp9IibxzduaSk3+morfTu5Ks9OymmA9Q8+24zJ8Hk5lyAPA2/xJ1hJa3XhDrmEQwJlSl6pUPU3o203SlD5F8pAB5NHynLCu9BhtO1qt2PgoPmizNMgIBaCYCLgYYSDH0xmT9G3pCbIz41q/LjIXc7z28IqCkW5Rpf6o6YCGaFn4M2xODt7ikw/nwjNlTksjpiU8qx4DPY8CIf1YzwHajqO9NErnkradendNDbJ2trEXNkRsz/AHye16/NajOWZW8ZjBIBQwvbdRCC9wZJ6PZ3veFQOVdHzGFrRepEWp9eQkC3k4djBYePhtulJbdBCJu27J9sHFS3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(122000001)(4326008)(8936002)(54906003)(110136005)(38100700002)(8676002)(2616005)(71200400001)(2906002)(478600001)(6512007)(36756003)(38070700005)(6506007)(316002)(66946007)(83380400001)(5660300002)(64756008)(26005)(558084003)(186003)(66476007)(66556008)(76116006)(66446008)(6486002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WnFJU1BzaGxlUUlqVzc0ZE50UTFqUWZST3E4RFQyVnI3UFlZZ0RKWVV2UWdB?=
 =?utf-8?B?L1BCUTFKLzBGcFkzbUJTVFloMGl6YU95THJISklHWThiZEN3RzZpZjhXZ1hP?=
 =?utf-8?B?QlN4RjFSL3BTeWorNDNFQnp4a0REMDFZZDlpWG1CTWlKa3pSWnpBWCtyemlN?=
 =?utf-8?B?YWhUQVZDTjB6NFBxdjN4NlljRXk1TnlBb0xJbEZRVEVmazUveG9rKzhzeFFp?=
 =?utf-8?B?UTlQWFhPWU4xNXduaFVWbnlITmUzcGxEenRValpOT1pCemxBOFg4bWhJUHZJ?=
 =?utf-8?B?WUo3dUJDWGcxUmROZG9pcGRFdWs5Nk9FdnVkSkxnd0JyWTVPQ1Rlak8yK3B4?=
 =?utf-8?B?YzZMYmFJZFVTSitUTFdOaXB1bDdnZUlDMFI5ZXExazVoYUI4RlZHcjR6azVB?=
 =?utf-8?B?bUpuOHlrcllMdG45M0pSVW5JZlE1M08yckdlVGZpNjlMeXhFMCtEVWI1MWly?=
 =?utf-8?B?djNrS3M2M2pEWE5SUXF1bWVBVVNFajBFdnNacjdlZlR5UW1vRHA2VHMxZFIr?=
 =?utf-8?B?NENndEI1NFhNQUlDN2svUkdZWkNBcWtuT2pGTk5XaDJoVHpYMXFRdXpLVU1L?=
 =?utf-8?B?RnMzOTRGM1Fqa3Y0eVpla0JEdzFKakNiTUdoZmRhZUFnRTc3TTlsYllCamdF?=
 =?utf-8?B?WkwwdXNLSEMvNVB2Z09rWVlDcmxUdVdCZDlEdWRqWitzREpwdk1zNHdtYklV?=
 =?utf-8?B?M2taU3BpWHlhUENiS1VPVDB6TVd3MldJU2FTU1RmU3kzcmJEMXdSVERpbHZH?=
 =?utf-8?B?NHpQNjg0TEZBV2x6S21RK3ZxR1M1Ky9zcEJBdXhwU1ZNM05hN3ZjVnk2Znht?=
 =?utf-8?B?eFFFMjR5WjUyZ1I3MFJ2cmxQRFFJOVBCNXMrbzllMitkWEZGTzJUaUNUUFlv?=
 =?utf-8?B?ZWFLWTB4MHFBd3JDdjRubDhaSVNyOUczdU1vMVhhTUJOa091UHVaMmI1Yy9J?=
 =?utf-8?B?aGlMQ0x3bEVWODZRb1N1aGllR1I4UlVFdm1tS3c0c0hTUGMvdHpRN1RPdCtT?=
 =?utf-8?B?dUptbSsyU1BzZ1duQXo0bm5ZMC9HMC9DYkd1Vnh4cXhuamE3cmsrTUowdXFY?=
 =?utf-8?B?Y0tETlV2clBSUDYwUVVJRHl3V0NJZnBla0JYQTdFNzZzNHBKaVFRMDVNQjlv?=
 =?utf-8?B?KzFNMERpMlRpN2ZhQWtIT0pUd01iUHRoN29tSURLZ25TVjNRV2hTM0VObEVZ?=
 =?utf-8?B?Ykt6WWRuWEw4dlBwN0FUYlZWSHJaYktLQTBHbG5ndGVUbkxvcWFzVTl0MTVx?=
 =?utf-8?B?RTNnakF4T1JPQmU1RU5qQWlJR2VFTlhMb2FGRVo2MWNhMnhkVTB1MUNjelox?=
 =?utf-8?B?UktFazhKRnpJeXFPVEtFMGFVL3hxZU9yUGgyNWxhRHN5Z1BidWxpR082cUJB?=
 =?utf-8?B?d1dIVklPMVo3MHdYSnZRSmZFaGh1aWVpUDVCZEJyTm9GT3U2MEFHOEhDR3Qr?=
 =?utf-8?B?QzZSM3VRVGxsaWV6aDJJL245OFU5K2NGOS9yNlVZeVJFQ1B2SVVTV2owVnFt?=
 =?utf-8?B?NFlrbWxOYTN5THhOaDUzS1lHYmxLQjVnNVkyL3dRYWJDRmV0ckMvcWJIc3dx?=
 =?utf-8?B?M3VXWkphenEvNDhRR3BOUWQvcnlYTTRhczB3dEdRS1hNLzJ4NUZaK0RzS2ND?=
 =?utf-8?B?U1UyOGQzeHNYd0VVMVVmazViR0lXQ3lkZk03Zjd4T1ZsdGNKVHVwSXNQOG5h?=
 =?utf-8?B?dWNUaXFad2VmTkppWmZsOXZNZWdQOGhpVWdwbFdRcVY2YjdzQVJtVThlQWZU?=
 =?utf-8?B?SFJrTkRDYkNCaHVqTUs4VUk0M056R1dJTm1vY2w0YkFoalZEM00zUkZJck9o?=
 =?utf-8?B?UXlmeEt2OTNNM2JsdUpKZz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B0B2B8A2BBA40643BD55F379648676CF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eb15aa2-b372-41b4-3540-08d95b75bdc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2021 20:39:10.1274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aKeuCtW9Ls/F7MOp6xl2Vi/4dQR7UW1SBQ6uixZ9VLDUFEj5c9PVywpl/plYoSQdKpG7ra5dakdXYQQAJAcJLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4791
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTA4LTA5IGF0IDIwOjE5ICswODAwLCBDYWkgSHVvcWluZyB3cm90ZToNCj4g
dG8gcmVwbGFjZSBwcmludGsoS0VSTl9XQVJOSU5HIC4uLikgd2l0aCBtbHg1X2NvcmVfd2Fybigp
IGtpbmRseQ0KPiBpZiB3ZSB1c2UgbWx4NV9jb3JlX3dhcm4oKSwgdGhlIHByZWZpeCAibWx4NToi
IG5vdCBuZWVkZWQNCg0KaW4gbWx4NWUgaXQgaXMgbmV0ZGV2IHN0YWNrIHNvIG5ldGRldl93YXJu
KHByaXYtPm5ldGRldiwgImZvbyBiYXIiKTsNCnBsZWFzZS4NCg==
