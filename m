Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E568E5FC004
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 06:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiJLE5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 00:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJLE44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 00:56:56 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667A79E6A2;
        Tue, 11 Oct 2022 21:56:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mL9wGUtG6dBYcH89sZ0g4zp6LFw2qGgHtW2KmUuXqQziZwNDOGI0YOPNn+T94Jt2UAAi10dbZ3Keo3Z8FmiJixArRwsMJGFpouxNAMSD4ZpJkj2hwm0tJW1i0GBFkc2ChZmfFxyhdute8EO1EnXhLG5Y/WlO59CcdGV4A3m9xvLhQCBtjgNfNmthV6FdfuRx5q/s3UFUW1X+5890I7lmComkyzTQTV147RnFN4WihheZpe35bGkqxADXX59tDcpADQ1KF+rZk3dOnVP8M7qVr1C43ahN8O6efX5Ao7g8AwHJXZueSaTbgbMMNPeGEM3SnYOJxIkZ/7ydensZKS4GnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQrPtpMKHw6txWevRxaMRwlC/CGpLA47SiYEOelJLtE=;
 b=BKTK6nv3dovAIdYXHTpEVzc1NaJgVUK5677GLU2+aYELYsW/KrQoyY6KkGiFsLQuK2FyVGSwUkLzGH+1iB3ZVga8PZO7YkHkW+Lg0C1ESUZOA4LLOXwcJxL77ZlJGRIakWd65rW1kZXSP863+iaLQ4ngPEPUTiOB7BUNE1HHTR5V3eAO5NFgmBe+n/rBD46BaLad80fE30d23kzf5ONHZfmIwWZt56EOOmv5aYlfSz5THa8lKdEHSzMasR7xYtRrs6N108HByPhlK2u1mPpAoJZHLB9i1i/f8/wcMplaJGms4A6epbQFBwTBqDbb9eChXaYHa9fQuRgamndJ2qi++A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQrPtpMKHw6txWevRxaMRwlC/CGpLA47SiYEOelJLtE=;
 b=ZiUep6ZipmGDDt5Kz5CCUUw20z+PmFc97WSS98osOJKrAlicYXKRhfJADYjF3ywIvjI5IPasUeHz8Cv6y1Y9KBP7+rPFVRAXEMnRwDkfl8KwxuYQ1WDla+C0PCkJffNyCB6L04KURjXXXKo7S9WtuRtrsWXr8/vSpKtm7EsXzywkcb98hJfSOrBHadRz4qmV7R9+IQqZ3jdeMvDQyDzfqyHCvOZk572AM6YCrGqu77axM/PRUSH5vVRl61o3BxWBZRVxlWGQJHvkUuhjc5/Ay8Ugj86w8y3ArYNncjxwkDT0JTm+Btdi3iZ675K8e/iMkVlDal/0YzfMfw9b9+nCHw==
Received: from LV2PR12MB5727.namprd12.prod.outlook.com (2603:10b6:408:17d::7)
 by DM6PR12MB4188.namprd12.prod.outlook.com (2603:10b6:5:215::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Wed, 12 Oct
 2022 04:56:53 +0000
Received: from LV2PR12MB5727.namprd12.prod.outlook.com
 ([fe80::1b0:77b3:780c:ea36]) by LV2PR12MB5727.namprd12.prod.outlook.com
 ([fe80::1b0:77b3:780c:ea36%2]) with mapi id 15.20.5709.021; Wed, 12 Oct 2022
 04:56:53 +0000
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Revanth Kumar Uppala <ruppala@nvidia.com>
CC:     Jonathan Hunter <jonathanh@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v4 RESEND] stmmac: tegra: Add MGBE support
Thread-Topic: [PATCH net-next v4 RESEND] stmmac: tegra: Add MGBE support
Thread-Index: AQHYz0KK0TEm2qmBmU241dJjBKAgHa3zjSuAgBbAn3A=
Date:   Wed, 12 Oct 2022 04:56:52 +0000
Message-ID: <LV2PR12MB5727354F4A1EDE7B08FBC5A5AF229@LV2PR12MB5727.namprd12.prod.outlook.com>
References: <20220923114922.864552-1-thierry.reding@gmail.com>
 <1b50703c-9de0-3331-0517-2691b7005489@gmail.com>
