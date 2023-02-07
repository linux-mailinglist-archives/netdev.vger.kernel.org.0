Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687D268DCAF
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 16:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbjBGPPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 10:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbjBGPOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 10:14:54 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2058.outbound.protection.outlook.com [40.107.95.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5931219A;
        Tue,  7 Feb 2023 07:14:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K278LxrajzbBjCj58CqemZm3wvtlscsRn3reEDCP7WvU3CQo5H27lirwsOSqe3qxgGkX0NFOVBfCl4OToN81IJOpkmLU1/87BEp1D2iGDWnS5t+DYmfGZPDbpBvzNXB5wmMGvq6frrDpAEpzV9LF8OQ7srcCRgZtdx+xbVB9QMneVtqKpgFeq41oY53hOmquuZ0kBfi0g3YRmVrvmfyx9YCHxUxQ8N9iAb/aMj/6ieMYeMYl5NcEcUqSFfI8Ux/fZ087EAgZoUpZKMoVs53m1GWKWG+n1buSv95dxe6Nv0r0XV72DPPOT7d/7j/TSsuYqaYS1LzEoXAC+9UlEnhxSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k5WVY84Kld4bb5OXe4s4VXFsFi9j6s1EoDdUNx774m4=;
 b=oD2RM+QMAwxau7VD6wj9rE9lMeop41gFKwSAC3fhkPgyFt/orrYbXbBI35s383PWrOZnmt6gXJ5fNI12/1O36b9LEWXii/k9V+v2oHd0o1uQa10QNRlcP7IhgmdIEjgSNbO/8biwkIQUred50Op3qU/j/rZQivhR/eDpteFEi+kKDA8/6u2HPm8AxWXymQTtqkqQYQxpkZD0wGVfRMsGwQheLL2b9eBoU+c9iobLZDbaosidoJLqGCO3aa1NFSBv/X2Y2iFF+7h02MlLYDjxtp+1lCO88lFToYrO1NuBKhtuw3fko2weST5kzyIc2/x/j0clly0qrNxhuzd8m0dIZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5WVY84Kld4bb5OXe4s4VXFsFi9j6s1EoDdUNx774m4=;
 b=a8xjonZ7aZQDVCpBiRN36ZDBrEMbEMu5aHF0tOCTouNOsYEMoYuwHIHLr9hJYceLwKk4Lpocm/GdUaYtzBPsFJp4F/JSiEqMpvX7ilORMjBDEzhPT8SjLbZPV52hFewJ+b6AyH8d8ClxX7TPzCSJnnHZbqEriGmep8SJcrV4QAg=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by DS0PR12MB8295.namprd12.prod.outlook.com (2603:10b6:8:f6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 15:14:50 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%9]) with mapi id 15.20.6064.036; Tue, 7 Feb 2023
 15:14:50 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v5 net-next 3/8] sfc: enumerate mports in ef100
Thread-Topic: [PATCH v5 net-next 3/8] sfc: enumerate mports in ef100
Thread-Index: AQHZNveQ6+I+2rm1aE2+8Jl9mNQZ7K7B4caAgAG9+gA=
Date:   Tue, 7 Feb 2023 15:14:50 +0000
Message-ID: <DM6PR12MB4202E89F45A1DCD3D7F16879C1DB9@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
 <20230202111423.56831-4-alejandro.lucero-palau@amd.com>
 <fc2d452c-fa7f-39bb-b8bc-08e07ee9fbbc@gmail.com>
In-Reply-To: <fc2d452c-fa7f-39bb-b8bc-08e07ee9fbbc@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-exchange-imapappendstamp: DM6PR12MB4202.namprd12.prod.outlook.com
 (15.20.6086.009)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|DS0PR12MB8295:EE_
