Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E8040F92C
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244214AbhIQNcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:32:12 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:57311 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243646AbhIQNcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 09:32:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631885447; x=1663421447;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kWh8bgRtxHUljLy/4pkpehjqp++AHwv1DpdDm3WVZa8=;
  b=YQEzGL0FbJ9SqQTo+wJUh23k6JeA8Igsatrk1hlpRNIjILnJSHh5tVcf
   EGCDm6Y6rBEy3AZlgkDjMftR3nmMXRIWWc3b5LTM9cSaRnqoYQ0STB7x4
   dAwaafoURp2i35XiRi21qo1gjFcDjyZQwZ3E9qcaktIpyC5+QmbfFPeyc
   OuxV/aCJhq227I15McKHqQ0N5+f1D5K+mLHZViX+56xdVNyL80lKTGspq
   YFORxO6HAI/lV8r6HiQv1sLUi2WbtzQ+HPZb2h48iIxJfyeDgR8KJ5QYh
   3SA0SCVxDL0K2yiBISTxDKOdQlKCuRLM0PBIafU5WkPU4LbP06LGTW2zB
   Q==;
IronPort-SDR: gwduTEkFFMoh5J9hNLg258yV8RGjsbLEYohl7GPHSGutCbca4vszDiCNCN7ueV8z7XMnxcgoUl
 Ugijt0c2Q5YO9flOE+80RPOjHqnDWahMbMhz3Z7jjgqzaqJ3lHRw/P7mjndB50dRYEYI1b0JqA
 VKtjjCi15sBRb10lFa6yExRMzPleaDt35cxTgMibaLFnT4rBV22A9ghzDzUsI8n50Ewb5Jpo8E
 wUJdsPfnrB9dpE3Q9v4J/qRh9utMMkWDWKQO1+9t1c/1jn2SEIYyOd9PFF5A0qYLdAbrZ+PQab
 HtFXbMmy0EF8WvFnN298hL/u
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="136950711"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Sep 2021 06:30:47 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 17 Sep 2021 06:30:46 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14 via Frontend
 Transport; Fri, 17 Sep 2021 06:30:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKI7lOcGOGEMM/2e8n28WScoe1j08dTxhS3+j5pOrABtTN7CZDy8ciSi9YXfX/aqSnYB6T/gtjdA1HAwu6Ki9L/FClADEVaG5QWPHbtR9dIA430lTt6M6VkFr/QEuFZIYFsoZScCN5tDtsA+82tSERSIhdwDMq+ndc8V9/tloqaZKWfaAvjS+11u8ZDVE5xVBloJqWF5XxgIORHIH6MXFpv3FxM8YGWWbhH/A0MJpK13JtxigxDg51TSbx5Tf2VZGtNgfpTGkpWgk9a/ifVuS51/laxNBflv2MqMd9MrNOEuNLThw3B2NJr29SIgRY8oO6nu5B8azcmga8xSzA57dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=kWh8bgRtxHUljLy/4pkpehjqp++AHwv1DpdDm3WVZa8=;
 b=eVpwA4lA3ZzpKRds6l8cEnKzMP1DxRmW1c4sac2bicMpa84cJokpaxY6FEi0y6ynVz/syKaWIpY6Y2rfCKWatFzSSygQzP+l/n/UVphz/fGw9D0gB5f9Ktli4WwWPF5gMrxYJox+zbyCaDjdZ8GH7v1qS/ATBSZy0w14hM+i9NBFmprXyEydhjcXih7qLLVEd1Nh1Iz//eOs4mgqKaqp4/xHHNiwb2sLoj0LPNDnK1CtsJLEKl+2KYNznV3BdzTn8gSUi+PLuLTAMHNuAl2xF8jObFltk+KLvaCNrmREdYJP51bYcV/206Jk6Ya7u1d8IaZK/1kpUwcEuhLQOZnFhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kWh8bgRtxHUljLy/4pkpehjqp++AHwv1DpdDm3WVZa8=;
 b=objt+r782YwjBWv9l04GkBzSKCtzNeRanye9VDLLY1Xm4si8Ef0+Qs/qOWPZwivQo8calVHv1+SR+ameX94g3NR+ezwuJ/ImyMc0/dxMMSlLxzRzV9rXi7F5MIuObbgtVGrHjqvda38qsQwFe8ksGbDAimEmjB86KO+wnX8Vrno=
