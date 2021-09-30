Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3FA41E202
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 21:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346913AbhI3TIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 15:08:23 -0400
Received: from mail-dm6nam11on2051.outbound.protection.outlook.com ([40.107.223.51]:55169
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347152AbhI3TIR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 15:08:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D747J9KToy5TCfP8PCwD0dVMcALOxuceSEhKiiR5FiKK0BUwBZ2ttoHEAphNZN9ktHK2nc0wYyvcFIcHoN5lIfWdUy64t2DvT6AhIeM9SwV/Ax3AlXVHdtMLt/YlDu9adMvnHoGGD9RgMNF2AanIFHmRT8AkDabZYs42Ow8aaXVlPKvpPV1iBaZvpPJpEL9tX9310T0BGH+0IYgOsIJcLqLtHWBHjZdYeijJ8RIFg7FyifE2ZFnzJK1HhelSe0Pv/Z0KVIzWm2rS9HaxBlKth6UHBFSgpujf5I67+pmwwh/yAJPgIwFKt8wF1FnjrUeIdS2HeC1FubYCgkztkCzdiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cSKl/2BdtTjmu39RkSdFNhLcxwMsDBZ7bsrwfUci8hQ=;
 b=klOW5/9LAgADuvtefgCOvoqfPekc07YrFkpEL1VPBBPOJLnkPUP+3iDXW9P3a8Ltdi8g+766W5Ytny/Xmb9f+fIW+7rhhQ9/+axgMm1oAVIQJWnDYsGBHvzsqlK8uoR99eD8/aPipbcS3rHuQ6SfKG2ZdNY/CFhfVUFudfDaCPFzQTUbFCKnU8L5KJbKYhNPhE+kN3Z/9bBMB03ava95eY5DCarmr8AQgUW+wiSTRkaT/V0UgwHUSrlorKzmE9gjAVuKQGvNacStwY468Zy7p4eg7ZYMCMqeQ2lAIfXGLoimqtr5ZgBx/tm6H7tN2KWf8WZPG3eDkeUDBPJy5YKVWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSKl/2BdtTjmu39RkSdFNhLcxwMsDBZ7bsrwfUci8hQ=;
 b=Pe5eYHM8tED0EcEnkCub7RyTDbQfoR4BKGr038M1QLjFfNrvtjXhipWC1WiT9NFOPZlBGulwvU5DtnuA08jKwq/CExQxDrzmDxHCN88zlh28R8oHftjGFxDHYMc+vMALSoh82yIRhKZwUh7qw8FCnwNNPi+YJO45eRl+g48BDCdvPTgHbdP0JqxNYUHSPo7h8eTwsH7M9bm64edUVjWfuzBelHzf9N+vgAHPe+r+4uNVBugDgeFaTaaX/+RopagI3GtezkMzteV7uJhMZAuir6admG1wWGRjiMwhdKxiEIpvzHz3zEGERAo48bfEYOtKy3s7uNb6ul7OPhXAFG20iQ==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3094.namprd12.prod.outlook.com (2603:10b6:a03:db::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Thu, 30 Sep
 2021 19:06:32 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%6]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 19:06:32 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][net-next] net/mlx5: Use struct_size() helper in
 kvzalloc()
Thread-Topic: [PATCH][net-next] net/mlx5: Use struct_size() helper in
 kvzalloc()