x-ms-office365-filtering-correlation-id: c9c2a70c-7507-4e55-6ae6-08db091e0ef4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ooBU7QwVwQ2Y5FLsjipYMri2IRtjRojBExwv67c9Qj+Iclkg0cMlnQ/ampWrm7ZPLwaYNSB1m6lFKWBuJZ0CqLnS6m3rYsgT+HC+ehOfB6zliypaxSbmuI9r6maKCRApTqu+E35YCyNsD8nX+GUEE+pG4BvUcNK0QkOx1t2Pa6sX6g1pHN0PmaKTOOi/ApOyPSxoua9L14NLnaUj7NkRN/jLzBV82RZ27bnDsNpeY9T1d9LsVkxs6nDorwfeOnExXcZx8uzxFY05x1n7X5ynK6zAhnvd9jt+BD0Y0VIY+SsVgrH6jMrL1zaYu9v2jw5uyOzxUqkWrrbPJ7iPOPXfrTGD14fva5F6I/1RgnO9hAl3K/j6W1DRIROV/FaByEp9v7GDBSTtOLmSaLXBcUVaofh0FABBR9vTHwT12G0CoTLh4xkG32Qw9tN6G58Jox9jlP5/bJxhiRvk4x1367PMNsyYpat5FcJ6Bafb4w0ZKCRy9k5GZnwHvCm4hVIgWOq55KWH40xPV1sEnkHGSNtSqxXpMWNADsSp061Qw74UqR21JKYnLl3KoC/2pli+ytZsuPxCHtHYJmsKVIME4jlmDzpqJdwPSWUXz03aY3p0QRTCogXMgeYsDzOFmpmR9HVFHcDWZs/68SMN6R3Cng0is0UwB8vHfW40BkziW4dH/W3TIPRwPAxOAg/7+sQTi2fxex0FmdDF+clC5yjjWVHGZJ6Rz1jxIWfa2+wquHEOdr+GOxS+wLDgdLthk3I0gZwa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(451199018)(38070700005)(33656002)(55016003)(38100700002)(122000001)(6636002)(7696005)(316002)(2906002)(71200400001)(478600001)(54906003)(110136005)(7416002)(52536014)(66946007)(6506007)(41300700001)(5660300002)(9686003)(76116006)(66556008)(4744005)(66446008)(8676002)(8936002)(4326008)(64756008)(26005)(186003)(66476007)(53546011)(65966003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?LzFyd2ZNR2hOOVpQVUowTkY1YzdRaWgzUVU0cEtuamZBa1hHUFUvOC8vdnVD?=
 =?utf-8?B?SjZ1QXRLOUJsLzZBM055cU5mc3N1ZGp1K1psTUJ3bmcxdUoydDZvdVA3bnBn?=
 =?utf-8?B?Uy9QQWdMMDFSN3AyTFhXbHQ5L0tiUCtYc0ZKU2xVdkUzMWdPakltNlNyRUJu?=
 =?utf-8?B?Z0htUkhmUEdacHdkak14ei80bi8rcjJzMVp1UmRyRzRxSHVFUm5nWGZVMVhX?=
 =?utf-8?B?N28rblhpS2pwbFJEbTlsR1V0Nm0wZGFmZWpFNmlNSFFQbGlUc2ZJZXJmZnRE?=
 =?utf-8?B?bVZHZkpja2ZJVE5GRjExbTNFMms0WEREV05vbU1pRExxb3RPMXl5Z29Pa3kx?=
 =?utf-8?B?UUJ2d2VCRG5kN2dqOGwwRzZXY2laY2NYaGp5amQ1TURyVlZ4ak5BdkMrbTdX?=
 =?utf-8?B?NzdqSmdRK2hreThHMnB2bGtRdHpvQUdOMFoySFJEcHNCYU0yOHcyUmQ5VXdC?=
 =?utf-8?B?cHl4ZXZVWFZwKzJJV3VLdXRFbWlZd3Axczh4SnRBeTh6MDVWSWhmTjhObVZv?=
 =?utf-8?B?WEl3bGYyMll4THZKNWZuTDh4Z2hjOEdXVGFTZ1ZDbzkrczVZbHo0KzhuQ01u?=
 =?utf-8?B?cVg3a2drVHpvaVVWemY1ajl0UzJWMGl2TVY3R2FLZzU4SDAwK2pLYndTM1RH?=
 =?utf-8?B?RGZIRGhVdnNIMG9NRlRNdnhOSm5ldU9ZOWcxYWp3QUtWVUMyS28rbzU2L2pR?=
 =?utf-8?B?YUo5Tlp4bnpKZ2hBVm9vUkZCbG1RWDEzNUhDeThMS21oVFBWNGVXcWR3TXdo?=
 =?utf-8?B?cUR2R2tzL2lOYXVhTjQ5dU1rT01BbS85Mkk4K3lNMkI5MGVoN1FSUUVsNjhp?=
 =?utf-8?B?NTNLcHU1cXl1Kzh4cVk4V21DQWJlUHBmbmh2MGJSczJqWEZjTGEvVFFldXI4?=
 =?utf-8?B?Z3BsRXpVNHZ4aXdMek9OQjdnckZ3cytDblArdTRXRDhVNklwbzRCdzJiTytp?=
 =?utf-8?B?T3RuRURpTW9LSjE5SlZTMm82dkQ3OWZJSmlUNmdFU1VDdDMyOHVXRE5LQldo?=
 =?utf-8?B?MStDVWxLd21zMStrNG52VWpWemFWcGhZNXRSTzJUQVY3RlAwY0hERWhiZGNV?=
 =?utf-8?B?VmxNdlFLckxsTWN3SDdsc1YreDY3TEhUOU1jYnpRWHl4UHkzajJVbnVyOUVT?=
 =?utf-8?B?RnFPVGtzVkFxMEN1cVREQ3pZUjdvcVhnNFJLVHhVY3paQkIwbE5OYTdxMXh3?=
 =?utf-8?B?eWZTZnFJMks3aGJqRllsNXhiR1JKVnMyWjVYazg2cWJJTHppaWc2QzNZTXB6?=
 =?utf-8?B?YnNkWHBRV2Q4ZjJ4Z3c2NDF6V0lBTVdXWEVTVXFxaEVVSUt4cVo1ZGx0UUMv?=
 =?utf-8?B?SFZHb2Q4eFJxL3R0RFl5ZUI3RkF5Z2NON0kvUDBWREU1TEZqR2xoUGZnQVBO?=
 =?utf-8?B?Q2VBa1BJdG9Pa2xOR0w5Nm5pOWFiczZJdmlpdFJ3Y2ZLOWwrYnRLSTFCR3Nj?=
 =?utf-8?B?dFpjR28walZ5MFFyQTRNVHhqZW10WGgyL0laanhOMmRacXFZT3hiWDFZTmlG?=
 =?utf-8?B?ZzNKWW9POXBzajJQMXJhQndmKzRKMGlvWmg4TW00TXZabXBNaERtN2JHU3Br?=
 =?utf-8?B?c3JzQ3lZaEhkUUlYOHkwY3cxam9QRmM4TzZyamVJYWo5L0NUMklrS3JOWW8v?=
 =?utf-8?B?M1F5d1lCU0xtd2pkcm9hMmlIQTUvbTR3aGRYbnpxRURGbFR4ZkNGUUJVZm9T?=
 =?utf-8?B?MFIvdUlCZnNyQXFoYTlnNnY4Rnl4bUFaeFRPTHIrUTBVajhNY29UZ2dMQ2hi?=
 =?utf-8?B?RzFYQ29CWUMvd0VXU1czcm1zTzhzL1Zrd2xEQTBCS0I1ZDUvN3hxOU0raEZo?=
 =?utf-8?B?eDJlUm04LzNObVh0blBJUnZONURYNTF6TlVYQWhhU0c4cFFzNnB5Njd4a0ta?=
 =?utf-8?B?MWpZVzNwSVVkeDdlcVFCSWhhcGQwenp2V2hCMkdWcE5uMHA3dXVCTUY5M3pD?=
 =?utf-8?B?YmRWa0djWXRlb3JGZnY1TEZtYkdMZ0RQeXlua1ZncVpCNk5sTnlZZWh3NW1q?=
 =?utf-8?B?K1ROVTdTZkY4NGVVbWFEblh2WGlGeHo3aEtWS1BGb1FoNDFMZmE1Q0NWVGxu?=
 =?utf-8?B?T1N0RGcyQmw4VTIyTEk5SlZzZnUrdXJqZytIcFBLNk4xQ3BicWZYRWJQVFJx?=
 =?utf-8?Q?u+IY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC991FF3892F5A439060F850243974DE@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9c2a70c-7507-4e55-6ae6-08db091e0ef4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 15:14:50.7000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fTou4YpG3gvLQ9a4AmyjLDRBfwkHJTL+vSP12qNUNb5GA30Gm4yRmvn3MV9c34a11JcjZqEka8Taksm5zImmVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8295
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzYvMjMgMTI6MzgsIEVkd2FyZCBDcmVlIHdyb3RlOg0KPiBPbiAwMi8wMi8yMDIzIDEx
OjE0LCBhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20gd3JvdGU6DQo+PiBGcm9tOiBBbGVq
YW5kcm8gTHVjZXJvIDxhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20+DQo+Pg0KPj4gTUFF
IHBvcnRzIChtcG9ydHMpIGFyZSB0aGUgcG9ydHMgb24gdGhlIEVGMTAwIGVtYmVkZGVkIHN3aXRj
aCBzdWNoDQo+PiBhcyBuZXR3b3JraW5nIFBDSWUgZnVuY3Rpb25zLCB0aGUgcGh5c2ljYWwgcG9y
dCwgYW5kIHBvdGVudGlhbGx5DQo+PiBvdGhlcnMuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQWxl
amFuZHJvIEx1Y2VybyA8YWxlamFuZHJvLmx1Y2Vyby1wYWxhdUBhbWQuY29tPg0KPiAuLi4NCj4+
ICtzdHJ1Y3QgbWFlX21wb3J0X2Rlc2Mgew0KPj4gKwl1MzIgbXBvcnRfaWQ7DQo+PiArCXUzMiBm
bGFnczsNCj4+ICsJdTMyIGNhbGxlcl9mbGFnczsgLyogZW51bSBtYWVfbXBvcnRfZGVzY19jYWxs
ZXJfZmxhZ3MgKi8NCj4+ICsJdTMyIG1wb3J0X3R5cGU7IC8qIE1BRV9NUE9SVF9ERVNDX01QT1JU
X1RZUEVfKiAqLw0KPj4gKwl1bmlvbiB7DQo+PiArCQl1MzIgcG9ydF9pZHg7IC8qIGZvciBtcG9y
dF90eXBlID09IE5FVF9QT1JUICovDQo+PiArCQl1MzIgYWxpYXNfbXBvcnRfaWQ7IC8qIGZvciBt
cG9ydF90eXBlID09IEFMSUFTICovDQo+PiArCQlzdHJ1Y3QgeyAvKiBmb3IgbXBvcnRfdHlwZSA9
PSBWTklDICovDQo+PiArCQkJdTMyIHZuaWNfY2xpZW50X3R5cGU7IC8qIE1BRV9NUE9SVF9ERVND
X1ZOSUNfQ0xJRU5UX1RZUEVfKiAqLw0KPj4gKwkJCXUzMiBpbnRlcmZhY2VfaWR4Ow0KPj4gKwkJ
CXUxNiBwZl9pZHg7DQo+PiArCQkJdTE2IHZmX2lkeDsNCj4+ICsJCX07DQo+PiArCX07DQo+PiAr
CXN0cnVjdCByaGFzaF9oZWFkIGxpbmthZ2U7DQo+PiArCXN0cnVjdCBlZnhfcmVwICplZnY7DQo+
IExvb2tzIGxpa2UgdGhpcyBpc24ndCB1c2VkIG9yIHBvcHVsYXRlZCBhbnl3aGVyZSwgc28gcHJv
YmFibHkNCj4gICBzaG91bGRuJ3QgYmUgYWRkZWQgeWV0Lg0KDQoNCk9LLg0KDQpUaGFua3MNCg0K
PiBBcGFydCBmcm9tIHRoYXQsIExHVE0uDQo=
