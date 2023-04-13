Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4476E0709
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 08:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjDMGiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 02:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDMGiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 02:38:16 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2040.outbound.protection.outlook.com [40.107.96.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712D36EA0
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 23:38:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=na8BUETfkuuM4bDTFuiuib2hKfinqeluFtiyHelqZF6ZCP+1WPazsZhoXqOUamO1NHU5ORyLxNpaqJQsdGyOXjViOlXF+KWLLLV+MC+e4d6jQ93Su95IoUHD80odalwbl5ceU+ONgbdskU/Cvx72EuF9i0DbdY5zW0A40Uw0n9iNrluO+C9oqNf+UEhc20mIAnXcnVxBgqSNc1iYcGCyWy6G6Sz1OcIKvr45URWSoL3c7M4wpD7HjoOCouZ09r5KdTVpUgYvDNQYQSxyKT2PrF+XZ6aJab1kEQ/3jarw2uDbN4KsNYJp43FYY5FPZxwZIIfQusal4Xex2LMK9TspBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yc0G1Nb8bR6YBhH09hn+lAcNX1bfYQiKSS1a0iF+Mow=;
 b=ACsnxKyxrxJTh9FF+nevadAstkflcVBW0Op9B1CaafAKLt1/EZnB0/GmHjS8VJcP3AjyHkAiJel1wK0ST6bkOJ64R4IVxWi+fKJdj7wWId1vTY1lft6C1uLSnWzlupO9RTXj3uUH/Y6oJt21nCouJFG6esxZH7TleOpUILa2utTkcxJWVgymMakr9naTRLATBELmO06vR41KtDgrhWPVLJ1HnV0dK+P3bF71tk5ALnw26ZogYqXmo+tfRoMsoWebirN6WW3s3rS/ci2VR1yJYekEFAJIBwU8QulblbIlE1Yomw9AQVL0wJWEWOucptaXaafc9ZHhyDsXJ5Y0oKmH6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yc0G1Nb8bR6YBhH09hn+lAcNX1bfYQiKSS1a0iF+Mow=;
 b=P2IDX8U6Kz6aNUIic7ktDz+vyWoCgHkFDOsCxPoUVS0gCBPe61dYfh1M/2pisfBI2Z1LzIg6c01mBN0aO23yb/CuJMnIZSckRE2C5Bw0ZCtb8TgDCzT1ADSwJedz7EC7Q5D529m+cZoR8GMk+ioQ4iEq6zVvkXPoo/J6l66HCkQZNk1aQF0ZOhnTHejGx1UeA7k9GOeTZUNqxE150ceTMrydIxDlnQ2HKu4yTuYVYTXGc+WPS9/5pI31QBBGzI5O4+RTHfqjMOYh8O8botYtp89PcXy7m5y5wJ+YSx6E5wVBHyzxGepXO42wAzpuVlpAFCoyjOzJXb+BmUmQ5vJNQg==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by SJ0PR12MB7065.namprd12.prod.outlook.com (2603:10b6:a03:4ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Thu, 13 Apr
 2023 06:38:13 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5%6]) with mapi id 15.20.6277.036; Thu, 13 Apr 2023
 06:38:13 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: RE: [PATCH net-next v4 5/5] macsec: Add MACsec rx_handler change
 support
Thread-Topic: [PATCH net-next v4 5/5] macsec: Add MACsec rx_handler change
 support
Thread-Index: AQHZagj/V0dWeiWus0uVfTv6PZHn168nynqAgAEDOPA=
Date:   Thu, 13 Apr 2023 06:38:12 +0000
Message-ID: <IA1PR12MB6353A4C01FE89E6256C89E94AB989@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230408105735.22935-1-ehakim@nvidia.com>
 <20230408105735.22935-6-ehakim@nvidia.com> <ZDbHI/VLKkGib3kQ@hog>