Thread-Index: AQHXtLVKpLSpqeUlFkSptBquRQhK8qu88yUA
Date:   Thu, 30 Sep 2021 19:06:32 +0000
Message-ID: <c121c9b4a21066eed32351e3324919df1c14d1c2.camel@nvidia.com>
References: <20210928221157.GA278221@embeddedor>
In-Reply-To: <20210928221157.GA278221@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c781a6d-18ec-4564-d069-08d984456aba
x-ms-traffictypediagnostic: BYAPR12MB3094:
x-microsoft-antispam-prvs: <BYAPR12MB30941F5C15A5DB85302DB632B3AA9@BYAPR12MB3094.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FHzC9q7iTOCbRI2gnKCCwEfgXF5/PBkDbRhg8pstOqSfESLjByoJeU98NSSK2zr4TI4OszjztbL4g3QE9Gk5Eq6A9lLFfIcMAtkj8erqKSsI4NFJCMRypXTU35KxLrKlCBNg0dfv23/we9I2Izy4bohs1qVacyRpqxq/6Uq0NtJbV/dT7fJqGlCHnXSIfdQdySNsfsa5C9ECbe4nB+CJ3P2QbT7ps7wTl41g/8j6yFM24Wagc00V2Hi2nfoDLV/M/QN5TUti8vIWy9onpF1h1UlLk2LUn8tU9dS5Qw4vR+AtNPMDjRRYWXJG/g8QTG21wVciNKapBldQe2+eILvfGjpP6OGEHI9E22GUgWpArD+eZUGPPkz2Z4uHyj0Yn3r3gfqEoi7xZ+ra36g6SMj98W5QaU9VgYB0nrQ/KF0S9sV7K6zgIIozGw6k96TatQI7AL7s3UFQQue+NSZPtH13ULCOok3V0OGKYlOnwUnsfaWZ+BghaRD0azNXL7+ebonJPCtRJUw2rtxDA8HGpLhskEHjyWuN0XOytNCX6uV5YJGilwEf/FwjFh3uDw5SoVrWH6joPwMEhE9/EQMWSARQ0l2G+XT5cqsq8m47IafQq6uAPg7dxfHL1N7A1zzam28oJWfPvMnDM4xnnzmaoQAuqUyvpeoywO+aKHInx6HVTQn53tYQyU+1mSSlTmF/pDWu2WG2O+U/Q9NjlJpO3OMWf7OaTn8wekenqreJz6l9IH7qEmqaNtKGyErYa9jbfPLEoJC2rKvrhVYI/cSSF8R87GwVyBf3zgwcR1jcO+Et6RQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(4744005)(966005)(66556008)(6506007)(66946007)(186003)(83380400001)(38100700002)(5660300002)(316002)(122000001)(8936002)(86362001)(36756003)(8676002)(2616005)(110136005)(26005)(54906003)(76116006)(4326008)(6486002)(66446008)(38070700005)(6512007)(71200400001)(508600001)(64756008)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eVRHWnNzQ2JhT3lQZk1ZdW42c2JkdWZqV0VqWGp1MUd3bEFITVM1ZW53UWtx?=
 =?utf-8?B?TDBoRUwzZmdXSG1KSFlLckZDRS9NVnlhSlRyUytWd1cvWHlUQjR4S2tBZHRH?=
 =?utf-8?B?V29zQ0VneFlpdlhXYXdDR2ZKczdPS3o1UU5Nb3R1VkdaU2lmeUloRndVMDZK?=
 =?utf-8?B?QWc5b0haOVpHWG13WDJSdDcxd09sajZ5NUoyNW5tem1wS2pjSHR5Q2RXTy80?=
 =?utf-8?B?Z2c1cHZTRk9nOVRvekRaRGNNaEV0b3lyRDk0d004VUV4UXdnNmVQVEVCSXZT?=
 =?utf-8?B?bzVUZ3BUcHBWNDRHQXIyVkUzMW1qTC9IZFBwQ1Z0Uk5Zd3NOLzVRQ0dpOEo2?=
 =?utf-8?B?NUh3WlF6bDBob2ExS1BzUUpnTUVIUkhtMzF3Q3BENUlYeDAyUnJRK0R2TlFu?=
 =?utf-8?B?ckxlMksySU1WM0NQVktwUUUwY1daaHpMUGN4MGVZcnJocUdVZ0ZtM2o0MWVT?=
 =?utf-8?B?K1pCeHZTYmI1QjVXdmdWWHUvd3FrSnYrUW1wWnFvSjRCZy9vZXNBc1JJSVFJ?=
 =?utf-8?B?U2h5UEdRMnlra2FtZmVrZzM4OWR2VVk0L25wZjIwcHdXSkZENXJtKzFVNDVN?=
 =?utf-8?B?V0hydkZhZHg4VnhSREE5SlJFWFpWaStqSERFK3J2cG40MDl4TDhZS0dhdG5S?=
 =?utf-8?B?dEhaSlFWWGVlVU1EVEN4LzZtcDlxb3llb3VRV0oyWTBNNTBIM3FBeSs2clZS?=
 =?utf-8?B?V25OMzEzblBkNmNralV0RVQzdG1lV01OSHphLzZvR3FCWXdNZHJmMWFhUTha?=
 =?utf-8?B?THJEVmZyZlhlRkxsQjRiYmZoUGpkb0dXSmtkMnkrTEx4ejFZMW4yU2dVMFBU?=
 =?utf-8?B?TnA5UjBqQXlrWlYxYnhhb2ZLRENGaU5ndU5ZTUllZjAyaFJIZENPVTRsMUJE?=
 =?utf-8?B?NTBSQVd6dG05TWpXenBWb1IzNE9GQzNZTGNDSUIwN09KNkFrbnhyNUhoU2R3?=
 =?utf-8?B?WFNKMzdub2lPdjc0OWw2enM3aHhjSUppVkJ2S2trV20ybGxmWjVXVlgrc0Nn?=
 =?utf-8?B?UkQ3Y2NKVlFYN3VxZ3hiRTBhcHhIdTBnS2d2ZFVFRUFLazhEanRyRTFiSVBp?=
 =?utf-8?B?TXliQ2NVVjdBRGRvdEFNZUF3MWhCRSswMWNyWi9SNGs0NjhBRUVQdEtzRjA2?=
 =?utf-8?B?aUNxbDBVcHJMMkxVWldRaDFIbmtZbFU1QnVOdVB0NGNuSmIyU25kNDNzT09K?=
 =?utf-8?B?TjJTOCtYY1NTdmczSXl2ZzlCbmQxMVRJNUQvZFZwQy9lOUNDcTNldUg5c1Q5?=
 =?utf-8?B?LzRQRUh2SlExSmdRTC9oQm96V2ZzOWpqdTVzZ2dDb2V3aGUzK213cFJrdGxF?=
 =?utf-8?B?b1dDVlMwU1N3ekZoWmY1R0NlakdLZlE1cDFuRjV3a0xSeXlYcVkzK2t3RkJS?=
 =?utf-8?B?SGlUcjZEd21rSGhQNVl3aGNDdU1BZitpbVBFRlNrY1dqRjZqNzJnUzg4MWlU?=
 =?utf-8?B?NC8raFlsTHhqRmkxMkdyVE5oWHpBTXVWeXp5aDJBUCtIaEVmWitGVEhvdW9Q?=
 =?utf-8?B?S2NqV0JrN0pVMEI4TXV1Zm9yUXZ5Q29nTDNmZ3ZVSEpWR3lKWE5NdThKZnBt?=
 =?utf-8?B?UTMzelNQR0NzaktMaUYrUUw2ak9ZelFka0ZUUEFZbWVqT2RhWW1idFNLTnRo?=
 =?utf-8?B?NjgzWmNvVkw5ekdVNWV4dFdxQWt2eG5YakxNV3pSN2hNWlBiMFpXb3RJNks3?=
 =?utf-8?B?SWR2c1drNDY0aUVtNzZndXAyVG1lWFY1a2JUanJpamk3UU1kZGtrZTcwVU13?=
 =?utf-8?B?NWY4Um5yQjhjcSt4Tzh2U0l1UHhzTUJGbjRpRGg3T0NVZW5MSlloTHlGWk5K?=
 =?utf-8?B?YkdkRFRxdGdqNUlmaElVdz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DCEFF4ACDA765147BEEE7AC3B0B7A965@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c781a6d-18ec-4564-d069-08d984456aba
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 19:06:32.6658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vB7EZZ03ARkjtdegsNewAtONaclvn2G0vIdUzbzM6MYaOfBbt56DOUL6UgKiB5Dcppnhn1PGQb0dSqwBCrsFog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTA5LTI4IGF0IDE3OjExIC0wNTAwLCBHdXN0YXZvIEEuIFIuIFNpbHZhIHdy
b3RlOg0KPiBNYWtlIHVzZSBvZiB0aGUgc3RydWN0X3NpemUoKSBoZWxwZXIgaW5zdGVhZCBvZiBh
biBvcGVuLWNvZGVkDQo+IHZlcnNpb24sDQo+IGluIG9yZGVyIHRvIGF2b2lkIGFueSBwb3RlbnRp
YWwgdHlwZSBtaXN0YWtlcyBvciBpbnRlZ2VyIG92ZXJmbG93cw0KPiB0aGF0LA0KPiBpbiB0aGUg
d29yc2Ugc2NlbmFyaW8sIGNvdWxkIGxlYWQgdG8gaGVhcCBvdmVyZmxvd3MuDQo+IA0KPiBMaW5r
OiBodHRwczovL2dpdGh1Yi5jb20vS1NQUC9saW51eC9pc3N1ZXMvMTYwDQo+IFNpZ25lZC1vZmYt
Ynk6IEd1c3Rhdm8gQS4gUi4gU2lsdmEgPGd1c3Rhdm9hcnNAa2VybmVsLm9yZz4NCg0KYXBwbGll
ZCB0byBuZXQtbmV4dC1tbHg1DQo=