Received: from SN6PR11MB3422.namprd11.prod.outlook.com (2603:10b6:805:da::18)
 by SA2PR11MB5179.namprd11.prod.outlook.com (2603:10b6:806:112::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 13:30:44 +0000
Received: from SN6PR11MB3422.namprd11.prod.outlook.com
 ([fe80::e139:9d6a:71c3:99c8]) by SN6PR11MB3422.namprd11.prod.outlook.com
 ([fe80::e139:9d6a:71c3:99c8%6]) with mapi id 15.20.4523.016; Fri, 17 Sep 2021
 13:30:44 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] net: macb: add support for MII on RGMII interface
Thread-Topic: [PATCH v2 0/4] net: macb: add support for MII on RGMII interface
Thread-Index: AQHXq8g3uWhmL8/CpUmD0Bh+5jeONg==
Date:   Fri, 17 Sep 2021 13:30:44 +0000
Message-ID: <984bcf20-60b8-fc86-b6ee-fd3f4bbb0624@microchip.com>
References: <20210917132615.16183-1-claudiu.beznea@microchip.com>
In-Reply-To: <20210917132615.16183-1-claudiu.beznea@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none
 header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb8f5e38-40eb-4ac7-7f41-08d979df5a0b
x-ms-traffictypediagnostic: SA2PR11MB5179:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB5179D127B83B7E22EEF630F287DD9@SA2PR11MB5179.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qd/Pfja0b7qEz3qo2keU4te5YWMFDvFIesba7K8t5o39VhOoKQPz+PqWLWwEKj6CIVyWgDTI44hOkFMmF3inWQdFUMSLhz3HNu04tZYiOwyGLzjy1Jz7byUlgp+Rpv1dILkIRD4O7ULb0Hv5hNQaYvaml+K+N+xBWYvehPO/y/4fBGa1VWFesLFaJPOFcBXvDYbjFQziSMUHIlZs4fAPbSX4Pvbf+cjZMPRX8Xki9okZIdsglf4TJTTNom7fECj4Ws6DCOOPG3k5AlQ6DsBA0Vda5MeMjyQq0OnygPBLGmZSWfvW5U0T1c1B+wqKhYqDr9kOwVGB9q2ZS2zLM+2jtcoFRys7KSbg9s+qp3Brpa7hJuCBVZogOFyNWUnEE39g5qqKmQni0f8n/+crD0IEnJU5SGngFfpD0RMMXELR1DU3AmBJ6QI5m/dwAaMh+WVBATQUTqnGrW2D54IUPnX9rtV5k/pm9wxq/lL+UyeDaKLZpuCR302HXgfyPPPIsOXP/3z1T+mZgP9aZb/6suurtLfxStjTKEQX7Sm1cVs2T4jRdLLUTIo0MyYlTpv8svvj1cpvEepS3/yAuzIdOmdFOqX2SQ9a7zLYB0d2gD/GGOyT8oLkwBsQWWbPQ37CPoZNC8qVli2MtbvPKLKv6HSHQi1S1xE9pp6LAoPdBGw+NTwQOFHosEvtLgSK2/QoM/jmH+MYLJEYb7cgJEzokXItuerRxYMoc+yLBCSmNU5aFasp9Sv5oANWVJpkPWppBgZlA+cJjNfRVo4LNSAjbGs9dw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3422.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(39860400002)(396003)(66946007)(64756008)(66446008)(66476007)(31686004)(38100700002)(66556008)(54906003)(110136005)(91956017)(76116006)(2906002)(31696002)(86362001)(2616005)(8676002)(5660300002)(6486002)(8936002)(4744005)(83380400001)(316002)(38070700005)(4326008)(53546011)(6506007)(71200400001)(122000001)(186003)(36756003)(26005)(478600001)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?THROQkQ1ZUJwaE1OcXNlbGhrNGRSSXhDLzBnUzBUWkVEcjRma3pTaTdFSTA5?=
 =?utf-8?B?dW9vaDA1R1lRZmgzQWowdVh4RlBNbUVXNEx2bC8rOVN6eENEODNNRncyQ0c0?=
 =?utf-8?B?dWs0ZERDWU1IdnlPNUgrQW15M2diRXVSU0N5RUxMUENnNldwUWovNVhUUUtQ?=
 =?utf-8?B?bjQyajFtNEJkSEdEaEtpN0tSYTROWkV2YkN4alVXK2gwZUdVY05XZmVzZEM1?=
 =?utf-8?B?eElHTjVtNGFRd1ZJZ0JINnB0S0ttd3VRQkYvNHpYcUpTOHpoWWtIcTBnNmtu?=
 =?utf-8?B?cE5ueWpwdU16dzBOSHBlWVgxY0c5TlpGa0RUOTJGUDFSSkYyR0xFanRHdFd6?=
 =?utf-8?B?MDVRY1RXek9oekZKcXdVK0JaVW42cjhxckhENW9PU1BxRU1wYmxHdHBTK25u?=
 =?utf-8?B?TmQ2NUM3bmJUdzNKYitjL2Vvd0tPN0hxZGgvVUE5ZEZiOEJuOFE1UWp4ajM0?=
 =?utf-8?B?VHI0Mks1UVhDMEl3L1Mzd3VYalZPa1pxZGY4TEhoc3J1bTZuenphTDd1VW5S?=
 =?utf-8?B?RTA5Q0d0MGJBRGdiTHhqMjVteGVJSm4vbDNBOTZiSmNNK21TLzJXQUFsQU9t?=
 =?utf-8?B?S0tsTlNueTJsSFNqRWErOFFlSlBDMEhhbFVaNlBWRXdXZ2JmQmpZN1M4VEpQ?=
 =?utf-8?B?L04zRTI2aWF0bUlaOGc4YUYweHBmRjVHMEdqSzk5YjlWa294UUdBM0ZwQzJT?=
 =?utf-8?B?M3RheFpDVXc0NE91d2VHaW9UdS9yWnM0bDQ1bkpRWWlvQ3F3WmZmTlQ4TEVm?=
 =?utf-8?B?VFdGWE9ab2lpMEdURnhUVm44bEp2Tk8yeVJMNDFiRzF0aDN3alRwMHVPQkVU?=
 =?utf-8?B?ZEQzMUdma3cyOFR2eXRoQVBnNU1iQzB1MHpkZkJxK3g2eUZmd0hGRnB5clh5?=
 =?utf-8?B?NzUvZ2lMT2RYbjRBSVBHdG1MOStGM0JJem9IdlVDbHhBbnU4MlRQRUFYTXd0?=
 =?utf-8?B?MlhaNXNpRWplb3oyMm1DdGQ2SHNCS1llNjQ5dTFydnViSXBXM0xQeEJYV0dz?=
 =?utf-8?B?Qmw4djk3VWVlb2YvV1ZDZFlsaUd2VkZSTWxvMmNxdTYxWTF2MmpSNXFpTExn?=
 =?utf-8?B?MjRmMUFaT0FROE5tMVNKVHBJUlBnQWR6QjdJVVBrdTF1VVJ1ajF0cEhYQm0z?=
 =?utf-8?B?Tkx5Ynk2Z1hzTW9GMitqY1lRZE9GQjNvbWVvVEJEaUJEYm91THZETVcyU2tM?=
 =?utf-8?B?NTRsME9Fa1BiNVpLN2xIWGg3d001emorVm9BektQNGVEQTFHWlpQc0JHREdL?=
 =?utf-8?B?U1BvbG40bzlTeFJURW5PTktqQUkvUCtCZ0RjQlZIL3BqbHNnbzd0SzdMcVdO?=
 =?utf-8?B?cHVmb2doRnV1Z3VnK1J1QWFBRVg3b1FtZnVmbG5WUXNtUldhK0RwZFBZTm5E?=
 =?utf-8?B?bi91emxyUU1JQlo2RThuWlFKenBiZzllN2duV1IrMDJWQWM5Wmk0SExvUGNB?=
 =?utf-8?B?Mi9JcVdHMGhUSVRXcXZ2UW9HTkxSREtNMkUrRUdpSEQ1S2FaVG13Qk1TdVJ1?=
 =?utf-8?B?QjRZaml5L2I5clFPWmM3czJWMkpHYndCNk55c1hNM3NxVE95b2pRTk9FYWdy?=
 =?utf-8?B?NHhnMzFFa1VPWmpNc2RVMVRTNC9zaG9uV2R4M3p3TDZJeXM4ZmJ6cytOTW9Z?=
 =?utf-8?B?cy9OK3JETHdQbDNoNlBjRWpFemxVUnpDRXFKVE5QYmJVakJaMDJKck8yRVRM?=
 =?utf-8?B?OFgwRmZyMG51bkwvdUExd3U3QXd0S0RneVRxbU1rLzMwNFJpdEVkRW9UVlJl?=
 =?utf-8?Q?cdVdmt3iJ24UISRExQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <25633BDF20AEC4498B6BE9DF8E97C939@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3422.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb8f5e38-40eb-4ac7-7f41-08d979df5a0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2021 13:30:44.3517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /k3d7tzW0hAc3kXxyEYhLW4VIvjCyskeZpb+bXsOw8HKJHZzkmzN93SSm3sMCpm9LRgEIfqxtzfds4aJzHqE4bpH762WPVGvSlsS3HhkyXU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5179
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTcuMDkuMjAyMSAxNjoyNiwgQ2xhdWRpdSBCZXpuZWEgd3JvdGU6DQo+IEhpLA0KPiANCj4g
VGhpcyBzZXJpZXMgYWRkcyBzdXBwb3J0IGZvciBNSUkgbW9kZSBvbiBSR01JSSBpbnRlcmZhY2Ug
KHBhdGNoZXMgMy80LA0KPiA0LzQpLiBBbG9uZyB3aXRoIHRoaXMgdGhlIHNlcmllcyBhbHNvIGNv
bnRhaW5zIG1pbm9yIGNsZWFudXBzIChwYXRjaGVzIDEvMywNCj4gMi8zKSBvbiBtYWNiLmguDQo+
IA0KPiBUaGFuayB5b3UsDQo+IENsYXVkaXUgQmV6bmVhDQo+IA0KPiBDaGFuZ2VzIGluIHYyOg0K
PiAtIGFkZGVkIHBhdGNoIDQvNCB0byBlbmFibGUgTUlJIG9uIFJHTUlJIHN1cHBvcnQgZm9yIFNB
TUE3RzUgTUFDIElQcw0KDQphbmQgY29sbGVjdGVkIHRhZ3MNCg0KPiANCj4gQ2xhdWRpdSBCZXpu
ZWEgKDQpOg0KPiAgIG5ldDogbWFjYjogYWRkIGRlc2NyaXB0aW9uIGZvciBTUlRTTQ0KPiAgIG5l
dDogbWFjYjogYWxpZ24gZm9yIE9TU01PREUgb2Zmc2V0DQo+ICAgbmV0OiBtYWNiOiBhZGQgc3Vw
cG9ydCBmb3IgbWlpIG9uIHJnbWlpDQo+ICAgbmV0OiBtYWNiOiBlbmFibGUgbWlpIG9uIHJnbWlp
IGZvciBzYW1hN2c1DQo+IA0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiLmgg
ICAgICB8IDcgKysrKystLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21h
aW4uYyB8IDkgKysrKysrKy0tDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyks
IDQgZGVsZXRpb25zKC0pDQo+IA0KDQo=