In-Reply-To: <ZDbHI/VLKkGib3kQ@hog>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|SJ0PR12MB7065:EE_
x-ms-office365-filtering-correlation-id: 3c65f0a0-56db-494a-4070-08db3be9a7ae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BxAQCw/9ZAwDs34XvpSp1nQSLOG5WA/BcRIzstFg5SIcOo3hT789OG3I07qBwLSgHjtM3BW0fITyeGDhvW6tG5u2F58Fx00jIXbuxZAu9jTPbwyS12smRAd4sfxa1NXS3bbG66UCL5J1NhtGd/A/VFBaWpT1HQ9+y3Spb1+wvrZahqkNV51ofWN+pHWzRJj89feQuTAExCfKZRNtFubEegakNbJ/GnlaR/+bhXYuGWDehEl/PUCniVh585cinXEfgZ9XblJrsayh84XVjwzrxnDOBy9VkieKGn/9R09ZbYvo/WbwBsVjUdFKRsmafZZkFovbtrw+4qy8J0sVQC9gz6GO5mUl63EAEEbCNi739BhwzBiBqnlYVm2qsWHL5Mz9+Lx7zjPQ5u3sjQqhzvTK/cgT7Q3N7kbgR3GDq/ymKoiccoGV3io1waiPQvsDwmNCFGjGKCiyUVMoVCOB3FLdDuCh2V+4/YFyi3HdFMll1gyAehKsIjl1LpvkPu6ZcPcoz2QQ+GvfnWRUukSFAwJrj4bk6KhmurkxUa9VKIEFlxXTL8N7CNTfXje9sHlcaRwqrg8iPy/dwGnReqcbqaQtbg4D/mAPu7VeovOVWymRXxu4V6B1v6E/wpN1Kn6uHjAY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(451199021)(86362001)(38100700002)(33656002)(38070700005)(41300700001)(122000001)(8936002)(52536014)(7696005)(478600001)(5660300002)(4326008)(316002)(71200400001)(55016003)(186003)(53546011)(66446008)(26005)(76116006)(54906003)(2906002)(6916009)(8676002)(9686003)(6506007)(66556008)(66476007)(64756008)(66946007)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MnZTeFpIK1d4WXV6NGY1cTE0U0FoOWxpNFJnVUZJZWppUFA3bXFqWXFUdUpp?=
 =?utf-8?B?NE53azZXM0VjVDNxRUx2elFjRWZyeHR5b2cvdy9TZEoxVEVkR0s5SmQ4aFZV?=
 =?utf-8?B?S2k5MjlRSXIyZjQrZys3Q09hakhSZHEzQVl5a2d6cG5yWVhNUTFHaEFQVnJ5?=
 =?utf-8?B?d3UvTFUrL29KblN0M1c5RlBBWjZlaG9qcFN6Uk1adW9ES21taFNGdEJtckkr?=
 =?utf-8?B?bE9OZTlPRFpSYmtNczNXYnhrU25VbVAwK05OOEZlUk4rUmFSYzUyQWhtd0Va?=
 =?utf-8?B?S0MrYnJZV2FKK2RqYUd0WUFFeG9sTFRHK0E1aDI3Q2FRMktFUmJjWUpRRzM1?=
 =?utf-8?B?TE1MUmc2RDFCeW4wQU1YaUR3Zmw4RWdFbUZETFRtOGkxMVRRZGxOQ1dGNWlq?=
 =?utf-8?B?NE9HMENHRzlqSkV4eXo4NkYxSnhDZGhMSUtYMElFc3A1aG0wUWZPTWN3dndw?=
 =?utf-8?B?dW40YTNURjdBZWR1eitSbDBvNmt2UVJMTGxjOEx0SmRZV3UwQWdYZkN1eWlP?=
 =?utf-8?B?dW5rVXZ0L3BpeGUrdjNMa0RhZ1Y5M284QUFZWHJJTzVlOFVUOWYzUnorSVFz?=
 =?utf-8?B?dmtaQnlDUU9VSlQrMEt5ekxlWnd0QUtJRFRmYURWbko1TEZGMUxwbHkzdjlx?=
 =?utf-8?B?ZXpxMjJwc0dKdkZ0b1VLOFVTU0ZHcit6akI5YW5RNGlxekt0ckgzYnhMNFdm?=
 =?utf-8?B?R2t2RW95bmxxNmYwTmdWTm8rSTlCd0tVdnZyQStKRDE1WXA1Z1NnQ3BQZlY5?=
 =?utf-8?B?VEJPcExCaHVKYkJaVitsWGNVMDdKZHlnOHhKS2dPN2JsMHhYKzk1VTl5OGpJ?=
 =?utf-8?B?eTVUK0FXekxadjJ2Wjk2cGxoZ0VmNlNmamZuUkhUcXAyS0kzWHpnQnlDNStR?=
 =?utf-8?B?NnhrYVdxemNsTzg1SW1MM1pvYmY3ZDdDRUJKUm1wdE5sSTIvRnZ6MjRqN1cv?=
 =?utf-8?B?OVA0L0JPb09kZFh3M3pIS3BtakNmSFJGSXBnc3FmSmJCOUFLZ1V2SlRwdFND?=
 =?utf-8?B?LzdkUisvVWMrQXNxc2RLWWVHVDVldUR4eGpnY2c3T3YwRk5ZdjBidTMyNXlr?=
 =?utf-8?B?Tmh2a2xvL0dLYklSSittNk5FeEtUL0I1QVIvTUZGSGdyaU00VThtRGdZY2dk?=
 =?utf-8?B?OTB1NnpMN2NRSjZFaGlXTG93bFNpZnRoZXR1d2djM2FXdUovWWFPYW45U0VE?=
 =?utf-8?B?WU9uZ1IvL3BuY3gxalYzdks0OXcya3V5eE5OeVRHMEhRM0piSGZlOHVVVGNE?=
 =?utf-8?B?ZlpEL1Z3bGZwOWs0UFNkMG54b0VjK3JyYnBNcGNpekU0UEI3UVRBNHpCNnc3?=
 =?utf-8?B?WXdyZ3d0TVRIUUF4K2xrWlBIdlFFaW9vc3hZNi9kS2Vva1h5M0lVZzZnWnVM?=
 =?utf-8?B?bkYxUHYyd3Z6ZGZ2a1N1SXE1c2JCQ29LS0dOSjk3QXpRZVZaeE1rMGhzRUJj?=
 =?utf-8?B?QStVODRmTE94Zll4QVZ5cDNhejNMVlJaNTVLcU96aFV1dC8zaytUbDhJNlJU?=
 =?utf-8?B?WDdEaldtKzlUVGUvODlrMlZUUTV1bFlGTEMyVHlLb2l1MmplYWhDYlUwdXJ2?=
 =?utf-8?B?Nmsyb2wraUIvSTlNSWRlMHBBbWdrcGJYekJaZnFPbDJnVXFabUI4WkJ2KzNL?=
 =?utf-8?B?VTZ1R09iVU50VkVSbEtrUHJLVFFVZGJ0ZVlyOEFzQzJRN1BVN09SL1dzMXh6?=
 =?utf-8?B?MmZiYjB0UU90MWRmdG15SHFvUWJ4U1pmWFBmMzNCeVhnZEI2dXQvR0lzMjJp?=
 =?utf-8?B?emZPditpTjBjOForcGtsanBGQ3dKRys1Kzl5OG1BOG5lRC9tS3hBY09rbFBa?=
 =?utf-8?B?Sk13U1lMUVhERGNHdnJ4bjBpcmZWK2VsaG1KdG56MmJqSkdJVVZVMWNoN1Ax?=
 =?utf-8?B?OG5UQXN0dTlUMUlvSW84MWltOElOYkdGZmZMUjJCend2ek9sa2l4N1Q2NVgw?=
 =?utf-8?B?R2NZR1NQRWVQYW8zS1UxY3dPc0UzbVRnYUxhcjJ4ZzMvd0V0SnlHTkEzbTky?=
 =?utf-8?B?Znd6VGs0NmRuL29neFlkclRwcDR0UEpOL1IwcXUya1NyM2FRWFg4ZTI5cFIw?=
 =?utf-8?B?UjBRMENzQW1qUWlpdkowOERORFYzRVVjNDR2L2FzSGVzc3pIS2J4NG9xb1A1?=
 =?utf-8?Q?8ms8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c65f0a0-56db-494a-4070-08db3be9a7ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2023 06:38:12.9134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qVFqEvkwtFVCB/qmJE10l8nbXoa1ZVc/KkD0Ayvsju2spgttR65M51qJqSlGxpsgIQtBY+s+Oe3AMR+v0Vb50A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7065
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FicmluYSBEdWJyb2Nh
IDxzZEBxdWVhc3lzbmFpbC5uZXQ+DQo+IFNlbnQ6IFdlZG5lc2RheSwgMTIgQXByaWwgMjAyMyAx
Nzo1OQ0KPiBUbzogRW1lZWwgSGFraW0gPGVoYWtpbUBudmlkaWEuY29tPg0KPiBDYzogZGF2ZW1A
ZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsNCj4gZWR1
bWF6ZXRAZ29vZ2xlLmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGVvbkBrZXJuZWwub3Jn
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjQgNS81XSBtYWNzZWM6IEFkZCBNQUNz
ZWMgcnhfaGFuZGxlciBjaGFuZ2UNCj4gc3VwcG9ydA0KPiANCj4gRXh0ZXJuYWwgZW1haWw6IFVz
ZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4gDQo+IA0KPiAyMDIzLTA0
LTA4LCAxMzo1NzozNSArMDMwMCwgRW1lZWwgSGFraW0gd3JvdGU6DQo+ID4gT2ZmbG9hZGluZyBk
ZXZpY2UgZHJpdmVycyB3aWxsIG1hcmsgb2ZmbG9hZGVkIE1BQ3NlYyBTS0JzIHdpdGggdGhlDQo+
ID4gY29ycmVzcG9uZGluZyBTQ0kgaW4gdGhlIHNrYl9tZXRhZGF0YV9kc3Qgc28gdGhlIG1hY3Nl
YyByeCBoYW5kbGVyDQo+ID4gd2lsbCBrbm93IHRvIHdoaWNoIGludGVyZmFjZSB0byBkaXZlcnQg
dGhvc2Ugc2ticywgaW4gY2FzZSBvZiBhIG1hcmtlZA0KPiA+IHNrYiBhbmQgYSBtaXNtYXRjaCBv
biB0aGUgZHN0IE1BQyBhZGRyZXNzLCBkaXZlcnQgdGhlIHNrYiB0byB0aGUNCj4gPiBtYWNzZWMg
bmV0X2RldmljZSB3aGVyZSB0aGUgbWFjc2VjIHJ4X2hhbmRsZXIgd2lsbCBiZSBjYWxsZWQuDQo+
IA0KPiBRdW90aW5nIG15IHJlcGx5IHRvIHYyOg0KPiANCj4gPT09PT09PT0NCj4gDQo+IFNvcnJ5
LCBJIGRvbid0IHVuZGVyc3RhbmQgd2hhdCB5b3UncmUgdHJ5aW5nIHRvIHNheSBoZXJlIGFuZCBp
biB0aGUgc3ViamVjdCBsaW5lLg0KPiANCj4gVG8gbWUsICJBZGQgTUFDc2VjIHJ4X2hhbmRsZXIg
Y2hhbmdlIHN1cHBvcnQiIHNvdW5kcyBsaWtlIHlvdSdyZSBjaGFuZ2luZw0KPiB3aGF0IGZ1bmN0
aW9uIGlzIHVzZWQgYXMgLT5yeF9oYW5kbGVyLCB3aGljaCBpcyBub3Qgd2hhdCB0aGlzIHBhdGNo
IGlzIGRvaW5nLg0KPiANCj4gPT09PT09PT0NCg0KU29ycnkgdGhhdCBJIG1pc3NlZCBpdC4NCndo
YXQgZG8geW91IHRoaW5rIG9mICJEb24ndCByZWx5IHNvbGVseSBvbiB0aGUgZHN0IE1BQyBhZGRy
ZXNzIGZvciBza2IgZGl2ZXJzaW9uIHVwb24gTUFDc2VjIHJ4X2hhbmRsZXIgY2hhbmdlIg0KaXMg
aXQgZ29vZCBlbm91Z2g/DQoNCj4gPiBFeGFtcGxlIG9mIHN1Y2ggYSBjYXNlIGlzIGhhdmluZyBh
IE1BQ3NlYyB3aXRoIFZMQU4gYXMgYW4gaW5uZXIgaGVhZGVyDQo+ID4gRVRIRVJORVQgfCBTRUNU
QUcgfCBWTEFOIHBhY2tldC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEVtZWVsIEhha2ltIDxl
aGFraW1AbnZpZGlhLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvbWFjc2VjLmMgfCAx
NiArKysrKysrKysrKysrKy0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCsp
LCAyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L21hY3Nl
Yy5jIGIvZHJpdmVycy9uZXQvbWFjc2VjLmMgaW5kZXgNCj4gPiAyNTYxNjI0N2Q3YTUuLjRlNThk
MmI0ZjBlMSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9tYWNzZWMuYw0KPiA+ICsrKyBi
L2RyaXZlcnMvbmV0L21hY3NlYy5jDQo+ID4gQEAgLTEwMTYsMTQgKzEwMTYsMTggQEAgc3RhdGlj
IGVudW0gcnhfaGFuZGxlcl9yZXN1bHQNCj4gaGFuZGxlX25vdF9tYWNzZWMoc3RydWN0IHNrX2J1
ZmYgKnNrYikNCj4gPiAgICAgICAgICAgICAgIHN0cnVjdCBza19idWZmICpuc2tiOw0KPiA+ICAg
ICAgICAgICAgICAgc3RydWN0IHBjcHVfc2VjeV9zdGF0cyAqc2VjeV9zdGF0cyA9IHRoaXNfY3B1
X3B0cihtYWNzZWMtPnN0YXRzKTsNCj4gPiAgICAgICAgICAgICAgIHN0cnVjdCBuZXRfZGV2aWNl
ICpuZGV2ID0gbWFjc2VjLT5zZWN5Lm5ldGRldjsNCj4gPiArICAgICAgICAgICAgIHN0cnVjdCBt
YWNzZWNfcnhfc2MgKnJ4X3NjX2ZvdW5kID0gTlVMTDsNCj4gDQo+IEkgZG9uJ3QgdGhpbmsgIl9m
b3VuZCIgaXMgYWRkaW5nIGFueSBpbmZvcm1hdGlvbi4gInJ4X3NjIiBpcyBlbm91Z2guIEFuZCBz
aW5jZSBpdCdzDQo+IG9ubHkgdXNlZCBpbiB0aGUgaWYgYmxvY2sgYmVsb3csIGl0IGNvdWxkIGJl
IGRlZmluZWQgZG93biB0aGVyZS4NCg0KQWdyZWUsIHdpbGwgZHJvcCB0aGUgIl9mb3VuZCIuDQoN
Cj4gQW5kIGJ0dyBJIGRvbid0IHRoaW5rIHdlIGV2ZW4gbmVlZCB0byBjaGVjayAiJiYgcnhfc2Nf
Zm91bmQiIGluIHRoZSBjb2RlDQo+IHlvdSdyZSBhZGRpbmcsIGJ1dCBtYXliZSBJIG5lZWQgbW9y
ZSBjb2ZmZWUuIEFueXdheSwgSSdkIGJlIGZpbmUgd2l0aCBzYXZpbmcgdGhlDQo+IHJlc3VsdCBv
ZiBmaW5kX3J4X3NjIGFuZCByZXVzaW5nIGl0Lg0KPiANCj4gaWYgKEEgJiYgIXJ4X3NjKQ0KPiAg
ICAgY29udGludWU7DQo+IA0KPiBbLi4uXQ0KPiANCj4gaWYgKEEpIC8vIGhlcmUgd2Uga25vdyBy
eF9zYyBjYW4ndCBiZSBOVUxMLCBvdGhlcndpc2Ugd2Ugd291bGQgaGF2ZSBoaXQgdGhlDQo+IGNv
bnRpbnVlIGVhcmxpZXINCj4gICAgIHBhY2tldF9ob3N0IGV0Yw0KDQpBZ3JlZSwgd2lsbCBkbyB0
aGF0Lg0KDQo+ID4gICAgICAgICAgICAgICAvKiBJZiBoL3cgb2ZmbG9hZGluZyBpcyBlbmFibGVk
LCBIVyBkZWNvZGVzIGZyYW1lcyBhbmQgc3RyaXBzDQo+ID4gICAgICAgICAgICAgICAgKiB0aGUg
U2VjVEFHLCBzbyB3ZSBoYXZlIHRvIGRlZHVjZSB3aGljaCBwb3J0IHRvIGRlbGl2ZXIgdG8uDQo+
ID4gICAgICAgICAgICAgICAgKi8NCj4gPiAgICAgICAgICAgICAgIGlmIChtYWNzZWNfaXNfb2Zm
bG9hZGVkKG1hY3NlYykgJiYgbmV0aWZfcnVubmluZyhuZGV2KSkgew0KPiA+IC0gICAgICAgICAg
ICAgICAgICAgICBpZiAobWRfZHN0ICYmIG1kX2RzdC0+dHlwZSA9PSBNRVRBREFUQV9NQUNTRUMg
JiYNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICAgICghZmluZF9yeF9zYygmbWFjc2VjLT5z
ZWN5LCBtZF9kc3QtPnUubWFjc2VjX2luZm8uc2NpKSkpDQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgIHJ4X3NjX2ZvdW5kID0gKG1kX2RzdCAmJiBtZF9kc3QtPnR5cGUgPT0gTUVUQURBVEFfTUFD
U0VDKQ0KPiA/DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZmluZF9y
eF9zYygmbWFjc2VjLT5zZWN5LA0KPiA+ICsgbWRfZHN0LT51Lm1hY3NlY19pbmZvLnNjaSkgOiBO
VUxMOw0KPiA+ICsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgaWYgKG1kX2RzdCAmJiBtZF9k
c3QtPnR5cGUgPT0gTUVUQURBVEFfTUFDU0VDICYmDQo+ID4gKyAhcnhfc2NfZm91bmQpIHsNCj4g
PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb250aW51ZTsNCj4gPiArICAgICAgICAg
ICAgICAgICAgICAgfQ0KPiANCj4ge30gbm90IG5lZWRlZCBhcm91bmQgYSBzaW5nbGUgbGluZS4N
Cg0KQUNLICwgd2lsbCByZW1vdmUgdGhlbS4NCg0KPiA+DQo+ID4gICAgICAgICAgICAgICAgICAg
ICAgIGlmIChldGhlcl9hZGRyX2VxdWFsXzY0Yml0cyhoZHItPmhfZGVzdCwNCj4gPiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIG5kZXYtPmRldl9hZGRy
KSkgew0KPiA+IEBAIC0xMDQ4LDYgKzEwNTIsMTQgQEAgc3RhdGljIGVudW0gcnhfaGFuZGxlcl9y
ZXN1bHQNCj4gPiBoYW5kbGVfbm90X21hY3NlYyhzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPiA+DQo+
ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgX19uZXRpZl9yeChuc2tiKTsNCj4gPiAg
ICAgICAgICAgICAgICAgICAgICAgfQ0KPiA+ICsNCj4gPiArICAgICAgICAgICAgICAgICAgICAg
aWYgKG1kX2RzdCAmJiBtZF9kc3QtPnR5cGUgPT0gTUVUQURBVEFfTUFDU0VDICYmDQo+IHJ4X3Nj
X2ZvdW5kKSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc2tiLT5kZXYgPSBu
ZGV2Ow0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNrYi0+cGt0X3R5cGUgPSBQ
QUNLRVRfSE9TVDsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICByZXQgPSBSWF9I
QU5ETEVSX0FOT1RIRVI7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZ290byBv
dXQ7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIH0NCj4gPiArDQo+ID4gICAgICAgICAgICAg
ICAgICAgICAgIGNvbnRpbnVlOw0KPiA+ICAgICAgICAgICAgICAgfQ0KPiA+DQo+ID4gLS0NCj4g
PiAyLjIxLjMNCj4gPg0KPiANCj4gLS0NCj4gU2FicmluYQ0KDQo=