In-Reply-To: <1b50703c-9de0-3331-0517-2691b7005489@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: f.fainelli@gmail.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR12MB5727:EE_|DM6PR12MB4188:EE_
x-ms-office365-filtering-correlation-id: f52337f9-4730-46fe-9622-08daac0e2e30
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pp0oh3DIYh8/6Pr+yyXOsPInjZvJNuCAVjlYJ0AAkLe+ylGzyn3PDGHFnU9GyN75DSHyk050kRxuOHfhM2QhT1mkDRBoN2MpSAyLES1p7Cvybj9XTI/sG2TFND5/s0eMAYZYaXp0YqyUgcVfTrysTYmfyN4vTJV9Jo9UmQvx/wTbo6yHH2BxbwomVnD+CK2bjlrBYZlUFFusoTn+6DItWkJUNLCaBCEWmW3VHuNzCdZwOQ5Ci+BKLM5ly/SG9tOt0+52NPhkDXBx6l7qUR8HD+24i/W0qy+ao+Yle3D17dQSVVgdBktzlXYkQgYikvVrkdP2UHZgyCZ580e4msS18K8LZdGnZYGY2s3+7AcJz561wM5ThWr3WgFDHN023OFZlTu9+9CUfED9UCGAG+AjP8C5yD8K06VmoHynyxaePb03hQfAgOASz9HVlJaGFa9iIIEhQ5i9Qv9jZ8JbIkQ06MR7wnoMeqNPI7Tuj0q00L97YOWaYOxXHDFTKjjaEja72MgP06rcN/4Rid0yCKlTItZVpwb3/9i7DNL4DsqB8rjxkwJVs5unzrbmBcdf0jYqVsAyTTYPozK3qQonKMssrAOUdHFrwdXJilDTcTxZERROtUZs4CWg//FxynaIJY0GsmyYIzMgiVwjMAV3xGgoxzDeRigSjmToyxs3pm30sxBOGSSRt8NiqpxVt/8vdtMzMdNfHSSM51xOXvPpan2d7dLBPDPDpgSKNZg34NnyI6eWcfiRuvT0HxVCPgxhtNUa7Z2P/nOZ/9YQgklfdsMZI/IBLx8IlaeE2xLkJuAxezM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5727.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199015)(76116006)(7696005)(26005)(52536014)(38070700005)(4326008)(6506007)(41300700001)(8936002)(66446008)(8676002)(33656002)(9686003)(66946007)(66556008)(64756008)(66476007)(7416002)(316002)(122000001)(38100700002)(55016003)(2906002)(921005)(5660300002)(86362001)(71200400001)(6636002)(53546011)(110136005)(478600001)(83380400001)(186003)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDhIVHZWSlcvY0YxTVA5OEcvSENSNkpQYTZBdXF3c3JQMk90anRna1ZzKzlZ?=
 =?utf-8?B?dFpJcDljTDcxQTZBWVhpaytaK3hoWHdiY3ZIMVdMeTlPMlRTV21YMHcvL2RY?=
 =?utf-8?B?VzBlbGo1dmhmdXNFbDNLcDEveUUyblBRUkFIZ1piTVdINC9HeDNOUGx6MVVC?=
 =?utf-8?B?d3MzQjhYMTBBNk9YOUJBTHI4Zld1cUxPanF0RnU3ZUZJRng0M1NkQUpTa0Z3?=
 =?utf-8?B?WVF5VXc2TURYUEpVMzA5NloxclJ5VjRyQm5qbTMwdkJCcUhvRE1DdzB6NEVD?=
 =?utf-8?B?eEhFOW1Ud2lZcjBPL2pSNHI5cXpiWDRwbDZlaEFENlduMG01OUExMlRhSldx?=
 =?utf-8?B?QUZrSm4vOFd3bWdCZnhnK3k4QzRHSzVVODNzNHVXUkc3UU13ampqODNGejNS?=
 =?utf-8?B?ckdycTFUMHVrcEpVUjFNSHpXQkxOZjY4UlRKeXhDYlVna28wOU1hcEI2TFYr?=
 =?utf-8?B?M1o2WGVSeWpsUWdRbDZFM1BXd3Z2ZXM5MnNoM1NJWEhaVTBhNjV2V0N5OUdU?=
 =?utf-8?B?WG9wQk1Za1dqNTlpNHpFenlNcmdKZGFOWXdPTzM5RzRoWmd3a3NaV3R1d21D?=
 =?utf-8?B?T1A4VE5rK0U5SW5qeXBTaTlNNHM1VG1Eampxd01jYWpSakdzeGhQUlBZZjM0?=
 =?utf-8?B?VnNQdmJXVFpuZU9lYlY2NnhuR2ZRTitpT3Z3SUNkQmdMYTRnL3FROWJOMkp3?=
 =?utf-8?B?RUN6cU0xN296Y0J6NUc2TkNlZGUyTWx3UVZPZGhQQWRQZFAzS2x2T3pocTBl?=
 =?utf-8?B?S0VUZGcyRU85ZTJDYnBkVGxlZDY0T1d1MytLTFF0ZGY4aGdidERTb1RVOEhO?=
 =?utf-8?B?cHBIY3RLNVJmT1FtR25mekkzMVNjOE5JeWJzempmRjJNeEJvOHV4eXJOdjB5?=
 =?utf-8?B?T3pQL2RpN2tjRzk3MDg4c1I5c2xJZDFlSUdtcjhXK254dTQ1cHZjdmdISFdS?=
 =?utf-8?B?OHpqWjNYMGtkMno1NG1XbllPYWkxM3VYK28rM2RLOEl6RS9SRHorQjlPbmpF?=
 =?utf-8?B?SElKdkFMdFJXSkJtNllnSjBsOEhOM0pNdHlwZEkyU091ak9WMkovM2tNSjg1?=
 =?utf-8?B?RzNLVEg2eWxoVFZpMUxBclNWT0Z2QlBLb1FRTDdiUVpaTjZLUWhnUTRxUS9T?=
 =?utf-8?B?YnpGRDBvZkxGeW41dHBlbWp1NTErRm5KZEptYjEwaUZ2eVpWajNiaHVyTEVB?=
 =?utf-8?B?b1dVaWx0akJ0dXJWRHB6aDR4bG9LSGhra3V3a0VnZkJxZmxmMkZ6OGp6elhV?=
 =?utf-8?B?dmtFNmhBelo1OEhkN2lYMkFrT2U3eFNmblhGR3YrSlhPODZYcmlqdVZzd2hL?=
 =?utf-8?B?OGd1TGJMMU83L3QwK3Z2aVh6cHVtUS9FTXg4d0ttdW5EN0IrTnlvanJCSnZz?=
 =?utf-8?B?V1hqUFY5bVdXbDR1NzZ2UURZWk5GekQ5UzI1dG9PQW5zMUdwWE9ER2s1UHRa?=
 =?utf-8?B?Z0swMC82ek10NkJPY0FOcU5zdU03ZWhKVFd3UE0wTHJGUGIybG1POUtHUU5a?=
 =?utf-8?B?M0RRNjBhV1FqbHR6Q1Y5cXJLNFpvSzc0VEcvR0E0YVpYT3B4SFNGNkJLNG5V?=
 =?utf-8?B?R2tWQXlNd0xWTC9BajgzUUNPU2dIRy9BM0hPUSt2VUkvTVJuSkhRUW85cXBt?=
 =?utf-8?B?VXlOZVBuQm5MZmlyQU1JTEg5L25EL3pGczlIcGl3K0tuMUNOdExwVEE5UC9T?=
 =?utf-8?B?dDA3MGhVUDBYNDJmWU5WTlZJTC9STEZHWXc1T2NQTGIxRU1leGRLS3VVMGpL?=
 =?utf-8?B?Q1JCTDFmQzY2SVhxNXJJNWJKNlNwVGk4b3ZoUHo4MHlPSDVNWFZzbGovU1Nw?=
 =?utf-8?B?SjBaMlBHSjFGNit1Z2dmRmh2WlZ4aGhoVXowRnFZKzlzTkV0TG5HRFFaYVFr?=
 =?utf-8?B?eW1yL2ZvZEk3NTk0ZDI4Unh5NVEwUWpBSWdzSS90Z2V1NDBwS0JHN3ZNeGFP?=
 =?utf-8?B?SlZpMlFZVzZOL1J3VTcrWnFVQVR1emQwbFpBYVBzb2dHVjRIQ3ZFUUJvV0tn?=
 =?utf-8?B?Zm51OEFUdlpBT3FLRlRuMXZSUXg2K3hXc1NUQkNEdzBVYXFZbjZDa0ZQKzhv?=
 =?utf-8?B?YlcwZXhFTlF2d21UNFI5U3RNNW9JYUJxdU55clozcHZ4UzZ5djJWa2djbzEv?=
 =?utf-8?Q?VayVHsDZ34WEbHpZJ5hWq8mX0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5727.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f52337f9-4730-46fe-9622-08daac0e2e30
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2022 04:56:53.0177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VAEmZIUgIg2LivV7YnaroAcRAkxjaz04rLF4l7CYe1OLWpF90NaXGf6dW1tXOpqrcXdaYtqL4XDQOyNZdf3FDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4188
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQEZsb3JpYW4gRmFpbmVsbGksDQpUaGFua3MgZm9yIHRoZSByZXZpZXcuDQoNCj4gLS0tLS1P
cmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxs
aUBnbWFpbC5jb20+DQo+IFNlbnQ6IDI3IFNlcHRlbWJlciAyMDIyIDEwOjUzIFBNDQo+IFRvOiBU
aGllcnJ5IFJlZGluZyA8dGhpZXJyeS5yZWRpbmdAZ21haWwuY29tPjsgRGF2aWQgUyAuIE1pbGxl
cg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xl
LmNvbT47IEpha3ViDQo+IEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBQYW9sbyBBYmVuaSA8
cGFiZW5pQHJlZGhhdC5jb20+OyBSdXNzZWxsDQo+IEtpbmcgPGxpbnV4QGFybWxpbnV4Lm9yZy51
az47IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IFZsYWRpbWlyDQo+IE9sdGVhbiA8b2x0
ZWFudkBnbWFpbC5jb20+DQo+IENjOiBKb25hdGhhbiBIdW50ZXIgPGpvbmF0aGFuaEBudmlkaWEu
Y29tPjsgQmhhZHJhbSBWYXJrYQ0KPiA8dmJoYWRyYW1AbnZpZGlhLmNvbT47IGxpbnV4LXRlZ3Jh
QHZnZXIua2VybmVsLm9yZzsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBS
ZTogW1BBVENIIG5ldC1uZXh0IHY0IFJFU0VORF0gc3RtbWFjOiB0ZWdyYTogQWRkIE1HQkUgc3Vw
cG9ydA0KPiANCj4gRXh0ZXJuYWwgZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3Ig
YXR0YWNobWVudHMNCj4gDQo+IA0KPiArUnVzc2VsbCwgQW5kcmV3LCBWbGFkaW1pciwNCj4gDQo+
IE9uIDkvMjMvMjIgMDQ6NDksIFRoaWVycnkgUmVkaW5nIHdyb3RlOg0KPiA+IEZyb206IEJoYWRy
YW0gVmFya2EgPHZiaGFkcmFtQG52aWRpYS5jb20+DQo+ID4NCj4gPiBBZGQgc3VwcG9ydCBmb3Ig
dGhlIE11bHRpLUdpZ2FiaXQgRXRoZXJuZXQgKE1HQkUvWFBDUykgSVAgZm91bmQgb24NCj4gPiBO
VklESUEgVGVncmEyMzQgU29Dcy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJoYWRyYW0gVmFy
a2EgPHZiaGFkcmFtQG52aWRpYS5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogVGhpZXJyeSBSZWRp
bmcgPHRyZWRpbmdAbnZpZGlhLmNvbT4NCj4gPiAtLS0NCj4gPiAgIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L3N0bWljcm8vc3RtbWFjL0tjb25maWcgICB8ICAgNiArDQo+ID4gICBkcml2ZXJzL25ldC9l
dGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9NYWtlZmlsZSAgfCAgIDEgKw0KPiA+ICAgLi4uL25ldC9l
dGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9kd21hYy10ZWdyYS5jIHwgMjkwDQo+ID4gKysrKysrKysr
KysrKysrKysrDQo+IA0KPiBZb3Ugc2hvdWxkIGJlIG1vZGVsaW5nIHRoaXMgYXMgYSBwcm9wZXIg
UENTIGRyaXZlciBhbmQgaGF2ZSBhICdwY3MtaGFuZGxlJw0KPiBwcm9wZXJ0eSBwb2ludGluZyB0
byBpdCBpbiB5b3VyIERldmljZSBUcmVlLg0KPiANCj4gVGhlIGNvbmZpZ3VyYXRpb24geW91IGFy
ZSBkb2luZyBoZXJlIGlzIHByb2JhYmx5IHdvcmtpbmcgdGhlIGZpcnN0IHRpbWUgeW91DQo+IGJy
aW5nLXVwIHRoZSBuZXR3b3JrIGRldmljZSBidXQgSSBkb3VidCBpdCB3b3JrcyBhY3Jvc3Mgc3lz
dGVtDQo+IHN1c3BlbmQvcmVzdW1lIHN0YXRlcyB3aGVyZSBwb3dlciB0byB0aGUgR01BQyBhbmQg
UENTIGlzIGxvc3QsIGl0IGFsc28NCj4gYmVncyB0aGUgcXVlc3Rpb24gb2Ygd2hpY2ggbWVkaXVt
cyB0aGlzIHdhcyB0ZXN0ZWQgd2l0aCBhbmQgd2hldGhlcg0KPiBkeW5hbWljIHN3aXRjaGluZyBv
ZiBzcGVlZHMgYW5kIHNvIG9uIGlzIHdvcmtpbmc/DQo+IC0tDQoNCkZvciBUZWdyYTIzNCwgdGhl
cmUgaXMgVVBIWSBsYW5lcyBjb250cm9sIGxvZ2ljIGluc2lkZSBYUENTIElQIHdoaWNoIGlzIG1l
bW9yeS1tYXBwZWQgSVAgKG5vdCBwYXJ0IG9mIHRoZSBNQUMgSVApLg0KbWdiZV91cGh5X2xhbmVf
YnJpbmd1cCBwZXJmb3JtcyBVUEhZIGxhbmUgYnJpbmcgdXAgaGVyZS4gSGVyZSBNR0JFL1hQQ1Mg
d29ya3MgaW4gWEZJIG1vZGUuDQoNCkFncmVlIHRoYXQgbGFuZSBicmluZyBkb3duIGxvZ2ljIGlz
IG5vdCBwcmVzZW50IGludGVyZmFjZSBkb3duL3N1c3BlbmQgcGF0aHMuIFdpbGwgdXBkYXRlIHRo
ZSBjaGFuZ2VzIGFjY29yZGluZ2x5Lg0KT25lIG1vcmUgdGhpbmcgaXMgdGhhdCBVUEhZIGxhbmUg
YnJpbmcgc2hvdWxkIGhhcHBlbiBvbmx5IGFmdGVyIHRoZSBsaW5lIHNpZGUgbGluayBpcyB1cC4g
VGhpcyBhbHNvIHdpbGwgbWFrZSB0aGUgY2hhbmdlcy4NClBsZWFzZSBsZXQgbWUga25vdyBpZiBJ
IG1pc3MgYW55dGhpbmcgaGVyZS4NCg0KVGhhbmtzLA0KQmhhZHJhbS4NCg==
